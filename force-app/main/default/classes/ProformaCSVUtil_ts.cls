/***************************************************************************************
  * Project Name : Hyundai Mobis
  * File Name    : ProformaCSVUtil_ts
  * Description  : 
  * Copyright    : Copyright © I2max. All Rights Reserved. 2022 
  * Author       : KyeJin Cheong
  * Created Date : 2022-12-06
****************************************************************************************/
@isTest
private class ProformaCSVUtil_ts {

    @TestSetup
    static void setData(){
        insert SalesTestDataUtil.getProformaCSVList();
        insert SalesTestDataUtil.getBusinessPlanCurrency();
        
    }

    /**
     * Search
     */
    @IsTest
    static void testCase01() {

        List<Map<String, Object>> inputMapList = new List<Map<String, Object>>();

        Test.startTest();

        // Existed Proforma CSV
        List<ProformaDummy__c> proformaCSVList = [
                SELECT Id, Index__c, OEMStatus__c,ProjectStatus__c, OITargetYear__c, DealGrade__c, BU__c, ModuleParts__c, Team__c, MediumProductGroup__c, SmallProductGroup__c, ProductDescription__c, Account__c, OIManagingRegion__c, VehicleProject__c, SOP__c, MobisPlant__c, SalesEntity__c, CurrencyIsoCode, Usage__c

                        // Relevant Year
                        , RelevantYearY0__c, RelevantYearY1__c, RelevantYearY2__c, RelevantYearY3__c, RelevantYearY4__c, RelevantYearY5__c, RelevantYearY6__c, RelevantYearY7__c, RelevantYearY8__c, RelevantYearY9__c

                        // OEM Vehicle Volume
                        , OEMVehicleVolumeY0__c, OEMVehicleVolumeY1__c, OEMVehicleVolumeY2__c, OEMVehicleVolumeY3__c, OEMVehicleVolumeY4__c, OEMVehicleVolumeY5__c, OEMVehicleVolumeY6__c, OEMVehicleVolumeY7__c, OEMVehicleVolumeY8__c, OEMVehicleVolumeY9__c

                        // Piece Price
                        , PiecePriceY0__c, PiecePriceY1__c, PiecePriceY2__c, PiecePriceY3__c, PiecePriceY4__c, PiecePriceY5__c, PiecePriceY6__c, PiecePriceY7__c, PiecePriceY8__c, PiecePriceY9__c

                        // Option Rate
                        , OptionRateY0__c, OptionRateY1__c, OptionRateY2__c, OptionRateY3__c, OptionRateY4__c, OptionRateY5__c, OptionRateY6__c, OptionRateY7__c, OptionRateY8__c, OptionRateY9__c
                FROM ProformaDummy__c
        ];

        // CSV Line
        Map<String, Object> inputLineMap;

        // CSV Line -> CSV Line Map
        for(ProformaDummy__c proformaCSV : proformaCSVList) {
            inputLineMap = new Map<String, Object>();

            inputLineMap.put('Index', proformaCSV.Index__c);
            inputLineMap.put('OEM Status', proformaCSV.OEMStatus__c);
            inputLineMap.put('Project Status', proformaCSV.ProjectStatus__c);
            inputLineMap.put('OI Target Year', proformaCSV.OITargetYear__c);
            inputLineMap.put('Deal Grade', proformaCSV.DealGrade__c);
            inputLineMap.put('BU', proformaCSV.BU__c);
            inputLineMap.put('Module & Parts', proformaCSV.ModuleParts__c);
            inputLineMap.put('Team', proformaCSV.Team__c);
            inputLineMap.put('Medium Product Group', proformaCSV.MediumProductGroup__c);
            inputLineMap.put('Small Product Group', proformaCSV.SmallProductGroup__c);
            inputLineMap.put('Product Description', proformaCSV.ProductDescription__c);
            inputLineMap.put('Accounts', proformaCSV.Account__c);
            inputLineMap.put('OI Managing Region', proformaCSV.OIManagingRegion__c);
            inputLineMap.put('Vehicle Project', proformaCSV.VehicleProject__c);
            inputLineMap.put('SOP', proformaCSV.SOP__c);
            inputLineMap.put('Mobis Plant', proformaCSV.MobisPlant__c);
            inputLineMap.put('Sales Entity', proformaCSV.SalesEntity__c);
            inputLineMap.put('Currency', proformaCSV.CurrencyIsoCode);
            inputLineMap.put('Usage', proformaCSV.Usage__c);

            // Relevant Year
            inputLineMap.put('Relevant Year (Y+0)', proformaCSV.RelevantYearY0__c);
            inputLineMap.put('Relevant Year (Y+1)', proformaCSV.RelevantYearY1__c);
            inputLineMap.put('Relevant Year (Y+2)', proformaCSV.RelevantYearY2__c);
            inputLineMap.put('Relevant Year (Y+3)', proformaCSV.RelevantYearY3__c);
            inputLineMap.put('Relevant Year (Y+4)', proformaCSV.RelevantYearY4__c);
            inputLineMap.put('Relevant Year (Y+5)', proformaCSV.RelevantYearY5__c);
            inputLineMap.put('Relevant Year (Y+6)', proformaCSV.RelevantYearY6__c);
            inputLineMap.put('Relevant Year (Y+7)', proformaCSV.RelevantYearY7__c);
            inputLineMap.put('Relevant Year (Y+8)', proformaCSV.RelevantYearY8__c);
            inputLineMap.put('Relevant Year (Y+9)', proformaCSV.RelevantYearY9__c);

            // OEM Vehicle Volume
            inputLineMap.put('OEM Vehicle Volume (Y+0)', proformaCSV.OEMVehicleVolumeY0__c);
            inputLineMap.put('OEM Vehicle Volume (Y+1)', proformaCSV.OEMVehicleVolumeY1__c);
            inputLineMap.put('OEM Vehicle Volume (Y+2)', proformaCSV.OEMVehicleVolumeY2__c);
            inputLineMap.put('OEM Vehicle Volume (Y+3)', proformaCSV.OEMVehicleVolumeY3__c);
            inputLineMap.put('OEM Vehicle Volume (Y+4)', proformaCSV.OEMVehicleVolumeY4__c);
            inputLineMap.put('OEM Vehicle Volume (Y+5)', proformaCSV.OEMVehicleVolumeY5__c);
            inputLineMap.put('OEM Vehicle Volume (Y+6)', proformaCSV.OEMVehicleVolumeY6__c);
            inputLineMap.put('OEM Vehicle Volume (Y+7)', proformaCSV.OEMVehicleVolumeY7__c);
            inputLineMap.put('OEM Vehicle Volume (Y+8)', proformaCSV.OEMVehicleVolumeY8__c);
            inputLineMap.put('OEM Vehicle Volume (Y+9)', proformaCSV.OEMVehicleVolumeY9__c);

            // Piece Price
            inputLineMap.put('Piece Price (Y+0)', proformaCSV.PiecePriceY0__c);
            inputLineMap.put('Piece Price (Y+1)', proformaCSV.PiecePriceY1__c);
            inputLineMap.put('Piece Price (Y+2)', proformaCSV.PiecePriceY2__c);
            inputLineMap.put('Piece Price (Y+3)', proformaCSV.PiecePriceY3__c);
            inputLineMap.put('Piece Price (Y+4)', proformaCSV.PiecePriceY4__c);
            inputLineMap.put('Piece Price (Y+5)', proformaCSV.PiecePriceY5__c);
            inputLineMap.put('Piece Price (Y+6)', proformaCSV.PiecePriceY6__c);
            inputLineMap.put('Piece Price (Y+7)', proformaCSV.PiecePriceY7__c);
            inputLineMap.put('Piece Price (Y+8)', proformaCSV.PiecePriceY8__c);
            inputLineMap.put('Piece Price (Y+9)', proformaCSV.PiecePriceY9__c);

            // Option Rate
            inputLineMap.put('Option Rate (Y+0)', proformaCSV.OptionRateY0__c);
            inputLineMap.put('Option Rate (Y+1)', proformaCSV.OptionRateY1__c);
            inputLineMap.put('Option Rate (Y+2)', proformaCSV.OptionRateY2__c);
            inputLineMap.put('Option Rate (Y+3)', proformaCSV.OptionRateY3__c);
            inputLineMap.put('Option Rate (Y+4)', proformaCSV.OptionRateY4__c);
            inputLineMap.put('Option Rate (Y+5)', proformaCSV.OptionRateY5__c);
            inputLineMap.put('Option Rate (Y+6)', proformaCSV.OptionRateY6__c);
            inputLineMap.put('Option Rate (Y+7)', proformaCSV.OptionRateY7__c);
            inputLineMap.put('Option Rate (Y+8)', proformaCSV.OptionRateY8__c);
            inputLineMap.put('Option Rate (Y+9)', proformaCSV.OptionRateY9__c);

            inputMapList.add(inputLineMap);
        }

        System.debug('inputMapList.size() > ' + inputMapList.size());

        // Test 시작
        ProformaCSVUtil.search('ProformaDummy__c', inputMapList);

        Test.stopTest();
    }

