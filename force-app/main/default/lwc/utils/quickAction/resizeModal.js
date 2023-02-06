export const resizeModal = (component) => {
  const style = document.createElement("style");
  style.innerText = `.slds-modal__container {
        width: 95% !important;
        max-width: 95% !important;
        min-width: 95% !important;
    }`;
  component.template.querySelector("lightning-modal-base").appendChild(style);
};