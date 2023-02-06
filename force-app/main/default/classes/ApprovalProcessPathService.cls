/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 02-01-2023
 * @last modified by  : https://github.com/Eldor901
 **/
public without sharing class ApprovalProcessPathService {
  private static final String PUBLIC_SITE_URL = ApprovalProcessSettings__c.getInstance(
      'MobisApprovalProcessSettings'
    )
    .PublicSiteURL__c;

  public static Map<String, List<PicklistDTO>> getPicklists() {
    List<PicklistDTO> approvalTypes = PickListConverter.pickListToOption(
      (ApprovalProcessPath__c.ApprovalType__c.getDescribe().getPickListValues())
    );

    Map<String, List<PicklistDTO>> picklists = new Map<String, List<PicklistDTO>>();

    picklists.put('approvalTypes', approvalTypes);

    return picklists;
  }

  public static Boolean createFavoriteApporvalPath(
    String name,
    ID OpportunityId,
    List<ApprovalProcessPathDTO> favoriteApprovalProcessPathes
  ) {
    if (favoriteApprovalProcessPathes.size() == 0) {
      throw new IllegalArgumentException(System.label.ERR_EMPTY_FAVORITE_PATHS);
    }

    List<FavoriteApprovalPathGroup__c> favoriteApprovalGroup = [
      SELECT Name__c, OwnerId
      FROM FavoriteApprovalPathGroup__c
      WHERE Name__c = :name AND OwnerId = :UserInfo.getUserId()
    ];

    if (favoriteApprovalGroup.size() != 0) {
      throw new IllegalArgumentException(System.label.ERR_UNIQUE_FAV_NAME);
    }

    FavoriteApprovalPathGroup__c favoriteApprovalPathGroup = new FavoriteApprovalPathGroup__c();
    favoriteApprovalPathGroup.Name__c = name;

    insert favoriteApprovalPathGroup;

    List<Favorite_Approval_Path_Item__c> favoriteApprovalPathItems = new List<Favorite_Approval_Path_Item__c>();

    ApprovalProcess__c approvalProcess = OpportunityApprovalProcess.getStageApprovalProcess(
      OpportunityId
    );

    for (
      ApprovalProcessPathDTO favoriteApprovalProcessPath : favoriteApprovalProcessPathes
    ) {
      Favorite_Approval_Path_Item__c favApprovalPath = new Favorite_Approval_Path_Item__c();

      favApprovalPath.Favorite_Approval_Path_Group_Id__c = favoriteApprovalPathGroup.id;
      favApprovalPath.Approval_Type__c = favoriteApprovalProcessPath.ApprovalType;
      favApprovalPath.Report_Type__c = approvalProcess.ReportType__c;
      favApprovalPath.Contact__c = favoriteApprovalProcessPath.Id;

      favoriteApprovalPathItems.add(favApprovalPath);
    }

    insert favoriteApprovalPathItems;

    return true;
  }

  private static ApprovalProcessPath__c getOwnerApprovalPathUser(
    String approvalProcessId,
    String Comment
  ) {
    List<Contact> approvalProcessOwnerUser = [
      SELECT Id
      FROM Contact
      WHERE UserId__c = :UserInfo.getUserId()
      LIMIT 1
    ];

    if (approvalProcessOwnerUser.isEmpty()) {
      throw new IllegalArgumentException(
        System.Label.ERR_CONTACT_USER_NOT_FOUND
      );
    }

    ApprovalProcessPath__c approvalProcessPathCreator = new ApprovalProcessPath__c();

    approvalProcessPathCreator.ApprovalType__c = 'Draft';
    approvalProcessPathCreator.ApprovalProcess__c = approvalProcessId;
    approvalProcessPathCreator.ApprovalProcessPathUID__c = GenerateUID.generate();
    approvalProcessPathCreator.Order__c = 0;
    approvalProcessPathCreator.Employee__c = approvalProcessOwnerUser[0].Id;
    approvalProcessPathCreator.RequestDateTime__c = Datetime.now();
    approvalProcessPathCreator.ApprovalStatus__c = 'Approved';
    approvalProcessPathCreator.ApprovalUser__c = UserInfo.getUserId();
    approvalProcessPathCreator.ApprovalDateTime__c = Datetime.now();
    approvalProcessPathCreator.Comment__c = Comment;
    
    System.debug('오너 : ' + approvalProcessPathCreator);
    return approvalProcessPathCreator;
  }

  private static List<ApprovalProcessPath__c> getDefaultRefUser(
    String approvalProcessId,
    String Comment
  ) {
    // for ApprovalProcessPath.Employee__c
    List<Contact> approvalProcessDefaultUser = new List<Contact>();
    approvalProcessDefaultUser.add([SELECT Id, UserId__c FROM Contact WHERE EmployeeNumber__c = : '1607371']);
    approvalProcessDefaultUser.add([SELECT Id, UserId__c FROM Contact WHERE EmployeeNumber__c = : '1605674']);

    if (approvalProcessDefaultUser.isEmpty()) {
      throw new IllegalArgumentException(
        System.Label.ERR_CONTACT_USER_NOT_FOUND
      );
    }

    List<ApprovalProcessPath__c> approvalProcessPathCreatorList = new List<ApprovalProcessPath__c>();

    for(Integer i=1 ; i < approvalProcessDefaultUser.size()+1; i++){
    ApprovalProcessPath__c approvalProcessPathCreator = new ApprovalProcessPath__c();

    approvalProcessPathCreator.ApprovalType__c = 'Reference';
    approvalProcessPathCreator.ApprovalProcess__c = approvalProcessId;
    approvalProcessPathCreator.ApprovalProcessPathUID__c = GenerateUID.generate();
    approvalProcessPathCreator.Order__c = i * 0.1;
    approvalProcessPathCreator.Employee__c = approvalProcessDefaultUser[i-1].Id;
    approvalProcessPathCreator.RequestDateTime__c = Datetime.now();
    approvalProcessPathCreator.ApprovalUser__c = approvalProcessDefaultUser[i-1].UserId__c;

    approvalProcessPathCreatorList.add(approvalProcessPathCreator);
  }

    System.debug('참고 유저 : ' + approvalProcessPathCreatorList);
    return approvalProcessPathCreatorList;
  }

  public static Boolean createApprovalProcessPathes(
    ID OpportunityId,
    String Comment,
    List<ApprovalProcessPathDTO> approvalProcessPathes
  ) {
    ApprovalProcess__c approvalProcess = OpportunityApprovalProcess.getStageApprovalProcess(
      OpportunityId
    );

    List<ApprovalProcessPath__c> newApprovalProcessPathes = new List<ApprovalProcessPath__c>();

    newApprovalProcessPathes.add(
      getOwnerApprovalPathUser(approvalProcess.Id, Comment)
    );
    newApprovalProcessPathes.addAll(
      getDefaultRefUser(approvalProcess.Id, Comment)
    );

    for (
      ApprovalProcessPathDTO currentApprovalProcessPath : approvalProcessPathes
    ) {
      ApprovalProcessPath__c newApprovalProcess = new ApprovalProcessPath__c();
      newApprovalProcess.ApprovalType__c = currentApprovalProcessPath.ApprovalType;
      newApprovalProcess.ApprovalProcess__c = approvalProcess.Id;
      newApprovalProcess.ApprovalProcessPathUID__c = GenerateUID.generate();
      newApprovalProcess.Order__c = currentApprovalProcessPath.Order;
      newApprovalProcess.Employee__c = currentApprovalProcessPath.Id;
      newApprovalProcess.SiteURL__c =
        PUBLIC_SITE_URL +
        'approve?uid=' +
        newApprovalProcess.ApprovalProcessPathUID__c;

      newApprovalProcess.ApprovalUser__c = currentApprovalProcessPath.UserId;

      newApprovalProcessPathes.add(newApprovalProcess);
    }

    insert newApprovalProcessPathes;

    ApproverActionUtil.groupApprovalUsers(approvalProcess.Id);

    return true;
  }

  public static List<FavoriteApprovalPathGroup__c> getFavoriteApprovalPathGroup() {
    return [
      SELECT Id, Name__c
      FROM FavoriteApprovalPathGroup__c
      WHERE OwnerId = :UserInfo.getUserId()
    ];
  }

  public static List<Favorite_Approval_Path_Item__c> getFavoriteApprovalPathItems(
    String groupId
  ) {
    return [
      SELECT
        Approval_Type__c,
        Contact__r.Department__c,
        Contact__r.Id,
        Contact__r.EmpDepartment__r.Name,
        Contact__r.PositionName__c,
        Contact__r.Name
      FROM Favorite_Approval_Path_Item__c
      WHERE Favorite_Approval_Path_Group_Id__r.Id = :groupId
    ];
  }

  public static List<ApprovalProcessPath__c> getApprovalProcessPathes(
    ID approvalProcessId
  ) {
    List<ApprovalProcessPath__c> approvalProcessPathes = [
      SELECT
        Id,
        Employee__r.Name,
        Employee__r.PositionName__c,
        Employee__r.EmpDepartment__r.Name,
        ProcessName__c,
        ApprovalType__c,
        ApprovalStatus__c,
        LastModifiedDate,
        CreatedDate,
        ApprovalDateTime__c,
        Comment__c
      FROM ApprovalProcessPath__c
      WHERE ApprovalProcess__c = :approvalProcessId
      ORDER BY Order__c
    ];

    return approvalProcessPathes;
  }

  public static List<ApprovalProcess__c> getApprovalProcesses(
    ID OpportunityId
  ) {
    Opportunity opportunity = [
      SELECT id, StageName
      FROM Opportunity
      WHERE id = :OpportunityId
    ];

    List<ApprovalProcess__c> approvalProcesses = [
      SELECT
        Id,
        ApprovalStatus__c,
        OwnerId,
        ReportType__c,
        LastModifiedDate,
        CreatedDate,
        (
          SELECT Id, ApprovalStatus__c, ApprovalType__c
          FROM Approval_Process_Path__r
          WHERE NotifiedGroup__c = 1
        )
      FROM ApprovalProcess__c
      WHERE Opportunity__c = :OpportunityId
      ORDER BY CreatedDate DESC
    ];

    return approvalProcesses;
  }
}