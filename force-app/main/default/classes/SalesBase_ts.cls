/***************************************************************************************
  * Project Name : Hyundai Mobis
  * File Name    : SalesBase_ts
  * Description  :
  * Copyright    : Copyright © I2max. All Rights Reserved. 2022
  * Author       : KyeJin Cheong
  * Created Date : 2022-12-07
****************************************************************************************/

@IsTest
private class SalesBase_ts {

    @TestSetup
    static void setData() {

    }

    @IsTest
    static void testCase01() {

        Test.startTest();

        SalesBase.ProformaWrapper proformaWrapper = new SalesBase.ProformaWrapper();

        proformaWrapper.index = null;
        proformaWrapper.projectStatus = null;
        proformaWrapper.oemStatus = null;
        proformaWrapper.oiTargetYear = null;
        proformaWrapper.dealGrade = null;
        proformaWrapper.bu = null;
        proformaWrapper.moduleParts = null;
        proformaWrapper.team = null;
        proformaWrapper.mediumProductGroup = null;
        proformaWrapper.smallProductGroup = null;
        proformaWrapper.productDescription = null;
        proformaWrapper.accounts = null;
        proformaWrapper.oiManagingRegion = null;
        proformaWrapper.vehicleProject = null;
        proformaWrapper.sop = null;
        proformaWrapper.mobisPlant = null;
        proformaWrapper.salesEntity = null;
        proformaWrapper.currencyIsoCode = null;
        proformaWrapper.usage = null;

        proformaWrapper.relevantYearY0 = null;
        proformaWrapper.relevantYearY1 = null;
        proformaWrapper.relevantYearY2 = null;
        proformaWrapper.relevantYearY3 = null;
        proformaWrapper.relevantYearY4 = null;
        proformaWrapper.relevantYearY5 = null;
        proformaWrapper.relevantYearY6 = null;
        proformaWrapper.relevantYearY7 = null;
        proformaWrapper.relevantYearY8 = null;
        proformaWrapper.relevantYearY9 = null;

        proformaWrapper.oemVehicleVolumeY0 = null;
        proformaWrapper.oemVehicleVolumeY1 = null;
        proformaWrapper.oemVehicleVolumeY2 = null;
        proformaWrapper.oemVehicleVolumeY3 = null;
        proformaWrapper.oemVehicleVolumeY4 = null;
        proformaWrapper.oemVehicleVolumeY5 = null;
        proformaWrapper.oemVehicleVolumeY6 = null;
        proformaWrapper.oemVehicleVolumeY7 = null;
        proformaWrapper.oemVehicleVolumeY8 = null;
        proformaWrapper.oemVehicleVolumeY9 = null;

        proformaWrapper.piecePriceY0 = null;
        proformaWrapper.piecePriceY1 = null;
        proformaWrapper.piecePriceY2 = null;
        proformaWrapper.piecePriceY3 = null;
        proformaWrapper.piecePriceY4 = null;
        proformaWrapper.piecePriceY5 = null;
        proformaWrapper.piecePriceY6 = null;
        proformaWrapper.piecePriceY7 = null;
        proformaWrapper.piecePriceY8 = null;
        proformaWrapper.piecePriceY9 = null;

        proformaWrapper.optionRateY0 = null;
        proformaWrapper.optionRateY1 = null;
        proformaWrapper.optionRateY2 = null;
        proformaWrapper.optionRateY3 = null;
        proformaWrapper.optionRateY4 = null;
        proformaWrapper.optionRateY5 = null;
        proformaWrapper.optionRateY6 = null;
        proformaWrapper.optionRateY7 = null;
        proformaWrapper.optionRateY8 = null;
        proformaWrapper.optionRateY9 = null;

        SalesBase.PlanningPerformanceWrapper planningPerformanceWrapper = new SalesBase.PlanningPerformanceWrapper();

        planningPerformanceWrapper.index = null;
        planningPerformanceWrapper.bu = null;
        planningPerformanceWrapper.team = null;
        planningPerformanceWrapper.oiManagingRegion = null;
        planningPerformanceWrapper.account = null;
        planningPerformanceWrapper.expectedMonth = null;
        planningPerformanceWrapper.planningAmount = null;
        planningPerformanceWrapper.buId = null;
        planningPerformanceWrapper.accountId = null;
        planningPerformanceWrapper.errorMessage = null;

        Test.stopTest();

    }

}