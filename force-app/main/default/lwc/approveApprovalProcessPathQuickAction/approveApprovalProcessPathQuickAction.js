/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 02-06-2023
 * @last modified by  : Bekhzod Ubaydullaev
 **/
import approverAction from "@salesforce/apex/ApprovalProcessPathController.approverAction";
import APPROVAL_STATUS from "@salesforce/schema/ApprovalProcessPath__c.ApprovalStatus__c";
import APPROVAL_ID from "@salesforce/schema/ApprovalProcessPath__c.ApprovalUser__c";
import APPROVAL_PROCESS_STATUS from "@salesforce/schema/ApprovalProcessPath__c.ApprovalProcess__r.ApprovalStatus__c";
import Id from "@salesforce/user/Id";
import { editorFromats, successToast, translations } from "c/utils";
import { CloseActionScreenEvent } from "lightning/actions";
import { getFieldValue, getRecord, updateRecord } from "lightning/uiRecordApi";
import { api, LightningElement, wire } from "lwc";

export default class ApproveApprovalProcessPathQuickAction extends LightningElement {
  @api recordId;

  formats = editorFromats;
  comment = "";
  errorText = null;
  loader = true;

  pathData;

  @wire(getRecord, {
    recordId: "$recordId",
    fields: [APPROVAL_ID, APPROVAL_STATUS, APPROVAL_PROCESS_STATUS]
  })
  approvalProcessPath(result) {
    if (result.data) {
      this.pathData = result;
      if (!this.isApprover) {
        this.errorText = translations.ERR_NOT_APPROVER;
      }

      if (
        this.approvalStatus === "Rejected" ||
        this.approvalStatus === "Approved"
      ) {
        this.errorText = translations.ERR_PROCESSED_APPROVAL;
      }

      if (this.approvalStatus === "Not Sent") {
        this.errorText = translations.ERR_CANT_APPROVE_YET;
      }

      if (this.approvalProcessStatus === "Cancelled") {
        this.errorText = translations.ERR_APPROVAL_CANCELLED;
      }

      updateRecord({ fields: { Id: this.recordId } });
    } else if (result.error) {
      this.errorText = "Error with loading the data. Please try again";
    }
    this.loader = false;
  }

  get aprovalProcessPathApprovalId() {
    return getFieldValue(this.pathData.data, APPROVAL_ID);
  }

  get approvalProcessStatus() {
    return getFieldValue(this.pathData.data, APPROVAL_PROCESS_STATUS);
  }

  get isApprover() {
    return Id === this.aprovalProcessPathApprovalId;
  }

  get isErrorText() {
    return this.errorText !== null;
  }

  get showEditor() {
    return !this.isErrorText && !this.loader;
  }

  get approvalStatus() {
    return getFieldValue(this.pathData.data, APPROVAL_STATUS);
  }

  handleRichTextChange(e) {
    this.comment = e.target.value;
  }

  connectedCallback() {
    this.loader = true;
  }

  async onSave() {
    if (this.isApprover) {
      await approverAction({
        approvalProcessPathId: this.recordId,
        action: "Approved",
        comment: this.comment
      });

      this.dispatchEvent(successToast(translations.SUCC_APPROVE));

      updateRecord({ fields: { Id: this.recordId } });

      this.dispatchEvent(new CloseActionScreenEvent());
    }
  }

  onCancel() {
    this.errorText = null;
    this.dispatchEvent(new CloseActionScreenEvent());
  }
}