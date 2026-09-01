import System.CPUTime
import Control.Exception (evaluate)
import System.Environment (getArgs)

fibonacci :: Integer -> Integer
fibonacci number | number < 2 = number
                 | otherwise = fibonacci (number - 1) + fibonacci (number - 2)
countPrimes :: Int -> Int
countPrimes limit = length [number | number <- [2..limit], isPrime number]
  where isPrime number = all (\factor -> number `mod` factor /= 0) [2..floor (sqrt (fromIntegral number))]
seconds :: Integer -> Double
seconds value = fromIntegral value / 1.0e12
main :: IO ()
main = do
  arguments <- getArgs
  let fibonacciInput = if null arguments then 35 else read (head arguments)
      primeLimit = if length arguments < 2 then 200000 else read (arguments !! 1)
  start <- getCPUTime
  fr <- evaluate (fibonacci fibonacciInput)
  end <- getCPUTime
  primeStart <- getCPUTime
  pr <- evaluate (countPrimes primeLimit)
  primeEnd <- getCPUTime
  putStrLn $ show (seconds (end-start)) ++ "," ++ show (seconds (primeEnd-primeStart))
