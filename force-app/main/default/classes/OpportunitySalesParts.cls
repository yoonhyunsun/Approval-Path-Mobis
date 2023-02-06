/**
 * Created by i2max-김창희 on 2022-09-05.
 */

public with sharing class OpportunitySalesParts extends SalesPartsBase{

    /**
            * init 될때 모든 해당 opty의 정보와 하위 salesParts, partsVolume에 대한 모든 값 출력, 테이블의 넓이까지 계산 출럭
            *
            * @ param Map<String, Object> -> recordId
            * @ return ComponentResponse
            *
        */
    @AuraEnabled
    public static ComponentResponse doGetSalesParts(Map<String, Object> pmap){
        ComponentResponse scr = new ComponentResponse();
        String recordId = (String) pmap.get('recordId');

        List<relevantYearWrapper> relevantYearsList;
        Map<String, Object> salesPartsMap;
        Map<String, PartsVolumeWrapper> partsVolumesList;
        Map<String, Object> optyInfoMap;
        Map<String, Object> vpInfoMap;

        optyInfoMap = SalesPartsBase.getOptyInfoMap(recordId);
        relevantYearsList = SalesPartsBase.getRelevantYears(recordId);
        salesPartsMap = SalesPartsBase.getSalesParts(recordId);
        partsVolumesList = SalesPartsBase.getPartsVolumes(recordId, relevantYearsList);
        vpInfoMap = SalesPartsBase.getVehicleProjectInfo(recordId);

        scr.setData('optyStage', optyInfoMap.get('optyStage'));
        scr.setData('paymentCurrency', optyInfoMap.get('paymentCurrency'));
        scr.setData('expectedSales', optyInfoMap.get('expectedSales'));
        scr.setData('dealGradeSales', optyInfoMap.get('dealGradeSales'));
        scr.setData('relevantYearsList', relevantYearsList);

        Integer tableWidth = 564;
        if (relevantYearsList.size() > 0) tableWidth += relevantYearsList.size() * 132;

        scr.setData('tableWidth', tableWidth);
        scr.setData('salesPartsList', salesPartsMap.get('salesPartsList'));
        scr.setData('annualPeakVolume', salesPartsMap.get('annualPeakVolume'));
        scr.setData('partsVolumesList', partsVolumesList);
        scr.setData('isGPlatform', vpInfoMap.get('isGPlatform'));
        scr.setData('vpList', vpInfoMap.get('vpList'));
        return scr;
    }
    /**
            * sales parts 생성시 New component 에서 값을 가져와 sales parts 생성
            *
            * @ param Map<String, Object> -> recordId / pinNumber(Parts Number) / usage / description / vehicleProject
            * @ return ComponentResponse
            *
        */
    @AuraEnabled
    public static ComponentResponse doCreateSalesParts(Map<String, Object> pmap){
        ComponentResponse scr = new ComponentResponse();
        String recordId = (String) pmap.get('recordId');
        String pinNumber = (String) pmap.get('pinNumber');
        Decimal usage = (Decimal) pmap.get('usage');
        String description = (String) pmap.get('description');
        String vehicleProject = (String) pmap.get('vehicleProject');

        SalesPartsBase.createSalesParts(recordId, pinNumber, usage, description, vehicleProject);
        return scr;
    }
    /**
                * new 버튼 클릭시 opty의 정보 가져와서 New component에 출력
                *
                * @ param Map<String, Object> -> recordId
                * @ return ComponentResponse
                *
            */
    @AuraEnabled
    public static ComponentResponse doGetOptyInfo(Map<String, Object> pmap){
        ComponentResponse scr = new ComponentResponse();
        String recordId = (String) pmap.get('recordId');

        Map<String, Object> optyInfo = new Map<String, Object>(SalesPartsBase.getOptyInfo(recordId));
        Map<String, Object> vpInfoMap = new Map<String, Object>(SalesPartsBase.getVehicleProjectInfo(recordId));

        scr.setData('SOP', optyInfo.get('SOP'));
        scr.setData('lifeCycle', optyInfo.get('lifeCycle'));
        scr.setData('isGPlatform', vpInfoMap.get('isGPlatform'));
        scr.setData('vpList', vpInfoMap.get('vpList'));
        return scr;
    }
    /**
                * SalesParts, Parts volume 저장시 변경된 값을 가져와서 각각 저장
                *
                * @ param Map<String, Object> -> recordId / spSaveList / pvSaveList
                * @ return ComponentResponse
                *
            */
    @AuraEnabled
    public static ComponentResponse doSaveSalesPartsVolumes(Map<String, Object> pmap){
        ComponentResponse scr = new ComponentResponse();
        String recordId = (String) pmap.get('recordId');
        String spSaveList = (String) pmap.get('spSaveList');
        String pvSaveList = (String) pmap.get('pvSaveList');

        if (String.isEmpty(pvSaveList) && String.isEmpty(spSaveList)) return scr;

        List<OpportunitySalesPartsWrapper> spList = (List<OpportunitySalesPartsWrapper>) System.JSON.deserialize(spSaveList, List<OpportunitySalesPartsWrapper>.class);
        if(!spList.isEmpty()) SalesPartsBase.saveSalesParts(recordId, spList);

        List<OpportunitySalesPartsVolumeWrapper> pvList = (List<OpportunitySalesPartsVolumeWrapper>) System.JSON.deserialize(pvSaveList, List<OpportunitySalesPartsVolumeWrapper>.class);
        if(!pvList.isEmpty())SalesPartsBase.savePartsVolumes(recordId, pvList);

        return scr;
    }
    /**
                * SalesParts 삭제시 해당 salesParts 리스트 가져와 삭제
                *
                * @ param Map<String, Object> -> recordId / removeList
                * @ return ComponentResponse
                *
            */
    @AuraEnabled
    public static ComponentResponse doRemoveSalesParts(Map<String, Object>pmap){
        ComponentResponse scr = new ComponentResponse();
        String recordId = (String) pmap.get('recordId');
        String removeList = (String) pmap.get('removeList');

        if (String.isEmpty(removeList)) return scr;

        List<OpportunitySalesPartsWrapper> spList = (List<OpportunitySalesPartsWrapper>) System.JSON.deserialize(removeList, List<OpportunitySalesPartsWrapper>.class);
        SalesPartsBase.removeSalesParts(recordId, spList);

        return scr;
    }
    /**
                * SalesParts에 대한 summary 테이블 값 출력, 해당 테이블의 길이 또한 조정
                *
                * @ param Map<String, Object> -> recordId
                * @ return ComponentResponse
                *
            */
    @AuraEnabled
    public static ComponentResponse doGetSalesPartsSummary(Map<String, Object>pmap){
        ComponentResponse scr = new ComponentResponse();
        String recordId = (String) pmap.get('recordId');

        List<relevantYearWrapper> relevantYearsList;
        List<SalesPartsSummaryWrapper> summaryList;

        relevantYearsList = SalesPartsBase.getRelevantYears(recordId);
        summaryList = SalesPartsBase.getSalesPartsSummary(recordId, relevantYearsList);

        Integer tableWidth = 324;
        if (relevantYearsList.size() > 0) tableWidth += relevantYearsList.size() * 108;

        scr.setData('tableWidth', tableWidth);
        scr.setData('relevantYearsList', relevantYearsList);
        scr.setData('summaryList', summaryList);
        return scr;
    }
}