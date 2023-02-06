/**
 * @description       :
 * @author            : Bekhzod Ubaydullaev
 * @group             :
 * @last modified on  : 01-06-2023
 * @last modified by  : Bekhzod Ubaydullaev
 **/
public without sharing class OpportunityTeamQuipShare {
  public static void shareQuipDocMemberInserted(
    List<OpportunityTeamMember> teamMembers,
    Boolean addOrRemove
  ) {
    Map<String, String> allUserWithQuipIds = addQuipIdsToAllMembers(
      teamMembers,
      addOrRemove
    );

    if (allUserWithQuipIds.containsKey('ERROR')) {
      System.debug(allUserWithQuipIds.get('ERROR'));
      return;
    }

    Map<String, Set<String>> opptyUserMap = userQuipIdMapping(
      teamMembers,
      allUserWithQuipIds
    );

    for (String opptyId : opptyUserMap.keySet()) {
      List<String> threads = new List<String>();
      Opportunity oppty = [
        SELECT
          Id,
          StageName,
          QuipDoc__c,
          QuipDoc2__c,
          QuipDoc3__c,
          QuipDoc4__c,
          QuipDoc5__c,
          QuipDoc6__c,
          QuipDoc7__c,
          QuipDoc8__c
        FROM Opportunity
        WHERE Id = :opptyId
      ];
      if (oppty.QuipDoc__c != null) {
        threads.add(oppty.QuipDoc__c);
      }
      if (oppty.QuipDoc2__c != null) {
        threads.add(oppty.QuipDoc2__c);
      }
      if (oppty.QuipDoc3__c != null) {
        threads.add(oppty.QuipDoc3__c);
      }
      if (oppty.QuipDoc4__c != null) {
        threads.add(oppty.QuipDoc4__c);
      }
      if (oppty.QuipDoc5__c != null) {
        threads.add(oppty.QuipDoc5__c);
      }
      if (oppty.QuipDoc6__c != null) {
        threads.add(oppty.QuipDoc6__c);
      }
      if (oppty.QuipDoc7__c != null) {
        threads.add(oppty.QuipDoc7__c);
      }
      if (oppty.QuipDoc8__c != null) {
        threads.add(oppty.QuipDoc8__c);
      }

      for (String thread : threads) {
        if (addOrRemove) {
          QuipAPI.addMembers(thread, opptyUserMap.get(opptyId));
        } else {
          QuipAPI.removeMembers(thread, opptyUserMap.get(opptyId));
        }
      }
    }
    saveQuipIds(allUserWithQuipIds);
  }

  public static Map<String, String> addQuipIdsToAllMembers(
    List<OpportunityTeamMember> teamMembers,
    Boolean addOrRemove
  ) {
    Set<Id> userIdSet = new Set<Id>();
    for (OpportunityTeamMember member : teamMembers) {
      userIdSet.add(member.UserId);
    }

    if (addOrRemove) {
      Set<Id> opportunityId = new Set<Id>();
      for (OpportunityTeamMember member : teamMembers) {
        opportunityId.add(member.OpportunityId);
      }
      List<Opportunity> opptyList = [
        SELECT Id, OwnerId
        FROM Opportunity
        WHERE Id IN :opportunityId
      ];
      for (Opportunity oppty : opptyList) {
        userIdSet.add(oppty.OwnerId);
      }
    }

    List<User> memberUserInfo = [
      SELECT Id, Email, QuipId__c
      FROM USER
      WHERE Id IN :userIdSet
    ];

    Map<String, String> membersWithoutQuipId = new Map<String, String>();
    Map<String, String> membersWithQuipId = new Map<String, String>();

    for (User user : memberUserInfo) {
      if (user.QuipId__c == null) {
        membersWithoutQuipId.put(
          String.valueOf(user.Id),
          String.valueOf(user.Email)
        );
      } else {
        membersWithQuipId.put(
          String.valueOf(user.Id),
          String.valueOf(user.QuipId__c)
        );
      }
    }

    if (membersWithoutQuipId.keySet().size() != 0) {
      Map<String, String> getWithQuipIds = QuipAPI.getQuipId(
        membersWithoutQuipId
      );
      if (getWithQuipIds.containsKey('ERROR')) {
        return getWithQuipIds;
      }
      if (getWithQuipIds.keySet().size() == 0) {
        Map<String, String> errormap = new Map<String, String>();
        errormap.put(
          'ERROR',
          'Users have quip unathorized emails in salesforce'
        );
        return errormap;
      }
      membersWithQuipId.putAll(getWithQuipIds);
    }
    return membersWithQuipId;
  }

  public static Map<String, Set<String>> userQuipIdMapping(
    List<OpportunityTeamMember> teamMembers,
    Map<String, String> mapWithQuipIds
  ) {
    Map<String, Set<String>> opptyUserMap = new Map<String, Set<String>>();
    for (OpportunityTeamMember member : teamMembers) {
      for (String userId : mapWithQuipIds.keySet()) {
        if (member.UserId == userId) {
          if (opptyUserMap.containsKey(member.OpportunityId)) {
            opptyUserMap.get(member.OpportunityId)
              .add(mapWithQuipIds.get(userId));
          } else {
            opptyUserMap.put(
              member.OpportunityId,
              new Set<String>{ mapWithQuipIds.get(userId) }
            );
          }
        }
      }
    }
    return opptyUserMap;
  }

  public static void saveQuipIds(Map<String, String> mapWithQuipIds) {
    List<User> memberUserInfo = [
      SELECT Id, Email, QuipId__c
      FROM USER
      WHERE Id IN :mapWithQuipIds.keySet()
    ];
    Integer count = memberUserInfo.size();
    for (User user : memberUserInfo) {
      if (mapWithQuipIds.containsKey(user.Id) && user.QuipId__c == null) {
        user.QuipId__c = mapWithQuipIds.get(user.Id);
        --count;
      }
    }
    if (count != memberUserInfo.size()) {
      Database.SaveResult[] res = Database.update(memberUserInfo, false);
    }
  }

  public static void shareQuipDocInserted(
    Map<String, List<String>> opptyQuipDoc,
    List<OpportunityTeamMember> teamMembers
  ) {
    Map<String, String> allUserWithQuipIds = addQuipIdsToAllMembers(
      teamMembers,
      true
    );
    if (allUserWithQuipIds.containsKey('ERROR')) {
      System.debug(allUserWithQuipIds.get('ERROR'));
      return;
    }

    Map<String, Set<String>> opptyUserMap = userQuipIdMapping(
      teamMembers,
      allUserWithQuipIds
    );

    for (String opptyId : opptyQuipDoc.keySet()) {
      for (String quipUrl : opptyQuipDoc.get(opptyId)) {
        if (opptyUserMap.get(opptyId).size() != 0) {
          QuipAPI.addMembers(quipUrl, opptyUserMap.get(opptyId));
        }
      }
    }

    saveQuipIds(allUserWithQuipIds);
  }

  public static void shareQuipApprovers(
    Map<String, List<String>> quipDocUserMap,
    Boolean addOrRemove
  ) {
    Map<String, String> allUserWithQuipIds = addQuipIdAllApprovers(
      quipDocUserMap.values()
    );
    if (allUserWithQuipIds.containsKey('ERROR')) {
      System.debug(allUserWithQuipIds.get('ERROR'));
      return;
    }

    for (String quipDoc : quipDocUserMap.keySet()) {
      if (addOrRemove) {
        Map<Integer, List<String>> quipAccessNum = new Map<Integer, List<String>>();
        quipAccessNum.put(3, new List<String>());
        for (String userId : quipDocUserMap.get(quipDoc)) {
          if (allUserWithQuipIds.containsKey(userId)) {
            quipAccessNum.get(3).add(allUserWithQuipIds.get(userId));
          }
        }
        QuipAPI.addApproversWithAccessNumber(quipDoc, quipAccessNum);
      } else {
        Set<String> quipIds = new Set<String>();
        for (String userId : quipDocUserMap.get(quipDoc)) {
          if (allUserWithQuipIds.containsKey(userId)) {
            quipIds.add(allUserWithQuipIds.get(userId));
          }
        }
        QuipAPI.removeMembers(quipDoc, quipIds);
      }
    }
    saveQuipIds(allUserWithQuipIds);
  }

  public static Map<String, String> addQuipIdAllApprovers(
    List<List<String>> approverIds
  ) {
    Set<Id> userIdSet = new Set<Id>();
    for (List<String> apprList : approverIds) {
      for (String appr : apprList) {
        userIdSet.add(appr);
      }
    }

    List<User> approverUserInfo = [
      SELECT Id, Email, QuipId__c
      FROM USER
      WHERE Id IN :userIdSet
    ];

    Map<String, String> approversWithoutQuipId = new Map<String, String>();
    Map<String, String> approversWithQuipId = new Map<String, String>();

    //========================
    List<Contact> cons = [SELECT Id, Email FROM Contact WHERE Id IN :userIdSet];
    for (Contact con : cons) {
      approversWithoutQuipId.put(
        String.valueOf(con.Id),
        String.valueOf(con.Email)
      );
    }

    for (User user : approverUserInfo) {
      if (user.QuipId__c == null) {
        approversWithoutQuipId.put(
          String.valueOf(user.Id),
          String.valueOf(user.Email)
        );
      } else {
        approversWithQuipId.put(
          String.valueOf(user.Id),
          String.valueOf(user.QuipId__c)
        );
      }
    }

    if (approversWithoutQuipId.keySet().size() != 0) {
      Map<String, String> getWithQuipIds = QuipAPI.getQuipId(
        approversWithoutQuipId
      );
      if (getWithQuipIds.containsKey('ERROR')) {
        return getWithQuipIds;
      }
      if (getWithQuipIds.keySet().size() == 0) {
        Map<String, String> errormap = new Map<String, String>();
        errormap.put(
          'ERROR',
          'Users have quip unathorized emails in salesforce'
        );
        return errormap;
      }
      approversWithQuipId.putAll(getWithQuipIds);
    }
    return approversWithQuipId;
  }
}