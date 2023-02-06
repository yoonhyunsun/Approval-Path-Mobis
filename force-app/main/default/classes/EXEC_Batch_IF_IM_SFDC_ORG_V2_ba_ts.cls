/**
 * Created by hyodongmin on 2022/12/26.
 */

@IsTest
private class EXEC_Batch_IF_IM_SFDC_ORG_V2_ba_ts {
    @IsTest
    static void testBehavior() {
        EXEC_Batch_IF_IM_SFDC_ORG_V2_ba ba = new EXEC_Batch_IF_IM_SFDC_ORG_V2_ba();
        Database.QueryLocator kQueryLocator = ba.start(new TestContext());
        System.assertEquals('SELECT Id, BRANCH_CD__c, BRANCH_NM__c, PARENT_DEPT_CD__c, DEPT_CD__c, DEPT_NM__c, DEPT_NM_EN__c, ' +
                'DISPLAY__c, DEPT_LVL_CD__c, MGR_ID__c FROM IF_IM_SFDC_ORGMASTER2__c WHERE DUMMY_STATUS__c = NULL', kQueryLocator.getQuery());
    }

    @IsTest
    static void testExecute() {

        List<IF_IM_SFDC_ORGMASTER2__c> kDummyList = new List<IF_IM_SFDC_ORGMASTER2__c>{
                new IF_IM_SFDC_ORGMASTER2__c(
                        BRANCH_CD__c = 'a', BRANCH_NM__c = 'aa', DEPT_CD__c = '1', DEPT_NM_EN__c = '11', DEPT_NM__c = 'k11',
                        DISPLAY__c = 'Y', DEPT_LVL_CD__c = '6', MGR_ID__c = '6666'
                )
        };
        insert kDummyList;
        EXEC_Batch_IF_IM_SFDC_ORG_V2_ba ba = new EXEC_Batch_IF_IM_SFDC_ORG_V2_ba();
        Database.QueryLocator kQueryLocator = ba.start(new TestContext());  // 필요한 필드가 select 됐는지 확인
        kDummyList = Database.query(kQueryLocator.getQuery());

        ba.execute(new TestContext(), kDummyList);

        // Department__c 입력 확인
        Department__c kDepartment = [
                SELECT Id, BranchCode__c, BranchName__c, ParentDepartment__c, DepartmentCode__c, Name,
                        IsDisplay__c, Department_Number__c, DepartmentLevel__c, ManagerNumber__c
                FROM Department__c
        ];
        System.assertEquals('a', kDepartment.BranchCode__c);
        System.assertEquals('aa', kDepartment.BranchName__c);
        System.assertEquals(null, kDepartment.ParentDepartment__c);
        System.assertEquals('1', kDepartment.DepartmentCode__c);
        System.assertEquals('k11', kDepartment.Name);
        System.assertEquals(6, kDepartment.DepartmentLevel__c);
        System.assertEquals('6666', kDepartment.ManagerNumber__c);
        System.assertEquals(true, kDepartment.IsDisplay__c);
        System.assertEquals(EXEC_Util.toUniqueKey('a', '1'), kDepartment.Department_Number__c);

        // dummy status 업데이트 확인
        kDummyList = [SELECT DUMMY_STATUS__c FROM IF_IM_SFDC_ORGMASTER2__c WHERE DUMMY_STATUS__c = 'C']; // DUMMY_STATUS_CONTINUE
        System.assertEquals(1, kDummyList.size());
    }

    @IsTest
    static void testExecuteException() {

        EXEC_Batch_IF_IM_SFDC_ORG_V2_ba ba = new EXEC_Batch_IF_IM_SFDC_ORG_V2_ba();
        ba.start(new TestContext());

        ba.execute(new TestContext(), null);    // for coverage
    }

