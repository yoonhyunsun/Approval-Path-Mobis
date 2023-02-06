/**
 * @description       :
 * @author            : Chaewon Kwak
 * @last modified on  : 11-17-2022
 * @last modified by  : Chaewon Kwak
 **/
@isTest
public class Opportunity_tr_ts {
  @TestSetup
  static void makeData() {
    RecordType vehicleRecordType = [
      SELECT Id
      FROM recordtype
      WHERE SobjectType = 'vehicleProject__c'
      LIMIT 1
    ];

    AccountRegion__c accRegion = new AccountRegion__c(
      Name = 'Test Account Region'
    );
    insert accRegion;

    Account acc = new Account(
      Name = 'Test Account',
      AccountRegion__c = accRegion.Id
    );
    insert acc;

    VehicleProject__c vehicleProj = new VehicleProject__c(
      RecordTypeId = vehicleRecordType.Id,
      Name = 'Test Vehicle Project',
      AccountName__c = acc.Id
    );
    insert vehicleProj;

    BU__c bu = new BU__c(Name = 'Test BU');
    insert bu;

    Product2 product = new Product2(
      Name = 'Test Product',
      BU__c = bu.Id,
      LargeGroup__c = 'AV'
    );
    insert product;

    Opportunity oppty = new Opportunity(
      AccountId = acc.Id,
      VehicleProject__c = vehicleProj.Id,
      BU__c = bu.Id,
      Product__c = product.Id,
      CloseDate = System.today() + 15,
      ProductSpecification__c = 'Test Opportunity'
    );
    insert oppty;

    DocumentType__mdt documentTypeMDT = [
      SELECT DeveloperName, Department__c
      FROM DocumentType__mdt
      WHERE Label = 'RFQ Package'
    ];

    Contents__c content = new Contents__c(
      Name = 'RFQ Package',
      DocumentType__c = documentTypeMDT.DeveloperName,
      DepartmentIncharge__c = documentTypeMDT.Department__c,
      Opportunity__c = oppty.Id,
      Description__c = 'Test Content'
    );
    insert content;
  }

  @isTest
  static void OpportunityTriggerInsertTest() {
    Opportunity testOppty = [
      SELECT
        Name,
        Id,
        AccountId,
        VehicleProject__c,
        BU__c,
        CloseDate,
        Product__c,
        ProductSpecification__c,
        StageName,
        Description
      FROM Opportunity
      WHERE ProductSpecification__c = 'Test Opportunity'
    ];

    Contents__c testContent = [
      SELECT
        Name,
        DocumentType__c,
        DepartmentIncharge__c,
        Opportunity__c,
        Description__c
      FROM Contents__c
      WHERE Description__c = 'Test Content'
    ];

    Test.startTest();
    try {
      insert testOppty;
    } catch (Exception e) {
      System.assertEquals(
        'Test Account Test Vehicle Project Test Product',
        testOppty.Name
      );
      System.assertEquals('Qualification', testOppty.StageName);
    }

    // testContent.Opportunity__c = testOppty.Id;
    try {
      insert testContent;
    } catch (Exception e) {
      System.assertEquals('A', testContent.DocumentType__c);
    }
  }
}