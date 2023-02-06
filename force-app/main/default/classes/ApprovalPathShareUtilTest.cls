/**
 * @description       :
 * @author            : Bekhzod Ubaydullaev
 * @group             :
 * @last modified on  : 12-12-2022
 * @last modified by  : Bekhzod Ubaydullaev
 **/
@IsTest
public class ApprovalPathShareUtilTest {
  @IsTest
  static void testShare() {
    Test.setMock(HttpCalloutMock.class, new QuipCalloutMockTest());
    String expt;
    User user = TestFactory.createUser('i2us');
    Department__c dep = TestFactory.createDepartment('Test');
    Contact con = TestFactory.createContact('Test', dep.Id);
    Opportunity opp = OpportunityFactory.createOpportunityRfqValid('Test');
    ApprovalProcess__c app = TestFactory.createApprovalProcess(
      'test',
      opp.Id,
      'Created'
    );
    ApprovalProcessPath__c path = TestFactory.createApprovalProcessPath(
      app.Id,
      user.Id,
      'General Approval',
      con.Id
    );
    ApprovalProcessPath__c path2 = TestFactory.createApprovalProcessPath(
      app.Id,
      UserInfo.getUserId(),
      'General Approval',
      con.Id
    );
    Test.startTest();
    try {
      ApprovalPathSharingUtil.shareRecord(
        new List<ApprovalProcessPath__c>{ path, path2 }
      );
      ApprovalPathSharingUtil.deleteShareRecord(
        new List<ApprovalProcessPath__c>{ path, path2 }
      );
    } catch (Exception e) {
      expt = e.getMessage();
    }
    Test.stopTest();
    System.assertEquals(null, expt);
  }

  @isTest
  static void testLockUnlock() {
    String expt;
    Opportunity opp = OpportunityFactory.createOpportunityWithStage(
      'RFQ Received',
      'https://mobis/quip/url',
      'Test Name'
    );
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new QuipCalloutMockTest());
    try {
      ApprovalPathSharingUtil.lockQuipAndRecord(opp.QuipDoc__c, opp.Id);
      ApprovalPathSharingUtil.unlockQuipAndRecord(opp.QuipDoc__c, opp.Id);
    } catch (Exception e) {
      expt = e.getMessage();
    }
    Test.stopTest();
    System.assertEquals(null, expt);
  }

  @IsTest
  static void testCancelApproval() {
    Test.setMock(HttpCalloutMock.class, new QuipCalloutMockTest());
    Department__c dep = TestFactory.createDepartment('Test');
    Contact con = TestFactory.createContact('Test', dep.Id);
    Opportunity opp = OpportunityFactory.createOpportunityWithStage(
      'RFQ Received',
      'https://mobis/quip/url',
      'Test Name'
    );
    ApprovalProcess__c app = TestFactory.createApprovalProcess(
      'test',
      opp.Id,
      'Created'
    );
    ApprovalProcessPath__c path = TestFactory.createApprovalProcessPath(
      app.Id,
      userinfo.getuserid(),
      'General Approval',
      con.Id
    );
    ApprovalProcessPath__c pathApp = [
      SELECT ID, NotifiedGroup__c, ApprovalUser__c
      FROM ApprovalProcessPath__c
      LIMIT 1
    ];
    pathApp.NotifiedGroup__c = 1;
    pathApp.ApprovalUser__c = userinfo.getuserid();
    update pathApp;
    Test.startTest();
    app.ApprovalStatus__c = 'In Progress';
    update app;
    ApprovalProcess__c appProcess = [
      SELECT Id, ApprovalStatus__c
      FROM ApprovalProcess__c
      LIMIT 1
    ];
    appProcess.ApprovalStatus__c = 'Cancelled';
    update appProcess;
    Test.stopTest();
  }

  @TestSetup
  static void makeData() {
    TestFactory.createCustomSetting();
  }
}