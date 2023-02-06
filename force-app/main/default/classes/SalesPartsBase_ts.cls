/**
 * Created by changheekim on 2022/12/05.
 */

@IsTest
private class SalesPartsBase_ts {
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


        List<SalesPartsBase.relevantYearWrapper>  relevantYearList = SalesPartsBase.getRelevantYears(opty.Id);
        SalesPartsBase.getOptyInfoMap(opty.Id);
        Map<String, Object> salesPartsMap = SalesPartsBase.getSalesParts(opty.Id);
        SalesPartsBase.getPartsVolumes(opty.Id, relevantYearList);
        SalesPartsBase.getSalesPartsSummary(opty.Id, relevantYearList);
        SalesPartsBase.getVehicleProjectInfo(opty.Id);
        SalesPartsBase.getOptyInfo(opty.Id);

        String pinNumber = 'NPN-02331';
        Decimal usage = 1;
        String description = 'SalesPartsBase Test';
        String vehicleProject = opty.VehicleProject__c;
        SalesPartsBase.createSalesParts(opty.Id, pinNumber, usage, description, vehicleProject);

        List<SalesPartsBase.SalesPartsWrapper> spwList = (List<SalesPartsBase.SalesPartsWrapper>) salesPartsMap.get('salesPartsList');
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
        List<OpportunitySalesPartsWrapper> spList = (List<OpportunitySalesPartsWrapper>) System.JSON.deserialize(jmapJson, List<OpportunitySalesPartsWrapper>.class);
        SalesPartsBase.saveSalesParts(opty.Id, spList);

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
        List<OpportunitySalesPartsVolumeWrapper> pvList = (List<OpportunitySalesPartsVolumeWrapper>) System.JSON.deserialize(lmapJson, List<OpportunitySalesPartsVolumeWrapper>.class);

        SalesPartsBase.savePartsVolumes(opty.Id, pvList);
        SalesPartsBase.removeSalesParts(opty.Id, spList);


        Test.stopTest();
    }
}