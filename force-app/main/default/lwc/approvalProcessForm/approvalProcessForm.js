/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 02-03-2023
 * @last modified by  : Bekhzod Ubaydullaev
 **/
import { LightningElement, api, wire, track } from "lwc";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import getMobisApprovalCustomSettings from "@salesforce/apex/GetCustomSettingsLWC.getMobisApprovalCustomSettings";
import OPPORTUNITY_ID_FIELD from "@salesforce/schema/Opportunity.Id";
import OPP_ACC_FIELD from "@salesforce/schema/Opportunity.Account.Name";
import VIHICLE_FIELD from "@salesforce/schema/Opportunity.VehicleProject__r.Name";
import STAGE_NAME from "@salesforce/schema/Opportunity.StageName";
import LAST_DISTRIBUTION_ID from "@salesforce/schema/Opportunity.LastDistributionId__c";

import { translations } from "c/utils";
import { notifyProcessing } from "c/utils";
import { requestQuipPdf } from "c/utils";
import { refreshApex } from "@salesforce/apex";

const fields = [
  LAST_DISTRIBUTION_ID,
  OPPORTUNITY_ID_FIELD,
  OPP_ACC_FIELD,
  VIHICLE_FIELD,
  STAGE_NAME
];

export default class ApprovalProcessForm extends LightningElement {
  @api opportunityId;

  @api reportData;

  labels = translations;

  @track
  quipDocument = { error: null, url: null, isLoading: true };

  @wire(getMobisApprovalCustomSettings)
  approvalCustomSettings;

  _getRecordResponse;

  @wire(getRecord, { recordId: "$opportunityId", fields })
  opportunity(response) {
    this._getRecordResponse = response;
  }

  docUrl;

  @track hasConnected = true;

  async connectedCallback() {
    // recordId in opportunity avaliable only after some period
    notifyProcessing(this, {
      loading: false,
      message: this.labels.LOAD_QUIP_DOC
    });

    if (this.hasConnected) {
      // eslint-disable-next-line @lwc/lwc/no-async-operation
      setTimeout(async () => {
        const quip = await requestQuipPdf(
          this.opportunityId,
          this.reportData?.reportType ?? null
        );

        await refreshApex(this._getRecordResponse);

        console.log(quip.error);

        if (quip.error)
          notifyProcessing(this, {
            loading: false,
            error: true,
            message: quip.error
          });

        this.quipDocument = { ...quip, isLoading: false };
        notifyProcessing(this, { loading: false });

        this.docUrl =
          this.approvalCustomSettings.data.PublicSiteURL__c +
          "approve/services/apexrest/GetQuipPdf/?docId=" +
          getFieldValue(this._getRecordResponse.data, LAST_DISTRIBUTION_ID);
      }, 1000);
      this.hasConnected = false;
    }
  }

  get getAccountName() {
    return getFieldValue(this._getRecordResponse.data, OPP_ACC_FIELD);
  }

  get getDistributionId() {
    return getFieldValue(this._getRecordResponse.data, LAST_DISTRIBUTION_ID);
  }

  get OpportunityStage() {
    return getFieldValue(this._getRecordResponse.data, STAGE_NAME);
  }

  get Vehicle() {
    return getFieldValue(this._getRecordResponse.data, VIHICLE_FIELD);
  }

  get showFields() {
    return this.quipDocument.isLoading || this.quipDocument.error;
  }

  get ApprovalProcessName() {
    if (this._getRecordResponse.data) {
      const name =
        this.getAccountName +
        " " +
        this.Vehicle +
        " " +
        this.reportData?.reportType;

      return name;
    }

    return "";
  }

  @api async handleSubmit() {
    this.template.querySelector("lightning-record-edit-form").submit();
  }
}