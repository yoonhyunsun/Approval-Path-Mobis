/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 11-24-2022
 * @last modified by  : https://github.com/Eldor901
 **/
public class ApprovalProcessPathFactory {
  public static ApprovalProcessPathDTO createApprovalPath(String ApprovalType) {
    ApprovalProcessPathDTO approvalPath = new ApprovalProcessPathDTO();
    approvalPath.ApprovalType = ApprovalType;

    return approvalPath;
  }

  public static List<ApprovalProcessPathDTO> validApprovalPaths() {
    List<ApprovalProcessPathDTO> approvalProcessPaths = new List<ApprovalProcessPathDTO>();

    approvalProcessPaths.add(createApprovalPath('General Approval'));
    approvalProcessPaths.add(createApprovalPath('Reference'));
    approvalProcessPaths.add(createApprovalPath('Reference'));
    approvalProcessPaths.add(createApprovalPath('Collaboration'));
    approvalProcessPaths.add(createApprovalPath('General Approval'));
    approvalProcessPaths.add(createApprovalPath('Reference'));
    approvalProcessPaths.add(createApprovalPath('Collaboration'));
    approvalProcessPaths.add(createApprovalPath('General Approval'));
    approvalProcessPaths.add(createApprovalPath('General Approval'));

    return approvalProcessPaths;
  }

  public static List<ApprovalProcessPathDTO> invalidApprovalPaths() {
    List<ApprovalProcessPathDTO> approvalProcessPaths = new List<ApprovalProcessPathDTO>();

    approvalProcessPaths.add(createApprovalPath('General Approval'));
    approvalProcessPaths.add(createApprovalPath('Reference'));

    return approvalProcessPaths;
  }

  public static List<ApprovalProcessPathDTO> favoriteApprovalPaths() {
    List<ApprovalProcessPathDTO> approvalProcessPaths = new List<ApprovalProcessPathDTO>();

    approvalProcessPaths.add(createApprovalPath('General Approval'));
    approvalProcessPaths.add(createApprovalPath('Reference'));
    approvalProcessPaths.add(createApprovalPath('General Approval'));

    return approvalProcessPaths;
  }

  public static ApprovalProcessPath__c createApprovalProcessPath(
    String approvalProcessId
  ) {
    ApprovalProcessPath__c approvalPath = new ApprovalProcessPath__c();
    approvalPath.ApprovalStatus__c = 'Read';
    approvalPath.ApprovalProcess__c = approvalProcessId;
    approvalPath.ApprovalUser__c = UserInfo.getUserId();
    approvalPath.ApprovalProcessPathUID__c = GenerateUID.generate();

    insert approvalPath;

    return approvalPath;
  }
}