/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 11-17-2022
 * @last modified by  : https://github.com/Eldor901
 **/

@isTest
public class OpportuniryControllerTest {
  @isTest
  static void getOpportunityRecordAccess() {
    Opportunity opp = [SELECT id FROM Opportunity LIMIT 1];

    UserRecordAccess access = OpportunityController.getOpportunityRecordAccess(
      opp.Id
    );

    system.assertEquals(true, access.HasEditAccess);
  }

  @isTest
  static void opportunityHasInProgressApprovalProcess() {
    Opportunity opp = [SELECT id FROM Opportunity LIMIT 1];

    Boolean hasInProgressApprovalProcess = OpportunityController.opportunityHasInProgressApprovalProcess(
      opp.Id
    );

    system.assertEquals(false, hasInProgressApprovalProcess);
  }

  @TestSetup
  static void makeData() {
    Opportunity opp = OpportunityFactory.createDefaulOpportunity();
  }
}