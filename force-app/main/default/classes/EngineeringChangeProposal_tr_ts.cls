/**
 * Created by changheekim on 2022/12/05.
 */

@IsTest
private class EngineeringChangeProposal_tr_ts {
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
        List<EngineeringChangeProposal__c> ecpList = [
                SELECT Id, EngineeringChangeRequest__c, Development__c, Description__c,
                        PN1__c, CurrPiecePrice1__c, Description1__c, SourcingPN1__c, CurrentPN1__c,
                        PN2__c, CurrPiecePrice2__c, Description2__c, SourcingPN2__c , CurrentPN2__c
                FROM EngineeringChangeProposal__c
        ];

        for (EngineeringChangeProposal__c ecp : ecpList) {
            ecp.CurrPiecePrice1__c = 1111;
            ecp.CurrPiecePrice2__c = 2222;
            ecp.CurrentPN1__c = 'ecpDpName1111';
            ecp.CurrentPN2__c = 'ecpDpName2222';
        }

        update ecpList;
        Test.stopTest();
    }
}