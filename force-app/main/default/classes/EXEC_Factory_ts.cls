/**
 * Created by hyodongmin on 2022/08/23.
 */

@IsTest
private class EXEC_Factory_ts {

    @IsTest
    private static void testGetWebCallout() {
        EXEC_Manager.IChainCallout webCallout = EXEC_Factory.getWebCallout(EXEC_Manager.CHAIN_CALLOUT_SAMPLE);
        System.assert(webCallout instanceof EXEC_ChainCalloutAdapter);
        System.assert(((EXEC_ChainCalloutAdapter)webCallout).outboundExecutor instanceof IF_Outbound_sample);
    }
    @IsTest
    private static void testGetBatch() {
        Database.Batchable<SObject> batch = EXEC_Factory.getBatch(EXEC_Manager.CHAIN_BATCH_IF_IM_SFDC_HRMASTER);
        System.assert(batch instanceof EXEC_Batch_IF_IM_SFDC_HRMASTER_ba);
        batch = EXEC_Factory.getBatch(EXEC_Manager.CHAIN_BATCH_IF_IM_SFDC_ORGMASTER);
        System.assert(batch instanceof EXEC_Batch_IF_IM_SFDC_ORGMASTER_ba);
        batch = EXEC_Factory.getBatch(EXEC_Manager.CHAIN_BATCH_IF_IM_SFDC_ORGMASTER2);
        System.assert(batch instanceof EXEC_Batch_IF_IM_SFDC_ORGMASTER2_ba);
        batch = EXEC_Factory.getBatch(EXEC_Manager.CHAIN_BATCH_IF_IM_SFDC_HRMASTER_V2);
        System.assert(batch instanceof EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba);
        batch = EXEC_Factory.getBatch(EXEC_Manager.CHAIN_BATCH_IF_IM_SFDC_ORG_V2);
        System.assert(batch instanceof EXEC_Batch_IF_IM_SFDC_ORG_V2_ba);
        batch = EXEC_Factory.getBatch(EXEC_Manager.CHAIN_BATCH_IF_IM_SFDC_ORG_V2_2);
        System.assert(batch instanceof EXEC_Batch_IF_IM_SFDC_ORG_V2_2_ba);
        batch = EXEC_Factory.getBatch(EXEC_Manager.CHAIN_BATCH_IF_ERP_SFDC_SALES);
        System.assert(batch instanceof EXEC_Batch_IF_ERP_SFDC_SALES_ba);
        batch = EXEC_Factory.getBatch(EXEC_Manager.CHAIN_BATCH_IF_ERP_SFDC_OUTPRICE);
        System.assert(batch instanceof EXEC_Batch_IF_ERP_SFDC_OUTPRICE_ba);
        batch = EXEC_Factory.getBatch(EXEC_Manager.CHAIN_BATCH_IF_ERP_SFDC_EXCHANGE_RATE);
        System.assert(batch instanceof EXEC_Batch_IF_ERP_SFDC_EXCH_RATE_ba);
    }

    @IsTest
    private static void testGetBatchDelete() {
        Database.Batchable<SObject> batch = EXEC_Factory.getBatch(EXEC_Manager.CHAIN_BATCH_DELETE_IF_IM_SFDC_HRMASTER);
        System.assertEquals('IF_IM_SFDC_HRMASTER__c', ((EXEC_Delete_ba) batch).sObjectName);
        batch = EXEC_Factory.getBatch(EXEC_Manager.CHAIN_BATCH_DELETE_IF_IM_SFDC_ORGMASTER);
        System.assertEquals('IF_IM_SFDC_ORGMASTER__c', ((EXEC_Delete_ba) batch).sObjectName);
        batch = EXEC_Factory.getBatch(EXEC_Manager.CHAIN_BATCH_DELETE_IF_IM_SFDC_HRMASTER_V2);
        System.assertEquals('IF_IM_SFDC_HRMASTER2__c', ((EXEC_Delete_ba) batch).sObjectName);
        batch = EXEC_Factory.getBatch(EXEC_Manager.CHAIN_BATCH_DELETE_IF_IM_SFDC_ORG_V2);
        System.assertEquals('IF_IM_SFDC_ORGMASTER2__c', ((EXEC_Delete_ba) batch).sObjectName);
        batch = EXEC_Factory.getBatch(EXEC_Manager.CHAIN_BATCH_DELETE_IF_ERP_SFDC_SALES);
        System.assertEquals('IF_ERP_SFDC_SALES__c', ((EXEC_Delete_ba) batch).sObjectName);
        batch = EXEC_Factory.getBatch(EXEC_Manager.CHAIN_BATCH_DELETE_IF_ERP_SFDC_OUTPRICE);
        System.assertEquals('IF_ERP_SFDC_OUTPRICE__c', ((EXEC_Delete_ba) batch).sObjectName);
        batch = EXEC_Factory.getBatch(EXEC_Manager.CHAIN_BATCH_DELETE_IF_ERP_SFDC_EXCHANGE_RATE);
        System.assertEquals('IF_ERP_SFDC_EXCHANGE_RATE__c', ((EXEC_Delete_ba) batch).sObjectName);

        batch = EXEC_Factory.getBatch('for-null');
        System.assert(null == batch);
    }

