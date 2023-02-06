/**
 * Created by changheekim on 2022/11/23.
 */

public with sharing class LumpSumCollectionCurrency_tr extends TriggerHandler{

    public override void beforeUpdate(){
        ExpectedSalesChange((List<LumpSumCollectionManagement__c>) Trigger.old, (List<LumpSumCollectionManagement__c>) Trigger.new);
    }

    public static void ExpectedSalesChange(List<LumpSumCollectionManagement__c> oldLscList, List<LumpSumCollectionManagement__c> newLscList){

        if(oldLscList == null || newLscList == null) return;

        List<LumpSumCollectionManagement__c> changedList = new List<LumpSumCollectionManagement__c>();
        Set<Id> ctIdSet = new Set<Id>();

        for (Integer i = 0; i < newLscList.size(); i++) {
            LumpSumCollectionManagement__c oldLsc = oldLscList.get(i);
            LumpSumCollectionManagement__c newLsc = newLscList.get(i);

            if (oldLsc.TotalAmount__c != newLsc.TotalAmount__c || oldLsc.EDDCost__c != newLsc.EDDCost__c) {
                changedList.add(newLsc);
                ctIdSet.add(newLsc.CurrencyType__c);
            }
        }

        if(changedList.isEmpty()) return;

        Map<Id, Currency__c> ctMap = new Map<Id, Currency__c>([
                SELECT Id, Name, Year__c, JPY__c, MXN__c, RUB__c, USD__c, BRL__c, CAD__c,
                        CNY__c, EUR__c,INR__c, fm_CNYConversion__c, fm_EURConversion__c
                FROM Currency__c WHERE Id IN :  ctIdSet
        ]);

        Id toolingId = Schema.SObjectType.LumpSumCollectionManagement__c.getRecordTypeInfosByDeveloperName().get('Tooling_Cost_Management').getRecordTypeId();

        for (LumpSumCollectionManagement__c lsc : changedList) {
            Decimal targetCost = 0;

            if (lsc.RecordTypeId == toolingId) {
                targetCost = lsc.TotalAmount__c;
            }else{
                targetCost = lsc.EDDCost__c;
            }
            
            String country = lsc.CurrencyIsoCode+'__c';
            Decimal countryRate = 1;

            if(lsc.CurrencyIsoCode !='KRW' ){
                countryRate = (Decimal) ctMap.get(lsc.CurrencyType__c).get(country);
            }

            if(lsc.CurrencyIsoCode == 'USD'){
                lsc.USDConvertCost__c = targetCost;
            }else if(lsc.CurrencyIsoCode =='KRW'){
                lsc.USDConvertCost__c = targetCost / ctMap.get(lsc.CurrencyType__c).USD__c;
            }else if(lsc.CurrencyIsoCode =='JPY'){
                lsc.USDConvertCost__c = targetCost * countryRate * 0.01 / ctMap.get(lsc.CurrencyType__c).USD__c;
            }else{
                lsc.USDConvertCost__c = targetCost * countryRate / ctMap.get(lsc.CurrencyType__c).USD__c;
            }

            if (lsc.CurrencyIsoCode == 'USD') {
                lsc.TotalCost__c = CostMilConvert(lsc.CurrencyIsoCode, targetCost);
            }else{
                lsc.TotalCost__c = CostMilConvert(lsc.CurrencyIsoCode, targetCost) + ' (' + CostMilConvert('USD', lsc.USDConvertCost__c) + ')';
            }
        }
    }
    
    public static String CostMilConvert(String currencyCode, Decimal targetCost){
        String convertStr = '';
        Decimal decimalES;
        String strES= '';
        String unit = ' Mil.';

        System.debug(currencyCode);
        System.debug(targetCost);

        if( targetCost > 1000000000){
            decimalES = (targetCost/1000000).setScale(0);

            strES = String.valueOf(decimalES);
            String strFirst = strES.substring(0, strES.length() - 3);
            String strSecond = strES.substring(strES.length() - 3, strES.length());
            convertStr = currencyCode + ' ' + strFirst + ',' + strSecond + unit;

        }else if(targetCost > 1000000){
            decimalES = (targetCost/1000000).setScale(0);
            strES = String.valueOf(decimalES);
            convertStr = currencyCode + ' ' + strES + unit;

        }else if(targetCost > 1000){
            strES = String.valueOf(targetCost.setScale(0));
            String strFirst = strES.substring(0, strES.length() - 3);
            String strSecond = strES.substring(strES.length() - 3, strES.length());
            convertStr = currencyCode + ' ' + strFirst + ',' + strSecond;

        }else{
            strES = String.valueOf(targetCost.setScale(0));
            convertStr = currencyCode + ' ' + strES;
        }

        return convertStr;
    }
    
    
}