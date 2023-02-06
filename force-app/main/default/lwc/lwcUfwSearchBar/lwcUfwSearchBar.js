/****************************************************************************************
 * Project Name : Hyundai Mobis
 * File Name    : lwcUfwSearchBar
 * Description  :
 * Copyright    : Copyright © 2022 I2max. All Rights Reserved.
 * Author       : I2MAX
 * Created Date : 2022-05-12
 ****************************************************************************************/
import { api, track, wire } from 'lwc';
import { LwcComBase } from 'c/lwcComBase';

export default class LwcUfwSearchBar extends LwcComBase {
    @api customClassName;

    get customClass() {
        return (this.customClassName) ? 'slds-list_horizontal ' + this.customClassName : 'slds-list_horizontal';
    }
}