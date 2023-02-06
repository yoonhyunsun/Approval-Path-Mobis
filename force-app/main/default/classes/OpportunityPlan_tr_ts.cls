/**
 * Created by hyodongmin on 2022/11/01.
 */

@IsTest
private class OpportunityPlan_tr_ts {
    @IsTest
    static void testAfterUpdate() {
        new OpportunityPlan_tr().afterUpdate(); // for coverage
    }
    @IsTest
    static void testPersistPlanningPerformanceIf() {
        OpportunityPlan_tr.persistPlanningPerformanceIf(
                new List<Opportunity>{
                        (Opportunity) TestUtil.treatFields(new Opportunity(), new Object[]{
                                'Id', 'idddd1',
                                'StageName', 'Closed Won'
                        })
                },
                new List<Opportunity>{
                        (Opportunity) TestUtil.treatFields(new Opportunity(), new Object[]{
                                'Id', 'idddd1',
                                'StageName', 'Closed Won'
                        })
                });
        System.assertEquals(0, [SELECT Id FROM PlanningPerformance__c].size()); // 처리 할 것 없음
    }
    @IsTest
    static void testPersistPlanningPerformanceIfNull() {
        OpportunityPlan_tr.persistPlanningPerformanceIf(null, null);
        System.assertEquals(0, [SELECT Id FROM PlanningPerformance__c].size()); // null
    }
    /*
    @IsTest
    static void testPersistPlanningPerformanceIf2() {
        User usr = new User(Alias = 't',LastName = 'Testing', Username = 'testUser1@mobis.co.kr.ps');
        insert usr;
        Account acc = new Account(Name = 'acc');
        insert acc;
        VehicleProject__c vp = new VehicleProject__c(Name = 'vp', AccountName__c = acc.Id);
        insert vp;
        Product2 pd = new Product2(Name = 'pd');
        insert pd;
        Opportunity kNew = new Opportunity(StageName = 'Closed Won', VehicleProject__c = vp.Id, Product__c = pd.Id, AccountId = acc.Id,
                CloseDate = Date.today(), OwnerId = usr.Id);
        insert kNew;
        Opportunity kOld = kNew.clone();
        kOld.StageName = 'Qualification';

        OpportunityPlan_tr.persistPlanningPerformanceIf(
                new List<Opportunity>{ kOld },
                new List<Opportunity>{ kNew });
        System.assertEquals(1, [SELECT Id FROM PlanningPerformance__c].size()); // 승인 여부 관계없이 입력
    }
    @IsTest
    static void testPersistPlanningPerformanceIfIntegration() {
        Test.setMock(HttpCalloutMock.class, new RestMock());
        
        User usr = new User(Alias = 't',LastName = 'Testing', Username = 'testUser1@mobis.co.kr.ps');
        insert usr;
        Account acc = new Account(Name = 'acc');
        insert acc;
        VehicleProject__c vp = new VehicleProject__c(Name = 'vp', AccountName__c = acc.Id);
        insert vp;
        Product2 pd = new Product2(Name = 'pd');
        insert pd;
        Currency__c ct = new Currency__c(USD__c = 1400);
        insert ct;

        BU__c bu = new BU__c(Name = 'bu');
        Opportunity kNew = new Opportunity(StageName = 'Qualification', VehicleProject__c = vp.Id, Product__c = pd.Id, AccountId = acc.Id,
                OwnerId = usr.Id,
                CurrencyType__c = ct.Id, BU__c = bu.Id, CloseDate = Date.newInstance(2022, 1, 2),
                ManagementTeam__c = 'MJP', OIManagingregion__c='KR', DealGrade__c='A', SOP__c = Date.newInstance(2022, 12, 2),
                LifeCycle__c='4', Competitors__c='AL', Incoterms__c='CIP', InvestmentsToolingCost__c='Amortization', InvestmentsEDD__c='Amortization',
                PaymentTerms__c='T/T 105 Days', OEPlant__c='Aachen (Germany)', ExpectedOI__c=Date.newInstance(2022, 12, 2),
                SEG__c='Sedan', ActualRFQReceivedDate__c = Date.newInstance(2022, 12, 2), MobisPlant__c='IHL', IsRFQReceived__c = true, ToolingCost__c = 0);
        insert kNew;

        // 단계별 승인 필요
        ApprovalProcess__c[] aps = new ApprovalProcess__c[]{
                new ApprovalProcess__c(ApprovalStatus__c = 'Approved', Name = 'RFQ Receipt', Opportunity__c = kNew.Id, QuipURL__c = '/asdf.doc'),
                new ApprovalProcess__c(ApprovalStatus__c = 'Approved', Name = 'Quote', Opportunity__c = kNew.Id, QuipURL__c = '/asdf.doc'),
                new ApprovalProcess__c(ApprovalStatus__c = 'Approved', Name = 'Intake', Opportunity__c = kNew.Id, QuipURL__c = '/asdf.doc')
        };
        insert aps;

        SalesParts__c salesParts = new SalesParts__c(Opportunity__c = kNew.Id, PinNumber__c = 'pin1', Description__c = 'xyz',
                StartYear__c = '2022', EndYear__c = '2022');
        insert salesParts;
        SalesPartsVolume__c salesPartsVolume = new SalesPartsVolume__c(SalesParts__c = salesParts.Id, Cost__c = 1.0,
                CRRate__c = 2.0, IsStartYear__c = true, LastYearCost__c = 3.0, OptionRate__c = 4.0, RelevantYear__c = '2022',
                Usage__c = 5.0, VehicleVolume__c = 6.0, CurrencyType__c = ct.Id);
        insert salesPartsVolume;
        salesPartsVolume = (SalesPartsVolume__c) TestUtil.treatField(salesPartsVolume, 'Name',
                [SELECT Name FROM SalesPartsVolume__c LIMIT 1].Name); // 이름 갱신

        System.assertEquals(0, [SELECT Id FROM PlanningPerformance__c].size());

        kNew.StageName = 'RFQ Received';
        update kNew;
        kNew.StageName = 'Quote Submitted';
        update kNew;
        kNew.StageName = 'Negotiation';
        update kNew;
        Test.startTest();
        kNew.StageName = 'Closed Won';
        kNew.ManagementTeam__c = 'MPE';
        kNew.OIManagingregion__c = 'KR';
        kNew.DealGrade__c = 'A';
        kNew.SOP__c = Date.today();
        kNew.LifeCycle__c = '9';
        kNew.Competitors__c = 'CNC';
        kNew.Incoterms__c = 'CFR';
        kNew.InvestmentsToolingCost__c = 'Lump sum';
        kNew.InvestmentsEDD__c = 'Lump sum';
        kNew.PaymentTerms__c = 'T/T 30 Days';
        kNew.OEPlant__c = 'Flint (US)';
        kNew.ExpectedOI__c = Date.today();
        kNew.SEG__c = 'LCV';
        kNew.MobisPlant__c = 'MIN';
        kNew.StageValidationCheck__c = false;

        update kNew;
        Test.stopTest();

        PlanningPerformance__c plan = [SELECT Id, Opportunity__c FROM PlanningPerformance__c];
        System.assertEquals(kNew.Id, plan.Opportunity__c); // 바르게 입력됨

        Development__c dev = [SELECT Id, Opportunity__c, BU__c, Product__c, CurrencyType__c, VehicleProject__c FROM Development__c];
        System.assertEquals(kNew.Id, dev.Opportunity__c);
        System.assertEquals(bu.Id, dev.BU__c);
        System.assertEquals(pd.Id, dev.Product__c);
        System.assertEquals(ct.Id, dev.CurrencyType__c);
        System.assertEquals(vp.Id, dev.VehicleProject__c);

        DevelopmentParts__c devPart = [SELECT Id, Development__c, Name, SourcingPartsNumber__c, SourcingDate__c, Description__c FROM DevelopmentParts__c];
        System.assertEquals(dev.Id, devPart.Development__c);
        System.assertEquals('pin1', devPart.Name);
        System.assertEquals('pin1', devPart.SourcingPartsNumber__c);
        System.assertEquals(Date.newInstance(2022, 1, 2), devPart.SourcingDate__c);
        System.assertEquals('xyz', devPart.Description__c);

        DevelopmentPartsVolume__c devPartVol = [
                SELECT Id, Name, DevelopmentParts__c, Cost__c, CRRate__c, IsStartYear__c,
                        LastYearCost__c, OptionRate__c, RelevantYear__c, Usage__c, VehicleVolume__c
                FROM DevelopmentPartsVolume__c
        ];
        System.assertEquals(salesPartsVolume.Name, devPartVol.Name);
        System.assertEquals(devPart.Id, devPartVol.DevelopmentParts__c);
        System.assertEquals(1.0, devPartVol.Cost__c);
        System.assertEquals(2.0, devPartVol.CRRate__c);
        System.assertEquals(true, devPartVol.IsStartYear__c);
        System.assertEquals(3.0, devPartVol.LastYearCost__c);
        System.assertEquals(4.0, devPartVol.OptionRate__c);
        System.assertEquals('2022', devPartVol.RelevantYear__c);
        System.assertEquals(5.0, devPartVol.Usage__c);
        System.assertEquals(6.0, devPartVol.VehicleVolume__c);

    }
*/
    @IsTest
    static void testCreateOpptyDevelopments() {
        List<Opportunity> kWonApprovedList = new List<Opportunity>{
                (Opportunity) TestUtil.treatFields(new Opportunity(), new Object[]{
                        'Id', 'id1',
                        'Name', 'name1',
                        'BU__c', 'bu',
                        'Product__c', 'pro',
                        'CurrencyType__c', 'cur',
                        'CurrencyIsoCode', 'KRW',
                        'DealGrade__c', 'A',
                        'VehicleProject__c', 've'
                }),
                (Opportunity) TestUtil.treatFields(new Opportunity(), new Object[]{
                        'Id', 'id2',
                        'Name', 'name2',
                        'BU__c', 'bu2',
                        'Product__c', 'pro2',
                        'CurrencyType__c', 'cur2',
                        'CurrencyIsoCode', 'USD',
                        'DealGrade__c', 'B',
                        'VehicleProject__c', 've2'
                })
        };

        Map<Id, Development__c> kMap2 = OpportunityPlan_tr.createOpptyDevelopments(kWonApprovedList);
        Map<String, Development__c> kMap = (Map<String, Development__c>) JSON.deserialize(JSON.serialize(kMap2), Map<String, Development__c>.class);// id to string
        System.assertEquals(2, kMap.size());
        System.assertEquals('bu', kMap.get('id1').BU__c);
        System.assertEquals('[OI] name1', kMap.get('id1').Name);
        System.assertEquals('pro', kMap.get('id1').Product__c);
        System.assertEquals('cur', kMap.get('id1').CurrencyType__c);
        System.assertEquals('KRW', kMap.get('id1').CurrencyIsoCode);
        System.assertEquals('A', kMap.get('id1').DealGrade__c);
        System.assertEquals('ve', kMap.get('id1').VehicleProject__c);
        System.assertEquals('bu2', kMap.get('id2').BU__c);
        System.assertEquals('[OI] name2', kMap.get('id2').Name);
        System.assertEquals('pro2', kMap.get('id2').Product__c);
        System.assertEquals('cur2', kMap.get('id2').CurrencyType__c);
        System.assertEquals('USD', kMap.get('id2').CurrencyIsoCode);
        System.assertEquals('B', kMap.get('id2').DealGrade__c);
        System.assertEquals('ve2', kMap.get('id2').VehicleProject__c);
    }

