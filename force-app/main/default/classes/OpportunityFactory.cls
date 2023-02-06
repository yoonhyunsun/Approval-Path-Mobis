/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 12-20-2022
 * @last modified by  : Bekhzod Ubaydullaev
 **/

@isTest
public class OpportunityFactory {
  public static Opportunity createDefaulOpportunity() {
    AccountRegion__c accountRegion = TestFactory.createAccountRegion('KR');
    Account acc = TestFactory.createAccount('Acc', accountRegion.Id);
    VehicleProject__c vp = TestFactory.createVehicleProject('Vehicle', acc.Id);
    BU__c bu = TestFactory.createBU('Vehicle');
    Product2 product = TestFactory.createProduct(
      'product',
      bu.Id,
      'AV',
      'ADAS Driving'
    );

    return TestFactory.createOpportunity(acc.Id, vp.Id, bu.Id, product.Id);
  }

  public static Opportunity createOpportunityRfqValid(String randomName) {
    AccountRegion__c accountRegion = TestFactory.createAccountRegion(
      randomName
    );
    Account acc = TestFactory.createAccount(randomName, accountRegion.Id);
    VehicleProject__c vp = TestFactory.createVehicleProject(randomName, acc.Id);
    BU__c bu = TestFactory.createBU(randomName);
    Product2 product = TestFactory.createProduct(
      randomName,
      bu.Id,
      'AV',
      'ADAS Driving'
    );
    Currency__c cur = TestFactory.createCurrency(randomName);
    return TestFactory.createOpportunityRfqValid(
      acc.Id,
      vp.Id,
      bu.Id,
      product.Id,
      cur.Id
    );
  }

  public static Opportunity createOpportunityWithStage(
    String opportunityStage,
    String QuipDoc,
    String randomName
  ) {
    Opportunity newOpportunity = createOpportunityRfqValid(randomName);
    Opportunity opp = [
      SELECT Id, Name, StageName, QuipDoc__c
      FROM Opportunity
      WHERE Id = :newOpportunity.Id
    ];
    opp.StageName = opportunityStage;
    if (!String.isBlank(QuipDoc)) {
      opp.QuipDoc__c = QuipDoc;
    }
    update opp;
    return opp;
  }

  public static Opportunity createOpportunityWithApprovalProcesses(
    String opportunityStage,
    String processStatus,
    Integer approvalNum,
    String randomName
  ) {
    Opportunity opportunity = createOpportunityWithStage(
      opportunityStage,
      null,
      randomName
    );
    List<ApprovalProcess__c> apps = ApprovalProcessFactory.createApprovalProcesses(
      opportunity.Id,
      opportunityStage,
      processStatus,
      approvalNum
    );
    return opportunity;
  }

  public static ContentDocumentLink createOpportunityPdfFile(
    String filename,
    Id opportunityId
  ) {
    ContentVersion cVersion = new ContentVersion();
    cVersion.Title = filename;
    cVersion.ContentLocation = 'S';
    cVersion.PathOnClient = filename + '.pdf';
    cVersion.VersionData = EncodingUtil.base64Decode('Test');
    insert cVersion;

    ContentDocumentLink cdl = new ContentDocumentLink();
    cdl.ContentDocumentId = [
      SELECT Id, ContentDocumentId
      FROM ContentVersion
      WHERE Id = :cVersion.Id
    ]
    .ContentDocumentId;
    cdl.LinkedEntityId = opportunityId;
    cdl.ShareType = 'V';
    insert cdl;
    return cdl;
  }
}