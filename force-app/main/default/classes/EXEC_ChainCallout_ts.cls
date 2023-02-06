/**
 * Created by hyodongmin on 2022/08/23.
 */

@IsTest
private with sharing class EXEC_ChainCallout_ts {

    @IsTest
    private static void testGetChainName() {
        EXEC_IChain chain = new EXEC_ChainCallout(new EXEC_Delegate(), EXEC_Manager.getChains(), 'aggregation..', 'name', 1);
        System.assertEquals('name', chain.getChainName(), 'Expect name');
    }
    @IsTest
    private static void testStartChain() {
//        List<String> chains = new List<String>{
//                EXEC_Manager.CHAIN_CALLOUT_SAMPLE
//        };
        EXEC_Manager.CalloutResult result = new EXEC_Manager.CalloutResult(IF_Outbound.RESULT_CODE_END, '');
        TestWebCallout webCallout = new TestWebCallout(result);
        TestChain testChain = new TestChain();
        TestDelegate delegate = new TestDelegate(webCallout, testChain);
        EXEC_IChain chain = new EXEC_ChainCallout(delegate, EXEC_Manager.getChains(), 'aggregation..', 'name', 1);
        chain.startChain(new EXEC_ChainContext());

        System.assert(false == testChain.isInvoked(), 'Expect true');
        System.assert(delegate.isEnqueued, 'Expect true');
        System.assert(false == delegate.isRepeated, 'Expect true');
    }

    @IsTest
    private static void testExecuteNext() {
        List<String> chains = new List<String>{
                EXEC_Manager.CHAIN_CALLOUT_SAMPLE
        };
        EXEC_Manager.CalloutResult result = new EXEC_Manager.CalloutResult(IF_Outbound.RESULT_CODE_END, '');
        TestWebCallout webCallout = new TestWebCallout(result);
        TestChain testChain = new TestChain();
        TestDelegate delegate = new TestDelegate(webCallout, testChain);
        Queueable chain = new EXEC_ChainCallout(delegate, chains, 'aggregation..', EXEC_Manager.CHAIN_CALLOUT_SAMPLE, 1);
        chain.execute(null);

        System.assert(testChain.isInvoked(), 'Expect true');
        System.assert(false == delegate.isEnqueued, 'Expect true');
        System.assert(false == delegate.isRepeated, 'Expect true');
    }

    @IsTest
    private static void testExecuteError() {
        List<String> chains = new List<String>{
                EXEC_Manager.CHAIN_CALLOUT_SAMPLE
        };
        EXEC_Manager.CalloutResult result = new EXEC_Manager.CalloutResult(IF_Outbound.RESULT_CODE_ERROR, '');
        TestWebCallout webCallout = new TestWebCallout(result);
        TestChain testChain = new TestChain();
        TestDelegate delegate = new TestDelegate(webCallout, testChain);
        Queueable chain = new EXEC_ChainCallout(delegate, chains, 'aggregation..', EXEC_Manager.CHAIN_CALLOUT_SAMPLE, 1);
        chain.execute(null);

        System.assert(false == testChain.isInvoked(), 'Expect true');
        System.assert(false == delegate.isEnqueued, 'Expect true');
        System.assert(false == delegate.isRepeated, 'Expect true');
    }

    @IsTest
    private static void testExecuteFail() {
        List<String> chains = new List<String>{
                EXEC_Manager.CHAIN_CALLOUT_SAMPLE
        };
        EXEC_Manager.CalloutResult result = new EXEC_Manager.CalloutResult(IF_Outbound.RESULT_CODE_FAIL, '');
        TestWebCallout webCallout = new TestWebCallout(result);
        TestChain testChain = new TestChain();
        TestDelegate delegate = new TestDelegate(webCallout, testChain);
        Queueable chain = new EXEC_ChainCallout(delegate, chains, 'aggregation..', EXEC_Manager.CHAIN_CALLOUT_SAMPLE, 1);
        chain.execute(null);

        System.assert(false == testChain.isInvoked(), 'Expect true');
        System.assert(false == delegate.isEnqueued, 'Expect true');
        System.assert(false == delegate.isRepeated, 'Expect true');
    }

    @IsTest
    private static void testExecuteRepeat() {
        List<String> chains = new List<String>{
                EXEC_Manager.CHAIN_CALLOUT_SAMPLE
        };
        EXEC_Manager.CalloutResult result = new EXEC_Manager.CalloutResult(2, '');
        TestWebCallout webCallout = new TestWebCallout(result);
        TestChain testChain = new TestChain();
        TestDelegate delegate = new TestDelegate(webCallout, testChain);
        Queueable chain = new EXEC_ChainCallout(delegate, chains, 'aggregation..', EXEC_Manager.CHAIN_CALLOUT_SAMPLE, 1);
        chain.execute(null);

        System.assert(false == testChain.isInvoked(), 'Expect true');
        System.assert(false == delegate.isEnqueued, 'Expect true');
        System.assert(delegate.isRepeated, 'Expect true');
    }

    @IsTest
    private static void testExecuteRepeatMaxOver() {
        List<String> chains = new List<String>{
                EXEC_Manager.CHAIN_CALLOUT_SAMPLE
        };
        EXEC_Manager.CalloutResult result = new EXEC_Manager.CalloutResult(2, '');
        TestWebCallout webCallout = new TestWebCallout(result);
        TestChain testChain = new TestChain();
        TestDelegate delegate = new TestDelegate(webCallout, testChain);
        Queueable chain = new EXEC_ChainCallout(delegate, chains, 'aggregation..', EXEC_Manager.CHAIN_CALLOUT_SAMPLE, 500);
        chain.execute(null);

        System.assert(false == testChain.isInvoked(), 'Expect true');
        System.assert(false == delegate.isEnqueued, 'Expect true');
        System.assert(false == delegate.isRepeated, 'Expect true');
    }

    public class TestDelegate extends EXEC_Delegate {
        public Boolean isEnqueued = false;
        public Boolean isRepeated = false;
        TestWebCallout testWebCallout;
        TestChain testChain;
        public TestDelegate(TestWebCallout aTestWebCallout, TestChain aTestChain) {
            testWebCallout = aTestWebCallout;
            testChain = aTestChain;
        }

        public override EXEC_Manager.IChainCallout getWebCallout(String aChainName) {
            return testWebCallout;
        }

        public override EXEC_IChain nextChain(List<String> aChains, String aCurrentChainName) {
            return testChain;
        }

        public override Database.Batchable<SObject> getBatch(String aChainName) {
            return super.getBatch(aChainName);
        }

        public override Id executeBatch(Database.Batchable<SObject> batchable) {
            return super.executeBatch(batchable);
        }

        public override Id enqueueJob(Queueable aQueueable) {
            isEnqueued = true;
            return '01I9D000000XnYp';   // NOPMD for test
        }

        public override Id repeat(Queueable aQueueable) {
            isRepeated = true;
            return '01I9D000000XnYp';   // NOPMD for test
        }
    }

    public class TestWebCallout implements EXEC_Manager.IChainCallout {
        EXEC_Manager.CalloutResult result;
        public TestWebCallout(EXEC_Manager.CalloutResult aResult) {
            result = aResult;
        }

        public EXEC_Manager.CalloutResult callout(String aAggregation) {
            return result;
        }
    }

    public class TestChain implements EXEC_IChain {
        Integer resultOfStartChain = -1;

        public Boolean isInvoked() {
            return 1 == resultOfStartChain;
        }

        public Id startChain(EXEC_ChainContext aContext) {
            resultOfStartChain = 1;
            return null;
        }

        public String getChainName() {
            return 'TestChain';
        }
    }
}