/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 12-07-2022
 * @last modified by  : Bekhzod Ubaydullaev
 **/
import APPROVAL_STATUS from "@salesforce/schema/ApprovalProcessPath__c.ApprovalStatus__c";
import APPROVAL_ID from "@salesforce/schema/ApprovalProcessPath__c.ApprovalUser__c";
import APPROVAL_PROCESS_STATUS from "@salesforce/schema/ApprovalProcessPath__c.ApprovalProcess__r.ApprovalStatus__c";
import Id from "@salesforce/user/Id";
import { editorFromats, successToast, translations } from "c/utils";
import { CloseActionScreenEvent } from "lightning/actions";
import { getFieldValue, getRecord, updateRecord } from "lightning/uiRecordApi";
import { api, LightningElement, wire } from "lwc";

import approverAction from "@salesforce/apex/ApprovalProcessPathController.approverAction";

export default class RejectApprovalProcessPathQuickAction extends LightningElement {
  @api recordId;

  formats = editorFromats;
  comment = "";
  errorText = null;
  loader = true;

  @wire(getRecord, {
    recordId: "$recordId",
    fields: [APPROVAL_ID, APPROVAL_STATUS, APPROVAL_PROCESS_STATUS]
  })
  approvalProcessPath;

  get aprovalProcessPathApprovalId() {
    return getFieldValue(this.approvalProcessPath.data, APPROVAL_ID);
  }

  get approvalStatus() {
    return getFieldValue(this.approvalProcessPath.data, APPROVAL_STATUS);
  }

  get approvalProcessStatus() {
    return getFieldValue(
      this.approvalProcessPath.data,
      APPROVAL_PROCESS_STATUS
    );
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

  handleRichTextChange(e) {
    this.comment = e.target.value;
  }

  connectedCallback() {
    // eslint-disable-next-line @lwc/lwc/no-async-operation
    setTimeout(() => {
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

      this.loader = false;
    }, 500);
  }

  async onSave() {
    if (this.isApprover) {
      await approverAction({
        approvalProcessPathId: this.recordId,
        action: "Rejected",
        comment: this.comment
      });

      this.dispatchEvent(successToast("You have successfully rejected"));
      updateRecord({ fields: { Id: this.recordId } });

      this.dispatchEvent(new CloseActionScreenEvent());
    }
  }

  onCancel() {
    this.errorText = null;
    this.dispatchEvent(new CloseActionScreenEvent());
  }
}