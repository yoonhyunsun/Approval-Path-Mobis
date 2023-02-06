import { LightningElement, api, wire } from "lwc";
import { subscribe, unsubscribe } from "lightning/empApi";
import { getRecord } from "lightning/uiRecordApi";
import ID_FIELD from "@salesforce/schema/Opportunity.Id";
import QUICK_ACTION_STAGE from "@salesforce/schema/Opportunity.Quick_Action_Stage__c";

import { proxyToObj, updateOpportunity } from "c/utils";

const fields = [ID_FIELD, QUICK_ACTION_STAGE];

export default class OpportunityEventListener extends LightningElement {
  @api recordId;

  channelName = "/event/Approval_Process__e";
  subscription = null;

  @wire(getRecord, { recordId: "$recordId", fields })
  opportunity;

  async connectedCallback() {
    await this.handleSubscribe();
  }

  disconnectedCallback() {
    this.handleUnsubscribe();
  }

  async handleSubscribe() {
    const logicCallback = async (response) => {
      let data = proxyToObj(response).data;
      if (this.recordId === data.payload.opptyId__c) {
        await updateOpportunity(data.payload.opptyId__c, "Draft");
      }
    };
    this.subscription = await subscribe(this.channelName, -1, logicCallback);
  }

  handleUnsubscribe() {
    unsubscribe(this.subscription, (response) => {
      console.log("Unsubscribe: ", JSON.stringify(response));
    });
  }
}