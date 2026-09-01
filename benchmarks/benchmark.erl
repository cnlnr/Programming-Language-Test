#!/usr/bin/env escript
main(Args) ->
    FibonacciInput = argument(Args, 1, 35),
    PrimeLimit = argument(Args, 2, 2000000),
    NumericIterations = argument(Args, 3, 100000),
    Start = erlang:monotonic_time(microsecond), FR = fibonacci(FibonacciInput), FT = (erlang:monotonic_time(microsecond) - Start) / 1000000,
    Start2 = erlang:monotonic_time(microsecond), PR = count_primes(PrimeLimit), PT = (erlang:monotonic_time(microsecond) - Start2) / 1000000,
    NumericStart = erlang:monotonic_time(microsecond), NumericResult = lists:sum([fibonacci_iterative(FibonacciInput) || _ <- lists:seq(1, NumericIterations)]), NT = (erlang:monotonic_time(microsecond) - NumericStart) / 1000000,
    if NumericResult < 0 -> erlang:error(benchmark_result_validation_failed); true -> io:format("~.6f,~.6f,~.6f,~B,~B,~B~n", [FT, PT, NT, FR, PR, NumericResult]) end.

argument(Args, Position, Default) ->
    case lists:nthtail(Position - 1, Args) of
        [Value | _] -> list_to_integer(Value);
        [] -> Default
    end.
fibonacci(N) when N < 2 -> N;
fibonacci(N) -> fibonacci(N - 1) + fibonacci(N - 2).
fibonacci_iterative(N) -> fibonacci_iterative(N, 0, 1).
fibonacci_iterative(0, Previous, _) -> Previous;
fibonacci_iterative(N, Previous, Current) -> fibonacci_iterative(N - 1, Current, Previous + Current).
count_primes(Limit) -> count_primes(2, Limit, 0).
count_primes(Number, Limit, Count) when Number > Limit -> Count;
count_primes(Number, Limit, Count) -> count_primes(Number + 1, Limit, Count + case prime(Number) of true -> 1; false -> 0 end).
prime(Number) -> prime(Number, 2).
prime(Number, Factor) when Factor * Factor > Number -> true;
prime(Number, Factor) -> Number rem Factor =/= 0 andalso prime(Number, Factor + 1).
