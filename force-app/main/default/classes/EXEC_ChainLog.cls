/**
 * Created by hyodongmin on 2022/08/23.
 */

public with sharing class EXEC_ChainLog implements Queueable, EXEC_IChain {
    private EXEC_ChainContext chainContext;
    protected EXEC_Delegate delegate;
    protected List<String> chains;
    protected String chainName;

    public EXEC_ChainLog(EXEC_Delegate aDelegate, List<String> aChains, String aChainName) {
        delegate = aDelegate;
        chains = aChains;
        chainName = aChainName;
    }

    public void execute(QueueableContext param1) {
        System.debug('execute....' + chainName + ', context: ' + chainContext);

        // insert a log
        IF_Util.logSimple(chainName, delegate.getLog(chainName).message, null);

        delegate.nextChain(chains, chainName).startChain(chainContext);
    }

    public Id startChain(EXEC_ChainContext aContext) {
        chainContext = aContext;
        System.debug('Chain started => ' + chainName);
        return delegate.enqueueJob(this);
    }

    public String getChainName() {
        return chainName;
    }
}