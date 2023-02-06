/**
 * Created by hyodongmin on 2022/08/23.
 */

@IsTest
private class BatchLogger_ts implements Database.Batchable<Object> {

    public void execute(Database.BatchableContext param1, List<Object> param2) {
    }

    public void finish(Database.BatchableContext param1) {
    }

    public Iterable<Object> start(Database.BatchableContext param1) {
        return (Iterable<Object>) [SELECT Id FROM Account];
    }

    @IsTest
    static void testBehavior() {
        BatchLogger_ts kBatch = new BatchLogger_ts();
        Id jobId = Database.executeBatch(kBatch);

        BatchLogger kLogger = new BatchLogger(jobId, String.valueOf(kBatch));

        kLogger.start();
        kLogger.log('some log');
        kLogger.finish();

        List<BatchLog__c> logs = [
                SELECT
                        Error__c,
                        Log__c
                FROM BatchLog__c
                WHERE cronId__c = :jobId
        ];
        System.assertEquals(1, logs.size());
        System.assert(logs[0].Log__c.contains('some log'));
    }
    @IsTest
    static void testBehaviorError() {
        BatchLogger_ts kBatch = new BatchLogger_ts();
        Id jobId = Database.executeBatch(kBatch);

        BatchLogger kLogger = new BatchLogger(jobId, String.valueOf(kBatch));

        kLogger.start();
        kLogger.error('some error');
        kLogger.finish();

        List<BatchLog__c> logs = [
                SELECT
                        Error__c,
                        Log__c
                FROM BatchLog__c
                WHERE cronId__c = :jobId
        ];
        System.assertEquals(1, logs.size());
        System.assert(logs[0].Error__c.contains('some error'));
        System.assertEquals(kLogger.getError(), logs[0].Error__c);
    }

    @IsTest
    static void testAppendSafely() {
        System.assertEquals('0123456789.....', BatchLogger.appendSafely('0123456789', 'asdf', 0));
        System.assertEquals('0123456789.....', BatchLogger.appendSafely('0123456789', 'asdf', 1));
        System.assertEquals('0123456789.....', BatchLogger.appendSafely('0123456789', 'asdf', 10));
        System.assertEquals('0123456789.....', BatchLogger.appendSafely('0123456789', 'asdf', 11));
        System.assertEquals('0123456789.....', BatchLogger.appendSafely('0123456789', 'asdf', 12));
        System.assertEquals('0123456789.....', BatchLogger.appendSafely('0123456789', 'asdf', 13));
        System.assertEquals('0123456789asdf', BatchLogger.appendSafely('0123456789', 'asdf', 14));
        System.assertEquals('0123456789asdf', BatchLogger.appendSafely('0123456789', 'asdf', 15));
        System.assertEquals('0123456789asdf', BatchLogger.appendSafely('0123456789', 'asdf', 20));
        System.assertEquals('0123456789asdf', BatchLogger.appendSafely('0123456789', 'asdf', 10000));
    }

}