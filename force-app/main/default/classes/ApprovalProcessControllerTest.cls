/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 12-11-2022
 * @last modified by  : Bekhzod Ubaydullaev
 **/
@isTest
public class ApprovalProcessControllerTest {
  @isTest
  static void getReportTypes() {
    Map<String, List<PicklistDTO>> reportTypes = ApprovalProcessController.getReportTypes();

    system.assertEquals(reportTypes.size() > 0, true);
  }

  // @isTest
  // static void submitApprovalProcess() {
  //   List<Opportunity> opp = [SELECT Id FROM Opportunity LIMIT 1];

  //   Boolean isSubmitted = ApprovalProcessController.submitApprovalProcess(
  //     opp[0].Id
  //   );

  //   system.assertEquals(isSubmitted, true);
  // }

  @TestSetup
  static void makeData() {
    Test.setMock(HttpCalloutMock.class, new QuipCalloutMockTest());
    Opportunity opp = OpportunityFactory.createDefaulOpportunity();
    ApprovalProcess__c approvalProcess = TestFactory.createApprovalProcess(
      'Approval',
      opp.Id,
      'Created'
    );
    ApprovalProcessPathFactory.createApprovalProcessPath(approvalProcess.Id);
  }
}