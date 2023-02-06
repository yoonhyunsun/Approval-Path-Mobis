/****************************************************************************************
  * @filename      : ProjectTree
  * @projectname   : Hyundai Mobis PS
  * @author        : EH LEE
  * @date          : 2022-08-17 
  * @group         : 
  * @group-content : 
  * @description   : 
  * @tester        : ProjectTree_ts.cls
  * @reference     : 
  * @copyright     : Copyright © I2max. All Rights Reserved.
  * @modification Log
  * ===============================================================
  * ver     date                author              description
  * ===============================================================
    0.1     2022-08-17            EH LEE                 Create
****************************************************************************************/

public with sharing class ProjectTree extends ProjectTreeUtils{
    /**
        * ProjectTree 에서 Account와 vehicle project를 카드형태로 가져오는 메서드
        *
        * @ param Map<String, Object> pmap
        * @ return ComponentResponse
        *
    */
    @AuraEnabled
    public static ComponentResponse doGetProjectAccount (Map<String, Object> pmap){
        ComponentResponse scr = new ComponentResponse();
        String recordId = (String) pmap.get('recordId');
        Account account = new Account();
        Map<String, Object> getProjectMap = new Map<String, Object>();
        Double vehicleTotalAmount = 0;

        account = ProjectTreeUtils.getProjectAccount(recordId);
        getProjectMap = ProjectTreeUtils.getVehicleProject(recordId);
        Integer zoomLevel = 75;

        scr.setData('account', account);
        scr.setData('vpList' ,getProjectMap.get('vpList'));
        scr.setData('vehicleTotalAmount' , getProjectMap.get('vehicleTotalAmount'));
        scr.setData('zoomLevel', zoomLevel);

        return scr;
    }
    /**
        * ProjectCard 에서 Opty를 카드형태로 가져오는 메서드, 플렛폼 타입에 따라 갈림
        *
        * @ param Map<String, Object> pmap
        * @ return ComponentResponse
        *
    */
    @AuraEnabled
    public static ComponentResponse doGetProjectOpportunities (Map<String, Object> pmap){
        ComponentResponse scr = new ComponentResponse();
        String vpId = (String) pmap.get('vpId');

        List<OptyWrapper> optyWrapList = new List<OptyWrapper>();
        Boolean isGPlatform = ProjectTreeUtils.isGPlatform(vpId);

        if(isGPlatform == true){
            optyWrapList = ProjectTreeUtils.gPlatformOpportunities(vpId);
        }else{
            optyWrapList = ProjectTreeUtils.singleOpportunities(vpId);
        }

        scr.setData('optyWrapList', optyWrapList);
        return scr;
    }
    /**
        * ProjectOpportunity 에서 sales Parts를 카드형태로 가져오는 메서드, 플렛폼 타입에 따라 갈림
        *
        * @ param Map<String, Object> pmap
        * @ return ComponentResponse
        *
    */
    @AuraEnabled
    public static ComponentResponse doGetProjectSalesParts (Map<String, Object> pmap){
        ComponentResponse scr = new ComponentResponse();
        String optyId = (String) pmap.get('optyId');
        String vpId = (String) pmap.get('vpId');

        List<SalesParts__c> spList = new List<SalesParts__c>();
        Boolean isGPlatform = ProjectTreeUtils.isGPlatform(vpId);

        if(isGPlatform == true){
            spList = ProjectTreeUtils.gPlatformSalesParts(optyId);
        }else{
            spList = ProjectTreeUtils.singleSalesParts(optyId, vpId);
        }

        scr.setData('spList', spList);
        return scr;
    }
}