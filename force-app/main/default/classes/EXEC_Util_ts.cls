/**
 * Created by hyodongmin on 2022/09/08.
 */

@IsTest
private class EXEC_Util_ts {
    @IsTest
    static void testGetChainStatus() {
        List<String> kChains = new List<String>{
                EXEC_Manager.CHAIN_LOG_START
        };

        Test.startTest();
        EXEC_Factory.getChain(kChains, kChains[0], '').startChain(new EXEC_ChainContext());
        // queued
        System.assertEquals('Queued', EXEC_Util.getChainStatus(EXEC_Util.getChainClassNameSet(kChains)));
        Test.stopTest();

        // completed - 배치 완료 1분 이내에는 실행 불가
        System.assertEquals('Completed', EXEC_Util.getChainStatus(EXEC_Util.getChainClassNameSet(kChains)));

        TestUtil.sleep(8000);

        // 일정 시간 후 실행 가능
        System.assertEquals('', EXEC_Util.getChainStatus(EXEC_Util.getChainClassNameSet(kChains), 7));

    }
    @IsTest
    static void testGetChainStatusAborted() {
        List<String> kChains = new List<String>{
                EXEC_Manager.CHAIN_LOG_START
        };

        Test.startTest();
        EXEC_Factory.getChain(kChains, kChains[0], '').startChain(new EXEC_ChainContext());
        System.abortJob([SELECT Id FROM AsyncApexJob WHERE Status = 'Queued'].Id);
        // Aborted == not running
        System.assertEquals('', EXEC_Util.getChainStatus(EXEC_Util.getChainClassNameSet(kChains)));
        Test.stopTest();

        System.assertEquals('', EXEC_Util.getChainStatus(EXEC_Util.getChainClassNameSet(kChains)));
    }
    @IsTest
    static void testGetChainStatus2() {
        List<String> kChains = new List<String>{
                'IF_test', 'chainBatchTest', 'logTest'
        };

        // 실행 중인 배치 없음
        System.assertEquals('', EXEC_Util.getChainStatus(EXEC_Util.getChainClassNameSet(kChains)));
    }
    @IsTest
    static void testGetChainClassNameSet() {
        List<String> kChains = new List<String>{
                'IF_test', 'chainBatchTest', 'logTest'
        };
        System.assertEquals(new Set<String>{'EXEC_ChainCallout', 'EXEC_ChainBatch', 'EXEC_ChainLog'},
                EXEC_Util.getChainClassNameSet(kChains));
    }
    @IsTest
    static void testToUniqueKey() {
        System.assertEquals('a@1', EXEC_Util.toUniqueKey('a', '1'));
    }
    @IsTest
    static void testToUniqueKey2() {
        System.assertEquals('a@1', EXEC_Util.toUniqueKey('a', null, '1'));
        System.assertEquals('a@1', EXEC_Util.toUniqueKey('a', '', '1'));
        System.assertEquals('a@1', EXEC_Util.toUniqueKey('a', ' ', '1'));
        System.assertEquals('b@1', EXEC_Util.toUniqueKey('a', 'b', '1'));
    }
    @IsTest
    static void testToNull() {
        System.assertEquals(null, EXEC_Util.toNull(null, '{null}'));
        System.assertEquals(null, EXEC_Util.toNull('{null}', '{null}'));
        System.assertEquals('abc', EXEC_Util.toNull('abc', '{null}'));
        System.assertEquals('abc', EXEC_Util.toNull('abc', null));
    }
    @IsTest
    static void testConvertNullToNull() {
        Contact kContact = new Contact(FirstName = 'Test', LastName = 'Name', MiddleName = '{NULL}', Phone = 'NULL');
        EXEC_Util.convertNullToNull(kContact, null);
        System.assertEquals('{NULL}', kContact.MiddleName);

        EXEC_Util.convertNullToNull(kContact, '{NULL}');

        System.assertEquals('Test', kContact.FirstName);
        System.assertEquals('Name', kContact.LastName);
        System.assertEquals(null, kContact.MiddleName);
        System.assertEquals('NULL', kContact.Phone);


        EXEC_Util.convertNullToNull(null, '{NULL}');
        EXEC_Util.convertNullToNull(null, '');
        EXEC_Util.convertNullToNull(null, null);
    }
    @IsTest
    static void testConvertNullToNull2() {
        Contact kContact = new Contact(FirstName = 'Test', LastName = 'Name', MiddleName = 'NULL', Phone = '{NULL}', IsBusinessLead__c = true);
        insert kContact;

        kContact = [SELECT Id FROM Contact WHERE MiddleName = 'NULL'];
        EXEC_Util.convertNullToNull(kContact, 'NULL');    // for coverage
    }
    @IsTest
    static void testIsKorean() {
        System.assertEquals(true, EXEC_Util.isKorean('ㄱ'));
        System.assertEquals(true, EXEC_Util.isKorean('ㅎ'));
        System.assertEquals(true, EXEC_Util.isKorean('ㅏ'));
        System.assertEquals(true, EXEC_Util.isKorean('ㅣ'));
        System.assertEquals(true, EXEC_Util.isKorean('가'));
        System.assertEquals(true, EXEC_Util.isKorean('힣'));
        System.assertEquals(true, EXEC_Util.isKorean('한'));
        System.assertEquals(true, EXEC_Util.isKorean('한글'));
        System.assertEquals(true, EXEC_Util.isKorean('한글ㅁ'));
        System.assertEquals(false, EXEC_Util.isKorean('한글 '));
        System.assertEquals(false, EXEC_Util.isKorean('한글1'));
        System.assertEquals(false, EXEC_Util.isKorean('한글a'));
        System.assertEquals(false, EXEC_Util.isKorean(null));
        System.assertEquals(false, EXEC_Util.isKorean('a'));
        System.assertEquals(false, EXEC_Util.isKorean('1'));
        System.assertEquals(false, EXEC_Util.isKorean(' '));
    }

