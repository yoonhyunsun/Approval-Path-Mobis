/**
 * @description       :
 * @author            : Bekhzod Ubaydullaev
 * @group             :
 * @last modified on  : 01-30-2023
 * @last modified by  : Bekhzod Ubaydullaev
 **/
@SuppressWarnings('PMD.ApexCRUDViolation')
public without sharing class SendEmailToSubmitter {
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

  private static String changeHtmlBody(
    String htmlBody,
    String opportunityNameReportType,
    String approvedOrRejected,
    String recordLink
  ) {
    htmlBody = htmlBody.replace('{!CompanyLogo}', LOGO_URL);
    htmlBody = htmlBody.replace(
      '{!OpportunityNameReportType}',
      opportunityNameReportType
    );
    htmlBody = htmlBody.replace('{!ApprovedOrRejected}', approvedOrRejected);
    htmlBody = htmlBody.replace('{!RecordLink}', recordLink);
    return htmlBody;
  }

  private static String changePlainTextBody(
    String plainBody,
    String opportunityNameReportType,
    String approvedOrRejected,
    String recordLink
  ) {
    plainBody = plainBody.replace(
      '{!OpportunityNameReportType}',
      opportunityNameReportType
    );
    plainBody = plainBody.replace('{!ApprovedOrRejected}', approvedOrRejected);
    plainBody = plainBody.replace('{!RecordLink}', recordLink);
    return plainBody;
  }

  @future(callout=true)
  public static void sendEmail(String toEmail, String uId) {
    try {
      List<ApprovalProcessPath__c> approvalPath = [
        SELECT
          Id,
          ApprovalProcess__r.CreatedBy.Email,
          ApprovalProcess__r.CreatedBy.Name,
          ApprovalProcess__r.ReportType__c,
          ApprovalProcess__r.Opportunity__r.Name,
          ApprovalStatus__c
        FROM ApprovalProcessPath__c
        WHERE ApprovalProcessPathUID__c = :uId
      ];

      List<EmailTemplate> emailTemplate = [
        SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body
        FROM EmailTemplate
        WHERE Name = 'AfterApprovedSubmitterEmail'
      ];

      OrgWideEmailAddress[] owea = [
        SELECT Id, Address, DisplayName
        FROM OrgWideEmailAddress
        WHERE DisplayName = :SENDER_NAME OR Address = :COMPANY_EMAIL
        LIMIT 1
      ];

      String opportunityNameReportType =
        approvalPath[0].ApprovalProcess__r.Opportunity__r.Name +
        ': ' +
        approvalPath[0].ApprovalProcess__r.ReportType__c;

      Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();

      if (owea.size() > 0) {
        message.setOrgWideEmailAddressId(owea.get(0).Id);
      }

      message.setSubject(
        opportunityNameReportType +
        ' ' +
        approvalPath[0].ApprovalStatus__c
      );
      message.setTemplateId(emailTemplate[0].Id);
      message.toAddresses = new List<String>{ toEmail };

      String customSiteUrl =
        URL.getSalesforceBaseUrl().toExternalForm() +
        '/' +
        approvalPath[0].Id;

      String htmlBody = changeHtmlBody(
        emailTemplate[0].HtmlValue,
        opportunityNameReportType,
        approvalPath[0].ApprovalStatus__c.toLowercase(),
        customSiteUrl
      );
      message.setHtmlBody(htmlBody);

      String plainBody = changePlainTextBody(
        emailTemplate[0].Body,
        opportunityNameReportType,
        approvalPath[0].ApprovalStatus__c.toLowercase(),
        customSiteUrl
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