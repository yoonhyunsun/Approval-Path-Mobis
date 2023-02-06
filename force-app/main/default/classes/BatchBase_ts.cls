/**
 * Created by hyodongmin on 2022/08/23.
 */

@IsTest
private class BatchBase_ts {
    @IsTest
    static void testBehavior() {
        // for coverage
        BatchBase kBatchable = new TestBatchBase();
        Database.BatchableContext kContext = new TestContext();
        kBatchable.start(kContext);

        kBatchable.finish(kContext);

        kBatchable.getLogger();
    }

    @IsTest
    static void testPersistUpsertResult() {
        BatchBase kBatchable = new TestBatchBase();
        Database.BatchableContext kContext = new TestContext();
        kBatchable.start(kContext);

        Account kAccount = new Account();
        Database.UpsertResult kResult = Database.upsert(kAccount, false);
        kBatchable.persistUpsertResult(kAccount, Account.BillingCity, kResult);
        System.assertEquals(BatchBase.DUMMY_STATUS_FAILURE, kAccount.BillingCity);

        kAccount = new Account(Name = 'asdf');
        kResult = Database.upsert(kAccount);
        kBatchable.persistUpsertResult(kAccount, Account.BillingCity, kResult, 'M');
        System.assertEquals('M', kAccount.BillingCity);
    }

    class TestBatchBase extends BatchBase {
        protected override Database.QueryLocator start2(Database.BatchableContext batchableContext) {
            return Database.getQueryLocator('SELECT Id FROM Account');
        }
        public override void execute(Database.BatchableContext context, List<SObject> scope) {
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
}