/****************************************************************************************
 * Project Name : Hyundai Mobis
 * File Name    : planningPerformanceManagementCmp
 * Description  :
 * Copyright    : Copyright © I2max. All Rights Reserved. 2022
 * Author       : Kyejin Cheong
 * Created Date : 2022-11-21
 ****************************************************************************************/

import { SalesBaseCmp } from "c/salesBaseCmp";
import { api, wire, track, LightningElement } from "lwc";
import { getObjectInfos } from "lightning/uiObjectInfoApi";
import { loadStyle } from "lightning/platformResourceLoader";

// Static Resources
import PLANNINGTEMPLATE from "@salesforce/resourceUrl/PlanningTemplate";

// Object
import PLANNING_PERFORMANCE_OBJECT from "@salesforce/schema/PlanningPerformance__c";

// Apex
import init from "@salesforce/apex/PlanningPerformanceManagement.init";

// Label
import COM_MSG_APEX_ERROR from "@salesforce/label/c.COM_MSG_APEX_ERROR";
import COM_MSG_APEX_SUCCESS from "@salesforce/label/c.COM_MSG_APEX_SUCCESS";
import COM_BTN_CANCEL from "@salesforce/label/c.COM_BTN_CANCEL";
import COM_BTN_SAVE from "@salesforce/label/c.COM_BTN_SAVE";

export default class PlanningPerformanceManagementCmp extends SalesBaseCmp {
  /**
   * Object Info
   */
  planningPerformanceObjectInfo;

  /**
   * Const
   */
  COM_BTN_CANCEL = COM_BTN_CANCEL;
  COM_BTN_SAVE = COM_BTN_SAVE;
  COM_MSG_APEX_SUCCESS = COM_MSG_APEX_SUCCESS;
  COM_MSG_APEX_ERROR = COM_MSG_APEX_ERROR;

  /**
   * Variable
   */

  /*
   * =============================================================================
   * =============================================================================
   * Getter & Setter
   * =============================================================================
   * =============================================================================
   */

  /**
   * Object Info Wire 여부
   */
  get objectInfoWired() {
    return (
      this.planningPerformanceObjectInfo &&
      this.planningPerformanceObjectInfo.fields
    );
  }

  /**
   * Label Object
   */
  get getLabelObj() {
    return {
      COM_BTN_SAVE: COM_BTN_SAVE,
      COM_BTN_CANCEL: COM_BTN_CANCEL,
      COM_MSG_APEX_ERROR: COM_MSG_APEX_ERROR,
      COM_MSG_APEX_SUCCESS: COM_MSG_APEX_SUCCESS
    };
  }

  // csv column header
  /*columnHeader = [
    "Index",
    "BU",
    "LargeGroup",
    "Account",
    "AccountRegion",
    "Date",
    "WeightedLTR"
  ];*/

  /*
   * =============================================================================
   * =============================================================================
   * Event Fire
   * =============================================================================
   * =============================================================================
   */

  /*
   * =============================================================================
   * =============================================================================
   * Event Handler
   * =============================================================================
   * =============================================================================
   */

  /**
   *  CSV Upload Handler
   */
  handleCSVUpload(event) {
    console.log("handleCSVUpload");
    const files = event.target.files;

    let params = {
      self: this,
      files: files,
      objectInfo: this.planningPerformanceObjectInfo,
      label: this.getLabelObj
    };

    console.log("params:" + JSON.stringify(params));
    this.gfnSvcCSVReadFiles(params);
  }

  //  handleCSVDownload() {
  //    let doc = " ";
  //    this.columnHeader.forEach((element) => {
  //      doc += element + `,`;
  //    });
  //    doc += `\n`;
  //    let downloadElement = document.createElement("a");

  //    downloadElement.href = "data:text/csv;charset=utf-8," + encodeURI(doc);
  //    downloadElement.target = "_self";
  //    downloadElement.download = "Template.csv";
  //    document.body.appendChild(downloadElement);
  //    downloadElement.click();
  //  }

  // CSV Template 다운로드 부분
  downloadCSVTemplate(event) {
    const planningTemplate = PLANNINGTEMPLATE;
    window.open(planningTemplate, "_blank");
    return null;
  }

  handleSearch(event) {
    console.log("handleSearch >> ");

    this.gfnSvcRefreshPage();
  }

  /*
   * =============================================================================
   * =============================================================================
   * Initialize
   * =============================================================================
   * =============================================================================
   */
  connectedCallback() {
    this.gfnComConnectedCallback(() => {
      this.doInit();
    });
  }

  doInit() {
    this.gfnComApex({
      serverAction: init,
      cFuncName: "doInit",
      sFuncName: "init",
      params: {},
      resultHandler: (result) => {
        try {
          console.log(result.data.connected);
        } catch (error) {
          this.gfnSvcHandleError(error);
        }
      }
    });
  }

  /*
   * =============================================================================
   * =============================================================================
   * Functions
   * =============================================================================
   * =============================================================================
   */

  /*
   * =============================================================================
   * =============================================================================
   * Wire Info
   * =============================================================================
   * =============================================================================
   */

  /**
   * Object Info Wire Service
   */
  objectApiNames = [PLANNING_PERFORMANCE_OBJECT];
  @wire(getObjectInfos, { objectApiNames: "$objectApiNames" })
  wiredObjectInfo({ data, error }) {
    this.gfnComWiredApex({ data, error })
      .then((data) => {
        this.gfnLog("[planning&performance Info] ", data.results[0].result);
        this.planningPerformanceObjectInfo = data.results[0].result;
      })
      .catch((error) => {
        this.gfnSvcHandleError(error);
      });
  }
}