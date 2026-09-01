function fibonacci(number)
  if number < 2 then return number end
  return fibonacci(number - 1) + fibonacci(number - 2)
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
local fibonacci_input = tonumber(arg[1]) or 35; local prime_limit = tonumber(arg[2]) or 200000
local start = os.clock(); local fibonacci_result = fibonacci(fibonacci_input); local fibonacci_time = os.clock() - start
start = os.clock(); local prime_result = count_primes(prime_limit); local prime_time = os.clock() - start
print(string.format("%.6f,%.6f", fibonacci_time, prime_time))
