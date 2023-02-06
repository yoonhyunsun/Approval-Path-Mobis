/**
 * Created by hyodongmin on 2022/07/28.
 */

@IsTest
private class IF_Util_ts {

    @IsTest
    private static void testLogSimple() {
        IF_Util.logSimple('name', 'text', null);

        List<IF_LOG__c> kLogs = [SELECT Id, OERRORTEXT__c FROM IF_LOG__c WHERE IFID__c = 'name'];

        System.assertEquals(1, kLogs.size());
        System.assertEquals('text', kLogs[0].OERRORTEXT__c);
    }
    @IsTest
    static void testSendEmailIfError() {
        Integer emailInvocationsBefore = Limits.getEmailInvocations();
        System.assertEquals(0, emailInvocationsBefore, 'Expected 0');

        Test.startTest();
        IF_Util.sendEmailIfError(new IF_Util(), 'Test Error Occurred');
        Integer emailInvocations = Limits.getEmailInvocations();
        Test.stopTest();

        System.assertEquals(1, emailInvocations, 'An email should be sent');
    }

    @IsTest
    static void testSendEmailIfErrorBlank() {
        Test.startTest();
        IF_Util.sendEmailIfError(new IF_Util(), '');
        IF_Util.sendEmailIfError(new IF_Util(), ' ');
        Integer emailInvocations = Limits.getEmailInvocations();
        Test.stopTest();

        System.assertEquals(0, emailInvocations, 'Expected 0');
    }

    @IsTest
    static void testSendEmailIfErrorNull() {
        Test.startTest();
        IF_Util.sendEmailIfError(new IF_Util(), null);
        Integer emailInvocations = Limits.getEmailInvocations();
        Test.stopTest();

        System.assertEquals(0, emailInvocations, 'Expected 0');
    }

    @IsTest
    static void testSendEmailIfErrorToAdmin() {
        Test.startTest();
        IF_Util.sendEmailIfError(new IF_Util(), 'to admin test email');
        Integer emailInvocations = Limits.getEmailInvocations();
        Test.stopTest();

        List<Schema.EmailMessage> emails = [SELECT Id, ToAddress FROM EmailMessage WHERE CreatedDate >= TODAY];

        System.assertEquals(1, emailInvocations, 'Expected 1');
        System.assertEquals(1, emails.size());
        // 작성자 이메일 포함
        String authorEmail = [SELECT Id, LastModifiedBy.Email FROM ApexClass WHERE Name = 'IF_Util'].LastModifiedBy.Email;
        System.assertEquals(true, emails[0].ToAddress.split('; ').contains(authorEmail));

        // 어드민 이메일 포함 (중복 제거)
        List<AggregateResult> admins = [SELECT Email FROM User WHERE Profile.Name = 'System Administrator'GROUP BY Email];
        Integer kNum = 1;  // 작성자 수 포함
        for (AggregateResult kAggregateResult : admins) {
            if(kAggregateResult.get('Email') == authorEmail){
                kNum = 0;  // 작성자 수 제외
                break;  // 어드민에 작성자가 포함되어 있다면 수신자가 중복 제거된다.
            }
        }
        System.assertEquals(admins.size() + kNum, emails[0].ToAddress.split('; ').size());
    }

    @IsTest
    static void testSendEmailWithContext() {
        Integer emailInvocationsBefore = Limits.getEmailInvocations();
        System.assertEquals(0, emailInvocationsBefore, 'Expected 0');

        EXEC_ChainContext kContext = new EXEC_ChainContext(); // default false
        kContext.enableEmailSending = true;

        Test.startTest();
        IF_Util.sendEmailWithContext(kContext, new IF_Util(), 'Test Error Occurred');
        Integer emailInvocations = Limits.getEmailInvocations();
        Test.stopTest();

        System.assertEquals(1, emailInvocations, 'An email should be sent');
    }

