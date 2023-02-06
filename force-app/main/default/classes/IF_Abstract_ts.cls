/**
 * Created by hyodongmin on 2022/07/27.
 */

@IsTest
private class IF_Abstract_ts {
    @IsTest
    static void testBehavior() {
        IF_Abstract ifAbstract = new TEST_IF_Abstract(100);
        System.assertEquals(100, ifAbstract.countPerPage);

        IF_Abstract ifAbstract2 = new TEST_IF_Abstract();
        System.assertEquals(2000, ifAbstract2.countPerPage);
    }

    @IsTest
    static void testInputHeader2() {
        IF_Abstract.InputHeader2 kHeader = new IF_Abstract.InputHeader2();

        kHeader = new IF_Abstract.InputHeader2('task-id');
        System.assertEquals('task-id', kHeader.ifId);
        kHeader = new IF_Abstract.InputHeader2('tracking-id', 'task-id', 'datetime');
        System.assertEquals('tracking-id', kHeader.ifTrackingId);
        System.assertEquals('task-id', kHeader.ifId);
        System.assertEquals('datetime', kHeader.ifDateTime);
    }

    @IsTest
    static void testRequestBody() {
        IF_Abstract.RequestBody kBody = new IF_Abstract.RequestBody();
        System.assertEquals(true, kBody.getRequest() != null);
    }

    @IsTest
    static void testResponseBody() {
        IF_Abstract.ResponseBody kBody = new IF_Abstract.ResponseBody();
        System.assertEquals(true, kBody.getResponse() != null);
    }

    @IsTest
    static void testGetInputBody() {
        IF_Abstract ifAbstract2 = new TEST_IF_Abstract();
        System.assert(null != ifAbstract2.getNewRequestBody());
    }

    @IsTest
    static void testGetOutputBody() {
        IF_Abstract ifAbstract2 = new TEST_IF_Abstract();
        System.assert(null != ifAbstract2.getNewResponseBody());
    }

    @IsTest
    static void testDeserialize() {
        Map<String, Object> kPayload = new Map<String, Object>();
        kPayload.put('t_data', new List<Object>{
                JSON.deserialize('{"var":"asdf"}', T_VAR.class)
        });
        IF_Abstract ifAbstract2 = new TEST_IF_Abstract();

        List<IF_Abstract.T_DATA> kList = ifAbstract2.deserializePayloadData(kPayload);

        System.assertEquals('asdf', ((T_VAR)kList[0]).var);
    }

