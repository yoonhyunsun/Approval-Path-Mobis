/**
 * Created by hyodongmin on 2022/08/23.
 */

public with sharing class EXEC_Factory {

    /**
     * WebCallout 을 실행하는 객체 반환
     *
     * @param aChainName  체인 이름
     *
     * @return EXEC_Manager.IChainCallout
     */
    public static EXEC_Manager.IChainCallout getWebCallout(String aChainName) {
        EXEC_Manager.IChainCallout kWebCallout = null;
        IF_OutboundIRequester kRequester = new IF_OutboundBasicRequester(new IF_OutboundBasicAuth());

        if (EXEC_Manager.CHAIN_CALLOUT_SAMPLE.equals(aChainName)) {
            kWebCallout = new EXEC_ChainCalloutAdapter(new IF_Outbound_sample(kRequester));
        }
        return kWebCallout;
    }

    /**
     * Database.Batchable<SObject> 을 실행하는 객체 반환
     *
     * @param aChainName  체인 이름
     *
     * @return Database.Batchable<SObject>
     */
    public static Database.Batchable<SObject> getBatch(String aChainName) {
        Database.Batchable<SObject> kBatch = null;
        // batch
        if (EXEC_Manager.CHAIN_BATCH_IF_IM_SFDC_ORGMASTER.equals(aChainName)) {
            kBatch = new EXEC_Batch_IF_IM_SFDC_ORGMASTER_ba();
        } else if (EXEC_Manager.CHAIN_BATCH_IF_IM_SFDC_ORGMASTER2.equals(aChainName)) {
            kBatch = new EXEC_Batch_IF_IM_SFDC_ORGMASTER2_ba();
        } else if (EXEC_Manager.CHAIN_BATCH_IF_IM_SFDC_HRMASTER.equals(aChainName)) {
            kBatch = new EXEC_Batch_IF_IM_SFDC_HRMASTER_ba();
        } else if (EXEC_Manager.CHAIN_BATCH_IF_IM_SFDC_ORG_V2.equals(aChainName)) {
            kBatch = new EXEC_Batch_IF_IM_SFDC_ORG_V2_ba();
        } else if (EXEC_Manager.CHAIN_BATCH_IF_IM_SFDC_ORG_V2_2.equals(aChainName)) {
            kBatch = new EXEC_Batch_IF_IM_SFDC_ORG_V2_2_ba();
        } else if (EXEC_Manager.CHAIN_BATCH_IF_IM_SFDC_HRMASTER_V2.equals(aChainName)) {
            kBatch = new EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba();
        } else if (EXEC_Manager.CHAIN_BATCH_IF_ERP_SFDC_SALES.equals(aChainName)) {
            kBatch = new EXEC_Batch_IF_ERP_SFDC_SALES_ba();
        } else if (EXEC_Manager.CHAIN_BATCH_IF_ERP_SFDC_OUTPRICE.equals(aChainName)) {
            kBatch = new EXEC_Batch_IF_ERP_SFDC_OUTPRICE_ba();
        } else if (EXEC_Manager.CHAIN_BATCH_IF_ERP_SFDC_EXCHANGE_RATE.equals(aChainName)) {
            kBatch = new EXEC_Batch_IF_ERP_SFDC_EXCH_RATE_ba();
        } else
                // delete
                if (EXEC_Manager.CHAIN_BATCH_DELETE_IF_IM_SFDC_HRMASTER.equals(aChainName)) {
                    kBatch = new EXEC_Delete_ba('IF_IM_SFDC_HRMASTER__c');
                } else if (EXEC_Manager.CHAIN_BATCH_DELETE_IF_IM_SFDC_ORGMASTER.equals(aChainName)) {
                    kBatch = new EXEC_Delete_ba('IF_IM_SFDC_ORGMASTER__c');
                } else if (EXEC_Manager.CHAIN_BATCH_DELETE_IF_IM_SFDC_HRMASTER_V2.equals(aChainName)) {
                    kBatch = new EXEC_Delete_ba('IF_IM_SFDC_HRMASTER2__c');
                } else if (EXEC_Manager.CHAIN_BATCH_DELETE_IF_IM_SFDC_ORG_V2.equals(aChainName)) {
                    kBatch = new EXEC_Delete_ba('IF_IM_SFDC_ORGMASTER2__c');
                } else if (EXEC_Manager.CHAIN_BATCH_DELETE_IF_ERP_SFDC_SALES.equals(aChainName)) {
                    kBatch = new EXEC_Delete_ba('IF_ERP_SFDC_SALES__c');
                } else if (EXEC_Manager.CHAIN_BATCH_DELETE_IF_ERP_SFDC_OUTPRICE.equals(aChainName)) {
                    kBatch = new EXEC_Delete_ba('IF_ERP_SFDC_OUTPRICE__c');
                } else if (EXEC_Manager.CHAIN_BATCH_DELETE_IF_ERP_SFDC_EXCHANGE_RATE.equals(aChainName)) {
                    kBatch = new EXEC_Delete_ba('IF_ERP_SFDC_EXCHANGE_RATE__c');
                }
        return kBatch;
    }

    /**
     * 로그를 남기는 체인 반환
     *
     * @param aChainName 로그 체인 이름
     *
     * @return EXEC_Manager.ChainLog
     */
    public static EXEC_Manager.ChainLog getLog(String aChainName) {
        EXEC_Manager.ChainLog kLog = null;
        if (EXEC_Manager.CHAIN_LOG_START.equals(aChainName)) {
            kLog = new EXEC_Manager.ChainLog('------------------------- Start chain ----------------------------');
        } else if (EXEC_Manager.CHAIN_LOG_END.equals(aChainName)) {
            kLog = new EXEC_Manager.ChainLog('------------------------- End chain ----------------------------');
        }
        return kLog;
    }

    /**
     * 지정한 이름의 체인을 반환한다.
     *
     * @param aChains 실행할 체인 이름들
     * @param aChainName 체인 이름
     * @param aPrevChainName 이전 체인 이름
     *
     * @return EXEC_IChain
     */
    public static EXEC_IChain getChain(List<String> aChains, String aChainName, String aPrevChainName) {
        if (String.isBlank(aChainName)) {
            // 마지막 이거나 없는 체인 이름일 경우 빈 체인을 반환
            return new EXEC_ChainEmpty(aPrevChainName);
        } else {
            // queue 와 batch 구분
            if (isQueue(aChainName)) {
                return new EXEC_ChainCallout(new EXEC_Delegate(), aChains, IF_Comm.giveAGGR(), aChainName, 1);
            } else if (isBatch(aChainName)) {
                return new EXEC_ChainBatch(new EXEC_Delegate(), aChains, aChainName);
            } else {
                return new EXEC_ChainLog(new EXEC_Delegate(), aChains, aChainName);
            }
        }
    }

    // ***************************************
    // Utils
    // ***************************************
    @TestVisible
    private static Boolean isQueue(String aChainName) {
        //return aChainName.contains('WebCallout');
        return aChainName.contains('IF_');
    }

    @TestVisible
    private static Boolean isBatch(String aChainName) {
        return aChainName.contains('chainBatch');
    }
}