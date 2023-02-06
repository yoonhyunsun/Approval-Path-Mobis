/**
 * Created by hyodongmin on 2022/10/24.
 */

@IsTest
private class EXEC_Batch_IF_ERP_SFDC_EXCH_RATE_ba_ts {
    @IsTest
    static void testBehavior() {
        EXEC_Batch_IF_ERP_SFDC_EXCH_RATE_ba ba = new EXEC_Batch_IF_ERP_SFDC_EXCH_RATE_ba();
        Database.QueryLocator kQueryLocator = ba.start(new TestContext());
        System.assertEquals('SELECT Id, DATUM__c,GUBUN__c, WAERS__c, CHKYN__c, STAND_NUM__c, CSEL_NUM__c, CBUY_NUM__c, ' +
                'TSEL_NUM__c, TBUY_NUM__c, TCHG_NUM__c, USCHG_NUM__c, CHGRE_NUM__c, SDATE__c ' +
                'FROM IF_ERP_SFDC_EXCHANGE_RATE__c WHERE DUMMY_STATUS__c = NULL', kQueryLocator.getQuery());
    }

    @IsTest
    static void testExecute() {
        EXEC_Batch_IF_ERP_SFDC_EXCH_RATE_ba ba = new EXEC_Batch_IF_ERP_SFDC_EXCH_RATE_ba();
        ba.start(new TestContext());


        List<IF_ERP_SFDC_EXCHANGE_RATE__c> kDummyList = new List<IF_ERP_SFDC_EXCHANGE_RATE__c>{
                new IF_ERP_SFDC_EXCHANGE_RATE__c(
                        CHKYN__c = 'X',     STAND_NUM__c = '1.1', WAERS__c = 'USD', DATUM__c = '20221122', CHGRE_NUM__c = '2.2',
                        TCHG_NUM__c = '3.3', CBUY_NUM__c = '4.4', CSEL_NUM__c = '5.5', TBUY_NUM__c = '6.6', TSEL_NUM__c = '7.7',
                        USCHG_NUM__c = '8.8'
                ),
                new IF_ERP_SFDC_EXCHANGE_RATE__c(CHKYN__c = ''),  // 미적용 -> 성공
                new IF_ERP_SFDC_EXCHANGE_RATE__c(CHKYN__c = null),    // 미적용 -> 성공
                new IF_ERP_SFDC_EXCHANGE_RATE__c(CHKYN__c = 'X', STAND_NUM__c = 'NOT NUM')    // error
        };
        insert kDummyList;

        ba.execute(new TestContext(), kDummyList);

        // MonthlyCurrency__c 입력 확인
        MonthlyCurrency__c[] kMonthlyCurrency = [
                SELECT Id, Name, BasicRateofExchange__c, CurrencyIsoCode, Date__c, ExchangeCommissionRate__c, ForeignCurrencyCheck__c,
                        ForeignExchangeBuyingRate__c, ForeignExchangeSellingRate__c, TTBuyingRate__c, TTSellingRate__c, USDExchangeRate__c
                FROM MonthlyCurrency__c
        ];
        System.assertEquals(1, kMonthlyCurrency.size()); // CHKYN__c = 'X' 인 것만 데이터 입력
        System.assertEquals('2022-11-22 (USD)', kMonthlyCurrency[0].Name);
        System.assertEquals(1.1, kMonthlyCurrency[0].BasicRateofExchange__c);
        System.assertEquals('USD', kMonthlyCurrency[0].CurrencyIsoCode);
        System.assertEquals(Date.newInstance(2022, 11, 22), kMonthlyCurrency[0].Date__c);
        System.assertEquals(2.2, kMonthlyCurrency[0].ExchangeCommissionRate__c);
        System.assertEquals(3.3, kMonthlyCurrency[0].ForeignCurrencyCheck__c);
        System.assertEquals(4.4, kMonthlyCurrency[0].ForeignExchangeBuyingRate__c);
        System.assertEquals(5.5, kMonthlyCurrency[0].ForeignExchangeSellingRate__c);
        System.assertEquals(6.6, kMonthlyCurrency[0].TTBuyingRate__c);
        System.assertEquals(7.7, kMonthlyCurrency[0].TTSellingRate__c);
        System.assertEquals(8.8, kMonthlyCurrency[0].USDExchangeRate__c);

        // dummy status 업데이트 확인
        System.assertEquals(1, [SELECT Id, CHKYN__c FROM IF_ERP_SFDC_EXCHANGE_RATE__c WHERE DUMMY_STATUS__c = 'S' AND CHKYN__c = 'X'].size()); // 성공 3개
        System.assertEquals(2, [SELECT Id, CHKYN__c FROM IF_ERP_SFDC_EXCHANGE_RATE__c WHERE DUMMY_STATUS__c = 'S' AND CHKYN__c = ''].size()); // 성공 3개, '', null
        System.assertEquals(2, [SELECT Id, CHKYN__c FROM IF_ERP_SFDC_EXCHANGE_RATE__c WHERE DUMMY_STATUS__c = 'S' AND CHKYN__c = NULL].size()); // 성공 3개, '', null
        System.assertEquals(1, [SELECT Id FROM IF_ERP_SFDC_EXCHANGE_RATE__c WHERE DUMMY_STATUS__c = 'F'].size()); // 실패 1개
    }

