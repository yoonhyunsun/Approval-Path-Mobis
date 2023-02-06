@RestResource(urlMapping='/ApprovalProcessInfoTable/*')
global without sharing class ApprovalProcessPathInfoTableController {
    @HttpGet
    global static void getInfo() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        String uid = RestContext.request.params.get('uid');

        List<ApprovalProcessPath__c> app = [SELECT ApprovalProcess__c FROM ApprovalProcessPath__c WHERE  ApprovalProcessPathUID__c = :uid ];
        List<ApprovalProcessPath__c> apps = new List<ApprovalProcessPath__c>();
        ApprovalProcess__c ap = new ApprovalProcess__c();
        if (!app.isEmpty()) {
            ap = [SELECT Name FROM ApprovalProcess__c WHERE Id = :app[0].ApprovalProcess__c LIMIT 1];
            apps = [SELECT Name, Employee__r.Name, fm_Title__c, fm_Department__c, ApprovalType__c, ApprovalStatus__c, ApprovalDateTime__c, Comment__c FROM ApprovalProcessPath__c WHERE  ApprovalProcess__c = :app[0].ApprovalProcess__c ORDER BY Order__c];
        }

        Boolean showButtons = false; 

        JSONGenerator gen = JSON.createGenerator(true);

        if (!apps.isEmpty()) {
            showButtons = ApproverActionUtil.showApproveButtons(uid);
            gen.writeStartObject();
            gen.writeFieldName('approval_paths');
            gen.writeStartArray();
            for (ApprovalProcessPath__c approvalPath : apps) {
                gen.writeStartObject();
                gen.writeStringField('process_name', approvalPath.Name == null ? '' : ap.Name);
                gen.writeStringField('employee', approvalPath.Employee__r.Name == null ? '' : approvalPath.Employee__r.Name);
                gen.writeStringField('title', approvalPath.fm_Title__c == null ? '' : approvalPath.fm_Title__c);
                gen.writeStringField('department', approvalPath.fm_Department__c == null ? '' : approvalPath.fm_Department__c);
                gen.writeStringField('approval_type', approvalPath.ApprovalType__c == null ? '' : approvalPath.ApprovalType__c);
                gen.writeStringField('approval_status', approvalPath.ApprovalStatus__c == null ? '' : approvalPath.ApprovalStatus__c);
                gen.writeStringField('approval_datetime', approvalPath.ApprovalDateTime__c == null ? '' : String.valueOf(approvalPath.ApprovalDateTime__c));
                gen.writeStringField('comment', approvalPath.Comment__c == null ? '' : approvalPath.Comment__c);
                gen.writeEndObject();
            }
            gen.writeEndArray();
            gen.writeEndObject();

            response.statusCode = 200;
        } else {
            gen.writeStartObject();
            gen.writeStringField('error', 'Not Found');
            gen.writeEndObject();

            response.statusCode = 404;
        }

        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(gen.getAsString());

    }
}