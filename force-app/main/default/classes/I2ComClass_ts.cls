/****************************************************************************************
  * @filename      : I2ComClass_ts
  * @author        : I2MAX
  * @date          : 2020-12-29 오후 5:16
  * @group         :
  * @group-content :
  * @description   : 
  * @reference     :
  * @release       : v1.0.0
  * @copyright     : Copyright © I2max. All Rights Reserved.
  * @modification Log
  * ===============================================================
  * ver     date                     author            description
  * ===============================================================
    0.1     2020-12-29 오후 5:16      I2MAX               Create
****************************************************************************************/
@IsTest
private class I2ComClass_ts {
    class InitData extends I2ComClass.InitData {
    }

    @IsTest
    static void testBehavior() {
        //==============================================================================
        // Logic Test
        //==============================================================================
        InitData initData = new InitData();
        System.assertNotEquals(null, initData);
        System.assertNotEquals(null, new I2ComClass.Option('label', 'value'));

        I2ComClass.ResData resData = new I2ComClass.ResData(1000, new List<SObject>{ new Account(Name = 'TestAccount') });
        System.assertNotEquals(null, resData);
        System.assertNotEquals(0, resData.recordSize);
    }
}