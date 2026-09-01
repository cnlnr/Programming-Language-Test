def fibonacci(number)
  return number if number < 2
  fibonacci(number - 1) + fibonacci(number - 2)
end

def fibonacci_iterative(number)
  previous, current = 0, 1
  number.times { previous, current = current, previous + current }
  previous
end

def count_primes(limit)
  is_prime = Array.new(limit + 1, true)
  is_prime[0] = is_prime[1] = false
  (2..Math.sqrt(limit).to_i).each do |number|
    next unless is_prime[number]
    (number * number..limit).step(number) { |multiple| is_prime[multiple] = false }
  end
  is_prime.count(true)
end

fibonacci_input = (ARGV[0] || 37).to_i
prime_limit = (ARGV[1] || 2000000).to_i
numeric_iterations = (ARGV[2] || 100000).to_i
start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
fibonacci_result = fibonacci(fibonacci_input)
fibonacci_time = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start
start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
prime_result = count_primes(prime_limit)
prime_time = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start
start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
numeric_result = 0
numeric_iterations.times { numeric_result += fibonacci_iterative(fibonacci_input) }
iterative_numeric_time = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start
raise 'benchmark result validation failed' if numeric_result.negative?
puts "#{format('%.6f', fibonacci_time)},#{format('%.6f', prime_time)},#{format('%.6f', iterative_numeric_time)},#{fibonacci_result},#{prime_result},#{numeric_result}"
