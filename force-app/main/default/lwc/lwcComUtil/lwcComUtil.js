/****************************************************************************************
 * Project Name : Hyundai Mobis
 * File Name    : lwcComUtil
 * Description  :
 * Copyright    : Copyright © 2022 I2max. All Rights Reserved.
 * Author       : I2MAX
 * Created Date : 2022-05-12
 ****************************************************************************************/
import { LwcComData } from 'c/lwcComData';

/**
 * 공통 유틸리티
 * [소스내 접근법]
 * 1. 해당 Util Object 내부에서 다른 함수 호출
 *      this.함수명
 * 2. 해당 Util Object 내부에서 다른 Util의 함수 호출
 *      this.ArrayUtil.isArray(target)
 * @class
 * @hideconstructor
 */
const LwcComUtil = {
    /**
     * 보편적인 Util 함수들
     * @class
     * @hideconstructor
     */
    ComUtil : {
        /**
         * Deep Copy 생성 함수
         * _ (lodash : ThirdParty 라이브러리) 또는 커스텀 _DeepClone 를 이용
         * @function
         * @param {Object} thisArg - this 파라미터 객체
         * @param {Object} target - clone 대상 객체
         * @returns {Object} DeepClone 객체 반환
         */
        deepClone : (thisArg, target) => {
            return (thisArg._) ? thisArg._.cloneDeep(target) : LwcComUtil.ComUtil._DeepClone(target);
        },

        /**
         * custom DeepClone 함수
         * 내부적으로 사용할 것이므로 외부에서는 사용하지 말것
         * @private
         * @param {Object} target - clone 대상 객체
         * @returns {Object} DeepClone 객체
         */
        _DeepClone : (target) => {
            // Basis.
            if (!LwcComUtil.TypeUtil.isObject(target)) {
                return target;
            }

            let objectClone;

            // Filter out special objects.
            const Constructor = target.constructor;

            switch (Constructor) {
                // Implement other special objects here.
                case RegExp:
                    objectClone = new Constructor(target);
                    break;
                case Date:
                    objectClone = new Constructor(target.getTime());
                    break;
                default:
                    objectClone = new Constructor();
            }

            // Clone each property.
            for (let prop in target) {
                objectClone[prop] = LwcComUtil.ComUtil._DeepClone(target[prop]);
            }

            return objectClone;
        },

    },

    /**
     * Community Site 와 관련된 Utils
     * [유의사항]
     * import communityId from '@salesforce/community/Id';
     * import communityPath from '@salesforce/community/basePath';
     * 위 두개의 모듈 사용시 에러가 발생.
     * @class
     * @hideconstructor
     */
    CommunityUtil : {
        /**
         * Commuinity Site 여부 판단
         * @function
         * @returns {boolean} true or false
         */
        isCommunity : () => new RegExp("/s/").test(window.location.toString())
    },

    /**
     * javascript Type을 정의하는 Utils
     * @class
     * @hideconstructor
     */
    TypeUtil : {
        /**
         * String 여부
         * @function
         * @param {any} value - 판단 파라미터값
         * @returns {boolean} true or false
         */
        isString : (value) => {
            return typeof value === 'string' || value instanceof String;
        },

        /**
         * Number 여부
         * @type function
         * @function
         * @param {any} value - 판단 파라미터값
         * @returns {boolean} true or false
         */
        isNumber : (value) => {
            return typeof value === 'number' && isFinite(value);
        },

        /**
         * Object 여부
         * @type function
         * @function
         * @param {any} value - 판단 파라미터값
         * @returns {boolean} true or false
         */
        isObject : (value) => {
            return value && typeof value === 'object' && value.constructor === Object;
        },

        /**
         * Array 여부
         * @type function
         * @function
         * @param {any} value - 판단 파라미터값
         * @returns {boolean} true or false
         */
        isArray : (value) => {
            return value && typeof value === 'object' && value.constructor === Array;
        },

        /**
         * Boolean 여부
         * @type function
         * @function
         * @param {any} value - 판단 파라미터값
         * @returns {boolean} true or false
         */
        isBoolean : (value) => {
            return typeof value === 'boolean';
        },

        /**
         * Date 여부
         * @type function
         * @function
         * @param {any} value - 판단 파라미터값
         * @returns {boolean} true or false
         */
        isDate : (value) => {
            return value instanceof Date;
        },

        /**
         * Function 여부
         * @type function
         * @function
         * @param {any} value - 판단 파라미터값
         * @returns {boolean} true or false
         */
        isFunction : (value) => {
            return typeof value === 'function';
        },

        /**
         * Null 여부
         * @type function
         * @function
         * @param {any} value - 판단 파라미터값
         * @returns {boolean} true or false
         */
        isNull : (value) => {
            return value === null;
        },

        /**
         * Undefined 여부
         * @type function
         * @function
         * @param {any} value - 판단 파라미터값
         * @returns {boolean} true or false
         */
        isUndefined : (value) => {
            return typeof value === 'undefined';
        },

        /**
         * Error 여부
         * @type function
         * @function
         * @param {any} value - 판단 파라미터값
         * @returns {boolean} true or false
         */
        isError : (value) => {
            return value instanceof Error && typeof value.message !=='undefined';
        },

        /**
         * 정규식 여부
         * @type function
         * @function
         * @param {any} value - 판단 파라미터값
         * @returns {boolean} true or false
         */
        isRegExp : (value) => {
            return value && typeof value === 'object' && value.constructor === RegExp;
        }
    },

    /**
     * ProxyUtil : Proxy 객체 핸들링 Util만 적용
     * @class
     * @hideconstructor
     */
    ProxyUtil : {
        // TODO : 2021-02-18    JSON method를 사용하지 않고 하는 방식 deepClone
        /**
         * Proxy 객체를 일반 객체 또는 배열로 변환
         * 주로 로깅시 Proxy를 변환하여 로깅 처리
         * proxyData가 null, undefined 인 경우는 parse 에러가 발생
         * 따라서 빈 스트링으로 리턴[유의]
         * @example : this.ProxyUtil.toObject(this, proxyData)
         * @param thisArg {Object} thisArg - this 파라미터 객체
         * @param proxyData {Proxy} proxyData - Proxy된 데이터 객체
         * @returns {any}
         */
        // toObject: (proxyData) => {
        //     return !!proxyData ? JSON.parse(JSON.stringify(proxyData), null, 2) : '';
        // }

        /**
         * Proxy 객체를 일반 Object 변환
         * @type function
         * @function
         * @param {Object} thisArg - this 파라미터 객체
         * @param proxyData {Proxy} proxyData - Proxy된 데이터 객체
         * @returns {boolean} true or false
         * @example : this.ProxyUtil.toObject(this, proxyData)
         */
        toObject: (thisArg, proxyData) => {
            return !!proxyData ? LwcComUtil.ComUtil.deepClone(thisArg, proxyData) : '';
        }
    },

    /**
     * ArrayUtil : 자주 사용하는 Array 관련 Util만 적용
     * 기본은 Pure Javascript의 Array 객체를 이용
     * @class
     * @hideconstructor
     */
    ArrayUtil : {
        /**
         * array 여부
         * @param {any} target - 비교 대상 객체
         * @returns {boolean} true or false
         * @example this.ArrayUtil.isArray(target)
         */
        isArray: (target) => {
            return Array.isArray(target);
        },
        /**
         * Array Not Empty 여부
         * @param {any[]} arr - 비교 대상 객체
         * @returns {boolean} true or false
         * @example this.ArrayUtil.isNotEmpty(arr)
         */
        isNotEmpty: (arr) => {
            return !LwcComUtil.PropertyUtil.isEmpty(arr);
        },
        /**
         * Array Empty 여부
         * @param {any[]} arr - 비교 대상 객체
         * @returns {boolean} true or false
         * @example this.ArrayUtil.isEmpty(arr)
         */
        isEmpty: (arr) => {
            return LwcComUtil.PropertyUtil.isEmpty(arr) || !LwcComUtil.ArrayUtil.isArray(arr) || (arr.length === 0);
        },
        /**
         * array인지 여부를 판단하여 array시 그대로 반환, 아닐 경우 array 생성
         * @param {any} target - array 생성 객체
         * @returns {*}
         * @example this.ArrayUtil.makeArray(target)
         */
        makeArray: (target) => {
            return LwcComUtil.ArrayUtil.isArray(target) ? target : [target];
        },

    },

    /**
     * DateUtil : 자주 사용하는 Date 관련 Util만 적용
     * 기본은 Pure Javascript의 Date 객체를 이용
     * @class
     * @hideconstructor
     */
    DateUtil : {
        /**
         * Date 여부
         * @param {any} target - Date 여부 판단 대상
         * @returns {boolean} true or false
         * @example this.DateUtil.isDate(target)
         */
        isDate: (target) => {
            switch (typeof target) {
                case 'number':
                    return true;
                case 'string':
                    return !isNaN(Date.parse(target));
                case 'object':
                    if (value instanceof Date) {
                        return !isNaN(target.getTime());
                    }
                default:
                    return false;
            }
        },

        /**
         * 오늘 Date를 구함
         * @returns {Date}
         * @example this.DateUtil.getToday()
         */
        getToday: () => {
            return new Date();
        },

        /**
         * ISO(UTC) 기준시 리턴
         * @returns {string}
         * @example this.DateUtil.getISOToday()
         */
        getISOToday: () => {
            return new Date().toISOString();
        },
    },

    /**
     * ElementUtil : 자주 사용하는 Elements 관련 Util만 적용
     * @class
     * @hideconstructor
     */
    ElementUtil : {
        /**
         * this.template.querySelectorAll 로 넘겨온 elements를 일반 array로 변환 리턴
         * @param {Element[]} elements : this.template.querySelectorAll - Element 배열
         * @returns {any[]}
         */
        makeArrayQuerySelectorAllElement: (elements) => {
            return Array.from(elements);
        },

        /**
         * this.template.querySelectorAll 로 넘겨온 elements의 value 값을 배열로 넘김
         * @param elements : this.template.querySelectorAll
         * @returns any[]}
         */
        getInputCheckedValues: (elements) => {
            return this.makeArrayQuerySelectorAllElement
                .filter(element => element.checked)
                .map(element => element.value);
        },

        /**
         * options 배열을 생성
         * @param {any[]} picklistValues : getPicklistValues.data.values - picklist 값들로 Options 생성
         * @returns {any[]}
         */
        makeOptions: (picklistValues=[]) => {
            return Object.entries(picklistValues)
                .map(picklistValue => ({'label': picklistValue[1].label, 'value': picklistValue[1].value}));
        },

        /**
         * 상위 picklist 에서 선택된 값의 dependent picklist의 값을 구함
         * @param {string[]}dependentPicklist - 컨트롤러 선택된 값에 의존적인 picklist
         * @param {string} controllerSelectedValue - 컨트롤러 선택된 값
         * @returns {any[]}
         */
        getDependentPicklist: (dependentPicklist, controllerSelectedValue) => {
            return dependentPicklist.values.filter(values => {
                if(values.validFor.includes(dependentPicklist.controllerValues[controllerSelectedValue])) {
                    return values;
                }
            });
        },

        /**
         * 상위 picklist 에서 선택된 값의 dependent picklist의 값을 구하여 options를 생성
         * @param {string[]}dependentPicklist - 컨트롤러 선택된 값에 의존적인 picklist
         * @param {string} controllerSelectedValue - 컨트롤러 선택된 값
         * @returns {any[]}
         */
        makeDependentPicklistOptions: (dependentPicklist, controllerSelectedValue) => {
            return LwcComUtil.ElementUtil.makeOptions(this.getDependentPicklist(dependentPicklist, controllerSelectedValue));
        }
    },

    /**
     * class 안의 property 관련 Util
     * @class
     * @hideconstructor
     */
    PropertyUtil : {
        /**
         * property가 empty인지 여부
         * @param {any} target - 판단 대상
         * @returns {boolean}
         * @example this.PropertyUtil.isEmpty(target)
         */
        isEmpty: (target) => {
            return (target === undefined || target === null);
        },

        /**
         * property가 not empty인지 여부
         * @param {any} target - 판단 대상
         * @returns {boolean}
         * @example this.PropertyUtil.isNotEmpty(target)
         */
        isNotEmpty: (target) => {
            return !LwcComUtil.PropertyUtil.isEmpty(target);
        },

        /**
         * class 안의 property의 true, false는 string으로 변환되어 저장이 됨.
         * 따라서 javascript 안에서 property를 바로 true, false 비교시 문제가 됨
         * 따라서, 비교시 이 함수를 호출하여 비교할 것
         * @param {any} trueOrFalseString - boolean 으로 판단되는 대상값
         * @returns {boolean|any}
         * @example this.PropertyUtil.isTrue(trueOrFalseString)
         */
        isTrue: (trueOrFalseString) => {
            if(LwcComUtil.PropertyUtil.isEmpty(trueOrFalseString))  return false;
            return JSON.parse(trueOrFalseString);
        },

        /**
         * 해당 필드에 기본값이 undefined or null 인 경우 기본값 세팅
         * @param {any} target - 판단 대상값
         * @param {any} defaultValue - 디폴트 값
         * @returns any
         */
        setDefault: (target, defaultValue='') => {
            return LwcComUtil.PropertyUtil.isEmpty(target) ? defaultValue : target;
        }
    },

    /**
     * Apex 호출 관련 Util
     * @class
     * @hideconstructor
     */
    ApexUtil : {

        /**
         * [search 영역 조회 사용]페이징 처리 및 노페이징 Search 조회 파라미터 request params 생성
         * @param {Number} pageSize - 페이지 사이즈
         * @param {Number} pageNumber - 호출 페이지 번호
         * @param {Object} reqData - 호출 파라미터 객체
         * @returns {Object}
         * @example this.ApexUtil.createSearchReqParams(10, 1, {});
         */
        createSearchReqParams: (pageSize=10, pageNumber=1, reqData={}) => {
            return {
                [LwcComData.PagingData.gComReqDataParam.pageSize]:   pageSize,
                [LwcComData.PagingData.gComReqDataParam.pageNumber]: pageNumber,
                [LwcComData.PagingData.gComReqDataParam.reqData]:    reqData
            };
        },

        /**
         * [search 영역 조회 사용]기본 searchReqParams에 reqData를 추가적으로 세팅
         * @param {Object} reqParams - 호출을 위한 기본 파라미터 객체
         * @param {Object} reqData - 호출 파라미터 객체
         * @returns {Object} 세팅된 reqParams
         * @example this.ApexUtil.setSearchReqData(reqParams, this.getFilterValue());
         */
        setSearchReqData: (reqParams=LwcComUtil.ApexUtil.createSearchReqParams(), reqData={}) => {
            reqParams[LwcComData.PagingData.gComReqDataParam.reqData] = reqData;
            return reqParams;
        }
    },

    /**
     * Window 관련 Util
     * @class
     * @hideconstructor
     */
    WindowUtil : {
        /**
         * 현재 uri의 queryString을 map으로 전환
         * @param {string} queryString - 현재 URI의 queryString
         * @returns {{}} : Object 리턴
         */
        getURIParams: (queryString=window.location.search) => {
            const hashes = queryString.slice(queryString.indexOf('?') + 1).split('&');
            const params = {};

            for (const hash of hashes) {
                const [key, val] = hash.split('=');
                //==================================================================
                // hashes : 빈문자열을 split 하면 배열에 공백이 들어가서 length가 1이 됨
                // 빈값의 key가 존재하므로 체크하여 key 값이 존재할 경우에만 세팅
                //==================================================================
                if(key) {
                    params[key] = decodeURIComponent(val);
                }
            }

            return params;
        },
    },

    /**
     * Logging 관련 Util
     * @class
     * @hideconstructor
     */
    LogUtil : {

        /**
         * 전체 로깅 show / hide 여부
         * @type {boolean}
         */
        isShow: true,

        /**
         * 서버단 호출 로깅 처리.
         * [유의]lwcComBase 안에서만 사용함.
         *
         * @param {Object} funcs - 로깅처리 정보 Object
         * @param {Object} logs - 로깅 대상 객체
         * @param {boolean} isDisplay - 로깅 display 여부
         * @param {boolean} isError - 에러여부
         * @example this.LogUtil.comLog(null, {error: isLogJSON ? this.ProxyUtil.toObject(error) : error}, this.LogUtil.isShow, true);
         */
        comLog: (funcs, logs, isDisplay=LwcComUtil.LogUtil.isShow, isError=false) => {
            if(isDisplay) {
                isError || console.group('%c'+ funcs.startFuncName+ ' -> ' + funcs.endFuncName, 'color:blue');
                for (let key in logs) {
                    console.info('%c'+key, 'color:red', logs[key]);
                }
                isError || console.groupEnd();
            }
        },

        /**
         * 일반 업무 공통 로깅
         * @param {any[]} args - 로깅 처리 대상
         * @example this.LogUtil.log('addCallback called....', params);
         */
        log: (...args) => {
            LwcComUtil.LogUtil.isShow && console.log(...args);
        }
    },

    /**
     * Client 관련 Util
     * @class
     * @hideconstructor
     */
    ClientUtil : {
        /**
         * 실행 O/S 명 구함
         * @param {window} window - window 객체
         * @returns {string}
         * @example this.ClientUtil.getOperatingSystem();
         */
        getOperatingSystem : (window = window) => {
            let operatingSystem = 'Unknown';
            if (window && window.navigator.appVersion.indexOf('Win') !== -1)      { operatingSystem = 'Windows'; }
            else if (window && window.navigator.appVersion.indexOf('Mac') !== -1)      { operatingSystem = 'Mac'; }
            else if (window && window.navigator.appVersion.indexOf('X11') !== -1)      { operatingSystem = 'UNIX'; }
            else if (window && window.navigator.appVersion.indexOf('Linux') !== -1)    { operatingSystem = 'Linux'; }
            return operatingSystem;
        },

        /**
         * 실행 Browser 구함
         * @param {window} window - window 객체
         * @returns {string}
         * @example this.ClientUtil.getBrowser();
         */
        getBrowser : (window = window) => {
            let currentBrowser = 'Unknown';
            if (window && window.navigator.userAgent.indexOf('Chrome') !== -1)        { currentBrowser = 'Chrome'; }
            else if (window && window.navigator.userAgent.indexOf('Firefox') !== -1)  { currentBrowser = 'Firefox'; }
            else if (window && window.navigator.userAgent.indexOf('MSIE') !== -1)     { currentBrowser = 'IE'; }
            else if (window && window.navigator.userAgent.indexOf('Edge') !== -1)     { currentBrowser = 'Edge'; }
            else if (window && window.navigator.userAgent.indexOf('Safari') !== -1)   { currentBrowser = 'Safari'; }
            else if (window && window.navigator.userAgent.indexOf('Opera') !== -1)    { currentBrowser = 'Opera'; }
            else { console.log('Others'); }

            return currentBrowser;
        }
    },

    /**
     * CSV 관련 Util
     * @class
     * @hideconstructor
     * @deprecated
     * @see lwcComService.js 참조
     */
    CsvUtil : {
        /**
         * Single Table csv export
         * row data 기반 export
         * @param fileName
         * @param targetTable
         * @deprecated
         * @see lwcComService.js 참조
         */
        exportCsv : ({fileName='csvfile', targetTable}) => {
            let tableContent = targetTable.innerHTML.replace(/<(\/a|a)([^>]*)>/gi,"");

            let utf8Heading = "<meta http-equiv=\"content-type\" content=\"application/vnd.ms-excel; charset=UTF-8\">";
            let uri = 'data:application/vnd.ms-excel;base64;chartset=UTF-8,';
            let template = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40">' + utf8Heading + '<head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body><table>{table}</table></body></html>';

            let base64 = function (s) {
                return window.btoa(unescape(encodeURIComponent(s)))
            };

            let format = function (s, c) {
                return s.replace(/{(\w+)}/g, function (m, p) {
                    return c[p];
                });
            };

            let ctx =  {
                worksheet: name || 'Worksheet',
                table: tableContent,
            };

            let a = document.createElement("a");
            a.href = uri + base64(format(template, ctx));
            a.download = fileName;
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
        },

        /**
         * Single Table csv export
         * checkbox 혹은 component 등의 그려지지 않는 data를 임의로 세팅해서 그려내는 기능
         * @param fileName
         * @param targetTheadList
         * @param customTheadList
         * @param recordList
         * @param callbackFn
         * @deprecated
         * @see lwcComService.js 참조
         */
        exportCsvWithData : ({
                                 fileName='csvfile',
                                 targetTheadList=[],
                                 customTheadList=null,
                                 recordList=[],
                                 callbackFn
                             }) => {

            // tbody 매핑 callback 함수
            const callback = callbackFn;

            let thead = document.createElement("THEAD");

            //--------------------------------------------------------
            // thead 구성
            //--------------------------------------------------------
            if(customTheadList) {
                let theadList = customTheadList;
                theadList = !LwcComUtil.ArrayUtil.isEmpty(theadList) ? theadList : [theadList];

                theadList.forEach((item) => {
                    let th = document.createElement("TH");
                    th.innerText = item;
                    thead.appendChild(th);
                });
            }
            else {
                targetTheadList.forEach((item) => {
                    let th = document.createElement("TH");
                    th.innerText = item.innerHTML;
                    thead.appendChild(th);
                });
            }

            //--------------------------------------------------------
            // tbody 구성
            //--------------------------------------------------------

            let tbody = document.createElement("TBODY");

            recordList.forEach((item) => {
                tbody.appendChild(callback(item));
            });

            let table = document.createElement("TABLE");
            table.appendChild(thead);
            table.appendChild(tbody);

            //--------------------------------------------------------
            // 파일 다운로드
            //--------------------------------------------------------

            let utf8Heading = "<meta http-equiv=\"content-type\" content=\"application/vnd.ms-excel; charset=UTF-8\">";
            let uri = 'data:application/vnd.ms-excel;base64;chartset=UTF-8,';
            let template = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40">' + utf8Heading + '<head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body><table>{table}</table></body></html>';

            let base64 = function (s) {
                return window.btoa(unescape(encodeURIComponent(s)))
            };
            let format = function (s, c) {
                return s.replace(/{(\w+)}/g, function (m, p) {
                    return c[p];
                });
            };

            let ctx =  {
                worksheet: name || 'Worksheet',
                table: table.innerHTML,
            };

            let a = document.createElement("a");
            a.href = uri + base64(format(template, ctx));
            a.download = fileName;
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
        }
    }
}

export { LwcComUtil }