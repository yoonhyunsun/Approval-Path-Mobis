/**
 * Created by changheekim on 2022/09/05.
 */


public without sharing abstract class SalesPartsBase {


    /**
        * opty의 SOP부터 Life Cycle 까지의 년도를 구하는 메서드,
        * sop가 다르고, life cycle이 달라도 모든 가장 낮은 년도 부터, 가장 큰 년도 까지 정리해서 출력
        * --> sop와 life cycle이 모두 동일하게 변경
        *
        * @ param String recordId
        * @ return List<relevantYearWrapper>
        *
    */
    public static List<relevantYearWrapper> getRelevantYears (String recordId){

        List<relevantYearWrapper> relevantYearsList = new List<relevantYearWrapper>();
        List<String> spvYearList = new List<String>();

        List<SalesParts__c> spl = [SELECT Id, Name, StartYear__c, EndYear__c FROM SalesParts__c WHERE Opportunity__c =: recordId];

        if (!spl.isEmpty()) {
            for (SalesParts__c sp : spl) {
                if(sp.StartYear__c != null){
                    spvYearList.add(sp.StartYear__c);
                }
                if (sp.EndYear__c != null) {
                    spvYearList.add(sp.EndYear__c);
                }
            }

            if(spvYearList.size() > 0) {
                spvYearList.sort();
                Integer firstYear = Integer.valueOf(spvYearList.get(0));
                Integer lastYear = Integer.valueOf(spvYearList.get(spvYearList.size() - 1));

                for (Integer i = 0; i < lastYear - firstYear + 1; i++) {
                    relevantYearWrapper ryw = new relevantYearWrapper();
                    ryw.relevantYear = String.valueOf(firstYear + i);
                    relevantYearsList.add(ryw);
                }
            }
        }

        return relevantYearsList;
    }
    /**
        * opty에서 가져올수있는 단계, 통화, USD기준 기대값, 가격등급 적용 USD 기준 기대값 가져오는 메서드,
        *
        * @ param String recordId
        * @ return Map<String, Object>
        *
    */
    public static Map<String, Object> getOptyInfoMap(String recordId){
        Map<String, Object> optyInfoMap = new Map<String, Object>();

        Opportunity opty = [SELECT Id,StageName, Name, CurrencyIsoCode, ru_ExpectedUSDConvert__c, fm_ExpectedUSDConvertrefDealgrade__c, Product__c FROM Opportunity WHERE Id =: recordId];

        System.debug(opty.StageName);
        Boolean stageFlag = true ;//	RFQ Received Quote Submitted Negotiation

        if (opty.StageName == 'RFQ Received' || opty.StageName == 'Quote Submitted' || opty.StageName == 'Negotiation' ) stageFlag = false;

        optyInfoMap.put('optyStage', stageFlag);
        optyInfoMap.put('paymentCurrency', String.valueOf(opty.CurrencyIsoCode));
        optyInfoMap.put('expectedSales',String.valueOf(opty.ru_ExpectedUSDConvert__c));
        optyInfoMap.put('dealGradeSales',String.valueOf(opty.fm_ExpectedUSDConvertrefDealgrade__c));

        return optyInfoMap;
    }
    /**
        * opty의 해당 하는 salesParts를 가져오는 메서드
        *
        * @ param String recordId
        * @ return Map<String, Object>
        *
    */
    public static Map<String, Object> getSalesParts(String recordId){
        Map<String, Object> salesPartsMap = new Map<String, Object>();

        List<SalesPartsWrapper> spwList = new List<SalesPartsWrapper>();
        String annualPeakVolumeStr = '';
        Double annualPeakVolume = 0;

        List<SalesParts__c> spl = [SELECT Id, Usage__c, LifeCycle__c, Name, Opportunity__c,
                PinNumber__c, Product__c, ru_MobisTotalVolume__c, ru_TotalAmount__c, fm_WeightedAverage__c,
                ru_VehicleTotalVolume__c, Description__c, VehicleProject__c, VehicleProject__r.Name,
                ru_AnnualPeakVolume__c, CreatedDate FROM SalesParts__c WHERE Opportunity__c =: recordId ORDER BY CreatedDate];
        System.debug('==========');
        for (SalesParts__c sp : spl) {
            System.debug(sp.CreatedDate);
        }
        System.debug('==========');
        for (SalesParts__c sp  : spl) {
            SalesPartsWrapper spw = new SalesPartsWrapper();
            spw.id = sp.Id;
            spw.usage = sp.Usage__c;
            spw.lifeCycle = sp.LifeCycle__c;
            spw.name = sp.Name;
            spw.opportunityId = sp.Opportunity__c;
            spw.pinNumber = sp.PinNumber__c;
            spw.productId = sp.Product__c;
            spw.mobisTotal = sp.ru_MobisTotalVolume__c;
            spw.totalAmount = sp.ru_TotalAmount__c;
            spw.vehicleTotal = sp.ru_VehicleTotalVolume__c;
            spw.description = sp.Description__c;
            spw.weightedAverage = sp.fm_WeightedAverage__c;
            spw.vehicleProjectId = sp.VehicleProject__c;
            spw.vehicleProjectName = sp.VehicleProject__r.Name;
            spwList.add(spw);

            if(sp.ru_AnnualPeakVolume__c != null && sp.ru_AnnualPeakVolume__c != 0){
                //System.debug(sp.PinNumber__c + ' ' + sp.ru_AnnualPeakVolume__c);
                annualPeakVolume += sp.ru_AnnualPeakVolume__c;
            }
            System.debug(sp.CreatedDate);
        }

        annualPeakVolumeStr = String.valueOf(annualPeakVolume);

        salesPartsMap.put('salesPartsList', spwList);
        salesPartsMap.put('annualPeakVolume', annualPeakVolumeStr);

        return salesPartsMap;
    }
    /**
        * opty의 해당 하는 Parts volume을 가져오는 메서드, Aura는 원하는 곳에 값을 출력할수 있는 map이 지원되지 않아서
        * sop가 다르고 life cycle이 다를때를 대비해 빈 값을 생성하여 뿌려줌,
        * --> sop와 life cycle이 모두 동일하게 변경
        *
        * @ param String recordId, List<relevantYearWrapper> relevantYearsList
        * @ return Map<String, PartsVolumeWrapper>
        *
    */
    public static Map<String, PartsVolumeWrapper> getPartsVolumes(String recordId, List<relevantYearWrapper> relevantYearsList){
        Map<String, PartsVolumeWrapper> spvListMap = new Map<String, PartsVolumeWrapper>();
        Map<String, PartsVolumeWrapper> pvwMap = new Map<String, PartsVolumeWrapper>();
        Set<Id> spIdSet = new Set<Id>();

        List<SalesParts__c> spl = [SELECT Id, Name, CurrencyIsoCode, Usage__c, StartYear__c, EndYear__c FROM SalesParts__c WHERE Opportunity__c =: recordId];

        if (!spl.isEmpty()) {
            for (SalesParts__c sp : spl) {
                spIdSet.add(sp.Id);
            }
            List<SalesPartsVolume__c> spvList = [ SELECT Id, Cost__c, CRRate__c, fm_MobisProductVolume__c,
                    fm_TotalAmount__c, Name, OptionRate__c, RelevantYear__c, SalesParts__c, IsStartYear__c, LastYearCost__c,
                    Usage__c, VehicleVolume__c, CurrencyIsoCode FROM SalesPartsVolume__c WHERE SalesParts__c =:spIdSet ORDER BY RelevantYear__c
            ];
            // salesParts의 Id와 해당년도 값을 key값으로 생성, 사용
            for (SalesPartsVolume__c spv : spvList) {
                String pvwKey = spv.SalesParts__c + spv.RelevantYear__c;
                PartsVolumeWrapper pvw = new PartsVolumeWrapper();
                pvw.id = spv.Id;
                pvw.name = spv.Name;
                pvw.salesPartsId = spv.SalesParts__c;
                pvw.relevantYear = spv.RelevantYear__c;
//                if (spv.IsStartYear__c) {
                pvw.cost = spv.Cost__c;
//                }else{
//                    pvw.cost = spv.LastYearCost__c;
//                }
                pvw.isStartYear = spv.IsStartYear__c;
                pvw.crRate = spv.CRRate__c;
                pvw.mobisProductVolume = spv.fm_MobisProductVolume__c;
                pvw.totalAmount = spv.fm_TotalAmount__c;
                pvw.optionRate = spv.OptionRate__c;
                pvw.usage = spv.Usage__c;
                pvw.vehicleVolume = spv.VehicleVolume__c;
                pvw.pvCurrency = spv.CurrencyIsoCode;
                spvListMap.put(pvwKey, pvw);
            }

            Set<String> relevantYearSet = new Set<String>();

            for (relevantYearWrapper ryw : relevantYearsList) {
                relevantYearSet.add(String.valueOf(ryw.relevantYear));
            }

            for (SalesParts__c sp  : spl) {
                Integer firstYear = Integer.valueOf(sp.StartYear__c);
                Integer lastYear = Integer.valueOf(sp.EndYear__c);
                Set<String> yearRange = new Set<String>();

                for (Integer i = 0; i < lastYear - firstYear + 1; i++) {
                    String targetYear = String.valueOf(firstYear + i);
                    yearRange.add(targetYear);
                }

                for (String ry : relevantYearSet) {
                    PartsVolumeWrapper pvw = new PartsVolumeWrapper();
                    String spvListMapKey = sp.Id + ry;
                    //이전에 생성한 key값이 있는경우, 생성하지 않고 지나감.
                    if (spvListMap.containsKey(spvListMapKey)) {
                        pvw = spvListMap.get(spvListMapKey);
                    } else {// key 값이 없는경우, 해당년도의 salesPartsVolume이 없기에 빈 값을 생성. (정렬, 화면 표기용)
                        pvw.name = null;
                        pvw.salesPartsId = sp.Id;
                        pvw.relevantYear = ry;
                        if(ry == sp.StartYear__c){
                            pvw.isStartYear = true;
                        }
                        pvw.cost = 0;
                        pvw.crRate = 0;
                        pvw.mobisProductVolume = 0;
                        pvw.totalAmount = 0;
                        pvw.optionRate = 100;
                        pvw.usage = sp.Usage__c;
                        pvw.vehicleVolume = 0;
                        pvw.pvCurrency = sp.CurrencyIsoCode;
                    }
                    if (yearRange.contains(ry)) {
                        pvw.yearRange = true;
                    }else{
                        pvw.yearRange = false;
                    }
                    pvwMap.put(spvListMapKey, pvw);
                }
            }
        }
        return pvwMap;
    }
    /**
        * opty 밑 sales Parts의 요약,
        * 파트 넘버와, 추가로 기재한 정보, 해당하는 해당 년도별 총 생산 해야하는 "차량의 수"를 구하는 메서드
        *
        * @ param String recordId, List<relevantYearWrapper> relevantYearsList
        * @ return List<SalesPartsSummaryWrapper>
        *
    */
    public static List<SalesPartsSummaryWrapper> getSalesPartsSummary(String recordId, List<relevantYearWrapper> relevantYearsList){
        List<SalesPartsSummaryWrapper> spsList = new List<SalesPartsSummaryWrapper>();
        Set<Id> spIdSet = new Set<Id>();

        List<SalesParts__c> spl = [SELECT Id, PinNumber__c, Description__c FROM SalesParts__c WHERE Opportunity__c =: recordId];

        if (!spl.isEmpty()) {
            for (SalesParts__c sp : spl) {
                spIdSet.add(sp.Id);
            }

            List<SalesPartsVolume__c> spvList = [
                    SELECT Id, Cost__c, CRRate__c, fm_MobisProductVolume__c,
                            fm_TotalAmount__c, Name, OptionRate__c, RelevantYear__c, SalesParts__c,
                            Usage__c, VehicleVolume__c, CurrencyIsoCode
                    FROM SalesPartsVolume__c
                    WHERE SalesParts__c = :spIdSet
                    ORDER BY RelevantYear__c
            ];

            List<Decimal> totalList = new List<Decimal>();
            for (Integer i = 0; i <relevantYearsList.size(); i++) {
                totalList.add(0);
            }
            for (SalesParts__c sp : spl) {
                SalesPartsSummaryWrapper sps = new SalesPartsSummaryWrapper();
                sps.pinNumber = sp.PinNumber__c;
                sps.description = sp.Description__c;
                sps.vehicleVolumeList = new List<Decimal>();
                sps.total = 0;
                // 년도별 total에 해당하는 배열 만드는 부분
                for (Integer j = 0; j < relevantYearsList.size(); j++) {
                    Decimal vehicleVolume = 0;
                    for (SalesPartsVolume__c spv : spvList) {
                        if(spv.SalesParts__c == sp.Id && spv.RelevantYear__c == relevantYearsList[j].relevantYear){
                            vehicleVolume = spv.VehicleVolume__c;
                            totalList[j] += spv.VehicleVolume__c;
                        }
                    }
                    sps.vehicleVolumeList.add(vehicleVolume);
                    sps.total += vehicleVolume;
                }
                spsList.add(sps);
            }
            SalesPartsSummaryWrapper totalSps = new SalesPartsSummaryWrapper();
            totalSps.pinNumber = 'Total';
            totalSps.vehicleVolumeList = totalList;
            totalSps.total = 0;
            //마지막 총 합계 연산
            for (Decimal dec : totalList) {
                totalSps.total += dec;
            }
            spsList.add(totalSps);
        }
        return spsList;
    }
    /**
        * sales Parts에 대한 값 생성, 저장함
        *
        * @ param String recordId, List<OpportunitySalesPartsWrapper> spwList
        * @ return
        *
    */
    public static void saveSalesParts (String recordId, List<OpportunitySalesPartsWrapper> spwList){
        List<SalesParts__c> spList = new List<SalesParts__c>();
        for (OpportunitySalesPartsWrapper sOne : spwList) {
            SalesParts__c sp = new SalesParts__c();
            sp.Id = sOne.id;
            sp.PinNumber__c = sOne.pinNumber;
            sp.Description__c = sOne.description;
            sp.VehicleProject__c = sOne.vehicleProjectId;
            spList.add(sp);
        }
        Database.upsert(spList, false);
    }

    /**
        * parts volume에 대한 값 생성 저장, 변경된 parts volume에 대한 리스트를 가져와 validation 확인 후
        * 가져온 값에 해 insert, update시 필요한 값을 추가해주고, 첫번째 년도에 대한 검증을 한 후 upsert 한다.
        *
        * @ param String recordId, List<OpportunitySalesPartsVolumeWrapper> pvwList
        * @ return
        *
    */
    public static void savePartsVolumes(String recordId, List<OpportunitySalesPartsVolumeWrapper> pvwList){
        List<SalesPartsVolume__c> pvList = new List<SalesPartsVolume__c>();

        Set<Id> spIdSet = new Set<Id>();

        for (OpportunitySalesPartsVolumeWrapper sOne : pvwList) {
            if (sOne.value.vehicleVolume =='') sOne.value.vehicleVolume = '0';
            if (sOne.value.crRate =='') sOne.value.crRate = '0';
            if (sOne.value.cost =='') sOne.value.cost = '0';
            if(Decimal.valueOf(sOne.value.vehicleVolume) < 0) throw new AuraHandledException('Please put the positive number to the OEM Vehicles.');
            if(Decimal.valueOf(sOne.value.cost) < 0) throw new AuraHandledException('Please put the positive number to the Piece Price.');
            spIdSet.add(sOne.value.salesPartsId);
        }

        Map<Id, SalesParts__c> spIdMap = new Map<Id, SalesParts__c>([SELECT Id, CurrencyIsoCode, CurrencyType__c, PinNumber__c, StartYear__c FROM SalesParts__c WHERE Id =: spIdSet]);

        for (OpportunitySalesPartsVolumeWrapper sOne : pvwList) {
            if (sOne.value.yearRange) {
                SalesPartsVolume__c pv = new SalesPartsVolume__c();
                //기존에 값이 있으면 update하기 위해 id로 매칭
                //기존에 값이 없던 화면표기용 이면 생성해주기 위해 salesParts 값 넣어줌
                if(sOne.value.id != null) pv.Id = sOne.value.id;
                if (sOne.value.id == null) pv.SalesParts__c = sOne.value.salesPartsId;

                pv.IsStartYear__c = false;
                if (sOne.value.relevantYear == spIdMap.get(sOne.value.salesPartsId).StartYear__c) pv.IsStartYear__c = true;
                if (pv.IsStartYear__c == true && Decimal.valueOf(sOne.value.crRate) != 0) throw new AuraHandledException('CR rate cannot be entered for the first year.');


                pv.RelevantYear__c = sOne.value.relevantYear;
                pv.Cost__c = Decimal.valueOf(sOne.value.cost);
                pv.CRRate__c = Decimal.valueOf(sOne.value.crRate);
                pv.OptionRate__c = Decimal.valueOf(sOne.value.optionRate);
                pv.Usage__c = Decimal.valueOf(sOne.value.usage);
                pv.VehicleVolume__c = Decimal.valueOf(sOne.value.vehicleVolume);
                pv.CurrencyIsoCode = spIdMap.get(sOne.value.salesPartsId).CurrencyIsoCode;
                pv.CurrencyType__c = spIdMap.get(sOne.value.salesPartsId).CurrencyType__c;

                pvList.add(pv);
            }
        }

        // sop에 해당하는 년도, 첫번째 년도에 parts Volume이 없는지 확인하는 부분.
        // 새로생성, 변경된 parts volume과 변경되지 않은 기존의 parts volume을 가져와
        // 검증하기 위한 Map을 생성하고 sales Parts별로 시작년도의 값이 true가 하나라도 없다면 예외 처리한다.
        List<SalesPartsVolume__c> existPvList = new List<SalesPartsVolume__c>([SELECT Id, SalesParts__c, IsStartYear__c FROM SalesPartsVolume__c WHERE SalesParts__c =: spIdSet]);
        List<SalesPartsVolume__c> totalList  = new List<SalesPartsVolume__c>();

        totalList.addAll(existPvList);
        totalList.addAll(pvList);

        Map<Id, Boolean> firstRecordCheckMap = new Map<Id, Boolean>();
        for (Id id2 : spIdSet) {
            firstRecordCheckMap.put(id2, false);
        }

        for (SalesPartsVolume__c spv : totalList) {
            if (spv.IsStartYear__c) {
                firstRecordCheckMap.put(spv.SalesParts__c, spv.IsStartYear__c);
            }
        }

        for (String str : firstRecordCheckMap.keySet()) {
            if(!firstRecordCheckMap.get(str)) throw new AuraHandledException('Please put the value corresponding to the year of SOP.');
        }

        if(pvList.size() > 0){
            Database.upsert(pvList, true);
//            Database.UpsertResult[] urList = Database.upsert(pvList, true);
//            for (Database.UpsertResult ur : urList) {
//                System.debug(ur);
//            }
        }
    }
    /**
        * sales Parts를 삭제하는 메소드
        *
        * @ param String recordId, List<OpportunitySalesPartsWrapper> removeList
        * @ return
        *
    */
    public static void removeSalesParts(String recordId, List<OpportunitySalesPartsWrapper> removeList) {
        List<SalesParts__c> spList = new List<SalesParts__c>();

        for (OpportunitySalesPartsWrapper rOne : removeList) {
            SalesParts__c sp = new SalesParts__c();
            sp.Id = rOne.id;
            spList.add(sp);
        }
//        Database.delete(spList, false);
        Database.DeleteResult[] drs = Database.delete(spList, false);
        for (Database.DeleteResult deleteResult : drs) {
            System.debug(deleteResult);
        }
    }


    //============================================================
    //============================================================
    //============================================================
    //============================================================
    //============================================================
    //newSalesParts
    //============================================================
    //============================================================
    //============================================================
    //============================================================
    //============================================================

    /**
        * sales Parts 생성시 해당 opty의 차량 프로젝트의 recordType이 paltform일 때,
        * 차량 프로젝트를 선택할수 있도록 값을 가져오는 메서드.
        *
        * @ param String recordId
        * @ return Map<String, Object>
        *
    */
    public static Map<String, Object> getVehicleProjectInfo(String recordId){
        Map<String, Object> vpInfoMap = new Map<String, Object>();

        Opportunity opty = [SELECT Id, SOP__c, LifeCycle__c, VehicleProject__c,
                VehicleProject__r.RecordTypeId, VehicleProject__r.SingleProject1__c,
                VehicleProject__r.SingleProject2__c, VehicleProject__r.SingleProject3__c,
                VehicleProject__r.SingleProject4__c, VehicleProject__r.SingleProject5__c,
                VehicleProject__r.SingleProject6__c, VehicleProject__r.SingleProject7__c,
                VehicleProject__r.SingleProject8__c, VehicleProject__r.SingleProject9__c,
                VehicleProject__r.SingleProject10__c
        FROM Opportunity WHERE Id =: recordId];

        Id gPlatformId = Schema.SObjectType.VehicleProject__c.getRecordTypeInfosByDeveloperName().get('Platform').getRecordTypeId();
        List<VehicleProject__c> vpList = new List<VehicleProject__c>();
        //차량 프로젝트 타입이 플렛폼일때, 모든 하위 프로젝트를 넣어준다.
        if (opty.VehicleProject__r.RecordTypeId == gPlatformId) {
            vpInfoMap.put('isGPlatform', true);
            Set<Id> vpIdSet = new Set<Id>();
            for (Integer i = 1; i < 11; i++) {
                String vpSp = 'SingleProject'+i+'__c';
                if( vpSp != null ){
                    vpIdSet.add((Id)opty.VehicleProject__r.get(vpSp));
                }
            }

            vpList = [SELECT Id, Name FROM VehicleProject__c WHERE Id =: vpIdSet];
            System.debug(vpList);
            vpInfoMap.put('vpList', vpList);
        }else{//차량 프로젝트 타입이 싱글일때, 해당 프로젝트의 값을 넣어주고, 고정시킨다.
            vpInfoMap.put('isGPlatform', false);
            vpList = [SELECT Id,Name FROM VehicleProject__c WHERE Id =: opty.VehicleProject__c];
            vpInfoMap.put('vpList', vpList);
        }

        for (String str : vpInfoMap.keySet()) {
            System.debug(vpInfoMap.get(str));
        }

        return vpInfoMap;
    }
    /**
        * sales Parts 생성시 해당 opty의 정보를 가져오는 메서드
        *
        * @ param String recordId
        * @ return Map<String, Object>
        *
    */
    public static Map<String, Object> getOptyInfo (String recordId){
        Map<String, Object> optyInfoMap = new Map<String, Object>();

        String SOP = '';
        Opportunity opty = [SELECT Id, SOP__c, LifeCycle__c FROM Opportunity WHERE Id =: recordId];
        SOP = String.valueOf(opty.SOP__c);

        System.debug(opty.SOP__c + ' ' + opty.LifeCycle__c);
        optyInfoMap.put('SOP',SOP);
        optyInfoMap.put('lifeCycle',opty.LifeCycle__c);

        return optyInfoMap;
    }
    /**
        * sales Parts 생성시 validation을 걸어 확인하고 opty에서 가져올수 있는 값을 가져와
        * field에 저장한다.
        *
        * @ param String recordId, String pinNumber, Decimal usage, String description, String vehicleProject
        * @ return
        *
    */
    public static void createSalesParts(String recordId, String pinNumber, Decimal usage, String description, String vehicleProject){
//      try {
        List<SalesParts__c> spList = new List<SalesParts__c>();

        Opportunity opty = [SELECT Id, SOP__c, LifeCycle__c, CurrencyIsoCode, CurrencyType__c, Product__c FROM Opportunity WHERE Id =: recordId];

        if(opty.SOP__c == null) throw new AuraHandledException('SOP isn\'t exist in Opportunity');
        if(opty.LifeCycle__c == null || opty.LifeCycle__c == '') throw new AuraHandledException('LifeCycle isn\'t exist in Opportunity');
        if(vehicleProject == null) throw new AuraHandledException('Please Choose a vehicleProject');
        if(opty.CurrencyType__c == null) throw new AuraHandledException('Please Choose a Currency Type');


        Integer intLifeCycle = Integer.valueOf(opty.LifeCycle__c) -1;

        String startYear = '';
        String endYear = '';

        startYear = String.valueOf(opty.SOP__c.year());
        Date addLifeCycleYear = opty.SOP__c.addYears(intLifeCycle);
        endYear = String.valueOf(addLifeCycleYear.year());

        SalesParts__c sp = new SalesParts__c();
        sp.PinNumber__c = pinNumber;
        sp.Opportunity__c = opty.Id;
        sp.Product__c = opty.Product__c;
        sp.Usage__c =  Integer.valueOf(usage);
        sp.StartYear__c = startYear;
        sp.EndYear__c = endYear;
        sp.LifeCycle__c = Integer.valueOf(opty.LifeCycle__c);
        sp.CurrencyIsoCode = opty.CurrencyIsoCode;
        sp.CurrencyType__c = opty.CurrencyType__c;
        sp.Description__c = description;
        sp.VehicleProject__c = vehicleProject;
        spList.add(sp);

        Database.SaveResult[] srList = Database.insert(spList, false);
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess() == false) {
                for(Database.Error err : sr.getErrors()) {
                    throw new AuraHandledException(err.getMessage());
                }
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


    public class PackageWrapper{
        @AuraEnabled
        public String id { get; set; }
        @AuraEnabled
        public List<SalesPartsWrapper> spwlist { get; set; }
        @AuraEnabled
        public List<PartsVolumeWrapper> pvwlist { get; set; }

        public PackageWrapper(){
            spwList = new List<SalesPartsWrapper>();
            pvwlist = new List<PartsVolumeWrapper>();
        }
    }

    public class relevantYearWrapper{
        @AuraEnabled
        public String relevantYear { get; set; }
    }
    public class SalesPartsWrapper{
        @AuraEnabled
        public String id { get; set; }
        @AuraEnabled
        public String name { get; set; }
        @AuraEnabled
        public String opportunityId { get; set; }
        @AuraEnabled
        public String productId { get; set; }
        @AuraEnabled
        public String pinNumber { get; set; }
        @AuraEnabled
        public Decimal lifeCycle { get; set; }
        @AuraEnabled
        public Decimal usage { get; set; }
        @AuraEnabled
        public Decimal mobisTotal { get; set; }
        @AuraEnabled
        public Decimal totalAmount { get; set; }
        @AuraEnabled
        public Decimal vehicleTotal { get; set; }
        @AuraEnabled
        public Decimal weightedAverage { get; set; }
        @AuraEnabled
        public String description { get; set; }
        @AuraEnabled
        public String vehicleProjectId { get; set; }
        @AuraEnabled
        public String vehicleProjectName { get; set; }
        @AuraEnabled
        public String spCurrency { get; set; }
        @AuraEnabled
        public Map<String, PartsVolumeWrapper> spvMap { get; set; }
    }

    public class PartsVolumeWrapper{
        @AuraEnabled
        public String id { get; set; }
        @AuraEnabled
        public String name { get; set; }
        @AuraEnabled
        public String salesPartsId { get; set; }
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
        public Boolean yearRange {get; set;}
        @AuraEnabled
        public Boolean isStartYear {get; set;}
        @AuraEnabled
        public String pvCurrency { get; set; }
    }

    public class SalesPartsSummaryWrapper{
        @AuraEnabled
        public String id { get; set; }
        @AuraEnabled
        public String pinNumber { get; set; }
        @AuraEnabled
        public String description { get; set; }
        @AuraEnabled
        public List<Decimal> mobisVolumeList { get; set; }
        @AuraEnabled
        public List<Decimal> vehicleVolumeList { get; set; }
        @AuraEnabled
        public Decimal total { get; set; }
    }

}