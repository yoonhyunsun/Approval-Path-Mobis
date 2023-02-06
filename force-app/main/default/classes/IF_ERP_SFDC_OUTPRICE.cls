/**
 * '가격' 인터페이스 (ZSD_SEND_CRM_GLOBAL_PRICE)
 *
 * Created by hyodongmin on 2022/08/24.
 */

public with sharing class IF_ERP_SFDC_OUTPRICE  extends IF_Inbound {

    // ***************************************
    // Own data class
    // ***************************************
    public virtual class DataOutPrice extends IF_Abstract.T_DATA {
        public String KUNNR;    // 고객 번호
        public String MATNR;    // 자재 번호
        public String DATAB;    // 효력 시작일
        public String LFDID;    // 적용차수
        public String DATBI;    // 효력 종료일
        public String KSCHL;    // 조건 유형
        public String KONWA;    // 비율단위 (통화 또는 %)
        public String KPEIN;    // 조건가격결정단위
        public String KMEIN;    // 조건단위
        public String DMBTR;    // 개당 신규단가
        public String ZIMDCHGCD1;   // 사유코드1
        public String ZAMOUNT1;     // 가격차액1
        public String ZIMDCHGCD2;   // 사유코드2
        public String ZAMOUNT2;     // 가격차액2
        public String ZIMDCHGCD3;   // 사유코드3
        public String ZAMOUNT3;     // 가격차액3
        public String ZIMDCHGCD4;   // 사유코드4
        public String ZAMOUNT4;     // 가격차액4
        public String ZIMDCHGCD5;   // 사유코드5
        public String ZAMOUNT5;     // 가격차액5
        public String ZKUNNC;   // 업체 Code
        public String SPART;    // 제품군
        public String VTEXT;    // 내역
        public String MVGR1;    // 자재그룹 1
        public String BEZEI;    // 모델코드명
        public String ZPRODCD;  // 제품구분코드
        public String ZVEHTY;   // 차종명
        public String MAKTX;    // 자재내역
        public String DMBTR2;   // 기존단가
        public String ZEDFG;    // 내수/수출 구분
        public String NAME1;    // 고객명
        public String ZCONNO;   // 품의번호
        public String ERNAM;    // 오브젝트 생성자 이름
        public String ORGEH;    // 조직 단위
    }

    // ***************************************
    // Override
    // ***************************************

    public override void process(IF_Abstract.InputAbstract aInput, IF_Abstract.OutputAbstract aOutput) {
        IF_Abstract.InputPayload kInputPayload = (IF_Abstract.InputPayload) aInput.getPayload();
//        IF_Abstract.OutputPayload kOutputPayload = (IF_Abstract.OutputPayload) aOutput.getPayload();

        if (null != kInputPayload.t_data) {
            List<IF_ERP_SFDC_OUTPRICE__c> kList = new List<IF_ERP_SFDC_OUTPRICE__c>();
            for (Object kObj : kInputPayload.t_data) {
                DataOutPrice kData = (DataOutPrice) kObj;

                IF_ERP_SFDC_OUTPRICE__c kMaster = new IF_ERP_SFDC_OUTPRICE__c();
                kMaster.KUNNR__c = kData.KUNNR;
                kMaster.MATNR__c = kData.MATNR;
                kMaster.DATAB__c = kData.DATAB;
                kMaster.LFDID__c = kData.LFDID;
                kMaster.DATBI__c = kData.DATBI;
                kMaster.KSCHL__c = kData.KSCHL;
                kMaster.KONWA__c = kData.KONWA;
                kMaster.KPEIN__c = kData.KPEIN;
                kMaster.KMEIN__c = kData.KMEIN;
                kMaster.DMBTR__c = kData.DMBTR;
                kMaster.ZIMDCHGCD1__c = kData.ZIMDCHGCD1;
                kMaster.ZAMOUNT1__c = kData.ZAMOUNT1;
                kMaster.ZIMDCHGCD2__c = kData.ZIMDCHGCD2;
                kMaster.ZAMOUNT2__c = kData.ZAMOUNT2;
                kMaster.ZIMDCHGCD3__c = kData.ZIMDCHGCD3;
                kMaster.ZAMOUNT3__c = kData.ZAMOUNT3;
                kMaster.ZIMDCHGCD4__c = kData.ZIMDCHGCD4;
                kMaster.ZAMOUNT4__c = kData.ZAMOUNT4;
                kMaster.ZIMDCHGCD5__c = kData.ZIMDCHGCD5;
                kMaster.ZAMOUNT5__c = kData.ZAMOUNT5;
                kMaster.ZKUNNC__c = kData.ZKUNNC;
                kMaster.SPART__c = kData.SPART;
                kMaster.VTEXT__c = kData.VTEXT;
                kMaster.MVGR1__c = kData.MVGR1;
                kMaster.BEZEI__c = kData.BEZEI;
                kMaster.ZPRODCD__c = kData.ZPRODCD;
                kMaster.ZVEHTY__c = kData.ZVEHTY;
                kMaster.MAKTX__c = kData.MAKTX;
                kMaster.DMBTR2__c = kData.DMBTR2;
                kMaster.ZEDFG__c = kData.ZEDFG;
                kMaster.NAME1__c = kData.NAME1;
                kMaster.ZCONNO__c = kData.ZCONNO;
                kMaster.ERNAM__c = kData.ERNAM;
                kMaster.ORGEH__c = kData.ORGEH;
                kList.add(kMaster);
            }
            insert kList;
        }
    }

    public override String getIfId() {
        return IF_FACTORY.IF_ERP_SFDC_OUTPRICE;
    }

    public override IF_Abstract.T_DATA deserializeOne(String aJson) {
        return (DataOutPrice) JSON.deserialize(aJson, DataOutPrice.class);
    }
}