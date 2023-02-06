/**
 * @description       :
 * @author            : Bekhzod Ubaydullaev
 * @group             :
 * @last modified on  : 01-27-2023
 * @last modified by  : Bekhzod Ubaydullaev
 **/
public without sharing class OpportunityTeamQuipCallMethods {
  public static void quipDocInsert(
    Map<String, List<String>> opptyQuipDoc,
    Boolean future
  ) {
    List<OpportunityTeamMember> teamMembers = [
      SELECT Id, OpportunityId, UserId
      FROM OpportunityTeamMember
      WHERE OpportunityId IN :opptyQuipDoc.keySet()
    ];
    if (teamMembers.size() == 0) {
      System.debug(
        'No team members for Opportunity: ' +
        JSON.serialize(opptyQuipDoc.keySet())
      );
      return;
    }

    if (future) {
      String opptyQuipDeserial = JSON.serialize(opptyQuipDoc);
      String teamMembersDeserial = JSON.serialize(teamMembers);
      quipDocInsertFuture(opptyQuipDeserial, teamMembersDeserial);
    } else {
      BatchQuipDocInserted batch = new BatchQuipDocInserted(opptyQuipDoc);
      Database.executeBatch(batch, 30);
    }
  }

  @future(callout=true)
  public static void addRemoveFuture(String deserialJson, Boolean addOrRemove) {
    List<OpportunityTeamMember> teamMembers = (List<OpportunityTeamMember>) Json.deserialize(
      deserialJson,
      List<OpportunityTeamMember>.class
    );
    OpportunityTeamQuipShare.shareQuipDocMemberInserted(
      teamMembers,
      addOrRemove
    );
  }

  @future(callout=true)
  public static void quipDocInsertFuture(
    String opptyQuipDeserial,
    String teamMembersDeserial
  ) {
    Map<String, List<String>> opptyQuipDoc = (Map<String, List<String>>) JSON.deserialize(
      opptyQuipDeserial,
      Map<String, List<String>>.class
    );
    List<OpportunityTeamMember> teamMembers = (List<OpportunityTeamMember>) Json.deserialize(
      teamMembersDeserial,
      List<OpportunityTeamMember>.class
    );
    OpportunityTeamQuipShare.shareQuipDocInserted(opptyQuipDoc, teamMembers);
  }

  public static void shareQuipDocInserted(
    Map<String, List<String>> opptyQuipDoc,
    List<OpportunityTeamMember> teamMembers
  ) {
    OpportunityTeamQuipShare.shareQuipDocInserted(opptyQuipDoc, teamMembers);
  }

  public static void shareQuipDocMemberInserted(
    List<OpportunityTeamMember> teamMembers,
    Boolean addOrRemove
  ) {
    OpportunityTeamQuipShare.shareQuipDocMemberInserted(
      teamMembers,
      addOrRemove
    );
  }

  public static Map<String, List<String>> approversMapping(
    List<ApprovalProcessPath__c> paths
  ) {
    Map<String, List<String>> processUserMap = new Map<String, List<String>>();
    Map<String, List<String>> quipDocUserMap = new Map<String, List<String>>();
    Set<Id> appovalProcesses = new Set<Id>();
    for (ApprovalProcessPath__c path : paths) {
      appovalProcesses.add(path.ApprovalProcess__c);
    }

    List<ApprovalProcessPath__c> allPathesToCheck = [
      SELECT
        Id,
        ApprovalProcess__c,
        Opportunity__c,
        ApprovalStatus__c,
        ApprovalUser__c,
        ApprovalType__c,
        Employee__c
      FROM ApprovalProcessPath__c
      WHERE ApprovalProcess__c IN :appovalProcesses
    ];

    for (ApprovalProcessPath__c path : paths) {
      if (path.ApprovalUser__c != null && path.ApprovalType__c != 'Draft') {
        Boolean include = true;
        for (ApprovalProcessPath__c pathCheck : allPathesToCheck) {
          if (
            path.ApprovalProcess__c == pathCheck.ApprovalProcess__c &&
            path.ApprovalUser__c == pathCheck.ApprovalUser__c &&
            pathCheck.ApprovalType__c == 'Draft'
          ) {
            include = false;
          }
        }
        if (include) {
          if (processUserMap.containsKey(path.ApprovalProcess__c)) {
            processUserMap.get(path.ApprovalProcess__c)
              .add(path.ApprovalUser__c);
          } else {
            processUserMap.put(
              path.ApprovalProcess__c,
              new List<String>{ path.ApprovalUser__c }
            );
          }
        }
      }
      if (
        path.ApprovalUser__c == null &&
        path.Employee__c != null &&
        path.ApprovalType__c != 'Draft'
      ) {
        if (processUserMap.containsKey(path.ApprovalProcess__c)) {
          processUserMap.get(path.ApprovalProcess__c).add(path.Employee__c);
        } else {
          processUserMap.put(
            path.ApprovalProcess__c,
            new List<String>{ path.Employee__c }
          );
        }
      }
    }
    List<ApprovalProcess__c> processes = [
      SELECT Id, Opportunity__c, QuipURL__c
      FROM ApprovalProcess__c
      WHERE Id IN :processUserMap.keySet()
    ];
    for (ApprovalProcess__c app : processes) {
      if (
        processUserMap.containsKey(app.Id) && String.isNotBlank(app.QuipURL__c)
      ) {
        quipDocUserMap.put(app.QuipURL__c, processUserMap.get(app.Id));
      }
    }

    return quipDocUserMap;
  }

  public static void shareWithApprovers(
    List<ApprovalProcessPath__c> paths,
    Boolean addOrRemove
  ) {
    Map<String, List<String>> quipDocUserMap = approversMapping(paths);

    if (quipDocUserMap.keySet().size() == 0) {
      return;
    }

    if (quipDocUserMap.keySet().size() <= 20) {
      String serialized = JSON.serialize(quipDocUserMap);
      futureSharePaths(serialized, addOrRemove);
    } else {
      Database.executeBatch(
        new BatchAddRemoveApprovers(paths, addOrRemove),
        70
      );
    }
  }

  @future(callout=true)
  public static void futureSharePaths(String serialized, Boolean addOrRemove) {
    Map<String, List<String>> quipDocUserMap = (Map<String, List<String>>) Json.deserialize(
      serialized,
      Map<String, List<String>>.class
    );
    OpportunityTeamQuipShare.shareQuipApprovers(quipDocUserMap, addOrRemove);
  }
}