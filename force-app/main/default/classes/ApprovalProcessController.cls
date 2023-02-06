/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 11-21-2022
 * @last modified by  : https://github.com/Eldor901
 **/
public without sharing class ApprovalProcessController {
  @AuraEnabled(cacheable=true)
  public static Map<String, List<PicklistDTO>> getReportTypes() {
    return ApprovalProcessService.getReportTypes();
  }

  @AuraEnabled
  public static Boolean submitApprovalProcess(String OpportunityId) {
    return ApprovalProcessService.submitApprovalProcess(OpportunityId);
  }

}