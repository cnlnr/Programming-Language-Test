import 'dart:math';
import 'dart:io';

int fibonacci(int number) {
  if (number < 2) return number;
  return fibonacci(number - 1) + fibonacci(number - 2);
}
int fibonacciIterative(int number) { var previous = 0; var current = 1; for (var index = 0; index < number; index++) { final next = previous + current; previous = current; current = next; } return previous; }

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
  final primeLimit = int.tryParse(arguments[1]) ?? 2000000;
  final numericIterations = int.tryParse(arguments[2]) ?? 100000;
  var start = Stopwatch()..start(); final fibonacciResult = fibonacci(fibonacciInput); start.stop(); final fibonacciTime = start.elapsedMicroseconds / 1e6;
  start = Stopwatch()..start(); final primeResult = countPrimes(primeLimit); start.stop(); final primeTime = start.elapsedMicroseconds / 1e6;
  start = Stopwatch()..start(); var numericResult = 0; for (var iteration = 0; iteration < numericIterations; iteration++) numericResult += fibonacciIterative(fibonacciInput); start.stop(); final iterativeNumericTime = start.elapsedMicroseconds / 1e6;
  if (numericResult < 0) throw StateError('benchmark result validation failed');
  print('${fibonacciTime.toStringAsFixed(6)},${primeTime.toStringAsFixed(6)},${iterativeNumericTime.toStringAsFixed(6)},$fibonacciResult,$primeResult,$numericResult');
}
