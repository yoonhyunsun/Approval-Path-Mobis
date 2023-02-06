/****************************************************************************************
 * Project Name : Hyundai Mobis
 * File Name    : lwcUfwHeader
 * Description  :
 * Copyright    : Copyright © 2022 I2max. All Rights Reserved.
 * Author       : I2MAX
 * Created Date : 2022-05-12
 ****************************************************************************************/
import {api, track, wire} from 'lwc';
import { LwcComBase } from 'c/lwcComBase';

export default class LwcUfwHeader extends LwcComBase {
    @api iconName;
    @api type;
    @api title;
    @api condition1 = false;
    @api condition2 = false;
    @api condition3 = false;

    // Community 여부
    isCommunity = this.gComIsCommunity;
}