    @IsTest
    static void testSendEmailWithContextFalse() {

        EXEC_ChainContext kContext = new EXEC_ChainContext(); // default false

        Test.startTest();
        IF_Util.sendEmailWithContext(kContext, new IF_Util(), 'Test Error Occurred');
        Integer emailInvocations = Limits.getEmailInvocations();
        Test.stopTest();

        System.assertEquals(0, emailInvocations, 'Expected 0');
    }

//    @IsTest
//    static void testNotifyApproval() {
//        createCustomSetting();
//        // if info
//        insert new IF_INFO__c(IF_ID__c = 'IF_SFDC_ONE_APPROVAL', FORCE_LOGGING__c = true, URL__c = '...');
//
//        String kUserName = UserInfo.getName();
//
//        Account acc = new Account(Name = 'acc');
//        insert acc;
//        VehicleProject__c vp = new VehicleProject__c(Name = 'vp', AccountName__c = acc.Id);
//        insert vp;
//        Product2 pd = new Product2(Name = 'pd');
//        insert pd;
//        Opportunity kNew = new Opportunity(StageName = 'Closed Won', VehicleProject__c = vp.Id, Product__c = pd.Id, AccountId = acc.Id,
//                CloseDate = Date.today());
//        insert kNew;
//        ApprovalProcess__c ap = new ApprovalProcess__c(ApprovalStatus__c = 'Approved', Opportunity__c = kNew.Id, QuipURL__c = 'asdf/bcd');
//        insert ap;
//
//        // Contact
//        Id kRecordTypeId = SUtil.getRecordTypeId(Contact.class, 'Employee');
//        Contact kContact = new Contact(
//                LastName = 'asdf', UserId__c = UserInfo.getUserId(), EmployeeNumber__c = '1234',
//                IsEmployee__c = true, RecordTypeId = kRecordTypeId, IsExecutive__c = false, IsBusinessLead__c = true
//        );
//        insert kContact;
//        Contact kContact2 = new Contact(
//                LastName = 'qwer2', UserId__c = UserInfo.getUserId(), EmployeeNumber__c = '4322',
//                IsEmployee__c = true, RecordTypeId = kRecordTypeId, IsExecutive__c = false, IsBusinessLead__c = true
//        );
//        insert kContact2; // patch multi selected row
//
//        // approval
//        ApprovalProcessPath__c kApp = new ApprovalProcessPath__c(
//                RequestDateTime__c = Datetime.newInstance(9999),
//                ApprovalProcess__c = ap.Id, ApprovalUser__c = UserInfo.getUserId(), Employee__c = kContact.Id
//        );
//        insert kApp;
//
//        kApp = [SELECT Name, ApprovalProcess__r.Name FROM ApprovalProcessPath__c WHERE Id = :kApp.Id];
//
//
//        ExampleCalloutMock kMock = new ExampleCalloutMock();
//        Test.startTest();
//        Test.setMock(HttpCalloutMock.class, kMock);
//        IF_Util.notifyApproval(kApp.Id);
//        Test.stopTest();
//
//        String kApprovalUrl = Url.getOrgDomainUrl().toExternalForm() + '/lightning/r/' + kApp.Id + '/view';
//
//        System.debug(kApprovalUrl);
//
//        Map<String, Object> kMap = (Map<String, Object>) JSON.deserializeUntyped(kMock.requestBody);
//        System.assertEquals(kApp.Name, TestUtil.valueOf(kMap, 'request.payload.t_data.input.DOCNBR'));
//        System.assertEquals('1', TestUtil.valueOf(kMap, 'request.payload.t_data.ACNT_CNT'));
//        System.assertEquals('_', TestUtil.valueOf(kMap, 'request.payload.t_data.input.APPARA'));
//        System.assertEquals(kApp.ApprovalProcess__r.Name, TestUtil.valueOf(kMap, 'request.payload.t_data.input.DOCNAM'));
//        System.assertEquals('1234', TestUtil.valueOf(kMap, 'request.payload.t_data.input.PEMPNO'));
//        System.assertEquals(kUserName, TestUtil.valueOf(kMap, 'request.payload.t_data.input.PNAME'));
//        System.assertEquals(Datetime.newInstance(9999).format('yyyyMMdd'), TestUtil.valueOf(kMap, 'request.payload.t_data.input.DOCDTE'));
//        System.assertEquals(kApprovalUrl, TestUtil.valueOf(kMap, 'request.payload.t_data.input.APPURL'));
//    }

//    @IsTest
//    static void testNotifyApprovalToCollaboration() {
//        createCustomSetting();
//        // if info
//        insert new IF_INFO__c(IF_ID__c = 'IF_SFDC_ONE_APPROVAL', FORCE_LOGGING__c = true, URL__c = '...');
//
//        String kUserName = UserInfo.getName();
//
//        Account acc = new Account(Name = 'acc');
//        insert acc;
//        VehicleProject__c vp = new VehicleProject__c(Name = 'vp', AccountName__c = acc.Id);
//        insert vp;
//        Product2 pd = new Product2(Name = 'pd');
//        insert pd;
//        Opportunity kNew = new Opportunity(StageName = 'Closed Won', VehicleProject__c = vp.Id, Product__c = pd.Id, AccountId = acc.Id,
//                CloseDate = Date.today());
//        insert kNew;
//        ApprovalProcess__c ap = new ApprovalProcess__c(ApprovalStatus__c = 'Approved', Opportunity__c = kNew.Id, QuipURL__c = 'asdf/bcd');
//        insert ap;
//
//        // Contact
//        Id kRecordTypeId = SUtil.getRecordTypeId(Contact.class, 'Employee');
//        Contact kContact = new Contact(
//                LastName = 'asdf', UserId__c = UserInfo.getUserId(), EmployeeNumber__c = '1234',
//                IsEmployee__c = true, RecordTypeId = kRecordTypeId, IsExecutive__c = false, IsBusinessLead__c = true
//        );
//        insert kContact;
//
//        // approval
//        ApprovalProcessPath__c kApp = new ApprovalProcessPath__c(
//                RequestDateTime__c = Datetime.newInstance(9999),
//                ApprovalProcessPathUID__c = 'aa-bb-cc',
//                ApprovalProcess__c = ap.Id, /*ApprovalUser__c = UserInfo.getUserId(),*/ Employee__c = kContact.Id   // contact 만있으면 협조자
//        );
//        insert kApp;
//
//        kApp = [SELECT Name, ApprovalProcessPathUID__c, ApprovalProcess__r.Name FROM ApprovalProcessPath__c WHERE Id = :kApp.Id];
//
//        ExampleCalloutMock kMock = new ExampleCalloutMock();
//        Test.startTest();
//        Test.setMock(HttpCalloutMock.class, kMock);
//        IF_Util.notifyApproval(kApp.Id);   // contact id 로 발송
//        Test.stopTest();
//
//        String kApprovalUrl = ApprovalProcessSettings__c.getInstance('MobisApprovalProcessSettings').PublicSiteURL__c + 'approve?uid=' + kApp.ApprovalProcessPathUID__c + '&';
//
//        System.debug(kApprovalUrl);
//
//        Map<String, Object> kMap = (Map<String, Object>) JSON.deserializeUntyped(kMock.requestBody);
//        System.assertEquals(kApp.Name, TestUtil.valueOf(kMap, 'request.payload.t_data.input.DOCNBR'));
//        System.assertEquals('1', TestUtil.valueOf(kMap, 'request.payload.t_data.ACNT_CNT'));
//        System.assertEquals('_', TestUtil.valueOf(kMap, 'request.payload.t_data.input.APPARA'));
//        System.assertEquals(kApp.ApprovalProcess__r.Name, TestUtil.valueOf(kMap, 'request.payload.t_data.input.DOCNAM'));
//        System.assertEquals('1234', TestUtil.valueOf(kMap, 'request.payload.t_data.input.PEMPNO'));
//        System.assertEquals(kUserName, TestUtil.valueOf(kMap, 'request.payload.t_data.input.PNAME'));
//        System.assertEquals(Datetime.newInstance(9999).format('yyyyMMdd'), TestUtil.valueOf(kMap, 'request.payload.t_data.input.DOCDTE'));
//        System.assertEquals(kApprovalUrl, TestUtil.valueOf(kMap, 'request.payload.t_data.input.APPURL'));
//    }

//    @IsTest
//    static void testRemoveApprovalNotification() {
//        createCustomSetting();
//        // if info
//        insert new IF_INFO__c(IF_ID__c = 'IF_SFDC_ONE_APPROVAL', FORCE_LOGGING__c = true, URL__c = '...');
//
//        String kUserName = UserInfo.getName();
//
//        Account acc = new Account(Name = 'acc');
//        insert acc;
//        VehicleProject__c vp = new VehicleProject__c(Name = 'vp', AccountName__c = acc.Id);
//        insert vp;
//        Product2 pd = new Product2(Name = 'pd');
//        insert pd;
//        Opportunity kNew = new Opportunity(StageName = 'Closed Won', VehicleProject__c = vp.Id, Product__c = pd.Id, AccountId = acc.Id,
//                CloseDate = Date.today());
//        insert kNew;
//        ApprovalProcess__c ap = new ApprovalProcess__c(ApprovalStatus__c = 'Approved', Opportunity__c = kNew.Id, QuipURL__c = 'asdf/bcd');
//        insert ap;
//
//        // Contact
//        Id kRecordTypeId = SUtil.getRecordTypeId(Contact.class, 'Employee');
//        Contact kContact = new Contact(
//                LastName = 'asdf', UserId__c = UserInfo.getUserId(), EmployeeNumber__c = '1234',
//                IsEmployee__c = true, RecordTypeId = kRecordTypeId, IsExecutive__c = false, IsBusinessLead__c = true
//        );
//        insert kContact;
//        Contact kContact2 = new Contact(
//                LastName = 'rewq2', UserId__c = UserInfo.getUserId(), EmployeeNumber__c = '2832',
//                IsEmployee__c = true, RecordTypeId = kRecordTypeId, IsExecutive__c = false, IsBusinessLead__c = true
//        );
//        insert kContact2; // patch multi selected row
//
//        // approval
//        ApprovalProcessPath__c kApp = new ApprovalProcessPath__c(
//                RequestDateTime__c = Datetime.newInstance(9999),
//                ApprovalProcess__c = ap.Id, ApprovalUser__c = UserInfo.getUserId(), Employee__c = kContact.Id
//        );
//        insert kApp;
//
//        kApp = [SELECT Name, ApprovalProcess__r.Name FROM ApprovalProcessPath__c WHERE Id = :kApp.Id];
//
//        ExampleCalloutMock kMock = new ExampleCalloutMock();
//        Test.startTest();
//        Test.setMock(HttpCalloutMock.class, kMock);
//        IF_Util.removeApprovalNotification(kApp.Id);
//        Test.stopTest();
//
//        String kApprovalUrl = Url.getOrgDomainUrl().toExternalForm() + '/lightning/r/' + kApp.Id + '/view';
//
//        System.debug(kApprovalUrl);
//
//        Map<String, Object> kMap = (Map<String, Object>) JSON.deserializeUntyped(kMock.requestBody);
//        System.assertEquals('0', TestUtil.valueOf(kMap, 'request.payload.t_data.ACNT_CNT'));
//        System.assertEquals(kApp.Name, TestUtil.valueOf(kMap, 'request.payload.t_data.input.DOCNBR'));
//        System.assertEquals('_', TestUtil.valueOf(kMap, 'request.payload.t_data.input.APPARA'));
//        System.assertEquals(kApp.ApprovalProcess__r.Name, TestUtil.valueOf(kMap, 'request.payload.t_data.input.DOCNAM'));
//        System.assertEquals('1234', TestUtil.valueOf(kMap, 'request.payload.t_data.input.PEMPNO'));
//        System.assertEquals(kUserName, TestUtil.valueOf(kMap, 'request.payload.t_data.input.PNAME'));
//        System.assertEquals(Datetime.newInstance(9999).format('yyyyMMdd'), TestUtil.valueOf(kMap, 'request.payload.t_data.input.DOCDTE'));
//        System.assertEquals(kApprovalUrl, TestUtil.valueOf(kMap, 'request.payload.t_data.input.APPURL'));
//    }

