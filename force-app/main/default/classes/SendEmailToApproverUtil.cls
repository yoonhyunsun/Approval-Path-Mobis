/**
 * @description       :
 * @author            : Bekhzod Ubaydullaev
 * @group             :
 * @last modified on  : 01-30-2023
 * @last modified by  : Bekhzod Ubaydullaev
 **/
@SuppressWarnings('PMD.ApexCRUDViolation')
public without sharing class SendEmailToApproverUtil {
  private static final String LOGO_URL = ApprovalProcessSettings__c.getInstance(
      'MobisApprovalProcessSettings'
    )
    .LogoURL__c;
  private static final String SENDER_NAME = ApprovalProcessSettings__c.getInstance(
      'MobisApprovalProcessSettings'
    )
    .EmailSenderName__c;
  private static final String COMPANY_EMAIL = ApprovalProcessSettings__c.getInstance(
      'MobisApprovalProcessSettings'
    )
    .CompanyEmail__c;
  private static final String PUBLIC_SITE_URL = ApprovalProcessSettings__c.getInstance(
      'MobisApprovalProcessSettings'
    )
    .PublicSiteURL__c;

  private static String changeHtmlBody(
    String htmlBody,
    String customSiteUrl,
    String approvalRequesterName,
    String processName
  ) {
    htmlBody = htmlBody.replace('{!CustomSiteLink}', customSiteUrl);
    htmlBody = htmlBody.replace('{!CompanyLogo}', LOGO_URL);
    htmlBody = htmlBody.replace(
      '{!ApprovalRequesterName}',
      approvalRequesterName
    );
    htmlBody = htmlBody.replace('{!ProcessName}', processName);
    return htmlBody;
  }

  private static String changePlainTextBody(
    String plainBody,
    String customSiteUrl,
    String approvalRequesterName,
    String processName
  ) {
    plainBody = plainBody.replace('{!CustomSiteLink}', customSiteUrl);
    plainBody = plainBody.replace(
      '{!ApprovalRequesterName}',
      approvalRequesterName
    );
    plainBody = plainBody.replace('{!ProcessName}', processName);
    return plainBody;
  }

  @future(callout=true)
  public static void sendEmail(String uId) {
    try {
      OrgWideEmailAddress[] owea = [
        SELECT Id, Address, DisplayName
        FROM OrgWideEmailAddress
        WHERE DisplayName = :SENDER_NAME OR Address = :COMPANY_EMAIL
        LIMIT 1
      ];

      List<ApprovalProcessPath__c> approvalPath = [
        SELECT
          Id,
          CreatedBy.Name,
          ApprovalType__c,
          ApprovalUser__c,
          ApprovalProcess__r.Name,
          Employee__r.Email,
          ApprovalUser__r.IsActive,
          ApprovalProcess__r.OwnerId
        FROM ApprovalProcessPath__c
        WHERE ApprovalProcessPathUID__c = :uId
      ];

      List<User> submitter = [
        SELECT Id, Name
        FROM User
        WHERE Id = :approvalPath[0].ApprovalProcess__r.OwnerId
      ];

      List<EmailTemplate> emailTemplate = [
        SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body
        FROM EmailTemplate
        WHERE Name = 'RequestApprovalEmail'
      ];

      if (approvalPath[0].ApprovalType__c == 'Reference') {
        emailTemplate = [
          SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body
          FROM EmailTemplate
          WHERE Name = 'RequestViewReferenceEmail'
        ];
      }

      Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();

      if (owea.size() > 0) {
        message.setOrgWideEmailAddressId(owea.get(0).Id);
      }
      message.setSubject(
        'Approval Request' +
        ' ' +
        approvalPath[0].ApprovalProcess__r.Name
      );
      message.setTemplateId(emailTemplate[0].Id);
      message.toAddresses = new List<String>{
        approvalPath[0].Employee__r.Email
      };

      String siteUrl = '';
      String customSiteUrl = '';

      if (
        approvalPath[0].ApprovalUser__c == null ||
        !approvalPath[0].ApprovalUser__r.IsActive
      ) {
        siteUrl = PUBLIC_SITE_URL + 'approve';
        customSiteUrl = siteUrl + '?uid=' + uId;
      } else {
        customSiteUrl =
          URL.getSalesforceBaseUrl().toExternalForm() +
          '/' +
          approvalPath[0].Id;
      }

      if (customSiteUrl.indexOf('?USERID') != -1) {
        customSiteUrl = customSiteUrl.substring(
          0,
          customSiteUrl.indexOf('?USERID')
        );
      }

      String htmlBody = changeHtmlBody(
        emailTemplate[0].HtmlValue,
        customSiteUrl,
        submitter[0].Name,
        approvalPath[0].ApprovalProcess__r.Name
      );
      message.setHtmlBody(htmlBody);

      String plainBody = changePlainTextBody(
        emailTemplate[0].Body,
        customSiteUrl,
        submitter[0].Name,
        approvalPath[0].ApprovalProcess__r.Name
      );
      message.setPlainTextBody(plainBody);

      Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>{
        message
      };
      Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

      if (!results[0].success) {
        System.debug(
          'The email failed to send: ' + results[0].errors[0].message
        );
        return;
      }
      System.debug('The email was sent successfully');
    } catch (Exception e) {
      System.debug(e);
    }
  }
}