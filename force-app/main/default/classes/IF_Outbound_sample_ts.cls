/**
 * Created by hyodongmin on 2022/09/05.
 */

@IsTest
private class IF_Outbound_sample_ts {
    @IsTest
    static void testBehavior() {
        IF_Outbound_sample ifOutboundSample = new IF_Outbound_sample(new IF_OutboundBasicRequester(new IF_OutboundBasicAuth()));
        ifOutboundSample.getIfId();
        ifOutboundSample.deserialize('{}');
        ifOutboundSample.deserializeOne('{"updateDt":"2000-09-09"}');
        ifOutboundSample.processPre(new IF_Abstract.Input());
        ifOutboundSample.prepareRequest('body', 'url');
        ifOutboundSample.processPost(new IF_Abstract.Input(), new IF_Abstract.Output());
    }
}