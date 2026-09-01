import 'dart:math';
import 'dart:io';

int fibonacci(int number) {
  if (number < 2) return number;
  return fibonacci(number - 1) + fibonacci(number - 2);
}

int countPrimes(int limit) {
  final isPrime = List<bool>.filled(limit + 1, true);
  isPrime[0] = false; isPrime[1] = false;
  for (var number = 2; number <= sqrt(limit); number++) {
    if (isPrime[number]) {
      for (var multiple = number * number; multiple <= limit; multiple += number) isPrime[multiple] = false;
    }
  }
  return isPrime.where((value) => value).length;
}

void main(List<String> arguments) {
  final fibonacciInput = int.tryParse(arguments[0]) ?? 35;
  final primeLimit = int.tryParse(arguments[1]) ?? 200000;
  var start = Stopwatch()..start(); final fibonacciResult = fibonacci(fibonacciInput); start.stop(); final fibonacciTime = start.elapsedMicroseconds / 1e6;
  start = Stopwatch()..start(); final primeResult = countPrimes(primeLimit); start.stop(); final primeTime = start.elapsedMicroseconds / 1e6;
  print('${fibonacciTime.toStringAsFixed(6)},${primeTime.toStringAsFixed(6)}');
}
