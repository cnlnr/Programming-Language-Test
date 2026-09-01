package main

import (
    "fmt"
    "os"
    "strconv"
    "time"
)

func fibonacci(number int) int64 {
    if number < 2 { return int64(number) }
    return fibonacci(number-1) + fibonacci(number-2)
}

func fibonacciIterative(number int) int64 { previous, current := int64(0), int64(1); for index := 0; index < number; index++ { previous, current = current, previous+current }; return previous }

func countPrimes(limit int) int {
    isPrime := make([]bool, limit+1)
    for number := range isPrime { isPrime[number] = true }
    isPrime[0], isPrime[1] = false, false
    for number := 2; number*number <= limit; number++ {
        if isPrime[number] {
            for multiple := number*number; multiple <= limit; multiple += number { isPrime[multiple] = false }
        }
    }
    count := 0
    for _, prime := range isPrime { if prime { count++ } }
    return count
}

func main() {
    fibonacciInput := 37; primeLimit := 2000000; numericIterations := 100000
    if len(os.Args) > 1 { fibonacciInput, _ = strconv.Atoi(os.Args[1]) }; if len(os.Args) > 2 { primeLimit, _ = strconv.Atoi(os.Args[2]) }; if len(os.Args) > 3 { numericIterations, _ = strconv.Atoi(os.Args[3]) }
    start := time.Now(); fibonacciResult := fibonacci(fibonacciInput); fibonacciTime := time.Since(start).Seconds()
    start = time.Now(); primeResult := countPrimes(primeLimit); primeTime := time.Since(start).Seconds()
    start = time.Now(); numericResult := int64(0); for iteration := 0; iteration < numericIterations; iteration++ { numericResult += fibonacciIterative(fibonacciInput) }; iterativeNumericTime := time.Since(start).Seconds()
    if numericResult < 0 { panic("benchmark result validation failed") }; fmt.Printf("%.6f,%.6f,%.6f,%d,%d,%d\n", fibonacciTime, primeTime, iterativeNumericTime, fibonacciResult, primeResult, numericResult)
}
