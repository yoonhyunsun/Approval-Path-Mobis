/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 01-05-2023
 * @last modified by  : https://github.com/Eldor901
 **/

public class ApprovalProcessPathDTO {
  // user Id
  @AuraEnabled
  public String Id { get; set; }
  @AuraEnabled
  public String Name { get; set; }
  @AuraEnabled
  public String Department { get; set; }
  @AuraEnabled
  public String Comment { get; set; }
  @AuraEnabled
  public String ApprovalType { get; set; }
  @AuraEnabled
  public String ApprovalStage { get; set; }
  @AuraEnabled
  public String ReportType { get; set; }
  @AuraEnabled
  public Double Order { get; set; }
  @AuraEnabled
  public String Position { get; set; }

  // edit approval path
  //COMEBACK split to classes and extend
  @AuraEnabled
  public String ApprovalPathId { get; set; }

  @AuraEnabled
  public Boolean IsChanged { get; set; }

  @AuraEnabled
  public String Approved { get; set; }

  @AuraEnabled
  public Integer ApprovalPathGroup { get; set; }

  @AuraEnabled
  public String ContactEmail { get; set; }

  @AuraEnabled
  public String UserId { get; set; }
}