function fibonacci(number)
  if number < 2 then return number end
  return fibonacci(number - 1) + fibonacci(number - 2)
end
function fibonacci_iterative(number)
  local previous, current = 0, 1
  for _ = 1, number do previous, current = current, previous + current end
  return previous
end
function count_primes(limit)
  local is_prime = {}
  for number = 0, limit do is_prime[number] = true end
  is_prime[0] = false; is_prime[1] = false
  for number = 2, math.floor(math.sqrt(limit)) do
    if is_prime[number] then
      for multiple = number * number, limit, number do is_prime[multiple] = false end
    end
  end
  local count = 0
  for number = 0, limit do if is_prime[number] then count = count + 1 end end
  return count
end
local fibonacci_input = tonumber(arg[1]) or 37; local prime_limit = tonumber(arg[2]) or 2000000; local numeric_iterations = tonumber(arg[3]) or 100000
local start = os.clock(); local fibonacci_result = fibonacci(fibonacci_input); local fibonacci_time = os.clock() - start
start = os.clock(); local prime_result = count_primes(prime_limit); local prime_time = os.clock() - start
start = os.clock(); local numeric_result = 0; for _ = 1, numeric_iterations do numeric_result = numeric_result + fibonacci_iterative(fibonacci_input) end; local iterative_numeric_time = os.clock() - start
if numeric_result < 0 then error('benchmark result validation failed') end
print(string.format("%.6f,%.6f,%.6f,%d,%d,%d", fibonacci_time, prime_time, iterative_numeric_time, fibonacci_result, prime_result, numeric_result))
