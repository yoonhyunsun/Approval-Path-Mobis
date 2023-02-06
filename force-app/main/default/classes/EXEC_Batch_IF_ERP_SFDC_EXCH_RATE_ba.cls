/**
 * Created by hyodongmin on 2022/10/20.
 */

public with sharing class EXEC_Batch_IF_ERP_SFDC_EXCH_RATE_ba extends BatchBase {

    protected override Database.QueryLocator start2(Database.BatchableContext batchableContext) {
        /*
        아직 처리하지 않은 레코드 반환
         */
        return Database.getQueryLocator('SELECT Id, DATUM__c,GUBUN__c, WAERS__c, CHKYN__c, STAND_NUM__c, CSEL_NUM__c, CBUY_NUM__c, ' +
                'TSEL_NUM__c, TBUY_NUM__c, TCHG_NUM__c, USCHG_NUM__c, CHGRE_NUM__c, SDATE__c ' +
                'FROM IF_ERP_SFDC_EXCHANGE_RATE__c WHERE DUMMY_STATUS__c = NULL');
    }

    public override void execute(Database.BatchableContext context, List<SObject> aSObjList) {
        /*
        실 오브젝트에 맵핑하여 입력 DUMMY_STATUS__c = DUMMY_STATUS_INPUT

        upsert 실패시 => DUMMY_STATUS_FAILURE
        성공 -> DUMMY_STATUS_SUCCESS
         */
        try {
            List<IF_ERP_SFDC_EXCHANGE_RATE__c> kDummyList = (List<IF_ERP_SFDC_EXCHANGE_RATE__c>) aSObjList;
            
            Map<String, IF_ERP_SFDC_EXCHANGE_RATE__c> kDummyMap = new Map<String, IF_ERP_SFDC_EXCHANGE_RATE__c>();
            List<MonthlyCurrency__c> kRateList = new List<MonthlyCurrency__c>();
            for (IF_ERP_SFDC_EXCHANGE_RATE__c kDummy : kDummyList) {
                kDummy.DUMMY_STATUS__c = DUMMY_STATUS_INPUT;

                if('X'.equalsIgnoreCase(kDummy.CHKYN__c)) { // X : 적용 / Space : 미적용

                    MonthlyCurrency__c kRate = new MonthlyCurrency__c();
                    try {

                        // 예외 발생 시 실패로 처리, 하나라도 없다면 의미있는 데이터라고 볼 수 없다.
                        kRate.BasicRateofExchange__c = Decimal.valueOf(kDummy.STAND_NUM__c);
                        kRate.CurrencyIsoCode = kDummy.WAERS__c;    // BRL CAD CNY EUR INR JPY KRW MXN RUB USD ( CurrencyType )
                        kRate.Date__c = SUtil.min(SUtil.max(SUtil.toDate(SUtil.toDateStr(kDummy.DATUM__c))));
                        kRate.ExchangeCommissionRate__c = Decimal.valueOf(kDummy.CHGRE_NUM__c);
                        kRate.ForeignCurrencyCheck__c = Decimal.valueOf(kDummy.TCHG_NUM__c);
                        kRate.ForeignExchangeBuyingRate__c = Decimal.valueOf(kDummy.CBUY_NUM__c);
                        kRate.ForeignExchangeSellingRate__c = Decimal.valueOf(kDummy.CSEL_NUM__c);
                        kRate.TTBuyingRate__c = Decimal.valueOf(kDummy.TBUY_NUM__c);
                        kRate.TTSellingRate__c = Decimal.valueOf(kDummy.TSEL_NUM__c);
                        kRate.USDExchangeRate__c = Decimal.valueOf(kDummy.USCHG_NUM__c);

                    } catch (Exception e) {
                        kRate.Date__c = null;
                        kRate.CurrencyIsoCode = null;
                    }

                    if (null != kRate.Date__c && String.isNotBlank(kRate.CurrencyIsoCode)) {
                        kRate.Name = String.format('{0} ({1})', new String[]{ ((Datetime)kRate.Date__c).format('yyyy-MM-dd'), kRate.CurrencyIsoCode });
                        String kUniqueKey = toUniqueKey(kRate.Date__c.format(), kRate.CurrencyIsoCode);
                        kRateList.add(kRate);
                        kDummyMap.put(kUniqueKey, kDummy);
                    } else {
                        kDummy.DUMMY_STATUS__c = DUMMY_STATUS_FAILURE;
                    }
                } else {
                    kDummy.DUMMY_STATUS__c = DUMMY_STATUS_SUCCESS;
                }
            }

            Database.SaveResult[] kResultList = Database.insert(kRateList, false);

            for (Integer i = 0; i < kResultList.size(); ++i) {
                Database.SaveResult kResult = kResultList[i];
                MonthlyCurrency__c kRate = kRateList[i];
                IF_ERP_SFDC_EXCHANGE_RATE__c kDummy = kDummyMap.get(toUniqueKey(kRate.Date__c.format(), kRate.CurrencyIsoCode));

                persistResult(kDummy, IF_ERP_SFDC_EXCHANGE_RATE__c.DUMMY_STATUS__c,  kResult.isSuccess(), kResult.getErrors(), DUMMY_STATUS_SUCCESS);
            }
            update aSObjList;
        } catch (Exception e) {
            logger.log('Error Msg : ' + e.getMessage());
        }
    }

    private static String toUniqueKey(String aDate, String aCurrency) {
        return EXEC_Util.toUniqueKey(aDate, aCurrency);
    }
}