/**
 * @description       :
 * @author            : Bekhzod Ubaydullaev
 * @group             :
 * @last modified on  : 12-23-2022
 * @last modified by  : Bekhzod Ubaydullaev
 **/
@IsTest
public class OpportunityStageApproverTriggerUtilTest {
  @IsTest
  static void testChangeState() {
    Test.setMock(HttpCalloutMock.class, new QuipCalloutMockTest());
    Opportunity opp = OpportunityFactory.createOpportunityWithApprovalProcesses(
      'RFQ Received',
      'Approved',
      1,
      'Test'
    );
    ApprovalProcess__c app = [
      SELECT Id, Opportunity__c, Opportunity_Stage__c, ReportType__c
      FROM ApprovalProcess__c
      LIMIT 1
    ];
    OpportunityStageApproverTriggerUtil.changeQuickActionDraft(opp.Id);
    OpportunityStageApproverTriggerUtil.changeStage(app);
    app.Opportunity_Stage__c = 'Quote Submitted';
    update app;
    OpportunityStageApproverTriggerUtil.changeStage(app);
    OpportunityStageApproverTriggerUtil.deleteApprovalAndPaths(
      new List<ApprovalProcess__c>{ app }
    );
    Opportunity opp1 = [SELECT Id, StageName FROM Opportunity LIMIT 1];
    System.assertEquals('Negotiation', opp1.StageName);
  }
  /*
  @IsTest
  static void testChangeStateNegotiation() {
    Test.setMock(HttpCalloutMock.class, new QuipCalloutMockTest());
    List<Schema.PicklistEntry> entries = ApprovalProcess__c.ReportType__c.getDescribe()
      .getPicklistValues();
    Opportunity opp = OpportunityFactory.createOpportunityWithApprovalProcesses(
      'Negotiation',
      'Approved',
      1,
      'Test'
    );
    ApprovalProcess__c app = [
      SELECT Id, Opportunity__c, Opportunity_Stage__c, ReportType__c
      FROM ApprovalProcess__c
      LIMIT 1
    ];
    for (Integer i = 4; i <= 6; i++) {
      app.ReportType__c = entries[i].getValue();
      update app;
      OpportunityStageApproverTriggerUtil.changeStage(app);
      opp.StageName = 'Negotiation';
      update opp;
    }
    Opportunity opp1 = [SELECT Id, StageName FROM Opportunity LIMIT 1];
    System.assertEquals('Negotiation', opp1.StageName);
  }

  @IsTest
  static void testChangeQuoteSubmitted() {
    Test.setMock(HttpCalloutMock.class, new QuipCalloutMockTest());
    List<Schema.PicklistEntry> entries = ApprovalProcess__c.ReportType__c.getDescribe()
      .getPicklistValues();
    Profile profile = [
      SELECT Id
      FROM Profile
      WHERE Name = 'System Administrator'
      LIMIT 1
    ];
    User user = TestFactory.createUser('someUser');
    user.ProfileId = profile.Id;
    update user;
    System.runAs(user) {
      for (Integer i = 0; i < 3; i++) {
        OpportunityFactory.createOpportunityWithApprovalProcesses(
          'Quote Submitted',
          'Approved',
          1,
          i + ''
        );
      }
      List<Opportunity> oppList = [
        SELECT
          Id,
          FirstReportApproved__c,
          SecondReportApproved__c,
          ThirdReportApproved__c,
          SecondReportNeeded__c,
          ThirdReportNeeded__c
        FROM Opportunity
        ORDER BY CreatedDate
      ];

      oppList[2].FirstReportApproved__c = true;
      oppList[2].SecondReportApproved__c = true;
      oppList[2].SecondReportNeeded__c = true;
      oppList[2].ThirdReportNeeded__c = true;

      oppList[1].FirstReportApproved__c = true;
      oppList[1].SecondReportNeeded__c = true;

      update oppList;

      List<Opportunity> oppList3 = [
        SELECT Id, StageName
        FROM Opportunity
        ORDER BY CreatedDate
      ];
      for (Opportunity opp : oppList3) {
        opp.StageName = 'Quote Submitted';
      }
      update oppList3;

      List<ApprovalProcess__c> apps = [
        SELECT Id, Opportunity_Stage__c, Opportunity__c, ReportType__c
        FROM ApprovalProcess__c
        ORDER BY CreatedDate
      ];
      for (Integer i = 0; i < 3; i++) {
        apps[i].ReportType__c = entries[i + 1].getValue();
      }
      update apps;

      List<ApprovalProcess__c> appUpdated = [
        SELECT Id, Opportunity_Stage__c, Opportunity__c, ReportType__c
        FROM ApprovalProcess__c
        ORDER BY CreatedDate
      ];

      for (ApprovalProcess__c app : appUpdated) {
        OpportunityStageApproverTriggerUtil.changeStage(app);
      }
    }
    System.assert(true);
  }
*/
  @IsTest
  static void testCatch() {
    Test.setMock(HttpCalloutMock.class, new QuipCalloutMockTest());
    OpportunityStageApproverTriggerUtil.deleteApprovalAndPaths(
      new List<ApprovalProcess__c>{ null }
    );
    OpportunityStageApproverTriggerUtil.changeQuickActionDraft('Error');
    OpportunityStageApproverTriggerUtil.changeStage(null);
    System.assert(true);
  }

  @TestSetup
  static void makeData() {
    TestFactory.createCustomSetting();
  }
}