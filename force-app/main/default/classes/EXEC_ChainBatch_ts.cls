/**
 * Created by hyodongmin on 2022/08/23.
 */

@IsTest
private class EXEC_ChainBatch_ts extends BatchBase {

    @IsTest
    private static void testGetChainName() {
        EXEC_IChain chain = new EXEC_ChainBatch(new EXEC_Delegate(), EXEC_Manager.getChains(), 'name');
        System.assertEquals('name', chain.getChainName(), 'Expect name');
    }

    @IsTest
    private static void testStartChain() {
        TestChain testChain = new TestChain();
        TestDelegate delegate = new TestDelegate(new EXEC_ChainBatch_ts(), testChain);
        EXEC_IChain chain = new EXEC_ChainBatch(delegate, EXEC_Manager.getChains(), 'name');
        chain.startChain(new EXEC_ChainContext());

        System.assert(false == testChain.isInvoked(), 'Expect true');
        System.assert(delegate.isExecuteBatch, 'Expect true');
    }

    @IsTest
    private static void testStart() {
        TestChain testChain = new TestChain();

        EXEC_ChainBatch_ts batchable = new EXEC_ChainBatch_ts();
        TestDelegate delegate = new TestDelegate(batchable, testChain);
        Database.Batchable<SObject> batch = new EXEC_ChainBatch(delegate, EXEC_Manager.getChains(), 'name');

        batch.start(new TestContext());

        System.assert(batchable.isStarted, 'Expect true');
        System.assert(false == batchable.isExecuted, 'Expect true');
        System.assert(false == batchable.isFinished, 'Expect true');
    }

    @IsTest
    private static void testExecute() {
        TestChain testChain = new TestChain();

        EXEC_ChainBatch_ts batchable = new EXEC_ChainBatch_ts();
        TestDelegate delegate = new TestDelegate(batchable, testChain);
        Database.Batchable<SObject> batch = new EXEC_ChainBatch(delegate, EXEC_Manager.getChains(), 'name');

        batch.execute(null, null);

        System.assert(false == batchable.isStarted, 'Expect true');
        System.assert(batchable.isExecuted, 'Expect true');
        System.assert(false == batchable.isFinished, 'Expect true');
    }

    @IsTest
    private static void testFinish() {
        TestChain testChain = new TestChain();

        EXEC_ChainBatch_ts batchable = new EXEC_ChainBatch_ts();
        TestDelegate delegate = new TestDelegate(batchable, testChain);
        Database.Batchable<SObject> batch = new EXEC_ChainBatch(delegate, EXEC_Manager.getChains(), 'name');

        batch.start(new TestContext());
        batch.finish(null);

        System.assert(batchable.isStarted, 'Expect true');
        System.assert(false == batchable.isExecuted, 'Expect true');
        System.assert(batchable.isFinished, 'Expect true');
    }


    private class TestDelegate extends EXEC_Delegate {
        public Boolean isExecuteBatch = false;

        Database.Batchable<SObject> batchable;
        TestChain testChain;
        public TestDelegate(Database.Batchable<SObject> aBatchable, TestChain aTestChain) {
            batchable = aBatchable;
            testChain = aTestChain;
        }

        public override EXEC_Manager.IChainCallout getWebCallout(String aChainName) {
            return null;
        }

        public override EXEC_IChain nextChain(List<String> aChains, String aCurrentChainName) {
            return testChain;
        }

        public override Database.Batchable<SObject> getBatch(String aChainName) {
            return batchable;
        }

        public override Id executeBatch(Database.Batchable<SObject> batchable) {
            isExecuteBatch = true;
            return '01I9D000000XnYp'; // NOPMD just test
        }

        public override Id enqueueJob(Queueable aQueueable) {
            return '01I9D000000XnYp'; // NOPMD just test
        }

        public override Id repeat(Queueable aQueueable) {
            return '01I9D000000XnYp'; // NOPMD just test
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

    class TestContext implements Database.BatchableContext {
        public Id getChildJobId() {
            return '01p9D000002zVAW';
        }
        public Id getJobId() {
            return '01p9D000002oIBQ';
        }
    }

    // ***************************************
    // implements for test
    // ***************************************

    public Boolean isExecuted = false;
    public Boolean isStarted = false;
    public Boolean isFinished = false;
    public override void execute(Database.BatchableContext param1, List<SObject> param2) {
        isExecuted = true;
    }

    protected override void finish2(Database.BatchableContext param1) {
        isFinished = true;
    }

    protected override Database.QueryLocator start2(Database.BatchableContext param1) {
        isStarted = true;
        return null;
    }
}