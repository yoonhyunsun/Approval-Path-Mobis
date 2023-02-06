/**
 * 기본 API 요청
 * 
 * Created by hyodongmin on 2022/08/05.
 */

public with sharing class IF_OutboundBasicRequester implements IF_OutboundIRequester {
    final IF_OutboundIAuth auth;

    /**
     * API 에 필요한 인증 정보가 필요하다.
     * 
     * @param aAuth IF_OutboundIAuth
     */
    public IF_OutboundBasicRequester(IF_OutboundIAuth aAuth) {
        auth = aAuth;
    }

    public IF_OutboundBasicRequester() {
        auth = new IF_OutboundBasicAuth();
    }

    /**
     * 기본 인증 정보로 기본 Callout 실행
     *
     * @param aHttpReq HttpRequest
     * @param aDeserializer Deserializer 
     *
     * @return Data Object
     */
    public IF_OutboundRequesterResult request(HttpRequest aHttpReq, IF_OutboundIDeserializer aDeserializer) {
        String kAuthId = auth.getAuthKeyName();
        String kAuthPw = auth.getAuthValue();
        String kEndpoint = IF_Static.getDomain() + aHttpReq.getEndpoint();

        aHttpReq.setEndpoint(kEndpoint);

        String kIdPw = EncodingUtil.base64Encode(Blob.valueOf(kAuthId + ':' + kAuthPw));
        aHttpReq.setHeader('Authorization', 'Basic ' + kIdPw);

        System.debug(aHttpReq);

        String kResponseBody = IF_Base.webCallOut(aHttpReq);

        return new IF_OutboundRequesterResult(kResponseBody, aDeserializer.deserialize(kResponseBody));
    }
}