/**
 * @description       :
 * @author            : Bekhzod Ubaydullaev
 * @group             :
 * @last modified on  : 11-25-2022
 * @last modified by  : Bekhzod Ubaydullaev
 **/
@IsTest
public class QuipControllerServiceTest {
  @IsTest
  static void testGetUrlTry() {
    QuipDTO quipDto;
    QuipDTO quipDto2;
    List<Schema.PicklistEntry> entries = ApprovalProcess__c.ReportType__c.getDescribe()
      .getPicklistValues();
    Test.setMock(HttpCalloutMock.class, new QuipCalloutMockTest());
    Test.startTest();
    List<Opportunity> opp = [
      SELECT Id, StageName, LastPdfUpdate__c, LastDistributionId__c
      FROM Opportunity
      WHERE StageName = 'RFQ Received'
      ORDER BY CreatedDate
    ];
    quipDto = QuipController.getQuipPdfUrl(opp[0].Id, entries[0].getValue());
    quipDto2 = QuipController.getQuipPdfUrl(opp[1].Id, entries[0].getValue());
    Test.stopTest();
    System.assertNotEquals(null, quipDto);
    System.assertNotEquals(null, quipDto2);
  }

  @IsTest
  static void testGetUrlCatch() {
    QuipDTO quipDto;
    QuipDTO quipDto2 = new QuipDTO();
    quipDto2.exportPdfStatus = 'SUCCESS';
    List<Opportunity> opp = [
      SELECT Id, StageName, LastPdfUpdate__c, LastDistributionId__c
      FROM Opportunity
      WHERE StageName = 'RFQ Received'
      ORDER BY CreatedDate
    ];
    List<Schema.PicklistEntry> entries = ApprovalProcess__c.ReportType__c.getDescribe()
      .getPicklistValues();
    Test.setMock(HttpCalloutMock.class, new QuipCalloutMockTest());
    Test.startTest();
    quipDto2 = QuipController.tryQuipPdfUrl(quipDto2, opp[1].Id);
    quipDto = QuipController.getQuipPdfUrl(
      OpportunityFactory.createOpportunityWithStage(
          'RFQ Received',
          'quip/12345',
          'Test 2'
        )
        .Id,
      entries[0].getValue()
    );
    Test.stopTest();
    System.assertNotEquals(null, quipDto);
    System.assertEquals(null, quipDto2.error);
  }

  @IsTest
  static void testNewPdfIF() {
    QuipDTO quipDto = new QuipDTO();
    quipDto.exportPdfStatus = 'PROGRESSING';
    QuipDTO quipDto2 = new QuipDTO();
    quipDto2.exportPdfStatus = 'SUCCESS';
    List<Opportunity> opp = [
      SELECT Id, StageName, LastPdfUpdate__c, LastDistributionId__c
      FROM Opportunity
      WHERE StageName = 'RFQ Received'
      ORDER BY CreatedDate
    ];
    Test.setMock(HttpCalloutMock.class, new QuipCalloutMockTest());
    Test.startTest();
    quipDto = QuipController.tryQuipPdfUrl(quipDto, opp[1].Id);
    quipDto2 = QuipController.tryQuipPdfUrl(quipDto2, opp[0].Id);
    Test.stopTest();
    System.assertEquals(null, quipDto.error);
    System.assertNotEquals(null, quipDto2.error);
  }

  @TestSetup
  static void makeData() {
    OpportunityFactory.createOpportunityWithStage(
      'RFQ Received',
      'quip/12345',
      'Test'
    );

    Opportunity opp = OpportunityFactory.createOpportunityWithStage(
      'RFQ Received',
      'quip/12345',
      'Test IF'
    );

    ContentDocumentLink cdl = OpportunityFactory.createOpportunityPdfFile(
      'Test',
      opp.Id
    );

    List<Opportunity> opport = [
      SELECT Id, StageName, LastPdfUpdate__c, LastDistributionId__c
      FROM Opportunity
      WHERE StageName = 'RFQ Received'
      ORDER BY CreatedDate
    ];

    opport[0].LastPdfUpdate__c = '1558224928731511';
    opport[0].LastDistributionId__c = cdl.Id;
    update opport;
  }
}