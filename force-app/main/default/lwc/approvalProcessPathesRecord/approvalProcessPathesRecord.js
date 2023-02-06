/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 09-23-2022
 * @last modified by  : https://github.com/Eldor901
 **/
import getApprovalProcessPathes from "@salesforce/apex/ApprovalProcessPathController.getApprovalProcessPathes";
import { LightningElement, api, wire } from "lwc";

export default class ApprovalProcessPathesRecord extends LightningElement {
  @api
  recordId;

  data = null;

  @wire(getApprovalProcessPathes, { approvalProcessPathId: "$recordId" })
  approvalPathes(data) {
    if (data.data) {
      this.data = data.data.map(({ Employee__r, ...rest }) => ({
        Name: Employee__r.Name,
        PositionName__c: Employee__r.PositionName__c,
        Department__c: Employee__r.Department__c,
        ...rest
      }));
    }
  }
}