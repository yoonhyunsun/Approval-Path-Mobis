/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 09-26-2022
 * @last modified by  : https://github.com/Eldor901
 **/
import { LightningElement, track, wire, api } from "lwc";
import { CloseActionScreenEvent } from "lightning/actions";
import getContacts from "@salesforce/apex/ContactController.getContacts";
import LightningPrompt from "lightning/prompt";
import getPicklists from "@salesforce/apex/ApprovalProcessPathController.getPicklists";
import createFavoriteApporvalPath from "@salesforce/apex/ApprovalProcessPathController.createFavoriteApporvalPath";
import { proxyToObj, successToast, errorToast } from "c/utils";
import getFavoriteApprovalPathItems from "@salesforce/apex/ApprovalProcessPathController.getFavoriteApprovalPathItems";
import createApprovalProcessPathes from "@salesforce/apex/ApprovalProcessPathController.createApprovalProcessPathes";
import { updateOpportunity } from "c/utils";
import { enumerate } from "c/utils";

export default class ContactSearcherQuickAction extends LightningElement {
  @api recordId;
  name = "";
  department = "";
  @track selectedContacts = [];

  onNameChange({ target: { value } }) {
    this.name = value;
  }

  onDepartmentChange({ target: { value } }) {
    this.department = value;
  }

  @wire(getContacts, { name: "$name", department: "$department" })
  contacts;

  @wire(getPicklists)
  approvalProcessPathPickLists;

  onContactTableClick(event) {
    const user = event.detail;
    if (!this.selectedContacts.find((el) => el.Id === user.Id))
      this.selectedContacts.push({
        ...user,
        ApprovalType:
        this.approvalProcessPathPickLists.data.approvalTypes[1].value
      });
  }

  async onFavoriteGroupSelect(event) {
    const groupId = event.detail;

    const response = await getFavoriteApprovalPathItems({ groupId });
    this.selectedContacts = response.map(
      ({ Approval_Type__c, Contact__r }) => ({
        ApprovalType: Approval_Type__c,
        ...Contact__r
      })
    );
  }

  onSelectedContactDelete(event) {
    const filteredContact = this.selectedContacts.filter(
      (el) => el.Id !== event.detail
    );

    this.selectedContacts = [...filteredContact];
  }

  onSelectedContactsDelete() {
    this.selectedContacts = [];
  }

  approvalTypeSelect(event) {
    const idx = this.selectedContacts.findIndex(
      (el) => el.Id === event.detail.userId
    );
    this.selectedContacts[idx].ApprovalType = event.detail.value;
  }

  async onSave() {
    try {
      await createApprovalProcessPathes({
        OpportunityId: this.recordId,
        approvalProcessPathes: enumerate([...proxyToObj(this.selectedContacts)])
      });

      await updateOpportunity(this.recordId, "Path Selected");

      this.dispatchEvent(new CloseActionScreenEvent());
    } catch (e) {
      this.dispatchEvent(errorToast(e.body.message));
    }
  }

  onSaveFavorite() {
    LightningPrompt.open({
      message: "Name",
      label: "Save approval path as favorite!", // this is the header text
      defaultValue: ""
    }).then(async (name) => {
      if (name === null) return;

      if (name.trim() === "") {
        this.dispatchEvent(
          errorToast("Record not saved. Name should be unique")
        );

        return;
      }

      try {
        await createFavoriteApporvalPath({
          name,
          OpportunityId: this.recordId,
          favoriteApprovalProcessPathes: [...proxyToObj(this.selectedContacts)]
        });

        this.dispatchEvent(successToast());
      } catch (e) {
        this.dispatchEvent(errorToast(e.body.message));
      }
    });
  }

  async onCancel() {
    this.dispatchEvent(new CloseActionScreenEvent());
  }
}