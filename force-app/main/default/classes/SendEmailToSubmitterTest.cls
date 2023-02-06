@isTest
private class SendEmailToSubmitterTest {
    @isTest static void sendEmailToSubmitterTest() {

        ApprovalProcess__c ap = [SELECT ID FROM ApprovalProcess__c WHERE Name = 'test notify submitter'];
        ApprovalProcessPath__c app = [SELECT Id, ApprovalProcessPathUID__c, ApprovalProcess__r.Opportunity__r.Name, ApprovalProcess__r.ReportType__c FROM ApprovalProcessPath__c WHERE ApprovalProcess__c = :ap.Id LIMIT 1];

        Test.startTest();
        SendEmailToSubmitter.sendEmail('foxpocus@gmail.com', app.ApprovalProcessPathUID__c);
        Test.stopTest();

        
    }

    @TestSetup
    static void makeData(){
        TestFactory.createCustomSetting();
        Test.setMock(HttpCalloutMock.class, new QuipCalloutMockTest());
        
        User user = TestFactory.createUser('i2us');
        Department__c dep = TestFactory.createDepartment('Test Notify Submitter');
        Contact con = TestFactory.createContact('Test notify submitter', dep.Id);
        Opportunity opp = OpportunityFactory.createOpportunityRfqValid('Test notify submitter');

        opp.Name = 'Test Opp';
        update opp;

        ApprovalProcess__c approvalProcess = new ApprovalProcess__c();
        approvalProcess.Name = 'test notify submitter';
        approvalProcess.Opportunity_Stage__c = 'Qualification';
        approvalProcess.ApprovalStatus__c = 'Created';
        approvalProcess.Opportunity__c = opp.Id;
        approvalProcess.QuipURL__c = 'https://www.mobis.com/';
        approvalProcess.ReportType__c = 'Report of RFQ Receipt';
        insert approvalProcess;

        ApprovalProcessPath__c path = new ApprovalProcessPath__c();
        path.ApprovalProcess__c = approvalProcess.Id;
        path.ApprovalUser__c = user.Id;
        path.ApprovalType__c = 'General Approval';
        path.Employee__c = con.Id;
        path.ApprovalProcessPathUID__c = GenerateUID.generate();
        insert path;        
        
    }
}