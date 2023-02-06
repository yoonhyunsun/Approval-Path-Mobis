/**
 * Created by changheekim on 2022/12/06.
 */

@IsTest
private class ProjectTree_ts {
    @TestSetup
    static void setData(){
        insert SalesTestDataUtil.getSalesPartsList();
        insert SalesTestDataUtil.getCombineSalesPartsVolumeList();
    }

    @IsTest
    static void testBehavior() {
        Test.startTest();

        List<VehicleProject__c> vpList = [
                SELECT Id, Name, RecordTypeId, AccountName__c
                FROM VehicleProject__c
        ];
        Map<String, Object> pmap = new Map<String, Object>();
        pmap.put('recordId',vpList[0].Id);
        ProjectTree.doGetProjectAccount(pmap);

        pmap.put('vpId', vpList[0].Id);
        ComponentResponse scr = ProjectTree.doGetProjectOpportunities(pmap);

        List<ProjectTreeUtils.OptyWrapper> optyWrapList = (List<ProjectTreeUtils.OptyWrapper>)scr.getData('optyWrapList');

        pmap.put('optyId',optyWrapList[0].id);

        ProjectTree.doGetProjectSalesParts(pmap);

        Test.stopTest();
    }
}