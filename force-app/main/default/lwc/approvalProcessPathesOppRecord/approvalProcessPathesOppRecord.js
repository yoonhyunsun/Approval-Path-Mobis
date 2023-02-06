/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 09-29-2022
 * @last modified by  : https://github.com/Eldor901
 **/
import { LightningElement, wire, api, track } from "lwc";
import getApprovalProcessPathesOfOpportunity from "@salesforce/apex/ApprovalProcessPathController.getApprovalProcessPathesOfOpportunity";
import { enumerate } from "c/utils";
import { refreshApex } from "@salesforce/apex";

export default class ApprovalProcessPathesOppRecord extends LightningElement {
  @api recordId;

  @track data = null;

  _wireApprovalData;
  @wire(getApprovalProcessPathesOfOpportunity, { OpportunityId: "$recordId" })
  approvalPathes(data) {
    this._wireApprovalData = data;
    if (data.data) {
      this.data = enumerate(
        data.data.map(({ ApprovalProcess__r, ...rest }) => ({
          Report: ApprovalProcess__r.ReportType__c,
          ...rest
        }))
      );
    }
  }

  async onRefresh() {
    await refreshApex(this._wireApprovalData);
  }
}