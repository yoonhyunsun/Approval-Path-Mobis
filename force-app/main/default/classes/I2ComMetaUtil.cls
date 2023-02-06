/****************************************************************************************
  * @filename      : I2ComMetaUtil
  * @author        : I2MAX
  * @date          : 2020-12-29 오후 5:19
  * @group         : 
  * @group-content : 
  * @description   : 
  * @tester        : I2ComMetaUtil_ts.cls
  * @reference     :
  * @release       : v1.0.0
  * @copyright     : Copyright © I2max. All Rights Reserved.
  * @modification Log
  * ===============================================================
  * ver     date                     author              description
  * ===============================================================
    0.1     2020-12-29 오후 5:19      I2MAX               Create
****************************************************************************************/
public class I2ComMetaUtil {
    /**
     * Sobject 정보 가져옴
     *
     * @param targetObject  : String(Sobject)
     *
     * @return List<Schema.DescribeSObjectResult>
     */
    public static List<Schema.DescribeSObjectResult> getDescribeSObjectResults(final String targetObject) {
        return getDescribeSObjectResults(new List<String>{ targetObject });
    }

    /**
     * Sobject 정보 가져옴(Multi 처리)
     *
     * @param targetObjectList  : List<String>
     *
     * @return  List<Schema.DescribeSObjectResult>
     */
    public static List<Schema.DescribeSObjectResult> getDescribeSObjectResults(final List<String> targetObjectList) {
        return Schema.describeSObjects(targetObjectList);
    }
}