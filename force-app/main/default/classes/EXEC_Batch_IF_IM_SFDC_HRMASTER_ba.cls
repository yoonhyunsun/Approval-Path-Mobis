/**
 * Created by hyodongmin on 2022/09/06.
 */

public virtual with sharing class EXEC_Batch_IF_IM_SFDC_HRMASTER_ba extends BatchBase {

    protected override Database.QueryLocator start2(Database.BatchableContext batchableContext) {
        /*
        아직 처리하지 않은 레코드 반환
         */
        return Database.getQueryLocator('SELECT Id, UserType__c, UserID__c, UserNm__c, UserENm__c, BranchCd__c, BranchNm__c, DeptCd__c, ' +
                'DeptNm__c, JwCd__c, JwNm__c, JcCd__c, JcNm__c, Status__c, RetireDt__c, IsResidentYn__c, UserEmail__c, UserEmailExt__c, ' +
                'UserMobile__c, IfJobNumber__c, FirstName__c, LastName__c FROM IF_IM_SFDC_HRMASTER__c WHERE DUMMY_STATUS__c = NULL');
    }

    public override void execute(Database.BatchableContext context, List<SObject> aSObjList) {
        /*
        실 오브젝트에 맵핑하여 입력 DUMMY_STATUS__c = DUMMY_STATUS_INPUT

        upsert 실패시 => DUMMY_STATUS_FAILURE
        성공 -> DUMMY_STATUS_SUCCESS
         */

        try {
            List<IF_IM_SFDC_HRMASTER__c> kDummyList = (List<IF_IM_SFDC_HRMASTER__c>) aSObjList;

            Map<String, Department__c> kUnique2DepartmentMap = mapUnique2Department(kDummyList);

            Map<String, IF_IM_SFDC_HRMASTER__c> kDummyMap = new Map<String, IF_IM_SFDC_HRMASTER__c>();
            Map<String, Contact> kContactMap = new Map<String, Contact>();
            Id kRecordTypeId = SUtil.getRecordTypeId(Contact.class, 'Employee');
            for (IF_IM_SFDC_HRMASTER__c kDummy : kDummyList) {

                Contact kContact = mapDummyToContact(kDummy, kRecordTypeId, kUnique2DepartmentMap);

                kContactMap.put(kContact.EmployeeKey__c, kContact);
                kDummyMap.put(kContact.EmployeeKey__c, kDummy);
            }

            // 이메일 변환 후 User 맵핑 // fixme contact 에 trigger 를 적용하면 이부분은 제거해야한다.
            new SUserContactCoupler().couple(kContactMap.values());

            Database.UpsertResult[] kResultList = Database.upsert(kContactMap.values(), Contact.EmployeeKey__c, false);

            for (Integer i = 0; i < kResultList.size(); ++i) {
                Database.UpsertResult kResult = kResultList[i];
                Contact kContact = kContactMap.values()[i];
                IF_IM_SFDC_HRMASTER__c kDummy = kDummyMap.get(kContact.EmployeeKey__c);

                persistUpsertResult(kDummy, IF_IM_SFDC_HRMASTER__c.DUMMY_STATUS__c, kResult);

            }
            update aSObjList;
        } catch (Exception e) {
            logger.log('Error Msg : ' + e.getMessage());
        }
    }

    @TestVisible
    protected virtual Contact mapDummyToContact(IF_IM_SFDC_HRMASTER__c aDummy, Id aRecordTypeId, Map<String, Department__c> aUnique2DepartmentMap) {
        aDummy.DUMMY_STATUS__c = DUMMY_STATUS_INPUT;

        Contact kContact = new Contact();
        kContact.RecordTypeId = aRecordTypeId;
        kContact.EmployeeType__c = aDummy.UserType__c;  // 사용자구분(EX/HR/GHR/GEX)
        kContact.EmployeeNumber__c = aDummy.UserID__c;  // 사번
        kContact.EmployeeKey__c = aDummy.UserID__c;    // 고유 키, UserType 은 변경 가능한 것으로 보임, 사번만 이용. // EXEC_Util.toUniqueKey(kDummy.UserType__c, kDummy.UserID__c);
        /* 이름 저장 정책
         -> FistName/LastName 은 한글 이름을 우선 선택, 없다면 외국이름을 이용 (외국이름은 LastName 만 이용)
         -> 외국 이름은 별도 필드에 그대로 저장
         */
        String kName = SUtil.orDefault(chooseName(aDummy.UserNm__c, aDummy.UserENm__c), aDummy.UserID__c);
        String[] kNames = EXEC_Util.splitName(kName);
        kContact.FirstName = kNames[0]?.capitalize();             // 이름
        kContact.LastName = kNames[1]?.capitalize();             // 성
        kContact.InternationalName__c = aDummy.UserENm__c;             // 외국 이름 저장
        kContact.EmpDepartment__c = aUnique2DepartmentMap.get(EXEC_Util.toUniqueKey('1000', aDummy.BranchCd__c, aDummy.DeptCd__c))?.Id;  // 부서 Id
        kContact.JobTitleCode__c = toNull(aDummy.JcCd__c);      // 직책코드
        kContact.JobTitle__c = toNull(aDummy.JcNm__c);      // 직책명
        kContact.PositionCode__c = toNull(aDummy.JwCd__c);      // 직위코드
        kContact.PositionName__c = toNull(aDummy.JwNm__c);          // 직위명
        kContact.Status__c = mapStatus(aDummy.Status__c);          // 계정상태
        kContact.IsResident__c = SUtil.isYn(aDummy.IsResidentYn__c);    // 주재원여부
        kContact.RetiredDate__c = SUtil.max(SUtil.min(SUtil.toDate(SUtil.toDateStr(aDummy.RetireDt__c)))); // 퇴직일
        // kDummy.BranchCd__c 로 국내/해외 구분 국내 = 1000, 해외 = 나머지, 별도 필드없이 EmpDepartment__c 로 구분

        /* 암호화 필드 */
        kContact.Email = SUtil.isEmail(aDummy.UserEmail__c) ? aDummy.UserEmail__c : getManualEmail(aDummy.UserID__c, aDummy.BranchCd__c);           // 이메일
        kContact.ExternalEmail__c = SUtil.isEmail(aDummy.UserEmailExt__c) ? aDummy.UserEmailExt__c : null; // 외부이메일
        kContact.MobilePhone = SUtil.isPhone(aDummy.UserMobile__c) ? aDummy.UserMobile__c : null;      // 휴대폰번호
        /* 암호화 필드 */
        kContact.UpdatedDate__c = SUtil.max(SUtil.min(SUtil.toDate(SUtil.toDateStr(aDummy.IfJobNumber__c))));   // 데이터변경일 20220701011404365f13bfff0-c05f
        kContact.IsEmployee__c = true;  // 항상 true
        return kContact;
    }

    @TestVisible
    private static Map<String, Department__c> mapUnique2Department(List<IF_IM_SFDC_HRMASTER__c> aDummyList) {
        // 부서 목록 만들기
        Set<String> kDepartmentKeys = SMapper.toStringSet(
                SMapper.toSet(aDummyList, new SMapper.UniqueSetter('1000', IF_IM_SFDC_HRMASTER__c.BranchCd__c, IF_IM_SFDC_HRMASTER__c.DeptCd__c))
        );

        List<Department__c> kDepartments = [SELECT Id, Department_Number__c FROM Department__c WHERE Department_Number__c IN :kDepartmentKeys];

        return (Map<String, Department__c>) SMapper.toMap(Department__c.class, kDepartments, Department__c.Department_Number__c);
    }

    @TestVisible
    protected String chooseName(String aCandidate1, String aCandidate2) {
        return String.isBlank(aCandidate1) ? aCandidate2 : aCandidate1;
    }

    @TestVisible
    protected String mapStatus(String aStatus) {
        if ('0' == aStatus) {
            return 'Resigned';  // 퇴직
        } else if ('1' == aStatus) {
            return 'Long Absence';  // 휴직
        } else if ('3' == aStatus) {
            return 'Active';    // 재직중
        }
        return null;
    }

    @TestVisible
    protected String toNull(String aStr) {
        return EXEC_Util.toNull(aStr, 'NULL');
    }


    @TestVisible
    protected String getManualEmail(String aEmployeeNumber, String aBranchCode) {
        if (String.isNotBlank(aEmployeeNumber) && String.isNotBlank(aBranchCode)) {
            if('1000' == aBranchCode) {
                return aEmployeeNumber + '@mobis.co.kr';
            } else {
                return aEmployeeNumber + '@gmobis.com';
            }
        }
        return null;
    }

}