/**
 * Created by hyodongmin on 2022/09/22.
 */

@IsTest
private class EXEC_Batch_IF_ERP_SFDC_SALES_ba_ts {
    @IsTest
    static void testBehavior() {
        EXEC_Batch_IF_ERP_SFDC_SALES_ba ba = new EXEC_Batch_IF_ERP_SFDC_SALES_ba();
        Database.QueryLocator kQueryLocator = ba.start(new TestContext());
        System.assertEquals('SELECT Id, BUKRS__c, BUKRS_DESC__c, CALMONTH__c, DMBTR__c, DMBTR_USD__c, DUMMY_STATUS__c, FKIMG__c, ' +
                'PRCTR__c, SPMON__c, STWAE__c, VRKME__c, WAERS_V__c, ZBIZTP__c, ZBIZTP_DESC__c, ZCOMTP__c, ZCOMTP_DESC__c, ' +
                'ZCOPTP__c, ZCOPTP_DESC__c, ZEDFG__c, ZEDFG_DESC__c, ZKUNTP__c, ZKUNTP_DESC__c, ZPROD__c, ZPROD_DESC__c, ' +
                'ZREGTP__c, ZREGTP_DESC__c, ZSUMGU__c, ZUSG__c, ZVEHTY__c, ZVERS__c FROM IF_ERP_SFDC_SALES__c ' +
                'WHERE DUMMY_STATUS__c = NULL', kQueryLocator.getQuery());
    }

    @IsTest
    static void testExecute() {

        EXEC_Batch_IF_ERP_SFDC_SALES_ba ba = new EXEC_Batch_IF_ERP_SFDC_SALES_ba();
        ba.start(new TestContext());

        List<IF_ERP_SFDC_SALES__c> kDummyList = new List<IF_ERP_SFDC_SALES__c>{
                new IF_ERP_SFDC_SALES__c(
                        CALMONTH__c = '1',
                        SPMON__c = '2',
                        BUKRS_DESC__c = '3',
                        ZPROD_DESC__c = '4',
                        PRCTR__c = '5',
                        ZKUNTP_DESC__c = '6',
                        ZBIZTP_DESC__c = '7',
                        ZREGTP__c = '8',
                        ZCOPTP_DESC__c = '9',
                        ZUSG__c = '10',
                        FKIMG__c = '11',
                        VRKME__c = '12',
                        DMBTR__c = '13',
                        STWAE__c = 'KRW',
                        DMBTR_USD__c = '15',
                        ZSUMGU__c = '88',
                        WAERS_V__c = '16'
                )
        };
        insert kDummyList;

        ba.execute(new TestContext(), kDummyList);

        // Department__c 입력 확인
        Sales__c kSales = [
                SELECT Id, Date__c, SalesMonth__c, CompanyCode__c, Product__c, DomesticExport__c, Clientcode__c,
                        Businesscode__c, Regioncode__c, Corporatecode__c, USG__c, ActualInvoicedQuantity__c,
                        SalesUnit__c, Amount__c, CurrencyIsoCode, SalesAmountUSD__c, StatisticCurrency__c, Key__c, Type__c
                FROM Sales__c
        ];
        System.assertEquals('1', kSales.Date__c);
        System.assertEquals('2', kSales.SalesMonth__c);
        System.assertEquals('3', kSales.CompanyCode__c);
        System.assertEquals('4', kSales.Product__c);
        System.assertEquals('5', kSales.DomesticExport__c);
        System.assertEquals('6', kSales.Clientcode__c);
        System.assertEquals('7', kSales.Businesscode__c);
        System.assertEquals('8', kSales.Regioncode__c);
        System.assertEquals('9', kSales.Corporatecode__c);
        System.assertEquals('10', kSales.USG__c);
        System.assertEquals(11, kSales.ActualInvoicedQuantity__c);
        System.assertEquals('12', kSales.SalesUnit__c);
        System.assertEquals(13, kSales.Amount__c);
        System.assertEquals('KRW', kSales.CurrencyIsoCode);
        System.assertEquals(15, kSales.SalesAmountUSD__c);
        System.assertEquals('16', kSales.StatisticCurrency__c);
        System.assertEquals('88', kSales.Type__c);
        System.assertEquals(EXEC_Batch_IF_ERP_SFDC_SALES_ba.toKey(kDummyList[0]), kSales.Key__c);

        // dummy status 업데이트 확인
        kDummyList = [SELECT DUMMY_STATUS__c FROM IF_ERP_SFDC_SALES__c WHERE DUMMY_STATUS__c = 'S'];
        System.assertEquals(1, kDummyList.size());
    }

    @IsTest
    static void testExecuteException() {

        EXEC_Batch_IF_ERP_SFDC_SALES_ba ba = new EXEC_Batch_IF_ERP_SFDC_SALES_ba();
        ba.start(new TestContext());

        ba.execute(new TestContext(), new Account[]{});    // for coverage
    }

    class TestContext implements Database.BatchableContext {
        public Id getChildJobId() {
            return '01p9D000002zVAW';
        }
        public Id getJobId() {
            return '01p9D000002oIBQ';
        }
    }
}