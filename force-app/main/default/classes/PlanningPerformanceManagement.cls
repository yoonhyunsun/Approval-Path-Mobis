/***************************************************************************************
  * Project Name : Hyundai Mobis
  * File Name    : ProformaManagement
  * Description  :
  * Copyright    : Copyright © I2max. All Rights Reserved. 2022
  * Author       : KyeJin Cheong
  * Created Date : 2022-11-21
****************************************************************************************/

public with sharing class PlanningPerformanceManagement {

    /**
     * Initialize
     */
    @AuraEnabled
    public static ComponentResponse init() {
        ComponentResponse response = new ComponentResponse();

        String connected = 'connected';

        response.setData('connected', connected);

        return response;
    }

    /**
     * @param csvName CSV File Name
     * @return ComponentResponse
     * @description 현재 배치 실행 범위는 2000 을 기준으로 실행된다.
     */
    /*@AuraEnabled
    public static ComponentResponse exportProformaMaster(String csvName) {

        ComponentResponse response = new ComponentResponse();

        ProformaExportBatch batch = new ProformaExportBatch();
        batch.csvName = csvName;
        batch.ownerId = UserInfo.getUserId();

        System.debug('batch.csvName > ' + batch.csvName);
        System.debug('batch.ownerId > ' + batch.ownerId);

        Database.executeBatch(batch, 2000);

        return response;
    }*/
}