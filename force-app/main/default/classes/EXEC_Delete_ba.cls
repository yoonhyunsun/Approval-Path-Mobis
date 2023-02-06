/**
 * Created by hyodongmin on 2022/08/11.
 */

public with sharing class EXEC_Delete_ba implements Database.Batchable<SObject>, Database.Stateful {

    /*
    IF_Delete_ba batch = new IF_Delete_ba('IF_SFDC_GSIS_HOSPITAL__c', Date.today());
    Database.executeBatch(batch, 2000);
    */

    public Date ifDate;               // Delete Date
    public String sObjectName;        // Object Name

    /**
     * @param aSObjectName Object Name
     */
    public EXEC_Delete_ba(String aSObjectName) {
        this.sObjectName = aSObjectName;
    }

    /**
     * @param aSObjectName  Dummy Object Name
     * @param aDeleteDate 삭제 기준일
     */
    public EXEC_Delete_ba(String aSObjectName, Date aDeleteDate) {
        this.sObjectName = aSObjectName;
        this.ifDate = aDeleteDate;
    }

    /**
     * 삭제할 레코드 추출, 지정한 날짜가 없다면 한 달 이전 데이터를 추출한다.
     *
     * @param aContext Database.BatchableContext
     * @return Database.QueryLocator
     */
    public Database.QueryLocator start(Database.BatchableContext aContext) {

        if (ifDate == null) {
            ifDate = Date.today().addMonths(-1);
        }

        // covert to local time
        Datetime kDeleteDateTime = Datetime.newInstance(ifDate, Time.newInstance(0, 0, 0, 0));
        String kDeleteDateTimeString = kDeleteDateTime.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');

        String kQuery = '';
        kQuery += 'SELECT Id';
        kQuery += ' FROM ' + sObjectName;
        kQuery += ' WHERE CreatedDate < ' + kDeleteDateTimeString;

        return Database.getQueryLocator(kQuery);
    }

    /**
     * Object 의 데이터를 삭제
     *
     * @param aContext Database.BatchableContext
     * @param scope List<SObject>
     */
    public void execute(Database.BatchableContext aContext, List<SObject> scope) {
        System.debug('scope : ' + scope);
        try {
            delete scope;
            Database.emptyRecycleBin(scope);
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'Error Msg : ' + e.getMessage());
        }
    }

    /**
     * Batch 종료
     * @param aContext Database.BatchableContext
     */
    public void finish(Database.BatchableContext aContext) {
        System.debug('--- Delete finish ---');
    }

}