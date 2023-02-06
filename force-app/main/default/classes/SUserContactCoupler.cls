/**
 * User 와 Contact 이 동일한 이메일이라면 Contact 에 UserId 를 lookup 한다.
 * 각 Object 가 추가/삭제/수정 되는 경우 이에 맞게 처리해준다.
 * 데이터만 입력하고 DML 은 실행하지 않으므로 반환하는 데이터를 적절히 이용해야한다.
 *
 * Created by hyodongmin on 2022/10/07.
 */

public with sharing class SUserContactCoupler {
  /**
   * User insert 시 사용.
   * User 에 변경이 있는 경우 다음과 같이 처리한다.
   * <pre>
   * - 추가: 입력된 이메일과 동일한 Contact 에 UserId 를 입력한다.
   * - 수정: 이전 연결은 끊고, 수정된 이메일과 동일한 Contact 에 UserId 를 입력한다.
   * - 삭제(Inactive): 아무런 처리도 하지 않는다.
   * </pre>
   *
   * @param aNewUsers User List New
   *
   * @return Contact 목록
   */
  public List<Contact> couple(List<User> aNewUsers) {
    if (null != aNewUsers) {
      // insert
      return persistUserId(aNewUsers);
    }
    return new List<Contact>();
  }

  /**
   * User update 시 사용.
   * User 에 변경이 있는 경우 다음과 같이 처리한다.
   * <pre>
   * - 추가: 입력된 이메일과 동일한 Contact 에 UserId 를 입력한다.
   * - 수정: 이전 연결은 끊고, 수정된 이메일과 동일한 Contact 에 UserId 를 입력한다.
   * - 삭제(Inactive): 아무런 처리도 하지 않는다.
   * </pre>
   * update 인 경우 수정된 User 의 수보다 큰 수의 목록이 반환 될 수 있다.
   *
   * @param aOldMap User Map Old
   * @param aNewMap User Map New
   *
   * @return Contact 목록
   */
  public List<Contact> couple(Map<Id, User> aOldMap, Map<Id, User> aNewMap) {
    if (null != aOldMap && null != aNewMap) {
      // update
      // 이메일이 수정된 것만 처리
      List<User> kUsers = new List<User>();
      for (User kNew : aNewMap.values()) {
        // update 가 필요한 것만 추출
        User kOld = aOldMap.get(kNew.Id);
        // 사번번호만 수정된 것
        if (kNew.IsActive && kNew.EmployeeNumber != kOld.EmployeeNumber) {
          kUsers.add(kNew);
        }
      }

      if (false == kUsers.isEmpty()) {
        List<Contact> kContacts = persistUserId(kUsers);

        // 수정된 UserId 와 연결된 기존 Contact 끊기
        List<Contact> kOldContacts = removeLeavedUserId(kUsers, kContacts);

        kContacts.addAll(kOldContacts); // 업데이트 될 것과 삭제 된 것 병합

        return kContacts;
      }
      return new List<Contact>();
    }
    // do nothing
    return new List<Contact>();
  }

  @TestVisible
  private static List<Contact> removeLeavedUserId(
    List<User> aUsers,
    List<Contact> aUpdatedContacts
  ) {
    // 업데이트되지 않은 것 중 기존 유저들은 제거
    List<Contact> kOldContacts = [
      SELECT Id, EmployeeNumber__c
      FROM Contact
      WHERE UserId__c IN :aUsers AND Id NOT IN :aUpdatedContacts
    ];
    for (Contact kOldContact : kOldContacts) {
      kOldContact.UserId__c = null;
    }
    return kOldContacts;
  }

  @TestVisible
  private static List<Contact> persistUserId(List<User> aUsers) {
    Set<String> kEmails = SMapper.toStringSet(
      SMapper.toSet(
        aUsers,
        new SMapper.BasicSetter(User.EmployeeNumber)
          .decorator(new SMapper.LowercaseDecorator())
      )
    );

    List<Contact> kContacts = [
      SELECT Id, EmployeeNumber__c
      FROM Contact
      WHERE EmployeeNumber__c IN :kEmails
    ]; // 입력한 이메일과 동일한 Contact

    Map<String, Id> kEmail2UserIdMap = (Map<String, Id>) SMapper.toMap(
      Id.class,
      aUsers,
      new SMapper.BasicMapper(User.EmployeeNumber, User.Id)
        .keyDecorator(new SMapper.LowercaseDecorator())
    );

    for (Contact kContact : kContacts) {
      if (String.isNotBlank(kContact.EmployeeNumber__c)) {
        kContact.UserId__c = kEmail2UserIdMap.get(kContact.EmployeeNumber__c); // 이메일이 동일한 User
      }
    }
    return kContacts;
  }

  /**
   * Contact Insert 시 사용
   * Contact 에 변경이 있는 경우 다음과 같이 처리한다.
   * <pre>
   * - 추가: 입력된 이메일과 동일한 UserId 를 입력한다.
   * - 수정: User 로 부터 수정된 경우도 있으므로 각 필드의 값을 이전과 대조하여 처리해야한다. (BeforeUpdate)
   *        -> UserId 는 동일하고 이메일이 수정된 경우: 입력된 이메일과 동일한 UserId 를 입력한다.
   *        -> 이메일은 동일하고 UserId 가 수정된 경우: User 에서 수정. 아무 처리도 하지 않는다.
   * - 삭제: 아무런 처리도 하지 않는다.
   * </pre>
   *
   * @param aNewContacts Contact Map New
   *
   */
  public void couple(List<Contact> aNewContacts) {
    if (null != aNewContacts) {
      // insert
      // 이메일 변환 후 User 맵핑
      persistUserId(aNewContacts);
    }
  }
  /**
   * Contact Update 시 사용
   * Contact 에 변경이 있는 경우 다음과 같이 처리한다.
   * <pre>
   * - 추가: 입력된 이메일과 동일한 UserId 를 입력한다.
   * - 수정: User 로 부터 수정된 경우도 있으므로 각 필드의 값을 이전과 대조하여 처리해야한다. (BeforeUpdate)
   *        -> UserId 는 동일하고 이메일이 수정된 경우: 입력된 이메일과 동일한 UserId 를 입력한다.
   *        -> 이메일은 동일하고 UserId 가 수정된 경우: User 에서 수정. 아무 처리도 하지 않는다.
   * - 삭제: 아무런 처리도 하지 않는다.
   * </pre>
   *
   * @param aOldMap Contact Map Old
   * @param aNewMap Contact Map New
   *
   */
  public void couple(Map<Id, Contact> aOldMap, Map<Id, Contact> aNewMap) {
    if (null != aOldMap && null != aNewMap) {
      // update
      List<Contact> kContacts = new List<Contact>();
      for (Contact kNew : aNewMap.values()) {
        // update 가 필요한 것만 추출
        Contact kOld = aOldMap.get(kNew.Id);
        if (
          kNew.IsEmployee__c &&
          kNew.UserId__c == kOld.UserId__c &&
          kNew.EmployeeNumber__c != kOld.EmployeeNumber__c
        ) {
          // 이메일만 수정된 것
          kContacts.add(kNew);
        }
      }
      if (false == kContacts.isEmpty()) {
        persistUserId(kContacts);
      }
    }
  }

  @TestVisible
  private static void persistUserId(List<Contact> aContacts) {
    Set<String> kEmails = SMapper.toStringSet(
      SMapper.toSet(
        aContacts,
        new SMapper.BasicSetter(Contact.EmployeeNumber__c)
          .decorator(new SMapper.LowercaseDecorator())
      )
    );

    List<User> kUsers = [
      SELECT Id, EmployeeNumber
      FROM User
      WHERE EmployeeNumber = :kEmails AND IsActive = TRUE
    ];

    Map<String, Id> kEmail2UserIdMap = (Map<String, Id>) SMapper.toMap(
      Id.class,
      kUsers,
      new SMapper.BasicMapper(User.EmployeeNumber, User.Id)
        .keyDecorator(new SMapper.LowercaseDecorator())
    );

    for (Contact kContact : aContacts) {
      if (String.isNotBlank(kContact.EmployeeNumber__c)) {
        kContact.UserId__c = kEmail2UserIdMap.get(
          kContact.EmployeeNumber__c.toLowerCase()
        ); // 이메일이 동일한 User 없으면 null
      }
    }
  }
}