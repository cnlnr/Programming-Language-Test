package main
import "core:fmt"
import "core:os"
import "core:strconv"
import "core:time"
fibonacci :: proc(number: int) -> int { if number < 2 { return number }; return fibonacci(number - 1) + fibonacci(number - 2) }
count_primes :: proc(limit: int) -> int { prime := make([]bool, limit + 1); for &value in prime { value = true }; prime[0] = false; prime[1] = false; for number := 2; number * number <= limit; number += 1 { if prime[number] { for multiple := number * number; multiple <= limit; multiple += number { prime[multiple] = false } } }; count := 0; for value in prime { if value { count += 1 } }; return count }
main :: proc() {
	fibonacci_input := 35
	prime_limit := 200000
	if len(os.args) > 1 { fibonacci_input = strconv.atoi(os.args[1]) }
	if len(os.args) > 2 { prime_limit = strconv.atoi(os.args[2]) }
	fibonacci_start := time.now()
	_ = fibonacci(fibonacci_input)
	fibonacci_time := time.duration_seconds(time.diff(fibonacci_start, time.now()))
	prime_start := time.now()
	_ = count_primes(prime_limit)
	prime_time := time.duration_seconds(time.diff(prime_start, time.now()))
	fmt.println(fibonacci_time, ",", prime_time)
}
