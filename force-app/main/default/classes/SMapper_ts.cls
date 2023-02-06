/**
 * Created by hyodongmin on 2022/09/21.
 */

@IsTest
private class SMapper_ts {
    @IsTest
    static void testToIdSet() {
        Set<Object> kSet = new Set<Object>{ '01p9D0000030FYr', '01p9D0000030FY1' };

        Set<Id> kIdSet = SMapper.toIdSet(kSet);
        System.assertEquals('01p9D0000030FYr', new List<Id>(kIdSet)[0]);
        System.assertEquals('01p9D0000030FY1', new List<Id>(kIdSet)[1]);
        System.assertEquals(0, SMapper.toIdSet(new Set<Object>()).size());
        System.assertEquals(0, SMapper.toIdSet(null).size());
    }
    @IsTest
    static void testToStringSet() {
        Set<Object> kSet = new Set<Object>{ 'a', 'b' };

        Set<String> kStringSet = SMapper.toStringSet(kSet);
        System.assertEquals('a', new List<String>(kStringSet)[0]);
        System.assertEquals('b', new List<String>(kStringSet)[1]);
        System.assertEquals(0, SMapper.toStringSet(new Set<Object>()).size());
        System.assertEquals(0, SMapper.toStringSet(null).size());
    }
    @IsTest
    static void testToSet() {
        List<SObject> kSObjects = new List<SObject>{
                TestUtil.treatFields(new Account(), new String[]{ 'BillingState', 'a' }),
                TestUtil.treatFields(new Account(), new String[]{ 'BillingState', 'b' }),
                TestUtil.treatFields(new Account(), new String[]{ 'BillingState', 'c' })
        };

        Set<Object> kSet = SMapper.toSet(kSObjects, Account.BillingState);
        System.assertEquals('a', new List<Object>(kSet)[0]);
        System.assertEquals('b', new List<Object>(kSet)[1]);
        System.assertEquals('c', new List<Object>(kSet)[2]);
        SObjectField kNullField = null;
        System.assertEquals(0, SMapper.toSet(null, kNullField).size());
        System.assertEquals(0, SMapper.toSet(new List<SObject>(), kNullField).size());
        System.assertEquals(0, SMapper.toSet(null, Account.BillingState).size());
    }
    @IsTest
    static void testToSet2() {
        List<SObject> kSObjects = new List<SObject>{
                TestUtil.treatFields(new Account(), new String[]{ 'BillingStreet', '1' }),
                TestUtil.treatFields(new Account(), new String[]{ 'BillingStreet', '2' }),
                TestUtil.treatFields(new Account(), new String[]{ 'BillingStreet', '3' })
        };

        Set<Object> kSet = SMapper.toSet(kSObjects, new SMapper.BasicSetter(Account.BillingStreet));
        System.assertEquals('1', new List<Object>(kSet)[0]);
        System.assertEquals('2', new List<Object>(kSet)[1]);
        System.assertEquals('3', new List<Object>(kSet)[2]);
        SMapper.ISetter kNullSetter = null;
        System.assertEquals(0, SMapper.toSet(null, kNullSetter).size());
        System.assertEquals(0, SMapper.toSet(new List<SObject>(), kNullSetter).size());
        System.assertEquals(0, SMapper.toSet(null, new SMapper.BasicSetter(Account.BillingStreet)).size());
    }
    @IsTest
    static void testToMap() {
        List<SObject> kSObjects = new List<SObject>{
                TestUtil.treatFields(new Account(), new String[]{ 'BillingState', 'a', 'BillingStreet', '1' }),
                TestUtil.treatFields(new Account(), new String[]{ 'BillingState', 'b', 'BillingStreet', '2' }),
                TestUtil.treatFields(new Account(), new String[]{ 'BillingState', 'c', 'BillingStreet', '3' })
        };
        Map<String, Object> kMap = SMapper.toMap(String.class, kSObjects, Account.BillingState, Account.BillingStreet);

        System.assertEquals('1', kMap.get('a'));
        System.assertEquals('2', kMap.get('b'));
        System.assertEquals('3', kMap.get('c'));

        System.assertEquals(0, SMapper.toMap(String.class, null, null, null).size());
        System.assertEquals(0, SMapper.toMap(String.class, kSObjects, Account.BillingState, null).size());
        System.assertEquals(0, SMapper.toMap(String.class, kSObjects, null, Account.BillingStreet).size());
        System.assertEquals(0, SMapper.toMap(String.class, null, Account.BillingState, Account.BillingStreet).size());
    }
    @IsTest
    static void testToMap2() {
        List<SObject> kSObjects = new List<SObject>{
                TestUtil.treatFields(new Account(), new String[]{ 'BillingState', 'a', 'BillingStreet', '111' }),
                TestUtil.treatFields(new Account(), new String[]{ 'BillingState', 'b', 'BillingStreet', '222' }),
                TestUtil.treatFields(new Account(), new String[]{ 'BillingState', 'c', 'BillingStreet', '333' })
        };
        Map<String, Object> kMap = SMapper.toMap(Account.class, kSObjects, Account.BillingState);

        System.assertEquals('111', ((Account) kMap.get('a')).BillingStreet);
        System.assertEquals('222', ((Account) kMap.get('b')).BillingStreet);
        System.assertEquals('333', ((Account) kMap.get('c')).BillingStreet);

        SObjectField kNullField = null;
        System.assertEquals(0, SMapper.toMap(Account.class, null, kNullField).size());
        System.assertEquals(0, SMapper.toMap(Account.class, kSObjects, kNullField).size());
        System.assertEquals(0, SMapper.toMap(Account.class, null, Account.BillingState).size());
    }
    @IsTest
    static void testToMap3() {
        List<SObject> kSObjects = new List<SObject>{
                TestUtil.treatFields(new Account(), new String[]{ 'BillingState', 'a', 'BillingStreet', '11' }),
                TestUtil.treatFields(new Account(), new String[]{ 'BillingState', 'b', 'BillingStreet', '22' }),
                TestUtil.treatFields(new Account(), new String[]{ 'BillingState', 'c', 'BillingStreet', '33' })
        };
        Map<String, Object> kMap = SMapper.toMap(String.class, kSObjects, new SMapper.BasicMapper(Account.BillingState, Account.BillingStreet));

        System.assertEquals('11', kMap.get('a'));
        System.assertEquals('22', kMap.get('b'));
        System.assertEquals('33', kMap.get('c'));

        SMapper.IMapper kNullMapper = null;
        System.assertEquals(0, SMapper.toMap(String.class, null, kNullMapper).size());
        System.assertEquals(0, SMapper.toMap(String.class, kSObjects, kNullMapper).size());
        System.assertEquals(0, SMapper.toMap(String.class, null, new SMapper.BasicMapper(Account.BillingState, Account.BillingStreet)).size());
    }
    @IsTest
    static void testBasicSetter() {
        SMapper.ISetter kSetter = new SMapper.BasicSetter(Account.BillingState);
        Set<Object> kSet = new Set<Object>();
        kSetter.add(kSet, TestUtil.treatFields(new Account(), new String[]{ 'BillingState', 'a', 'BillingStreet', '11' }));
        kSetter.add(kSet, TestUtil.treatFields(new Account(), new String[]{ 'BillingState', null, 'BillingStreet', '22' }));
        kSetter.add(null, TestUtil.treatFields(new Account(), new String[]{ 'BillingState', 'c', 'BillingStreet', '33' }));
        kSetter.add(kSet, null);

        System.assertEquals(2, kSet.size()); // null 인자들은 무시되었음
        System.assertEquals('a', new List<Object>(kSet)[0]);
        System.assertEquals(null, new List<Object>(kSet)[1]);
    }
    @IsTest
    static void testNotNullSetter() {
        SMapper.ISetter kSetter = new SMapper.BasicSetter(Account.BillingState).decorator(new SMapper.NotNullDecorator());
        Set<Object> kSet = new Set<Object>();
        kSetter.add(kSet, TestUtil.treatFields(new Account(), new String[]{ 'BillingState', 'a', 'BillingStreet', '11' }));
        kSetter.add(kSet, TestUtil.treatFields(new Account(), new String[]{ 'BillingState', null, 'BillingStreet', '22' }));
        kSetter.add(null, TestUtil.treatFields(new Account(), new String[]{ 'BillingState', 'c', 'BillingStreet', '33' }));
        kSetter.add(kSet, null);

        System.assertEquals(1, kSet.size()); // null 인자들과 null 값은 무시되었음
        System.assertEquals('a', new List<Object>(kSet)[0]);
    }
    @IsTest
    static void testUniqueSetter() {
        SMapper.ISetter kSetter = new SMapper.UniqueSetter(Account.BillingState, Account.BillingStreet);
        Set<Object> kSet = new Set<Object>();
        kSetter.add(kSet, TestUtil.treatFields(new Account(), new String[]{ 'BillingState', 'a', 'BillingStreet', '11' }));
        kSetter.add(kSet, TestUtil.treatFields(new Account(), new String[]{ 'BillingState', null, 'BillingStreet', '22' }));
        kSetter.add(null, TestUtil.treatFields(new Account(), new String[]{ 'BillingState', 'c', 'BillingStreet', '33' }));
        kSetter.add(kSet, null);

        System.assertEquals(2, kSet.size()); // null 인자들은 무시되었음
        System.assertEquals(EXEC_Util.toUniqueKey('a', '11'), new List<Object>(kSet)[0]);
        System.assertEquals(EXEC_Util.toUniqueKey('null', '22'), new List<Object>(kSet)[1]);
    }
    @IsTest
    static void testUniqueSetterDefault() {
        SMapper.ISetter kSetter = new SMapper.UniqueSetter('1000', Account.BillingState, Account.BillingStreet);
        Set<Object> kSet = new Set<Object>();
        kSetter.add(kSet, TestUtil.treatFields(new Account(), new String[]{ 'BillingState', 'a', 'BillingStreet', '11' }));
        kSetter.add(kSet, TestUtil.treatFields(new Account(), new String[]{ 'BillingState', null, 'BillingStreet', '22' }));
        kSetter.add(null, TestUtil.treatFields(new Account(), new String[]{ 'BillingState', 'c', 'BillingStreet', '33' }));
        kSetter.add(kSet, null);

        System.assertEquals(2, kSet.size()); // null 인자들은 무시되었음
        System.assertEquals(EXEC_Util.toUniqueKey('a', '11'), new List<Object>(kSet)[0]);
        System.assertEquals(EXEC_Util.toUniqueKey('1000', '22'), new List<Object>(kSet)[1]);    // 지정한 기본값
    }
    @IsTest
    static void testUniqueSetterFail() {
        SMapper.ISetter kSetter = new SMapper.UniqueSetter('1000', Account.BillingState, Account.BillingStreet)
                .decorator(new DecoFail()); // 항상 실패
        Set<Object> kSet = new Set<Object>();
        kSetter.add(kSet, TestUtil.treatFields(new Account(), new String[]{ 'BillingState', 'a', 'BillingStreet', '11' }));
        kSetter.add(kSet, TestUtil.treatFields(new Account(), new String[]{ 'BillingState', 'b', 'BillingStreet', '22' }));

        System.assertEquals(0, kSet.size()); // 모두 실패 처리
    }
    @IsTest
    static void testBasicMapper() {
        SMapper.IMapper kMapper = new SMapper.BasicMapper(Account.BillingState, Account.BillingStreet);
        Map<String, Object> kMap = new Map<String, Object>();
        kMapper.put(kMap, TestUtil.treatFields(new Account(), new String[]{ 'BillingState', 'a', 'BillingStreet', '1111' }));
        kMapper.put(kMap, TestUtil.treatFields(new Account(), new String[]{ 'BillingState', null, 'BillingStreet', '2222' }));
        kMapper.put(kMap, TestUtil.treatFields(new Account(), new String[]{ 'BillingState', 'c', 'BillingStreet', null }));
        kMapper.put(null, TestUtil.treatFields(new Account(), new String[]{ 'BillingState', 'd', 'BillingStreet', '4444' }));
        kMapper.put(kMap, null);

        System.assertEquals(2, kMap.size()); // null 인자들과 null key 는 무시되었음
        System.assertEquals('1111', kMap.get('a'));
        System.assertEquals(null, kMap.get('c'));   // 값이 null 인 것은 인정
    }
    @IsTest
    static void testBasicMapperFailKey() {
        SMapper.IMapper kMapper = new SMapper.BasicMapper(Account.BillingState, Account.BillingStreet)
                .keyDecorator(new DecoFail());
        Map<String, Object> kMap = new Map<String, Object>();
        kMapper.put(kMap, TestUtil.treatFields(new Account(), new String[]{ 'BillingState', 'a', 'BillingStreet', '1111' }));

        System.assertEquals(0, kMap.size()); // key 실패
    }
    @IsTest
    static void testBasicMapperFailValue() {
        SMapper.IMapper kMapper = new SMapper.BasicMapper(Account.BillingState, Account.BillingStreet)
                .valueDecorator(new DecoFail());
        Map<String, Object> kMap = new Map<String, Object>();
        kMapper.put(kMap, TestUtil.treatFields(new Account(), new String[]{ 'BillingState', 'a', 'BillingStreet', '1111' }));

        System.assertEquals(0, kMap.size()); // value 실패
    }
    @IsTest
    static void testBasicMapperFailKeyValue() {
        SMapper.IMapper kMapper = new SMapper.BasicMapper(Account.BillingState, Account.BillingStreet)
                .keyDecorator(new DecoFail())
                .valueDecorator(new DecoFail());
        Map<String, Object> kMap = new Map<String, Object>();
        kMapper.put(kMap, TestUtil.treatFields(new Account(), new String[]{ 'BillingState', 'a', 'BillingStreet', '1111' }));

        System.assertEquals(0, kMap.size()); // key, value 실패
    }
    @IsTest
    static void testSObjectMapper() {
        SMapper.IMapper kMapper = new SMapper.SObjectMapper(Account.BillingState);
        Map<String, Object> kMap = new Map<String, Object>();
        kMapper.put(kMap, TestUtil.treatFields(new Account(), new String[]{ 'BillingState', 'a', 'BillingStreet', '1111' }));
        kMapper.put(kMap, TestUtil.treatFields(new Account(), new String[]{ 'BillingState', null, 'BillingStreet', '2222' }));
        kMapper.put(kMap, TestUtil.treatFields(new Account(), new String[]{ 'BillingState', 'c', 'BillingStreet', null }));
        kMapper.put(null, TestUtil.treatFields(new Account(), new String[]{ 'BillingState', 'd', 'BillingStreet', '4444' }));
        kMapper.put(kMap, null);

        System.assertEquals(2, kMap.size()); // null 인자들과 null key 는 무시되었음
        System.assertEquals('1111', ((Account) kMap.get('a')).BillingStreet);
        System.assertEquals(null, ((Account) kMap.get('c')).BillingStreet);   // 값이 null 인 것은 인정
    }
    @IsTest
    static void testSObjectMapperFailKey() {
        SMapper.IMapper kMapper = new SMapper.SObjectMapper(Account.BillingState)
                .keyDecorator(new DecoFail());
        Map<String, Object> kMap = new Map<String, Object>();
        kMapper.put(kMap, TestUtil.treatFields(new Account(), new String[]{ 'BillingState', 'a', 'BillingStreet', '1111' }));

        System.assertEquals(0, kMap.size()); // key fail
    }
    @IsTest
    static void testSObjectMapperFailValue() {
        SMapper.IMapper kMapper = new SMapper.SObjectMapper(Account.BillingState)
                .valueDecorator(new DecoFail());
        Map<String, Object> kMap = new Map<String, Object>();
        kMapper.put(kMap, TestUtil.treatFields(new Account(), new String[]{ 'BillingState', 'a', 'BillingStreet', '1111' }));

        System.assertEquals(0, kMap.size()); // value fail
    }
    @IsTest
    static void testSObjectMapperFailKeyValue() {
        SMapper.IMapper kMapper = new SMapper.SObjectMapper(Account.BillingState)
                .keyDecorator(new DecoFail())
                .valueDecorator(new DecoFail());
        Map<String, Object> kMap = new Map<String, Object>();
        kMapper.put(kMap, TestUtil.treatFields(new Account(), new String[]{ 'BillingState', 'a', 'BillingStreet', '1111' }));

        System.assertEquals(0, kMap.size()); // key value fail
    }
    @IsTest
    static void testUniqueMapper() {
        SMapper.IMapper kMapper = new SMapper.UniqueMapper(Account.BillingState, Account.BillingStreet);
        Map<String, Object> kMap = new Map<String, Object>();
        kMapper.put(kMap, TestUtil.treatFields(new Account(), new String[]{ 'Name', '1', 'BillingState', 'a', 'BillingStreet', '1111' }));
        kMapper.put(kMap, TestUtil.treatFields(new Account(), new String[]{ 'Name', '2', 'BillingState', null, 'BillingStreet', '2222' }));
        kMapper.put(kMap, TestUtil.treatFields(new Account(), new String[]{ 'Name', '3', 'BillingState', 'c', 'BillingStreet', null }));
        kMapper.put(null, TestUtil.treatFields(new Account(), new String[]{ 'BillingState', 'd', 'BillingStreet', '4444' }));
        kMapper.put(kMap, null);

        System.assertEquals(3, kMap.size()); // null 인자들과 null key 는 무시되었음
        System.assertEquals('1', ((Account) kMap.get(EXEC_Util.toUniqueKey('a', '1111'))).Name);
        System.assertEquals('2', ((Account) kMap.get(EXEC_Util.toUniqueKey('null', '2222'))).Name);
        System.assertEquals('3', ((Account) kMap.get(EXEC_Util.toUniqueKey('c', 'null'))).Name);
    }
    @IsTest
    static void testUniqueMapperDefault() {
        SMapper.IMapper kMapper = new SMapper.UniqueMapper('1000', Account.BillingState, Account.BillingStreet);
        Map<String, Object> kMap = new Map<String, Object>();
        kMapper.put(kMap, TestUtil.treatFields(new Account(), new String[]{ 'Name', '1', 'BillingState', 'a', 'BillingStreet', '1111' }));
        kMapper.put(kMap, TestUtil.treatFields(new Account(), new String[]{ 'Name', '2', 'BillingState', null, 'BillingStreet', '2222' }));
        kMapper.put(kMap, TestUtil.treatFields(new Account(), new String[]{ 'Name', '3', 'BillingState', 'c', 'BillingStreet', null }));
        kMapper.put(null, TestUtil.treatFields(new Account(), new String[]{ 'BillingState', 'd', 'BillingStreet', '4444' }));
        kMapper.put(kMap, null);

        System.assertEquals(3, kMap.size()); // null 인자들과 null key 는 무시되었음
        System.assertEquals('1', ((Account) kMap.get(EXEC_Util.toUniqueKey('a', '1111'))).Name);
        System.assertEquals('2', ((Account) kMap.get(EXEC_Util.toUniqueKey('1000', '2222'))).Name);    // 지정한 기본값
        System.assertEquals('3', ((Account) kMap.get(EXEC_Util.toUniqueKey('c', 'null'))).Name);
    }
    @IsTest
    static void testUniqueMapperFailKey() {
        SMapper.IMapper kMapper = new SMapper.UniqueMapper('1000', Account.BillingState, Account.BillingStreet)
                .keyDecorator(new DecoFail());
        Map<String, Object> kMap = new Map<String, Object>();
        kMapper.put(kMap, TestUtil.treatFields(new Account(), new String[]{ 'Name', '1', 'BillingState', 'a', 'BillingStreet', '1111' }));

        System.assertEquals(0, kMap.size()); // key fail
    }
    @IsTest
    static void testUniqueMapperFailValue() {
        SMapper.IMapper kMapper = new SMapper.UniqueMapper('1000', Account.BillingState, Account.BillingStreet)
                .valueDecorator(new DecoFail());
        Map<String, Object> kMap = new Map<String, Object>();
        kMapper.put(kMap, TestUtil.treatFields(new Account(), new String[]{ 'Name', '1', 'BillingState', 'a', 'BillingStreet', '1111' }));

        System.assertEquals(0, kMap.size()); // key fail
    }
    @IsTest
    static void testUniqueMapperFailKeyValue() {
        SMapper.IMapper kMapper = new SMapper.UniqueMapper('1000', Account.BillingState, Account.BillingStreet)
                .keyDecorator(new DecoFail())
                .valueDecorator(new DecoFail());
        Map<String, Object> kMap = new Map<String, Object>();
        kMapper.put(kMap, TestUtil.treatFields(new Account(), new String[]{ 'Name', '1', 'BillingState', 'a', 'BillingStreet', '1111' }));

        System.assertEquals(0, kMap.size()); // key value fail
    }
    @IsTest
    static void testDecoratorContext() {
        SMapper.DecoratorContext kContext = new SMapper.DecoratorContext('aa');
        System.assertEquals(true, kContext.isSuccess);
        System.assertEquals('aa', kContext.value);
    }

