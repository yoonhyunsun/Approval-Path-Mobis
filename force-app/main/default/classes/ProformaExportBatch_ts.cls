/***************************************************************************************
  * Project Name : Hyundai Mobis
  * File Name    : ProformaExportBatch_ts
  * Description  :
  * Copyright    : Copyright © I2max. All Rights Reserved. 2022
  * Author       : KyeJin Cheong
  * Created Date : 2022-12-07
****************************************************************************************/

@IsTest
private class ProformaExportBatch_ts {

    @TestSetup
    static void setData(){
        insert SalesTestDataUtil.getProformaCSVList();
    }

    @IsTest
    static void testCase01() {

        ProformaExportBatch batch = new ProformaExportBatch();

        batch.csvName = 'Test CSV';
        batch.changeDescription = 'Test Description';
        batch.ownerId = UserInfo.getUserId();

        Database.executeBatch(batch, 2000);
    }
}