    @IsTest
    static void testExecuteNAKey() {
        EXEC_Batch_IF_ERP_SFDC_EXCH_RATE_ba ba = new EXEC_Batch_IF_ERP_SFDC_EXCH_RATE_ba();
        ba.start(new TestContext());


        List<IF_ERP_SFDC_EXCHANGE_RATE__c> kDummyList = new List<IF_ERP_SFDC_EXCHANGE_RATE__c>{
                new IF_ERP_SFDC_EXCHANGE_RATE__c(
                        CHKYN__c = 'X',     STAND_NUM__c = '1.1', WAERS__c = 'USD', DATUM__c = '', CHGRE_NUM__c = '2.2',
                        TCHG_NUM__c = '3.3', CBUY_NUM__c = '4.4', CSEL_NUM__c = '5.5', TBUY_NUM__c = '6.6', TSEL_NUM__c = '7.7',
                        USCHG_NUM__c = '8.8'
                ),
                new IF_ERP_SFDC_EXCHANGE_RATE__c(
                        CHKYN__c = 'X',     STAND_NUM__c = '1.1', WAERS__c = '', DATUM__c = '20221122', CHGRE_NUM__c = '2.2',
                        TCHG_NUM__c = '3.3', CBUY_NUM__c = '4.4', CSEL_NUM__c = '5.5', TBUY_NUM__c = '6.6', TSEL_NUM__c = '7.7',
                        USCHG_NUM__c = '8.8'
                )
        };
        insert kDummyList;

        ba.execute(new TestContext(), kDummyList);

        // MonthlyCurrency__c 입력 확인
        MonthlyCurrency__c[] kMonthlyCurrency = [
                SELECT Id, Name, BasicRateofExchange__c, CurrencyIsoCode, Date__c, ExchangeCommissionRate__c, ForeignCurrencyCheck__c,
                        ForeignExchangeBuyingRate__c, ForeignExchangeSellingRate__c, TTBuyingRate__c, TTSellingRate__c, USDExchangeRate__c
                FROM MonthlyCurrency__c
        ];
        System.assertEquals(0, kMonthlyCurrency.size()); // 필수 데이터가 없어서 입력 안됨

        // dummy status 업데이트 확인
        System.assertEquals(2, [SELECT Id, CHKYN__c FROM IF_ERP_SFDC_EXCHANGE_RATE__c WHERE DUMMY_STATUS__c = 'F'].size()); // 실패 2개
    }

    @IsTest
    static void testExecuteException() {
        EXEC_Batch_IF_ERP_SFDC_EXCH_RATE_ba ba = new EXEC_Batch_IF_ERP_SFDC_EXCH_RATE_ba();
        ba.start(new TestContext());

        ba.execute(new TestContext(), null);    // for coverage
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