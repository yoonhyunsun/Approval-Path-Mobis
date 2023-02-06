/**
 * @description       : 
 * @author            : Bekhzod Ubaydullaev
 * @group             : 
 * @last modified on  : 01-06-2023
 * @last modified by  : Bekhzod Ubaydullaev
**/
@isTest
private class ChangeApproverUtilTest {
  @isTest
  static void testAddApprovers() {
    Test.setMock(HttpCalloutMock.class, new QuipBatchCalloutMockTest());
    List<ApprovalProcessPathDto> approvalProcessPathsDto = new List<ApprovalProcessPathDTO>();
    List<ApprovalProcessPath__c> apps = [
      SELECT
        Id,
        ApprovalProcess__c,
        ApprovalProcessPathUID__c,
        ApprovalStatus__c,
        ApprovalType__c,
        ApprovalUser__c,
        Employee__c,
        NotifiedGroup__c,
        RequestDateTime__c,
        SiteURL__c,
        Order__c,
        ApprovalProcess__r.CreatedBy.Email,
        ApprovalProcess__r.CreatedBy.Name,
        ApprovalProcess__r.ReportType__c,
        ApprovalProcess__r.Opportunity__r.Name,
        ApprovalProcess__r.Name,
        Employee__r.Email
      FROM ApprovalProcessPath__c
    ];

    for (ApprovalProcessPath__c app : apps) {
      ApprovalProcessPathDTO appDto = new ApprovalProcessPathDTO();

      appDto.Id = app.Employee__c;
      appDto.ApprovalPathId = app.Id;
      appDto.ApprovalPathGroup = app.NotifiedGroup__c.intValue();
      appDto.ApprovalType = app.ApprovalType__c;
      appDto.Order = app.Order__c;
      appDto.ContactEmail = app.Employee__r.Email;
      appDto.UserId = app.ApprovalUser__c;

      approvalProcessPathsDto.add(appDto);
    }

    ApprovalProcessPathDTO appDto = new ApprovalProcessPathDTO();

    Contact cont = [
      SELECT Id, Email
      FROM Contact
      WHERE LastName = 'Test notify submitter 6'
    ];

    appDto.Id = String.valueOf(cont.Id);
    appDto.ApprovalType = 'General Approval';
    appDto.Order = 6;
    appDto.ContactEmail = cont.Email;
    approvalProcessPathsDto.add(appDto);

    approvalProcessPathsDto.remove(3);

    approvalProcessPathsDto[2].ApprovalType = 'Reference';

    Test.startTest();
    ChangeApproverUtil.editApprovers(
      apps[0].ApprovalProcess__c,
      approvalProcessPathsDto
    );
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
    Contact con4 = TestFactory.createContact('Test notify submitter 4', dep.Id);
    Contact con5 = TestFactory.createContact('Test notify submitter 5', dep.Id);
    Contact con6 = TestFactory.createContact('Test notify submitter 6', dep.Id);

    con2.Email = 'test@test2.com';
    con3.Email = 'test@test3.com';
    con4.Email = 'test@test4.com';
    con5.Email = 'test@test5.com';
    con5.Email = 'test@test6.com';

    con2.UserId__c = user.Id;
    con3.UserId__c = user.Id;
    con4.UserId__c = user.Id;
    con5.UserId__c = user.Id;
    con6.UserId__c = user.Id;

    con2.IsEmployee__c = true;
    con3.IsEmployee__c = true;
    con4.IsEmployee__c = true;
    con5.IsEmployee__c = true;
    con6.IsEmployee__c = true;

    con2.EmployeeNumber__c = '1';
    con3.EmployeeNumber__c = '2';
    con4.EmployeeNumber__c = '3';
    con5.EmployeeNumber__c = '4';
    con5.EmployeeNumber__c = '5';

    update con2;
    update con3;
    update con4;
    update con5;
    update con6;
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
    path2.ApprovalStatus__c = 'Read';
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
    path5.Employee__c = con5.Id;
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