/**
 * Created by changheekim on 2022/12/06.
 */
@IsTest
private class ProjectTreeUtils_ts {
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
        Id platformVpId;
        Id singleVpId;

        for (VehicleProject__c vp : vpList) {
            if(vp.RecordTypeId == SalesConst.RECTYPE_SINGLE_PROJECT){
                singleVpId = vp.Id;
            }else{
                platformVpId = vp.Id;
            }
        }

        ProjectTreeUtils.getProjectAccount(singleVpId);
        ProjectTreeUtils.getVehicleProject(singleVpId);
        ProjectTreeUtils.getVehicleProject(platformVpId);
        ProjectTreeUtils.isGPlatform(platformVpId);

        ProjectTreeUtils.gPlatformOpportunities(platformVpId);
        List<ProjectTreeUtils.OptyWrapper> optyWrapList = ProjectTreeUtils.singleOpportunities(singleVpId);

        ProjectTreeUtils.gPlatformSalesParts(platformVpId);
        ProjectTreeUtils.singleSalesParts(optyWrapList[0].id, singleVpId);

        Test.stopTest();
    }
}