/**
 * Created by changheekim on 2022/11/29.
 */

@IsTest
private class DevelopmentCurrency_tr_ts {
    @TestSetup
    static void setData(){
        insert SalesTestDataUtil.getDevelopment();
        insert SalesTestDataUtil.getDevelopmentPartsList();
        insert SalesTestDataUtil.getDevelopmentPartsVolumeList();
    }
    @IsTest
    static void testBehavior() {
        Test.startTest();

        List<SObject> updateList = new List<SObject>();
        List<DevelopmentPartsVolume__c> dpvList = new List<DevelopmentPartsVolume__c>();

        dpvList = [
                SELECT Id, DevelopmentParts__c, CurrencyIsoCode, CurrencyType__c, Usage__c,
                        IsStartYear__c, RelevantYear__c, VehicleVolume__c, Cost__c,
                        OptionRate__c, CRRate__c,LastYearCost__c FROM DevelopmentPartsVolume__c
        ];

        for (DevelopmentPartsVolume__c dpv : dpvList) {
            dpv.VehicleVolume__c = (dpv.VehicleVolume__c / 100000);
            updateList.add(dpv);
        }

        update updateList;

        Test.stopTest();
    }
}