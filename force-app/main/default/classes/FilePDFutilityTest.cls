/**
 * @description       :
 * @author            : Bekhzod Ubaydullaev
 * @group             :
 * @last modified on  : 12-20-2022
 * @last modified by  : Bekhzod Ubaydullaev
 **/
@IsTest
public class FilePDFutilityTest {
  @IsTest
  static void testUrlByReportType() {
    Test.setMock(HttpCalloutMock.class, new QuipCalloutMockTest());
    ReportTypeDTO reportTypeDTO;
    List<Schema.PicklistEntry> entries = ApprovalProcess__c.ReportType__c.getDescribe()
      .getPicklistValues();

    reportTypeDTO = QuipController.getReportTypeAndQuipUrl(
      OpportunityFactory.createOpportunityWithStage(
          'RFQ Received',
          'quip Url',
          'Test'
        )
        .Id,
      entries[0].getValue()
    );
    System.assertNotEquals(null, reportTypeDTO);
  }
  /*
  @IsTest
  static void getQuipUrlQuoteSubmitted() {
    Test.setMock(HttpCalloutMock.class, new QuipCalloutMockTest());
    List<Schema.PicklistEntry> entries = ApprovalProcess__c.ReportType__c.getDescribe()
      .getPicklistValues();

    ReportTypeDTO reportTypeDTO;
    for (Integer i = 0; i < 3; i++) {
      OpportunityFactory.createOpportunityWithApprovalProcesses(
        'Quote Submitted',
        'Approved',
        i,
        i + ''
      );
    }
    List<Opportunity> oppList = [
      SELECT
        Id,
        FirstReportApproved__c,
        SecondReportApproved__c,
        ThirdReportApproved__c,
        SecondReportNeeded__c,
        ThirdReportNeeded__c
      FROM Opportunity
      ORDER BY CreatedDate
    ];

    oppList[2].FirstReportApproved__c = true;
    oppList[2].SecondReportApproved__c = true;
    oppList[2].SecondReportNeeded__c = true;
    oppList[2].ThirdReportNeeded__c = true;

    oppList[1].FirstReportApproved__c = true;
    oppList[1].SecondReportNeeded__c = true;

    update oppList;

    List<Opportunity> oppList3 = [
      SELECT Id, StageName
      FROM Opportunity
      ORDER BY CreatedDate
    ];
    for (Opportunity opp : oppList3) {
      opp.StageName = 'Quote Submitted';
    }
    update oppList3;

    for (Integer i = 0; i < 3; i++) {
      reportTypeDTO = FilePDFutility.getQuipUrlByReportType(
        oppList[i].Id,
        entries[i + 1].getValue()
      );
    }
    System.assertNotEquals(null, reportTypeDTO);
  }
*/
  /*
  @IsTest
  static void getQuipUrlNegotiation() {
    Test.setMock(HttpCalloutMock.class, new QuipCalloutMockTest());
    ReportTypeDTO reportTypeDTO;
    List<Schema.PicklistEntry> entries = ApprovalProcess__c.ReportType__c.getDescribe()
      .getPicklistValues();
    for (Integer j = 4; j < 7; j++) {
      reportTypeDTO = FilePDFutility.getQuipUrlByReportType(
        OpportunityFactory.createOpportunityWithStage(
            'Negotiation',
            null,
            j + ''
          )
          .Id,
        entries[j].getValue()
      );
    }
    System.assertNotEquals(null, reportTypeDTO);
  }
*/
  @IsTest
  static void testPdfMethods() {
    Test.setMock(HttpCalloutMock.class, new QuipCalloutMockTest());
    QuipDTO quip = new QuipDTO();
    QuipDTO quip2 = new QuipDTO();
    Opportunity opp = OpportunityFactory.createOpportunityRfqValid('Test');
    Opportunity opp2 = OpportunityFactory.createOpportunityRfqValid('Test 2');
    OpportunityFactory.createOpportunityPdfFile('Test', opp.Id);
    quip = FilePDFutility.generatePdfUrl(quip, opp.Id);
    FilePDFutility.deletePDF(opp.Id);
    quip2 = FilePDFutility.generatePdfUrl(quip2, opp2.Id);
    FilePDFutility.deletePDF(opp2.Id);
    System.assertEquals(null, quip.error);
    System.assertNotEquals(null, quip2.error);
  }

  @TestSetup
  static void makeData() {
    TestFactory.createCustomSetting();
  }
}