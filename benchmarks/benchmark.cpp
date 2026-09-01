#include <chrono>
#include <cmath>
#include <iostream>
#include <cstdlib>

long long fibonacci(int number) {
    if (number < 2) return number;
    return fibonacci(number - 1) + fibonacci(number - 2);
}

long long fibonacci_iterative(int number) {
    long long previous = 0;
    long long current = 1;
    for (int index = 0; index < number; ++index) {
        const long long next = previous + current;
        previous = current;
        current = next;
    }
    return previous;
}

int count_primes(int limit) {
    bool* is_prime = new bool[limit + 1];
    for (int number = 0; number <= limit; ++number) is_prime[number] = true;
    is_prime[0] = false;
    is_prime[1] = false;
    for (int number = 2; number <= std::sqrt(limit); ++number) {
        if (is_prime[number]) {
            for (int multiple = number * number; multiple <= limit; multiple += number) {
                is_prime[multiple] = false;
            }
        }
    }
    int result = 0;
    for (int number = 0; number <= limit; ++number) result += is_prime[number];
    delete[] is_prime;
    return result;
}

template <typename Function>
double timed(Function function, int argument, long long& result) {
    auto start = std::chrono::steady_clock::now();
    result = function(argument);
    auto end = std::chrono::steady_clock::now();
    return std::chrono::duration<double>(end - start).count();
}

int main(int argc, char** argv) {
    const int fibonacci_input = argc > 1 ? std::atoi(argv[1]) : 35;
    const int prime_limit = argc > 2 ? std::atoi(argv[2]) : 2000000;
    const int numeric_iterations = argc > 3 ? std::atoi(argv[3]) : 100000;
    long long fibonacci_result;
    long long prime_result;
    double fibonacci_time = timed(fibonacci, fibonacci_input, fibonacci_result);
    double prime_time = timed(count_primes, prime_limit, prime_result);
    const auto numeric_start = std::chrono::steady_clock::now();
    long long numeric_result = 0;
    for (int iteration = 0; iteration < numeric_iterations; ++iteration) numeric_result += fibonacci_iterative(fibonacci_input);
    const double iterative_numeric_time = std::chrono::duration<double>(std::chrono::steady_clock::now() - numeric_start).count();
    if (numeric_result < 0) return 1;
    std::cout << fibonacci_time << "," << prime_time << "," << iterative_numeric_time << "," << fibonacci_result << "," << prime_result << "," << numeric_result << "\n";
}
