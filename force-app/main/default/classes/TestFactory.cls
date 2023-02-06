/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 12-19-2022
 * @last modified by  : Bekhzod Ubaydullaev
 **/

@isTest
public class TestFactory {
  public static Contact createContact(String lastName, ID departmentId) {
    Id recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
      .get('Employee')
      .getRecordTypeId();

    Contact con = new Contact(LastName = lastName, recordTypeId = recordTypeId);

    con.EmpDepartment__c = departmentId;
    con.IsExecutive__c = true;
    con.UserId__c = userinfo.getUserId();

    insert con;

    return con;
  }

  public static Department__c createDepartment(String name) {
    Department__c department = new Department__c();
    department.Name = name;

    insert department;

    return department;
  }

  public static Opportunity createOpportunity(
    ID accountId,
    ID vehicleId,
    ID BuId,
    ID productId
  ) {
    Opportunity opp = new Opportunity();
    opp.AccountId = accountId;
    opp.VehicleProject__c = vehicleId;
    opp.BU__c = BuId;
    opp.Product__c = productId;
    opp.CloseDate = System.today();
    opp.IsRFQReceived__c = true;

    insert opp;

    return opp;
  }

  public static Account createAccount(String name, ID regionId) {
    Account acc = new Account();
    acc.Name = name;
    acc.AccountRegion__c = regionId;
    insert acc;

    return acc;
  }

  public static AccountRegion__c createAccountRegion(String name) {
    AccountRegion__c accReg = new AccountRegion__c();

    accReg.Name = name;

    insert accReg;

    return accReg;
  }

  public static VehicleProject__c createVehicleProject(
    String name,
    ID accountId
  ) {
    VehicleProject__c vehicle = new VehicleProject__c();
    vehicle.name = name;
    vehicle.AccountName__c = accountId;

    insert vehicle;

    return vehicle;
  }

  public static BU__c createBU(String name) {
    BU__c bu = new BU__c();
    bu.Name = name;
    insert bu;

    return bu;
  }

  public static Product2 createProduct(
    String name,
    ID bUId,
    String LargeGroupName,
    String MediumGroupName
  ) {
    Product2 product = new Product2();

    product.Name = name;
    product.BU__c = bUId;
    product.LargeGroup__c = LargeGroupName;
    product.MediumGroup__c = MediumGroupName;

    insert product;

    return product;
  }

  public static ApprovalProcess__c createApprovalProcess(
    String name,
    ID opportunityId,
    String ApprovalStatus
  ) {
    ApprovalProcess__c approvalProcess = new ApprovalProcess__c();
    approvalProcess.Name = name;
    approvalProcess.Opportunity_Stage__c = 'Qualification';
    approvalProcess.ApprovalStatus__c = ApprovalStatus;
    approvalProcess.Opportunity__c = opportunityId;
    approvalProcess.QuipURL__c = 'https://www.mobis.com/';

    insert approvalProcess;
    return approvalProcess;
  }

  public static ApprovalProcessPath__c createApprovalProcessPath(
    ID approvalProcessId,
    ID ApprovalUserId,
    String approvalType,
    ID employeeId
  ) {
    ApprovalProcessPath__c processPath = new ApprovalProcessPath__c();

    processPath.ApprovalProcess__c = approvalProcessId;
    processPath.ApprovalUser__c = ApprovalUserId;
    processPath.ApprovalType__c = approvalType;
    processPath.Employee__c = employeeId;

    insert processPath;

    return processPath;
  }

  public static ApprovalProcessSettings__c createCustomSetting() {
    ApprovalProcessSettings__c setting = new ApprovalProcessSettings__c();
    setting.Name = 'MobisApprovalProcessSettings';
    setting.CompanyEmail__c = 'tokyodreamer0702@gmail.com';
    setting.EmailSenderName__c = 'Mobis Support';
    setting.LogoURL__c = 'https://upload.wikimedia.org/wikipedia/en/thumb/3/3b/Hyundai_Mobis_logo.svg/1200px-Hyundai_Mobis_logo.svg.png';
    setting.PublicSiteURL__c = 'https://mobis--ps.sandbox.my.salesforce-sites.com/';

    insert setting;

    return setting;
  }

  public static Currency__c createCurrency(String name) {
    Currency__c cur = new Currency__c();
    cur.Name = name;
    insert cur;
    return cur;
  }

  public static Opportunity createOpportunityRfqValid(
    ID accountId,
    ID vehicleId,
    ID BuId,
    ID productId,
    ID currencyId
  ) {
    Opportunity opp = new Opportunity();
    opp.AccountId = accountId;
    opp.VehicleProject__c = vehicleId;
    opp.BU__c = BuId;
    opp.Product__c = productId;
    opp.CloseDate = System.today();
    opp.ManagementTeam__c = 'Global AV Business Team';
    opp.OIManagingregion__c = 'CN';
    opp.DealGrade__c = 'A';
    opp.SOP__c = System.today();
    opp.LifeCycle__c = '6';
    opp.Competitors__c = 'TBD';
    opp.Incoterms__c = 'EXW';
    opp.InvestmentsEDD__c = 'Lump sum';
    opp.InvestmentsToolingCost__c = 'Lump sum';
    opp.PaymentTerms__c = 'T/T 47 Days';
    opp.OEPlant__c = 'Aachen (Germany)';
    opp.MobisPlant__c = 'AL (Commision)';
    opp.ExpectedOI__c = System.today();
    opp.SEG__c = 'A-Seg.';
    opp.CurrencyType__c = currencyId;
    opp.MobisRecentSubmittedQuote__c = 'Some quote';
    opp.FirstReportApproved__c = false;
    opp.SecondReportApproved__c = false;
    opp.ThirdReportApproved__c = false;
    opp.SecondReportNeeded__c = false;
    opp.ThirdReportNeeded__c = false;
    opp.IsRFQReceived__c = true;
    opp.ActualRFQReceivedDate__c = System.today();

    insert opp;

    return opp;
  }

  public static User createUser(String name) {
    Profile profileId = [
      SELECT Id
      FROM Profile
      WHERE Name = 'Standard User'
      LIMIT 1
    ];

    User usr = new User(
      LastName = name,
      FirstName = name,
      Alias = name,
      Email = 'bekhzod.ubaydullaev@i2max.co.kr',
      Username = name + '@gmail.com',
      ProfileId = profileId.id,
      TimeZoneSidKey = 'GMT',
      LanguageLocaleKey = 'en_US',
      EmailEncodingKey = 'UTF-8',
      LocaleSidKey = 'en_US'
    );
    insert usr;
    return usr;
  }

  //Active contact
  public static Contact createContactEmployee(
    String lastName,
    String jobTitleCode
  ) {
    Id recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
      .get('Employee')
      .getRecordTypeId();

    Contact con = new Contact(LastName = lastName, recordTypeId = recordTypeId);
    con.IsEmployee__c = true;
    con.JobTitleCode__c = jobTitleCode;
    con.Status__c = 'Active';
    con.UserId__c = userinfo.getUserId();

    insert con;

    return con;
  }
}