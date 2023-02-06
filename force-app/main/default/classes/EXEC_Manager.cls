/**
 * Created by hyodongmin on 2022/08/23.
 */

public with sharing class EXEC_Manager {

    // 이름에 'IF_' 포함되어야 queue 와 batch 가 구분되므로 주의
    public final static String CHAIN_CALLOUT_SAMPLE = 'IF_OUTBOUND_SAMPLE';

    public final static String CHAIN_BATCH_SAMPLE = 'chainBatchSample';
    public final static String CHAIN_BATCH_IF_IM_SFDC_ORGMASTER = 'chainBatchIfImSfdcOrgmaster';
    public final static String CHAIN_BATCH_IF_IM_SFDC_ORGMASTER2 = 'chainBatchIfImSfdcOrgmaster2';
    public final static String CHAIN_BATCH_IF_IM_SFDC_HRMASTER = 'chainBatchIfImSfdcHrmaster';
    public final static String CHAIN_BATCH_IF_IM_SFDC_ORG_V2 = 'chainBatchIfImSfdcOrgV2';
    public final static String CHAIN_BATCH_IF_IM_SFDC_ORG_V2_2 = 'chainBatchIfImSfdcOrgV22';
    public final static String CHAIN_BATCH_IF_IM_SFDC_HRMASTER_V2 = 'chainBatchIfImSfdcHrmasterV2';
    public final static String CHAIN_BATCH_IF_ERP_SFDC_SALES = 'chainBatchIfErpSfdcSales';
    public final static String CHAIN_BATCH_IF_ERP_SFDC_OUTPRICE = 'chainBatchIfErpSfdcOutprice';
    public final static String CHAIN_BATCH_IF_ERP_SFDC_EXCHANGE_RATE = 'chainBatchIfErpSfdcExchangeRate';

    public final static String CHAIN_BATCH_DELETE_SAMPLE = 'chainBatchDeleteSample';
    public final static String CHAIN_BATCH_DELETE_IF_IM_SFDC_HRMASTER = 'chainBatchDeleteIfImSfdcHrmaster';
    public final static String CHAIN_BATCH_DELETE_IF_IM_SFDC_ORGMASTER = 'chainBatchDeleteIfImSfdcOrgmaster';
    public final static String CHAIN_BATCH_DELETE_IF_IM_SFDC_HRMASTER_V2 = 'chainBatchDeleteIfImSfdcHrmasterV2';
    public final static String CHAIN_BATCH_DELETE_IF_IM_SFDC_ORG_V2 = 'chainBatchDeleteIfImSfdcOrgV2';
    public final static String CHAIN_BATCH_DELETE_IF_ERP_SFDC_SALES = 'chainBatchDeleteIfErpSfdcSales';
    public final static String CHAIN_BATCH_DELETE_IF_ERP_SFDC_OUTPRICE = 'chainBatchDeleteIfErpSfdcOutprice';
    public final static String CHAIN_BATCH_DELETE_IF_ERP_SFDC_EXCHANGE_RATE = 'chainBatchDeleteIfErpSfdcExchangeRate';

    public final static String CHAIN_LOG_START = 'chainLogStart';
    public final static String CHAIN_LOG_END = 'chainLogEnd';

    // 여기에 나열 되는 순서대로 실행된다.
    static List<String> chains = new List<String>{
            // log start
            CHAIN_LOG_START,

            // web callout
//            CHAIN_CALLOUT_SAMPLE,

            // batch
            CHAIN_BATCH_IF_IM_SFDC_ORG_V2,   // 인사 정보보다 조직 정보가 우선 실행되어야한다.
            CHAIN_BATCH_IF_IM_SFDC_ORG_V2_2,   // 인사 정보보다 조직 정보가 우선 실행되어야한다.
            CHAIN_BATCH_IF_IM_SFDC_HRMASTER_V2,
            CHAIN_BATCH_IF_ERP_SFDC_SALES,
            CHAIN_BATCH_IF_ERP_SFDC_OUTPRICE,
            CHAIN_BATCH_IF_ERP_SFDC_EXCHANGE_RATE,

            // batch - delete
            CHAIN_BATCH_DELETE_IF_IM_SFDC_HRMASTER,
            CHAIN_BATCH_DELETE_IF_IM_SFDC_ORGMASTER,
            CHAIN_BATCH_DELETE_IF_ERP_SFDC_SALES,
            CHAIN_BATCH_DELETE_IF_ERP_SFDC_OUTPRICE,
            CHAIN_BATCH_DELETE_IF_ERP_SFDC_EXCHANGE_RATE,

            // log end
            CHAIN_LOG_END
    };

    /**
     * 체인 실행 순서 변경
     *
     * @param aChains List<String>
     */
    public static void replaceChains(List<String> aChains) {
        chains = aChains;
    }

    /**
     * 다음 실행할 체인 객체를 반환한다.
     *
     * @param aChains 실행할 체인 이름들
     * @param aCurrentChainName 현재 실행한 체인 이름
     *
     * @return EXEC_IChain
     */
    public static EXEC_IChain nextChain(List<String> aChains, String aCurrentChainName) {
        String kNextChainName = getNextChainName(aChains, aCurrentChainName);
        return EXEC_Factory.getChain(aChains, kNextChainName, aCurrentChainName);
    }

    /**
     * 체인의 시작, EXEC_Manager.first().startChain() 으로 실행
     * @return EXEC_IChain 처음 체인
     */
    public static EXEC_IChain first() {
        System.debug(LoggingLevel.WARN, chains);
        return EXEC_Factory.getChain(chains, chains.get(0), 'first()');
    }

    // ***************************************
    // Utils
    // ***************************************
    @TestVisible
    private static String getNextChainName(List<String> chains, String aChainName) {
        Integer kIndex = chains.indexOf(aChainName);
        if (kIndex > -1) {
            ++kIndex;
            if (kIndex < chains.size()) {
                return chains.get(kIndex);
            } /*else {
                // aChainName is last element
            }*/
        }
        return null;
    }

    /**
     * 설정된 체인 순서 배열 반환
     * @return 체인들
     */
    public static List<String> getChains() {
        return chains;
    }

    // ***************************************
    // interface
    // ***************************************

    public interface IChainCallout {
        CalloutResult callout(String aAggregation);
    }

    // ***************************************
    // Inner Class
    // ***************************************
    public class CalloutResult {
        public Integer code = 0;
        public String message = '';
        public CalloutResult(Integer aCode, String aMessage) {
            code = aCode;
            message = aMessage;
        }
    }

    public class ChainLog {
        public final String message;
        public ChainLog(String aMessage) {
            message = aMessage;
        }
    }
}