/**
 * Created by hyodongmin on 2022/08/17.
 */

public class TestUtil {
    /**
     * 테스트 실행을 잠시 멈춘다. 최대 10초
     *
     * @param aMillis sleep time
     */
    @TestVisible
    private static void sleep(Integer aMillis) {
        // "pause" to allow testing of code
        Long startTime = Datetime.now().getTime();
        Long finalTime = Datetime.now().getTime();
        Long millisecondsToWait = aMillis; // vary this depending on your "sleep" needs
        while (finalTime - startTime < millisecondsToWait) {
            finalTime = Datetime.now().getTime();
        }
    }

    /**
     * 다중 Map 의 경로를 찾아 값을 반환한다.
     * <pre>
     *  Map<String, Object> kMap1 = new Map<String, Object>();
     *  kMap1.put('value', '1');
     *  System.assertEquals('1', TestUtil.valueOf(kMap1, 'value'));
     *
     *  List<String> kStrList = new List<String>();
     *  kStrList.add('a');
     *  kStrList.add('b');
     *  kMap1.put('arr', kStrList);
     *
     *  Map<String, Object> kMap2 = new Map<String, Object>();
     *  kMap2.put('map1', kMap1);
     *
     *  System.assertEquals('1', TestUtil.valueOf(kMap2, 'map1.value'));
     *
     *  Map<String, Object> kMap3 = new Map<String, Object>();
     *  kMap3.put('map2', kMap2);
     *  System.assertEquals('a',  ((List<String>) TestUtil.valueOf(kMap3, 'map2.map1.arr'))[0]);
     *  System.assertEquals('b',  ((List<String>) TestUtil.valueOf(kMap3, 'map2.map1.arr'))[1]);
     * </pre>
     *
     * @param aMap Map<String, Object>
     * @param aKey '.' 으로 연결된 키 모음 ex> 'response.payload.value'
     *
     * @return Object 지정한 경로의 값
     */
    @TestVisible
    private static Object valueOf(Map<String, Object> aMap, String aKey) {
        String[] kKeys = aKey.split('\\.');
        if(kKeys.size() > 1) {
            String kKey = kKeys.remove(0);
            return valueOf((Map<String, Object>) aMap.get(kKey), String.join(kKeys, '.'));
        } else {
            return aMap.get(kKeys[0]);
        }
    }

    /**
     * 쓰기 금지된 필드 (ex> formula 등) 에 값을 지정해준다.
     *
     * @param aSObj SObject
     * @param aFieldName 저장할 필드 이름
     * @param aValue 필드의 값
     *
     * @return SObject
     */
    @TestVisible
    private static SObject treatField(SObject aSObj, String aFieldName, Object aValue) {
        return treatFields(aSObj, new List<Object>{ aFieldName, aValue });
    }

    /**
     * 쓰기 금지된 필드 (ex> formula 등) 에 값을 지정해준다.
     *
     * @param aSObj SObject
     * @param aKeyValues {필드 이름, 값, 이름, 값 ...}
     *
     * @return SObject
     */
    @TestVisible
    private static SObject treatFields(SObject aSObj, List<Object> aKeyValues) {
        String kJsonStr = JSON.serialize(aSObj);
        Map<String, Object> kDataMap = (Map<String, Object>) JSON.deserializeUntyped(kJsonStr);
        for (Integer i = 0; i < aKeyValues.size(); ++i) {
            kDataMap.put((String) aKeyValues[i], aKeyValues[++i]);
        }
        kJsonStr = JSON.serialize(kDataMap);
        return (SObject) JSON.deserialize(kJsonStr, SObject.class);
    }

    /**
     * Loaner_Demo_Consumed_Item__r 과 같이 SOQL 로 만들어진 참조 배열은 JSON 내부 구조가 특별하다. 그에 맞게 구조를 만들어 준다.
     *
     * @param aObjects List<Object>
     *
     * @return JSON 구조에 맞는 Map
     */
    @TestVisible
    private static Object rewriteSubQuery(List<Object> aObjects) {
        Map<String, Object> kDataMap = new Map<String, Object>();
        kDataMap.put('totalSize', aObjects.size());
        kDataMap.put('done', true);
        kDataMap.put('records', aObjects);
        return kDataMap;
    }
}