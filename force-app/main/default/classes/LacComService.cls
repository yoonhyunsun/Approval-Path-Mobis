/****************************************************************************************
  * @filename      : LacComService
  * @author        : I2MAX
  * @date          : 2020-12-29 오후 5:18
  * @group         : 
  * @group-content : 
  * @description   : 
  * @tester        : LacComService_ts.cls
  * @reference     :
  * @release       : v1.0.0
  * @copyright     : Copyright © I2max. All Rights Reserved.
  * @modification Log
  * ===============================================================
  * ver     date                     author              description
  * ===============================================================
    0.1     2020-12-29 오후 5:18      I2MAX               Create
****************************************************************************************/
public class LacComService {
    /**
     * Sobject field label 정보 가져옴
     *
     * @param targetObjectList : List<String>
     *
     * @return Map<String, Map<String, String>>
     */
    @AuraEnabled
    public static Map<String, Map<String, String>> getMultiSObjectLabel(List<String> targetObjectList) {
        return I2ComService.gfnGetMultiSObjectLabel(targetObjectList);
    }
}