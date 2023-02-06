/**
 * @description       :
 * @author            : Bekhzod Ubaydullaev
 * @group             :
 * @last modified on  : 12-18-2022
 * @last modified by  : Bekhzod Ubaydullaev
 **/
public with sharing class BatchQuipDocInserted implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
  Map<String, List<String>> opptyQuipDoc;
  public BatchQuipDocInserted(Map<String, List<String>> opptyQuipDoc) {
    this.opptyQuipDoc = opptyQuipDoc;
  }
  public Database.QueryLocator start(Database.BatchableContext BC) {
    return Database.getQueryLocator(
      [SELECT Id FROM Opportunity WHERE Id IN :this.opptyQuipDoc.keySet()]
    );
  }

  public void execute(
    Database.BatchableContext BC,
    List<Opportunity> opportunityRecords
  ) {
    Map<String, List<String>> opptyQuip = new Map<String, List<String>>();
    for (Opportunity oppty : opportunityRecords) {
      if (this.opptyQuipDoc.containsKey(String.valueOf(oppty.Id))) {
        opptyQuip.put(
          String.valueOf(oppty.Id),
          this.opptyQuipDoc.get(String.valueOf(oppty.Id))
        );
      }
    }
    List<OpportunityTeamMember> teamMembers = [
      SELECT Id, OpportunityId, UserId
      FROM OpportunityTeamMember
      WHERE OpportunityId IN :opptyQuip.keySet()
    ];
    OpportunityTeamQuipCallMethods.shareQuipDocInserted(opptyQuip, teamMembers);
  }

  public void finish(Database.BatchableContext BC) {
  }
}