    @IsTest
    static void testCreateSalesDevParts() {
        List<Opportunity> kList = new Opportunity[]{
                (Opportunity) TestUtil.treatFields(new Opportunity(), new Object[]{
                        'Id', '01p9D0000031g0a',    // map.get(Id) 의 경우 형식이 올바르지 않으면 에러가 발생하여 임시 Id 맵핑
                        'CloseDate', Date.newInstance(2022, 11, 22),
                        'Sales_Parts__r', TestUtil.rewriteSubQuery(new Object[]{
                                (SalesParts__c) TestUtil.treatField(new SalesParts__c(PinNumber__c = 'pin1', Description__c = 'desc1', AutoNumber__c = 1), 'Id', 'id1'),
                                (SalesParts__c) TestUtil.treatField(new SalesParts__c(PinNumber__c = 'pin2', Description__c = 'desc2', AutoNumber__c = 2), 'Id', 'id2')
                        })
                }),
                (Opportunity) TestUtil.treatFields(new Opportunity(), new Object[]{
                        'Id', '01p9D0000031g0Z',
                        'CloseDate', Date.newInstance(2022, 11, 22),
                        'Sales_Parts__r', TestUtil.rewriteSubQuery(new Object[]{
                                (SalesParts__c) TestUtil.treatField(new SalesParts__c(PinNumber__c = 'pin3', Description__c = 'desc3', AutoNumber__c = 3), 'Id', 'id3'),
                                (SalesParts__c) TestUtil.treatField(new SalesParts__c(PinNumber__c = 'pin4', Description__c = 'desc4', AutoNumber__c = 4), 'Id', 'id4')
                        })
                })
        };
        Map<Id, Development__c> kOppty2DevMap = new Map<Id, Development__c>{
                '01p9D0000031g0a' => (Development__c) TestUtil.treatField(new Development__c(), 'Id', 'dev1'),
                '01p9D0000031g0Z' => (Development__c) TestUtil.treatField(new Development__c(), 'Id', 'dev2')
        };
        Map<Id, DevelopmentParts__c> kMap = OpportunityPlan_tr.createSalesDevParts(kList, kOppty2DevMap);
        System.assertEquals(4, kMap.values().size());
        System.assertEquals('dev1', kMap.values()[0].Development__c);
        System.assertEquals('pin1', kMap.values()[0]. Name);
        System.assertEquals('pin1', kMap.values()[0].SourcingPartsNumber__c);
        System.assertEquals('desc1', kMap.values()[0].Description__c);
        System.assertEquals(1, kMap.values()[0].AutoNumber__c);
        System.assertEquals(Date.newInstance(2022, 11, 22), kMap.values()[0].SourcingDate__c);
        System.assertEquals('dev1', kMap.values()[1].Development__c);
        System.assertEquals('pin2', kMap.values()[1]. Name);
        System.assertEquals('pin2', kMap.values()[1].SourcingPartsNumber__c);
        System.assertEquals('desc2', kMap.values()[1].Description__c);
        System.assertEquals(2, kMap.values()[1].AutoNumber__c);
        System.assertEquals(Date.newInstance(2022, 11, 22), kMap.values()[1].SourcingDate__c);

        System.assertEquals('dev2', kMap.values()[2].Development__c);
        System.assertEquals('pin3', kMap.values()[2]. Name);
        System.assertEquals('pin3', kMap.values()[2].SourcingPartsNumber__c);
        System.assertEquals('desc3', kMap.values()[2].Description__c);
        System.assertEquals(3, kMap.values()[2].AutoNumber__c);
        System.assertEquals(Date.newInstance(2022, 11, 22), kMap.values()[2].SourcingDate__c);
        System.assertEquals('dev2', kMap.values()[3].Development__c);
        System.assertEquals('pin4', kMap.values()[3]. Name);
        System.assertEquals('pin4', kMap.values()[3].SourcingPartsNumber__c);
        System.assertEquals('desc4', kMap.values()[3].Description__c);
        System.assertEquals(4, kMap.values()[3].AutoNumber__c);
        System.assertEquals(Date.newInstance(2022, 11, 22), kMap.values()[3].SourcingDate__c);

    }

