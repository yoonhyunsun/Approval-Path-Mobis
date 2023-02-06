/**
 * Created by changheekim on 2022/11/08.
 */

public with sharing class DevelopmentPartsTriggerHandler extends TriggerHandler {

    public override void afterUpdate(){
        setDevPartsVolumes((List<DevelopmentParts__c>) Trigger.old, (List<DevelopmentParts__c>) Trigger.new);
    }

    private void setDevPartsVolumes(List<DevelopmentParts__c> oldDpList, List<DevelopmentParts__c> newDpList){

        if(newDpList == null || oldDpList == null) return;

        List<DevelopmentParts__c> changedList = new List<DevelopmentParts__c>();

        for (Integer i = 0; i < newDpList.size(); i++) {
            DevelopmentParts__c oldDp = newDpList.get(i);
            DevelopmentParts__c newDp = oldDpList.get(i);
            if( oldDp.ru_TotalAmount__c != newDp.ru_TotalAmount__c){
                changedList.add(newDp);
            }
        }

        if (changedList.isEmpty()) return;

        Set<Id> dpIdSet = new Set<Id>();
        List<String> dpYearList = new List<String>();
        List<String> relevantYearList = new List<String>();

        for (DevelopmentParts__c dp : changedList) {
            dpIdSet.add(dp.Id);
            dpYearList.add(dp.StartYear__c);
            dpYearList.add(dp.EndYear__c);
        }

        dpYearList.sort();
        Integer minYear = Integer.valueOf(dpYearList.get(0));
        Integer maxYear = Integer.valueOf(dpYearList.get(dpYearList.size() - 1));
        for (Integer i = 0; i < maxYear - minYear + 1; i++) {
            String relevantYear = String.valueOf(minYear + i);
            relevantYearList.add(relevantYear);
        }

        List<DevelopmentPartsVolume__c> dpvList = [
                SELECT Id, Cost__c, CRRate__c, fm_MobisProductVolume__c, fm_TotalAmount__c,
                        DevelopmentParts__c, IsStartYear__c, LastYearCost__c, Name, OptionRate__c,
                        RelevantYear__c, Usage__c
                FROM DevelopmentPartsVolume__c
                WHERE DevelopmentParts__c =: dpIdSet
                ORDER BY RelevantYear__c
        ];

        Map<String, Map<String,DevelopmentPartsVolume__c>> dpYearDpvMap = new Map<String, Map<String, DevelopmentPartsVolume__c>>();

        for (DevelopmentPartsVolume__c dpv : dpvList) {
            if (dpYearDpvMap.containsKey(dpv.DevelopmentParts__c)) {
                if (!dpYearDpvMap.get(dpv.DevelopmentParts__c).containsKey(dpv.RelevantYear__c)) {
                    dpYearDpvMap.get(dpv.DevelopmentParts__c).put(dpv.RelevantYear__c, dpv);
                }
            }else{
                 dpYearDpvMap.put(dpv.DevelopmentParts__c, new Map<String, DevelopmentPartsVolume__c>{
                         dpv.RelevantYear__c => dpv
                 });
            }
        }

        List<DevelopmentPartsVolume__c> updateDpvList = new List<DevelopmentPartsVolume__c>();

        for (String dpIdKey : dpYearDpvMap.keySet()) {
            for (Integer i = 0; i < relevantYearList.size() - 1; i++) {
                if (dpYearDpvMap.get(dpIdKey).containsKey(relevantYearList[i])) {

                    DevelopmentPartsVolume__c currentDpv = dpYearDpvMap.get(dpIdKey).get(relevantYearList[i]);

                    if (currentDpv.IsStartYear__c) {
                        currentDpv.LastYearCost__c = currentDpv.fm_TotalAmount__c / currentDpv.fm_MobisProductVolume__c;
                        updateDpvList.add(currentDpv);
                    }

                    for(Integer j = i + 1; j < relevantYearList.size(); j++){
                        if (dpYearDpvMap.get(dpIdKey).containsKey(relevantYearList[j])) {

                            DevelopmentPartsVolume__c nextDpv = (DevelopmentPartsVolume__c) dpYearDpvMap.get(dpIdKey).get(relevantYearList[j]);

                            if (currentDpv.fm_MobisProductVolume__c != 0 && currentDpv.fm_MobisProductVolume__c != null){

                                Decimal beforeRound = (currentDpv.fm_TotalAmount__c / currentDpv.fm_MobisProductVolume__c);
                                nextDpv.LastYearCost__c = beforeRound.setScale(6, RoundingMode.HALF_UP);
                            /**
                            * TODO: check condition
                            */
                            }else if(currentDpv.fm_MobisProductVolume__c != 0){
                                nextDpv.LastYearCost__c = currentDpv.LastYearCost__c;
                            }
                            updateDpvList.add(nextDpv);
                            break;
                        }
                    }
                }
            }
        }

        for (DevelopmentPartsVolume__c dpv : updateDpvList) {
            if(dpv.LastYearCost__c != 0 && dpv.LastYearCost__c != null) {
                Decimal newCost = (dpv.LastYearCost__c * (100 - dpv.CRRate__c)) / 100;
                dpv.Cost__c = newCost.setScale(4, RoundingMode.HALF_UP);
            }
        }

        Database.update(updateDpvList);
//        Database.SaveResult[] srList = Database.update(updateDpvList);
//        for (Database.SaveResult sr : srList) {
//            System.debug(sr);
//        }
    }

}