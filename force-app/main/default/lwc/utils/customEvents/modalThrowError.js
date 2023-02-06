//notifies parent component about loading, error state
export const notifyProcessing = (component, state) => {
  const errorEvent = new CustomEvent("processing", {
    detail: {
      ...state
    }
  });

  component.dispatchEvent(errorEvent);
};