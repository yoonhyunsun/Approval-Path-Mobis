@isTest
private class ResendEmailJobTest {
  @isTest
  static void testJob() {
    ApprovalProcessPath__c app = [
      SELECT Id
      FROM ApprovalProcessPath__c
      WHERE ApprovalStatus__c = 'Not Read'
    ];

    Test.startTest();
    Datetime scheduleTime = Datetime.now().addYears(2);
    String cronExp = scheduleTime.second() + ' ' + scheduleTime.minute() + ' ' + scheduleTime.hour() + ' ' + scheduleTime.day() + ' ' + scheduleTime.month() + ' ? ' + scheduleTime.year();

    String jobId = System.schedule(
      'Resend Email To APP ' + app.Id,
      cronExp,
      new ResendEmailAndNotificationToApproverJob()
    );
    CronTrigger ct = [
      SELECT Id, CronExpression, TimesTriggered, NextFireTime
      FROM CronTrigger
      WHERE id = :jobId
    ];

    System.assertEquals(0, ct.TimesTriggered);

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

    con.UserId__c = user.Id;
    con2.UserId__c = user.Id;

    con.IsEmployee__c = true;
    con2.IsEmployee__c = true;

    con.EmployeeNumber__c = '1';
    con2.EmployeeNumber__c = '2';

    update con;
    update con2;
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
    path2.ApprovalType__c = 'General Approval';
    path2.ApprovalStatus__c = 'Not Sent';
    path2.Employee__c = con2.Id;
    path2.ApprovalProcessPathUID__c = GenerateUID.generate();
    path2.NotifiedGroup__c = 2;
    path2.RequestDateTime__c = Datetime.now();
    insert path2;
  }
}