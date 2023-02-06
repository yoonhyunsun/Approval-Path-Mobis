/**
 * Created by hyodongmin on 2022/12/26.
 */

public inherited sharing class IF_IM_SFDC_ORGMASTER2 extends IF_Inbound {

    // ***************************************
    // Own data class
    // ***************************************
    public virtual class DataOrgMaster2 extends IF_Abstract.T_DATA {
        public String BRANCH_CD;        // 법인코드
        public String DEPT_CD;        // 부서코드
        public String BRANCH_NM;        // 법인이름
        public String DEPT_NM;        // 부서명
        public String PARENT_DEPT_CD;        // 상위부서코드
        public String DEPT_NM_EN;        // 부서영문명
        public String DEPT_LVL_CD;        // 부서레벨코드
        public String DEPT_LVL_NM;        // 부서레벨명
//        public String ORDER;        // 조직순서
        public String MGR_ID;        // 부서장사번
        public String ENDDT;        // 부서만료일
//        public String IFID;        // I/F 주체
//        public String IFJOBNUMBER;        // 인터페이스 날짜,시간
//        public String CREATETIME;        // 생성일
//        public String UPDATETIME;        // 변경일
        public String DISPLAY;        // 사용여부
        public String PROV_DT;        // 프로비전일자
    }

    // ***************************************
    // Override
    // ***************************************

    public override void process(IF_Abstract.InputAbstract aInput, IF_Abstract.OutputAbstract aOutput) {
        IF_Abstract.InputPayload kInputPayload = (IF_Abstract.InputPayload) aInput.getPayload();
//        IF_Abstract.OutputPayload kOutputPayload = (IF_Abstract.OutputPayload) aOutput.getPayload();

        if (null != kInputPayload.t_data) {
            List<IF_IM_SFDC_ORGMASTER2__c> kList = new List<IF_IM_SFDC_ORGMASTER2__c>();
            for (Object kObj : kInputPayload.t_data) {
                DataOrgMaster2 kData = (DataOrgMaster2) kObj;

                IF_IM_SFDC_ORGMASTER2__c kMaster = new IF_IM_SFDC_ORGMASTER2__c();
                kMaster.BRANCH_CD__c = kData.BRANCH_CD;
                kMaster.DEPT_CD__c = kData.DEPT_CD;
                kMaster.BRANCH_NM__c = kData.BRANCH_NM;
                kMaster.DEPT_NM__c = kData.DEPT_NM;
                kMaster.PARENT_DEPT_CD__c = kData.PARENT_DEPT_CD;
                kMaster.DEPT_NM_EN__c = kData.DEPT_NM_EN;
                kMaster.DEPT_LVL_CD__c = kData.DEPT_LVL_CD;
                kMaster.DEPT_LVL_NM__c = kData.DEPT_LVL_NM;
//                kMaster.ORDER__c = kData.ORDER;
                kMaster.MGR_ID__c = kData.MGR_ID;
                kMaster.ENDDT__c = kData.ENDDT;
//                kMaster.IFID__c = kData.IFID;
//                kMaster.IFJOBNUMBER__c = kData.IFJOBNUMBER;
//                kMaster.CREATETIME__c = kData.CREATETIME;
//                kMaster.UPDATETIME__c = kData.UPDATETIME;
                kMaster.DISPLAY__c = kData.DISPLAY;
                kMaster.PROV_DT__c = kData.PROV_DT;

                kList.add(kMaster);
            }
            insert kList;
        }
    }

    // 조직 데이터는 3000개까지 입력 허용
    protected override Integer limitData(Integer aSize) {
        return 3000;
    }

    public override String getIfId() {
        return IF_FACTORY.IF_IM_SFDC_ORGMASTER2;
    }

    public override IF_Abstract.T_DATA deserializeOne(String aJson) {
        return (DataOrgMaster2) JSON.deserialize(aJson, DataOrgMaster2.class);
    }
}