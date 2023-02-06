public without sharing class GetCustomSettingsLWC {
  @AuraEnabled(cacheable=true)
  public static ApprovalProcessSettings__c getMobisApprovalCustomSettings() {
    return ApprovalProcessSettings__c.getOrgDefaults();
  }
}