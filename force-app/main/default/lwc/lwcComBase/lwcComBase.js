/****************************************************************************************
 * Project Name : Hyundai Mobis
 * File Name    : lwcComBase
 * Description  :
 * Copyright    : Copyright © 2022 I2max. All Rights Reserved.
 * Author       : I2MAX
 * Created Date : 2022-05-12
 ****************************************************************************************/

/**
 * =====================================================
 * 기본 import
 * =====================================================
 */
import { LightningElement, api, wire, track }       from 'lwc';
import { refreshApex }                              from '@salesforce/apex';
import { ShowToastEvent }                           from 'lightning/platformShowToastEvent';
import { NavigationMixin, CurrentPageReference }    from 'lightning/navigation';
// import isGuest                                      from '@salesforce/user/isGuest';
import Id                                           from '@salesforce/user/Id';
import CLIENT_FORM_FACTOR                           from '@salesforce/client/formFactor'
import LANG                                         from '@salesforce/i18n/lang';

/**
 * =====================================================
 * 공통 Utils and Services
 * =====================================================
 */

import { LwcComData } from 'c/lwcComData';
import { LwcComUtil } from 'c/lwcComUtil';
import { LwcComNaviService } from "c/lwcComNaviService";
import { LwcComClass } from "c/lwcComClass";

/**
 * apex 호출시 pure javascript error 발생시 대표에러 표시 여부
 * false (Default) : 기본적으로 javascript pure error시 공통 기본 메시지를 보여줌
 */
const IS_DEFAULT_PURE_ERROR = false;
/**
 * apex 호출시 apex 호출 로깅을 보여줌
 * true (Default) : 기본적으로 javascript pure error 메시지를 보여줌
 */
const IS_DEFAULT_APEX_RESULT_LOG_JSON = true;

/**
 * =====================================================
 * 최상위 공통 변수
 * g+업무코드(Com)+변수명
 * =====================================================
 */

/**
 * =====================================================
 * 최상위 공통 함수
 * g+업무코드(Com)+함수명
 * =====================================================
 */

/**
 * =====================================================
 * export 항목 : 하위 업무 컴포넌트에 항목만 export 할 것
 * =====================================================
 */

/**
 * 공통 기본 Class
 * 모든 컴포넌트 클래스의 공통단 최상위 클래스며
 * 기본적인 member, method 가 built-in 됨.
 * @extends NavigationMixin(LightningElement)
 */
export class LwcComBase extends NavigationMixin(LightningElement) {

    /*
     * ======================================================
     * 공통처리 Properties
     * ======================================================
     */

    /**
     * [공통] third-party lodash library 객체
     * @type {Object}
     */

    /**
     * [공통] 로그인 사용자 Id
     * @type {string}
     */
    gComLoginUserId = Id;
    /**
     * [공통] Guest User 여부
     * @type {boolean}
     */
    // gComIsGuestUser = isGuest;
    /**
     * [공통] i18n - 사용자 Lang
     * @type {string}
     */
    gComLang = LANG;
    /**
     * [공통] life hooks (connectedCallback) - 초기 한번수행 제어 플래그
     * @type {boolean}
     */
    gComInitConnected = false;
    /**
     * [공통] life hooks (renderedCallback) - 초기 한번수행 제어 플래그
     * @type {boolean}
     */
    gComInitRendered = false;
    /**
     * [공통] APEX 호출 Properties : 필요시 사용 - 초기 세팅, 거래 데이터 용
     * @type {object}
     */
    @track  gComInitData = {};
    /**
     * [공통] APEX 호출 Properties : 필요시 사용 - apex 호출 데이터 용
     * @type {object}
     */
    @track  gComReqData = {};
    /**
     * [공통] APEX 호출 Properties : 필요시 사용 - apex 결과 데이터 용
     * @type {{}}
     */
    @track  gComResData = {};
    /**
     * [공통] 처리할 Error
     * @type {Object}
     */
    @track  gComError;
    /**
     * [공통] spinner display 제어 flag
     * @type {boolean}
     */
    @track gComIsSpinner = false;
    /**
     * [공통] Navigator 처리 current pageReference Object
     * @type {Object}
     */
    @wire(CurrentPageReference) gComPageRef;

    /*
     * =============================================================================
     * =============================================================================
     * 공통처리 Function
     * =============================================================================
     * =============================================================================
     */

    /*
     * =============================================================================
     * =============================================================================
     * Event
     * =============================================================================
     * =============================================================================
     */

