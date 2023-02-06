/***************************************************************************************
  * Project Name : Hyundai Mobis
  * File Name    : ProformaCSVUtil
  * Description  : 
  * Copyright    : Copyright © I2max. All Rights Reserved. 2022 
  * Author       : KyeJin Cheong
  * Created Date : 2022-11-09
****************************************************************************************/

public with sharing class ProformaCSVUtil extends SalesBase {

    // --------------------
    // CSV Header Label
    // --------------------

    // Proforma

    // Proforma Dummy
    private static final String CSV_HEADER_INDEX                = 'Index';
    private static final String CSV_HEADER_OEM_STATUS           = 'OEM Status';
    private static final String CSV_HEADER_PROJECT_STATUS       = 'Project Status';
    private static final String CSV_HEADER_OI_TARGET_YEAR       = 'OI Target Year';
    private static final String CSV_HEADER_DEAL_GRADE           = 'Deal Grade';
    private static final String CSV_HEADER_BU                   = 'BU';
    private static final String CSV_HEADER_MODULE_PARTS         = 'Module Parts'; // Edited By Kyejin Cheong (23.01.13)
    private static final String CSV_HEADER_TEAM                 = 'Team';
    private static final String CSV_HEADER_MEDIUM_PRODUCT_GROUP = 'Medium Product Group';
    private static final String CSV_HEADER_SMALL_PRODUCT_GROUP  = 'Small Product Group';
    private static final String CSV_HEADER_PRODUCT_DESCRIPTION  = 'Product Description';
    private static final String CSV_HEADER_ACCOUNTS             = 'Accounts';
    private static final String CSV_HEADER_OI_MANAGING_REGION   = 'OI Managing Region';
    private static final String CSV_HEADER_VEHICLE_PROJECT      = 'Vehicle Project';
    private static final String CSV_HEADER_SOP                  = 'SOP';
    private static final String CSV_HEADER_MOBIS_PLANT          = 'Mobis Plant';
    private static final String CSV_HEADER_SALES_ENTITY         = 'Sales Entity';
    private static final String CSV_HEADER_CURRENCYISOCODE      = 'Currency';
    private static final String CSV_HEADER_USAGE                = 'Usage';

    // Relevant Year
    private static final String CSV_HEADER_RELEVANT_YEAR_Y0     = 'Relevant Year (Y+0)';
    private static final String CSV_HEADER_RELEVANT_YEAR_Y1     = 'Relevant Year (Y+1)';
    private static final String CSV_HEADER_RELEVANT_YEAR_Y2     = 'Relevant Year (Y+2)';
    private static final String CSV_HEADER_RELEVANT_YEAR_Y3     = 'Relevant Year (Y+3)';
    private static final String CSV_HEADER_RELEVANT_YEAR_Y4     = 'Relevant Year (Y+4)';
    private static final String CSV_HEADER_RELEVANT_YEAR_Y5     = 'Relevant Year (Y+5)';
    private static final String CSV_HEADER_RELEVANT_YEAR_Y6     = 'Relevant Year (Y+6)';
    private static final String CSV_HEADER_RELEVANT_YEAR_Y7     = 'Relevant Year (Y+7)';
    private static final String CSV_HEADER_RELEVANT_YEAR_Y8     = 'Relevant Year (Y+8)';
    private static final String CSV_HEADER_RELEVANT_YEAR_Y9     = 'Relevant Year (Y+9)';

    // OEM Vehicle Volume
    private static final String CSV_HEADER_OEM_VEHICLE_VOLUME_Y0 = 'OEM Vehicle Volume (Y+0)';
    private static final String CSV_HEADER_OEM_VEHICLE_VOLUME_Y1 = 'OEM Vehicle Volume (Y+1)';
    private static final String CSV_HEADER_OEM_VEHICLE_VOLUME_Y2 = 'OEM Vehicle Volume (Y+2)';
    private static final String CSV_HEADER_OEM_VEHICLE_VOLUME_Y3 = 'OEM Vehicle Volume (Y+3)';
    private static final String CSV_HEADER_OEM_VEHICLE_VOLUME_Y4 = 'OEM Vehicle Volume (Y+4)';
    private static final String CSV_HEADER_OEM_VEHICLE_VOLUME_Y5 = 'OEM Vehicle Volume (Y+5)';
    private static final String CSV_HEADER_OEM_VEHICLE_VOLUME_Y6 = 'OEM Vehicle Volume (Y+6)';
    private static final String CSV_HEADER_OEM_VEHICLE_VOLUME_Y7 = 'OEM Vehicle Volume (Y+7)';
    private static final String CSV_HEADER_OEM_VEHICLE_VOLUME_Y8 = 'OEM Vehicle Volume (Y+8)';
    private static final String CSV_HEADER_OEM_VEHICLE_VOLUME_Y9 = 'OEM Vehicle Volume (Y+9)';

    // Piece Price
    private static final String CSV_HEADER_PIECE_PRICE_Y0 = 'Piece Price (Y+0)';
    private static final String CSV_HEADER_PIECE_PRICE_Y1 = 'Piece Price (Y+1)';
    private static final String CSV_HEADER_PIECE_PRICE_Y2 = 'Piece Price (Y+2)';
    private static final String CSV_HEADER_PIECE_PRICE_Y3 = 'Piece Price (Y+3)';
    private static final String CSV_HEADER_PIECE_PRICE_Y4 = 'Piece Price (Y+4)';
    private static final String CSV_HEADER_PIECE_PRICE_Y5 = 'Piece Price (Y+5)';
    private static final String CSV_HEADER_PIECE_PRICE_Y6 = 'Piece Price (Y+6)';
    private static final String CSV_HEADER_PIECE_PRICE_Y7 = 'Piece Price (Y+7)';
    private static final String CSV_HEADER_PIECE_PRICE_Y8 = 'Piece Price (Y+8)';
    private static final String CSV_HEADER_PIECE_PRICE_Y9 = 'Piece Price (Y+9)';

    // Option Rate
    private static final String CSV_HEADER_OPTION_RATE_Y0 = 'Option Rate (Y+0)';
    private static final String CSV_HEADER_OPTION_RATE_Y1 = 'Option Rate (Y+1)';
    private static final String CSV_HEADER_OPTION_RATE_Y2 = 'Option Rate (Y+2)';
    private static final String CSV_HEADER_OPTION_RATE_Y3 = 'Option Rate (Y+3)';
    private static final String CSV_HEADER_OPTION_RATE_Y4 = 'Option Rate (Y+4)';
    private static final String CSV_HEADER_OPTION_RATE_Y5 = 'Option Rate (Y+5)';
    private static final String CSV_HEADER_OPTION_RATE_Y6 = 'Option Rate (Y+6)';
    private static final String CSV_HEADER_OPTION_RATE_Y7 = 'Option Rate (Y+7)';
    private static final String CSV_HEADER_OPTION_RATE_Y8 = 'Option Rate (Y+8)';
    private static final String CSV_HEADER_OPTION_RATE_Y9 = 'Option Rate (Y+9)';

    /**
     * @return CSV 입력 내용을 읽은 후, Modal Screen 으로 전송
     */
    @AuraEnabled
    public static ComponentResponse search(String objectTypeValue, List<Map<String, Object>> inputLineMapList) {

        System.debug('objectTypeValue > ' + objectTypeValue);
        System.debug('inputLineMapList > ' + inputLineMapList);

        ComponentResponse response = new ComponentResponse();

        List<ProformaWrapper> csvList = new List<ProformaWrapper>();
        ProformaWrapper proformaWrapper;

        // Column : Basic Info
        String index;
        String oemStatus;
        String projectStatus;
        String oiTargetYear;
        String dealGrade;
        String bu;
        String moduleParts;
        String team;
        String mediumProductGroup;
        String smallProductGroup;
        String productDescription;
        String accounts;
        String oiManagingRegion;
        String vehicleProject;
        String sop;
        String mobisPlant;
        String salesEntity;
        String currencyIsoCode;
        String usage;

        // Column : Relevant Year
        String relevantYearY0;
        String relevantYearY1;
        String relevantYearY2;
        String relevantYearY3;
        String relevantYearY4;
        String relevantYearY5;
        String relevantYearY6;
        String relevantYearY7;
        String relevantYearY8;
        String relevantYearY9;

        // Column : OEM Vehicle Volume
        String oemVehicleVolumeY0;
        String oemVehicleVolumeY1;
        String oemVehicleVolumeY2;
        String oemVehicleVolumeY3;
        String oemVehicleVolumeY4;
        String oemVehicleVolumeY5;
        String oemVehicleVolumeY6;
        String oemVehicleVolumeY7;
        String oemVehicleVolumeY8;
        String oemVehicleVolumeY9;

        // Column : Option Rate
        String optionRateY0;
        String optionRateY1;
        String optionRateY2;
        String optionRateY3;
        String optionRateY4;
        String optionRateY5;
        String optionRateY6;
        String optionRateY7;
        String optionRateY8;
        String optionRateY9;

        // Column : Piece Price
        String piecePriceY0;
        String piecePriceY1;
        String piecePriceY2;
        String piecePriceY3;
        String piecePriceY4;
        String piecePriceY5;
        String piecePriceY6;
        String piecePriceY7;
        String piecePriceY8;
        String piecePriceY9;

        for(Map<String, Object> inputLineMap : inputLineMapList) {
            // Index
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_INDEX))){
                index = String.valueOf(inputLineMap.get(CSV_HEADER_INDEX));
            }
            System.debug('index > ' + index);
            // OEM Status
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_OEM_STATUS))){
                oemStatus = String.valueOf(inputLineMap.get(CSV_HEADER_OEM_STATUS));
            }
            System.debug('oemStatus > ' + oemStatus);
            // Project Status
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_PROJECT_STATUS))){
                projectStatus = String.valueOf(inputLineMap.get(CSV_HEADER_PROJECT_STATUS));
            }
            System.debug('projectStatus > ' + projectStatus);
            // OI Target Year
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_OI_TARGET_YEAR))){
                oiTargetYear = String.valueOf(inputLineMap.get(CSV_HEADER_OI_TARGET_YEAR));
            }
            // Deal Grade
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_DEAL_GRADE))){
                dealGrade = String.valueOf(inputLineMap.get(CSV_HEADER_DEAL_GRADE));
            }
            System.debug('dealGrade > ' + dealGrade);
            // BU
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_BU))){
                bu = String.valueOf(inputLineMap.get(CSV_HEADER_BU));
            }
            System.debug('bu > ' + bu);
            // Module & Parts
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_MODULE_PARTS))){
                moduleParts = String.valueOf(inputLineMap.get(CSV_HEADER_MODULE_PARTS));
            }
            System.debug('moduleParts > ' + moduleParts);
            // Team
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_TEAM))){
                team = String.valueOf(inputLineMap.get(CSV_HEADER_TEAM));
            }
            System.debug('team > ' + team);
            // Medium Product Group
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_MEDIUM_PRODUCT_GROUP))){
                mediumProductGroup = String.valueOf(inputLineMap.get(CSV_HEADER_MEDIUM_PRODUCT_GROUP));
            }
            System.debug('mediumProductGroup > ' + mediumProductGroup);
            // Small Product Group
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_SMALL_PRODUCT_GROUP))){
                smallProductGroup = String.valueOf(inputLineMap.get(CSV_HEADER_SMALL_PRODUCT_GROUP));
            }
            System.debug('smallProductGroup > ' + smallProductGroup);
            // Product Description
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_PRODUCT_DESCRIPTION))){
                productDescription = String.valueOf(inputLineMap.get(CSV_HEADER_PRODUCT_DESCRIPTION));
            }
            System.debug('productDescription > ' + productDescription);
            // Accounts
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_ACCOUNTS))){
                accounts = String.valueOf(inputLineMap.get(CSV_HEADER_ACCOUNTS));
            }
            System.debug('accounts > ' + accounts);
            // OI Managing Region
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_OI_MANAGING_REGION))){
                oiManagingRegion = String.valueOf(inputLineMap.get(CSV_HEADER_OI_MANAGING_REGION));
            }
            System.debug('oiManagingRegion > ' + oiManagingRegion);
            // Vehicle Project
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_VEHICLE_PROJECT))){
                vehicleProject = String.valueOf(inputLineMap.get(CSV_HEADER_VEHICLE_PROJECT));
            }
            System.debug('vehicleProject > ' + vehicleProject);
            // SOP
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_SOP))){
                sop = String.valueOf(inputLineMap.get(CSV_HEADER_SOP));
            }
            System.debug('sop > ' + sop);
            // Mobis Plant
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_MOBIS_PLANT))){
                mobisPlant = String.valueOf(inputLineMap.get(CSV_HEADER_MOBIS_PLANT));
            }
            System.debug('mobisPlant > ' + mobisPlant);
            // Sales Entity
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_SALES_ENTITY))){
                salesEntity = String.valueOf(inputLineMap.get(CSV_HEADER_SALES_ENTITY));
            }
            System.debug('salesEntity > ' + salesEntity);
            // Currency ISO Code
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_CURRENCYISOCODE))){
                currencyIsoCode = String.valueOf(inputLineMap.get(CSV_HEADER_CURRENCYISOCODE));
            }
            System.debug('currencyIsoCode > ' + currencyIsoCode);
            // Usage
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_USAGE))){
                usage = String.valueOf(inputLineMap.get(CSV_HEADER_USAGE));
            }
            System.debug('usage > ' + usage);

            // Relevant Year (Y+0)
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_RELEVANT_YEAR_Y0))){
                relevantYearY0 = String.valueOf(inputLineMap.get(CSV_HEADER_RELEVANT_YEAR_Y0));
            }
            System.debug('relevantYearY0 > ' + relevantYearY0);
            // Relevant Year (Y+1)
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_RELEVANT_YEAR_Y1))){
                relevantYearY1 = String.valueOf(inputLineMap.get(CSV_HEADER_RELEVANT_YEAR_Y1));
            }
            System.debug('relevantYearY1 > ' + relevantYearY1);
            // Relevant Year (Y+2)
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_RELEVANT_YEAR_Y2))){
                relevantYearY2 = String.valueOf(inputLineMap.get(CSV_HEADER_RELEVANT_YEAR_Y2));
            }
            System.debug('relevantYearY2 > ' + relevantYearY2);
            // Relevant Year (Y+3)
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_RELEVANT_YEAR_Y3))){
                relevantYearY3 = String.valueOf(inputLineMap.get(CSV_HEADER_RELEVANT_YEAR_Y3));
            }
            System.debug('relevantYearY3 > ' + relevantYearY3);
            // Relevant Year (Y+4)
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_RELEVANT_YEAR_Y4))){
                relevantYearY4 = String.valueOf(inputLineMap.get(CSV_HEADER_RELEVANT_YEAR_Y4));
            }
            System.debug('relevantYearY4 > ' + relevantYearY4);
            // Relevant Year (Y+5)
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_RELEVANT_YEAR_Y5))){
                relevantYearY5 = String.valueOf(inputLineMap.get(CSV_HEADER_RELEVANT_YEAR_Y5));
            }
            System.debug('relevantYearY5 > ' + relevantYearY5);
            // Relevant Year (Y+6)
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_RELEVANT_YEAR_Y6))){
                relevantYearY6 = String.valueOf(inputLineMap.get(CSV_HEADER_RELEVANT_YEAR_Y6));
            }
            System.debug('relevantYearY6 > ' + relevantYearY6);
            // Relevant Year (Y+7)
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_RELEVANT_YEAR_Y7))){
                relevantYearY7 = String.valueOf(inputLineMap.get(CSV_HEADER_RELEVANT_YEAR_Y7));
            }
            System.debug('relevantYearY7 > ' + relevantYearY7);
            // Relevant Year (Y+8)
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_RELEVANT_YEAR_Y8))){
                relevantYearY8 = String.valueOf(inputLineMap.get(CSV_HEADER_RELEVANT_YEAR_Y8));
            }
            System.debug('relevantYearY8 > ' + relevantYearY8);
            // Relevant Year (Y+9)
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_RELEVANT_YEAR_Y9))){
                relevantYearY9 = String.valueOf(inputLineMap.get(CSV_HEADER_RELEVANT_YEAR_Y9));
            }
            System.debug('relevantYearY9 > ' + relevantYearY9);

            // OEM Vehicle Volume (Y+0)
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_OEM_VEHICLE_VOLUME_Y0))){
                oemVehicleVolumeY0 = String.valueOf(inputLineMap.get(CSV_HEADER_OEM_VEHICLE_VOLUME_Y0));
            }
            System.debug('oemVehicleVolumeY0 > ' + oemVehicleVolumeY0);
            // OEM Vehicle Volume (Y+1)
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_OEM_VEHICLE_VOLUME_Y1))){
                oemVehicleVolumeY1 = String.valueOf(inputLineMap.get(CSV_HEADER_OEM_VEHICLE_VOLUME_Y1));
            }
            System.debug('oemVehicleVolumeY1 > ' + oemVehicleVolumeY1);
            // OEM Vehicle Volume (Y+2)
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_OEM_VEHICLE_VOLUME_Y2))){
                oemVehicleVolumeY2 = String.valueOf(inputLineMap.get(CSV_HEADER_OEM_VEHICLE_VOLUME_Y2));
            }
            System.debug('oemVehicleVolumeY2 > ' + oemVehicleVolumeY2);
            // OEM Vehicle Volume (Y+3)
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_OEM_VEHICLE_VOLUME_Y3))){
                oemVehicleVolumeY3 = String.valueOf(inputLineMap.get(CSV_HEADER_OEM_VEHICLE_VOLUME_Y3));
            }
            System.debug('oemVehicleVolumeY3 > ' + oemVehicleVolumeY3);
            // OEM Vehicle Volume (Y+4)
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_OEM_VEHICLE_VOLUME_Y4))){
                oemVehicleVolumeY4 = String.valueOf(inputLineMap.get(CSV_HEADER_OEM_VEHICLE_VOLUME_Y4));
            }
            System.debug('oemVehicleVolumeY4 > ' + oemVehicleVolumeY4);
            // OEM Vehicle Volume (Y+5)
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_OEM_VEHICLE_VOLUME_Y5))){
                oemVehicleVolumeY5 = String.valueOf(inputLineMap.get(CSV_HEADER_OEM_VEHICLE_VOLUME_Y5));
            }
            System.debug('oemVehicleVolumeY5 > ' + oemVehicleVolumeY5);
            // OEM Vehicle Volume (Y+6)
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_OEM_VEHICLE_VOLUME_Y6))){
                oemVehicleVolumeY6 = String.valueOf(inputLineMap.get(CSV_HEADER_OEM_VEHICLE_VOLUME_Y6));
            }
            System.debug('oemVehicleVolumeY6 > ' + oemVehicleVolumeY6);
            // OEM Vehicle Volume (Y+7)
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_OEM_VEHICLE_VOLUME_Y7))){
                oemVehicleVolumeY7 = String.valueOf(inputLineMap.get(CSV_HEADER_OEM_VEHICLE_VOLUME_Y7));
            }
            System.debug('oemVehicleVolumeY7 > ' + oemVehicleVolumeY7);
            // OEM Vehicle Volume (Y+8)
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_OEM_VEHICLE_VOLUME_Y8))){
                oemVehicleVolumeY8 = String.valueOf(inputLineMap.get(CSV_HEADER_OEM_VEHICLE_VOLUME_Y8));
            }
            System.debug('oemVehicleVolumeY8 > ' + oemVehicleVolumeY8);
            // OEM Vehicle Volume (Y+9)
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_OEM_VEHICLE_VOLUME_Y9))){
                oemVehicleVolumeY9 = String.valueOf(inputLineMap.get(CSV_HEADER_OEM_VEHICLE_VOLUME_Y9));
            }
            System.debug('oemVehicleVolumeY9 > ' + oemVehicleVolumeY9);

            // Option Rate (Y+0)
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_OPTION_RATE_Y0))){
                optionRateY0 = String.valueOf(inputLineMap.get(CSV_HEADER_OPTION_RATE_Y0));
            }
            System.debug('optaionRateY0 > ' + optionRateY0);
            // Option Rate (Y+1)
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_OPTION_RATE_Y1))){
                optionRateY1 = String.valueOf(inputLineMap.get(CSV_HEADER_OPTION_RATE_Y1));
            }
            System.debug('optaionRateY1 > ' + optionRateY1);
            // Option Rate (Y+2)
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_OPTION_RATE_Y2))){
                optionRateY2 = String.valueOf(inputLineMap.get(CSV_HEADER_OPTION_RATE_Y2));
            }
            System.debug('optaionRateY2 > ' + optionRateY2);
            // Option Rate (Y+3)
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_OPTION_RATE_Y3))){
                optionRateY3 = String.valueOf(inputLineMap.get(CSV_HEADER_OPTION_RATE_Y3));
            }
            System.debug('optaionRateY3 > ' + optionRateY3);
            // Option Rate (Y+4)
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_OPTION_RATE_Y4))){
                optionRateY4 = String.valueOf(inputLineMap.get(CSV_HEADER_OPTION_RATE_Y4));
            }
            System.debug('optaionRateY4 > ' + optionRateY4);
            // Option Rate (Y+5)
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_OPTION_RATE_Y5))){
                optionRateY5 = String.valueOf(inputLineMap.get(CSV_HEADER_OPTION_RATE_Y5));
            }
            System.debug('optaionRateY5 > ' + optionRateY5);
            // Option Rate (Y+6)
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_OPTION_RATE_Y6))){
                optionRateY6 = String.valueOf(inputLineMap.get(CSV_HEADER_OPTION_RATE_Y6));
            }
            System.debug('optionRateY6 > ' + optionRateY6);
            // Option Rate (Y+7)
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_OPTION_RATE_Y7))){
                optionRateY7 = String.valueOf(inputLineMap.get(CSV_HEADER_OPTION_RATE_Y7));
            }
            System.debug('optionRateY7 > ' + optionRateY7);
            // Option Rate (Y+8)
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_OPTION_RATE_Y8))){
                optionRateY8 = String.valueOf(inputLineMap.get(CSV_HEADER_OPTION_RATE_Y8));
            }
            System.debug('optionRateY8 > ' + optionRateY8);
            // Option Rate (Y+9)
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_OPTION_RATE_Y9))){
                optionRateY9 = String.valueOf(inputLineMap.get(CSV_HEADER_OPTION_RATE_Y9));
            }
            System.debug('optionRateY9 > ' + optionRateY9);

            // Piece Price (Y+0)
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_PIECE_PRICE_Y0))){
                piecePriceY0 = String.valueOf(inputLineMap.get(CSV_HEADER_PIECE_PRICE_Y0));
            }
            System.debug('piecePriceY0 > ' + piecePriceY0);
            // Piece Price (Y+1)
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_PIECE_PRICE_Y1))){
                piecePriceY1 = String.valueOf(inputLineMap.get(CSV_HEADER_PIECE_PRICE_Y1));
            }
            System.debug('piecePriceY1 > ' + piecePriceY1);
            // Piece Price (Y+2)
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_PIECE_PRICE_Y2))){
                piecePriceY2 = String.valueOf(inputLineMap.get(CSV_HEADER_PIECE_PRICE_Y2));
            }
            System.debug('piecePriceY2 > ' + piecePriceY2);
            // Piece Price (Y+3)
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_PIECE_PRICE_Y3))){
                piecePriceY3 = String.valueOf(inputLineMap.get(CSV_HEADER_PIECE_PRICE_Y3));
            }
            System.debug('piecePriceY3 > ' + piecePriceY3);
            // Piece Price (Y+4)
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_PIECE_PRICE_Y4))){
                piecePriceY4 = String.valueOf(inputLineMap.get(CSV_HEADER_PIECE_PRICE_Y4));
            }
            System.debug('piecePriceY4 > ' + piecePriceY4);
            // Piece Price (Y+5)
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_PIECE_PRICE_Y5))){
                piecePriceY5 = String.valueOf(inputLineMap.get(CSV_HEADER_PIECE_PRICE_Y5));
            }
            System.debug('piecePriceY5 > ' + piecePriceY5);
            // Piece Price (Y+6)
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_PIECE_PRICE_Y6))){
                piecePriceY6 = String.valueOf(inputLineMap.get(CSV_HEADER_PIECE_PRICE_Y6));
            }
            System.debug('piecePriceY6 > ' + piecePriceY6);
            // Piece Price (Y+7)
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_PIECE_PRICE_Y7))){
                piecePriceY7 = String.valueOf(inputLineMap.get(CSV_HEADER_PIECE_PRICE_Y7));
            }
            System.debug('piecePriceY7 > ' + piecePriceY7);
            // Piece Price (Y+8)
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_PIECE_PRICE_Y8))){
                piecePriceY8 = String.valueOf(inputLineMap.get(CSV_HEADER_PIECE_PRICE_Y8));
            }
            System.debug('piecePriceY8 > ' + piecePriceY8);
            // Piece Price (Y+4)
            if(Util.isNotEmpty(inputLineMap.get(CSV_HEADER_PIECE_PRICE_Y9))){
                piecePriceY9 = String.valueOf(inputLineMap.get(CSV_HEADER_PIECE_PRICE_Y9));
            }
            System.debug('piecePriceY9 > ' + piecePriceY9);
            System.debug('---------------------------------');

            // Proforma Volume Wrapper
            proformaWrapper = new ProformaWrapper();

            proformaWrapper.index = Integer.valueOf(index);
            proformaWrapper.oemStatus = oemStatus;
            proformaWrapper.projectStatus = projectStatus;
            proformaWrapper.oiTargetYear = Decimal.valueOf(oiTargetYear);
            proformaWrapper.dealGrade = dealGrade;
            proformaWrapper.bu = bu;
            proformaWrapper.moduleParts = moduleParts;
            proformaWrapper.team = team;
            proformaWrapper.mediumProductGroup = mediumProductGroup;
            proformaWrapper.smallProductGroup = smallProductGroup;
            proformaWrapper.productDescription = productDescription;
            proformaWrapper.accounts = accounts;
            proformaWrapper.oiManagingRegion = oiManagingRegion;
            proformaWrapper.vehicleProject = vehicleProject;
            proformaWrapper.sop = Decimal.valueOf(sop);
            proformaWrapper.mobisPlant = mobisPlant;
            proformaWrapper.salesEntity = salesEntity;
            proformaWrapper.currencyIsoCode = currencyIsoCode;
            proformaWrapper.usage = Decimal.valueOf(usage);

            // Relevant Year
            proformaWrapper.relevantYearY0 = Integer.valueOf(relevantYearY0);
            proformaWrapper.relevantYearY1 = Integer.valueOf(relevantYearY1);
            proformaWrapper.relevantYearY2 = Integer.valueOf(relevantYearY2);
            proformaWrapper.relevantYearY3 = Integer.valueOf(relevantYearY3);
            proformaWrapper.relevantYearY4 = Integer.valueOf(relevantYearY4);
            proformaWrapper.relevantYearY5 = Integer.valueOf(relevantYearY5);
            proformaWrapper.relevantYearY6 = Integer.valueOf(relevantYearY6);
            proformaWrapper.relevantYearY7 = Integer.valueOf(relevantYearY7);
            proformaWrapper.relevantYearY8 = Integer.valueOf(relevantYearY8);
            proformaWrapper.relevantYearY9 = Integer.valueOf(relevantYearY9);

            // OEM Vehicle Volume
            proformaWrapper.oemVehicleVolumeY0 = Decimal.valueOf(oemVehicleVolumeY0);
            proformaWrapper.oemVehicleVolumeY1 = Decimal.valueOf(oemVehicleVolumeY1);
            proformaWrapper.oemVehicleVolumeY2 = Decimal.valueOf(oemVehicleVolumeY2);
            proformaWrapper.oemVehicleVolumeY3 = Decimal.valueOf(oemVehicleVolumeY3);
            proformaWrapper.oemVehicleVolumeY4 = Decimal.valueOf(oemVehicleVolumeY4);
            proformaWrapper.oemVehicleVolumeY5 = Decimal.valueOf(oemVehicleVolumeY5);
            proformaWrapper.oemVehicleVolumeY6 = Decimal.valueOf(oemVehicleVolumeY6);
            proformaWrapper.oemVehicleVolumeY7 = Decimal.valueOf(oemVehicleVolumeY7);
            proformaWrapper.oemVehicleVolumeY8 = Decimal.valueOf(oemVehicleVolumeY8);
            proformaWrapper.oemVehicleVolumeY9 = Decimal.valueOf(oemVehicleVolumeY9);

            // Option Rate
            proformaWrapper.optionRateY0 = Integer.valueOf(optionRateY0);
            proformaWrapper.optionRateY1 = Integer.valueOf(optionRateY1);
            proformaWrapper.optionRateY2 = Integer.valueOf(optionRateY2);
            proformaWrapper.optionRateY3 = Integer.valueOf(optionRateY3);
            proformaWrapper.optionRateY4 = Integer.valueOf(optionRateY4);
            proformaWrapper.optionRateY5 = Integer.valueOf(optionRateY5);
            proformaWrapper.optionRateY6 = Integer.valueOf(optionRateY6);
            proformaWrapper.optionRateY7 = Integer.valueOf(optionRateY7);
            proformaWrapper.optionRateY8 = Integer.valueOf(optionRateY8);
            proformaWrapper.optionRateY9 = Integer.valueOf(optionRateY9);

            // Piece Price
            proformaWrapper.piecePriceY0 = Decimal.valueOf(piecePriceY0);
            proformaWrapper.piecePriceY1 = Decimal.valueOf(piecePriceY1);
            proformaWrapper.piecePriceY2 = Decimal.valueOf(piecePriceY2);
            proformaWrapper.piecePriceY3 = Decimal.valueOf(piecePriceY3);
            proformaWrapper.piecePriceY4 = Decimal.valueOf(piecePriceY4);
            proformaWrapper.piecePriceY5 = Decimal.valueOf(piecePriceY5);
            proformaWrapper.piecePriceY6 = Decimal.valueOf(piecePriceY6);
            proformaWrapper.piecePriceY7 = Decimal.valueOf(piecePriceY7);
            proformaWrapper.piecePriceY8 = Decimal.valueOf(piecePriceY8);
            proformaWrapper.piecePriceY9 = Decimal.valueOf(piecePriceY9);

            csvList.add(proformaWrapper);
        }

        System.debug('csvList.size() > ' + csvList.size());

        response.setData('wpList', csvList);

        return response;
    }

    /**
     * @description 생성 시 allOrNoting 은 TRUE 를 기본으로 하며 오류 행이 있으면 Rollback 한다. Save 완료 시, CSV File 을 자동 생성한다.
     * @return Save Success 여부 및 CSV Wrappers
     */
    @AuraEnabled
    public static ComponentResponse save(Map<String, Object> reqData) {
        ComponentResponse response = new ComponentResponse();

        final String objectTypeValue = (String) reqData.get('objectTypeValue');
        final String csvName = (String) reqData.get('csvName');
        final String changeDescription;
        if(Util.isEmpty((String) reqData.get('changeDescription'))){
            changeDescription = 'No Change Description';
        } else {
            changeDescription = (String) reqData.get('changeDescription');
        }

        System.debug('objectTypeValue > ' + objectTypeValue);
        System.debug('csvName > ' + csvName);
        System.debug('changeDescription > ' + changeDescription);

        // Content Version 생성

        // 에러 여부 확인 Map
        Map<Decimal, String> errorMap = new Map<Decimal, String>();

        List<ProformaWrapper> csvList = (List<ProformaWrapper>) JSON.deserialize((String) reqData.get('csvList'), List<ProformaWrapper>.class);

        if(SalesConst.PROFORMA_DUMMY.equalsIgnoreCase(objectTypeValue)){
            System.debug('Proforma Dummy');
            setProformaList(csvList, errorMap, csvName, changeDescription, false);
        }

        response.setData('wpList', csvList);
        response.setData('isSuccess', errorMap.isEmpty());

        return response;
    }

    /**
     * @param csvList CSV Wrappers
     * @param errorMap Key : Proforma Id, value : Error Msg
     * @param allOrNothing All or Nothing
     * @description CSV 입력된 내용대로 Proforma 를 생성하고 오류 시 관련 에러 메세지를 매핑한다.
     */
    @AuraEnabled
    public static void setProformaList(List<ProformaWrapper> csvList, Map<Decimal, String> errorMap, String csvName, String changeDescription, Boolean allOrNothing) {

        System.debug('csvList > ' + csvList);
        System.debug('errorMap > ' + errorMap);
        System.debug('csvName > ' + csvName);
        System.debug('changeDescription > ' + changeDescription);
        System.debug('allOrNothing > ' + allOrNothing);

        // Key : Index, Values : Proforma Dummy
        Map<String, ProformaDummy__c> upsertProformaMap = new Map<String, ProformaDummy__c>();
        ProformaDummy__c proforma;

        Date d = Date.today();
        String year = String.valueOf(d.year());
        System.debug('year > ' + year);

        List<Currency__c> currencies = [SELECT Id FROM Currency__c WHERE Year__c = :year];

        System.debug('currencies > ' + currencies);
        System.debug('csvList.size() > ' + csvList.size());

        for(ProformaWrapper csvWrapper : csvList) {
            // -----------------------------
            // Proforma Wrapper -> Proforma
            // -----------------------------

            System.debug('csvWrapper.index > ' + csvWrapper.index);
            System.debug('csvWrapper.projectStatus > ' + csvWrapper.projectStatus);

            proforma = new ProformaDummy__c();

            proforma.CurrencyType__c = currencies[0].Id;

            proforma.Index__c               = csvWrapper.index;
            proforma.OEMStatus__c           = csvWrapper.oemStatus;
            proforma.ProjectStatus__c       = csvWrapper.projectStatus;
            proforma.OITargetYear__c        = csvWrapper.oiTargetYear;
            proforma.DealGrade__c           = csvWrapper.dealGrade;
            proforma.BU__c                  = csvWrapper.bu;
            proforma.ModuleParts__c         = csvWrapper.moduleParts;
            proforma.Team__c                = csvWrapper.team;
            proforma.MediumProductGroup__c  = csvWrapper.mediumProductGroup;
            proforma.SmallProductGroup__c   = csvWrapper.smallProductGroup;
            proforma.ProductDescription__c  = csvWrapper.productDescription;
            proforma.Account__c             = csvWrapper.accounts;
            proforma.OIManagingRegion__c    = csvWrapper.oiManagingRegion;
            proforma.VehicleProject__c      = csvWrapper.vehicleProject;
            proforma.SOP__c                 = csvWrapper.sop;
            proforma.MobisPlant__c          = csvWrapper.mobisPlant;
            proforma.SalesEntity__c         = csvWrapper.salesEntity;
            proforma.CurrencyIsoCode        = csvWrapper.CurrencyIsoCode;
            proforma.Usage__c               = csvWrapper.usage;

            // Relevant Year
            proforma.RelevantYearY0__c      = csvWrapper.relevantYearY0;
            proforma.RelevantYearY1__c      = csvWrapper.relevantYearY1;
            proforma.RelevantYearY2__c      = csvWrapper.relevantYearY2;
            proforma.RelevantYearY3__c      = csvWrapper.relevantYearY3;
            proforma.RelevantYearY4__c      = csvWrapper.relevantYearY4;
            proforma.RelevantYearY5__c      = csvWrapper.relevantYearY5;
            proforma.RelevantYearY6__c      = csvWrapper.relevantYearY6;
            proforma.RelevantYearY7__c      = csvWrapper.relevantYearY7;
            proforma.RelevantYearY8__c      = csvWrapper.relevantYearY8;
            proforma.RelevantYearY9__c      = csvWrapper.relevantYearY9;

            // OEM Vehicle Volume
            proforma.OEMVehicleVolumeY0__c  = csvWrapper.oemVehicleVolumeY0;
            proforma.OEMVehicleVolumeY1__c  = csvWrapper.oemVehicleVolumeY1;
            proforma.OEMVehicleVolumeY2__c  = csvWrapper.oemVehicleVolumeY2;
            proforma.OEMVehicleVolumeY3__c  = csvWrapper.oemVehicleVolumeY3;
            proforma.OEMVehicleVolumeY4__c  = csvWrapper.oemVehicleVolumeY4;
            proforma.OEMVehicleVolumeY5__c  = csvWrapper.oemVehicleVolumeY5;
            proforma.OEMVehicleVolumeY6__c  = csvWrapper.oemVehicleVolumeY6;
            proforma.OEMVehicleVolumeY7__c  = csvWrapper.oemVehicleVolumeY7;
            proforma.OEMVehicleVolumeY8__c  = csvWrapper.oemVehicleVolumeY8;
            proforma.OEMVehicleVolumeY9__c  = csvWrapper.oemVehicleVolumeY9;

            // Piece Price
            proforma.PiecePriceY0__c        = csvWrapper.piecePriceY0;
            proforma.PiecePriceY1__c        = csvWrapper.piecePriceY1;
            proforma.PiecePriceY2__c        = csvWrapper.piecePriceY2;
            proforma.PiecePriceY3__c        = csvWrapper.piecePriceY3;
            proforma.PiecePriceY4__c        = csvWrapper.piecePriceY4;
            proforma.PiecePriceY5__c        = csvWrapper.piecePriceY5;
            proforma.PiecePriceY6__c        = csvWrapper.piecePriceY6;
            proforma.PiecePriceY7__c        = csvWrapper.piecePriceY7;
            proforma.PiecePriceY8__c        = csvWrapper.piecePriceY8;
            proforma.PiecePriceY9__c        = csvWrapper.piecePriceY9;

            // Option Rate
            proforma.OptionRateY0__c        = csvWrapper.optionRateY0;
            proforma.OptionRateY1__c        = csvWrapper.optionRateY1;
            proforma.OptionRateY2__c        = csvWrapper.optionRateY2;
            proforma.OptionRateY3__c        = csvWrapper.optionRateY3;
            proforma.OptionRateY4__c        = csvWrapper.optionRateY4;
            proforma.OptionRateY5__c        = csvWrapper.optionRateY5;
            proforma.OptionRateY6__c        = csvWrapper.optionRateY6;
            proforma.OptionRateY7__c        = csvWrapper.optionRateY7;
            proforma.OptionRateY8__c        = csvWrapper.optionRateY8;
            proforma.OptionRateY9__c        = csvWrapper.optionRateY9;

            // External Key : Proforma.Index + Proforma.VehicleProject + proforma.MediumProductGroup__c + proforma.SmallProductGroup__c
            proforma.ExternalID__c = SalesUtil.getProformaCSVExternalKey(proforma.Index__c, proforma.VehicleProject__c, proforma.MediumProductGroup__c, proforma.SmallProductGroup__c);
            upsertProformaMap.put(proforma.ExternalID__c, proforma);
        }
        System.debug('upsertProformaMap.size() > ' + upsertProformaMap.size());

        if(!upsertProformaMap.isEmpty()){
            upsert upsertProformaMap.values();

            // TODO: 실패 있으면 Rollback -> CPU Limit
            /*Savepoint sp = Database.setSavepoint();
            List<Database.UpsertResult> urList = Database.upsert(upsertProformaMap.values(), ProformaDummy__c.ExternalID__c, allOrNothing);
            Database.UpsertResult ur;*/

            ProformaConvertBatch batch = new ProformaConvertBatch();
            batch.upsertProformaMap = upsertProformaMap;
            System.debug('batch.upsertProformaMap.size() > ' + batch.upsertProformaMap.size());
            System.debug('batch' + batch);

            Database.executeBatch(batch, 1000);
        }

        Boolean isAllValid = errorMap.isEmpty();
        System.debug('isAllValid ? ' + isAllValid);

        if(isAllValid){
            System.debug('Export Batch Start!');

            ProformaExportBatch batch = new ProformaExportBatch();
            batch.csvName = csvName;
            batch.changeDescription = changeDescription;
            batch.ownerId = UserInfo.getUserId();

            System.debug('batch.csvName > ' + batch.csvName);
            System.debug('batch.ownerId > ' + batch.ownerId);

            Database.executeBatch(batch, 2000);
        }

    }



}