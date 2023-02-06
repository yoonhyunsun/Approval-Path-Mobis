/**
 * @description       :
 * @author            : Bekhzod Ubaydullaev
 * @group             :
 * @last modified on  : 09-20-2022
 * @last modified by  : https://github.com/Eldor901
 **/
public class QuipDTO {
  @AuraEnabled
  public String requestId { get; set; }

  @AuraEnabled
  public String lastUpdated { get; set; }

  @AuraEnabled
  public String threadId { get; set; }

  @AuraEnabled
  public String exportPdfStatus { get; set; }
  @AuraEnabled
  public String error { get; set; }
  @AuraEnabled
  public String quipPdfUrl { get; set; }
}