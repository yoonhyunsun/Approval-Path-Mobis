/****************************************************************************************
 * Project Name : Hyundai Mobis
 * File Name    : salesBaseCmp
 * Description  : Component Base
 * Copyright    : Copyright © 2022 I2max. All Rights Reserved.
 * Author       : Kyejin Cheong
 * Created Date : 2022-11-08
 ****************************************************************************************/

import { api, wire, track } from "lwc";
import { LwcComBase } from "c/lwcComBase";

// Label
import COM_CSV_FAILED from "@salesforce/label/c.COM_CSV_FAILED";
import COM_CSV_NO_CONTENT from "@salesforce/label/c.COM_CSV_NO_CONTENT";
import COM_CSV_FILE_TYPE from "@salesforce/label/c.COM_CSV_FILE_TYPE";

export class SalesBaseCmp extends LwcComBase {
  @api recordId;

  connectedCallBack() {
    // initialize component
    this.gfnComConnectedCallback(() => {});
  }

  /**
   * @author Kyejin Cheong
   * @description 태그 속성 Validation - 선택자 & 입력값 을 비교 검사 후 결과 리턴
   *              min-length, required 여부 등..
   * @return boolean - validation 결과
   */
  gfnSvcLightningInputValid(inputFieldList) {
    inputFieldList = Array.isArray(inputFieldList)
      ? inputFieldList
      : inputFieldList != null
      ? [inputFieldList]
      : [];

    const allValid = inputFieldList.reduce((validSoFar, inputCmp) => {
      return validSoFar && inputCmp.checkValidity();
    }, true);

    return allValid;
  }

  /*
   * =============================================================================
   * =============================================================================
   * Excel & CSV 관련
   * =============================================================================
   * =============================================================================
   */

  /**
   * Excel File Naming
   */
  gfnSvcExcelFileName(header = "Export") {
    // e.g. Model Code : 'AE', Part Code : 09011, Part Name : '', the file name will be 'Applied Price List_AE_0911_(empty)_20220203_155819'
    const today = new Date();
    const yyyy = String(today.getFullYear());
    const mm = String(today.getMonth() + 1).padStart(2, "0");
    const dd = String(today.getDate()).padStart(2, "0");
    const hours = String(today.getHours()).padStart(2, "0");
    const minutes = String(today.getMinutes()).padStart(2, "0");
    const seconds = String(today.getSeconds()).padStart(2, "0");
    const fileName =
      header + "_" + "_" + yyyy + mm + dd + "_" + hours + minutes + seconds;
    console.log("fileName > " + fileName);

    return fileName;
  }

  /**
   *  CSV Upload File read
   */
  gfnSvcCSVReadFiles(params = {}) {
    const self = params.self;
    const files = params.files;
    const objectInfo = params.objectInfo;
    const label = params.label;

    console.log("objectInfo > " + JSON.stringify(objectInfo));
    console.log("gfnSvcCSVReadFiles");
    console.log("files length > " + files.length);
    console.log("files type > " + files[0].type);
    console.log("files size > " + files[0].size);
    console.log("label > " + JSON.stringify(label));
    console.log('[SalesBaseCmp] objectInfo > ' + JSON.stringify(objectInfo));

    // CSV 파일만 선택 가능
    if (files[0].type !== "text/csv") {
      // Only CSV file type can be uploaded.
      this.gfnComShowToast(
        COM_CSV_FILE_TYPE,
        this.ToastData.gComShowToastVariant.w
      );
      return;
    }


    // Planning
    if (objectInfo.apiName === "PlanningPerformance__c") {
      [files].forEach(async (file) => {
        try {
          const result = await this.gfnSvcLoad(file);

          this.gComIsSpinner = false;
          this.file = this.gfnSvcCsvJSON(result);

          // ------------------------------
          // CSV Util Modal Open
          // ------------------------------
          const csvUtilCmp = self.template.querySelector(
            "c-planning-c-s-v-util-cmp"
          );
          csvUtilCmp.show({
            objectInfo: objectInfo,
            recordId: self.resHeader?.id,
            inputLineMapList: this.file,
            label: label
          });
        } catch (e) {
          // handle file load exception
          console.log(e);
          this.gfnComShowToast(
            COM_CSV_FAILED,
            this.ToastData.gComShowToastVariant.e
          ); // Failed to CSV upload.
          this.gComIsSpinner = false;
        }
      });
    } else {
      [files].forEach(async (file) => {
        try {
          const result = await this.gfnSvcLoad(file);

          this.gComIsSpinner = false;
          this.file = this.gfnSvcCsvJSON(result);

          // ------------------------------
          // CSV Util Modal Open
          // ------------------------------
          const csvUtilCmp = self.template.querySelector(
            "c-proforma-c-s-v-util-cmp"
          );
          csvUtilCmp.show({
            objectInfo: objectInfo,
            recordId: self.resHeader?.id,
            inputLineMapList: this.file,
            label: label
          });
        } catch (e) {
          // handle file load exception
          console.log(e);
          this.gfnComShowToast(
            COM_CSV_FAILED,
            this.ToastData.gComShowToastVariant.e
          ); // Failed to CSV upload.
          this.gComIsSpinner = false;
        }
      });
    }
  }

  async gfnSvcLoad(file) {
    return new Promise((resolve, reject) => {
      this.gComIsSpinner = true;
      const reader = new FileReader();
      // Read file into memory as UTF-8
      reader.onload = function () {
        resolve(reader.result);
      };
      reader.onerror = function () {
        reject(reader.error);
      };
      reader.readAsText(file[0]);
      // reader.readAsText(file, 'UTF-8');
    });
  }

  gfnSvcCsvJSON(csv) {
    let lines = csv.split(/\r\n|\n/);

    let result = [];

    // console.log('lines > ' + lines);
    let headers = lines[0].split(",");
    for (let i = 1; i < lines.length; i++) {
      let obj = {};
      let currentLine = lines[i].split(",");
      // console.log('currentLine > ' + currentLine);

      for (let j = 0; j < headers.length; j++) {
        if (currentLine[j]) {
          obj[headers[j]] = currentLine[j];
        }
      }

      if (Object.keys(obj).length) {
        // 비어있으면 result 에 담지 않는다.
        result.push(obj);
      }
    }
    console.log("result.length > " + result.length);

    return result;
  }

  gfnSvcHandleError = (error) => {
    console.error(error);
    if (error) {
      let errorMessage;

      if (error.body) {
        //----------------------------------------------------
        // basic error
        //----------------------------------------------------
        if (error.body.message) {
          errorMessage = error.body.message;
        }
        //----------------------------------------------------
        // page error
        //----------------------------------------------------
        else if (error.body.pageErrors[0]) {
          errorMessage = error.body.pageErrors[0].message;
        }
        //----------------------------------------------------
        // field error
        //----------------------------------------------------
        else if (error.body.fieldErrors) {
          Object.keys(error.body.fieldErrors).forEach(function (field, index) {
            if (error.body.fieldErrors[field]) {
              errorMessage =
                "[" + field + "] : " + error.body.fieldErrors[field][0].message;
            }
          });
        }
      }

      if (errorMessage) {
        this.gfnComShowToast(
          errorMessage,
          this.ToastData.gComShowToastVariant.e
        );
      }
    }
  };

  gfnSvcAssignValueToObject = (targetObj, key, value) => {
    if (targetObj.hasOwnProperty(key)) {
      Object.assign(targetObj[key], value);
    } else {
      targetObj[key] = value;
    }
  };

  gfnSvcRefreshPage() {
    eval("$A.get('e.force:refreshView').fire();");
  }
}