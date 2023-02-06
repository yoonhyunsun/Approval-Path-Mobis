/**
 * @description       :
 * @author            : Bekhzod Ubaydullaev
 * @group             :
 * @last modified on  : 12-01-2022
 * @last modified by  : Bekhzod Ubaydullaev
 **/
public without sharing class OpportunityStageApproverTriggerUtil {
  public static void changeStage(ApprovalProcess__c app) {
    try {
      List<Opportunity> opportunity = [
        SELECT
          StageName,
          Quick_Action_Stage__c,
          FirstReportApproved__c,
          SecondReportApproved__c,
          ThirdReportApproved__c,
          SecondReportNeeded__c,
          ThirdReportNeeded__c
        FROM Opportunity
        WHERE Id = :app.Opportunity__c
      ];

      List<Schema.PicklistEntry> entries = ApprovalProcess__c.ReportType__c.getDescribe()
        .getPicklistValues();

      if (opportunity[0].StageName == app.Opportunity_Stage__c) {
        if (opportunity[0].StageName == 'Quote Submitted') {
          if (
            app.ReportType__c == entries[1].getValue() &&
            !opportunity[0].FirstReportApproved__c
          ) {
            opportunity[0].FirstReportApproved__c = true;
          }
          if (
            app.ReportType__c == entries[2].getValue() &&
            opportunity[0].FirstReportApproved__c &&
            !opportunity[0].SecondReportApproved__c &&
            opportunity[0].SecondReportNeeded__c
          ) {
            opportunity[0].SecondReportApproved__c = true;
          }
          if (
            app.ReportType__c == entries[3].getValue() &&
            opportunity[0].FirstReportApproved__c &&
            opportunity[0].SecondReportApproved__c &&
            !opportunity[0].ThirdReportApproved__c &&
            opportunity[0].ThirdReportNeeded__c &&
            opportunity[0].SecondReportNeeded__c
          ) {
            opportunity[0].ThirdReportApproved__c = true;
          }

          opportunity[0].StageName = 'Negotiation';
        }

        if (opportunity[0].StageName == 'RFQ Received') {
          opportunity[0].StageName = 'Quote Submitted';
        }

        if (opportunity[0].StageName == 'Negotiation') {
          if (app.ReportType__c == entries[4].getValue()) {
            opportunity[0].StageName = 'Closed Won';
          }
          if (app.ReportType__c == entries[5].getValue()) {
            opportunity[0].StageName = 'Closed Lost';
          }
          if (app.ReportType__c == entries[6].getValue()) {
            opportunity[0].StageName = 'Cancelled';
          }
        }

        opportunity[0].Quick_Action_Stage__c = 'Draft';

        update opportunity;
      }
    } catch (Exception e) {
      System.debug(e.getMessage());
    }
  }

  public static void changeQuickActionDraft(String opportunityId) {
    try {
      List<Opportunity> opportunity = [
        SELECT StageName, Quick_Action_Stage__c
        FROM Opportunity
        WHERE Id = :opportunityId
      ];

      opportunity[0].Quick_Action_Stage__c = 'Draft';

      update opportunity;
    } catch (Exception e) {
      System.debug(e.getMessage());
    }
  }

  public static void deleteApprovalAndPaths(List<ApprovalProcess__c> appList) {
    try {
      if (!applist.isEmpty()) {
        List<ApprovalProcessPath__c> pathList = [
          SELECT id
          FROM ApprovalProcessPath__c
          WHERE ApprovalProcess__c = :appList[0].Id
        ];
        delete pathList;
        delete appList[0];
      }
    } catch (Exception e) {
      System.debug(e.getMessage());
    }
  }
}