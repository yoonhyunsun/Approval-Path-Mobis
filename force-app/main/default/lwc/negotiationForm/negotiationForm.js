/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 11-29-2022
 * @last modified by  : https://github.com/Eldor901
 **/
import { LightningElement, track, wire } from "lwc";
import getReportTypes from "@salesforce/apex/ApprovalProcessController.getReportTypes";
import { translations } from "c/utils";

export default class NegotiationForm extends LightningElement {
  value = "";
  @track
  nagotiationReports = [];

  @wire(getReportTypes)
  ApprovalProcessReportTypes({ data }) {
    if (data) {
      this.nagotiationReports = [...data.reportTypes.slice(-3)].map(
        ({ value, label }, index) => {
          if (index === 0)
            return {
              label: `${label}: ${translations.HELPER_TEXT_CLOSED_WON}`,
              value: value
            };

          if (index === 1)
            return {
              label: `${label}: ${translations.HELPER_TEXT_CLOSED_LOST}`,
              value: value
            };

          if (index === 2)
            return {
              label: `${label}:  ${translations.HELPER_TEXT_CANCELLED}`,
              value: value
            };

          return "";
        }
      );

      this.value = data.reportTypes[data.reportTypes.length - 3].value;

      const selectedEvent = new CustomEvent("change", {
        detail: data.reportTypes[data.reportTypes.length - 3].value
      });
      this.dispatchEvent(selectedEvent);
    }
  }

  handleChange(event) {
    const selectedEvent = new CustomEvent("change", {
      detail: event.detail.value
    });

    this.dispatchEvent(selectedEvent);
  }
}