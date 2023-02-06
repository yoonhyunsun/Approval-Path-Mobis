/**
 * Created by changheekim on 2022/10/03.
 */

public with sharing class SalesPartsVolumeTriggerHandler extends TriggerHandler {
  public override void beforeInsert() {
    calculateUSDAmount((List<SalesPartsVolume__c>) Trigger.new);
  }
  public override void beforeUpdate() {
    calculateUSDAmount((List<SalesPartsVolume__c>) Trigger.new);
  }
  /**
   * parts volume의 값이 생성되거나 바뀌게 되면
   * 해당 currency에 따라 환율을 가져와 환산하여 값을 저장하는 트리거.
   *
   */
  private void calculateUSDAmount(List<SalesPartsVolume__c> newList) {
    if (newList == null)
      return;

    Set<Id> ctIdSet = new Set<Id>();

    for (SalesPartsVolume__c spv : newList) {
      ctIdSet.add(spv.CurrencyType__c);
    }

    if (ctIdSet.isEmpty())
      return;

    Map<Id, Currency__c> ctMap = new Map<Id, Currency__c>(
      [
        SELECT
          Id,
          Name,
          Year__c,
          JPY__c,
          MXN__c,
          RUB__c,
          USD__c,
          BRL__c,
          CAD__c,
          CNY__c,
          EUR__c,
          INR__c,
          fm_CNYConversion__c,
          fm_EURConversion__c,
          RecordTypeId,
          CustomerCurrencyEUR__c,
          CustomerCurrencyJPY__c,
          CustomerCurrencyCNY__c
        FROM Currency__c
        WHERE Id IN :ctIdSet
      ]
    );

    Id customerCurrency = SUtil.getRecordTypeId(
      Currency__c.class,
      'Customer_Currency'
    );
    for (SalesPartsVolume__c spv : newList) {
      String country = spv.CurrencyIsoCode + '__c';
      Decimal countryRate;
      // record type이 customer currency일 경우
      if (ctMap.get(spv.CurrencyType__c).RecordTypeId == customerCurrency) {
        if (spv.CurrencyIsoCode == 'EUR') {
          spv.USDConvertAmount__c =
            spv.fm_TotalAmount__c *
            ctMap.get(spv.CurrencyType__c).CustomerCurrencyEUR__c;
        } else if (spv.CurrencyIsoCode == 'CNY') {
          spv.USDConvertAmount__c =
            spv.fm_TotalAmount__c /
            ctMap.get(spv.CurrencyType__c).CustomerCurrencyCNY__c;
        }
      } else {
        if (spv.CurrencyIsoCode != 'KRW') {
          if (ctMap.get(spv.CurrencyType__c).get(country) == null) {
            countryRate = 1;
          } else {
            countryRate = (Decimal) ctMap.get(spv.CurrencyType__c).get(country);
          }
        }

        if (spv.CurrencyIsoCode == 'USD') {
          spv.USDConvertAmount__c = spv.fm_TotalAmount__c;
        } else if (spv.CurrencyIsoCode == 'KRW') {
          spv.USDConvertAmount__c =
            spv.fm_TotalAmount__c / ctMap.get(spv.CurrencyType__c).USD__c;
        } else if (spv.CurrencyIsoCode == 'JPY') {
          spv.USDConvertAmount__c =
            spv.fm_TotalAmount__c *
            countryRate *
            0.01 /
            ctMap.get(spv.CurrencyType__c).USD__c;
        } else {
          spv.USDConvertAmount__c =
            spv.fm_TotalAmount__c *
            countryRate /
            ctMap.get(spv.CurrencyType__c).USD__c;
        }
      }
    }
  }
}