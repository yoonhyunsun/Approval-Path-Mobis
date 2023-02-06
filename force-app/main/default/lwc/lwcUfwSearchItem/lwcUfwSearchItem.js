/****************************************************************************************
 * Project Name : Hyundai Mobis
 * File Name    : lwcUfwSearchItem
 * Description  :
 * Copyright    : Copyright © 2022 I2max. All Rights Reserved.
 * Author       : I2MAX
 * Created Date : 2022-05-12
 ****************************************************************************************/
import { api, track, wire } from 'lwc';
import { LwcComBase } from 'c/lwcComBase';

export default class LwcUfwSearchItem extends LwcComBase {
    @api label;

    // 자체 판단
    get hasLabel() {
        return !!this.label;
    }

    // label getter
    get labelName() {
        return (this.label) ? this.label : '';
    }
}