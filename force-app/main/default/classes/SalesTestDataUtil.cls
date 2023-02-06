/***************************************************************************************
  * Project Name : Hyundai Mobis
  * File Name    : SalesTestDataUtil
  * Description  : 
  * Copyright    : Copyright © I2max. All Rights Reserved. 2022 
  * Author       : KyeJin Cheong
  * Created Date : 2022-11-25
****************************************************************************************/

@SuppressWarnings('PMD.AvoidHardcodingId')
@IsTest
public with sharing class SalesTestDataUtil {

    // Custom Objects
    public static Account account;
    public static List<Account> accountList;
    public static AccountRegion__c accountRegion;
    public static List<AccountRegion__c> accountRegionList;
    public static BU__c bu;
    public static List<BU__c> buList;
    public static Product2 product;
    public static List<Product2> productList;
    public static VehicleProject__c singleVehicleProject;
    public static List<VehicleProject__c> singleVehicleProjectList;
    public static VehicleProject__c combineVehicleProject;
    public static List<VehicleProject__c> combineVehicleProjectList;
    public static Opportunity opportunity;
    public static List<Opportunity> opportunityList;
    public static Contents__c content;
    public static List<Contents__c> contentList;
    public static List<PlanningPerformance__c> planningCSVList;
    public static List<PlanningPerformance__c> planningList;
    public static List<ProformaDummy__c> proformaCSVList;
    public static List<Proforma__c> proformaList;

    //====================
    //====================
    //====================
    public static Currency__c businessCurrency;
    public static List<Currency__c> businessCurrencyList;
    public static Currency__c midToLongCurrency;
    public static List<Currency__c> midToLongCurrencyList;
    public static Currency__c customerCurrency;
    public static List<Currency__c> customerCurrencyList;
    public static SalesParts__c salesParts;
    public static List<SalesParts__c> salesPartsList;
    public static Opportunity combineOpportunity;
    public static List<SalesParts__c> combineSalesPartsList;
    public static List<SalesPartsVolume__c> combineSalesPartsVolumeList;
    public static SalesPartsVolume__c salesPartsVolume;
    public static List<SalesPartsVolume__c> salesPartsVolumeList;
    public static Development__c development;
    public static List<Development__c> developmentList;
    public static DevelopmentParts__c developmentPart;
    public static List<DevelopmentParts__c> developmentPartsList;
    public static DevelopmentPartsVolume__c developmentPartsVolume;
    public static List<DevelopmentPartsVolume__c> developmentPartsVolumeList;
    public static EngineeringChangeRequest__c ecr;
    public static List<EngineeringChangeRequest__c> ecrList;
    public static EngineeringChangeProposal__c ecp;
    public static List<EngineeringChangeProposal__c> ecpList;
    public static LumpSumCollectionManagement__c lsc;
    public static List<LumpSumCollectionManagement__c> lscList;

    public static void setBypass() {
        TriggerHandler.bypass('Opportunity_tr');
    }

    public static AccountRegion__c getAccountRegion() {
        accountRegion = new AccountRegion__c();

        accountRegion.Name = 'NA';

        return accountRegion;
    }

    public static List<AccountRegion__c> getAccountRegionList() {
        accountRegionList = new List<AccountRegion__c>();

        return accountRegionList;
    }

    public static Account getAccount() {
        if(accountRegion == null) insert getAccountRegion();

        account = new Account();

        account.Name = 'Test Account';
        account.AccountRegion__c = accountRegion.Id;
        account.KAE__c = UserInfo.getUserId();

        return account;
    }

    public static List<Account> getAccountList() {
        accountList = new List<Account>();

        return accountList;
    }

    public static BU__c getBU() {
        bu = new BU__c();

        bu.Name = 'Test BU';

        return bu;
    }

    public static List<BU__c> getBUList() {
        buList = new List<BU__c>();

        return buList;
    }

    public static Product2 getProduct() {
        if(bu == null) insert getBU();

        product = new Product2();

        product.Name = 'Test Product';
        product.BU__c = bu.Id;
        product.LargeGroup__c = 'AV'; // Label : Team, Test Values : AV

        return product;
    }

    public static List<Product2> getProductList() {
        if(bu == null) insert getBU();

        productList = new List<Product2>();

        product = new Product2();
        product.Name = 'Test Product AV';
        product.BU__c = bu.Id;
        product.LargeGroup__c = 'AV'; // Label : Team, Picklist Values : AV
        productList.add(product);

        product = new Product2();
        product.Name = 'Test Product Chassis & Safety';
        product.BU__c = bu.Id;
        product.LargeGroup__c = 'C & S'; // Label : Team, Picklist Values : C & S
        productList.add(product);

        product = new Product2();
        product.Name = 'Test Product e-PT';
        product.BU__c = bu.Id;
        product.LargeGroup__c = 'e-PT'; // Label : Team, Picklist Values : e-PT
        productList.add(product);

        product = new Product2();
        product.Name = 'Test Product IVI';
        product.BU__c = bu.Id;
        product.LargeGroup__c = 'IVI'; // Label : Team, Picklist Values : IVI
        productList.add(product);

        product = new Product2();
        product.Name = 'Test Product Lamp';
        product.BU__c = bu.Id;
        product.LargeGroup__c = 'Lamp'; // Label : Team, Picklist Values : Lamp
        productList.add(product);

        product = new Product2();
        product.Name = 'Test Product Module';
        product.BU__c = bu.Id;
        product.LargeGroup__c = 'Module'; // Label : Team, Picklist Values : Module
        productList.add(product);

        return productList;
    }

    public static VehicleProject__c getSingleVehicleProject() {
        if(account == null) insert getAccount();

        singleVehicleProject = new VehicleProject__c();

        singleVehicleProject.RecordTypeId = SalesConst.RECTYPE_SINGLE_PROJECT;
        singleVehicleProject.AccountName__c = account.Id;
        singleVehicleProject.Name = 'Test Single Vehicle Project';

        return singleVehicleProject;
    }

    public static List<VehicleProject__c> getSingleVehicleProjectList() {
        singleVehicleProjectList = new List<VehicleProject__c>();

        return singleVehicleProjectList;
    }

    public static VehicleProject__c getCombineVehicleProject() {
        if(account == null) insert getAccount();

        combineVehicleProject = new VehicleProject__c();

        combineVehicleProject.RecordTypeId = SalesConst.RECTYPE_PLATFORM_COMBINED_PROJECT;
        combineVehicleProject.AccountName__c = account.Id;
        combineVehicleProject.Name = 'Test Combine Vehicle Project';

        return combineVehicleProject;
    }

    public static List<VehicleProject__c> getCombineVehicleProjectList() {
        combineVehicleProjectList = new List<VehicleProject__c>();

        return combineVehicleProjectList;
    }

    public static Opportunity getOpportunity(){
        if(account == null) insert getAccount();
        if(bu == null) insert getBU();
        if(product == null) insert getProduct();
        if(singleVehicleProject == null) insert getSingleVehicleProject();
        //====================
        if(accountRegion == null) insert getAccountRegion();
        if(businessCurrency == null) insert getBusinessPlanCurrency();

        opportunity = new Opportunity();

        opportunity.Name = 'Test Opportunity';
        opportunity.AccountId = account.Id;
        opportunity.BU__c = bu.Id;
        opportunity.Product__c = product.Id;
        opportunity.VehicleProject__c = singleVehicleProject.Id; // Single Vehicle Project
        opportunity.CloseDate = Date.today().addYears(1); // Label : Expected RFQ received, Values : Current Date + Add 1 Year

        opportunity.StageName = 'Qualification';

        //====================
        opportunity.SOP__c = Date.today();
        opportunity.AccountRegion__c = accountRegion.Id;
        opportunity.CurrencyType__c = businessCurrency.Id;
        opportunity.LifeCycle__c = SalesConst.LIFE_CYCLE;
        opportunity.CurrencyIsoCode = SalesConst.DEFAULT_CURRENCY;

        return opportunity;
    }

    public static List<Opportunity> getOpportunityList() {
        opportunityList = new List<Opportunity>();

        return opportunityList;
    }

    /**
     * TODO: Content
     */
    public static Contents__c getContent() {
        if(opportunity == null) insert getOpportunity();

        content = new Contents__c();

        content.Name = 'Test Content';
        content.Opportunity__c = opportunity.Id;

        return content;
    }

    public static List<Contents__c> getContentList() {
        contentList = new List<Contents__c>();

        return contentList;
    }

    // Proforma CSV
    public static List<ProformaDummy__c> getProformaCSVList() {

        proformaCSVList = new List<ProformaDummy__c>();

        ProformaDummy__c proformaCSVLines = new ProformaDummy__c();

        proformaCSVLines.Index__c = 1;
        proformaCSVLines.OEMStatus__c = 'GOE';
        proformaCSVLines.ProjectStatus__c = 'MassProduction';
        proformaCSVLines.OITargetYear__c = 2018;
        proformaCSVLines.DealGrade__c = 'OI';
        proformaCSVLines.BU__c = 'C&S';
        proformaCSVLines.ModuleParts__c = 'Parts';
        proformaCSVLines.Team__c = 'Chassis & Safety';
        proformaCSVLines.MediumProductGroup__c = 'Air Suspension';
        proformaCSVLines.SmallProductGroup__c = 'Air Suspension';
        proformaCSVLines.ProductDescription__c = '';
        proformaCSVLines.Account__c = 'FAW';
        proformaCSVLines.OIManagingRegion__c = 'CN';
        proformaCSVLines.VehicleProject__c = 'E115';
        proformaCSVLines.SOP__c = 2020;
        proformaCSVLines.MobisPlant__c = 'Outsourcing';
        proformaCSVLines.SalesEntity__c = 'HQ';
        proformaCSVLines.CurrencyIsoCode = 'USD';
        proformaCSVLines.Usage__c = 1;

        // Relevant Year
        proformaCSVLines.RelevantYearY0__c = 2023;
        proformaCSVLines.RelevantYearY1__c = 2024;
        proformaCSVLines.RelevantYearY2__c = 2025;
        proformaCSVLines.RelevantYearY3__c = 2026;
        proformaCSVLines.RelevantYearY4__c = 2027;
        proformaCSVLines.RelevantYearY5__c = 2028;
        proformaCSVLines.RelevantYearY6__c = 2029;
        proformaCSVLines.RelevantYearY7__c = 2030;
        proformaCSVLines.RelevantYearY8__c = 2031;
        proformaCSVLines.RelevantYearY9__c = 2032;

        // OEM Vehicle Volume
        proformaCSVLines.OEMVehicleVolumeY0__c = 8550;
        proformaCSVLines.OEMVehicleVolumeY1__c = 8550;
        proformaCSVLines.OEMVehicleVolumeY2__c = 8550;
        proformaCSVLines.OEMVehicleVolumeY3__c = 6413;
        proformaCSVLines.OEMVehicleVolumeY4__c = 0;
        proformaCSVLines.OEMVehicleVolumeY5__c = 0;
        proformaCSVLines.OEMVehicleVolumeY6__c = 0;
        proformaCSVLines.OEMVehicleVolumeY7__c = 0;
        proformaCSVLines.OEMVehicleVolumeY8__c = 0;
        proformaCSVLines.OEMVehicleVolumeY9__c = 0;

        // Piece Price
        proformaCSVLines.PiecePriceY0__c = 569.3124;
        proformaCSVLines.PiecePriceY1__c = 569.3124;
        proformaCSVLines.PiecePriceY2__c = 569.3124;
        proformaCSVLines.PiecePriceY3__c = 569.3124;
        proformaCSVLines.PiecePriceY4__c = 0;
        proformaCSVLines.PiecePriceY5__c = 0;
        proformaCSVLines.PiecePriceY6__c = 0;
        proformaCSVLines.PiecePriceY7__c = 0;
        proformaCSVLines.PiecePriceY8__c = 0;
        proformaCSVLines.PiecePriceY9__c = 0;

        // Option Rate
        proformaCSVLines.OptionRateY0__c = 100;
        proformaCSVLines.OptionRateY1__c = 100;
        proformaCSVLines.OptionRateY2__c = 100;
        proformaCSVLines.OptionRateY3__c = 100;
        proformaCSVLines.OptionRateY4__c = 100;
        proformaCSVLines.OptionRateY5__c = 100;
        proformaCSVLines.OptionRateY6__c = 100;
        proformaCSVLines.OptionRateY7__c = 100;
        proformaCSVLines.OptionRateY8__c = 100;
        proformaCSVLines.OptionRateY9__c = 100;

        proformaCSVList.add(proformaCSVLines);

        proformaCSVLines = new ProformaDummy__c();

        proformaCSVLines.Index__c = 2;
        proformaCSVLines.OEMStatus__c = 'GOE';
        proformaCSVLines.ProjectStatus__c = 'MassProduction';
        proformaCSVLines.OITargetYear__c = 2018;
        proformaCSVLines.DealGrade__c = 'OI';
        proformaCSVLines.BU__c = 'C&S';
        proformaCSVLines.ModuleParts__c = 'Parts';
        proformaCSVLines.Team__c = 'Chassis & Safety';
        proformaCSVLines.MediumProductGroup__c = 'Air Suspension';
        proformaCSVLines.SmallProductGroup__c = 'Air Suspension';
        proformaCSVLines.ProductDescription__c = '';
        proformaCSVLines.Account__c = 'FAW';
        proformaCSVLines.OIManagingRegion__c = 'CN';
        proformaCSVLines.VehicleProject__c = 'H9(H7-II)';
        proformaCSVLines.SOP__c = 2020;
        proformaCSVLines.MobisPlant__c = 'Outsourcing';
        proformaCSVLines.SalesEntity__c = 'HQ';
        proformaCSVLines.CurrencyIsoCode = 'USD';
        proformaCSVLines.Usage__c = 1;

        // Relevant Year
        proformaCSVLines.RelevantYearY0__c = 2023;
        proformaCSVLines.RelevantYearY1__c = 2024;
        proformaCSVLines.RelevantYearY2__c = 2025;
        proformaCSVLines.RelevantYearY3__c = 2026;
        proformaCSVLines.RelevantYearY4__c = 2027;
        proformaCSVLines.RelevantYearY5__c = 2028;
        proformaCSVLines.RelevantYearY6__c = 2029;
        proformaCSVLines.RelevantYearY7__c = 2030;
        proformaCSVLines.RelevantYearY8__c = 2031;
        proformaCSVLines.RelevantYearY9__c = 2032;

        // OEM Vehicle Volume
        proformaCSVLines.OEMVehicleVolumeY0__c = 5000;
        proformaCSVLines.OEMVehicleVolumeY1__c = 5000;
        proformaCSVLines.OEMVehicleVolumeY2__c = 5000;
        proformaCSVLines.OEMVehicleVolumeY3__c = 2500;
        proformaCSVLines.OEMVehicleVolumeY4__c = 0;
        proformaCSVLines.OEMVehicleVolumeY5__c = 0;
        proformaCSVLines.OEMVehicleVolumeY6__c = 0;
        proformaCSVLines.OEMVehicleVolumeY7__c = 0;
        proformaCSVLines.OEMVehicleVolumeY8__c = 0;
        proformaCSVLines.OEMVehicleVolumeY9__c = 0;

        // Piece Price
        proformaCSVLines.PiecePriceY0__c = 574.45908;
        proformaCSVLines.PiecePriceY1__c = 574.45908;
        proformaCSVLines.PiecePriceY2__c = 574.45908;
        proformaCSVLines.PiecePriceY3__c = 574.45908;
        proformaCSVLines.PiecePriceY4__c = 0;
        proformaCSVLines.PiecePriceY5__c = 0;
        proformaCSVLines.PiecePriceY6__c = 0;
        proformaCSVLines.PiecePriceY7__c = 0;
        proformaCSVLines.PiecePriceY8__c = 0;
        proformaCSVLines.PiecePriceY9__c = 0;

        // Option Rate
        proformaCSVLines.OptionRateY0__c = 100;
        proformaCSVLines.OptionRateY1__c = 100;
        proformaCSVLines.OptionRateY2__c = 100;
        proformaCSVLines.OptionRateY3__c = 100;
        proformaCSVLines.OptionRateY4__c = 100;
        proformaCSVLines.OptionRateY5__c = 100;
        proformaCSVLines.OptionRateY6__c = 100;
        proformaCSVLines.OptionRateY7__c = 100;
        proformaCSVLines.OptionRateY8__c = 100;
        proformaCSVLines.OptionRateY9__c = 100;

        proformaCSVList.add(proformaCSVLines);

        System.debug('proformaCSVList.size() > ' + proformaCSVList.size()); // 2

        return proformaCSVList;
    }

    // Proforma
    public static List<Proforma__c> getProformaList() {

        if(proformaList == null) insert getProformaCSVList();

        proformaList = new List<Proforma__c>();

        Proforma__c proforma;

        for(ProformaDummy__c proformaDummy : proformaCSVList) {

            for(Integer i = 0; i < 10; i++) {
                // Input Values
                String relevantYear = 'RelevantYearY' + i + '__c';
                String oemVehicleVolume = 'OEMVehicleVolumeY' + i + '__c';
                String optionRate = 'OptionRateY' + i + '__c';
                String piecePrice = 'PiecePriceY' + i + '__c';

                // Formulas
                String crRate               = 'fm_CRRateY' + i + '__c';
                String mobisProductVolume   = 'fm_MobisProductVolumeY' + i + '__c';
                String localSalesAmount     = 'fm_LocalSalesAmountY' + i + '__c';
                String wonSalesAmount       = 'fm_WonSalesAmountY' + i + '__c';
                String dollarSalesAmount    = 'fm_DollarSalesAmountY' + i + '__c';

                proforma = new Proforma__c();

                proforma.CurrencyType__c        = proformaDummy.CurrencyType__c;
                proforma.CurrencyIsoCode        = proformaDummy.CurrencyIsoCode;

                proforma.OEMStatus__c           = proformaDummy.OEMStatus__c;
                proforma.ProjectStatus__c       = proformaDummy.ProjectStatus__c;
                proforma.OITargetYear__c        = proformaDummy.OITargetYear__c;
                proforma.DealGrade__c           = proformaDummy.DealGrade__c;
                proforma.BU__c                  = proformaDummy.BU__c;
                proforma.ModuleParts__c         = proformaDummy.ModuleParts__c;
                proforma.Team__c                = proformaDummy.Team__c;
                proforma.MediumProductGroup__c  = proformaDummy.MediumProductGroup__c;
                proforma.SmallProductGroup__c   = proformaDummy.SmallProductGroup__c;
                proforma.ProductDescription__c  = proformaDummy.ProductDescription__c;
                proforma.Account__c             = proformaDummy.Account__c;
                proforma.OIManagingRegion__c    = proformaDummy.OIManagingRegion__c;
                proforma.VehicleProject__c      = proformaDummy.VehicleProject__c;
                proforma.SOP__c                 = proformaDummy.SOP__c;
                proforma.MobisPlant__c          = proformaDummy.MobisPlant__c;
                proforma.SalesEntity__c         = proformaDummy.SalesEntity__c;
                proforma.Usage__c               = proformaDummy.Usage__c;

                // Input Values
                proforma.RelevantYear__c        = (Decimal) proformaDummy.get(relevantYear);
                proforma.OEMVehicleVolume__c    = (Decimal) proformaDummy.get(oemVehicleVolume);
                proforma.OptionRate__c          = (Decimal) proformaDummy.get(optionRate) * 0.01;
                proforma.PiecePrice__c          = (Decimal) proformaDummy.get(piecePrice);

                // 매출 데이터 및 CR율
                proforma.CRRate__c              = (Decimal) proformaDummy.get(crRate);
                proforma.MobisProductVolume__c  = (Decimal) proformaDummy.get(mobisProductVolume);
                proforma.LocalSalesAmount__c    = (Decimal) proformaDummy.get(localSalesAmount);
                proforma.WonSalesAmount__c      = (Decimal) proformaDummy.get(wonSalesAmount);
                proforma.DollarSalesAmount__c   = (Decimal) proformaDummy.get(dollarSalesAmount);

                // 수주 데이터
                if(proforma.SOP__c == proforma.RelevantYear__c && proforma.ProjectStatus__c.equalsIgnoreCase('Plan')) {
                    proforma.LocalContractAmount__c     = proformaDummy.fm_LocalContractAmount__c;
                    proforma.WonContractAmount__c       = proformaDummy.fm_WonContractAmount__c;
                    proforma.DollarContractAmount__c    = proformaDummy.fm_DollarContractAmount__c;
                } else {
                    // 0
                    proforma.LocalContractAmount__c     = 0;
                    proforma.WonContractAmount__c       = 0;
                    proforma.DollarContractAmount__c    = 0;
                }

                // Index + Project Status + OI Target Year + Medium Product Group + Small Product Group +
                // Product Description + Account + OI Managing Region + Vehicle Project + Mobis Plant + Sales Entity + Relevant Year
                proforma.ExternalID__c = SalesUtil.getProformaExternalKey(proformaDummy.Index__c, proforma.VehicleProject__c, proformaDummy.MediumProductGroup__c, proformaDummy.SmallProductGroup__c,
                        Integer.valueOf(proforma.RelevantYear__c), Integer.valueOf(proforma.OEMVehicleVolume__c), Integer.valueOf(proforma.OptionRate__c), Integer.valueOf(proforma.PiecePrice__c));

                proformaList.add(proforma);
            }
        }

        System.debug('proformaList.size() > ' + proformaList.size()); // 20

        return proformaList;
    }


    //====================
    //====================
    //====================

    public static Currency__c getBusinessPlanCurrency(){
        businessCurrency = new Currency__c();

        businessCurrency.Name = 'Test BP Currency';
        businessCurrency.RecordTypeId = SalesConst.RECTYPE_BUSINESS_PLAN;
        businessCurrency.CNY__c = SalesConst.CNY_RATE;
        businessCurrency.EUR__c = SalesConst.EUR_RATE;
        businessCurrency.JPY__c = SalesConst.JPY_RATE;
        businessCurrency.USD__c = SalesConst.USD_RATE;

        /**
         * @author Kyejin Cheong
         * @description 코드 에러 원인 - Test Factory Class 에 연도 미표기 (추가완료, 23-01-04)
         */
        businessCurrency.Year__c = '2023';

        return businessCurrency;
    }

    public static List<Currency__c> getBusinessPlanCurrencyList(){
        businessCurrencyList = new List<Currency__c>();
        return businessCurrencyList;
    }

    public static Currency__c getMidToLongCurrency(){
        midToLongCurrency = new Currency__c();

        midToLongCurrency.Name = 'Test MTL Currency';
        midToLongCurrency.RecordTypeId = SalesConst.RECTYPE_MID_TO_LONG_TERM;
        midToLongCurrency.CNY__c = SalesConst.CNY_RATE;
        midToLongCurrency.EUR__c = SalesConst.EUR_RATE;
        midToLongCurrency.JPY__c = SalesConst.JPY_RATE;
        midToLongCurrency.USD__c = SalesConst.USD_RATE;

        return midToLongCurrency;
    }

    public static List<Currency__c> getMidToLongCurrencyList(){
        midToLongCurrencyList = new List<Currency__c>();
        return midToLongCurrencyList;
    }

    public static Currency__c getCustomerCurrency(){
        customerCurrency = new Currency__c();

        customerCurrency.Name = 'Test Customer Currency';
        customerCurrency.RecordTypeId = SalesConst.RECTYPE_CUSTOMER_CURRENCY;
        customerCurrency.CustomerCurrencyEUR__c = SalesConst.EUR_RATE;
        customerCurrency.CustomerCurrencyCNY__c = SalesConst.CNY_RATE;

        return customerCurrency;
    }

    public static List<Currency__c> getCustomerCurrencyList(){
        customerCurrencyList = new List<Currency__c>();
        return customerCurrencyList;
    }

    public static SalesParts__c getSalesParts(){
        if(opportunity == null) insert getOpportunity();
        if(product == null) insert getProduct();
        if(singleVehicleProject == null) insert getSingleVehicleProject();
        if(businessCurrency == null) insert getBusinessPlanCurrency();

        salesParts = new SalesParts__c();
//        salesParts.PinNumber__c = 'SPPart-001';
        salesParts.Opportunity__c = opportunity.Id;
        salesParts.Product__c = product.Id;
        salesParts.VehicleProject__c = singleVehicleProject.Id;
        salesParts.CurrencyType__c = businessCurrency.Id;
        salesParts.CurrencyIsoCode = opportunity.CurrencyIsoCode;
        salesParts.Usage__c = SalesConst.USAGE;
        salesParts.LifeCycle__c = Decimal.valueOf( opportunity.LifeCycle__c);
        salesParts.StartYear__c = SalesConst.START_YEAR;
        salesParts.EndYear__c = SalesConst.END_YEAR;

        return salesParts;
    }
    public static List<SalesParts__c> getSalesPartsList(){
        salesPartsList = new List<SalesParts__c>();

        if(opportunity == null) insert getOpportunity();
        if(product == null) insert getProduct();
        if(singleVehicleProject == null) insert getSingleVehicleProject();
        if(businessCurrency == null) insert getBusinessPlanCurrency();

        for (Integer i = 0; i < 2; i++) {
            salesParts = new SalesParts__c();

//            if (i != 0) salesParts.PinNumber__c = 'NPN-99999';
            salesParts.Opportunity__c = opportunity.Id;
            salesParts.Product__c = product.Id;
            salesParts.VehicleProject__c = singleVehicleProject.Id;
            salesParts.CurrencyType__c = businessCurrency.Id;
            salesParts.CurrencyIsoCode = opportunity.CurrencyIsoCode;
            salesParts.Usage__c = SalesConst.USAGE;
            salesParts.LifeCycle__c = Decimal.valueOf( opportunity.LifeCycle__c);
            salesParts.StartYear__c = SalesConst.START_YEAR;
            salesParts.EndYear__c = SalesConst.END_YEAR;

            salesPartsList.add(salesParts);
        }

        return salesPartsList;
    }

    public static SalesPartsVolume__c getSalesPartsVolume(){
        if(salesParts == null) insert getSalesParts();
        if(businessCurrency == null) insert getBusinessPlanCurrency();

        salesPartsVolume = new SalesPartsVolume__c();

        salesPartsVolume.SalesParts__c = salesParts.Id;
        salesPartsVolume.CurrencyIsoCode = salesParts.CurrencyIsoCode;
        salesPartsVolume.Usage__c = salesParts.Usage__c;
        salesPartsVolume.CurrencyType__c = businessCurrency.Id;
        salesPartsVolume.IsStartYear__c = true;
        salesPartsVolume.RelevantYear__c = SalesConst.START_YEAR;
        salesPartsVolume.VehicleVolume__c = 10000;
        salesPartsVolume.OptionRate__c = 100;
        salesPartsVolume.Cost__c = 37.08;
        salesPartsVolume.CRRate__c = 0;
        salesPartsVolume.LastYearCost__c = 0.0;

        return salesPartsVolume;
    }

    public static List<SalesPartsVolume__c> getSalesPartsVolumeList(){
        salesPartsVolumeList = new List<SalesPartsVolume__c>();

        if(salesPartsList == null) insert getSalesPartsList();
        if(businessCurrency == null) insert getBusinessPlanCurrency();

        List<String> currencyList = SalesConst.DEFAULT_CURRENCY_LIST;
        for (Integer i = 0; i < currencyList.size(); i++) {
            salesPartsVolume = new SalesPartsVolume__c();

            salesPartsVolume.SalesParts__c = salesPartsList[0].Id;
            salesPartsVolume.CurrencyIsoCode = currencyList.get(i);
            salesPartsVolume.Usage__c = salesPartsList[0].Usage__c;
            salesPartsVolume.CurrencyType__c = businessCurrency.Id;
            salesPartsVolume.RelevantYear__c = String.valueOf(Integer.valueOf(SalesConst.START_YEAR) + i);
            if(i == 0){
                salesPartsVolume.IsStartYear__c = true;
            }else{
                salesPartsVolume.IsStartYear__c = false;
            }
            salesPartsVolume.VehicleVolume__c = 10000000;
            salesPartsVolume.OptionRate__c = 100;
            salesPartsVolume.Cost__c = 1137.08;
            salesPartsVolume.CRRate__c = 0;
            salesPartsVolume.LastYearCost__c = 0.0;

            salesPartsVolumeList.add(salesPartsVolume);
        }

        return salesPartsVolumeList;
    }

    public static Opportunity getCombineOpportunity(){
        if(account == null) insert getAccount();
        if(bu == null) insert getBU();
        if(product == null) insert getProduct();
        if(combineVehicleProject == null) insert getCombineVehicleProject();
        //====================
        if(accountRegion == null) insert getAccountRegion();
        if(businessCurrency == null) insert getBusinessPlanCurrency();

        combineOpportunity = new Opportunity();

        combineOpportunity.Name = 'Test CombineOpportunity';
        combineOpportunity.AccountId = account.Id;
        combineOpportunity.BU__c = bu.Id;
        combineOpportunity.Product__c = product.Id;
        combineOpportunity.VehicleProject__c = combineVehicleProject.Id; // Single Vehicle Project
        combineOpportunity.CloseDate = Date.today().addYears(1); // Label : Expected RFQ received, Values : Current Date + Add 1 Year

        combineOpportunity.StageName = 'Qualification';

        //====================
        combineOpportunity.SOP__c = Date.today();
        combineOpportunity.AccountRegion__c = accountRegion.Id;
        combineOpportunity.CurrencyType__c = businessCurrency.Id;
        combineOpportunity.LifeCycle__c = SalesConst.LIFE_CYCLE;
        combineOpportunity.CurrencyIsoCode = SalesConst.DEFAULT_CURRENCY;

        return combineOpportunity;
    }

    public static List<SalesParts__c> getCombineSalesPartsList(){
        combineSalesPartsList = new List<SalesParts__c>();

        if(combineOpportunity == null) insert getCombineOpportunity();
        if(product == null) insert getProduct();
        if(combineVehicleProject == null) insert getCombineVehicleProject();
        if(businessCurrency == null) insert getBusinessPlanCurrency();

        for (Integer i = 0; i < 2; i++) {
            salesParts = new SalesParts__c();

//            if (i != 0) salesParts.PinNumber__c = 'NPN-99999';
            salesParts.Opportunity__c = combineOpportunity.Id;
            salesParts.Product__c = product.Id;
            salesParts.VehicleProject__c = combineVehicleProject.Id;
            salesParts.CurrencyType__c = businessCurrency.Id;
            salesParts.CurrencyIsoCode = combineOpportunity.CurrencyIsoCode;
            salesParts.Usage__c = SalesConst.USAGE;
            salesParts.LifeCycle__c = Decimal.valueOf( combineOpportunity.LifeCycle__c);
            salesParts.StartYear__c = SalesConst.START_YEAR;
            salesParts.EndYear__c = SalesConst.END_YEAR;

            combineSalesPartsList.add(salesParts);
        }

        return combineSalesPartsList;
    }

    public static List<SalesPartsVolume__c> getCombineSalesPartsVolumeList(){
        combineSalesPartsVolumeList = new List<SalesPartsVolume__c>();

        if(combineSalesPartsList == null) insert getCombineSalesPartsList();
        if(businessCurrency == null) insert getBusinessPlanCurrency();

        List<String> currencyList = SalesConst.DEFAULT_CURRENCY_LIST;
        for (Integer i = 0; i < currencyList.size(); i++) {
            salesPartsVolume = new SalesPartsVolume__c();

            salesPartsVolume.SalesParts__c = combineSalesPartsList[0].Id;
            salesPartsVolume.CurrencyIsoCode = currencyList.get(i);
            salesPartsVolume.Usage__c = combineSalesPartsList[0].Usage__c;
            salesPartsVolume.CurrencyType__c = businessCurrency.Id;
            salesPartsVolume.RelevantYear__c = String.valueOf(Integer.valueOf(SalesConst.START_YEAR) + i);
            if(i == 0){
                salesPartsVolume.IsStartYear__c = true;
            }else{
                salesPartsVolume.IsStartYear__c = false;
            }
            salesPartsVolume.VehicleVolume__c = 10000000;
            salesPartsVolume.OptionRate__c = 100;
            salesPartsVolume.Cost__c = 1137.08;
            salesPartsVolume.CRRate__c = 0;
            salesPartsVolume.LastYearCost__c = 0.0;

            combineSalesPartsVolumeList.add(salesPartsVolume);
        }

        return combineSalesPartsVolumeList;
    }


    public static Development__c getDevelopment() {
        if(accountRegion == null) insert getAccountRegion();
        if(singleVehicleProject == null) insert getSingleVehicleProject();
        if(bu == null) insert getBU();
        if(product == null) insert getProduct();
        if(opportunity == null) insert getOpportunity();
        if(businessCurrency == null) insert getBusinessPlanCurrency();

        development = new Development__c();

        development.Name = '[OI] ' + opportunity.Name;
        development.Opportunity__c = opportunity.Id;
        development.BU__c = opportunity.BU__c;
        development.Product__c = opportunity.Product__c;
        development.CurrencyType__c = opportunity.CurrencyType__c;
        development.CurrencyIsoCode = opportunity.CurrencyIsoCode;
        development.DealGrade__c = opportunity.DealGrade__c;
        development.VehicleProject__c = opportunity.VehicleProject__c;
        development.AccountRegion__c = opportunity.AccountRegion__c;
        development.ProductSpecification__c = opportunity.ProductSpecification__c;

        development.SourcingToolingCost__c = 123;
        return development;
    }
    public static List<Development__c> getDevelopmentList() {
        developmentList = new List<Development__c>();

        return developmentList;
    }


    public static DevelopmentParts__c getDevelopmentParts() {
        if(development == null) insert getDevelopment();
        if(businessCurrency == null) insert getBusinessPlanCurrency();

        developmentPart = new DevelopmentParts__c();

        return developmentPart;
    }
    public static List<DevelopmentParts__c> getDevelopmentPartsList() {
        developmentPartsList = new List<DevelopmentParts__c>();
        if(development == null) insert getDevelopment();
        if(businessCurrency == null) insert getBusinessPlanCurrency();


        for (Integer i = 0; i < 2; i++) {
            developmentPart = new DevelopmentParts__c();
            developmentPart.Name = 'NPN-1111' + i;
            developmentPart.Development__c = development.Id;
            developmentPart.CurrencyType__c = businessCurrency.Id;
            developmentPart.CurrencyIsoCode = opportunity.CurrencyIsoCode;
            developmentPart.Usage__c = SalesConst.USAGE;
            developmentPart.StartYear__c = SalesConst.START_YEAR;
            developmentPart.EndYear__c = SalesConst.END_YEAR;

            developmentPart.SourcingPieceCost__c = 100 + i;

            developmentPartsList.add(developmentPart);
        }

        return developmentPartsList;
    }



    public static DevelopmentPartsVolume__c getDevelopmentPartsVolume() {
        if(developmentPart == null) insert getDevelopmentParts();
        if(businessCurrency == null) insert getBusinessPlanCurrency();

        developmentPartsVolume = new DevelopmentPartsVolume__c();
        return developmentPartsVolume;
    }
    public static List<DevelopmentPartsVolume__c> getDevelopmentPartsVolumeList() {
        developmentPartsVolumeList = new List<DevelopmentPartsVolume__c>();
        if(developmentPartsList == null) insert getDevelopmentPartsList();
        if(businessCurrency == null) insert getBusinessPlanCurrency();

        List<String> currencyList = SalesConst.DEFAULT_CURRENCY_LIST;

        for (Integer i = 0; i < currencyList.size(); i++) {
            developmentPartsVolume = new DevelopmentPartsVolume__c();

            developmentPartsVolume.DevelopmentParts__c = developmentPartsList[0].Id;
            developmentPartsVolume.CurrencyIsoCode = currencyList.get(i);
            developmentPartsVolume.Usage__c = developmentPartsList[0].Usage__c;
            developmentPartsVolume.CurrencyType__c = businessCurrency.Id;
            if(i == 0) developmentPartsVolume.IsStartYear__c = true;
            developmentPartsVolume.RelevantYear__c = String.valueOf(Integer.valueOf(SalesConst.START_YEAR) + i);
            developmentPartsVolume.VehicleVolume__c = 10000000;
            developmentPartsVolume.OptionRate__c = 100;
            developmentPartsVolume.Cost__c = 1137.08;
            developmentPartsVolume.CRRate__c = 0;
            developmentPartsVolume.LastYearCost__c = 0.0;

            developmentPartsVolumeList.add(developmentPartsVolume);
        }
        return developmentPartsVolumeList;
    }

    public static EngineeringChangeRequest__c getEngineeringChangeRequest(){
        if(accountRegion == null) insert getAccountRegion();
        if(singleVehicleProject == null) insert getSingleVehicleProject();
        if(bu == null) insert getBU();
        if(product == null) insert getProduct();
        if(opportunity == null) insert getOpportunity();
        if(businessCurrency == null) insert getBusinessPlanCurrency();
        if(development == null) insert  getDevelopment();
        if(developmentPartsList == null) insert getDevelopmentPartsList();

        ecr = new EngineeringChangeRequest__c();
        return ecr;
    }

    public static List<EngineeringChangeRequest__c> getEcrList(){
        ecrList = new List<EngineeringChangeRequest__c>();
        if(accountRegion == null) insert getAccountRegion();
        if(singleVehicleProject == null) insert getSingleVehicleProject();
        if(bu == null) insert getBU();
        if(product == null) insert getProduct();
        if(opportunity == null) insert getOpportunity();
        if(businessCurrency == null) insert getBusinessPlanCurrency();
        if(development == null) insert  getDevelopment();
        if(developmentPartsList == null) insert getDevelopmentPartsList();

        for (Integer i = 0; i < 2; i++) {
            ecr = new EngineeringChangeRequest__c();
            ecr.Development__c = development.Id;
            ecr.Description__c = 'test ecr 00'+ i;
            ecr.CurrencyIsoCode = development.CurrencyIsoCode;
            ecr.PN1__c = developmentPartsList[0].Id;
            ecr.PN2__c = developmentPartsList[1].Id;
            ecr.SourcingPiecePrice1__c = 111;
            ecr.SourcingPiecePrice2__c = 222;
            ecrList.add(ecr);
        }
        return ecrList;
    }

    public static List<EngineeringChangeProposal__c> getEcpList(){
        ecpList = new List<EngineeringChangeProposal__c>();
        if(accountRegion == null) insert getAccountRegion();
        if(singleVehicleProject == null) insert getSingleVehicleProject();
        if(bu == null) insert getBU();
        if(product == null) insert getProduct();
        if(opportunity == null) insert getOpportunity();
        if(businessCurrency == null) insert getBusinessPlanCurrency();
        if(development == null) insert  getDevelopment();
        if(developmentPartsList == null) insert getDevelopmentPartsList();
        if(ecrList == null) insert getEcrList();

        for (EngineeringChangeRequest__c ecr : ecrList) {
            for (Integer i = 0; i < 2; i++) {
                ecp = new EngineeringChangeProposal__c();

                ecp.EngineeringChangeRequest__c = ecr.Id;
                ecp.Development__c = ecr.Development__c;
                ecp.Description__c = 'ecp Test 00' + i + ecr.Id;
                ecp.PN1__c = developmentPartsList[0].Id;
                ecp.CurrPiecePrice1__c = 111;
                ecp.SourcingPN1__c = 'ecpDpName1';
                ecp.Description1__c = 'ecp des test 1';
                ecp.PN2__c = developmentPartsList[1].Id;
                ecp.CurrPiecePrice2__c = 222;
                ecp.SourcingPN2__c = 'ecpDpName2';
                ecp.Description2__c = 'ecp des test 2';
                ecpList.add(ecp);
            }
        }
        return ecpList;
    }

    public static List<LumpSumCollectionManagement__c> getLscList(){
        lscList = new List<LumpSumCollectionManagement__c>();
        if(accountRegion == null) insert getAccountRegion();
        if(singleVehicleProject == null) insert getSingleVehicleProject();
        if(bu == null) insert getBU();
        if(product == null) insert getProduct();
        if(opportunity == null) insert getOpportunity();
        if(businessCurrency == null) insert getBusinessPlanCurrency();
        if(development == null) insert  getDevelopment();

        List<String> currencyList = SalesConst.DEFAULT_CURRENCY_LIST;
        System.debug(currencyList.size());
        System.debug('currencyList.size()');
        for (Integer i = 0; i < currencyList.size(); i++) {
            lsc =  new LumpSumCollectionManagement__c();

            lsc.Development__c = development.Id;
            lsc.RecordTypeId = SalesConst.RECTYPE_ED_D_MANAGEMENT;
            if(i == 0) lsc.RecordTypeId = SalesConst.RECTYPE_TOOLING_COST_MANAGEMENT;
            lsc.CurrencyIsoCode = currencyList.get(i);
            lsc.CurrencyType__c = development.CurrencyType__c;

            lscList.add(lsc);
        }
        System.debug('lscList.size()');
        System.debug(lscList.size());


        return lscList;
    }

    
    // Planning CSV
    public static List<PlanningPerformance__c> getPlanningCSVList() {
        if(account == null) insert getAccount();
        if(bu == null) insert getBU();


        PlanningCSVList = new List<PlanningPerformance__c>();
        PlanningPerformance__c planningCSVLines = new PlanningPerformance__c();

        planningCSVLines.Index__c = 1;
        planningCSVLines.Account__c = account.Id;
        planningCSVLines.BU__c = bu.Id;
        planningCSVLines.LargeGroup__c = 'Chassis & Safety';
        planningCSVLines.OIManagingregion__c = 'CN';
        planningCSVLines.WeightedLTR__c = 50;
        planningCSVLines.Date__c = Date.valueOf('2023-04-01');

        planningCSVList.add(planningCSVLines);


        planningCSVLines = new PlanningPerformance__c();

        planningCSVLines.Index__c = 2;
        planningCSVLines.Account__c = account.Id;
        planningCSVLines.BU__c = bu.Id;
        planningCSVLines.LargeGroup__c = 'Chassis & Safety';
        planningCSVLines.OIManagingregion__c = 'CN';
        planningCSVLines.WeightedLTR__c = 60;
        planningCSVLines.Date__c = Date.valueOf('2023-05-01');

        planningCSVList.add(planningCSVLines);


        System.debug('planningCSVList.size() > ' + planningCSVList.size()); // 2

        return planningCSVList;
    }

    // Planning
    public static List<PlanningPerformance__c> getPlanningList() {

        if(planningList == null) insert getPlanningCSVList();
        
        planningList = new List<PlanningPerformance__c>();
        PlanningPerformance__c planning;

        for(PlanningPerformance__c planningCSV : planningCSVList) {
            planning = new PlanningPerformance__c();
            
            planning.Index__c = planningCSV.Index__c;
            planning.Account__c = planningCSV.Account__c;
            planning.BU__c = planningCSV.BU__c;
            planning.LargeGroup__c = planningCSV.LargeGroup__c;
            planning.OIManagingregion__c = planningCSV.OIManagingregion__c;
            planning.WeightedLTR__c = planningCSV.WeightedLTR__c;
            planning.Date__c = planningCSV.Date__c;
            planning.ExternalKey__c = SalesUtil.getPlanningExternalKey(planning.Date__c.year(), Integer.valueOf(planningCSV.Index__c));
                
            planningList.add(planning);
            }

        System.debug('planningList.size() > ' + planningList.size()); 
        return planningList;
    }
    

}