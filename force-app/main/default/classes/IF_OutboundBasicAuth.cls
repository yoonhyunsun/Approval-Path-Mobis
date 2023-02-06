/**
 * 기본 인증 정보
 * 
 * Created by hyodongmin on 2022/08/05.
 */

public with sharing class IF_OutboundBasicAuth implements IF_OutboundIAuth {

    /**
     * @return 기본 인증 키 이름
     */
    public String getAuthKeyName() {
        return IF_Static.getClientId();
    }

    /**
     * @return 기본 인증 키 값
     */
    public String getAuthValue() {
        return IF_Static.getClientSecret();
    }
}