/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 01-23-2023
 * @last modified by  : https://github.com/Eldor901
 **/
import { LightningElement, api } from "lwc";
import userId from "@salesforce/user/Id";
import PromptModal from "c/promptModal";
import { updateApprovalProcess } from "c/utils";
import { NavigationMixin } from "lightning/navigation";

export default class ApprovalProcessRow extends NavigationMixin(
  LightningElement
) {
  @api row;

  async onHandleCancel() {
    const isApproved = await PromptModal.open({
      size: "small",
      content: "Are you cancelling this request?"
    });

    if (isApproved) {
      await updateApprovalProcess(this.row.Id, "Cancelled");
      this.dispatchEvent(new CustomEvent("refresh"));
    }
  }

  onReportClick(event) {
    const id = event.currentTarget.dataset.id;

    this[NavigationMixin.Navigate]({
      type: "standard__recordPage",
      attributes: {
        recordId: id,
        actionName: "view"
      }
    });
  }

  get showCancelButton() {
    const hidden = this.row?.Approval_Process_Path__r?.some(
      (el) =>
        el.ApprovalStatus__c === "Approved" ||
        el.ApprovalStatus__c === "Rejected"
    );

    return (
      this.row.ApprovalStatus__c === "Created" ||
      (this.row.ApprovalStatus__c === "In Progress" &&
        this.row.OwnerId === userId &&
        !hidden)
    );
  }
}