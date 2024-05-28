'(expression:
  (letrec*
   ((square (λ (x) (app * x x)))
    (modulo-power
     (λ (base exp n)
       (match
        (app = exp 0)
        ((#f)
         (match
          (app odd? exp)
          ((#f)
           (app modulo (app square (app modulo-power base (app / exp 2) n)) n))
          (_
           (app
            modulo
            (app * base (app modulo-power base (app - exp 1) n))
            n))))
        (_ 1))))
    (is-trivial-composite?
     (λ (n)
       (app
        or
        (app = (app modulo n 2) 0)
        (app = (app modulo n 3) 0)
        (app = (app modulo n 5) 0)
        (app = (app modulo n 7) 0)
        (app = (app modulo n 11) 0)
        (app = (app modulo n 13) 0)
        (app = (app modulo n 17) 0)
        (app = (app modulo n 19) 0)
        (app = (app modulo n 23) 0))))
    (is-fermat-prime?
     (λ (n iterations)
       (app
        or
        (app <= iterations 0)
        (let* ((byte-size (app ceiling (app / (app log n) (app log 2))))
               (a (app random byte-size)))
          (match
           (app = (app modulo-power a (app - n 1) n) 1)
           ((#f) (app #f))
           (_ (app is-fermat-prime? n (app - iterations 1))))))))
    (generate-fermat-prime
     (λ (byte-size iterations)
       (let ((n (app random byte-size)))
         (match
          (app
           and
           (app not (app is-trivial-composite? n))
           (app is-fermat-prime? n iterations))
          ((#f) (app generate-fermat-prime byte-size iterations))
          (_ n)))))
    (iterations 10)
    (byte-size 15))
   (app generate-fermat-prime byte-size iterations)))

'(query:
  (app
   and
   (-> (app not (app is-trivial-composite? n)) <-)
   (app is-fermat-prime? n iterations))
  (env
   ((letrec*
     (square ... byte-size)
     (-> (app generate-fermat-prime byte-size iterations) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   and
   (-> (app not (app is-trivial-composite? n)) <-)
   (app is-fermat-prime? n iterations))
  (env
   ((match
     (app
      and
      (app not (app is-trivial-composite? n))
      (app is-fermat-prime? n iterations))
     ((#f) (-> (app generate-fermat-prime byte-size iterations) <-))
     _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   and
   (app not (app is-trivial-composite? n))
   (-> (app is-fermat-prime? n iterations) <-))
  (env
   ((letrec*
     (square ... byte-size)
     (-> (app generate-fermat-prime byte-size iterations) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   and
   (app not (app is-trivial-composite? n))
   (-> (app is-fermat-prime? n iterations) <-))
  (env
   ((match
     (app
      and
      (app not (app is-trivial-composite? n))
      (app is-fermat-prime? n iterations))
     ((#f) (-> (app generate-fermat-prime byte-size iterations) <-))
     _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   or
   (-> (app = (app modulo n 2) 0) <-)
   (app = (app modulo n 3) 0)
   (app = (app modulo n 5) 0)
   (app = (app modulo n 7) 0)
   (app = (app modulo n 11) 0)
   (app = (app modulo n 13) 0)
   (app = (app modulo n 17) 0)
   (app = (app modulo n 19) 0)
   (app = (app modulo n 23) 0))
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   or
   (app = (app modulo n 2) 0)
   (-> (app = (app modulo n 3) 0) <-)
   (app = (app modulo n 5) 0)
   (app = (app modulo n 7) 0)
   (app = (app modulo n 11) 0)
   (app = (app modulo n 13) 0)
   (app = (app modulo n 17) 0)
   (app = (app modulo n 19) 0)
   (app = (app modulo n 23) 0))
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   or
   (app = (app modulo n 2) 0)
   (app = (app modulo n 3) 0)
   (-> (app = (app modulo n 5) 0) <-)
   (app = (app modulo n 7) 0)
   (app = (app modulo n 11) 0)
   (app = (app modulo n 13) 0)
   (app = (app modulo n 17) 0)
   (app = (app modulo n 19) 0)
   (app = (app modulo n 23) 0))
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   or
   (app = (app modulo n 2) 0)
   (app = (app modulo n 3) 0)
   (app = (app modulo n 5) 0)
   (-> (app = (app modulo n 7) 0) <-)
   (app = (app modulo n 11) 0)
   (app = (app modulo n 13) 0)
   (app = (app modulo n 17) 0)
   (app = (app modulo n 19) 0)
   (app = (app modulo n 23) 0))
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   or
   (app = (app modulo n 2) 0)
   (app = (app modulo n 3) 0)
   (app = (app modulo n 5) 0)
   (app = (app modulo n 7) 0)
   (-> (app = (app modulo n 11) 0) <-)
   (app = (app modulo n 13) 0)
   (app = (app modulo n 17) 0)
   (app = (app modulo n 19) 0)
   (app = (app modulo n 23) 0))
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   or
   (app = (app modulo n 2) 0)
   (app = (app modulo n 3) 0)
   (app = (app modulo n 5) 0)
   (app = (app modulo n 7) 0)
   (app = (app modulo n 11) 0)
   (-> (app = (app modulo n 13) 0) <-)
   (app = (app modulo n 17) 0)
   (app = (app modulo n 19) 0)
   (app = (app modulo n 23) 0))
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   or
   (app = (app modulo n 2) 0)
   (app = (app modulo n 3) 0)
   (app = (app modulo n 5) 0)
   (app = (app modulo n 7) 0)
   (app = (app modulo n 11) 0)
   (app = (app modulo n 13) 0)
   (-> (app = (app modulo n 17) 0) <-)
   (app = (app modulo n 19) 0)
   (app = (app modulo n 23) 0))
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   or
   (app = (app modulo n 2) 0)
   (app = (app modulo n 3) 0)
   (app = (app modulo n 5) 0)
   (app = (app modulo n 7) 0)
   (app = (app modulo n 11) 0)
   (app = (app modulo n 13) 0)
   (app = (app modulo n 17) 0)
   (-> (app = (app modulo n 19) 0) <-)
   (app = (app modulo n 23) 0))
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   or
   (app = (app modulo n 2) 0)
   (app = (app modulo n 3) 0)
   (app = (app modulo n 5) 0)
   (app = (app modulo n 7) 0)
   (app = (app modulo n 11) 0)
   (app = (app modulo n 13) 0)
   (app = (app modulo n 17) 0)
   (app = (app modulo n 19) 0)
   (-> (app = (app modulo n 23) 0) <-))
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app * (-> base <-) (app modulo-power base (app - exp 1) n))
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * (-> base <-) (app modulo-power base (app - exp 1) n))
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * (-> base <-) (app modulo-power base (app - exp 1) n))
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * (-> x <-) x)
  (env
   ((app
     modulo
     (-> (app square (app modulo-power base (app / exp 2) n)) <-)
     n))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * base (-> (app modulo-power base (app - exp 1) n) <-))
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * base (-> (app modulo-power base (app - exp 1) n) <-))
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * base (-> (app modulo-power base (app - exp 1) n) <-))
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * x (-> x <-))
  (env
   ((app
     modulo
     (-> (app square (app modulo-power base (app / exp 2) n)) <-)
     n))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> exp <-) 1)
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> exp <-) 1)
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> exp <-) 1)
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> iterations <-) 1)
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query:
  (app - (-> iterations <-) 1)
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> n <-) 1)
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> n <-) 1)
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app / (-> (app log n) <-) (app log 2))
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app / (-> (app log n) <-) (app log 2))
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app / (-> exp <-) 2)
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app / (-> exp <-) 2)
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app / (-> exp <-) 2)
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app / (app log n) (-> (app log 2) <-))
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con: ⊥
literals: '(0.6931471805599453 ⊥ ⊥)

