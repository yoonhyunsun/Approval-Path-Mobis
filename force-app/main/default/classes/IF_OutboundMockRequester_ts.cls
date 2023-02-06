/**
 * Created by hyodongmin on 2022/08/12.
 */

@IsTest
private class IF_OutboundMockRequester_ts {
    @IsTest
    static void testBehavior() {
        IfStaticValue__c kMockValue = new IfStaticValue__c(
                Name = 'MOCK',
                hub_url__c = 'https://aa.bb.cc/',
                hub_oauth_client_id__c = 'xxx',
                hub_oauth_client_secret__c = 'yyy'
        );
        insert kMockValue;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock());

        HttpRequest kHttpReq = new HttpRequest();
        kHttpReq.setEndpoint('ddd');    // Interface url without base URL. ex> '/extra/sfdc/lorem/ipsum'
        kHttpReq.setBody('body');     // body string
        String response = new IF_OutboundMockRequester().request(kHttpReq, new TestDeserializer()).raw;

        Test.stopTest();

        System.assertEquals('GREAT SCOTT', response);
    }

    private class ExampleCalloutMock implements HttpCalloutMock{
        public HttpResponse respond(HttpRequest req){
            System.assertEquals('yyy', req.getHeader('xxx'));
            System.assertEquals('https://aa.bb.cc/ddd', req.getEndpoint());

            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody('GREAT SCOTT');
            return res;
        }
    }

    private class TestDeserializer implements IF_OutboundIDeserializer {
        public Object deserialize(String aJson) {
            return aJson;
        }
    }
}