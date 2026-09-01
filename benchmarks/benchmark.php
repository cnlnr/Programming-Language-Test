<?php
function fibonacci(int $number): int {
    if ($number < 2) return $number;
    return fibonacci($number - 1) + fibonacci($number - 2);
}
function fibonacci_iterative(int $number): int { $previous = 0; $current = 1; for ($index = 0; $index < $number; $index++) { [$previous, $current] = [$current, $previous + $current]; } return $previous; }
function count_primes(int $limit): int {
    $isPrime = array_fill(0, $limit + 1, true);
    $isPrime[0] = false; $isPrime[1] = false;
    for ($number = 2; $number <= sqrt($limit); $number++) {
        if ($isPrime[$number]) {
            for ($multiple = $number * $number; $multiple <= $limit; $multiple += $number) $isPrime[$multiple] = false;
        }
    }
    return count(array_filter($isPrime));
}
$fibonacciInput = (int)($argv[1] ?? 37); $primeLimit = (int)($argv[2] ?? 2000000); $numericIterations = (int)($argv[3] ?? 100000);
$start = hrtime(true); $fibonacciResult = fibonacci($fibonacciInput); $fibonacciTime = (hrtime(true) - $start) / 1e9;
$start = hrtime(true); $primeResult = count_primes($primeLimit); $primeTime = (hrtime(true) - $start) / 1e9;
$start = hrtime(true); $numericResult = 0; for ($iteration = 0; $iteration < $numericIterations; $iteration++) $numericResult += fibonacci_iterative($fibonacciInput); $iterativeNumericTime = (hrtime(true) - $start) / 1e9;
if ($numericResult < 0) exit(1); printf("%.6f,%.6f,%.6f,%d,%d,%d\n", $fibonacciTime, $primeTime, $iterativeNumericTime, $fibonacciResult, $primeResult, $numericResult);