'(query:
  (app / (app log n) (-> (app log 2) <-))
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con: ⊥
literals: '(0.6931471805599453 ⊥ ⊥)

'(query:
  (app <= (-> iterations <-) 0)
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query:
  (app <= (-> iterations <-) 0)
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> (app modulo n 11) <-) 0)
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> (app modulo n 13) <-) 0)
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> (app modulo n 17) <-) 0)
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> (app modulo n 19) <-) 0)
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> (app modulo n 2) <-) 0)
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> (app modulo n 23) <-) 0)
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> (app modulo n 3) <-) 0)
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> (app modulo n 5) <-) 0)
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> (app modulo n 7) <-) 0)
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> (app modulo-power a (app - n 1) n) <-) 1)
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> (app modulo-power a (app - n 1) n) <-) 1)
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> exp <-) 0)
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> exp <-) 0)
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> exp <-) 0)
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app ceiling (-> (app / (app log n) (app log 2)) <-))
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app ceiling (-> (app / (app log n) (app log 2)) <-))
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app generate-fermat-prime (-> byte-size <-) iterations)
  (env
   ((letrec*
     (square ... byte-size)
     (-> (app generate-fermat-prime byte-size iterations) <-)))))
clos/con: ⊥
literals: '(15 ⊥ ⊥)

