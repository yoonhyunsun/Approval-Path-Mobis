/**
 * Created by changheekim on 2022/09/14.
 */

public without sharing class SalesPartsTriggerHandler extends TriggerHandler{
    private static Integer count = 0;
    public override void beforeInsert(){
        setPinNumber();
    }

    public override void afterUpdate(){
        setSalesPartsVolumes();
    }
    /**
        * salesParts 의 값이 변경되면 작동하는 트리거,
        * 하위 SalesPartsVolume의 단가에 cr률 전체적으로 적용하여 저장한다.
        * PartsVolume에 값이 변동되고 난뒤 salesPart 가 변동되기 때문에
        * 다음년도의 단가를 조정하는식으로 저장한다.
        * 중간이 비어있는 경우 때문에 작성되었으나 변경
        *
    */
    private void setSalesPartsVolumes(){

        List<SalesParts__c> spList = (List<SalesParts__c>) Trigger.new;
        Set<Id> spIdSet = new Set<Id>();

        List<String> spYearList = new List<String>();
        List<String> relevantYearList = new List<String>();

        for (SalesParts__c sp : spList) {
            spIdSet.add(sp.Id);
            spYearList.add(sp.StartYear__c);
            spYearList.add(sp.EndYear__c);
        }
        //해당 salesParts의 시작년도와 마지막년도로 년도를 계산
        spYearList.sort();
        Integer minYear = Integer.valueOf(spYearList.get(0));
        Integer maxYear = Integer.valueOf(spYearList.get(spYearList.size() - 1));
        for (Integer i = 0; i < maxYear - minYear + 1; i++) {
            String relevantYear = String.valueOf(minYear + i);
            relevantYearList.add(relevantYear);
        }

        List<SalesPartsVolume__c> spvList = [
                SELECT Id, Cost__c, CRRate__c, fm_MobisProductVolume__c,
                        fm_TotalAmount__c, Name, OptionRate__c, RelevantYear__c, SalesParts__c, LastYearCost__c,
                        Usage__c, VehicleVolume__c, CurrencyIsoCode, IsStartYear__c
                FROM SalesPartsVolume__c
                WHERE SalesParts__c = :spIdSet
                ORDER BY RelevantYear__c
        ];
        //Map<salesPartId , <RelevantYear, PartsVolume>>
        //salesParts의 아이디를 기준으로 년도와 partsVolume에 대한 값을 Map으로 저장한다.
        Map<String, Map<String, SalesPartsVolume__c>> spYearSpvMap = new Map<String, Map<String, SalesPartsVolume__c>>();

        for (SalesPartsVolume__c spv : spvList) {
            if (spYearSpvMap.containsKey(spv.SalesParts__c)) {//salesParts가 있을때
                if (!spYearSpvMap.get(spv.SalesParts__c).containsKey(spv.RelevantYear__c)) {// 해당년도의 값이 없을떼
                    spYearSpvMap.get(spv.SalesParts__c).put(spv.RelevantYear__c, spv);
                }
            } else { //salesParts가 없을때
                spYearSpvMap.put(spv.SalesParts__c, new Map<String, SalesPartsVolume__c>{
                        spv.RelevantYear__c => spv
                });
            }
        }

        List<SalesPartsVolume__c> updateSpvList = new List<SalesPartsVolume__c>();

        for (String spIdKey : spYearSpvMap.keySet()) {//들어온 salesParts 기준 반복
            for (Integer i = 0; i < relevantYearList.size() - 1; i++) {// 만들어놓은 해당년도 만큼 반복
                if (spYearSpvMap.get(spIdKey).containsKey(relevantYearList[i])) {//해당되는 parts volume이면

                    SalesPartsVolume__c currentSpv = spYearSpvMap.get(spIdKey).get(relevantYearList[i]);

                    if(currentSpv.IsStartYear__c){ //시작 년도 일때.
                        if (currentSpv.fm_MobisProductVolume__c != 0 && currentSpv.fm_TotalAmount__c != 0) {
                            currentSpv.LastYearCost__c = currentSpv.fm_TotalAmount__c / currentSpv.fm_MobisProductVolume__c;
                        }else{
                            currentSpv.LastYearCost__c = 0;
                        }
                        updateSpvList.add(currentSpv);
                    }

                    for (Integer j = i + 1; j < relevantYearList.size(); j++) {//다음에 오는 해에 lastYearCost 값 넣고 break, lastYearCost 계산하기 위해 전달되는 값
                        if (spYearSpvMap.get(spIdKey).containsKey(relevantYearList[j])) {
                            SalesPartsVolume__c nextSpv = spYearSpvMap.get(spIdKey).get(relevantYearList[j]);

                            if(currentSpv.fm_MobisProductVolume__c != 0 && currentSpv.fm_MobisProductVolume__c != null){
                                Decimal beforeRound = (currentSpv.fm_TotalAmount__c / currentSpv.fm_MobisProductVolume__c);// currenctSpv.LastYearCost
                                nextSpv.LastYearCost__c = beforeRound.setScale(6, RoundingMode.HALF_UP);
//
//                            }else if(currentSpv.fm_MobisProductVolume__c != 0){
//                                nextSpv.LastYearCost__c = currentSpv.LastYearCost__c;
                            }
                            System.debug(i);
                            System.debug(j);
                            System.debug(currentSpv.LastYearCost__c);
                            System.debug(nextSpv.LastYearCost__c);
                            updateSpvList.add(nextSpv);
                            break;
                        }
                    }
                }
            }
        }
        //요청사항으로 변경 당해년도의 값이변경되어야해서 cost 변경하는 부분 추가.
        System.debug('updateSpvList.size() '+updateSpvList.size());
        for (SalesPartsVolume__c spv : updateSpvList) {
            if(spv.LastYearCost__c != 0 && spv.LastYearCost__c != null){
                Decimal newCost = (spv.LastYearCost__c * (100 - spv.CRRate__c)) / 100;
                spv.Cost__c = newCost.setScale(4,RoundingMode.HALF_UP );
                System.debug(spv.Cost__c);
            }
        }

        Database.update(updateSpvList);
//        Database.SaveResult[] srList = Database.update(updateSpvList);
//        for (Database.SaveResult sr : srList) {
//            System.debug(sr);
//        }
    }

    /**
        * pinNumber--> Parts Number가 생성될 때 값이 비어있으면 NPN-00000 의 형식으로 생성되게끔 하는 트리거
        * npn으로 검색한후 값을 가져와 가장 큰 수의 다음 값으로 저장
        *
    */
    private void setPinNumber() {
        List<SalesParts__c> spList = (List<SalesParts__c>) Trigger.new;
        List<SalesParts__c> lastNPN = [SELECT Id, PinNumber__c, Opportunity__c FROM SalesParts__c WHERE PinNumber__c LIKE '%NPN-%' ORDER BY PinNumber__c DESC LIMIT 1];

        if(lastNPN.size() > 0) {
            String subStr = lastNPN[0].PinNumber__c.substring(0, 4);
            String subNum = lastNPN[0].PinNumber__c.substring(4);
            count = Integer.valueOf(subNum);

            for (SalesParts__c sp : spList) {
                if (sp.PinNumber__c == '' || sp.PinNumber__c == null) {
                    count++;
                    String zeroStr = '00000' + count;
                    Integer size = zeroStr.length();
                    String inNPN = subStr + zeroStr.substring(size - 5, size);
                    sp.PinNumber__c = inNPN;
                }
            }
        }else{
            for (Integer i = 0; i < spList.size(); i++) {
                if (spList[i].PinNumber__c == '' || spList[i].PinNumber__c == null) {
                    count++;
                    String zeroStr = '00000' + count;
                    Integer size = zeroStr.length();
                    String inNPN = 'NPN-' + zeroStr.substring(size - 5, size);
                    spList[i].PinNumber__c = inNPN;
                }
            }
        }
    }
}