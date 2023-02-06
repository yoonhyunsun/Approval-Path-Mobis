/**
 * Created by changheekim on 2022/11/28.
 */

@IsTest
private class DevelopmentPartsWrapper_ts {
    @IsTest
    static void testBehavior() {
        DevelopmentPartsWrapper dpw = new DevelopmentPartsWrapper();
        dpw.description = 'test dpw.description';
        dpw.mobisTotal = 1;
        dpw.name ='test dpw.name';
        dpw.developmentId = null;
        dpw.pinNumber= 'test dpw.pinNumber';
        dpw.totalAmount = '1';
        dpw.vehicleTotal = 1;
        dpw.checked = 'false';
        dpw.className = 'value-change';

        String json = JSON.serialize(dpw);
        DevelopmentPartsWrapper obj = DevelopmentPartsWrapper.parse(json);
        System.debug(obj);
    }
}