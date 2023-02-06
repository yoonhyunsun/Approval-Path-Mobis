/**
 * Created by hyodongmin on 2022/09/07.
 */

@IsTest
private class EXEC_Batch_IF_IM_SFDC_HRMASTER_ba_ts {
    @IsTest
    static void testBehavior() {
        EXEC_Batch_IF_IM_SFDC_HRMASTER_ba ba = new EXEC_Batch_IF_IM_SFDC_HRMASTER_ba();
        Database.QueryLocator kQueryLocator = ba.start(new TestContext());
        System.assertEquals('SELECT Id, UserType__c, UserID__c, UserNm__c, UserENm__c, BranchCd__c, BranchNm__c, DeptCd__c, ' +
                'DeptNm__c, JwCd__c, JwNm__c, JcCd__c, JcNm__c, Status__c, RetireDt__c, IsResidentYn__c, UserEmail__c, UserEmailExt__c, ' +
                'UserMobile__c, IfJobNumber__c, FirstName__c, LastName__c FROM IF_IM_SFDC_HRMASTER__c WHERE DUMMY_STATUS__c = NULL', kQueryLocator.getQuery());
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

        EXEC_Batch_IF_IM_SFDC_HRMASTER_ba ba = new EXEC_Batch_IF_IM_SFDC_HRMASTER_ba();
        ba.start(new TestContext());


        List<IF_IM_SFDC_HRMASTER__c> kDummyList = new List<IF_IM_SFDC_HRMASTER__c>{
                new IF_IM_SFDC_HRMASTER__c(
                        UserType__c = 'EX', UserID__c = '1111', UserNm__c = '홍길동', BranchCd__c = 'a', DeptCd__c = '1',
                        JwCd__c = 'aa', JwNm__c = 'bb', JcCd__c = 'cc', JcNm__c = 'dd', Status__c = '0', IsResidentYn__c = 'N',
                        UserEmail__c = 'a@a.bc', UserEmailExt__c = 'ex@a.bc', UserMobile__c = '01012345678', IfJobNumber__c = '20220701011404365f13bfff0-c05f'
                )
        };
        insert kDummyList;

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
        System.assertEquals('1111', kContact.EmployeeKey__c);
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
        System.assertEquals(Date.newInstance(2022, 7, 1), kContact.UpdatedDate__c);
        System.assertEquals(true, kContact.IsEmployee__c);
      //  System.assertEquals(kUser.Id, kContact.UserId__c);

        // dummy status 업데이트 확인
        kDummyList = [SELECT DUMMY_STATUS__c FROM IF_IM_SFDC_HRMASTER__c WHERE DUMMY_STATUS__c = 'S'];
        System.assertEquals(1, kDummyList.size());
    }
    @IsTest
    static void testExecuteBranchCodeNull() {

        Department__c[] kDepartments = new Department__c[]{
                new Department__c(Department_Number__c = EXEC_Util.toUniqueKey('1000', 'AAA'))
        };
        insert kDepartments;

        EXEC_Batch_IF_IM_SFDC_HRMASTER_ba ba = new EXEC_Batch_IF_IM_SFDC_HRMASTER_ba();
        ba.start(new TestContext());

        List<IF_IM_SFDC_HRMASTER__c> kDummyList = new List<IF_IM_SFDC_HRMASTER__c>{
                new IF_IM_SFDC_HRMASTER__c(
                        UserType__c = 'EX', UserID__c = '1111', UserNm__c = '홍길동', BranchCd__c = null, DeptCd__c = 'AAA',
                        JwCd__c = 'aa', JwNm__c = 'bb', JcCd__c = 'cc', JcNm__c = 'dd', Status__c = '0', IsResidentYn__c = 'N',
                        UserEmail__c = 'a@a.bc', UserEmailExt__c = 'ex@a.bc', UserMobile__c = '01012345678', IfJobNumber__c = '20220701011404365f13bfff0-c05f'
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
        EXEC_Batch_IF_IM_SFDC_HRMASTER_ba ba = new EXEC_Batch_IF_IM_SFDC_HRMASTER_ba();
        IF_IM_SFDC_HRMASTER__c kDummy = new IF_IM_SFDC_HRMASTER__c(
        UserType__c = 'EX', UserID__c = '1111', UserNm__c = '홍길동', UserENm__c = 'Hong Gildong', BranchCd__c = '1000', DeptCd__c = '1', FirstName__c = '길동', LastName__c = '홍',
        JwCd__c = 'aa', JwNm__c = 'bb', JcCd__c = 'cc', JcNm__c = 'dd', Status__c = '0', IsResidentYn__c = 'N', RetireDt__c = '20221122',
        UserEmail__c = '', UserEmailExt__c = 'ex@a.bc', UserMobile__c = '01012345678', IfJobNumber__c = '20220701011404365f13bfff0-c05f'
        );
        Id kRecordTypeId = SUtil.getRecordTypeId(Contact.class, 'Employee');

        Map<String, Department__c> kUnique2DepartmentMap = new Map<String, Department__c>();
        kUnique2DepartmentMap.put('1000@1', (Department__c) TestUtil.treatField(new Department__c(Department_Number__c = '1000@1'), 'Id', '01p9D000002zVAW'));
        kUnique2DepartmentMap.put('a@1', (Department__c) TestUtil.treatField(new Department__c(Department_Number__c = 'a@1'), 'Id', '01p9D000002oIBQ'));

        Contact kContact = ba.mapDummyToContact(kDummy, kRecordTypeId, kUnique2DepartmentMap);
        // 국내 이메일
        System.assertEquals('1111@mobis.co.kr', kContact.Email);

        kDummy.BranchCd__c = '2939';
        kContact = ba.mapDummyToContact(kDummy, kRecordTypeId, kUnique2DepartmentMap);
        // 해외 이메일
        System.assertEquals('1111@gmobis.com', kContact.Email);
    }

    @IsTest
    static void testExecuteDateError() {
        Department__c[] kDepartments = new Department__c[]{
                new Department__c(Department_Number__c = EXEC_Util.toUniqueKey('a', '1'))
        };
        insert kDepartments;

        EXEC_Batch_IF_IM_SFDC_HRMASTER_ba ba = new EXEC_Batch_IF_IM_SFDC_HRMASTER_ba();
        ba.start(new TestContext());

        List<IF_IM_SFDC_HRMASTER__c> kDummyList = new List<IF_IM_SFDC_HRMASTER__c>{
                new IF_IM_SFDC_HRMASTER__c(
                        UserType__c = 'EX', UserID__c = '1111', UserNm__c = 'first last', BranchCd__c = 'a', DeptCd__c = '1',
                        JwCd__c = 'aa', JwNm__c = 'bb', JcCd__c = 'cc', JcNm__c = 'dd', Status__c = '0', IsResidentYn__c = 'N',
                        UserEmail__c = 'a@a.b', UserEmailExt__c = 'ex@a.b', UserMobile__c = '01012345678',
                        IfJobNumber__c = 'xxxxxxxx'
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

        EXEC_Batch_IF_IM_SFDC_HRMASTER_ba ba = new EXEC_Batch_IF_IM_SFDC_HRMASTER_ba();
        ba.start(new TestContext());

        List<IF_IM_SFDC_HRMASTER__c> kDummyList = new List<IF_IM_SFDC_HRMASTER__c>{
                new IF_IM_SFDC_HRMASTER__c(
                        UserType__c = 'EX', UserID__c = '1111', UserNm__c = 'first last', BranchCd__c = 'a', DeptCd__c = '1',
                        JwCd__c = 'aa', JwNm__c = 'bb', JcCd__c = 'cc', JcNm__c = 'dd', Status__c = '0', IsResidentYn__c = 'N',
                        UserEmail__c = 'a@a.b', UserEmailExt__c = 'ex@a.b', UserMobile__c = '01012345678',
                        IfJobNumber__c = '99990101'
                )
        };
        insert kDummyList;

        ba.execute(new TestContext(), kDummyList);

        // Contact 입력 확인
        Contact kContact = [SELECT Id, UpdatedDate__c FROM Contact];
        System.assertEquals(Date.valueOf('4000-12-31'), kContact.UpdatedDate__c);
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

        EXEC_Batch_IF_IM_SFDC_HRMASTER_ba ba = new EXEC_Batch_IF_IM_SFDC_HRMASTER_ba();
        ba.start(new TestContext());

        List<IF_IM_SFDC_HRMASTER__c> kDummyList = new List<IF_IM_SFDC_HRMASTER__c>{
                new IF_IM_SFDC_HRMASTER__c(
                        UserType__c = 'EX', UserID__c = '1111', UserNm__c = 'first last', BranchCd__c = 'a', DeptCd__c = '1',
                        JwCd__c = 'aa', JwNm__c = 'bb', JcCd__c = 'cc', JcNm__c = 'dd', Status__c = '0', IsResidentYn__c = 'N',
                        UserEmail__c = 'a@a.b', UserEmailExt__c = 'ex@a.b', UserMobile__c = '0000',
                        IfJobNumber__c = 'xxxxxxxx'
                )
        };
        insert kDummyList;

        ba.execute(new TestContext(), kDummyList);

        // Contact 입력 확인
        Contact kContact = [SELECT Id, Email, ExternalEmail__c, Phone, UserId__c FROM Contact];
        System.assertEquals('1111@gmobis.com', kContact.Email);
        System.assertEquals(null, kContact.ExternalEmail__c);
        System.assertEquals(null, kContact.Phone);
      //  System.assertEquals(kUser.Id, kContact.UserId__c);    // 변환한 이메일을 비교해서 User 입력
    }

    @IsTest
    static void testExecuteException() {

        EXEC_Batch_IF_IM_SFDC_HRMASTER_ba ba = new EXEC_Batch_IF_IM_SFDC_HRMASTER_ba();
        ba.start(new TestContext());

        ba.execute(new TestContext(), null);    // for coverage
    }

    @IsTest
    static void testMapDummyToContact() {
        EXEC_Batch_IF_IM_SFDC_HRMASTER_ba ba = new EXEC_Batch_IF_IM_SFDC_HRMASTER_ba();
        IF_IM_SFDC_HRMASTER__c kDummy = new IF_IM_SFDC_HRMASTER__c(
                UserType__c = 'EX', UserID__c = '1111', UserNm__c = '홍길동', UserENm__c = 'Hong Gildong', BranchCd__c = 'a', DeptCd__c = '1', FirstName__c = '길동', LastName__c = '홍',
                JwCd__c = 'aa', JwNm__c = 'bb', JcCd__c = 'cc', JcNm__c = 'dd', Status__c = '0', IsResidentYn__c = 'N', RetireDt__c = '20221122',
                UserEmail__c = 'a@a.bc', UserEmailExt__c = 'ex@a.bc', UserMobile__c = '01012345678', IfJobNumber__c = '20220701011404365f13bfff0-c05f'
        );
        Id kRecordTypeId = SUtil.getRecordTypeId(Contact.class, 'Employee');

        Map<String, Department__c> kUnique2DepartmentMap = new Map<String, Department__c>();
        kUnique2DepartmentMap.put('1000@1', (Department__c) TestUtil.treatField(new Department__c(Department_Number__c = '1000@1'), 'Id', '01p9D000002zVAW'));
        kUnique2DepartmentMap.put('a@1', (Department__c) TestUtil.treatField(new Department__c(Department_Number__c = 'a@1'), 'Id', '01p9D000002oIBQ'));

        Contact kContact = ba.mapDummyToContact(kDummy, kRecordTypeId, kUnique2DepartmentMap);
// Contact 입력 확인
        System.assertEquals(kRecordTypeId, kContact.RecordTypeId);
        System.assertEquals('EX', kContact.EmployeeType__c);
        System.assertEquals('1111', kContact.EmployeeNumber__c);
        System.assertEquals('1111', kContact.EmployeeKey__c);
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
        System.assertEquals(Date.newInstance(2022, 7, 1), kContact.UpdatedDate__c);
        System.assertEquals(true, kContact.IsEmployee__c);

        // dummy status 업데이트 확인
        System.assertEquals('I', kDummy.DUMMY_STATUS__c);
    }
    @IsTest
    static void testMapDummyToContact2() {
        EXEC_Batch_IF_IM_SFDC_HRMASTER_ba ba = new EXEC_Batch_IF_IM_SFDC_HRMASTER_ba();
        IF_IM_SFDC_HRMASTER__c kDummy = new IF_IM_SFDC_HRMASTER__c(
                UserType__c = 'EX', UserID__c = '1111', UserNm__c = '', UserENm__c = 'Hong Gildong', BranchCd__c = 'a', DeptCd__c = '1', FirstName__c = '길동', LastName__c = '홍',
                JwCd__c = 'aa', JwNm__c = 'bb', JcCd__c = 'cc', JcNm__c = 'dd', Status__c = '0', IsResidentYn__c = 'N', RetireDt__c = 'xxxxxx',
                UserEmail__c = 'a@a.bc', UserEmailExt__c = 'ex@a.bc', UserMobile__c = '01012345678', IfJobNumber__c = '20220701011404365f13bfff0-c05f'
        );
        Id kRecordTypeId = SUtil.getRecordTypeId(Contact.class, 'Employee');

        Map<String, Department__c> kUnique2DepartmentMap = new Map<String, Department__c>();
        kUnique2DepartmentMap.put('1000@1', (Department__c) TestUtil.treatField(new Department__c(Department_Number__c = '1000@1'), 'Id', '01p9D000002zVAW'));

        Contact kContact = ba.mapDummyToContact(kDummy, kRecordTypeId, kUnique2DepartmentMap);
        // 이름이 없다면 외국어 이름을 이용함
        System.assertEquals('', kContact.FirstName);
        System.assertEquals('Hong Gildong', kContact.LastName);
        System.assertEquals('Hong Gildong', kContact.InternationalName__c);

        System.assertEquals(null, kContact.RetiredDate__c); // 날자 변환 실패
    }
    @IsTest
    static void testMapDummyToContact3() {
        EXEC_Batch_IF_IM_SFDC_HRMASTER_ba ba = new EXEC_Batch_IF_IM_SFDC_HRMASTER_ba();
        IF_IM_SFDC_HRMASTER__c kDummy = new IF_IM_SFDC_HRMASTER__c(
                UserType__c = 'EX', UserID__c = '1111', UserNm__c = '홍길동', UserENm__c = '', BranchCd__c = 'a', DeptCd__c = '1', FirstName__c = '길동', LastName__c = '홍',
                JwCd__c = 'aa', JwNm__c = 'bb', JcCd__c = 'cc', JcNm__c = 'dd', Status__c = '0', IsResidentYn__c = 'N', RetireDt__c = 'xxxxxx',
                UserEmail__c = 'a@a.bc', UserEmailExt__c = 'ex@a.bc', UserMobile__c = '01012345678', IfJobNumber__c = '20220701011404365f13bfff0-c05f'
        );
        Id kRecordTypeId = SUtil.getRecordTypeId(Contact.class, 'Employee');

        Map<String, Department__c> kUnique2DepartmentMap = new Map<String, Department__c>();
        kUnique2DepartmentMap.put('1000@1', (Department__c) TestUtil.treatField(new Department__c(Department_Number__c = '1000@1'), 'Id', '01p9D000002zVAW'));

        Contact kContact = ba.mapDummyToContact(kDummy, kRecordTypeId, kUnique2DepartmentMap);
        //외국어 이름 없음
        System.assertEquals('길동', kContact.FirstName);
        System.assertEquals('홍', kContact.LastName);
        System.assertEquals('', kContact.InternationalName__c);

        kDummy.UserENm__c = null;
        kContact = ba.mapDummyToContact(kDummy, kRecordTypeId, kUnique2DepartmentMap);
        System.assertEquals(null, kContact.InternationalName__c);
    }

    @IsTest
    static void testIsNull() {
        System.assertEquals(null, new EXEC_Batch_IF_IM_SFDC_HRMASTER_ba().toNull(null));
        System.assertEquals(null, new EXEC_Batch_IF_IM_SFDC_HRMASTER_ba().toNull('NULL'));
        System.assertEquals('abc', new EXEC_Batch_IF_IM_SFDC_HRMASTER_ba().toNull('abc'));
        System.assertEquals('', new EXEC_Batch_IF_IM_SFDC_HRMASTER_ba().toNull(''));
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
        System.assertEquals(null, new EXEC_Batch_IF_IM_SFDC_HRMASTER_ba().getManualEmail(null, null));
        System.assertEquals(null, new EXEC_Batch_IF_IM_SFDC_HRMASTER_ba().getManualEmail('', ''));
        System.assertEquals('1@mobis.co.kr', new EXEC_Batch_IF_IM_SFDC_HRMASTER_ba().getManualEmail('1', '1000'));
        System.assertEquals('1@gmobis.com', new EXEC_Batch_IF_IM_SFDC_HRMASTER_ba().getManualEmail('1', '2000'));
    }

    @IsTest
    static void testMapUnique2Department() {
        insert new Department__c[]{
                new Department__c(Department_Number__c = EXEC_Util.toUniqueKey('a', '1')),
                new Department__c(Department_Number__c = EXEC_Util.toUniqueKey('a', '2')),
                new Department__c(Department_Number__c = EXEC_Util.toUniqueKey('b', '1')),
                new Department__c(Department_Number__c = EXEC_Util.toUniqueKey('b', '2'))
        };

        List<IF_IM_SFDC_HRMASTER__c> kDummyList = new List<IF_IM_SFDC_HRMASTER__c>{
                new IF_IM_SFDC_HRMASTER__c(BranchCd__c = 'a', DeptCd__c = '1'),
                new IF_IM_SFDC_HRMASTER__c(BranchCd__c = 'a', DeptCd__c = '2'),
                new IF_IM_SFDC_HRMASTER__c(BranchCd__c = 'b', DeptCd__c = '1'),
                new IF_IM_SFDC_HRMASTER__c(BranchCd__c = 'b', DeptCd__c = '2')
        };
        Map<String, Department__c> kUnique2DepartmentMap = EXEC_Batch_IF_IM_SFDC_HRMASTER_ba.mapUnique2Department(kDummyList);

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
        System.assertEquals('name 1', new EXEC_Batch_IF_IM_SFDC_HRMASTER_ba().chooseName('name 1', 'name 2'));
        System.assertEquals('name 1', new EXEC_Batch_IF_IM_SFDC_HRMASTER_ba().chooseName('name 1', ''));
        System.assertEquals('name 1', new EXEC_Batch_IF_IM_SFDC_HRMASTER_ba().chooseName('name 1', null));
        System.assertEquals('name 2', new EXEC_Batch_IF_IM_SFDC_HRMASTER_ba().chooseName('', 'name 2'));
        System.assertEquals('name 2', new EXEC_Batch_IF_IM_SFDC_HRMASTER_ba().chooseName(null, 'name 2'));
        System.assertEquals('', new EXEC_Batch_IF_IM_SFDC_HRMASTER_ba().chooseName('', ''));
    }

    @IsTest
    static void testMapStatus() {
        System.assertEquals('Resigned', new EXEC_Batch_IF_IM_SFDC_HRMASTER_ba().mapStatus('0'));
        System.assertEquals('Long Absence', new EXEC_Batch_IF_IM_SFDC_HRMASTER_ba().mapStatus('1'));
        System.assertEquals('Active', new EXEC_Batch_IF_IM_SFDC_HRMASTER_ba().mapStatus('3'));
        System.assertEquals(null, new EXEC_Batch_IF_IM_SFDC_HRMASTER_ba().mapStatus(''));
        System.assertEquals(null, new EXEC_Batch_IF_IM_SFDC_HRMASTER_ba().mapStatus(null));
    }

}