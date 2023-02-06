/**
 * Created by hyodongmin on 2022/07/27.
 */

@IsTest
private class IF_Inbound_ts {

    @IsTest
    private static void testGetIfId() {
        IF_Inbound ifBase = new TEST_IF_Inbound();
        System.assertEquals('test_id', ifBase.getIfId());
    }
    @IsTest
    private static void testDeserialize() {
        IF_Inbound ifBase = new TEST_IF_Inbound();
        IF_Abstract.RequestBody testRequestBody = (IF_Abstract.RequestBody) ifBase.deserialize('{\n' +
                '    "request": {\n' +
                '        "header": {\n' +
                '            "ifTrackingId": "IF_GSIS_SFDC_0000_1",\n' +
                '            "ifSenderGp": "GISIS",\n' +
                '            "ifSender": "GISIS",\n' +
                '            "ifResult": "",\n' +
                '            "ifReceiverGp": "SFDC",\n' +
                '            "ifReceiver": "SFDC",\n' +
                '            "ifId": "IF_GSIS_SFDC_0000_1",\n' +
                '            "ifFailMsg": "",\n' +
                '            "ifFailCode": "",\n' +
                '            "ifDateTime": "20201106181838"\n' +
                '        },\n' +
                '        "payload": {\n' +
                '            "ifAggregation": "0002e2d0-cec3-6e84-5761-ae68b3bf20a3",\n' +
                '            "ifTotCnt": "1",\n' +
                '            "ifSplitCnt": "100",\n' +
                '            "ifSplitSeq": "67",\n' +
                '            "t_data": [\n' +
                '                {\n' +
                '                    "test1": "TestCD",\n' +
                '                    "test2": "PROD_CD",\n' +
                '                    "test3": "MDL_CD"\n' +
                '                }\n' +
                '            ]\n' +
                '        }\n' +
                '    }\n' +
                '}');
        System.assertEquals('0002e2d0-cec3-6e84-5761-ae68b3bf20a3',testRequestBody.getRequest().getPayload().ifAggregation);
        System.assertEquals('1', testRequestBody.getRequest().getPayload().ifTotCnt);
        System.assertEquals('100', testRequestBody.getRequest().getPayload().ifSplitCnt);
        System.assertEquals('67', testRequestBody.getRequest().getPayload().ifSplitSeq);
    }
    @IsTest
    static void testLimitData() {
        System.assertEquals(new TEST_IF_Inbound_0().countPerPage, new TEST_IF_Inbound_0().limitData(0));
    }
    @IsTest
    private static void testProcessBefore() {
        IF_Inbound ifBase = new TEST_IF_Inbound();

        IF_Abstract.Input kInput = new IF_Abstract.Input();
        IF_Abstract.InputPayload inputPayload = new IF_Abstract.InputPayload();
        inputPayload.ifAggregation = 'agg';
        kInput.setPayload(inputPayload);

        IF_Abstract.Output kOutput = new IF_Abstract.Output();

        ifBase.processBefore(kInput, kOutput);
        System.assertEquals('agg', kOutput.getPayload().ifAggregation);
        System.assertEquals('0', kOutput.getPayload().ifRcvCnt);

        inputPayload.t_data = null;
        ifBase.processBefore(kInput, kOutput);
        System.assertEquals('0', kOutput.getPayload().ifRcvCnt);

        inputPayload.t_data = new List<IF_Abstract.T_DATA>{
                new IF_Abstract.T_DATA(), new IF_Abstract.T_DATA()
        };
        ifBase.processBefore(kInput, kOutput);
        System.assertEquals('2', kOutput.getPayload().ifRcvCnt);
    }
    @IsTest
    private static void testProcess() {
        IF_Inbound ifBase = new TEST_IF_Inbound();

        IF_Abstract.Input kInput = new IF_Abstract.Input();
        IF_Abstract.InputPayload inputPayload = new IF_Abstract.InputPayload();
        inputPayload.ifAggregation = 'agg';
        inputPayload.ifTotCnt = 'tot';
        inputPayload.ifSplitCnt = 'cnt';
        inputPayload.ifSplitSeq = 'seq';
        kInput.setPayload(inputPayload);

        IF_Abstract.Output kOutput = new IF_Abstract.Output();
        IF_Abstract.OutputPayload kOutputPayload = new IF_Abstract.OutputPayload();
        kOutputPayload.ifAggregation = 'agg2';
        kOutput.setPayload(kOutputPayload);

        ifBase.process(kInput, kOutput);
        System.assertEquals('agg', kOutput.getPayload().ifAggregation);
        System.assertEquals('rev_cnt', kOutput.getPayload().ifRcvCnt);
    }
    @IsTest
    private static void testReturnLogParams() {
        IF_Inbound ifBase = new TEST_IF_Inbound();

        IF_Abstract.Input kInput = new IF_Abstract.Input();
        IF_Abstract.InputPayload inputPayload = new IF_Abstract.InputPayload();
        inputPayload.ifAggregation = 'agg';
        inputPayload.ifTotCnt = 'tot';
        inputPayload.ifSplitCnt = 'cnt';
        inputPayload.ifSplitSeq = 'seq';
        kInput.setPayload(inputPayload);

        IF_Abstract.Output kOutput = new IF_Abstract.Output();
        IF_Abstract.OutputPayload kOutputPayload = new IF_Abstract.OutputPayload();
        kOutputPayload.ifAggregation = 'agg2';
        kOutput.setPayload(kOutputPayload);

        ifBase.returnLogParams(kInput, kOutput);
        System.assertEquals('agg2', kOutput.getPayload().ifAggregation);
        System.assertEquals('cnt', kOutput.getPayload().ifRcvCnt);
    }
    @IsTest
    private static void testPerformPost() {
        IF_Inbound ifBase = new TEST_IF_Inbound();

        String requestBody = '{\n' +
                '    "request": {\n' +
                '        "header": {\n' +
                '            "ifTrackingId": "tracking_id",\n' +
                '            "ifSenderGp": "GISIS",\n' +
                '            "ifSender": "GISIS",\n' +
                '            "ifResult": "",\n' +
                '            "ifReceiverGp": "SFDC",\n' +
                '            "ifReceiver": "SFDC",\n' +
                '            "ifId": "test_id",\n' +
                '            "ifFailMsg": "",\n' +
                '            "ifFailCode": "",\n' +
                '            "ifDateTime": "20201106181838"\n' +
                '        },\n' +
                '        "payload": {\n' +
                '            "ifAggregation": "0002e2d0-cec3-6e84-5761-ae68b3bf20a3",\n' +
                '            "ifTotCnt": "1",\n' +
                '            "ifSplitCnt": "100",\n' +
                '            "ifSplitSeq": "67"\n' +
                '        }\n' +
                '    }\n' +
                '}';

        IF_Abstract.ResponseBodyAbstract kResponseBody = ifBase.onPost(requestBody);

        // response data 검증
        System.assertEquals('0002e2d0-cec3-6e84-5761-ae68b3bf20a3', kResponseBody.getResponse().getPayload().ifAggregation);
        System.assertEquals('100', kResponseBody.getResponse().getPayload().ifRcvCnt);
        System.assertEquals('Success', ((IF_Abstract.InputHeader2)kResponseBody.getResponse().header).ifMessage);
    }
    @IsTest
    private static void testOnPostBlankBody() {
        IF_Inbound ifBase = new TEST_IF_Inbound();

        String requestBody = '';

        IF_Abstract.ResponseBodyAbstract kResponseBody = ifBase.onPost(requestBody);

        // response data 검증
        System.assertEquals(null, kResponseBody.getResponse().getPayload().ifAggregation);
        System.assertEquals('E', kResponseBody.getResponse().header.ifResult);
        System.assertEquals(true, ((IF_Abstract.InputHeader2)kResponseBody.getResponse().header).ifMessage.contains('Request body is Empty.'));
        System.assertEquals(null, kResponseBody.getResponse().header.ifFailMsg);
    }
    @IsTest
    private static void testOnPostDefaultTime() {
        insert new IF_INFO__c(IF_ID__c = 'test_id', FORCE_LOGGING__c = true);

        Datetime kNow = Datetime.now();
        IF_Inbound ifBase = new TEST_IF_Inbound_0();

        String requestBody = '{\n' +
                '    "request": {\n' +
                '        "header": {\n' +
                '            "ifTrackingId": "tracking_id_default_time",\n' +
                '            "ifId": "test_id"\n' +
                '        },\n' +
                '        "payload": {\n' +
                '            "ifAggregation": "0002e2d0-cec3-6e84-5761-ae68b3bf20a3"\n' +
                '        }\n' +
                '    }\n' +
                '}';

        Test.startTest();
        IF_Abstract.ResponseBodyAbstract kResponseBody = ifBase.onPost(requestBody);
        Test.stopTest();

        // response data 검증
        System.assertEquals('0002e2d0-cec3-6e84-5761-ae68b3bf20a3', kResponseBody.getResponse().getPayload().ifAggregation);
        System.assertEquals('rev_cnt', kResponseBody.getResponse().getPayload().ifRcvCnt);

        // ifDateTime 입력 확인
        IF_LOG__c kLog = [SELECT Id, OIFDATE__c FROM IF_LOG__c WHERE OMSGGUID__c = 'tracking_id_default_time'];
        System.assertEquals(true, Datetime.valueOfGmt(kLog.OIFDATE__c) >= kNow.addSeconds(-1)); // ms 는 비교가 안되어 1초 뻬고 비교
    }
    @IsTest
    private static void testPerformPostIncorrectId() {
        IF_Inbound ifBase = new TEST_IF_Inbound();

        String requestBody = '{\n' +
                '    "request": {\n' +
                '        "header": {\n' +
                '            "ifTrackingId": "tracking_id",\n' +
                '            "ifSenderGp": "GISIS",\n' +
                '            "ifSender": "GISIS",\n' +
                '            "ifResult": "",\n' +
                '            "ifReceiverGp": "SFDC",\n' +
                '            "ifReceiver": "SFDC",\n' +
                '            "ifId": "====incorrect_id====",\n' +
                '            "ifFailMsg": "",\n' +
                '            "ifFailCode": "",\n' +
                '            "ifDateTime": "20201106181838"\n' +
                '        },\n' +
                '        "payload": {\n' +
                '            "ifAggregation": "0002e2d0-cec3-6e84-5761-ae68b3bf20a3",\n' +
                '            "ifTotCnt": "1",\n' +
                '            "ifSplitCnt": "100",\n' +
                '            "ifSplitSeq": "67"\n' +
                '        }\n' +
                '    }\n' +
                '}';

        IF_Abstract.ResponseBodyAbstract kResponseBody = ifBase.onPost(requestBody);

        // response data 검증
        System.assertEquals(null, kResponseBody.getResponse().getPayload().ifAggregation);
        System.assertEquals('tracking_id', kResponseBody.getResponse().header.ifTrackingId);
        System.assertEquals('E', kResponseBody.getResponse().header.ifResult);
        System.assertEquals('IF_Base.IFException', kResponseBody.getResponse().header.ifFailCode);
        System.assert(((IF_Abstract.InputHeader2)kResponseBody.getResponse().header).ifMessage.contains('IFID is empty or incorrect'));
    }

