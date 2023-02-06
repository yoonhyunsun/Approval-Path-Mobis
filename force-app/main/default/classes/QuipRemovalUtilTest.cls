/**
 * @description       :
 * @author            : Bekhzod Ubaydullaev
 * @group             :
 * @last modified on  : 12-11-2022
 * @last modified by  : Bekhzod Ubaydullaev
 **/
@IsTest
public class QuipRemovalUtilTest {
  @IsTest
  static void testDelete() {
    Test.setMock(HttpCalloutMock.class, new QuipCalloutMockTest());
    Opportunity opp = OpportunityFactory.createOpportunityWithStage(
      'RFQ Received',
      'quip/url/12345',
      'Test Name'
    );
    Opportunity opp2 = OpportunityFactory.createOpportunityWithStage(
      'RFQ Received',
      'quip/url/12345',
      'Test Name IF'
    );
    List<ApprovalProcess__c> appList = ApprovalProcessFactory.createApprovalProcesses(
      opp.Id,
      opp.StageName,
      'Created',
      1
    );
    opp.QuipDoc__c = null;
    update opp;
    String expt;
    try {
      QuipRemovalUtil.checkQuipDeleted(opp2);
      QuipRemovalUtil.checkQuipDeleted(opp);
    } catch (Exception e) {
      expt = e.getMessage();
    }
    System.assertEquals(null, expt);
  }
}