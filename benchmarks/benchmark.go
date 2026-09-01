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
    fibonacciInput, _ := strconv.Atoi(os.Args[1]); primeLimit, _ := strconv.Atoi(os.Args[2])
    start := time.Now(); fibonacciResult := fibonacci(fibonacciInput); fibonacciTime := time.Since(start).Seconds()
    start = time.Now(); primeResult := countPrimes(primeLimit); primeTime := time.Since(start).Seconds()
    _ = fibonacciResult
    _ = primeResult
    fmt.Printf("%.6f,%.6f\n", fibonacciTime, primeTime)
}
