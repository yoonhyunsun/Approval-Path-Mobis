/**
 * @description       :
 * @author            : Bekhzod Ubaydullaev
 * @group             :
 * @last modified on  : 01-06-2023
 * @last modified by  : Bekhzod Ubaydullaev
 **/
@IsTest
public class BatchTest {
  @TestSetup
  static void makeData() {
    Test.setMock(HttpCalloutMock.class, new QuipBatchCalloutMockTest());
    TestFactory.createCustomSetting();
  }

  @IsTest
  public static void testAddOpptyTeam() {
    Test.setMock(HttpCalloutMock.class, new QuipBatchCalloutMockTest());
    Opportunity opp = OpportunityFactory.createOpportunityRfqValid('Test');
    List<OpportunityTeamMember> opptyTeam = new List<OpportunityTeamMember>();
    for (Integer i = 0; i < 20; i++) {
      OpportunityTeamMember member = new OpportunityTeamMember();
      member.OpportunityId = opp.Id;
      member.TeamMemberRole = '';
      member.UserId = UserInfo.getUserId();

      opptyTeam.add(member);
    }
    insert opptyTeam;
    List<OpportunityTeamMember> team = [
      SELECT Id, OpportunityId, TeamMemberRole, UserId
      FROM OpportunityTeamMember
    ];
    BatchAddRemoveOpportunityTeamMember batch = new BatchAddRemoveOpportunityTeamMember(
      team,
      true
    );
    Database.executeBatch(batch, 20);
    System.assert(true);
  }

  @IsTest
  public static void testRemoveOpptyTeam() {
    Test.setMock(HttpCalloutMock.class, new QuipBatchCalloutMockTest());
    Opportunity opp = OpportunityFactory.createOpportunityRfqValid('Test');
    Opportunity opp1 = [
      SELECT
        Id,
        QuipDoc__c,
        QuipDoc2__c,
        QuipDoc3__c,
        QuipDoc4__c,
        QuipDoc5__c,
        QuipDoc6__c,
        QuipDoc7__c,
        QuipDoc8__c
      FROM Opportunity
      WHERE Id = :opp.Id
    ];
    opp1.QuipDoc__c = 'https://mobis/quip/id';
    opp1.QuipDoc2__c = 'https://mobis/quip/id';
    opp1.QuipDoc3__c = 'https://mobis/quip/id';
    opp1.QuipDoc4__c = 'https://mobis/quip/id';
    opp1.QuipDoc5__c = 'https://mobis/quip/id';
    opp1.QuipDoc6__c = 'https://mobis/quip/id';
    opp1.QuipDoc7__c = 'https://mobis/quip/id';
    opp1.QuipDoc8__c = 'https://mobis/quip/id';
    update opp1;
    List<OpportunityTeamMember> opptyTeam = new List<OpportunityTeamMember>();
    for (Integer i = 0; i < 20; i++) {
      OpportunityTeamMember member = new OpportunityTeamMember();
      member.OpportunityId = opp.Id;
      member.TeamMemberRole = '';
      member.UserId = UserInfo.getUserId();

      opptyTeam.add(member);
    }
    insert opptyTeam;
    List<OpportunityTeamMember> team = [
      SELECT Id, OpportunityId, TeamMemberRole, UserId
      FROM OpportunityTeamMember
    ];
    BatchAddRemoveOpportunityTeamMember batch = new BatchAddRemoveOpportunityTeamMember(
      team,
      false
    );
    Database.executeBatch(batch, 20);
    System.assert(true);
  }

  @IsTest
  public static void testDocInserted() {
    Test.setMock(HttpCalloutMock.class, new QuipBatchCalloutMockTest());
    Map<String, List<String>> m = new Map<String, List<String>>();
    List<String> l = new List<String>();
    for (Integer i = 0; i < 10; i++) {
      l.add('https://quip/123');
      l.add('https://quip/456');
    }
    Opportunity opp = OpportunityFactory.createOpportunityRfqValid('Test');
    OpportunityTeamMember member = new OpportunityTeamMember();
    member.OpportunityId = opp.Id;
    member.TeamMemberRole = '';
    member.UserId = UserInfo.getUserId();
    insert member;
    m.put(opp.Id, l);
    BatchQuipDocInserted batch = new BatchQuipDocInserted(m);
    Database.executeBatch(batch, 20);
    System.assert(true);
  }

  @IsTest
  public static void testApprovalDeleted() {
    Test.setMock(HttpCalloutMock.class, new QuipBatchCalloutMockTest());
    Opportunity opp = OpportunityFactory.createOpportunityWithApprovalProcesses(
      'RFQ Received',
      'Created',
      2,
      'Test'
    );
    List<ApprovalProcess__c> appList = [
      SELECT
        Id,
        Name,
        QuipURL__c,
        ApprovalStatus__c,
        Opportunity__c,
        Opportunity_Stage__c
      FROM ApprovalProcess__c
    ];
    Database.executeBatch(new BatchApprovalProcessDeleted(appList), 10);
    System.assert(true);
  }

  @IsTest
  public static void testApproversQuipAdd() {
    Test.setMock(HttpCalloutMock.class, new QuipBatchCalloutMockTest());
    User user = TestFactory.createUser('te@a.a');
    user.Email = 'testemail@gmail.com';
    update user;
    Opportunity opp = OpportunityFactory.createOpportunityWithApprovalProcesses(
      'RFQ Received',
      'Created',
      1,
      'Test'
    );
    List<ApprovalProcess__c> appList = [
      SELECT
        Id,
        Name,
        QuipURL__c,
        ApprovalStatus__c,
        Opportunity__c,
        Opportunity_Stage__c
      FROM ApprovalProcess__c
    ];
    appList[0].QuipURL__c = 'https://mobis/quip/id';
    update appList;

    Department__c dep = TestFactory.createDepartment('Test Depatment');
    Contact con = TestFactory.createContact('Test Contact', dep.Id);

    ApprovalProcessPath__c path = new ApprovalProcessPath__c();
    path.ApprovalProcess__c = appList[0].Id;
    path.ApprovalUser__c = user.Id;
    path.ApprovalType__c = 'Collaboration';
    path.ApprovalStatus__c = 'Not Sent';
    path.Employee__c = con.Id;
    path.ApprovalProcessPathUID__c = GenerateUID.generate();
    path.RequestDateTime__c = Datetime.now();
    insert path;
    Database.executeBatch(
      new BatchAddRemoveApprovers(
        new List<ApprovalProcessPath__c>{ path },
        true
      ),
      10
    );
  }
}