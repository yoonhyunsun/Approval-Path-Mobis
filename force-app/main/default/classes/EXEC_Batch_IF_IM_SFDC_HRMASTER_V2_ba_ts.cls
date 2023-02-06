/**
 * Created by hyodongmin on 2022/12/26.
 */

@IsTest
private class EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba_ts {
    @IsTest
    static void testBehavior() {
        EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba ba = new EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba();
        Database.QueryLocator kQueryLocator = ba.start(new TestContext());
        System.assertEquals('SELECT Id, USER_TYPE__c, USER_ID__c, NAME__c, NAME_EN__c, BRANCH_CD__c, BRANCH_NM__c, DEPT_CD__c, ' +
                'DEPT_NM__c, POSITION_CD__c, POSITION_NM__c, DUTY_CD__c, DUTY_NM__c, STATUS__c, RETIRE_DT__c, EXPAT_YN__c, EMAIL__c, ' +
                'EMAIL_EXT__c, MOBILE__c, PROV_DT__c FROM IF_IM_SFDC_HRMASTER2__c WHERE DUMMY_STATUS__c = NULL', kQueryLocator.getQuery());
    }

    @IsTest
    static void testExecute() {
        Profile kProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        User kUser = new User(Alias = 'testUser', Email = 'a@a.bc',
                EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US', ProfileId = kProfile.Id,
                TimeZoneSidKey = 'Asia/Seoul',
                Username = 'testUser@mobis.co.kr.ps');

        insert kUser;

        Department__c[] kDepartments = new Department__c[]{
                new Department__c(Department_Number__c = EXEC_Util.toUniqueKey('a', '1')),
                new Department__c(Department_Number__c = EXEC_Util.toUniqueKey('a', '2'))
        };
        insert kDepartments;

        List<IF_IM_SFDC_HRMASTER2__c> kDummyList = new List<IF_IM_SFDC_HRMASTER2__c>{
                new IF_IM_SFDC_HRMASTER2__c(
                        USER_TYPE__c = 'EX', USER_ID__c = '1111', NAME__c = '홍길동', BRANCH_CD__c = 'a', DEPT_CD__c = '1',
                        POSITION_CD__c = 'aa', POSITION_NM__c = 'bb', DUTY_CD__c = 'cc', DUTY_NM__c = 'dd', STATUS__c = '0', EXPAT_YN__c = 'N',
                        EMAIL__c = 'a@a.bc', EMAIL_EXT__c = 'ex@a.bc', MOBILE__c = '01012345678', PROV_DT__c = '20220701121110'
                )
        };
        insert kDummyList;

        EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba ba = new EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba();
        Database.QueryLocator kQueryLocator = ba.start(new TestContext());  // 필요한 필드가 select 됐는지 확인
        kDummyList = Database.query(kQueryLocator.getQuery());

        ba.execute(new TestContext(), kDummyList);

        // Contact 입력 확인
        Contact kContact = [
                SELECT Id, RecordTypeId, EmployeeType__c, EmployeeNumber__c, EmployeeKey__c, FirstName, LastName, EmpDepartment__c, JobTitleCode__c,
                        JobTitle__c, PositionCode__c, PositionName__c, Status__c, IsResident__c,
                        Email, ExternalEmail__c, MobilePhone, /*Permission__c,*/ UpdatedDate__c, IsEmployee__c, UserId__c
                FROM Contact
        ];
        Id kRecordTypeId = SUtil.getRecordTypeId(Contact.class, 'Employee');
        System.assertEquals(kRecordTypeId, kContact.RecordTypeId);
        System.assertEquals('EX', kContact.EmployeeType__c);
        System.assertEquals('1111', kContact.EmployeeNumber__c);
        System.assertEquals('a1111', kContact.EmployeeKey__c);
        System.assertEquals('길동', kContact.FirstName);
        System.assertEquals('홍', kContact.LastName);

        System.assertEquals(kDepartments[0].Id, kContact.EmpDepartment__c);

        System.assertEquals('aa', kContact.PositionCode__c);
        System.assertEquals('bb', kContact.PositionName__c);
        System.assertEquals('cc', kContact.JobTitleCode__c);
        System.assertEquals('dd', kContact.JobTitle__c);
        System.assertEquals('Resigned', kContact.Status__c);
        System.assertEquals(false, kContact.IsResident__c);
        System.assertEquals('a@a.bc', kContact.Email);
        System.assertEquals('ex@a.bc', kContact.ExternalEmail__c);
        System.assertEquals('01012345678', kContact.MobilePhone);
//        System.assertEquals('Long Absence', kContact.Permission__c);
        System.assertEquals(Datetime.newInstance(2022, 7, 1, 12, 11, 10), kContact.UpdatedDate__c);
        System.assertEquals(true, kContact.IsEmployee__c);
   //     System.assertEquals(kUser.Id, kContact.UserId__c);

        // dummy status 업데이트 확인
        kDummyList = [SELECT DUMMY_STATUS__c FROM IF_IM_SFDC_HRMASTER2__c WHERE DUMMY_STATUS__c = 'S'];
        System.assertEquals(1, kDummyList.size());
    }
    @IsTest
    static void testExecuteBranchCodeNull() {

        Department__c[] kDepartments = new Department__c[]{
                new Department__c(Department_Number__c = EXEC_Util.toUniqueKey('1000', 'AAA'))
        };
        insert kDepartments;

        EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba ba = new EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba();
        ba.start(new TestContext());

        List<IF_IM_SFDC_HRMASTER2__c> kDummyList = new List<IF_IM_SFDC_HRMASTER2__c>{
                new IF_IM_SFDC_HRMASTER2__c(
                        USER_TYPE__c = 'EX', USER_ID__c = '1111', NAME__c = '홍길동', BRANCH_CD__c = null, DEPT_CD__c = 'AAA',
                        POSITION_CD__c = 'aa', POSITION_NM__c = 'bb', DUTY_CD__c = 'cc', DUTY_NM__c = 'dd', STATUS__c = '0', EXPAT_YN__c = 'N',
                        EMAIL__c = 'a@a.bc', EMAIL_EXT__c = 'ex@a.bc', MOBILE__c = '01012345678', PROV_DT__c = '20220701121110'
                )
        };
        insert kDummyList;

        ba.execute(new TestContext(), kDummyList);

        // Contact 입력 확인
        Contact kContact = [SELECT EmpDepartment__c FROM Contact];

        System.assertEquals(kDepartments[0].Id, kContact.EmpDepartment__c);
    }
    @IsTest
    static void testExecuteEmail() {
        EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba ba = new EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba();
        IF_IM_SFDC_HRMASTER2__c kDummy = new IF_IM_SFDC_HRMASTER2__c(
                USER_TYPE__c = 'EX', USER_ID__c = '1111', NAME__c = '홍길동', NAME_EN__c = 'Hong Gildong', BRANCH_CD__c = '1000', DEPT_CD__c = '1',
                POSITION_CD__c = 'aa', POSITION_NM__c = 'bb', DUTY_CD__c = 'cc', DUTY_NM__c = 'dd', STATUS__c = '0', EXPAT_YN__c = 'N', RETIRE_DT__c = '20221122',
                EMAIL__c = '', EMAIL_EXT__c = 'ex@a.bc', MOBILE__c = '01012345678', PROV_DT__c = '20220701121110'
        );
        Id kRecordTypeId = SUtil.getRecordTypeId(Contact.class, 'Employee');

        Map<String, Department__c> kUnique2DepartmentMap = new Map<String, Department__c>();
        kUnique2DepartmentMap.put('1000@1', (Department__c) TestUtil.treatField(new Department__c(Department_Number__c = '1000@1'), 'Id', '01p9D000002zVAW'));
        kUnique2DepartmentMap.put('a@1', (Department__c) TestUtil.treatField(new Department__c(Department_Number__c = 'a@1'), 'Id', '01p9D000002oIBQ'));

        Contact kContact = EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba.mapDummyToContact(kDummy, kRecordTypeId, kUnique2DepartmentMap);
        // 국내 이메일
        System.assertEquals('1111@mobis.co.kr', kContact.Email);

        kDummy.BRANCH_CD__c = '2939';
        kContact = EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba.mapDummyToContact(kDummy, kRecordTypeId, kUnique2DepartmentMap);
        // 해외 이메일
        System.assertEquals('1111@gmobis.com', kContact.Email);
    }

