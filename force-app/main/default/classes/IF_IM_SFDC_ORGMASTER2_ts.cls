/**
 * Created by hyodongmin on 2022/12/26.
 */

@IsTest
private class IF_IM_SFDC_ORGMASTER2_ts {
    @IsTest
    static void testProcess() {
        String json = '{\n' +
                '    "BRANCH_CD": "BRANCH_CD",\n' +
                '    "DEPT_CD": "DEPT_CD",\n' +
                '    "BRANCH_NM": "BRANCH_NM",\n' +
                '    "DEPT_NM": "DEPT_NM",\n' +
                '    "PARENT_DEPT_CD": "PARENT_DEPT_CD",\n' +
                '    "DEPT_NM_EN": "DEPT_NM_EN",\n' +
                '    "DEPT_LVL_CD": "10",\n' +
                '    "DEPT_LVL_NM": "DEPT_LVL_NM",\n' +
                '    "MGR_ID": "MGR_ID",\n' +
                '    "ENDDT": "22221111",\n' +
                '    "DISPLAY": "Y",\n' +
                '    "PROV_DT": "PROV_DT"\n' +
                '}';

        IF_Abstract.Input kInput = new IF_Abstract.Input();
        IF_Abstract.InputPayload inputPayload = new IF_Abstract.InputPayload();
        kInput.getPayload().t_data = new List<IF_Abstract.T_DATA>{
                new IF_IM_SFDC_ORGMASTER2().deserializeOne(json)
        };

        new IF_IM_SFDC_ORGMASTER2().process(kInput, null);

        //
        List<IF_IM_SFDC_ORGMASTER2__c> kList = [
                SELECT BRANCH_CD__c, BRANCH_NM__c, CreatedById, CreatedDate, CurrencyIsoCode, DEPT_LVL_NM__c,
                        DEPT_CD__c, DEPT_LVL_CD__c, DEPT_NM__c, DEPT_NM_EN__c, DISPLAY__c, DUMMY_STATUS__c, ENDDT__c,
                        Id, IsDeleted, LastModifiedById, LastModifiedDate, MGR_ID__c, Name,
                        OwnerId, PARENT_DEPT_CD__c, PROV_DT__c, SystemModstamp
                FROM IF_IM_SFDC_ORGMASTER2__c];

        System.assertEquals(1, kList.size());
        IF_IM_SFDC_ORGMASTER2__c kData = kList[0];
        System.assertEquals('BRANCH_CD', kData.BRANCH_CD__c);
        System.assertEquals('DEPT_CD', kData.DEPT_CD__c);
        System.assertEquals('BRANCH_NM', kData.BRANCH_NM__c);
        System.assertEquals('DEPT_NM', kData.DEPT_NM__c);
        System.assertEquals('PARENT_DEPT_CD', kData.PARENT_DEPT_CD__c);
        System.assertEquals('DEPT_NM_EN', kData.DEPT_NM_EN__c);
        System.assertEquals('10', kData.DEPT_LVL_CD__c);
        System.assertEquals('DEPT_LVL_NM', kData.DEPT_LVL_NM__c);
        System.assertEquals('MGR_ID', kData.MGR_ID__c);
        System.assertEquals('22221111', kData.ENDDT__c);
        System.assertEquals('Y', kData.DISPLAY__c);
        System.assertEquals('PROV_DT', kData.PROV_DT__c);
    }
    @IsTest
    static void testGetIfId() {
        System.assertEquals('IF_IM_SFDC_ORGMASTER2', new IF_IM_SFDC_ORGMASTER2().getIfId());
    }
    @IsTest
    static void testDeserializeOne() {
        String json = '{\n' +
                '    "BRANCH_CD": "BRANCH_CD",\n' +
                '    "DEPT_CD": "DEPT_CD",\n' +
                '    "BRANCH_NM": "BRANCH_NM",\n' +
                '    "DEPT_NM": "DEPT_NM",\n' +
                '    "PARENT_DEPT_CD": "PARENT_DEPT_CD",\n' +
                '    "DEPT_NM_EN": "DEPT_NM_EN",\n' +
                '    "DEPT_LVL_CD": "10",\n' +
                '    "DEPT_LVL_NM": "DEPT_LVL_NM",\n' +
                '    "MGR_ID": "MGR_ID",\n' +
                '    "ENDDT": "22221111",\n' +
                '    "DISPLAY": "Y",\n' +
                '    "PROV_DT": "PROV_DT"\n' +
                '}';

        IF_IM_SFDC_ORGMASTER2.DataOrgMaster2 kData = (IF_IM_SFDC_ORGMASTER2.DataOrgMaster2) new IF_IM_SFDC_ORGMASTER2().deserializeOne(json);
        System.assertEquals('BRANCH_CD', kData.BRANCH_CD);
        System.assertEquals('DEPT_CD', kData.DEPT_CD);
        System.assertEquals('BRANCH_NM', kData.BRANCH_NM);
        System.assertEquals('DEPT_NM', kData.DEPT_NM);
        System.assertEquals('PARENT_DEPT_CD', kData.PARENT_DEPT_CD);
        System.assertEquals('DEPT_NM_EN', kData.DEPT_NM_EN);
        System.assertEquals('10', kData.DEPT_LVL_CD);
        System.assertEquals('DEPT_LVL_NM', kData.DEPT_LVL_NM);
        System.assertEquals('MGR_ID', kData.MGR_ID);
        System.assertEquals('22221111', kData.ENDDT);
        System.assertEquals('Y', kData.DISPLAY);
        System.assertEquals('PROV_DT', kData.PROV_DT);
    }
    @IsTest
    static void testIF_IM_SFDC_ORGMASTER() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/IF_IM_SFDC_ORGMASTER2';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueOf('{\n' +
                '    "request": {\n' +
                '        "header": {\n' +
                '            "ifTrackingId": "0002e2d0-cec3-6e84-5761-ae68b3bf20a3",\n' +
                '            "ifResult": "",\n' +
                '            "ifId": "IF_IM_SFDC_ORGMASTER2",\n' +
                '            "ifFailMsg": "",\n' +
                '            "ifFailCode": "",\n' +
                '            "ifDateTime": "2020-09-10 17:17:38"\n' +
                '        },\n' +
                '        "payload": {\n' +
                '            "ifAggregation": "c3e1e6d7-95a3-c995-c087-a1c5cf9555da",\n' +
                '            "ifTotCnt": "1",\n' +
                '            "ifSplitCnt": "1",\n' +
                '            "ifSplitSeq": "1",\n' +
                '            "t_data": [\n' +
                '                {\n' +
                '    "BRANCH_CD": "BRANCH_CD",\n' +
                '    "DEPT_CD": "DEPT_CD",\n' +
                '    "BRANCH_NM": "BRANCH_NM",\n' +
                '    "DEPT_NM": "DEPT_NM",\n' +
                '    "PARENT_DEPT_CD": "PARENT_DEPT_CD",\n' +
                '    "DEPT_NM_EN": "DEPT_NM_EN",\n' +
                '    "DEPT_LVL_CD": "10",\n' +
                '    "DEPT_LVL_NM": "DEPT_LVL_NM",\n' +
                '    "MGR_ID": "MGR_ID",\n' +
                '    "ENDDT": "22221111",\n' +
                '    "DISPLAY": "Y",\n' +
                '    "PROV_DT": "PROV_DT"\n' +
                '                },\n' +
                '                {\n' +
                '    "BRANCH_CD": "BRANCH_CD",\n' +
                '    "DEPT_CD": "DEPT_CD",\n' +
                '    "BRANCH_NM": "BRANCH_NM",\n' +
                '    "DEPT_NM": "DEPT_NM",\n' +
                '    "PARENT_DEPT_CD": "PARENT_DEPT_CD",\n' +
                '    "DEPT_NM_EN": "DEPT_NM_EN",\n' +
                '    "DEPT_LVL_CD": "10",\n' +
                '    "DEPT_LVL_NM": "DEPT_LVL_NM",\n' +
                '    "MGR_ID": "MGR_ID",\n' +
                '    "ENDDT": "22221111",\n' +
                '    "DISPLAY": "Y",\n' +
                '    "PROV_DT": "PROV_DT"\n' +
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

        System.assertEquals('0002e2d0-cec3-6e84-5761-ae68b3bf20a3', TestUtil.valueOf(kOutputMap, 'response.header.ifTrackingId'));
        System.assertEquals('c3e1e6d7-95a3-c995-c087-a1c5cf9555da', TestUtil.valueOf(kOutputMap, 'response.payload.ifAggregation'));
        System.assertEquals('2', TestUtil.valueOf(kOutputMap, 'response.payload.ifRcvCnt'));
    }

//    @IsTest
//    static void testIF_IM_SFDC_ORGMASTER_limit_3000() {
//        String body = '{\n' +
//                '    "request": {\n' +
//                '        "header": {\n' +
//                '            "ifTrackingId": "0002e2d0-cec3-6e84-5761-ae68b3bf20a3",\n' +
//                '            "ifResult": "",\n' +
//                '            "ifId": "IF_IM_SFDC_ORGMASTER2",\n' +
//                '            "ifFailMsg": "",\n' +
//                '            "ifFailCode": "",\n' +
//                '            "ifDateTime": "2020-09-10 17:17:38"\n' +
//                '        },\n' +
//                '        "payload": {\n' +
//                '            "ifAggregation": "c3e1e6d7-95a3-c995-c087-a1c5cf9555da",\n' +
//                '            "ifTotCnt": "1",\n' +
//                '            "ifSplitCnt": "1",\n' +
//                '            "ifSplitSeq": "1",\n' +
//                '            "t_data": [\n' +
//                '            ]\n' +
//                '        }\n' +
//                '    }\n' +
//                '}';
//        String d =
//                '                {\n' +
//                        '                    "BRANCH_CD": "BRANCH_CD"\n' +
//                        '                }';
//
//        IF_Abstract.RequestBody kRequestBody = (IF_Abstract.RequestBody) JSON.deserialize(body, IF_Abstract.RequestBody.class);
//        for (Integer i = 0; i < 3000; ++i) {
//            kRequestBody.getRequest().getPayload().t_data.add(new IF_IM_SFDC_HRMASTER2().deserializeOne(d));
//        }
//
//        RestRequest req = new RestRequest();
//        RestResponse res = new RestResponse();
//        req.requestURI = '/services/apexrest/IF_IM_SFDC_ORGMASTER2';  //Request URL
//        req.httpMethod = 'POST';//HTTP Request Type
//        req.requestBody = Blob.valueOf(JSON.serialize(kRequestBody));
//
//        RestContext.request = req;
//        RestContext.response= res;
//
//        Test.startTest();
//        IF_ROUTER.doPost();
//        Map<String, Object> kOutputMap = (Map<String, Object>) JSON.deserializeUntyped(res.responseBody.toString());
//        Test.stopTest();
//
//        System.assertEquals('0002e2d0-cec3-6e84-5761-ae68b3bf20a3', TestUtil.valueOf(kOutputMap, 'response.header.ifTrackingId'));
//        System.assertEquals('c3e1e6d7-95a3-c995-c087-a1c5cf9555da', TestUtil.valueOf(kOutputMap, 'response.payload.ifAggregation'));
//        System.assertEquals('3000', TestUtil.valueOf(kOutputMap, 'response.payload.ifRcvCnt'));
//    }
    @IsTest
    static void testIF_IM_SFDC_ORGMASTER_limit_over() {
        String body = '{\n' +
                '    "request": {\n' +
                '        "header": {\n' +
                '            "ifTrackingId": "0002e2d0-cec3-6e84-5761-ae68b3bf20a3",\n' +
                '            "ifResult": "",\n' +
                '            "ifId": "IF_IM_SFDC_ORGMASTER2",\n' +
                '            "ifFailMsg": "",\n' +
                '            "ifFailCode": "",\n' +
                '            "ifDateTime": "2020-09-10 17:17:38"\n' +
                '        },\n' +
                '        "payload": {\n' +
                '            "ifAggregation": "c3e1e6d7-95a3-c995-c087-a1c5cf9555da",\n' +
                '            "ifTotCnt": "1",\n' +
                '            "ifSplitCnt": "1",\n' +
                '            "ifSplitSeq": "1",\n' +
                '            "t_data": [\n' +
                '            ]\n' +
                '        }\n' +
                '    }\n' +
                '}';
        String d =
                '                {\n' +
                        '                    "BRANCH_CD": "BRANCH_CD"\n' +
                        '                }';

        IF_Abstract.RequestBody kRequestBody = (IF_Abstract.RequestBody) JSON.deserialize(body, IF_Abstract.RequestBody.class);
        for (Integer i = 0; i < 3001; ++i) {
            kRequestBody.getRequest().getPayload().t_data.add(new IF_IM_SFDC_HRMASTER2().deserializeOne(d));
        }

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/IF_IM_SFDC_ORGMASTER2';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueOf(JSON.serialize(kRequestBody));

        RestContext.request = req;
        RestContext.response= res;

        Test.startTest();
        IF_ROUTER.doPost();
        Map<String, Object> kOutputMap = (Map<String, Object>) JSON.deserializeUntyped(res.responseBody.toString());
        Test.stopTest();

        System.assertEquals(null, TestUtil.valueOf(kOutputMap, 'response.header.ifTrackingId'));
        System.assertEquals(null, TestUtil.valueOf(kOutputMap, 'response.payload.ifAggregation'));
        System.assertEquals(null, TestUtil.valueOf(kOutputMap, 'response.payload.ifRcvCnt'));
        System.assertEquals('E', TestUtil.valueOf(kOutputMap, 'response.header.ifResult'));
        System.assertEquals(true, ((String) TestUtil.valueOf(kOutputMap, 'response.header.ifMessage')).contains('t_data size over'));
    }
}