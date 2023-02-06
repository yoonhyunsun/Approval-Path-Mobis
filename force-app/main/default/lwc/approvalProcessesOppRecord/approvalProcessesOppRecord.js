/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 10-04-2022
 * @last modified by  : https://github.com/Eldor901
 **/
import { LightningElement, api, track, wire } from "lwc";
import getApprovalProcesses from "@salesforce/apex/ApprovalProcessPathController.getApprovalProcesses";
import { enumerate } from "c/utils";
import { refreshApex } from "@salesforce/apex";

export default class ApprovalProcessesOppRecord extends LightningElement {
  @api recordId;

  @track data = null;

  _wireApprovalData;
  @wire(getApprovalProcesses, { OpportunityId: "$recordId" })
  approvalPathes(data) {
    this._wireApprovalData = data;
    if (data.data) {
      this.data = enumerate(
        data.data.map(({ ReportType__c, ...rest }) => ({
          Report: ReportType__c,
          ...rest
        }))
      );
    }
  }

  async onRefresh() {
    await refreshApex(this._wireApprovalData);
  }
}