/***************************************************************************************
 * Project Name : Hyundai Mobis
 * File Name    : SalesUtil
 * Description  :
 * Copyright    : Copyright © I2max. All Rights Reserved. 2022
 * Author       : KyeJin Cheong
 * Created Date : 2022-12-07
 ****************************************************************************************/

@IsTest
private class SalesUtil_ts {

    @IsTest
    static void testCase01() {
        SalesUtil.getProformaCSVExternalKey(1, 'VP', 'Test', 'Test');
        SalesUtil.getProformaExternalKey(1, 'VP', 'Test', 'Test', 2023, 1, 100, 1000);
        SalesUtil.getFieldSet('Proforma_Export_List', 'ProformaDummy__c');
        SalesUtil.getPlanningExternalKey(2022, 1);
    }
}