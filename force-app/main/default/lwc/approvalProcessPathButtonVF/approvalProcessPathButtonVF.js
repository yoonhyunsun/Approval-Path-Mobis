/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 12-09-2022
 * @last modified by  : Bekhzod Ubaydullaev
 **/
import { LightningElement, api } from "lwc";
import LightningAlert from "lightning/alert";
import { editorFromats, translations } from "c/utils";
export default class ApprovalProcessPathButtonVF extends LightningElement {
  @api uid;
  showChild = true;

  actionResult = "";
  alertTheme = "";

  labels = translations;

  showComment = false;
  action;
  comment = "";
  formats = editorFromats;

  handleRichTextChange(e) {
    this.comment = e.detail.value;
  }

  async alertShow() {
    await LightningAlert.open({
      message: "",
      theme: this.alertTheme,
      label: this.actionResult
    });
  }

  closeCommentBlock() {
    this.showComment = false;
  }

  saveComment() {
    this.approveOrReject(this.uid, this.action, this.comment);
    this.showComment = false;
  }

  handleApproveClick() {
    this.showComment = true;
    this.action = "Approved";
  }

  handleRejectClick() {
    this.showComment = true;
    this.action = "Rejected";
  }

  approveOrReject(uid, action, comment) {
    var reqBody = {
      uid: uid,
      action: action,
      comment: comment
    };

    var endPoint = "/approve/services/apexrest/ApprovalAction/";

    //get request
    fetch(endPoint, {
      method: "POST",
      headers: {
        "Content-Type": "application/json; charset=utf-8"
      },

      body: JSON.stringify(reqBody)
    })
      .then((response) => {
        if (!response.ok) {
          this.error = response;
        }

        if (response.status !== 200) {
          this.hasError = true;
          this.alertTheme = "error";
        } else {
          this.showChild = false;
          this.alertTheme = "success";
        }

        return response.json();
      })
      .then((jsonResponse) => {
        this.actionResult = jsonResponse.result;
        this.alertShow();
      })
      .catch((error) => {
        this.error = error;
      });
  }
}