/**
 * API 인증에 필요한 값을 설정
 * 
 * Created by hyodongmin on 2022/08/04.
 */

public interface IF_OutboundIAuth {

    /**
     * 인증에 이용되는 키의 이름
     * 
     * @return ex> 'authKey' 
     */
    String getAuthKeyName();

    /**
     * 인증키 값
     * 
     * @return 'xxxxxxxx'
     */
    String getAuthValue();
}