    /**
     * [공통] toast 호출 - 토스트 옵션을 개발자가 프리하게 설정하여 호출
     * @function
     * @param {object} toastOption - Toast 정보 객체
     * @example
     * this.gfnComShowToastSelf({
     *    title : 'Success!',
     *    message: 'sucessfully done.'
     * });
     * @since 1.0.0
     * @see https://developer.salesforce.com/docs/component-library/bundle/lightning-platform-show-toast-event/documentation
     */
    gfnComShowToastSelf = (toastOption = {}) => {
        this.dispatchEvent(new ShowToastEvent(toastOption));
    };

    /**
     * [공통] toast 호출 : simple toast
     * @function
     * @param {string} message - Toast 에 보여지는 메시지
     * @param {string} mode - Determines how persistent the toast is. Valid values are: dismissable (default),
     *               remains visible until you click the close button or 3 seconds has elapsed,
     *               whichever comes first; pester, remains visible for 3 seconds and disappears automatically.
     *               No close button is provided; sticky, remains visible until you click the close button.
     * @param {string} variant - info (default), success, warning, and error.
     * @since 1.0.0
     */
    gfnComShowToast = (message, variant=this.ToastData.gComShowToastVariant.i, mode=this.ToastData.gComShowToastMode.dismissable) => {
        this.dispatchEvent(new ShowToastEvent({
            message: message,
            variant: variant,
            mode: mode
        }));
    };

    /**
     * [공통] 정상적 처리 Default ShowToast
     * @function
     * @example
     * this.gfnComShowToastDefaultSuccess();
     * @since 1.0.0
     */
    gfnComShowToastDefaultSuccess = () => {
        this.gfnComShowToast(this.ToastData.gComShowToastMessages.s, this.ToastData.gComShowToastVariant.s);
    };

    /**
     * 기본 : lwc 컴포넌트 Custom Event dispatch(fire)
     * bubbles : true 인 경우가 매우 많이 사용되므로 기본으로 세팅함.
     * @function
     * @param {string} customEventName - 이벤트명
     * @param {object} detail - 이벤트 파라미터
     * @param {boolean} bubbles : true(default) - bubbles 여부
     * @param {boolean} composed - composed 여부
     * @example
     * this.gfnComFireDispatch('comboboxchange',{comboBoxValue:event.detail.value});
     * @since 1.0.0
     */
    gfnComFireDispatch = (customEventName, detail, {bubbles=true, composed=false}={}, thisArg=this) => {
        thisArg.dispatchEvent(new CustomEvent(customEventName, {
            detail: detail,
            bubbles: bubbles,
            composed: composed
        }));
    };

    /*
     * =============================================================================
     * =============================================================================
     * Apex Call
     * =============================================================================
     * =============================================================================
     */

    /**
     * [공통] wire된 property cache refresh
     * @function
     * @param {any} wireProperty - cache refresh 대상의 wire 로 연결된 property
     * @returns {Promise<any>}
     * @since 1.0.0
     */
    gfnComRereshApex = (wireProperty) => {
        return refreshApex(wireProperty);
    };

    /**
     * [공통] wire adapter 사용시 Sync모듈이 필요한 경우 사용
     * @function
     * @param {object} data - 결과 데이터
     * @param {object} error - 에러 데이터
     * @param {function} callback - 업무 처리 함수
     * @example
     - @wire(getObjectInfo, { objectApiName: OPPORTUNITY_OBJECT.objectApiName })
     wireGetObjectInfo({error, data}) {
            // sync 로 처리할 경우
            this.gfnComWiredSync({error, data}, (data) => {
                //============================================================================
                // log를 반드시 찍어보고 해당 항목을 처리할 것
                //============================================================================
                this.gfnLog('111. opportunityObject for data', data);
                this.opportunityObject = data;
                this.defaultRecordTypeId = data.defaultRecordTypeId;
            });
        }
     * @since 1.0.0
     */
    gfnComWiredSync = ({error, data}, callback) => {
        /*
         * ================================================================
         * [중요] 반드시 error, data의 존재 유무를 판단해야 함.
         * ================================================================
         */
        error && this.gfnComHandleError(error);
        data && callback && callback(data);
    }

    /**
     * [공통] wire adapter 사용시 Async 모듈이 필요한 경우 사용
     * @function
     * @param {object} data - 결과 데이터
     * @param {object} error - 에러 데이터
     * @returns {Promise<any>}
     * @since 1.0.0
     */
    gfnComWiredAsync = ({error, data}) => {
        return this.gfnComWiredApex({data, error});
    }

