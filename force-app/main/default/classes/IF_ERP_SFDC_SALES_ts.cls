/**
 * Created by hyodongmin on 2022/08/25.
 */

@IsTest
private class IF_ERP_SFDC_SALES_ts {
    @IsTest
    static void testProcess() {
        String json = '{\n' +
                '    "ZSUMGU": "집계구분",\n' +
                '    "CALMONTH": "년월(YYYYMM)",\n' +
                '    "SPMON": "매출발생년월",\n' +
                '    "ZVERS": "버전",\n' +
                '    "BUKRS": "회사 코드",\n' +
                '    "BUKRS_DESC": "회사 코드명",\n' +
                '    "ZPROD": "제품",\n' +
                '    "ZPROD_DESC": "제품명",\n' +
                '    "ZVEHTY": "차종명",\n' +
                '    "PRCTR": "손익 센터",\n' +
                '    "ZEDFG": "내수",\n' +
                '    "ZEDFG_DESC": "내수/수출 구분명",\n' +
                '    "ZKUNTP": "aa",\n' +
                '    "ZKUNTP_DESC": "고객구분명",\n' +
                '    "ZBIZTP": "구분",\n' +
                '    "ZBIZTP_DESC": "사업구분명",\n' +
                '    "ZCOMTP": "본사",\n' +
                '    "ZCOMTP_DESC": "본사/해외명",\n' +
                '    "ZREGTP": "지역",\n' +
                '    "ZREGTP_DESC": "지역구분명",\n' +
                '    "ZCOPTP": "법인구분",\n' +
                '    "ZCOPTP_DESC": "법인구분명",\n' +
                '    "ZUSG": "--",\n' +
                '    "FKIMG": "실제 대금청구 수량",\n' +
                '    "VRKME": "판매 단위",\n' +
                '    "DMBTR": "금액(현지 통화)",\n' +
                '    "STWAE": "현지통화",\n' +
                '    "DMBTR_USD": "매출금액(USD)",\n' +
                '    "WAERS_V": "통계 통화"\n' +
                '}';

        IF_Abstract.Input kInput = new IF_Abstract.Input();
        kInput.getPayload().t_data = new List<IF_Abstract.T_DATA>{
                new IF_ERP_SFDC_SALES().deserializeOne(json)
        };

        new IF_ERP_SFDC_SALES().process(kInput, new IF_Abstract.Output());


        List<IF_ERP_SFDC_SALES__c> kList = [
                SELECT ZSUMGU__c, CALMONTH__c, SPMON__c, ZVERS__c, BUKRS__c, BUKRS_DESC__c, ZPROD__c,
                        ZPROD_DESC__c, ZVEHTY__c, PRCTR__c, ZEDFG__c, ZEDFG_DESC__c, ZKUNTP__c, ZKUNTP_DESC__c, ZBIZTP__c, ZBIZTP_DESC__c,
                        ZCOMTP__c, ZCOMTP_DESC__c, ZREGTP__c, ZREGTP_DESC__c, ZCOPTP__c, ZCOPTP_DESC__c, ZUSG__c, FKIMG__c, VRKME__c, DMBTR__c, STWAE__c,
                        DMBTR_USD__c, WAERS_V__c
                FROM IF_ERP_SFDC_SALES__c
        ];

        System.assertEquals(1, kList.size());
        IF_ERP_SFDC_SALES__c kData = kList[0];
        System.assertEquals('집계구분', kData.ZSUMGU__c);
        System.assertEquals('년월(YYYYMM)', kData.CALMONTH__c);
        System.assertEquals('매출발생년월', kData.SPMON__c);
        System.assertEquals('버전', kData.ZVERS__c);
        System.assertEquals('회사 코드', kData.BUKRS__c);
        System.assertEquals('회사 코드명', kData.BUKRS_DESC__c);
        System.assertEquals('제품', kData.ZPROD__c);
        System.assertEquals('제품명', kData.ZPROD_DESC__c);
        System.assertEquals('차종명', kData.ZVEHTY__c);
        System.assertEquals('손익 센터', kData.PRCTR__c);
        System.assertEquals('내수', kData.ZEDFG__c);
        System.assertEquals('내수/수출 구분명', kData.ZEDFG_DESC__c);
        System.assertEquals('aa', kData.ZKUNTP__c);
        System.assertEquals('고객구분명', kData.ZKUNTP_DESC__c);
        System.assertEquals('구분', kData.ZBIZTP__c);
        System.assertEquals('사업구분명', kData.ZBIZTP_DESC__c);
        System.assertEquals('본사', kData.ZCOMTP__c);
        System.assertEquals('본사/해외명', kData.ZCOMTP_DESC__c);
        System.assertEquals('지역', kData.ZREGTP__c);
        System.assertEquals('지역구분명', kData.ZREGTP_DESC__c);
        System.assertEquals('법인구분', kData.ZCOPTP__c);
        System.assertEquals('법인구분명', kData.ZCOPTP_DESC__c);
        System.assertEquals('--', kData.ZUSG__c);
        System.assertEquals('실제 대금청구 수량', kData.FKIMG__c);
        System.assertEquals('판매 단위', kData.VRKME__c);
        System.assertEquals('금액(현지 통화)', kData.DMBTR__c);
        System.assertEquals('현지통화', kData.STWAE__c);
        System.assertEquals('매출금액(USD)', kData.DMBTR_USD__c);
        System.assertEquals('통계 통화', kData.WAERS_V__c);
    }
    @IsTest
    static void testGetIfId() {
        System.assertEquals('IF_ERP_SFDC_SALES', new IF_ERP_SFDC_SALES().getIfId());
    }
    @IsTest
    static void testDeserializeOne() {
        String json = '{\n' +
                '    "ZSUMGU": "집계구분",\n' +
                '    "CALMONTH": "년월(YYYYMM)",\n' +
                '    "SPMON": "매출발생년월",\n' +
                '    "ZVERS": "버전",\n' +
                '    "BUKRS": "회사 코드",\n' +
                '    "BUKRS_DESC": "회사 코드명",\n' +
                '    "ZPROD": "제품",\n' +
                '    "ZPROD_DESC": "제품명",\n' +
                '    "ZVEHTY": "차종명",\n' +
                '    "PRCTR": "손익 센터",\n' +
                '    "ZEDFG": "내수",\n' +
                '    "ZEDFG_DESC": "내수/수출 구분명",\n' +
                '    "ZKUNTP": "aa",\n' +
                '    "ZKUNTP_DESC": "고객구분명",\n' +
                '    "ZBIZTP": "구분",\n' +
                '    "ZBIZTP_DESC": "사업구분명",\n' +
                '    "ZCOMTP": "본사",\n' +
                '    "ZCOMTP_DESC": "본사/해외명",\n' +
                '    "ZREGTP": "지역",\n' +
                '    "ZREGTP_DESC": "지역구분명",\n' +
                '    "ZCOPTP": "법인구분",\n' +
                '    "ZCOPTP_DESC": "법인구분명",\n' +
                '    "ZUSG": "--",\n' +
                '    "FKIMG": "실제 대금청구 수량",\n' +
                '    "VRKME": "판매 단위",\n' +
                '    "DMBTR": "금액(현지 통화)",\n' +
                '    "STWAE": "현지통화",\n' +
                '    "DMBTR_USD": "매출금액(USD)",\n' +
                '    "WAERS_V": "통계 통화"\n' +
                '}';

        IF_ERP_SFDC_SALES.DataSales kData = (IF_ERP_SFDC_SALES.DataSales) new IF_ERP_SFDC_SALES().deserializeOne(json);
        System.assertEquals('집계구분', kData.ZSUMGU);
        System.assertEquals('년월(YYYYMM)', kData.CALMONTH);
        System.assertEquals('매출발생년월', kData.SPMON);
        System.assertEquals('버전', kData.ZVERS);
        System.assertEquals('회사 코드', kData.BUKRS);
        System.assertEquals('회사 코드명', kData.BUKRS_DESC);
        System.assertEquals('제품', kData.ZPROD);
        System.assertEquals('제품명', kData.ZPROD_DESC);
        System.assertEquals('차종명', kData.ZVEHTY);
        System.assertEquals('손익 센터', kData.PRCTR);
        System.assertEquals('내수', kData.ZEDFG);
        System.assertEquals('내수/수출 구분명', kData.ZEDFG_DESC);
        System.assertEquals('aa', kData.ZKUNTP);
        System.assertEquals('고객구분명', kData.ZKUNTP_DESC);
        System.assertEquals('구분', kData.ZBIZTP);
        System.assertEquals('사업구분명', kData.ZBIZTP_DESC);
        System.assertEquals('본사', kData.ZCOMTP);
        System.assertEquals('본사/해외명', kData.ZCOMTP_DESC);
        System.assertEquals('지역', kData.ZREGTP);
        System.assertEquals('지역구분명', kData.ZREGTP_DESC);
        System.assertEquals('법인구분', kData.ZCOPTP);
        System.assertEquals('법인구분명', kData.ZCOPTP_DESC);
        System.assertEquals('--', kData.ZUSG);
        System.assertEquals('실제 대금청구 수량', kData.FKIMG);
        System.assertEquals('판매 단위', kData.VRKME);
        System.assertEquals('금액(현지 통화)', kData.DMBTR);
        System.assertEquals('현지통화', kData.STWAE);
        System.assertEquals('매출금액(USD)', kData.DMBTR_USD);
        System.assertEquals('통계 통화', kData.WAERS_V);
    }

