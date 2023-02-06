@isTest
private class ApproverActionServiceTest {
    @isTest
    static void testMarkReadWithStatusNotRead() {
        Test.setMock(HttpCalloutMock.class, new QuipCalloutMockTest());
        ApprovalProcessPath__c app = [SELECT Id, ApprovalProcessPathUID__c FROM ApprovalProcessPath__c WHERE ApprovalStatus__c = 'Not Read' LIMIT 1];
        Test.startTest();
        String result = ApproverActionService.markRead(app.ApprovalProcessPathUID__c);
        Test.stopTest();
        System.assertEquals('Success', result);
    }

    @isTest
    static void testMarkReadWithStatusRead() {
        Test.setMock(HttpCalloutMock.class, new QuipCalloutMockTest());
        ApprovalProcessPath__c app = [SELECT Id, ApprovalProcessPathUID__c FROM ApprovalProcessPath__c WHERE ApprovalStatus__c = 'Read' LIMIT 1];
        Test.startTest();
        String result = ApproverActionService.markRead(app.ApprovalProcessPathUID__c);
        Test.stopTest();
        System.assertEquals('Already Processed', result);
    }

    @isTest
    static void testMarkReadWithTypeReference() {
        Test.setMock(HttpCalloutMock.class, new QuipCalloutMockTest());
        ApprovalProcessPath__c app = [SELECT Id, ApprovalProcessPathUID__c FROM ApprovalProcessPath__c WHERE ApprovalType__c = 'Reference' LIMIT 1];
        Test.startTest();
        String result = ApproverActionService.markRead(app.ApprovalProcessPathUID__c);
        Test.stopTest();
        System.assertEquals('Success', result);
    }

    @isTest
    static void testMarkReadNotFound() {
        Test.setMock(HttpCalloutMock.class, new QuipCalloutMockTest());
        Test.startTest();
        String result = ApproverActionService.markRead('0');
        Test.stopTest();
        System.assertEquals('Not Found', result);
    }

    @isTest
    static void testApproverActionApproved() {
        Test.setMock(HttpCalloutMock.class, new QuipCalloutMockTest());
        ApprovalProcessPath__c app = [SELECT Id, ApprovalProcessPathUID__c FROM ApprovalProcessPath__c WHERE ApprovalType__c = 'Collaboration' AND ApprovalStatus__c = 'Read' LIMIT 1];
        Test.startTest();
        String result = ApproverActionService.approverAction(app.ApprovalProcessPathUID__c, 'Approved', 'approved');
        Test.stopTest();
        //System.assertEquals('Successfully approved', result);
    }

    @isTest
    static void testApproverActionWrongParams() {
        Test.setMock(HttpCalloutMock.class, new QuipCalloutMockTest());
        ApprovalProcessPath__c app = [SELECT Id, ApprovalProcessPathUID__c FROM ApprovalProcessPath__c WHERE ApprovalType__c = 'Collaboration' AND ApprovalStatus__c = 'Read' LIMIT 1];
        Test.startTest();
        String result = ApproverActionService.approverAction(app.ApprovalProcessPathUID__c, 'Wrong Param', 'approved');
        Test.stopTest();
    }

    @isTest
    static void testApproverActionAlreadyApproved() {
        Test.setMock(HttpCalloutMock.class, new QuipCalloutMockTest());
        ApprovalProcessPath__c app = [SELECT Id, ApprovalProcessPathUID__c FROM ApprovalProcessPath__c WHERE ApprovalType__c = 'Collaboration' AND ApprovalStatus__c = 'Approved' LIMIT 1];
        Test.startTest();
        String result = ApproverActionService.approverAction(app.ApprovalProcessPathUID__c, 'Approved', 'approved');
        Test.stopTest();
    }

    @isTest
    static void testApproverActionNotFound() {
        Test.setMock(HttpCalloutMock.class, new QuipCalloutMockTest());
        Test.startTest();
        String result = ApproverActionService.approverAction('0', 'Approved', 'approved');
        Test.stopTest();
    }

