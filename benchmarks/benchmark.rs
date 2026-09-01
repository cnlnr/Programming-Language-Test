use std::time::Instant;

fn fibonacci(number: i32) -> i64 {
    if number < 2 { return i64::from(number); }
    fibonacci(number - 1) + fibonacci(number - 2)
}

fn fibonacci_iterative(number: i32) -> i64 {
    let mut previous = 0;
    let mut current = 1;
    for _ in 0..number {
        let next = previous + current;
        previous = current;
        current = next;
    }
    previous
}

fn count_primes(limit: usize) -> usize {
    let mut is_prime = vec![true; limit + 1];
    is_prime[0] = false;
    is_prime[1] = false;
    for number in 2..=((limit as f64).sqrt() as usize) {
        if is_prime[number] {
            for multiple in (number * number..=limit).step_by(number) { is_prime[multiple] = false; }
        }
    }
    is_prime.into_iter().filter(|value| *value).count()
}

fn main() {
    let arguments: Vec<String> = std::env::args().collect();
    let fibonacci_input = arguments.get(1).and_then(|value| value.parse().ok()).unwrap_or(35);
    let prime_limit = arguments.get(2).and_then(|value| value.parse().ok()).unwrap_or(200000);
    let numeric_iterations = arguments.get(3).and_then(|value| value.parse().ok()).unwrap_or(100000);
    let start = Instant::now(); let fibonacci_result = fibonacci(fibonacci_input); let fibonacci_time = start.elapsed().as_secs_f64();
    let start = Instant::now(); let prime_result = count_primes(prime_limit); let prime_time = start.elapsed().as_secs_f64();
    let start = Instant::now();
    let mut numeric_result = 0;
    for _ in 0..numeric_iterations { numeric_result += fibonacci_iterative(fibonacci_input); }
    let iterative_numeric_time = start.elapsed().as_secs_f64();
    if numeric_result < 0 { panic!("benchmark result validation failed"); }
    println!("{:.6},{:.6},{:.6},{},{},{}", fibonacci_time, prime_time, iterative_numeric_time, fibonacci_result, prime_result, numeric_result);
}
