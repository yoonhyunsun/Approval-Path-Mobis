/**
 * Created by changheekim on 2022/12/05.
 */

@IsTest
private class EngineeringChangeRequest_tr_ts {
    @TestSetup
    static void setData(){
        insert SalesTestDataUtil.getDevelopment();
        insert SalesTestDataUtil.getDevelopmentPartsList();
        insert SalesTestDataUtil.getDevelopmentPartsVolumeList();
        insert SalesTestDataUtil.getEcrList();
        insert SalesTestDataUtil.getEcpList();
    }
    @IsTest
    static void testBehavior() {
        Test.startTest();
        List<EngineeringChangeRequest__c> ecrList = [
                SELECT Id, Development__c, Description__c, fm_SourcingToolingCost__c,
                        PN1__c, PN2__c, SourcingPiecePrice1__c, SourcingPiecePrice2__c
                FROM EngineeringChangeRequest__c];

        Set<String> ecrIdSet = new Set<String>();

        for (EngineeringChangeRequest__c ecr : ecrList) {
            System.debug(ecr);
            ecrIdSet.add(ecr.Id);
        }

        List<EngineeringChangeProposal__c> ecpList = [
                SELECT Id, EngineeringChangeRequest__c, Development__c, Description__c,
                        PN1__c, CurrPiecePrice1__c, Description1__c, SourcingPN1__c, CurrentPN1__c,
                        PN2__c, CurrPiecePrice2__c, Description2__c, SourcingPN2__c , CurrentPN2__c
                FROM EngineeringChangeProposal__c
                WHERE EngineeringChangeRequest__c =:ecrIdSet
        ];

        for (EngineeringChangeProposal__c ecp : ecpList) {
            ecp.CurrPiecePrice1__c = 100;
            ecp.CurrPiecePrice2__c = 200;
            ecp.CurrentPN1__c = 'ecpDpName11';
            ecp.CurrentPN2__c = 'ecpDpName22';
        }

        update ecpList;
        Test.stopTest();

    }
}