/**
 * Created by hyodongmin on 2022/10/31.
 */

public with sharing class OpportunityPlan_tr extends TriggerHandler {
  @TestVisible
  protected override void afterUpdate() {
    persistPlanningPerformanceIf(
      (List<Opportunity>) Trigger.old,
      (List<Opportunity>) Trigger.new
    );
  }

  /**
   * Opportunity 상태가 'Closed Won' 인 것을 선택한다. 이를 이용하여 PlanningPerformance 추가한다.
   *
   * @param aOldList List<Opportunity>
   * @param aNewList List<Opportunity>
   */
  @TestVisible
  private static void persistPlanningPerformanceIf(
    List<Opportunity> aOldList,
    List<Opportunity> aNewList
  ) {
    if (null == aOldList || null == aNewList) {
      return;
    }

    List<Opportunity> kWonList = chooseOpportunities(
      'Closed Won',
      aOldList,
      aNewList
    );

    if (kWonList.isEmpty()) {
      return; // 처리 할 것이 없음
    }

    // PlanningPerformance
    insert createPlans(kWonList, Date.today());

    // Development
    Map<Id, Development__c> kOppty2DevMap = createOpptyDevelopments(kWonList);
    insert kOppty2DevMap.values(); // dev

    List<Opportunity> kWonWithSalesPartList = [
      SELECT
        Id,
        CloseDate,
        (
          SELECT
            Id,
            PinNumber__c,
            Description__c,
            StartYear__c,
            EndYear__c,
            Usage__c,
            SourcingPieceCost__c,
            AutoNumber__c,
            CurrencyType__c,
            CurrencyIsoCode
          FROM Sales_Parts__r
        )
      FROM Opportunity
      WHERE Id IN :kWonList
    ];

    Map<Id, DevelopmentParts__c> kSales2DevPartMap = createSalesDevParts(
      kWonWithSalesPartList,
      kOppty2DevMap
    );
    insert kSales2DevPartMap.values(); // dev part

    List<SalesParts__c> kSalesPartsList = [
      SELECT
        Id,
        (
          SELECT
            Id,
            Name,
            Cost__c,
            CRRate__c,
            IsStartYear__c,
            LastYearCost__c,
            OptionRate__c,
            RelevantYear__c,
            Usage__c,
            VehicleVolume__c,
            CurrencyType__c,
            CurrencyIsoCode
          FROM Sales_Parts_Volume__r
        )
      FROM SalesParts__c
      WHERE Id IN :kSales2DevPartMap.keySet()
    ];

    List<DevelopmentPartsVolume__c> kDevVolPartList = createDevVolumes(
      kSalesPartsList,
      kSales2DevPartMap
    );
    insert kDevVolPartList; // dev part vol
  }

  @TestVisible
  private static Map<Id, Development__c> createOpptyDevelopments(
    List<Opportunity> aWonApprovedList
  ) {
    Map<Id, Development__c> kOppty2DevMap = new Map<Id, Development__c>();
    for (Opportunity kOpportunity : aWonApprovedList) {
      Development__c kDevelopment = new Development__c();
      kDevelopment.Name = '[OI] ' + kOpportunity.Name;
      kDevelopment.Opportunity__c = kOpportunity.Id;
      kDevelopment.BU__c = kOpportunity.BU__c;
      kDevelopment.Product__c = kOpportunity.Product__c;
      kDevelopment.CurrencyType__c = kOpportunity.CurrencyType__c;
      kDevelopment.CurrencyIsoCode = kOpportunity.CurrencyIsoCode;
      kDevelopment.DealGrade__c = kOpportunity.DealGrade__c;
      kDevelopment.VehicleProject__c = kOpportunity.VehicleProject__c;
      kDevelopment.AccountRegion__c = kOpportunity.AccountRegion__c;
      kDevelopment.ProductSpecification__c = kOpportunity.ProductSpecification__c;
      kDevelopment.SourcingToolingCost__c = kOpportunity.ToolingCost__c;
      kDevelopment.SOP__c = kOpportunity.SOP__c;
      kDevelopment.OIManagingRegion__c = kOpportunity.OIManagingregion__c;
      kDevelopment.ExpectedVehicleTotalVolume__c = kOpportunity.ExpectedVehicleTotalVolume__c;
      kDevelopment.SalesAmount__c = kOpportunity.SalesAmountIncLumpSumSales__c;
      kDevelopment.OwnerId = kOpportunity.OwnerId;
      kOppty2DevMap.put(kOpportunity.Id, kDevelopment);
    }
    return kOppty2DevMap;
  }

  @TestVisible
  private static Map<Id, DevelopmentParts__c> createSalesDevParts(
    List<Opportunity> aWonWithSalesPartList,
    Map<Id, Development__c> aOppty2DevMap
  ) {
    Map<Id, DevelopmentParts__c> kSales2DevPartMap = new Map<Id, DevelopmentParts__c>();
    for (Opportunity kOpportunity : aWonWithSalesPartList) {
      for (SalesParts__c kSalesPart : kOpportunity.Sales_Parts__r) {
        DevelopmentParts__c kDevPart = new DevelopmentParts__c();
        kDevPart.Development__c = aOppty2DevMap.get(kOpportunity.Id).Id;
        kDevPart.Name = kSalesPart.PinNumber__c;
        kDevPart.SourcingPartsNumber__c = kSalesPart.PinNumber__c;
        kDevPart.SourcingDate__c = kOpportunity.CloseDate;
        kDevPart.Description__c = kSalesPart.Description__c;
        kDevPart.StartYear__c = kSalesPart.StartYear__c;
        kDevPart.EndYear__c = kSalesPart.EndYear__c;
        kDevPart.Usage__c = kSalesPart.Usage__c;
        kDevPart.SourcingPiecePrice__c = kSalesPart.SourcingPieceCost__c;
        kDevPart.CurrencyType__c = kSalesPart.CurrencyType__c;
        kDevPart.CurrencyIsoCode = kSalesPart.CurrencyIsoCode;
        kDevPart.AutoNumber__c = kSalesPart.AutoNumber__c;

        kSales2DevPartMap.put(kSalesPart.Id, kDevPart);
      }
    }
    return kSales2DevPartMap;
  }

  @TestVisible
  private static List<DevelopmentPartsVolume__c> createDevVolumes(
    List<SalesParts__c> aSalesPartsList,
    Map<Id, DevelopmentParts__c> aSales2DevPartMap
  ) {
    List<DevelopmentPartsVolume__c> kDevVolPartList = new List<DevelopmentPartsVolume__c>();
    for (SalesParts__c kSalesPart : aSalesPartsList) {
      for (SalesPartsVolume__c kVolume : kSalesPart.Sales_Parts_Volume__r) {
        DevelopmentPartsVolume__c kDevVol = new DevelopmentPartsVolume__c();
        kDevVol.Name = kVolume.Name;
        kDevVol.DevelopmentParts__c = aSales2DevPartMap.get(kSalesPart.Id).Id;
        kDevVol.Cost__c = kVolume.Cost__c;
        kDevVol.CRRate__c = kVolume.CRRate__c;
        kDevVol.IsStartYear__c = kVolume.IsStartYear__c;
        kDevVol.LastYearCost__c = kVolume.LastYearCost__c;
        kDevVol.OptionRate__c = kVolume.OptionRate__c;
        kDevVol.RelevantYear__c = kVolume.RelevantYear__c;
        kDevVol.Usage__c = kVolume.Usage__c;
        kDevVol.VehicleVolume__c = kVolume.VehicleVolume__c;
        kDevVol.CurrencyIsoCode = kVolume.CurrencyIsoCode;
        kDevVol.CurrencyType__c = kVolume.CurrencyType__c;

        kDevVolPartList.add(kDevVol);
      }
    }
    return kDevVolPartList;
  }

  /**
   * 업데이트 된 Opportunity 중 특정 stage 로 변경된 것만 반환한다.
   *
   * @param aTargetStageName 선택 할 Opportunity stage name
   * @param aOldList List<Opportunity>
   * @param aNewList List<Opportunity>
   *
   * @return List<Opportunity>
   */
  @TestVisible
  private static List<Opportunity> chooseOpportunities(
    String aTargetStageName,
    List<Opportunity> aOldList,
    List<Opportunity> aNewList
  ) {
    List<Opportunity> kWonList = new List<Opportunity>();
    for (Integer i = 0; i < aNewList.size(); ++i) {
      Opportunity kOld = aOldList.get(i);
      Opportunity kNew = aNewList.get(i);
      if (
        kOld.StageName != aTargetStageName &&
        kNew.StageName == aTargetStageName
      ) {
        kWonList.add(kNew);
      }
    }
    return kWonList;
  }

  /**
   * 전달하는 Opportunity 로 PlanningPerformance 를 생성하여 반환한다.
   *
   * @param aWonForPlanList PlanningPerformance 를 추가할 opportunity 목록
   * @param aToday Date.today();
   *
   * @return List<PlanningPerformance__c>
   */
  @TestVisible
  private static List<PlanningPerformance__c> createPlans(
    List<Opportunity> aWonForPlanList,
    Date aToday
  ) {
    List<PlanningPerformance__c> kPlanList = new List<PlanningPerformance__c>();

    Id kRecordTypeId = SUtil.getRecordTypeId(
      PlanningPerformance__c.class,
      'Performance'
    );
    for (Opportunity kOpportunity : aWonForPlanList) {
      PlanningPerformance__c kPlan = new PlanningPerformance__c();
      kPlan.OwnerId = kOpportunity.OwnerId;
      kPlan.RecordTypeId = kRecordTypeId;
      kPlan.Date__c = aToday;
      kPlan.BU__c = kOpportunity.BU__c;
      kPlan.LargeGroup__c = kOpportunity.LargeGroup__c;
      kPlan.AccountRegion__c = kOpportunity.AccountRegion__c;
      kPlan.Account__c = kOpportunity.AccountId;
      kPlan.VehicleProject__c = kOpportunity.VehicleProject__c;
      kPlan.Product__c = kOpportunity.Product__c;
      kPlan.DealGrade__c = kOpportunity.DealGrade__c;
      //kPlan.WeightedLTR__c = kOpportunity.ru_ExpectedSales__c;
      kPlan.WeightedLTR__c = kOpportunity.SalesAmountIncLumpSumSales__c;
      kPlan.WeightedLTRrefDealGrade__c = kOpportunity.fm_ExpectedSalesrefDealgrade__c;
      kPlan.Opportunity__c = kOpportunity.Id;
      //
      kPlan.WeightedLTRUSD__c = kOpportunity.ru_ExpectedUSDConvert__c;
      kPlan.WeightedLTRUSDrefDealGrade__c = kOpportunity.fm_ExpectedUSDConvertrefDealgrade__c;
      kPlan.WeightedLTRUnit__c = kOpportunity.ExpectedSales__c;
      kPlan.WeightedLTRUSDrefDealGradeUnit__c = kOpportunity.ExpectedSalesrefDealgrade__c;
      kPlan.Profit__c = kOpportunity.ProfitIncLumpSumSales__c;
      kPlan.SalesAmount__c = kOpportunity.SalesAmountIncLumpSumSales__c;

      kPlan.ManagementTeam__c = kOpportunity.ManagementTeam__c;
      kPlan.OIManagingregion__c = kOpportunity.OIManagingregion__c;
      kPlan.MobisPlant__c = kOpportunity.MobisPlant__c;
      kPlan.LifeCycle__c = kOpportunity.LifeCycle__c;
      kPlan.SOP__c = kOpportunity.SOP__c;
      kPlan.MediumGroup__c = kOpportunity.MediumGroup__c;

      kPlan.Name =
        String.valueOf(aToday.year()) +
        '. ' +
        String.valueOf(aToday.month()).leftPad(2, '0') +
        '. Performance'; // 2022.09 Performance
      kPlanList.add(kPlan);
    }

    return kPlanList;
  }
}