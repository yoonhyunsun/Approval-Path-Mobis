/**
 * 'Custom setting' 의 기본 설정을 참조한다.
 *
 * Created by hyodongmin on 2022/08/11.
 */

public with sharing class IF_Static {

    private static IfStaticValue__c staticValue;
    static {
        staticValue = IfStaticValue__c.getInstance('INTERFACE');
        if (null == staticValue) {
            staticValue = (IfStaticValue__c) IfStaticValue__c.getSObjectType().newSObject(null, true);
        }
    }

    /**
     * 인터페이스 환경 설정 재정의
     *
     * @param aStaticValue IfStaticValue__c
     */
    public static void replaceIfStaticValue(IfStaticValue__c aStaticValue) {
        staticValue = aStaticValue;
    }

    /**
     * 외부 API 요청에 이용되는 Domain
     *
     * @return callout request domain
     */
    public static String getDomain() {
        return staticValue.hub_url__c;
    }

    /**
     * 체인 실행 여부
     *
     * @return Boolean
     */
    public static Boolean isChainEnabled() {
        return staticValue.chain_enabled__c;
    }

    /**
     * 저장된 Client Id
     *
     * @return String
     */
    public static String getClientId() {
        return staticValue.hub_oauth_client_id__c;
    }

    /**
     * 저장된 Client Secret
     *
     * @return String
     */
    public static String getClientSecret() {
        return staticValue.hub_oauth_client_secret__c;
    }
}