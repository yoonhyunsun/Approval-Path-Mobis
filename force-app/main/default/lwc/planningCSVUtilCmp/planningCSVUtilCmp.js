/****************************************************************************************
  * Project Name : Hyundai Mobis
  * File Name    : planningCSVUtilCmp
  * Description  : 
  * Copyright    : Copyright © I2max. All Rights Reserved. 2022 
  * Author       : Hyunsun Yoon
  * Created Date : 2022-11-25
****************************************************************************************/

import {SalesBaseCmp} from 'c/salesBaseCmp';
import { api, wire, track }       from 'lwc';

// Apex
import search from '@salesforce/apex/PlanningCSVUtil.search';
import save from '@salesforce/apex/PlanningCSVUtil.save';

// Label
export default class PlanningCsvUtilCmp extends SalesBaseCmp {

    /*
     * Variable
     */
    isShowModal = false;
    isShowSave = false;
    isLoading = false;
    objectInfo; // Object (Required)
    inputLineMapList; // CSV Input Line Map List (Required)
    csvList = [];
    errorLines = 0;
    label = {};

    @api show(params) {
        console.log('PlanningCsvUtilCmp show()');
        console.log('params > ' + JSON.stringify(params));
        this.isShowModal = true;

        this.objectInfo = params.objectInfo;
        this.recordId   = params.recordId;
        this.inputLineMapList = params.inputLineMapList;
        this.label = params.label;
        if(this.objectInfo && this.inputLineMapList.length) {
            this.doSearch();
        }
    }

    /*
     * =============================================================================
     * =============================================================================
     * Getter & Setter
     * =============================================================================
     * =============================================================================
     */
    get getHeader() {
        console.log('this.objectInfo > ' + this.objectInfo);
        return this.objectInfo?.label + ' Upload';
    }

    /**
     * 입력한 총 라인 수
     * @returns {*|number}
     */
    get getEnteredTotalLines() {
        return !!this.inputLineMapList ? this.inputLineMapList.length : 0;
    }
    /**
     * 성공 라인 수
     * @returns {*|number}
     */
    get getSuccessLines() {
        return !!this.inputLineMapList ? (this.inputLineMapList.length - this.errorLines) : 0;
    }
    /**
     * 오류 라인 수
     * @returns {*|number}
     */
    get getErrorLines() {
        return this.errorLines;
    }
    /**
     * 오류 or Apex 통신 중 비활성화
     * @returns {boolean}
     */
    get getSaveDisabled() {
        return !this.csvList.length || this.errorLines !== 0 || this.isLoading;
    }

   

    get getPlanningFlag() {
        return this.objectInfo?.apiName === 'PlanningPerformance__c';
    }
    
    /*
     * =============================================================================
     * =============================================================================
     * Initialize
     * =============================================================================
     * =============================================================================
     */
    connectedCallback() {
        // initialize component
        this.gfnComConnectedCallback(() => {

        });
    }

    doInit() {
        // initialize
        this.csvList = [];
        this.objectInfo = {};
        this.inputLineMapList = [];
        this.errorLines = 0;
    }

    /*
     * =============================================================================
     * =============================================================================
     * Functions
     * =============================================================================
     * =============================================================================
     */
    doCancel() {
        console.log('CSV doCancel');
        this.doCloseModal();
    }

    doCloseModal() {
        this.doInit();
        this.isShowModal = false;
    }

    doSearch() {
        let errorLines = 0;

        console.log('CSV doSearch');
        console.log('this.objectInfo.fields > ' + JSON.stringify(this.objectInfo.fields));

        this.isLoading = true;

        this.gfnComApex({
            serverAction    : search,
            cFuncName       : 'doSearch',
            sFuncName       : 'search',
            params          : {
                objectTypeValue : this.objectInfo.apiName,
                inputLineMapList : this.inputLineMapList,
            },
            resultHandler   : result => {
                try{
                    this.isLoading  = false;

                    console.log('result.data.wpList > ' + JSON.stringify(result.data.wpList));
                    console.log('result.data.errorList > ' + JSON.stringify(result.data.errorList));
                    console.log('에러라인 > ' + result.data.errorList.length);

                    if(result.data.errorList.length > 0) {
                        this.isShowSave; // false
                    } else {
                        this.isShowSave = true;
                    }
                    this.setCSVList = result.data.wpList;
                }
                catch(error){
                    this.gfnSvcHandleError(error);
                }
            },
            errorHandler : error => {
                this.isLoading  = false;
                this.gfnSvcHandleError(error);
            }
        });
    }

    set setCSVList(wpList) {
        let idx = 1;
        let errorLines = 0;
        let tempList = [];

        wpList.forEach(function (item) {

            item.index = idx;
            idx++;
            // Error 여부 확인
            if(item.errorMessage && item.errorMessage.length) {
                errorLines += 1;
                item.style = 'background-color: #F59D9D;';
            }
            tempList.push(item);
        });

        this.csvList = tempList;
        this.errorLines = errorLines;
    }


    doSave() {
        console.log('CSV doSave');

        this.isLoading = true;

        console.log('this.objectInfo.apiName' + JSON.stringify(this.objectInfo.apiName));
        let reqData = {
            objectTypeValue : this.objectInfo.apiName,
            csvList : JSON.stringify(this.csvList)
        }

        console.log('reqParams >> ' + JSON.stringify(reqData));

        this.gfnComApex({
            serverAction    : save,
            cFuncName       : 'doSave',
            sFuncName       : 'save',
            params          : this.ApexUtil.setSearchReqData({}, reqData),
            resultHandler   : result => {
                try {
                    if(result.data.isSuccess) {
                        console.log(result.data.isSuccess);
                        this.gfnComShowToast(this.label.COM_MSG_APEX_SUCCESS, this.ToastData.gComShowToastVariant.s);
                    }
                    this.isLoading = false;
                    this.doCloseModal();

                }
                catch(error) {
                    this.gfnSvcHandleError(error);
                }
            },
            errorHandler : error => {
                this.isLoading = false;
                this.gfnSvcHandleError(error);
            }
        });
    }

}