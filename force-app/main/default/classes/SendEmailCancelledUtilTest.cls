@isTest
private class SendEmailCancelledUtilTest {
    @isTest 
    static void emailSendCancelledTest() {
        TestFactory.createCustomSetting();

        Test.setMock(HttpCalloutMock.class, new QuipCalloutMockTest());
        Test.startTest();
        SendEmailCancelledUtil.sendEmail('createdByName', 'oppName', 'approvalProcessName', 'test@test.test');
        Test.stopTest();  
    }

    @isTest 
    static void emailSendCancelledWithoutEmailTest() {
        TestFactory.createCustomSetting();

        Test.setMock(HttpCalloutMock.class, new QuipCalloutMockTest());
        Test.startTest();
        SendEmailCancelledUtil.sendEmail('createdByName', 'oppName', 'approvalProcessName', '');
        Test.stopTest();  
    }
}