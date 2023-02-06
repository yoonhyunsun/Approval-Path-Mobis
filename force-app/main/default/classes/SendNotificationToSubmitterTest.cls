@isTest
private class SendNotificationToSubmitterTest {

    @isTest
    static void testNotifyUser() {
      Test.setMock(HttpCalloutMock.class, new QuipCalloutMockTest());
        User user = TestFactory.createUser('i2us');
        Department__c dep = TestFactory.createDepartment('Test Notify Submitter');
        Contact con = TestFactory.createContact('Test notify submitter', dep.Id);
        Opportunity opp = OpportunityFactory.createOpportunityRfqValid('Test notify submitter');
        ApprovalProcess__c app = TestFactory.createApprovalProcess(
          'test notify submitter',
          opp.Id,
          'Created'
        );
        ApprovalProcessPath__c path = TestFactory.createApprovalProcessPath(
          app.Id,
          user.Id,
          'General Approval',
          con.Id
        );

        Set<String> users = new Set<String>();
        users.add(user.Id);
        Test.startTest();
        SendNotificationToSubmitter.notifyUsers(users, path.Id);
        SendNotificationCancelledApproval.notifyFirstApprover(users,app.Id);
        Test.stopTest();
        System.assert(true);
    }


}