/**
 * Created by hyodongmin on 2022/09/22.
 */

public with sharing class EXEC_Batch_IF_ERP_SFDC_SALES_ba extends BatchBase {

    protected override Database.QueryLocator start2(Database.BatchableContext batchableContext) {
        /*
        아직 처리하지 않은 레코드 반환
         */
        return Database.getQueryLocator('SELECT Id, BUKRS__c, BUKRS_DESC__c, CALMONTH__c, DMBTR__c, DMBTR_USD__c, DUMMY_STATUS__c, ' +
                'FKIMG__c, PRCTR__c, SPMON__c, STWAE__c, VRKME__c, WAERS_V__c, ZBIZTP__c, ZBIZTP_DESC__c, ZCOMTP__c, ZCOMTP_DESC__c, ' +
                'ZCOPTP__c, ZCOPTP_DESC__c, ZEDFG__c, ZEDFG_DESC__c, ZKUNTP__c, ZKUNTP_DESC__c, ZPROD__c, ZPROD_DESC__c, ZREGTP__c, ' +
                'ZREGTP_DESC__c, ZSUMGU__c, ZUSG__c, ZVEHTY__c, ZVERS__c FROM IF_ERP_SFDC_SALES__c WHERE DUMMY_STATUS__c = NULL');
    }

    public override void execute(Database.BatchableContext context, List<SObject> aSObjList) {
        /*
        실 오브젝트에 맵핑하여 입력 DUMMY_STATUS__c = DUMMY_STATUS_INPUT

        upsert 실패시 => DUMMY_STATUS_FAILURE
        성공 -> DUMMY_STATUS_SUCCESS
         */
        try {
            List<IF_ERP_SFDC_SALES__c> kDummyList = (List<IF_ERP_SFDC_SALES__c>) aSObjList;
            List<Sales__c> kSalesList = new List<Sales__c>();
            for (IF_ERP_SFDC_SALES__c kDummy : kDummyList) {
                kDummy.DUMMY_STATUS__c = DUMMY_STATUS_INPUT;

                Sales__c kSales = new Sales__c();
                kSales.Date__c = kDummy.CALMONTH__c;
                kSales.SalesMonth__c = kDummy.SPMON__c;
                kSales.CompanyCode__c = kDummy.BUKRS_DESC__c;
                kSales.Product__c = kDummy.ZPROD_DESC__c;
                kSales.DomesticExport__c = kDummy.PRCTR__c;
                kSales.Clientcode__c = kDummy.ZKUNTP_DESC__c;
                kSales.Businesscode__c = kDummy.ZBIZTP_DESC__c;
                kSales.Regioncode__c = kDummy.ZREGTP__c;
                kSales.Corporatecode__c = kDummy.ZCOPTP_DESC__c;
                kSales.USG__c = kDummy.ZUSG__c;
                kSales.ActualInvoicedQuantity__c = Decimal.valueOf(SUtil.orDefault(kDummy.FKIMG__c, '0'));
                kSales.SalesUnit__c = kDummy.VRKME__c;
                kSales.Amount__c = Decimal.valueOf(SUtil.orDefault(kDummy.DMBTR__c, '0'));
                kSales.CurrencyIsoCode = kDummy.STWAE__c;
                kSales.SalesAmountUSD__c = Decimal.valueOf(SUtil.orDefault(kDummy.DMBTR_USD__c, '0'));
                kSales.StatisticCurrency__c = kDummy.WAERS_V__c;
                kSales.Type__c = kDummy.ZSUMGU__c;
                kSales.Key__c = toKey(kDummy);

                kSalesList.add(kSales);
            }

            Database.UpsertResult[] kResultList = Database.upsert(kSalesList, Sales__c.Key__c, false);

            for (Integer i = 0; i < kResultList.size(); ++i) {
                Database.UpsertResult kResult = kResultList[i];
                IF_ERP_SFDC_SALES__c kDummy = kDummyList[i];

                persistUpsertResult(kDummy, IF_ERP_SFDC_SALES__c.DUMMY_STATUS__c, kResult);
            }
            update aSObjList;
        } catch (Exception e) {
            logger.log('Error Msg : ' + e.getMessage());
        }
    }

    @TestVisible
    private static String toKey(IF_ERP_SFDC_SALES__c kDummy) {
        return kDummy.ZSUMGU__c + '+' + kDummy.CALMONTH__c + '+' + kDummy.SPMON__c + '+' + kDummy.ZVERS__c + '+' + kDummy.BUKRS__c + '+' + kDummy.ZPROD__c
                + '+' + kDummy.ZVEHTY__c + '+' + kDummy.PRCTR__c + '+' + kDummy.ZEDFG__c + '+' + kDummy.ZKUNTP__c + '+' + kDummy.ZBIZTP__c;
    }
}