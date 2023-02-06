/**
 * Created by hyodongmin on 2022/12/26.
 */

public inherited sharing class IF_IM_SFDC_HRMASTER2 extends IF_Inbound {

    // ***************************************
    // Own data class
    // ***************************************
    public virtual class DataHRMaster2 extends IF_Abstract.T_DATA {
//        public String MOBIS_ID;           // 통합ID	법인코드+사번 => 제거 해당 필드 직접 사용
        public String BRANCH_CD;             // 법인코드	본사 : 1000, hq 법인 : 4200, min
        public String BRANCH_NM;             // 법인명
        public String DOMAIN;            // 국내/해외(IM)	D:한국 F:한국이외
        public String USER_TYPE;           // 계정구분(IM:user_gubun) 	HR:본사, GHR:법인
        public String EMP_GROUP_CD;           // 사용자유형코드(법인)	법인별 코드 상이
        public String EMP_GROUP_NM;             // 사용자유형명(법인)	법인별 코드 상이
        public String EXPAT_YN;             // 주재원여부(IM)	주재원 Y
        public String USER_ID;               // 사번
        public String NAME;               // 이름(기본)
        public String NAME_EN;               // 이름(영문)
        public String NAME_ZH;               // 이름(중문)
        public String NAME_KR;              // 이름(한글)
        public String SHORT_NM;           // 이름약어
        public String STATUS;         // 계정상태	3:재직, 0:퇴직, 1:휴직
        public String RETIRE_DT;          // 퇴직일
        public String RETIRE_EXP_DT;      // 만료예정일
        public String POSITION_CD;         // 직위코드(내부)
        public String POSITION_NM;         // 직위명(내부)
        public String POSITION_OUT_CD;         // 직위코드(외부)
        public String POSITION_OUT_NM;         // 직급명(외부)
        public String DUTY_CD;         // 직급코드(내부)
        public String DUTY_NM;         // 직급명(내부)
        public String DEPT_CD;         // 부서코드
        public String DEPT_NM;         // 부서명(자국어)
        public String PART_CD;         // 부서코드
        public String PART_NM;         // 부서명(영문)
//        public String DEPT_SIL_CD;         // 실코드
//        public String DEPT_DIV_CD;         // 본부코드
//        public String PART_MGR_ID;         // 파트장사번
        public String DEPT_MGR_ID;         // 부서장사번
        public String SIL_MGR_ID;         // 실장사번
        public String EMAIL;         // 이메일(암호화)
        public String EMAIL_EXT;         // 외부이메일(암호화)
        public String MOBILE;         // 휴대폰(암호화)
        public String OFFICE_TEL;         // 사내전화
        public String PROV_DT;         // 프로비전일자(데이터변경일)
    }

    // ***************************************
    // Override
    // ***************************************

    public override void process(IF_Abstract.InputAbstract aInput, IF_Abstract.OutputAbstract aOutput) {
        IF_Abstract.InputPayload kInputPayload = (IF_Abstract.InputPayload) aInput.getPayload();
//        IF_Abstract.OutputPayload kOutputPayload = (IF_Abstract.OutputPayload) aOutput.getPayload();

        if (null != kInputPayload.t_data) {
            List<IF_IM_SFDC_HRMASTER2__c> kList = new List<IF_IM_SFDC_HRMASTER2__c>();
            for (Object kObj : kInputPayload.t_data) {
                DataHRMaster2 kDataHRMaster = (DataHRMaster2) kObj;

                IF_IM_SFDC_HRMASTER2__c kHrmaster = new IF_IM_SFDC_HRMASTER2__c();
//                kHrmaster.MOBIS_ID__c = kDataHRMaster.MOBIS_ID;
                kHrmaster.BRANCH_CD__c = kDataHRMaster.BRANCH_CD;
                kHrmaster.BRANCH_NM__c = kDataHRMaster.BRANCH_NM;
                kHrmaster.DOMAIN__c = kDataHRMaster.DOMAIN;
                kHrmaster.USER_TYPE__c = kDataHRMaster.USER_TYPE;
                kHrmaster.EMP_GROUP_CD__c = kDataHRMaster.EMP_GROUP_CD;
                kHrmaster.EMP_GROUP_NM__c = kDataHRMaster.EMP_GROUP_NM;
                kHrmaster.EXPAT_YN__c = kDataHRMaster.EXPAT_YN;
                kHrmaster.USER_ID__c = kDataHRMaster.USER_ID;
                kHrmaster.NAME__c = kDataHRMaster.NAME;
                kHrmaster.NAME_EN__c = kDataHRMaster.NAME_EN;
                kHrmaster.NAME_ZH__c = kDataHRMaster.NAME_ZH;
                kHrmaster.NAME_KR__c = kDataHRMaster.NAME_KR;
                kHrmaster.SHORT_NM__c = kDataHRMaster.SHORT_NM;
                kHrmaster.STATUS__c = kDataHRMaster.STATUS;
                kHrmaster.RETIRE_DT__c = kDataHRMaster.RETIRE_DT;
                kHrmaster.RETIRE_EXP_DT__c = kDataHRMaster.RETIRE_EXP_DT;
                kHrmaster.POSITION_CD__c = kDataHRMaster.POSITION_CD;
                kHrmaster.POSITION_NM__c = kDataHRMaster.POSITION_NM;
                kHrmaster.POSITION_OUT_CD__c = kDataHRMaster.POSITION_OUT_CD;
                kHrmaster.POSITION_OUT_NM__c = kDataHRMaster.POSITION_OUT_NM;
                kHrmaster.DUTY_CD__c = kDataHRMaster.DUTY_CD;
                kHrmaster.DUTY_NM__c = kDataHRMaster.DUTY_NM;
                kHrmaster.DEPT_CD__c = kDataHRMaster.DEPT_CD;
                kHrmaster.DEPT_NM__c = kDataHRMaster.DEPT_NM;
                kHrmaster.PART_CD__c = kDataHRMaster.PART_CD;
                kHrmaster.PART_NM__c = kDataHRMaster.PART_NM;
//                kHrmaster.DEPT_SIL_CD__c = kDataHRMaster.DEPT_SIL_CD;
//                kHrmaster.DEPT_DIV_CD__c = kDataHRMaster.DEPT_DIV_CD;
//                kHrmaster.PART_MGR_ID__c = kDataHRMaster.PART_MGR_ID;
                kHrmaster.DEPT_MGR_ID__c = kDataHRMaster.DEPT_MGR_ID;
                kHrmaster.SIL_MGR_ID__c = kDataHRMaster.SIL_MGR_ID;
                kHrmaster.EMAIL__c = kDataHRMaster.EMAIL;
                kHrmaster.EMAIL_EXT__c = kDataHRMaster.EMAIL_EXT;
                kHrmaster.MOBILE__c = kDataHRMaster.MOBILE;
                kHrmaster.OFFICE_TEL__c = kDataHRMaster.OFFICE_TEL;
                kHrmaster.PROV_DT__c = kDataHRMaster.PROV_DT;

                kList.add(kHrmaster);
            }
            insert kList;
        }
    }
    protected override void setSuccessResult(IF_Abstract.OutputAbstract aOutput) {
        aOutput.header.ifResult = IF_Base.RESULT_SUCCESS;
        IF_Abstract.InputHeader2 kHeader3 = (IF_Abstract.InputHeader2) aOutput.header;
        kHeader3.SYNC_IP = '';
        kHeader3.SYNC_DT = Datetime.now().format('yyyyMMddHHmmss');
        kHeader3.FLAG = 'Y';
        kHeader3.DESC_reserved916 = 'Success';
    }
    protected override void setFailResult(IF_Abstract.OutputAbstract aOutput, Exception e) {
        IF_Abstract.InputHeader2 kHeader3 = (IF_Abstract.InputHeader2) aOutput.header;
        kHeader3.SYNC_IP = '';
        kHeader3.SYNC_DT = Datetime.now().format('yyyyMMddHHmmss');
        kHeader3.FLAG = 'E';
        kHeader3.DESC_reserved916 = aOutput.header.ifFailMsg;
    }
    protected override void clearResponse(IF_Abstract.OutputAbstract aOutput) {
        aOutput.header.ifResult = null;
        aOutput.header.ifFailMsg = null;
        aOutput.header.ifFailCode = null;
    }

    // 인사 데이터는 3000개까지 입력 허용
    protected override Integer limitData(Integer aSize) {
        return 3000;
    }

    public override String getIfId() {
        return IF_FACTORY.IF_IM_SFDC_HRMASTER2;
    }

    public override IF_Abstract.T_DATA deserializeOne(String aJson) {
        return (DataHRMaster2) JSON.deserialize(aJson, DataHRMaster2.class);
    }
}