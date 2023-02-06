/**
 * Created by changheekim on 2022/11/28.
 */

@IsTest
private class OpportunitySalesPartsWrapper_ts {
    @IsTest
    static void testBehavior() {

        OpportunitySalesPartsWrapper osp = new OpportunitySalesPartsWrapper();

        osp.description = 'test osp.description';
        osp.lifeCycle = 1;
        osp.mobisTotal = 1;
        osp.name ='test osp.name';
        osp.opportunityId = null;
        osp.pinNumber= 'test osp.pinNumber';
        osp.vehicleProjectId = null;
        osp.productId = null;
        osp.totalAmount = '1';
        osp.usage = 1;
        osp.vehicleTotal = 1;
        osp.checked = false;
        osp.className = 'value-change';

        String json = JSON.serialize(osp);
        OpportunitySalesPartsWrapper obj = OpportunitySalesPartsWrapper.parse(json);
        System.debug(obj);
    }
}