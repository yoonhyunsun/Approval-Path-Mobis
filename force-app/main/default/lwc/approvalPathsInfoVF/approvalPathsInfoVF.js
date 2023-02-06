/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 02-04-2023
 * @last modified by  : Bekhzod Ubaydullaev
 **/
import { LightningElement, api } from "lwc";
import { translations } from "c/utils";

const columns = [
  //{ label: "Process Name", fieldName: "process_name" },
  { label: "Employee", fieldName: "employee" },
  { label: "Position", fieldName: "title" },
  { label: "Department", fieldName: "department" },
  { label: "Approval Type", fieldName: "approval_type" },
  { label: "Approval Status", fieldName: "approval_status" },
  { label: "Approval Date&Time", fieldName: "approval_datetime" }
  //{ label: "Comment", fieldName: "comment", type: "richText"}
];

export default class ApprovalPathsInfoVF extends LightningElement {
  columns = columns;
  @api uid;
  tableData = {};

  labels = translations;

  loadReportContentTable() {
    fetch(
      "/approve/services/apexrest/ApprovalProcessInfoTable/?uid=" + this.uid,
      {
        method: "GET",
        headers: {
          "Content-Type": "application/json"
        },
        mode: "cors"
      }
    ).then(async (response) => {
      this.tableData = await response.json();

      if (this.tableData.success === "false") {
        throw new Error("e");
      }
    });
  }

  handleClickTableRefreshButton() {
    this.loadReportContentTable();
    this.dispatchEvent(new CustomEvent("refresh"));
  }

  connectedCallback() {
    this.loadReportContentTable();
  }
}