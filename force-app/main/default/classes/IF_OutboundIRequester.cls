/**
 * 외부 API 요청을 실행하는 인터페이스
 * 
 * Created by hyodongmin on 2022/08/04.
 */

public interface IF_OutboundIRequester {
    /**
     * API 를 요청하고 Data Object 로 변환하여 반환한다. 결과에 따라서 (인증 오류 등) API 재요청을 하는 경우도 있기에 Deserializing 을 여기서 처리한다.
     *
     * @param aHttpReq HttpRequest
     * @param aDeserializer IF_OutboundIDeserializer 구현체
     *
     * @return new IF_OutboundRequesterResult( Response raw data, aDeserializer 로 객체화한 데이터 )
     */
    IF_OutboundRequesterResult request(HttpRequest aHttpReq, IF_OutboundIDeserializer aDeserializer);
}