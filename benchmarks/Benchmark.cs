using System;
class Benchmark {
    static long Fibonacci(int number) => number < 2 ? number : Fibonacci(number - 1) + Fibonacci(number - 2);
    static int CountPrimes(int limit) { var prime = new bool[limit + 1]; Array.Fill(prime, true); prime[0] = prime[1] = false; for (var number = 2; number * number <= limit; number++) if (prime[number]) for (var multiple = number * number; multiple <= limit; multiple += number) prime[multiple] = false; var count = 0; foreach (var value in prime) if (value) count++; return count; }
    static void Main(string[] args) { var fibonacciInput = args.Length > 0 ? int.Parse(args[0]) : 35; var primeLimit = args.Length > 1 ? int.Parse(args[1]) : 200000; var watch = System.Diagnostics.Stopwatch.StartNew(); var fr = Fibonacci(fibonacciInput); watch.Stop(); var ft = watch.Elapsed.TotalSeconds; watch.Restart(); var pr = CountPrimes(primeLimit); watch.Stop(); Console.WriteLine($"{ft:F6},{watch.Elapsed.TotalSeconds:F6}"); }
}