    @IsTest
    static void testCreateDevVolumes() {
        List<SalesParts__c> kList = new List<SalesParts__c>{
                (SalesParts__c) TestUtil.treatFields(new SalesParts__c(), new Object[]{
                        'Id', '01p9D0000031g0a',
                        'Sales_Parts_Volume__r', TestUtil.rewriteSubQuery(new Object[]{
                                (SalesPartsVolume__c) TestUtil.treatField(new SalesPartsVolume__c(
                                        Cost__c = 1.0, CRRate__c = 2.0, IsStartYear__c = true, LastYearCost__c = 3.0, OptionRate__c = 4.0,
                                        RelevantYear__c = '2022', Usage__c = 5.0, VehicleVolume__c = 6.0
                                ), 'Name', 'name1'),
                                (SalesPartsVolume__c) TestUtil.treatField(new SalesPartsVolume__c(
                                        Cost__c = 11.0, CRRate__c = 22.0, IsStartYear__c = true, LastYearCost__c = 33.0, OptionRate__c = 44.0,
                                        RelevantYear__c = '2023', Usage__c = 55.0, VehicleVolume__c = 66.0
                                ), 'Name', 'name2')
                        })
                }),
                (SalesParts__c) TestUtil.treatFields(new SalesParts__c(), new Object[]{
                        'Id', '01p9D0000031g0Z',
                        'Sales_Parts_Volume__r', TestUtil.rewriteSubQuery(new Object[]{
                                (SalesPartsVolume__c) TestUtil.treatField(new SalesPartsVolume__c(
                                        Cost__c = 111.0, CRRate__c = 222.0, IsStartYear__c = true, LastYearCost__c = 333.0, OptionRate__c = 444.0,
                                        RelevantYear__c = '2024', Usage__c = 555.0, VehicleVolume__c = 666.0
                                ), 'Name', 'name3')
                        })
                })
        };
        Map<Id, DevelopmentParts__c> kSales2DevPartMap = new Map<Id, DevelopmentParts__c>{
                '01p9D0000031g0a' => (DevelopmentParts__c) TestUtil.treatField(new DevelopmentParts__c(), 'Id', 'devPart1'),
                '01p9D0000031g0Z' => (DevelopmentParts__c) TestUtil.treatField(new DevelopmentParts__c(), 'Id', 'devPart2')
        };
        List<DevelopmentPartsVolume__c> kResults = OpportunityPlan_tr.createDevVolumes(kList, kSales2DevPartMap);
        System.assertEquals(3, kResults.size());
        System.assertEquals('name1', kResults[0].Name);
        System.assertEquals('devPart1', kResults[0].DevelopmentParts__c);
        System.assertEquals(1.0, kResults[0].Cost__c);
        System.assertEquals(2.0, kResults[0].CRRate__c);
        System.assertEquals(true, kResults[0].IsStartYear__c);
        System.assertEquals(3.0, kResults[0].LastYearCost__c);
        System.assertEquals(4.0, kResults[0].OptionRate__c);
        System.assertEquals('2022', kResults[0].RelevantYear__c);
        System.assertEquals(5.0, kResults[0].Usage__c);
        System.assertEquals(6.0, kResults[0].VehicleVolume__c);

        System.assertEquals('name2', kResults[1].Name);
        System.assertEquals('devPart1', kResults[1].DevelopmentParts__c);
        System.assertEquals(11.0, kResults[1].Cost__c);
        System.assertEquals(22.0, kResults[1].CRRate__c);
        System.assertEquals(true, kResults[1].IsStartYear__c);
        System.assertEquals(33.0, kResults[1].LastYearCost__c);
        System.assertEquals(44.0, kResults[1].OptionRate__c);
        System.assertEquals('2023', kResults[1].RelevantYear__c);
        System.assertEquals(55.0, kResults[1].Usage__c);
        System.assertEquals(66.0, kResults[1].VehicleVolume__c);

        System.assertEquals('name3', kResults[2].Name);
        System.assertEquals('devPart2', kResults[2].DevelopmentParts__c);
        System.assertEquals(111.0, kResults[2].Cost__c);
        System.assertEquals(222.0, kResults[2].CRRate__c);
        System.assertEquals(true, kResults[2].IsStartYear__c);
        System.assertEquals(333.0, kResults[2].LastYearCost__c);
        System.assertEquals(444.0, kResults[2].OptionRate__c);
        System.assertEquals('2024', kResults[2].RelevantYear__c);
        System.assertEquals(555.0, kResults[2].Usage__c);
        System.assertEquals(666.0, kResults[2].VehicleVolume__c);
    }

