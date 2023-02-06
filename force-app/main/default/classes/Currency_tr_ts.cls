/**
 * Created by hyunsunyoon on 2023/01/30.
 */

@IsTest
private class Currency_tr_ts {

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
        Id customerCurrency = SUtil.getRecordTypeId(Currency__c.class, 'Customer_Currency');

        List<Currency__c> currencyList = [SELECT Id, RecordTypeId, CustomerCurrencyEUR__c, CustomerCurrencyCNY__c, CustomerCurrencyJPY__c FROM Currency__c];
        for(Currency__c curr : currencyList) {
            curr.RecordTypeId = customerCurrency;
            curr.CustomerCurrencyEUR__c = 1.2;
            curr.CustomerCurrencyCNY__c = 6.5;
            updateList.add(curr);
        }

        List<Opportunity> optyList = [SELECT Id, ru_ExpectedSales__c, fm_ExpectedSalesrefDealgrade__c, CurrencyIsoCode, CurrencyType__c FROM Opportunity WHERE CurrencyType__c IN :currencyList];
        for (Opportunity opty : optyList) {
            opty.CurrencyIsoCode = 'CNY';
            updateList.add(opty);
        }

        update updateList;


        Test.stopTest();
    }
}