    @IsTest
    static void testExecuteDateError() {
        Department__c[] kDepartments = new Department__c[]{
                new Department__c(Department_Number__c = EXEC_Util.toUniqueKey('a', '1'))
        };
        insert kDepartments;

        EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba ba = new EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba();
        ba.start(new TestContext());

        List<IF_IM_SFDC_HRMASTER2__c> kDummyList = new List<IF_IM_SFDC_HRMASTER2__c>{
                new IF_IM_SFDC_HRMASTER2__c(
                        USER_TYPE__c = 'EX', USER_ID__c = '1111', NAME__c = 'first last', BRANCH_CD__c = 'a', DEPT_CD__c = '1',
                        POSITION_CD__c = 'aa', POSITION_NM__c = 'bb', DUTY_CD__c = 'cc', DUTY_NM__c = 'dd', STATUS__c = '0', EXPAT_YN__c = 'N',
                        EMAIL__c = 'a@a.b', EMAIL_EXT__c = 'ex@a.b', MOBILE__c = '01012345678', PROV_DT__c = 'xxxxxxxx'
                )
        };
        insert kDummyList;

        ba.execute(new TestContext(), kDummyList);

        // Contact 입력 확인
        Contact kContact = [SELECT Id, UpdatedDate__c FROM Contact];
        System.assertEquals(null, kContact.UpdatedDate__c);
    }

