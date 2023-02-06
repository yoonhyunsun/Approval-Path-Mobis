/**
 * @description       :
 * @author            : Bekhzod Ubaydullaev
 * @group             :
 * @last modified on  : 10-19-2022
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
}