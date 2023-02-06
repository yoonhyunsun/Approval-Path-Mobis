/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 11-15-2022
 * @last modified by  : https://github.com/Eldor901
 **/
public class ApprovalPathValidation {
  public static Boolean checkApprovalPaths(
    List<ApprovalProcessPathDTO> approvalProcessPathes
  ) {
    if (approvalProcessPathes.isEmpty()) {
      throw new IllegalArgumentException(System.Label.ERR_NOT_APPROVAL_PATH);
    }

    return true;
  }
}