/**
 * Created by hyodongmin on 2022/12/26.
 */

@IsTest
private class IF_IM_SFDC_HRMASTER2_ts {
    @IsTest
    static void testProcess() {
        String json = '{\n' +
                '    "BRANCH_CD": "BRANCH_CD",\n' +
                '    "BRANCH_NM": "BRANCH_NM",\n' +
                '    "DOMAIN": "D",\n' +
                '    "USER_TYPE": "USER_TYPE",\n' +
                '    "EMP_GROUP_CD": "EMP_GROUP_CD",\n' +
                '    "EMP_GROUP_NM": "EMP_GROUP_NM",\n' +
                '    "EXPAT_YN": "Y",\n' +
                '    "USER_ID": "USER_ID",\n' +
                '    "NAME": "NAME",\n' +
                '    "NAME_EN": "NAME_EN",\n' +
                '    "NAME_ZH": "NAME_ZH",\n' +
                '    "NAME_KR": "NAME_KR",\n' +
                '    "SHORT_NM": "SHORT_NM",\n' +
                '    "STATUS": "3",\n' +
                '    "RETIRE_DT": "22220111",\n' +
                '    "RETIRE_EXP_DT": "22221111",\n' +
                '    "POSITION_CD": "POSITION_CD",\n' +
                '    "POSITION_NM": "POSITION_NM",\n' +
                '    "POSITION_OUT_CD": "POSITION_OUT_CD",\n' +
                '    "POSITION_OUT_NM": "POSITION_OUT_NM",\n' +
                '    "DUTY_CD": "DUTY_CD",\n' +
                '    "DUTY_NM": "DUTY_NM",\n' +
                '    "DEPT_CD": "DEPT_CD",\n' +
                '    "DEPT_NM": "DEPT_NM",\n' +
                '    "PART_CD": "PART_CD",\n' +
                '    "PART_NM": "PART_NM",\n' +
                '    "DEPT_MGR_ID": "DEPT_MGR_ID",\n' +
                '    "SIL_MGR_ID": "SIL_MGR_ID",\n' +
                '    "EMAIL": "EMAIL",\n' +
                '    "EMAIL_EXT": "EMAIL_EXT",\n' +
                '    "MOBILE": "MOBILE",\n' +
                '    "OFFICE_TEL": "OFFICE_TEL",\n' +
                '    "PROV_DT": "22221111"\n' +
                '}';

        IF_Abstract.Input kInput = new IF_Abstract.Input();
        IF_Abstract.InputPayload inputPayload = new IF_Abstract.InputPayload();
        kInput.getPayload().t_data = new List<IF_Abstract.T_DATA>{
                new IF_IM_SFDC_HRMASTER2().deserializeOne(json)
        };

        new IF_IM_SFDC_HRMASTER2().process(kInput, null);

        //
        List<IF_IM_SFDC_HRMASTER2__c> kList = [
                SELECT BRANCH_CD__c, BRANCH_NM__c, CreatedById, CreatedDate, CurrencyIsoCode, DEPT_CD__c,
                        DEPT_MGR_ID__c, DEPT_NM__c, DOMAIN__c, DUMMY_STATUS__c, DUTY_CD__c, DUTY_NM__c,
                        EMAIL__c, EMAIL_EXT__c, EMP_GROUP_CD__c, EMP_GROUP_NM__c, EXPAT_YN__c, Id, IsDeleted, LastModifiedById,
                        LastModifiedDate, MOBILE__c, Name, NAME__c, NAME_EN__c, NAME_KR__c, NAME_ZH__c,
                        OFFICE_TEL__c, OwnerId, PART_CD__c, PART_NM__c, POSITION_CD__c, POSITION_NM__c,
                        POSITION_OUT_CD__c, POSITION_OUT_NM__c, PROV_DT__c, RETIRE_DT__c, RETIRE_EXP_DT__c, SHORT_NM__c,
                        SIL_MGR_ID__c, STATUS__c, SystemModstamp, USER_ID__c, USER_TYPE__c
                FROM IF_IM_SFDC_HRMASTER2__c
        ];

        System.assertEquals(1, kList.size());
        IF_IM_SFDC_HRMASTER2__c kData = kList[0];
        System.assertEquals('BRANCH_CD', kData.BRANCH_CD__c);
        System.assertEquals('BRANCH_NM', kData.BRANCH_NM__c);
        System.assertEquals('D', kData.DOMAIN__c);
        System.assertEquals('USER_TYPE', kData.USER_TYPE__c);
        System.assertEquals('EMP_GROUP_CD', kData.EMP_GROUP_CD__c);
        System.assertEquals('EMP_GROUP_NM', kData.EMP_GROUP_NM__c);
        System.assertEquals('Y', kData.EXPAT_YN__c);
        System.assertEquals('USER_ID', kData.USER_ID__c);
        System.assertEquals('NAME', kData.NAME__c);
        System.assertEquals('NAME_EN', kData.NAME_EN__c);
        System.assertEquals('NAME_ZH', kData.NAME_ZH__c);
        System.assertEquals('NAME_KR', kData.NAME_KR__c);
        System.assertEquals('SHORT_NM', kData.SHORT_NM__c);
        System.assertEquals('3', kData.STATUS__c);
        System.assertEquals('22220111', kData.RETIRE_DT__c);
        System.assertEquals('22221111', kData.RETIRE_EXP_DT__c);
        System.assertEquals('POSITION_CD', kData.POSITION_CD__c);
        System.assertEquals('POSITION_NM', kData.POSITION_NM__c);
        System.assertEquals('POSITION_OUT_CD', kData.POSITION_OUT_CD__c);
        System.assertEquals('POSITION_OUT_NM', kData.POSITION_OUT_NM__c);
        System.assertEquals('DUTY_CD', kData.DUTY_CD__c);
        System.assertEquals('DUTY_NM', kData.DUTY_NM__c);
        System.assertEquals('DEPT_CD', kData.DEPT_CD__c);
        System.assertEquals('DEPT_NM', kData.DEPT_NM__c);
        System.assertEquals('PART_CD', kData.PART_CD__c);
        System.assertEquals('PART_NM', kData.PART_NM__c);
        System.assertEquals('DEPT_MGR_ID', kData.DEPT_MGR_ID__c);
        System.assertEquals('SIL_MGR_ID', kData.SIL_MGR_ID__c);
        System.assertEquals('EMAIL', kData.EMAIL__c);
        System.assertEquals('EMAIL_EXT', kData.EMAIL_EXT__c);
        System.assertEquals('MOBILE', kData.MOBILE__c);
        System.assertEquals('OFFICE_TEL', kData.OFFICE_TEL__c);
        System.assertEquals('22221111', kData.PROV_DT__c);
    }
    @IsTest
    static void testGetIfId() {
        System.assertEquals('IF_IM_SFDC_HRMASTER2', new IF_IM_SFDC_HRMASTER2().getIfId());
    }
    @IsTest
    static void testDeserializeOne() {
        String json = '{\n' +
                '    "BRANCH_CD": "BRANCH_CD",\n' +
                '    "BRANCH_NM": "BRANCH_NM",\n' +
                '    "DOMAIN": "D",\n' +
                '    "USER_TYPE": "USER_TYPE",\n' +
                '    "EMP_GROUP_CD": "EMP_GROUP_CD",\n' +
                '    "EMP_GROUP_NM": "EMP_GROUP_NM",\n' +
                '    "EXPAT_YN": "Y",\n' +
                '    "USER_ID": "USER_ID",\n' +
                '    "NAME": "NAME",\n' +
                '    "NAME_EN": "NAME_EN",\n' +
                '    "NAME_ZH": "NAME_ZH",\n' +
                '    "NAME_KR": "NAME_KR",\n' +
                '    "SHORT_NM": "SHORT_NM",\n' +
                '    "STATUS": "3",\n' +
                '    "RETIRE_DT": "22220111",\n' +
                '    "RETIRE_EXP_DT": "22221111",\n' +
                '    "POSITION_CD": "POSITION_CD",\n' +
                '    "POSITION_NM": "POSITION_NM",\n' +
                '    "POSITION_OUT_CD": "POSITION_OUT_CD",\n' +
                '    "POSITION_OUT_NM": "POSITION_OUT_NM",\n' +
                '    "DUTY_CD": "DUTY_CD",\n' +
                '    "DUTY_NM": "DUTY_NM",\n' +
                '    "DEPT_CD": "DEPT_CD",\n' +
                '    "DEPT_NM": "DEPT_NM",\n' +
                '    "PART_CD": "PART_CD",\n' +
                '    "PART_NM": "PART_NM",\n' +
                '    "DEPT_MGR_ID": "DEPT_MGR_ID",\n' +
                '    "SIL_MGR_ID": "SIL_MGR_ID",\n' +
                '    "EMAIL": "EMAIL",\n' +
                '    "EMAIL_EXT": "EMAIL_EXT",\n' +
                '    "MOBILE": "MOBILE",\n' +
                '    "OFFICE_TEL": "OFFICE_TEL",\n' +
                '    "PROV_DT": "22221111"\n' +
                '}';

        IF_IM_SFDC_HRMASTER2.DataHRMaster2 kData = (IF_IM_SFDC_HRMASTER2.DataHRMaster2) new IF_IM_SFDC_HRMASTER2().deserializeOne(json);
        System.assertEquals('BRANCH_CD', kData.BRANCH_CD);
        System.assertEquals('BRANCH_NM', kData.BRANCH_NM);
        System.assertEquals('D', kData.DOMAIN);
        System.assertEquals('USER_TYPE', kData.USER_TYPE);
        System.assertEquals('EMP_GROUP_CD', kData.EMP_GROUP_CD);
        System.assertEquals('EMP_GROUP_NM', kData.EMP_GROUP_NM);
        System.assertEquals('Y', kData.EXPAT_YN);
        System.assertEquals('USER_ID', kData.USER_ID);
        System.assertEquals('NAME', kData.NAME);
        System.assertEquals('NAME_EN', kData.NAME_EN);
        System.assertEquals('NAME_ZH', kData.NAME_ZH);
        System.assertEquals('NAME_KR', kData.NAME_KR);
        System.assertEquals('SHORT_NM', kData.SHORT_NM);
        System.assertEquals('3', kData.STATUS);
        System.assertEquals('22220111', kData.RETIRE_DT);
        System.assertEquals('22221111', kData.RETIRE_EXP_DT);
        System.assertEquals('POSITION_CD', kData.POSITION_CD);
        System.assertEquals('POSITION_NM', kData.POSITION_NM);
        System.assertEquals('POSITION_OUT_CD', kData.POSITION_OUT_CD);
        System.assertEquals('POSITION_OUT_NM', kData.POSITION_OUT_NM);
        System.assertEquals('DUTY_CD', kData.DUTY_CD);
        System.assertEquals('DUTY_NM', kData.DUTY_NM);
        System.assertEquals('DEPT_CD', kData.DEPT_CD);
        System.assertEquals('DEPT_NM', kData.DEPT_NM);
        System.assertEquals('PART_CD', kData.PART_CD);
        System.assertEquals('PART_NM', kData.PART_NM);
        System.assertEquals('DEPT_MGR_ID', kData.DEPT_MGR_ID);
        System.assertEquals('SIL_MGR_ID', kData.SIL_MGR_ID);
        System.assertEquals('EMAIL', kData.EMAIL);
        System.assertEquals('EMAIL_EXT', kData.EMAIL_EXT);
        System.assertEquals('MOBILE', kData.MOBILE);
        System.assertEquals('OFFICE_TEL', kData.OFFICE_TEL);
        System.assertEquals('22221111', kData.PROV_DT);
    }
    @IsTest
    static void testIF_IM_SFDC_HRMASTER() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/IF_IM_SFDC_HRMASTER2';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueOf('{\n' +
                '    "request": {\n' +
                '        "header": {\n' +
                '            "ifTrackingId": "0002e2d0-cec3-6e84-5761-ae68b3bf20a3",\n' +
                '            "ifResult": "",\n' +
                '            "ifId": "IF_IM_SFDC_HRMASTER2",\n' +
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
                '                     "BRANCH_CD": "BRANCH_CD",\n' +
                '                     "BRANCH_NM": "BRANCH_NM",\n' +
                '                     "DOMAIN": "D",\n' +
                '                     "USER_TYPE": "USER_TYPE",\n' +
                '                     "EMP_GROUP_CD": "EMP_GROUP_CD",\n' +
                '                     "EMP_GROUP_NM": "EMP_GROUP_NM",\n' +
                '                     "EXPAT_YN": "Y",\n' +
                '                     "USER_ID": "USER_ID",\n' +
                '                     "NAME": "NAME",\n' +
                '                     "NAME_EN": "NAME_EN",\n' +
                '                     "NAME_ZH": "NAME_ZH",\n' +
                '                     "NAME_KR": "NAME_KR",\n' +
                '                     "SHORT_NM": "SHORT_NM",\n' +
                '                     "STATUS": "3",\n' +
                '                     "RETIRE_DT": "22220111",\n' +
                '                     "RETIRE_EXP_DT": "22221111",\n' +
                '                     "POSITION_CD": "POSITION_CD",\n' +
                '                     "POSITION_NM": "POSITION_NM",\n' +
                '                     "POSITION_OUT_CD": "POSITION_OUT_CD",\n' +
                '                     "POSITION_OUT_NM": "POSITION_OUT_NM",\n' +
                '                     "DUTY_CD": "DUTY_CD",\n' +
                '                     "DUTY_NM": "DUTY_NM",\n' +
                '                     "DEPT_CD": "DEPT_CD",\n' +
                '                     "DEPT_NM": "DEPT_NM",\n' +
                '                     "PART_CD": "PART_CD",\n' +
                '                     "PART_NM": "PART_NM",\n' +
                '                     "DEPT_MGR_ID": "DEPT_MGR_ID",\n' +
                '                     "SIL_MGR_ID": "SIL_MGR_ID",\n' +
                '                     "EMAIL": "EMAIL",\n' +
                '                     "EMAIL_EXT": "EMAIL_EXT",\n' +
                '                     "MOBILE": "MOBILE",\n' +
                '                     "OFFICE_TEL": "OFFICE_TEL",\n' +
                '                     "PROV_DT": "22221111"\n' +
                '                }\n' +
                '            ]\n' +
                '        }\n' +
                '    }\n' +
                '}');

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        IF_ROUTER.doPost();
        Test.stopTest();
        String str = res.responseBody.toString();
        System.debug(str);
        Map<String, Object> kOutputMap = (Map<String, Object>) JSON.deserializeUntyped(str);

