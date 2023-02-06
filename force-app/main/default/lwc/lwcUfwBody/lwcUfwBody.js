/****************************************************************************************
 * Project Name : Hyundai Mobis
 * File Name    : lwcUfwBody
 * Description  :
 * Copyright    : Copyright © 2022 I2max. All Rights Reserved.
 * Author       : I2MAX
 * Created Date : 2022-05-12
 ****************************************************************************************/
import { api, track, wire } from 'lwc';
import { LwcComBase } from 'c/lwcComBase';

export default class LwcUfwBody extends LwcComBase {
    // @api hasSearchSection = false;

    _hasSearchSection = false;

    @api
    get hasSearchSection() {
        return this._hasSearchSection;
    };
    set hasSearchSection(value) {
        this._hasSearchSection = this.PropertyUtil.isTrue(value);
    };
}