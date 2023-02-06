/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 02-02-2023
 * @last modified by  : https://github.com/Eldor901
 **/
import createApprovalProcessPathes from "@salesforce/apex/ApprovalProcessPathController.createApprovalProcessPathes";
import createFavoriteApporvalPath from "@salesforce/apex/ApprovalProcessPathController.createFavoriteApporvalPath";
import editApprovalProcessPaths from "@salesforce/apex/ApprovalProcessPathController.editApprovalProcessPaths";
import getFavoriteApprovalPathGroup from "@salesforce/apex/ApprovalProcessPathController.getFavoriteApprovalPathGroup";
import getFavoriteApprovalPathItems from "@salesforce/apex/ApprovalProcessPathController.getFavoriteApprovalPathItems";
import getPicklists from "@salesforce/apex/ApprovalProcessPathController.getPicklists";
import getApprovalProcessSubmittedContacts from "@salesforce/apex/ContactController.getApprovalProcessSubmittedContacts";
import getContacts from "@salesforce/apex/ContactController.getContacts";
import getDefaultPaths from "@salesforce/apex/ContactController.getDefaultPaths";
import PromptModal from "c/promptModal";
import {
  enumerate,
  errorToast,
  proxyToObj,
  submitForApproval,
  successToast,
  translations,
  updateOpportunity,
  editorFromats
} from "c/utils";
import { api, LightningElement, track, wire } from "lwc";
import { detectChangedContacts } from "./detectChangedContacts";
import { filterSubmittedContactsByGroup } from "./filterSubmittedContactsByGroup";
import { refreshApex } from "@salesforce/apex";

export default class ContactSearcherQuickAction extends LightningElement {
  @api recordId;
  //create|edit
  @api type;

  labels = translations;
  formats = editorFromats;

  name = "";
  department = "";
  loading = false;
  comment = "";

  @track contacts;

  @track selectedContacts = [];

  @track submitter = [];

  //not modified contacts by user
  @track submittedContacts = [];

  onNameChange({ target: { value } }) {
    this.name = value;
  }

  onDepartmentChange({ target: { value } }) {
    this.department = value;
  }

  @wire(getFavoriteApprovalPathGroup)
  favoriteGroups;

  @wire(getPicklists)
  approvalProcessPathPickLists;

  get favoriteGroupOptions() {
    return this.favoriteGroups.data
      ? this.favoriteGroups.data.map((el) => ({
          label: el.Name__c,
          value: el.Id
        }))
      : [];
  }

  handleRichTextChange({ target: { value } }) {
    this.comment = value;
  }

  async connectedCallback() {
    if (this.type === "edit") {
      const submittedContacts = await getApprovalProcessSubmittedContacts({
        opportunityId: this.recordId
      });

      const submitter = submittedContacts.shift();
      this.comment = submitter.Comment__c;
      this.submitter = submitter;

      const mappedSubmittedContacts = filterSubmittedContactsByGroup(
        submittedContacts
      ).map((el) => {
        return {
          Id: el.Employee__r.Id,
          ApprovalType: el.ApprovalType__c,
          PositionName__c: el.Employee__r?.PositionName__c,
          DepartmentName: el.Employee__r?.EmpDepartment__r?.Name,
          ContactEmail: el.Employee__r?.Email,
          Name: el.Employee__r.Name,
          ApprovalPathId: el.Id,
          ApprovalPathGroup: el.NotifiedGroup__c,
          ApprovalGroup: el.ApprovalProcess__r.CurrentGroupNumber__c,
          disabled: el.disabled ?? false,
          GroupNumber: el.GroupNumber,
          UserId: el.Employee__r.UserId__c
        };
      });

      this.selectedContacts = [...proxyToObj(mappedSubmittedContacts)];
      this.submittedContacts = [...proxyToObj(mappedSubmittedContacts)];

      return;
    }

    if (this.selectedContacts.length !== 0) return;

    const data = await getDefaultPaths({ opportunityId: this.recordId });

    const newContacts = await data.map((el) => {
      return {
        ...el,
        ApprovalType: el.ApprovalType,
        PositionName__c: el.Position,
        DepartmentName: el.Department
      };
    });

    this.selectedContacts = [...newContacts];
  }

