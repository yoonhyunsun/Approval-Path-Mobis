/**
 * @description       :
 * @author            : Bekhzod Ubaydullaev
 * @group             :
 * @last modified on  : 02-08-2023
 * @last modified by  : Bekhzod Ubaydullaev
 **/
public class QuipRemovalUtil {
  public static void checkQuipDeleted(Opportunity opportunity) {
    List<ApprovalProcess__c> appList = [
      SELECT id, ReportType__c, ApprovalStatus__c, Opportunity__c
      FROM ApprovalProcess__c
      WHERE
        Opportunity__c = :opportunity.Id
        AND Opportunity_Stage__c = :opportunity.StageName
      ORDER BY CreatedDate DESC
    ];

    if (appList.isEmpty()) {
      return;
    }

    ReportTypeDTO reportNew;
    reportNew = FilePDFutility.getQuipUrlByReportType(
      opportunity.Id,
      appList[0].ReportType__c
    );

    if (
      reportNew.quipDocUrl == 'ERROR' &&
      appList[0].ApprovalStatus__c == 'Created'
    ) {
      OpportunityStageApproverTriggerUtil.deleteApprovalAndPaths(appList);
      OpportunityStageApproverTriggerUtil.changeQuickActionDraft(
        opportunity.Id
      );

      // Publish event
      // When removing a quip doc , approvalid__c is user id
      Approval_Process__e event = new Approval_Process__e();
      event.opptyId__c = String.valueOf(opportunity.Id);
      event.opptyStage__c = String.valueOf(opportunity.StageName);
      event.userId__c = String.valueOf(UserInfo.getUserId());
      event.type__c = 'DRAFT';
      Eventbus.publish(event);
    }
  }

  public static Boolean checkIfNoCreatedOrInProgressApproval(
    String opportunityId
  ) {
    List<ApprovalProcess__c> appList = [
      SELECT id, ReportType__c, Opportunity__c, ApprovalStatus__c
      FROM ApprovalProcess__c
      WHERE
        Opportunity__c = :opportunityId
        AND (ApprovalStatus__c = 'In Progress'
        OR ApprovalStatus__c = 'Created')
      ORDER BY CreatedDate DESC
    ];
    if (appList.size() == 0) {
      return true;
    }
    return false;
  }

  public static Decimal getLastReplayId(String opportunityId) {
    List<Opportunity> oppty = [
      SELECT Id, StageName, LastReplayId__c
      FROM Opportunity
      WHERE Id = :opportunityId
    ];
    return oppty[0].LastReplayId__c;
  }

  public static Boolean checkIfIsLatestApproval(String approvalId) {
    List<ApprovalProcess__c> currentApp = [
      SELECT
        Id,
        OwnerId,
        CreatedDate,
        Opportunity_Stage__c,
        Opportunity__c,
        QuipURL__c
      FROM ApprovalProcess__c
      WHERE Id = :approvalId
    ];

    if (currentApp.size() == 0) {
      return false;
    }

    List<ApprovalProcess__c> apps = [
      SELECT
        Id,
        OwnerId,
        CreatedDate,
        Opportunity_Stage__c,
        Opportunity__c,
        QuipURL__c
      FROM ApprovalProcess__c
      WHERE
        Opportunity__c = :currentApp[0].Opportunity__c
        AND Opportunity_Stage__c = :currentApp[0].Opportunity_Stage__c
        AND CreatedDate > :currentApp[0].CreatedDate
    ];
    if (apps.size() == 0) {
      return true;
    }
    return false;
  }

  public static String getOpptyCurrentStage(String opportunityId) {
    List<Opportunity> oppty = [
      SELECT Id, StageName
      FROM Opportunity
      WHERE Id = :opportunityId
    ];
    return oppty[0].StageName;
  }

  public static List<String> getOwnerAndTeamMemberIds(String approvalId) {
    List<ApprovalProcess__c> currentApp = [
      SELECT
        Id,
        OwnerId,
        CreatedBy.Id,
        CreatedDate,
        Opportunity_Stage__c,
        Opportunity__c,
        QuipURL__c
      FROM ApprovalProcess__c
      WHERE Id = :approvalId
    ];
    List<OpportunityTeamMember> teamMembers = [
      SELECT Id, OpportunityId, UserId
      FROM OpportunityTeamMember
      WHERE OpportunityId = :currentApp[0].Opportunity__c
    ];
    List<String> userIds = new List<String>();
    for (OpportunityTeamMember member : teamMembers) {
      userIds.add(member.UserId);
    }
    if (currentApp.size() != 0) {
      userIds.add(currentApp[0].OwnerId);
      userIds.add(currentApp[0].CreatedBy.Id);
    }
    return userIds;
  }

  public static void createEventRejectedApproval(ApprovalProcess__c approval) {
    Approval_Process__e event = new Approval_Process__e();
    event.opptyId__c = String.valueOf(approval.Opportunity__c);
    event.approvalid__c = String.valueOf(approval.Id);
    event.opptyStage__c = String.valueOf(approval.Opportunity_Stage__c);
    event.quipDocUrl__c = String.valueOf(approval.QuipURL__c);
    event.type__c = 'REJECT';
    Eventbus.publish(event);
  }
}