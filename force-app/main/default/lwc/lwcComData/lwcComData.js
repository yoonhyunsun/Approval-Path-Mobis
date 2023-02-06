/****************************************************************************************
 * Project Name : Hyundai Mobis
 * File Name    : lwcComData
 * Description  :
 * Copyright    : Copyright © 2022 I2max. All Rights Reserved.
 * Author       : I2MAX
 * Created Date : 2022-05-12
 ****************************************************************************************/
import COM_MSG_APEX_SUCCESS from '@salesforce/label/c.COM_MSG_APEX_SUCCESS';
import COM_MSG_APEX_ERROR from '@salesforce/label/c.COM_MSG_APEX_ERROR';

/**
 * 공통 데이터 - 공통 모듈에서 사용하는 데이터(공통 커스텀 라벨, 공통 상수 등등)
 * @class
 * @hideconstructor
 */
const LwcComData = {
    /**
     * 토스트 관련 데이터
     * @class
     * @hideconstructor
     */
    ToastData :  {
        /**
         * 성공과 에러의 기본 메시지 타입 정의
         * @type {Object}
         * @example this.gfnComShowToast(this.ToastData.gComShowToastMessages.s, this.ToastData.gComShowToastVariant.s);
         */
        gComShowToastMessages: {
            's': COM_MSG_APEX_SUCCESS, 'e': COM_MSG_APEX_ERROR
        },
        // gComShowToastMessages: {
        //     's': `${COM_MSG_APEX_SUCCESS}`, 'e': `${COM_MSG_APEX_ERROR}`
        // },

        /**
         * toast variant 타입 정의
         * @type {Object}
         * @example this.gfnComShowToast(this.ToastData.gComShowToastMessages.s, this.ToastData.gComShowToastVariant.s);
         */
        gComShowToastVariant: {
            'i': 'info', 's': 'success', 'w': 'warning', 'e': 'error'
        },

        /**
         * toast mode 타입 정의
         * @type {Object}
         * @example this.gfnComShowToast(this.ToastData.gComShowToastMessages.s, this.ToastData.gComShowToastVariant.s, this.ToastData.gComShowToastMode.pester);
         */
        gComShowToastMode: {
            'dismissable': 'dismissable', 'pester': 'pester', 'sticky': 'sticky'
        },
    },

    /**
     * 페이징 관련 데이터
     * @class
     * @hideconstructor
     */
    PagingData : {
        /**
         * 페이징 size, number parameter variable name
         * @type {Object}
         * @example convParams[this.PagingData.gComReqDataParam.pageNumber]
         */
        gComReqDataParam: {
            'pageSize': 'pageSize', 'pageNumber': 'pageNumber', 'reqData': 'reqData'
        },

        /**
         * 페이징 이전, 다음 커스텀 이벤트명
         * @type {Object}
         * @example this.gfnComFireDispatch(this.PagingData.gComPagingEvent.prev, {
                        [this.PagingData.gComReqDataParam.pageNumber]: this.pageNumber,
                        [this.PagingData.gComReqDataParam.pageSize]: this.pageSize,
                    });
         */
        gComPagingEvent: {
            'prev': 'previouspage', 'next': 'nextpage'
        },
    },

    /**
     * 기타 데이터
     * @class
     * @hideconstructor
     */
    EtcData : {
        /**
         * 기본 조회 function name
         * @type {Object}
         * @example cFuncName=this.EtcData.gComDefaultSearchFunction
         */
        gComDefaultSearchFunction: 'doSearch',
    }
}

//============================================================================
// Read Only and No delete Property
//============================================================================
Object.defineProperty(LwcComData.ToastData, 'gComShowToastMessages', {writable: false, configurable: false});
Object.defineProperty(LwcComData.ToastData, 'gComShowToastVariant', {writable: false, configurable: false});
Object.defineProperty(LwcComData.ToastData, 'gComShowToastMode', {writable: false, configurable: false});

Object.defineProperty(LwcComData.PagingData, 'gComReqDataParam', {writable: false, configurable: false});
Object.defineProperty(LwcComData.PagingData, 'gComPagingEvent', {writable: false, configurable: false});

export { LwcComData };