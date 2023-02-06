/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 02-03-2023
 * @last modified by  : Bekhzod Ubaydullaev
 **/
import { LightningElement, api, track } from "lwc";
import pdfJs from "@salesforce/resourceUrl/pdfjs";
import { translations } from "c/utils";

export default class CustomPdfViewerVF extends LightningElement {
  labels = translations;

  @api pdfUrl;

  fullscreenView = false;

  docUrl;

  @track hasRendered = true;

  renderedCallback() {
    if (this.hasRendered && this.pdfUrl) {
      this.docUrl = pdfJs + "/web/viewer.html?file=" + this.pdfUrl;
      this.hasRendered = false;
    }
  }

  expandedViewToogle() {
    this.fullscreenView = !this.fullscreenView;
    if (this.fullscreenView === true) {
      document.body.style.overflow = "hidden";
    } else {
      document.body.style.overflow = "auto";
    }
  }
}