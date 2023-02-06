/**
 * Created by changheekim on 2022/11/29.
 */

@IsTest
private class DevelopmentPartsVolumeTriggerHandler_ts {

    @TestSetup
    static void setData(){
        insert SalesTestDataUtil.getDevelopmentPartsVolumeList();
    }

    @IsTest
    static void testBehavior() {
        Test.startTest();

        List<DevelopmentPartsVolume__c> dpvList = new List<DevelopmentPartsVolume__c>();

        dpvList = [
                SELECT Id, DevelopmentParts__c, CurrencyIsoCode, CurrencyType__c, Usage__c,
                        IsStartYear__c, RelevantYear__c, VehicleVolume__c, Cost__c,
                        OptionRate__c, CRRate__c,LastYearCost__c FROM DevelopmentPartsVolume__c
        ];

        Test.stopTest();
    }
}