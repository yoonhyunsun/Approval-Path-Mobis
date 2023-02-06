/**
 * Created by changheekim on 2022/11/28.
 */

@IsTest
private class OpportunitySalesPartsVolumeWrapper_ts {
    @IsTest
    static void testBehavior() {

        OpportunitySalesPartsVolumeWrapper.Value ospvValue = new OpportunitySalesPartsVolumeWrapper.Value();
        ospvValue.name = 'test ospvValue';
        ospvValue.cost = '1';
        ospvValue.crRate = '0';
        ospvValue.mobisProductVolume = '2';
        ospvValue.optionRate = '100';
        ospvValue.relevantYear = '2002';
        ospvValue.salesPartsId = null;
        ospvValue.totalAmount = '1';
        ospvValue.usage = '2';
        ospvValue.vehicleVolume = '1';
        ospvValue.yearRange = false;
        ospvValue.pvCurrency = '12342';


        OpportunitySalesPartsVolumeWrapper ospv =  new OpportunitySalesPartsVolumeWrapper();
        ospv.key = 'Test ospv key';
        ospv.className = ' Test ospv className';
        ospv.value = ospvValue;

        String json = JSON.serialize(ospv);
        OpportunitySalesPartsVolumeWrapper obj = OpportunitySalesPartsVolumeWrapper.parse(json);
        System.debug(obj);
    }
}