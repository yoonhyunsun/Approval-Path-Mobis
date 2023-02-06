/****************************************************************************************
  * @filename      : I2ComMetaUtil_ts
  * @author        : I2MAX
  * @date          : 2020-12-29 오후 5:20
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
    0.1     2020-12-29 오후 5:20      I2MAX               Create
****************************************************************************************/
@IsTest
private class I2ComMetaUtil_ts {
    @IsTest
    static void testBehavior() {
        //==============================================================================
        // Logic Test
        //==============================================================================
        System.assertNotEquals(null, I2ComMetaUtil.getDescribeSObjectResults('Account'));
    }
}