    @IsTest
    private static void testOnPostDataLimit() {
        IF_Inbound ifBase = new TEST_IF_Inbound_Limit();

        String requestBody = '{\n' +
                '    "request": {\n' +
                '        "header": {\n' +
                '            "ifTrackingId": "tracking_id",\n' +
                '            "ifId": "test_id",\n' +
                '            "ifDateTime": "20201106181838"\n' +
                '        },\n' +
                '        "payload": {\n' +
                '            "ifAggregation": "0002e2d0-cec3-6e84-5761-ae68b3bf20a3",\n' +
                '            "ifTotCnt": "1",\n' +
                '            "ifSplitCnt": "100",\n' +
                '            "ifSplitSeq": "67",\n' +
                '            "t_data":[{}, {}, {}, {}, {}] ' +
                '        }\n' +
                '    }\n' +
                '}';

        IF_Abstract.ResponseBodyAbstract kResponseBody = ifBase.onPost(requestBody);

        // 로그용 인풋 바디 설정됨
        System.assertEquals(true, String.isNotBlank(ifBase.inputBody));

        // response data 검증
        System.assertEquals(null, kResponseBody.getResponse().getPayload().ifAggregation);
        System.assertEquals(null, kResponseBody.getResponse().header.ifTrackingId);
        System.assertEquals('E', kResponseBody.getResponse().header.ifResult);
        System.assertEquals(true, ((IF_Abstract.InputHeader2)kResponseBody.getResponse().header).ifMessage.contains('t_data size over. (max: 3)'));
        System.assertEquals(null, kResponseBody.getResponse().header.ifFailMsg);
    }

