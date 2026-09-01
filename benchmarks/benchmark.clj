(defn fibonacci [n]
  (if (< n 2)
    n
    (+ (fibonacci (- n 1)) (fibonacci (- n 2)))))

(defn fibonacci-iterative [n]
  (loop [previous 0, current 1, index n]
    (if (zero? index)
      previous
      (recur current (+ previous current) (dec index)))))

(defn count-primes [limit]
  (let [is-prime (boolean-array (inc limit) true)]
    (aset is-prime 0 false)
    (aset is-prime 1 false)
    (doseq [number (range 2 (inc (int (Math/sqrt limit))))]
      (when (aget is-prime number)
        (doseq [multiple (range (* number number) (inc limit) number)]
          (aset is-prime multiple false))))
    (count (filter identity (seq is-prime)))))

(defn benchmark [fibonacci-input prime-limit numeric-iterations]
  (let [start-fib (System/nanoTime)
        fib-result (fibonacci fibonacci-input)
        fib-time (/ (- (System/nanoTime) start-fib) 1e9)
        start-prime (System/nanoTime)
        prime-result (count-primes prime-limit)
        prime-time (/ (- (System/nanoTime) start-prime) 1e9)
        start-numeric (System/nanoTime)
        numeric-result (loop [sum 0, index 0]
                        (if (< index numeric-iterations)
                          (recur (+ sum (fibonacci-iterative fibonacci-input)) (inc index))
                          sum))
        numeric-time (/ (- (System/nanoTime) start-numeric) 1e9)]
    (println (format "%f,%f,%f,%d,%d,%d"
                     fib-time prime-time numeric-time
                     fib-result prime-result numeric-result))))

(def args (vec *command-line-args*))
(let [fibonacci-input (Integer/parseInt (nth args 0 "37"))
      prime-limit (Integer/parseInt (nth args 1 "2000000"))
      numeric-iterations (Integer/parseInt (nth args 2 "2000000"))]
  (benchmark fibonacci-input prime-limit numeric-iterations))
