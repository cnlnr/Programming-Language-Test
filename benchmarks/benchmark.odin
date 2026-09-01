package main
import "core:fmt"
import "core:os"
import "core:strconv"
import "core:time"
fibonacci :: proc(number: int) -> int { if number < 2 { return number }; return fibonacci(number - 1) + fibonacci(number - 2) }
fibonacci_iterative :: proc(number: int) -> int { previous, current := 0, 1; for index := 0; index < number; index += 1 { previous, current = current, previous + current }; return previous }
count_primes :: proc(limit: int) -> int { prime := make([]bool, limit + 1); for &value in prime { value = true }; prime[0] = false; prime[1] = false; for number := 2; number * number <= limit; number += 1 { if prime[number] { for multiple := number * number; multiple <= limit; multiple += number { prime[multiple] = false } } }; count := 0; for value in prime { if value { count += 1 } }; return count }
main :: proc() {
	fibonacci_input := 35
	prime_limit := 2000000
	numeric_iterations := 100000
	if len(os.args) > 1 { fibonacci_input = strconv.atoi(os.args[1]) }
	if len(os.args) > 2 { prime_limit = strconv.atoi(os.args[2]) }
	if len(os.args) > 3 { numeric_iterations = strconv.atoi(os.args[3]) }
	fibonacci_start := time.now()
	fibonacci_result := fibonacci(fibonacci_input)
	fibonacci_time := time.duration_seconds(time.diff(fibonacci_start, time.now()))
	prime_start := time.now()
	prime_result := count_primes(prime_limit)
	prime_time := time.duration_seconds(time.diff(prime_start, time.now()))
	numeric_start := time.now(); numeric_result := 0; for iteration := 0; iteration < numeric_iterations; iteration += 1 { numeric_result += fibonacci_iterative(fibonacci_input) }; iterative_numeric_time := time.duration_seconds(time.diff(numeric_start, time.now()))
	if numeric_result < 0 { panic("benchmark result validation failed") }
	fmt.println(fibonacci_time, ",", prime_time, ",", iterative_numeric_time, ",", fibonacci_result, ",", prime_result, ",", numeric_result)
}
