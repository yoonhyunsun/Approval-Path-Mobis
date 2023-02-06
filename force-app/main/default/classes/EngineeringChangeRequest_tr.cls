/**
 * Created by changheekim on 2022/11/22.
 */

public with sharing class EngineeringChangeRequest_tr extends TriggerHandler{
    public override void afterUpdate(){
        rollupPiecePriceDevParts((List<EngineeringChangeRequest__c>) Trigger.old ,  (List<EngineeringChangeRequest__c>) Trigger.new);
    }
    /**
       * ECR에는 각각의 ECP가 연결되어 값을 rollup할 수 있는데
       * DevPart와 ECR은 M-D가 아니기 때문에 직접 rollup을 해주는 트리거
       *
   */
    public static void rollupPiecePriceDevParts (List<EngineeringChangeRequest__c> oldECRList ,  List<EngineeringChangeRequest__c> newECRList){

        if (null == oldECRList || null == newECRList) return;

        List<EngineeringChangeRequest__c> changedList = new List<EngineeringChangeRequest__c>();
        Set<Id> devIdSet = new Set<Id>();

        for (Integer i = 0 ; i < newECRList.size() ; i++) {
            EngineeringChangeRequest__c oldECR = oldECRList.get(i);
            EngineeringChangeRequest__c newECR = newECRList.get(i);
            if(oldECR.fm_CurrentTotalPiecePrice__c != newECR.fm_CurrentTotalPiecePrice__c){

                changedList.add(newECR);
                devIdSet.add(newECR.Development__c);
            }
        }
        if(changedList.isEmpty()) return;


        List<EngineeringChangeRequest__c> allECRList = new List<EngineeringChangeRequest__c>([
                SELECT Id, Name, Development__c, PN1__c, ru_CurrPiecePriceSourcingExc1__c,
                        PN2__c, ru_CurrPiecePriceSourcingExc2__c, PN3__c, ru_CurrPiecePriceSourcingExc3__c, 
                        PN4__c, ru_CurrPiecePriceSourcingExc4__c, PN5__c, ru_CurrPiecePriceSourcingExc5__c, 
                        PN6__c, ru_CurrPiecePriceSourcingExc6__c, PN7__c, ru_CurrPiecePriceSourcingExc7__c, 
                        PN8__c, ru_CurrPiecePriceSourcingExc8__c, PN9__c, ru_CurrPiecePriceSourcingExc9__c, 
                        PN10__c, ru_CurrPiecePriceSourcingExc10__c, PN11__c, ru_CurrPiecePriceSourcingExc11__c, 
                        PN12__c, ru_CurrPiecePriceSourcingExc12__c, PN13__c, ru_CurrPiecePriceSourcingExc13__c, 
                        PN14__c, ru_CurrPiecePriceSourcingExc14__c, PN15__c, ru_CurrPiecePriceSourcingExc15__c 
                FROM EngineeringChangeRequest__c WHERE Development__c IN : devIdSet
        ]);


        Map<Id, EngineeringChangeRequest__c> ecrIdMap = new Map<Id, EngineeringChangeRequest__c>();
        Map <Id, Map<Id,EngineeringChangeRequest__c>> devIdEcrMap = new Map<Id, Map<Id, EngineeringChangeRequest__c>>();
        //<dev Id , <ECR Id, ECR>>
        for (EngineeringChangeRequest__c ecr : allECRList) {
            if (devIdEcrMap.containsKey(ecr.Development__c)) {
                if(!devIdEcrMap.get(ecr.Development__c).containsKey(ecr.Id)){
                    devIdEcrMap.get(ecr.Development__c).put(ecr.Id, ecr);
                }
            }else{
                devIdEcrMap.put(ecr.Development__c, new Map<Id, EngineeringChangeRequest__c>{
                        ecr.Id => ecr
                });
            }
        }


        Map<Id, Map<Id, Decimal>> devIdAmountMap =  new Map<Id, Map<Id, Decimal>>();
        Map<Id, Decimal> pnAmountMap = new Map<Id, Decimal>();

        for (Id devId : devIdEcrMap.keySet()) {
            ecrIdMap = devIdEcrMap.get(devId);
            for (Id ecrId : ecrIdMap.keySet()) {
                for (Integer i = 1; i < 16; i++) {
                    String pn ='PN'+i+'__c'; // 해당 devPart Id
                    String piecePrice ='ru_CurrPiecePriceSourcingExc'+i+'__c';

                    if(ecrIdMap.get(ecrId).get(pn) != null){
                        if (devIdAmountMap.containsKey(devId)) {
                            if (devIdAmountMap.get(devId).containsKey((Id)ecrIdMap.get(ecrId).get(pn))) {
                                pnAmountMap = devIdAmountMap.get(devId);
                                Decimal Amount = (Decimal) pnAmountMap.get((Id) ecrIdMap.get(ecrId).get(pn));
                                Amount += (Decimal) ecrIdMap.get(ecrId).get(piecePrice);
                                pnAmountMap.put((Id) ecrIdMap.get(ecrId).get(pn), Amount);
                            }else{
                                devIdAmountMap.get(devId).put((Id)ecrIdMap.get(ecrId).get(pn), (Decimal) ecrIdMap.get(ecrId).get(piecePrice));
                            }
                        }else {
                            devIdAmountMap.put(devId, new Map<Id, Decimal>{
                                    (Id) ecrIdMap.get(ecrId).get(pn) => (Decimal) ecrIdMap.get(ecrId).get(piecePrice)
                            });
                        }
                    }
                }
            }
        }

        List<DevelopmentParts__c> dpList = new List<DevelopmentParts__c>();

        for (Id devId : devIdAmountMap.keySet()) {
            pnAmountMap = devIdAmountMap.get(devId);

            for (Id pnId : pnAmountMap.keySet()) {
                DevelopmentParts__c dp = new DevelopmentParts__c();
                dp.Id = pnId;
                dp.ECRTotalPiecePrice__c = pnAmountMap.get(pnId);
                dpList.add(dp);
            }
        }

        Database.SaveResult[] dpsr = Database.update (dpList, true);

//        for (Database.SaveResult sr : dpsr) {
//            System.debug(sr);
//        }


    }
}