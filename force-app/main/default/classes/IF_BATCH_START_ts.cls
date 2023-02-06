/**
 * Created by hyodongmin on 2022/09/13.
 */

@IsTest
private class IF_BATCH_START_ts {

    @IsTest
    static void testInputBatch() {
        IF_BATCH_START.InputBatch kInput = new IF_BATCH_START.InputBatch();
        IF_BATCH_START.InputPayloadBatch kPayload = new IF_BATCH_START.InputPayloadBatch();
        kPayload.disabled = true;
        kInput.setPayload(kPayload);

        System.assertEquals(true, ((IF_BATCH_START.InputPayloadBatch) kInput.getPayload()).disabled);
    }
    @IsTest
    static void testOutputBatch() {
        IF_BATCH_START.OutputBatch kOutput = new IF_BATCH_START.OutputBatch();
        IF_BATCH_START.OutputPayloadBatch kPayload = new IF_BATCH_START.OutputPayloadBatch();
        kPayload.status = 'S';
        kPayload.reason = 'r';
        kOutput.setPayload(kPayload);

        System.assertEquals('S', ((IF_BATCH_START.OutputPayloadBatch) kOutput.getPayload()).status);
        System.assertEquals('r', ((IF_BATCH_START.OutputPayloadBatch) kOutput.getPayload()).reason);
    }
    @IsTest
    static void testProcess() {
        List<String> kChains = new List<String>{
                ''
        };
        EXEC_Manager.replaceChains(kChains);

        IF_BATCH_START kIf = new IF_BATCH_START();
        IF_BATCH_START.InputBatch kInput = new IF_BATCH_START.InputBatch();
        ((IF_BATCH_START.InputPayloadBatch) kInput.getPayload()).disabled = null;

        IF_BATCH_START.OutputBatch kOutput = new IF_BATCH_START.OutputBatch();
        kOutput.getPayload().ifAggregation = 'ifAggregation';
        kIf.process(kInput, kOutput);

        System.assertEquals('ifAggregation', kOutput.getPayload().ifAggregation); // aggregation 유지
        System.assertEquals('S', ((IF_BATCH_START.OutputPayloadBatch) kOutput.getPayload()).status);  // chain 실행
        System.assertEquals('', ((IF_BATCH_START.OutputPayloadBatch) kOutput.getPayload()).reason);  // chain 실행
    }
    @IsTest
    static void testProcess2() {
        List<String> kChains = new List<String>{
                EXEC_Manager.CHAIN_LOG_START
        };
        EXEC_Manager.replaceChains(kChains);
        EXEC_Factory.getChain(kChains, kChains[0], '').startChain(new EXEC_ChainContext());

        IF_BATCH_START kIf = new IF_BATCH_START();
        IF_BATCH_START.InputBatch kInput = new IF_BATCH_START.InputBatch();
        IF_BATCH_START.OutputBatch kOutput = new IF_BATCH_START.OutputBatch();
        kIf.process(kInput, kOutput);

        System.assertEquals('F', ((IF_BATCH_START.OutputPayloadBatch) kOutput.getPayload()).status);  // chain 이미 실행 중
        System.assertEquals('Queued', ((IF_BATCH_START.OutputPayloadBatch) kOutput.getPayload()).reason);  // chain 이미 실행 중
    }
    @IsTest
    static void testProcessDisabled() {
        List<String> kChains = new List<String>{
                ''
        };
        EXEC_Manager.replaceChains(kChains);

        IF_BATCH_START kIf = new IF_BATCH_START();
        IF_BATCH_START.InputBatch kInput = new IF_BATCH_START.InputBatch();
        ((IF_BATCH_START.InputPayloadBatch) kInput.getPayload()).disabled = true;
        IF_BATCH_START.OutputBatch kOutput = new IF_BATCH_START.OutputBatch();
        kIf.process(kInput, kOutput);

        System.assertEquals('F', ((IF_BATCH_START.OutputPayloadBatch) kOutput.getPayload()).status);  // chain 이미 실행 중
        System.assertEquals('disabled=true', ((IF_BATCH_START.OutputPayloadBatch) kOutput.getPayload()).reason);  // chain 이미 실행 중
    }
    @IsTest
    static void testRetrieveJobStatus() {
        List<String> kChains = new List<String>{
                'IF_test', 'chainBatchTest', 'logTest'
        };
        EXEC_Manager.replaceChains(kChains);

        // 실행 중인 배치 없음
        System.assertEquals('', IF_BATCH_START.retrieveJobStatus());
    }
    @IsTest
    static void testGetIfId() {
        System.assertEquals(IF_FACTORY.IF_BATCH_START, new IF_BATCH_START().getIfId());
    }
    @IsTest
    static void testDeserialize() {
        String kJson = '{\n' +
                '    "request": {\n' +
                '        "header": {\n' +
                '            "ifTrackingId": "trackingId",\n' +
                '            "ifId": "IF_BATCH_START",\n' +
                '            "ifDateTime": "2020-09-10 17:17:38"\n' +
                '        },\n' +
                '        "payload": {\n' +
                '            "ifAggregation": "aggregation",\n' +
                '            "disabled": true\n' +
                '        }\n' +
                '    }\n' +
                '}';
        IF_BATCH_START.RequestBodyBatch kInput = (IF_BATCH_START.RequestBodyBatch) new IF_BATCH_START().deserialize(kJson);
        System.assertEquals('trackingId', kInput.getRequest().header.ifTrackingId);
        System.assertEquals('IF_BATCH_START', kInput.getRequest().header.ifId);
        System.assertEquals('2020-09-10 17:17:38', kInput.getRequest().header.ifDateTime);
        System.assertEquals('aggregation', kInput.getRequest().getPayload().ifAggregation);
        System.assertEquals(true, ((IF_BATCH_START.InputPayloadBatch) kInput.getRequest().getPayload()).disabled);
    }
    @IsTest
    static void testDeserializeOne() {
        System.assertEquals(null, new IF_BATCH_START().deserializeOne('{}'));
    }
    @IsTest
    static void testPost() {
        EXEC_Manager.replaceChains(new List<String>{ '' });    // for test, skip batch

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/IF_BATCH_START';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueOf('{\n' +
                '    "request": {\n' +
                '        "header": {\n' +
                '            "ifTrackingId": "{{trackingId}}",\n' +
                '            "ifId": "IF_BATCH_START",\n' +
                '            "ifDateTime": "2020-09-10 17:17:38"\n' +
                '        },\n' +
                '        "payload": {\n' +
                '            "ifAggregation": "{{aggregation}}",\n' +
                '            "disabled": null\n' +
                '        }\n' +
                '    }\n' +
                '}');

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        IF_ROUTER.doPost();
        System.debug(res.responseBody.toString());
        Map<String, Object> kOutputMap = (Map<String, Object>) JSON.deserializeUntyped(res.responseBody.toString());
        Test.stopTest();

        System.assertEquals('{{trackingId}}', TestUtil.valueOf(kOutputMap, 'response.header.ifTrackingId'));
        System.assertEquals('{{aggregation}}', TestUtil.valueOf(kOutputMap, 'response.payload.ifAggregation'));
        System.assertEquals('S', TestUtil.valueOf(kOutputMap, 'response.payload.status'));
    }
    @IsTest
    static void testPost2() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/IF_BATCH_START';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueOf('{\n' +
                '    "request": {\n' +
                '        "header": {\n' +
                '            "ifTrackingId": "{{trackingId}}",\n' +
                '            "ifId": "IF_BATCH_START",\n' +
                '            "ifDateTime": "2020-09-10 17:17:38"\n' +
                '        },\n' +
                '        "payload": {\n' +
                '            "ifAggregation": "{{aggregation}}",\n' +
                '            "disabled": true\n' +
                '        }\n' +
                '    }\n' +
                '}');

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        IF_ROUTER.doPost();
        System.debug(res.responseBody.toString());
        Map<String, Object> kOutputMap = (Map<String, Object>) JSON.deserializeUntyped(res.responseBody.toString());
        Test.stopTest();

        System.assertEquals('{{trackingId}}', TestUtil.valueOf(kOutputMap, 'response.header.ifTrackingId'));
        System.assertEquals('{{aggregation}}', TestUtil.valueOf(kOutputMap, 'response.payload.ifAggregation'));
        System.assertEquals('F', TestUtil.valueOf(kOutputMap, 'response.payload.status'));
    }
}