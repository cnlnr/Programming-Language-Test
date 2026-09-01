program benchmark
  implicit none
  integer :: fib_input, prime_limit, numeric_iterations
  integer(kind=8) :: fib_result, prime_result, numeric_result
  real :: fib_time, prime_time, numeric_time
  real :: start_time, end_time
  character(len=32) :: arg1, arg2, arg3

  if (command_argument_count() >= 3) then
    call get_command_argument(1, arg1)
    call get_command_argument(2, arg2)
    call get_command_argument(3, arg3)
    read(arg1, *) fib_input
    read(arg2, *) prime_limit
    read(arg3, *) numeric_iterations
  else
    fib_input = 37
    prime_limit = 2000000
    numeric_iterations = 2000000
  end if

  call cpu_time(start_time)
  fib_result = fibonacci(fib_input)
  call cpu_time(end_time)
  fib_time = end_time - start_time

  call cpu_time(start_time)
  prime_result = count_primes(prime_limit)
  call cpu_time(end_time)
  prime_time = end_time - start_time

  call cpu_time(start_time)
  numeric_result = 0_8
  do while (numeric_iterations > 0)
    numeric_result = numeric_result + fibonacci_iterative(fib_input)
    numeric_iterations = numeric_iterations - 1
  end do
  call cpu_time(end_time)
  numeric_time = end_time - start_time

  print '(F0.6, ",", F0.6, ",", F0.6, ",", I0, ",", I0, ",", I0)', &
        fib_time, prime_time, numeric_time, fib_result, prime_result, numeric_result

contains

  recursive integer(kind=8) function fibonacci(n) result(value)
    integer, intent(in) :: n
    if (n < 2) then
      value = n
    else
      value = fibonacci(n - 1) + fibonacci(n - 2)
    end if
  end function fibonacci

  integer(kind=8) function fibonacci_iterative(n) result(value)
    integer, intent(in) :: n
    integer :: index
    integer(kind=8) :: previous, current, next_value
    previous = 0_8
    current = 1_8
    do index = 1, n
      next_value = previous + current
      previous = current
      current = next_value
    end do
    value = previous
  end function fibonacci_iterative

  integer(kind=8) function count_primes(limit) result(total)
    integer, intent(in) :: limit
    logical, allocatable :: is_prime(:)
    integer :: number, multiple
    allocate(is_prime(0:limit))
    is_prime = .true.
    is_prime(0) = .false.
    if (limit >= 1) is_prime(1) = .false.
    do number = 2, int(sqrt(real(limit)))
      if (is_prime(number)) then
        do multiple = number * number, limit, number
          is_prime(multiple) = .false.
        end do
      end if
    end do
    total = count(is_prime)
    deallocate(is_prime)
  end function count_primes

end program benchmark
