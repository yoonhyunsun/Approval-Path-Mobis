/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 12-23-2022
 * @last modified by  : Bekhzod Ubaydullaev
 **/
public without sharing class OpportunityController {
  @AuraEnabled
  public static UserRecordAccess getOpportunityRecordAccess(
    String opportunityId
  ) {
    return [
      SELECT RecordId, HasEditAccess
      FROM UserRecordAccess
      WHERE UserId = :UserInfo.getUserId() AND RecordId = :opportunityId
    ];
  }

  @AuraEnabled
  public static Boolean getGeneralApprovalUser(String opportunityId) {
    List<ApprovalProcessPath__c> generalApproverPath = [
      SELECT Id, ApprovalUser__c 
      FROM ApprovalProcessPath__c 
      WHERE Opportunity__c = :opportunityId AND ApprovalType__c = 'General Approval'
      ];

    List<Id> ids = new List<Id>();  
    for(ApprovalProcessPath__c path : generalApproverPath) {
      ids.add(path.ApprovalUser__c);
    }

      Id tempUserId = [
        SELECT Id
        FROM User
        WHERE Id = :UserInfo.getUserId()
      ].Id;

      if(ids.contains(tempUserId)) {
        return true;
      }else{
        return false;
      }
  }

  @AuraEnabled
  public static Boolean opportunityHasInProgressApprovalProcess(
    String opportunityId
  ) {
    List<ApprovalProcess__c> approvalProcesses = [
      SELECT Id
      FROM ApprovalProcess__c
      WHERE
        Opportunity__c = :opportunityId
        AND ApprovalStatus__c = 'IN PROGRESS'
    ];

    return approvalProcesses.size() > 0;
  }

  @AuraEnabled
  public static Boolean opportunityRfqSectionFilled(String opportunityId) {
    List<Opportunity> opp = [
      SELECT
        Id,
        ManagementTeam__c,
        OIManagingregion__c,
        DealGrade__c,
        SOP__c,
        LifeCycle__c,
        Competitors__c,
        Incoterms__c,
        InvestmentsToolingCost__c,
        InvestmentsEDD__c,
        PaymentTerms__c,
        OEPlant__c,
        ExpectedOI__c,
        SEG__c,
        CurrencyType__c,
        MobisPlant__c
      FROM Opportunity
      WHERE Id = :opportunityId
    ];

    if (
      String.isBlank(opp[0].ManagementTeam__c) ||
      String.isBlank(opp[0].OIManagingregion__c) ||
      String.isBlank(opp[0].DealGrade__c) ||
      opp[0].SOP__c == null ||
      String.isBlank(opp[0].LifeCycle__c) ||
      String.isBlank(opp[0].Competitors__c) ||
      String.isBlank(opp[0].Incoterms__c) ||
      String.isBlank(opp[0].InvestmentsToolingCost__c) ||
      String.isBlank(opp[0].InvestmentsEDD__c) ||
      String.isBlank(opp[0].PaymentTerms__c) ||
      String.isBlank(opp[0].OEPlant__c) ||
      opp[0].ExpectedOI__c == null ||
      String.isBlank(opp[0].SEG__c) ||
      String.isBlank(opp[0].CurrencyType__c) ||
      String.isBlank(opp[0].MobisPlant__c)
    ) {
      return false;
    }

    return true;
  }

  @AuraEnabled
  public static String getUserProfile(
    String opportunityId
  ) {
    return [
      SELECT Name
      FROM Profile
      WHERE Id = :UserInfo.getProfileId()
    ].Name;
  }
}