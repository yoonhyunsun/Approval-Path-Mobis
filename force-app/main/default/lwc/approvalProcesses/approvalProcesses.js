/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 12-07-2022
 * @last modified by  : https://github.com/Eldor901
 **/
import { LightningElement, api } from "lwc";
import { approvalProcessColumns } from "c/utils";
import { translations } from "c/utils";

export default class ApprovalProcesses extends LightningElement {
  @api tableData;
  ampm = false;

  columns = approvalProcessColumns;

  labels = translations;

  get tableLength() {
    return this.tableData?.length ?? 0;
  }

  onRefresh() {
    const refreshEvent = new CustomEvent("refresh");

    this.dispatchEvent(refreshEvent);
  }
}