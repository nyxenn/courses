const palindromes = function (s) {
  const a = "a".charCodeAt(0);
  const z = "z".charCodeAt(0);
  const zero = "0".charCodeAt(0);
  const nine = "9".charCodeAt(0);

  const filtered = Array.from(s.toLowerCase())
    .map((x) => x.charCodeAt(0))
    .filter((x) => (x >= zero && x <= nine) || (x >= a && x <= z));

  let is_palindrome = true;
  for (let i = 0; i <= Math.floor(filtered.length / 2); i++) {
    if (filtered[i] === filtered[filtered.length - i - 1]) continue;
    is_palindrome = false;
  }

  return is_palindrome;
};

// Do not edit below this line
module.exports = palindromes;
