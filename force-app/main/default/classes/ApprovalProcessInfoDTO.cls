public class ApprovalProcessInfoDTO {

    String processName;
    String ownerId;
    String description;
    String opportunityName;
    String reportType;
    String pdfUrl;

    public ApprovalProcessInfoDTO() {}

    public ApprovalProcessInfoDTO(String processName, String ownerId, String description, String opportunityName, String reportType, String pdfUrl) {
        this.processName = processName;
        this.ownerId = ownerId;
        this.description = description;
        this.opportunityName = opportunityName;
        this.reportType = reportType;
        this.pdfUrl = pdfUrl;
    }
}