/**
 * Created by hyodongmin on 2022/08/25.
 */

@IsTest
private class IF_ERP_SFDC_OUTPRICE_ts {
    @IsTest
    static void testProcess() {
        String json = '{\n' +
                '                    "KUNNR": "고객 번호",\n' +
                '                    "MATNR": "자재 번호",\n' +
                '                    "DATAB": "효력 시작일",\n' +
                '                    "LFDID": "적용차수",\n' +
                '                    "DATBI": "효력 종료일",\n' +
                '                    "KSCHL": "조건 유형",\n' +
                '                    "KONWA": "비율단위",\n' +
                '                    "KPEIN": "aaaa",\n' +
                '                    "KMEIN": "조건단위",\n' +
                '                    "DMBTR": "개당 신규단가",\n' +
                '                    "ZIMDCHGCD1": "사유코드1",\n' +
                '                    "ZAMOUNT1": "가격차액1",\n' +
                '                    "ZIMDCHGCD2": "사유코드2",\n' +
                '                    "ZAMOUNT2": "가격차액2",\n' +
                '                    "ZIMDCHGCD3": "사유코드3",\n' +
                '                    "ZAMOUNT3": "가격차액3",\n' +
                '                    "ZIMDCHGCD4": "사유코드4",\n' +
                '                    "ZAMOUNT4": "가격차액4",\n' +
                '                    "ZIMDCHGCD5": "사유코드5",\n' +
                '                    "ZAMOUNT5": "가격차액5",\n' +
                '                    "ZKUNNC": "업체 Code",\n' +
                '                    "SPART": "제품군",\n' +
                '                    "VTEXT": "내역",\n' +
                '                    "MVGR1": "자재그룹 1",\n' +
                '                    "BEZEI": "모델코드명",\n' +
                '                    "ZPRODCD": "제품구분코드",\n' +
                '                    "ZVEHTY": "차종명",\n' +
                '                    "MAKTX": "자재내역",\n' +
                '                    "DMBTR2": "기존단가",\n' +
                '                    "ZEDFG": "내수",\n' +
                '                    "NAME1": "고객명",\n' +
                '                    "ZCONNO": "품의번호",\n' +
                '                    "ERNAM": "오브젝트 생성자 이름",\n' +
                '                    "ORGEH": "조직 단위"\n' +
                '                }';

        IF_Abstract.Input kInput = new IF_Abstract.Input();
        kInput.getPayload().t_data = new List<IF_Abstract.T_DATA>{
                new IF_ERP_SFDC_OUTPRICE().deserializeOne(json)
        };

        new IF_ERP_SFDC_OUTPRICE().process(kInput, null);

        //
        List<IF_ERP_SFDC_OUTPRICE__c> kList = [
                SELECT KUNNR__c, MATNR__c, DATAB__c, LFDID__c, DATBI__c, KSCHL__c, KONWA__c, KPEIN__c, KMEIN__c, DMBTR__c,
                        ZIMDCHGCD1__c, ZAMOUNT1__c, ZIMDCHGCD2__c, ZAMOUNT2__c, ZIMDCHGCD3__c, ZAMOUNT3__c, ZIMDCHGCD4__c,
                        ZAMOUNT4__c, ZIMDCHGCD5__c, ZAMOUNT5__c, ZKUNNC__c, SPART__c, VTEXT__c, MVGR1__c, BEZEI__c, ZPRODCD__c,
                        ZVEHTY__c, MAKTX__c, DMBTR2__c, ZEDFG__c, NAME1__c, ZCONNO__c, ERNAM__c, ORGEH__c
                FROM IF_ERP_SFDC_OUTPRICE__c
        ];

        System.assertEquals(1, kList.size());
        IF_ERP_SFDC_OUTPRICE__c kData = kList[0];
        System.assertEquals('고객 번호', kData.KUNNR__c);
        System.assertEquals('자재 번호', kData.MATNR__c);
        System.assertEquals('효력 시작일', kData.DATAB__c);
        System.assertEquals('적용차수', kData.LFDID__c);
        System.assertEquals('효력 종료일', kData.DATBI__c);
        System.assertEquals('조건 유형', kData.KSCHL__c);
        System.assertEquals('비율단위', kData.KONWA__c);
        System.assertEquals('aaaa', kData.KPEIN__c);
        System.assertEquals('조건단위', kData.KMEIN__c);
        System.assertEquals('개당 신규단가', kData.DMBTR__c);
        System.assertEquals('사유코드1', kData.ZIMDCHGCD1__c);
        System.assertEquals('가격차액1', kData.ZAMOUNT1__c);
        System.assertEquals('사유코드2', kData.ZIMDCHGCD2__c);
        System.assertEquals('가격차액2', kData.ZAMOUNT2__c);
        System.assertEquals('사유코드3', kData.ZIMDCHGCD3__c);
        System.assertEquals('가격차액3', kData.ZAMOUNT3__c);
        System.assertEquals('사유코드4', kData.ZIMDCHGCD4__c);
        System.assertEquals('가격차액4', kData.ZAMOUNT4__c);
        System.assertEquals('사유코드5', kData.ZIMDCHGCD5__c);
        System.assertEquals('가격차액5', kData.ZAMOUNT5__c);
        System.assertEquals('업체 Code', kData.ZKUNNC__c);
        System.assertEquals('제품군', kData.SPART__c);
        System.assertEquals('내역', kData.VTEXT__c);
        System.assertEquals('자재그룹 1', kData.MVGR1__c);
        System.assertEquals('모델코드명', kData.BEZEI__c);
        System.assertEquals('제품구분코드', kData.ZPRODCD__c);
        System.assertEquals('차종명', kData.ZVEHTY__c);
        System.assertEquals('자재내역', kData.MAKTX__c);
        System.assertEquals('기존단가', kData.DMBTR2__c);
        System.assertEquals('내수', kData.ZEDFG__c);
        System.assertEquals('고객명', kData.NAME1__c);
        System.assertEquals('품의번호', kData.ZCONNO__c);
        System.assertEquals('오브젝트 생성자 이름', kData.ERNAM__c);
        System.assertEquals('조직 단위', kData.ORGEH__c);
    }
    @IsTest
    static void testGetIfId() {
        System.assertEquals('IF_ERP_SFDC_OUTPRICE', new IF_ERP_SFDC_OUTPRICE().getIfId());
    }
    @IsTest
    static void testDeserializeOne() {
        String json = '{\n' +
                '                    "KUNNR": "고객 번호",\n' +
                '                    "MATNR": "자재 번호",\n' +
                '                    "DATAB": "효력 시작일",\n' +
                '                    "LFDID": "적용차수",\n' +
                '                    "DATBI": "효력 종료일",\n' +
                '                    "KSCHL": "조건 유형",\n' +
                '                    "KONWA": "비율단위",\n' +
                '                    "KPEIN": "aaaa",\n' +
                '                    "KMEIN": "조건단위",\n' +
                '                    "DMBTR": "개당 신규단가",\n' +
                '                    "ZIMDCHGCD1": "사유코드1",\n' +
                '                    "ZAMOUNT1": "가격차액1",\n' +
                '                    "ZIMDCHGCD2": "사유코드2",\n' +
                '                    "ZAMOUNT2": "가격차액2",\n' +
                '                    "ZIMDCHGCD3": "사유코드3",\n' +
                '                    "ZAMOUNT3": "가격차액3",\n' +
                '                    "ZIMDCHGCD4": "사유코드4",\n' +
                '                    "ZAMOUNT4": "가격차액4",\n' +
                '                    "ZIMDCHGCD5": "사유코드5",\n' +
                '                    "ZAMOUNT5": "가격차액5",\n' +
                '                    "ZKUNNC": "업체 Code",\n' +
                '                    "SPART": "제품군",\n' +
                '                    "VTEXT": "내역",\n' +
                '                    "MVGR1": "자재그룹 1",\n' +
                '                    "BEZEI": "모델코드명",\n' +
                '                    "ZPRODCD": "제품구분코드",\n' +
                '                    "ZVEHTY": "차종명",\n' +
                '                    "MAKTX": "자재내역",\n' +
                '                    "DMBTR2": "기존단가",\n' +
                '                    "ZEDFG": "내수",\n' +
                '                    "NAME1": "고객명",\n' +
                '                    "ZCONNO": "품의번호",\n' +
                '                    "ERNAM": "오브젝트 생성자 이름",\n' +
                '                    "ORGEH": "조직 단위"\n' +
                '                }';

        IF_ERP_SFDC_OUTPRICE.DataOutPrice kData = (IF_ERP_SFDC_OUTPRICE.DataOutPrice) new IF_ERP_SFDC_OUTPRICE().deserializeOne(json);
        System.assertEquals('고객 번호', kData.KUNNR);
        System.assertEquals('자재 번호', kData.MATNR);
        System.assertEquals('효력 시작일', kData.DATAB);
        System.assertEquals('적용차수', kData.LFDID);
        System.assertEquals('효력 종료일', kData.DATBI);
        System.assertEquals('조건 유형', kData.KSCHL);
        System.assertEquals('비율단위', kData.KONWA);
        System.assertEquals('aaaa', kData.KPEIN);
        System.assertEquals('조건단위', kData.KMEIN);
        System.assertEquals('개당 신규단가', kData.DMBTR);
        System.assertEquals('사유코드1', kData.ZIMDCHGCD1);
        System.assertEquals('가격차액1', kData.ZAMOUNT1);
        System.assertEquals('사유코드2', kData.ZIMDCHGCD2);
        System.assertEquals('가격차액2', kData.ZAMOUNT2);
        System.assertEquals('사유코드3', kData.ZIMDCHGCD3);
        System.assertEquals('가격차액3', kData.ZAMOUNT3);
        System.assertEquals('사유코드4', kData.ZIMDCHGCD4);
        System.assertEquals('가격차액4', kData.ZAMOUNT4);
        System.assertEquals('사유코드5', kData.ZIMDCHGCD5);
        System.assertEquals('가격차액5', kData.ZAMOUNT5);
        System.assertEquals('업체 Code', kData.ZKUNNC);
        System.assertEquals('제품군', kData.SPART);
        System.assertEquals('내역', kData.VTEXT);
        System.assertEquals('자재그룹 1', kData.MVGR1);
        System.assertEquals('모델코드명', kData.BEZEI);
        System.assertEquals('제품구분코드', kData.ZPRODCD);
        System.assertEquals('차종명', kData.ZVEHTY);
        System.assertEquals('자재내역', kData.MAKTX);
        System.assertEquals('기존단가', kData.DMBTR2);
        System.assertEquals('내수', kData.ZEDFG);
        System.assertEquals('고객명', kData.NAME1);
        System.assertEquals('품의번호', kData.ZCONNO);
        System.assertEquals('오브젝트 생성자 이름', kData.ERNAM);
        System.assertEquals('조직 단위', kData.ORGEH);
    }

