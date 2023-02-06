/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 01-30-2023
 * @last modified by  : https://github.com/Eldor901
 **/
import { LightningElement, api, track } from "lwc";
import { enumerate, proxyToObj, translations } from "c/utils";
import getSubmitter from "@salesforce/apex/ContactController.getSubmitter";

export default class SelectedContactsTable extends LightningElement {
  @api selectedContacts;

  @api type;

  @api createdsubmitter;

  selectedContactId;

  hoverEffect = "";

  labels = translations;

  @track submitterInfo;

  async connectedCallback() {
    this.submitterInfo = await getSubmitter();
  }

  get submitter() {
    if (this.type === "edit") {
      return this.createdsubmitter.Employee__r;
    }

    return this.submitterInfo;
  }



  handleChange(event) {
    this.value = event.detail.value;
  }

  get favoriteGroupOptions() {
    return this.favoriteGroups.data
      ? this.favoriteGroups.data.map((el) => ({
          label: el.Name__c,
          value: el.Id
        }))
      : [];
  }

  get isSelectedContact() {
    return this.selectedContacts.length > 0;
  }

  get allSelectedContacts() {
    const selectedContacts = proxyToObj(this.selectedContacts);

    return enumerate(
      selectedContacts.map((el) => ({
        ...el
      }))
    );
  }

  onUserDelete(event) {
    const userEvet = new CustomEvent("userdelete", {
      detail: event.detail
    });

    this.dispatchEvent(userEvet);
  }

  handleApprovalTypeChange(event) {
    const userEvet = new CustomEvent("approvaltypeselect", {
      detail: {
        value: event.detail.value,
        userId: event.detail.userId
      }
    });

    this.dispatchEvent(userEvet);
  }

  onDeleteSelectedElements() {
    const userEvet = new CustomEvent("deleteselected", {
      detail: {}
    });

    this.dispatchEvent(userEvet);
  }

  onDragOver(e) {
    const selectedContacts = proxyToObj(this.selectedContacts);

    const selectedElementIdx = selectedContacts.findIndex(
      (el) => el.Id === this.selectedContactId
    );
    const droppedElementIdx = selectedContacts.findIndex(
      (el) => el.Id === e.detail
    );

    if (selectedElementIdx === -1 || droppedElementIdx === -1) return;

    [
      selectedContacts[selectedElementIdx],
      selectedContacts[droppedElementIdx]
    ] = [
      selectedContacts[droppedElementIdx],
      selectedContacts[selectedElementIdx]
    ];

    const swapElements = new CustomEvent("swap", {
      detail: {
        selectedContacts: selectedContacts
      }
    });
    this.dispatchEvent(swapElements);
  }

  onDragStart(e) {
    this.selectedContactId = e.currentTarget.dataset.id;
  }
}