/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 02-04-2023
 * @last modified by  : Bekhzod Ubaydullaev
 **/
import { LightningElement, api } from "lwc";
export default class ViewApprovalProcessVF extends LightningElement {
  show = false;
  found = true;
  @api uid;
  result = {};
  pdfUrl;

  loadReportContent() {
    fetch("/approve/services/apexrest/ApprovalProcessInfo/?uid=" + this.uid, {
      method: "GET",
      headers: {
        "Content-Type": "application/json"
      },
      mode: "cors"
    }).then(async (response) => {
      if (response.status === 404) {
        this.found = false;
      }
      this.result = await response.json();

      if (!this.pdfUrl || this.pdfUrl !== this.result.pdf_url + this.uid) {
        this.pdfUrl = this.result.pdf_url + this.uid;
      }
      this.show = this.result.show_approve_buttons;

      if (this.result.success === "false") {
        throw new Error("e");
      }
    });
  }

  connectedCallback() {
    this.loadReportContent();
  }

  handleRefresh() {
    this.loadReportContent();
  }
}