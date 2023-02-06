/**
 * Created by changheekim on 2022/12/05.
 */

@IsTest
private class LumpSumCollectionCurrency_tr_ts {
    @TestSetup
    static void setData(){
        insert SalesTestDataUtil.getEcpList();
        insert SalesTestDataUtil.getLscList();
    }
    @IsTest
    static void testBehavior() {
        try {
            Test.startTest();
            List<LumpSumCollectionManagement__c> lscList = [
                    SELECT Id, Development__c, RecordTypeId, CurrencyType__c, CurrencyIsoCode, EDDCost__c, TotalAmount__c
                    FROM LumpSumCollectionManagement__c
            ];

            System.debug('lscList.size()');
            System.debug(lscList.size());
            for (LumpSumCollectionManagement__c lsc : lscList) {
                if(lsc.RecordTypeId == SalesConst.RECTYPE_ED_D_MANAGEMENT){
                    lsc.EDDCost__c = 1000000001;
                }else{
                    lsc.EDDCost__c = 999999;
                }
                System.debug(lsc);
            }

            update lscList;
            Test.stopTest();
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
    }
}