    @IsTest
    static void testSplitName() {
        System.assertEquals(new String[]{ '', '' }, EXEC_Util.splitName(null));
        System.assertEquals(new String[]{ '', '' }, EXEC_Util.splitName(''));
        System.assertEquals(new String[]{ '', '' }, EXEC_Util.splitName(' '));
        System.assertEquals(new String[]{ '', '허' }, EXEC_Util.splitName('허')); // 1글자는 성으로 판단. 이름은 빈 칸
        System.assertEquals(new String[]{ '훈', '허' }, EXEC_Util.splitName('허훈'));
        System.assertEquals(new String[]{ '', 'jordan' }, EXEC_Util.splitName('jordan'));
//        System.assertEquals(new String[]{ 'michael', 'jordan' }, EXEC_Util.splitName('michael jordan'));
//        System.assertEquals(new String[]{ 'michael', 'jordan' }, EXEC_Util.splitName('  michael    jordan   '));
        System.assertEquals(new String[]{'',  'michael jordan' }, EXEC_Util.splitName('michael jordan'));
        System.assertEquals(new String[]{'',  'michael jordan' }, EXEC_Util.splitName('  michael    jordan   '));
        System.assertEquals(new String[]{ '개똥', '김' }, EXEC_Util.splitName('김개똥'));
        System.assertEquals(new String[]{ '개똥', '김' }, EXEC_Util.splitName('김 개똥'));
        System.assertEquals(new String[]{ '개똥', '김' }, EXEC_Util.splitName('김 개 똥'));
        System.assertEquals(new String[]{ '개똥', '김' }, EXEC_Util.splitName('김   개   똥'));
        System.assertEquals(new String[]{ '진', '선우' }, EXEC_Util.splitName('선우진')); // 2글자 성
        System.assertEquals(new String[]{ '진', '독고' }, EXEC_Util.splitName('독고진')); // 2글자 성
        System.assertEquals(new String[]{ '진구', '독고' }, EXEC_Util.splitName('독고진구')); // 2글자 성
        System.assertEquals(new String[]{ '수한무거북이와두루미', '서' }, EXEC_Util.splitName('서수한무거북이와두루미'));
        System.assertEquals(new String[]{ '', '漢子' }, EXEC_Util.splitName('漢子'));
        System.assertEquals(new String[]{ '', '한글漢子' }, EXEC_Util.splitName('한글漢子'));
        System.assertEquals(new String[]{ '', '한글 漢子' }, EXEC_Util.splitName('한글 漢子'));
        System.assertEquals(new String[]{ '', '漢子한글' }, EXEC_Util.splitName('漢子한글'));
        System.assertEquals(new String[]{ '', '漢子 한글' }, EXEC_Util.splitName('漢子 한글'));
        System.assertEquals(new String[]{ '', '한글ENG' }, EXEC_Util.splitName('한글ENG'));
        System.assertEquals(new String[]{ '', '한글 ENG' }, EXEC_Util.splitName('한글 ENG'));
        System.assertEquals(new String[]{ '', 'ENG한글' }, EXEC_Util.splitName('ENG한글'));
        System.assertEquals(new String[]{ '', 'ENG 한글' }, EXEC_Util.splitName('ENG 한글'));
    }

}