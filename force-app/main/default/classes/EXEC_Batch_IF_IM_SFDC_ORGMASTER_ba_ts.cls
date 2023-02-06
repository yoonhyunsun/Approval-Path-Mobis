/**
 * Created by hyodongmin on 2022/09/07.
 */

@IsTest
private class EXEC_Batch_IF_IM_SFDC_ORGMASTER_ba_ts {
    @IsTest
    static void testBehavior() {
        EXEC_Batch_IF_IM_SFDC_ORGMASTER_ba ba = new EXEC_Batch_IF_IM_SFDC_ORGMASTER_ba();
        Database.QueryLocator kQueryLocator = ba.start(new TestContext());
        System.assertEquals('SELECT Id, BranchCode__c, BranchName__c, ParObjid__c, Objid__c, Stext__c, ' +
                'IsDisplay__c, Depth__c, MgrId__c FROM IF_IM_SFDC_ORGMASTER__c WHERE DUMMY_STATUS__c = NULL', kQueryLocator.getQuery());
    }

    @IsTest
    static void testExecute() {
        EXEC_Batch_IF_IM_SFDC_ORGMASTER_ba ba = new EXEC_Batch_IF_IM_SFDC_ORGMASTER_ba();
        ba.start(new TestContext());


        List<IF_IM_SFDC_ORGMASTER__c> kDummyList = new List<IF_IM_SFDC_ORGMASTER__c>{
                new IF_IM_SFDC_ORGMASTER__c(
                        BranchCode__c = 'a', BranchName__c = 'aa', Objid__c = '1', Stext__c = '11', IsDisplay__c = 'Y',
                        Depth__c = '6', MgrId__c = '6666'
                )
        };
        insert kDummyList;

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
        System.assertEquals('11', kDepartment.Name);
        System.assertEquals(6, kDepartment.DepartmentLevel__c);
        System.assertEquals('6666', kDepartment.ManagerNumber__c);
        System.assertEquals(true, kDepartment.IsDisplay__c);
        System.assertEquals(EXEC_Util.toUniqueKey('a', '1'), kDepartment.Department_Number__c);

        // dummy status 업데이트 확인
        kDummyList = [SELECT DUMMY_STATUS__c FROM IF_IM_SFDC_ORGMASTER__c WHERE DUMMY_STATUS__c = 'C']; // DUMMY_STATUS_CONTINUE
        System.assertEquals(1, kDummyList.size());
    }

    @IsTest
    static void testExecuteException() {

        EXEC_Batch_IF_IM_SFDC_ORGMASTER_ba ba = new EXEC_Batch_IF_IM_SFDC_ORGMASTER_ba();
        ba.start(new TestContext());

        ba.execute(new TestContext(), null);    // for coverage
    }

    @IsTest
    static void testMapDummyToDepartment() {
        EXEC_Batch_IF_IM_SFDC_ORGMASTER_ba ba = new EXEC_Batch_IF_IM_SFDC_ORGMASTER_ba();

        IF_IM_SFDC_ORGMASTER__c kDummy =  new IF_IM_SFDC_ORGMASTER__c(
                BranchCode__c = 'a', BranchName__c = 'aa', Objid__c = '1', Stext__c = '11', IsDisplay__c = 'Y',
                Depth__c = '6', MgrId__c = '6666'
        );

        // Department__c 입력 확인
        Department__c kDepartment = ba.mapDummyToDepartment(kDummy);

        System.assertEquals('a', kDepartment.BranchCode__c);
        System.assertEquals('aa', kDepartment.BranchName__c);
        System.assertEquals(null, kDepartment.ParentDepartment__c);
        System.assertEquals('1', kDepartment.DepartmentCode__c);
        System.assertEquals('11', kDepartment.Name);
        System.assertEquals(6, kDepartment.DepartmentLevel__c);
        System.assertEquals('6666', kDepartment.ManagerNumber__c);
        System.assertEquals(true, kDepartment.IsDisplay__c);
        System.assertEquals(EXEC_Util.toUniqueKey('a', '1'), kDepartment.Department_Number__c);

        // dummy status 업데이트 확인
        System.assertEquals(BatchBase.DUMMY_STATUS_INPUT, kDummy.DUMMY_STATUS__c);
    }

    @IsTest
    static void testMapDummyToDepartment2() {
        EXEC_Batch_IF_IM_SFDC_ORGMASTER_ba ba = new EXEC_Batch_IF_IM_SFDC_ORGMASTER_ba();

        IF_IM_SFDC_ORGMASTER__c kDummy =  new IF_IM_SFDC_ORGMASTER__c(
                BranchCode__c = 'a', BranchName__c = 'aa', Objid__c = '1', Stext__c = '11', IsDisplay__c = 'Y',
                Depth__c = '', MgrId__c = ''
        );

        System.assertEquals('', kDummy.MgrId__c);

        // Department__c 입력 확인
        Department__c kDepartment = ba.mapDummyToDepartment(kDummy);

        System.assertEquals(null, kDepartment.DepartmentLevel__c);
        System.assertEquals('', kDepartment.ManagerNumber__c);

        kDummy.Depth__c = null;
        kDummy.MgrId__c = null;
        kDepartment = ba.mapDummyToDepartment(kDummy);
        System.assertEquals(null, kDepartment.DepartmentLevel__c);
        System.assertEquals(null, kDepartment.ManagerNumber__c);

        kDummy.Depth__c = 'abc'; // 숫자 아님
        kDepartment = ba.mapDummyToDepartment(kDummy);
        System.assertEquals(null, kDepartment.DepartmentLevel__c);
    }

    @IsTest
    static void testMapDummyToDepartment3() {
        EXEC_Batch_IF_IM_SFDC_ORGMASTER_ba ba = new EXEC_Batch_IF_IM_SFDC_ORGMASTER_ba();

        IF_IM_SFDC_ORGMASTER__c kDummy =  new IF_IM_SFDC_ORGMASTER__c(
                /*BranchCode__c = 'a', BranchName__c = 'aa',*/ Objid__c = '1', Stext__c = '11', IsDisplay__c = 'Y',
                Depth__c = '', MgrId__c = ''
        );

        // Department__c 입력 확인
        Department__c kDepartment = ba.mapDummyToDepartment(kDummy);

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