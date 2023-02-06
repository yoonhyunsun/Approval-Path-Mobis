/**
 * @description       :
 * @author            : Bekhzod Ubaydullaev
 * @group             :
 * @last modified on  : 01-13-2023
 * @last modified by  : Bekhzod Ubaydullaev
 **/
public without sharing class DefaultApprovalPathsService {
  public static List<ApprovalProcessPathDTO> getDefaultsMain(Id opportunityId) {
    Opportunity opportunity = [
      SELECT
        Id,
        StageName,
        Account.KAE__r.Id,
        FirstReportApproved__c,
        SecondReportApproved__c,
        ThirdReportApproved__c
      FROM Opportunity
      WHERE Id = :opportunityId
    ];

    if (opportunity.StageName == 'RFQ Received') {
      return dtoRfqReceived(
        UserInfo.getUserId(),
        opportunity.Account.KAE__r.Id
      );
    }

    if (opportunity.StageName == 'Quote Submitted') {
      List<ApprovalProcess__c> appList = [
        SELECT Id, Opportunity_Stage__c
        FROM ApprovalProcess__c
        WHERE
          Opportunity_Stage__c = 'Quote Submitted'
          AND ApprovalStatus__c = 'Approved'
          AND Opportunity__c = :opportunityId
        ORDER BY CreatedDate
      ];

      return sortByQuote(appList, opportunity);
    }
    return createDtoFromContact(getDefaultContacts(UserInfo.getUserId()));
  }

  public static List<ApprovalProcessPathDTO> sortByQuote(
    List<ApprovalProcess__c> appList,
    Opportunity opportunity
  ) {
    if (appList.size() == 0 && !opportunity.FirstReportApproved__c) {
      return createDtoFromContact(getDefaultContacts(UserInfo.getUserId()));
    }
    if (
      appList.size() == 1 &&
      opportunity.FirstReportApproved__c &&
      !opportunity.SecondReportApproved__c
    ) {
      return dtoFromApprovalPath(appList[0]);
    }
    return dtoFromApprovalPath(appList[appList.size() - 1]);
  }

  public static List<ApprovalProcessPathDTO> dtoFromApprovalPath(
    ApprovalProcess__c approval
  ) {
    List<ApprovalProcessPath__c> paths = [
      SELECT
        Id,
        ApprovalProcess__c,
        ApprovalType__c,
        Order__c,
        Employee__r.Id,
        Employee__r.Name,
        Employee__r.EmpDepartment__r.Name,
        Employee__r.PositionName__c,
        Employee__r.Email,
        Employee__r.UserId__c
      FROM ApprovalProcessPath__c
      WHERE ApprovalProcess__c = :approval.Id AND ApprovalType__c != 'Draft'
      ORDER BY Order__c
    ];

    List<ApprovalProcessPathDTO> result = new List<ApprovalProcessPathDTO>();
    for (ApprovalProcessPath__c path : paths) {
      ApprovalProcessPathDTO newDto = new ApprovalProcessPathDTO();
      newDto.ApprovalType = path.ApprovalType__c;
      newDto.Id = path.Employee__r.Id;
      newDto.Name = path.Employee__r.Name;
      newDto.Department = path.Employee__r.EmpDepartment__r.Name;
      newDto.Position = path.Employee__r.PositionName__c;
      newDto.ContactEmail = path.Employee__r.Email;
      newDto.UserId = path.Employee__r.UserId__c;

      result.add(newDto);
    }
    return result;
  }

  public static List<ApprovalProcessPathDTO> createDtoFromContact(
    List<Contact> contacts
  ) {
    List<ApprovalProcessPathDTO> result = new List<ApprovalProcessPathDTO>();
    for (Contact contact : contacts) {
      ApprovalProcessPathDTO path = new ApprovalProcessPathDTO();
      path.Id = contact.Id;
      path.Name = contact.Name;
      path.Department = contact.EmpDepartment__r.Name;
      path.Position = contact.PositionName__c;
      path.ContactEmail = contact.Email;
      path.UserId = contact.UserId__c;
      if (contact.IsCollaborator__c) {
        path.ApprovalType = 'Collaboration';
      } else {
        path.ApprovalType = 'General Approval';
      }
      result.add(path);
    }
    return result;
  }

  public static List<Contact> getDefaultContacts(Id currId) {
    List<Contact> currUser = [
      SELECT
        id,
        name,
        Status__c,
        EmpDepartment__c,
        EmpDepartment__r.Name,
        JobTitleCode__c,
        PositionName__c,
        UserId__c,
        Email,
        EmpDepartment__r.ParentDepartment__c,
        EmpDepartment__r.ParentDepartment__r.ParentDepartment__c
      FROM Contact
      WHERE UserId__c = :currId AND IsEmployee__c = TRUE
    ];

    List<Contact> teamLeader = new List<Contact>();
    List<Contact> departmentLeader = new List<Contact>();
    List<Contact> businessUnitLeader = new List<Contact>();
    List<Contact> collaborators = new List<Contact>();

    if (currUser.size() != 0 && currUser[0].EmpDepartment__c != null) {
      teamLeader = [
        SELECT
          id,
          name,
          Status__c,
          EmpDepartment__c,
          EmpDepartment__r.Name,
          JobTitleCode__c,
          PositionName__c,
          UserId__c,
          Email,
          IsCollaborator__c,
          EmpDepartment__r.ParentDepartment__c
        FROM Contact
        WHERE
          Status__c = 'Active'
          AND EmpDepartment__c = :currUser[0].EmpDepartment__c
          AND JobTitleCode__c = 'B03'
      ];
    }

    if (
      currUser.size() != 0 &&
      currUser[0].EmpDepartment__r.ParentDepartment__c != null
    ) {
      departmentLeader = [
        SELECT
          id,
          name,
          Status__c,
          EmpDepartment__c,
          EmpDepartment__r.Name,
          JobTitleCode__c,
          PositionName__c,
          UserId__c,
          Email,
          IsCollaborator__c,
          EmpDepartment__r.ParentDepartment__c
        FROM Contact
        WHERE
          Status__c = 'Active'
          AND EmpDepartment__c = :currUser[0]
            .EmpDepartment__r.ParentDepartment__c
          AND JobTitleCode__c = 'A08'
      ];
    }

    if (
      currUser.size() != 0 &&
      currUser[0].EmpDepartment__r.ParentDepartment__r.ParentDepartment__c !=
      null
    ) {
      businessUnitLeader = [
        SELECT
          id,
          name,
          Status__c,
          EmpDepartment__c,
          EmpDepartment__r.Name,
          JobTitleCode__c,
          PositionName__c,
          UserId__c,
          Email,
          IsCollaborator__c,
          EmpDepartment__r.ParentDepartment__c
        FROM Contact
        WHERE
          Status__c = 'Active'
          AND EmpDepartment__c = :currUser[0]
            .EmpDepartment__r.ParentDepartment__r.ParentDepartment__c
          AND JobTitleCode__c = 'A05'
      ];
    }

    if (currUser.size() != 0 && currUser[0].EmpDepartment__c != null) {
      collaborators = [
        SELECT
          id,
          name,
          Status__c,
          EmpDepartment__c,
          EmpDepartment__r.Name,
          JobTitleCode__c,
          PositionName__c,
          UserId__c,
          Email,
          IsCollaborator__c,
          EmpDepartment__r.ParentDepartment__c
        FROM Contact
        WHERE
          Status__c = 'Active'
          AND IsCollaborator__c = TRUE
          AND EmpDepartment__c = :currUser[0].EmpDepartment__c
      ];
    }

    List<Contact> ceo = [
      SELECT
        id,
        name,
        Status__c,
        EmpDepartment__c,
        EmpDepartment__r.Name,
        JobTitleCode__c,
        PositionName__c,
        UserId__c,
        Email,
        IsCollaborator__c,
        EmpDepartment__r.ParentDepartment__c
      FROM Contact
      WHERE Status__c = 'Active' AND JobTitleCode__c = 'A02'
    ];

    List<Contact> result = new List<Contact>();
    result.addAll(teamLeader);
    result.addAll(departmentLeader);
    result.addAll(businessUnitLeader);
    result.addAll(collaborators);
    result.addAll(ceo);

    return result;
  }

  public static List<ApprovalProcessPathDTO> dtoRfqReceived(
    Id currId,
    Id kaeId
  ) {
    List<Contact> currUser = [
      SELECT
        id,
        name,
        Status__c,
        EmpDepartment__c,
        EmpDepartment__r.Name,
        JobTitleCode__c,
        PositionName__c,
        UserId__c,
        Email,
        EmpDepartment__r.ParentDepartment__c
      FROM Contact
      WHERE UserId__c = :currId AND IsEmployee__c = TRUE
    ];

    List<Contact> teamLeader = new List<Contact>();
    List<Contact> kae = new List<Contact>();
    List<Contact> departmentLeader = new List<Contact>();

    if (currUser.size() != 0 && currUser[0].EmpDepartment__c != null) {
      teamLeader = [
        SELECT
          id,
          name,
          Status__c,
          EmpDepartment__c,
          EmpDepartment__r.Name,
          JobTitleCode__c,
          PositionName__c,
          UserId__c,
          Email,
          IsCollaborator__c,
          EmpDepartment__r.ParentDepartment__c
        FROM Contact
        WHERE
          Status__c = 'Active'
          AND EmpDepartment__c = :currUser[0].EmpDepartment__c
          AND JobTitleCode__c = 'B03'
      ];
    }

    if (kaeId != null) {
      kae = [
        SELECT
          id,
          name,
          Status__c,
          EmpDepartment__c,
          EmpDepartment__r.Name,
          JobTitleCode__c,
          PositionName__c,
          UserId__c,
          Email,
          IsCollaborator__c,
          EmpDepartment__r.ParentDepartment__c
        FROM Contact
        WHERE Status__c = 'Active' AND UserId__c = :kaeId
        ORDER BY CreatedDate
      ];
    }

    if (
      currUser.size() != 0 &&
      currUser[0].EmpDepartment__r.ParentDepartment__c != null
    ) {
      departmentLeader = [
        SELECT
          id,
          name,
          Status__c,
          EmpDepartment__c,
          EmpDepartment__r.Name,
          JobTitleCode__c,
          PositionName__c,
          UserId__c,
          Email,
          IsCollaborator__c,
          EmpDepartment__r.ParentDepartment__c
        FROM Contact
        WHERE
          Status__c = 'Active'
          AND EmpDepartment__c = :currUser[0]
            .EmpDepartment__r.ParentDepartment__c
          AND JobTitleCode__c = 'A08'
      ];
    }

    List<ApprovalProcessPathDTO> teamLeaderDto = createDtoFromContactRfqReceived(
      teamLeader,
      false
    );
    List<ApprovalProcessPathDTO> kaeDto = createDtoFromContactRfqReceived(
      kae,
      true
    );
    List<ApprovalProcessPathDTO> departmentLeaderDto = createDtoFromContactRfqReceived(
      departmentLeader,
      false
    );

    List<ApprovalProcessPathDTO> result = new List<ApprovalProcessPathDTO>();
    result.addAll(teamLeaderDto);
    if (kaeDto.size() != 0) {
      result.add(kaeDto[0]);
    }
    result.addAll(departmentLeaderDto);

    return result;
  }

  public static List<ApprovalProcessPathDTO> createDtoFromContactRfqReceived(
    List<Contact> contacts,
    Boolean kae
  ) {
    List<ApprovalProcessPathDTO> result = new List<ApprovalProcessPathDTO>();
    for (Contact contact : contacts) {
      ApprovalProcessPathDTO path = new ApprovalProcessPathDTO();
      path.Id = contact.Id;
      path.Name = contact.Name;
      path.Department = contact.EmpDepartment__r.Name;
      path.Position = contact.PositionName__c;
      path.UserId = contact.UserId__c;
      path.ContactEmail = contact.Email;
      if (kae) {
        path.ApprovalType = 'Reference';
      } else {
        path.ApprovalType = 'General Approval';
      }
      result.add(path);
    }
    return result;
  }
}