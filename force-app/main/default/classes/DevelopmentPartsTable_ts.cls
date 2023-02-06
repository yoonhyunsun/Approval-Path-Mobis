/**
 * Created by changheekim on 2022/12/06.
 */

@IsTest
private class DevelopmentPartsTable_ts {
    @TestSetup
    static void setData(){
        insert SalesTestDataUtil.getDevelopment();
        insert SalesTestDataUtil.getDevelopmentPartsList();
        insert SalesTestDataUtil.getDevelopmentPartsVolumeList();
    }

    @IsTest
    static void testBehavior() {
        Test.startTest();

        Development__c dev = [
                SELECT Id
                FROM Development__c LIMIT 1
        ];
        Map<String, Object> pmap = new Map<String, Object>();
        pmap.put('recordId', dev.Id);

        ComponentResponse scr = DevelopmentPartsTable.doGetDevParts(pmap);
        List<DevelopmentPartsBase.DevPartsWrapper> dpList = new List<DevelopmentPartsBase.DevPartsWrapper>();
        dpList = (List<DevelopmentPartsBase.DevPartsWrapper>) scr.getData('devPartsList');

        Map<String, Object> jmap = new Map<String, Object>();
        jmap.put('developmentId',dpList[0].developmentId);
        jmap.put('id',dpList[0].id);
        jmap.put('mobisTotal',dpList[0].mobisTotal);
        jmap.put('name',dpList[0].name);
        jmap.put('pinNumber','dpt-pn1');
        jmap.put('totalAmount',dpList[0].totalAmount);
        jmap.put('vehicleTotal',dpList[0].vehicleTotal);
        jmap.put('checked',true);
        jmap.put('description','devpartsTable test');
        jmap.put('className','dp-change');

        String jmapJson = '['+JSON.serialize(jmap)+']';

        List<DevelopmentPartsVolume__c> dpvList = [
                SELECT Id
                FROM DevelopmentPartsVolume__c
        ];
        
        DevelopmentPartsVolumesWrapper.Value kmap = new DevelopmentPartsVolumesWrapper.Value();
        kmap.id = dpvList[0].Id;
        kmap.name = 'test kmaps';
        kmap.vehicleVolume = '1';
        kmap.optionRate = '100';
        kmap.mobisProductVolume = '2';
        kmap.cost = '1';
        kmap.crRate = '0';
        kmap.totalAmount = '1';
        kmap.relevantYear = '2022';
        kmap.devPartsId = dpList[0].id;
        kmap.usage = '2';

        DevelopmentPartsVolumesWrapper lmap = new DevelopmentPartsVolumesWrapper();
        lmap.key = 'Test devp key';
        lmap.className = 'value-change';
        lmap.value = kmap;

        String lmapJson = '[' +JSON.serialize(lmap)+']';

        pmap.put('dpSaveList',jmapJson);
        pmap.put('dpvSaveList',lmapJson);
        pmap.put('removeList', jmapJson);

        DevelopmentPartsTable.doSaveDevPartsVolumes(pmap);
        DevelopmentPartsTable.doRemoveDevParts(pmap);

        Test.stopTest();
    }
}