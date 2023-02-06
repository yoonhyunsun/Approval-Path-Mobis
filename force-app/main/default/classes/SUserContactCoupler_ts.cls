/**
 * Created by hyodongmin on 2022/10/07.
 */

@IsTest
private class SUserContactCoupler_ts {
  @IsTest
  static void testCoupleUserInsert() {
    List<User> kUsers = insertUsers();
    insertContacts();

    List<Contact> kResults = new SUserContactCoupler().couple(kUsers);
    System.assertEquals(2, kResults.size()); // 업데이트가 필요한 Contact
    System.assertEquals(
      [SELECT Id FROM User WHERE EmployeeNumber = 'aaa@a.bc']
      .Id,
      kResults[0].UserId__c
    );
    System.assertEquals(
      [SELECT Id FROM User WHERE EmployeeNumber = 'bbb@a.bc']
      .Id,
      kResults[1].UserId__c
    );

    kUsers = null;
    System.assertEquals(0, new SUserContactCoupler().couple(kUsers).size());
  }

  @IsTest
  static void testCoupleUserUpdate() {
    List<User> kUsers = insertUsers();

    Id kRecordTypeId = SUtil.getRecordTypeId(Contact.class, 'Employee');
    List<Contact> kContacts = new List<Contact>{
      new Contact(
        EmployeeNumber__c = 'bbb@a.bc',
        LastName = 'Bbb',
        IsEmployee__c = true,
        RecordTypeId = kRecordTypeId
      ),
      new Contact(
        EmployeeNumber__c = 'ooo@a.bc',
        UserId__c = kUsers[0].Id,
        LastName = 'Bbb',
        IsEmployee__c = true,
        RecordTypeId = kRecordTypeId
      ),
      new Contact(
        EmployeeNumber__c = 'xxx@a.bc',
        UserId__c = kUsers[3].Id,
        LastName = 'Ccc',
        IsEmployee__c = true,
        RecordTypeId = kRecordTypeId
      )
    };
    insert kContacts;

    Map<Id, User> kOldMap = new Map<Id, User>(kUsers);
    Map<Id, User> kNewMap = new Map<Id, User>{
      kUsers[0].Id => (User) new User(
        Id = kUsers[0].Id,
        EmployeeNumber = 'bbb@a.bc',
        IsActive = true
      ), // 이메일 수정
      kUsers[1].Id => (User) new User(
        Id = kUsers[1].Id,
        EmployeeNumber = 'pppppp@a.bc',
        IsActive = false
      ), // 이메일 수정, active = false
      kUsers[2].Id => (User) new User(
        Id = kUsers[2].Id,
        EmployeeNumber = kUsers[2].EmployeeNumber,
        IsActive = true
      )
    };
    List<Contact> kResults = new SUserContactCoupler().couple(kOldMap, kNewMap);
    System.assertEquals(2, kResults.size()); // 새로 지정한 1개, 연결 끊은 1개
    System.assertEquals('bbb@a.bc', kResults[0].EmployeeNumber__c); // 변경된 이메일
    System.assertEquals(kUsers[0].Id, kResults[0].UserId__c); // 아이디 지정
    System.assertEquals('ooo@a.bc', kResults[1].EmployeeNumber__c); // 이전 이메일
    System.assertEquals(null, kResults[1].UserId__c); // 아이디 해제
  }

