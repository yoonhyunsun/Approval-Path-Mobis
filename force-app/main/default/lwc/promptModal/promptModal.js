/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 11-15-2022
 * @last modified by  : https://github.com/Eldor901
 **/
import { api } from "lwc";
import LightningModal from "lightning/modal";

export default class PromptModal extends LightningModal {
  @api content;
  @api title;

  text = undefined;

  get hasContent() {
    return this.content?.length > 0 ?? false;
  }

  onChange({ target: { value } }) {
    this.text = value;
  }

  handleSave() {
    if (this.hasContent) return this.close(true);

    return this.close(this.text);
  }

  handleCancel() {
    this.close(undefined);
  }
}