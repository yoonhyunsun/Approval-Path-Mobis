/****************************************************************************************
 * Project Name : Hyundai Mobis
 * File Name    : lwcUfwHeaderQa
 * Description  :
 * Copyright    : Copyright © 2022 I2max. All Rights Reserved.
 * Author       : I2MAX
 * Created Date : 2022-05-25
 ****************************************************************************************/

import {api,track} from 'lwc';
import {LwcComBase} from "c/lwcComBase";

const CSS_CLASS = 'modal-hidden';

export default class LwcUfwHeaderQa extends LwcComBase {

    /*
 * =============================================================================
 * =============================================================================
 * Property / getter, setter
 * =============================================================================
 * =============================================================================
 */
    /**
     * QA Header String
     */
    @api headerString;

    /**
     * 우상단 close 버튼 제거여부 private
     * @type {boolean}
     * @private
     */
    _removeCloseIcon = false;

    /**
     * 우상단 close 버튼 제거여부
     * @returns {boolean}
     */
    @api
    get removeCloseIcon() {
        return this._removeCloseIcon;
    }
    set removeCloseIcon(value) {
        this._removeCloseIcon = this.PropertyUtil.isTrue(value);
    }

    /**
     * Header String 존재 여부
     * @returns {boolean}
     */
    get hasHeaderString() {
        return !!this.headerString;
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
    /**
     * Modal Popup Close
     */
    handleDialogClose() {
        this.gfnComFireDispatch('ufw_model_close', {
            showModal: false
        });
    }

    /**
     * 정확한 기능은 나중에 기술
     */
    handleSlotTaglineChange() {
        const taglineEl = this.template.querySelector('p');
        taglineEl.classList.remove(CSS_CLASS);
    }

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
}