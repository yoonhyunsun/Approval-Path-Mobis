/****************************************************************************************
  * @author        : i2max_namho100
  * @date          : 2022-03-10
  *
  * @group         : I/F
  * @group-content : Common
  * @description   : Test class
****************************************************************************************/
@IsTest
private class IF_Base_ts {

    @IsTest
    private static void testInputHeader() {
        IF_Base.InputHeader inputHeader;
        inputHeader = new IF_Base.InputHeader();
        inputHeader = new IF_Base.InputHeader('');
        inputHeader = new IF_Base.InputHeader('', '');
        inputHeader = new IF_Base.InputHeader('', '', '');
//            inputHeader = new IF_Base.InputHeader('', '', '', '');
        inputHeader = new IF_Base.InputHeader('', '', '', '', '', '');
        inputHeader.genMsg();
        inputHeader.giveGUID();
    }

    @IsTest
    private static void testHeader() {
        IF_Base.Header header = new IF_Base.Header();
        System.assert(null != header, 'not null');
    }
    @IsTest
    private static void testLogInit() {
        new IF_Base().logInit('');
    }

    @IsTest
    private static void testLogStart() {
        IF_Base base = new IF_Base();
        base.logInit('test');
        base.logStart(new IF_Base.InputHeader());
    }

    @IsTest
    private static void testLogProcess() {
        IF_Base base = new IF_Base();
        base.logInit('test');
        base.logProcess(IF_Base.LOG_STEP1, '');
        base.logProcess(IF_Base.LOG_STEP1_1, '');
        base.logProcess(IF_Base.LOG_STEP2, '');
    }

    @IsTest
    private static void testLogEnd() {
        IF_Base base = new IF_Base();
        base.logInit('TEST');
        IF_Base.InputHeader inputHeader = new IF_Base.InputHeader();
        inputHeader.ifResult = 'F';
        base.logEnd(inputHeader, '', '', '', '', '');
    }

    @IsTest
    private static void testWebCallOut() {
        Test.setMock(HttpCalloutMock.class, new HttpCalloutSuccessMock());
        HttpRequest httpReq = new HttpRequest();
        httpReq.setHeader('authKey', 'xxx');
        IF_Base.webCallOut(httpReq);
    }

    @IsTest
    private static void testGetIfInfo() {
        insert new IF_INFO__c(IF_ID__c = 'test_id', URL__c = 'url..', TITLE__c='title', FORCE_LOGGING__c = true);

        IF_INFO__c info = new IF_Base().getIfInfo('test_id');
        System.assertEquals(true, info.FORCE_LOGGING__c);
        System.assertEquals('url..', info.URL__c);
    }

    @IsTest
    private static void testGetIfInfoDefault() {
        new IF_Base().getIfInfo('');
    }

    @IsTest
    private static void testSetOutputHeader() {
        IF_Base.InputHeader inputHeader = new IF_Base.InputHeader();
        IF_Base.InputHeader outputHeader = new IF_Base.InputHeader();
        try {

            outputHeader = new IF_Base().setOutputHeader(outputHeader, inputHeader);

            if (true) {
                throw new DmlException('Exception');
            }
        } catch (Exception ex) {
            System.debug(ex);
            outputHeader = new IF_Base().setOutputHeader(outputHeader, inputHeader, ex);
        }
    }

//    @IsTest public static void myUnitTest() {
//        try {
//            testInputHeader();
//            testHeader();
//            testLogInit();
//            testLogStart();
//            testLogProcess();
//            testLogEnd();
//            testWebCallOut();
//            testGetIfInfo();
//
//            testSetOutputHeader();
//
//            Test.setMock(HttpCalloutMock.class, new HttpCalloutSuccessMock());
//
//        } catch (Exception ex) {
//            System.debug(ex);
//        }
//    }

    // HTTPResponse 객체 생성
    private static HttpResponse newResponse(Integer statusCode) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(statusCode);
        res.setBody('');
        return res;
    }

    // StatusCode=200 Mock
    public class HttpCalloutSuccessMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = newResponse(200);
            return res;
        }
    }


    @IsTest
    static void testGuestUser() {
        User kUser = [SELECT Id FROM User WHERE Profile.Name = 'Approve Page Profile' AND IsActive = TRUE LIMIT 1];
        System.runAs(kUser) {
            System.debug(UserInfo.getName());
            Test.startTest();
            System.enqueueJob(new webCallOutLog_qu2()); // queue 에서는 without sharing
            Test.stopTest();

            Boolean ex = false;
            try {
                new webCallOutLog_qu2().execute(null); // 직접 실행 with sharing
            } catch (Exception e){
                ex = true;
            }
            System.assertEquals(true, ex); // with sharing 에러 발생


        }
    }

    @IsTest
    static void testGuestUser2() {
        User kUser = [SELECT Id FROM User WHERE Profile.Name = 'Approve Page Profile' AND IsActive = TRUE LIMIT 1];

        System.runAs(kUser) {
            System.debug(UserInfo.getName());

            Test.startTest();
            System.enqueueJob(new TEST_webCallOutLog_qu2()); // 에러 없음, with sharing 이지만 부모 클래스의 설정(inherited sharing)을 따른다.
            Test.stopTest();

            Boolean ex = false;
            try {
                new TEST_webCallOutLog_qu3().execute(null); // 직접 실행 without sharing 이지만 부모 클래스의 설정(inherited sharing)을 따른다.
            } catch (Exception e){
                ex = true;
            }
            System.assertEquals(true, ex); // with sharing 에러 발생
        }
    }

    private virtual inherited sharing class webCallOutLog_qu2 implements Queueable {

        public void execute(QueueableContext qc) {
            //insert log;
            IF_LOG__c log = new IF_LOG__c();
            insert log;

            //insert logFile;
            Attachment attSnd = new Attachment(Name = 'InputParameter' + '.json', Body = Blob.valueOf(''), ParentId = log.Id);
            Attachment attRcv = new Attachment(Name = 'OutputResult' + '.json', Body = Blob.valueOf(''), ParentId = log.Id);
            insert attSnd;
            insert attRcv;

            System.debug('IF_BaseLogREST log END');
        }

    }

    private with sharing class TEST_webCallOutLog_qu2 extends webCallOutLog_qu2 {

    }

    private without sharing class TEST_webCallOutLog_qu3 extends webCallOutLog_qu2 {

    }
}