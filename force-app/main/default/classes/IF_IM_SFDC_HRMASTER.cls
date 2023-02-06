/**
 * '인사' 인터페이스 (VW_HR_MASTER_ALL)
 * 
 * Created by hyodongmin on 2022/08/05.
 */

public inherited sharing class IF_IM_SFDC_HRMASTER extends IF_Inbound {

    // ***************************************
    // Own data class
    // ***************************************
    public virtual class DataHRMaster extends IF_Abstract.T_DATA {
        public String USER_TYPE;           // 사용자구분(EX/HR/GHR/GEX)
        public String USER_ID;             // 사번
        public String USER_NM;             // 이름
        public String USER_ENM;            // 외국이름(영문명또는중국명)
        public String BRANCH_CD;           // 법인코드
        public String BRANCH_NM;           // 법인명
        public String DEPT_CD;             // 부서코드
        public String DEPT_NM;             // 부서명
        public String JW_CD;               // 직위코드
        public String JW_NM;               // 직위명
        public String JC_CD;               // 직책코드
        public String JC_NM;               // 직책명
        public String STATUS;              // 계정상태
        public String RETIRE_DT;           // 퇴직일
        public String RESIDENT_YN;         // 주재원여부
        public String USER_EMAIL;          // 이메일
        public String USER_EMAIL_EXT;      // 외부이메일
        public String USER_MOBILE;         // 휴대폰번호
        public String IFJOBNUMBER;         // 데이터변경일
    }

    // ***************************************
    // Override
    // ***************************************

    public override void process(IF_Abstract.InputAbstract aInput, IF_Abstract.OutputAbstract aOutput) {
        IF_Abstract.InputPayload kInputPayload = (IF_Abstract.InputPayload) aInput.getPayload();
//        IF_Abstract.OutputPayload kOutputPayload = (IF_Abstract.OutputPayload) aOutput.getPayload();

        if(null != kInputPayload.t_data) {
            List<IF_IM_SFDC_HRMASTER__c> kList = new List<IF_IM_SFDC_HRMASTER__c>();
            for (Object kObj :kInputPayload.t_data) {
                DataHRMaster kDataHRMaster = (DataHRMaster) kObj;

                IF_IM_SFDC_HRMASTER__c kHrmaster = new IF_IM_SFDC_HRMASTER__c();
                kHrmaster.UserType__c = kDataHRMaster.USER_TYPE;
                kHrmaster.UserID__c = kDataHRMaster.USER_ID;
                kHrmaster.UserNm__c = kDataHRMaster.USER_NM;
                kHrmaster.UserENm__c = kDataHRMaster.USER_ENM;
                kHrmaster.BranchCd__c = kDataHRMaster.BRANCH_CD;
                kHrmaster.BranchNm__c = kDataHRMaster.BRANCH_NM;
                kHrmaster.DeptCd__c = kDataHRMaster.DEPT_CD;
                kHrmaster.DeptNm__c = kDataHRMaster.DEPT_NM;
                kHrmaster.JwCd__c = kDataHRMaster.JW_CD;
                kHrmaster.JwNm__c = kDataHRMaster.JW_NM;
                kHrmaster.JcCd__c = kDataHRMaster.JC_CD;
                kHrmaster.JcNm__c = kDataHRMaster.JC_NM;
                kHrmaster.Status__c = kDataHRMaster.STATUS;
                kHrmaster.RetireDt__c = kDataHRMaster.RETIRE_DT;
                kHrmaster.IsResidentYn__c = kDataHRMaster.RESIDENT_YN;
                kHrmaster.UserEmail__c = kDataHRMaster.USER_EMAIL;
                kHrmaster.UserEmailExt__c = kDataHRMaster.USER_EMAIL_EXT;
                kHrmaster.UserMobile__c = kDataHRMaster.USER_MOBILE;
                kHrmaster.IfJobNumber__c = kDataHRMaster.IFJOBNUMBER;
                kList.add(kHrmaster);
            }
            insert kList;
        }
    }

    // 인사 데이터는 3000개까지 입력 허용
    protected override Integer limitData(Integer aSize) {
        return 3000;
    }

    public override String getIfId() {
        return IF_FACTORY.IF_IM_SFDC_HRMASTER;
    }

    public override IF_Abstract.T_DATA deserializeOne(String aJson) {
        return (DataHRMaster) JSON.deserialize(aJson, DataHRMaster.class);
    }
}