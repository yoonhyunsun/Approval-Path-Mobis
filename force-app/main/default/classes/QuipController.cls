/**
 * @description       :
 * @author            : Bekhzod Ubaydullaev
 * @group             :
 * @last modified on  : 02-08-2023
 * @last modified by  : Bekhzod Ubaydullaev
 **/
public class QuipController {
  @AuraEnabled
  public static ReportTypeDTO getReportTypeAndQuipUrl(
    String opportunityId,
    String reportType
  ) {
    return FilePDFutility.getQuipUrlByReportType(opportunityId, reportType);
  }

  @AuraEnabled
  public static QuipDTO getQuipPdfUrl(String opportunityId, String reportType) {
    return QuipRequestsService.getQuipPdfUrl(opportunityId, reportType);
  }

  @AuraEnabled
  public static QuipDTO tryQuipPdfUrl(QuipDTO quipDto, String opportunityId) {
    return QuipRequestsService.tryQuipPdfUrl(quipDto, opportunityId);
  }

  @AuraEnabled
  public static Boolean checkIfIsLatestApproval(String approvalId) {
    return QuipRemovalUtil.checkIfIsLatestApproval(approvalId);
  }

  @AuraEnabled
  public static String getOpptyCurrentStage(String opportunityId) {
    return QuipRemovalUtil.getOpptyCurrentStage(opportunityId);
  }

  @AuraEnabled
  public static List<String> getOwnerAndTeamMemberIds(String approvalId) {
    return QuipRemovalUtil.getOwnerAndTeamMemberIds(approvalId);
  }

  @AuraEnabled
  public static void unlockQuip(String quipUrl) {
    QuipAPI.lockThreadSynchronous(quipUrl, false);
  }

  @AuraEnabled
  public static Boolean checkIfNoCreatedOrInProgressApproval(
    String opportunityId
  ) {
    return QuipRemovalUtil.checkIfNoCreatedOrInProgressApproval(opportunityId);
  }

  @AuraEnabled
  public static Decimal getLastReplayId(String opportunityId) {
    return QuipRemovalUtil.getLastReplayId(opportunityId);
  }
}