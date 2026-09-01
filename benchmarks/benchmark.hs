import Control.Exception (evaluate)
import System.Environment (getArgs)
import Data.List (foldl')
import GHC.Clock (getMonotonicTimeNSec)

fibonacci :: Integer -> Integer
fibonacci number | number < 2 = number
                 | otherwise = fibonacci (number - 1) + fibonacci (number - 2)
fibonacciIterative :: Integer -> Integer
fibonacciIterative number = go number 0 1
  where go 0 previous _ = previous
        go remaining previous current = go (remaining - 1) current (previous + current)
{-# NOINLINE fibonacciIterative #-}

numericBenchmark :: Integer -> Integer -> Integer
numericBenchmark input iterations = foldl' (\total _ -> total + fibonacciIterative input) 0 [1 .. iterations]
{-# NOINLINE numericBenchmark #-}
countPrimes :: Int -> Int
countPrimes limit = length [number | number <- [2..limit], isPrime number]
  where isPrime number = all (\factor -> number `mod` factor /= 0) [2..floor (sqrt (fromIntegral number))]
main :: IO ()
main = do
  arguments <- getArgs
  let fibonacciInput = if null arguments then 37 else read (head arguments)
      primeLimit = if length arguments < 2 then 2000000 else read (arguments !! 1)
      numericIterations = if length arguments < 3 then 100000 else read (arguments !! 2)
  start <- getMonotonicTimeNSec
  fr <- evaluate (fibonacci fibonacciInput)
  end <- getMonotonicTimeNSec
  primeStart <- getMonotonicTimeNSec
  pr <- evaluate (countPrimes primeLimit)
  primeEnd <- getMonotonicTimeNSec
  numericStart <- getMonotonicTimeNSec
  numericResult <- evaluate (numericBenchmark fibonacciInput numericIterations)
  numericEnd <- getMonotonicTimeNSec
  let seconds startTime endTime = fromIntegral (endTime - startTime) / 1.0e9
  if numericResult < 0 then error "benchmark result validation failed" else putStrLn $ show (seconds start end) ++ "," ++ show (seconds primeStart primeEnd) ++ "," ++ show (seconds numericStart numericEnd) ++ "," ++ show fr ++ "," ++ show pr ++ "," ++ show numericResult
