/**
 * @description       :
 * @author            : Bekhzod Ubaydullaev
 * @group             :
 * @last modified on  : 01-30-2023
 * @last modified by  : Bekhzod Ubaydullaev
 **/
@SuppressWarnings('PMD.ApexCRUDViolation')
public without sharing class SendNotificationToApproverUtil {
  public static void notifyUsers(Set<String> recipientsIds, String targetId) {
    CustomNotificationType notificationType = [
      SELECT Id, DeveloperName
      FROM CustomNotificationType
      WHERE DeveloperName = 'Notify_User_Quip'
    ];
    List<ApprovalProcessPath__c> approvalPath = [
      SELECT
        Name,
        ApprovalProcess__r.Name,
        ApprovalProcess__r.OwnerId,
        ApprovalType__c,
        CreatedBy.Id,
        CreatedBy.Name
      FROM ApprovalProcessPath__c
      WHERE Id = :targetId
    ];

    List<User> submitter = [
      SELECT Id, Name, Email
      FROM User
      WHERE Id = :approvalPath[0].ApprovalProcess__r.OwnerId
    ];

    Messaging.CustomNotification notification = new Messaging.CustomNotification();

    String body =
      'Path Number: ' +
      approvalPath[0].Name +
      ' • ' +
      'Approval Process: ' +
      approvalPath[0].ApprovalProcess__r.Name +
      ' • ' +
      'Approval Type: ' +
      approvalPath[0].ApprovalType__c;

    if (approvalPath[0].ApprovalType__c == 'Reference') {
      notification.setTitle(
        submitter[0].Name +
        ' ' +
        'is requesting review for approval process path'
      );
    } else {
      notification.setTitle(
        submitter[0].Name +
        ' ' +
        'is requesting approval for approval process path'
      );
    }

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