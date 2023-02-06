/**
 * Created by hyodongmin on 2022/09/05.
 */

@IsTest
private class EXEC_Batch_Sample_ba_ts {
    @IsTest
    static void testBehavior() {
        EXEC_Batch_Sample_ba ba = new EXEC_Batch_Sample_ba();
        ba.start(new TestContext());
        ba.execute(new TestContext() , new SObject[]{});
        ba.finish(null);
    }


    class TestContext implements Database.BatchableContext {
        public Id getChildJobId() {
            return '01p9D000002zVAW';
        }
        public Id getJobId() {
            return '01p9D000002oIBQ';
        }
    }
}