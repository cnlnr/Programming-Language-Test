<?php
function fibonacci(int $number): int {
    if ($number < 2) return $number;
    return fibonacci($number - 1) + fibonacci($number - 2);
}
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
$fibonacciInput = (int)($argv[1] ?? 35); $primeLimit = (int)($argv[2] ?? 200000);
$start = hrtime(true); $fibonacciResult = fibonacci($fibonacciInput); $fibonacciTime = (hrtime(true) - $start) / 1e9;
$start = hrtime(true); $primeResult = count_primes($primeLimit); $primeTime = (hrtime(true) - $start) / 1e9;
printf("%.6f,%.6f\n", $fibonacciTime, $primeTime);
