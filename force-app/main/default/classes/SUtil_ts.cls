/**
 * Created by hyodongmin on 2022/07/22.
 */

@IsTest
private class SUtil_ts {

    @IsTest
    static void testToName() {
        System.assertEquals('User', SUtil.toName(User.class));
        System.assertEquals('User', SUtil.toName(new User()));
        System.assertEquals('User', SUtil.toName('0059D000004DGS3'));
    }

    @IsTest
    static void testGetRecordTypeId() {
        RecordType kRecordType = [SELECT DeveloperName, SobjectType FROM RecordType LIMIT 1];
        Type kType = Type.forName(kRecordType.SobjectType);
        System.assertEquals(((SObject) kType.newInstance()).getSObjectType().getDescribe()
                .getRecordTypeInfosByDeveloperName().get(kRecordType.DeveloperName).getRecordTypeId(),
                SUtil.getRecordTypeId(kType, kRecordType.DeveloperName));
    }

    @IsTest
    static void testToLikeKeyword() {
        System.assertEquals('%', SUtil.toLikeKeyword(null));
        System.assertEquals('%', SUtil.toLikeKeyword(''));
        System.assertEquals('%', SUtil.toLikeKeyword(' '));
        System.assertEquals('%keyword%', SUtil.toLikeKeyword('keyword'));
    }

    @IsTest
    static void testToNullKeyword() {
        System.assertEquals(null, SUtil.toNullKeyword(null));
        System.assertEquals(null, SUtil.toNullKeyword(''));
        System.assertEquals(null, SUtil.toNullKeyword(' '));
        System.assertEquals('keyword', SUtil.toNullKeyword('keyword'));
    }

    @IsTest
    static void testOneOrNull() {
        System.assertEquals(null, SUtil.oneOrNull(null));
        System.assertEquals(null, SUtil.oneOrNull(new List<Object>()));
        System.assertEquals('one', SUtil.oneOrNull(new List<Object>{ 'one' }));
        System.assertEquals('one', SUtil.oneOrNull(new List<Object>{ 'one', 'two' }));
    }

    @IsTest
    static void testOrDefault() {
        System.assertEquals(null, SUtil.orDefault(null, null));
        System.assertEquals('', SUtil.orDefault(null, ''));
        System.assertEquals('d', SUtil.orDefault('', 'd'));
        System.assertEquals('d', SUtil.orDefault(' ', 'd'));
        System.assertEquals('abc', SUtil.orDefault('abc', 'd'));
        System.assertEquals('abc', SUtil.orDefault('abc', null));
    }

    @IsTest
    static void testIsYn() {
        System.assert(false == SUtil.isYn(null));
        System.assert(false == SUtil.isYn('n'));
        System.assert(false == SUtil.isYn('N'));
        System.assert(SUtil.isYn('y'));
        System.assert(SUtil.isYn('Y'));
    }

    @IsTest
    static void testToDate() {
        System.assertEquals(null, SUtil.toDate(null));
        System.assertEquals(null, SUtil.toDate('')); // for fail if no exception.
        System.assertEquals(Date.newInstance(2022, 6, 7), SUtil.toDate('2022-06-07'));
        System.assertEquals(Date.newInstance(2022, 6, 7), SUtil.toDate('2022-06-07 13:13:33'));
    }

    @IsTest
    static void testToDateStr() {
        System.assertEquals(null, SUtil.toDateStr(null));
        System.assertEquals(null, SUtil.toDateStr(''));
        System.assertEquals(null, SUtil.toDateStr('1'));
        System.assertEquals(null, SUtil.toDateStr('1111111'));
        System.assertEquals('1111-11-11', SUtil.toDateStr('11111111'));
        System.assertEquals('1111-11-11', SUtil.toDateStr('111111111'));
        System.assertEquals('1111-11-11', SUtil.toDateStr('1111111112345678'));
    }

