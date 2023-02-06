/**
 * Created by changheekim on 2022/11/18.
 */

public with sharing class DevelopmentPartsVolumeTriggerHandler extends TriggerHandler{
    public override void beforeInsert(){
        calculateUSDAmount((List<DevelopmentPartsVolume__c>) Trigger.new);

    }
    public override void beforeUpdate(){
        calculateUSDAmount((List<DevelopmentPartsVolume__c>) Trigger.new);

    }

    private void calculateUSDAmount (List<DevelopmentPartsVolume__c> newList) {

        if (newList == null) return;

        Set<Id> ctIdSet = new Set<Id>();

        for (DevelopmentPartsVolume__c dpv : newList) {
            ctIdSet.add(dpv.CurrencyType__c);
        }

        if(ctIdSet.isEmpty()) return;

        Map<Id, Currency__c> ctMap = new Map<Id, Currency__c>([
                SELECT Id, Name, Year__c, JPY__c, MXN__c, RUB__c, USD__c, BRL__c, CAD__c,
                        CNY__c, EUR__c,INR__c, fm_CNYConversion__c, fm_EURConversion__c
                FROM Currency__c WHERE Id IN :  ctIdSet
        ]);

        for (DevelopmentPartsVolume__c dpv : newList) {
            if (dpv.CurrencyType__c != null) {
                String country = dpv.CurrencyIsoCode + '__c';
                Decimal countryRate;

                if(dpv.CurrencyIsoCode !='KRW' ){
                    if (ctMap.get(dpv.CurrencyType__c).get(country) == null) {
                        countryRate = 1;
                    }else{
                        countryRate = (Decimal) ctMap.get(dpv.CurrencyType__c).get(country);
                    }
                }
                if(dpv.CurrencyIsoCode == 'USD'){
                    dpv.USDConvertAmount__c = dpv.fm_TotalAmount__c;
                }else if(dpv.CurrencyIsoCode =='KRW'){
                    dpv.USDConvertAmount__c = dpv.fm_TotalAmount__c / ctMap.get(dpv.CurrencyType__c).USD__c;
                }else if(dpv.CurrencyIsoCode =='JPY'){
                    dpv.USDConvertAmount__c = dpv.fm_TotalAmount__c * countryRate * 0.01 / ctMap.get(dpv.CurrencyType__c).USD__c;
                }else{
                    dpv.USDConvertAmount__c = dpv.fm_TotalAmount__c * countryRate / ctMap.get(dpv.CurrencyType__c).USD__c;
                }
            }
        }
    }
}