  async handleSearch() {
    try {
      this.loading = true;
      this.contacts = await getContacts({
        name: this.name,
        department: this.department
      });
      this.loading = false;
    } catch (e) {
      console.log(e);
    }
  }

  handleEnter(e) {
    if (e.keyCode === 13) this.handleSearch();
  }

  onContactTableClick(event) {
    const user = event.detail;
    if (!this.selectedContacts.find((el) => el.Id === user.Id)) {
      console.log(user?.UserId__c);

      this.selectedContacts.push({
        ...user,
        UserId: user?.UserId__c,
        ContactEmail: user?.Email,
        DepartmentName: user.EmpDepartment__r.Name,
        ApprovalType:
          this.approvalProcessPathPickLists.data.approvalTypes[3].value
      });
    }
  }

  async onFavoriteGroupSelect(event) {
    const groupId = event.detail.value;
    const response = await getFavoriteApprovalPathItems({ groupId });

    this.selectedContacts = [
      ...response.map(({ Approval_Type__c, Contact__r }) => ({
        ApprovalType: Approval_Type__c,
        DepartmentName: Contact__r.EmpDepartment__r?.Name,
        ...Contact__r
      }))
    ];
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

  @api async handleSave() {
    await this.onSave();

    return true;
  }

  @api async handleEditSave() {
    const contacts = detectChangedContacts(
      proxyToObj(this.selectedContacts),
      proxyToObj(this.submittedContacts)
    );

    try {
      await editApprovalProcessPaths({
        OpportunityId: this.recordId,
        Comment: this.comment,
        approvalProcessPaths: enumerate([
          ...contacts.map(
            ({
              DepartmentName,
              PositionName__c,
              isChanged,
              disabled,
              ...rest
            }) => ({
              Department: DepartmentName,
              Position: PositionName__c,
              IsChanged: isChanged,
              Approved: disabled,

              ...rest
            })
          )
        ])
      });

      const selectedEvent = new CustomEvent("submitsuccess");
      this.dispatchEvent(selectedEvent);
    } catch (e) {
      this.dispatchEvent(errorToast(e.body.message));
      throw e.body.message;
    }
  }

  async onSave() {
    try {
      await createApprovalProcessPathes({
        OpportunityId: this.recordId,
        Comment: this.comment,
        approvalProcessPathes: enumerate([...proxyToObj(this.selectedContacts)])
      });
      await updateOpportunity(this.recordId, "Path Selected");
      const selectedEvent = new CustomEvent("submitsuccess");
      this.dispatchEvent(selectedEvent);
      return true;
    } catch (e) {
      this.dispatchEvent(errorToast(e.body.message));
      throw e.body.message;
    }
  }

  @api async handleSubmitForApproval() {
    await submitForApproval(this);
  }

  @api handleSaveFavorite() {
    return this.template.querySelectorAll("lightning-button")[0].click();
  }

  async onSaveFavorite() {
    const name = await PromptModal.open({
      size: "small",
      title: "Save approval path as favorite!"
    });

    if (name === undefined) return;

    console.log(name);

    if (name?.length === 0) {
      this.dispatchEvent(errorToast("Value is empty"));
      return;
    }

    try {
      await createFavoriteApporvalPath({
        name,
        OpportunityId: this.recordId,
        favoriteApprovalProcessPathes: [...proxyToObj(this.selectedContacts)]
      });
      this.dispatchEvent(successToast());

      refreshApex(this.favoriteGroups);
    } catch (e) {
      this.dispatchEvent(errorToast(e.body.message));
    }
  }

  onSwap(event) {
    this.selectedContacts = [...event.detail.selectedContacts];
  }
}