/**
 * Created by hyodongmin on 2022/08/23.
 */

@IsTest
private class EXEC_ChainCalloutAdapter_ts {
    @IsTest
    static void testBehavior() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock());

        EXEC_Manager.CalloutResult kResult = new EXEC_ChainCalloutAdapter(new TestIFOutbound()).callout('aggr...');

        Test.stopTest();

        // NullPointerException, response body 가 파싱되지 못하여 null 임
        System.assertEquals(-2, kResult.code);
        System.assertEquals('Attempt to de-reference a null object', kResult.message);
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

    class TestIFOutbound extends IF_Outbound {

        public TestIFOutbound(){
            super(new IF_OutboundBasicRequester(new IF_OutboundBasicAuth()));
        }

        protected override void processPre(IF_Abstract.InputAbstract aInput) {
        }

        protected override HttpRequest prepareRequest(String aReqBody, String aEndPoint) {
            return new HttpRequest();
        }

        protected override Integer processPost(IF_Abstract.InputAbstract aInput, IF_Abstract.OutputAbstract aOutput) {
            return -100;
        }

        public override String getIfId() {
            return '';
        }

        public override Object deserialize(String aJson) {
            return null;
        }

        public override IF_Abstract.T_DATA deserializeOne(String aJson) {
            return null;
        }
    }
}