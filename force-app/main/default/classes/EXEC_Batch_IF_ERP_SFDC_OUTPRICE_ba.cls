/**
 * Created by hyodongmin on 2022/09/22.
 */

public with sharing class EXEC_Batch_IF_ERP_SFDC_OUTPRICE_ba extends BatchBase {

    protected override Database.QueryLocator start2(Database.BatchableContext batchableContext) {
        /*
        아직 처리하지 않은 레코드 반환
         */
        return Database.getQueryLocator('SELECT Id, BEZEI__c, DATAB__c, DATBI__c, DMBTR2__c, DMBTR__c, DUMMY_STATUS__c, ' +
                'ERNAM__c,KMEIN__c, KONWA__c, KPEIN__c, KSCHL__c, KUNNR__c, LFDID__c, MAKTX__c, MATNR__c, MVGR1__c, NAME1__c, ' +
                'ORGEH__c, SPART__c,  VTEXT__c, ZAMOUNT1__c, ZAMOUNT2__c, ZAMOUNT3__c, ZAMOUNT4__c, ZAMOUNT5__c, ZCONNO__c, ' +
                'ZEDFG__c, ZIMDCHGCD1__c, ZIMDCHGCD2__c, ZIMDCHGCD3__c, ZIMDCHGCD4__c, ZIMDCHGCD5__c, ZKUNNC__c, ZPRODCD__c, ' +
                'ZVEHTY__c FROM IF_ERP_SFDC_OUTPRICE__c WHERE DUMMY_STATUS__c = NULL');
    }

    public override void execute(Database.BatchableContext context, List<SObject> aSObjList) {
        /*
        실 오브젝트에 맵핑하여 입력 DUMMY_STATUS__c = DUMMY_STATUS_INPUT

        upsert 실패시 => DUMMY_STATUS_FAILURE
        성공 -> DUMMY_STATUS_SUCCESS
         */
        try {
            List<IF_ERP_SFDC_OUTPRICE__c> kDummyList = (List<IF_ERP_SFDC_OUTPRICE__c>) aSObjList;
            List<Outprice__c> kList = new List<Outprice__c>();
            for (IF_ERP_SFDC_OUTPRICE__c kDummy : kDummyList) {
                kDummy.DUMMY_STATUS__c = DUMMY_STATUS_INPUT;

                Outprice__c kOutprice = new Outprice__c();
                kOutprice.AccountNo__c = kDummy.KUNNR__c;
                kOutprice.MaterialNo__c = kDummy.MATNR__c;
                kOutprice.EffectiveStartDate__c = toDate(kDummy.DATAB__c);
                kOutprice.AppliedVersion__c = kDummy.LFDID__c;
                kOutprice.EffectiveEndDate__c = toDate(kDummy.DATBI__c);
                kOutprice.ConditionType__c = kDummy.KSCHL__c;
                kOutprice.RateUnit__c = kDummy.KONWA__c;
                kOutprice.ConditionPriceUnit__c = kDummy.KPEIN__c;
                kOutprice.ConditionUnit__c = kDummy.KMEIN__c;
                kOutprice.CurrentUnitPrice__c = toDecimal(kDummy.DMBTR__c);
                kOutprice.ReasonCode1__c = kDummy.ZIMDCHGCD1__c;
                kOutprice.PriceDifference1__c = toDecimal(kDummy.ZAMOUNT1__c);
                kOutprice.ReasonCode2__c = kDummy.ZIMDCHGCD2__c;
                kOutprice.PriceDifference2__c = toDecimal(kDummy.ZAMOUNT2__c);
                kOutprice.ReasonCode3__c = kDummy.ZIMDCHGCD3__c;
                kOutprice.PriceDifference3__c = toDecimal(kDummy.ZAMOUNT3__c);
                kOutprice.ReasonCode4__c = kDummy.ZIMDCHGCD4__c;
                kOutprice.PriceDifference4__c = toDecimal(kDummy.ZAMOUNT4__c);
                kOutprice.ReasonCode5__c = kDummy.ZIMDCHGCD5__c;
                kOutprice.PriceDifference5__c = toDecimal(kDummy.ZAMOUNT5__c);
                kOutprice.VendorCode__c = kDummy.ZKUNNC__c;
                kOutprice.ProductGroup__c = kDummy.SPART__c;
                kOutprice.Description__c = kDummy.VTEXT__c;
                kOutprice.MaterialGroup1__c = kDummy.MVGR1__c;
                kOutprice.ModelCodeName__c = kDummy.BEZEI__c;
                kOutprice.ProductGroupCode__c = kDummy.ZPRODCD__c;
                kOutprice.CarTypeName__c = kDummy.ZVEHTY__c;
                kOutprice.MaterialDetail__c = kDummy.MAKTX__c;
                kOutprice.OriginalPrice__c = toDecimal(kDummy.DMBTR2__c);
                kOutprice.DomesticExport__c = kDummy.ZEDFG__c;
                kOutprice.AccountName__c = kDummy.NAME1__c;
                kOutprice.ApprovalNo__c = kDummy.ZCONNO__c;
                kOutprice.CreatedBy__c = kDummy.ERNAM__c;
                kOutprice.OrganizationUnit__c = kDummy.ORGEH__c;
                kOutprice.Key__c = toKey(kDummy);
                kList.add(kOutprice);
            }

            Database.UpsertResult[] kResultList = Database.upsert(kList, Outprice__c.Key__c, false);

            for (Integer i = 0; i < kResultList.size(); ++i) {
                Database.UpsertResult kResult = kResultList[i];
                IF_ERP_SFDC_OUTPRICE__c kDummy = kDummyList[i];

                persistUpsertResult(kDummy, IF_ERP_SFDC_OUTPRICE__c.DUMMY_STATUS__c, kResult);
            }
            update aSObjList;
        } catch (Exception e) {
            logger.log('Error Msg : ' + e.getMessage());
        }
    }

    private static Date toDate(String aYyyyMmDd) {
        return SUtil.max(SUtil.min(SUtil.toDate(SUtil.toDateStr(aYyyyMmDd))));
    }
    
    private static Decimal toDecimal(String aValue) {
        return Decimal.valueOf(SUtil.orDefault(aValue, '0'));
    }

    @TestVisible
    private static String toKey(IF_ERP_SFDC_OUTPRICE__c kDummy) {
        return kDummy.KUNNR__c + '+' + kDummy.MATNR__c + '+' + kDummy.DATAB__c + '+' + kDummy.LFDID__c;
    }
}