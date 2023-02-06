/**
 * Created by changheekim on 2022/11/30.
 */

@IsTest
private class OpportunitySalesParts_ts {
    @TestSetup
    static void setData(){
        insert SalesTestDataUtil.getOpportunity();
        insert SalesTestDataUtil.getSalesPartsList();
        insert SalesTestDataUtil.getSalesPartsVolumeList();
    }

    @IsTest
    static void testBehavior() {
        Test.startTest();

        Opportunity opty = [
                SELECT Id, SOP__c, VehicleProject__c
                FROM Opportunity LIMIT 1
        ];

        //List<SalesParts__c> spList =[SELECT Id, StartYear__c, Usage__c, LifeCycle__c, EndYear__c FROM SalesParts__c WHERE Opportunity__c =: opty.id];

        Map<String, Object> pmap = new Map<String, Object>();
        pmap.put('recordId',opty.Id);

        ComponentResponse scr = OpportunitySalesParts.doGetSalesParts(pmap);
        OpportunitySalesParts.doGetOptyInfo(pmap);
        OpportunitySalesParts.doGetSalesPartsSummary(pmap);
        
        pmap.put('pinNumber', 'NPN-02331');
        pmap.put('usage', 1);
        pmap.put('description', 'optySalesParts Test');
        pmap.put('vehicleProject',opty.VehicleProject__c);

        OpportunitySalesParts.doCreateSalesParts(pmap);

        List<SalesPartsBase.SalesPartsWrapper> spwList = new List<SalesPartsBase.SalesPartsWrapper>();
        spwList = (List<SalesPartsBase.SalesPartsWrapper>) scr.getData('salesPartsList');

        Map<String, Object> jmap = new Map<String, Object>();
        jmap.put('description', 'jamp description Test');
        jmap.put('id', spwList[0].id);
        jmap.put('lifeCycle', spwList[0].lifeCycle);
        jmap.put('mobisTotal', spwList[0].mobisTotal);
        jmap.put('name', spwList[0].name);
        jmap.put('opportunityId', spwList[0].opportunityId);
        jmap.put('pinNumber', spwList[0].pinNumber);
        jmap.put('vehicleProjectId', spwList[0].vehicleProjectId);
        jmap.put('productId', spwList[0].productId);
        jmap.put('totalAmount', spwList[0].totalAmount);
        jmap.put('usage', spwList[0].usage);
        jmap.put('vehicleTotal', spwList[0].vehicleTotal);
        jmap.put('checked', true);
        jmap.put('className', 'sp-change');

        String jmapJson = '['+JSON.serialize(jmap)+']';

        OpportunitySalesPartsVolumeWrapper.Value kmap = new OpportunitySalesPartsVolumeWrapper.Value();
        kmap.salesPartsId = spwList[0].id;
        kmap.name = 'test kmaps';
        kmap.cost = '1';
        kmap.crRate = '0';
        kmap.mobisProductVolume = '2';
        kmap.optionRate = '100';
        kmap.relevantYear = '2023';
        kmap.totalAmount = '1';
        kmap.usage = '2';
        kmap.vehicleVolume = '1';
        kmap.yearRange = true;
        kmap.pvCurrency = '12342';

        OpportunitySalesPartsVolumeWrapper lmap = new OpportunitySalesPartsVolumeWrapper();
        lmap.key = 'Test ospv key';
        lmap.className = ' Test ospv className';
        lmap.value = kmap;

        String lmapJson = '[' +JSON.serialize(lmap)+']';


        pmap.put('removeList', jmapJson);
        pmap.put('spSaveList',jmapJson);
        pmap.put('pvSaveList',lmapJson);

        OpportunitySalesParts.doSaveSalesPartsVolumes(pmap);
        OpportunitySalesParts.doRemoveSalesParts(pmap);

        Test.stopTest();
    }
}