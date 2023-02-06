/**
 * @description       :
 * @author            : Bekhzod Ubaydullaev
 * @group             :
 * @last modified on  : 12-18-2022
 * @last modified by  : Bekhzod Ubaydullaev
 **/
public without sharing class BatchAddRemoveOpportunityTeamMember implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
  public Boolean addOrRemove;
  public List<OpportunityTeamMember> teamMember;
  public BatchAddRemoveOpportunityTeamMember(
    List<OpportunityTeamMember> teamMember,
    Boolean addOrRemove
  ) {
    this.addOrRemove = addOrRemove;
    this.teamMember = teamMember;
  }
  public Database.QueryLocator start(Database.BatchableContext BC) {
    return Database.getQueryLocator(
      [
        SELECT Id, Name, OpportunityId, UserId, OpportunityAccessLevel
        FROM OpportunityTeamMember
        WHERE Id IN :this.teamMember
      ]
    );
  }

  public void execute(
    Database.BatchableContext BC,
    List<OpportunityTeamMember> teamMembers
  ) {
    OpportunityTeamQuipCallMethods.shareQuipDocMemberInserted(
      teamMembers,
      this.addOrRemove
    );
  }

  public void finish(Database.BatchableContext BC) {
  }
}