'(query:
  (app generate-fermat-prime (-> byte-size <-) iterations)
  (env
   ((match
     (app
      and
      (app not (app is-trivial-composite? n))
      (app is-fermat-prime? n iterations))
     ((#f) (-> (app generate-fermat-prime byte-size iterations) <-))
     _))))
clos/con: ⊥
literals: '(15 ⊥ ⊥)

'(query:
  (app generate-fermat-prime byte-size (-> iterations <-))
  (env
   ((letrec*
     (square ... byte-size)
     (-> (app generate-fermat-prime byte-size iterations) <-)))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query:
  (app generate-fermat-prime byte-size (-> iterations <-))
  (env
   ((match
     (app
      and
      (app not (app is-trivial-composite? n))
      (app is-fermat-prime? n iterations))
     ((#f) (-> (app generate-fermat-prime byte-size iterations) <-))
     _))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query:
  (app is-fermat-prime? (-> n <-) (app - iterations 1))
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app is-fermat-prime? (-> n <-) (app - iterations 1))
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app is-fermat-prime? (-> n <-) iterations)
  (env
   ((letrec*
     (square ... byte-size)
     (-> (app generate-fermat-prime byte-size iterations) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app is-fermat-prime? (-> n <-) iterations)
  (env
   ((match
     (app
      and
      (app not (app is-trivial-composite? n))
      (app is-fermat-prime? n iterations))
     ((#f) (-> (app generate-fermat-prime byte-size iterations) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app is-fermat-prime? n (-> (app - iterations 1) <-))
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con: ⊥
literals: '(9 ⊥ ⊥)

'(query:
  (app is-fermat-prime? n (-> (app - iterations 1) <-))
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app is-fermat-prime? n (-> iterations <-))
  (env
   ((letrec*
     (square ... byte-size)
     (-> (app generate-fermat-prime byte-size iterations) <-)))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query:
  (app is-fermat-prime? n (-> iterations <-))
  (env
   ((match
     (app
      and
      (app not (app is-trivial-composite? n))
      (app is-fermat-prime? n iterations))
     ((#f) (-> (app generate-fermat-prime byte-size iterations) <-))
     _))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query:
  (app is-trivial-composite? (-> n <-))
  (env
   ((letrec*
     (square ... byte-size)
     (-> (app generate-fermat-prime byte-size iterations) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app is-trivial-composite? (-> n <-))
  (env
   ((match
     (app
      and
      (app not (app is-trivial-composite? n))
      (app is-fermat-prime? n iterations))
     ((#f) (-> (app generate-fermat-prime byte-size iterations) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app log (-> n <-))
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app log (-> n <-))
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (-> (app * base (app modulo-power base (app - exp 1) n)) <-) n)
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (-> (app * base (app modulo-power base (app - exp 1) n)) <-) n)
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (-> (app * base (app modulo-power base (app - exp 1) n)) <-) n)
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (-> (app square (app modulo-power base (app / exp 2) n)) <-) n)
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (-> (app square (app modulo-power base (app / exp 2) n)) <-) n)
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (-> (app square (app modulo-power base (app / exp 2) n)) <-) n)
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (-> n <-) 11)
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (-> n <-) 13)
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (-> n <-) 17)
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (-> n <-) 19)
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (-> n <-) 2)
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (-> n <-) 23)
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (-> n <-) 3)
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (-> n <-) 5)
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (-> n <-) 7)
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (app * base (app modulo-power base (app - exp 1) n)) (-> n <-))
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (app * base (app modulo-power base (app - exp 1) n)) (-> n <-))
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (app * base (app modulo-power base (app - exp 1) n)) (-> n <-))
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (app square (app modulo-power base (app / exp 2) n)) (-> n <-))
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (app square (app modulo-power base (app / exp 2) n)) (-> n <-))
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (app square (app modulo-power base (app / exp 2) n)) (-> n <-))
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo-power (-> a <-) (app - n 1) n)
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo-power (-> a <-) (app - n 1) n)
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo-power (-> base <-) (app - exp 1) n)
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo-power (-> base <-) (app - exp 1) n)
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo-power (-> base <-) (app - exp 1) n)
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo-power (-> base <-) (app / exp 2) n)
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo-power (-> base <-) (app / exp 2) n)
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo-power (-> base <-) (app / exp 2) n)
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo-power a (-> (app - n 1) <-) n)
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo-power a (-> (app - n 1) <-) n)
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo-power a (app - n 1) (-> n <-))
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo-power a (app - n 1) (-> n <-))
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo-power base (-> (app - exp 1) <-) n)
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo-power base (-> (app - exp 1) <-) n)
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo-power base (-> (app - exp 1) <-) n)
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo-power base (-> (app / exp 2) <-) n)
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo-power base (-> (app / exp 2) <-) n)
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo-power base (-> (app / exp 2) <-) n)
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo-power base (app - exp 1) (-> n <-))
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo-power base (app - exp 1) (-> n <-))
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo-power base (app - exp 1) (-> n <-))
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo-power base (app / exp 2) (-> n <-))
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo-power base (app / exp 2) (-> n <-))
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo-power base (app / exp 2) (-> n <-))
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app not (-> (app is-trivial-composite? n) <-))
  (env
   ((letrec*
     (square ... byte-size)
     (-> (app generate-fermat-prime byte-size iterations) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app not (-> (app is-trivial-composite? n) <-))
  (env
   ((match
     (app
      and
      (app not (app is-trivial-composite? n))
      (app is-fermat-prime? n iterations))
     ((#f) (-> (app generate-fermat-prime byte-size iterations) <-))
     _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app odd? (-> exp <-))
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app odd? (-> exp <-))
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app odd? (-> exp <-))
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app or (-> (app <= iterations 0) <-) (let* (byte-size ... a) ...))
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (-> (app <= iterations 0) <-) (let* (byte-size ... a) ...))
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (app <= iterations 0) (-> (let* (byte-size ... a) ...) <-))
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (app <= iterations 0) (-> (let* (byte-size ... a) ...) <-))
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app random (-> byte-size <-))
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app random (-> byte-size <-))
  (env
   ((letrec*
     (square ... byte-size)
     (-> (app generate-fermat-prime byte-size iterations) <-)))))
