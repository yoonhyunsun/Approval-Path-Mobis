/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 01-30-2023
 * @last modified by  : https://github.com/Eldor901
 **/
public class ContactController {
  @AuraEnabled
  public static List<Contact> getContacts(String name, String department) {
    return ContactService.getContacts(name, department);
  }

  @AuraEnabled
  public static List<ApprovalProcessPathDTO> getDefaultPaths(Id opportunityId) {
    return DefaultApprovalPathsService.getDefaultsMain(opportunityId);
  }

  @AuraEnabled
  public static List<ApprovalProcessPath__c> getApprovalProcessSubmittedContacts(
    Id opportunityId
  ) {
    return ContactService.getApprovalProcessSubmittedContacts(opportunityId);
  }

  @AuraEnabled
  public static Contact getSubmitter() {
    return ContactService.getSubmitter();
  }

  @AuraEnabled
  public static List<Contact> getDefaultReferencer() {
    return ContactService.getDefaultReferencer();
  }

  @AuraEnabled
  public static Boolean checkifNotRFQ(Id opportunityId) {
    Opportunity oppty = [SELECT Id, StageName FROM Opportunity WHERE Id =: opportunityId];
    System.debug('oppty stage : ' + oppty.StageName);
    return oppty.StageName == 'RFQ Received' ? false : true;
  }


}