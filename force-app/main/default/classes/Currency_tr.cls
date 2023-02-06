public without sharing class Currency_tr extends TriggerHandler {
    public override void beforeUpdate(){
        currencyChanged((List<Currency__c>) Trigger.old, (List<Currency__c>) Trigger.new);
    }

    public override void afterUpdate(){
        currencyChanged((List<Currency__c>) Trigger.old, (List<Currency__c>) Trigger.new);
    }

    
    public static void currencyChanged(List<Currency__c> oldList ,List<Currency__c> newList){
        if (null == oldList || null == newList) return;
        Id customerCurrency = SUtil.getRecordTypeId(Currency__c.class, 'Customer_Currency');


        System.debug('old : '+oldList);
        System.debug('new : '+newList);
        List<Currency__c> changedList = new List<Currency__c>();
        for (Integer i = 0 ; i < newList.size() ; i++) {
            Currency__c oldCur = oldList.get(i);
            Currency__c newCur = newList.get(i);
            if(oldCur.CustomerCurrencyEUR__c != newCur.CustomerCurrencyEUR__c || oldCur.CustomerCurrencyCNY__c != newCur.CustomerCurrencyCNY__c || oldCur.CustomerCurrencyJPY__c != newCur.CustomerCurrencyJPY__c){
                if(newCur.RecordTypeId == customerCurrency){
                    changedList.add(newCur);
                }
            }
        }

        System.debug('changedList : ' + changedList);
        if(changedList.isEmpty()) return;

        List<SObject> updateList =  new List<SObject>();

        List<Opportunity> oppList = new List<Opportunity>([SELECT Id, Name, CurrencyType__c FROM Opportunity WHERE CurrencyType__c IN :changedList]);
        for (Opportunity opp : oppList) {
            opp.CurrencyType__c = opp.CurrencyType__c;
            opp.CustomerCurrencyChanged__c = 'Customer Currency Changed';
            updateList.add(opp);
        }
        System.debug('updateList : ' + updateList);
        update updateList;
    }
}