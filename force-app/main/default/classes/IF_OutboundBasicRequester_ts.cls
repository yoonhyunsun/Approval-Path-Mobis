/**
 * Created by hyodongmin on 2022/08/05.
 */

@IsTest
private class IF_OutboundBasicRequester_ts {

    @IsTest
    private static void testConstructor() {
        IF_OutboundBasicRequester outbound = new IF_OutboundBasicRequester(); // for coverage
    }

    @IsTest
    private static void testCallout() {

        IfStaticValue__c ifStaticValue = new IfStaticValue__c();
        IF_Static.replaceIfStaticValue(ifStaticValue);

        IF_OutboundBasicRequester outbound = new IF_OutboundBasicRequester(new TestAuth());

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock());

        HttpRequest kHttpReq = new HttpRequest();
        kHttpReq.setEndpoint('url');    // Interface url without base URL. ex> '/extra/sfdc/lorem/ipsum'
        kHttpReq.setBody('');     // body string
        String response = outbound.request(kHttpReq, new TestDeserializer()).raw;

        Test.stopTest();

        System.assertEquals('GREAT SCOTT', response);
    }

    private class ExampleCalloutMock implements HttpCalloutMock{
        public HttpResponse respond(HttpRequest req){
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody('GREAT SCOTT');
            return res;
        }
    }
    
    private class TestAuth implements IF_OutboundIAuth {

        public String getAuthKeyName() {
            return 'auth-key';
        }

        public String getAuthValue() {
            return 'auth-value';
        }
    }
    
    private class TestDeserializer implements IF_OutboundIDeserializer {

        public Object deserialize(String aJson) {
            return aJson;
        }
    }
}