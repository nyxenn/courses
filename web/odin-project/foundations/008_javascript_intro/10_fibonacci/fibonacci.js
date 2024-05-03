let cache = [];

const fibonacci = function (n) {
  if (cache[n]) return cache[n];

  n = +n;
  if (n === NaN || n < 0) return "OOPS";
  if (n < 2) return n;

  const num = fibonacci(n - 1) + fibonacci(n - 2);
  cache[n] = num;
  return num;
};

// Do not edit below this line
module.exports = fibonacci;
