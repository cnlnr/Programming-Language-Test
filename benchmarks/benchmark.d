import std.stdio;
import std.datetime.stopwatch;
import std.conv : to;
import core.runtime : Runtime;

pragma(inline, false)
void validateResults(long fibonacciResult, int primeResult) {
	if (fibonacciResult < 0 || primeResult < 0) {
		throw new Exception("benchmark result validation failed");
	}
}

long fibonacci(int number) {
	if (number < 2) return number;
	return fibonacci(number - 1) + fibonacci(number - 2);
}

int countPrimes(int limit) {
	auto prime = new bool[limit + 1];
	prime[] = true;
	prime[0] = prime[1] = false;
	for (int number = 2; number * number <= limit; number++) {
		if (prime[number]) {
			for (int multiple = number * number; multiple <= limit; multiple += number) {
				prime[multiple] = false;
			}
		}
	}
	int count;
	foreach (value; prime) count += value;
	return count;
}

void main() {
	auto arguments = Runtime.args;
	auto fibonacciInput = arguments.length > 1 ? to!int(arguments[1]) : 40;
	auto primeLimit = arguments.length > 2 ? to!int(arguments[2]) : 1_000_000;
	auto timer = StopWatch();
	timer.start();
	auto fibonacciResult = fibonacci(fibonacciInput);
	timer.stop();
	auto fibonacciTime = timer.peek.total!"usecs" / 1_000_000.0;
	timer.reset();
	timer.start();
	auto primeResult = countPrimes(primeLimit);
	timer.stop();
	auto primeTime = timer.peek.total!"usecs" / 1_000_000.0;
	validateResults(fibonacciResult, primeResult);
	writefln("%.6f,%.6f", fibonacciTime, primeTime);
}
