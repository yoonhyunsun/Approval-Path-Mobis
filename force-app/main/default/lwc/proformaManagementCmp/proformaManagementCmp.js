/****************************************************************************************
  * Project Name : Hyundai Mobis
  * File Name    : proformaManagementCmp
  * Description  : 
  * Copyright    : Copyright © I2max. All Rights Reserved. 2022 
  * Author       : Kyejin Cheong
  * Created Date : 2022-11-15
****************************************************************************************/

import {SalesBaseCmp} from 'c/salesBaseCmp';
import { api, wire, track }       from 'lwc';
import { getObjectInfos } from 'lightning/uiObjectInfoApi';
import {loadStyle} from "lightning/platformResourceLoader";

// Object
import PROFORMA_DUMMY_OBJECT from '@salesforce/schema/ProformaDummy__c';

// Apex
import init from '@salesforce/apex/ProformaManagement.init';
import getFileList from '@salesforce/apex/ProformaManagement.getFileList';

// Label
import COM_MSG_APEX_ERROR from '@salesforce/label/c.COM_MSG_APEX_ERROR';
import COM_MSG_APEX_SUCCESS from '@salesforce/label/c.COM_MSG_APEX_SUCCESS';
import COM_BTN_CANCEL from '@salesforce/label/c.COM_BTN_CANCEL';
import COM_BTN_SAVE from '@salesforce/label/c.COM_BTN_SAVE';
import COM_BTN_TEMPLATE_DOWNLOAD from '@salesforce/label/c.COM_BTN_TEMPLATE_DOWNLOAD';

// Static Resources
import CSV_TEMPLATE from '@salesforce/resourceUrl/LWC_CSV_Template';

export default class ProformaManagementCmp extends SalesBaseCmp {

    /**
     * Object Info
     */
    proformaDummyObjectInfo;

    /**
     * Const
     */
    COM_BTN_CANCEL = COM_BTN_CANCEL;
    COM_BTN_SAVE = COM_BTN_SAVE;
    COM_MSG_APEX_SUCCESS = COM_MSG_APEX_SUCCESS;
    COM_MSG_APEX_ERROR = COM_MSG_APEX_ERROR;
    COM_BTN_TEMPLATE_DOWNLOAD = COM_BTN_TEMPLATE_DOWNLOAD;

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
    get objectInfoWired(){
        return this.proformaDummyObjectInfo && this.proformaDummyObjectInfo.fields;
    }

    /**
     * Label Object
     */
    get getLabelObj() {
        return {
            COM_BTN_SAVE : COM_BTN_SAVE,
            COM_BTN_CANCEL : COM_BTN_CANCEL,
            COM_MSG_APEX_ERROR : COM_MSG_APEX_ERROR,
            COM_MSG_APEX_SUCCESS : COM_MSG_APEX_SUCCESS
        }
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

    /**
     *  CSV Upload Handler
     */
    handleCSVUpload(event) {
        console.log('handleCSVUpload');
        const files = event.target.files;

        let params = {
            self : this,
            files : files,
            objectInfo : this.proformaDummyObjectInfo,
            label : this.getLabelObj
        }

        this.gfnSvcCSVReadFiles(params);
    }

    handleSearch(event) {
        console.log('handleSearch >>> ');

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
            serverAction    : init,
            cFuncName       : 'doInit',
            sFuncName       : 'init',
            params          : {},
            resultHandler   : result => {
                try{
                    console.log(result.data.connected);

                    this.doGetFileList('getFileList');

                } catch(error) {
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

     /**
      * CSV Template Download
      */
     doCsvTemplate() {
         const url = CSV_TEMPLATE + '/ProformaManagement_CSV_Template.csv';
         window.open(url, '_blank');
     }

     doGetFileList(cFunc) {

         console.log('doGetFileList > ');

         // 검색 요청값 세팅
         let self = this;
         self.filesList = [];
         self.descriptionList = [];

         // 실행
         this.gfnComApex({
             serverAction: getFileList,
             cFuncName: cFunc,
             sFuncName: 'getFileList',
             params: {}, // 렌더링 오류 방지를 위하여 초기화 처리
             resultHandler: result => {
                 let data = result.data.mapIdTitle;

                 console.log('data > ' + JSON.stringify(data));

                 self.filesList = Object.keys(data).map(item=>({
                     "label":JSON.stringify(data[item].Title),
                     "value":item,
                     "url":`/sfc/servlet.shepherd/document/download/${item}`,
                     "description":JSON.stringify(data[item].Description),
                     }))
                 console.log(self.filesList);

             }
         });
     }

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
     objectApiNames = [PROFORMA_DUMMY_OBJECT];
     @wire(getObjectInfos, { objectApiNames : '$objectApiNames' })
     wiredObjectInfo({data,error}){
         this.gfnComWiredApex({data,error})
             .then( data => {
                 this.gfnLog('[proforma dummy Info] ', data.results[0].result);
                 this.proformaDummyObjectInfo = data.results[0].result;
             })
             .catch( error => {
                 this.gfnSvcHandleError(error);
             });
     }
}