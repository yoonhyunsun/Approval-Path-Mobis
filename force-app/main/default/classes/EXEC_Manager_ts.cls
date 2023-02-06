/**
 * Created by hyodongmin on 2022/08/23.
 */

@IsTest
private class EXEC_Manager_ts {
    @IsTest
    private static void testSetChains() {
        EXEC_Manager.replaceChains(new List<String>{ null });
        System.assertEquals(1, EXEC_Manager.getChains().size(), 'Expected 1');
        System.assertEquals(null, EXEC_Manager.getChains()[0], 'Expected null');
    }
    @IsTest
    private static void testNextChain() {
        EXEC_IChain chain;
        
        // log start
        chain = EXEC_Manager.nextChain(EXEC_Manager.getChains(), EXEC_Manager.CHAIN_LOG_START);
//        System.assert(chain instanceof EXEC_ChainCallout, 'Expected true');
        System.assert(chain instanceof EXEC_ChainBatch, 'Expected true');
        
        // callout
//        chain = EXEC_Manager.nextChain(EXEC_Manager.getChains(), EXEC_Manager.CHAIN_CALLOUT_SAMPLE);
//        System.assert(chain instanceof EXEC_ChainBatch, 'Expected true');

        // batch
//        chain = EXEC_Manager.nextChain(EXEC_Manager.getChains(), EXEC_Manager.CHAIN_BATCH_IF_IM_SFDC_ORGMASTER);
//        System.assert(chain instanceof EXEC_ChainBatch, 'Expected true');
//        System.assertEquals(EXEC_Manager.CHAIN_BATCH_IF_IM_SFDC_ORGMASTER2, ((EXEC_ChainBatch)chain).chainName);  // 순서 중요!!
//
//        chain = EXEC_Manager.nextChain(EXEC_Manager.getChains(), EXEC_Manager.CHAIN_BATCH_IF_IM_SFDC_ORGMASTER2);
//        System.assert(chain instanceof EXEC_ChainBatch, 'Expected true');
//        System.assertEquals(EXEC_Manager.CHAIN_BATCH_IF_IM_SFDC_HRMASTER, ((EXEC_ChainBatch)chain).chainName);  // 순서 중요!!
//
//        chain = EXEC_Manager.nextChain(EXEC_Manager.getChains(), EXEC_Manager.CHAIN_BATCH_IF_IM_SFDC_HRMASTER);
//        System.assert(chain instanceof EXEC_ChainBatch, 'Expected true');
//        System.assertEquals(EXEC_Manager.CHAIN_BATCH_IF_IM_SFDC_ORG_V2, ((EXEC_ChainBatch)chain).chainName);  // 순서 중요!!

        chain = EXEC_Manager.nextChain(EXEC_Manager.getChains(), EXEC_Manager.CHAIN_BATCH_IF_IM_SFDC_ORG_V2);
        System.assert(chain instanceof EXEC_ChainBatch, 'Expected true');
        System.assertEquals(EXEC_Manager.CHAIN_BATCH_IF_IM_SFDC_ORG_V2_2, ((EXEC_ChainBatch)chain).chainName);  // 순서 중요!!

        chain = EXEC_Manager.nextChain(EXEC_Manager.getChains(), EXEC_Manager.CHAIN_BATCH_IF_IM_SFDC_ORG_V2_2);
        System.assert(chain instanceof EXEC_ChainBatch, 'Expected true');
        System.assertEquals(EXEC_Manager.CHAIN_BATCH_IF_IM_SFDC_HRMASTER_V2, ((EXEC_ChainBatch)chain).chainName);  // 순서 중요!!

        chain = EXEC_Manager.nextChain(EXEC_Manager.getChains(), EXEC_Manager.CHAIN_BATCH_IF_IM_SFDC_HRMASTER_V2);
        System.assert(chain instanceof EXEC_ChainBatch, 'Expected true');

        chain = EXEC_Manager.nextChain(EXEC_Manager.getChains(), EXEC_Manager.CHAIN_BATCH_IF_ERP_SFDC_SALES);
        System.assert(chain instanceof EXEC_ChainBatch, 'Expected true');
        chain = EXEC_Manager.nextChain(EXEC_Manager.getChains(), EXEC_Manager.CHAIN_BATCH_IF_ERP_SFDC_OUTPRICE);
        System.assert(chain instanceof EXEC_ChainBatch, 'Expected true');
        chain = EXEC_Manager.nextChain(EXEC_Manager.getChains(), EXEC_Manager.CHAIN_BATCH_IF_ERP_SFDC_EXCHANGE_RATE);
        System.assert(chain instanceof EXEC_ChainBatch, 'Expected true');
        // batch - delete
        chain = EXEC_Manager.nextChain(EXEC_Manager.getChains(), EXEC_Manager.CHAIN_BATCH_DELETE_IF_IM_SFDC_HRMASTER);
        System.assert(chain instanceof EXEC_ChainBatch, 'Expected true');
        chain = EXEC_Manager.nextChain(EXEC_Manager.getChains(), EXEC_Manager.CHAIN_BATCH_DELETE_IF_IM_SFDC_ORGMASTER);
        System.assert(chain instanceof EXEC_ChainBatch, 'Expected true');
        chain = EXEC_Manager.nextChain(EXEC_Manager.getChains(), EXEC_Manager.CHAIN_BATCH_DELETE_IF_ERP_SFDC_SALES);
        System.assert(chain instanceof EXEC_ChainBatch, 'Expected true');
        chain = EXEC_Manager.nextChain(EXEC_Manager.getChains(), EXEC_Manager.CHAIN_BATCH_DELETE_IF_ERP_SFDC_OUTPRICE);
        System.assert(chain instanceof EXEC_ChainBatch, 'Expected true');
        chain = EXEC_Manager.nextChain(EXEC_Manager.getChains(), EXEC_Manager.CHAIN_BATCH_DELETE_IF_ERP_SFDC_EXCHANGE_RATE);
        System.assert(chain instanceof EXEC_ChainLog, 'Expected true');
        
        // log end
        chain = EXEC_Manager.nextChain(EXEC_Manager.getChains(), EXEC_Manager.CHAIN_LOG_END);
        System.assert(chain instanceof EXEC_ChainEmpty, 'Expected true');

        // empty
        chain = EXEC_Manager.nextChain(EXEC_Manager.getChains(), 'asdf');
        System.assert(chain instanceof EXEC_ChainEmpty, 'Expected true');
        chain = EXEC_Manager.nextChain(EXEC_Manager.getChains(), null);
        System.assert(chain instanceof EXEC_ChainEmpty, 'Expected true');
    }
    @IsTest
    private static void testChainValid() {
        List<String> chains = EXEC_Manager.getChains();
        EXEC_IChain chain;
        chain = EXEC_Manager.first();
        System.assert(null != chain, 'Expected not null');

        // 체인이 나열된 객체들이 모두 팩토리에서 반환되는지 확인
        for (String chainName : chains) {
            System.debug('chainName => ' + chainName);
            if (EXEC_Factory.isBatch(chainName)) {
                System.assert(null != EXEC_Factory.getBatch(chainName), 'Expected not null');
            } else if (EXEC_Factory.isQueue(chainName)) {
                System.assert(null != EXEC_Factory.getWebCallout(chainName), 'Expected not null');
            } else {
                System.assert(null != EXEC_Factory.getLog(chainName), 'Expected not null');
            }
        }
    }
    @IsTest
    private static void testFirst() {
        EXEC_IChain chain;
        chain = EXEC_Manager.first();
        System.assertEquals(EXEC_Manager.CHAIN_LOG_START, chain.getChainName(), 'Expected EXEC_Manager.CHAIN_LOG_START');
    }
    @IsTest
    private static void testGetNextChainName() {
        List<String> chains = new List<String>{ 'a', 'b', 'c', 'd' };
        System.assertEquals('b', EXEC_Manager.getNextChainName(chains, 'a'), 'Expected b');
        System.assertEquals('c', EXEC_Manager.getNextChainName(chains, 'b'), 'Expected c');
        System.assertEquals('d', EXEC_Manager.getNextChainName(chains, 'c'), 'Expected d');
        System.assertEquals(null, EXEC_Manager.getNextChainName(chains, 'd'), 'Expected null');
        System.assertEquals(null, EXEC_Manager.getNextChainName(chains, 'F'), 'Expected null');
        System.assertEquals(null, EXEC_Manager.getNextChainName(chains, ''), 'Expected null');
    }

    @IsTest
    private static void testWebCalloutResult() {
        EXEC_Manager.CalloutResult result = new EXEC_Manager.CalloutResult(0, '');
        System.assertEquals(0, result.code, 'Expected 0');
        System.assertEquals('', result.message, 'Expected empty');
    }

    @IsTest
    private static void testChainLog() {
        EXEC_Manager.ChainLog kLog = new EXEC_Manager.ChainLog('msg');
        System.assertEquals('msg', kLog.message, 'Expected msg');
    }
}