    @IsTest
    static void testMapDummyToDepartment() {
        IF_IM_SFDC_ORGMASTER2__c kDummy = new IF_IM_SFDC_ORGMASTER2__c(
                BRANCH_CD__c = 'a', BRANCH_NM__c = 'aa', DEPT_CD__c = '1', DEPT_NM_EN__c = '11', DEPT_NM__c = 'k11',
                DISPLAY__c = 'Y', DEPT_LVL_CD__c = '6', MGR_ID__c = '6666'
        );

        // Department__c 입력 확인
        Department__c kDepartment = EXEC_Batch_IF_IM_SFDC_ORG_V2_ba.mapDummyToDepartment(kDummy);

        System.assertEquals('a', kDepartment.BranchCode__c);
        System.assertEquals('aa', kDepartment.BranchName__c);
        System.assertEquals(null, kDepartment.ParentDepartment__c);
        System.assertEquals('1', kDepartment.DepartmentCode__c);
        System.assertEquals('k11', kDepartment.Name);
        System.assertEquals(6, kDepartment.DepartmentLevel__c);
        System.assertEquals('6666', kDepartment.ManagerNumber__c);
        System.assertEquals(true, kDepartment.IsDisplay__c);
        System.assertEquals(EXEC_Util.toUniqueKey('a', '1'), kDepartment.Department_Number__c);

        // dummy status 업데이트 확인
        System.assertEquals(BatchBase.DUMMY_STATUS_INPUT, kDummy.DUMMY_STATUS__c);
    }

    @IsTest
    static void testMapDummyToDepartment2() {

        IF_IM_SFDC_ORGMASTER2__c kDummy = new IF_IM_SFDC_ORGMASTER2__c(
                BRANCH_CD__c = 'a', BRANCH_NM__c = 'aa', DEPT_CD__c = '1', DEPT_NM_EN__c = '11', DEPT_NM__c = 'k11',
                DISPLAY__c = 'Y', DEPT_LVL_CD__c = '',  MGR_ID__c = ''
        );

        System.assertEquals('', kDummy.MGR_ID__c);

        // Department__c 입력 확인
        Department__c kDepartment = EXEC_Batch_IF_IM_SFDC_ORG_V2_ba.mapDummyToDepartment(kDummy);

        System.assertEquals(null, kDepartment.DepartmentLevel__c);
        System.assertEquals('', kDepartment.ManagerNumber__c);

        kDummy.DEPT_LVL_CD__c = null;
        kDummy.MGR_ID__c = null;
        kDepartment = EXEC_Batch_IF_IM_SFDC_ORG_V2_ba.mapDummyToDepartment(kDummy);
        System.assertEquals(null, kDepartment.DepartmentLevel__c);
        System.assertEquals(null, kDepartment.ManagerNumber__c);

        kDummy.DEPT_LVL_CD__c = 'abc'; // 숫자 아님
        kDepartment = EXEC_Batch_IF_IM_SFDC_ORG_V2_ba.mapDummyToDepartment(kDummy);
        System.assertEquals(null, kDepartment.DepartmentLevel__c);

        kDummy.DEPT_NM_EN__c = ''; // 영문이름 없으면 한글이름 사용
        kDepartment = EXEC_Batch_IF_IM_SFDC_ORG_V2_ba.mapDummyToDepartment(kDummy);
        System.assertEquals('k11', kDepartment.Name);

        kDummy.DEPT_NM_EN__c = 'NULL'; // 영문이름 'NULL' 체크
        kDepartment = EXEC_Batch_IF_IM_SFDC_ORG_V2_ba.mapDummyToDepartment(kDummy);
        System.assertEquals('k11', kDepartment.Name);
    }

    @IsTest
    static void testMapDummyToDepartment3() {
        IF_IM_SFDC_ORGMASTER2__c kDummy = new IF_IM_SFDC_ORGMASTER2__c(
                /*BRANCH_CD__c = 'a', BRANCH_NM__c = 'aa',*/ DEPT_CD__c = '1', DEPT_NM_EN__c = '11', DEPT_NM__c = 'k11',
                DISPLAY__c = 'Y', DEPT_LVL_CD__c = '6',  MGR_ID__c = ''
        );

        // Department__c 입력 확인
        Department__c kDepartment = EXEC_Batch_IF_IM_SFDC_ORG_V2_ba.mapDummyToDepartment(kDummy);

        System.assertEquals('1000', kDepartment.BranchCode__c); // 법인 코드 기본값
        System.assertEquals('본사', kDepartment.BranchName__c);   // 법인 이름 기본값
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