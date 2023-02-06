/**
 * Created by hyodongmin on 2022/08/23.
 */

public with sharing class EXEC_ChainBatch implements Database.Batchable<SObject>, Database.Stateful, EXEC_IChain {

    private Database.Batchable<SObject> batchable;
    private EXEC_ChainContext chainContext;

    protected EXEC_Delegate delegate;
    protected List<String> chains;
    public final String chainName;

    public EXEC_ChainBatch(EXEC_Delegate aDelegate, List<String> aChains, String aChainName) {
        delegate = aDelegate;
        chains = aChains;
        chainName = aChainName;
        batchable = delegate.getBatch(chainName);
    }

    // ***************************************
    // implement Database.Batchable
    // ***************************************
    public Iterable<SObject> start(Database.BatchableContext param1) {
        System.debug('start....' + chainName + ', context: ' + chainContext);
        return batchable.start(param1);
    }
    public void execute(Database.BatchableContext param1, List<SObject> param2) {
        System.debug('execute....' + chainName);
        batchable.execute(param1, param2);
    }

    public void finish(Database.BatchableContext param1) {
        System.debug('finish....' + chainName);
        batchable.finish(param1);

        if (batchable instanceof BatchBase) {
            BatchBase kBatchBase = (BatchBase) batchable;
            IF_Util.sendEmailWithContext(chainContext, this, kBatchBase.getLogger().getError());
        }

        // 다음 배치 실행
        EXEC_IChain next = delegate.nextChain(chains, chainName);
        next.startChain(chainContext);
    }

    // ***************************************
    // implement IF_EXEC_Chain
    // ***************************************
    public String getChainName() {
        return chainName;
    }

    public Id startChain(EXEC_ChainContext aContext) {
        chainContext = aContext;
        System.debug('Chain started => ' + chainName);
        return delegate.executeBatch(this);
    }
}