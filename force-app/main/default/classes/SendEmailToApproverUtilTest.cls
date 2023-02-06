@isTest
private class SendEmailToApproverUtilTest {
    @isTest static void sendEmailToOtherApproverTest() {

        ApprovalProcess__c ap = [SELECT ID FROM ApprovalProcess__c WHERE Name = 'test notify approver'];
        ApprovalProcessPath__c app = [SELECT Id, ApprovalProcessPathUID__c, ApprovalProcess__r.Opportunity__r.Name, ApprovalProcess__r.ReportType__c FROM ApprovalProcessPath__c WHERE ApprovalProcess__c = :ap.Id AND ApprovalType__c = 'General Approval' LIMIT 1];

        Test.startTest();
        SendEmailToApproverUtil.sendEmail(app.ApprovalProcessPathUID__c);
        Test.stopTest();

    }

    @isTest static void sendEmailToReferenceApproverTest() {

        ApprovalProcess__c ap = [SELECT ID FROM ApprovalProcess__c WHERE Name = 'test notify approver'];
        ApprovalProcessPath__c app = [SELECT Id, ApprovalProcessPathUID__c, ApprovalProcess__r.Opportunity__r.Name, ApprovalProcess__r.ReportType__c FROM ApprovalProcessPath__c WHERE ApprovalProcess__c = :ap.Id AND ApprovalType__c = 'Reference' LIMIT 1];

        Test.startTest();
        SendEmailToApproverUtil.sendEmail(app.ApprovalProcessPathUID__c);
        Test.stopTest();

    }

    @isTest static void sendEmailToApproverWithoutEmailTest() {

        ApprovalProcess__c ap = [SELECT ID FROM ApprovalProcess__c WHERE Name = 'test notify approver'];
        ApprovalProcessPath__c app = [SELECT Id, ApprovalProcessPathUID__c, ApprovalProcess__r.Opportunity__r.Name, ApprovalProcess__r.ReportType__c FROM ApprovalProcessPath__c WHERE ApprovalProcess__c = :ap.Id AND ApprovalType__c = 'Collaboration' LIMIT 1];

        Test.startTest();
        SendEmailToApproverUtil.sendEmail(app.ApprovalProcessPathUID__c);
        Test.stopTest();

    }


    @TestSetup
    static void makeData(){
        TestFactory.createCustomSetting();
        Test.setMock(HttpCalloutMock.class, new QuipCalloutMockTest());
        
        User user = TestFactory.createUser('i2us');
        Department__c dep = TestFactory.createDepartment('Test Notify Approver');

        Contact con = TestFactory.createContact('Test notify approver', dep.Id);
        con.Email = 'test@test.test';
        update con;

        Contact con2 = TestFactory.createContact('Test notify approver 2', dep.Id);

        Opportunity opp = OpportunityFactory.createOpportunityRfqValid('Test notify approver');

        ApprovalProcess__c approvalProcess = new ApprovalProcess__c();
        approvalProcess.Name = 'test notify approver';
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
        
        ApprovalProcessPath__c path2 = new ApprovalProcessPath__c();
        path2.ApprovalProcess__c = approvalProcess.Id;
        path2.ApprovalUser__c = null;
        path2.ApprovalType__c = 'Reference';
        path2.Employee__c = con.Id;
        path2.ApprovalProcessPathUID__c = GenerateUID.generate();
        insert path2;   

        ApprovalProcessPath__c path3 = new ApprovalProcessPath__c();
        path3.ApprovalProcess__c = approvalProcess.Id;
        path3.ApprovalUser__c = null;
        path3.ApprovalType__c = 'Collaboration';
        path3.Employee__c = con2.Id;
        path3.ApprovalProcessPathUID__c = GenerateUID.generate();
        insert path3;   
        
    }
}