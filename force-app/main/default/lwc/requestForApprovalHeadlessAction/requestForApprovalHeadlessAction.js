/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 02-03-2023
 * @last modified by  : Bekhzod Ubaydullaev
 **/
// import PMS_CODE from "@salesforce/schema/Opportunity.PMSCode__c";
import S_CODE from "@salesforce/schema/Opportunity.Scode__c";
import STAGE_NAME from "@salesforce/schema/Opportunity.StageName";
import RequestForApprovalModal from "c/requestForApprovalModal";
import {
  errorToast,
  requestForApprovalErrorHandler,
  translations
} from "c/utils";
import { getFieldValue, getRecord } from "lightning/uiRecordApi";
import { api, LightningElement, wire } from "lwc";

const fields = [S_CODE, STAGE_NAME];

export default class ReportTypeQuickAction extends LightningElement {
  @api recordId;

  isExecuting = false;

  @wire(getRecord, { recordId: "$recordId", fields })
  opportunityRecord;

  get OpportunityStage() {
    return getFieldValue(this.opportunityRecord.data, STAGE_NAME);
  }
  get OpportunitySCode() {
    return getFieldValue(this.opportunityRecord.data, S_CODE);
  }

  // get OpportunityPMSCode() {
  //   return getFieldValue(this.opportunityRecord.data, PMS_CODE);
  // }

  @api async invoke() {
    if (this.isExecuting) {
      return;
    }

    this.isExecuting = true;

    //3000 wait untill quip save changes
    // eslint-disable-next-line @lwc/lwc/no-async-operation
    setTimeout(async () => {
      const hasError = await requestForApprovalErrorHandler(this);
      if (hasError) return;
      if (this.OpportunityStage === "RFQ Received" && !this.OpportunitySCode) {
        this.dispatchEvent(errorToast(translations.ERR_ENTER_S_CODE));
        return;
      }
      await RequestForApprovalModal.open({
        label: "Modal Header",
        recordId: this.recordId,
        size: "large"
      });

      this.isExecuting = false;
    }, 3000);
  }
}