    @IsTest
    static void testToDatetime() {
        System.assertEquals(null, SUtil.toDatetime(null));
        System.assertEquals(null, SUtil.toDatetime('')); // for fail if no exception.
        System.assertEquals(null, SUtil.toDatetime('2022-06-07'));
        System.assertEquals(Datetime.newInstance(2022, 6, 7, 12, 11, 10), SUtil.toDatetime('2022-06-07 12:11:10'));
    }

    @IsTest
    static void testToDatetimeStr() {
        System.assertEquals(null, SUtil.toDatetimeStr(null));
        System.assertEquals(null, SUtil.toDatetimeStr(''));
        System.assertEquals(null, SUtil.toDatetimeStr('1'));
        System.assertEquals(null, SUtil.toDatetimeStr('1111111111111'));
        System.assertEquals('1111-11-11 11:11:11', SUtil.toDatetimeStr('11111111111111'));
        System.assertEquals('1111-11-11 11:11:11', SUtil.toDatetimeStr('111111111111112222'));
    }

    @IsTest
    static void testMin() {
        Date kDate = null;
        System.assertEquals(null, SUtil.min(kDate));
        Datetime kDatetime = null;
        System.assertEquals(null, SUtil.min(kDatetime));
        System.assertEquals(Date.valueOf('1700-01-01'), SUtil.min(Date.valueOf('1000-01-01')));
        System.assertEquals(Date.valueOf('1700-01-01'), SUtil.min(Date.valueOf('1699-01-01')));
        System.assertEquals(Date.valueOf('1700-01-02'), SUtil.min(Date.valueOf('1700-01-02')));
        System.assertEquals(Datetime.valueOfGmt('1700-01-01 00:00:00'), SUtil.min(Datetime.valueOfGmt('1699-12-31 23:59:59')));
        System.assertEquals(Datetime.valueOfGmt('1700-01-01 23:59:59'), SUtil.min(Datetime.valueOfGmt('1700-01-01 23:59:59')));
        System.assertEquals(Datetime.valueOfGmt('1700-01-02 00:00:00'), SUtil.min(Datetime.valueOfGmt('1700-01-02 00:00:00')));
        System.assertEquals(Datetime.valueOfGmt('2222-01-02 01:22:33'), SUtil.min(Datetime.valueOfGmt('2222-01-02 01:22:33')));
    }
    @IsTest
    static void testMax() {
        Date kDate = null;
        System.assertEquals(null, SUtil.max(kDate));
        Datetime kDatetime = null;
        System.assertEquals(null, SUtil.max(kDatetime));
        System.assertEquals(Date.valueOf('4000-12-31'), SUtil.max(Date.valueOf('9999-01-01')));
        System.assertNotEquals(Date.valueOf('9999-01-01'), SUtil.max(Date.valueOf('9999-01-01')));
        System.assertEquals(Date.valueOf('4000-12-31'), SUtil.max(Date.valueOf('4001-01-01')));
        System.assertEquals(Date.valueOf('4000-12-30'), SUtil.max(Date.valueOf('4000-12-30')));
        System.assertEquals(Datetime.valueOfGmt('4000-12-31 00:00:00'), SUtil.max(Datetime.valueOfGmt('9999-12-31 00:00:01')));
        System.assertNotEquals(Datetime.valueOfGmt('9999-12-31 00:00:01'), SUtil.max(Datetime.valueOfGmt('9999-12-31 00:00:01')));
        System.assertEquals(Datetime.valueOfGmt('4000-12-31 00:00:00'), SUtil.max(Datetime.valueOfGmt('4000-12-31 00:00:01')));
        System.assertEquals(Datetime.valueOfGmt('4000-12-30 23:59:59'), SUtil.max(Datetime.valueOfGmt('4000-12-30 23:59:59')));
        System.assertEquals(Datetime.valueOfGmt('4000-12-30 00:00:00'), SUtil.max(Datetime.valueOfGmt('4000-12-30 00:00:00')));
        System.assertEquals(Datetime.valueOfGmt('2222-01-02 01:22:33'), SUtil.max(Datetime.valueOfGmt('2222-01-02 01:22:33')));
    }