        System.assertEquals('0002e2d0-cec3-6e84-5761-ae68b3bf20a3', TestUtil.valueOf(kOutputMap, 'response.header.ifTrackingId'));
        System.assertEquals('c3e1e6d7-95a3-c995-c087-a1c5cf9555da', TestUtil.valueOf(kOutputMap, 'response.payload.ifAggregation'));
        System.assertEquals('1', TestUtil.valueOf(kOutputMap, 'response.payload.ifRcvCnt'));
        System.assertEquals('', TestUtil.valueOf(kOutputMap, 'response.header.SYNC_IP'));
        System.assertEquals(14, ((String)TestUtil.valueOf(kOutputMap, 'response.header.SYNC_DT')).length());
        System.assertEquals('Y', TestUtil.valueOf(kOutputMap, 'response.header.FLAG'));
        System.assertEquals('Success', TestUtil.valueOf(kOutputMap, 'response.header.DESC'));
//        System.assertEquals('{"response":{"header":{"ifTrackingId":"0002e2d0-cec3-6e84-5761-ae68b3bf20a3","ifId":"IF_IM_SFDC_HRMASTER2","ifDateTime":"2020-09-10 17:17:38","SYNC_IP":"","SYNC_DT":"20221227114223","FLAG":"Y"},"payload":{"ifAggregation":"c3e1e6d7-95a3-c995-c087-a1c5cf9555da","ifRcvCnt":"1","t_data":[]}}}', str);
    }

