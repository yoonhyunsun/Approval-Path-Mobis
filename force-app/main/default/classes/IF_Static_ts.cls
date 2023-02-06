/**
 * Created by hyodongmin on 2022/08/11.
 */

@IsTest
private class IF_Static_ts {
    @IsTest
    static void testBehavior() {
        IfStaticValue__c kIfStaticValue = new IfStaticValue__c(
                hub_url__c = 'https://...',
                chain_enabled__c = true,
                hub_oauth_client_id__c = 'id---',
                hub_oauth_client_secret__c = 'secret---'
        );
        IF_Static.replaceIfStaticValue(kIfStaticValue);

        System.assertEquals('https://...', IF_Static.getDomain());
        System.assertEquals(true, IF_Static.isChainEnabled());
        System.assertEquals('id---', IF_Static.getClientId());
        System.assertEquals('secret---', IF_Static.getClientSecret());
    }
}