/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 10-04-2022
 * @last modified by  : https://github.com/Eldor901
 **/
import { LightningElement, api } from "lwc";
import { approvalProcessPathColumns } from "c/utils";
import { NavigationMixin } from "lightning/navigation";

export default class ApprovalProcessPathesInfo extends NavigationMixin(
  LightningElement
) {
  @api tableData;
  ampm = false;

  columns = approvalProcessPathColumns;

  onReportClick(event) {
    const id = event.currentTarget.dataset.id;

    this[NavigationMixin.Navigate]({
      type: "standard__recordPage",
      attributes: {
        recordId: id,
        actionName: "view"
      }
    });
  }

  get tableLength() {
    return this.tableData?.length ?? 0;
  }

  onRefresh() {
    const refreshEvent = new CustomEvent("refresh");

    this.dispatchEvent(refreshEvent);
  }
}