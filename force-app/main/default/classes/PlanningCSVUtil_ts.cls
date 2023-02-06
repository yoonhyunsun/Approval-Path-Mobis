/***************************************************************************************
  * Project Name : Hyundai Mobis
  * File Name    : PlanningCSVUtil_ts
  * Description  : 
  * Copyright    : Copyright © I2max. All Rights Reserved. 2022 
  * Author       : Hyunsun Yoon
  * Created Date : 2022-12-06
****************************************************************************************/
//@isTest
public class PlanningCSVUtil_ts {

    /*
    @TestSetup
    static void setData(){
        insert SalesTestDataUtil.getPlanningCSVList();
    }


    // Search
    @IsTest
    static void testSearch() {

        List<Map<String, Object>> inputMapList = new List<Map<String, Object>>();

        Test.startTest();

        // Existed Planning CSV
        List<PlanningPerformance__c> planningCSVList = [
                SELECT 
                    Id, 
                    Index__c, 
                    Account__c,
                    BU__c, 
                    LargeGroup__c, 
                    OIManagingRegion__c, 
                    WeightedLTR__c,
                    Date__c
                FROM PlanningPerformance__c
        ];

        // CSV Line
        Map<String, Object> inputLineMap;

        // CSV Line -> CSV Line Map
        for(PlanningPerformance__c planningCSV : planningCSVList) {
            inputLineMap = new Map<String, Object>();

            inputLineMap.put('Index', planningCSV.Index__c);
            inputLineMap.put('BU', planningCSV.BU__c);
            inputLineMap.put('Team', planningCSV.LargeGroup__c);
            inputLineMap.put('OIManagingRegion', planningCSV.OIManagingRegion__c);
            inputLineMap.put('Account', planningCSV.Account__c);
            inputLineMap.put('ExpectedMonth', planningCSV.Date__c);
            inputLineMap.put('PlanningAmount', planningCSV.WeightedLTR__c);

            inputMapList.add(inputLineMap);
        }

        System.debug('inputMapList.size() > ' + inputMapList.size());

        // Test 시작
        PlanningCSVUtil.search('PlanningPerformance__c', inputMapList);

        Test.stopTest();
    }



    // Save
    @IsTest
    static void testSave() {

        Test.startTest();

        Map<String, Object> reqData = new Map<String, Object>();

        // Existed Planning CSV
        List<PlanningPerformance__c> planningCSVList = [
                SELECT 
                    Id, 
                    Index__c, 
                    Account__c,
                    BU__c, 
                    LargeGroup__c, 
                    OIManagingRegion__c, 
                    WeightedLTR__c,
                    Date__c
                FROM PlanningPerformance__c
        ];

        List<SalesBase.PlanningPerformanceWrapper> csvList = new List<SalesBase.PlanningPerformanceWrapper>();
        SalesBase.PlanningPerformanceWrapper csvWrapper;

        for(PlanningPerformance__c planningCSV : planningCSVList) {

            csvWrapper = new SalesBase.PlanningPerformanceWrapper();

            csvWrapper.index = (Integer) planningCSV.Index__c;
            csvWrapper.buId = planningCSV.BU__c;
            csvWrapper.team = planningCSV.LargeGroup__c;
            csvWrapper.oiManagingRegion = planningCSV.OIManagingRegion__c;
            csvWrapper.accountId = planningCSV.Account__c;
            csvWrapper.expectedMonth = planningCSV.Date__c;
            csvWrapper.planningAmount = planningCSV.WeightedLTR__c;

            csvList.add(csvWrapper);
        }

        System.debug('csvList.size() > ' + csvList.size());

        reqData.put('csvName', JSON.serialize('Test CSV File'));
        reqData.put('changeDescription', JSON.serialize('Test Description'));
        reqData.put('objectTypeValue', SalesConst.PLANNING_PERFORMANCE);
        reqData.put('csvList', JSON.serialize(csvList));

        PlanningCSVUtil.save(reqData);

        Test.stopTest();
    }
       
	*/
}