//    @IsTest
//    static void testIF_IM_SFDC_HRMASTER_Limit_3000() {
//        String body = '{\n' +
//                '    "request": {\n' +
//                '        "header": {\n' +
//                '            "ifTrackingId": "0002e2d0-cec3-6e84-5761-ae68b3bf20a3",\n' +
//                '            "ifId": "IF_IM_SFDC_HRMASTER2",\n' +
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
//                '                    "USER_TYPE": "EX"\n' +
//                '                }';
//
//        IF_Abstract.RequestBody kRequestBody = (IF_Abstract.RequestBody) JSON.deserialize(body, IF_Abstract.RequestBody.class);
//        for (Integer i = 0; i < 3000; ++i) {
//            kRequestBody.getRequest().getPayload().t_data.add(new IF_IM_SFDC_HRMASTER2().deserializeOne(d));
//        }
//
//        RestRequest req = new RestRequest();
//        RestResponse res = new RestResponse();
//        req.requestURI = '/services/apexrest/IF_IM_SFDC_HRMASTER2';  //Request URL
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
                '            "ifId": "IF_IM_SFDC_HRMASTER2",\n' +
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
            kRequestBody.getRequest().getPayload().t_data.add(new IF_IM_SFDC_HRMASTER2().deserializeOne(d));
        }

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/IF_IM_SFDC_HRMASTER2';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueOf(JSON.serialize(kRequestBody));

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        IF_ROUTER.doPost();
        Test.stopTest();
        String str = res.responseBody.toString();
        System.debug(str);
        Map<String, Object> kOutputMap = (Map<String, Object>) JSON.deserializeUntyped(str);

        System.assertEquals(null, TestUtil.valueOf(kOutputMap, 'response.header.ifTrackingId')); // data parsing 중 발생하여 tracking id 확인 못함
        System.assertEquals(null, TestUtil.valueOf(kOutputMap, 'response.payload.ifAggregation'));
        System.assertEquals('', TestUtil.valueOf(kOutputMap, 'response.header.SYNC_IP'));
        System.assertEquals(14, ((String)TestUtil.valueOf(kOutputMap, 'response.header.SYNC_DT')).length());
        System.assertEquals('E', TestUtil.valueOf(kOutputMap, 'response.header.FLAG'));
        // '_reserved916' 제거된 필드로 저장됨
        System.assertEquals(true, ((String) TestUtil.valueOf(kOutputMap, 'response.header.DESC')).contains('t_data size over'));
    }
}