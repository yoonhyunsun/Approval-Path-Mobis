/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 12-06-2022
 * @last modified by  : https://github.com/Eldor901
 **/
import { api, LightningElement, wire } from "lwc";
import APPROVAL_STATUS from "@salesforce/schema/ApprovalProcessPath__c.ApprovalStatus__c";
import APPROVAL_ID from "@salesforce/schema/ApprovalProcessPath__c.ApprovalUser__c";
import Id from "@salesforce/user/Id";
import { editorFromats } from "c/utils";
import { getFieldValue, getRecord, updateRecord } from "lightning/uiRecordApi";
import { translations } from "c/utils";

export default class RichTextModal extends LightningElement {
  formats = editorFromats;
  comment = "";
  errorText = null;
  loader = true;
  labels = translations;
  @api recordId;

  @wire(getRecord, {
    recordId: "$recordId",
    fields: [APPROVAL_ID, APPROVAL_STATUS]
  })
  approvalProcessPath;

  get aprovalProcessPathApprovalId() {
    return getFieldValue(this.approvalProcessPath?.data, APPROVAL_ID);
  }

  get isApprover() {
    return Id === this.aprovalProcessPathApprovalId;
  }

  get isErrorText() {
    return this.errorText !== null;
  }

  get getSaveOkText() {
    return this.errorText
      ? translations.COM_BTN_OK
      : translations.COM_BTN_CANCEL;
  }

  get showEditor() {
    return !this.isErrorText && !this.loader;
  }

  get approvalStatus() {
    return getFieldValue(this.approvalProcessPath?.data, APPROVAL_STATUS);
  }

  handleRichTextChange(e) {
    this.text = e.target.value;
  }

  connectedCallback() {
    // eslint-disable-next-line @lwc/lwc/no-async-operation
    setTimeout(() => {
      if (!this.isApprover) {
        this.errorText = translations.ERR_PROCESSED_APPROVAL;
      }

      if (
        this.approvalStatus === "Rejected" ||
        this.approvalStatus === "Approved"
      ) {
        this.errorText = translations.ERR_NOT_APPROVER;
      }

      if (this.approvalStatus === "Not Sent") {
        this.errorText = translations.ERR_CANT_APPROVE_YET;
      }

      updateRecord({ fields: { Id: this.recordId } });

      this.loader = false;
    }, 1000);
  }

  onCancel() {
    if (this.isApprover) this.dispatchEvent(new CustomEvent("cancel"));
  }

  onSave() {
    if (this.isApprover)
      this.dispatchEvent(
        new CustomEvent("save", {
          detail: this.text
        })
      );
  }
}