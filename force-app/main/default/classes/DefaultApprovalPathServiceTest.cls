/**
 * @description       :
 * @author            : Bekhzod Ubaydullaev
 * @group             :
 * @last modified on  : 01-13-2023
 * @last modified by  : Bekhzod Ubaydullaev
 **/
@IsTest
public class DefaultApprovalPathServiceTest {
  @IsTest
  static void testRfqReceived() {
    Opportunity opp = OpportunityFactory.createOpportunityWithStage(
      'RFQ Received',
      'quip/url',
      'Random name'
    );
    Account acc = [SELECT Id, KAE__c FROM Account LIMIT 1];
    acc.KAE__c = UserInfo.getUserId();
    update acc;

    Department__c departmentChild = TestFactory.createDepartment('dep1');
    Department__c departmentParent = TestFactory.createDepartment('dep2');
    Department__c departmentChildupdated = [
      SELECT Id, ParentDepartment__c
      FROM Department__c
      WHERE Id = :departmentChild.Id
    ];
    departmentChildupdated.ParentDepartment__c = departmentParent.Id;
    update departmentChildupdated;

    Contact currContact = TestFactory.createContactEmployee('Current', null);
    Contact currContactupdated = [
      SELECT Id, EmpDepartment__c, EmpDepartment__r.ParentDepartment__c
      FROM Contact
      WHERE Id = :currContact.Id
    ];
    currContactupdated.EmpDepartment__c = departmentChild.Id;
    update currContactupdated;

    Contact teamleader = TestFactory.createContactEmployee(
      'Team Leader',
      'B03'
    );
    Contact teamleaderupdated = [
      SELECT Id, EmpDepartment__c, EmpDepartment__r.ParentDepartment__c
      FROM Contact
      WHERE Id = :teamleader.Id
    ];
    teamleaderupdated.EmpDepartment__c = departmentChild.Id;
    update teamleaderupdated;

    Contact departmentLeader = TestFactory.createContactEmployee(
      'Department Leader',
      'A08'
    );
    Contact departmentLeaderupdated = [
      SELECT Id, EmpDepartment__c, EmpDepartment__r.ParentDepartment__c
      FROM Contact
      WHERE Id = :departmentLeader.Id
    ];
    departmentLeaderupdated.EmpDepartment__c = departmentParent.Id;
    update departmentLeaderupdated;
    List<ApprovalProcessPathDTO> dto = ContactController.getDefaultPaths(
      opp.Id
    );
    System.assertEquals(3, dto.size());
  }
  /*
  @IsTest
  static void testNegotiation() {
    Opportunity opp = OpportunityFactory.createOpportunityWithStage(
      'Negotiation',
      'quip/url',
      'Random name'
    );
    Contact currContact = TestFactory.createContactEmployee('Current', null);
    Contact teamleader = TestFactory.createContactEmployee(
      'Team Leader',
      'B03'
    );
    Contact departmentLeader = TestFactory.createContactEmployee(
      'Department Leader',
      'A08'
    );
    Contact businessUnitLeader = TestFactory.createContactEmployee(
      'Business Unit Leader',
      'A05'
    );
    Contact ceo = TestFactory.createContactEmployee('CEO', 'A02');
    Contact collaborator = TestFactory.createContactEmployee(
      'Collaborator',
      null
    );
    collaborator.IsCollaborator__c = true;
    update collaborator;
    List<ApprovalProcessPathDTO> dto = DefaultApprovalPathsService.getDefaultsMain(
      opp.Id
    );
    System.assertEquals(4, dto.size());
  }
*/
  /*
  @IsTest
  static void testQuoteSubmitted() {
    Test.setMock(HttpCalloutMock.class, new QuipCalloutMockTest());
    Opportunity opp0 = OpportunityFactory.createOpportunityWithApprovalProcesses(
      'Quote Submitted',
      'Approved',
      0,
      'Test 0'
    );
    Opportunity opp1 = OpportunityFactory.createOpportunityWithApprovalProcesses(
      'Quote Submitted',
      'Approved',
      1,
      'Test 1'
    );
    opp1.FirstReportApproved__c = true;
    update opp1;

    Contact con = TestFactory.createContactEmployee('Contact', 'A02');
    ApprovalProcess__c app = [SELECT Id FROM ApprovalProcess__c LIMIT 1];
    ApprovalProcessPath__c path = TestFactory.createApprovalProcessPath(
      app.Id,
      UserInfo.getUserId(),
      'General Approval',
      con.Id
    );
    Opportunity opp2 = OpportunityFactory.createOpportunityWithApprovalProcesses(
      'Quote Submitted',
      'Approved',
      2,
      'Test 2'
    );
    List<Opportunity> oppList3 = [
      SELECT Id, StageName
      FROM Opportunity
      ORDER BY CreatedDate
    ];
    for (Opportunity opp : oppList3) {
      opp.StageName = 'Quote Submitted';
    }
    update oppList3;
    List<ApprovalProcessPathDTO> dto0 = DefaultApprovalPathsService.getDefaultsMain(
      opp0.Id
    );
    List<ApprovalProcessPathDTO> dto1 = DefaultApprovalPathsService.getDefaultsMain(
      opp1.Id
    );
    List<ApprovalProcessPathDTO> dto2 = DefaultApprovalPathsService.getDefaultsMain(
      opp2.Id
    );
    System.assertEquals(1, dto0.size());
    System.assertEquals(1, dto1.size());
    System.assertEquals(0, dto2.size());
  }
*/
  @TestSetup
  static void makeData() {
    TestFactory.createCustomSetting();
    Test.setMock(HttpCalloutMock.class, new QuipCalloutMockTest());
  }
}