    /**
     * Save
     */
    @IsTest
    static void testCase02() {

        Test.startTest();

        Currency__c currencyType = [SELECT Id, Name, Year__c FROM Currency__c];

        System.debug('Test.currencyType > ' + currencyType);

        Map<String, Object> reqData = new Map<String, Object>();

        // Existed Proforma CSV
        List<ProformaDummy__c> proformaCSVList = [
                SELECT Id, Index__c, OEMStatus__c,ProjectStatus__c, OITargetYear__c, DealGrade__c, BU__c, ModuleParts__c, Team__c, MediumProductGroup__c, SmallProductGroup__c, ProductDescription__c, Account__c, OIManagingRegion__c, VehicleProject__c, SOP__c, MobisPlant__c, SalesEntity__c, CurrencyIsoCode, Usage__c

                        // Relevant Year
                        , RelevantYearY0__c, RelevantYearY1__c, RelevantYearY2__c, RelevantYearY3__c, RelevantYearY4__c, RelevantYearY5__c, RelevantYearY6__c, RelevantYearY7__c, RelevantYearY8__c, RelevantYearY9__c

                        // OEM Vehicle Volume
                        , OEMVehicleVolumeY0__c, OEMVehicleVolumeY1__c, OEMVehicleVolumeY2__c, OEMVehicleVolumeY3__c, OEMVehicleVolumeY4__c, OEMVehicleVolumeY5__c, OEMVehicleVolumeY6__c, OEMVehicleVolumeY7__c, OEMVehicleVolumeY8__c, OEMVehicleVolumeY9__c

                        // Piece Price
                        , PiecePriceY0__c, PiecePriceY1__c, PiecePriceY2__c, PiecePriceY3__c, PiecePriceY4__c, PiecePriceY5__c, PiecePriceY6__c, PiecePriceY7__c, PiecePriceY8__c, PiecePriceY9__c

                        // Option Rate
                        , OptionRateY0__c, OptionRateY1__c, OptionRateY2__c, OptionRateY3__c, OptionRateY4__c, OptionRateY5__c, OptionRateY6__c, OptionRateY7__c, OptionRateY8__c, OptionRateY9__c
                FROM ProformaDummy__c
        ];

        List<SalesBase.ProformaWrapper> csvList = new List<SalesBase.ProformaWrapper>();
        SalesBase.ProformaWrapper csvWrapper;

        for(ProformaDummy__c proformaCSV : proformaCSVList) {

            csvWrapper = new SalesBase.ProformaWrapper();

            csvWrapper.index = (Integer) proformaCSV.Index__c;
            csvWrapper.oemStatus = proformaCSV.OEMStatus__c;
            csvWrapper.projectStatus = proformaCSV.ProjectStatus__c;
            csvWrapper.oiTargetYear = proformaCSV.OITargetYear__c;
            csvWrapper.dealGrade = proformaCSV.DealGrade__c;
            csvWrapper.bu = proformaCSV.BU__c;
            csvWrapper.moduleParts = proformaCSV.ModuleParts__c;
            csvWrapper.team = proformaCSV.Team__c;
            csvWrapper.mediumProductGroup = proformaCSV.MediumProductGroup__c;
            csvWrapper.smallProductGroup = proformaCSV.SmallProductGroup__c;
            csvWrapper.productDescription = proformaCSV.ProductDescription__c;
            csvWrapper.accounts = proformaCSV.Account__c;
            csvWrapper.oiManagingRegion = proformaCSV.OIManagingRegion__c;
            csvWrapper.vehicleProject = proformaCSV.VehicleProject__c;
            csvWrapper.sop = proformaCSV.SOP__c;
            csvWrapper.mobisPlant = proformaCSV.MobisPlant__c;
            csvWrapper.salesEntity = proformaCSV.SalesEntity__c;
            csvWrapper.currencyIsoCode = proformaCSV.CurrencyIsoCode;
            csvWrapper.usage = proformaCSV.Usage__c;
            // Relevant Year
            csvWrapper.relevantYearY0 = (Integer) proformaCSV.RelevantYearY0__c;
            csvWrapper.relevantYearY1 = (Integer) proformaCSV.RelevantYearY1__c;
            csvWrapper.relevantYearY2 = (Integer) proformaCSV.RelevantYearY2__c;
            csvWrapper.relevantYearY3 = (Integer) proformaCSV.RelevantYearY3__c;
            csvWrapper.relevantYearY4 = (Integer) proformaCSV.RelevantYearY4__c;
            csvWrapper.relevantYearY5 = (Integer) proformaCSV.RelevantYearY5__c;
            csvWrapper.relevantYearY6 = (Integer) proformaCSV.RelevantYearY6__c;
            csvWrapper.relevantYearY7 = (Integer) proformaCSV.RelevantYearY7__c;
            csvWrapper.relevantYearY8 = (Integer) proformaCSV.RelevantYearY8__c;
            csvWrapper.relevantYearY9 = (Integer) proformaCSV.RelevantYearY9__c;

            // OEM Vehicle Volume
            csvWrapper.oemVehicleVolumeY0 = (Integer) proformaCSV.OEMVehicleVolumeY0__c;
            csvWrapper.oemVehicleVolumeY1 = (Integer) proformaCSV.OEMVehicleVolumeY1__c;
            csvWrapper.oemVehicleVolumeY2 = (Integer) proformaCSV.OEMVehicleVolumeY2__c;
            csvWrapper.oemVehicleVolumeY3 = (Integer) proformaCSV.OEMVehicleVolumeY3__c;
            csvWrapper.oemVehicleVolumeY4 = (Integer) proformaCSV.OEMVehicleVolumeY4__c;
            csvWrapper.oemVehicleVolumeY5 = (Integer) proformaCSV.OEMVehicleVolumeY5__c;
            csvWrapper.oemVehicleVolumeY6 = (Integer) proformaCSV.OEMVehicleVolumeY6__c;
            csvWrapper.oemVehicleVolumeY7 = (Integer) proformaCSV.OEMVehicleVolumeY7__c;
            csvWrapper.oemVehicleVolumeY8 = (Integer) proformaCSV.OEMVehicleVolumeY8__c;
            csvWrapper.oemVehicleVolumeY9 = (Integer) proformaCSV.OEMVehicleVolumeY9__c;

            // Piece Price
            csvWrapper.piecePriceY0 = proformaCSV.PiecePriceY0__c;
            csvWrapper.piecePriceY1 = proformaCSV.PiecePriceY1__c;
            csvWrapper.piecePriceY2 = proformaCSV.PiecePriceY2__c;
            csvWrapper.piecePriceY3 = proformaCSV.PiecePriceY3__c;
            csvWrapper.piecePriceY4 = proformaCSV.PiecePriceY4__c;
            csvWrapper.piecePriceY5 = proformaCSV.PiecePriceY5__c;
            csvWrapper.piecePriceY6 = proformaCSV.PiecePriceY6__c;
            csvWrapper.piecePriceY7 = proformaCSV.PiecePriceY7__c;
            csvWrapper.piecePriceY8 = proformaCSV.PiecePriceY8__c;
            csvWrapper.piecePriceY9 = proformaCSV.PiecePriceY9__c;

            // Option Rate
            csvWrapper.optionRateY0 = (Integer) proformaCSV.OptionRateY0__c;
            csvWrapper.optionRateY1 = (Integer) proformaCSV.OptionRateY1__c;
            csvWrapper.optionRateY2 = (Integer) proformaCSV.OptionRateY2__c;
            csvWrapper.optionRateY3 = (Integer) proformaCSV.OptionRateY3__c;
            csvWrapper.optionRateY4 = (Integer) proformaCSV.OptionRateY4__c;
            csvWrapper.optionRateY5 = (Integer) proformaCSV.OptionRateY5__c;
            csvWrapper.optionRateY6 = (Integer) proformaCSV.OptionRateY6__c;
            csvWrapper.optionRateY7 = (Integer) proformaCSV.OptionRateY7__c;
            csvWrapper.optionRateY8 = (Integer) proformaCSV.OptionRateY8__c;
            csvWrapper.optionRateY9 = (Integer) proformaCSV.OptionRateY9__c;

            csvList.add(csvWrapper);
        }

        System.debug('csvList.size() > ' + csvList.size());

        reqData.put('csvName', JSON.serialize('Test CSV File'));
        reqData.put('changeDescription', JSON.serialize('Test Description'));
        reqData.put('objectTypeValue', SalesConst.PROFORMA_DUMMY);
        reqData.put('csvList', JSON.serialize(csvList));

        ProformaCSVUtil.save(reqData);

        Test.stopTest();
    }
}