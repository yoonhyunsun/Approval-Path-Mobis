@SuppressWarnings('PMD.ApexCRUDViolation')
public without sharing class SendEmailCancelledUtil {

  private static final String LOGO_URL = ApprovalProcessSettings__c.getInstance('MobisApprovalProcessSettings').LogoURL__c;
  private static final String SENDER_NAME = ApprovalProcessSettings__c.getInstance('MobisApprovalProcessSettings').EmailSenderName__c;
  private static final String COMPANY_EMAIL = ApprovalProcessSettings__c.getInstance('MobisApprovalProcessSettings').CompanyEmail__c;

  private static String changeHtmlBody(
    String htmlBody,
    String opportunityName
  ) {
    htmlBody = htmlBody.replace('{!CompanyLogo}', LOGO_URL);
    htmlBody = htmlBody.replace('{!Opportunity.Name}', opportunityName);
    return htmlBody;
  }

  private static String changePlainTextBody(
    String plainBody,
    String opportunityName
  ) {
    plainBody = plainBody.replace('{!Opportunity.Name}', opportunityName);
    return plainBody;
  }

  public static void sendEmail(String createdByName, String oppName, String approvalProcessName, String toEmail) {
    try {

      List<EmailTemplate> emailTemplate = [
        SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body
        FROM EmailTemplate
        WHERE Name = 'ApproverRemovedEmail'
      ];

      OrgWideEmailAddress[] owea = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName = :SENDER_NAME OR Address = :COMPANY_EMAIL LIMIT 1];

      Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();

      if (owea.size() > 0) {
        message.setOrgWideEmailAddressId(owea.get(0).Id);
      }
      message.setSubject('Approval Request' + ' ' + approvalProcessName);
      message.setTemplateId(emailTemplate[0].Id);
      message.toAddresses = new List<String>{ toEmail };


      String htmlBody = changeHtmlBody(
        emailTemplate[0].HtmlValue,
        oppName
      );
      message.setHtmlBody(htmlBody);

      String plainBody = changePlainTextBody(
        emailTemplate[0].Body,
        oppName
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