  @IsTest
  static void testCoupleUserUpdateEmpty() {
    Map<Id, User> kOldMap = new Map<Id, User>{
      '01p9D0000030Kyk' => (User) TestUtil.treatField(
        new User(EmployeeNumber = 'xxx@a.bc', IsActive = true),
        'Id',
        '01p9D0000030Kyk'
      )
    };
    Map<Id, User> kNewMap = new Map<Id, User>{
      '01p9D0000030Kyk' => (User) TestUtil.treatField(
        new User(EmployeeNumber = 'xxx@a.bc', IsActive = true),
        'Id',
        '01p9D0000030Kyk'
      )
    };
    List<Contact> kResults = new SUserContactCoupler().couple(kOldMap, kNewMap);
    System.assertEquals(0, kResults.size());
  }
  @IsTest
  static void testCoupleUserDelete() {
    Map<Id, User> kMap = new Map<Id, User>{ '01p9D0000030Kyi' => new User() };
    List<Contact> kContacts = new SUserContactCoupler().couple(kMap, null);

    System.assertEquals(0, kContacts.size());
  }
  @IsTest
  static void testRemoveLeavedUserId() {
    List<User> kUsers = insertUsers();

    Id kRecordTypeId = SUtil.getRecordTypeId(Contact.class, 'Employee');
    List<Contact> kContacts = new List<Contact>{
      new Contact(
        EmployeeNumber__c = 'aaa@a.bc',
        LastName = 'Aaa',
        IsEmployee__c = true,
        RecordTypeId = kRecordTypeId
      ),
      new Contact(
        EmployeeNumber__c = 'ooo@a.bc',
        UserId__c = kUsers[0].Id,
        LastName = 'Bbb',
        IsEmployee__c = true,
        RecordTypeId = kRecordTypeId
      ),
      new Contact(
        EmployeeNumber__c = 'ppp@a.bc',
        UserId__c = kUsers[1].Id,
        LastName = 'Ccc',
        IsEmployee__c = true,
        RecordTypeId = kRecordTypeId
      )
    };
    insert kContacts;

    List<Contact> kResults = SUserContactCoupler.persistUserId(kUsers);

    List<Contact> kResults2 = SUserContactCoupler.removeLeavedUserId(
      kUsers,
      kResults
    );
    System.assertEquals(2, kResults2.size()); // 이전 이메일에 연결됐던 Contact 2개
    System.assertEquals(null, kResults2[0].UserId__c); // UserId 제거
    System.assertEquals(null, kResults2[1].UserId__c); // UserId 제거
  }
  @IsTest
  static void testPersistUserIdUser() {
    List<User> kUsers = insertUsers();
    insertContacts();

    List<Contact> kResults = SUserContactCoupler.persistUserId(kUsers);
    System.assertEquals(2, kResults.size()); // 업데이트가 필요한 Contact
    System.assertEquals(
      [SELECT Id FROM User WHERE EmployeeNumber = 'aaa@a.bc']
      .Id,
      kResults[0].UserId__c
    );
    System.assertEquals(
      [SELECT Id FROM User WHERE EmployeeNumber = 'bbb@a.bc']
      .Id,
      kResults[1].UserId__c
    );
  }
  @IsTest
  static void testPersistUserIdUser2() {
    List<User> kUsers = insertUsers();
    for (User kUser : kUsers) {
      kUser.EmployeeNumber = kUser.EmployeeNumber.capitalize(); // 대소문자 구분없이 처리
    }
    insertContacts();

    List<Contact> kResults = SUserContactCoupler.persistUserId(kUsers);
    System.assertEquals(2, kResults.size()); // 업데이트가 필요한 Contact
    System.assertEquals(
      [SELECT Id FROM User WHERE EmployeeNumber = 'aaa@a.bc']
      .Id,
      kResults[0].UserId__c
    );
    System.assertEquals(
      [SELECT Id FROM User WHERE EmployeeNumber = 'bbb@a.bc']
      .Id,
      kResults[1].UserId__c
    );
  }
  @IsTest
  static void testCoupleContactInsert() {
    insertUsers();

    List<Contact> kContacts = new List<Contact>{
      new Contact(EmployeeNumber__c = 'aaa@a.bc')
    };
    new SUserContactCoupler().couple(kContacts);
    System.assertEquals(
      [SELECT Id FROM User WHERE EmployeeNumber = 'aaa@a.bc']
      .Id,
      kContacts[0].UserId__c
    );
  }
  @IsTest
  static void testCoupleContactUpdate() {
    List<User> kUsers = insertUsers();

    Map<Id, Contact> kOldMap = new Map<Id, Contact>{
      '01p9D0000030Kyi' => (Contact) TestUtil.treatField(
        new Contact(
          EmployeeNumber__c = 'aaa@a.bc',
          UserId__c = null,
          IsEmployee__c = true
        ),
        'Id',
        '01p9D0000030Kyi'
      ),
      '01p9D0000030Kyj' => (Contact) TestUtil.treatField(
        new Contact(
          EmployeeNumber__c = '333@a.bc',
          UserId__c = kUsers[2].Id,
          IsEmployee__c = true
        ),
        'Id',
        '01p9D0000030Kyj'
      ),
      '01p9D0000030Kyk' => (Contact) TestUtil.treatField(
        new Contact(
          EmployeeNumber__c = '444@a.bc',
          UserId__c = kUsers[3].Id,
          IsEmployee__c = true
        ),
        'Id',
        '01p9D0000030Kyk'
      ),
      '01p9D0000030Kyl' => (Contact) TestUtil.treatField(
        new Contact(
          EmployeeNumber__c = 'xxx@a.bc',
          UserId__c = null,
          IsEmployee__c = true
        ),
        'Id',
        '01p9D0000030Kyl'
      )
    };
    Map<Id, Contact> kNewMap = new Map<Id, Contact>{
      '01p9D0000030Kyi' => (Contact) TestUtil.treatField(
        new Contact(
          EmployeeNumber__c = 'bbb@a.bc',
          UserId__c = null,
          IsEmployee__c = true
        ),
        'Id',
        '01p9D0000030Kyi'
      ), // 이메일 수정
      '01p9D0000030Kyj' => (Contact) TestUtil.treatField(
        new Contact(
          EmployeeNumber__c = '333@a.bc',
          UserId__c = null,
          IsEmployee__c = true
        ),
        'Id',
        '01p9D0000030Kyj'
      ), // UserId 직접 수정
      '01p9D0000030Kyk' => (Contact) TestUtil.treatField(
        new Contact(
          EmployeeNumber__c = '444@a.bc',
          UserId__c = kUsers[3].Id,
          IsEmployee__c = true
        ),
        'Id',
        '01p9D0000030Kyk'
      ), // 수정 없음 1
      '01p9D0000030Kyl' => (Contact) TestUtil.treatField(
        new Contact(
          EmployeeNumber__c = 'xxx@a.bc',
          UserId__c = null,
          IsEmployee__c = true
        ),
        'Id',
        '01p9D0000030Kyl'
      ) // 수정 없음 2
    };
    new SUserContactCoupler().couple(kOldMap, kNewMap);
    System.assertEquals(
      [SELECT Id FROM User WHERE EmployeeNumber = 'bbb@a.bc']
      .Id,
      kNewMap.get('01p9D0000030Kyi').UserId__c
    ); // 이메일 수정 처리
    System.assertEquals(null, kNewMap.get('01p9D0000030Kyj').UserId__c); // 변화 없음
    System.assertEquals(
      [SELECT Id FROM User WHERE EmployeeNumber = '444@a.bc']
      .Id,
      kNewMap.get('01p9D0000030Kyk').UserId__c
    ); // 수정 없음 1
    System.assertEquals(null, kNewMap.get('01p9D0000030Kyl').UserId__c); // 수정 없음 2
  }
  @IsTest
  static void testCoupleContactUpdateCustomer() {
    insertUsers();

    Map<Id, Contact> kOldMap = new Map<Id, Contact>{
      '01p9D0000030Kyi' => (Contact) TestUtil.treatField(
        new Contact(
          EmployeeNumber__c = 'aaa@a.bc',
          UserId__c = null,
          IsEmployee__c = false
        ),
        'Id',
        '01p9D0000030Kyi'
      )
    };
    Map<Id, Contact> kNewMap = new Map<Id, Contact>{
      '01p9D0000030Kyi' => (Contact) TestUtil.treatField(
        new Contact(
          EmployeeNumber__c = 'bbb@a.bc',
          UserId__c = null,
          IsEmployee__c = false
        ),
        'Id',
        '01p9D0000030Kyi'
      ) // 이메일 수정
    };
    new SUserContactCoupler().couple(kOldMap, kNewMap);
    System.assertEquals(null, kNewMap.get('01p9D0000030Kyi').UserId__c); // customer 는 이메일 수정해도 처리 안됨
  }
  @IsTest
  static void testCoupleContactDelete() {
    Map<Id, Contact> kMap = new Map<Id, Contact>{
      '01p9D0000030Kyi' => new Contact()
    };
    new SUserContactCoupler().couple(kMap, null);

    System.assertEquals(null, kMap.get('01p9D0000030Kyi').UserId__c);
  }
  @IsTest
  static void testPersistUserIdContact() {
    insertUsers();

    List<Contact> kContacts = new List<Contact>{
      new Contact(EmployeeNumber__c = 'aaa@a.bc'),
      new Contact(EmployeeNumber__c = 'bbb@a.bc'),
      new Contact(EmployeeNumber__c = 'ccc@a.bc'),
      new Contact(EmployeeNumber__c = null)
    };

    SUserContactCoupler.persistUserId(kContacts);
    System.assertEquals(4, kContacts.size());
    System.assertEquals(
      [SELECT Id FROM User WHERE EmployeeNumber = 'aaa@a.bc']
      .Id,
      kContacts[0].UserId__c
    );
    System.assertEquals(
      [SELECT Id FROM User WHERE EmployeeNumber = 'bbb@a.bc']
      .Id,
      kContacts[1].UserId__c
    );
    System.assertEquals(null, kContacts[2].UserId__c); // Email 에 해당하는 user 가 없음
    System.assertEquals(null, kContacts[3].UserId__c); // Email 이 null 이면 null 반환
  }
  @IsTest
  static void testPersistUserIdContactInactive() {
    insertUsers();

    Profile kProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
    User[] kUsers2 = new List<User>{
      new User(
        Alias = 'testUse5',
        EmployeeNumber = '555@a.bc',
        Email = 'testUse5@test.invalid',
        EmailEncodingKey = 'UTF-8',
        LastName = 'Testing',
        LanguageLocaleKey = 'en_US',
        LocaleSidKey = 'en_US',
        ProfileId = kProfile.Id,
        TimeZoneSidKey = 'Asia/Seoul',
        IsActive = false,
        Username = 'testUser5@mobis.co.kr.ps'
      )
    };
    insert kUsers2;

    List<Contact> kContacts = new List<Contact>{
      new Contact(EmployeeNumber__c = 'aaa@a.bc'),
      new Contact(EmployeeNumber__c = 'bbb@a.bc'),
      new Contact(EmployeeNumber__c = 'ccc@a.bc'),
      new Contact(EmployeeNumber__c = null),
      new Contact(EmployeeNumber__c = '555@a.bc')
    };

    SUserContactCoupler.persistUserId(kContacts);
    System.assertEquals(5, kContacts.size());
    System.assertEquals(
      [SELECT Id FROM User WHERE EmployeeNumber = 'aaa@a.bc']
      .Id,
      kContacts[0].UserId__c
    );
    System.assertEquals(
      [SELECT Id FROM User WHERE EmployeeNumber = 'bbb@a.bc']
      .Id,
      kContacts[1].UserId__c
    );
    System.assertEquals(null, kContacts[2].UserId__c); // Email 에 해당하는 user 가 없음
    System.assertEquals(null, kContacts[3].UserId__c); // Email 이 null 이면 null 반환
    System.assertEquals(null, kContacts[4].UserId__c); // inactive user 는 맵핑하지 않음
  }
  @IsTest
  static void testPersistUserIdContact2() {
    insertUsers();

    List<Contact> kContacts = new List<Contact>{ // 대소문자 구분없이 처리
      new Contact(EmployeeNumber__c = 'Aaa@a.bc'),
      new Contact(EmployeeNumber__c = 'Bbb@a.bc'),
      new Contact(EmployeeNumber__c = 'Ccc@a.bc'),
      new Contact(EmployeeNumber__c = null)
    };

    SUserContactCoupler.persistUserId(kContacts);
    System.assertEquals(4, kContacts.size());
    System.assertEquals(
      [SELECT Id FROM User WHERE EmployeeNumber = 'aaa@a.bc']
      .Id,
      kContacts[0].UserId__c
    );
    System.assertEquals(
      [SELECT Id FROM User WHERE EmployeeNumber = 'bbb@a.bc']
      .Id,
      kContacts[1].UserId__c
    );
    System.assertEquals(null, kContacts[2].UserId__c); // Email 에 해당하는 user 가 없음
    System.assertEquals(null, kContacts[3].UserId__c); // Email 이 null 이면 null 반환
  }

