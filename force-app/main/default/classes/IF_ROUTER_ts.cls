/**
 * Created by hyodongmin on 2022/08/09.
 */

@IsTest
private with sharing class IF_ROUTER_ts {
    @IsTest
    static void testInvalidId() {

        RestRequest req = new RestRequest();
        req.requestBody = Blob.valueOf('{}');
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/BAD_ID';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type

        RestContext.request = req;
        RestContext.response= res;

        Test.startTest();
        Exception kEx = null;
        try {
            IF_ROUTER.doPost();
        } catch (Exception e){
            System.debug(e);
            kEx = e;
        }
        Test.stopTest();
        System.assertEquals(true, kEx.getMessage().contains('Invalid IF URL'));
    }

}