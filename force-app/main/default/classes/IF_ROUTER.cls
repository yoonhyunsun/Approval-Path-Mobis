/**
 * Inbound Interface 의 라우터. 인터페이스 ID 에 해당하는 객체로 처리한다.
 * 
 * Created by hyodongmin on 2022/08/08.
 */

@RestResource(UrlMapping='/*')
global with sharing class IF_ROUTER {
    /**
     * POST Method 처리
     * 요청 URL (/services/apexrest/{ID}} 의 Interface ID 를 이용해 해당 처리 객체를 찾고, 처리하여 결과를 반환한다. 
     */
    @HttpPost
    global static void doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String kUrl = req.requestURI;
        String kIfId = kUrl.substringAfterLast('/');
        IF_Inbound kInbound = IF_FACTORY.getInterfaceInbound(kIfId);
        if (null == kInbound) {
            throw new IF_Base.IFException('Invalid IF URL');
        }

        res.statusCode = 200;
        res.headers.put('Content-Type', 'application/json;charset=UTF-8');
        String kJson = JSON.serialize(kInbound.onPost(req.requestBody.toString()), true);
        kJson = kJson.replaceAll('_reserved916(?=":)', ''); // 예약어 변수값을 사용할 수 없어서 임의 문자를 붙여서 직열화 후 이를 제거
        res.responseBody = Blob.valueOf(kJson);
    }
}