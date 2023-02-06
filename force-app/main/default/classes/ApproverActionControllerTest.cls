@isTest
private class ApproverActionControllerTest {
  @isTest
  static void testApprove() {
    ApprovalProcessPath__c app = [
      SELECT Id, ApprovalProcessPathUID__c
      FROM ApprovalProcessPath__c
      WHERE ApprovalStatus__c = 'Not Read' AND ApprovalType__c = 'General Approval' LIMIT 1
    ];
    RestRequest request = new RestRequest();
    request.requestUri = '/services/apexrest/ApprovalAction/*';
    request.httpMethod = 'POST';
    RestResponse response = new RestResponse();

    JSONGenerator gen = JSON.createGenerator(true);
    gen.writeStartObject();
    gen.writeStringField('uid', app.ApprovalProcessPathUID__c);
    gen.writeStringField('action', 'Approved');
    gen.writeStringField('comment', 'Hello');
    gen.writeEndObject();

    request.requestBody = Blob.valueof(gen.getAsString());
    RestContext.request = request;
    RestContext.response = response;

    Test.startTest();
    ApproverActionController.approveOrReject();
    Test.stopTest();
  }

  @isTest
  static void testWrongParams() {
    ApprovalProcessPath__c app = [
      SELECT Id, ApprovalProcessPathUID__c
      FROM ApprovalProcessPath__c
      WHERE ApprovalStatus__c = 'Not Read' AND ApprovalType__c = 'General Approval' LIMIT 1
    ];
    RestRequest request = new RestRequest();
    request.requestUri = '/services/apexrest/ApprovalAction/*';
    request.httpMethod = 'POST';
    RestResponse response = new RestResponse();

    JSONGenerator gen = JSON.createGenerator(true);
    gen.writeStartObject();
    gen.writeStringField('uid', app.ApprovalProcessPathUID__c);
    gen.writeStringField('action', 'Wrong Param');
    gen.writeStringField('comment', 'Hello');
    gen.writeEndObject();

    request.requestBody = Blob.valueof(gen.getAsString());
    RestContext.request = request;
    RestContext.response = response;

    Test.startTest();
    ApproverActionController.approveOrReject();
    Test.stopTest();
  }

  @isTest
  static void testNotFound() {
    ApprovalProcessPath__c app = [
      SELECT Id, ApprovalProcessPathUID__c
      FROM ApprovalProcessPath__c
      WHERE ApprovalStatus__c = 'Not Read' AND ApprovalType__c = 'General Approval' LIMIT 1
    ];
    RestRequest request = new RestRequest();
    request.requestUri = '/services/apexrest/ApprovalAction/*';
    request.httpMethod = 'POST';
    RestResponse response = new RestResponse();

    JSONGenerator gen = JSON.createGenerator(true);
    gen.writeStartObject();
    gen.writeStringField('uid', '123');
    gen.writeStringField('action', 'Approved');
    gen.writeStringField('comment', 'Hello');
    gen.writeEndObject();

    request.requestBody = Blob.valueof(gen.getAsString());
    RestContext.request = request;
    RestContext.response = response;

    Test.startTest();
    ApproverActionController.approveOrReject();
    Test.stopTest();
  }

  @isTest
  static void testAlreadyProcessed() {
    ApprovalProcessPath__c app = [
      SELECT Id, ApprovalProcessPathUID__c
      FROM ApprovalProcessPath__c
      WHERE ApprovalType__c = 'Collaboration' AND ApprovalStatus__c = 'Approved' LIMIT 1
    ];
    RestRequest request = new RestRequest();
    request.requestUri = '/services/apexrest/ApprovalAction/*';
    request.httpMethod = 'POST';
    RestResponse response = new RestResponse();

    JSONGenerator gen = JSON.createGenerator(true);
    gen.writeStartObject();
    gen.writeStringField('uid', app.ApprovalProcessPathUID__c);
    gen.writeStringField('action', 'Approved');
    gen.writeStringField('comment', 'Hello');
    gen.writeEndObject();

    request.requestBody = Blob.valueof(gen.getAsString());
    RestContext.request = request;
    RestContext.response = response;

    Test.startTest();
    ApproverActionController.approveOrReject();
    Test.stopTest();
  }

  @TestSetup
  static void makeData() {
    Test.setMock(HttpCalloutMock.class, new QuipCalloutMockTest());
    TestFactory.createCustomSetting();
    User user = TestFactory.createUser('i2us');
    Department__c dep = TestFactory.createDepartment('Test Notify Submitter');
    Contact con = TestFactory.createContact('Test notify submitter', dep.Id);
    Contact con2 = TestFactory.createContact('Test notify submitter 2', dep.Id);
    Contact con3 = TestFactory.createContact('Test notify submitter 3', dep.Id);

    con2.UserId__c = user.Id;
    con3.UserId__c = user.Id;

    con2.IsEmployee__c = true;
    con3.IsEmployee__c = true;

    con2.EmployeeNumber__c = '1';
    con3.EmployeeNumber__c = '2';

    update con2;
    update con3;
    Opportunity opp = OpportunityFactory.createOpportunityRfqValid(
      'Test notify submitter'
    );

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
    path3.ApprovalStatus__c = 'Approved';
    path3.Employee__c = con3.Id;
    path3.ApprovalProcessPathUID__c = GenerateUID.generate();
    path3.NotifiedGroup__c = 2;
    path3.RequestDateTime__c = Datetime.now();
    insert path3;
  }
}