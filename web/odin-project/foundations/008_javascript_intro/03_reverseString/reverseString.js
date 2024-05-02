const reverseString = function (s) {
  let reversed = "";
  for (let i = s.length - 1; i >= 0; i--) {
    reversed += s[i];
  }

  return reversed;
};

// Do not edit below this line
module.exports = reverseString;
