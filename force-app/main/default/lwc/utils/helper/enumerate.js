export const enumerate = (obj) => {
  const newObj = [...obj];

  for (let i = 0; i < newObj.length; i++) {
    newObj[i].Order = i + 1;
  }

  return newObj;
};