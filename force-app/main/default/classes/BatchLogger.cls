/**
 * Created by hyodongmin on 2022/08/23.
 */

public with sharing class BatchLogger {

    private BatchLog__c bl;
    private String sLog;
    public BatchLogger(String jobId, String clsName) {
        bl = new BatchLog__c();
        bl.cronId__c = jobId;                                //Job ID
        /**
         * @author Kyejin Cheong
         * @description Max Length 길이 제한에 걸려 코드 수정
         */
        //bl.Name = clsName;    //Class Name
        bl.Name         = clsName.substring(0,clsName.indexOf(':'));    //Class Name
        sLog = '';
        sError = '';
    }

    private String sError;

    public void start() {
        start('Start!!');
    }

    public void start(String log) {
        bl.StartTime__c = System.now();
        log(log, bl.cronId__c);
    }

    public void finish() {
        finish('Finish!!');
    }

    public void finish(String log) {
        bl.EndTime__c = System.now();
        log(log, bl.cronId__c);
    }

    public void finish(Integer gCnt, Integer tCnt) {
        finish('Finish!!', gCnt, tCnt);
    }

    public void finish(String log, Integer gCnt, Integer tCnt) {
        bl.EndTime__c = System.now();
        bl.GuessCnt__c  = gCnt;
        bl.TotalCnt__c  = tCnt;
        log(log, bl.CronID__c);
    }


    public void log(String log, String cronId) {
        //system.debug('============== log ['+cronId+']');
        List<AsyncApexJob> apexJobs = [SELECT CreatedById, JobItemsProcessed, Status, TotalJobItems, ApexClass.Name FROM AsyncApexJob WHERE Id = :cronId];
        if (!apexJobs.isEmpty()) {
            AsyncApexJob apexJob = apexJobs[0];

            sLog += '[' + apexJob.Status + '] : [' + String.valueOf(System.now()) + '] (No : ' + apexJob.JobItemsProcessed + '/' + apexJob.TotalJobItems + ') <br>';
            sLog += 'Debug Log : ' + log + '<br>';
            sLog += '=================================================================<br>';
            bl.Status__c = apexJob.Status;
            bl.Log__c = sLog;
            bl.Error__c = sError;
            bl.IsFlag__c =  (String.isNotEmpty(sError) && sError.deleteWhitespace().length() > 0) ? 'Error' : 'Success';
            bl.User__c = apexJob.CreatedById;
            bl.GuessSize__c = apexJob.TotalJobItems;
            bl.TotalSize__c = apexJob.JobItemsProcessed;

            upsert bl;
        }
    }

    public void log(String log) {
        String kLog = '[' + String.valueOf(System.now()) + '] <br>';
        kLog += 'Debug Log : ' + log + '<br>';
        kLog += '=================================================================<br>';
        sLog = appendSafely(sLog, kLog, 130000);

        System.debug(kLog);
    }
    public void error(String log) {
        String kError = '[' + String.valueOf(System.now()) + '] <br>';
        kError += 'Error Log : ' + log + ' <br>';
        kError += '=================================================================<br>';
        sError = appendSafely(sError, kError, 130000);

        System.debug(kError);
    }

    @TestVisible
    private static String appendSafely(String aBody, String aTail, Integer aMax) {
        if (aBody.length() + aTail.length() > aMax) {
            if (!aBody.endsWith('.....')) {
                aBody += '.....';
            }
            return aBody;
        }
        return aBody + aTail;
    }

    public String getError() {
        return sError;
    }

    public String getBlId(){
        return bl.Id;
    }

}