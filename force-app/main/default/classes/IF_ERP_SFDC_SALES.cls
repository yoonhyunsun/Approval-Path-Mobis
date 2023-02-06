/**
 * '매출' 인터페이스 (ZSD_SEND_CRM_SALES)
 *
 * Created by hyodongmin on 2022/08/24.
 */

public with sharing class IF_ERP_SFDC_SALES extends IF_Inbound {

    // ***************************************
    // Own data class
    // ***************************************
    public virtual class DataSales extends IF_Abstract.T_DATA {
        public String ZSUMGU;       // 집계구분
        public String CALMONTH;     // 년월(YYYYMM)
        public String SPMON;        // 매출발생년월
        public String ZVERS;        // 버전
        public String BUKRS;        // 회사 코드
        public String BUKRS_DESC;       // 회사 코드명
        public String ZPROD;        // 제품
        public String ZPROD_DESC;       // 제품명
        public String ZVEHTY;       // 차종명
        public String PRCTR;        // 손익 센터
        public String ZEDFG;        // 내수/수출 구분
        public String ZEDFG_DESC;       // 내수/수출 구분명
        public String ZKUNTP;       // 고객구분
        public String ZKUNTP_DESC;      // 고객구분명
        public String ZBIZTP;       // 사업구분
        public String ZBIZTP_DESC;      // 사업구분명
        public String ZCOMTP;       // 본사/해외
        public String ZCOMTP_DESC;      // 본사/해외명
        public String ZREGTP;       // 지역구분
        public String ZREGTP_DESC;      // 지역구분명
        public String ZCOPTP;       // 법인구분
        public String ZCOPTP_DESC;      // 법인구분명
        public String ZUSG;     // USG
        public String FKIMG;        // 실제 대금청구 수량
        public String VRKME;        // 판매 단위
        public String DMBTR;        // 금액(현지 통화)
        public String STWAE;        // 현지통화
        public String DMBTR_USD;        // 매출금액(USD)
        public String WAERS_V;      // 통계 통화
    }

    // ***************************************
    // Override
    // ***************************************

    public override void process(IF_Abstract.InputAbstract aInput, IF_Abstract.OutputAbstract aOutput) {
        IF_Abstract.InputPayload kInputPayload = (IF_Abstract.InputPayload) aInput.getPayload();
//        IF_Abstract.OutputPayload kOutputPayload = (IF_Abstract.OutputPayload) aOutput.getPayload();

        if (null != kInputPayload.t_data) {
            List<IF_ERP_SFDC_SALES__c> kList = new List<IF_ERP_SFDC_SALES__c>();
            for (Object kObj : kInputPayload.t_data) {
                DataSales kData = (DataSales) kObj;

                IF_ERP_SFDC_SALES__c kMaster = new IF_ERP_SFDC_SALES__c();
                kMaster.ZSUMGU__c = kData.ZSUMGU;
                kMaster.CALMONTH__c = kData.CALMONTH;
                kMaster.SPMON__c = kData.SPMON;
                kMaster.ZVERS__c = kData.ZVERS;
                kMaster.BUKRS__c = kData.BUKRS;
                kMaster.BUKRS_DESC__c = kData.BUKRS_DESC;
                kMaster.ZPROD__c = kData.ZPROD;
                kMaster.ZPROD_DESC__c = kData.ZPROD_DESC;
                kMaster.ZVEHTY__c = kData.ZVEHTY;
                kMaster.PRCTR__c = kData.PRCTR;
                kMaster.ZEDFG__c = kData.ZEDFG;
                kMaster.ZEDFG_DESC__c = kData.ZEDFG_DESC;
                kMaster.ZKUNTP__c = kData.ZKUNTP;
                kMaster.ZKUNTP_DESC__c = kData.ZKUNTP_DESC;
                kMaster.ZBIZTP__c = kData.ZBIZTP;
                kMaster.ZBIZTP_DESC__c = kData.ZBIZTP_DESC;
                kMaster.ZCOMTP__c = kData.ZCOMTP;
                kMaster.ZCOMTP_DESC__c = kData.ZCOMTP_DESC;
                kMaster.ZREGTP__c = kData.ZREGTP;
                kMaster.ZREGTP_DESC__c = kData.ZREGTP_DESC;
                kMaster.ZCOPTP__c = kData.ZCOPTP;
                kMaster.ZCOPTP_DESC__c = kData.ZCOPTP_DESC;
                kMaster.ZUSG__c = kData.ZUSG;
                kMaster.FKIMG__c = kData.FKIMG;
                kMaster.VRKME__c = kData.VRKME;
                kMaster.DMBTR__c = kData.DMBTR;
                kMaster.STWAE__c = kData.STWAE;
                kMaster.DMBTR_USD__c = kData.DMBTR_USD;
                kMaster.WAERS_V__c = kData.WAERS_V;
                kList.add(kMaster);
            }
            insert kList;
        }
    }

    public override String getIfId() {
        return IF_FACTORY.IF_ERP_SFDC_SALES;
    }

    public override IF_Abstract.T_DATA deserializeOne(String aJson) {
        return (DataSales) JSON.deserialize(aJson, DataSales.class);
    }
}