    @IsTest
    static void testChooseOpportunities() {
        Opportunity[] opps = OpportunityPlan_tr.chooseOpportunities('Closed Won',
                new List<Opportunity>{
                        (Opportunity) TestUtil.treatFields(new Opportunity(), new Object[]{
                                'Id', 'idddd1',
                                'StageName', 'Closed Won'
                        }),
                        (Opportunity) TestUtil.treatFields(new Opportunity(), new Object[]{
                                'Id', 'idddd2',
                                'StageName', 'Qualification'
                        }),
                        (Opportunity) TestUtil.treatFields(new Opportunity(), new Object[]{
                                'Id', 'idddd3',
                                'StageName', 'Closed Won'
                        })
                },
                new List<Opportunity>{
                        (Opportunity) TestUtil.treatFields(new Opportunity(), new Object[]{
                                'Id', 'idddd1',
                                'StageName', 'Closed Won'
                        }),
                        (Opportunity) TestUtil.treatFields(new Opportunity(), new Object[]{
                                'Id', 'idddd2',
                                'StageName', 'Closed Won'
                        }),
                        (Opportunity) TestUtil.treatFields(new Opportunity(), new Object[]{
                                'Id', 'idddd3',
                                'StageName', 'Closed Lost'
                        })
                });
        System.assertEquals(1, opps.size());
        System.assertEquals('idddd2', opps[0].Id); // Closed Won 으로 변경된 것\
        System.assertEquals('Closed Won', opps[0].StageName);   // new 선택
    }

