/**
 * Created by hyodongmin on 2022/09/07.
 */

public virtual with sharing class EXEC_Batch_IF_IM_SFDC_ORGMASTER_ba extends BatchBase {

    protected override Database.QueryLocator start2(Database.BatchableContext batchableContext) {
        /*
        아직 처리하지 않은 레코드 반환
         */
        return Database.getQueryLocator('SELECT Id, BranchCode__c, BranchName__c, ParObjid__c, Objid__c, Stext__c, ' +
                'IsDisplay__c, Depth__c, MgrId__c FROM IF_IM_SFDC_ORGMASTER__c WHERE DUMMY_STATUS__c = NULL');
    }

    public override void execute(Database.BatchableContext context, List<SObject> aSObjList) {
        /*
        실 오브젝트에 맵핑하여 입력 DUMMY_STATUS__c = DUMMY_STATUS_INPUT

        upsert 실패시 => DUMMY_STATUS_FAILURE
        성공 -> DUMMY_STATUS_CONTINUE ( 다음 배치에서 상위 부서를 맵핑 할 수 있도록 표시 )
         */

        try {
            List<IF_IM_SFDC_ORGMASTER__c> kDummyList = (List<IF_IM_SFDC_ORGMASTER__c>) aSObjList;

            Map<String, IF_IM_SFDC_ORGMASTER__c> kDummyMap = new Map<String, IF_IM_SFDC_ORGMASTER__c>();
            Map<String, Department__c> kDepartmentMap = new Map<String, Department__c>();
            for (IF_IM_SFDC_ORGMASTER__c kDummy : kDummyList) {

                Department__c kDepartment = mapDummyToDepartment(kDummy);

                kDepartmentMap.put(kDepartment.Department_Number__c, kDepartment);
                kDummyMap.put(kDepartment.Department_Number__c, kDummy);
            }

            Database.UpsertResult[] kResultList = Database.upsert(kDepartmentMap.values(), Department__c.Department_Number__c, false);

            for (Integer i = 0; i < kResultList.size(); ++i) {
                Database.UpsertResult kResult = kResultList[i];
                Department__c kDepartment = kDepartmentMap.values()[i];
                IF_IM_SFDC_ORGMASTER__c kDummy = kDummyMap.get(kDepartment.Department_Number__c);

                persistUpsertResult(kDummy, IF_IM_SFDC_ORGMASTER__c.DUMMY_STATUS__c,  kResult, DUMMY_STATUS_CONTINUE);
            }
            update aSObjList;

        } catch (Exception e) {
            logger.log('Error Msg : ' + e.getMessage());
        }
    }
    @TestVisible
    protected virtual Department__c mapDummyToDepartment(IF_IM_SFDC_ORGMASTER__c kDummy) {
        kDummy.DUMMY_STATUS__c = DUMMY_STATUS_INPUT;

        Department__c kDepartment = new Department__c();
        kDepartment.BranchCode__c = SUtil.orDefault(kDummy.BranchCode__c, '1000');
        kDepartment.BranchName__c = SUtil.orDefault(kDummy.BranchName__c, '본사');
//                kDepartment.ParentDepartment__c = kDummy.ParObjid__c; // EXEC_Batch_IF_IM_SFDC_ORGMASTER2_ba 로 적용

        if(String.isNotBlank(kDummy.Depth__c) && kDummy.Depth__c.isNumeric()) {
            kDepartment.DepartmentLevel__c = Integer.valueOf(kDummy.Depth__c);  // 부서레벨
        }
        kDepartment.ManagerNumber__c = toNull(kDummy.MgrId__c)?.normalizeSpace(); // 부서장사번
        kDepartment.DepartmentCode__c = kDummy.Objid__c;
        kDepartment.Name = kDummy.Stext__c;
        kDepartment.IsDisplay__c = SUtil.isYn(kDummy.IsDisplay__c);
        kDepartment.Department_Number__c = EXEC_Util.toUniqueKey(kDepartment.BranchCode__c, kDepartment.DepartmentCode__c);

        return kDepartment;
    }

    @TestVisible
    protected String toNull(String aStr) {
        return EXEC_Util.toNull(aStr, 'NULL');
    }

}