@isTest
private class ApprovalProcessPathInfoTableContTest {

    @isTest
    static void testGetInfoTable() {

        ApprovalProcessPath__c app = [SELECT Id, ApprovalProcessPathUID__c FROM ApprovalProcessPath__c WHERE ApprovalStatus__c = 'Not Read'];
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/ApprovalProcessInfoTable/*';
        request.httpMethod = 'GET';
        RestResponse response = new RestResponse();

        request.params.put('uid', app.ApprovalProcessPathUID__c);
        RestContext.request = request;
        RestContext.response = response;

        String uid = RestContext.request.params.get('uid');
        Test.startTest();
        ApprovalProcessPathInfoTableController.getInfo();
        Test.stopTest();
    }

    @isTest
    static void testNotFound() {

        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/ApprovalProcessInfoTable/*';
        request.httpMethod = 'GET';
        RestResponse response = new RestResponse();

        request.params.put('uid', '123');
        RestContext.request = request;
        RestContext.response = response;

        String uid = RestContext.request.params.get('uid');
        Test.startTest();
        ApprovalProcessPathInfoTableController.getInfo();
        Test.stopTest();
    }

    @TestSetup
    static void makeData(){
        Test.setMock(HttpCalloutMock.class, new QuipCalloutMockTest());
        TestFactory.createCustomSetting();
        User user = TestFactory.createUser('i2us');
        Department__c dep = TestFactory.createDepartment('Test Notify Submitter');
        Contact con = TestFactory.createContact('Test notify submitter', dep.Id);
        Opportunity opp = OpportunityFactory.createOpportunityRfqValid('Test notify submitter');

        opp.Name = 'Test Opp';
        opp.StageName = 'RFQ Received';
        update opp;

        ApprovalProcess__c approvalProcess = new ApprovalProcess__c();
        approvalProcess.Name = 'test notify submitter';
        approvalProcess.Opportunity_Stage__c = 'RFQ Received';
        approvalProcess.ApprovalStatus__c = 'In Progress';
        approvalProcess.Opportunity__c = opp.Id;
        approvalProcess.QuipURL__c = 'https://www.mobis.com/';
        approvalProcess.ReportType__c = 'Report of RFQ Receipt';
        insert approvalProcess;

        ApprovalProcessPath__c path = new ApprovalProcessPath__c();
        path.ApprovalProcess__c = approvalProcess.Id;
        path.ApprovalUser__c = user.Id;
        path.ApprovalType__c = 'General Approval';
        path.ApprovalStatus__c = 'Not Read';
        path.Employee__c = con.Id;
        path.ApprovalProcessPathUID__c = GenerateUID.generate();
        path.NotifiedGroup__c = 1;
        path.RequestDateTime__c = Datetime.now();
        insert path;    

        ApprovalProcessPath__c path2 = new ApprovalProcessPath__c();
        path2.ApprovalProcess__c = approvalProcess.Id;
        path2.ApprovalUser__c = user.Id;
        path2.ApprovalType__c = 'General Approval';
        path2.ApprovalStatus__c = 'Read';
        path2.Employee__c = con.Id;
        path2.ApprovalProcessPathUID__c = GenerateUID.generate();
        path2.NotifiedGroup__c = 2;
        path2.RequestDateTime__c = Datetime.now();
        insert path2; 
        
    }
}