fibonacci <- function(number) { if (number < 2) return(number); fibonacci(number - 1) + fibonacci(number - 2) }
fibonacci_iterative <- function(number) { previous <- 0; current <- 1; for (index in seq_len(number)) { next_value <- previous + current; previous <- current; current <- next_value }; previous }
count_primes <- function(limit) { prime <- rep(TRUE, limit + 1); prime[1:2] <- FALSE; for (number in 2:floor(sqrt(limit))) if (prime[number + 1]) prime[seq(number * number, limit, by = number) + 1] <- FALSE; sum(prime) }
arguments <- commandArgs(trailingOnly = TRUE)
fibonacci_input <- if (length(arguments) >= 1) as.integer(arguments[1]) else 37
prime_limit <- if (length(arguments) >= 2) as.integer(arguments[2]) else 2000000
numeric_iterations <- if (length(arguments) >= 3) as.integer(arguments[3]) else 100000
start <- proc.time()[3]; fibonacci_result <- fibonacci(fibonacci_input); fibonacci_time <- proc.time()[3] - start
start <- proc.time()[3]; prime_result <- count_primes(prime_limit); prime_time <- proc.time()[3] - start
start <- proc.time()[3]; numeric_result <- 0; for (iteration in seq_len(numeric_iterations)) numeric_result <- numeric_result + fibonacci_iterative(fibonacci_input); iterative_numeric_time <- proc.time()[3] - start
if (numeric_result < 0) stop("benchmark result validation failed")
cat(sprintf("%.6f", fibonacci_time), ",", sprintf("%.6f", prime_time), ",", sprintf("%.6f", iterative_numeric_time), ",", sprintf("%.0f", fibonacci_result), ",", sprintf("%.0f", prime_result), ",", sprintf("%.0f", numeric_result), "\n", sep = "")
