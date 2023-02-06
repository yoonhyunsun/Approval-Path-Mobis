/**
 * @description       :
 * @author            : Bekhzod Ubaydullaev
 * @group             :
 * @last modified on  : 10-20-2022
 * @last modified by  : Bekhzod Ubaydullaev
 **/
public without sharing class QuipRequestsService {
  
  public static QuipDTO getQuipPdfUrl(String opportunityId, String reportType) {
    QuipDTO quipDto = new QuipDTO();
    try {
      Opportunity opportunity = [
        SELECT
          Id,
          QuipDoc__c,
          LastPdfUpdate__c,
          LastPdfUrl__c,
          LastDistributionId__c
        FROM Opportunity
        WHERE Id = :opportunityId
      ];

      ReportTypeDTO reportTypeDTO = FilePDFutility.getQuipUrlByReportType(
        opportunityId,
        reportType
      );

      if (reportTypeDTO.quipDocUrl == 'ERROR') {
        quipDto.error = 'No quip document found';
        return quipDto;
      }

      String threadId = QuipAPI.idFromUrl(reportTypeDTO.quipDocUrl);

      quipDto.threadId = threadId;

      quipDto = QuipAPI.checkDocUpdate(quipDto);

      if (quipDto.error != null) {
        return quipDto;
      }

      if (quipDto.lastUpdated == opportunity.LastPdfUpdate__c) {
        List<ContentDocumentLink> cdl = [
          SELECT Id
          FROM ContentDocumentLink
          WHERE Id = :opportunity.LastDistributionId__c
        ];
        if (!cdl.isEmpty()) {
          quipDto.quipPdfUrl = opportunity.LastPdfUrl__c;
          return quipDto;
        }
      }

      quipDto = QuipAPI.createPdfRequest(quipDto, opportunityId);

      if (quipDto.error != null) {
        return quipDto;
      }

      quipDto = tryQuipPdfUrl(quipDto, opportunityId);
    } catch (Exception e) {
      quipDto.error = e.getMessage();
    }
    return quipDto;
  }

  public static QuipDTO tryQuipPdfUrl(QuipDTO quipDto, String opportunityId) {
    Opportunity opportunity = [
      SELECT Id, QuipDoc__c, LastPdfUpdate__c, LastPdfUrl__c
      FROM Opportunity
      WHERE Id = :opportunityId
    ];

    quipDto = QuipAPI.retrievePDF(quipDto);

    if (quipDto.error != null || quipDto.exportPdfStatus != 'SUCCESS') {
      return quipDto;
    }

    // CREATE NEW PDF
    FilePDFutility.deletePDF(opportunity.Id);
    quipDto = FilePDFutility.generatePdfUrl(quipDto, opportunity.Id);

    if (quipDto.error != null) {
      return quipDto;
    }

    opportunity.LastPdfUpdate__c = quipDto.lastUpdated;
    opportunity.LastPdfUrl__c = quipDto.quipPdfUrl;
    update opportunity;

    return quipDto;
  }
}