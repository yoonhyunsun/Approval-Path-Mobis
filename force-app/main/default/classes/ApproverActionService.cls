/**
 * @description       : 
 * @author            : https://github.com/Eldor901
 * @group             : 
 * @last modified on  : 09-30-2022
 * @last modified by  : https://github.com/Eldor901
**/
@SuppressWarnings('PMD.ApexCRUDViolation')
public without sharing class ApproverActionService {
  public static String approverAction(
    String uid,
    String action, //Approved | Rejected
    String comment
  ) {
    String result = '';
    try {
      List<ApprovalProcessPath__c> approvalProcessPath = [
        SELECT
          ApprovalStatus__c,
          ApprovalProcess__c,
          ApprovalProcessPathUID__c,
          Comment__c,
          ApprovalDateTime__c
        FROM ApprovalProcessPath__c
        WHERE ApprovalProcessPathUID__c = :uid
      ];

      if (!approvalProcessPath.isEmpty()) {
        if (action == 'Approved' || action == 'Rejected') {
          if (approvalProcessPath[0].ApprovalStatus__c != 'Not Read' && approvalProcessPath[0].ApprovalStatus__c != 'Read') {
            result = 'Already Processed';
          } else {
            approvalProcessPath[0].ApprovalStatus__c = action;

            approvalProcessPath[0].Comment__c = comment.unescapeHtml4();

            approvalProcessPath[0].ApprovalDateTime__c = Datetime.now();

            update approvalProcessPath;



            if (action == 'Approved') {
              result = 'Successfully approved';
            } else if (action == 'Rejected') {
              result = 'Successfully rejected';
            }
          }
        } else {
          result = 'Wrong Parameters';
        }
      } else {
        result = 'Not Found';
      }
    } catch (Exception e) {
      System.debug(e.getMessage());
    }
    return result;
  }

  public static String markRead(String uid) {
    String result = '';
    try {
      List<ApprovalProcessPath__c> approvalProcessPath = [
        SELECT ApprovalStatus__c, OpenDateTime__c, ApprovalType__c, ApprovalDateTime__c
        FROM ApprovalProcessPath__c
        WHERE ApprovalProcessPathUID__c = :uid
      ];

      if (!approvalProcessPath.isEmpty()) {
        if (approvalProcessPath[0].ApprovalStatus__c != 'Not Read') {
          result = 'Already Processed';
        } else {
          if (approvalProcessPath[0].ApprovalType__c == 'Reference') {
            approvalProcessPath[0].ApprovalDateTime__c = Datetime.now();
          }
          approvalProcessPath[0].ApprovalStatus__c = 'Read';

          approvalProcessPath[0].OpenDateTime__c = Datetime.now();

          update approvalProcessPath;
          result = 'Success';
        }
      } else {
        result = 'Not Found';
      }
    } catch (Exception e) {
      System.debug(e.getMessage());
      result = e.getMessage();
    }

    return result;
  }
}