    @IsTest
    static void testExecuteDateLimit() {
        Department__c[] kDepartments = new Department__c[]{
                new Department__c(Department_Number__c = EXEC_Util.toUniqueKey('a', '1'))
        };
        insert kDepartments;

        EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba ba = new EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba();
        ba.start(new TestContext());

        List<IF_IM_SFDC_HRMASTER2__c> kDummyList = new List<IF_IM_SFDC_HRMASTER2__c>{
                new IF_IM_SFDC_HRMASTER2__c(
                        USER_TYPE__c = 'EX', USER_ID__c = '1111', NAME__c = 'first last', BRANCH_CD__c = 'a', DEPT_CD__c = '1',
                        POSITION_CD__c = 'aa', POSITION_NM__c = 'bb', DUTY_CD__c = 'cc', DUTY_NM__c = 'dd', STATUS__c = '0', EXPAT_YN__c = 'N',
                        EMAIL__c = 'a@a.b', EMAIL_EXT__c = 'ex@a.b', MOBILE__c = '01012345678', PROV_DT__c = '99990101235959'
                )
        };
        insert kDummyList;

        ba.execute(new TestContext(), kDummyList);

        // Contact 입력 확인
        Contact kContact = [SELECT Id, UpdatedDate__c FROM Contact];
        System.assertEquals(Datetime.valueOfGmt('4000-12-31 00:00:00'), kContact.UpdatedDate__c);
    }

