/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 01-06-2023
 * @last modified by  : Bekhzod Ubaydullaev
 **/
@isTest
public class ApprovalProcessPathControllerTest {
  @isTest
  static void getPickliststest() {
    Map<String, List<PicklistDTO>> picklists = ApprovalProcessPathController.getPicklists();

    system.assertEquals(picklists.size() > 0, true);
  }

  @isTest
  static void createApprovalProcessPathesValid() {
    List<Opportunity> opp = [SELECT Id FROM Opportunity LIMIT 1];

    Boolean hasCreated = ApprovalProcessPathController.createApprovalProcessPathes(
      opp[0].Id,
      'comment',
      ApprovalProcessPathFactory.validApprovalPaths()
    );

    system.assert(hasCreated, 'Approval process has been created successfully');
  }

  // @isTest
  // static void createApprovalProcessPathesInValid() {
  //   List<Opportunity> opp = [SELECT Id FROM Opportunity LIMIT 1];

  //   Boolean exceptionOccurred = false;

  //   try {
  //     Boolean hasCreated = ApprovalProcessPathController.createApprovalProcessPathes(
  //       opp[0].Id,
  //       ApprovalProcessPathFactory.invalidApprovalPaths()
  //     );
  //   } catch (Exception e) {
  //     exceptionOccurred = true;
  //   }

  //   system.assert(
  //     exceptionOccurred,
  //     'throw exception if first and last contacts not general approval'
  //   );
  // }

  @isTest
  static void createFavoriteApporvalPath() {
    List<Opportunity> opp = [SELECT Id FROM Opportunity LIMIT 1];

    Boolean hasCreated = ApprovalProcessPathController.createFavoriteApporvalPath(
      'Group',
      opp[0].Id,
      ApprovalProcessPathFactory.favoriteApprovalPaths()
    );

    system.assert(hasCreated, 'favorite approval path. has been created');
  }

  // @isTest
  // static void editApprovalProcessPaths() {
  //   List<Opportunity> opp = [SELECT Id FROM Opportunity LIMIT 1];

  //   ApprovalProcess__c approvalProcess = [
  //     SELECT id
  //     FROM ApprovalProcess__c
  //     LIMIT 1
  //   ];

  //   ApprovalProcessPathFactory.createApprovalProcessPath(approvalProcess.Id);

  //   Boolean isSubmitted = ApprovalProcessController.submitApprovalProcess(
  //     opp[0].Id
  //   );

  //   Boolean hasEdited = ApprovalProcessPathController.editApprovalProcessPaths(
  //     opp[0].Id,
  //     ApprovalProcessPathFactory.validApprovalPaths()
  //   );

  //   system.assert(hasEdited, 'Change for approval');
  // }

  @isTest
  static void getFavoriteApprovalPathGroup() {
    List<Opportunity> opp = [SELECT Id FROM Opportunity LIMIT 1];

    ApprovalProcessPathController.createFavoriteApporvalPath(
      'Group',
      opp[0].Id,
      ApprovalProcessPathFactory.favoriteApprovalPaths()
    );

    system.assertEquals(
      ApprovalProcessPathController.getFavoriteApprovalPathGroup().size(),
      1
    );
  }

  @isTest
  static void getFavoriteApprovalPaths() {
    List<Opportunity> opp = [SELECT Id FROM Opportunity LIMIT 1];

    ApprovalProcessPathController.createFavoriteApporvalPath(
      'Group',
      opp[0].Id,
      ApprovalProcessPathFactory.favoriteApprovalPaths()
    );

    FavoriteApprovalPathGroup__c favoriteGroup = [
      SELECT Id
      FROM FavoriteApprovalPathGroup__c
      LIMIT 1
    ];

    system.assertEquals(
      ApprovalProcessPathController.getFavoriteApprovalPathItems(
          favoriteGroup.Id
        )
        .size(),
      ApprovalProcessPathFactory.favoriteApprovalPaths().size()
    );
  }

  @isTest
  static void getApprovalProcessPaths() {
    ApprovalProcessPath__c approvalPath = new ApprovalProcessPath__c();

    ApprovalProcess__c approvalProcess = [
      SELECT id
      FROM ApprovalProcess__c
      LIMIT 1
    ];

    approvalPath.ApprovalProcess__c = approvalProcess.id;

    insert approvalPath;

    system.assertEquals(
      1,
      ApprovalProcessPathController.getApprovalProcessPathes(approvalPath.id)
        .size()
    );
  }

