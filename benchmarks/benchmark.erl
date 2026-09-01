#!/usr/bin/env escript
main(Args) ->
    FibonacciInput = argument(Args, 1, 35),
    PrimeLimit = argument(Args, 2, 200000),
    Start = erlang:monotonic_time(microsecond), FR = fibonacci(FibonacciInput), FT = (erlang:monotonic_time(microsecond) - Start) / 1000000,
    Start2 = erlang:monotonic_time(microsecond), PR = count_primes(PrimeLimit), PT = (erlang:monotonic_time(microsecond) - Start2) / 1000000,
    io:format("~.6f,~.6f~n", [FT, PT]).

argument(Args, Position, Default) ->
    case lists:nthtail(Position - 1, Args) of
        [Value | _] -> list_to_integer(Value);
        [] -> Default
    end.
fibonacci(N) when N < 2 -> N;
fibonacci(N) -> fibonacci(N - 1) + fibonacci(N - 2).
count_primes(Limit) -> count_primes(2, Limit, 0).
count_primes(Number, Limit, Count) when Number > Limit -> Count;
count_primes(Number, Limit, Count) -> count_primes(Number + 1, Limit, Count + case prime(Number) of true -> 1; false -> 0 end).
prime(Number) -> prime(Number, 2).
prime(Number, Factor) when Factor * Factor > Number -> true;
prime(Number, Factor) -> Number rem Factor =/= 0 andalso prime(Number, Factor + 1).
