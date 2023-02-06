/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 09-15-2022
 * @last modified by  : https://github.com/Eldor901
 **/
public class FavoriteApprovalProcessPath {
  @AuraEnabled
  public String Id { get; set; }
  @AuraEnabled
  public String Name { get; set; }
  @AuraEnabled
  public String Department { get; set; }
  @AuraEnabled
  public String ApprovalType { get; set; }
  @AuraEnabled
  public String ApprovalStage { get; set; }
  @AuraEnabled
  public String ReportType { get; set; }
}