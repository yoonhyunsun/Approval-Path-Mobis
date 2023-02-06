/**
 * @description       :
 * @author            : Bekhzod Ubaydullaev
 * @group             :
 * @last modified on  : 11-22-2022
 * @last modified by  : Bekhzod Ubaydullaev
 **/
@IsTest
public class ApprovalProcessFactory {
  public static List<ApprovalProcess__c> createApprovalProcesses(
    String opportunityId,
    String opportunityStage,
    String processStatus,
    Integer approvalNum
  ) {
    List<ApprovalProcess__c> apps = new List<ApprovalProcess__c>();
    for (Integer i = 0; i < approvalNum; i++) {
      ApprovalProcess__c app = TestFactory.createApprovalProcess(
        'Test',
        opportunityId,
        processStatus
      );
      app.Opportunity_Stage__c = opportunityStage;
      apps.add(app);
    }
    update apps;
    return apps;
  }
}