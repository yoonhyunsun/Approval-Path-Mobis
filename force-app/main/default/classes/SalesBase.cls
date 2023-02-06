/***************************************************************************************
 * Project Name : Hyundai Mobis
 * File Name    : SalesBase
 * Description  :
 * Copyright    : Copyright © I2max. All Rights Reserved. 2022
 * Author       : KyeJin Cheong
 * Created Date : 2022-11-08
 ****************************************************************************************/

public abstract without sharing class SalesBase {
  /**
   * @description Proforma Wrapper
   */
  public class ProformaWrapper {
    @AuraEnabled
    public Integer index { get; set; } // Index
    @AuraEnabled
    public String projectStatus { get; set; } // Project Status
    @AuraEnabled
    public String oemStatus { get; set; } // OEM Status
    @AuraEnabled
    public Decimal oiTargetYear { get; set; } // OI Target Year
    @AuraEnabled
    public String dealGrade { get; set; } // Deal Grade
    @AuraEnabled
    public String bu { get; set; } // BU
    @AuraEnabled
    public String moduleParts { get; set; } // Module & Parts
    @AuraEnabled
    public String team { get; set; } // Team
    @AuraEnabled
    public String mediumProductGroup { get; set; } // Medium Product Group
    @AuraEnabled
    public String smallProductGroup { get; set; } // Small Product Group
    @AuraEnabled
    public String productDescription { get; set; } // Product Description
    @AuraEnabled
    public String accounts { get; set; } // Accounts
    @AuraEnabled
    public String oiManagingRegion { get; set; } // OI Managing Region
    @AuraEnabled
    public String vehicleProject { get; set; } // Vehicle Project
    @AuraEnabled
    public Decimal sop { get; set; } // SOP
    @AuraEnabled
    public String mobisPlant { get; set; } // Mobis Plant
    @AuraEnabled
    public String salesEntity { get; set; } // Sales Entity
    @AuraEnabled
    public String currencyIsoCode { get; set; } // Currency ISO Code
    @AuraEnabled
    public Decimal usage { get; set; } // Usage

    // Relevant Year
    @AuraEnabled
    public Integer relevantYearY0 { get; set; } // Relevant Year (Y+0)
    @AuraEnabled
    public Integer relevantYearY1 { get; set; } // Relevant Year (Y+1)
    @AuraEnabled
    public Integer relevantYearY2 { get; set; } // Relevant Year (Y+2)
    @AuraEnabled
    public Integer relevantYearY3 { get; set; } // Relevant Year (Y+3)
    @AuraEnabled
    public Integer relevantYearY4 { get; set; } // Relevant Year (Y+4)
    @AuraEnabled
    public Integer relevantYearY5 { get; set; } // Relevant Year (Y+5)
    @AuraEnabled
    public Integer relevantYearY6 { get; set; } // Relevant Year (Y+6)
    @AuraEnabled
    public Integer relevantYearY7 { get; set; } // Relevant Year (Y+7)
    @AuraEnabled
    public Integer relevantYearY8 { get; set; } // Relevant Year (Y+8)
    @AuraEnabled
    public Integer relevantYearY9 { get; set; } // Relevant Year (Y+9)

    // OEM Vehicle Volume
    @AuraEnabled
    public Decimal oemVehicleVolumeY0 { get; set; } // OEM Vehicle Volume (Y+0)
    @AuraEnabled
    public Decimal oemVehicleVolumeY1 { get; set; } // OEM Vehicle Volume (Y+1)
    @AuraEnabled
    public Decimal oemVehicleVolumeY2 { get; set; } // OEM Vehicle Volume (Y+2)
    @AuraEnabled
    public Decimal oemVehicleVolumeY3 { get; set; } // OEM Vehicle Volume (Y+3)
    @AuraEnabled
    public Decimal oemVehicleVolumeY4 { get; set; } // OEM Vehicle Volume (Y+4)
    @AuraEnabled
    public Decimal oemVehicleVolumeY5 { get; set; } // OEM Vehicle Volume (Y+5)
    @AuraEnabled
    public Decimal oemVehicleVolumeY6 { get; set; } // OEM Vehicle Volume (Y+6)
    @AuraEnabled
    public Decimal oemVehicleVolumeY7 { get; set; } // OEM Vehicle Volume (Y+7)
    @AuraEnabled
    public Decimal oemVehicleVolumeY8 { get; set; } // OEM Vehicle Volume (Y+8)
    @AuraEnabled
    public Decimal oemVehicleVolumeY9 { get; set; } // OEM Vehicle Volume (Y+9)

    // Option Rate
    @AuraEnabled
    public Integer optionRateY0 { get; set; } // Option Rate (Y+0)
    @AuraEnabled
    public Integer optionRateY1 { get; set; } // Option Rate (Y+1)
    @AuraEnabled
    public Integer optionRateY2 { get; set; } // Option Rate (Y+2)
    @AuraEnabled
    public Integer optionRateY3 { get; set; } // Option Rate (Y+3)
    @AuraEnabled
    public Integer optionRateY4 { get; set; } // Option Rate (Y+4)
    @AuraEnabled
    public Integer optionRateY5 { get; set; } // Option Rate (Y+5)
    @AuraEnabled
    public Integer optionRateY6 { get; set; } // Option Rate (Y+6)
    @AuraEnabled
    public Integer optionRateY7 { get; set; } // Option Rate (Y+7)
    @AuraEnabled
    public Integer optionRateY8 { get; set; } // Option Rate (Y+8)
    @AuraEnabled
    public Integer optionRateY9 { get; set; } // Option Rate (Y+9)

    // Piece Price
    @AuraEnabled
    public Decimal piecePriceY0 { get; set; } // Piece Price (Y+0)
    @AuraEnabled
    public Decimal piecePriceY1 { get; set; } // Piece Price (Y+1)
    @AuraEnabled
    public Decimal piecePriceY2 { get; set; } // Piece Price (Y+2)
    @AuraEnabled
    public Decimal piecePriceY3 { get; set; } // Piece Price (Y+3)
    @AuraEnabled
    public Decimal piecePriceY4 { get; set; } // Piece Price (Y+4)
    @AuraEnabled
    public Decimal piecePriceY5 { get; set; } // Piece Price (Y+5)
    @AuraEnabled
    public Decimal piecePriceY6 { get; set; } // Piece Price (Y+6)
    @AuraEnabled
    public Decimal piecePriceY7 { get; set; } // Piece Price (Y+7)
    @AuraEnabled
    public Decimal piecePriceY8 { get; set; } // Piece Price (Y+8)
    @AuraEnabled
    public Decimal piecePriceY9 { get; set; } // Piece Price (Y+9)
  }

  /**
    * @description Planning & Performance Wrapper
    */
  public class PlanningPerformanceWrapper {
    @AuraEnabled public Integer index             { get; set; } // Index
    @AuraEnabled public String  bu                { get; set; } // BU (CSV Input Values)
    @AuraEnabled public String  team              { get; set; } // Team
    @AuraEnabled public String  oiManagingRegion  { get; set; } // OI Managing Region (CSV Input Values)
    @AuraEnabled public String  account           { get; set; } // Account (CSV Input Values)
    @AuraEnabled public Date    expectedMonth     { get; set; } // Expected Month
    @AuraEnabled public Decimal planningAmount   { get; set; } // Planning Amount

    @AuraEnabled public String  buId              { get; set; } // BU (Id)
    @AuraEnabled public String  accountId         { get; set; } // Account (Id)

    @AuraEnabled public String  errorMessage      { get; set; }
  }

}