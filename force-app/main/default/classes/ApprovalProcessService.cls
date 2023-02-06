/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 11-21-2022
 * @last modified by  : https://github.com/Eldor901
 **/
public without sharing class ApprovalProcessService {
  public static Map<String, List<PicklistDTO>> getReportTypes() {
    List<PicklistDTO> reportTypes = PickListConverter.pickListToOption(
      (ApprovalProcess__c.ReportType__c.getDescribe().getPickListValues())
    );

    Map<String, List<PicklistDTO>> picklists = new Map<String, List<PicklistDTO>>();

    picklists.put('reportTypes', reportTypes);

    return picklists;
  }

  public static Boolean submitApprovalProcess(String OpportunityId) {
    Opportunity opp = [
      SELECT id, Quick_Action_Stage__c, StageName, LastPdfUrl__c
      FROM Opportunity
      WHERE id = :OpportunityId
      LIMIT 1
    ];

    ApprovalProcess__c approvalProcess = [
      SELECT Id, ApprovalStatus__c, PdfURL__c
      FROM ApprovalProcess__c
      WHERE
        ApprovalStatus__c = 'Created'
        AND Opportunity_Stage__c = :opp.StageName
        AND Opportunity__c = :opp.Id
      LIMIT 1
    ];

    approvalProcess.PdfURL__c = opp.LastPdfUrl__c;
    approvalProcess.ApprovalStatus__c = 'In Progress';

    try {
      update approvalProcess;
    } catch (Exception e) {
      System.debug(e.getMessage());
    }

    ApproverActionUtil.notifyUsers(approvalProcess.Id, 1);

    ApprovalProcess__c ap = [
      SELECT Id, ApprovalStatus__c
      FROM ApprovalProcess__c
      WHERE
      Id = :approvalProcess.Id
      LIMIT 1
    ];

    if (ap.ApprovalStatus__c == 'Approved') {
      return false;
    }


    return true;
  }
}