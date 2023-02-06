/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 01-30-2023
 * @last modified by  : https://github.com/Eldor901
 **/
public without sharing class ContactService {
  public static List<Contact> getContacts(String name, String department) {
    if ((name.length() == 0) && (department.length() == 0))
      return new List<Contact>();

    String searchName = '%' + name + '%';
    String searchDepartment = '%' + department + '%';

    return [
      SELECT Id, Name, EmpDepartment__r.Name, PositionName__c, UserId__c, Email
      FROM Contact
      WHERE
        (Name LIKE :searchName
        OR FullNameWithoutBlank__c LIKE :searchName)
        AND EmpDepartment__r.Name LIKE :searchDepartment
      LIMIT 50
    ];
  }

  public static List<ApprovalProcessPath__c> getApprovalProcessSubmittedContacts(
    Id opportunityId
  ) {
    ApprovalProcess__c approvalProcess = [
      SELECT Id
      FROM ApprovalProcess__c
      WHERE
        Opportunity__c = :opportunityId
        AND ApprovalStatus__c = 'In Progress'
    ];

    return [
      SELECT
        Id,
        Employee__r.Id,
        Employee__r.Name,
        Employee__r.UserId__c,
        Employee__r.PositionName__c,
        ApprovalProcess__r.CurrentGroupNumber__c,
        NotifiedGroup__c,
        Employee__r.EmpDepartment__r.Name,
        Employee__r.Email,
        ProcessName__c,
        ApprovalType__c,
        ApprovalStatus__c,
        Comment__c
      FROM ApprovalProcessPath__c
      WHERE ApprovalProcess__c = :approvalProcess.Id
      ORDER BY Order__c
    ];
  }

  public static Contact getSubmitter() {
    List<Contact> approvalProcessOwnerUser = [
      SELECT Id, Name, EmpDepartment__r.Name, PositionName__c, UserId__c, Email
      FROM Contact
      WHERE UserId__c = :UserInfo.getUserId()
      LIMIT 1
    ];

    if (approvalProcessOwnerUser.isEmpty()) {
      throw new IllegalArgumentException(
        System.Label.ERR_CONTACT_USER_NOT_FOUND
      );
    }

    return approvalProcessOwnerUser[0];
  }

}