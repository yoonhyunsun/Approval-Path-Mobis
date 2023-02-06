/**
 * @description       :
 * @author            : Bekhzod Ubaydullaev
 * @group             :
 * @last modified on  : 12-07-2022
 * @last modified by  : Bekhzod Ubaydullaev
 **/
public without sharing class ApprovalPathSharingUtil {
  public static void shareRecord(List<ApprovalProcessPath__c> paths) {
    List<ApprovalProcess__Share> processShare = new List<ApprovalProcess__Share>();

    /** NEED to create a Custom sharing reason for Approval Process */
    for (ApprovalProcessPath__c path : paths) {
      //Cannot share a record with User who is the owner of a record, else Error
      if (
        path.ApprovalProcess__r.OwnerId != path.ApprovalUser__c &&
        path.ApprovalUser__c != null
      ) {
        ApprovalProcess__Share procShare = new ApprovalProcess__Share();
        procShare.ParentId = path.ApprovalProcess__c;
        procShare.UserOrGroupId = path.ApprovalUser__c;
        procShare.AccessLevel = 'Edit';
        procShare.RowCause = Schema.ApprovalProcess__Share.RowCause.Approval_Sharing__c;
        processShare.add(procShare);
      }
    }

    if (processShare.size() != 0) {
      Database.SaveResult[] srs = Database.insert(processShare, false);
    }
  }

  public static void deleteShareRecord(List<ApprovalProcessPath__c> paths) {
    List<ApprovalProcess__Share> recordsDelete = new List<ApprovalProcess__Share>();
    Map<Id, Set<Id>> m = new Map<Id, Set<Id>>();
    String rowCause = Schema.ApprovalProcess__Share.RowCause.Approval_Sharing__c;

    for (ApprovalProcessPath__c path : paths) {
      if (path.ApprovalUser__c != null) {
        if (m.containsKey(path.ApprovalProcess__c)) {
          m.get(path.ApprovalProcess__c).add(path.ApprovalUser__c);
        } else {
          m.put(path.ApprovalProcess__c, new Set<Id>{ path.ApprovalUser__c });
        }
      }
    }

    for (Id key : m.keySet()) {
      List<ApprovalProcess__Share> share = [
        SELECT Id, ParentId, AccessLevel, UserOrGroupId, RowCause
        FROM ApprovalProcess__Share
        WHERE
          ParentId = :key
          AND UserOrGroupId IN :m.get(key)
          AND RowCause = :rowCause
      ];
      recordsDelete.addAll(share);
    }

    if (recordsDelete.size() != 0) {
      Database.DeleteResult[] result = Database.delete(recordsDelete, false);
    }
  }

  public static void unlockRecord(List<Id> oppList) {
    List<Approval.UnlockResult> lrList = Approval.unlock(oppList, false);
  }

  public static void lockRecord(List<Id> oppList) {
    List<Approval.LockResult> lrList = Approval.lock(oppList, false);
  }

  public static void unlockQuipAndRecord(String quipUrl, String Id) {
    QuipAPI.lockThread(quipUrl, false);
    unlockRecord(new List<Id>{ Id });
  }

  public static void lockQuipAndRecord(String quipUrl, String Id) {
    QuipAPI.lockThread(quipUrl, true);
    lockRecord(new List<Id>{ Id });
  }

  public static void cancelApproval(ApprovalProcess__c approval) {
    List<ApprovalProcessPath__c> paths = [
      SELECT Id, ApprovalProcess__c, ApprovalUser__c, NotifiedGroup__c
      FROM ApprovalProcessPath__c
      WHERE ApprovalProcess__c = :approval.Id
    ];

    for (ApprovalProcessPath__c path : paths) {
      if (path.NotifiedGroup__c == 1 && path.ApprovalUser__c != null) {
        SendNotificationCancelledApproval.notifyFirstApprover(
          new Set<String>{ path.ApprovalUser__c },
          approval.Id
        );
      }
    }

    QuipAPI.lockThread(approval.QuipURL__c, false);
    deleteShareRecord(paths);
    unlockRecord(new List<Id>{ approval.Opportunity__c });
    OpportunityStageApproverTriggerUtil.changeQuickActionDraft(
      approval.Opportunity__c
    );
  }
}