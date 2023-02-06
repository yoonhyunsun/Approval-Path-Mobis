/**
 * Created by hyodongmin on 2022/08/05.
 */

@IsTest
private class IF_OutboundBasicAuth_ts {

    @IsTest
    private static void testAuthKeyName() {

        IfStaticValue__c ifStaticValue = new IfStaticValue__c();
        ifStaticValue.hub_oauth_client_id__c = 'id';
        IF_Static.replaceIfStaticValue(ifStaticValue);

        IF_OutboundBasicAuth auth = new IF_OutboundBasicAuth();

        String authHeader = auth.getAuthKeyName();

        System.assertEquals('id', authHeader);
    }

    @IsTest
    private static void testGetAuthKey() {

        IfStaticValue__c ifStaticValue = new IfStaticValue__c();
        ifStaticValue.hub_oauth_client_secret__c = 'secret';
        IF_Static.replaceIfStaticValue(ifStaticValue);

        IF_OutboundBasicAuth auth = new IF_OutboundBasicAuth();

        String key = auth.getAuthValue();

        System.assertEquals('secret', key);
    }
}