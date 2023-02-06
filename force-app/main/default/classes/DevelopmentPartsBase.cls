/**
 * Created by changheekim on 2022/11/03.
 */

public with sharing abstract class DevelopmentPartsBase {

    public static List<RelevantYearWrapper> getRelevantYears(String recordId){
        List<RelevantYearWrapper> relevantYearsList = new List<RelevantYearWrapper>();
        List<String> dpvYearList = new List<String>();

        List<DevelopmentParts__c> dpList = [SELECT Id, Name, StartYear__c, EndYear__c FROM DevelopmentParts__c WHERE Development__c =: recordId];

        Set<Id> dpIdSet =  new Set<Id>();

        if(!dpList.isEmpty()){
            for (DevelopmentParts__c dp : dpList) {
                dpIdSet.add(dp.Id);
            }
            List<DevelopmentPartsVolume__c> dpvList = [SELECT Id, Name, RelevantYear__c FROM DevelopmentPartsVolume__c WHERE DevelopmentParts__c =: dpIdSet];

            for (DevelopmentPartsVolume__c dpv : dpvList) {
                dpvYearList.add(dpv.RelevantYear__c);
            }

            if (!dpvYearList.isEmpty()) {
                dpvYearList.sort();
                Integer firstYear = Integer.valueOf(dpvYearList.get(0));
                Integer lastYear = Integer.valueOf(dpvYearList.get(dpvYearList.size() - 1));

                for (Integer i = 0; i < lastYear - firstYear + 1; i++) {
                    RelevantYearWrapper ryw = new RelevantYearWrapper();
                    ryw.relevantYear = String.valueOf(firstYear + i);
                    relevantYearsList.add(ryw);
                }
            }
        }
        return relevantYearsList;
    }

    public static Map<String, String>getPaymentCurrencyInfo(String recordId){
        Map<String, String> paymentInfoMap = new Map<String, String>();

        Development__c dev = [SELECT Id, Name, CurrencyIsoCode, ru_ExpectedSales__c, fm_DealGradeConvert__c FROM Development__c WHERE Id =:recordId];

        String expectedSales;
        String dealGradeSales;

        if(dev.CurrencyIsoCode != 'USD'){
            CurrencyType cy = [SELECT Id, IsoCode, ConversionRate FROM CurrencyType WHERE IsoCode =: dev.CurrencyIsoCode];
            expectedSales = String.valueOf(dev.ru_ExpectedSales__c / cy.ConversionRate);
            dealGradeSales = String.valueOf(dev.ru_ExpectedSales__c * dev.fm_DealGradeConvert__c / cy.ConversionRate);

        }else{
            expectedSales = String.valueOf(dev.ru_ExpectedSales__c);
            dealGradeSales = String.valueOf(dev.ru_ExpectedSales__c * dev.fm_DealGradeConvert__c);
        }

        paymentInfoMap.put('paymentCurrency', dev.CurrencyIsoCode);
        paymentInfoMap.put('expectedSales',expectedSales);
        paymentInfoMap.put('dealGradeSales',dealGradeSales);

        return paymentInfoMap;
    }

    public static Map<String, Object> getDevParts(String recordId){
        Map<String, Object> devPartsObjectMap = new Map<String, Object>();

        List<DevPartsWrapper> dpwList = new List<DevPartsWrapper>();

        Double annualPeakVolume = 0;

        List<DevelopmentParts__c> dpList = [SELECT Id, Name, Description__c, fm_WeightedAverage__c,
                Development__c, ru_VehicleTotalVolume__c, ru_MobisTotalVolume__c, ru_TotalAmount__c,
                ru_AnnualPeakVolume__c FROM DevelopmentParts__c WHERE Development__c =: recordId];

        for (DevelopmentParts__c dp : dpList) {
            System.debug(dp);
        }
        for (DevelopmentParts__c dp : dpList) {
            DevPartsWrapper dpw = new DevPartsWrapper();
            dpw.id = dp.Id;
            dpw.name = dp.Name;
            dpw.developmentId = dp.Development__c;
            dpw.vehicleTotal = dp.ru_VehicleTotalVolume__c;
            dpw.mobisTotal = dp.ru_MobisTotalVolume__c;
            dpw.weightedAverage = dp.fm_WeightedAverage__c;
            dpw.totalAmount = dp.ru_TotalAmount__c;
            dpw.description = dp.Description__c;
            dpwList.add(dpw);

            if (dp.ru_AnnualPeakVolume__c != null && dp.ru_AnnualPeakVolume__c != 0) {
                annualPeakVolume += dp.ru_AnnualPeakVolume__c;
            }
        }


        for (DevPartsWrapper dpw : dpwList) {
            System.debug(dpw);
        }
        devPartsObjectMap.put('devPartsList', dpwList);
        devPartsObjectMap.put('annualPeakVolume', String.valueOf(annualPeakVolume));

        return devPartsObjectMap;
    }

    public static Map<String, DevPartsVolumeWrapper> getDevPartsVolumes(String recordId, List<RelevantYearWrapper> relevantYearsList){
        Map<String, DevPartsVolumeWrapper> existDpvwMap = new Map<String, DevPartsVolumeWrapper>();
        Map<String, DevPartsVolumeWrapper> devPartsVolumesList = new Map<String, DevPartsVolumeWrapper>();

        Set<Id> dpIdSet = new Set<Id>();

        List<DevelopmentParts__c> dpList = [SELECT Id, Name, StartYear__c, EndYear__c, Usage__c FROM DevelopmentParts__c WHERE Development__c =: recordId];

        for (DevelopmentParts__c dp : dpList) {
            dpIdSet.add(dp.Id);
        }

        List<DevelopmentPartsVolume__c> dpvList =[SELECT Id, Cost__c, CRRate__c, fm_MobisProductVolume__c,
                fm_TotalAmount__c, Name, OptionRate__c, RelevantYear__c, DevelopmentParts__c, IsStartYear__c, LastYearCost__c,
                Usage__c, VehicleVolume__c, CurrencyIsoCode FROM DevelopmentPartsVolume__c WHERE DevelopmentParts__c =: dpIdSet ORDER BY RelevantYear__c];

        for (DevelopmentPartsVolume__c dpv : dpvList) {
            String dpvwKey = dpv.DevelopmentParts__c + dpv.RelevantYear__c;

            DevPartsVolumeWrapper dpvw = new DevPartsVolumeWrapper();
            dpvw.id = dpv.Id;
            dpvw.name = dpv.Name;
            dpvw.devPartsId = dpv.DevelopmentParts__c;
            dpvw.relevantYear = dpv.RelevantYear__c;
            dpvw.cost = dpv.Cost__c;
            dpvw.crRate = dpv.CRRate__c;
            dpvw.mobisProductVolume = dpv.fm_MobisProductVolume__c;
            dpvw.totalAmount = dpv.fm_TotalAmount__c;
            dpvw.optionRate = dpv.OptionRate__c;
            dpvw.usage = dpv.Usage__c;
            dpvw.vehicleVolume = dpv.VehicleVolume__c;
            dpvw.isStartYear = dpv.IsStartYear__c;

            existDpvwMap.put(dpvwKey, dpvw);
        }

        Set<String> relevantYearSet = new Set<String>();

        for (RelevantYearWrapper ryw : relevantYearsList) {
            relevantYearSet.add(String.valueOf(ryw.relevantYear));
        }

        for (DevelopmentParts__c dp : dpList) {
            Integer firstYear = Integer.valueOf(dp.StartYear__c);
            Integer lastYear = Integer.valueOf(dp.EndYear__c);
            Set<String> yearRange = new Set<String>();

            for (Integer i = 0; i < lastYear - firstYear + 1; i++) {
                String targetYear = String.valueOf(firstYear + i);
                yearRange.add(targetYear);
            }

            for (String ry : relevantYearSet) {
                DevPartsVolumeWrapper newDpw = new DevPartsVolumeWrapper();
                String dpwListMapKey = dp.Id + ry;

                if(existDpvwMap.containsKey(dpwListMapKey)){
                    newDpw = existDpvwMap.get(dpwListMapKey);
                }else{
                    newDpw.name = null;
                    newDpw.devPartsId = dp.Id;
                    newDpw.relevantYear = ry;
                    if(ry == dp.StartYear__c){
                        newDpw.isStartYear = true;
                    }
                    newDpw.vehicleVolume = 0;
                    newDpw.optionRate = 0;
                    newDpw.mobisProductVolume = 0;
                    newDpw.cost = 0;
                    newDpw.crRate = 0;
                    newDpw.totalAmount = 0;
                    newDpw.usage = dp.Usage__c;
                    //currency
                }
                System.debug(newDpw);
                devPartsVolumesList.put(dpwListMapKey, newDpw);
            }
        }

        return devPartsVolumesList;
    }

    public static void removeDevParts(String recordId, List<DevelopmentPartsWrapper> removeList){
        List<DevelopmentParts__c> dpList = new List<DevelopmentParts__c>();
        for (DevelopmentPartsWrapper dpw : removeList) {
            DevelopmentParts__c dp = new DevelopmentParts__c();
            dp.Id = dpw.id;
            dpList.add(dp);
        }
        if(dpList.size() > 0){
            Database.delete(dpList, false);
        }
    }

    public static void saveDevParts(String recordId, List<DevelopmentPartsWrapper> dpwList){
        List<DevelopmentParts__c> dpList = new List<DevelopmentParts__c>();

        for (DevelopmentPartsWrapper dpw : dpwList) {
            DevelopmentParts__c dp = new DevelopmentParts__c();
            dp.Id = dpw.id;
            dp.Name = dpw.name;
            dp.Description__c = dpw.description;
            dpList.add(dp);
        }
        if(dpList.size() > 0) {
            Database.update(dpList, false);
        }
    }

    public static void saveDevPartsVolume(String recordId, List<DevelopmentPartsVolumesWrapper> dpvwList){
        List<DevelopmentPartsVolume__c> dpvList = new List<DevelopmentPartsVolume__c>();

        for (DevelopmentPartsVolumesWrapper dpvw : dpvwList) {
            DevelopmentPartsVolume__c dpv = new DevelopmentPartsVolume__c();
            dpv.Id = dpvw.value.id;
            dpv.Name = dpvw.value.name;
            //dpv.DevelopmentParts__c = dpvw.value.devPartsId;
            dpv.VehicleVolume__c = Decimal.valueOf(dpvw.value.vehicleVolume);
            dpv.OptionRate__c = Decimal.valueOf(dpvw.value.optionRate);
            dpv.Cost__c = Decimal.valueOf(dpvw.value.cost);
            dpv.CRRate__c = Decimal.valueOf(dpvw.value.crRate);
            dpv.Usage__c = Decimal.valueOf(dpvw.value.usage);
            dpv.RelevantYear__c = dpvw.value.relevantYear;

            dpvList.add(dpv);
        }
        System.debug(dpvList.size());
        if(dpvList.size() > 0){
            Database.SaveResult[] dsr = Database.update(dpvList, true);

            System.debug(dsr.size());
            for (Database.SaveResult saveResult : dsr) {
                System.debug(saveResult);
            }
        }
    }



    //============================================================
    //============================================================
    //============================================================
    //============================================================
    //============================================================
    //Wrapper
    //============================================================
    //============================================================
    //============================================================
    //============================================================
    //============================================================


    public class RelevantYearWrapper{
        @AuraEnabled
        public String relevantYear { get; set; }
    }

    public class DevPartsWrapper{
        @AuraEnabled
        public String id { get; set; }
        @AuraEnabled
        public String name { get; set; }
        @AuraEnabled
        public String developmentId { get; set; }
        @AuraEnabled
        public Decimal vehicleTotal { get; set; }
        @AuraEnabled
        public Decimal mobisTotal { get; set; }
        @AuraEnabled
        public Decimal weightedAverage { get; set; }
        @AuraEnabled
        public Decimal totalAmount { get; set; }
        @AuraEnabled
        public String description { get; set; }
    }

    public class DevPartsVolumeWrapper{
        @AuraEnabled
        public String id { get; set; }
        @AuraEnabled
        public String name { get; set; }
        @AuraEnabled
        public String devPartsId { get; set; }
        @AuraEnabled
        public String relevantYear { get; set; }
        @AuraEnabled
        public Decimal cost { get; set; }
        @AuraEnabled
        public Decimal lastYearCost { get; set; }
        @AuraEnabled
        public Decimal crRate { get; set; }
        @AuraEnabled
        public Decimal optionRate { get; set; }
        @AuraEnabled
        public Decimal mobisProductVolume { get; set; }
        @AuraEnabled
        public Decimal totalAmount { get; set; }
        @AuraEnabled
        public Decimal usage { get; set; }
        @AuraEnabled
        public Decimal vehicleVolume { get; set; }
        @AuraEnabled
        public Boolean isStartYear {get; set;}
    }
}