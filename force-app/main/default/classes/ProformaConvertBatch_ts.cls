/***************************************************************************************
  * Project Name : Hyundai Mobis
  * File Name    : ProformaConvertBatch_ts
  * Description  :
  * Copyright    : Copyright © I2max. All Rights Reserved. 2022
  * Author       : KyeJin Cheong
  * Created Date : 2022-12-07
****************************************************************************************/

@IsTest
private class ProformaConvertBatch_ts {

    @TestSetup
    static void setData() {
        insert SalesTestDataUtil.getProformaCSVList();
    }

    @IsTest
    static void testCase01() {

        Test.startTest();

        List<ProformaDummy__c> proformaCSVList = [SELECT Id, Index__c, ExternalID__c FROM ProformaDummy__c];

        Map<String, ProformaDummy__c> upsertProformaMap = new Map<String, ProformaDummy__c>();

        for(ProformaDummy__c proformaCSV : proformaCSVList) {
            upsertProformaMap.put(proformaCSV.ExternalID__c, proformaCSV);
        }

        ProformaConvertBatch batch = new ProformaConvertBatch();

        batch.upsertProformaMap = upsertProformaMap;

        Database.executeBatch(batch);

        Test.stopTest();
    }

}