    @IsTest
    static void testExecuteNullFields() {
        Profile kProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        User kUser = new User(Alias = 'testUser', Email = '1111@gmobis.com',
                EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US', ProfileId = kProfile.Id,
                TimeZoneSidKey = 'Asia/Seoul',
                Username = 'testUser@mobis.co.kr.ps');

        insert kUser;
        Department__c[] kDepartments = new Department__c[]{
                new Department__c(Department_Number__c = EXEC_Util.toUniqueKey('a', '1'))
        };
        insert kDepartments;

        EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba ba = new EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba();
        ba.start(new TestContext());

        List<IF_IM_SFDC_HRMASTER2__c> kDummyList = new List<IF_IM_SFDC_HRMASTER2__c>{
                new IF_IM_SFDC_HRMASTER2__c(
                        USER_TYPE__c = 'EX', USER_ID__c = '1111', NAME__c = 'first last', BRANCH_CD__c = 'a', DEPT_CD__c = '1',
                        POSITION_CD__c = 'aa', POSITION_NM__c = 'TEMP', DUTY_CD__c = 'cc', DUTY_NM__c = 'TEMP', STATUS__c = '0', EXPAT_YN__c = 'N',
                        EMAIL__c = 'a@a.b', EMAIL_EXT__c = 'ex@a.b', MOBILE__c = '0000', PROV_DT__c = 'xxxxxxxx'
                )
        };
        insert kDummyList;

        ba.execute(new TestContext(), kDummyList);

        // Contact 입력 확인
        Contact kContact = [SELECT Id, Email, ExternalEmail__c, Phone, UserId__c, JobTitle__c, EmployeeKey__c, PositionName__c FROM Contact];
        System.assertEquals('1111@gmobis.com', kContact.Email);
        System.assertEquals(null, kContact.ExternalEmail__c);
        System.assertEquals(null, kContact.Phone);
        System.assertEquals(null, kContact.JobTitle__c);
        System.assertEquals(null, kContact.PositionName__c);
        System.assertEquals('a1111', kContact.EmployeeKey__c);
       // System.assertEquals(kUser.Id, kContact.UserId__c);    // 변환한 이메일을 비교해서 User 입력
    }

    @IsTest
    static void testExecuteException() {

        EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba ba = new EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba();
        ba.start(new TestContext());

        ba.execute(new TestContext(), null);    // for coverage
    }

