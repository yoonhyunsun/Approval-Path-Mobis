/**
 * SObject 의 값을 이용해 Set, Map 등으로 맵핑할 때 사용한다.
 * <pre>
 *     // Contact 의 Email 값을 나열한 Set
 *     Set<String> kEmails = SMapper.toStringSet(SMapper.toSet(aContacts, Contact.Email));
 *     // Contact 의 Email 값을 나열한 Set - Null 제외
 *     Set<String> kEmails = SMapper.toStringSet(SMapper.toSet(aContacts, new SMapper.BasicSetter(Contact.Email).decorator(new SMapper.NotNullDecorator())));
 *     // User 의 Email 과 Id 를 key 와 value 로 이용한 Map
 *     Map<String, Id> kEmail2IdMap = (Map<String, Id>) SMapper.toMap(Id.class, kUsers, User.Email, User.Id);
 *     // Value 에 SObject 를 지정
 *     (Map<String, Department__c>) SMapper.toMap(Department__c.class, kDepartments, Department__c.Department_Number__c);
 *  </pre>
 *
 * Created by hyodongmin on 2022/09/20.
 */

public with sharing class SMapper {
    /**
     * Set&lt;Object> 를 Set&lt;Id> 으로 변환
     * - Set 은 Map 과 달리 generic up-casting 이 불가하여 loop 변환이 필요하다.
     *
     * @param aSet Set&lt;Object>
     *
     * @return Set&lt;Id>
     */
    public static Set<Id> toIdSet(Set<Object> aSet) {
        Set<Id> kSet = new Set<Id>();
        if (null == aSet || aSet.isEmpty()) {
            return kSet;
        }
        for (Object kObj : aSet) {
            kSet.add((Id) kObj);
        }
        return kSet;
    }
    /**
     * Set&lt;Object> 를 Set&lt;String> 으로 변환
     * - Set 은 Map 과 달리 generic up-casting 이 불가하여 loop 변환이 필요하다.
     *
     * @param aSet Set&lt;Object>
     *
     * @return Set&lt;String>
     */
    public static Set<String> toStringSet(Set<Object> aSet) {
        Set<String> kSet = new Set<String>();
        if (null == aSet || aSet.isEmpty()) {
            return kSet;
        }
        for (Object kObj : aSet) {
            kSet.add((String) kObj);
        }
        return kSet;
    }

    /**
     * 배열의 특정 값들을 세트로 반환
     *
     * @param aSObjects SObject list
     * @param aKeyField 값을 이용할 필드
     *
     * @return Set&lt;Object> 값들의 세트
     */
    public static Set<Object> toSet(List<SObject> aSObjects, SObjectField aKeyField) {
        if (null == aSObjects || null == aKeyField) {
            return new Set<Object>();
        }
        return toSet(aSObjects, new BasicSetter(aKeyField));
    }

    /**
     * 배열의 특정 값들을 세트로 반환
     *
     * @param aSObjects SObject list
     * @param aSetter ISetter 값을 입력하는 interface
     *
     * @return Set&lt;Object> 값들의 세트
     */
    public static Set<Object> toSet(List<SObject> aSObjects, ISetter aSetter) {
        Set<Object> kSet = new Set<Object>();
        if (null == aSObjects || null == aSetter) {
            return kSet;
        }

        for (SObject kSObj : aSObjects) {
            aSetter.add(kSet, kSObj);
        }
        return kSet;
    }

    /**
     * 배열을 특정 Map&lt;String, Object> 로 변환
     *
     * @param aType Object type
     * @param aSObjects  SObject list
     * @param aKeyField 키로 사용할 필드
     * @param aValueField 값으로 사용할 필드, null 이면 객체를 값으로 이용
     *
     * @return Map&lt;String, Object>
     */
    public static Map<String, Object> toMap(Type aType, List<SObject> aSObjects, SObjectField aKeyField, SObjectField aValueField) {
        if (null == aSObjects || null == aKeyField || null == aValueField) {
            return (Map<String, Object>) Type.forName('Map<String,' + aType.getName() + '>').newInstance();
        }
        return toMap(aType, aSObjects, new BasicMapper(aKeyField, aValueField));
    }

    /**
     * 배열을 특정 Map&lt;String, Object> 로 변환
     *
     * @param aType Object type
     * @param aSObjects  SObject list
     * @param aKeyField 키로 사용할 필드
     *
     * @return Map&lt;String, Object>
     */
    public static Map<String, Object> toMap(Type aType, List<SObject> aSObjects, SObjectField aKeyField) {
        if (null == aSObjects || null == aKeyField) {
            return (Map<String, Object>) Type.forName('Map<String,' + aType.getName() + '>').newInstance();
        }
        return toMap(aType, aSObjects, new SObjectMapper(aKeyField));
    }


    /**
     * 배열을 특정 Map&lt;String, Object> 로 변환
     *
     * @param aType Object type
     * @param aSObjects  SObject list
     * @param aMapper IMapper
     *
     * @return Map&lt;String, Object>
     */
    public static Map<String, Object> toMap(Type aType, List<SObject> aSObjects, IMapper aMapper) {
        Type kType = Type.forName('Map<String,' + aType.getName() + '>');
        Map<String, Object> kMap = (Map<String, Object>) kType.newInstance();
        if (null == aSObjects || null == aMapper) {
            return kMap;
        }
        for (SObject kObj : aSObjects) {
            aMapper.put(kMap, kObj);
        }

        return kMap;
    }

    // ***************************************
    // interface / abstract
    // ***************************************
    public interface ISetter {
        void add(Set<Object> aSet, SObject aSObject);
    }

    public interface IMapper {
        void put(Map<String, Object> aMap, SObject aSObject);
    }

    /**
     * DecoratorContext
     */
    public class DecoratorContext {
        public Object value;
        public Boolean isSuccess = true;    // value 처리에 실패한 경우 false, false 인 value 는 제외된다.
        public DecoratorContext(Object aValue) {
            value = aValue;
        }
    }

    /**
     * IDecorator
     */
    public interface IDecorator {
        DecoratorContext decorate(DecoratorContext aContext);
    }

    private class DecoratorSet {
        protected Set<IDecorator> decorators = new Set<IDecorator>();

        public void add(IDecorator aDecorator) {
            decorators.add(aDecorator);
        }
        public DecoratorContext decorate(DecoratorContext aContext) {
            for (IDecorator kDecorator : decorators) {
                aContext = kDecorator.decorate(aContext);
                if (false == aContext.isSuccess) {
                    break;
                }
            }
            return aContext;
        }
    }

    /**
     * AbstractSetter
     */
    public abstract class AbstractSetter implements ISetter {
        protected DecoratorSet decorator = new DecoratorSet();

        public AbstractSetter decorator(IDecorator aDecorator) {
            decorator.add(aDecorator);
            return this;
        }
        public DecoratorContext decorate(DecoratorContext aContext) {
            return decorator.decorate(aContext);
        }
    }

    /**
     * AbstractMapper
     */
    public abstract class AbstractMapper implements IMapper {
        protected DecoratorSet keyDecorator = new DecoratorSet();
        protected DecoratorSet valueDecorator = new DecoratorSet();

        public AbstractMapper keyDecorator(IDecorator aDecorator) {
            keyDecorator.add(aDecorator);
            return this;
        }
        public DecoratorContext decorateKey(DecoratorContext aContext) {
            return keyDecorator.decorate(aContext);
        }

        public AbstractMapper valueDecorator(IDecorator aDecorator) {
            valueDecorator.add(aDecorator);
            return this;
        }
        public DecoratorContext decorateValue(DecoratorContext aContext) {
            return valueDecorator.decorate(aContext);
        }
    }

    // ***************************************
    // Decorator
    // ***************************************
    /**
     * String value 를 소문자로 변환, 실패 없음 (null 인 경우 그대로 null 을 반환)
     */
    public class LowercaseDecorator implements IDecorator {
        public DecoratorContext decorate(DecoratorContext aContext) {
            Object a = aContext.value;
            aContext.value = null == a ? a : ((String) a).toLowerCase();
            return aContext;
        }
    }
    /**
     * Value 가 String.isBlank() 인 경우 실패
     */
    public class NotBlankDecorator implements IDecorator {
        public DecoratorContext decorate(DecoratorContext aContext) {
            if (String.isBlank((String) aContext.value)) {
                aContext.isSuccess = false;
            }
            return aContext;
        }
    }
    /**
     * Value 가 null 인 경우 실패
     */
    public class NotNullDecorator implements IDecorator {
        public DecoratorContext decorate(DecoratorContext aContext) {
            if (null == aContext.value) {
                aContext.isSuccess = false;
            }
            return aContext;
        }
    }

    // ***************************************
    // Setter / Mapper
    // ***************************************
    /**
     * SObject 의 값을 세트에 저장
     */
    public class BasicSetter extends AbstractSetter {
        final SObjectField key;
        public BasicSetter(SObjectField aKey) {
            key = aKey;
        }
        public void add(Set<Object> aSet, SObject aSObject) {
            if (null != aSet && null != aSObject) {
                DecoratorContext kContext = decorate(new DecoratorContext(aSObject.get(key)));
                if (kContext.isSuccess) {
                    aSet.add(kContext.value);
                }
            }
        }
    }

    /**
     * SObject 의 값으로 고유키를 생성하여 세트에 저장
     */
    public class UniqueSetter extends AbstractSetter {
        final SObjectField key1;
        final SObjectField key2;
        final String defaultPrefix;
        public UniqueSetter(SObjectField aKey1, SObjectField aKey2) {
            key1 = aKey1;
            key2 = aKey2;
        }
        public UniqueSetter(String aDefaultPrefix, SObjectField aKey1, SObjectField aKey2) {
            defaultPrefix = aDefaultPrefix;
            key1 = aKey1;
            key2 = aKey2;
        }
        public void add(Set<Object> aSet, SObject aSObject) {
            if (null != aSet && null != aSObject) {
                String kBranchCode = null == aSObject.get(key1) ? defaultPrefix : (String) aSObject.get(key1);
                DecoratorContext kContext = decorate(new DecoratorContext(EXEC_Util.toUniqueKey(kBranchCode, (String) aSObject.get(key2))));
                if (kContext.isSuccess) {
                    aSet.add(kContext.value);
                }
            }
        }
    }

    /**
     * 지정한 Key 필드의 값을 키로 사용하여 value 필드의 값을 저장
     */
    public class BasicMapper extends AbstractMapper {
        final SObjectField key;
        final SObjectField value;
        public BasicMapper(SObjectField aKeyField, SObjectField aValueField) {
            key = aKeyField;
            value = aValueField;
        }

        public void put(Map<String, Object> aMap, SObject aSObject) {
            if (null != aMap && null != aSObject && null != aSObject.get(key)) {
                DecoratorContext kKeyContext = decorateKey(new DecoratorContext(aSObject.get(key)));
                DecoratorContext kValueContext = decorateValue(new DecoratorContext(aSObject.get(value)));
                if (kKeyContext.isSuccess && kValueContext.isSuccess) {
                    aMap.put((String) kKeyContext.value, kValueContext.value);
                }
            }
        }
    }

    /**
     * 지정한 Key 필드의 값을 키로 사용하여 SObject 를 저장
     */
    public class SObjectMapper extends AbstractMapper {
        final SObjectField key;
        public SObjectMapper(SObjectField aKeyField) {
            key = aKeyField;
        }

        public void put(Map<String, Object> aMap, SObject aSObject) {
            if (null != aMap && null != aSObject && null != aSObject.get(key)) {
                DecoratorContext kKeyContext = decorateKey(new DecoratorContext(aSObject.get(key)));
                DecoratorContext kValueContext = decorateValue(new DecoratorContext(aSObject));
                if (kKeyContext.isSuccess && kValueContext.isSuccess) {
                    aMap.put((String) kKeyContext.value, kValueContext.value);
                }
            }
        }
    }

    /**
     * SObject 의 값으로 고유키를 생성하여 SObject 를 저장
     */
    public class UniqueMapper extends AbstractMapper {
        final SObjectField key1;
        final SObjectField key2;
        final String defaultPrefix;
        public UniqueMapper(SObjectField aKey1, SObjectField aKey2) {
            key1 = aKey1;
            key2 = aKey2;
        }
        public UniqueMapper(String aDefaultPrefix, SObjectField aKey1, SObjectField aKey2) {
            defaultPrefix = aDefaultPrefix;
            key1 = aKey1;
            key2 = aKey2;
        }
        public void put(Map<String, Object> aMap, SObject aSObject) {
            if (null != aMap && null != aSObject) {
                String kBranchCode = null == aSObject.get(key1) ? defaultPrefix : (String) aSObject.get(key1);
                DecoratorContext kKeyContext = decorateKey(new DecoratorContext(EXEC_Util.toUniqueKey(kBranchCode, (String) aSObject.get(key2))));
                DecoratorContext kValueContext = decorateValue(new DecoratorContext(aSObject));
                if (kKeyContext.isSuccess && kValueContext.isSuccess) {
                    aMap.put((String) kKeyContext.value, kValueContext.value);
                }
            }
        }
    }

}