/**
 * Created by hyodongmin on 2022/08/23.
 */

public with sharing abstract class BatchBase implements Database.Batchable<SObject>, Database.Stateful, Database.AllowsCallouts {
    public static final String DUMMY_STATUS_INPUT = 'I';    // 레코드 처리 중
    public static final String DUMMY_STATUS_SUCCESS = 'S';  // 레코드 처리 완료
    public static final String DUMMY_STATUS_FAILURE = 'F';  // 레코드 처리 실패
    public static final String DUMMY_STATUS_CONTINUE = 'C'; // 레코드 추가 처리 필요

    protected BatchLogger logger;

    public Database.QueryLocator start(Database.BatchableContext context) {
        logger = new BatchLogger(context.getJobId(), String.valueOf(this));
        logger.start('Start!!');
        return start2(context);
    }

    protected abstract Database.QueryLocator start2(Database.BatchableContext batchableContext);

    public abstract void execute(Database.BatchableContext context, List<SObject> scope);

    protected virtual void finish2(Database.BatchableContext context) {
        System.debug(LoggingLevel.WARN, '--- finish: ' + SUtil.toName(this));
    }

    public void finish(Database.BatchableContext context) {
        finish2(context);
        logger.finish();
    }

    public BatchLogger getLogger() {
        return logger;
    }

    /**
     * 업서트 결과를 더미에 반영
     *
     * @param aDummy Dummy object
     * @param aField Dummy object status field
     * @param aResult Upsert result
     */
    @TestVisible
    protected void persistUpsertResult(SObject aDummy, SObjectField aField, Database.UpsertResult aResult) {
        persistUpsertResult(aDummy, aField, aResult, DUMMY_STATUS_SUCCESS);
    }

    /**
     * 업서트 결과를 더미에 반영
     *
     * @param aDummy Dummy object
     * @param aField Dummy object status field
     * @param aResult Upsert result
     * @param aSuccessCode 성공 코드
     */
    @TestVisible
    protected void persistUpsertResult(SObject aDummy, SObjectField aField, Database.UpsertResult aResult, String aSuccessCode) {
        persistResult(aDummy, aField, aResult.isSuccess(), aResult.getErrors(), aSuccessCode);
    }

    @TestVisible
    protected void persistResult(SObject aDummy, SObjectField aField, Boolean isSuccess, Database.Error[] aErrors, String aSuccessCode) {
        if (false == isSuccess) {
            logger.error('[ ' + SUtil.toName(this) + ' Error Dummy.Id:' + aDummy.Id + ']' + aErrors[0]);
            aDummy.put(aField, DUMMY_STATUS_FAILURE);
        } else {
            aDummy.put(aField, aSuccessCode);
        }
    }
}