    @IsTest
    static void testAbstractSetter() {
        SMapper.AbstractSetter kSetter = new TestSetter();
        kSetter.decorator(new Deco1())
                .decorator(new Deco2())
                .decorator(new Deco4());

        System.assertEquals('0124', kSetter.decorate(new SMapper.DecoratorContext('0')).value);
        System.assertEquals(true, kSetter.decorate(new SMapper.DecoratorContext('0')).isSuccess);
    }

    @IsTest
    static void testAbstractSetterFail() {
        SMapper.AbstractSetter kSetter = new TestSetter();
        kSetter.decorator(new Deco1())
                .decorator(new DecoFail())
                .decorator(new Deco4());

        System.assertEquals('01', kSetter.decorate(new SMapper.DecoratorContext('0')).value);
        System.assertEquals(false, kSetter.decorate(new SMapper.DecoratorContext('0')).isSuccess);
    }

    @IsTest
    static void testAbstractMapper() {
        SMapper.AbstractMapper kMapper = new TestMapper();
        kMapper.keyDecorator(new Deco1())
                .keyDecorator(new Deco2())
                .keyDecorator(new Deco4());
        kMapper.valueDecorator(new Deco4())
                .valueDecorator(new Deco1())
                .valueDecorator(new Deco2());

        System.assertEquals('0124', kMapper.decorateKey(new SMapper.DecoratorContext('0')).value);
        System.assertEquals(true, kMapper.decorateKey(new SMapper.DecoratorContext('0')).isSuccess);
        System.assertEquals('0412', kMapper.decorateValue(new SMapper.DecoratorContext('0')).value);
        System.assertEquals(true, kMapper.decorateValue(new SMapper.DecoratorContext('0')).isSuccess);
    }

