/**
 * Created by hyodongmin on 2022/12/26.
 */

public with sharing class EXEC_Batch_IF_IM_SFDC_ORG_V2_ba extends BatchBase {

    public override Database.QueryLocator start2(Database.BatchableContext batchableContext) {
        /*
        아직 처리하지 않은 레코드 반환
         */
        return Database.getQueryLocator('SELECT Id, BRANCH_CD__c, BRANCH_NM__c, PARENT_DEPT_CD__c, DEPT_CD__c, DEPT_NM__c, DEPT_NM_EN__c, ' +
                'DISPLAY__c, DEPT_LVL_CD__c, MGR_ID__c FROM IF_IM_SFDC_ORGMASTER2__c WHERE DUMMY_STATUS__c = NULL');
    }

    public override void execute(Database.BatchableContext context, List<SObject> aSObjList) {
        /*
        실 오브젝트에 맵핑하여 입력 DUMMY_STATUS__c = DUMMY_STATUS_INPUT

        upsert 실패시 => DUMMY_STATUS_FAILURE
        성공 -> DUMMY_STATUS_CONTINUE ( 다음 배치에서 상위 부서를 맵핑 할 수 있도록 표시 )
         */

        try {
            List<IF_IM_SFDC_ORGMASTER2__c> kDummyList = (List<IF_IM_SFDC_ORGMASTER2__c>) aSObjList;

            Map<String, IF_IM_SFDC_ORGMASTER2__c> kDummyMap = new Map<String, IF_IM_SFDC_ORGMASTER2__c>();
            Map<String, Department__c> kDepartmentMap = new Map<String, Department__c>();
            for (IF_IM_SFDC_ORGMASTER2__c kDummy : kDummyList) {

                Department__c kDepartment = mapDummyToDepartment(kDummy);

                kDepartmentMap.put(kDepartment.Department_Number__c, kDepartment);
                kDummyMap.put(kDepartment.Department_Number__c, kDummy);
            }

            Database.UpsertResult[] kResultList = Database.upsert(kDepartmentMap.values(), Department__c.Department_Number__c, false);

            for (Integer i = 0; i < kResultList.size(); ++i) {
                Database.UpsertResult kResult = kResultList[i];
                Department__c kDepartment = kDepartmentMap.values()[i];
                IF_IM_SFDC_ORGMASTER2__c kDummy = kDummyMap.get(kDepartment.Department_Number__c);

                persistUpsertResult(kDummy, IF_IM_SFDC_ORGMASTER2__c.DUMMY_STATUS__c, kResult, DUMMY_STATUS_CONTINUE);
            }
            update aSObjList;

        } catch (Exception e) {
            logger.log('Error Msg : ' + e.getMessage());
        }
    }
    @TestVisible
    private static Department__c mapDummyToDepartment(IF_IM_SFDC_ORGMASTER2__c kDummy) {
        kDummy.DUMMY_STATUS__c = BatchBase.DUMMY_STATUS_INPUT;

        Department__c kDepartment = new Department__c();
        kDepartment.BranchCode__c = SUtil.orDefault(kDummy.BRANCH_CD__c, '1000');
        kDepartment.BranchName__c = SUtil.orDefault(kDummy.BRANCH_NM__c, '본사');
//                kDepartment.ParentDepartment__c = kDummy.PARENT_DEPT_CD__c; // EXEC_Batch_IF_IM_SFDC_ORG_V2_2_ba 로 적용

        if (String.isNotBlank(kDummy.DEPT_LVL_CD__c) && kDummy.DEPT_LVL_CD__c.isNumeric()) {
            kDepartment.DepartmentLevel__c = Integer.valueOf(kDummy.DEPT_LVL_CD__c);  // 부서레벨
        }
        kDepartment.ManagerNumber__c = toNull(kDummy.MGR_ID__c)?.normalizeSpace(); // 부서장사번
        kDepartment.DepartmentCode__c = kDummy.DEPT_CD__c;
        kDepartment.Name = toNull(kDummy.DEPT_NM__c);
        kDepartment.IsDisplay__c = SUtil.isYn(kDummy.DISPLAY__c);
        kDepartment.Department_Number__c = EXEC_Util.toUniqueKey(kDepartment.BranchCode__c, kDepartment.DepartmentCode__c);

        return kDepartment;
    }

    @TestVisible
    private static String toNull(String aStr) {
        return EXEC_Util.toNull(aStr, 'NULL');
    }
}