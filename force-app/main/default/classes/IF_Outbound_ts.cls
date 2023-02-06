/**
 * Created by hyodongmin on 2022/07/28.
 */

@IsTest
public with sharing class IF_Outbound_ts {
    
    @IsTest
    static void testIfUrl() {
        IF_Outbound outbound = new TEST_IF_Outbound();
        outbound.setIfUrl('asdf-url');
        System.assertEquals('asdf-url', outbound.getIfUrl());
    }

    @IsTest
    static void testSkip() {
        IF_Outbound outbound = new TEST_IF_Outbound();
        outbound.setSkip(true);
        System.assertEquals(true, outbound.isSkip());
    }

    @IsTest
    static void testInfoId() {
        IF_Outbound outbound = new TEST_IF_Outbound();
        outbound.setInfoId('01p9D000002SD9m');
        System.assertEquals('01p9D000002SD9m', outbound.getInfoId());
    }
    @IsTest
    private static void testExecute() {
        IF_Outbound outbound = new TEST_IF_OutboundExec();
        System.assertEquals(999, outbound.execute('agggr').code);
    }
    @IsTest
    private static void testExecuteSkip() {
        IF_Outbound outbound = new TEST_IF_OutboundExec();
        outbound.setSkip(true);
        System.assertEquals(IF_Outbound.RESULT_CODE_END, outbound.execute('agggr').code);
    }

    @IsTest
    private static void testPerformExecute() {
        IF_Outbound outbound = new TEST_IF_OutboundCallout();
        outbound.setIfUrl('');

        IF_Outbound.Result result = outbound.performExecute(new IF_Abstract.RequestBody(), 'aggregation--');
        System.assertEquals(IF_Outbound.RESULT_CODE_END, result.code);
    }

    @IsTest
    private static void testPerformExecuteLog() {
        insert new IF_INFO__c(IF_ID__c = 'test_outbound_id', URL__c = 'url..', TITLE__c='title', FORCE_LOGGING__c = true);

        List<IF_LOG__c> kList = [SELECT Id FROM IF_LOG__c];
        System.assertEquals(0, kList.size());

        IF_Outbound outbound = new TEST_IF_OutboundCallout();

        IF_Abstract.RequestBody kInput = new IF_Abstract.RequestBody();
        kInput.getRequest().getPayload().ifTotCnt = '1';
        kInput.getRequest().getPayload().ifSplitSeq = '2';
        kInput.getRequest().getPayload().ifSplitCnt = '3';

        Test.startTest();
        IF_Outbound.Result result = outbound.performExecute(kInput, 'aggregation--');
        Test.stopTest();
        System.assertEquals(IF_Outbound.RESULT_CODE_END, result.code);

        kList = [SELECT Id, LOG_TYPE__c, MSGGUID__c, IFID__c, IFDATE__c,
                ifAggregation__c, ifTotCnt__c, ifSplitSeq__c, ifSplitCnt__c, ifRcvCnt__c FROM IF_LOG__c];
        System.assertEquals(1, kList.size());
        System.assertEquals('SND', kList[0].LOG_TYPE__c);
        System.assertEquals(false, String.isBlank(kList[0].MSGGUID__c));
        System.assertEquals('test_outbound_id', kList[0].IFID__c);
        System.assertEquals(false, String.isBlank(kList[0].IFDATE__c));
        System.assertEquals('aggregation--', kList[0].ifAggregation__c);
        System.assertEquals('1', kList[0].ifTotCnt__c);
        System.assertEquals('2', kList[0].ifSplitSeq__c);
        System.assertEquals('3', kList[0].ifSplitCnt__c);
        System.assertEquals(null, kList[0].ifRcvCnt__c);
    }

    @IsTest
    private static void testPerformExecuteError() {
        IF_Outbound outbound = new TEST_IF_Outbound();

        IF_Outbound.Result result = outbound.performExecute(new IF_Abstract.RequestBody(), 'aggregation--');
        System.assertEquals(IF_Outbound.RESULT_CODE_ERROR, result.code);  // getDomain() 에서 null pointer 
    }

    @IsTest
    private static void testPerformExecuteFail() {
        IF_Outbound outbound = new TEST_IF_OutboundFail();
        outbound.setIfUrl('');

        IF_Outbound.Result result = outbound.performExecute(new IF_Abstract.RequestBody(), 'aggregation--');
        System.assertEquals(IF_Outbound.RESULT_CODE_FAIL, result.code);  
    }
    @IsTest
    private static void testDoPostProcessIfCalloutSuccess() {
        IF_Outbound ifBase = new TEST_IF_Outbound();

        IF_Abstract.Input kInput = new IF_Abstract.Input();
        IF_Abstract.Output kOutput = new IF_Abstract.Output();

        System.assertEquals(IF_Outbound.RESULT_CODE_FAIL, ifBase.doPostProcessIfCalloutSuccess('', kInput, kOutput));
        System.assertEquals(IF_Outbound.RESULT_CODE_FAIL, ifBase.doPostProcessIfCalloutSuccess(null, kInput, kOutput));
        System.assertEquals(-1, ifBase.doPostProcessIfCalloutSuccess(IF_Base.RESULT_SUCCESS, kInput, kOutput));
    }
    @IsTest
    private static void testAppendErrorMessage() {
        System.assertEquals('err\nerr', IF_Outbound.appendErrorMessage('err', 'err'));
        System.assertEquals('err', IF_Outbound.appendErrorMessage('', 'err'));
        System.assertEquals('err', IF_Outbound.appendErrorMessage(null, 'err'));
    }
    @IsTest
    static void testLimitData() {
        System.assertEquals(100, new TEST_IF_Outbound().limitData(100));
    }
    @IsTest
    static void testProcessBefore() {
        IF_Outbound ifBase = new TEST_IF_Outbound();
        IF_Abstract.Input kInput = new IF_Abstract.Input();

        ifBase.processBefore(kInput, 'aggr');
        System.assertEquals('aggr', kInput.getPayload().ifAggregation);
    }
    @IsTest
    static void testBehavior() {
        System.debug(IF_Outbound.RESULT_CODE_END);
        System.debug(IF_Outbound.RESULT_CODE_ERROR);
        System.debug(IF_Outbound.RESULT_CODE_FAIL);

        System.debug(new IF_Outbound.Result().code);
        System.debug(new IF_Outbound.Result().message);
    }

    @IsTest
    static void testGetSuccessCode() {
        IF_Outbound ifBase = new TEST_IF_Outbound();
        System.assertEquals(IF_Base.RESULT_SUCCESS, ifBase.getSuccessCode());
    }
    
    private class T_DATA22 extends IF_Abstract.T_DATA {
    }

    private virtual class TEST_IF_Outbound extends IF_Outbound {
        public TEST_IF_Outbound(){
            super(new TEST_IF_OutboundRequester());
        }
        public TEST_IF_Outbound(IF_OutboundIRequester aRequester){
            super(aRequester);
        }
        protected override void processPre(IF_Abstract.InputAbstract aInput) {
        }

        protected override HttpRequest prepareRequest(String aReqBody, String aEndPoint) {
            return new HttpRequest();
        }

        protected override Integer processPost(IF_Abstract.InputAbstract aInput, IF_Abstract.OutputAbstract aOutput) {
            return -1;
        }

        public override String getIfId() {
            return 'test_outbound_id';
        }

        public override IF_Abstract.T_DATA deserializeOne(String aJson) {
            return new T_DATA22();
        }
    }

    private virtual class TEST_IF_OutboundExec extends TEST_IF_Outbound {
        public TEST_IF_OutboundExec(){
            super();
        }
        protected override IF_Outbound.Result performExecute(IF_Abstract.RequestBodyAbstract aInputObj, String aAggregation) {
            IF_Outbound.Result result = new IF_Outbound.Result();
            result.code = 999;
            return result;
        }
    }

    private virtual class TEST_IF_OutboundCallout extends TEST_IF_Outbound {
        public TEST_IF_OutboundCallout(){
            super(new TEST_IF_OutboundRequesterCallout());
        }
    }

    private class TEST_IF_OutboundRequesterCallout implements IF_OutboundIRequester {
        public IF_OutboundRequesterResult request(HttpRequest aHttpReq, IF_OutboundIDeserializer aDeserializer) {
            String str ='{\n' +
                    '    "response": {\n' +
                    '        "header": {\n' +
                    '            "ifTrackingId": "tracking-id",\n' +
                    '            "ifResult": "S",\n' +
                    '            "ifId": "if-id",\n' +
                    '            "ifDateTime": "20201106181838"\n' +
                    '        },\n' +
                    '        "payload": {\n' +
                    '            "ifAggregation": "0002e2d0-cec3-6e84-5761-ae68b3bf20a3",\n' +
                    '            "ifTotCnt": "1",\n' +
                    '            "ifSplitCnt": "100"\n' +
                    '        }\n' +
                    '    }\n' +
                    '}';
            return new IF_OutboundRequesterResult(str, aDeserializer.deserialize(str));
        }
    }
    private virtual class TEST_IF_OutboundFail extends TEST_IF_Outbound {
        public TEST_IF_OutboundFail(){
            super(new TEST_IF_OutboundRequesterFail());
        }
    }
    private class TEST_IF_OutboundRequesterFail implements IF_OutboundIRequester {
        public IF_OutboundRequesterResult request(HttpRequest aHttpReq, IF_OutboundIDeserializer aDeserializer) {
            String str = '{\n' +
                    '    "response": {\n' +
                    '        "header": {\n' +
                    '            "ifTrackingId": "tracking-id",\n' +
                    '            "ifSenderGp": "--",\n' +
                    '            "ifSender": "---",\n' +
                    '            "ifResult": "E",\n' +
                    '            "ifReceiverGp": "SFDC",\n' +
                    '            "ifReceiver": "SFDC",\n' +
                    '            "ifId": "if-id",\n' +
                    '            "ifFailMsg": "",\n' +
                    '            "ifFailCode": "",\n' +
                    '            "ifDateTime": "20201106181838"\n' +
                    '        }\n' +
                    '    }\n' +
                    '}';
            return new IF_OutboundRequesterResult(str, aDeserializer.deserialize(str));
        }
    }
    
    private class TEST_IF_OutboundAuth implements IF_OutboundIAuth {

        public String getAuthKeyName() {
            return 'auth-key';
        }

        public String getAuthValue() {
            return IF_Static.getClientSecret();
        }
    }
    
    private class TEST_IF_OutboundRequester implements IF_OutboundIRequester {
        public IF_OutboundRequesterResult request(HttpRequest aHttpReq, IF_OutboundIDeserializer aDeserializer) {
            return null;
        }
    }
}