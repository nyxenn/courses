const sumAll = function (a, b) {
  if (typeof a != "number" || typeof b != "number") return "ERROR";
  if (a < 0 || b < 0) return "ERROR";

  const max = Math.max(a, b);
  return ((max + 1) / 2) * max;
};

// Do not edit below this line
module.exports = sumAll;
