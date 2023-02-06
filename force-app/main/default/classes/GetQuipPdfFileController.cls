@RestResource(urlMapping='/GetQuipPdf/*')
global without sharing class GetQuipPdfFileController {
  @HttpGet
  global static void getPdf() {
    RestRequest request = RestContext.request;
    RestResponse response = RestContext.response;
    String uid = RestContext.request.params.get('uid');
    Id docId = RestContext.request.params.get('docId');

    if (uid != null) {
      List<ApprovalProcessPath__c> app = [
        SELECT Id, ApprovalProcess__r.Opportunity__r.LastDistributionId__c
        FROM ApprovalProcessPath__c
        WHERE ApprovalProcessPathUID__c = :uid
        LIMIT 1
      ];

      if (app.isEmpty()) {
        response.statusCode = 404;
        return;
      }

      docId = app[0].ApprovalProcess__r.Opportunity__r.LastDistributionId__c;
    }

    List<ContentDocumentLink> cdl = [
      SELECT ID, ContentDocumentId
      FROM ContentDocumentLink
      WHERE Id = :docId
      LIMIT 1
    ];

    if (cdl.isEmpty()) {
      response.statusCode = 404;
      return;
    }

    List<ContentVersion> cv = [
      SELECT Id, VersionData
      FROM ContentVersion
      WHERE ContentDocumentId = :cdl[0].ContentDocumentId AND IsLatest = TRUE
      LIMIT 1
    ];

    if (cv.isEmpty()) {
      response.statusCode = 404;
      return;
    }

    RestContext.response.addHeader('Content-Type', 'application/pdf');
    RestContext.response.addHeader(
      'Content-Disposition',
      'inline; filename=doc.pdf'
    );
    response.statusCode = 200;
    RestContext.response.responseBody = cv[0].VersionData;
  }
}