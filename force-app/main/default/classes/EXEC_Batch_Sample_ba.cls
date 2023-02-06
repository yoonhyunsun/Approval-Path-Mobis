/**
 * Created by hyodongmin on 2022/08/23.
 */

public with sharing class EXEC_Batch_Sample_ba extends BatchBase {

    protected override Database.QueryLocator start2(Database.BatchableContext batchableContext) {
        return Database.getQueryLocator('SELECT Id FROM IF_IM_SFDC_ORGMASTER__c ORDER BY CreatedDate DESC');
    }

    public override void execute(Database.BatchableContext context, List<SObject> scope) {
        logger.log(String.valueOf(scope.size()));
        System.debug(scope.size());
    }

}