/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 11-15-2022
 * @last modified by  : https://github.com/Eldor901
 **/
import { LightningElement } from "lwc";
import { translations } from "c/utils";

export default class RichTextEditorModal extends LightningElement {
  comment = "";
  formats = [
    "font",
    "size",
    "bold",
    "italic",
    "underline",
    "list",
    "indent",
    "align",
    "link",
    "clean",
    "table",
    "header"
  ];

  lables = translations;

  onSave() {
    const event = new CustomEvent("save", {
      detail: { comment: this.comment }
    });

    this.dispatchEvent(event);
  }

  onCancel() {
    const event = new CustomEvent("cancel", {
      detail: { comment: this.comment }
    });

    this.dispatchEvent(event);
  }

  handleRichTextChange(e) {
    this.comment = e.detail.value;
  }
}