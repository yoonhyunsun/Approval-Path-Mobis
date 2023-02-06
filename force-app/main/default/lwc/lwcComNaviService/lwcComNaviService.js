/****************************************************************************************
 * Project Name : Hyundai Mobis
 * File Name    : lwcComNaviService
 * Description  :
 * Copyright    : Copyright © 2022 I2max. All Rights Reserved.
 * Author       : I2MAX
 * Created Date : 2022-05-12
 ****************************************************************************************/
import {NavigationMixin} from 'lightning/navigation';
import {ShowToastEvent} from "lightning/platformShowToastEvent";
import {LwcComUtil} from 'c/lwcComUtil';

/**
 * 공통 Navigation Service
 * @class
 * @hideconstructor
 */
const LwcComNaviService = {

    /**
     * 기본적인 PageReference 이용
     * @function
     * @param {object} self - this parameter 객체
     * @param {object} pageReference - 개발자 세팅 pageReference 객체
     * @param {boolean} isUrl - generatorUrl 이용하여 별도 window 로 open 여부
     * @since 1.0.0
     */
    gfnSvcNaviByPageReference : (self, pageReference= LwcComNaviService.toastNoParam(self), isUrl=false) => {
        if(!pageReference) {
            return;
        }

        !isUrl ? self[NavigationMixin.Navigate](pageReference) : self[NavigationMixin.GenerateUrl](pageReference).then(url => window.open(url));
    },

    /**
     * PageReference Type : standard__objectPage
     * In communities, list and home are the same
     * @function
     * @param {object} self - this parameter 객체
     * @param {string} objectApiName - SObject API 명
     * @param {string} actionName - 적용한 action명(list, home, new)
     * @param {object} state - 부가 state 정보
     * @param {boolean} isUrl - generatorUrl 이용하여 별도 window 로 open 여부
     * @since 1.0.0
     */
    gfnSvcNaviByStdObjectPage : (self, objectApiName= LwcComNaviService.toastNoParam(self), actionName='list', state = {}, isUrl=false) => {
        if(!objectApiName) {
            return;
        }

        if(!isUrl) {
            self[NavigationMixin.Navigate]({
                type: 'standard__objectPage',
                attributes: {
                    objectApiName: objectApiName,
                    actionName: actionName
                },
                state: state
            });
        } else {
            self[NavigationMixin.GenerateUrl]({
                type: 'standard__objectPage',
                attributes: {
                    objectApiName: objectApiName,
                    actionName: actionName
                },
                state: state
            }).then(url => window.open(url));
        }
    },

    /**
     * PageReference Type : standard__recordPage
     * Communities only support view
     * @function
     * @param {object} self - this parameter 객체
     * @param {string} recordId - recordId
     * @param {string} actionName - 적용한 action명(view, edit, clone)
     * @param {string} objApi - SObject API
     * @param {object} state - 부가 state 정보
     * @param {boolean} isUrl - generatorUrl 이용하여 별도 window 로 open 여부
     * @since 1.0.0
     */
    gfnSvcNaviByStdRecordPage : (self, recordId=LwcComNaviService.toastNoParam(self), actionName='view', objApi='', state = {}, isUrl=false) => {
        if(!recordId) {
            return;
        }

        if(!isUrl) {
            self[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: recordId,
                    objectApiName: objApi,
                    actionName: actionName
                },
                state: state
            });
        } else {
            self[NavigationMixin.GenerateUrl]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: recordId,
                    objectApiName: objApi,
                    actionName: actionName
                },
                state: state
            }).then(url => window.open(url));
        }
    },

    /**
     * PageReference Type : standard__navItemPage
     * @function
     * @param {object} self - this parameter 객체
     * @param {string} apiName - tab name
     * @param {object} state - 부가 state 정보
     * @param {boolean} isUrl - generatorUrl 이용하여 별도 window 로 open 여부
     * @since 1.0.0
     */
    gfnSvcNaviByStdNaviItemPage : (self, apiName=LwcComNaviService.toastNoParam(self), state = {}, isUrl=false) => {
        if(!apiName) {
            return;
        }

        if(!isUrl) {
            self[NavigationMixin.Navigate]({
                type: 'standard__navItemPage',
                attributes: {
                    apiName: apiName
                },
                state: state
            });
        } else {
            self[NavigationMixin.GenerateUrl]({
                type: 'standard__navItemPage',
                attributes: {
                    apiName: apiName
                },
                state: state
            }).then(url => window.open(url));
        }
    },

    /**
     * PageReference Type : standard__namedPage
     * [lightning experience 용]
     * @function
     * @param {object} self - this parameter 객체
     * @param {string} pageName - 적용한 page 명 (home, chatter)
     * @param {object} state - 부가 state 정보
     * @param {boolean} isUrl - generatorUrl 이용하여 별도 window 로 open 여부
     * @since 1.0.0
     */
    gfnSvcNaviByStdNamedPage : (self, pageName=LwcComNaviService.toastNoParam(self), state = {}, isUrl=false) => {
        if(!isUrl) {
            self[NavigationMixin.Navigate]({
                type: 'standard__namedPage',
                attributes: {
                    pageName: pageName
                },
                state: state
            });
        } else {
            self[NavigationMixin.GenerateUrl]({
                type: 'standard__namedPage',
                attributes: {
                    pageName: pageName
                },
                state: state
            }).then(url => window.open(url));
        }
    },

    /**
     * PageReference Type : comm__namedPage
     * [community 용]
     * @function
     * @param {object} self - this parameter 객체
     * @param {string} name - community page name
     * @param {object} state - 부가 state 정보
     * @param {boolean} isUrl - generatorUrl 이용하여 별도 window 로 open 여부
     * @since 1.0.0
     */
    gfnSvcNaviByCommNamedPage : (self, name=LwcComNaviService.toastNoParam(self), state = {}, isUrl=false) => {
        if(!name) {
            return;
        }

        if(!isUrl) {
            self[NavigationMixin.Navigate]({
                type: 'comm__namedPage',
                attributes: {
                    name: name
                },
                state: state
            });
        } else {
            self[NavigationMixin.GenerateUrl]({
                type: 'comm__namedPage',
                attributes: {
                    name: name
                },
                state: state
            }).then(url => window.open(url));
        }
    },

    /**
     * PageReference Type : mix standard__namedPage and comm__namedPage
     * @function
     * @param {object} self - this parameter 객체
     * @param {string} name - page name
     * @param {object} state - 부가 state 정보
     * @param {boolean} isUrl - generatorUrl 이용하여 별도 window 로 open 여부
     * @since 1.0.0
     */
    gfnSvcNaviByNamedPage : (self, name=LwcComNaviService.toastNoParam(self), state={}, isUrl=false) => {
        LwcComUtil.ComUtil.isCommunity() ? LwcComNaviService.gfnSvcNaviByCommNamedPage(self, name, state, isUrl) : LwcComNaviService.gfnSvcNaviByStdNamedPage(self, name, state, isUrl);
    },

    /**
     * pageReference type : standard__webPage
     * @function
     * @param {object} self - this parameter 객체
     * @param {string} url - url
     * @since 1.0.0
     */
    gfnSvcNaviByWebPage : (self, url=LwcComNaviService.toastNoParam(self)) => {
        self[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: url
            }
        });
    },

    /**
     * 내부적으로 사용 : Show toast, when missing parameter
     * @function
     * @private
     * @param {object} self - this parameter 객체
     */
    toastNoParam : (self) => {
        self.dispatchEvent(new ShowToastEvent({
            message: 'Missing parameter',
            variant: 'error',
            mode: 'dismissible'
        }));

        return false;
    }

}

export { LwcComNaviService };