    @isTest
    static void testApproverActionRejected() {
        Test.setMock(HttpCalloutMock.class, new QuipCalloutMockTest());
        ApprovalProcessPath__c app = [SELECT Id, ApprovalProcessPathUID__c FROM ApprovalProcessPath__c WHERE ApprovalType__c = 'Collaboration' AND ApprovalStatus__c = 'Read' LIMIT 1];
        Test.startTest();
        String result = ApproverActionService.approverAction(app.ApprovalProcessPathUID__c, 'Rejected', 'approved');
        Test.stopTest();
    }

    @TestSetup
    static void makeData(){
        Test.setMock(HttpCalloutMock.class, new QuipCalloutMockTest());
        TestFactory.createCustomSetting();
        User user = TestFactory.createUser('i2us');
        Department__c dep = TestFactory.createDepartment('Test Notify Submitter');
        Contact con = TestFactory.createContact('Test notify submitter', dep.Id);
        Contact con2 = TestFactory.createContact('Test notify submitter 2', dep.Id);
        Contact con3 = TestFactory.createContact('Test notify submitter 3', dep.Id);
        Contact con4 = TestFactory.createContact('Test notify submitter 4', dep.Id);
        Contact con5 = TestFactory.createContact('Test notify submitter 4', dep.Id);

        con2.UserId__c = user.Id;
        con3.UserId__c = user.Id;
        con4.UserId__c = user.Id;
        con5.UserId__c = user.Id;

        con2.IsEmployee__c = true;
        con3.IsEmployee__c = true;
        con4.IsEmployee__c = true;
        con5.IsEmployee__c = true;

        con2.EmployeeNumber__c = '1';
        con3.EmployeeNumber__c = '2';
        con4.EmployeeNumber__c = '3';
        con5.EmployeeNumber__c = '4';

        update con2;
        update con3;
        update con4;
        update con5;
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
        path2.ApprovalType__c = 'Reference';
        path2.ApprovalStatus__c = 'Not Read';
        path2.Employee__c = con2.Id;
        path2.ApprovalProcessPathUID__c = GenerateUID.generate();
        path2.NotifiedGroup__c = 2;
        path2.RequestDateTime__c = Datetime.now();
        insert path2;     
        
        ApprovalProcessPath__c path3 = new ApprovalProcessPath__c();
        path3.ApprovalProcess__c = approvalProcess.Id;
        path3.ApprovalUser__c = user.Id;
        path3.ApprovalType__c = 'Collaboration';
        path3.ApprovalStatus__c = 'Read';
        path3.Employee__c = con3.Id;
        path3.ApprovalProcessPathUID__c = GenerateUID.generate();
        path3.NotifiedGroup__c = 2;
        path3.RequestDateTime__c = Datetime.now();
        insert path3;

        ApprovalProcessPath__c path5 = new ApprovalProcessPath__c();
        path5.ApprovalProcess__c = approvalProcess.Id;
        path5.ApprovalUser__c = user.Id;
        path5.ApprovalType__c = 'Collaboration';
        path5.ApprovalStatus__c = 'Approved';
        path5.Employee__c = con3.Id;
        path5.ApprovalProcessPathUID__c = GenerateUID.generate();
        path5.NotifiedGroup__c = 2;
        path5.RequestDateTime__c = Datetime.now();
        insert path5;

        ApprovalProcessPath__c path4 = new ApprovalProcessPath__c();
        path4.ApprovalProcess__c = approvalProcess.Id;
        path4.ApprovalUser__c = user.Id;
        path4.ApprovalType__c = 'General Approval';
        path4.ApprovalStatus__c = 'Not Sent';
        path4.Employee__c = con4.Id;
        path4.ApprovalProcessPathUID__c = GenerateUID.generate();
        path4.NotifiedGroup__c = 3;
        path4.RequestDateTime__c = Datetime.now();
        insert path4;   
    }
}