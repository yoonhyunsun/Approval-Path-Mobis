public without sharing class ResendEmailAndNotificationToApprovers {

    public void resendEmailAndNotification(String approvalProcessPathId) {

        ApprovalProcessPath__c app = [SELECT Id, ApprovalStatus__c, ApprovalType__c, ApprovalProcessPathUID__c, ApprovalUser__c FROM ApprovalProcessPath__c WHERE Id = :approvalProcessPathId LIMIT 1];

        if (app == null) {
            return;
        }

        if (app.ApprovalStatus__c == 'Not Read' || (app.ApprovalStatus__c == 'Read' && app.ApprovalType__c != 'Reference')) {
            SendEmailToApproverUtil.sendEmail(
              app.ApprovalProcessPathUID__c
            );
            // Send IF to Mobis EAI
            IF_Util.notifyApproval(app.Id);
    
            if (app.ApprovalUser__c != null) {
              //Send notification
              SendNotificationToApproverUtil.notifyUsers(
                new Set<String>{ app.ApprovalUser__c },
                String.valueOf(app.Id)
              );
            }
          }        
    }

}