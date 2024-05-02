const roundTo = function (value, decimals) {
  return Math.round(value * 10 ** decimals) / 10 ** decimals;
};

const convertToCelsius = function (f) {
  const converted = ((f - 32) * 5) / 9;
  return roundTo(converted, 1);
};

const convertToFahrenheit = function (c) {
  const converted = (c * 9) / 5 + 32;
  return roundTo(converted, 1);
};

// Do not edit below this line
module.exports = {
  convertToCelsius,
  convertToFahrenheit,
};
