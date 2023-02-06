/**
 * Created by hyodongmin on 2022/12/26.
 */

@IsTest
private class EXEC_Batch_IF_IM_SFDC_ORG_V2_2_ba_ts {
    @IsTest
    static void testBehavior() {
        EXEC_Batch_IF_IM_SFDC_ORG_V2_2_ba ba = new EXEC_Batch_IF_IM_SFDC_ORG_V2_2_ba();
        Database.QueryLocator kQueryLocator = ba.start(new TestContext());
        System.assertEquals('SELECT BRANCH_CD__c, PARENT_DEPT_CD__c, DEPT_CD__c FROM IF_IM_SFDC_ORGMASTER2__c WHERE DUMMY_STATUS__c = \'C\'', kQueryLocator.getQuery());
    }

    @IsTest
    static void testExecute() {

        insert new Department__c[]{
                new Department__c(Department_Number__c = EXEC_Util.toUniqueKey('a', '1'),
                        BranchCode__c = 'a', DepartmentCode__c = '1'),
                new Department__c(Department_Number__c = EXEC_Util.toUniqueKey('a', '2'),
                        BranchCode__c = 'a', DepartmentCode__c = '2'),
                new Department__c(Department_Number__c = EXEC_Util.toUniqueKey('b', '1'),
                        BranchCode__c = 'b', DepartmentCode__c = '1'),
                new Department__c(Department_Number__c = EXEC_Util.toUniqueKey('b', '2'),
                        BranchCode__c = 'b', DepartmentCode__c = '2'),
                new Department__c(Department_Number__c = EXEC_Util.toUniqueKey('b', '3'),
                        BranchCode__c = 'b', DepartmentCode__c = '3')
        };
        // 이미 상위 부서가 있는 부서
        insert new Department__c(Department_Number__c = EXEC_Util.toUniqueKey('c', '1'),
                BranchCode__c = 'c', DepartmentCode__c = '1', ParentDepartment__c = [SELECT Id FROM Department__c WHERE Department_Number__c = :EXEC_Util.toUniqueKey('a', '1')].Id);

        System.assertEquals([SELECT Id FROM Department__c WHERE Department_Number__c = :EXEC_Util.toUniqueKey('a', '1')].Id,
                [SELECT ParentDepartment__c FROM Department__c WHERE Department_Number__c = :EXEC_Util.toUniqueKey('c', '1')].ParentDepartment__c);

        EXEC_Batch_IF_IM_SFDC_ORG_V2_2_ba ba = new EXEC_Batch_IF_IM_SFDC_ORG_V2_2_ba();
        ba.start(new TestContext());


        List<IF_IM_SFDC_ORGMASTER2__c> kDummyList = new List<IF_IM_SFDC_ORGMASTER2__c>{
                new IF_IM_SFDC_ORGMASTER2__c(
                        BRANCH_CD__c = 'a', BRANCH_NM__c = 'aa', DEPT_CD__c = '1', DEPT_NM__c = '11', DISPLAY__c = 'Y',
                        PARENT_DEPT_CD__c = '2', DUMMY_STATUS__c = 'C'
                ),
                new IF_IM_SFDC_ORGMASTER2__c(
                        BRANCH_CD__c = 'b', BRANCH_NM__c = 'bb', DEPT_CD__c = '2', DEPT_NM__c = '22', DISPLAY__c = 'Y',
                        PARENT_DEPT_CD__c = '1', DUMMY_STATUS__c = 'C'
                ),
                new IF_IM_SFDC_ORGMASTER2__c(
                        BRANCH_CD__c = 'b', BRANCH_NM__c = 'bb', DEPT_CD__c = '3', DEPT_NM__c = '33', DISPLAY__c = 'Y',
                        PARENT_DEPT_CD__c = null, DUMMY_STATUS__c = 'C'
                ),
                new IF_IM_SFDC_ORGMASTER2__c(    // 기존의 상위 부서를 삭제
                        BRANCH_CD__c = 'c', BRANCH_NM__c = 'cc', DEPT_CD__c = '1', DEPT_NM__c = '1111', DISPLAY__c = 'Y',
                        PARENT_DEPT_CD__c = null, DUMMY_STATUS__c = 'C'
                )
        };
        insert kDummyList;

        ba.execute(new TestContext(), kDummyList);

        // Department__c.ParentDepartment__c 업데이트 확인
        Department__c kDepartment = [
                SELECT Id, ParentDepartment__r.Department_Number__c
                FROM Department__c
                WHERE BranchCode__c = 'a' AND DepartmentCode__c = '1'
                AND Department_Number__c = :EXEC_Util.toUniqueKey('a', '1')
        ];
        // 동일 법인의 상위 부서 Id 가 ParentDepartment__c 에 저장
        System.assertEquals(EXEC_Util.toUniqueKey('a', '2'),
                kDepartment.ParentDepartment__r.Department_Number__c);

        kDepartment = [
                SELECT Id, ParentDepartment__r.Department_Number__c
                FROM Department__c
                WHERE BranchCode__c = 'b' AND DepartmentCode__c = '2'
                AND Department_Number__c = :EXEC_Util.toUniqueKey('b', '2')
        ];
        // 동일 법인의 상위 부서 Id 가 ParentDepartment__c 에 저장
        System.assertEquals(EXEC_Util.toUniqueKey('b', '1'),
                kDepartment.ParentDepartment__r.Department_Number__c);

        kDepartment = [
                SELECT Id, ParentDepartment__c
                FROM Department__c
                WHERE BranchCode__c = 'b' AND DepartmentCode__c = '3'
                AND Department_Number__c = :EXEC_Util.toUniqueKey('b', '3')
        ];
        // 상위 부서 없음
        System.assertEquals(null, kDepartment.ParentDepartment__c);

        kDepartment = [
                SELECT Id, ParentDepartment__c
                FROM Department__c
                WHERE BranchCode__c = 'c' AND DepartmentCode__c = '1'
                AND Department_Number__c = :EXEC_Util.toUniqueKey('c', '1')
        ];
        // 등록돼있던 상위 부서 삭제
        System.assertEquals(null, kDepartment.ParentDepartment__c);


        // dummy status 업데이트 확인
        kDummyList = [SELECT DUMMY_STATUS__c FROM IF_IM_SFDC_ORGMASTER2__c WHERE DUMMY_STATUS__c = 'S'];
        System.assertEquals(4, kDummyList.size());
    }

