/**
 * Created by hyodongmin on 2022/09/07.
 */

public with sharing class EXEC_Util {

    /**
     * EXE_Manager 체인이 실행 중인지 확인한다.
     *
     * @param aChainClassNameSet 체인 클래스 이름
     *
     * @return '' = 실행 중이 아님, 나머지 = 체인 실행 중
     */
    public static String getChainStatus(Set<String> aChainClassNameSet) {
        return getChainStatus(aChainClassNameSet, 60);
    }

    /**
     * EXE_Manager 체인이 실행 중인지 확인한다.
     *
     * @param aChainClassNameSet 체인 클래스 이름
     * @param aSec 완료 Job 대기 시간
     *
     * @return '' = 실행 중이 아님, 나머지 = 체인 실행 중
     */
    public static String getChainStatus(Set<String> aChainClassNameSet, Integer aSec) {
        AsyncApexJob[] kJobs = [
                SELECT ApexClass.Name, Status
                FROM AsyncApexJob
                WHERE ApexClass.Name IN :aChainClassNameSet
                AND (
                        Status NOT IN ('Completed', 'Failed', 'Aborted')    // 실행 중이 아닌 상태가 아니거나
                        OR (
                                Status IN ('Completed')
                                AND CompletedDate > :System.now().addSeconds(-aSec)   // 1분 이내 완료된 경우, 다음 배치가 있을 수 있다.
                        )
                )
        ];
        System.debug(kJobs);
        if (kJobs.size() > 0) {
            return kJobs[0].Status;
        }
        return '';
    }

    /**
     * 주어진 체인 이름을 클래스 이름으로 변환해서 반환
     *
     * @param kChains 체인 리스트 (보통 EXE_Manager.getChains())
     * @return Set<String>
     */
    public static Set<String> getChainClassNameSet(List<String> kChains) {
        Set<String> kChainNameSet = new Set<String>();
        for (String str : kChains) {
            EXEC_IChain kChain = EXEC_Factory.getChain(kChains, str, '');
            if (null != kChain) {
                kChainNameSet.add(SUtil.toName(kChain));
            }
        }
        System.debug(kChainNameSet);
        return kChainNameSet;
    }

    /**
     * 전달된 문자열이 Null 을 나타내는 문자열이라면 null 을 반환한다.
     *
     * @param aStr 문자열
     * @param aNullStr Null 을 나타내는 문자열 ex> '(NULL)'
     *
     * @return null 또는 전달된 문자열
     */
    public static String toNull(String aStr, String aNullStr) {
        if (aStr == aNullStr) {
            return null;
        }
        return aStr;
    }

    /**
     * SObject 의 문자열 필드 중 Null 을 나타내는 것을 null 처리한다.
     *
     * @param aSObject SObject
     * @param aNullStr Null 을 나타내는 문자열 ex> '(NULL)'
     */
    public static void convertNullToNull(SObject aSObject, String aNullStr) {
        if (null == aSObject || String.isBlank(aNullStr)) {
            return;
        }

        Map<String, Object> kFieldMap = aSObject.getPopulatedFieldsAsMap(); // 값이 지정된 필드만 반환한다.
        for (String kKey : kFieldMap.keySet()) {
            if (aSObject.get(kKey) instanceof String && aSObject.get(kKey) == aNullStr) {
                aSObject.put(kKey, null);
            }
        }
    }

    /**
     * 고유 Key 반환
     * 전달하는 두 값을 이용하여 고유 키를 생성
     *
     * @param aFirst 값 1
     * @param aSecond 값 2
     *
     * @return 고유 키
     */
    public static String toUniqueKey(String aFirst, String aSecond) {
        return aFirst + '@' + aSecond;
    }

    /**
     * 고유 Key 반환
     * 전달하는 두 값을 이용하여 고유 키를 생성, aFirst 가 없는 경우 aDefaultFirst 이용
     *
     * @param aDefaultFirst 값 1 의 기본값
     * @param aFirst 값 1
     * @param aSecond 값 2
     *
     * @return 고유 키
     */
    public static String toUniqueKey(String aDefaultFirst, String aFirst, String aSecond) {
        return toUniqueKey((String.isBlank(aFirst) ? aDefaultFirst : aFirst), aSecond);
    }

    /**
     * 문자열이 한글로 이루어졌는지 확인 (공백 허용 안됨)
     * @param aStr text
     *
     * @return Boolean
     */
    public static Boolean isKorean(String aStr) {
        return SUtil.isKorean(aStr);
    }

    /**
     * 문자열을 성과 이름으로 분리하여 반환한다.
     *
     * @param aFullName 성명
     *
     * @return [이름, 성]
     */
    public static String[] splitName(String aFullName) {
        /*
        - 한글로 시작하는지 구분
        - 영문이라면 ' ' 으로만 구분하여 F, L 반환
        - 한글이라면 두 글자 성으로 시작하는지 확인 -> L
        - 나머지를 F
         */
        if (String.isBlank(aFullName)) {
            return new String[]{ '', '' };
        }

        aFullName = aFullName.normalizeSpace(); // 중복되는 공백 제거

        if (isKorean(aFullName.deleteWhitespace())) {
            if (aFullName.length() == 1) {    // 1글자라면 '성'만 반환, 이름은 빈칸
                return new String[]{ '', aFullName };
            }
            aFullName = aFullName.deleteWhitespace();

            String kTwoChar = aFullName.left(2);
            String[] kTwoCharLastNames = new String[]{ '강전', '남궁', '도씨', '독고', '동방', '등정', '망절', '무본', '사공', '서문', '선우', '소봉', '어금', '장곡', '제갈', '황목', '황보' };
            if (kTwoCharLastNames.indexOf(kTwoChar) > -1) {   // 2글자 성
                return new String[]{ kTwoChar.difference(aFullName), kTwoChar };
            } else { // 1글자 성
                String kFirstChar = aFullName.left(1);
                return new String[]{ kFirstChar.difference(aFullName), kFirstChar };
            }

        } else {
            // 외국어 이름은 모두 성으로 취급
            return new String[]{ '', aFullName };
        }
    }

    /*
'가', '간', '갈', '감', '강', '강전', '개', '견', '경', '계', '고', '곡', '공', '곽', '관', '교', '구', '국', '군', '궁', '궉', '권', '근', '금', '기', '길', '김',
'나', '난', '남', '남궁', '낭', '내', '노', '뇌', '누',
'다', '단', '담', '당', '대', '도', '도씨', '독', '독고', '돈', '동', '동방', '두', '등', '등정',
'라', '란', '랑', '려', '로', '뢰', '류', '리', '림',
'마', '만', '망절', '매', '맹', '명', '모', '목', '묘', '무', '무본', '묵', '문', '미', '민',
'박', '반', '방', '배', '백', '번', '범', '변', '보', '복', '봉', '부', '비', '빈', '빙',
'사', '사공', '산', '삼', '상', '서', '서문', '석', '선', '선우', '설', '섭', '성', '소', '소봉', '손', '송', '수', '순', '승', '시', '신', '심', '십',
'아', '안', '애', '야', '양', '어', '어금', '엄', '여', '연', '염', '엽', '영', '예', '오', '옥', '온', '옹', '완', '왕', '요', '용', '우', '운', '원', '위', '유', '육', '윤', '은', '음', '이', '인', '임',
'자', '잠', '장', '장곡', '저', '전', '점', '정', '제', '제갈', '조', '종', '좌', '주', '준', '즙', '증', '지', '진',
'차', '창', '채', '천', '초', '총', '최', '추', '춘',
'쾌',
'탁', '탄', '탕', '태',
'판', '팽', '편', '평', '포', '표', '풍', '피', '필',
'하', '학', '한', '함', '해', '허', '혁', '현', '형', '호', '홍', '화', '환', '황', '황목', '황보', '후', '흥'
     */
}