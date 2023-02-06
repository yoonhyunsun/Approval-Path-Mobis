/**
 * @description       :
 * @author            : Bekhzod Ubaydullaev
 * @group             :
 * @last modified on  : 12-09-2022
 * @last modified by  : Bekhzod Ubaydullaev
 **/
@RestResource(urlMapping='/MarkReadApprovalPath/*')
global without sharing class MarkReadApprovalPathController {
  @HttpGet
  global static void markRead() {
    RestRequest request = RestContext.request;
    RestResponse response = RestContext.response;
    String uid = RestContext.request.params.get('uid');

    String result = ApproverActionService.markRead(uid);

    JSONGenerator gen = JSON.createGenerator(true);

    gen.writeStartObject();
    gen.writeStringField('result', result);
    gen.writeEndObject();

    if (result == 'Success') {
      response.statusCode = 200;
    } else if (result == 'Already Processed') {
      response.statusCode = 400;
    } else if (result == 'Not Found') {
      response.statusCode = 404;
    }

    RestContext.response.addHeader('Content-Type', 'application/json');
    RestContext.response.responseBody = Blob.valueOf(gen.getAsString());
  }
}