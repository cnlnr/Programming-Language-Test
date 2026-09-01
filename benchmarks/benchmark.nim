import std/[math, monotimes, os, strutils, times]

proc fibonacci(number: int): int =
  if number < 2: return number
  fibonacci(number - 1) + fibonacci(number - 2)

proc fibonacciIterative(number: int): int =
  var previous = 0
  var current = 1
  for _ in 0..<number: (previous, current) = (current, previous + current)
  previous

proc countPrimes(limit: int): int =
  var prime = newSeq[bool](limit + 1)
  for value in prime.mitems: value = true
  prime[0] = false; prime[1] = false
  for number in 2..int(sqrt(float(limit))):
    if prime[number]:
      for multiple in countup(number * number, limit, number): prime[multiple] = false
  for value in prime: result += int(value)

let fibonacciInput = if paramCount() > 0: parseInt(paramStr(1)) else: 37
let primeLimit = if paramCount() > 1: parseInt(paramStr(2)) else: 2_000_000
let numericIterations = if paramCount() > 2: parseInt(paramStr(3)) else: 100_000
let start = getMonoTime()
let fibonacciResult = fibonacci(fibonacciInput)
let fibonacciTime = inNanoseconds(getMonoTime() - start).float / 1_000_000_000.0
let primeStart = getMonoTime()
let primeResult = countPrimes(primeLimit)
let primeTime = inNanoseconds(getMonoTime() - primeStart).float / 1_000_000_000.0
let numericStart = getMonoTime()
var numericResult = 0
for _ in 0..<numericIterations:
  numericResult += fibonacciIterative(fibonacciInput)
let iterativeNumericTime = inNanoseconds(getMonoTime() - numericStart).float / 1_000_000_000.0
if numericResult < 0: quit("benchmark result validation failed", 1)
echo fibonacciTime, ",", primeTime, ",", iterativeNumericTime, ",", fibonacciResult, ",", primeResult, ",", numericResult
