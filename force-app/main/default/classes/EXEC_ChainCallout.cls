/**
 * Created by hyodongmin on 2022/08/23.
 */

public with sharing class EXEC_ChainCallout implements Queueable, Database.AllowsCallouts, EXEC_IChain {
    public final static Integer REPEAT_MAX = 50;

    private EXEC_ChainContext chainContext;
    protected EXEC_Delegate delegate;
    protected List<String> chains;
    protected String aggregation;
    protected String chainName;
    protected Integer repeatCount;

    public EXEC_ChainCallout(EXEC_Delegate aDelegate, List<String> aChains, String aAggregation, String aChainName, Integer aRepeatCount) {
        delegate = aDelegate;
        chains = aChains;
        aggregation = aAggregation;
        chainName = aChainName;
        repeatCount = aRepeatCount;
    }

    // ***************************************
    // implement Queueable
    // ***************************************
    public void execute(QueueableContext param1) {
        System.debug('execute....' + chainName + ', context: ' + chainContext);

        EXEC_Manager.IChainCallout webCallout = delegate.getWebCallout(chainName);
        EXEC_Manager.CalloutResult result = webCallout.callout(aggregation);

        if (IF_Outbound.RESULT_CODE_END == result.code) {
            System.debug('next....' + chainName);
            // 다음 callout 실행
            EXEC_IChain next = delegate.nextChain(chains, chainName);
            next.startChain(chainContext);
        } else if (IF_Outbound.RESULT_CODE_ERROR == result.code || IF_Outbound.RESULT_CODE_FAIL == result.code) {
            // API 실패 (PAGE_FAIL) => 종료, 관리자에게 이메일 발송
            // 에러 발생 (PAGE_ERROR) => 종료, 관리자에게 이메일 발송
            System.debug('####################### error ' + chainName + ' #######################');
            IF_Util.sendEmailWithContext(chainContext, this, 'WebCallout error: [' + chainName + '] ' + result.message);
        } else {
            // next page - 현재 callout 재실행
            if (repeatCount < REPEAT_MAX) {
                delegate.repeat(new EXEC_ChainCallout(delegate, chains, aggregation, chainName, ++repeatCount));
            } else {
                // 동일 API 를 반복해서 호출하는 경우 제한이 있다. (REPEAT_MAX)
                // 체인을 종료하고 관리자에게 메일 발송
                System.debug('####################### error ' + chainName + ' repeat over  #######################');
                IF_Util.sendEmailWithContext(chainContext, this, 'WebCallout error: [' + chainName + '] ' + 'REPEAT_MAX over ');
            }
        }
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
        return delegate.enqueueJob(this);
    }

}