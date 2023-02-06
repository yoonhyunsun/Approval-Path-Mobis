export const debounce = (callback, wait) => {
  let timerId;
  return (...args) => {
    clearTimeout(timerId);
    // eslint-disable-next-line @lwc/lwc/no-async-operation
    timerId = setTimeout(() => {
      callback(...args);
    }, wait);
  };
};