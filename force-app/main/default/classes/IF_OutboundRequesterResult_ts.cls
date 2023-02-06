/**
 * Created by hyodongmin on 2022/08/18.
 */

@IsTest
private class IF_OutboundRequesterResult_ts {
    @IsTest
    static void testBehavior() {
        IF_OutboundRequesterResult kResult = new IF_OutboundRequesterResult('test', 111);
        System.assertEquals('test', kResult.raw);
        System.assertEquals(111, kResult.body);
    }
}