/***************************************************************************************
 * Project Name : Hyundai Mobis
 * File Name    : PlanningCSVUtil
 * Description  :
 * Copyright    : Copyright © I2max. All Rights Reserved. 2022
 * Author       : Chaewon Kwak
 * Created Date : 2022-11-28
 ****************************************************************************************/

public with sharing class PlanningCSVUtil extends SalesBase {

  private static final String CSV_HEADER_INDEX = 'Index';
  private static final String CSV_HEADER_BU = 'BU';
  private static final String CSV_HEADER_TEAM = 'Team';
  private static final String CSV_HEADER_OI_MANAGING_REGION = 'OIManagingRegion';
  private static final String CSV_HEADER_ACCOUNT = 'Account';
  private static final String CSV_HEADER_EXPECTED_MONTH = 'ExpectedMonth';
  private static final String CSV_HEADER_PLANNING_AMOUNT = 'PlanningAmount';

  @AuraEnabled
  public static ComponentResponse search(
          String objectTypeValue,
          List<Map<String, Object>> inputLineMapList
  ) {
    System.debug('objectTypeValue > ' + objectTypeValue);
    System.debug('inputLineMapList > ' + inputLineMapList);

    ComponentResponse response = new ComponentResponse();

    List<PlanningPerformanceWrapper> csvList = new List<PlanningPerformanceWrapper>();
    List<String> errorList = new List<String>();

    PlanningPerformanceWrapper planningPerformanceWrapper;

    // Params : CSV Input Values
    String index;
    String bu;
    String team;
    String oiManagingRegion; // Account Region -> OI Managing Region
    String account;
    String expectedMonth;
    String planningAmount;

    // Params : Look-Up
    String buId; // BU Name -> BU ID
    String accountId; // Account Name -> Account ID
    String oiManagingRegionName;

    /**
     * @author Kyejin Cheong
     * @description Account Region -> OI Managing Region (Picklist) 변경
     */
    // Account
    Map<String, Id> accIdMap = new Map<String, Id>();
    List<Account> accList = [SELECT Id, Name FROM Account];
    for (Account acc : accList) {
      accIdMap.put(acc.Name, acc.Id);
    }

    // BU
    Map<String, Id> buIdMap = new Map<String, Id>();
    List<BU__c> buList = [SELECT Id, Name FROM BU__c];
    // bu is duplicate -> existedBU
    for (BU__c existingBU : buList) {
      buIdMap.put(existingBU.Name, existingBU.Id);
    }

    // OIManagingRegion
    List<Schema.PicklistEntry> oiManagingRegionList = PlanningPerformance__c.OIManagingregion__c.getDescribe().getPicklistValues();
    Map<string, string> oiManagingRegionMap = new Map<string, string>();
    for (Schema.PicklistEntry picklists : oiManagingRegionList) {
      oiManagingRegionMap.put(picklists.getLabel(), picklists.getValue());
    }

    // Team
    List<Schema.PicklistEntry> teamList = PlanningPerformance__c.LargeGroup__c.getDescribe().getPicklistValues();
    Map<string, string> teamMap = new Map<string, string>();
    for (Schema.PicklistEntry picklists : teamList) {
      teamMap.put(picklists.getLabel(), picklists.getValue());
    }

    // CSV Input Values -> Salesforce Data
    for (Map<String, Object> inputLineMap : inputLineMapList) {
      // Index
      if (Util.isNotEmpty(inputLineMap.get(CSV_HEADER_INDEX))) {
        index = String.valueOf(inputLineMap.get(CSV_HEADER_INDEX));
      }
      System.debug('index > ' + index);
      // BU
      if (Util.isNotEmpty(inputLineMap.get(CSV_HEADER_BU))) {
        bu = String.valueOf(inputLineMap.get(CSV_HEADER_BU));
      }
      System.debug('bu > ' + bu);

      // Team
      if (Util.isNotEmpty(inputLineMap.get(CSV_HEADER_TEAM))) {
        team = String.valueOf(inputLineMap.get(CSV_HEADER_TEAM));
      }
      System.debug('team > ' + team);

      // OI Managing Region
      if (Util.isNotEmpty(inputLineMap.get(CSV_HEADER_OI_MANAGING_REGION))) {
        oiManagingRegion = String.valueOf(
                inputLineMap.get(CSV_HEADER_OI_MANAGING_REGION)
        );
      }
      System.debug('oiManagingRegion > ' + oiManagingRegion);

      // Account
      if (Util.isNotEmpty(inputLineMap.get(CSV_HEADER_ACCOUNT))) {
        account = String.valueOf(inputLineMap.get(CSV_HEADER_ACCOUNT));
      }
      System.debug('account > ' + account);

      // Expected Month
      if (Util.isNotEmpty(inputLineMap.get(CSV_HEADER_EXPECTED_MONTH))) {
        expectedMonth = String.valueOf(
                inputLineMap.get(CSV_HEADER_EXPECTED_MONTH)
        );
      }
      System.debug('expectedMonth > ' + expectedMonth);

      // Planning Amount
      if (Util.isNotEmpty(inputLineMap.get(CSV_HEADER_PLANNING_AMOUNT))) {
        planningAmount = String.valueOf(inputLineMap.get(CSV_HEADER_PLANNING_AMOUNT));
      }
      System.debug('planningAmount > ' + planningAmount);
      System.debug('---------------------------------');

      // Create PlanningPerformance Wrapper
      planningPerformanceWrapper = new planningPerformanceWrapper();

      // Set Wrapper Values
      // Index
      planningPerformanceWrapper.index = Integer.valueOf(index);
      
      // BU
      if (buIdMap.containsKey(bu)) {
        planningPerformanceWrapper.bu = bu;
        planningPerformanceWrapper.buId = buIdMap.get(bu);
      } else {
        planningPerformanceWrapper.errorMessage = '';
        planningPerformanceWrapper.errorMessage += '[BU]';
      }

      // OI Managing Region
      if (oiManagingRegionMap.containsKey(oiManagingRegion)) {
        planningPerformanceWrapper.oiManagingRegion = oiManagingRegionMap.get(oiManagingRegion); // Modal 창에서 가져오는 값..? -> value
      } else {
        planningPerformanceWrapper.errorMessage = '';
        planningPerformanceWrapper.errorMessage += '[OIManagingRegion]';
      }
      // Team
      if (teamMap.containsKey(team)) {
        planningPerformanceWrapper.team = teamMap.get(team); // Modal 창에서 가져오는 값..? -> value
      } else {
        planningPerformanceWrapper.errorMessage = '';
        planningPerformanceWrapper.errorMessage += '[Team]';
      }
      // Account
      if (accIdMap.containsKey(account)) {
        planningPerformanceWrapper.account = account;
        planningPerformanceWrapper.accountId = accIdMap.get(account);
      } 
      // else {
      //   planningPerformanceWrapper.errorMessage = '';
      //   planningPerformanceWrapper.errorMessage += '[Account]';
      // }
      
      // Expected Month
      // input Date : ex) 2023.06
      planningPerformanceWrapper.expectedMonth = Date.valueOf(expectedMonth.replace('.', '-') + '-01');
      // Planning Amount
      planningPerformanceWrapper.planningAmount = Decimal.valueOf(planningAmount);

      csvList.add(planningPerformanceWrapper);
      errorList.add(planningPerformanceWrapper.errorMessage);
    }

    System.debug('errorList > ' + errorList.size());
    System.debug('csvList.size() > ' + csvList.size());

    response.setData('wpList', csvList);
    response.setData('errorList', errorList);

    return response;
  }

  // 버튼을 눌렀을 떄
  @AuraEnabled
  public static ComponentResponse save(Map<String, Object> reqData) {
    ComponentResponse response = new ComponentResponse();

    final String objectTypeValue = (String) reqData.get('objectTypeValue');

    System.debug('objectTypeValue > ' + objectTypeValue);

    Map<Decimal, String> errorMap = new Map<Decimal, String>();

    List<PlanningPerformanceWrapper> csvList = (List<PlanningPerformanceWrapper>) JSON.deserialize(
      (String) reqData.get('csvList'),
      List<PlanningPerformanceWrapper>.class
    );

    if (SalesConst.PLANNING_PERFORMANCE.equalsIgnoreCase(objectTypeValue)) {
      System.debug('Planning Performance');
      setPlanningList(csvList, errorMap, false);
    }

    response.setData('wpList', csvList);
    response.setData('isSuccess', errorMap.isEmpty());

    return response;
  }

  @AuraEnabled
  public static void setPlanningList(List<PlanningPerformanceWrapper> csvList, Map<Decimal, String> errorMap, Boolean allOrNothing) {
    Map<String, PlanningPerformance__c> upsertPlanningMap = new Map<String, PlanningPerformance__c>();
    PlanningPerformance__c planning;

    for (PlanningPerformanceWrapper csvWrapper : csvList) {

      planning = new PlanningPerformance__c();
      planning.RecordTypeId = SalesConst.RECTYPE_PP_PLAN;
      planning.Index__c = csvWrapper.index;
      planning.BU__c = csvWrapper.buId;
      planning.LargeGroup__c = csvWrapper.team;
      planning.OIManagingregion__c = csvWrapper.oiManagingRegion;
      planning.Account__c = csvWrapper.accountId;
      planning.Date__c = csvWrapper.expectedMonth;
      planning.WeightedLTR__c = csvWrapper.planningAmount;
      planning.Name = planning.Date__c.year() + '년 ' + planning.Date__c.month() + '월 계획';

      // TODO: Project & Product 추가해서 조합키 생성하기
      planning.ExternalKey__c = SalesUtil.getPlanningExternalKey(csvWrapper.expectedMonth.year(), csvWrapper.index);

      upsertPlanningMap.put(planning.ExternalKey__c, planning);
    }
    System.debug('upsertPlanningMap.size() > ' + upsertPlanningMap.size());

    if (!upsertPlanningMap.isEmpty()) {
      // upsert upsertPlanningMap.values();
      Savepoint sp = Database.setSavepoint();
      List<Database.UpsertResult> urList = Database.upsert(
        upsertPlanningMap.values(),
        PlanningPerformance__c.ExternalKey__c,
        allOrNothing
      );
      Database.UpsertResult ur;

      for (Integer i = 0; i < urList.size(); i++) {
        ur = urList[i];
        planning = upsertPlanningMap.values()[i];

        if (!ur.isSuccess()) {
          errorMap.put(planning.Index__c, ur.getErrors()[0].getMessage());
        }

        System.debug('errorMap.size() >' + errorMap.size());
      }

      for(PlanningPerformanceWrapper wp : csvList) {
        wp.errorMessage = errorMap.get(wp.index);
        System.debug('wp Error >> ' + wp);
      }
      if (!errorMap.isEmpty()) {
        System.debug('<< RollBack >>');
        Database.rollback(sp);
      }
    }
  }

}