    @IsTest
    static void testCreatePlans() {
        List<Opportunity> kWonForPlanList = new Opportunity[]{
                (Opportunity) TestUtil.treatFields(new Opportunity(), new Object[]{
                        'BU__c', 'bu',
                        'LargeGroup__c', 'LargeGroup',
                        'AccountRegion__c', 'AccountRegion',
                        'AccountId', 'eee',
                        'VehicleProject__c', 'VehicleProject',
                        'Product__c', 'Product',
                        'DealGrade__c', 'DealGrade',
                        'SalesAmountIncLumpSumSales__c', 100,
                        'fm_ExpectedSalesrefDealgrade__c', 1000,
                        'Id', 'idddd'
                })
        };
        Date kToday = Date.newInstance(2022, 7, 22);
        Id kRecordTypeId = SUtil.getRecordTypeId(PlanningPerformance__c.class, 'Performance');

        PlanningPerformance__c[] plans = OpportunityPlan_tr.createPlans(kWonForPlanList, kToday);
        System.assertEquals(1, plans.size());
        System.assertEquals('bu', plans[0].BU__c);
        System.assertEquals('LargeGroup', plans[0].LargeGroup__c);
        System.assertEquals('AccountRegion', plans[0].AccountRegion__c);
        System.assertEquals('eee', plans[0].Account__c);
        System.assertEquals('VehicleProject', plans[0].VehicleProject__c);
        System.assertEquals('Product', plans[0].Product__c);
        System.assertEquals('DealGrade', plans[0].DealGrade__c);
        System.assertEquals(100, plans[0].WeightedLTR__c);
        System.assertEquals(1000, plans[0].WeightedLTRrefDealGrade__c);
        System.assertEquals('idddd', plans[0].Opportunity__c);
        System.assertEquals('2022. 07. Performance', plans[0]. Name);
        System.assertEquals(kRecordTypeId, plans[0].RecordTypeId);
        System.assertEquals(kToday, plans[0].Date__c);
    }

    private class RestMock implements HttpCalloutMock {

        public HttpResponse respond(HttpRequest param1) {
            String fullJson = 'your Json Response';

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'text/json');
            res.setBody(fullJson);
            res.setStatusCode(200);
            return res;
        }
    }
}