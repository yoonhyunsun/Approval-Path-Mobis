/**
 * @description       :
 * @author            : Bekhzod Ubaydullaev
 * @group             :
 * @last modified on  : 02-03-2023
 * @last modified by  : Bekhzod Ubaydullaev
 **/
@SuppressWarnings('PMD.ApexCRUDViolation')
public without sharing class ApproverActionUtil {
  public static void notifyNextUsers(
    String approvalProcessId,
    Integer groupNumber
  ) {
    List<ApprovalProcess__c> approvalProcess = [
      SELECT ApprovalStatus__c, CurrentGroupNumber__c
      FROM ApprovalProcess__c
      WHERE Id = :approvalProcessId
    ];
    List<ApprovalProcessPath__c> approvalProcessPaths = [
      SELECT
        Id,
        ApprovalStatus__c,
        Employee__r.Email,
        ApprovalType__c,
        NotifiedGroup__c
      FROM ApprovalProcessPath__c
      WHERE
        ApprovalProcess__c = :approvalProcessId
        AND NotifiedGroup__c = :groupNumber
        AND ApprovalType__c != 'Draft'
      ORDER BY Order__c
    ];

    if (!approvalProcess.isEmpty() && !approvalProcessPaths.isEmpty()) {
      Integer approvals = 0;
      for (ApprovalProcessPath__c app : approvalProcessPaths) {
        if (
          app.ApprovalStatus__c == 'Approved' ||
          app.ApprovalType__c == 'Reference'
        ) {
          approvals++;
        }
      }

      if (approvals == approvalProcessPaths.size()) {
        if (isLastGroup(approvalProcessId, groupNumber)) {
          approvalProcess[0].ApprovalStatus__c = 'Approved';
        } else {
          approvalProcess[0].CurrentGroupNumber__c = notifyUsers(
            approvalProcessId,
            groupNumber + 1
          );
          List<ApprovalProcess__c> ap = [
            SELECT ApprovalStatus__c
            FROM ApprovalProcess__c
            WHERE Id = :approvalProcessId
          ];
          approvalProcess[0].ApprovalStatus__c = ap[0].ApprovalStatus__c;
        }

        update approvalProcess;
      }
    }
  }

  private static Boolean isLastGroup(
    String approvalProcessId,
    Integer currentGroupNumber
  ) {
    List<ApprovalProcessPath__c> approvalProcessPaths = [
      SELECT Id, NotifiedGroup__c
      FROM ApprovalProcessPath__c
      WHERE
        ApprovalProcess__c = :approvalProcessId
        AND ApprovalType__c != 'Draft'
      ORDER BY Order__c
    ];

    return currentGroupNumber ==
      approvalProcessPaths[approvalProcessPaths.size() - 1]
        .NotifiedGroup__c.intValue();
  }

  public static void groupApprovalUsers(String approvalProcessId) {
    List<ApprovalProcessPath__c> approvalProcessPaths = [
      SELECT Id, NotifiedGroup__c, ApprovalType__c
      FROM ApprovalProcessPath__c
      WHERE
        ApprovalProcess__c = :approvalProcessId
        AND ApprovalType__c != 'Draft'
      ORDER BY Order__c
    ];

    if (!approvalProcessPaths.isEmpty()) {
      Integer groupNumber = 0;
      Integer collRef = 0;
      for (ApprovalProcessPath__c app : approvalProcessPaths) {
        if (app.ApprovalType__c == 'General Approval') {
          collRef = 0;
          groupNumber++;
        }
        if (
          (app.ApprovalType__c == 'Reference' ||
          app.ApprovalType__c == 'Collaboration') && collRef != 0
        ) {
          collRef++;
        } else if (
          (app.ApprovalType__c == 'Reference' ||
          app.ApprovalType__c == 'Collaboration') && collRef == 0
        ) {
          collRef++;
          groupNumber++;
        }

        app.NotifiedGroup__c = groupNumber;
      }

      update approvalProcessPaths;
    }
  }

  public static Integer notifyUsers(
    String approvalProcessId,
    Integer groupNumber
  ) {
    List<ApprovalProcessPath__c> approvalProcessPaths = [
      SELECT
        Id,
        ApprovalUser__c,
        ApprovalType__c,
        ApprovalStatus__c,
        Employee__r.Id,
        ApprovalProcessPathUID__c
      FROM ApprovalProcessPath__c
      WHERE
        ApprovalProcess__c = :approvalProcessId
        AND NotifiedGroup__c = :groupNumber
        AND ApprovalType__c != 'Draft'
      ORDER BY Order__c
    ];

    if (approvalProcessPaths.isEmpty()) {
      List<ApprovalProcess__c> ap = [
        SELECT Id, ApprovalStatus__c
        FROM ApprovalProcess__c
        WHERE Id = :approvalProcessId
      ];
      ap[0].ApprovalStatus__c = 'Approved';
      update ap;

      return groupNumber - 1;
    }

    Integer references = 0;

    for (ApprovalProcessPath__c app : approvalProcessPaths) {
      if (app.ApprovalType__c == 'Reference') {
        references++;
      }

      if (app.ApprovalStatus__c == 'Not Sent') {
        SendEmailToApproverUtil.sendEmail(app.ApprovalProcessPathUID__c);
        // Send IF to Mobis EAI
        IF_Util.notifyApproval(app.Id);

        if (app.ApprovalUser__c != null) {
          //Send notification
          SendNotificationToApproverUtil.notifyUsers(
            new Set<String>{ app.ApprovalUser__c },
            String.valueOf(app.Id)
          );
        }
        app.ApprovalStatus__c = 'Not Read';
        app.RequestDateTime__c = Datetime.now();

        Datetime scheduleTime = Datetime.now().addDays(2);
        String cronExp =
          scheduleTime.second() +
          ' ' +
          scheduleTime.minute() +
          ' ' +
          scheduleTime.hour() +
          ' ' +
          scheduleTime.day() +
          ' ' +
          scheduleTime.month() +
          ' ? ' +
          scheduleTime.year();

        System.schedule(
          'Resend Email To APP ' + String.valueOf(app.Id),
          cronExp,
          new ResendEmailAndNotificationToApproverJob()
        );
      }
    }

    if (references == approvalProcessPaths.size()) {
      notifyUsers(approvalProcessId, groupNumber + 1);
    }

    update approvalProcessPaths;
    return groupNumber;
  }

  public static void rejectApprovalProcessPath(String approvalProcessId) {
    List<ApprovalProcess__c> ap = [
      SELECT ApprovalStatus__c
      FROM ApprovalProcess__c
      WHERE Id = :approvalProcessId
    ];

    if (!ap.isEmpty()) {
      ap[0].ApprovalStatus__c = 'Rejected';
      update ap;
    }
  }

  public static Boolean showApproveButtons(String uid) {
    List<ApprovalProcessPath__c> approvalProcessPaths = [
      SELECT ApprovalStatus__c, ApprovalType__c
      FROM ApprovalProcessPath__c
      WHERE ApprovalProcessPathUID__c = :uid
    ];

    Boolean result = true;

    if (!approvalProcessPaths.isEmpty()) {
      if (
        approvalProcessPaths[0].ApprovalStatus__c == 'Approved' ||
        approvalProcessPaths[0].ApprovalStatus__c == 'Rejected' ||
        approvalProcessPaths[0].ApprovalStatus__c == 'Not Sent' ||
        approvalProcessPaths[0].ApprovalType__c == 'Reference'
      ) {
        result = false;
      }
    }

    return result;
  }

  public static void notifySubmitter(String appUID) {
    ApprovalProcessPath__c approvalPath = [
      SELECT
        Id,
        CreatedBy.Id,
        CreatedBy.Email,
        CreatedBy.Name,
        ApprovalUser__c,
        ApprovalProcess__r.ReportType__c,
        ApprovalProcess__r.Opportunity__r.Name,
        ApprovalStatus__c,
        ApprovalProcess__r.OwnerId
      FROM ApprovalProcessPath__c
      WHERE ApprovalProcessPathUID__c = :appUID
    ];

    List<User> submitter = [
      SELECT Id, Name, Email
      FROM User
      WHERE Id = :approvalPath.ApprovalProcess__r.OwnerId
    ];

    //Send notification
    SendNotificationToSubmitter.notifyUsers(
      new Set<String>{ String.valueOf(submitter[0].Id) },
      String.valueOf(approvalPath.Id)
    );

    SendEmailToSubmitter.sendEmail(submitter[0].Email, appUID);
  }

  public static void removeNotificationFromMobis(Id approvalProcessId) {
    List<ApprovalProcessPath__c> apps = [
      SELECT Id
      FROM ApprovalProcessPath__c
      WHERE
        ApprovalProcess__c = :approvalProcessId
        AND (NotifiedGroup__c = 1
        OR NotifiedGroup__c = 2)
    ];
    for (ApprovalProcessPath__c app : apps) {
      IF_Util.removeApprovalNotification(app.Id);
    }
  }
}