    @IsTest
    static void testAbstractMapperFail() {
        SMapper.AbstractMapper kMapper = new TestMapper();
        kMapper.keyDecorator(new Deco1())
                .keyDecorator(new DecoFail())
                .keyDecorator(new Deco4());
        kMapper.valueDecorator(new Deco4())
                .valueDecorator(new DecoFail())
                .valueDecorator(new Deco2());

        System.assertEquals('01', kMapper.decorateKey(new SMapper.DecoratorContext('0')).value);
        System.assertEquals(false, kMapper.decorateKey(new SMapper.DecoratorContext('0')).isSuccess);
        System.assertEquals('04', kMapper.decorateValue(new SMapper.DecoratorContext('0')).value);
        System.assertEquals(false, kMapper.decorateValue(new SMapper.DecoratorContext('0')).isSuccess);
    }

    @IsTest
    static void testLowercaseDecorator() {
        SMapper.AbstractSetter kSetter = new TestSetter();
        kSetter.decorator(new SMapper.LowercaseDecorator()); // 항상 성공

        System.assertEquals('abcd', kSetter.decorate(new SMapper.DecoratorContext('ABCD')).value);
        System.assertEquals(true, kSetter.decorate(new SMapper.DecoratorContext('ABCD')).isSuccess);
        System.assertEquals(null, kSetter.decorate(new SMapper.DecoratorContext(null)).value);
        System.assertEquals(true, kSetter.decorate(new SMapper.DecoratorContext(null)).isSuccess);
    }

