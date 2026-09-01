function fibonacci(n::Int)
    if n < 2
        return n
    end
    return fibonacci(n - 1) + fibonacci(n - 2)
end

function fibonacci_iterative(n::Int)
    previous = 0
    current = 1
    for _ in 1:n
        previous, current = current, previous + current
    end
    return previous
end

function count_primes(limit::Int)
    is_prime = trues(limit + 1)
    is_prime[1] = false
    is_prime[2] = false
    for number in 2:isqrt(limit)
        if is_prime[number + 1]
            for multiple in (number * number):number:limit
                is_prime[multiple + 1] = false
            end
        end
    end
    return count(is_prime[3:end])
end

function main()
    args = length(ARGS) >= 3 ? ARGS : ["37", "2000000", "2000000"]
    fibonacci_input = parse(Int, args[1])
    prime_limit = parse(Int, args[2])
    numeric_iterations = parse(Int, args[3])

    start = time_ns()
    fibonacci_result = fibonacci(fibonacci_input)
    fibonacci_time = (time_ns() - start) / 1e9

    start = time_ns()
    prime_result = count_primes(prime_limit)
    prime_time = (time_ns() - start) / 1e9

    start = time_ns()
    numeric_result = 0
    for _ in 1:numeric_iterations
        numeric_result += fibonacci_iterative(fibonacci_input)
    end
    iterative_time = (time_ns() - start) / 1e9

    println(string(fibonacci_time, ",", prime_time, ",", iterative_time, ",", fibonacci_result, ",", prime_result, ",", numeric_result))
end

main()
