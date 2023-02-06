/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 01-27-2023
 * @last modified by  : https://github.com/Eldor901
 **/
import { api } from "lwc";
import LightningModal from "lightning/modal";
import { translations } from "c/utils";

export default class PdfViewerModal extends LightningModal {
  @api url;
  labels = translations;

  get fitUrl() {
    return this.url + "#view=FitH";
  }
}