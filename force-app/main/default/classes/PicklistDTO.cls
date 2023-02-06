/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 09-15-2022
 * @last modified by  : https://github.com/Eldor901
 **/
public class PicklistDTO {
  @AuraEnabled
  public String label { get; set; }
  @AuraEnabled
  public String value { get; set; }
}