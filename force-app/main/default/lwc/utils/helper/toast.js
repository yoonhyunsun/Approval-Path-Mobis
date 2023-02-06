import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { translations } from "c/utils";

export const successToast = (name) => {
  const event = new ShowToastEvent({
    message: name ?? translations.SUCC_SAVE_RECORD,
    variant: "success"
  });

  return event;
};

export const errorToast = (message) => {
  const event = new ShowToastEvent({
    message: message,
    variant: "error"
  });

  return event;
};