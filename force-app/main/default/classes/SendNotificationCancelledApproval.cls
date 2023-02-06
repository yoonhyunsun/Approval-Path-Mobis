/**
 * @description       :
 * @author            : Bekhzod Ubaydullaev
 * @group             :
 * @last modified on  : 01-30-2023
 * @last modified by  : Bekhzod Ubaydullaev
 **/
@SuppressWarnings('PMD.ApexCRUDViolation')
public without sharing class SendNotificationCancelledApproval {
  // @future
  public static void notifyFirstApprover(
    Set<String> recipientId,
    String approvalId
  ) {
    CustomNotificationType notificationType = [
      SELECT Id, DeveloperName
      FROM CustomNotificationType
      WHERE DeveloperName = 'Notify_User_Quip'
    ];

    List<ApprovalProcess__c> approval = [
      SELECT Name, Opportunity__c, Opportunity__r.Name, OwnerId
      FROM ApprovalProcess__c
      WHERE Id = :approvalId
    ];

    List<User> submitter = [
      SELECT Id, Name
      FROM User
      WHERE Id = :approval[0].OwnerId
    ];

    Messaging.CustomNotification notification = new Messaging.CustomNotification();

    String body =
      'Approval Process: ' +
      approval[0].Name +
      ' • ' +
      'Opportunity: ' +
      approval[0].Opportunity__r.Name;

    notification.setTitle(
      submitter[0].Name +
      ' ' +
      'cancelled approval process'
    );

    notification.setBody(body);

    notification.setNotificationTypeId(notificationType.Id);
    notification.setTargetId(approval[0].Opportunity__c);
    notification.setSenderId(submitter[0].Id);

    try {
      notification.send(recipientId);
    } catch (Exception e) {
      System.debug('Problem sending notification: ' + e.getMessage());
    }
  }
}