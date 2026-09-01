function fibonacci(number) {
  if (number < 2) return number;
  return fibonacci(number - 1) + fibonacci(number - 2);
}

function countPrimes(limit) {
  const isPrime = new Array(limit + 1).fill(true);
  isPrime[0] = false;
  isPrime[1] = false;
  for (let number = 2; number <= Math.sqrt(limit); number += 1) {
    if (isPrime[number]) {
      for (let multiple = number * number; multiple <= limit; multiple += number) {
        isPrime[multiple] = false;
      }
    }
  }
  return isPrime.filter(Boolean).length;
}

const fibonacciInput = Number(process.argv[2] || 35);
const primeLimit = Number(process.argv[3] || 200000);
const fibonacciStart = process.hrtime.bigint();
const fibonacciResult = fibonacci(fibonacciInput);
const fibonacciTime = Number(process.hrtime.bigint() - fibonacciStart) / 1e9;
const primeStart = process.hrtime.bigint();
const primeResult = countPrimes(primeLimit);
const primeTime = Number(process.hrtime.bigint() - primeStart) / 1e9;
console.log(`${fibonacciTime.toFixed(6)},${primeTime.toFixed(6)}`);
