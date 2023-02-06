/**
 * 'MOCK' server 를 target 으로 callout 요청
 * 
 * Created by hyodongmin on 2022/08/05.
 */

public with sharing class IF_OutboundMockRequester implements IF_OutboundIRequester {

    public IF_OutboundRequesterResult request(HttpRequest aHttpReq, IF_OutboundIDeserializer aDeserializer) {
        IfStaticValue__c kMockValue = IfStaticValue__c.getInstance('MOCK');

        String kAuthKey = kMockValue.hub_oauth_client_id__c;
        String kAuthValue = kMockValue.hub_oauth_client_secret__c;
        String kEndpoint = kMockValue.hub_url__c + aHttpReq.getEndpoint();

        aHttpReq.setEndpoint(kEndpoint);
        aHttpReq.setHeader(kAuthKey, kAuthValue);

        String kResponseBody = IF_Base.webCallOut(aHttpReq);
        return new IF_OutboundRequesterResult(kResponseBody, aDeserializer.deserialize(kResponseBody));
    }
}