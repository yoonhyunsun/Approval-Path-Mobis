/**
 * Created by hyodongmin on 2022/10/13.
 */

@IsTest
private class IF_SFDC_ONE_APPROVAL_ts {
    @IsTest
    static void testBehavior() {
        IF_SFDC_ONE_APPROVAL.DataOneApproval kData = new IF_SFDC_ONE_APPROVAL.DataOneApproval();
        System.assertEquals('CR', kData.APPTYP);
        System.assertEquals('CRM', kData.APPNAM);
    }
    @IsTest
    static void testConstructor() {
        IF_SFDC_ONE_APPROVAL.DataOneApproval kData = new IF_SFDC_ONE_APPROVAL.DataOneApproval();
        new IF_SFDC_ONE_APPROVAL(new IF_OutboundBasicRequester(new IF_OutboundBasicAuth()), kData, '1'); // for coverage
    }
    @IsTest
    static void testInputOneApproval() {
        IF_SFDC_ONE_APPROVAL.InputOneApproval kInput = new IF_SFDC_ONE_APPROVAL.InputOneApproval();
        kInput.setPayload(new IF_SFDC_ONE_APPROVAL.InputPayloadOneApproval());
    }
    @IsTest
    static void testOutputOneApproval() {
        IF_SFDC_ONE_APPROVAL.OutputOneApproval kOutput = new IF_SFDC_ONE_APPROVAL.OutputOneApproval();
        kOutput.setPayload(new IF_SFDC_ONE_APPROVAL.OutputPayloadOneApproval());
    }
    @IsTest
    static void testRequestBodyOneApproval() {
        IF_SFDC_ONE_APPROVAL.RequestBodyOneApproval kBody = new IF_SFDC_ONE_APPROVAL.RequestBodyOneApproval();
        System.assertEquals(null, ((IF_SFDC_ONE_APPROVAL.InputPayloadOneApproval) kBody.getRequest().getPayload()).t_data);
    }
    @IsTest
    static void testResponseBodyOneApproval() {
        IF_SFDC_ONE_APPROVAL.ResponseBodyOneApproval kBody = new IF_SFDC_ONE_APPROVAL.ResponseBodyOneApproval();
        System.assertEquals(null, ((IF_SFDC_ONE_APPROVAL.OutputPayloadOneApproval) kBody.getResponse().getPayload()).t_data);
    }
    @IsTest
    static void testGetSuccessCode() {
        IF_SFDC_ONE_APPROVAL.DataOneApproval kData = new IF_SFDC_ONE_APPROVAL.DataOneApproval();
        IF_SFDC_ONE_APPROVAL kApproval = new IF_SFDC_ONE_APPROVAL(new IF_OutboundBasicRequester(new IF_OutboundBasicAuth()), kData, '1');
        System.assertEquals('Z', kApproval.getSuccessCode());
    }
    @IsTest
    static void testProcessPre() {
        IF_SFDC_ONE_APPROVAL.DataOneApproval kData = new IF_SFDC_ONE_APPROVAL.DataOneApproval();
        IF_SFDC_ONE_APPROVAL kApproval = new IF_SFDC_ONE_APPROVAL(new IF_OutboundBasicRequester(new IF_OutboundBasicAuth()), kData, '1');
        kApproval.processPre(new IF_SFDC_ONE_APPROVAL.InputOneApproval());  // for coverage
    }
    @IsTest
    static void testSerialize() {
        IF_SFDC_ONE_APPROVAL.DataOneApproval kData = new IF_SFDC_ONE_APPROVAL.DataOneApproval();
        IF_SFDC_ONE_APPROVAL kApproval = new IF_SFDC_ONE_APPROVAL(new IF_OutboundBasicRequester(new IF_OutboundBasicAuth()), kData, '1');

        kData.DOCNBR = 'DOCNBR';
        kData.DOCNAM = 'DOCNAM';
        kData.PEMPNO = 'PEMPNO';
        kData.PNAME = 'PNAME';
        kData.DOCDTE = 'DOCDTE';
        kData.APPURL = 'APPURL';
        kData.APPARA = 'APPARA';
        IF_SFDC_ONE_APPROVAL.InputDataOneApproval kInput = new IF_SFDC_ONE_APPROVAL.InputDataOneApproval();
        kInput.input = kData;
        IF_SFDC_ONE_APPROVAL.RequestBodyOneApproval kBody = new IF_SFDC_ONE_APPROVAL.RequestBodyOneApproval();
        ((IF_SFDC_ONE_APPROVAL.InputPayloadOneApproval) kBody.getRequest().getPayload()).t_data = kInput;
        String kResult = kApproval.serialize(kBody);

        IF_SFDC_ONE_APPROVAL.RequestBodyOneApproval kResultObj = (IF_SFDC_ONE_APPROVAL.RequestBodyOneApproval) JSON.deserialize(kResult, IF_SFDC_ONE_APPROVAL.RequestBodyOneApproval.class);

        System.assertEquals('DOCNBR', ((IF_SFDC_ONE_APPROVAL.InputPayloadOneApproval) kResultObj.getRequest().getPayload()).t_data.input.DOCNBR);
        System.assertEquals('DOCNAM', ((IF_SFDC_ONE_APPROVAL.InputPayloadOneApproval) kResultObj.getRequest().getPayload()).t_data.input.DOCNAM);
        System.assertEquals('PEMPNO', ((IF_SFDC_ONE_APPROVAL.InputPayloadOneApproval) kResultObj.getRequest().getPayload()).t_data.input.PEMPNO);
        System.assertEquals('PNAME', ((IF_SFDC_ONE_APPROVAL.InputPayloadOneApproval) kResultObj.getRequest().getPayload()).t_data.input.PNAME);
        System.assertEquals('DOCDTE', ((IF_SFDC_ONE_APPROVAL.InputPayloadOneApproval) kResultObj.getRequest().getPayload()).t_data.input.DOCDTE);
        System.assertEquals('APPURL', ((IF_SFDC_ONE_APPROVAL.InputPayloadOneApproval) kResultObj.getRequest().getPayload()).t_data.input.APPURL);
        System.assertEquals('APPARA', ((IF_SFDC_ONE_APPROVAL.InputPayloadOneApproval) kResultObj.getRequest().getPayload()).t_data.input.APPARA);

    }
    @IsTest
    static void testPrepareRequest() {
        IF_SFDC_ONE_APPROVAL.DataOneApproval kData = new IF_SFDC_ONE_APPROVAL.DataOneApproval();
        IF_SFDC_ONE_APPROVAL kApproval = new IF_SFDC_ONE_APPROVAL(new IF_OutboundBasicRequester(new IF_OutboundBasicAuth()), kData, '1');

        HttpRequest kRequest = kApproval.prepareRequest('body---', 'url');
        System.assertEquals('POST', kRequest.getMethod());
        System.assertEquals('application/json; charset=utf-8', kRequest.getHeader('Content-Type'));
        System.assertEquals('url', kRequest.getEndpoint());
        System.assertEquals('body---', kRequest.getBody());
    }
    @IsTest
    static void testProcessPost() {
        IF_SFDC_ONE_APPROVAL.DataOneApproval kData = new IF_SFDC_ONE_APPROVAL.DataOneApproval();
        IF_SFDC_ONE_APPROVAL kApproval = new IF_SFDC_ONE_APPROVAL(new IF_OutboundBasicRequester(new IF_OutboundBasicAuth()), kData, '1');

        System.assertEquals(IF_Outbound.RESULT_CODE_END, kApproval.processPost(new IF_SFDC_ONE_APPROVAL.InputOneApproval(), new IF_SFDC_ONE_APPROVAL.OutputOneApproval()));
    }
    @IsTest
    static void testEtc() {
        IF_SFDC_ONE_APPROVAL.DataOneApproval kData = new IF_SFDC_ONE_APPROVAL.DataOneApproval();
        IF_SFDC_ONE_APPROVAL kApproval = new IF_SFDC_ONE_APPROVAL(new IF_OutboundBasicRequester(new IF_OutboundBasicAuth()), kData, '1');

        System.assertEquals(true, kApproval.getNewRequestBody() instanceof IF_SFDC_ONE_APPROVAL.RequestBodyOneApproval);
        System.assertEquals(IF_FACTORY.IF_SFDC_ONE_APPROVAL, kApproval.getIfId());
        System.assertEquals(null, kApproval.deserializeOne('{}'));

        String kJson = '{"response":{"header":{"ifId":"IF_SFDC_ONE_APPROVAL","ifTrackingId":"","iFDateTime":"","ifResult":"Z","ifMessage":"Success","ifFailCode":""},"payload":{"ifAggregation":"","ifRcvCnt":"","t_data":{}}}}';
        System.assertEquals(false, null == ((IF_SFDC_ONE_APPROVAL.OutputPayloadOneApproval) ((IF_SFDC_ONE_APPROVAL.ResponseBodyOneApproval) kApproval.deserialize(kJson)).getResponse().getPayload()).t_data);
    }

