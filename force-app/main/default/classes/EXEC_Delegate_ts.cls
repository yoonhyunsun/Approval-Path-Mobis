/**
 * Created by hyodongmin on 2022/08/23.
 */

@IsTest
private class EXEC_Delegate_ts implements Database.Batchable<SObject> {

    @IsTest
    private static void testGetWebCallout() {
        EXEC_Delegate delegate = new EXEC_Delegate();
        System.assert(delegate.getWebCallout(EXEC_Manager.CHAIN_CALLOUT_SAMPLE) instanceof EXEC_ChainCalloutAdapter, 'Expect true');
        System.assert(((EXEC_ChainCalloutAdapter)delegate.getWebCallout(EXEC_Manager.CHAIN_CALLOUT_SAMPLE)).outboundExecutor instanceof IF_Outbound_sample);
    }

    @IsTest
    private static void testGetBatch() {
        EXEC_Delegate delegate = new EXEC_Delegate();
        System.assert(delegate.getBatch(EXEC_Manager.CHAIN_BATCH_DELETE_IF_IM_SFDC_HRMASTER) instanceof EXEC_Delete_ba, 'Expect true');
    }

    @IsTest
    private static void testGetLog() {
        EXEC_Delegate delegate = new EXEC_Delegate();
        System.assert(null != delegate.getLog(EXEC_Manager.CHAIN_LOG_START).message, 'Expect true');
    }

    @IsTest
    private static void testNextChain() {
        EXEC_Delegate delegate = new EXEC_Delegate();
        System.assert(delegate.nextChain(EXEC_Manager.getChains(), EXEC_Manager.CHAIN_LOG_START) instanceof EXEC_ChainBatch, 'Expect true');
    }

    @IsTest
    private static void testEnqueueJob() {
        IfStaticValue__c ifStaticValue = new IfStaticValue__c();
        ifStaticValue.chain_enabled__c = true;
        IF_Static.replaceIfStaticValue(ifStaticValue);

        EXEC_Delegate delegate = new EXEC_Delegate();

        TestQueueable queueable = new TestQueueable();
        Test.startTest();
        Id jobId = delegate.enqueueJob(queueable);
        Test.stopTest();

        System.assertEquals('Completed', [SELECT Id, Status FROM AsyncApexJob WHERE Id = :jobId][0].Status, 'Expect Completed');
    }

    @IsTest
    private static void testEnqueueJobDisable() {
        IfStaticValue__c ifStaticValue = new IfStaticValue__c();
        ifStaticValue.chain_enabled__c = false;
        IF_Static.replaceIfStaticValue(ifStaticValue);

        EXEC_Delegate delegate = new EXEC_Delegate();

        TestQueueable queueable = new TestQueueable();
        Test.startTest();
        Id jobId = delegate.enqueueJob(queueable);
        Test.stopTest();

        System.assertEquals(null, jobId, 'Expect null');
    }

    @IsTest
    private static void testExecuteBatch() {
        IfStaticValue__c ifStaticValue = new IfStaticValue__c();
        ifStaticValue.chain_enabled__c = true;
        IF_Static.replaceIfStaticValue(ifStaticValue);

        Lead l = new Lead();
        l.FirstName = 'Salesforce';
        l.LastName = 'Codes';
        l.Company = 'salesforce codes';
        l.LeadSource = 'Web';
        insert l;

        EXEC_Delegate delegate = new EXEC_Delegate();

        EXEC_Delegate_ts batch = new EXEC_Delegate_ts();
        Test.startTest();
        delegate.executeBatch(batch);
        Test.stopTest();

        Lead leads = [SELECT Rating FROM Lead WHERE Id = :l.Id];
        System.assertEquals('Warm', leads.Rating, 'Expect Warm');

    }

    @IsTest
    private static void testExecuteBatchDisable() {
        IfStaticValue__c ifStaticValue = new IfStaticValue__c();
        ifStaticValue.chain_enabled__c = false;
        IF_Static.replaceIfStaticValue(ifStaticValue);

        EXEC_Delegate delegate = new EXEC_Delegate();

        EXEC_Delegate_ts batch = new EXEC_Delegate_ts();
        Test.startTest();
        Id jobId = delegate.executeBatch(batch);
        Test.stopTest();

        System.assertEquals(null, jobId, 'Expect null');

    }

    @IsTest
    private static void testRepeat() {
        IfStaticValue__c ifStaticValue = new IfStaticValue__c();
        ifStaticValue.chain_enabled__c = true;
        IF_Static.replaceIfStaticValue(ifStaticValue);

        EXEC_Delegate delegate = new EXEC_Delegate();

        TestQueueable queueable = new TestQueueable();
        Test.startTest();
        Id jobId = delegate.repeat(queueable);
        Test.stopTest();

        System.assertEquals('Completed', [SELECT Id, Status FROM AsyncApexJob WHERE Id = :jobId][0].Status, 'Expect Completed');
    }

    @IsTest
    private static void testRepeatDisable() {
        IfStaticValue__c ifStaticValue = new IfStaticValue__c();
        ifStaticValue.chain_enabled__c = false;
        IF_Static.replaceIfStaticValue(ifStaticValue);

        EXEC_Delegate delegate = new EXEC_Delegate();

        TestQueueable queueable = new TestQueueable();
        Test.startTest();
        Id jobId = delegate.repeat(queueable);
        Test.stopTest();

        System.assertEquals(null, jobId, 'Expect null');
    }

    public class TestQueueable implements Queueable {

        public void execute(QueueableContext param1) {
            System.debug('TestQueueable-->');
        }
    }

    // ***************************************
    // implements for test
    // ***************************************

    public void execute(Database.BatchableContext param1, List<Lead> param2) {
        for (Lead l : param2) {
            if (l.LeadSource == 'web') {
                l.Rating = 'warm';
            }
        }
        update param2;
    }

    public void finish(Database.BatchableContext param1) {
        System.debug('finish');
    }

    public Database.QueryLocator start(Database.BatchableContext param1) {
        return Database.getQueryLocator('SELECT LeadSource,Rating FROM Lead');
    }
}