clos/con: ⊥
literals: '(15 ⊥ ⊥)

'(query:
  (app random (-> byte-size <-))
  (env
   ((match
     (app
      and
      (app not (app is-trivial-composite? n))
      (app is-fermat-prime? n iterations))
     ((#f) (-> (app generate-fermat-prime byte-size iterations) <-))
     _))))
clos/con: ⊥
literals: '(15 ⊥ ⊥)

'(query:
  (app random (-> byte-size <-))
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app square (-> (app modulo-power base (app / exp 2) n) <-))
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app square (-> (app modulo-power base (app / exp 2) n) <-))
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app square (-> (app modulo-power base (app / exp 2) n) <-))
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let (... () (n (-> (app random byte-size) <-)) () ...) ...)
  (env
   ((letrec*
     (square ... byte-size)
     (-> (app generate-fermat-prime byte-size iterations) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let (... () (n (-> (app random byte-size) <-)) () ...) ...)
  (env
   ((match
     (app
      and
      (app not (app is-trivial-composite? n))
      (app is-fermat-prime? n iterations))
     ((#f) (-> (app generate-fermat-prime byte-size iterations) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let (n)
    (->
     (match
      (app
       and
       (app not (app is-trivial-composite? n))
       (app is-fermat-prime? n iterations))
      ...)
     <-))
  (env
   ((letrec*
     (square ... byte-size)
     (-> (app generate-fermat-prime byte-size iterations) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let (n)
    (->
     (match
      (app
       and
       (app not (app is-trivial-composite? n))
       (app is-fermat-prime? n iterations))
      ...)
     <-))
  (env
   ((match
     (app
      and
      (app not (app is-trivial-composite? n))
      (app is-fermat-prime? n iterations))
     ((#f) (-> (app generate-fermat-prime byte-size iterations) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let* (...
         ()
         (byte-size (-> (app ceiling (app / (app log n) (app log 2))) <-))
         a
         ...)
    ...)
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let* (...
         ()
         (byte-size (-> (app ceiling (app / (app log n) (app log 2))) <-))
         a
         ...)
    ...)
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let* (... byte-size (a (-> (app random byte-size) <-)) () ...) ...)
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let* (... byte-size (a (-> (app random byte-size) <-)) () ...) ...)
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let* (byte-size ... a)
    (-> (match (app = (app modulo-power a (app - n 1) n) 1) ...) <-))
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let* (byte-size ... a)
    (-> (match (app = (app modulo-power a (app - n 1) n) 1) ...) <-))
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (square ... byte-size)
   (-> (app generate-fermat-prime byte-size iterations) <-))
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (->
    (app
     and
     (app not (app is-trivial-composite? n))
     (app is-fermat-prime? n iterations))
    <-)
   (#f)
   _)
  (env
   ((letrec*
     (square ... byte-size)
     (-> (app generate-fermat-prime byte-size iterations) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (->
    (app
     and
     (app not (app is-trivial-composite? n))
     (app is-fermat-prime? n iterations))
    <-)
   (#f)
   _)
  (env
   ((match
     (app
      and
      (app not (app is-trivial-composite? n))
      (app is-fermat-prime? n iterations))
     ((#f) (-> (app generate-fermat-prime byte-size iterations) <-))
     _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app
    and
    (app not (app is-trivial-composite? n))
    (app is-fermat-prime? n iterations))
   (#f)
   (_ (-> n <-)))
  (env
   ((letrec*
     (square ... byte-size)
     (-> (app generate-fermat-prime byte-size iterations) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app
    and
    (app not (app is-trivial-composite? n))
    (app is-fermat-prime? n iterations))
   (#f)
   (_ (-> n <-)))
  (env
   ((match
     (app
      and
      (app not (app is-trivial-composite? n))
      (app is-fermat-prime? n iterations))
     ((#f) (-> (app generate-fermat-prime byte-size iterations) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app
    and
    (app not (app is-trivial-composite? n))
    (app is-fermat-prime? n iterations))
   ((#f) (-> (app generate-fermat-prime byte-size iterations) <-))
   _)
  (env
   ((letrec*
     (square ... byte-size)
     (-> (app generate-fermat-prime byte-size iterations) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app
    and
    (app not (app is-trivial-composite? n))
    (app is-fermat-prime? n iterations))
   ((#f) (-> (app generate-fermat-prime byte-size iterations) <-))
   _)
  (env
   ((match
     (app
      and
      (app not (app is-trivial-composite? n))
      (app is-fermat-prime? n iterations))
     ((#f) (-> (app generate-fermat-prime byte-size iterations) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app = (app modulo-power a (app - n 1) n) 1)
   (#f)
   (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-)))
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app = (app modulo-power a (app - n 1) n) 1)
   (#f)
   (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-)))
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app = (app modulo-power a (app - n 1) n) 1)
   ((#f) (-> (app #f) <-))
   _)
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app = (app modulo-power a (app - n 1) n) 1)
   ((#f) (-> (app #f) <-))
   _)
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app odd? exp)
   (#f)
   (_
    (->
     (app modulo (app * base (app modulo-power base (app - exp 1) n)) n)
     <-)))
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app odd? exp)
   (#f)
   (_
    (->
     (app modulo (app * base (app modulo-power base (app - exp 1) n)) n)
     <-)))
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app odd? exp)
   (#f)
   (_
    (->
     (app modulo (app * base (app modulo-power base (app - exp 1) n)) n)
     <-)))
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app odd? exp)
   ((#f)
    (->
     (app modulo (app square (app modulo-power base (app / exp 2) n)) n)
     <-))
   _)
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app odd? exp)
   ((#f)
    (->
     (app modulo (app square (app modulo-power base (app / exp 2) n)) n)
     <-))
   _)
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app odd? exp)
   ((#f)
    (->
     (app modulo (app square (app modulo-power base (app / exp 2) n)) n)
     <-))
   _)
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (-> (app = (app modulo-power a (app - n 1) n) 1) <-) (#f) _)
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app = (app modulo-power a (app - n 1) n) 1) <-) (#f) _)
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app = exp 0) <-) (#f) _)
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app = exp 0) <-) (#f) _)
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app = exp 0) <-) (#f) _)
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app odd? exp) <-) (#f) _)
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app odd? exp) <-) (#f) _)
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app odd? exp) <-) (#f) _)
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app = exp 0) ((#f) (-> (match (app odd? exp) ...) <-)) _)
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app = exp 0) ((#f) (-> (match (app odd? exp) ...) <-)) _)
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app = exp 0) ((#f) (-> (match (app odd? exp) ...) <-)) _)
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (base exp n) (-> (match (app = exp 0) ...) <-))
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (base exp n) (-> (match (app = exp 0) ...) <-))
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (base exp n) (-> (match (app = exp 0) ...) <-))
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (byte-size iterations) (-> (let (n) ...) <-))
  (env
   ((letrec*
     (square ... byte-size)
     (-> (app generate-fermat-prime byte-size iterations) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (byte-size iterations) (-> (let (n) ...) <-))
  (env
   ((match
     (app
      and
      (app not (app is-trivial-composite? n))
      (app is-fermat-prime? n iterations))
     ((#f) (-> (app generate-fermat-prime byte-size iterations) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (n iterations)
    (-> (app or (app <= iterations 0) (let* (byte-size ... a) ...)) <-))
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (n iterations)
    (-> (app or (app <= iterations 0) (let* (byte-size ... a) ...)) <-))
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (n)
    (->
     (app
      or
      (app = (app modulo n 2) 0)
      (app = (app modulo n 3) 0)
      (app = (app modulo n 5) 0)
      (app = (app modulo n 7) 0)
      (app = (app modulo n 11) 0)
      (app = (app modulo n 13) 0)
      (app = (app modulo n 17) 0)
      (app = (app modulo n 19) 0)
      (app = (app modulo n 23) 0))
     <-))
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x) (-> (app * x x) <-))
  (env
   ((app
     modulo
     (-> (app square (app modulo-power base (app / exp 2) n)) <-)
     n))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: ((top) letrec* (square ... byte-size) ...) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  a
  (let* (... byte-size (a (-> (app random byte-size) <-)) () ...) ...)
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  a
  (let* (... byte-size (a (-> (app random byte-size) <-)) () ...) ...)
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  base
  (λ (base exp n) (-> (match (app = exp 0) ...) <-))
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  base
  (λ (base exp n) (-> (match (app = exp 0) ...) <-))
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  base
  (λ (base exp n) (-> (match (app = exp 0) ...) <-))
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  byte-size
  (let* (...
         ()
         (byte-size (-> (app ceiling (app / (app log n) (app log 2))) <-))
         a
         ...)
    ...)
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  byte-size
  (let* (...
         ()
         (byte-size (-> (app ceiling (app / (app log n) (app log 2))) <-))
         a
         ...)
    ...)
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  byte-size
  (letrec* (... iterations (byte-size (-> 15 <-)) () ...) ...)
  (env ()))
clos/con: ⊥
literals: '(15 ⊥ ⊥)

'(store:
  byte-size
  (λ (byte-size iterations) (-> (let (n) ...) <-))
  (env
   ((letrec*
     (square ... byte-size)
     (-> (app generate-fermat-prime byte-size iterations) <-)))))
clos/con: ⊥
literals: '(15 ⊥ ⊥)

'(store:
  byte-size
  (λ (byte-size iterations) (-> (let (n) ...) <-))
  (env
   ((match
     (app
      and
      (app not (app is-trivial-composite? n))
      (app is-fermat-prime? n iterations))
     ((#f) (-> (app generate-fermat-prime byte-size iterations) <-))
     _))))
clos/con: ⊥
literals: '(15 ⊥ ⊥)

'(store:
  exp
  (λ (base exp n) (-> (match (app = exp 0) ...) <-))
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  exp
  (λ (base exp n) (-> (match (app = exp 0) ...) <-))
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  exp
  (λ (base exp n) (-> (match (app = exp 0) ...) <-))
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  generate-fermat-prime
  (letrec*
   (...
    is-fermat-prime?
    (generate-fermat-prime (-> (λ (byte-size iterations) ...) <-))
    iterations
    ...)
   ...)
  (env
   ((letrec*
     (square ... byte-size)
     (-> (app generate-fermat-prime byte-size iterations) <-)))))
clos/con:
	'((letrec*
   (...
    is-fermat-prime?
    (generate-fermat-prime (-> (λ (byte-size iterations) ...) <-))
    iterations
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  generate-fermat-prime
  (letrec*
   (...
    is-fermat-prime?
    (generate-fermat-prime (-> (λ (byte-size iterations) ...) <-))
    iterations
    ...)
   ...)
  (env
   ((match
     (app
      and
      (app not (app is-trivial-composite? n))
      (app is-fermat-prime? n iterations))
     ((#f) (-> (app generate-fermat-prime byte-size iterations) <-))
     _))))
clos/con:
	'((letrec*
   (...
    is-fermat-prime?
    (generate-fermat-prime (-> (λ (byte-size iterations) ...) <-))
    iterations
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  generate-fermat-prime
  (letrec*
   (...
    is-fermat-prime?
    (generate-fermat-prime (-> (λ (byte-size iterations) ...) <-))
    iterations
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    is-fermat-prime?
    (generate-fermat-prime (-> (λ (byte-size iterations) ...) <-))
    iterations
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  is-fermat-prime?
  (letrec*
   (...
    is-trivial-composite?
    (is-fermat-prime? (-> (λ (n iterations) ...) <-))
    generate-fermat-prime
    ...)
   ...)
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con:
	'((letrec*
   (...
    is-trivial-composite?
    (is-fermat-prime? (-> (λ (n iterations) ...) <-))
    generate-fermat-prime
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  is-fermat-prime?
  (letrec*
   (...
    is-trivial-composite?
    (is-fermat-prime? (-> (λ (n iterations) ...) <-))
    generate-fermat-prime
    ...)
   ...)
  (env
   ((letrec*
     (square ... byte-size)
     (-> (app generate-fermat-prime byte-size iterations) <-)))))
clos/con:
	'((letrec*
   (...
    is-trivial-composite?
    (is-fermat-prime? (-> (λ (n iterations) ...) <-))
    generate-fermat-prime
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  is-fermat-prime?
  (letrec*
   (...
    is-trivial-composite?
    (is-fermat-prime? (-> (λ (n iterations) ...) <-))
    generate-fermat-prime
    ...)
   ...)
  (env
   ((match
     (app
      and
      (app not (app is-trivial-composite? n))
      (app is-fermat-prime? n iterations))
     ((#f) (-> (app generate-fermat-prime byte-size iterations) <-))
     _))))
clos/con:
	'((letrec*
   (...
    is-trivial-composite?
    (is-fermat-prime? (-> (λ (n iterations) ...) <-))
    generate-fermat-prime
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  is-fermat-prime?
  (letrec*
   (...
    is-trivial-composite?
    (is-fermat-prime? (-> (λ (n iterations) ...) <-))
    generate-fermat-prime
    ...)
   ...)
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con:
	'((letrec*
   (...
    is-trivial-composite?
    (is-fermat-prime? (-> (λ (n iterations) ...) <-))
    generate-fermat-prime
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  is-fermat-prime?
  (letrec*
   (...
    is-trivial-composite?
    (is-fermat-prime? (-> (λ (n iterations) ...) <-))
    generate-fermat-prime
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    is-trivial-composite?
    (is-fermat-prime? (-> (λ (n iterations) ...) <-))
    generate-fermat-prime
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  is-trivial-composite?
  (letrec*
   (...
    modulo-power
    (is-trivial-composite? (-> (λ (n) ...) <-))
    is-fermat-prime?
    ...)
   ...)
  (env
   ((letrec*
     (square ... byte-size)
     (-> (app generate-fermat-prime byte-size iterations) <-)))))
clos/con:
	'((letrec*
   (...
    modulo-power
    (is-trivial-composite? (-> (λ (n) ...) <-))
    is-fermat-prime?
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  is-trivial-composite?
  (letrec*
   (...
    modulo-power
    (is-trivial-composite? (-> (λ (n) ...) <-))
    is-fermat-prime?
    ...)
   ...)
  (env
   ((match
     (app
      and
      (app not (app is-trivial-composite? n))
      (app is-fermat-prime? n iterations))
     ((#f) (-> (app generate-fermat-prime byte-size iterations) <-))
     _))))
clos/con:
	'((letrec*
   (...
    modulo-power
    (is-trivial-composite? (-> (λ (n) ...) <-))
    is-fermat-prime?
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  is-trivial-composite?
  (letrec*
   (...
    modulo-power
    (is-trivial-composite? (-> (λ (n) ...) <-))
    is-fermat-prime?
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    modulo-power
    (is-trivial-composite? (-> (λ (n) ...) <-))
    is-fermat-prime?
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  iterations
  (letrec*
   (... generate-fermat-prime (iterations (-> 10 <-)) byte-size ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(store:
  iterations
  (λ (byte-size iterations) (-> (let (n) ...) <-))
  (env
   ((letrec*
     (square ... byte-size)
     (-> (app generate-fermat-prime byte-size iterations) <-)))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(store:
  iterations
  (λ (byte-size iterations) (-> (let (n) ...) <-))
  (env
   ((match
     (app
      and
      (app not (app is-trivial-composite? n))
      (app is-fermat-prime? n iterations))
     ((#f) (-> (app generate-fermat-prime byte-size iterations) <-))
     _))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(store:
  iterations
  (λ (n iterations)
    (-> (app or (app <= iterations 0) (let* (byte-size ... a) ...)) <-))
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(store:
  iterations
  (λ (n iterations)
    (-> (app or (app <= iterations 0) (let* (byte-size ... a) ...)) <-))
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  modulo-power
  (letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-trivial-composite?
    ...)
   ...)
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con:
	'((letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-trivial-composite?
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  modulo-power
  (letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-trivial-composite?
    ...)
   ...)
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con:
	'((letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-trivial-composite?
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  modulo-power
  (letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-trivial-composite?
    ...)
   ...)
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con:
	'((letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-trivial-composite?
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  modulo-power
  (letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-trivial-composite?
    ...)
   ...)
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con:
	'((letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-trivial-composite?
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  modulo-power
  (letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-trivial-composite?
    ...)
   ...)
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
clos/con:
	'((letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-trivial-composite?
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  modulo-power
  (letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-trivial-composite?
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-trivial-composite?
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n
  (let (... () (n (-> (app random byte-size) <-)) () ...) ...)
  (env
   ((letrec*
     (square ... byte-size)
     (-> (app generate-fermat-prime byte-size iterations) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  n
  (let (... () (n (-> (app random byte-size) <-)) () ...) ...)
  (env
   ((match
     (app
      and
      (app not (app is-trivial-composite? n))
      (app is-fermat-prime? n iterations))
     ((#f) (-> (app generate-fermat-prime byte-size iterations) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  n
  (λ (base exp n) (-> (match (app = exp 0) ...) <-))
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  n
  (λ (base exp n) (-> (match (app = exp 0) ...) <-))
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  n
  (λ (base exp n) (-> (match (app = exp 0) ...) <-))
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  n
  (λ (n iterations)
    (-> (app or (app <= iterations 0) (let* (byte-size ... a) ...)) <-))
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  n
  (λ (n iterations)
    (-> (app or (app <= iterations 0) (let* (byte-size ... a) ...)) <-))
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  n
  (λ (n)
    (->
     (app
      or
      (app = (app modulo n 2) 0)
      (app = (app modulo n 3) 0)
      (app = (app modulo n 5) 0)
      (app = (app modulo n 7) 0)
      (app = (app modulo n 11) 0)
      (app = (app modulo n 13) 0)
      (app = (app modulo n 17) 0)
      (app = (app modulo n 19) 0)
      (app = (app modulo n 23) 0))
     <-))
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  square
  (letrec* (... () (square (-> (λ (x) ...) <-)) modulo-power ...) ...)
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con:
	'((letrec* (... () (square (-> (λ (x) ...) <-)) modulo-power ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  square
  (letrec* (... () (square (-> (λ (x) ...) <-)) modulo-power ...) ...)
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con:
	'((letrec* (... () (square (-> (λ (x) ...) <-)) modulo-power ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  square
  (letrec* (... () (square (-> (λ (x) ...) <-)) modulo-power ...) ...)
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
clos/con:
	'((letrec* (... () (square (-> (λ (x) ...) <-)) modulo-power ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  square
  (letrec* (... () (square (-> (λ (x) ...) <-)) modulo-power ...) ...)
  (env ()))
clos/con:
	'((letrec* (... () (square (-> (λ (x) ...) <-)) modulo-power ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x
  (λ (x) (-> (app * x x) <-))
  (env
   ((app
     modulo
     (-> (app square (app modulo-power base (app / exp 2) n)) <-)
     n))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)
