;1.1
(* 6 5)
(+ 5 3 4)
(- 9 1)
(/ 6 2)
(+ (* 2 4) (- 4 6))

(define a 3)
(define b (+ a 1))
(+ a b (* a b))
(not (= a b))
(if (and (> b a) (< b (* a b)))
    b
    a
    )
(cond ((= a 4) 6)
      ((= b 4) (+ 6 7 a))
      (else 25))
(+ 2 (if (> b a) b a))
(* (cond ((> a b) a)
         ((< a b) b)
         (else -1))
   (+ a 1))

;1.2
(/ (+ 5 4 (- 2 (- 3 (+ 6 (/ 4 5)))))
   (* 3 (- 6 2) (- 2 7)))

;1.3
(define (square x) (* x x))
(define (sum_of_squares x y) (+ (square x) (square y)))
(define (procedure1_3 a b c)
	(cond ((and (<= a b) (<= a c)) (sum_of_squares b c))
	      ((and (<= b a) (<= b c)) (sum_of_squares a c))
	      (else (sum_of_squares a b))))
(procedure1_3 3 2 1)

;1.4
(define (a-plus-abs-b a b)
  ((if (> b 0) + -) a b))
(a-plus-abs-b 3 4)
(a-plus-abs-b 3 -4)
(a-plus-abs-b 3 -4.55)

;1.5
(define (p) (p))
(define (test x y)
  (if (= x 0) 0 y))
(test 0 (p))
;Infinite runtime here. Why? Because to evaluate (test param0 param1), the interpreter
;first has to evaluate param0 and param1, sequentially. 0 is evaluated to 0, of course;
;then function (p) is evaluated. Function (p) is defined as a funtion that calls itself,
;thus this is a recursive function without termination condition. It never ends.

;computing square root of x
(define (sqrt x)
  (sqrt-iter 1.0 x))  ; always guess the square root is 1.0 at the beginning
(define (sqrt-iter guess x) 
  (if (good-enough? guess x) guess  ; if the guess is good enough, return the value guess 
      (sqrt-iter (improve-guess guess x) x)))  ; otherwise, improve the guess and proceed to the next iteration
(define (good-enough? guess x) 
  (< (abs (- (* guess guess) x)) 0.001))  ; |guess * guess - x| < 0.001?
(define (abs x) 
  (if (> x 0) x (- x)))
(define (improve-guess guess x)  ; improvement := (guess + x / guess) / 2 
  (/ (+ guess (/ x guess)) 2))

(sqrt 9)

;1.6
(define (new-if predicate then-clause else-clause) 
  (cond (predicate then-clause)
        (else else-clause)))
(new-if (= 3 2) 1 0)
(new-if (= 3 3) 1 0)

(define (sqrt-iter guess x) 
  (new-if (good-enough? guess x) guess  ; if the guess is good enough, return the value guess 
      (sqrt-iter (improve-guess guess x) x)))  ; otherwise, improve the guess and proceed to the next iteration

(sqrt 1)
;Infinite runtime here. Again, (new-if predicate then-clause else-clause) is a self-defined function. To evaluate
;this function, firstly the interpreter must evaluate predicate, then-clause, else-clause, sequentially. Here
;predicate is (good-enough? guess x), then-clause is guess, both easy to evaluate; however, the else-clause is 
;again a recursive function without termination condition, so it never ends. As a matter of fact, the idea here is
;that we should only evaluate the predicate to decide what to do next.

;-----
;1.7
;-----
(define (sqrt x)
  (sqrt-iter 1.0 x))  ; always guess the square root is 1.0 at the beginning
(define (sqrt-iter guess x) 
  (if (good-enough? guess x) guess  ; if the guess is good enough, return the value guess 
      (sqrt-iter (improve-guess guess x) x)))  ; otherwise, improve the guess and proceed to the next iteration
(define (good-enough? guess x) 
  (< (abs (- (* guess guess) x)) 0.001))  ; |guess * guess - x| < 0.001?
(define (abs x) 
  (if (> x 0) x (- x)))
(define (improve-guess guess x)  ; improvement := (guess + x / guess) / 2 
  (/ (+ guess (/ x guess)) 2))

(define (good-enough0? guess x) 
  (< (abs (- (improve-guess guess x) guess)) (* 0.001 guess)))

(sqrt 999999999999999999999999999)
;For very small number,
;the old "good-enough?" function converges too fast, resulting in inaccuracy: (sqrt 0.00000005) = 0.031250532810688444;
;while the new version is more accurate: (sqrt 0.00000005) = 0.0002236069910516385.
;For very big number,
;the old version is more accurate, although it takes more iterations to achieve this: (sqrt 999999999999999999999999999) = 31631394972364.664;  
;the new version: (sqrt 999999999999999999999999999) = 31622776601683.793.