    /**
     * wired apex resolve 공통 함수
     * 공통 에러처리를 위해 공통화
     * @function
     * @param {object} data - 결과 데이터
     * @param {object} error - 에러 데이터
     * @returns {Promise<any>}
     * @example
     - @wire(getOpportunity, { recordId: '$tempRecordId' })
     wiredOpportunity({data, error}){
                    this.gfnComWiredApex({data, error})
                    .then( data => {
                        this.gfnLog('data : ', data);
                        this.opportunity = data;
                    })
                    .catch( error => {
                        this.gfnComHandleError(error);
                    });
                }
     * @since 1.0.0
     */
    gfnComWiredApex = ({error, data}) => {
        return new Promise((resolve, reject) => {
            if (data && resolve) {
                try {
                    return resolve(data);
                }
                catch(error) {
                    this.gfnComHandleError(error);
                }
            }
            if (error) {
                if(reject)  return reject(error);
                else        return this.gfnComHandleError(error);
            }
        });
    };

    /**
     * [공통] apex 호출 메소드
     * @function
     * @async
     * @param {string} serverAction - apexMethodName
     * @param {string} cFuncName - client function Name
     * @param {string} sFuncName - server function Name
     * @param {object} params - parameters
     * @param {function } resultHandler - resolve handler(arrow function)
     * @param {function } errorHandler - reject handler(arrow function)
     * @param {boolean} isLogJSON - logJSON 여부
     * @param {string} tableFrame - tableElement 명
     * @returns {Promise<void>}
     * @since 1.0.0
     */
    gfnComApex = async ({
                            serverAction,
                            cFuncName=this.EtcData.gComDefaultSearchFunction,
                            sFuncName,
                            params,
                            resultHandler,
                            errorHandler=null,
                            isLogJSON=IS_DEFAULT_APEX_RESULT_LOG_JSON,
                            tableFrame=null
                        }) => {
        this.LogUtil.isShow && console.group('%c ==> Apex Call ', 'color:green');
        //==================================================================
        // Proxy 객체가 바로 넘어가는 것을 방지
        //==================================================================
        // let convParams = !!params ? this.ProxyUtil.toObject(params) : params;
        let convParams = !!params ? this.ProxyUtil.toObject(this, params) : params;

        this.LogUtil.comLog({startFuncName:cFuncName, endFuncName:sFuncName + '(server)'},{params: isLogJSON ? convParams : params});

        this.LogUtil.isShow && console.groupEnd();
        //==================================================================
        // spinner on
        //==================================================================
        this.gfnComShowSpinner();

        //==================================================================
        // Apex 호출
        // finally 는 추가하지 말자 : 메뉴클릭시 에러가 발생
        // success, catch 에서 finally 기능 처리(spinner 제거등)
        //==================================================================
        await serverAction(params)
            .then(result => {
                //==================================================================
                // finally 가 제대로 미동작 때문에 각각 제거
                //==================================================================
                this.gfnComFinallyActions();
                //==================================================================
                // apex 에서 void인 경우 parsing 에러 발생 제거
                //==================================================================
                // let convResult = !!result ? this.ProxyUtil.toObject(result) : '';
                let convResult = !!result ? this.ProxyUtil.toObject(this, result) : '';

                this.LogUtil.comLog({startFuncName:sFuncName, endFuncName:cFuncName + '(client)'},{result: isLogJSON ? convResult : result});

                if(resultHandler) {
                    //==================================================================
                    // tableFrame Setting
                    // params에 pageNumber, pageSize, _tableFrame의 존재여부로 판단
                    //==================================================================
                    const _tableFrame = tableFrame || this.template.querySelector('c-lwc-ufw-table-frame');
                    if( _tableFrame && convParams[this.PagingData.gComReqDataParam.pageNumber] && convParams[this.PagingData.gComReqDataParam.pageSize]) {
                        this.gfnComSetPagingInfo({pageInfo:params, result, tableFrame:_tableFrame});
                    }
                    //==================================================================
                    // resolve 수행
                    //==================================================================
                    return resultHandler(result);
                }
            })
            .catch(error => {
                //==================================================================
                // finally 가 제대로 미동작 때문에 각각 제거
                //==================================================================
                this.gfnComFinallyActions();
                this.LogUtil.isShow && console.group('%c ==> Server Error ', 'color:red');
                this.LogUtil.comLog(null, {error: isLogJSON ? this.ProxyUtil.toObject(error) : error}, this.LogUtil.isShow, true);
                this.LogUtil.isShow && console.groupEnd();
                // console.groupEnd();
                if(errorHandler)    return errorHandler(error);
                else                this.gfnComHandleError(error);
            });
    };

