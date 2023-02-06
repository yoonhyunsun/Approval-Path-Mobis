/**
 * Created by hyodongmin on 2022/09/22.
 */

@IsTest
private class EXEC_Batch_IF_ERP_SFDC_OUTPRICE_ba_ts {
    @IsTest
    static void testBehavior() {
        EXEC_Batch_IF_ERP_SFDC_OUTPRICE_ba ba = new EXEC_Batch_IF_ERP_SFDC_OUTPRICE_ba();
        Database.QueryLocator kQueryLocator = ba.start(new TestContext());
        System.assertEquals('SELECT Id, BEZEI__c, DATAB__c, DATBI__c, DMBTR2__c, DMBTR__c, DUMMY_STATUS__c, ' +
                'ERNAM__c,KMEIN__c, KONWA__c, KPEIN__c, KSCHL__c, KUNNR__c, LFDID__c, MAKTX__c, MATNR__c, MVGR1__c, NAME1__c, ' +
                'ORGEH__c, SPART__c,  VTEXT__c, ZAMOUNT1__c, ZAMOUNT2__c, ZAMOUNT3__c, ZAMOUNT4__c, ZAMOUNT5__c, ZCONNO__c, ' +
                'ZEDFG__c, ZIMDCHGCD1__c, ZIMDCHGCD2__c, ZIMDCHGCD3__c, ZIMDCHGCD4__c, ZIMDCHGCD5__c, ZKUNNC__c, ZPRODCD__c, ' +
                'ZVEHTY__c FROM IF_ERP_SFDC_OUTPRICE__c WHERE DUMMY_STATUS__c = NULL', kQueryLocator.getQuery());
    }

    @IsTest
    static void testExecute() {

        EXEC_Batch_IF_ERP_SFDC_OUTPRICE_ba ba = new EXEC_Batch_IF_ERP_SFDC_OUTPRICE_ba();
        ba.start(new TestContext());

        List<IF_ERP_SFDC_OUTPRICE__c> kDummyList = new List<IF_ERP_SFDC_OUTPRICE__c>{
                new IF_ERP_SFDC_OUTPRICE__c(
                        KUNNR__c = '1',
                        MATNR__c = '2',
                        DATAB__c = '20221122',
                        LFDID__c = '4',
                        DATBI__c = '99991111',
                        KSCHL__c = '6',
                        KONWA__c = '7',
                        KPEIN__c = '8',
                        KMEIN__c = '9',
                        DMBTR__c = '10',
                        ZIMDCHGCD1__c = '11',
                        ZAMOUNT1__c = '12',
                        ZIMDCHGCD2__c = '13',
                        ZAMOUNT2__c = '14',
                        ZIMDCHGCD3__c = '15',
                        ZAMOUNT3__c = '16',
                        ZIMDCHGCD4__c = '17',
                        ZAMOUNT4__c = '18',
                        ZIMDCHGCD5__c = '19',
                        ZAMOUNT5__c = '20',
                        ZKUNNC__c = '21',
                        SPART__c = '22',
                        VTEXT__c = '23',
                        MVGR1__c = '24',
                        BEZEI__c = '25',
                        ZPRODCD__c = '26',
                        ZVEHTY__c = '27',
                        MAKTX__c = '28',
                        DMBTR2__c = '29',
                        ZEDFG__c = '30',
                        NAME1__c = '31',
                        ZCONNO__c = '32',
                        ERNAM__c = '33',
                        ORGEH__c = '34'
                )
        };
        insert kDummyList;

        ba.execute(new TestContext(), kDummyList);

        // Department__c 입력 확인
        Outprice__c kObj = [
                SELECT AccountName__c, AccountNo__c, AppliedVersion__c, ApprovalNo__c, CarTypeName__c, ConditionPriceUnit__c,
                        ConditionType__c, ConditionUnit__c, CreatedBy__c, CurrentUnitPrice__c, Description__c, DomesticExport__c,
                        EffectiveEndDate__c, EffectiveStartDate__c, Key__c, MaterialDetail__c, MaterialGroup1__c, MaterialNo__c,
                        ModelCodeName__c, OrganizationUnit__c, OriginalPrice__c, PriceDifference1__c, PriceDifference2__c,
                        PriceDifference3__c, PriceDifference4__c, PriceDifference5__c, ProductGroup__c, ProductGroupCode__c,
                        RateUnit__c, ReasonCode1__c, ReasonCode2__c, ReasonCode3__c, ReasonCode4__c, ReasonCode5__c,
                        VendorCode__c
                FROM Outprice__c
        ];
        System.assertEquals('1', kObj.AccountNo__c);
        System.assertEquals('2', kObj.MaterialNo__c);
        System.assertEquals(Date.newInstance(2022, 11, 22), kObj.EffectiveStartDate__c);
        System.assertEquals('4', kObj.AppliedVersion__c);
        System.assertEquals(Date.newInstance(4000, 12, 31), kObj.EffectiveEndDate__c);
        System.assertEquals('6', kObj.ConditionType__c);
        System.assertEquals('7', kObj.RateUnit__c);
        System.assertEquals('8', kObj.ConditionPriceUnit__c);
        System.assertEquals('9', kObj.ConditionUnit__c);
        System.assertEquals(10, kObj.CurrentUnitPrice__c);
        System.assertEquals('11', kObj.ReasonCode1__c);
        System.assertEquals(12, kObj.PriceDifference1__c);
        System.assertEquals('13', kObj.ReasonCode2__c);
        System.assertEquals(14, kObj.PriceDifference2__c);
        System.assertEquals('15', kObj.ReasonCode3__c);
        System.assertEquals(16, kObj.PriceDifference3__c);
        System.assertEquals('17', kObj.ReasonCode4__c);
        System.assertEquals(18, kObj.PriceDifference4__c);
        System.assertEquals('19', kObj.ReasonCode5__c);
        System.assertEquals(20, kObj.PriceDifference5__c);
        System.assertEquals('21', kObj.VendorCode__c);
        System.assertEquals('22', kObj.ProductGroup__c);
        System.assertEquals('23', kObj.Description__c);
        System.assertEquals('24', kObj.MaterialGroup1__c);
        System.assertEquals('25', kObj.ModelCodeName__c);
        System.assertEquals('26', kObj.ProductGroupCode__c);
        System.assertEquals('27', kObj.CarTypeName__c);
        System.assertEquals('28', kObj.MaterialDetail__c);
        System.assertEquals(29, kObj.OriginalPrice__c);
        System.assertEquals('30', kObj.DomesticExport__c);
        System.assertEquals('31', kObj.AccountName__c);
        System.assertEquals('32', kObj.ApprovalNo__c);
        System.assertEquals('33', kObj.CreatedBy__c);
        System.assertEquals('34', kObj.OrganizationUnit__c);
        System.assertEquals(EXEC_Batch_IF_ERP_SFDC_OUTPRICE_ba.toKey(kDummyList[0]), kObj.Key__c);

        // dummy status 업데이트 확인
        kDummyList = [SELECT DUMMY_STATUS__c FROM IF_ERP_SFDC_OUTPRICE__c WHERE DUMMY_STATUS__c = 'S'];
        System.assertEquals(1, kDummyList.size());

    }

    @IsTest
    static void testExecuteException() {

        EXEC_Batch_IF_ERP_SFDC_OUTPRICE_ba ba = new EXEC_Batch_IF_ERP_SFDC_OUTPRICE_ba();
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