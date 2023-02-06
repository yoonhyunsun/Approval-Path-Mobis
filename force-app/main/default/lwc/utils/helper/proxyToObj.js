export const proxyToObj = (obj) => {
  return JSON.parse(JSON.stringify(obj));
};