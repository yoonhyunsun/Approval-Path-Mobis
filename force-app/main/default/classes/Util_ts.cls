/***************************************************************************************
  * Project Name : Hyundai Mobis
  * File Name    : Util_ts
  * Description  :
  * Copyright    : Copyright © I2max. All Rights Reserved. 2022
  * Author       : KyeJin Cheong
  * Created Date : 2022-11-23
****************************************************************************************/

@IsTest
public with sharing class Util_ts {

    public static Date d = Date.today();
    public static Datetime dt = Datetime.now();

    static testMethod void testCase01() {
        Test.startTest();

        User usr = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

        Util.getRecordTypeId('Product2', 'Labor');

        Util.isNull(d);
        Util.isEmpty(d);
        Util.isNotEmpty('abc');

        Util.substring('123', 1, 2);

        Test.stopTest();
    }

}