    @IsTest
    private static void testGetLog() {
        EXEC_Manager.ChainLog kLog = EXEC_Factory.getLog(EXEC_Manager.CHAIN_LOG_START);
        System.assert(kLog.message.contains('Start'));
        kLog = EXEC_Factory.getLog(EXEC_Manager.CHAIN_LOG_END);
        System.assert(kLog.message.contains('End'));
        kLog = EXEC_Factory.getLog('for-null');
        System.assert(null == kLog);
    }

    @IsTest
    private static void testIsQueue() {
        System.assert(false == EXEC_Factory.isQueue('a'));
        System.assert(false == EXEC_Factory.isQueue(''));
        System.assert(EXEC_Factory.isQueue('IF_CHINE_NAME'));
        System.assert(EXEC_Factory.isQueue(EXEC_Manager.CHAIN_CALLOUT_SAMPLE));
        System.assert(false == EXEC_Factory.isQueue(EXEC_Manager.CHAIN_BATCH_DELETE_SAMPLE));

        Boolean err = false;
        try {
            System.assert(false == EXEC_Factory.isQueue(null));
        } catch (Exception e) {
            err = true;
        }
        System.assert(err);
    }

    @IsTest
    private static void testIsBatch() {
        System.assert(false == EXEC_Factory.isBatch('a'));
        System.assert(false == EXEC_Factory.isBatch(''));
        System.assert(EXEC_Factory.isBatch('chainBatchName'));
    }

    @IsTest
    private static void testIsBatch2() {
        System.assert(EXEC_Factory.isBatch(EXEC_Manager.CHAIN_BATCH_SAMPLE));
        System.assert(EXEC_Factory.isBatch(EXEC_Manager.CHAIN_BATCH_DELETE_SAMPLE));

        Boolean err = false;
        try {
            System.assert(false == EXEC_Factory.isBatch(null));
        } catch (Exception e) {
            err = true;
        }
        System.assert(err);
    }

    @IsTest
    private static void testGetChain() {
        List<String> chains = new List<String>{
                EXEC_Manager.CHAIN_CALLOUT_SAMPLE
        };
        System.assert(EXEC_Factory.getChain(chains, null, 'prev') instanceof EXEC_ChainEmpty);
        System.assert(EXEC_Factory.getChain(chains, '', 'prev') instanceof EXEC_ChainEmpty);
        System.assert(EXEC_Factory.getChain(chains, ' ', 'prev') instanceof EXEC_ChainEmpty);
        System.assert(EXEC_Factory.getChain(chains, EXEC_Manager.CHAIN_CALLOUT_SAMPLE, 'prev') instanceof EXEC_ChainCallout);
        System.assert(EXEC_Factory.getChain(chains, EXEC_Manager.CHAIN_BATCH_SAMPLE, 'prev') instanceof EXEC_ChainBatch);
        System.assert(EXEC_Factory.getChain(chains, EXEC_Manager.CHAIN_LOG_START, 'prev') instanceof EXEC_ChainLog);
    }
}