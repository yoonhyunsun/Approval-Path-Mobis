/**
 * '환률(일별,월별)' 인터페이스 (IF_ERP_EXCHANGE01)
 *
 * Created by hyodongmin on 2022/08/24.
 */

public with sharing class IF_ERP_SFDC_EXCHANGE_RATE extends IF_Inbound {

    // ***************************************
    // Own data class
    // ***************************************
    public virtual class DataExchangeRate2 extends IF_Abstract.T_DATA {
        public String DATUM;    // 기준일자;
        public String GUBUN;    // 환율구분(1:매매기준율,2:비고시환율,3:월평균환율);
        public String WAERS;    // 통화 키 (CD:1080);
        public String CHKYN;    // X : 적용 / space :미적용;
        public String STAND;    // 매매 기준율;
        public String CSEL;     // 외국환 매도율;
        public String CBUY;     // 외국환 매입율;
        public String TSEL;     // T/ T매도율;
        public String TBUY;     // T/T 매입율;
        public String TCHG;     // 외화수표;
        public String USCHG;    // 대미 환산율(0.000000);
        public String CHGRE;    // 환가료(000.0000);
        public String SDATE;    // 등록일자
    }

    // ***************************************
    // Override
    // ***************************************

    public override void process(IF_Abstract.InputAbstract aInput, IF_Abstract.OutputAbstract aOutput) {
        IF_Abstract.InputPayload kInputPayload = (IF_Abstract.InputPayload) aInput.getPayload();
//        IF_Abstract.OutputPayload kOutputPayload = (IF_Abstract.OutputPayload) aOutput.getPayload();

        if (null != kInputPayload.t_data) {
            List<IF_ERP_SFDC_EXCHANGE_RATE__c> kList = new List<IF_ERP_SFDC_EXCHANGE_RATE__c>();
            for (Object kObj : kInputPayload.t_data) {
                DataExchangeRate2 kData = (DataExchangeRate2) kObj;

                IF_ERP_SFDC_EXCHANGE_RATE__c kMaster = new IF_ERP_SFDC_EXCHANGE_RATE__c();
                kMaster.DATUM__c = kData.DATUM;
                kMaster.GUBUN__c = kData.GUBUN;
                kMaster.WAERS__c = kData.WAERS;
                kMaster.CHKYN__c = kData.CHKYN;
                kMaster.STAND_NUM__c = kData.STAND;
                kMaster.CSEL_NUM__c = kData.CSEL;
                kMaster.CBUY_NUM__c = kData.CBUY;
                kMaster.TSEL_NUM__c = kData.TSEL;
                kMaster.TBUY_NUM__c = kData.TBUY;
                kMaster.TCHG_NUM__c = kData.TCHG;
                kMaster.USCHG_NUM__c = kData.USCHG;
                kMaster.CHGRE_NUM__c = kData.CHGRE;
                kMaster.SDATE__c = kData.SDATE;
                kList.add(kMaster);
            }
            insert kList;
        }
    }

    public override String getIfId() {
        return IF_FACTORY.IF_ERP_SFDC_EXCHANGE_RATE;
    }

    public override IF_Abstract.T_DATA deserializeOne(String aJson) {
        return (DataExchangeRate2) JSON.deserialize(aJson, DataExchangeRate2.class);
    }
}