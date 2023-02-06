/**
 * Created by hyodongmin on 2022/08/23.
 */

@IsTest
private class EXEC_ChainLog_ts {
    @IsTest
    static void testExecute() {
        TestChain testChain = new TestChain();
        EXEC_ChainLog chainLog = new EXEC_ChainLog(new TestDelegate(testChain), EXEC_Manager.getChains(), 'test-name');

        chainLog.execute(null);

        System.assert(testChain.isInvoked());

        List<IF_LOG__c> kLogs = [SELECT Id, OERRORTEXT__c FROM IF_LOG__c WHERE IFID__c = :chainLog.getChainName()];

        System.assertEquals(1, kLogs.size());
        System.assertEquals('test_message', kLogs[0].OERRORTEXT__c);

    }

    @IsTest
    static void testStartChain() {
        TestChain testChain = new TestChain();
        TestDelegate delegate = new TestDelegate(testChain);
        EXEC_ChainLog chainLog = new EXEC_ChainLog(delegate, EXEC_Manager.getChains(), 'test-name');

        chainLog.startChain(new EXEC_ChainContext());

        System.assert(delegate.isEnqueued);
        System.assert(false == delegate.isRepeated);

    }

    @IsTest
    static void testGetChainName() {
        TestChain testChain = new TestChain();
        TestDelegate delegate = new TestDelegate(testChain);
        EXEC_ChainLog chainLog = new EXEC_ChainLog(delegate, EXEC_Manager.getChains(), 'test-name');

        System.assertEquals('test-name', chainLog.getChainName());

    }

    public class TestDelegate extends EXEC_Delegate {
        public Boolean isEnqueued = false;
        public Boolean isRepeated = false;
        TestChain testChain;
        public TestDelegate(TestChain aTestChain) {
            testChain = aTestChain;
        }

        public override EXEC_Manager.IChainCallout getWebCallout(String aChainName) {
            return null;
        }

        public override EXEC_Manager.ChainLog getLog(String aChainName) {
            return new EXEC_Manager.ChainLog('test_message');
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