;-----
;1.8
;-----
(define (cubic-root x)
  (cond ((> x 0) (cubic-root-iter 1.0 x)) 
        ((< x 0) (- (cubic-root-iter 1.0 (- x))))
        (else 0)))  ; always guess the cubic root is 1.0 at the beginning
(define (cubic-root-iter guess x) 
  (if (good-enough? guess x) guess  ; if the guess is good enough, return the value guess 
      (cubic-root-iter (improve-guess guess x) x)))  ; otherwise, improve the guess and proceed to the next iteration
(define (abs x) 
  (if (> x 0) x (- x)))
(define (improve-guess guess x)  ; improvement := (x / guess^2 + 2 * guess) / 3 
  (/ (+ (* 2 guess) (/ x (* guess guess))) 3))
(define (good-enough? guess x) 
  (< (abs (- (improve-guess guess x) guess)) (* 0.000001 guess)))

(cubic-root 1)
(cubic-root -1)
(cubic-root 64)
(cubic-root -64)
(cubic-root -0.008)
(cubic-root 0)
;When x = 0, improved_guess = 2/3 * guess, that is, guess(i+1) = 2/3 * guess(i). Therefore |improved_guess - guess| = 1/3 * guess, 
;and is always greater than 0.000001 * guess, resulting in infinite interation here. x = 0 should be specifically taken care of.

;-----
;1.9
;-----
(+ 4 5)
--> (+ 3 5) + 1
--> (+ 2 5) + 1 + 1
--> (+ 1 5) + 1 + 1 + 1
--> (+ 0 5) + 1 + 1 + 1 + 1
--> 5 + 1 + 1 + 1 + 1
--> 6 + 1 + 1 + 1
--> 7 + 1 + 1
--> 8 + 1
--> 9
; There are deferred evaluations, which are "inc (+ 3 5)", "inc (+ 2 5)", "inc (+ 1 5)" and "inc (+ 0 5)", therefore this process is recursive.
; Expansion then contraction; a chain of deferred operations.

(+ 4 5)
--> (+ 3 6)
--> (+ 2 7)
--> (+ 1 8)
--> (+ 0 9)
--> 9
; No expansion then contraction. All we need to keep track of are the current values of the variables a and b.
; The state of the process can be summarized by a fixed number of state variables, together with the updating rule.

;-----
;1.10
;-----
(A 1 10)
--> (A 0 (A 1 9))
--> (A 0 (A 0 (A 1 8)))
--> ...
--> {9 "(A 0"s} (A 1 1)
--> {9 "(A 0"s} 2
--> {8 "(A 0"s} 2^2
--> ...
--> 2^10
--> 1024

