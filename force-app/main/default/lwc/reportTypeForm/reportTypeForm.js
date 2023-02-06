/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 10-03-2022
 * @last modified by  : https://github.com/Eldor901
 **/
import { LightningElement, api } from "lwc";
export default class ReportTypeForm extends LightningElement {
  @api
  reportData;

  connectedCallback() {
    console.log(this.reportData);
  }
}