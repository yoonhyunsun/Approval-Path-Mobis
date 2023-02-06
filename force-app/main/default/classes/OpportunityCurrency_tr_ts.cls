/**
 * Created by changheekim on 2022/11/29.
 */

@IsTest
private class OpportunityCurrency_tr_ts {

    @TestSetup
    static void setData(){
        insert SalesTestDataUtil.getOpportunity();
        insert SalesTestDataUtil.getSalesPartsList();
        insert SalesTestDataUtil.getSalesPartsVolumeList();
    }
    @IsTest
    static void testBehavior() {
        Test.startTest();

        List<SObject>updateList = new List<SObject>();

        List<Opportunity> optyList = [SELECT Id, ru_ExpectedSales__c, fm_ExpectedSalesrefDealgrade__c, CurrencyIsoCode, CurrencyType__c FROM Opportunity];
        for (Opportunity opty : optyList) {
            opty.CurrencyIsoCode = 'USD';
            updateList.add(opty);
        }
        List<SalesParts__c> spList = new List<SalesParts__c>([SELECT Id, Name, Opportunity__r.CurrencyIsoCode, Opportunity__r.CurrencyType__c, CurrencyIsoCode FROM SalesParts__c WHERE Opportunity__c IN :optyList]);
        List<SalesPartsVolume__c> spvList = new List<SalesPartsVolume__c>([SELECT Id, VehicleVolume__c, SalesParts__r.Opportunity__r.CurrencyIsoCode, SalesParts__r.Opportunity__r.CurrencyType__c  FROM SalesPartsVolume__c WHERE SalesParts__c IN :spList]);
        for (SalesPartsVolume__c spv : spvList) {
            spv.VehicleVolume__c = (spv.VehicleVolume__c / 100000);
            updateList.add(spv);
        }

        update updateList;


        Test.stopTest();
    }
}