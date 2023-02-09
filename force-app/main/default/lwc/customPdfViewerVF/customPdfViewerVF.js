/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 02-06-2023
 * @last modified by  : Chaewon Kwak
 **/
import { LightningElement, api, track } from "lwc";
import pdfJs from "@salesforce/resourceUrl/pdfjs";
import expandedPdf from "@salesforce/resourceUrl/expandedPdf";
import { translations } from "c/utils";

export default class CustomPdfViewerVF extends LightningElement {
  labels = translations;

  @api pdfUrl;

  fullscreenView = false;

  docUrl;

  expandedDocUrl;

  @track hasRendered = true;

  renderedCallback() {
    if (this.hasRendered && this.pdfUrl) {
      this.docUrl = pdfJs + "/web/viewer.html?file=" + this.pdfUrl;
      this.expandedDocUrl =
        expandedPdf + "/web/viewer.html?file=" + this.pdfUrl;

      this.hasRendered = false;
    }
  }

  expandedViewToogle() {
    this.fullscreenView = !this.fullscreenView;
    console.log(this.fullscreenView);
    if (this.fullscreenView === true) {
      document.body.style.overflow = "hidden";
    } else {
      document.body.style.overflow = "auto";
    }
  }
}