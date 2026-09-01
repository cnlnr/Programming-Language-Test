from time import perf_counter
import sys


def fibonacci(number: int) -> int:
    if number < 2:
        return number
    return fibonacci(number - 1) + fibonacci(number - 2)


def fibonacci_iterative(number: int) -> int:
    previous, current = 0, 1
    for _ in range(number):
        previous, current = current, previous + current
    return previous


def count_primes(limit: int) -> int:
    is_prime = [True] * (limit + 1)
    is_prime[0] = False
    is_prime[1] = False
    for number in range(2, int(limit ** 0.5) + 1):
        if is_prime[number]:
            for multiple in range(number * number, limit + 1, number):
                is_prime[multiple] = False
    return sum(is_prime)


def run_benchmark(function, argument: int) -> tuple[int, float]:
    start = perf_counter()
    result = function(argument)
    return result, perf_counter() - start


if __name__ == "__main__":
    fibonacci_input = int(sys.argv[1]) if len(sys.argv) > 1 else 37
    prime_limit = int(sys.argv[2]) if len(sys.argv) > 2 else 2_000_000
    numeric_iterations = int(sys.argv[3]) if len(sys.argv) > 3 else 100_000
    fibonacci_result, fibonacci_time = run_benchmark(fibonacci, fibonacci_input)
    prime_result, prime_time = run_benchmark(count_primes, prime_limit)
    start = perf_counter()
    numeric_result = 0
    for _ in range(numeric_iterations):
        numeric_result += fibonacci_iterative(fibonacci_input)
    iterative_numeric_time = perf_counter() - start
    print(f"{fibonacci_time:.6f},{prime_time:.6f},{iterative_numeric_time:.6f},{fibonacci_result},{prime_result},{numeric_result}")
