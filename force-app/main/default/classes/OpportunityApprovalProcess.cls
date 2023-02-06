/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 01-27-2023
 * @last modified by  : Bekhzod Ubaydullaev
 **/

/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 01-27-2023
 * @last modified by  : Bekhzod Ubaydullaev
 **/
public class OpportunityApprovalProcess {
  public static ApprovalProcess__c getStageApprovalProcess(
    String OpportunityId
  ) {
    Opportunity opp = [
      SELECT Id, StageName
      FROM Opportunity
      WHERE Id = :OpportunityId
    ];

    ApprovalProcess__c approvalProcess = [
      SELECT id, ReportType__c, OwnerId
      FROM ApprovalProcess__c
      WHERE
        Opportunity__c = :OpportunityId
        AND Opportunity_Stage__c = :opp.StageName
        AND ApprovalStatus__c = 'Created'
      LIMIT 1
    ];

    approvalProcess.OwnerId = UserInfo.getUserId();
    update approvalProcess;

    return approvalProcess;
  }
}