/****************************************************************************************
  * @filename      : Util
  * @projectname   : Hyundai Mobis PS
  * @author        : EH LEE
  * @date          : 2022-09-22 
  * @group         : 
  * @group-content : 
  * @description   : 
  * @tester        : Util_ts.cls
  * @reference     : 
  * @copyright     : Copyright © I2max. All Rights Reserved.
  * @modification Log
  * ===============================================================
  * ver     date                author              description
  * ===============================================================
    0.1     2022-09-22            EH LEE                 Create
****************************************************************************************/

global without sharing abstract class Util {

    public static String getRecordTypeId(String objName, String devName) {
        List<RecordType> rtList = [
                SELECT Id
                FROM RecordType
                WHERE SobjectType = :objName AND DeveloperName = :devName AND IsActive = true
        ];
        if (rtList.isEmpty()) {
            return '';
        } else {
            return rtList[0].Id;
        }

    }

    /**
     * substring
     * @param s     원본 문자열
     * @param startIndex        substring 시작 위치.
     * @param endIndex      substring 종료 위치.
     * @return       substring 된 문자열.
     * @Author      김성일
     * e.g.) Utiil.substring('123', 1, 2) --> '12300'
     * 정확히 짜르지 않으면 "Ending position out of bounds" 에러가 발생하여 정확히 짜르기 위함.
     */
    global static String substring(String s, Integer startIndex, Integer endIndex) {
        if (isEmpty(s)) return null;

        if (startIndex > s.length()) return '';

        if (endIndex > s.length()) {
            endIndex = s.length();
        }
        return s.substring(startIndex, endIndex);
    }

    /**
     * Null Check
     * @param o     Object
     * @return      o가 null 이면 true, null이 아니면 false 를 return.
     * @Author      snowChoi
     * e.g.) Util.isNull(null) --> true
     **/
    global static Boolean isNull(Object o) {
        return o == null ? true : false;
    }

    /**
     * Empty Check
     * @param o     Object
     * @return      o가 null 혹은 '' 이면 true, 아니면 false 를 return.
     * @Author      김성일
     * e.g.) Util.isEmpty(' ') --> true
     **/
    global static Boolean isEmpty(Object o) {
        if (o == null) return true;

        if (o instanceOf String) {
            if (''.equals(o)) return true;
            if (''.equals(String.valueOf(o).trim())) return true; // SPACE도 empty로 본다.
        } // type 별 null 기준 정의 필요. Number일 경우 등.

        return false;
    }

    /**
     * Not Empty Check
     * @param o     Object
     * @return      o가 null 혹은 '' 이면 true, 아니면 false 를 return.
     * @Author      김성일
     * e.g.) Util.isNotEmpty('a') --> true
     **/
    global static Boolean isNotEmpty(Object o) {
        return !isEmpty(o);
    }

}