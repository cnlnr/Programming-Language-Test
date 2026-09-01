import os
import time

fn fibonacci(number int) int { if number < 2 { return number }; return fibonacci(number - 1) + fibonacci(number - 2) }
fn count_primes(limit int) int { mut prime := []bool{len: limit + 1, init: true}; prime[0] = false; prime[1] = false; for number := 2; number * number <= limit; number++ { if prime[number] { for multiple := number * number; multiple <= limit; multiple += number { prime[multiple] = false } } }; mut count := 0; for value in prime { if value { count++ } }; return count }
fn main() { fibonacci_input := os.args[1].int(); prime_limit := os.args[2].int(); mut start := time.now(); _ := fibonacci(fibonacci_input); ft := time.now().unix_micro() - start.unix_micro(); start = time.now(); _ := count_primes(prime_limit); pt := time.now().unix_micro() - start.unix_micro(); println('${f64(ft) / 1000000.0},${f64(pt) / 1000000.0}') }
