/**
 * Created by changheekim on 2022/10/11.
 */

public without sharing abstract class ProjectTreeUtils {

    /**
        * 해당 차량 프로젝트의 opty를 가져오는 메서드.
        *
        * @author chkim
        * @param String recordId
        * @return Account
        *
    */
    public static Account getProjectAccount (String recordId){
        VehicleProject__c vp =  [SELECT Id, Name, AccountName__r.Name, AccountName__c, AccountName__r.ValueChain__c, AccountName__r.Phone, AccountName__r.Type FROM VehicleProject__c WHERE Id =: recordId];
        Account ac = new Account(
                Id = vp.AccountName__c,
                Name = vp.AccountName__r.Name,
                ValueChain__c = vp.AccountName__r.ValueChain__c,
                Phone = vp.AccountName__r.Phone,
                Type = vp.AccountName__r.Type);
        System.debug(ac);
        return ac;
    }

    /**
        * 해당 차량 프로젝트의 opty를 가져오는 메서드.
        *
        * @author chkim
        * @param String recordId
        * @return Map<String, Object>
        *
    */
    public static Map<String, Object> getVehicleProject(String recordId){
        Map<String, Object> getProjectMap = new Map<String, Object>();
        List<VehicleProject__c> vpList = new List<VehicleProject__c>();

        VehicleProject__c vehicleProject = [SELECT Id, Description__c, Name, RecordTypeId FROM VehicleProject__c WHERE Id =: recordId];
        vpList.add(vehicleProject);
        Double vehicleTotalAmount = 0;

        Id gPlatformId = Schema.SObjectType.VehicleProject__c.getRecordTypeInfosByDeveloperName().get('Platform').getRecordTypeId();

        if(vehicleProject.RecordTypeId == gPlatformId){
            List<Opportunity> optyList = [SELECT Id, Name, StageName, ru_ExpectedSales__c FROM Opportunity WHERE VehicleProject__c =: recordId];
            Decimal totalAmount = 0;
            for (Opportunity opty : optyList) {
                totalAmount += (opty.ru_ExpectedSales__c);
            }
            vehicleTotalAmount = totalAmount;
        }else{
            List<SalesParts__c> spList = new List<SalesParts__c>();
            spList = [SELECT Id, VehicleProject__c, Opportunity__c, ru_TotalAmount__c FROM SalesParts__c WHERE VehicleProject__c =: recordId];
            for (SalesParts__c sp : spList) {
                vehicleTotalAmount += sp.ru_TotalAmount__c;
            }
        }

        getProjectMap.put('vpList', vpList);
        getProjectMap.put('vehicleTotalAmount', vehicleTotalAmount);

        return getProjectMap;
    }
    /**
        * 해당 record의 type이 뭔지 구분하는 메서드.
        *
        * @author chkim
        * @param String recordId
        * @return Boolean
        *
    */
    public static Boolean isGPlatform(String recordId){
        Boolean isGPlatform = false;
        VehicleProject__c recTypeVp = [SELECT Id, Name, RecordTypeId FROM VehicleProject__c WHERE Id =: recordId];
        Id gPlatformId = Schema.SObjectType.VehicleProject__c.getRecordTypeInfosByDeveloperName().get('Platform').getRecordTypeId();

        System.debug(gPlatformId);
        if(recTypeVp.RecordTypeId == gPlatformId){
            isGPlatform = true;
        }
        return isGPlatform;
    }
    /**
        * vehicle project의 모든 opty들을 가져온다.
        *
        * @author chkim
        * @param String vpId
        * @return List<OptyWrapper>
        *
    */
    public static List<OptyWrapper> gPlatformOpportunities(String vpId){
        List<Opportunity> optyList = new List<Opportunity>();
        List<OptyWrapper> optyWrapList = new List<OptyWrapper>();

        System.debug('gPlatformOpportunities vpId ' + vpId);
        optyList = [SELECT Id, Name, StageName, ru_ExpectedSales__c FROM Opportunity WHERE VehicleProject__c =: vpId];

        for (Opportunity opty : optyList) {
            OptyWrapper optyWrap = new OptyWrapper();
            optyWrap.id = opty.Id;
            optyWrap.name = opty.Name;
            optyWrap.stageName = opty.StageName;
            optyWrap.expectedSales = (opty.ru_ExpectedSales__c );
            optyWrapList.add(optyWrap);
        }
        return optyWrapList;
    }
    /**
        * 레코드 타입이 single인 경우 sales parts중에 vehicle Project가 vpId인 salesParts의 opty가 나온다
        *
        * @author chkim
        * @param String vpId
        * @return List<OptyWrapper>
        *
    */
    public static List<OptyWrapper> singleOpportunities(String vpId){
        List<OptyWrapper> optyWrapList = new List<OptyWrapper>();
        List<Opportunity> optyList = new List<Opportunity>();
        Set<String> optyIdSet = new Set<String>();

        //sales parts의 vehicle Project가 vpId인 salesParts의 opty가 나온다
        //opty의 vehicle project가 vpId랑 일치하지 않을 경우
        //salesparts의 opty와 vehicleProject가 일치하는 경우 토탈을 opty에 값을 같이 뿌려준다.

        List<SalesParts__c> spList = new List<SalesParts__c>();

        spList = [SELECT Id, VehicleProject__c, Opportunity__c, ru_TotalAmount__c FROM SalesParts__c WHERE VehicleProject__c =: vpId];
        System.debug(spList);
        if (spList.size() > 0) {
            for (SalesParts__c sp : spList) {
                optyIdSet.add(sp.Opportunity__c);
            }
        }
        System.debug(optyIdSet);
        if (optyIdSet.size() > 0) {
            optyList = [SELECT Id, Name, StageName, VehicleProject__c, ru_ExpectedSales__c FROM Opportunity WHERE Id =: optyIdSet];
            for (Opportunity opty : optyList) {
                OptyWrapper optyWrap = new OptyWrapper();
                optyWrap.id = opty.Id;
                optyWrap.name = opty.Name;
                optyWrap.stageName = opty.StageName;
                if (opty.VehicleProject__c != vpId) {
                    for (SalesParts__c sp : spList) {
                        if (sp.VehicleProject__c == vpId && sp.Opportunity__c == opty.Id) {
                            optyWrap.expectedSales =sp.ru_TotalAmount__c;
                        }
                    }
                }else{
                    optyWrap.expectedSales = (opty.ru_ExpectedSales__c);
                }
                optyWrapList.add(optyWrap);
            }
        }
        return optyWrapList;
    }

    /**
        * 레코드 타입이 platform인 경우 해당 opty밑의 sales Parts를 가져온다.
        *
        * @author chkim
        * @param String optyId
        * @return List<SalesParts__c>
        *
    */
    public static List<SalesParts__c> gPlatformSalesParts(String optyId){
        List<SalesParts__c> spList = new List<SalesParts__c>();

        spList = [SELECT Id, Name, PinNumber__c, ru_MobisTotalVolume__c, ru_TotalAmount__c FROM SalesParts__c WHERE Opportunity__c =: optyId];

        return spList;
    }

    /**
        * 레코드 타입이 single인 경우 opty의 차량프로젝트를 vpId와 비교하고
        * 같은경우는 해당 opty의 salesPart가 나오게 되고
        * 다른경우는 해당 opty 밑에 있는 vehicle project를 바라보는 salesParts가 나온다.
        *
        * @author chkim
        * @param String optyId
        * @return List<SalesParts__c>
        *
    */
    public static List<SalesParts__c> singleSalesParts(String optyId, String vpId){
        List<SalesParts__c> spList = new List<SalesParts__c>();
        System.debug('optyId ' + optyId);
        System.debug('vpId ' + vpId);

        Opportunity opty = [SELECT Id, Name, VehicleProject__c FROM Opportunity WHERE Id =: optyId];

        if (opty.VehicleProject__c == vpId) {
            spList = [SELECT Id, Name, PinNumber__c, ru_MobisTotalVolume__c, ru_TotalAmount__c FROM SalesParts__c WHERE Opportunity__c =: optyId];

        }else{
            spList = [SELECT Id, Name, PinNumber__c, ru_MobisTotalVolume__c, ru_TotalAmount__c FROM SalesParts__c WHERE Opportunity__c =: optyId AND VehicleProject__c =:vpId];

        }

        return spList;
    }

    //==============================
    //==============================
    //==============================


    public class OptyWrapper {
        @AuraEnabled
        public String id { get; set; }
        @AuraEnabled
        public String name { get; set; }
        @AuraEnabled
        public String stageName { get; set; }
        @AuraEnabled
        public Double expectedSales { get; set; }
    }
}