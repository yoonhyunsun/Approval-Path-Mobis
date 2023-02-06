/****************************************************************************************
  * @filename      : Opportunity_tr
  * @projectname   : Hyundai Mobis PS
  * @author        : EH LEE
  * @date          : 2022-09-19 
  * @group         : 
  * @group-content : 
  * @description   : 
  * @tester        : Opportunity_tr_ts.cls
  * @reference     : 
  * @copyright     : Copyright © I2max. All Rights Reserved.
  * @modification Log
  * ===============================================================
  * ver     date                author              description
  * ===============================================================
    0.1     2022-09-19            EH LEE                 Create
****************************************************************************************/

public without sharing class Opportunity_tr extends TriggerHandler{

    public override void beforeInsert(){
        this.setOpportunityName();
        this.setStageName();
    }

    public override void beforeUpdate(){
        this.setOpportunityName();
    }

    public override void afterUpdate(){
        this.updateContents();
    }

    public override void afterInsert(){
        this.setDefaultContents();
    }

    private void setStageName(){
        List<Opportunity> newData = Trigger.new != null ? (List<Opportunity>)Trigger.new : new List<Opportunity>();
        for(Opportunity oppty : newData){
            oppty.StageName = 'Qualification';
        }

    }

    private void updateContents(){
        Map<Id,Opportunity> newDataMap = Trigger.newMap != null ? (Map<Id,Opportunity>)Trigger.newMap : new Map<Id,Opportunity>();
        Map<String, String> docuTypes = new Map<String, String>();
        List<Contents__c> contents = [SELECT Id, DocumentType__c, Opportunity__c FROM Contents__c WHERE Opportunity__c IN :newDataMap.keySet()];//TODO
        //결과가 없으면??
        Map<String, Contents__c> cmap = new Map<String, Contents__c>();

        for(Contents__c c : contents){
            cmap.put(c.Opportunity__c + c.DocumentType__c, c);//TODO
        }

        //DocumentType & Department picklist Map
        List<DocumentType__mdt> mdtList = [SELECT DeveloperName, Department__c FROM DocumentType__mdt];
        Map<String, String> dcMap = new Map<String, String>();

        for(DocumentType__mdt mdt : mdtList){
            dcMap.put(mdt.DeveloperName, mdt.Department__c);
        }

        List<Schema.PicklistEntry> ple1 = Contents__c.DocumentType__c.getDescribe().getPicklistValues();
        for(Schema.PicklistEntry dcEntry : ple1) {
            if (dcEntry.getValue() != 'I') {
                docuTypes.put(dcEntry.getValue(), dcEntry.getLabel());
            }
        }

        List<Contents__c> typeToCreate = new List<Contents__c>();

        System.debug('[updateContents] updateContents > ');

        for(Id opptyId : newDataMap.keySet()) {
                for (String dc : docuTypes.keySet()) {
                if(!cmap.containsKey(opptyId + dc)) {
                    Contents__c content = new Contents__c();
                    content.Name = docuTypes.get(dc);
                    content.DocumentType__c = dc;
                    content.Opportunity__c = opptyId;//TODO
                    content.DepartmentIncharge__c = dcMap.get(dc);
                    typeToCreate.add(content);
                }
            }
        }

        insert typeToCreate;
    }

    private void setDefaultContents(){
        Map<Id,Opportunity> newDataMap = Trigger.newMap != null ? (Map<Id,Opportunity>)Trigger.newMap : new Map<Id,Opportunity>();
        List<Contents__c> contents = new List<Contents__c>();
        Map<String, String> docuTypes = new Map<String, String>();

        Set<Id> opptyIds = newDataMap.keySet();

        List<Schema.PicklistEntry> ple1 = Contents__c.DocumentType__c.getDescribe().getPicklistValues();
        List<Schema.PicklistEntry> ple2 = Contents__c.DepartmentIncharge__c.getDescribe().getPicklistValues();
        //DocumentType & Department picklist Map
        List<DocumentType__mdt> mdtList = [SELECT DeveloperName, Department__c FROM DocumentType__mdt];
        Map<String, String> dcMap = new Map<String, String>();

        for(DocumentType__mdt mdt : mdtList){
            dcMap.put(mdt.DeveloperName, mdt.Department__c);
        }

        for(Schema.PicklistEntry dcEntry : ple1){
            if (dcEntry.getValue() != 'I') {
                docuTypes.put(dcEntry.getValue(), dcEntry.getLabel());
            }
        }


        for(String opptyId : opptyIds) {
            for (String dt : docuTypes.keySet()) {
                Contents__c content = new Contents__c();
                content.Name = docuTypes.get(dt);
                content.DocumentType__c = dt;
                content.DepartmentIncharge__c = dcMap.get(dt);
                content.Opportunity__c = opptyId;//TODO
                contents.add(content);
            }
        }

        insert contents;

    }

    // Opportunity naming rule
    // account name + vehicle projects + product + sequence number 3 digits
    private void setOpportunityName(){
        List<Opportunity> newData = Trigger.new != null ? (List<Opportunity>)Trigger.new : new List<Opportunity>();
        Map<Object, String> vehicleMap = new Map<Object, String>();
        Map<Object, String> prodMap = new Map<Object, String>();
        Map<Object, String> accMap = new Map<Object, String>();
        Map<Object, String> vehicleProductMap = new Map<Object, String>();

        for(Opportunity oppty : newData){
//            if(oppty.VehicleProject__c!=null && oppty.Product__c!=null && oppty.AccountId!=null) {
            System.debug(oppty);
                vehicleMap.put(oppty, oppty.VehicleProject__c);
                prodMap.put(oppty, oppty.Product__c);
                accMap.put(oppty, oppty.AccountId);
//                vehicleProductMap.put(oppty, );
//            } else {
//                oppty.addError('Required field is empty.');
//            }
        }

        Map<Id, VehicleProject__c> idVehicleMap = new Map<Id, VehicleProject__c>([SELECT Id, Name FROM VehicleProject__c WHERE Id IN :vehicleMap.values()]);
        Map<Id, Product2> idProduct2Map = new Map<Id, Product2>([SELECT Id, Name FROM Product2 WHERE Id IN :prodMap.values()]);
        Map<Id, Account> idAccMap = new Map<Id, Account>([SELECT Id, Name FROM Account WHERE Id IN :accMap.values()]);

        String accName;
        String prodName;
        String vehicleName;

        for( Opportunity opportunity : newData ) {
            String vehicleId = vehicleMap.get(opportunity);
            VehicleProject__c vehicle = idVehicleMap.get(vehicleId);
            vehicleName = Util.isEmpty(vehicle.Name) ? 'Null' : vehicle.Name;

            String prodId = prodMap.get(opportunity);
            Product2 prod = idProduct2Map.get(prodId);
            prodName = Util.isEmpty(prod.Name) ? 'Null' : prod.Name;

            String accId = accMap.get(opportunity);
            Account acc = idAccMap.get(accId);
            accName = Util.isEmpty(acc.Name) ? 'Null' : acc.Name;

            opportunity.Name = accName + ' ' + vehicleName + ' ' + prodName;
        }

//        Map<Object, Integer> sequenceMap = setSequence(accMap, prodMap, vehicleMap, newData);
//        for( Opportunity opportunity : newData ){
//            opportunity.Name += ' - ' + sequenceMap.get(opportunity);
//        }

    }

    //(Deprecated)
//    private Map<Object, Integer> setSequence(Map<Object, String> accMap, Map<Object, String> prodMap, Map<Object, String> vehicleMap, List<Opportunity> opportunities){
//        Map<Object, Integer> seqMap = new Map<Object, Integer>(); // oppty와 sequence number 조합
//        List<String> keys = new List<String>();
//        String seqNum;
//
//        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, Name, (SELECT Id, VehicleProject__c, Name, Product__c FROM Opportunities) FROM Account WHERE Id IN :accMap.values()]);
//
//        //몇번째 oppty에 해당하는지 검색 후 sequence 생성
//        for (Account account : accountMap.values()) {
//               for(Opportunity oppty : account.Opportunities){
//                       keys.add(String.valueOf(account.Id) + String.valueOf(oppty.VehicleProject__c) + String.valueOf(oppty.Product__c));
//            }
//        }
//
//        Integer i=1;
//        for(Opportunity oppty : opportunities){
//            for(String key : keys) {
//                if (key==String.valueOf(oppty.AccountId) + String.valueOf(oppty.VehicleProject__c) + String.valueOf(oppty.Product__c)) {
//                    i++;
//                }
//            }
//            seqMap.put(oppty,i);
//        }
//
//        return seqMap;
//    }


}