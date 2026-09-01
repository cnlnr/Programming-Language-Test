fibonacci <- function(number) { if (number < 2) return(number); fibonacci(number - 1) + fibonacci(number - 2) }
count_primes <- function(limit) { prime <- rep(TRUE, limit + 1); prime[1:2] <- FALSE; for (number in 2:floor(sqrt(limit))) if (prime[number + 1]) prime[seq(number * number, limit, by = number) + 1] <- FALSE; sum(prime) }
arguments <- commandArgs(trailingOnly = TRUE)
fibonacci_input <- if (length(arguments) >= 1) as.integer(arguments[1]) else 35
prime_limit <- if (length(arguments) >= 2) as.integer(arguments[2]) else 200000
start <- proc.time()[3]; fibonacci_result <- fibonacci(fibonacci_input); fibonacci_time <- proc.time()[3] - start
start <- proc.time()[3]; prime_result <- count_primes(prime_limit); prime_time <- proc.time()[3] - start
cat(sprintf("%.6f", fibonacci_time), ",", sprintf("%.6f", prime_time), "\n", sep = "")
