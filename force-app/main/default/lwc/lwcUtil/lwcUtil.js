/****************************************************************************************
 * @author            byeon jw
 * @date              2020-05-26
 * @group             Sales
 * @description

 * Modification Log
 * ===============================================================
 * Ver     Date                Author              Modification
 * ===============================================================
 0.1     2020-05-26             byeon jw            Create
 ****************************************************************************************/

import { ShowToastEvent } from 'lightning/platformShowToastEvent'


/**
 * @description Null Check (문자열 '' Null 판정)
 * @param object {object} value
 */
const isEmpty = (object) => {
    // return object === null || object === undefined || (typeof object === String && object === '') || (typeof object === Array & object.length === 0);
    return object === null || object === undefined || object === '';
};
/**
 * @description Not Null Check (문자열 '' Null 판정)
 * @param object {object} value
 */
const isNotEmpty = (object) => {
    return !isEmpty(object);
};
/**
 * @description Array 타입 변경
 * @param object {Object} value
 */
const toArray = (object) => {
    return Array.isArray(object) ? object : object != null ? [object] : [];
};
/**
 * @description Success Toast 생성
 *
 * @param title {String} Toast title
 * @param message {String} Toast message
 * @param thisArgs {context} this.dispatchEvent() 의 호출 구문을 식별하지 못함. 호출 구문 this 전달
 */
const toastSuccess = (title,message,thisArgs) => {
    if( isEmpty(title) || isEmpty(message) || isEmpty(thisArgs)){
        return;
    }
    const evt = new ShowToastEvent({
        // title   : isNotEmpty(title) ? title : 'Success',
        // message : isNotEmpty(message) ? message : 'success',
        title   : title,
        message : message,
        variant : 'success',
        mode    : 'pester'
    });
    thisArgs.dispatchEvent(evt);
};
/**
 * @description Fail Toast 생성
 *
 * @param title {String} Toast title
 * @param message {String} Toast message
 * @param thisArgs {context} this.dispatchEvent() 의 호출 구문을 식별하지 못함. 호출 구문  this 전달
 */
const toastError = (title,message,thisArgs) => {
    if( isEmpty(title) || isEmpty(message) || isEmpty(thisArgs)){
        return;
    }
    const evt = new ShowToastEvent({
        // title   : isNotEmpty(title) ? title : 'Error',
        // message : isNotEmpty(message) ? message : 'Error',
        title   : title,
        message : message,
        variant : 'error',
        mode    : 'pester'
    });
    thisArgs.dispatchEvent(evt);
};

export { isEmpty, isNotEmpty, toArray, toastSuccess , toastError }