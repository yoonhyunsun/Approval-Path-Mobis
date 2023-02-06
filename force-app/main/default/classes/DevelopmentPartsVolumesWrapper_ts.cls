/**
 * Created by changheekim on 2022/11/28.
 */

@IsTest
private class DevelopmentPartsVolumesWrapper_ts {
    @IsTest
    static void testBehavior() {

        DevelopmentPartsVolumesWrapper.Value dpvValue = new DevelopmentPartsVolumesWrapper.Value();
        dpvValue.name = 'test dpvValue';
        dpvValue.cost = '1';
        dpvValue.crRate = '0';
        dpvValue.mobisProductVolume = '2';
        dpvValue.optionRate = '100';
        dpvValue.relevantYear = '2002';
        dpvValue.devPartsId = null;
        dpvValue.totalAmount = '1';
        dpvValue.usage = '2';
        dpvValue.vehicleVolume = '1';
        

        DevelopmentPartsVolumesWrapper dpv =  new DevelopmentPartsVolumesWrapper();
        dpv.key = 'Test dpv key';
        dpv.className = ' Test dpv className';
        dpv.value = dpvValue;

        String json = JSON.serialize(dpv);
        DevelopmentPartsVolumesWrapper obj = DevelopmentPartsVolumesWrapper.parse(json);
        System.debug(obj);
        
    }
}