/**
 * Created by hyodongmin on 2022/07/11.
 */

/**
 * 기본 Util
 */
public with sharing class SUtil {
    /**
     * Id 에 해당하는 SObject 의 이름을 반환한다.
     *
     * @param aRecordId Id
     *
     * @return SObject 이름
     */
    public static String toName(Id aRecordId) {
        return aRecordId?.getSobjectType().getDescribe().getName();
    }

    /**
     * Class 의 이름을 반환한다.
     *
     * @param aType Class type
     *
     * @return Class 이름
     */
    public static String toName(Type aType) {
        return aType.getName();
    }

    /**
     * 객체 의 이름을 반환한다.
     *
     * @param aObj Object
     *
     * @return Class 이름
     */
    public static String toName(Object aObj) {
        return String.valueOf(aObj).substringBefore(':');
    }

    private static Map<Type, Map<String, Schema.RecordTypeInfo>> sObjectTypeToRecordTypesMap = new Map<Type, Map<String, Schema.RecordTypeInfo>>();

    /**
     * - CSUtils
     * Given an SObject name and Record Type name, return the Record Type's Id.
     *
     * @param aSObjectType SObject type ex> Account.class
     * @param aRecordType Record type developer name
     *
     * @return SObject.RecordTypeId or null
     */
    public static Id getRecordTypeId(Type aSObjectType, String aRecordType) {
        if (false == sObjectTypeToRecordTypesMap.containsKey(aSObjectType)) {
            Schema.SObjectType kSoType = Schema.getGlobalDescribe().get(toName(aSObjectType));
            sObjectTypeToRecordTypesMap.put(aSObjectType, kSoType.getDescribe().getRecordTypeInfosByDeveloperName());
        }

        Map<String, Schema.RecordTypeInfo> kRecordTypesMap = sObjectTypeToRecordTypesMap.get(aSObjectType);
        return kRecordTypesMap?.get(aRecordType)?.getRecordTypeId();
    }

    /**
     * SOQL 의 'LIKE' 검색에 이용되는 키워드로 변환하여 반환한다. null 인 경우 모든 문자와 매칭 되도록 '%'를 반환한다.
     * 단, '%' 은 null 을 포함하지 못하므로  {@link SUtil.toNullKeyword()} 와 함께 이용하여 다음과 같은 조건으로 검색할 수 있다.
     * 키워드가 null 인 경우와 아닌 경우, 대상 필드가 null 이거나 아닌 경우 모두 원활히 동작한다.
     *
     * <pre>
     *     SELECT Id FROM SOME_OBJECT
     *     WHERE type = :type
     *     AND ( Description LIKE :toLikeKeyword(keyword)
     *     OR Description = :toNullKeyword(keyword) )
     * </pre>
     *
     * @param aKeyword 키워드
     *
     * @return 변환된 키워드
     */
    public static String toLikeKeyword(String aKeyword) {
        return String.isBlank(aKeyword) ? '%' : '%' + aKeyword + '%';
    }

    /**
     * 키워드가 Blank 이면 null 을 반환한다.
     *
     * @param aKeyword 키워드
     *
     * @return 변환된 키워드
     */
    public static String toNullKeyword(String aKeyword) {
        return String.isBlank(aKeyword) ? null : aKeyword;
    }

    /**
     * List 에 값이 있다면 0번째를 반환한다. 그외에는 null 을 반환한다.
     * 
     * @param aList List<Object>
     *
     * @return List[0] or null 
     */
    public static Object oneOrNull(List<Object> aList) {
        return null == aList || aList.isEmpty() ? null : aList[0];
    }

    /**
     * 문자열이 Blank 라면 기본 문자열을 반환한다.
     *
     * @param aStr 문자열
     * @param aDefault 기본값 문자열
     *
     * @return aStr or aDefault
     */
    public static String orDefault(String aStr, String aDefault) {
        return String.isBlank(aStr) ? aDefault : aStr;
    }

    /**
     * 문자열 Y/N 을 Boolean 으로 변환. 대소문자 구분 없음
     *
     * @param aYn 'Y' 또는 'N'
     *
     * @return Boolean
     */
    public static Boolean isYn(String aYn) {
        return 'Y'.equalsIgnoreCase(aYn);
    }

    /**
     * Time string 을 Date 객체로 변환
     *
     * @param aString date string yyyy-MM-dd, yyyy-MM-dd HH:mm:ss
     *
     * @return Date
     */
    public static Date toDate(String aString) {
        if (aString == null) {
            return null;
        }

        try {
            return Date.valueOf(aString);
        } catch (Exception e){
            return null;
        }
    }

    /**
     * yyyyMMdd 문자열을 yyyy-MM-dd 로 변환. 긴 문자열은 잘라서 처리한다.
     *
     * @param aYyyyMMdd yyyyMMdd
     *
     * @return yyyy-MM-dd
     */
    public static String toDateStr(String aYyyyMMdd) {
        if (null == aYyyyMMdd) {
            return null;
        }
        aYyyyMMdd = aYyyyMMdd.left(8);
        if (aYyyyMMdd.length() < 8) {
            return null;
        }
        return aYyyyMMdd.left(4) + '-' + aYyyyMMdd.mid(4, 2) + '-' + aYyyyMMdd.right(2);
    }

    /**
     * Datetime string 을 Datetime 객체로 변환
     *
     * @param aString date string yyyy-MM-dd HH:mm:ss
     *
     * @return Date
     */
    public static Datetime toDatetime(String aString) {
        if (aString == null) {
            return null;
        }

        try {
            return Datetime.valueOf(aString);
        } catch (Exception e){
            return null;
        }
    }

    /**
     * yyyyMMddHHmmss 문자열을 yyyy-MM-dd HH:mm:ss 로 변환.
     *
     * @param aYyyyMMddHHmmss yyyyMMddHHmmss
     *
     * @return yyyy-MM-dd HH:mm:ss
     */
    public static String toDatetimeStr(String aYyyyMMddHHmmss) {
        if (null == aYyyyMMddHHmmss) {
            return null;
        }
        aYyyyMMddHHmmss = aYyyyMMddHHmmss.left(14);
        if (aYyyyMMddHHmmss.length() < 14) {
            return null;
        }
        return aYyyyMMddHHmmss.left(4) + '-' + aYyyyMMddHHmmss.mid(4, 2) + '-' + aYyyyMMddHHmmss.mid(6, 2)
              + ' ' +aYyyyMMddHHmmss.mid(8, 2) + ':' + aYyyyMMddHHmmss.mid(10, 2) + ':' + aYyyyMMddHHmmss.mid(12, 2);
    }

    /**
     * SFDC 의 Object 에 설정 가능한 최소시간을 적용한다. 1700-01-01 00:00:00 이 최소.
     *
     * @param aDatetime Datetime
     *
     * @return Datetime
     */
    public static Datetime min(Datetime aDatetime) {
        if(null == aDatetime) {
            return null;
        }
        if(aDatetime >= Datetime.newInstanceGmt(1700, 1, 1, 0, 0, 0)) {
            return aDatetime;
        } else {
            return Datetime.newInstanceGmt(1700, 1, 1, 0, 0, 0);
        }
    }

    /**
     * SFDC 의 Object 에 설정 가능한 최소시간을 적용한다. 1700-01-01 00:00:00 이 최소.
     *
     * @param aDate Date
     *
     * @return Date
     */
    public static Date min(Date aDate) {
        if(null == aDate) {
            return null;
        }
        Datetime kDatetime = min((Datetime) aDate);
        return Date.newInstance(kDatetime.yearGmt(), kDatetime.monthGmt(), kDatetime.dayGmt());
    }

    /**
     * SFDC 의 Object 에 설정 가능한 최대시간을 적용한다. 4000-12-31 00:00:00 이 최대.
     *
     * @param aDatetime Datetime
     *
     * @return Datetime
     */
    public static Datetime max(Datetime aDatetime) {
        if(null == aDatetime) {
            return null;
        }
        if(aDatetime < Datetime.newInstanceGmt(4000, 12, 31, 0, 0, 1)) {
            return aDatetime;
        } else {
            return Datetime.newInstanceGmt(4000, 12, 31, 0, 0, 0);
        }
    }

    /**
     * SFDC 의 Object 에 설정 가능한 최대시간을 적용한다. 4000-12-31 00:00:00 이 최대.
     *
     * @param aDate Date
     *
     * @return Date
     */
    public static Date max(Date aDate) {
        if(null == aDate) {
            return null;
        }
        Datetime kDatetime = max((Datetime) aDate);
        return Date.newInstance(kDatetime.yearGmt(), kDatetime.monthGmt(), kDatetime.dayGmt());
    }

    /**
     * 전화번호 형식의 문자열인지 확인
     *
     * @param aStr 전화번호
     *
     * @return Boolean
     */
    public static Boolean isPhone(String aStr) {
        if (String.isBlank(aStr)) {
            return false;
        }
        return Pattern.matches('^((\\+?\\d{1,3}[- ]?)\\d{1,3}|\\d{2,3})-?\\d{3,4}-?\\d{4}$', aStr);
    }

    /**
     * 주어진 문자열이 이메일 주소 형식인지 확인
     *
     * @param aStr 이메일 주소
     *
     * @return Boolean
     */
    public static Boolean isEmail(String aStr) {
        if (String.isBlank(aStr)) {
            return false;
        }
        return Pattern.matches('^[\\w\\-.+]+@([\\w-]+\\.)+[\\w-]{2,4}$', aStr);
    }

    /**
     * 문자열이 한글로 이루어졌는지 확인 (공백 허용 안됨)
     * @param aStr text
     *
     * @return Boolean
     */
    public static Boolean isKorean(String aStr) {
        if (String.isBlank(aStr)) {
            return false;
        }
        return Pattern.matches('[\\u3131-\\u3163\\uac00-\\ud7a3]+', aStr);
    }
}