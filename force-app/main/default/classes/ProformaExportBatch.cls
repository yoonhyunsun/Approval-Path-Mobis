/***************************************************************************************
  * Project Name : Hyundai Mobis
  * File Name    : ProformaExportBatch
  * Description  : 
  * Copyright    : Copyright © I2max. All Rights Reserved. 2022 
  * Author       : KyeJin Cheong
  * Created Date : 2022-11-18
****************************************************************************************/

global without sharing class ProformaExportBatch implements Database.Batchable<sObject>, Database.Stateful {

    // Variables
    public String csvName;
    public String ownerId;
    public String changeDescription;

    // CSV File Format
    public String fileHeader;
    public String generatedCSVFile = '';

    // Batch Logger
    public BatchLogger logger;
    public Integer gCnt;    // guess count
    public Integer tCnt;    // total count

    /**
     * @description I/F 대상 추출
     * @param bc (Database.BatchableContext)
     * @return Database.QueryLocator
     * @author Kyejin Cheong
     */
    global Database.QueryLocator start(Database.BatchableContext bc) {
        logger = new BatchLogger(BC.getJobId(), String.valueOf(this));
        logger.start('start!!');

        gCnt = tCnt = 0;

        String query = 'SELECT Id';

        // Get the fields from FieldSet
        List<Schema.FieldSetMember> fieldSetMembers = SalesUtil.getFieldSet('Proforma_Export_List', 'ProformaDummy__c');

        // Key : Field Label, Value : Field API Name
        for(Schema.FieldSetMember fieldSetMember : fieldSetMembers) {
            query += ', ' + fieldSetMember.getFieldPath();
        }

        query += ' FROM ProformaDummy__c ';
        query += ' ORDER BY Index__c';

        System.debug('query > ' + query);

        return Database.getQueryLocator(query);
    }

    /**
     * @description CSV 파일 생성에 필요한 Data 의 Header 와 Value 를 세팅한다.
     */
    global void execute(Database.BatchableContext bc, List<sObject> scope) {
        System.debug('scope.size : ' + scope.size());

        String fileRow;
        List<String> fieldsList;

        Map<String, String> fieldLabelValueMap = new Map<String, String>();
        List<Schema.FieldSetMember> fieldSetMembers = SalesUtil.getFieldSet('Proforma_Export_List', 'ProformaDummy__c');

        List<String> fileHeaderList = new List<String>();
        for(Schema.FieldSetMember fieldSetMember : fieldSetMembers) {

            fileHeaderList.add(fieldSetMember.getLabel());
            fieldLabelValueMap.put(fieldSetMember.getLabel(), fieldSetMember.getFieldPath());
        }
        fileHeader = String.join(fileHeaderList, ',') + '\n';

        for(ProformaDummy__c proformaDummy : (List<ProformaDummy__c>) scope) {
            fileRow = '';
            fieldsList = new List<String>();

            for(String fieldAPI : fieldLabelValueMap.values()){
                String value = String.valueOf(proformaDummy.get(fieldAPI));
                if('Name'.equalsIgnoreCase(fieldAPI)) {
                    value = value.replace(',', ' ');
                }
                fieldsList.add(value);
            }

            fileRow = String.join(fieldsList, ',');
            generatedCSVFile += fileRow + '\n';
        }

    }

    /**
     * @description 세팅된 Data 를 기준으로 CSV 파일 생성을 1회 실행한다.
     * @param context
     */
    global void finish(Database.BatchableContext context) {
        String currentClassName = String.valueOf(this).substring(0, String.valueOf(this).indexOf(':'));
        System.debug(currentClassName + ' Finish !');
        logger.finish(gCnt, tCnt);

        Blob csvBlob = Blob.valueOf(fileHeader + generatedCSVFile);

        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.ContentDocumentId = null; // contentDocumentId;
        cv.VersionData = csvBlob;
        cv.Title = csvName + '.csv';
        cv.PathOnClient = csvName;
        cv.Description = changeDescription;

        System.debug('>> ' + UserInfo.getUserName());

        String title;
        try {
            insert cv;
            title = '[' + csvName + '] File Saved Successfully';
            System.debug('title > ' + title);

        } catch (Exception e) {
            System.debug('==' + e.getStackTraceString());
            System.debug('Error > ' + e.getMessage());
            title = 'Failed to download the file.';
        }

    }

}