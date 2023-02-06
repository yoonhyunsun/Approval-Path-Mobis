/**
 * Created by hyodongmin on 2022/08/08.
 */

@IsTest
private class IF_IM_SFDC_ORGMASTER_ts {
    @IsTest
    static void testProcess() {
        String json = '{\n' +
                '    "BRANCHCODE": "BRANCHCODE",\n' +
                '    "OBJID": "OBJID",\n' +
                '    "DEPTH": "DEPTH",\n' +
                '    "BRANCHNAME": "BRANCHNAME",\n' +
                '    "PAR_OBJID": "PAR_OBJID",\n' +
                '    "STEXT": "STEXT",\n' +
                '    "mgr_id": "MGR_ID",\n' +
                '    "DISPLAY": "Y"\n' +
                '}';

        IF_Abstract.Input kInput = new IF_Abstract.Input();
        IF_Abstract.InputPayload inputPayload = new IF_Abstract.InputPayload();
        kInput.getPayload().t_data = new List<IF_Abstract.T_DATA>{
                new IF_IM_SFDC_ORGMASTER().deserializeOne(json)
        };

        new IF_IM_SFDC_ORGMASTER().process(kInput, null);

        // 
        List<IF_IM_SFDC_ORGMASTER__c> kList = [SELECT BranchCode__c, Objid__c, Depth__c, BranchName__c, ParObjid__c,
                Stext__c, MgrId__c, IsDisplay__c FROM IF_IM_SFDC_ORGMASTER__c];

        System.assertEquals(1, kList.size());
        IF_IM_SFDC_ORGMASTER__c kData = kList[0];
        System.assertEquals('BRANCHCODE', kData.BranchCode__c);
        System.assertEquals('OBJID', kData.Objid__c);
        System.assertEquals('DEPTH', kData.Depth__c);
        System.assertEquals('BRANCHNAME', kData.BranchName__c);
        System.assertEquals('PAR_OBJID', kData.ParObjid__c);
        System.assertEquals('STEXT', kData.Stext__c);
        System.assertEquals('MGR_ID', kData.MgrId__c);
        System.assertEquals('Y', kData.IsDisplay__c);
    }
    @IsTest
    static void testGetIfId() {
        System.assertEquals('IF_IM_SFDC_ORGMASTER', new IF_IM_SFDC_ORGMASTER().getIfId());
    }
    @IsTest
    static void testDeserializeOne() {
        String json = '{\n' +
                '    "BRANCHCODE": "BRANCHCODE",\n' +
                '    "OBJID": "OBJID",\n' +
                '    "DEPTH": "DEPTH",\n' +
                '    "BRANCHNAME": "BRANCHNAME",\n' +
                '    "PAR_OBJID": "PAR_OBJID",\n' +
                '    "STEXT": "STEXT",\n' +
                '    "mgr_id": "MGR_ID",\n' +
                '    "DISPLAY": "Y"\n' +
                '}';

        IF_IM_SFDC_ORGMASTER.DataOrgMaster kData = (IF_IM_SFDC_ORGMASTER.DataOrgMaster) new IF_IM_SFDC_ORGMASTER().deserializeOne(json);
        System.assertEquals('BRANCHCODE', kData.BRANCHCODE);
        System.assertEquals('OBJID', kData.OBJID);
        System.assertEquals('DEPTH', kData.DEPTH);
        System.assertEquals('BRANCHNAME', kData.BRANCHNAME);
        System.assertEquals('PAR_OBJID', kData.PAR_OBJID);
        System.assertEquals('STEXT', kData.STEXT);
        System.assertEquals('MGR_ID', kData.MGR_ID);
        System.assertEquals('Y', kData.DISPLAY);
    }
    @IsTest
    static void testIF_IM_SFDC_ORGMASTER() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/IF_IM_SFDC_ORGMASTER';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueOf('{\n' +
                '    "request": {\n' +
                '        "header": {\n' +
                '            "ifTrackingId": "0002e2d0-cec3-6e84-5761-ae68b3bf20a3",\n' +
                '            "ifResult": "",\n' +
                '            "ifId": "IF_IM_SFDC_ORGMASTER",\n' +
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
                '                    "BRANCHCODE": "BRANCHCODE",\n' +
                '                    "OBJID": "OBJID",\n' +
            '                        "DEPTH": "DEPTH",\n' +
                '                    "BRANCHNAME": "BRANCHNAME",\n' +
                '                    "PAR_OBJID": "PAR_OBJID",\n' +
                '                    "STEXT": "STEXT",\n' +
                '                    "mgr_id": "MGR_ID",\n' +
                '                    "DISPLAY": "Y"\n' +
                '                },\n' +
                '                {\n' +
                '                    "BRANCHCODE": "BRANCHCODE",\n' +
                '                    "OBJID": "OBJID",\n' +
                '                    "DEPTH": "DEPTH",\n' +
                '                    "BRANCHNAME": "BRANCHNAME",\n' +
                '                    "PAR_OBJID": "PAR_OBJID",\n' +
                '                    "STEXT": "STEXT",\n' +
                '                    "mgr_id": "MGR_ID",\n' +
                '                    "DISPLAY": "N"\n' +
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
        Map<String, Object> kResMap = (Map<String, Object>)TestUtil.valueOf(kOutputMap, 'response.header');
        System.assertEquals(false, kResMap.containsKey('SYNC_IP'));
        System.assertEquals(false, kResMap.containsKey('SYNC_DT'));
        System.assertEquals(false, kResMap.containsKey('FLAG'));
        System.assertEquals(false, kResMap.containsKey('DESC'));
    }
}