/***************************************************************************************
  * Project Name : Hyundai Mobis
  * File Name    : I2ComHelper_ts
  * Description  : 
  * Copyright    : Copyright © I2max. All Rights Reserved. 2022 
  * Author       : KyeJin Cheong
  * Created Date : 2022-11-29
****************************************************************************************/
@IsTest
private class I2ComHelper_ts {
    @IsTest
    static void testBehavior() {
        //==============================================================================
        // Data Setting
        //==============================================================================
        Account testAccount = new Account(Name='test');
        insert testAccount;

        I2ComClass.ResData resData = I2ComHelper.gfnQuery(
                'Id, Name',
                'Account',
                'WHERE Id = \'' + testAccount.Id + '\'',
                '',
                1,
                1
        );

        I2ComClass.ResData resData2 = I2ComHelper.gfnQueryNoPaging(
                'Id, Name',
                'Account',
                'WHERE Id = \'' + testAccount.Id + '\'',
                ''
        );

        Map<String, String> tmpMap = I2ComHelper.gfnCheckCondition(JSON.serialize(new Map<String, String>{'111'=>'111'}));

        //==============================================================================
        // Logic Test
        //==============================================================================
        System.assertNotEquals(resData, null);

        System.assertNotEquals(resData2, null);

        System.assertNotEquals(tmpMap, null);

        System.assertNotEquals(I2ComHelper.gfnHasCondition(tmpMap, '111'), null);
        System.assertNotEquals(I2ComHelper.gfnRefineCondition(' AND '), null);
    }
}