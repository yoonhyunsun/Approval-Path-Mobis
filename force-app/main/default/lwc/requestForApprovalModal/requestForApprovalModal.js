/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 12-02-2022
 * @last modified by  : https://github.com/Eldor901
 **/
import getReportTypeAndQuipUrl from "@salesforce/apex/QuipController.getReportTypeAndQuipUrl";
import QUICK_ACTION_STAGE from "@salesforce/schema/Opportunity.Quick_Action_Stage__c";
import STAGE_NAME from "@salesforce/schema/Opportunity.StageName";
import { updateOpportunity, translations } from "c/utils";
import LightningModal from "lightning/modal";
import { getFieldValue, getRecord } from "lightning/uiRecordApi";
import { api, wire } from "lwc";

const fields = [QUICK_ACTION_STAGE, STAGE_NAME];

export default class RequestForApprovalModal extends LightningModal {
  @api recordId;

  labels = translations;

  errorMessage = "";
  disableButton = false;

  selectedReportType;

  loader = false;

  checkcondition = false;
  negotiationStageSaved = false;

  reportData;

  @wire(getRecord, { recordId: "$recordId", fields })
  opportunityRecord;

  get OpportunityQuickAction() {
    return getFieldValue(this.opportunityRecord.data, QUICK_ACTION_STAGE);
  }

  get OpportunityStage() {
    return getFieldValue(this.opportunityRecord.data, STAGE_NAME);
  }

  get isStageNegotiation() {
    return (
      !this.negotiationStageSaved &&
      this.OpportunityStage === "Negotiation" &&
      this.OpportunityQuickAction === "Draft"
    );
  }

  get isFillApprovalProcessForm() {
    return this.OpportunityQuickAction === "Draft";
  }

  get isFillApprovalProcessPathForm() {
    return this.OpportunityQuickAction === "Process Created";
  }

  get header() {
    return this.isFillApprovalProcessForm
      ? translations.AP_REQUEST_REPORT
      : translations.AP_PROCESS_PATH;
  }

  async connectedCallback() {
    // this.recordId undefined in connectedCallback needs to wait for component load
    // eslint-disable-next-line @lwc/lwc/no-async-operation
    setTimeout(async () => {
      const reportData = await getReportTypeAndQuipUrl({
        opportunityId: this.recordId,
        reportType: null
      });
      this.reportData = reportData;
    }, 1000);
  }

  onReportTypeSelect(event) {
    this.selectedReportType = event.detail;
  }

  async onNegotiationReportChange(event) {
    if (typeof event.detail != "string") return;

    const reportData = await getReportTypeAndQuipUrl({
      opportunityId: this.recordId,
      reportType: event.detail
    });

    this.reportData = reportData;
  }

  async onSave() {
    this.loader = true;

    try {
      if (this.isFillApprovalProcessPathForm) {
        await this.template.querySelector("c-contact-searcher").handleSave();
      }

      if (this.isFillApprovalProcessForm && !this.isStageNegotiation) {
        await this.template
          .querySelector("c-approval-process-form")
          .handleSubmit();
        await updateOpportunity(this.recordId, "Process Created");
        this.loader = false;
      }

      if (this.isStageNegotiation && !this.negotiationStageSaved) {
        this.negotiationStageSaved = true;
      }
    } catch (e) {
      this.loader = false;
    }
  }

  async onSaveFavorite() {
    this.template.querySelector("c-contact-searcher").handleSaveFavorite();
  }

  async onSubmitForApproval() {
    try {
      this.loader = true;
      await this.template
        .querySelector("c-contact-searcher")
        .handleSubmitForApproval();
    } catch (e) {
      this.loader = false;
    }
  }

  async onProcess({ detail }) {
    if (detail?.error) {
      this.errorMessage = detail.message;
      this.disableButton = true;
    }

    if (!detail?.loading) {
      this.loader = false;
    }
  }

  async onCancel() {
    this.close("cancel");
  }

  async onSubmitSuccess() {
    this.close("submit");
    this.loader = false;
  }
}