/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 10-17-2022
 * @last modified by  : https://github.com/Eldor901
 **/

import { api, LightningElement } from "lwc";
import { submitForApproval } from "c/utils";

export default class SubmitForApprovalQucikAction extends LightningElement {
  @api recordId;

  @api async invoke() {
    await submitForApproval(this);
  }
}