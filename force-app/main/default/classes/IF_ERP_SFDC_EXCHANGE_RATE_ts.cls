/**
 * Created by hyodongmin on 2022/08/25.
 */

@IsTest
private class IF_ERP_SFDC_EXCHANGE_RATE_ts {
    @IsTest
    static void testProcess() {
        String json = '{\n' +
                '    "DATUM": "DATUM",\n' +
                '    "GUBUN": "9",\n' +
                '    "WAERS": "WAERS",\n' +
                '    "CHKYN": "Y",\n' +
                '    "STAND": "STAND_NUM",\n' +
                '    "CSEL": "CSEL_NUM",\n' +
                '    "CBUY": "CBUY_NUM",\n' +
                '    "TSEL": "TSEL_NUM",\n' +
                '    "TBUY": "TBUY_NUM",\n' +
                '    "TCHG": "TCHG_NUM",\n' +
                '    "USCHG": "USCHG_NUM",\n' +
                '    "CHGRE": "CHGRE_NUM"\n' +
                '}';

        IF_Abstract.Input kInput = new IF_Abstract.Input();
        kInput.getPayload().t_data = new List<IF_Abstract.T_DATA>{
                new IF_ERP_SFDC_EXCHANGE_RATE().deserializeOne(json)
        };

        new IF_ERP_SFDC_EXCHANGE_RATE().process(kInput, new IF_Abstract.Output());

        // 
        List<IF_ERP_SFDC_EXCHANGE_RATE__c> kList = [
                SELECT Id, DATUM__c, GUBUN__c, WAERS__c, CHKYN__c, STAND_NUM__c, CSEL_NUM__c, CBUY_NUM__c,
                        TSEL_NUM__c, TBUY_NUM__c, TCHG_NUM__c, USCHG_NUM__c, CHGRE_NUM__c
                FROM IF_ERP_SFDC_EXCHANGE_RATE__c
        ];

        System.assertEquals(1, kList.size());
        IF_ERP_SFDC_EXCHANGE_RATE__c kData = kList[0];
        System.assertEquals('DATUM', kData.DATUM__c);
        System.assertEquals('9', kData.GUBUN__c);
        System.assertEquals('WAERS', kData.WAERS__c);
        System.assertEquals('Y', kData.CHKYN__c);
        System.assertEquals('STAND_NUM', kData.STAND_NUM__c);
        System.assertEquals('CSEL_NUM', kData.CSEL_NUM__c);
        System.assertEquals('CBUY_NUM', kData.CBUY_NUM__c);
        System.assertEquals('TSEL_NUM', kData.TSEL_NUM__c);
        System.assertEquals('TBUY_NUM', kData.TBUY_NUM__c);
        System.assertEquals('TCHG_NUM', kData.TCHG_NUM__c);
        System.assertEquals('USCHG_NUM', kData.USCHG_NUM__c);
        System.assertEquals('CHGRE_NUM', kData.CHGRE_NUM__c);
    }
    @IsTest
    static void testGetIfId() {
        System.assertEquals('IF_ERP_SFDC_EXCHANGE_RATE', new IF_ERP_SFDC_EXCHANGE_RATE().getIfId());
    }
    @IsTest
    static void testDeserializeOne() {
        String json = '{\n' +
                '    "DATUM": "DATUM",\n' +
                '    "GUBUN": "9",\n' +
                '    "WAERS": "WAERS",\n' +
                '    "CHKYN": "Y",\n' +
                '    "STAND": "STAND_NUM",\n' +
                '    "CSEL": "CSEL_NUM",\n' +
                '    "CBUY": "CBUY_NUM",\n' +
                '    "TSEL": "TSEL_NUM",\n' +
                '    "TBUY": "TBUY_NUM",\n' +
                '    "TCHG": "TCHG_NUM",\n' +
                '    "USCHG": "USCHG_NUM",\n' +
                '    "CHGRE": "CHGRE_NUM"\n' +
                '}';

        IF_ERP_SFDC_EXCHANGE_RATE.DataExchangeRate2 kData = (IF_ERP_SFDC_EXCHANGE_RATE.DataExchangeRate2) new IF_ERP_SFDC_EXCHANGE_RATE().deserializeOne(json);
        System.assertEquals('DATUM', kData.DATUM);
        System.assertEquals('9', kData.GUBUN);
        System.assertEquals('WAERS', kData.WAERS);
        System.assertEquals('Y', kData.CHKYN);
        System.assertEquals('STAND_NUM', kData.STAND);
        System.assertEquals('CSEL_NUM', kData.CSEL);
        System.assertEquals('CBUY_NUM', kData.CBUY);
        System.assertEquals('TSEL_NUM', kData.TSEL);
        System.assertEquals('TBUY_NUM', kData.TBUY);
        System.assertEquals('TCHG_NUM', kData.TCHG);
        System.assertEquals('USCHG_NUM', kData.USCHG);
        System.assertEquals('CHGRE_NUM', kData.CHGRE);
    }

    @IsTest
    static void testPost() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/IF_ERP_SFDC_EXCHANGE_RATE';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueOf('{\n' +
                '    "request": {\n' +
                '        "header": {\n' +
                '            "ifTrackingId": "{{trackingId}}",\n' +
                '            "ifId": "IF_ERP_SFDC_EXCHANGE_RATE",\n' +
                '            "ifDateTime": "2020-09-10 17:17:38"\n' +
                '        },\n' +
                '        "payload": {\n' +
                '            "ifAggregation": "{{aggregation}}",\n' +
                '            "ifTotCnt": "1",\n' +
                '            "ifSplitCnt": "1",\n' +
                '            "ifSplitSeq": "1",\n' +
                '            "t_data": [\n' +
                '                {\n' +
                '                    "DATUM": "DATUM",\n' +
                '                    "GUBUN": "9",\n' +
                '                    "WAERS": "WAERS",\n' +
                '                    "CHKYN": "Y",\n' +
                '                    "STAND": "STAND_NUM",\n' +
                '                    "CSEL": "CSEL_NUM",\n' +
                '                    "CBUY": "CBUY_NUM",\n' +
                '                    "TSEL": "TSEL_NUM",\n' +
                '                    "TBUY": "TBUY_NUM",\n' +
                '                    "TCHG": "TCHG_NUM",\n' +
                '                    "USCHG": "USCHG_NUM",\n' +
                '                    "CHGRE": "CHGRE_NUM"\n' +
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
        System.assertEquals('S', TestUtil.valueOf(kOutputMap, 'response.header.ifResult'));
        System.assertEquals('{{aggregation}}', TestUtil.valueOf(kOutputMap, 'response.payload.ifAggregation'));
        System.assertEquals('1', TestUtil.valueOf(kOutputMap, 'response.payload.ifRcvCnt'));
        Map<String, Object> kResMap = (Map<String, Object>)TestUtil.valueOf(kOutputMap, 'response.header');
        System.assertEquals(false, kResMap.containsKey('SYNC_IP'));
        System.assertEquals(false, kResMap.containsKey('SYNC_DT'));
        System.assertEquals(false, kResMap.containsKey('FLAG'));
        System.assertEquals(false, kResMap.containsKey('DESC'));
    }
}