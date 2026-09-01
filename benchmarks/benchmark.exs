defmodule Benchmark do
  def fibonacci(n) when n < 2, do: n
  def fibonacci(n), do: fibonacci(n - 1) + fibonacci(n - 2)

  def fibonacci_iterative(n) do
    {result, _} =
      Enum.reduce(1..n, {0, 1}, fn _, {prev, curr} ->
        {curr, prev + curr}
      end)

    result
  end

  def count_primes(limit) do
    is_prime =
      Enum.map(0..limit, fn index ->
        index >= 2
      end)
      |> List.to_tuple()

    Enum.reduce(2..trunc(:math.sqrt(limit)), is_prime, fn number, acc ->
      if elem(acc, number) do
        Enum.reduce((number * number)..limit//number, acc, fn multiple, inner_acc ->
          :erlang.setelement(multiple + 1, inner_acc, false)
        end)
      else
        acc
      end
    end)
    |> Tuple.to_list()
    |> Enum.with_index()
    |> Enum.count(fn {value, idx} -> value and idx >= 2 end)
  end

  def run(fibonacci_input, prime_limit, numeric_iterations) do
    start = System.monotonic_time(:nanosecond)
    fib_result = fibonacci(fibonacci_input)
    fib_time = (System.monotonic_time(:nanosecond) - start) / 1_000_000_000.0

    start = System.monotonic_time(:nanosecond)
    prime_result = count_primes(prime_limit)
    prime_time = (System.monotonic_time(:nanosecond) - start) / 1_000_000_000.0

    start = System.monotonic_time(:nanosecond)
    numeric_result =
      Enum.reduce(1..numeric_iterations, 0, fn _, acc ->
        acc + fibonacci_iterative(fibonacci_input)
      end)

    numeric_time = (System.monotonic_time(:nanosecond) - start) / 1_000_000_000.0

    IO.puts(Enum.join([
      :erlang.float_to_binary(fib_time, decimals: 6),
      :erlang.float_to_binary(prime_time, decimals: 6),
      :erlang.float_to_binary(numeric_time, decimals: 6),
      Integer.to_string(fib_result),
      Integer.to_string(prime_result),
      Integer.to_string(numeric_result)
    ], ","))
  end
end

[fibonacci_input, prime_limit, numeric_iterations] =
  System.argv()
  |> Enum.map(&String.to_integer/1)

Benchmark.run(fibonacci_input, prime_limit, numeric_iterations)
