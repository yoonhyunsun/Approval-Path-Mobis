/**
 * Created by changheekim on 2022/11/30.
 */

public with sharing class EngineeringChangeProposal_tr extends TriggerHandler{
    public override void beforeUpdate(){

    }
    public override void afterUpdate(){
        setDevelopmentPartNumber((List<EngineeringChangeProposal__c>) Trigger.old ,  (List<EngineeringChangeProposal__c>) Trigger.new);

    }
    /**
       * ECP에서 개발중 파츠의 이름이 수정이 되면 그에 해당하는 devParts의
       * 이름이 변경되어야 한다, 그에 따른 이름 변경 트리거
       *
   */
    public static void setDevelopmentPartNumber(List<EngineeringChangeProposal__c> oldECPList, List<EngineeringChangeProposal__c> newECPList){

        if (oldECPList == null || newECPList == null) return;

        Set<Id> dpIdSet = new Set<Id>();
        Map<Id, String> changedDpIdMap = new Map<Id, String>();

        for (Integer i = 0; i < newECPList.size(); i++) {
            EngineeringChangeProposal__c oldECP = oldECPList.get(i);
            EngineeringChangeProposal__c newECP = newECPList.get(i);

            for (Integer j = 1; j < 16; j ++){
                String pnStr = 'PN'+j+'__c';
                String currentPnStr = 'CurrentPN'+j+'__c';
                //과거 partNumber와 현재 partNumber 비교
                if (oldECP.get(currentPnStr) != newECP.get(currentPnStr)) {
                    dpIdSet.add(String.valueOf(newECP.get(pnStr)));//바뀌어야하는 devPart Id
                    changedDpIdMap.put(String.valueOf(newECP.get(pnStr)), String.valueOf(newECP.get(currentPnStr))); //바뀌어야하는 devPartId랑 value
                }
            }
        }

        if (changedDpIdMap.isEmpty()) return;

        List<DevelopmentParts__c> dpList = [SELECT Id, Name FROM DevelopmentParts__c WHERE Id IN : dpIdSet];

        for (DevelopmentParts__c dp : dpList) {
            if (changedDpIdMap.containsKey(dp.Id)) {
                dp.Name = changedDpIdMap.get(dp.Id);
            }
        }

        update dpList;
    }


}