(A 2 4)
--> (A 1 (A 2 3))
--> (A 1 (A 1 (A 2 2)))
--> (A 1 (A 1 (A 1 (A 2 1))))
--> (A 1 (A 1 (A 1 2)))
--> (A 1 (A 1 4)
--> (A 1 16)
--> 65536

(A 3 3)
--> (A 2 (A 3 2))
--> (A 2 (A 2 (A 3 1)))
--> (A 2 (A 2 2))
--> (A 2 4)
--> 65536

(define (f n) (A 0 n))  ; 2n

(define (g n) (A 1 n))  ; 2^n

(define (h n) (A 2 n))  ; 2^^n (^^ is Knuth's up-arrow notation)

(define (k n) (* 5 n n))  ; 5n^2

;-------------
;count change
;-------------
(define (count-change amount) (cc amount 5))
(define (cc amount kinds-of-coins) 
  (cond ((= amount 0) 1)
        ((or (< amount 0) (= kinds-of-coins 0)) 0)
        (else (+ (cc amount (- kinds-of-coins 1))  ; not use current coin for current amount 
                 (cc (- amount (first-denomination kinds-of-coins)) kinds-of-coins)))))  ; use current coin for current amount
(define (first-denomination kinds-of-coins) 
  (cond ((= kinds-of-coins 1) 1)
        ((= kinds-of-coins 2) 5)
        ((= kinds-of-coins 3) 10)
        ((= kinds-of-coins 4) 25)
        ((= kinds-of-coins 5) 50)))

(count-change 100)

;-----
;1.11
;-----
(define (f n)  ;recursive 
  (if (< n 3) n (+ (f (- n 1)) (* 2 (f (- n 2))) (* 3 (f (- n 3))))))

(define (f n)  ;iterative 
  (if (< n 3) n (f-iter 0 1 2 (- n 2))))

(define (f-iter ppp pp p how-many-left) 
  (if (= how-many-left 0) p (f-iter pp p (+ (* 3 ppp) (* 2 pp) p) (- how-many-left 1))))

(f 20)

;-----
;1.12
;-----
;assume row >= col
;1
;1 1
;1 2 1
;1 3 3 1
;...
(define (pascal-element row col) 
  (if (or (= col 0) (= row col)) 1 
      (+ (pascal-element (- row 1) (- col 1)) (pascal-element (- row 1) col))))

;-----
;1.13
;-----
; Step 1. Prove by induction.
; Step 2. To prove Fib(n) = (a^n - b^n) / sqrt(5) is the closest integer to a^n / sqrt(5),
;         that is, to prove |(a^n - b^n) / sqrt(5) - a^n / sqrt(5)| <= 0.5.

;-----
;1.14
;-----
; Draw the recursion tree -- done.
; Space complexity: max depth of the recursion tree, which is O(n).
; Time complexity: number of nodes in the recursion tree, which has the same order of the
; number of leaves, which is O(2^n) (since the tree is binary).

;-----
;1.15
;-----
; a. 5 times. log_(3)_(12.5 / 0.1) = 4.37.
; b. Time complexity: O(log_(3)_(a / 0.1)) --> O(lg(a)).
;    Space complexity: 
;      (sine 12.15)
;      (p (sine 4.05))  --------------------- (1)
;      (p (p (sine 1.35)))  ----------------- (2)
;      (p (p (p (sine 0.45))))  ------------- (3)
;      (p (p (p (p (sine 0.15)))))  --------- (4)
;      (p (p (p (p (p (sine 0.05))))))  ----- (5)
;
;      (p (p (p (p (p 0.05)))))  ------------ (6)
;      (p (p (p (p 0.1495))))  -------------- (7)
;      (p (p (p 0.4351345505)))  ------------ (8)
;      (p (p 0.9758465331678772))  ---------- (9)
;      (p -0.7895631144708228)  ------------- (10)
;      -0.39980345741334
;        We can see that there is "expansion then contraction".
;        (1) - (5) are all deferred evaluations (as regards function p).
;        (6) - (10) are the steps where actual evaluations happen.
;        Therefore this is a recursive process.
;        The space complexity is therefore O(lg(a)).

;-----
;1.16
;-----
; Use idea in hint: a is used to keep track of the product of "extra" (current) bs when n is odd.
; For example: 3^12
; n   b     a
; 12  3     1
; 6   9     1
; 3   81    1
; 2   81    81
; 1   6561  81
; 0   6561  81*6561
(define (expt b n) 
  (fast-expt-iter b n 1))
(define (fast-expt-iter b n a) 
  (if (= n 0) a 
      (if (even? n) (fast-expt-iter (* b b) (/ n 2) a) (fast-expt-iter b (- n 1) (* a b)))))
(define (even? n) (= (remainder n 2) 0))

(expt 3 12)

;-----
;1.17
;-----
; Compute a * b. Assume a >= 0 and b >= 0.
; For example, 3 * 5
; (3, 5)
; 3 + (3, 4)
; 3 + 2 * (3, 2)
; 3 + 2 * (2 * (3, 1))
; 3 + 2 * (2 * (3 + (3, 0)))
; -- evaluations above are deferred --
; 3 + 2 * (2 * (3 + 0))
; 3 + 2 * (2 * 3)
; 3 + 2 * 6
; 3 + 12
; 15
; -- deferred evaluations are actually evaluated above --
; We can see "expansion then contraction" and deferred evaluations here, thus this is recursive.
(define (fast-mul a b) 
  (if (= b 0) 0 
      (if (even? b) (double (fast-mul a (halve b))) (+ a (fast-mul a (- b 1))))))
(define (even? n) (= (remainder n 2) 0))
(define (halve n) (/ n 2))
(define (double n) (* n 2))

(fast-mul 98 891)

;-----
;1.18
;-----
; Compute a * b, assume a >= 0 and b >= 0.
; fast-mul iterative version.
; Use idea in 1.16: c is used to keep track of the sum of "extra" (current) as when b is odd.
; For example: 3 * 5
; a    b    c
; 3    5    0
; 3    4    3
; 6    2    3
; 12   1    3
; 12   0    15
(define (fast-mul a b) 
  (fast-mul-iter a b 0))
(define (fast-mul-iter a b c) 
  (if (= b 0) c 
      (if (even? b) (fast-mul-iter (double a) (halve b) c) (fast-mul-iter a (- b 1) (+ c a)))))
(define (even? n) (= (remainder n 2) 0))
(define (halve n) (/ n 2))
(define (double n) (* n 2))

(fast-mul 0 3)