    @IsTest
    static void testIsMobileNumber() {
        System.assertEquals(false, SUtil.isPhone(null));
        System.assertEquals(false, SUtil.isPhone(''));
        System.assertEquals(false, SUtil.isPhone('null'));
        System.assertEquals(false, SUtil.isPhone('1'));
        System.assertEquals(false, SUtil.isPhone('11111'));
        System.assertEquals(false, SUtil.isPhone('11111111'));
        System.assertEquals(true, SUtil.isPhone('+1 8087339090'));
        System.assertEquals(true, SUtil.isPhone('+91 8087339090'));
        System.assertEquals(true, SUtil.isPhone('+912 8087339090'));
        System.assertEquals(true, SUtil.isPhone('8087339090'));
        System.assertEquals(true, SUtil.isPhone('08087339090'));
        System.assertEquals(true, SUtil.isPhone('+1-8087339090'));
        System.assertEquals(true, SUtil.isPhone('+91-8087339090'));
        System.assertEquals(true, SUtil.isPhone('+912-8087339090'));
        System.assertEquals(true, SUtil.isPhone('+918087677876'));
        System.assertEquals(true, SUtil.isPhone('+9108087735454'));
        System.assertEquals(true, SUtil.isPhone('01037037037'));
        System.assertEquals(true, SUtil.isPhone('010-3703-7037'));
        System.assertEquals(true, SUtil.isPhone('+82 1037037037'));
        System.assertEquals(true, SUtil.isPhone('+821037037037'));
        System.assertEquals(true, SUtil.isPhone('+82-10-3703-7037'));
        System.assertEquals(true, SUtil.isPhone('+82-010-3703-7037'));
        System.assertEquals(true, SUtil.isPhone('+82-2-1234-5678'));
        System.assertEquals(true, SUtil.isPhone('86-185-2235-2249'));
        System.assertEquals(true, SUtil.isPhone('021231234'));
        System.assertEquals(true, SUtil.isPhone('0212341234'));
    }

    @IsTest
    static void testIsEmail() {
        System.assertEquals(false, SUtil.isEmail(null));
        System.assertEquals(false, SUtil.isEmail(''));
        System.assertEquals(false, SUtil.isEmail('null'));
        System.assertEquals(false, SUtil.isEmail('null@a.a'));
        System.assertEquals(false, SUtil.isEmail('null@a.abcde'));
        System.assertEquals(true, SUtil.isEmail('null@a.aa'));
        System.assertEquals(true, SUtil.isEmail('null@a.abcd'));
        System.assertEquals(true, SUtil.isEmail('null@a.com'));
        System.assertEquals(true, SUtil.isEmail('null+@a.com'));
        System.assertEquals(true, SUtil.isEmail('null+sfdc@a.com'));
        System.assertEquals(true, SUtil.isEmail('null+sfdc.mail@a.com'));
        System.assertEquals(true, SUtil.isEmail('null.mail@a.com'));
    }
    @IsTest
    static void testIsKorean() {
        System.assertEquals(true, SUtil.isKorean('ㄱ'));
        System.assertEquals(true, SUtil.isKorean('ㅎ'));
        System.assertEquals(true, SUtil.isKorean('ㅏ'));
        System.assertEquals(true, SUtil.isKorean('ㅣ'));
        System.assertEquals(true, SUtil.isKorean('가'));
        System.assertEquals(true, SUtil.isKorean('힣'));
        System.assertEquals(true, SUtil.isKorean('한'));
        System.assertEquals(true, SUtil.isKorean('한글'));
        System.assertEquals(true, SUtil.isKorean('한글ㅁ'));
        System.assertEquals(false, SUtil.isKorean('한글 '));
        System.assertEquals(false, SUtil.isKorean('한글1'));
        System.assertEquals(false, SUtil.isKorean('한글a'));
        System.assertEquals(false, SUtil.isKorean(null));
        System.assertEquals(false, SUtil.isKorean('a'));
        System.assertEquals(false, SUtil.isKorean('1'));
        System.assertEquals(false, SUtil.isKorean(' '));
    }
}