    @IsTest
    static void testDeserializeLimit() {
        Map<String, Object> kPayload = new Map<String, Object>();
        kPayload.put('t_data', new List<Object>{
                JSON.deserialize('{"var":"asdf"}', T_VAR.class),
                JSON.deserialize('{"var":"asdf"}', T_VAR.class),
                JSON.deserialize('{"var":"asdf"}', T_VAR.class),
                JSON.deserialize('{"var":"asdf"}', T_VAR.class),
                JSON.deserialize('{"var":"asdf"}', T_VAR.class)
        });

        // 데이터 수 제한 없음 (기본값)
        System.assertEquals(5, new TEST_IF_Abstract().deserializePayloadData(kPayload).size());

        // 2개로 제한
        Boolean ex = false;
        try {
            new TEST_IF_Abstract_Limit().deserializePayloadData(kPayload).size();
        } catch (Exception e) {
            ex = true;
            System.assertEquals('t_data size over. (max: 2)', e.getMessage());
        }
        System.assertEquals(true, ex);
    }
    @IsTest
    private static void testReturnLogParams() {
        TEST_IF_Abstract ifBase = new TEST_IF_Abstract();

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
        kOutputPayload.ifRcvCnt = 'rev';
        kOutput.setPayload(kOutputPayload);

        IF_LOG__c kLog = ifBase.returnLogParams(kInput, kOutput);
        System.assertEquals('agg', kLog.ifAggregation__c);
        System.assertEquals('tot', kLog.ifTotCnt__c);
        System.assertEquals('cnt', kLog.ifSplitCnt__c);
        System.assertEquals('seq', kLog.ifSplitSeq__c);
        System.assertEquals('rev', kLog.ifRcvCnt__c);
    }
    @IsTest
    private static void testReturnLogParams1() {
        TEST_IF_Abstract ifBase = new TEST_IF_Abstract();

        IF_Abstract.Input kInput = new IF_Abstract.Input();
        IF_Abstract.InputPayload inputPayload = new IF_Abstract.InputPayload();
        inputPayload.ifAggregation = 'agg';
        inputPayload.ifTotCnt = 'tot';
        inputPayload.ifSplitCnt = 'cnt';
        inputPayload.ifSplitSeq = 'seq';
        kInput.setPayload(inputPayload);

        IF_Abstract.Output kOutput = new IF_Abstract.Output();
        kOutput.setPayload(null);


        IF_LOG__c kLog = ifBase.returnLogParams(kInput, kOutput);
        System.assertEquals('agg', kLog.ifAggregation__c);
        System.assertEquals('tot', kLog.ifTotCnt__c);
        System.assertEquals('cnt', kLog.ifSplitCnt__c);
        System.assertEquals('seq', kLog.ifSplitSeq__c);
        System.assertEquals(null, kLog.ifRcvCnt__c);
    }
    @IsTest
    private static void testReturnLogParams2() {
        TEST_IF_Abstract ifBase = new TEST_IF_Abstract();

        IF_Abstract.Input kInput = new IF_Abstract.Input();
        kInput.setPayload(null);

        IF_Abstract.Output kOutput = new IF_Abstract.Output();
        IF_Abstract.OutputPayload kOutputPayload = new IF_Abstract.OutputPayload();
        kOutputPayload.ifAggregation = 'agg2';
        kOutputPayload.ifRcvCnt = 'rev';
        kOutput.setPayload(kOutputPayload);


        IF_LOG__c kLog = ifBase.returnLogParams(kInput, kOutput);
        System.assertEquals(null, kLog.ifAggregation__c);
        System.assertEquals(null, kLog.ifTotCnt__c);
        System.assertEquals(null, kLog.ifSplitCnt__c);
        System.assertEquals(null, kLog.ifSplitSeq__c);
        System.assertEquals('rev', kLog.ifRcvCnt__c);
    }
    @IsTest
    private static void testReturnLogParams3() {
        TEST_IF_Abstract ifBase = new TEST_IF_Abstract();

        IF_Abstract.Input kInput = new IF_Abstract.Input();
        kInput.setPayload(null);

        IF_Abstract.Output kOutput = new IF_Abstract.Output();
        kOutput.setPayload(null);


        IF_LOG__c kLog = ifBase.returnLogParams(kInput, kOutput);
        System.assertEquals(null, kLog.ifAggregation__c);
        System.assertEquals(null, kLog.ifTotCnt__c);
        System.assertEquals(null, kLog.ifSplitCnt__c);
        System.assertEquals(null, kLog.ifSplitSeq__c);
        System.assertEquals(null, kLog.ifRcvCnt__c);
    }
    
    public class T_VAR extends IF_Abstract.T_DATA {
        public String var;
    }

    public virtual class TEST_IF_Abstract extends IF_Abstract {
        
        public TEST_IF_Abstract() {
            super();
        }

        public TEST_IF_Abstract(Integer aCountPerPage) {
            super(aCountPerPage);
        }

        public override String getIfId() {
            return '';
        }

        public override Object deserialize(String aJson) {
            return null;
        }

        public override T_DATA deserializeOne(String aJson) {
            return (T_VAR) JSON.deserialize(aJson, T_VAR.class);
        }
    }

    public class TEST_IF_Abstract_Limit extends TEST_IF_Abstract {
        public override Integer limitData(Integer aSize) {
            return 2;
        }
    }
}