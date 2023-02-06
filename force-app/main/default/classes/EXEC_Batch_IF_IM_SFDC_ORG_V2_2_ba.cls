/**
 * 조직도의 상위 부서를 맵핑하기 위한 배치.
 * 상위 부서의 Id 가 필요하기 때문에 조직도 입력을 끝내고 처리 중인 (DUMMY_STATUS__c = 'C') 조직도의 상위 부처를 맵핑한다.
 * Created by hyodongmin on 2022/12/26.
 */

public with sharing class EXEC_Batch_IF_IM_SFDC_ORG_V2_2_ba extends BatchBase {

    public override Database.QueryLocator start2(Database.BatchableContext batchableContext) {
        /*
        실 오브젝트에 인서트는 했지만 아직 '상위부서코드' 가 지정되지 않은 레코드
         */
        return Database.getQueryLocator('SELECT BRANCH_CD__c, PARENT_DEPT_CD__c, DEPT_CD__c FROM IF_IM_SFDC_ORGMASTER2__c WHERE DUMMY_STATUS__c = \'C\'');
    }

    public override void execute(Database.BatchableContext context, List<SObject> aSObjList) {
        try {
            List<IF_IM_SFDC_ORGMASTER2__c> kDummyList = (List<IF_IM_SFDC_ORGMASTER2__c>) aSObjList;

            Set<String> kParentCodeSet = new Set<String>();
            for (IF_IM_SFDC_ORGMASTER2__c kDummy : kDummyList) {
                kDummy.DUMMY_STATUS__c = DUMMY_STATUS_INPUT;

                if (String.isNotBlank(kDummy.PARENT_DEPT_CD__c)) {
                    kParentCodeSet.add(EXEC_Util.toUniqueKey('1000', kDummy.BRANCH_CD__c, kDummy.PARENT_DEPT_CD__c));
                }
            }

            // 상위 부서 목록
            List<Department__c> kParentDepartments = [SELECT Id, Department_Number__c FROM Department__c WHERE Department_Number__c IN :kParentCodeSet];

            //prepare map
            Map<String, IF_IM_SFDC_ORGMASTER2__c> kUnique2DummyMap = mapUnique2Dummy(kDummyList);
            Map<String, Department__c> kUnique2parentMap = mapUnique2Department(kParentDepartments);

            List<Department__c> kDepartmentList = new List<Department__c>();
            for (String kUniqueKey : kUnique2DummyMap.keySet()) {
                IF_IM_SFDC_ORGMASTER2__c kDummy = kUnique2DummyMap.get(kUniqueKey);
                Department__c kDepartment = new Department__c(Department_Number__c = kUniqueKey);
                // 상위 부서의 고유 키로 상위 부서 Id 선택, 상위 부서 코드(PARENT_DEPT_CD__c) 가 없는 경우 null 로 설정 됨
                String kUniqueParentKey = EXEC_Util.toUniqueKey('1000', kDummy.BRANCH_CD__c, kDummy.PARENT_DEPT_CD__c);
                kDepartment.ParentDepartment__c = kUnique2parentMap.get(kUniqueParentKey)?.Id;

                kDepartmentList.add(kDepartment);
            }

            Database.UpsertResult[] kResultList = Database.upsert(kDepartmentList, Department__c.Department_Number__c, false);

            for (Integer i = 0; i < kResultList.size(); ++i) {
                Database.UpsertResult kResult = kResultList[i];
                Department__c kDepartment = kDepartmentList[i];
                IF_IM_SFDC_ORGMASTER2__c kDummy = kUnique2DummyMap.get(kDepartment.Department_Number__c);

                persistUpsertResult(kDummy, IF_IM_SFDC_ORGMASTER2__c.DUMMY_STATUS__c, kResult);
            }
            update aSObjList;

        } catch (Exception e) {
            logger.log('Error Msg : ' + e.getMessage());
        }
    }

    @TestVisible
    static Map<String, IF_IM_SFDC_ORGMASTER2__c> mapUnique2Dummy(List<IF_IM_SFDC_ORGMASTER2__c> aDummyList) {
        return (Map<String, IF_IM_SFDC_ORGMASTER2__c>)
                SMapper.toMap(IF_IM_SFDC_ORGMASTER2__c.class, aDummyList, new SMapper.UniqueMapper('1000', IF_IM_SFDC_ORGMASTER2__c.BRANCH_CD__c, IF_IM_SFDC_ORGMASTER2__c.DEPT_CD__c));
    }

    @TestVisible
    static Map<String, Department__c> mapUnique2Department(List<Department__c> aDepartments) {
        return (Map<String, Department__c>) SMapper.toMap(Department__c.class, aDepartments, Department__c.Department_Number__c);
    }
}