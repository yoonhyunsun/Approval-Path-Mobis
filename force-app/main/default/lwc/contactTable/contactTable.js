/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 01-05-2023
 * @last modified by  : https://github.com/Eldor901
 **/
import { enumerate, proxyToObj, translations } from "c/utils";
import { api, LightningElement } from "lwc";

export default class ContactTable extends LightningElement {
  @api contacts;
  @api selectedContacts;

  labels = translations;

  get allContacts() {
    if (!this.contacts) return this.contacts;

    const contacts = proxyToObj(this.contacts);
    const selectedContacts = proxyToObj(this.selectedContacts);

    const filteredContacts = contacts.filter(
      (contact) =>
        !selectedContacts
          .map((selectedContact) => selectedContact.Id)
          .includes(contact.Id)
    );

    return enumerate(filteredContacts);
  }

  onUserClick(event) {
    const userId = event.currentTarget.dataset.id;

    const user = this.contacts.find((el) => el.Id === userId);

    const userEvet = new CustomEvent("userclick", {
      detail: user
    });

    this.dispatchEvent(userEvet);
  }
}