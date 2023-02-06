/**
 * Created by hyodongmin on 2022/08/23.
 */

@IsTest
private class EXEC_ChainEmpty_ts {

    @IsTest
    public static void testStartChain() {   // NOPMD just log.
        EXEC_IChain chain = new EXEC_ChainEmpty('prev');
        chain.startChain(new EXEC_ChainContext()); // just log.
    }

    @IsTest
    public static void testGetChainName() {
        EXEC_IChain chain = new EXEC_ChainEmpty('prev');
        System.assertEquals('empty', chain.getChainName(), 'Expect empty');
    }

}