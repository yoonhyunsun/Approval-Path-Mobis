/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 02-03-2023
 * @last modified by  : Chaewon Kwak
 **/
import { LightningElement, api, wire } from "lwc";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import APPROVAL_PROCESS_ID from "@salesforce/schema/ApprovalProcessPath__c.ApprovalProcess__c";
import OPPORTUNITY_LAST_PDF_URL from "@salesforce/schema/ApprovalProcessPath__c.ApprovalProcess__r.PdfURL__c";
import markRead from "@salesforce/apex/ApprovalProcessPathController.markRead";
import getMobisApprovalCustomSettings from "@salesforce/apex/GetCustomSettingsLWC.getMobisApprovalCustomSettings";
import APPROVAL_PROCESS_UID from "@salesforce/schema/ApprovalProcessPath__c.ApprovalProcessPathUID__c";

const FIELDS = [
  APPROVAL_PROCESS_UID,
  APPROVAL_PROCESS_ID,
  OPPORTUNITY_LAST_PDF_URL
];

export default class ViewApprovalProcess extends LightningElement {
  @api recordId;

  @wire(getRecord, { recordId: "$recordId", fields: FIELDS })
  approvalProcessPath;

  @wire(getMobisApprovalCustomSettings)
  approvalCustomSettings;

  docUrl;

  async connectedCallback() {
    await markRead({ approvalProcessPathId: this.recordId });
    // eslint-disable-next-line @lwc/lwc/no-async-operation
    setTimeout(async () => {
      this.docUrl =
        this.approvalCustomSettings.data.PublicSiteURL__c +
        "approve/services/apexrest/GetQuipPdf/?uid=" +
        getFieldValue(this.approvalProcessPath.data, APPROVAL_PROCESS_UID);
    }, 1000);
  }

  get approvalProcessId() {
    return getFieldValue(this.approvalProcessPath.data, APPROVAL_PROCESS_ID);
  }
}