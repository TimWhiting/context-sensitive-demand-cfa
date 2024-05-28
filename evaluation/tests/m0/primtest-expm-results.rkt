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
       (match
        (app = (app modulo n 2) 0)
        ((#f)
         (match
          (app = (app modulo n 3) 0)
          ((#f)
           (match
            (app = (app modulo n 5) 0)
            ((#f)
             (match
              (app = (app modulo n 7) 0)
              ((#f)
               (match
                (app = (app modulo n 11) 0)
                ((#f)
                 (match
                  (app = (app modulo n 13) 0)
                  ((#f)
                   (match
                    (app = (app modulo n 17) 0)
                    ((#f)
                     (match
                      (app = (app modulo n 19) 0)
                      ((#f)
                       (match
                        (app = (app modulo n 23) 0)
                        ((#f) (app #f))
                        (_ (app #t))))
                      (_ (app #t))))
                    (_ (app #t))))
                  (_ (app #t))))
                (_ (app #t))))
              (_ (app #t))))
            (_ (app #t))))
          (_ (app #t))))
        (_ (app #t)))))
    (is-fermat-prime?
     (λ (n iterations)
       (match
        (app <= iterations 0)
        ((#f)
         (match
          (let* ((byte-size (app ceiling (app / (app log n) (app log 2))))
                 (a (app random byte-size)))
            (match
             (app = (app modulo-power a (app - n 1) n) 1)
             ((#f) (app #f))
             (_ (app is-fermat-prime? n (app - iterations 1)))))
          ((#f) (app #f))
          (_ (app #t))))
        (_ (app #t)))))
    (generate-fermat-prime
     (λ (byte-size iterations)
       (let ((n (app random byte-size)))
         (match
          (match
           (app not (app is-trivial-composite? n))
           ((#f) (app #f))
           (_
            (match
             (app is-fermat-prime? n iterations)
             ((#f) (app #f))
             (_ (app #t)))))
          ((#f) (app generate-fermat-prime byte-size iterations))
          (_ n)))))
    (iterations 10)
    (byte-size 15))
   (app generate-fermat-prime byte-size iterations)))

'(query:
  (app * (-> base <-) (app modulo-power base (app - exp 1) n))
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * base (-> (app modulo-power base (app - exp 1) n) <-))
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (-> (app * base (app modulo-power base (app - ...) n)) <-) n)
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (-> (app square (app modulo-power base (app / ...) n)) <-) n)
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (app * base (app modulo-power base (app - ...) n)) (-> n <-))
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (app square (app modulo-power base (app / ...) n)) (-> n <-))
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app square (-> (app modulo-power base (app / exp 2) n) <-))
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let (... () (n (-> (app random byte-size) <-)) () ...) ...)
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let* (...
         ()
         (byte-size (-> (app ceiling (app / (app log ...) (app log ...))) <-))
         a
         ...)
    ...)
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let* (... byte-size (a (-> (app random byte-size) <-)) () ...) ...)
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let* (byte-size ... a) (-> (match (app = (app modulo-power ...) 1) ...) <-))
  (env (())))
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
   (app <= iterations 0)
   ((#f) (-> (match (let* (byte-size ... a) ...) ...) <-))
   _)
  (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app = (app modulo n 11) 0)
   ((#f) (-> (match (app = (app modulo ...) 0) ...) <-))
   _)
  (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app = (app modulo n 13) 0)
   ((#f) (-> (match (app = (app modulo ...) 0) ...) <-))
   _)
  (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app = (app modulo n 17) 0)
   ((#f) (-> (match (app = (app modulo ...) 0) ...) <-))
   _)
  (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app = (app modulo n 19) 0)
   ((#f) (-> (match (app = (app modulo ...) 0) ...) <-))
   _)
  (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app = (app modulo n 2) 0)
   ((#f) (-> (match (app = (app modulo ...) 0) ...) <-))
   _)
  (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app = (app modulo n 3) 0)
   ((#f) (-> (match (app = (app modulo ...) 0) ...) <-))
   _)
  (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app = (app modulo n 5) 0)
   ((#f) (-> (match (app = (app modulo ...) 0) ...) <-))
   _)
  (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app = (app modulo n 7) 0)
   ((#f) (-> (match (app = (app modulo ...) 0) ...) <-))
   _)
  (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app = (app modulo-power a (app - ...) n) 1)
   (#f)
   (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-)))
  (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app = (app modulo-power a (app - ...) n) 1)
   ((#f) (-> (app #f) <-))
   _)
  (env (())))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app not (app is-trivial-composite? n))
   (#f)
   (_ (-> (match (app is-fermat-prime? n iterations) ...) <-)))
  (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app odd? exp)
   (#f)
   (_ (-> (app modulo (app * base (app modulo-power ...)) n) <-)))
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app odd? exp)
   ((#f) (-> (app modulo (app square (app modulo-power ...)) n) <-))
   _)
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (match (app not (app is-trivial-composite? ...)) ...)
   (#f)
   (_ (-> n <-)))
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (match (app not (app is-trivial-composite? ...)) ...)
   ((#f) (-> (app generate-fermat-prime byte-size iterations) <-))
   _)
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (-> (app = (app modulo-power a (app - ...) n) 1) <-) (#f) _)
  (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app not (app is-trivial-composite? n)) <-) (#f) _)
  (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (match (app not (app is-trivial-composite? ...)) ...) <-) (#f) _)
  (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app = (app modulo n 11) 0) (#f) (_ (-> (app #t) <-)))
  (env (())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app = (app modulo n 13) 0) (#f) (_ (-> (app #t) <-)))
  (env (())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app = (app modulo n 17) 0) (#f) (_ (-> (app #t) <-)))
  (env (())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app = (app modulo n 19) 0) (#f) (_ (-> (app #t) <-)))
  (env (())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app = (app modulo n 2) 0) (#f) (_ (-> (app #t) <-)))
  (env (())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app = (app modulo n 23) 0) (#f) (_ (-> (app #t) <-)))
  (env (())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app = (app modulo n 23) 0) ((#f) (-> (app #f) <-)) _)
  (env (())))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app = (app modulo n 3) 0) (#f) (_ (-> (app #t) <-)))
  (env (())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app = (app modulo n 5) 0) (#f) (_ (-> (app #t) <-)))
  (env (())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app = (app modulo n 7) 0) (#f) (_ (-> (app #t) <-)))
  (env (())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app = exp 0) ((#f) (-> (match (app odd? exp) ...) <-)) _)
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app is-fermat-prime? n iterations) (#f) (_ (-> (app #t) <-)))
  (env (())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app is-fermat-prime? n iterations) ((#f) (-> (app #f) <-)) _)
  (env (())))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app not (app is-trivial-composite? n)) ((#f) (-> (app #f) <-)) _)
  (env (())))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (let* (byte-size ... a) ...) (#f) (_ (-> (app #t) <-)))
  (env (())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (let* (byte-size ... a) ...) ((#f) (-> (app #f) <-)) _)
  (env (())))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (n iterations) (-> (match (app <= iterations 0) ...) <-))
  (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: ((top) letrec* (square ... byte-size) ...) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app * (-> x <-) x) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app * x (-> x <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app - (-> exp <-) 1) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app - (-> iterations <-) 1) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app - (-> n <-) 1) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app / (-> (app log n) <-) (app log 2)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app / (-> exp <-) 2) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app / (app log n) (-> (app log 2) <-)) (env (())))
clos/con: ⊥
literals: '(0.6931471805599453 ⊥ ⊥)

'(query: (app <= (-> iterations <-) 0) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app = (-> (app modulo n 11) <-) 0) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app = (-> (app modulo n 13) <-) 0) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app = (-> (app modulo n 17) <-) 0) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app = (-> (app modulo n 19) <-) 0) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app = (-> (app modulo n 2) <-) 0) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app = (-> (app modulo n 23) <-) 0) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app = (-> (app modulo n 3) <-) 0) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app = (-> (app modulo n 5) <-) 0) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app = (-> (app modulo n 7) <-) 0) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app = (-> (app modulo-power a (app - n 1) n) <-) 1) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app = (-> exp <-) 0) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app ceiling (-> (app / (app log n) (app log 2)) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app generate-fermat-prime (-> byte-size <-) iterations) (env (())))
clos/con: ⊥
literals: '(15 ⊥ ⊥)

'(query: (app generate-fermat-prime byte-size (-> iterations <-)) (env (())))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query: (app is-fermat-prime? (-> n <-) (app - iterations 1)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app is-fermat-prime? (-> n <-) iterations) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app is-fermat-prime? n (-> (app - iterations 1) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app is-fermat-prime? n (-> iterations <-)) (env (())))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query: (app is-trivial-composite? (-> n <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app log (-> n <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo (-> n <-) 11) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo (-> n <-) 13) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo (-> n <-) 17) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo (-> n <-) 19) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo (-> n <-) 2) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo (-> n <-) 23) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo (-> n <-) 3) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo (-> n <-) 5) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo (-> n <-) 7) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo-power (-> a <-) (app - n 1) n) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo-power (-> base <-) (app - exp 1) n) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo-power (-> base <-) (app / exp 2) n) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo-power a (-> (app - n 1) <-) n) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo-power a (app - n 1) (-> n <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo-power base (-> (app - exp 1) <-) n) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo-power base (-> (app / exp 2) <-) n) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo-power base (app - exp 1) (-> n <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo-power base (app / exp 2) (-> n <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app not (-> (app is-trivial-composite? n) <-)) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app odd? (-> exp <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app random (-> byte-size <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app random (-> byte-size <-)) (env (())))
clos/con: ⊥
literals: '(15 ⊥ ⊥)

'(query: (let (n) (-> (match (match (app not ...) ...) ...) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (match (-> (app <= iterations 0) <-) (#f) _) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app = (app modulo n 11) 0) <-) (#f) _) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app = (app modulo n 13) 0) <-) (#f) _) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app = (app modulo n 17) 0) <-) (#f) _) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app = (app modulo n 19) 0) <-) (#f) _) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app = (app modulo n 2) 0) <-) (#f) _) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app = (app modulo n 23) 0) <-) (#f) _) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app = (app modulo n 3) 0) <-) (#f) _) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app = (app modulo n 5) 0) <-) (#f) _) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app = (app modulo n 7) 0) <-) (#f) _) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app = exp 0) <-) (#f) _) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app is-fermat-prime? n iterations) <-) (#f) _) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app odd? exp) <-) (#f) _) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (let* (byte-size ... a) ...) <-) (#f) _) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app <= iterations 0) (#f) (_ (-> (app #t) <-))) (env (())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (base exp n) (-> (match (app = exp 0) ...) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (λ (byte-size iterations) (-> (let (n) ...) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (λ (n) (-> (match (app = (app modulo ...) 0) ...) <-)) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (x) (-> (app * x x) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  a
  (let* (... byte-size (a (-> (app random byte-size) <-)) () ...) ...)
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  byte-size
  (let* (...
         ()
         (byte-size (-> (app ceiling (app / (app log ...) (app log ...))) <-))
         a
         ...)
    ...)
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  byte-size
  (letrec* (... iterations (byte-size (-> 15 <-)) () ...) ...)
  (env ()))
clos/con: ⊥
literals: '(15 ⊥ ⊥)

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
  (env (())))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(store:
  iterations
  (λ (n iterations) (-> (match (app <= iterations 0) ...) <-))
  (env (())))
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
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  n
  (λ (n iterations) (-> (match (app <= iterations 0) ...) <-))
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  square
  (letrec* (... () (square (-> (λ (x) ...) <-)) modulo-power ...) ...)
  (env ()))
clos/con:
	'((letrec* (... () (square (-> (λ (x) ...) <-)) modulo-power ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: base (λ (base exp n) (-> (match (app = exp 0) ...) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store: byte-size (λ (byte-size iterations) (-> (let (n) ...) <-)) (env (())))
clos/con: ⊥
literals: '(15 ⊥ ⊥)

'(store: exp (λ (base exp n) (-> (match (app = exp 0) ...) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store: n (λ (base exp n) (-> (match (app = exp 0) ...) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store: n (λ (n) (-> (match (app = (app modulo ...) 0) ...) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store: x (λ (x) (-> (app * x x) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)
