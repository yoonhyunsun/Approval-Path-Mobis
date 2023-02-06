/**
 * API Response 를 Deserializing 하는 인터페이스. 구현체는 대부분 {@link IF_Outbound} 이다.
 * {@link IF_OutboundIRequester} 의 parameter 로 이용하기 위해 정의한 interface
 * 
 * Created by hyodongmin on 2022/08/05.
 */

public interface IF_OutboundIDeserializer {
    /**
     * JSON 을 Data Object 로 변환한다.
     * 
     * @param aJson Response body JSON string
     *
     * @return Data Object for each API
     */
    Object deserialize(String aJson);
}