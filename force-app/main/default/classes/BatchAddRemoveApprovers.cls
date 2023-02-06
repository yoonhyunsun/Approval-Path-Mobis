/**
 * @description       :
 * @author            : Bekhzod Ubaydullaev
 * @group             :
 * @last modified on  : 01-27-2023
 * @last modified by  : Bekhzod Ubaydullaev
 **/
public without sharing class BatchAddRemoveApprovers implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
  public Boolean addOrRemove;
  public List<ApprovalProcessPath__c> paths;
  public BatchAddRemoveApprovers(
    List<ApprovalProcessPath__c> paths,
    Boolean addOrRemove
  ) {
    this.addOrRemove = addOrRemove;
    this.paths = paths;
  }

  public Database.QueryLocator start(Database.BatchableContext BC) {
    return Database.getQueryLocator(
      [
        SELECT
          Id,
          ApprovalProcess__c,
          Opportunity__c,
          ApprovalStatus__c,
          ApprovalUser__c,
          ApprovalType__c,
          Employee__c
        FROM ApprovalProcessPath__c
        WHERE Id IN :this.paths
      ]
    );
  }

  public void execute(
    Database.BatchableContext BC,
    List<ApprovalProcessPath__c> paths
  ) {
    Map<String, List<String>> quipDocUserMap = OpportunityTeamQuipCallMethods.approversMapping(
      paths
    );
    if (quipDocUserMap.keySet().size() == 0) {
      return;
    }
    OpportunityTeamQuipShare.shareQuipApprovers(
      quipDocUserMap,
      this.addOrRemove
    );
  }

  public void finish(Database.BatchableContext BC) {
  }
}