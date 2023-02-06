/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 01-19-2023
 * @last modified by  : https://github.com/Eldor901
 **/
import { LightningElement, api } from "lwc";
import { translations } from "c/utils";
import myResource from "@salesforce/resourceUrl/approvalRuleDocument";

export default class ApprovalRuleDocument extends LightningElement {
  @api show;

  ruleDocument = myResource;

  labels = translations;
}