    @IsTest
    static void testCallout() {
        // if info
        insert new IF_INFO__c(IF_ID__c = 'IF_SFDC_ONE_APPROVAL', FORCE_LOGGING__c = true, URL__c = '...');


        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock());

        IF_SFDC_ONE_APPROVAL.DataOneApproval kData = new IF_SFDC_ONE_APPROVAL.DataOneApproval();
        kData.PEMPNO = 'A1102874';
        IF_Outbound.Result kResult = new IF_SFDC_ONE_APPROVAL(new IF_OutboundBasicRequester(), kData, '1').execute(IF_Comm.giveAGGR());

        System.assertEquals(IF_Outbound.RESULT_CODE_END, kResult.code);
        System.assertEquals('', kResult.message);

        Test.stopTest();

        IF_LOG__c kIfLog = [
                SELECT Id, ifAggregation__c, OMSGGUID__c, OIFID__c, OIFDATE__c, OMSGSTATUS__c, OERRORTEXT__c, OERRORCODE__c
                FROM IF_LOG__c
                LIMIT 1
        ];
        System.debug(kIfLog);
        System.assertEquals(false, null == kIfLog);
    }

    @IsTest
    static void testCalloutResponseError() {
        // if info
        insert new IF_INFO__c(IF_ID__c = 'IF_SFDC_ONE_APPROVAL', FORCE_LOGGING__c = true, URL__c = '...');


        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ExampleCalloutErrorMock());

        IF_SFDC_ONE_APPROVAL.DataOneApproval kData = new IF_SFDC_ONE_APPROVAL.DataOneApproval();
        kData.PEMPNO = 'A1102874';
        IF_Outbound.Result kResult = new IF_SFDC_ONE_APPROVAL(new IF_OutboundBasicRequester(), kData, '1').execute(IF_Comm.giveAGGR());

        System.assertEquals(IF_Outbound.RESULT_CODE_ERROR, kResult.code);
        System.assertEquals('Attempt to de-reference a null object', kResult.message);

        Test.stopTest();

        IF_LOG__c kIfLog = [
                SELECT Id, ifAggregation__c, OMSGGUID__c, OIFID__c, OIFDATE__c, OMSGSTATUS__c, OERRORTEXT__c, OERRORCODE__c
                FROM IF_LOG__c
                LIMIT 1
        ];
        System.debug(kIfLog);
        System.assertEquals(false, null == kIfLog);
    }

    private class ExampleCalloutMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody('{"response":{"header":{"ifId":"IF_SFDC_ONE_APPROVAL","ifTrackingId":"","iFDateTime":"","ifResult":"Z","ifMessage":"Success","ifFailCode":""},"payload":{"ifAggregation":"","ifRcvCnt":"","t_data":{}}}}');
            return res;
        }
    }

    private class ExampleCalloutErrorMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody('{}');
            return res;
        }
    }
}