/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 01-09-2023
 * @last modified by  : https://github.com/Eldor901
 **/
import { api, LightningElement, wire } from "lwc";
import getPicklists from "@salesforce/apex/ApprovalProcessPathController.getPicklists";

export default class SelectedContactsTableRow extends LightningElement {
  @api selectedContacts;
  @api row;

  @api selectedContactId;

  @wire(getPicklists)
  picklists({ data }) {
    if (data) {
      const newApprovalTypes = [...data.approvalTypes];
      newApprovalTypes.shift();

      this.approvalTypes = newApprovalTypes;
    }
  }

  get selectedContact() {
    return this.row;
  }

  get rowStyles() {
    if (this.row.disabled) return `slds-hint-parent disabledRow row`;

    return "slds-hint-parent move row";
  }

  onDragStart(e) {
    const onDragstart = new CustomEvent("dragstart", {
      detail: e.currentTarget.dataset.id
    });
    this.dispatchEvent(onDragstart);
  }

  onDragOver(e) {
    e.preventDefault();
    const onDragOver = new CustomEvent("dragover", {
      detail: e.currentTarget.dataset.id
    });
    this.dispatchEvent(onDragOver);
  }

  onUserDelete(event) {
    const userId = event.currentTarget.dataset.id;

    const userEvet = new CustomEvent("userdelete", {
      detail: userId
    });

    this.dispatchEvent(userEvet);
  }

  handleApprovalTypeChange(event) {
    const userId = event.currentTarget.dataset.id;

    const userEvet = new CustomEvent("approvaltypeselect", {
      detail: {
        value: event.detail.value,
        userId
      }
    });

    this.dispatchEvent(userEvet);
  }
}