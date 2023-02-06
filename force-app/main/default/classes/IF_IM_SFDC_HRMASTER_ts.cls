/**
 * Created by hyodongmin on 2022/08/08.
 */

@IsTest
private class IF_IM_SFDC_HRMASTER_ts {
    @IsTest
    static void testProcess() {
        String json = '{\n' +
                '    "USER_TYPE": "EX",\n' +
                '    "USER_ID": "USER_ID",\n' +
                '    "USER_NM": "USER_NM",\n' +
                '    "USER_ENM": "USER_ENM",\n' +
                '    "BRANCH_CD": "BRANCH_CD",\n' +
                '    "BRANCH_NM": "BRANCH_NM",\n' +
                '    "DEPT_CD": "DEPT_CD",\n' +
                '    "DEPT_NM": "DEPT_NM",\n' +
                '    "JW_CD": "JW_CD",\n' +
                '    "JW_NM": "매니저",\n' +
                '    "JC_CD": "JC_CD",\n' +
                '    "JC_NM": "팀장",\n' +
                '    "STATUS": "3",\n' +
                '    "retire_dt": "20221122",\n' +
                '    "RESIDENT_YN": "Y",\n' +
                '    "USER_EMAIL": "asdf@asdf.a",\n' +
                '    "USER_EMAIL_EXT": "asdf.asdf@asdf.a",\n' +
                '    "USER_MOBILE": "USER_MOBILE",\n' +
                '    "IFJOBNUMBER": "2012-11-22"\n' +
                '}';

        IF_Abstract.Input kInput = new IF_Abstract.Input();
        IF_Abstract.InputPayload inputPayload = new IF_Abstract.InputPayload();
        kInput.getPayload().t_data = new List<IF_Abstract.T_DATA>{
                new IF_IM_SFDC_HRMASTER().deserializeOne(json)
        };

        new IF_IM_SFDC_HRMASTER().process(kInput, null);

        //
        List<IF_IM_SFDC_HRMASTER__c> kList = [
                SELECT UserType__c, UserID__c, UserNm__c, UserENm__c, BranchCd__c, BranchNm__c, DeptCd__c,
                        DeptNm__c, JwCd__c, JwNm__c, JcCd__c, JcNm__c, Status__c, RetireDt__c, IsResidentYn__c, UserEmail__c, UserEmailExt__c,
                        UserMobile__c, IfJobNumber__c
                FROM IF_IM_SFDC_HRMASTER__c
        ];

        System.assertEquals(1, kList.size());
        IF_IM_SFDC_HRMASTER__c kData = kList[0];
        System.assertEquals('EX', kData.UserType__c);
        System.assertEquals('USER_ID', kData.UserID__c);
        System.assertEquals('USER_NM', kData.UserNm__c);
        System.assertEquals('USER_ENM', kData.UserENm__c);
        System.assertEquals('BRANCH_CD', kData.BranchCd__c);
        System.assertEquals('BRANCH_NM', kData.BranchNm__c);
        System.assertEquals('DEPT_CD', kData.DeptCd__c);
        System.assertEquals('DEPT_NM', kData.DeptNm__c);
        System.assertEquals('JW_CD', kData.JwCd__c);
        System.assertEquals('매니저', kData.JwNm__c);
        System.assertEquals('JC_CD', kData.JcCd__c);
        System.assertEquals('팀장', kData.JcNm__c);
        System.assertEquals('3', kData.Status__c);
        System.assertEquals('20221122', kData.RetireDt__c);
        System.assertEquals('Y', kData.IsResidentYn__c);
        System.assertEquals('asdf@asdf.a', kData.UserEmail__c);
        System.assertEquals('asdf.asdf@asdf.a', kData.UserEmailExt__c);
        System.assertEquals('USER_MOBILE', kData.UserMobile__c);
        System.assertEquals('2012-11-22', kData.IfJobNumber__c);
    }
    @IsTest
    static void testGetIfId() {
        System.assertEquals('IF_IM_SFDC_HRMASTER', new IF_IM_SFDC_HRMASTER().getIfId());
    }
    @IsTest
    static void testDeserializeOne() {
        String json = '{\n' +
                '    "USER_TYPE": "EX",\n' +
                '    "USER_ID": "USER_ID",\n' +
                '    "USER_NM": "USER_NM",\n' +
                '    "USER_ENM": "USER_ENM",\n' +
                '    "BRANCH_CD": "BRANCH_CD",\n' +
                '    "BRANCH_NM": "BRANCH_NM",\n' +
                '    "DEPT_CD": "DEPT_CD",\n' +
                '    "DEPT_NM": "DEPT_NM",\n' +
                '    "JW_CD": "JW_CD",\n' +
                '    "JW_NM": "매니저",\n' +
                '    "JC_CD": "JC_CD",\n' +
                '    "JC_NM": "팀장",\n' +
                '    "STATUS": "3",\n' +
                '    "retire_dt": "20221122",\n' +
                '    "RESIDENT_YN": "Y",\n' +
                '    "USER_EMAIL": "asdf@asdf.a",\n' +
                '    "USER_EMAIL_EXT": "asdf.asdf@asdf.a",\n' +
                '    "USER_MOBILE": "USER_MOBILE",\n' +
                '    "IFJOBNUMBER": "2012-11-22"\n' +
                '}';

        IF_IM_SFDC_HRMASTER.DataHRMaster kData = (IF_IM_SFDC_HRMASTER.DataHRMaster) new IF_IM_SFDC_HRMASTER().deserializeOne(json);
        System.assertEquals('EX', kData.USER_TYPE);
        System.assertEquals('USER_ID', kData.USER_ID);
        System.assertEquals('USER_NM', kData.USER_NM);
        System.assertEquals('USER_ENM', kData.USER_ENM);
        System.assertEquals('BRANCH_CD', kData.BRANCH_CD);
        System.assertEquals('BRANCH_NM', kData.BRANCH_NM);
        System.assertEquals('DEPT_CD', kData.DEPT_CD);
        System.assertEquals('DEPT_NM', kData.DEPT_NM);
        System.assertEquals('JW_CD', kData.JW_CD);
        System.assertEquals('매니저', kData.JW_NM);
        System.assertEquals('JC_CD', kData.JC_CD);
        System.assertEquals('팀장', kData.JC_NM);
        System.assertEquals('3', kData.STATUS);
        System.assertEquals('20221122', kData.RETIRE_DT);
        System.assertEquals('Y', kData.RESIDENT_YN);
        System.assertEquals('asdf@asdf.a', kData.USER_EMAIL);
        System.assertEquals('asdf.asdf@asdf.a', kData.USER_EMAIL_EXT);
        System.assertEquals('USER_MOBILE', kData.USER_MOBILE);
        System.assertEquals('2012-11-22', kData.IFJOBNUMBER);
    }
    @IsTest
    static void testIF_IM_SFDC_HRMASTER() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/IF_IM_SFDC_HRMASTER';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueOf('{\n' +
                '    "request": {\n' +
                '        "header": {\n' +
                '            "ifTrackingId": "0002e2d0-cec3-6e84-5761-ae68b3bf20a3",\n' +
                '            "ifResult": "",\n' +
                '            "ifId": "IF_IM_SFDC_HRMASTER",\n' +
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
                '                    "USER_TYPE": "EX",\n' +
                '                    "USER_ID": "USER_ID",\n' +
                '                    "USER_NM": "USER_NM",\n' +
                '                    "USER_ENM": "USER_ENM",\n' +
                '                    "BRANCH_CD": "BRANCH_CD",\n' +
                '                    "BRANCH_NM": "BRANCH_NM",\n' +
                '                    "DEPT_CD": "DEPT_CD",\n' +
                '                    "DEPT_NM": "DEPT_NM",\n' +
                '                    "JW_CD": "JW_CD",\n' +
                '                    "JW_NM": "매니저",\n' +
                '                    "JC_CD": "JC_CD",\n' +
                '                    "JC_NM": "팀장",\n' +
                '                    "STATUS": "3",\n' +
                '                    "retire_dt": "20221122",\n' +
                '                    "RESIDENT_YN": "Y",\n' +
                '                    "USER_EMAIL": "asdf@asdf.a",\n' +
                '                    "USER_EMAIL_EXT": "asdf.asdf@asdf.a",\n' +
                '                    "USER_MOBILE": "USER_MOBILE",\n' +
                '                    "IFJOBNUMBER": "2012-11-22"\n' +
                '                }\n' +
                '            ]\n' +
                '        }\n' +
                '    }\n' +
                '}');

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        IF_ROUTER.doPost();
        Map<String, Object> kOutputMap = (Map<String, Object>) JSON.deserializeUntyped(res.responseBody.toString());
        Test.stopTest();

