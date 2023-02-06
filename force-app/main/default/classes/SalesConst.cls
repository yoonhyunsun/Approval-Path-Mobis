/***************************************************************************************
  * Project Name : Hyundai Mobis
  * File Name    : SalesConst
  * Description  : 
  * Copyright    : Copyright © I2max. All Rights Reserved. 2022 
  * Author       : KyeJin Cheong
  * Created Date : 2022-11-08
****************************************************************************************/

public class SalesConst {

    //----------------------------------
    // Object RecordType Id
    //----------------------------------
    // Vehicle Project
    public static final String RECTYPE_SINGLE_PROJECT = Schema.SObjectType.VehicleProject__c.getRecordTypeInfosByDeveloperName().get('Single_Project').getRecordTypeId();
    public static final String RECTYPE_PLATFORM_COMBINED_PROJECT = Schema.SObjectType.VehicleProject__c.getRecordTypeInfosByDeveloperName().get('Platform').getRecordTypeId();

    // Planning & Performance
    public static final String RECTYPE_PP_PLAN = Schema.SObjectType.PlanningPerformance__c.getRecordTypeInfosByDeveloperName().get('Planning').getRecordTypeId();

    //----------------------------------
    // SObject API name
    //----------------------------------
    public static final String PLANNING_PERFORMANCE = SObjectType.PlanningPerformance__c.getName();
    public static final String PROFORMA = SObjectType.Proforma__c.getName();
    public static final String PROFORMA_DUMMY = SObjectType.ProformaDummy__c.getName();

    // opportunity
    public static final String LIFE_CYCLE = '5';

    // CurrencyIsoCode
    public static final String DEFAULT_CURRENCY = 'EUR';
    public static final List<String> DEFAULT_CURRENCY_LIST = new List<String>{'USD', 'KRW', 'JPY', 'EUR', 'CNY'};

    // Currency
    public static final String RECTYPE_BUSINESS_PLAN = Schema.SObjectType.Currency__c.getRecordTypeInfosByDeveloperName().get('Business_Plan').getRecordTypeId();
    public static final String RECTYPE_MID_TO_LONG_TERM = Schema.SObjectType.Currency__c.getRecordTypeInfosByDeveloperName().get('Mid_to_long_term').getRecordTypeId();
    public static final String RECTYPE_CUSTOMER_CURRENCY = Schema.SObjectType.Currency__c.getRecordTypeInfosByDeveloperName().get('Customer_Currency').getRecordTypeId();
    public static final Double EUR_RATE = 1356.00;
    public static final Double USD_RATE = 1130.00;
    public static final Double JPY_RATE = 1017.30;
    public static final Double CNY_RATE = 163.19;

    // Sales Parts
    public static final String START_YEAR = '2022';
    public static final String END_YEAR = '2026';
    public static final Integer USAGE = 1;
    public static final List<String> DEFAULT_AMOUNT_LIST = new List<String>{'10000000000', '1000000000', '10000000', '100000', '1'};

    // Lump Sum Collection Management
    public static final String RECTYPE_ED_D_MANAGEMENT	 = Schema.SObjectType.LumpSumCollectionManagement__c.getRecordTypeInfosByDeveloperName().get('ED_D_Management').getRecordTypeId();
    public static final String RECTYPE_TOOLING_COST_MANAGEMENT = Schema.SObjectType.LumpSumCollectionManagement__c.getRecordTypeInfosByDeveloperName().get('Tooling_Cost_Management').getRecordTypeId();

}