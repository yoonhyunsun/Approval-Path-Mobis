/**
 * Created by changheekim on 2022/11/15.
 */

public without sharing class OpportunityCurrency_tr extends TriggerHandler {

    public override void beforeUpdate(){
        ExpectedSalesChange((List<Opportunity>) Trigger.old, (List<Opportunity>) Trigger.new);
    }

    public override void afterUpdate(){
        currencyTypeChange((List<Opportunity>) Trigger.old, (List<Opportunity>) Trigger.new);
    }
    /**
        * opty의 currency type이 바뀌는 경우 동작 하는 트리거
        * opty가의 currency가 바뀌면 하위 salesParts PartsVolume 의 currency가 전부 바뀌어야한다.
        * 바뀌면서 salesParts, partsVolume모두 업데이트 된다.
        *
    */
    public static void currencyTypeChange(List<Opportunity> oldOptyList ,List<Opportunity> newOptyList){
        if (null == oldOptyList || null == newOptyList) return;

    
        List<Opportunity> changedList = new List<Opportunity>();
        for (Integer i = 0 ; i < newOptyList.size() ; i++) {
            Opportunity oldOpty = oldOptyList.get(i);
            Opportunity newOpty = newOptyList.get(i);

            if(newOpty.CustomerCurrencyChanged__c == 'Customer Currency Changed' || oldOpty.CurrencyType__c != newOpty.CurrencyType__c || oldOpty.CurrencyIsoCode != newOpty.CurrencyIsoCode){
                changedList.add(newOpty);
            }
        }
        
        if(changedList.isEmpty()) return;

        List<SObject> updateList =  new List<SObject>();

        List<SalesParts__c> spList = new List<SalesParts__c>([SELECT Id, Name, Opportunity__r.CurrencyIsoCode, Opportunity__r.CurrencyType__c, CurrencyIsoCode FROM SalesParts__c WHERE Opportunity__c IN :changedList]);
        for (SalesParts__c sp : spList) {
            sp.CurrencyIsoCode = sp.Opportunity__r.CurrencyIsoCode;
            sp.CurrencyType__c = sp.Opportunity__r.CurrencyType__c;
            updateList.add(sp);
        }

        List<SalesPartsVolume__c> spvList = new List<SalesPartsVolume__c>([SELECT Id, SalesParts__r.Opportunity__r.CurrencyIsoCode, SalesParts__r.Opportunity__r.CurrencyType__c  FROM SalesPartsVolume__c WHERE SalesParts__c IN :spList]);
        for (SalesPartsVolume__c spv : spvList) {
            spv.CurrencyIsoCode = spv.SalesParts__r.Opportunity__r.CurrencyIsoCode;
            spv.CurrencyType__c = spv.SalesParts__r.Opportunity__r.CurrencyType__c;
            updateList.add(spv);
        }

        update updateList;
    }
    /**
        * opty의 currency type이 바뀌거나, rollup한 값이 바뀌게 되면
        * opty에서 USD로 환율 계산된 값을 저장하는 트리거
        *
    */
    private static void ExpectedSalesChange(List<Opportunity> oldOptyList ,List<Opportunity> newOptyList){

        if (null == oldOptyList || null == newOptyList) return;


        Set<Id> ctIdSet = new Set<Id>();
        List<Opportunity> changedList = new List<Opportunity>();

        for (Integer i = 0 ; i < newOptyList.size() ; i++) {
            Opportunity oldOpty = oldOptyList.get(i);
            Opportunity newOpty = newOptyList.get(i);

            if( oldOpty.ru_ExpectedUSDConvert__c != newOpty.ru_ExpectedUSDConvert__c || oldOpty.ru_ExpectedSales__c != newOpty.ru_ExpectedSales__c || oldOpty.CurrencyType__c != newOpty.CurrencyType__c || oldOpty.CurrencyIsoCode != newOpty.CurrencyIsoCode){
                changedList.add(newOpty);
                ctIdSet.add(newOpty.CurrencyType__c);
            }
        }

        if(changedList.isEmpty()) return;


        for (Opportunity opty : changedList) {

            String convertStr = '' ;
            String dealGradeStr ='';

            if(opty.CurrencyIsoCode == 'USD'){
                convertStr = AmountMilConverter(opty.CurrencyIsoCode, opty.ru_ExpectedSales__c);
                dealGradeStr = AmountMilConverter(opty.CurrencyIsoCode, opty.fm_ExpectedSalesrefDealgrade__c);
            }else{
                convertStr = AmountMilConverter(opty.CurrencyIsoCode, opty.ru_ExpectedSales__c) + ' (' + AmountMilConverter('USD', opty.ru_ExpectedUSDConvert__c) + ')';
                dealGradeStr = AmountMilConverter(opty.CurrencyIsoCode, opty.fm_ExpectedSalesrefDealgrade__c) + ' (' + AmountMilConverter('USD', opty.fm_ExpectedUSDConvertrefDealgrade__c) + ')';
            }
            opty.ExpectedSales__c = convertStr;
            opty.ExpectedSalesrefDealgrade__c = dealGradeStr;
        }
    }
    /**
        * 계산된 값에 unit 붙이는 메서드
        *
    */
    private static String AmountMilConverter(String currencyCode, Decimal targetAmount){
        String convertStr = '';
        Decimal decimalES;
        String strES='';
        String unit = ' Mil.';

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