export const hideModal = (component) => {
  const style = document.createElement("style");
  style.innerText = `.slds-modal__container {
          width: 0 !important;
          max-width: 0 !important;
      }`;
  component.template
    .querySelector("lightning-quick-action-panel")
    .appendChild(style);
};