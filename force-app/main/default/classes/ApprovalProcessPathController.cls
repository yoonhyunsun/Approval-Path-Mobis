/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 01-05-2023
 * @last modified by  : https://github.com/Eldor901
 **/
public without sharing class ApprovalProcessPathController {
  @AuraEnabled(cacheable=true)
  public static Map<String, List<PicklistDTO>> getPicklists() {
    return ApprovalProcessPathService.getPicklists();
  }

  @AuraEnabled
  public static Boolean createFavoriteApporvalPath(
    String name,
    ID OpportunityId,
    List<ApprovalProcessPathDTO> favoriteApprovalProcessPathes
  ) {
    return ApprovalProcessPathService.createFavoriteApporvalPath(
      name,
      OpportunityId,
      favoriteApprovalProcessPathes
    );
  }

  @AuraEnabled
  public static Boolean createApprovalProcessPathes(
    String OpportunityId,
    String Comment,
    List<ApprovalProcessPathDTO> approvalProcessPathes
  ) {
    if (!ApprovalPathValidation.checkApprovalPaths(approvalProcessPathes))
      return false;

    return ApprovalProcessPathService.createApprovalProcessPathes(
      OpportunityId,
      Comment,
      approvalProcessPathes
    );
  }

  @AuraEnabled
  public static Boolean editApprovalProcessPaths(
    String OpportunityId,
    String Comment,
    List<ApprovalProcessPathDto> approvalProcessPaths
  ) {
    if (!ApprovalPathValidation.checkApprovalPaths(approvalProcessPaths)) {
      return false;
    }

    try {
      ApprovalProcess__c approvalProcess = [
        SELECT Id
        FROM ApprovalProcess__c
        WHERE
          Opportunity__c = :OpportunityId
          AND ApprovalStatus__c = 'In Progress'
        LIMIT 1
      ];

      ApprovalProcessPath__c ownerApprovalProcess = [
        SELECT id, Comment__c
        FROM ApprovalProcessPath__c
        WHERE
          ApprovalType__c = 'Draft'
          AND ApprovalProcess__c = :approvalProcess.Id
      ];

      ownerApprovalProcess.Comment__c = Comment;

      update ownerApprovalProcess;

      ChangeApproverUtil.editApprovers(
        String.valueOf(approvalProcess.Id),
        approvalProcessPaths
      );
    } catch (Exception e) {
      System.debug(e.getMessage());
    }

    return true;
  }

  @AuraEnabled(cacheable=true)
  public static List<FavoriteApprovalPathGroup__c> getFavoriteApprovalPathGroup() {
    return ApprovalProcessPathService.getFavoriteApprovalPathGroup();
  }

  @AuraEnabled(cacheable=true)
  public static List<Favorite_Approval_Path_Item__c> getFavoriteApprovalPathItems(
    String groupId
  ) {
    return ApprovalProcessPathService.getFavoriteApprovalPathItems(groupId);
  }

  @AuraEnabled(cacheable=true)
  public static List<ApprovalProcessPath__c> getApprovalProcessPathes(
    String approvalProcessPathId
  ) {
    ApprovalProcessPath__c approvalProcessPath = [
      SELECT Id, ApprovalProcess__c
      FROM ApprovalProcessPath__c
      WHERE Id = :approvalProcessPathId
    ];

    return ApprovalProcessPathService.getApprovalProcessPathes(
      approvalProcessPath.ApprovalProcess__c
    );
  }

  @AuraEnabled(cacheable=true)
  public static List<ApprovalProcessPath__c> getApprovalProcessPathesOfOpportunity(
    ID OpportunityId
  ) {
    Opportunity opportunity = [
      SELECT id, StageName
      FROM Opportunity
      WHERE id = :OpportunityId
    ];

    List<ApprovalProcess__c> approvalProcess = [
      SELECT Id
      FROM ApprovalProcess__c
      WHERE
        Opportunity_Stage__c = :opportunity.StageName
        AND Opportunity__c = :OpportunityId
      LIMIT 1
    ];

    if (approvalProcess.size() == 0) {
      return new List<ApprovalProcessPath__c>();
    }

    return ApprovalProcessPathService.getApprovalProcessPathes(
      approvalProcess[0].Id
    );
  }

  @AuraEnabled(cacheable=true)
  public static List<ApprovalProcess__c> getApprovalProcesses(
    ID OpportunityId
  ) {
    return ApprovalProcessPathService.getApprovalProcesses(OpportunityId);
  }

  @AuraEnabled
  public static String approverAction(
    String approvalProcessPathId,
    String action,
    String comment
  ) {
    ApprovalProcessPath__c approvalProcessPath = [
      SELECT Id, ApprovalProcessPathUID__c
      FROM ApprovalProcessPath__c
      WHERE Id = :approvalProcessPathId
      LIMIT 1
    ];

    return ApproverActionService.approverAction(
      approvalProcessPath.ApprovalProcessPathUID__c,
      action,
      comment
    );
  }

  @AuraEnabled
  public static string markRead(String approvalProcessPathId) {
    ApprovalProcessPath__c approvalProcessPath = [
      SELECT Id, ApprovalProcessPathUID__c, ApprovalUser__c
      FROM ApprovalProcessPath__c
      WHERE Id = :approvalProcessPathId
      LIMIT 1
    ];

    if (approvalProcessPath.ApprovalUser__c == UserInfo.getUserId())
      return ApproverActionService.markRead(
        approvalProcessPath.ApprovalProcessPathUID__c
      );

    return '';
  }
}