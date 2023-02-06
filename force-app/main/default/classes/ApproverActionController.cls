@RestResource(urlMapping='/ApprovalAction/*')
global without sharing class ApproverActionController {
    @HttpPost
    global static void approveOrReject() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        String requestBody = request.requestBody.toString();

        ApproverActionParser approverAction = ApproverActionParser.parse(requestBody);

        String result = ApproverActionService.approverAction(approverAction.uid, approverAction.action, approverAction.comment);

        JSONGenerator gen = JSON.createGenerator(true);

        gen.writeStartObject();
        gen.writeStringField('result', result == null ? '' : result);
        gen.writeEndObject();

        if (result == 'Successfully approved' || result == 'Successfully rejected') {
            response.statusCode = 200;
        } else if (result == 'Wrong Parameters'){
            response.statusCode = 400;
        } else if (result == 'Not Found'){
            response.statusCode = 404; 
        } else if (result == 'Already Processed'){
            response.statusCode = 409;
        }

        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(gen.getAsString());
    }
}