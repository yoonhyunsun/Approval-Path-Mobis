/**
 * @description       :
 * @author            : Bekhzod Ubaydullaev
 * @group             :
 * @last modified on  : 12-28-2022
 * @last modified by  : Bekhzod Ubaydullaev
 **/
public without sharing class BatchApprovalProcessDeleted implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
  public List<ApprovalProcess__c> appList;
  public BatchApprovalProcessDeleted(List<ApprovalProcess__c> appList) {
    this.appList = appList;
  }
  public Database.QueryLocator start(Database.BatchableContext BC) {
    return Database.getQueryLocator(
      [
        SELECT
          Id,
          Name,
          QuipURL__c,
          ApprovalStatus__c,
          Opportunity__c,
          Opportunity_Stage__c
        FROM ApprovalProcess__c
        WHERE Id IN :this.appList
      ]
    );
  }

  public void execute(
    Database.BatchableContext BC,
    List<ApprovalProcess__c> approvalsDelete
  ) {
    List<Id> opptyList = new List<Id>();
    for (ApprovalProcess__c app : approvalsDelete) {
      if (app.Opportunity__c != null) {
        opptyList.add(app.Opportunity__c);
      }
      if (String.isNotBlank(app.QuipURL__c)) {
        String threadId = QuipAPI.idFromUrl(app.QuipURL__c);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(
          'callout:quip_secured/1/threads/lock-edits?thread_id=' +
          threadId +
          '&edits_disabled=false'
        );
        request.setMethod('POST');
        HttpResponse response = http.send(request);
      }
    }
    if (opptyList.size() != 0) {
      ApprovalPathSharingUtil.unlockRecord(opptyList);
    }
  }

  public void finish(Database.BatchableContext BC) {
  }
}