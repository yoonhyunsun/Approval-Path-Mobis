/***************************************************************************************
  * Project Name : Hyundai Mobis
  * File Name    : ProformaManagement_ts
  * Description  :
  * Copyright    : Copyright © I2max. All Rights Reserved. 2022
  * Author       : KyeJin Cheong
  * Created Date : 2022-12-07
****************************************************************************************/
@IsTest
private class ProformaManagement_ts {

    @TestSetup
    static void setData() {
        insert SalesTestDataUtil.getProformaList();
    }

    @IsTest
    static void testCase01() {

        ProformaManagement.init();

        Test.startTest();

        ProformaExportBatch batch = new ProformaExportBatch();

        batch.csvName = 'Test CSV';
        batch.changeDescription = 'Test Description';
        batch.ownerId = UserInfo.getUserId();

        Database.executeBatch(batch, 2000);

        ProformaManagement.getFileList();

        Test.stopTest();
    }
}