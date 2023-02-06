/**
 * @description       : 
 * @author            : Bekhzod Ubaydullaev
 * @group             : 
 * @last modified on  : 09-15-2022
 * @last modified by  : Bekhzod Ubaydullaev
**/
public  class EmailMessage {
    private static EmailTemplate emailTemplate;

    static{
        try{
            emailTemplate = [SELECT Id,Subject,Description, HtmlValue, DeveloperName, Body FROM EmailTemplate WHERE Name = 'RequestApprovalEmail'];
        }catch(Exception e){
            System.debug(e);
        }
    }

    private static String changeHtmlBody(String htmlBody, String customSiteUrl, String opptyId, String contactName, String uId){
        String companyLogoLink = 'https://logo-download.com/wp-content/data/images/png/Hyundai-Mobis-logo.png';
        htmlBody = htmlBody.replace('{!CustomSiteLink}', customSiteUrl+ '?Id=' + opptyId + '&uid='+uId);
        htmlBody = htmlBody.replace('{!ContactName}', contactName);
        htmlBody = htmlBody.replace('{!CompanyLogo}', companyLogoLink);
        return htmlBody;
    }

    private static String changePlainTextBody(String plainBody, String customSiteUrl, String contactName){
        plainBody = plainBody.replace('{!CustomSiteLink}', customSiteUrl);
        plainBody = plainBody.replace('{!ContactName}', contactName);
        return plainBody;
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    @future(callout=true)
    public static void sendEmail(Id contactId, String siteUrl, Id opptyId, String uId){
        try {
            Contact contact = [SELECT Id, Name, Email FROM Contact WHERE Id = :contactId];
            String currUserEmail = UserInfo.getUserEmail();
        
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Hyundai Mobis');
            message.setReplyTo(currUserEmail);
            message.setUseSignature(false);
            message.setBccSender(false);
            message.setSaveAsActivity(false);
            message.setTemplateID(emailTemplate.Id);
            message.toAddresses = new List<String>{ contact.Email };
    
            String customSiteUrl = siteUrl + '?Id=' + opptyId;
            String htmlBody = changeHtmlBody(emailTemplate.HtmlValue, siteUrl, opptyId, contact.Name, uId);
            message.setHtmlBody(htmlBody);
    
            String plainBody = changePlainTextBody(emailTemplate.Body, customSiteUrl, contact.Name);
            message.setPlainTextBody(plainBody);
    
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>{ message };
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
    
            if (!results[0].success) {
                System.debug('The email failed to send: ' + results[0].errors[0].message);
                return;   
            }
            System.debug('The email was sent successfully');
            
        } catch (Exception e) {
            System.debug(e);
        }

    }
}