    @IsTest
    static void testMapDummyToContact() {
        EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba ba = new EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba();
        IF_IM_SFDC_HRMASTER2__c kDummy = new IF_IM_SFDC_HRMASTER2__c(
                USER_TYPE__c = 'EX', USER_ID__c = '1111', NAME__c = '홍길동', NAME_EN__c = 'Hong Gildong', BRANCH_CD__c = 'a', DEPT_CD__c = '1',
                POSITION_CD__c = 'aa', POSITION_NM__c = 'bb', DUTY_CD__c = 'cc', DUTY_NM__c = 'dd', STATUS__c = '0', EXPAT_YN__c = 'N', RETIRE_DT__c = '20221122',
                EMAIL__c = 'a@a.bc', EMAIL_EXT__c = 'ex@a.bc', MOBILE__c = '01012345678', PROV_DT__c = '20220701121110'
        );
        Id kRecordTypeId = SUtil.getRecordTypeId(Contact.class, 'Employee');

        Map<String, Department__c> kUnique2DepartmentMap = new Map<String, Department__c>();
        kUnique2DepartmentMap.put('1000@1', (Department__c) TestUtil.treatField(new Department__c(Department_Number__c = '1000@1'), 'Id', '01p9D000002zVAW'));
        kUnique2DepartmentMap.put('a@1', (Department__c) TestUtil.treatField(new Department__c(Department_Number__c = 'a@1'), 'Id', '01p9D000002oIBQ'));

        Contact kContact = EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba.mapDummyToContact(kDummy, kRecordTypeId, kUnique2DepartmentMap);
// Contact 입력 확인
        System.assertEquals(kRecordTypeId, kContact.RecordTypeId);
        System.assertEquals('EX', kContact.EmployeeType__c);
        System.assertEquals('1111', kContact.EmployeeNumber__c);
        System.assertEquals('a1111', kContact.EmployeeKey__c);
        System.assertEquals('길동', kContact.FirstName);
        System.assertEquals('홍', kContact.LastName);
        System.assertEquals('Hong Gildong', kContact.InternationalName__c);

        System.assertEquals(kUnique2DepartmentMap.get('a@1').Id, kContact.EmpDepartment__c);

        System.assertEquals('aa', kContact.PositionCode__c);
        System.assertEquals('bb', kContact.PositionName__c);
        System.assertEquals('cc', kContact.JobTitleCode__c);
        System.assertEquals('dd', kContact.JobTitle__c);
        System.assertEquals('Resigned', kContact.Status__c);
        System.assertEquals(false, kContact.IsResident__c);
        System.assertEquals(Date.newInstance(2022, 11, 22), kContact.RetiredDate__c);
        System.assertEquals('a@a.bc', kContact.Email);
        System.assertEquals('ex@a.bc', kContact.ExternalEmail__c);
        System.assertEquals('01012345678', kContact.MobilePhone);
//        System.assertEquals('Long Absence', kContact.Permission__c);
        System.assertEquals(Datetime.newInstance(2022, 7, 1, 12, 11, 10), kContact.UpdatedDate__c);
        System.assertEquals(true, kContact.IsEmployee__c);

        // dummy status 업데이트 확인
        System.assertEquals('I', kDummy.DUMMY_STATUS__c);
    }
    @IsTest
    static void testMapDummyToContact2() {
        EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba ba = new EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba();
        IF_IM_SFDC_HRMASTER2__c kDummy = new IF_IM_SFDC_HRMASTER2__c(
                USER_TYPE__c = 'EX', USER_ID__c = '1111', NAME__c = '', NAME_EN__c = 'Hong Gildong', BRANCH_CD__c = 'a', DEPT_CD__c = '1',
                POSITION_CD__c = 'aa', POSITION_NM__c = 'bb', DUTY_CD__c = 'cc', DUTY_NM__c = 'dd', STATUS__c = '0', EXPAT_YN__c = 'N', RETIRE_DT__c = 'xxxxxx',
                EMAIL__c = 'a@a.bc', EMAIL_EXT__c = 'ex@a.bc', MOBILE__c = '01012345678', PROV_DT__c = '20220701121110'
        );
        Id kRecordTypeId = SUtil.getRecordTypeId(Contact.class, 'Employee');

        Map<String, Department__c> kUnique2DepartmentMap = new Map<String, Department__c>();
        kUnique2DepartmentMap.put('1000@1', (Department__c) TestUtil.treatField(new Department__c(Department_Number__c = '1000@1'), 'Id', '01p9D000002zVAW'));

        Contact kContact = EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba.mapDummyToContact(kDummy, kRecordTypeId, kUnique2DepartmentMap);
        // 이름이 없다면 외국어 이름을 이용함
        System.assertEquals('', kContact.FirstName);
        System.assertEquals('Hong Gildong', kContact.LastName);
        System.assertEquals('Hong Gildong', kContact.InternationalName__c);

        System.assertEquals(null, kContact.RetiredDate__c); // 날자 변환 실패
    }
    @IsTest
    static void testMapDummyToContact3() {
        EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba ba = new EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba();
        IF_IM_SFDC_HRMASTER2__c kDummy = new IF_IM_SFDC_HRMASTER2__c(
                USER_TYPE__c = 'EX', USER_ID__c = '1111', NAME__c = '홍길동', NAME_EN__c = '', BRANCH_CD__c = 'a', DEPT_CD__c = '1',
                POSITION_CD__c = 'aa', POSITION_NM__c = 'bb', DUTY_CD__c = 'cc', DUTY_NM__c = 'dd', STATUS__c = '0', EXPAT_YN__c = 'N', RETIRE_DT__c = 'xxxxxx',
                EMAIL__c = 'a@a.bc', EMAIL_EXT__c = 'ex@a.bc', MOBILE__c = '01012345678', PROV_DT__c = '20220701121110'
        );
        Id kRecordTypeId = SUtil.getRecordTypeId(Contact.class, 'Employee');

        Map<String, Department__c> kUnique2DepartmentMap = new Map<String, Department__c>();
        kUnique2DepartmentMap.put('1000@1', (Department__c) TestUtil.treatField(new Department__c(Department_Number__c = '1000@1'), 'Id', '01p9D000002zVAW'));

        Contact kContact = EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba.mapDummyToContact(kDummy, kRecordTypeId, kUnique2DepartmentMap);
        //외국어 이름 없음
        System.assertEquals('길동', kContact.FirstName);
        System.assertEquals('홍', kContact.LastName);
        System.assertEquals('', kContact.InternationalName__c);

        kDummy.NAME_EN__c = null;
        kContact = EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba.mapDummyToContact(kDummy, kRecordTypeId, kUnique2DepartmentMap);
        System.assertEquals(null, kContact.InternationalName__c);
    }