  @isTest
  static void getApprovalProcessPathesOfOpportunity() {
    List<Opportunity> opp = [SELECT Id FROM Opportunity LIMIT 1];

    List<ApprovalProcessPath__c> approvalPaths = ApprovalProcessPathController.getApprovalProcessPathesOfOpportunity(
      opp[0].Id
    );

    system.assertEquals(0, approvalPaths.size());
  }

  @isTest
  static void getApprovalProcesses() {
    List<Opportunity> opp = [SELECT Id FROM Opportunity LIMIT 1];

    List<ApprovalProcess__c> approvalProcesses = ApprovalProcessPathController.getApprovalProcesses(
      opp[0].Id
    );

    system.assertEquals(1, approvalProcesses.size());
  }

  @isTest
  static void approveApprovalProcessPath() {
    Contact employee = TestFactory.createContactEmployee('Contact', 'B05');
    Contact emp = [
      SELECT Id, UserId__c, EmployeeNumber__c
      FROM Contact
      WHERE Id = :employee.Id
    ];
    emp.UserId__c = UserInfo.getUserId();
    emp.EmployeeNumber__c = '100';
    update emp;

    ApprovalProcess__c approvalProcess = [
      SELECT id
      FROM ApprovalProcess__c
      LIMIT 1
    ];

    ApprovalProcessPath__c approvalProcessPath = ApprovalProcessPathFactory.createApprovalProcessPath(
      approvalProcess.Id
    );

    ApprovalProcessPath__c path = [
      SELECT Id, RequestDateTime__c
      FROM ApprovalProcessPath__c
      LIMIT 1
    ];
    path.RequestDateTime__c = Datetime.now();
    update path;

    String result;
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new QuipCalloutMockTest());
    result = ApprovalProcessPathController.approverAction(
      approvalProcessPath.id,
      'Approved',
      'Approved'
    );
    Test.stopTest();
    system.assertEquals('Successfully approved', result);
  }

  @isTest
  static void rejectApprovalProcessPath() {
    Contact employee = TestFactory.createContactEmployee('Contact', 'B05');
    Contact emp = [
      SELECT Id, UserId__c, EmployeeNumber__c
      FROM Contact
      WHERE Id = :employee.Id
    ];
    emp.UserId__c = UserInfo.getUserId();
    emp.EmployeeNumber__c = '100';
    update emp;

    ApprovalProcess__c approvalProcess = [
      SELECT id
      FROM ApprovalProcess__c
      LIMIT 1
    ];

    ApprovalProcessPath__c approvalProcessPath = ApprovalProcessPathFactory.createApprovalProcessPath(
      approvalProcess.Id
    );

    ApprovalProcessPath__c path = [
      SELECT Id, RequestDateTime__c
      FROM ApprovalProcessPath__c
      LIMIT 1
    ];
    path.RequestDateTime__c = Datetime.now();
    update path;

    String result;
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new QuipCalloutMockTest());
    result = ApprovalProcessPathController.approverAction(
      approvalProcessPath.Id,
      'Rejected',
      'Rejected'
    );
    Test.stopTest();
    system.assertEquals('Successfully rejected', result);
  }

  @isTest
  static void markRead() {
    Test.setMock(HttpCalloutMock.class, new QuipBatchCalloutMockTest());
    ApprovalProcess__c approvalProcess = [
      SELECT id
      FROM ApprovalProcess__c
      LIMIT 1
    ];

    ApprovalProcessPath__c approvalProcessPath = ApprovalProcessPathFactory.createApprovalProcessPath(
      approvalProcess.Id
    );

    approvalProcessPath.ApprovalStatus__c = 'Not Read';

    update approvalProcessPath;

    ApprovalProcessPathController.markRead(approvalProcessPath.Id);
  }

  @TestSetup
  static void makeData() {
    Test.setMock(HttpCalloutMock.class, new QuipCalloutMockTest());
    Opportunity opp = OpportunityFactory.createOpportunityRfqValid('Test');
    TestFactory.createApprovalProcess('Approval', opp.Id, 'Created');
    Department__c dep = TestFactory.createDepartment('It');
    TestFactory.createContact('user', dep.Id);
    TestFactory.createCustomSetting();
  }
}