/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 11-17-2022
 * @last modified by  : https://github.com/Eldor901
 **/
@isTest
public class ContactControllerTest {
  @isTest
  static void getContacts() {
    List<Contact> contacts = ContactController.getContacts('Us', 'It');

    system.assertEquals(1, contacts.size());
  }

  @TestSetup
  static void makeData() {
    Department__c dep = TestFactory.createDepartment('It');
    TestFactory.createContact('User', dep.Id);
  }
}