    @IsTest
    private static void testOnPostDataLimit2() {
        // deserialize() 를 오버라이드 하여 t_data 예외처리가 누락됐을 경우 IF_Inbound 에서 처리됨
        IF_Inbound ifBase = new TEST_IF_Inbound_Limit2();

        String requestBody = '{\n' +
                '    "request": {\n' +
                '        "header": {\n' +
                '            "ifTrackingId": "tracking_id",\n' +
                '            "ifId": "test_id",\n' +
                '            "ifDateTime": "20201106181838"\n' +
                '        },\n' +
                '        "payload": {\n' +
                '            "ifAggregation": "0002e2d0-cec3-6e84-5761-ae68b3bf20a3",\n' +
                '            "ifTotCnt": "1",\n' +
                '            "ifSplitCnt": "100",\n' +
                '            "ifSplitSeq": "67",\n' +
                '            "t_data":[{}, {}, {}, {}, {}] ' +
                '        }\n' +
                '    }\n' +
                '}';

        IF_Abstract.ResponseBodyAbstract kResponseBody = ifBase.onPost(requestBody);

        // 로그용 인풋 바디 설정됨
        System.assertEquals(true, String.isNotBlank(ifBase.inputBody));

        // response data 검증
        System.assertEquals(null, kResponseBody.getResponse().getPayload().ifAggregation);
        System.assertEquals('tracking_id', kResponseBody.getResponse().header.ifTrackingId);
        System.assertEquals('E', kResponseBody.getResponse().header.ifResult);
        System.assertEquals(true, ((IF_Abstract.InputHeader2)kResponseBody.getResponse().header).ifMessage.contains('t_data size over. (max: 3)'));
        System.assertEquals(null, kResponseBody.getResponse().header.ifFailMsg);
    }