    @IsTest
    static void testPost() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/IF_ERP_SFDC_SALES';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueOf('{\n' +
                '    "request": {\n' +
                '        "header": {\n' +
                '            "ifTrackingId": "{{trackingId}}",\n' +
                '            "ifId": "IF_ERP_SFDC_SALES",\n' +
                '            "ifDateTime": "2020-09-10 17:17:38"\n' +
                '        },\n' +
                '        "payload": {\n' +
                '            "ifAggregation": "{{aggregation}}",\n' +
                '            "ifTotCnt": "1",\n' +
                '            "ifSplitCnt": "1",\n' +
                '            "ifSplitSeq": "1",\n' +
                '            "t_data": [\n' +
                '                {\n' +
                '                    "ZSUMGU": "집계구분",\n' +
                '                    "CALMONTH": "년월(YYYYMM)",\n' +
                '                    "SPMON": "매출발생년월",\n' +
                '                    "ZVERS": "버전",\n' +
                '                    "BUKRS": "회사 코드",\n' +
                '                    "BUKRS_DESC": "회사 코드명",\n' +
                '                    "ZPROD": "제품",\n' +
                '                    "ZPROD_DESC": "제품명",\n' +
                '                    "ZVEHTY": "차종명",\n' +
                '                    "PRCTR": "손익 센터",\n' +
                '                    "ZEDFG": "내수",\n' +
                '                    "ZEDFG_DESC": "내수/수출 구분명",\n' +
                '                    "ZKUNTP": "--",\n' +
                '                    "ZKUNTP_DESC": "고객구분명",\n' +
                '                    "ZBIZTP": "구분",\n' +
                '                    "ZBIZTP_DESC": "사업구분명",\n' +
                '                    "ZCOMTP": "본사",\n' +
                '                    "ZCOMTP_DESC": "본사/해외명",\n' +
                '                    "ZREGTP": "지역",\n' +
                '                    "ZREGTP_DESC": "지역구분명",\n' +
                '                    "ZCOPTP": "법인구분",\n' +
                '                    "ZCOPTP_DESC": "법인구분명",\n' +
                '                    "ZUSG": "--",\n' +
                '                    "FKIMG": "실제 대금청구 수량",\n' +
                '                    "VRKME": "판매 단위",\n' +
                '                    "DMBTR": "금액(현지 통화)",\n' +
                '                    "STWAE": "현지통화",\n' +
                '                    "DMBTR_USD": "매출금액(USD)",\n' +
                '                    "WAERS_V": "통계 통화"\n' +
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