/***************************************************************************************
  * Project Name : Hyundai Mobis
  * File Name    : CSVUtil
  * Description  : 
  * Copyright    : Copyright © I2max. All Rights Reserved. 2022 
  * Author       : KyeJin Cheong
  * Created Date : 2022-11-23
****************************************************************************************/

public with sharing class CSVUtil extends SalesBase {

    /**
     * @return CSV 입력 내용을 읽은 후, Batch Class 실행한다.
     */
    @AuraEnabled
    public static ComponentResponse read(List<String> externalIdList, String objectTypeValue, List<Map<String, Object>> inputLineMapList) {

        System.debug('objectTypeValue > ' + objectTypeValue);
        System.debug('inputLineMapList > ' + inputLineMapList);
        System.debug('externalIdList > ' + externalIdList); // OK

        ComponentResponse response = new ComponentResponse();

        return response;
    }

}