    // ***************************************
    // Own data class
    // ***************************************


    public class TEST_IF_Inbound extends TEST_IF_Inbound_0 {
        public override IF_LOG__c returnLogParams(IF_Abstract.InputAbstract aInput, IF_Abstract.OutputAbstract aOutput) {
            IF_Abstract.InputPayload kInputPayload = aInput.getPayload();
            IF_Abstract.OutputPayload kOutputPayload = aOutput.getPayload();
            kOutputPayload.ifRcvCnt = kInputPayload.ifSplitCnt;
            return new IF_LOG__c(ifAggregation__c = 'test', ifSplitCnt__c = 'test', ifSplitSeq__c = 'test', ifTotCnt__c = 'test', ifRcvCnt__c = 'test');
        }
    }
    public class TEST_IF_Inbound_Limit extends TEST_IF_Inbound_0 {
        protected override Integer limitData(Integer aSize) {
            return 3;
        }
    }
    public class TEST_IF_Inbound_Limit2 extends TEST_IF_Inbound_0 {
        protected override Integer limitData(Integer aSize) {
            return 3;
        }
        public override Object deserialize(String aJson) {
            IF_Abstract.RequestBody kRequestBody = (IF_Abstract.RequestBody) JSON.deserialize(aJson, RequestBody.class);
            if (null != kRequestBody?.getRequest()?.getPayload()) {
                Map<String, Object> kDataMap = (Map<String, Object>) JSON.deserializeUntyped(aJson);
                Map<String, Object> kPayloadMap = (Map<String, Object>) ((Map<String, Object>) kDataMap.get('request')).get('payload');
                List<IF_Abstract.T_DATA> kTDataList = new List<IF_Abstract.T_DATA>();
                List<Object> kList = (List<Object>) kPayloadMap.get('t_data');

                // data 사이즈 검사 하지 않고 모두 파싱
                for (Object kObj : kList) {
                    kTDataList.add(deserializeOne(JSON.serialize(kObj)));
                }

                ((IF_Abstract.InputPayload) kRequestBody.getRequest().getPayload()).t_data = kTDataList;
            }
            return kRequestBody;
        }
    }

    public virtual class TEST_IF_Inbound_0 extends IF_Inbound {
        public override String getIfId() {
            return 'test_id';
        }

        public override IF_Abstract.RequestBodyAbstract getNewRequestBody() {
            return new IF_Abstract.RequestBody();
        }

        public override IF_Abstract.ResponseBodyAbstract getNewResponseBody() {
            return new IF_Abstract.ResponseBody();
        }

        public override IF_Abstract.T_DATA deserializeOne(String aReq) {
            return new IF_Abstract.T_DATA();
        }

        public override void process(IF_Abstract.InputAbstract aInput, IF_Abstract.OutputAbstract aOutput) { //NOPMD
            aOutput.getPayload().ifAggregation = aInput.getPayload().ifAggregation;
            aOutput.getPayload().ifRcvCnt = 'rev_cnt';
        }

    }
}