/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 12-07-2022
 * @last modified by  : https://github.com/Eldor901
 **/
import { LightningElement, wire, api, track } from "lwc";
import getApprovalProcessPaths from "@salesforce/apex/ApprovalProcessPathController.getApprovalProcessPathes";
import { approvalProcessPathColumns, translations } from "c/utils";
import { refreshApex } from "@salesforce/apex";

export default class ApprovalProcessPaths extends LightningElement {
  @api recordId;

  @track data = null;

  columns = approvalProcessPathColumns;

  labels = translations;

  tableData;

  _wireApprovalData;
  @wire(getApprovalProcessPaths, { approvalProcessPathId: "$recordId" })
  approvalProcessPaths(data) {
    this._wireApprovalData = data;
    if (data.data) {
      this.data = data.data.map(({ Employee__r, ...rest }) => ({
        Employee: Employee__r.Name,
        Department: Employee__r?.EmpDepartment__r?.Name,
        Position: Employee__r.PositionName__c,
        ...rest
      }));
    }
  }

  async onRefresh() {
    await refreshApex(this._wireApprovalData);
  }

  get tableLength() {
    return this.data?.length ?? 0;
  }
}