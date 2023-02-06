/****************************************************************************************
  * Project Name : Hyundai Mobis
  * File Name    : proformaCSVUtilCmp
  * Description  : 
  * Copyright    : Copyright © I2max. All Rights Reserved. 2022 
  * Author       : Kyejin Cheong
  * Created Date : 2022-11-14
****************************************************************************************/

import {SalesBaseCmp} from 'c/salesBaseCmp';
import { api, wire, track }       from 'lwc';

// Apex
import search from '@salesforce/apex/ProformaCSVUtil.search';
import save from '@salesforce/apex/ProformaCSVUtil.save';

// Label
export default class ProformaCsvUtilCmp extends SalesBaseCmp {

    /*
     * Variable
     */
    isShowModal = false;
    isLoading = false;
    objectInfo; // Object (Required)
    inputLineMapList; // CSV Input Line Map List (Required)
    csvList = [];
    errorLines = 0;
    label = {};

    @api show(params) {
        console.log('ProformaCsvUtilCmp show()');
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
    get getProformaFlag() {
        return this.objectInfo?.apiName === 'ProformaDummy__c';
    }
     
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
        let errorLines = 0;
        let tempList = [];

        wpList.forEach(function (item) {
            tempList.push(item);
        });

        console.log('tempList > ' + JSON.stringify(tempList));

        this.csvList = tempList;
        this.errorLines = errorLines;
    }

    doSave() {
        console.log('CSV doSave');

        const header = 'Proforma Management';
        const CSV_NAME = this.gfnSvcExcelFileName(header);
        const changeDescription = this.template.querySelector('[data-id=description]')?.value

        console.log('changeDescription > ' + changeDescription);

        this.isLoading = true;

        let reqData = {
            objectTypeValue : this.objectInfo.apiName,
            csvList : JSON.stringify(this.csvList),
            csvName: CSV_NAME,
            changeDescription : changeDescription
        }

        console.log('CSV_NAME > ' + CSV_NAME);

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