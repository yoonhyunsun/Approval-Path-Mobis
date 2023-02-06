/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 01-30-2023
 * @last modified by  : Bekhzod Ubaydullaev
 **/
@SuppressWarnings('PMD.ApexCRUDViolation')
// SORRY FOR THIS CODE :(
public without sharing class ChangeApproverUtil {
  private static final String PUBLIC_SITE_URL = ApprovalProcessSettings__c.getInstance(
      'MobisApprovalProcessSettings'
    )
    .PublicSiteURL__c;

  private static List<ApprovalProcessPath__c> getApprovalPaths(
    String approvalProcessId
  ) {
    List<ApprovalProcessPath__c> approvalPaths = [
      SELECT
        Id,
        ApprovalProcess__c,
        ApprovalProcessPathUID__c,
        ApprovalStatus__c,
        ApprovalType__c,
        ApprovalUser__c,
        Employee__c,
        NotifiedGroup__c,
        RequestDateTime__c,
        SiteURL__c,
        Order__c,
        CreatedBy.Email,
        CreatedBy.Name,
        ApprovalProcess__r.ReportType__c,
        ApprovalProcess__r.Opportunity__r.Name,
        ApprovalProcess__r.Name,
        Employee__r.Email
      FROM ApprovalProcessPath__c
      WHERE
        ApprovalProcess__c = :approvalProcessId
        AND ApprovalType__c != 'Draft'
    ];

    return approvalPaths;
  }

  private static void addAndRemoveApprovers(
    String approvalProcessId,
    List<ApprovalProcessPathDto> approvalProcessPaths
  ) {
    try {
      List<ApprovalProcessPath__c> approvalPaths = getApprovalPaths(
        approvalProcessId
      );

      List<ApprovalProcessPath__c> removeApprovalPaths = new List<ApprovalProcessPath__c>();
      removeApprovalPaths.addAll(approvalPaths);

      List<ApprovalProcessPath__c> newApprovalPaths = new List<ApprovalProcessPath__c>();

      for (ApprovalProcessPathDto appDTO : approvalProcessPaths) {
        if (appDTO.ApprovalPathId == null) {
          ApprovalProcessPath__c newApp = new ApprovalProcessPath__c();
          newApp.ApprovalProcess__c = approvalProcessId;

          newApp.ApprovalProcessPathUID__c = GenerateUID.generate();
          newApp.ApprovalType__c = appDTO.ApprovalType;
          newApp.Order__c = appDTO.Order;
          newApp.Employee__c = appDTO.Id;

          newApp.SiteURL__c =
            PUBLIC_SITE_URL +
            'approve?uid=' +
            newApp.ApprovalProcessPathUID__c;

          newApp.ApprovalUser__c = appDTO.UserId;

          newApprovalPaths.add(newApp);
        } else {
          for (Integer i = 0; i < removeApprovalPaths.size(); i++) {
            if (appDTO.ApprovalPathId.equals(removeApprovalPaths[i].Id)) {
              removeApprovalPaths.remove(i);
              --i;
            }
          }
        }
      }

      for (ApprovalProcessPath__c removeApp : removeApprovalPaths) {
        if (
          removeApp.ApprovalStatus__c.equals('Not Read') ||
          (removeApp.ApprovalStatus__c.equals('Read') &&
          !removeApp.ApprovalType__c.equals('Reference'))
        ) {
          SendEmailCancelledUtil.sendEmail(
            removeApp.CreatedBy.Name,
            removeApp.ApprovalProcess__r.Opportunity__r.Name,
            removeApp.ApprovalProcess__r.Name,
            removeApp.Employee__r.Email
          );

          IF_Util.removeApprovalNotification(removeApp.Id);
        }
      }

      insert newApprovalPaths;
      delete removeApprovalPaths;
    } catch (Exception e) {
      System.debug('addAndRemoveApprover:  ' + e.getMessage());
    }
  }

  private static void recreateChangedApprovers(
    String approvalProcessId,
    List<ApprovalProcessPathDto> approvalProcessPaths
  ) {
    try {
      List<ApprovalProcessPath__c> approvalPaths = getApprovalPaths(
        approvalProcessId
      );

      List<ApprovalProcessPath__c> removeApps = new List<ApprovalProcessPath__c>();
      List<ApprovalProcessPath__c> newApps = new List<ApprovalProcessPath__c>();

      for (ApprovalProcessPathDto appDTO : approvalProcessPaths) {
        for (ApprovalProcessPath__c app : approvalPaths) {
          if (
            appDTO.ApprovalPathId != null &&
            appDTO.ApprovalPathId.equals(app.Id) &&
            (!appDTO.ApprovalType.equals(app.ApprovalType__c) ||
            (appDTO.ApprovalPathGroup != app.NotifiedGroup__c))
          ) {
            removeApps.add(app);

            ApprovalProcessPath__c newApp = new ApprovalProcessPath__c();
            newApp.ApprovalProcess__c = approvalProcessId;
            newApp.ApprovalProcessPathUID__c = GenerateUID.generate();
            newApp.ApprovalType__c = appDTO.ApprovalType;
            newApp.Order__c = appDTO.Order;
            newApp.Employee__c = appDTO.Id;

            newApp.SiteURL__c =
              PUBLIC_SITE_URL +
              'approve?uid=' +
              newApp.ApprovalProcessPathUID__c;

            newApp.ApprovalUser__c = appDTO.UserId;

            newApps.add(newApp);
          }
        }
      }

      for (ApprovalProcessPath__c removeApp : removeApps) {
        if (
          removeApp.ApprovalStatus__c.equals('Not Read') ||
          (removeApp.ApprovalStatus__c.equals('Read') &&
          !removeApp.ApprovalType__c.equals('Reference'))
        ) {
          SendEmailCancelledUtil.sendEmail(
            removeApp.CreatedBy.Name,
            removeApp.ApprovalProcess__r.Opportunity__r.Name,
            removeApp.ApprovalProcess__r.Name,
            removeApp.Employee__r.Email
          );

          IF_Util.removeApprovalNotification(removeApp.Id);
        }
      }

      insert newApps;
      delete removeApps;
    } catch (Exception e) {
      System.debug('recreateChangedApprovers:  ' + e.getMessage());
    }
  }

  private static void notifyChangedApprovers(String approvalProcessId) {
    try {
      List<ApprovalProcess__c> approvalProcess = [
        SELECT ApprovalStatus__c, CurrentGroupNumber__c
        FROM ApprovalProcess__c
        WHERE Id = :approvalProcessId
      ];

      Integer groupNumber = approvalProcess[0].CurrentGroupNumber__c.intValue();

      List<ApprovalProcessPath__c> approvalProcessPaths = [
        SELECT
          Id,
          ApprovalStatus__c,
          Employee__r.Email,
          ApprovalType__c,
          NotifiedGroup__c,
          CreatedBy.Name,
          ApprovalProcess__r.Opportunity__r.Name,
          ApprovalProcess__r.Name
        FROM ApprovalProcessPath__c
        WHERE
          ApprovalProcess__c = :approvalProcessId
          AND NotifiedGroup__c >= :groupNumber - 1
          AND ApprovalType__c != 'Draft'
        ORDER BY Order__c
      ];

      if (!approvalProcess.isEmpty() && !approvalProcessPaths.isEmpty()) {
        Integer currentGroup = 0;

        for (ApprovalProcessPath__c app : approvalProcessPaths) {
          if (
            (app.ApprovalStatus__c != 'Approved' &&
            app.ApprovalType__c == 'General Approval') ||
            (app.ApprovalStatus__c != 'Approved' &&
            app.ApprovalType__c == 'Collaboration')
          ) {
            currentGroup = app.NotifiedGroup__c.intValue();
            break;
          }
        }

        if (currentGroup == 0) {
          approvalProcess[0].ApprovalStatus__c = 'Approved';
        } else {
          for (ApprovalProcessPath__c app : approvalProcessPaths) {
            if (
              (app.ApprovalStatus__c == 'Not Read' ||
              app.ApprovalStatus__c == 'Read') &&
              app.NotifiedGroup__c > currentGroup
            ) {
              app.ApprovalStatus__c = 'Not Sent';
              SendEmailCancelledUtil.sendEmail(
                app.CreatedBy.Name,
                app.ApprovalProcess__r.Opportunity__r.Name,
                app.ApprovalProcess__r.Name,
                app.Employee__r.Email
              );

              IF_Util.removeApprovalNotification(app.Id);
            }
          }
        }

        update approvalProcessPaths;
        update approvalProcess;

        if (currentGroup != 0) {
          ApproverActionUtil.notifyUsers(approvalProcessId, currentGroup);
          approvalProcess[0].CurrentGroupNumber__c = currentGroup;
        }
      }
    } catch (Exception e) {
      System.debug('notifyChangedApprovers:  ' + e.getMessage());
    }
  }

  private static void updateApprovalProcessPathOrders(
    String approvalProcessId,
    List<ApprovalProcessPathDto> approvalProcessPaths
  ) {
    try {
      List<ApprovalProcessPath__c> approvalPaths = getApprovalPaths(
        approvalProcessId
      );

      for (ApprovalProcessPathDto appDTO : approvalProcessPaths) {
        for (ApprovalProcessPath__c app : approvalPaths) {
          if (appDTO.Id.equals(app.Employee__c)) {
            app.Order__c = appDTO.Order;
          }
        }
      }

      update approvalPaths;
    } catch (Exception e) {
      System.debug(e.getMessage());
    }
  }

  public static void editApprovers(
    String approvalProcessId,
    List<ApprovalProcessPathDto> approvalProcessPaths
  ) {
    try {
      addAndRemoveApprovers(approvalProcessId, approvalProcessPaths);
      updateApprovalProcessPathOrders(approvalProcessId, approvalProcessPaths);
      ApproverActionUtil.groupApprovalUsers(approvalProcessId);
      recreateChangedApprovers(approvalProcessId, approvalProcessPaths);
      ApproverActionUtil.groupApprovalUsers(approvalProcessId);
      notifyChangedApprovers(approvalProcessId);
    } catch (Exception e) {
      System.debug(e.getMessage());
    }
  }
}