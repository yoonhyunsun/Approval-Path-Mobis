/***************************************************************************************
 * Project Name : Hyundai Mobis
 * File Name    : ProformaConvertBatch
 * Description  :
 * Copyright    : Copyright © I2max. All Rights Reserved. 2022
 * Author       : KyeJin Cheong
 * Created Date : 2022-11-23
 ****************************************************************************************/

global without sharing class ProformaConvertBatch implements Database.Batchable<sObject>, Database.Stateful {
  // Variables
  public Map<String, ProformaDummy__c> upsertProformaMap;

  /**
   * @description I/F 대상 추출
   * @param bc (Database.BatchableContext)
   * @return Database.QueryLocator
   * @author Kyejin Cheong
   */
  public Database.QueryLocator start(Database.BatchableContext bc) {
    // init(bc);
    System.debug('ProformaConvertBatch > ');

    Set<String> externalIds = upsertProformaMap.keySet();

    System.debug('externalIds.size() > ' + externalIds.size());

    String query = 'SELECT Id ';

    // Get the fields from FieldSet
    List<Schema.FieldSetMember> fieldSetMembers = SalesUtil.getFieldSet(
      'Proforma_Convert_List',
      'ProformaDummy__c'
    );

    // Key : Field Label, Value : Field API Name
    for (Schema.FieldSetMember fieldSetMember : fieldSetMembers) {
      query += ', ' + fieldSetMember.getFieldPath();
    }

    query += ' FROM ProformaDummy__c';
    query += ' WHERE ExternalID__c IN :externalIds';

    System.debug('query > ' + query);

    return Database.getQueryLocator(query);
  }

  public void execute(Database.BatchableContext bc, List<SObject> scope) {
    System.debug('bc > ' + bc);
    System.debug(scope);
    System.debug('scope.size : ' + scope.size());
    // gCnt += scope.size();

    // Key : External ID, values : Proforma
    Map<String, Proforma__c> proformaMap = new Map<String, Proforma__c>();

    Proforma__c proforma;

    for (ProformaDummy__c proformaDummy : (List<ProformaDummy__c>) scope) {
      for (Integer i = 0; i < 10; i++) {
        // Input Values
        String relevantYear = 'RelevantYearY' + i + '__c';
        String oemVehicleVolume = 'OEMVehicleVolumeY' + i + '__c';
        String optionRate = 'OptionRateY' + i + '__c';
        String piecePrice = 'PiecePriceY' + i + '__c';

        // Formulas
        String crRate = 'fm_CRRateY' + i + '__c';
        String mobisProductVolume = 'fm_MobisProductVolumeY' + i + '__c';
        String localSalesAmount = 'fm_LocalSalesAmountY' + i + '__c';
        String wonSalesAmount = 'fm_WonSalesAmountY' + i + '__c';
        String dollarSalesAmount = 'fm_DollarSalesAmountY' + i + '__c';

        proforma = new Proforma__c();

        proforma.CurrencyType__c = proformaDummy.CurrencyType__c;
        proforma.CurrencyIsoCode = proformaDummy.CurrencyIsoCode;

        proforma.OEMStatus__c = proformaDummy.OEMStatus__c;
        proforma.ProjectStatus__c = proformaDummy.ProjectStatus__c;
        proforma.OITargetYear__c = proformaDummy.OITargetYear__c;
        proforma.DealGrade__c = proformaDummy.DealGrade__c;
        proforma.BU__c = proformaDummy.BU__c;
        proforma.ModuleParts__c = proformaDummy.ModuleParts__c;
        proforma.Team__c = proformaDummy.Team__c;
        proforma.MediumProductGroup__c = proformaDummy.MediumProductGroup__c;
        proforma.SmallProductGroup__c = proformaDummy.SmallProductGroup__c;
        proforma.ProductDescription__c = proformaDummy.ProductDescription__c;
        proforma.Account__c = proformaDummy.Account__c;
        proforma.OIManagingRegion__c = proformaDummy.OIManagingRegion__c;
        proforma.VehicleProject__c = proformaDummy.VehicleProject__c;
        proforma.SOP__c = proformaDummy.SOP__c;
        proforma.MobisPlant__c = proformaDummy.MobisPlant__c;
        proforma.SalesEntity__c = proformaDummy.SalesEntity__c;
        proforma.Usage__c = proformaDummy.Usage__c;

        // Input Values
        proforma.RelevantYear__c = (Decimal) proformaDummy.get(relevantYear);
        proforma.OEMVehicleVolume__c = (Decimal) proformaDummy.get(
          oemVehicleVolume
        );
        proforma.OptionRate__c = (Decimal) proformaDummy.get(optionRate);
        proforma.PiecePrice__c = (Decimal) proformaDummy.get(piecePrice);

        // 매출 데이터 및 CR율
        proforma.CRRate__c = (Decimal) proformaDummy.get(crRate);
        proforma.MobisProductVolume__c = (Decimal) proformaDummy.get(
          mobisProductVolume
        );
        proforma.LocalSalesAmount__c = (Decimal) proformaDummy.get(
          localSalesAmount
        );
        proforma.WonSalesAmount__c = (Decimal) proformaDummy.get(
          wonSalesAmount
        );
        proforma.DollarSalesAmount__c = (Decimal) proformaDummy.get(
          dollarSalesAmount
        );

        // 수주 데이터
        if (
          proforma.OITargetYear__c == proforma.RelevantYear__c &&
          proforma.ProjectStatus__c.equalsIgnoreCase('Plan')
        ) {
          proforma.LocalContractAmount__c = proformaDummy.fm_LocalContractAmount__c;
          proforma.WonContractAmount__c = proformaDummy.fm_WonContractAmount__c;
          proforma.DollarContractAmount__c = proformaDummy.fm_DollarContractAmount__c;
        } else {
          // 0
          proforma.LocalContractAmount__c = 0;
          proforma.WonContractAmount__c = 0;
          proforma.DollarContractAmount__c = 0;
        }

        proforma.ExternalID__c = SalesUtil.getProformaExternalKey(
          proformaDummy.Index__c,
          proforma.VehicleProject__c,
          proformaDummy.MediumProductGroup__c,
          proformaDummy.SmallProductGroup__c,
          Integer.valueOf(proforma.RelevantYear__c),
          Integer.valueOf(proforma.OEMVehicleVolume__c),
          Integer.valueOf(proforma.OptionRate__c),
          Integer.valueOf(proforma.PiecePrice__c)
        );
        proformaMap.put(proforma.ExternalID__c, proforma);
      }
    }

    System.debug('proformaMap.size() > ' + proformaMap.size()); // 10000

    //오류/성공 기록 저장
    Database.UpsertResult[] urList;
    Database.UpsertResult ur;

    if (!proformaMap.isEmpty()) {
      urList = Database.upsert(
        proformaMap.values(),
        Proforma__c.ExternalID__c,
        false
      ); // 10000
    }
  }

  global void finish(Database.BatchableContext bc) {
  }
}