    /**
     * Server Action finally
     * 내부적으로만 사용함
     * @function
     * @private
     */
    gfnComFinallyActions() {
        this.gfnComHideSpinner();
    }

    /**
     * show spinner
     * @function
     * @private
     */
    gfnComShowSpinner() {
        this.gComIsSpinner = true;
    }

    /**
     * hide spinner
     * @function
     * @private
     */
    gfnComHideSpinner() {
        this.gComIsSpinner = false;
    }

    /**
     * [공통] table frame의 페이징 정보 세팅
     * @function
     * @param {object} pageInfo - 페이지 정보 객체
     * @param {object} result - 결과 객체
     * @param {string} tableFrame - table명
     * @since 1.0.0
     */
    gfnComSetPagingInfo = ({pageInfo, result, tableFrame}) => {
        const _pageInfo = this.ProxyUtil.toObject(this, pageInfo);
        const _tableFrame = tableFrame || this.template.querySelector('c-lwc-ufw-table-frame');

        _tableFrame[this.PagingData.gComReqDataParam.pageNumber]  = _pageInfo[this.PagingData.gComReqDataParam.pageNumber];
        _tableFrame[this.PagingData.gComReqDataParam.pageSize]    = _pageInfo[this.PagingData.gComReqDataParam.pageSize];
        // _tableFrame.totalSize   = result.totalSize;
        // _tableFrame.recordSize  = result.recordSize;
        // edit by jihoon
        _tableFrame.totalSize   = result.data.totalSize;
        _tableFrame.recordSize  = result.data.recordSize;
    }

    /**
     * [공통] 공통 에러 처리
     * 1. Apex 호출 에러는 proxy wrapping 된 에러 객체로 처리(body 사용)
     * 2. 일반 자바스크립트 pure Error 객체는 바로 message로 처리
     * @function
     * @param {error} error - proxy Error or pure Error
     * @param {boolean} isDefaultPureError - pure Error시 디폴트 메시지 여부
     * @since 1.0.0
     */
    gfnComHandleError = (error, isDefaultPureError=IS_DEFAULT_PURE_ERROR) => {
        console.error(error);
        this.gComError = error;
        this.gfnComShowToast(
            (isDefaultPureError ? 'An error occurred.' : this.gfnComReduceErrors(error).join(', ')),
            this.ToastData.gComShowToastVariant.e
        );
    };

    /**
     * [공통] 공통 에러 메시지 처리
     * 내부적으로 사용
     * @private
     * @function
     * @param errors
     * @returns {string}
     * @since 1.0.0
     */
    gfnComReduceErrors = (errors) => {
        errors = Array.isArray(errors) || [errors];
        return (errors
                // Remove null/undefined items
                .filter(error => !!error)
                // Extract an error message
                .map(error => {
                    // UI API read errors
                    if (Array.isArray(error.body)) {
                        return error.body.map(e => e.message);
                    }
                    // UI API DML, Apex and network errors
                    else if (error.body && typeof error.body.message === 'string') {
                        return error.body.message;
                    }
                    // JS errors
                    else if (typeof error.message === 'string') {
                        return error.message;
                    }
                    // Unknown error shape so try HTTP status text
                    return error.statusText;
                })
                // Flatten
                .reduce((prev, curr) => prev.concat(curr), [])
                // Remove empty strings
                .filter(message => !!message)
        );
    };

    /*
     * =============================================================================
     * =============================================================================
     * Promise Wrapper 모듈
     * =============================================================================
     * =============================================================================
     */

    /**
     * Lifecycle hooks 의 connectedCallback 수행
     * lodash 를 사용할 경우 hasLodash를 true 로 세팅하면 자신의 lodash(_) 필드에 세팅이 됨.
     * 따라서 각각의 event 핸들러 함수에서 this._ 로 접근하여 사용가능.
     * @function
     * @param {function} resolve - resolve 함수
     * @param {boolean} hasLodash - lodash 사용 여부
     * @param {boolean} onlyInit - 처음만 수행 여부
     * @since 1.0.0
     */
    gfnComConnectedCallback = (resolve, {hasLodash=false, onlyInit=true}={}) => {

        if(onlyInit) {
            if(LwcComUtil.PropertyUtil.isTrue(this.gComInitConnected)) return;
            this.gComInitConnected = true;
        }

        const action = () => {
            resolve && resolve();
        }

        hasLodash ? (() => {
            this.gfnSvcGetLodash(this).then(() => { action(); });
        })() : action();

    };

