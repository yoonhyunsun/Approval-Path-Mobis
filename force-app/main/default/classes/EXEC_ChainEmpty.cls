/**
 * Created by hyodongmin on 2022/08/23.
 */

public with sharing class EXEC_ChainEmpty implements EXEC_IChain {

    String prevChainName;
    public EXEC_ChainEmpty(String aPrevChainName){
        prevChainName = aPrevChainName;
    }

    public Id startChain(EXEC_ChainContext aContext) {
        System.debug('context: ' + aContext);
        System.debug('Chain end. prev: ' + prevChainName);
        return null;
    }

    public String getChainName() {
        return 'empty';
    }

}