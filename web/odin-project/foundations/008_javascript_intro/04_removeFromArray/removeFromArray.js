const removeFromArray = function (arr, ...val) {
  let filtered = [];
  for (let i = 0; i < arr.length; i++) {
    if (val.includes(arr[i])) continue;

    filtered.push(arr[i]);
  }

  return filtered;
};

// Do not edit below this line
module.exports = removeFromArray;