    @IsTest
    static void testNotifyError() {
        createCustomSetting();
        // if info
        insert new IF_INFO__c(IF_ID__c = 'IF_SFDC_ONE_APPROVAL', FORCE_LOGGING__c = true, URL__c = '...');

        Test.startTest();
        IF_Util.notifyApproval('002000000000000', '003000000000000');
        Test.stopTest();

        IF_LOG__c kLog = [SELECT Id, MSGGUID__c, OERRORTEXT__c FROM IF_LOG__c LIMIT 1];
        System.debug(kLog);
        System.assertEquals('EAI notify Error', kLog.MSGGUID__c);
        System.assertEquals(true, kLog.OERRORTEXT__c.contains('List has no rows for assignment'));
        System.assertEquals(true, kLog.OERRORTEXT__c.contains('003000000000000'));
    }

    private class ExampleCalloutMock implements HttpCalloutMock {
        public String requestBody;
        public HttpResponse respond(HttpRequest req) {
            // {"request":{"header":{"ifTrackingId":"0a359939-7942-5da1-d530-9c32e09a112d","ifId":"IF_SFDC_ONE_APPROVAL","ifDateTime":"2022-11-08 06:09:34"},"payload":{"ifAggregation":"7246061d-2e1a-0966-b874-7cdc5a00fb37","t_data":{"input":{"PEMPNO":"A1102874","APPTYP":"CR","APPNAM":"CRM"},"ACNT_CNT":"1"}}}}
            // assert request params
            this.requestBody = req.getBody();

            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody('{"response":{"header":{"ifId":"IF_SFDC_ONE_APPROVAL","ifTrackingId":"","iFDateTime":"","ifResult":"Z","ifMessage":"Success","ifFailCode":""},"payload":{"ifAggregation":"","ifRcvCnt":"","t_data":{}}}}');
            return res;
        }
    }

    static void createCustomSetting() {
        ApprovalProcessSettings__c setting = new ApprovalProcessSettings__c();
        setting.Name = 'MobisApprovalProcessSettings';
        setting.CompanyEmail__c = 'tokyodreamer0702@gmail.com';
        setting.EmailSenderName__c = 'Mobis Support';
        setting.LogoURL__c = 'https://upload.wikimedia.org/wikipedia/en/thumb/3/3b/Hyundai_Mobis_logo.svg/1200px-Hyundai_Mobis_logo.svg.png';
        setting.PublicSiteURL__c = 'https://mobis--ps.sandbox.my.salesforce-sites.com/';

        insert setting;
    }

//    @IsTest(SeeAllData=true)
//    static void testNOtiNoti() {
//        User kUser = [SELECT Id FROM User WHERE Profile.Name = 'HQ Sales User' AND Name = 'TestUser01' AND IsActive = TRUE LIMIT 1];
//        System.runAs(kUser) {
//            System.debug(UserInfo.getName());
//            Test.startTest();
//            IF_Util.notinoti();
//            Test.stopTest();
//        }
//    }
}