    @IsTest
    static void testNotBlankDecorator() {
        SMapper.IDecorator kDecorator = new SMapper.NotBlankDecorator();
        System.assertEquals(false, kDecorator.decorate(new SMapper.DecoratorContext(null)).isSuccess);
        System.assertEquals(null, kDecorator.decorate(new SMapper.DecoratorContext(null)).value);
        System.assertEquals(false, kDecorator.decorate(new SMapper.DecoratorContext('')).isSuccess);
        System.assertEquals(false, kDecorator.decorate(new SMapper.DecoratorContext('  ')).isSuccess);
        System.assertEquals(true, kDecorator.decorate(new SMapper.DecoratorContext('asdf')).isSuccess);
        System.assertEquals('asdf', kDecorator.decorate(new SMapper.DecoratorContext('asdf')).value);
    }

    @IsTest
    static void testNotNullDecorator() {
        SMapper.AbstractSetter kSetter = new TestSetter();
        kSetter.decorator(new SMapper.NotNullDecorator());  // null 이면 실패

        System.assertEquals('ABCD', kSetter.decorate(new SMapper.DecoratorContext('ABCD')).value);
        System.assertEquals(true, kSetter.decorate(new SMapper.DecoratorContext('ABCD')).isSuccess);
        System.assertEquals(null, kSetter.decorate(new SMapper.DecoratorContext(null)).value);
        System.assertEquals(false, kSetter.decorate(new SMapper.DecoratorContext(null)).isSuccess);
    }


    public class TestSetter extends SMapper.AbstractSetter {
        public void add(Set<Object> aSet, SObject aSObject) {
        }
    }

    public class TestMapper extends SMapper.AbstractMapper {
        public void put(Map<String, Object> aMap, SObject aSObject) {
        }
    }

    public class Deco1 implements SMapper.IDecorator {
        public SMapper.DecoratorContext decorate(SMapper.DecoratorContext aContext) {
            aContext.value = aContext.value + '1';
            return aContext;
        }
    }
    public class Deco2 implements SMapper.IDecorator {
        public SMapper.DecoratorContext decorate(SMapper.DecoratorContext aContext) {
            aContext.value = aContext.value + '2';
            return aContext;
        }
    }
    public class Deco4 implements SMapper.IDecorator {
        public SMapper.DecoratorContext decorate(SMapper.DecoratorContext aContext) {
            aContext.value = aContext.value + '4';
            return aContext;
        }
    }
    public class DecoFail implements SMapper.IDecorator {
        public SMapper.DecoratorContext decorate(SMapper.DecoratorContext aContext) {
            aContext.isSuccess = false;
            return aContext;
        }
    }
}