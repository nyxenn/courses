const findTheOldest = function (people) {
  let oldest;
  let oldest_age;

  people.forEach((p) => {
    if (p.yearOfDeath == undefined) return;

    const age = p.yearOfDeath - p.yearOfBirth;
    if (age <= oldest_age) return;

    oldest = p;
    oldest_age = age;
  });

  return oldest;
};

// Do not edit below this line
module.exports = findTheOldest;
