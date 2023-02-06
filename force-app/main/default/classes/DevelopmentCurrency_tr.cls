/**
 * Created by changheekim on 2022/11/21.
 */

public with sharing class DevelopmentCurrency_tr extends TriggerHandler{

    public override void beforeUpdate(){
        ExpectedSalesChange((List<Development__c>) Trigger.old, (List<Development__c>) Trigger.new);
    }

    public static void ExpectedSalesChange(List<Development__c> oldDevList, List<Development__c> newDevList){

        if(null == oldDevList || null == newDevList) return;

        List<Development__c> changedList = new List<Development__c>();

        for (Integer i = 0; i < newDevList.size() ; i++) {
            Development__c oldDev = oldDevList.get(i);
            Development__c newDev = newDevList.get(i);

            if (oldDev.ru_ExpectedUSDConvert__c != newDev.ru_ExpectedUSDConvert__c || oldDev.ru_ExpectedSales__c != newDev.ru_ExpectedSales__c){
                changedList.add(newDev);
            }
        }

        if (changedList.isEmpty()) return;


        for (Development__c dev : changedList) {
            String convertStr = '' ;

            if(dev.CurrencyIsoCode == 'USD'){
                convertStr = AmountMilConverter(dev.CurrencyIsoCode, dev.ru_ExpectedSales__c);
            }else{
                convertStr = AmountMilConverter(dev.CurrencyIsoCode, dev.ru_ExpectedSales__c) + ' (' + AmountMilConverter('USD', dev.ru_ExpectedUSDConvert__c) + ')';
            }
            dev.ExpectedSales__c = convertStr;
        }
    }

    private static String AmountMilConverter(String currencyCode, Decimal targetAmount){
        String convertStr = '';
        Decimal decimalES;
        String strES='';
        String unit = ' Mil.';

        System.debug(currencyCode);
        System.debug(targetAmount);

        if( targetAmount > 1000000000){
            decimalES = (targetAmount/1000000).setScale(0);

            strES = String.valueOf(decimalES);
            String strFirst = strES.substring(0, strES.length() - 3);
            String strSecond = strES.substring(strES.length() - 3, strES.length());
            convertStr = currencyCode + ' ' + strFirst + ',' + strSecond + unit;

        }else if(targetAmount > 1000000){
            decimalES = (targetAmount/1000000).setScale(0);
            strES = String.valueOf(decimalES);
            convertStr = currencyCode + ' ' + strES + unit;

        }else if(targetAmount > 100000){
            decimalES = ((targetAmount/100000).setScale(0))* 0.1;
            strES = String.valueOf(decimalES);
            convertStr = currencyCode + ' ' + strES + unit;

        }else if(targetAmount > 0){
            convertStr = currencyCode + ' 0.1' + unit;
        }else{
            convertStr = currencyCode + ' 0.0' + unit;
        }

        return convertStr;
    }
}