#include <chrono>
#include <cmath>
#include <iostream>
#include <cstdlib>

long long fibonacci(int number) {
    if (number < 2) return number;
    return fibonacci(number - 1) + fibonacci(number - 2);
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
    const int prime_limit = argc > 2 ? std::atoi(argv[2]) : 200000;
    long long fibonacci_result;
    long long prime_result;
    double fibonacci_time = timed(fibonacci, fibonacci_input, fibonacci_result);
    double prime_time = timed(count_primes, prime_limit, prime_result);
    std::cout << fibonacci_time << "," << prime_time << "\n";
}