    /**
     * Lifecycle hooks 의 renderedCallback 수행
     * lodash 를 사용할 경우 hasLodash를 true 로 세팅하면 자신의 lodash(_) 필드에 세팅이 됨.
     * 따라서 각각의 event 핸들러 함수에서 this._ 로 접근하여 사용가능.
     * @function
     * @param resolve
     * @param {boolean} hasLodash <Boolean> - lodash 를 수행 여부
     * @param {boolean} isExecute - 실행 여부 (wired 등 특정 속성값이 존재할 경우 수행)
     * @param {boolean} onlyInit <Boolean> - 한번만 수행 여부
     * @since 1.0.0
     */
    gfnComRenderedCallback = (resolve, {hasLodash=false, isExecute=true, onlyInit=true} = {}) => {

        if(onlyInit) {
            if(this.PropertyUtil.isTrue(this.gComInitRendered)) return;
            this.gComInitRendered = true;
        }

        const action = () => {
            resolve && resolve();
        }

        hasLodash ? (() => {
            this.gfnSvcGetLodash(this).then(() => { action(); });
        })() : action();

    };

    /*
     * =============================================================================
     * =============================================================================
     * 페이징 관련
     * =============================================================================
     * =============================================================================
     */

    /**
     * 이전 페이지 이벤트 핸들러
     * @function
     * @param {event} event - 처리 이벤트
     * @param {function} callFunc - callback function
     * @since 1.0.0
     */
    gComPreviousPage(event, callFunc) {
        if(event && callFunc)   callFunc.call(this, 'gComPreviousPage', this.ProxyUtil.toObject(this, event.detail));
    }

    /**
     * 다음 페이지 이벤트 핸들러
     * @function
     * @param {event} event - 처리 이벤트
     * @param {function} callFunc - callback function
     * @since 1.0.0
     */
    gComNextPage(event, callFunc) {
        if(event && callFunc)   callFunc.call(this, 'gComNextPage', this.ProxyUtil.toObject(this, event.detail));
    }

    /*
     * =============================================================================
     * =============================================================================
     * Modal & 동적 컴포넌트 관련
     * =============================================================================
     * =============================================================================
     */

    /**
     * 해당 QuickAction Show
     * @function
     * @since 1.0.0
     */
    @api
    gfnComShowModal() {
        this.template.querySelector('c-lwc-ufw-container-qa').showModal = true;
    }

    /**
     * 해당 QuickAction Close
     * @function
     * @since 1.0.0
     */
    @api
    gfnComCloseModal() {
        this.template.querySelector('c-lwc-ufw-container-qa').showModal = false;
    }

    /**
     * data setting 및 render 호출.
     * 기본은 callbackFn 없이 사용하나, 필요시 callbackFn 에서 전부 다 handling(this 유의).
     * @param {string} showComponentName : 렌더링 될 컴포넌트명('c-exm-reg-modal')
     * @param {boolean} isQuickAction : QuickAction 여부(true or false)
     * @param targetObj :
        * @param addCallback
     * @param selectorClass
     * @example
     * this.gfnComRenderDynamicComponent({
            showComponentName: this.showComponentName,
            params: new this.DynamicComponentClass(this, {}, true),
            isQuickAction: false,
            addCallback: () => {
                this.addCallback();
            }
        }, '.directRender');
     * @since 1.0.0
     */

    /**
     * data setting 및 render 호출.
     * 기본은 callbackFn 없이 사용하나, 필요시 callbackFn 에서 전부 다 handling(this 유의).
     * @function
     * @param {string} showComponentName - display 되는 component 명
     * @param {boolean} isQuickAction - QuickAction 여부
     * @param {object} params - 전달 parameters
     * @param {object} addCallback - 추가 수행 callback function
     * @param {string} selectorClass - 해당 c-lwc-ufw-dynamic-render 컴포넌트를 구분하는 class명
     * @example
     * handleSendCmpName2() {
        this.gfnComRenderDynamicComponent({
            showComponentName: 'c-zz-exm-popup-html-2',
            params: new this.DynamicComponentClass({
                paramThis:this, paramData:{}, isInit:true
            }),
        }, 'quickActionRender');
     }
     * @since 1.0.0
     */
    gfnComRenderDynamicComponent({showComponentName, isQuickAction=true, params, addCallback}={}, selectorClass) {
        params?.isInit && params?.paramThis?.gfnComRenderInitDynamicComponent(showComponentName, params);
        addCallback && addCallback();
        const clazz = selectorClass?.replaceAll(/[\.\s]/g, '');
        this.template.querySelector(`c-lwc-ufw-dynamic-render.${clazz}`).handleRender({
            showComponentName, isQuickAction
        });
    }

