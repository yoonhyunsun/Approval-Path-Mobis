/****************************************************************************************
  * @filename      : ComponentResponse_ts
  * @projectname   : HMID DMS
  * @author        : i2max_Byeon.jw
  * @date          : 2020-07-17 오후 1:34
  * @group         : Sales
  * @description   : 
  * @reference     : 
  * @modification Log
  * ===============================================================
  * ver     date                author              description
  * ===============================================================
    0.1     2020-07-17 오후 1:34     i2max_Byeon.jw       Create
****************************************************************************************/
@IsTest
private class ComponentResponse_Test {
    @IsTest
    static void testCase01() {
        ComponentResponse response = new ComponentResponse();

        response.setData('key', 'value');
        Map<String, Object> keyValues = new Map<String, Object>{ 'key2' => 'value2', 'key3' => 'value3' };

        response.setData(keyValues);

        String value = (String) response.getData('key');
    }
}