  private static User[] insertUsers() {
    Profile kProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
    User[] kUsers = new List<User>{
      new User(
        Alias = 'testUse1',
        EmployeeNumber = 'aaa@a.bc',
        EmailEncodingKey = 'UTF-8',
        LastName = 'Testing',
        LanguageLocaleKey = 'en_US',
        LocaleSidKey = 'en_US',
        ProfileId = kProfile.Id,
        TimeZoneSidKey = 'Asia/Seoul',
        Username = 'testUser1@mobis.co.kr.ps',
        Email = 'testUser1@test.invalid'
      ),
      new User(
        Alias = 'testUse2',
        EmployeeNumber = 'bbb@a.bc',
        EmailEncodingKey = 'UTF-8',
        LastName = 'Testing',
        LanguageLocaleKey = 'en_US',
        LocaleSidKey = 'en_US',
        ProfileId = kProfile.Id,
        TimeZoneSidKey = 'Asia/Seoul',
        Username = 'testUser2@mobis.co.kr.ps',
        Email = 'testUser2@test.invalid'
      ),
      new User(
        Alias = 'testUse3',
        EmployeeNumber = '333@a.bc',
        EmailEncodingKey = 'UTF-8',
        LastName = 'Testing',
        LanguageLocaleKey = 'en_US',
        LocaleSidKey = 'en_US',
        ProfileId = kProfile.Id,
        TimeZoneSidKey = 'Asia/Seoul',
        Username = 'testUser3@mobis.co.kr.ps',
        Email = 'testUser3@test.invalid'
      ),
      new User(
        Alias = 'testUse4',
        EmployeeNumber = '444@a.bc',
        EmailEncodingKey = 'UTF-8',
        LastName = 'Testing',
        LanguageLocaleKey = 'en_US',
        LocaleSidKey = 'en_US',
        ProfileId = kProfile.Id,
        TimeZoneSidKey = 'Asia/Seoul',
        Username = 'testUser4@mobis.co.kr.ps',
        Email = 'testUser4@test.invalid'
      )
    };

    insert kUsers;

    return kUsers;
  }

  private static List<Contact> insertContacts() {
    Id kRecordTypeId = SUtil.getRecordTypeId(Contact.class, 'Employee');
    List<Contact> kContacts = new List<Contact>{
      new Contact(
        EmployeeNumber__c = 'aaa@a.bc',
        LastName = 'Aaa',
        IsEmployee__c = true,
        RecordTypeId = kRecordTypeId
      ),
      new Contact(
        EmployeeNumber__c = 'bbb@a.bc',
        LastName = 'Bbb',
        IsEmployee__c = true,
        RecordTypeId = kRecordTypeId
      ),
      new Contact(
        EmployeeNumber__c = 'ccc@a.bc',
        LastName = 'Ccc',
        IsEmployee__c = true,
        RecordTypeId = kRecordTypeId
      ),
      new Contact(
        EmployeeNumber__c = null,
        LastName = 'Ddd',
        IsEmployee__c = true,
        RecordTypeId = kRecordTypeId
      )
    };
    insert kContacts;
    return kContacts;
  }
}