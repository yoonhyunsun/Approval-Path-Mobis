/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 01-13-2023
 * @last modified by  : https://github.com/Eldor901
 **/
import { LightningElement, api } from "lwc";

export default class CustomModal extends LightningElement {
  @api header;
  @api showmodal = false;
}