    @IsTest
    static void testExecuteBranchCodeNull() {

        insert new Department__c[]{
                new Department__c(Department_Number__c = EXEC_Util.toUniqueKey('1000', '1'),
                        BranchCode__c = '1000', DepartmentCode__c = '1'),
                new Department__c(Department_Number__c = EXEC_Util.toUniqueKey('1000', '2'),
                        BranchCode__c = '1000', DepartmentCode__c = '2')
        };

        EXEC_Batch_IF_IM_SFDC_ORG_V2_2_ba ba = new EXEC_Batch_IF_IM_SFDC_ORG_V2_2_ba();
        ba.start(new TestContext());

        List<IF_IM_SFDC_ORGMASTER2__c> kDummyList = new List<IF_IM_SFDC_ORGMASTER2__c>{
                new IF_IM_SFDC_ORGMASTER2__c(
                        BRANCH_CD__c = null, DEPT_CD__c = '1', PARENT_DEPT_CD__c = '2', DUMMY_STATUS__c = 'C'
                )
        };
        insert kDummyList;

        ba.execute(new TestContext(), kDummyList);

        // Department__c.ParentDepartment__c 업데이트 확인
        Department__c kDepartment = [
                SELECT Id, ParentDepartment__r.Department_Number__c
                FROM Department__c
                WHERE Department_Number__c = :EXEC_Util.toUniqueKey('1000', '1')
        ];
        // 기본값 법인의 상위 부서 Id 가 ParentDepartment__c 에 저장
        System.assertEquals(EXEC_Util.toUniqueKey('1000', '2'), kDepartment.ParentDepartment__r.Department_Number__c);

    }

    @IsTest
    static void testExecuteException() {

        EXEC_Batch_IF_IM_SFDC_ORG_V2_2_ba ba = new EXEC_Batch_IF_IM_SFDC_ORG_V2_2_ba();
        ba.start(new TestContext());

        ba.execute(new TestContext(), null);    // for coverage
    }


    class TestContext implements Database.BatchableContext {
        public Id getChildJobId() {
            return '01p9D000002zVAW';
        }
        public Id getJobId() {
            return '01p9D000002oIBQ';
        }
    }
}