    @IsTest
    static void testPost() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/IF_ERP_SFDC_OUTPRICE';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueOf('{\n' +
                '    "request": {\n' +
                '        "header": {\n' +
                '            "ifTrackingId": "{{trackingId}}",\n' +
                '            "ifId": "IF_ERP_SFDC_OUTPRICE",\n' +
                '            "ifDateTime": "2020-09-10 17:17:38"\n' +
                '        },\n' +
                '        "payload": {\n' +
                '            "ifAggregation": "{{aggregation}}",\n' +
                '            "ifTotCnt": "1",\n' +
                '            "ifSplitCnt": "1",\n' +
                '            "ifSplitSeq": "1",\n' +
                '            "t_data": [\n' +
                '                {\n' +
                '                    "KUNNR": "고객 번호",\n' +
                '                    "MATNR": "자재 번호",\n' +
                '                    "DATAB": "효력 시작일",\n' +
                '                    "LFDID": "적용차수",\n' +
                '                    "DATBI": "효력 종료일",\n' +
                '                    "KSCHL": "조건 유형",\n' +
                '                    "KONWA": "비율단위",\n' +
                '                    "KPEIN": "-----",\n' +
                '                    "KMEIN": "조건단위",\n' +
                '                    "DMBTR": "개당 신규단가",\n' +
                '                    "ZIMDCHGCD1": "사유코드1",\n' +
                '                    "ZAMOUNT1": "가격차액1",\n' +
                '                    "ZIMDCHGCD2": "사유코드2",\n' +
                '                    "ZAMOUNT2": "가격차액2",\n' +
                '                    "ZIMDCHGCD3": "사유코드3",\n' +
                '                    "ZAMOUNT3": "가격차액3",\n' +
                '                    "ZIMDCHGCD4": "사유코드4",\n' +
                '                    "ZAMOUNT4": "가격차액4",\n' +
                '                    "ZIMDCHGCD5": "사유코드5",\n' +
                '                    "ZAMOUNT5": "가격차액5",\n' +
                '                    "ZKUNNC": "업체 Code",\n' +
                '                    "SPART": "제품군",\n' +
                '                    "VTEXT": "내역",\n' +
                '                    "MVGR1": "자재그룹 1",\n' +
                '                    "BEZEI": "모델코드명",\n' +
                '                    "ZPRODCD": "제품구분코드",\n' +
                '                    "ZVEHTY": "차종명",\n' +
                '                    "MAKTX": "자재내역",\n' +
                '                    "DMBTR2": "기존단가",\n' +
                '                    "ZEDFG": "내수",\n' +
                '                    "NAME1": "고객명",\n' +
                '                    "ZCONNO": "품의번호",\n' +
                '                    "ERNAM": "오브젝트 생성자 이름",\n' +
                '                    "ORGEH": "조직 단위"\n' +
                '                }\n' +
                '            ]\n' +
                '        }\n' +
                '    }\n' +
                '}');

        RestContext.request = req;
        RestContext.response= res;

        Test.startTest();
        IF_ROUTER.doPost();
        Map<String, Object> kOutputMap = (Map<String, Object>) JSON.deserializeUntyped(res.responseBody.toString());
        Test.stopTest();

        System.assertEquals('{{trackingId}}', TestUtil.valueOf(kOutputMap, 'response.header.ifTrackingId'));
        System.assertEquals('{{aggregation}}', TestUtil.valueOf(kOutputMap, 'response.payload.ifAggregation'));
        System.assertEquals('1', TestUtil.valueOf(kOutputMap, 'response.payload.ifRcvCnt'));
        Map<String, Object> kResMap = (Map<String, Object>)TestUtil.valueOf(kOutputMap, 'response.header');
        System.assertEquals(false, kResMap.containsKey('SYNC_IP'));
        System.assertEquals(false, kResMap.containsKey('SYNC_DT'));
        System.assertEquals(false, kResMap.containsKey('FLAG'));
        System.assertEquals(false, kResMap.containsKey('DESC'));
    }
}