    /**
     * QuickAction이 아닌 일반 동적 렌더 초기화
     * 나중의 로직 분기를 위해 gfnComModalInit 과 일단 분리하여 처리
     * @function
     * @param {string} lwcComponentName - 컴포넌트 명
     * @param {object} renderData - render 시 전달되는 parameter data
     * @since 1.0.0
     */
    @api
    gfnComRenderInitDynamicComponent(lwcComponentName='', renderData=new this.DynamicComponentClass({})) {
        this.template.querySelector(lwcComponentName)?.gfnComInitDynamicComponent(renderData);
    }

    /**
     * 기본 컴포넌트의 초기 실행 함수로 동적 컴포넌트인 경우
     * 초기 수행이 필요할 경우에는 override 하여 구현할 것
     * @param {object} renderData - 렌더링시 전달 데이터
     * @private
     * @since 1.0.0
     */
    @api
    gfnComInitDynamicComponent(renderData) {}

    /*
     * =============================================================================
     * =============================================================================
     * ETC 정보
     * =============================================================================
     * =============================================================================
     */

    /**
     * 커뮤니티 사이트 여부
     * @getter
     * @type {boolean}
     * @returns {boolean}
     * @since 1.0.0
     */
    get gComIsCommunity() {
        return LwcComUtil.CommunityUtil.isCommunity();
    }

    /**
     * FormFactor
     * @getter
     * @type {string}
     * @returns {string}
     * @since 1.0.0
     */
    get gfnComFormFactor() {
        return CLIENT_FORM_FACTOR;
    }

    /**
     * [공통] FormFactor : Desktop 여부
     * @getter
     * @returns {boolean}
     * @since 1.0.0
     */
    get gfnComIsDesktop() {
        return CLIENT_FORM_FACTOR === 'Large';
    }

    /**
     * [공통] ForFactor : Tablet 여부
     * @getter
     * @returns {boolean}
     * @since 1.0.0
     */
    get gfnComIsTablet() {
        return CLIENT_FORM_FACTOR === 'Medium';
    }

    /**
     * [공통] ForFactor : Phone 여부
     * @getter
     * @returns {boolean}
     * @since 1.0.0
     */
    get gfnComIsPhone() {
        return CLIENT_FORM_FACTOR === 'Small';
    }

    /**
     * [공통] 해당 컴포넌트의 container component를 구함
     * @deprecated 미사용으로 삭제예정
     * @returns {Element}
     * @since 1.0.0
     */
    gfnComGetContainer = () => {
        return this.template.querySelector('c-lwc-ufw-container');
    }

    /**
     * lwcComUtil 에 정의되었지만 사용상 편의를 위해 lwcComBase에 gfnLog 생성
     * @param args
     * @example
     * this.gfnLog('good handle');
     * @since 1.0.0
     */
    gfnLog = (...args) => {
        this.LogUtil.log(...args);
    }

    /*
     * =============================================================================
     * =============================================================================
     * lifecycle hooks
     * 업무에서는 필요시 override 처리하고, super 호출을 한다.
     * super.disconnectedCallback();
     * super 호출후에 업무별 로직을 구현
     * =============================================================================
     * =============================================================================
     */

    /**
     * @author Jihoon Song
     * Example
     * @string : 사계절은 {0}, {1}, {2} 그리고 {3} 입니다.
     * @function this.gfnComStringFormat(string, '봄', '여름', '가을', '겨울');
     * @returns >> 사계절은 봄, 여름, 가을 그리고 겨울 입니다.
     */
    gfnComStringFormat(string) {
        let outerArguments = arguments;
        return string.replace(/\{(\d+)\}/g, function(index) {
            let argIndex = index.replace(/\{/g, '').replace(/\}/g, '');
            return outerArguments[parseInt(argIndex) + 1];
        });
    }


}

/**
 * =============================================================================
 * =============================================================================
 * Service, Util, Data는 Object로 구성하여 prototype 에 연결
 * =============================================================================
 * =============================================================================
 */
Object.assign(LwcComBase.prototype, LwcComNaviService);
Object.assign(LwcComBase.prototype, LwcComUtil, LwcComData);
Object.assign(LwcComBase.prototype, LwcComClass);