        System.assertEquals('0002e2d0-cec3-6e84-5761-ae68b3bf20a3', TestUtil.valueOf(kOutputMap, 'response.header.ifTrackingId'));
        System.assertEquals('c3e1e6d7-95a3-c995-c087-a1c5cf9555da', TestUtil.valueOf(kOutputMap, 'response.payload.ifAggregation'));
        System.assertEquals('1', TestUtil.valueOf(kOutputMap, 'response.payload.ifRcvCnt'));
        Map<String, Object> kResMap = (Map<String, Object>)TestUtil.valueOf(kOutputMap, 'response.header');
        System.assertEquals(false, kResMap.containsKey('SYNC_IP'));
        System.assertEquals(false, kResMap.containsKey('SYNC_DT'));
        System.assertEquals(false, kResMap.containsKey('FLAG'));
        System.assertEquals(false, kResMap.containsKey('DESC'));
    }

//    @IsTest
//    static void testIF_IM_SFDC_HRMASTER_Limit_3000() {
//        String body = '{\n' +
//                '    "request": {\n' +
//                '        "header": {\n' +
//                '            "ifTrackingId": "0002e2d0-cec3-6e84-5761-ae68b3bf20a3",\n' +
//                '            "ifId": "IF_IM_SFDC_HRMASTER",\n' +
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
//                        '                    "USER_TYPE": "EX"\n' +
//                        '                }';
//
//        IF_Abstract.RequestBody kRequestBody = (IF_Abstract.RequestBody) JSON.deserialize(body, IF_Abstract.RequestBody.class);
//        for (Integer i = 0; i < 3000; ++i) {
//            kRequestBody.getRequest().getPayload().t_data.add(new IF_IM_SFDC_HRMASTER().deserializeOne(d));
//        }
//
//        RestRequest req = new RestRequest();
//        RestResponse res = new RestResponse();
//        req.requestURI = '/services/apexrest/IF_IM_SFDC_HRMASTER';  //Request URL
//        req.httpMethod = 'POST';//HTTP Request Type
//        req.requestBody = Blob.valueOf(JSON.serialize(kRequestBody));
//
//        RestContext.request = req;
//        RestContext.response = res;
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
    static void testIF_IM_SFDC_HRMASTER_Limit_error() {
        String body = '{\n' +
                '    "request": {\n' +
                '        "header": {\n' +
                '            "ifTrackingId": "0002e2d0-cec3-6e84-5761-ae68b3bf20a3",\n' +
                '            "ifId": "IF_IM_SFDC_HRMASTER",\n' +
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
                        '                    "USER_TYPE": "EX"\n' +
                        '                }';

        IF_Abstract.RequestBody kRequestBody = (IF_Abstract.RequestBody) JSON.deserialize(body, IF_Abstract.RequestBody.class);
        for (Integer i = 0; i < 3001; ++i) {
            kRequestBody.getRequest().getPayload().t_data.add(new IF_IM_SFDC_HRMASTER().deserializeOne(d));
        }

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/IF_IM_SFDC_HRMASTER';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueOf(JSON.serialize(kRequestBody));

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        IF_ROUTER.doPost();
        Map<String, Object> kOutputMap = (Map<String, Object>) JSON.deserializeUntyped(res.responseBody.toString());
        Test.stopTest();

        System.assertEquals(null, TestUtil.valueOf(kOutputMap, 'response.header.ifTrackingId')); // data parsing 중 발생하여 tracking id 확인 못함
        System.assertEquals(null, TestUtil.valueOf(kOutputMap, 'response.payload.ifAggregation'));
        System.assertEquals('E', TestUtil.valueOf(kOutputMap, 'response.header.ifResult'));
        System.assertEquals(true, ((String) TestUtil.valueOf(kOutputMap, 'response.header.ifMessage')).contains('t_data size over'));
        Map<String, Object> kResMap = (Map<String, Object>)TestUtil.valueOf(kOutputMap, 'response.header');
        System.assertEquals(false, kResMap.containsKey('SYNC_IP'));
        System.assertEquals(false, kResMap.containsKey('SYNC_DT'));
        System.assertEquals(false, kResMap.containsKey('FLAG'));
        System.assertEquals(false, kResMap.containsKey('DESC'));
    }
}