    @IsTest
    static void testIsNull() {
        System.assertEquals(null, EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba.toNull(null));
        System.assertEquals(null, EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba.toNull('NULL'));
        System.assertEquals('abc', EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba.toNull('abc'));
        System.assertEquals('', EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba.toNull(''));
    }


    class TestContext implements Database.BatchableContext {
        public Id getChildJobId() {
            return '01p9D000002zVAW';
        }
        public Id getJobId() {
            return '01p9D000002oIBQ';
        }
    }
    @IsTest
    static void testGetManualEmail() {
        System.assertEquals(null, EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba.getManualEmail(null, null));
        System.assertEquals(null, EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba.getManualEmail('', ''));
        System.assertEquals('1@mobis.co.kr', EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba.getManualEmail('1', '1000'));
        System.assertEquals('1@gmobis.com', EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba.getManualEmail('1', '2000'));
    }

    @IsTest
    static void testMapUnique2Department() {
        insert new Department__c[]{
                new Department__c(Department_Number__c = EXEC_Util.toUniqueKey('a', '1')),
                new Department__c(Department_Number__c = EXEC_Util.toUniqueKey('a', '2')),
                new Department__c(Department_Number__c = EXEC_Util.toUniqueKey('b', '1')),
                new Department__c(Department_Number__c = EXEC_Util.toUniqueKey('b', '2'))
        };

        List<IF_IM_SFDC_HRMASTER2__c> kDummyList = new List<IF_IM_SFDC_HRMASTER2__c>{
                new IF_IM_SFDC_HRMASTER2__c(BRANCH_CD__c = 'a', DEPT_CD__c = '1'),
                new IF_IM_SFDC_HRMASTER2__c(BRANCH_CD__c = 'a', DEPT_CD__c = '2'),
                new IF_IM_SFDC_HRMASTER2__c(BRANCH_CD__c = 'b', DEPT_CD__c = '1'),
                new IF_IM_SFDC_HRMASTER2__c(BRANCH_CD__c = 'b', DEPT_CD__c = '2')
        };
        Map<String, Department__c> kUnique2DepartmentMap = EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba.mapUnique2Department(kDummyList);

        System.assertEquals(EXEC_Util.toUniqueKey('a', '1'),
                kUnique2DepartmentMap.get(EXEC_Util.toUniqueKey('a', '1')).Department_Number__c);
        System.assertEquals(EXEC_Util.toUniqueKey('a', '2'),
                kUnique2DepartmentMap.get(EXEC_Util.toUniqueKey('a', '2')).Department_Number__c);
        System.assertEquals(EXEC_Util.toUniqueKey('b', '1'),
                kUnique2DepartmentMap.get(EXEC_Util.toUniqueKey('b', '1')).Department_Number__c);
        System.assertEquals(EXEC_Util.toUniqueKey('b', '2'),
                kUnique2DepartmentMap.get(EXEC_Util.toUniqueKey('b', '2')).Department_Number__c);
    }

    @IsTest
    static void testChooseName() {
        System.assertEquals('name 1', EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba.chooseName('name 1', 'name 2'));
        System.assertEquals('name 1', EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba.chooseName('name 1', ''));
        System.assertEquals('name 1', EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba.chooseName('name 1', null));
        System.assertEquals('name 2', EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba.chooseName('', 'name 2'));
        System.assertEquals('name 2', EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba.chooseName(null, 'name 2'));
        System.assertEquals('', EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba.chooseName('', ''));
    }

    @IsTest
    static void testMapStatus() {
        System.assertEquals('Resigned', EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba.mapStatus('0'));
        System.assertEquals('Long Absence', EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba.mapStatus('1'));
        System.assertEquals('Active', EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba.mapStatus('3'));
        System.assertEquals(null, EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba.mapStatus(''));
        System.assertEquals(null, EXEC_Batch_IF_IM_SFDC_HRMASTER_V2_ba.mapStatus(null));
    }
}