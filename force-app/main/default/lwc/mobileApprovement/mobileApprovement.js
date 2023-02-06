/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 12-12-2022
 * @last modified by  : https://github.com/Eldor901
 **/
import approverAction from "@salesforce/apex/ApprovalProcessPathController.approverAction";
import { successToast, translations } from "c/utils";
import { updateRecord } from "lightning/uiRecordApi";
import { api, LightningElement } from "lwc";

export default class MobileApprovement extends LightningElement {
  @api recordId;

  approvement = null;

  get isApprove() {
    return this.approvement === "onApprove";
  }

  get isReject() {
    return this.approvement === "onReject";
  }

  async onApprove() {
    this.approvement = "onApprove";
  }

  async onReject() {
    this.approvement = "onReject";
  }

  async approvalPathAction(actionName, message, comment) {
    await approverAction({
      approvalProcessPathId: this.recordId,
      action: actionName,
      comment: comment ?? ""
    });

    this.dispatchEvent(successToast(message));
    await updateRecord({ fields: { Id: this.recordId } });

    this.approvement = null;
  }

  async onApproved(event) {
    await this.approvalPathAction(
      "Approved",
      translations.SUCC_APPROVE,
      event.detail
    );
  }

  async onRejected(event) {
    await this.approvalPathAction(
      "Rejected",
      translations.SUCC_REJECT,
      event.detail
    );
  }

  onCancel() {
    this.approvement = null;
  }
}