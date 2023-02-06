/**
 * Created by changheekim on 2022/11/03.
 */

public with sharing class DevelopmentPartsTable extends DevelopmentPartsBase{

    @AuraEnabled
    public static ComponentResponse doGetDevParts(Map<String, Object> pmap){
        ComponentResponse scr = new ComponentResponse();
        String recordId = (String) pmap.get('recordId');

        List<RelevantYearWrapper> relevantYearsList;
        Map<String, Object> devPartsObjectMap;
        Map<String, DevPartsVolumeWrapper> devPartsVolumesList;
        Map<String, String> paymentInfoMap;

        relevantYearsList = getRelevantYears(recordId);
        devPartsObjectMap = getDevParts(recordId);
        devPartsVolumesList = getDevPartsVolumes(recordId, relevantYearsList);
        paymentInfoMap = getPaymentCurrencyInfo(recordId);


        Integer tableWidth = 564;
        if (relevantYearsList.size() > 0) tableWidth += relevantYearsList.size() * 132;


        scr.setData('tableWidth', tableWidth);

        scr.setData('relevantYearsList', relevantYearsList);
        scr.setData('annualPeakVolume', devPartsObjectMap.get('annualPeakVolume'));
        scr.setData('devPartsList', devPartsObjectMap.get('devPartsList'));
        scr.setData('devPartsVolumesList', devPartsVolumesList);
        
        scr.setData('paymentCurrency', paymentInfoMap.get('paymentCurrency'));
        scr.setData('expectedSales', paymentInfoMap.get('expectedSales'));
        scr.setData('dealGradeSales', paymentInfoMap.get('dealGradeSales'));

        return scr;
    }

    @AuraEnabled
    public static ComponentResponse doRemoveDevParts(Map<String, Object> pmap){
        ComponentResponse scr = new ComponentResponse();

        String recordId = (String) pmap.get('recordId');
        String removeList = (String) pmap.get('removeList');

        System.debug('recordId' + recordId);
        System.debug('devRemoveList' + removeList);

        if(String.isEmpty(removeList)) return scr;


        List<DevelopmentPartsWrapper> dpList = (List<DevelopmentPartsWrapper>) System.JSON.deserialize(removeList, List<DevelopmentPartsWrapper>.class);
        removeDevParts(recordId, dpList);

        return scr;
    }

    @AuraEnabled
    public static ComponentResponse doSaveDevPartsVolumes(Map <String, Object> pmap){
        ComponentResponse scr = new ComponentResponse();

        String recordId = (String) pmap.get('recordId');
        String dpSaveList = (String) pmap.get('dpSaveList');
        String dpvSaveList = (String) pmap.get('dpvSaveList');

        if(String.isEmpty(dpSaveList) && String.isEmpty(dpvSaveList)) return scr;

        List<DevelopmentPartsWrapper> dpwList = (List<DevelopmentPartsWrapper>) System.JSON.deserialize(dpSaveList, List<DevelopmentPartsWrapper>.class);
        if(!dpwList.isEmpty()){
            saveDevParts(recordId, dpwList);
        }

        List<DevelopmentPartsVolumesWrapper> dpvwList = (List<DevelopmentPartsVolumesWrapper>) System.JSON.deserialize(dpvSaveList, List<DevelopmentPartsVolumesWrapper>.class);
        if(!dpvwList.isEmpty()){
            saveDevPartsVolume(recordId, dpvwList);
        }

        return scr;
    }
}