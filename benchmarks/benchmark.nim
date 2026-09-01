import std/[math, monotimes, os, strutils, times]

proc fibonacci(number: int): int =
  if number < 2: return number
  fibonacci(number - 1) + fibonacci(number - 2)

proc countPrimes(limit: int): int =
  var prime = newSeq[bool](limit + 1)
  for value in prime.mitems: value = true
  prime[0] = false; prime[1] = false
  for number in 2..int(sqrt(float(limit))):
    if prime[number]:
      for multiple in countup(number * number, limit, number): prime[multiple] = false
  for value in prime: result += int(value)

let fibonacciInput = if paramCount() > 0: parseInt(paramStr(1)) else: 35
let primeLimit = if paramCount() > 1: parseInt(paramStr(2)) else: 200000
let start = getMonoTime(); let fibonacciResult = fibonacci(fibonacciInput); let fibonacciTime = inNanoseconds(getMonoTime() - start).float / 1_000_000_000.0
let primeStart = getMonoTime(); let primeResult = countPrimes(primeLimit); let primeTime = inNanoseconds(getMonoTime() - primeStart).float / 1_000_000_000.0
echo fibonacciTime, ",", primeTime
