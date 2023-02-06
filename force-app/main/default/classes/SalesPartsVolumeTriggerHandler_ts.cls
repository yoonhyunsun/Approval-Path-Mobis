/**
 * Created by changheekim on 2022/11/28.
 */

@IsTest
private class SalesPartsVolumeTriggerHandler_ts {

    @TestSetup
    static void setData(){
        insert SalesTestDataUtil.getSalesPartsVolumeList();
    }

    @IsTest
    static void testBehavior() {
        Test.startTest();

        List<SalesPartsVolume__c> spvList = new List<SalesPartsVolume__c>();

        spvList = [
                SELECT Id, SalesParts__c, CurrencyIsoCode, CurrencyType__c, Usage__c,
                        IsStartYear__c, RelevantYear__c, VehicleVolume__c, Cost__c,
                        OptionRate__c, CRRate__c,LastYearCost__c FROM SalesPartsVolume__c
        ];

        Test.stopTest();
    }
}