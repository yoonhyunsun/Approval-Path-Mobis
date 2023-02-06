/**
 * @description       :
 * @author            : Bekhzod Ubaydullaev
 * @group             :
 * @last modified on  : 11-01-2022
 * @last modified by  : Bekhzod Ubaydullaev
 **/
public class QuipRemovalUtil {
  public static void checkQuipDeleted(Opportunity opportunity) {
    List<ApprovalProcess__c> appList = [
      SELECT id, ReportType__c, ApprovalStatus__c
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
      Approval_Process__e event = new Approval_Process__e();
      event.opptyId__c = String.valueOf(opportunity.Id);
      Eventbus.publish(event);
    }
  }
}