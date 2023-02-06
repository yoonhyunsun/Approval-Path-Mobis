/****************************************************************************************
  * @filename      : I2ComService_ts
  * @author        : I2MAX
  * @date          : 2020-12-29 오후 5:23
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
    0.1     2020-12-29 오후 5:23      I2MAX               Create
****************************************************************************************/
@IsTest
private class I2ComService_ts {
    @IsTest
    static void testBehavior() {
        //==============================================================================
        // Logic Test
        //==============================================================================
        System.assertNotEquals(null, I2ComService.gfnGetMultiSObjectLabel('Account'));

        String s = 'xxxxxxx';
        String p = 'll';
        Integer l = 4;
        Integer i = 1;
        String result1 = I2ComService.lpad(s, p, l);
        String result2 = I2ComService.lpad(1, p, l);


    }
}