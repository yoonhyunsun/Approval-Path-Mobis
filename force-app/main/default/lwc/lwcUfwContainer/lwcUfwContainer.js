/****************************************************************************************
 * Project Name : Hyundai Mobis
 * File Name    : lwcUfwContainer
 * Description  :
 * Copyright    : Copyright © 2022 I2max. All Rights Reserved.
 * Author       : I2MAX
 * Created Date : 2022-05-12
 ****************************************************************************************/
import {api, track, wire} from 'lwc';
import { LwcComBase } from 'c/lwcComBase';

export default class LwcUfwContainer extends LwcComBase {
    //==================================================================
    // spinner 여부
    //==================================================================
    @api isSpinner = false;

    // Edit by jihoon
    @api customContentClass;
    @api customFooterClass;
    @api customQuickActionClass;

    /**
     * Content 영역 Custom Class 지정
     * @returns {*|string}
     */
    get getContentClass() {
        return !!this.customContentClass ? this.customContentClass : 'slds-p-top_medium'; // default
    }
    /**
     * Content 영역 Custom Class 지정
     * @returns {*|string}
     */
    get getFooterClass() {
        return !!this.customFooterClass ? this.customFooterClass : 'slds-p-top_medium'; // default
    }
    /**
     * Content 영역 Custom Class 지정
     * @returns {*|string}
     */
    get getQuickActionClass() {
        return !!this.customQuickActionClass ? this.customQuickActionClass : 'slds-p-top_medium'; // default
    }
}