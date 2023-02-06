/**
 * '조직도' 인터페이스 (VW_ORG_MASTER_MOBIS)
 * 
 * Created by hyodongmin on 2022/08/05.
 */

public inherited sharing class IF_IM_SFDC_ORGMASTER extends IF_Inbound {

    // ***************************************
    // Own data class
    // ***************************************
    public virtual class DataOrgMaster extends IF_Abstract.T_DATA {
        public String BRANCHCODE;	    // 법인코드
        public String OBJID;	    // 부서코드
        public String BRANCHNAME;	    // 법인명
        public String DEPTH;	    // 부서레벨
        public String PAR_OBJID;	    // 상위부서코드
        public String STEXT;	    // 부서이름
        public String MGR_ID;	    // 부서장 사번
        public String DISPLAY;	    // 표시여부
    }

    // ***************************************
    // Override
    // ***************************************

    public override void process(IF_Abstract.InputAbstract aInput, IF_Abstract.OutputAbstract aOutput) {
        IF_Abstract.InputPayload kInputPayload = (IF_Abstract.InputPayload) aInput.getPayload();
//        IF_Abstract.OutputPayload kOutputPayload = (IF_Abstract.OutputPayload) aOutput.getPayload();

        if (null != kInputPayload.t_data) {
            List<IF_IM_SFDC_ORGMASTER__c> kList = new List<IF_IM_SFDC_ORGMASTER__c>();
            for (Object kObj : kInputPayload.t_data) {
                DataOrgMaster kData = (DataOrgMaster) kObj;

                IF_IM_SFDC_ORGMASTER__c kMaster = new IF_IM_SFDC_ORGMASTER__c();
                kMaster.BranchCode__c = kData.BRANCHCODE;
                kMaster.Objid__c = kData.OBJID;
                kMaster.BranchName__c = kData.BRANCHNAME;
                kMaster.Depth__c = kData.DEPTH;
                kMaster.ParObjid__c = kData.PAR_OBJID;
                kMaster.Stext__c = kData.STEXT;
                kMaster.MgrId__c = kData.MGR_ID;
                kMaster.IsDisplay__c = kData.DISPLAY;
                kList.add(kMaster);
            }
            insert kList;
        }
    }

    public override String getIfId() {
        return IF_FACTORY.IF_IM_SFDC_ORGMASTER;
    }

    public override IF_Abstract.T_DATA deserializeOne(String aJson) {
        return (DataOrgMaster) JSON.deserialize(aJson, DataOrgMaster.class);
    }
}