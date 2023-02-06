/****************************************************************************************
 * Project Name : Hyundai Mobis
 * File Name    : lwcUfwContainerQa
 * Description  :
 * Copyright    : Copyright © 2022 I2max. All Rights Reserved.
 * Author       : I2MAX
 * Created Date : 2022-05-25
 ****************************************************************************************/

import {api,track,wire} from 'lwc';
import {LwcComBase} from "c/lwcComBase";

export default class LwcUfwContainerQa extends LwcComBase {
    /*
     * =============================================================================
     * =============================================================================
     * Property / getter, setter
     * =============================================================================
     * =============================================================================
     */
    /**
     * Modal QuickAction Show 여부
     * @type {boolean}
     */
    @api showModal = false;
    /**
     * Large Modal 여부
     * @type {boolean}
     */
    @api isLarge = false;
    /**
     * Medium Modal 여부
     * @type {boolean}
     */
    @api isMedium = false;

    /**
     * Custom Modal Container Style
     */
    @api modalContainerStyle;

    /**
     * Modal Footer 여부
     */
    @api isFootless = false;

    /**
     * Modal QuickAction 사이즈별 전체 Class 지정
     * @returns {string}
     */
    get clazz() {
        return (this.PropertyUtil.isTrue(this.isLarge))
            ? 'slds-modal slds-fade-in-open slds-modal--large'
            : ((this.PropertyUtil.isTrue(this.isMedium)) ? 'slds-modal slds-fade-in-open slds-modal_medium' : 'slds-modal slds-fade-in-open');
    }

    /**
     * Container Style 지정 시 반영
     * @returns {string|*}
     */
    get getModalContainerStyle() {
        return !this.modalContainerStyle ? 'width: 90%;' : this.modalContainerStyle;
    }

    /**
     * Footer 가 없으면 Content bottom 영역 border radius 추가
     */
    get getContentStyle() {
        return this.isFootless ? 'border-radius: 0 0 5px 5px;' : '';
    }

    /*
     * =============================================================================
     * =============================================================================
     * function 구현
     * fireXXX : custom 이벤트 발생
     * handleXXX : custom 이벤트 핸들러
     * doXXX : Server 데이터 조회
     * 그 외 함수는 업무에 맞게 구현
     * =============================================================================
     * =============================================================================
     */


    /*
     * =============================================================================
     * =============================================================================
     * lifecycle hooks
     * 업무에서는 필요시 override 처리하고,
     * super호출이 필요할 경우 super 호출후에 업무별 로직을 구현
     * constructor, connectedCallback, render, renderedCallback, disConnectedCallback
     * =============================================================================
     * =============================================================================
     */
    connectedCallback() {
        this.gfnComConnectedCallback(() => {
            this.addEventListener('ufw_model_close', (detail) => {
                this.showModal = detail.showModal;
            }, this);
        });
    }

}