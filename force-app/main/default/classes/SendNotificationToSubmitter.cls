/**
 * @description       :
 * @author            : Bekhzod Ubaydullaev
 * @group             :
 * @last modified on  : 01-30-2023
 * @last modified by  : Bekhzod Ubaydullaev
 **/
public without sharing class SendNotificationToSubmitter {
  public static void notifyUsers(Set<String> recipientsIds, String targetId) {
    CustomNotificationType notificationType = [
      SELECT Id, DeveloperName
      FROM CustomNotificationType
      WHERE DeveloperName = 'Notify_Submitter_Quip'
    ];

    List<ApprovalProcessPath__c> approvalPath = [
      SELECT
        ApprovalProcess__r.ReportType__c,
        ApprovalProcess__r.Opportunity__r.Name,
        ApprovalProcess__r.OwnerId,
        CreatedBy.Id,
        ApprovalStatus__c
      FROM ApprovalProcessPath__c
      WHERE Id = :targetId
    ];

    List<User> submitter = [
      SELECT Id, Name, Email
      FROM User
      WHERE Id = :approvalPath[0].ApprovalProcess__r.OwnerId
    ];

    String opportunityNameReportType =
      approvalPath[0].ApprovalProcess__r.Opportunity__r.Name +
      ': ' +
      approvalPath[0].ApprovalProcess__r.ReportType__c;

    Messaging.CustomNotification notification = new Messaging.CustomNotification();

    String body =
      'Approval request for the ' +
      opportunityNameReportType +
      ' is ' +
      approvalPath[0].ApprovalStatus__c.toLowercase();

    notification.setTitle(
      'Approval process path has been ' +
      approvalPath[0].ApprovalStatus__c.toLowercase()
    );

    notification.setBody(body);

    notification.setNotificationTypeId(notificationType.Id);
    notification.setTargetId(targetId);
    notification.setSenderId(submitter[0].Id);

    try {
      notification.send(recipientsIds);
    } catch (Exception e) {
      System.debug('Problem sending notification: ' + e.getMessage());
    }
  }
}