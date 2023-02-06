/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 10-26-2022
 * @last modified by  : https://github.com/Eldor901
 **/
import { LightningElement } from "lwc";

export default class SaveFavoriteModal extends LightningElement {
  handleSave() {
    this.close(true);
  }

  handleCancel() {
    this.close(false);
  }
}