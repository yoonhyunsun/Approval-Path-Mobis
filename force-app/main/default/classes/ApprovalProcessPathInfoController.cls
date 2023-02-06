/**
 * @description       :
 * @author            : Bekhzod Ubaydullaev
 * @group             :
 * @last modified on  : 12-07-2022
 * @last modified by  : Bekhzod Ubaydullaev
 **/
@RestResource(urlMapping='/ApprovalProcessInfo/*')
global without sharing class ApprovalProcessPathInfoController {
  @HttpGet
  global static void getInfo() {
    RestRequest request = RestContext.request;
    RestResponse response = RestContext.response;
    String uid = RestContext.request.params.get('uid');

    String PUBLIC_SITE_URL = ApprovalProcessSettings__c.getInstance(
      'MobisApprovalProcessSettings'
    )
    .PublicSiteURL__c;

    List<ApprovalProcessPath__c> app = [
      SELECT ApprovalProcess__c, Employee__r.Name, fm_Department__c, ApprovalType__c, RequestDateTime__c, OpenDateTime__c, ApprovalDateTime__c, ApprovalStatus__c, Comment__c
      FROM ApprovalProcessPath__c
      WHERE ApprovalProcessPathUID__c = :uid
    ];
    List<ApprovalProcess__c> ap = new List<ApprovalProcess__c>();
    if (!app.isEmpty()) {
      ap = [
        SELECT
          Name,
          OwnerId,
          Description__c,
          Opportunity__r.Name,
          ReportType__c,
          PdfURL__c,
          ApprovalStatus__c
        FROM ApprovalProcess__c
        WHERE Id = :app[0].ApprovalProcess__c
      ];
    }

    Boolean showButtons = false;

    JSONGenerator gen = JSON.createGenerator(true);

    if (!ap.isEmpty() && ap[0].ApprovalStatus__c != 'Cancelled') {
      showButtons = ApproverActionUtil.showApproveButtons(uid);
      gen.writeStartObject();

      gen.writeStringField(
        'process_name',
        ap[0].Name == null ? '' : ap[0].Name
      );
      gen.writeStringField(
        'employee_name',
        String.valueOf(app[0].Employee__r.Name) == null
          ? ''
          : String.valueOf(app[0].Employee__r.Name)
      );
      gen.writeStringField(
        'department',
        app[0].fm_Department__c == null ? '' : app[0].fm_Department__c
      );
      gen.writeStringField(
        'opportunity_name',
        ap[0].Opportunity__r.Name == null ? '' : ap[0].Opportunity__r.Name
      );
      gen.writeStringField(
        'approval_type',
        app[0].ApprovalType__c == null ? '' : app[0].ApprovalType__c
      );
      gen.writeStringField(
        'comment',
        app[0].Comment__c == null ? '' : app[0].Comment__c
      );
      gen.writeStringField(
        'request_datetime',
        app[0].RequestDateTime__c == null ? '' : String.valueOf(app[0].RequestDateTime__c)
      );
      gen.writeStringField(
        'open_datetime',
        app[0].OpenDateTime__c == null ? '' : String.valueOf(app[0].OpenDateTime__c)
      );
      gen.writeStringField(
        'approval_datetime',
        app[0].ApprovalDateTime__c == null ? '' : String.valueOf(app[0].ApprovalDateTime__c)
      );
      gen.writeStringField(
        'approval_status',
        app[0].ApprovalStatus__c == null ? '' : app[0].ApprovalStatus__c
      );
      gen.writeStringField(
        'pdf_url',
        PUBLIC_SITE_URL + 'approve/services/apexrest/GetQuipPdf/?uid='
      );
      gen.writeBooleanField('show_approve_buttons', showButtons);

      gen.writeEndObject();

      response.statusCode = 200;
    } else {
      gen.writeStartObject();
      gen.writeStringField('error', 'Not Found');
      gen.writeEndObject();

      response.statusCode = 404;
    }

    RestContext.response.addHeader('Content-Type', 'application/json');
    RestContext.response.responseBody = Blob.valueOf(gen.getAsString());
  }
}