/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 01-27-2023
 * @last modified by  : https://github.com/Eldor901
 **/
import { LightningElement, api } from "lwc";
import PdfViewerModal from "c/pdfViewerModal";
import { translations } from "c/utils";

export default class PdfViewer extends LightningElement {
  @api url;

  @api showmodal = false;
  @api showmodalvf = false;

  labels = translations;

  async openInNewModal() {
    await PdfViewerModal.open({
      size: "large",
      url: this.url
    });
  }

  openModal = false;
  openInNewModalVF() {
    this.openModal = true;
  }
  handleCloseModal() {
    this.openModal = false;
  }

  get urlWithoutToolbar() {
    return this.url + "#toolbar=0";
  }

  get vfpdfUrl() {
    return this.url + "#view=FitH";
  }
}