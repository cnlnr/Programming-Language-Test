const std = @import("std");

fn nowNanoseconds() i128 {
	var counter: i64 = undefined;
	var frequency: i64 = undefined;
	_ = std.os.windows.ntdll.RtlQueryPerformanceCounter(&counter);
	_ = std.os.windows.ntdll.RtlQueryPerformanceFrequency(&frequency);
	return @divTrunc(@as(i128, counter) * 1_000_000_000, frequency);
}

fn fibonacci(number: i64) i64 { if (number < 2) return number; return fibonacci(number - 1) + fibonacci(number - 2); }
fn fibonacciIterative(number: i64) i64 { var previous: i64 = 0; var current: i64 = 1; var index: i64 = 0; while (index < number) : (index += 1) { const next = previous + current; previous = current; current = next; } return previous; }
fn countPrimes(limit: usize, allocator: std.mem.Allocator) !usize { const prime = try allocator.alloc(bool, limit + 1); @memset(prime, true); prime[0] = false; prime[1] = false; var number: usize = 2; while (number * number <= limit) : (number += 1) { if (prime[number]) { var multiple = number * number; while (multiple <= limit) : (multiple += number) { prime[multiple] = false; } } } var count: usize = 0; for (prime) |value| { if (value) { count += 1; } } return count; }
pub fn main(init: std.process.Init) !void { const arguments = try init.minimal.args.toSlice(init.arena.allocator()); const fibonacciInput = if (arguments.len > 1) try std.fmt.parseInt(i64, arguments[1], 10) else 37; const primeLimit = if (arguments.len > 2) try std.fmt.parseInt(usize, arguments[2], 10) else 2_000_000; const numericIterations = if (arguments.len > 3) try std.fmt.parseInt(i64, arguments[3], 10) else 100_000; const fibonacciStart = nowNanoseconds(); const fibonacciResult = fibonacci(fibonacciInput); const fibonacciTime = @as(f64, @floatFromInt(nowNanoseconds() - fibonacciStart)) / 1e9; const primeStart = nowNanoseconds(); const primeResult = try countPrimes(primeLimit, init.arena.allocator()); const primeTime = @as(f64, @floatFromInt(nowNanoseconds() - primeStart)) / 1e9; const numericStart = nowNanoseconds(); var numericResult: i64 = 0; var iteration: i64 = 0; while (iteration < numericIterations) : (iteration += 1) { numericResult += fibonacciIterative(fibonacciInput); } const iterativeNumericTime = @as(f64, @floatFromInt(nowNanoseconds() - numericStart)) / 1e9; if (numericResult < 0) return error.BenchmarkResultValidationFailed; std.debug.print("{d:.6},{d:.6},{d:.6},{d},{d},{d}\n", .{fibonacciTime, primeTime, iterativeNumericTime, fibonacciResult, primeResult, numericResult}); }
