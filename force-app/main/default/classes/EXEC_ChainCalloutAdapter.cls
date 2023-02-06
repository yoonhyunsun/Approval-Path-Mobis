/**
 * Created by hyodongmin on 2022/08/23.
 */

public with sharing class EXEC_ChainCalloutAdapter implements EXEC_Manager.IChainCallout{
    public final IF_Outbound outboundExecutor;

    public EXEC_ChainCalloutAdapter(IF_Outbound aExecutor){
        outboundExecutor = aExecutor;
    }

    // ***************************************
    // implement EXEC_Manager.IChainCallout
    // ***************************************
    public EXEC_Manager.CalloutResult callout(String aAggregation) {
        IF_Outbound.Result kResult = outboundExecutor.execute(aAggregation);
        return new EXEC_Manager.CalloutResult(kResult.code, kResult.message);
    }
}