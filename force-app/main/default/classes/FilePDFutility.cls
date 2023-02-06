/**
 * @description       :
 * @author            : Bekhzod Ubaydullaev
 * @group             :
 * @last modified on  : 01-04-2023
 * @last modified by  : Bekhzod Ubaydullaev
 **/

public class FilePDFutility {
  public static ReportTypeDTO getQuipUrlByReportType(
    String opportunityId,
    String reportType
  ) {
    ReportTypeDTO reportTypeDTO = new ReportTypeDTO();

    List<Schema.PicklistEntry> entries = ApprovalProcess__c.ReportType__c.getDescribe()
      .getPicklistValues();

    Opportunity opportunity = [
      SELECT
        Id,
        StageName,
        QuipDoc__c,
        QuipDoc3__c,
        QuipDoc4__c,
        QuipDoc5__c,
        QuipDoc6__c,
        QuipDoc7__c,
        QuipDoc8__c,
        FirstReportApproved__c,
        SecondReportApproved__c,
        ThirdReportApproved__c,
        SecondReportNeeded__c,
        ThirdReportNeeded__c
      FROM Opportunity
      WHERE Id = :opportunityId
    ];

    List<ApprovalProcess__c> appList = [
      SELECT Id, Opportunity_Stage__c
      FROM ApprovalProcess__c
      WHERE
        Opportunity_Stage__c = 'Quote Submitted'
        AND ApprovalStatus__c = 'Approved'
        AND Opportunity__c = :opportunityId
    ];

    if (opportunity.StageName == 'RFQ Received') {
      reportTypeDTO.quipDocUrl = opportunity.QuipDoc__c;
      reportTypeDTO.reportType = entries[0].getValue();
    }

    if (opportunity.StageName == 'Quote Submitted') {
      if (appList.size() == 0 && !opportunity.FirstReportApproved__c) {
        reportTypeDTO.quipDocUrl = opportunity.QuipDoc3__c;
        reportTypeDTO.reportType = entries[1].getValue();
      }
      if (
        appList.size() == 1 &&
        opportunity.FirstReportApproved__c &&
        !opportunity.SecondReportApproved__c &&
        opportunity.SecondReportNeeded__c
      ) {
        reportTypeDTO.quipDocUrl = opportunity.QuipDoc7__c;
        reportTypeDTO.reportType = entries[2].getValue();
      }
      if (
        appList.size() == 2 &&
        opportunity.FirstReportApproved__c &&
        opportunity.SecondReportApproved__c &&
        !opportunity.ThirdReportApproved__c &&
        opportunity.ThirdReportNeeded__c
      ) {
        reportTypeDTO.quipDocUrl = opportunity.QuipDoc8__c;
        reportTypeDTO.reportType = entries[3].getValue();
      }
    }

    if (opportunity.StageName == 'Negotiation') {
      if (reportType == entries[4].getValue() || reportType == null) {
        reportTypeDTO.quipDocUrl = opportunity.QuipDoc4__c;
        reportTypeDTO.reportType = entries[4].getValue();
      }

      if (reportType == entries[5].getValue()) {
        reportTypeDTO.quipDocUrl = opportunity.QuipDoc5__c;
        reportTypeDTO.reportType = entries[5].getValue();
      }

      if (reportType == entries[6].getValue()) {
        reportTypeDTO.quipDocUrl = opportunity.QuipDoc6__c;
        reportTypeDTO.reportType = entries[6].getValue();
      }
    }

    if (reportTypeDTO.quipDocUrl == null) {
      reportTypeDTO.quipDocUrl = 'ERROR';
    }

    return reportTypeDTO;
  }

  public static void deletePDF(Id opptyId) {
    Opportunity oppty = [
      SELECT Id, LastPdfUrl__c, LastDistributionId__c
      FROM Opportunity
      WHERE Id = :opptyId
    ];
    Id idToDelete = oppty.LastDistributionId__c;

    if (idToDelete == null) {
      return;
    }

    List<ContentDocumentLink> cdlToDelete = [
      SELECT Id
      FROM ContentDocumentLink
      WHERE Id = :idToDelete
    ];

    if (cdlToDelete.size() > 0) {
      Database.delete(cdlToDelete, false);
    }
  }

  public static QuipDTO generatePdfUrl(QuipDTO quipDto, Id opptyId) {
    Opportunity oppty = [
      SELECT Id, LastPdfUrl__c, LastDistributionId__c
      FROM Opportunity
      WHERE Id = :opptyId
    ];

    List<ContentDocumentLink> cdl = [
      SELECT ContentDocument.Title, ContentDocument.FileType, ContentDocumentId
      FROM ContentDocumentLink
      WHERE
        LinkedEntityId = :opptyId
        AND ShareType = 'V'
        AND ContentDocument.FileType = 'PDF'
      ORDER BY ContentDocument.CreatedDate DESC
      LIMIT 1
    ];

    if (cdl.size() == 0) {
      quipDto.error = 'No PDF file is available';
      return quipDto;
    }

    ContentVersion cv = [
      SELECT Id, Title
      FROM ContentVersion
      WHERE ContentDocumentId = :cdl[0].ContentDocumentId
    ];

    ContentDistribution cd = new ContentDistribution();
    cd.Name = cv.Title;
    cd.ContentVersionId = cv.Id;
    cd.PreferencesAllowViewInBrowser = true;
    cd.PreferencesAllowOriginalDownload = true;
    cd.PreferencesPasswordRequired = false;
    cd.PreferencesNotifyOnVisit = false;
    insert cd;

    oppty.LastDistributionId__c = cdl[0].Id;
    update oppty;

    ContentDistribution cdInserted = [
      SELECT DistributionPublicUrl
      FROM ContentDistribution
      WHERE Id = :cd.Id
    ];

    quipDto.quipPdfUrl = cdInserted.DistributionPublicUrl;

    return quipDto;
  }
}