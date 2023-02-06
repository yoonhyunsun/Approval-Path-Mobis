/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 11-16-2022
 * @last modified by  : https://github.com/Eldor901
 **/
import LightningModal from "lightning/modal";
import { api } from "lwc";
import { translations } from "c/utils";

export default class ChangeApproverModal extends LightningModal {
  labels = translations;
  loader = false;

  @api recordId;

  async onCancel() {
    this.close("cancel");
  }

  async onSubmitSuccess() {
    this.close("cancel");
    this.loader = false;
  }

  async onSave() {
    try {
      this.loader = true;

      await this.template.querySelector("c-contact-searcher").handleEditSave();
    } catch (e) {
      this.loader = false;
    }
  }
}