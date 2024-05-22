'(expression:
  (lettypes
   ((error r))
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
            (app
             modulo
             (app square (app modulo-power base (app / exp 2) n))
             n))
           (_
            (app
             modulo
             (app * base (app modulo-power base (app - exp 1) n))
             n))))
         (_ 1))))
     (jacobi
      (λ (a n)
        (match
         (app = n 1)
         ((#f)
          (match
           (app = a 1)
           ((#f)
            (match
             (app not (app = (app gcd a n) 1))
             ((#f)
              (match
               (app
                and
                (app = a 2)
                (let ((n-mod-8 (app modulo n 8)))
                  (match
                   (app or (app = n-mod-8 1) (app = n-mod-8 7))
                   ((#f)
                    (match
                     (app or (app = n-mod-8 3) (app = n-mod-8 5))
                     ((#f) (app error "no-match"))
                     (_ -1)))
                   (_ 1))))
               ((#f)
                (match
                 (app > a n)
                 ((#f)
                  (match
                   (app even? a)
                   ((#f)
                    (match
                     (app even? n)
                     ((#f)
                      (app
                       *
                       (app jacobi n a)
                       (match
                        (app even? (app / (app * (app - a 1) (app - n 1)) 4))
                        ((#f) -1)
                        (_ 1))))
                     (_ (app * (app jacobi a (app / n 2)) (app jacobi a 2)))))
                   (_ (app * (app jacobi (app / a 2) n) (app jacobi 2 n)))))
                 (_ (app jacobi (app modulo a n) n))))
               (c-x c-x)))
             (_ 0)))
           (_ 1)))
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
     (is-solovay-strassen-prime?
      (λ (n iterations)
        (match
         (app <= iterations 0)
         ((#f)
          (match
           (app and (app even? n) (app not (app = n 2)))
           ((#f)
            (let* ((byte-size (app ceiling (app / (app log n) (app log 2))))
                   (a
                    (app + 1 (app modulo (app random byte-size) (app - n 1)))))
              (let* ((jacobi-a-n (app jacobi a n))
                     (exp (app modulo-power a (app / (app - n 1) 2) n)))
                (match
                 (app
                  or
                  (app = jacobi-a-n 0)
                  (app not (app = (app modulo jacobi-a-n n) exp)))
                 ((#f) (app is-solovay-strassen-prime? n (app - iterations 1)))
                 (_ (app #f))))))
           (_ (app #f))))
         (_ (app #t)))))
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
     (generate-solovay-strassen-prime
      (λ (byte-size iterations)
        (let ((n (app generate-fermat-prime byte-size 5)))
          (match
           (app is-solovay-strassen-prime? n iterations)
           ((#f) (app generate-solovay-strassen-prime byte-size iterations))
           (_ n)))))
     (iterations 10)
     (byte-size 15))
    (let ((_ (app display "Generating prime...")))
      (let ((_ (app newline)))
        (let ((_
               (app
                display
                (app generate-solovay-strassen-prime byte-size iterations))))
          (let ((_
                 (app display " is prime with at least probability 1 - 1/2^")))
            (let ((_ (app display iterations)))
              (let ((_ (app display "."))) (app newline))))))))))

'(query: ((top) lettypes (error) ...) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (lettypes error ... error (letrec* (square ... byte-size) ...))
  (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (letrec* (... iterations (byte-size (-> 15 <-)) () ...) ...) (env ()))
clos/con: ⊥
literals: '(15 ⊥ ⊥)

'(query:
  (letrec*
   (... generate-solovay-strassen-prime (iterations (-> 10 <-)) byte-size ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query:
  (letrec*
   (...
    generate-fermat-prime
    (generate-solovay-strassen-prime (-> (λ (byte-size iterations) ...) <-))
    iterations
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    generate-fermat-prime
    (generate-solovay-strassen-prime (-> (λ (byte-size iterations) ...) <-))
    iterations
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (byte-size iterations) (-> (let (n) ...) <-))
  (env ((□? (byte-size iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let (... () (n (-> (app generate-fermat-prime byte-size 5) <-)) () ...) ...)
  (env ((□? (byte-size iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app generate-fermat-prime byte-size (-> 5 <-))
  (env ((□? (byte-size iterations)))))
clos/con: ⊥
literals: '(5 ⊥ ⊥)

'(query:
  (app generate-fermat-prime (-> byte-size <-) 5)
  (env ((□? (byte-size iterations)))))
clos/con: ⊥
literals: '(15 ⊥ ⊥)

'(query:
  (app (-> generate-fermat-prime <-) byte-size 5)
  (env ((□? (byte-size iterations)))))
clos/con:
	'((letrec*
   (...
    is-solovay-strassen-prime?
    (generate-fermat-prime (-> (λ (byte-size iterations) ...) <-))
    generate-solovay-strassen-prime
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (n) (-> (match (app is-solovay-strassen-prime? n iterations) ...) <-))
  (env ((□? (byte-size iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app is-solovay-strassen-prime? n iterations) (#f) (_ (-> n <-)))
  (env ((□? (byte-size iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app is-solovay-strassen-prime? n iterations)
   ((#f) (-> (app generate-solovay-strassen-prime byte-size iterations) <-))
   _)
  (env ((□? (byte-size iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app generate-solovay-strassen-prime byte-size (-> iterations <-))
  (env ((□? (byte-size iterations)))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query:
  (app generate-solovay-strassen-prime (-> byte-size <-) iterations)
  (env ((□? (byte-size iterations)))))
clos/con: ⊥
literals: '(15 ⊥ ⊥)

'(query:
  (app (-> generate-solovay-strassen-prime <-) byte-size iterations)
  (env ((□? (byte-size iterations)))))
clos/con:
	'((letrec*
   (...
    generate-fermat-prime
    (generate-solovay-strassen-prime (-> (λ (byte-size iterations) ...) <-))
    iterations
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _)
  (env ((□? (byte-size iterations)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app is-solovay-strassen-prime? n (-> iterations <-))
  (env ((□? (byte-size iterations)))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query:
  (app is-solovay-strassen-prime? (-> n <-) iterations)
  (env ((□? (byte-size iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app (-> is-solovay-strassen-prime? <-) n iterations)
  (env ((□? (byte-size iterations)))))
clos/con:
	'((letrec*
   (...
    is-fermat-prime?
    (is-solovay-strassen-prime? (-> (λ (n iterations) ...) <-))
    generate-fermat-prime
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    is-solovay-strassen-prime?
    (generate-fermat-prime (-> (λ (byte-size iterations) ...) <-))
    generate-solovay-strassen-prime
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    is-solovay-strassen-prime?
    (generate-fermat-prime (-> (λ (byte-size iterations) ...) <-))
    generate-solovay-strassen-prime
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (byte-size iterations) (-> (let (n) ...) <-))
  (env ((□? (byte-size iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let (... () (n (-> (app random byte-size) <-)) () ...) ...)
  (env ((□? (byte-size iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app random (-> byte-size <-)) (env ((□? (byte-size iterations)))))
clos/con: ⊥
literals: '(15 ⊥ ⊥)

'(query: (app (-> random <-) byte-size) (env ((□? (byte-size iterations)))))
clos/con:
	'((prim random) (env ()))
literals: '(⊥ ⊥ ⊥)

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
  (env ((□? (byte-size iterations)))))
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
  (env ((□? (byte-size iterations)))))
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
  (env ((□? (byte-size iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app generate-fermat-prime byte-size (-> iterations <-))
  (env ((□? (byte-size iterations)))))
clos/con: ⊥
literals: '(5 ⊥ ⊥)

'(query:
  (app generate-fermat-prime (-> byte-size <-) iterations)
  (env ((□? (byte-size iterations)))))
clos/con: ⊥
literals: '(15 ⊥ ⊥)

'(query:
  (app (-> generate-fermat-prime <-) byte-size iterations)
  (env ((□? (byte-size iterations)))))
clos/con:
	'((letrec*
   (...
    is-solovay-strassen-prime?
    (generate-fermat-prime (-> (λ (byte-size iterations) ...) <-))
    generate-solovay-strassen-prime
    ...)
   ...)
  (env ()))
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
  (env ((□? (byte-size iterations)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   and
   (app not (app is-trivial-composite? n))
   (-> (app is-fermat-prime? n iterations) <-))
  (env ((□? (byte-size iterations)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app is-fermat-prime? n (-> iterations <-))
  (env ((□? (byte-size iterations)))))
clos/con: ⊥
literals: '(5 ⊥ ⊥)

'(query:
  (app is-fermat-prime? (-> n <-) iterations)
  (env ((□? (byte-size iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app (-> is-fermat-prime? <-) n iterations)
  (env ((□? (byte-size iterations)))))
clos/con:
	'((letrec*
   (...
    is-trivial-composite?
    (is-fermat-prime? (-> (λ (n iterations) ...) <-))
    is-solovay-strassen-prime?
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   and
   (-> (app not (app is-trivial-composite? n)) <-)
   (app is-fermat-prime? n iterations))
  (env ((□? (byte-size iterations)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app not (-> (app is-trivial-composite? n) <-))
  (env ((□? (byte-size iterations)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app is-trivial-composite? (-> n <-))
  (env ((□? (byte-size iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app (-> is-trivial-composite? <-) n)
  (env ((□? (byte-size iterations)))))
clos/con:
	'((letrec*
   (...
    jacobi
    (is-trivial-composite? (-> (λ (n) ...) <-))
    is-fermat-prime?
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> not <-) (app is-trivial-composite? n))
  (env ((□? (byte-size iterations)))))
clos/con:
	'((prim not) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   (-> and <-)
   (app not (app is-trivial-composite? n))
   (app is-fermat-prime? n iterations))
  (env ((□? (byte-size iterations)))))
clos/con:
	'((prim and) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    is-fermat-prime?
    (is-solovay-strassen-prime? (-> (λ (n iterations) ...) <-))
    generate-fermat-prime
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    is-fermat-prime?
    (is-solovay-strassen-prime? (-> (λ (n iterations) ...) <-))
    generate-fermat-prime
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (n iterations) (-> (match (app <= iterations 0) ...) <-))
  (env ((□? (n iterations)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app <= iterations 0) (#f) (_ (-> (app #t) <-)))
  (env ((□? (n iterations)))))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ((□? (n iterations)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app <= iterations 0)
   ((#f) (-> (match (app and (app even? n) (app not (app = n 2))) ...) <-))
   _)
  (env ((□? (n iterations)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app and (app even? n) (app not (app = n 2)))
   (#f)
   (_ (-> (app #f) <-)))
  (env ((□? (n iterations)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((□? (n iterations)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app and (app even? n) (app not (app = n 2)))
   ((#f) (-> (let* (byte-size ... a) ...) <-))
   _)
  (env ((□? (n iterations)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let* (...
         byte-size
         (a (-> (app + 1 (app modulo (app random byte-size) (app - n 1))) <-))
         ()
         ...)
    ...)
  (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app + 1 (-> (app modulo (app random byte-size) (app - n 1)) <-))
  (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (app random byte-size) (-> (app - n 1) <-))
  (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app - n (-> 1 <-)) (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app - (-> n <-) 1) (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> - <-) n 1) (env ((□? (n iterations)))))
clos/con:
	'((prim -) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app modulo (-> (app random byte-size) <-) (app - n 1))
  (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app random (-> byte-size <-)) (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> random <-) byte-size) (env ((□? (n iterations)))))
clos/con:
	'((prim random) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> modulo <-) (app random byte-size) (app - n 1))
  (env ((□? (n iterations)))))
clos/con:
	'((prim modulo) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app + (-> 1 <-) (app modulo (app random byte-size) (app - n 1)))
  (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (app (-> + <-) 1 (app modulo (app random byte-size) (app - n 1)))
  (env ((□? (n iterations)))))
clos/con:
	'((prim +) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let* (...
         ()
         (byte-size (-> (app ceiling (app / (app log n) (app log 2))) <-))
         a
         ...)
    ...)
  (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app ceiling (-> (app / (app log n) (app log 2)) <-))
  (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app / (app log n) (-> (app log 2) <-)) (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(0.6931471805599453 ⊥ ⊥)

'(query: (app log (-> 2 <-)) (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query: (app (-> log <-) 2) (env ((□? (n iterations)))))
clos/con:
	'((prim log) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app / (-> (app log n) <-) (app log 2)) (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app log (-> n <-)) (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> log <-) n) (env ((□? (n iterations)))))
clos/con:
	'((prim log) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> / <-) (app log n) (app log 2)) (env ((□? (n iterations)))))
clos/con:
	'((prim /) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> ceiling <-) (app / (app log n) (app log 2)))
  (env ((□? (n iterations)))))
clos/con:
	'((prim ceiling) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let* (byte-size ... a) (-> (let* (jacobi-a-n ... exp) ...) <-))
  (env ((□? (n iterations)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let* (...
         jacobi-a-n
         (exp (-> (app modulo-power a (app / (app - n 1) 2) n) <-))
         ()
         ...)
    ...)
  (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo-power a (app / (app - n 1) 2) (-> n <-))
  (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo-power a (-> (app / (app - n 1) 2) <-) n)
  (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app / (app - n 1) (-> 2 <-)) (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query: (app / (-> (app - n 1) <-) 2) (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app - n (-> 1 <-)) (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app - (-> n <-) 1) (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> - <-) n 1) (env ((□? (n iterations)))))
clos/con:
	'((prim -) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> / <-) (app - n 1) 2) (env ((□? (n iterations)))))
clos/con:
	'((prim /) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app modulo-power (-> a <-) (app / (app - n 1) 2) n)
  (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app (-> modulo-power <-) a (app / (app - n 1) 2) n)
  (env ((□? (n iterations)))))
clos/con:
	'((letrec*
   (... square (modulo-power (-> (λ (base exp n) ...) <-)) jacobi ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...)
  (env ((□? (n iterations)))))
clos/con:
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env
   (((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-)))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...)))))
literals: '(⊤ ⊥ ⊥)

'(query: (app jacobi a (-> n <-)) (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app jacobi (-> a <-) n) (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> jacobi <-) a n) (env ((□? (n iterations)))))
clos/con:
	'((letrec*
   (... modulo-power (jacobi (-> (λ (a n) ...) <-)) is-trivial-composite? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let* (jacobi-a-n ... exp)
    (->
     (match
      (app
       or
       (app = jacobi-a-n 0)
       (app not (app = (app modulo jacobi-a-n n) exp)))
      ...)
     <-))
  (env ((□? (n iterations)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app
    or
    (app = jacobi-a-n 0)
    (app not (app = (app modulo jacobi-a-n n) exp)))
   (#f)
   (_ (-> (app #f) <-)))
  (env ((□? (n iterations)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((□? (n iterations)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app
    or
    (app = jacobi-a-n 0)
    (app not (app = (app modulo jacobi-a-n n) exp)))
   ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
   _)
  (env ((□? (n iterations)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app is-solovay-strassen-prime? n (-> (app - iterations 1) <-))
  (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app - iterations (-> 1 <-)) (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app - (-> iterations <-) 1) (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> - <-) iterations 1) (env ((□? (n iterations)))))
clos/con:
	'((prim -) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app is-solovay-strassen-prime? (-> n <-) (app - iterations 1))
  (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app (-> is-solovay-strassen-prime? <-) n (app - iterations 1))
  (env ((□? (n iterations)))))
clos/con:
	'((letrec*
   (...
    is-fermat-prime?
    (is-solovay-strassen-prime? (-> (λ (n iterations) ...) <-))
    generate-fermat-prime
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (->
    (app
     or
     (app = jacobi-a-n 0)
     (app not (app = (app modulo jacobi-a-n n) exp)))
    <-)
   (#f)
   _)
  (env ((□? (n iterations)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   or
   (app = jacobi-a-n 0)
   (-> (app not (app = (app modulo jacobi-a-n n) exp)) <-))
  (env ((□? (n iterations)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app not (-> (app = (app modulo jacobi-a-n n) exp) <-))
  (env ((□? (n iterations)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app = (app modulo jacobi-a-n n) (-> exp <-))
  (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> (app modulo jacobi-a-n n) <-) exp)
  (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo jacobi-a-n (-> n <-)) (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo (-> jacobi-a-n <-) n) (env ((□? (n iterations)))))
clos/con:
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env
   (((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-)))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...)))))
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> modulo <-) jacobi-a-n n) (env ((□? (n iterations)))))
clos/con:
	'((prim modulo) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> = <-) (app modulo jacobi-a-n n) exp)
  (env ((□? (n iterations)))))
clos/con:
	'((prim =) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> not <-) (app = (app modulo jacobi-a-n n) exp))
  (env ((□? (n iterations)))))
clos/con:
	'((prim not) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   or
   (-> (app = jacobi-a-n 0) <-)
   (app not (app = (app modulo jacobi-a-n n) exp)))
  (env ((□? (n iterations)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app = jacobi-a-n (-> 0 <-)) (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query: (app = (-> jacobi-a-n <-) 0) (env ((□? (n iterations)))))
clos/con:
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env
   (((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-)))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...)))))
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> = <-) jacobi-a-n 0) (env ((□? (n iterations)))))
clos/con:
	'((prim =) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   (-> or <-)
   (app = jacobi-a-n 0)
   (app not (app = (app modulo jacobi-a-n n) exp)))
  (env ((□? (n iterations)))))
clos/con:
	'((prim or) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app and (app even? n) (app not (app = n 2))) <-) (#f) _)
  (env ((□? (n iterations)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app and (app even? n) (-> (app not (app = n 2)) <-))
  (env ((□? (n iterations)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app not (-> (app = n 2) <-)) (env ((□? (n iterations)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app = n (-> 2 <-)) (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query: (app = (-> n <-) 2) (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> = <-) n 2) (env ((□? (n iterations)))))
clos/con:
	'((prim =) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> not <-) (app = n 2)) (env ((□? (n iterations)))))
clos/con:
	'((prim not) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app and (-> (app even? n) <-) (app not (app = n 2)))
  (env ((□? (n iterations)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app even? (-> n <-)) (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> even? <-) n) (env ((□? (n iterations)))))
clos/con:
	'((prim even?) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> and <-) (app even? n) (app not (app = n 2)))
  (env ((□? (n iterations)))))
clos/con:
	'((prim and) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app <= iterations 0) <-) (#f) _)
  (env ((□? (n iterations)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app <= iterations (-> 0 <-)) (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query: (app <= (-> iterations <-) 0) (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> <= <-) iterations 0) (env ((□? (n iterations)))))
clos/con:
	'((prim <=) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    is-trivial-composite?
    (is-fermat-prime? (-> (λ (n iterations) ...) <-))
    is-solovay-strassen-prime?
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    is-trivial-composite?
    (is-fermat-prime? (-> (λ (n iterations) ...) <-))
    is-solovay-strassen-prime?
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (n iterations)
    (-> (app or (app <= iterations 0) (let* (byte-size ... a) ...)) <-))
  (env ((□? (n iterations)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (app <= iterations 0) (-> (let* (byte-size ... a) ...) <-))
  (env ((□? (n iterations)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let* (... byte-size (a (-> (app random byte-size) <-)) () ...) ...)
  (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app random (-> byte-size <-)) (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> random <-) byte-size) (env ((□? (n iterations)))))
clos/con:
	'((prim random) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let* (...
         ()
         (byte-size (-> (app ceiling (app / (app log n) (app log 2))) <-))
         a
         ...)
    ...)
  (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app ceiling (-> (app / (app log n) (app log 2)) <-))
  (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app / (app log n) (-> (app log 2) <-)) (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(0.6931471805599453 ⊥ ⊥)

'(query: (app log (-> 2 <-)) (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query: (app (-> log <-) 2) (env ((□? (n iterations)))))
clos/con:
	'((prim log) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app / (-> (app log n) <-) (app log 2)) (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app log (-> n <-)) (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> log <-) n) (env ((□? (n iterations)))))
clos/con:
	'((prim log) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> / <-) (app log n) (app log 2)) (env ((□? (n iterations)))))
clos/con:
	'((prim /) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> ceiling <-) (app / (app log n) (app log 2)))
  (env ((□? (n iterations)))))
clos/con:
	'((prim ceiling) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let* (byte-size ... a)
    (-> (match (app = (app modulo-power a (app - n 1) n) 1) ...) <-))
  (env ((□? (n iterations)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app = (app modulo-power a (app - n 1) n) 1)
   (#f)
   (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-)))
  (env ((□? (n iterations)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app is-fermat-prime? n (-> (app - iterations 1) <-))
  (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app - iterations (-> 1 <-)) (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app - (-> iterations <-) 1) (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> - <-) iterations 1) (env ((□? (n iterations)))))
clos/con:
	'((prim -) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app is-fermat-prime? (-> n <-) (app - iterations 1))
  (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app (-> is-fermat-prime? <-) n (app - iterations 1))
  (env ((□? (n iterations)))))
clos/con:
	'((letrec*
   (...
    is-trivial-composite?
    (is-fermat-prime? (-> (λ (n iterations) ...) <-))
    is-solovay-strassen-prime?
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app = (app modulo-power a (app - n 1) n) 1)
   ((#f) (-> (app #f) <-))
   _)
  (env ((□? (n iterations)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((□? (n iterations)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app = (app modulo-power a (app - n 1) n) 1) <-) (#f) _)
  (env ((□? (n iterations)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app = (app modulo-power a (app - n 1) n) (-> 1 <-))
  (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (app = (-> (app modulo-power a (app - n 1) n) <-) 1)
  (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo-power a (app - n 1) (-> n <-))
  (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo-power a (-> (app - n 1) <-) n)
  (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app - n (-> 1 <-)) (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app - (-> n <-) 1) (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> - <-) n 1) (env ((□? (n iterations)))))
clos/con:
	'((prim -) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app modulo-power (-> a <-) (app - n 1) n)
  (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app (-> modulo-power <-) a (app - n 1) n)
  (env ((□? (n iterations)))))
clos/con:
	'((letrec*
   (... square (modulo-power (-> (λ (base exp n) ...) <-)) jacobi ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> = <-) (app modulo-power a (app - n 1) n) 1)
  (env ((□? (n iterations)))))
clos/con:
	'((prim =) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (-> (app <= iterations 0) <-) (let* (byte-size ... a) ...))
  (env ((□? (n iterations)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app <= iterations (-> 0 <-)) (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query: (app <= (-> iterations <-) 0) (env ((□? (n iterations)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> <= <-) iterations 0) (env ((□? (n iterations)))))
clos/con:
	'((prim <=) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> or <-) (app <= iterations 0) (let* (byte-size ... a) ...))
  (env ((□? (n iterations)))))
clos/con:
	'((prim or) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    jacobi
    (is-trivial-composite? (-> (λ (n) ...) <-))
    is-fermat-prime?
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    jacobi
    (is-trivial-composite? (-> (λ (n) ...) <-))
    is-fermat-prime?
    ...)
   ...)
  (env ()))
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
  (env ((□? (n)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
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
  (env ((□? (n)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app = (app modulo n 23) (-> 0 <-)) (env ((□? (n)))))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query: (app = (-> (app modulo n 23) <-) 0) (env ((□? (n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo n (-> 23 <-)) (env ((□? (n)))))
clos/con: ⊥
literals: '(23 ⊥ ⊥)

'(query: (app modulo (-> n <-) 23) (env ((□? (n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> modulo <-) n 23) (env ((□? (n)))))
clos/con:
	'((prim modulo) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> = <-) (app modulo n 23) 0) (env ((□? (n)))))
clos/con:
	'((prim =) (env ()))
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
  (env ((□? (n)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app = (app modulo n 19) (-> 0 <-)) (env ((□? (n)))))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query: (app = (-> (app modulo n 19) <-) 0) (env ((□? (n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo n (-> 19 <-)) (env ((□? (n)))))
clos/con: ⊥
literals: '(19 ⊥ ⊥)

'(query: (app modulo (-> n <-) 19) (env ((□? (n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> modulo <-) n 19) (env ((□? (n)))))
clos/con:
	'((prim modulo) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> = <-) (app modulo n 19) 0) (env ((□? (n)))))
clos/con:
	'((prim =) (env ()))
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
  (env ((□? (n)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app = (app modulo n 17) (-> 0 <-)) (env ((□? (n)))))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query: (app = (-> (app modulo n 17) <-) 0) (env ((□? (n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo n (-> 17 <-)) (env ((□? (n)))))
clos/con: ⊥
literals: '(17 ⊥ ⊥)

'(query: (app modulo (-> n <-) 17) (env ((□? (n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> modulo <-) n 17) (env ((□? (n)))))
clos/con:
	'((prim modulo) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> = <-) (app modulo n 17) 0) (env ((□? (n)))))
clos/con:
	'((prim =) (env ()))
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
  (env ((□? (n)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app = (app modulo n 13) (-> 0 <-)) (env ((□? (n)))))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query: (app = (-> (app modulo n 13) <-) 0) (env ((□? (n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo n (-> 13 <-)) (env ((□? (n)))))
clos/con: ⊥
literals: '(13 ⊥ ⊥)

'(query: (app modulo (-> n <-) 13) (env ((□? (n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> modulo <-) n 13) (env ((□? (n)))))
clos/con:
	'((prim modulo) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> = <-) (app modulo n 13) 0) (env ((□? (n)))))
clos/con:
	'((prim =) (env ()))
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
  (env ((□? (n)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app = (app modulo n 11) (-> 0 <-)) (env ((□? (n)))))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query: (app = (-> (app modulo n 11) <-) 0) (env ((□? (n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo n (-> 11 <-)) (env ((□? (n)))))
clos/con: ⊥
literals: '(11 ⊥ ⊥)

'(query: (app modulo (-> n <-) 11) (env ((□? (n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> modulo <-) n 11) (env ((□? (n)))))
clos/con:
	'((prim modulo) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> = <-) (app modulo n 11) 0) (env ((□? (n)))))
clos/con:
	'((prim =) (env ()))
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
  (env ((□? (n)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app = (app modulo n 7) (-> 0 <-)) (env ((□? (n)))))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query: (app = (-> (app modulo n 7) <-) 0) (env ((□? (n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo n (-> 7 <-)) (env ((□? (n)))))
clos/con: ⊥
literals: '(7 ⊥ ⊥)

'(query: (app modulo (-> n <-) 7) (env ((□? (n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> modulo <-) n 7) (env ((□? (n)))))
clos/con:
	'((prim modulo) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> = <-) (app modulo n 7) 0) (env ((□? (n)))))
clos/con:
	'((prim =) (env ()))
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
  (env ((□? (n)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app = (app modulo n 5) (-> 0 <-)) (env ((□? (n)))))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query: (app = (-> (app modulo n 5) <-) 0) (env ((□? (n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo n (-> 5 <-)) (env ((□? (n)))))
clos/con: ⊥
literals: '(5 ⊥ ⊥)

'(query: (app modulo (-> n <-) 5) (env ((□? (n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> modulo <-) n 5) (env ((□? (n)))))
clos/con:
	'((prim modulo) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> = <-) (app modulo n 5) 0) (env ((□? (n)))))
clos/con:
	'((prim =) (env ()))
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
  (env ((□? (n)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app = (app modulo n 3) (-> 0 <-)) (env ((□? (n)))))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query: (app = (-> (app modulo n 3) <-) 0) (env ((□? (n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo n (-> 3 <-)) (env ((□? (n)))))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(query: (app modulo (-> n <-) 3) (env ((□? (n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> modulo <-) n 3) (env ((□? (n)))))
clos/con:
	'((prim modulo) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> = <-) (app modulo n 3) 0) (env ((□? (n)))))
clos/con:
	'((prim =) (env ()))
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
  (env ((□? (n)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app = (app modulo n 2) (-> 0 <-)) (env ((□? (n)))))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query: (app = (-> (app modulo n 2) <-) 0) (env ((□? (n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo n (-> 2 <-)) (env ((□? (n)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query: (app modulo (-> n <-) 2) (env ((□? (n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> modulo <-) n 2) (env ((□? (n)))))
clos/con:
	'((prim modulo) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> = <-) (app modulo n 2) 0) (env ((□? (n)))))
clos/con:
	'((prim =) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   (-> or <-)
   (app = (app modulo n 2) 0)
   (app = (app modulo n 3) 0)
   (app = (app modulo n 5) 0)
   (app = (app modulo n 7) 0)
   (app = (app modulo n 11) 0)
   (app = (app modulo n 13) 0)
   (app = (app modulo n 17) 0)
   (app = (app modulo n 19) 0)
   (app = (app modulo n 23) 0))
  (env ((□? (n)))))
clos/con:
	'((prim or) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... modulo-power (jacobi (-> (λ (a n) ...) <-)) is-trivial-composite? ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... modulo-power (jacobi (-> (λ (a n) ...) <-)) is-trivial-composite? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (a n) (-> (match (app = n 1) ...) <-)) (env ((□? (a n)))))
clos/con:
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env
   (((app
      *
      (-> (app jacobi n a) <-)
      (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env
   (((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-)))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...)))))
literals: '(⊤ ⊥ ⊥)

'(query: (match (app = n 1) (#f) (_ (-> 1 <-))) (env ((□? (a n)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (match (app = n 1) ((#f) (-> (match (app = a 1) ...) <-)) _)
  (env ((□? (a n)))))
clos/con:
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env
   (((app
      *
      (-> (app jacobi n a) <-)
      (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env
   (((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-)))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...)))))
literals: '(⊤ ⊥ ⊥)

'(query: (match (app = a 1) (#f) (_ (-> 1 <-))) (env ((□? (a n)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (match
   (app = a 1)
   ((#f) (-> (match (app not (app = (app gcd a n) 1)) ...) <-))
   _)
  (env ((□? (a n)))))
clos/con:
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env
   (((app
      *
      (-> (app jacobi n a) <-)
      (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env
   (((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-)))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...)))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app not (app = (app gcd a n) 1)) (#f) (_ (-> 0 <-)))
  (env ((□? (a n)))))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query:
  (match
   (app not (app = (app gcd a n) 1))
   ((#f) (-> (match (app and (app = a 2) (let (n-mod-8) ...)) ...) <-))
   _)
  (env ((□? (a n)))))
clos/con:
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env
   (((app
      *
      (-> (app jacobi n a) <-)
      (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env
   (((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-)))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...)))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app and (app = a 2) (let (n-mod-8) ...)) (#f) (c-x (-> c-x <-)))
  (env ((□? (a n)))))
clos/con:
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env
   (((app
      *
      (-> (app jacobi n a) <-)
      (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env
   (((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-)))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...)))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app and (app = a 2) (let (n-mod-8) ...))
   ((#f) (-> (match (app > a n) ...) <-))
   c-x)
  (env ((□? (a n)))))
clos/con:
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env
   (((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-)))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-)))
  (env ((□? (a n)))))
clos/con:
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env
   (((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-)))))))
literals: '(⊤ ⊥ ⊥)

'(query: (app jacobi (app modulo a n) (-> n <-)) (env ((□? (a n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app jacobi (-> (app modulo a n) <-) n) (env ((□? (a n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo a (-> n <-)) (env ((□? (a n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo (-> a <-) n) (env ((□? (a n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> modulo <-) a n) (env ((□? (a n)))))
clos/con:
	'((prim modulo) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> jacobi <-) (app modulo a n) n) (env ((□? (a n)))))
clos/con:
	'((letrec*
   (... modulo-power (jacobi (-> (λ (a n) ...) <-)) is-trivial-composite? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app > a n) ((#f) (-> (match (app even? a) ...) <-)) _)
  (env ((□? (a n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app even? a)
   (#f)
   (_ (-> (app * (app jacobi (app / a 2) n) (app jacobi 2 n)) <-)))
  (env ((□? (a n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-))
  (env ((□? (a n)))))
clos/con:
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query: (app jacobi 2 (-> n <-)) (env ((□? (a n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app jacobi (-> 2 <-) n) (env ((□? (a n)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query: (app (-> jacobi <-) 2 n) (env ((□? (a n)))))
clos/con:
	'((letrec*
   (... modulo-power (jacobi (-> (λ (a n) ...) <-)) is-trivial-composite? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n))
  (env ((□? (a n)))))
clos/con:
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env
   (((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-)))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n))))))
literals: '(⊤ ⊥ ⊥)

'(query: (app jacobi (app / a 2) (-> n <-)) (env ((□? (a n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app jacobi (-> (app / a 2) <-) n) (env ((□? (a n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app / a (-> 2 <-)) (env ((□? (a n)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query: (app / (-> a <-) 2) (env ((□? (a n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> / <-) a 2) (env ((□? (a n)))))
clos/con:
	'((prim /) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> jacobi <-) (app / a 2) n) (env ((□? (a n)))))
clos/con:
	'((letrec*
   (... modulo-power (jacobi (-> (λ (a n) ...) <-)) is-trivial-composite? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> * <-) (app jacobi (app / a 2) n) (app jacobi 2 n))
  (env ((□? (a n)))))
clos/con:
	'((prim *) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app even? a) ((#f) (-> (match (app even? n) ...) <-)) _)
  (env ((□? (a n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app even? n)
   (#f)
   (_ (-> (app * (app jacobi a (app / n 2)) (app jacobi a 2)) <-)))
  (env ((□? (a n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-))
  (env ((□? (a n)))))
clos/con:
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env
   (((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-)))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query: (app jacobi a (-> 2 <-)) (env ((□? (a n)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query: (app jacobi (-> a <-) 2) (env ((□? (a n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> jacobi <-) a 2) (env ((□? (a n)))))
clos/con:
	'((letrec*
   (... modulo-power (jacobi (-> (λ (a n) ...) <-)) is-trivial-composite? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2))
  (env ((□? (a n)))))
clos/con:
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env
   (((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-)))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2))))))
literals: '(⊤ ⊥ ⊥)

'(query: (app jacobi a (-> (app / n 2) <-)) (env ((□? (a n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app / n (-> 2 <-)) (env ((□? (a n)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query: (app / (-> n <-) 2) (env ((□? (a n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> / <-) n 2) (env ((□? (a n)))))
clos/con:
	'((prim /) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app jacobi (-> a <-) (app / n 2)) (env ((□? (a n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> jacobi <-) a (app / n 2)) (env ((□? (a n)))))
clos/con:
	'((letrec*
   (... modulo-power (jacobi (-> (λ (a n) ...) <-)) is-trivial-composite? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> * <-) (app jacobi a (app / n 2)) (app jacobi a 2))
  (env ((□? (a n)))))
clos/con:
	'((prim *) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app even? n)
   ((#f)
    (->
     (app
      *
      (app jacobi n a)
      (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...))
     <-))
   _)
  (env ((□? (a n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app
   *
   (app jacobi n a)
   (-> (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...) <-))
  (env ((□? (a n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app even? (app / (app * (app - a 1) (app - n 1)) 4))
   (#f)
   (_ (-> 1 <-)))
  (env ((□? (a n)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (match
   (app even? (app / (app * (app - a 1) (app - n 1)) 4))
   ((#f) (-> -1 <-))
   _)
  (env ((□? (a n)))))
clos/con: ⊥
literals: '(-1 ⊥ ⊥)

'(query:
  (match (-> (app even? (app / (app * (app - a 1) (app - n 1)) 4)) <-) (#f) _)
  (env ((□? (a n)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app even? (-> (app / (app * (app - a 1) (app - n 1)) 4) <-))
  (env ((□? (a n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app / (app * (app - a 1) (app - n 1)) (-> 4 <-)) (env ((□? (a n)))))
clos/con: ⊥
literals: '(4 ⊥ ⊥)

'(query: (app / (-> (app * (app - a 1) (app - n 1)) <-) 4) (env ((□? (a n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app * (app - a 1) (-> (app - n 1) <-)) (env ((□? (a n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app - n (-> 1 <-)) (env ((□? (a n)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app - (-> n <-) 1) (env ((□? (a n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> - <-) n 1) (env ((□? (a n)))))
clos/con:
	'((prim -) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app * (-> (app - a 1) <-) (app - n 1)) (env ((□? (a n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app - a (-> 1 <-)) (env ((□? (a n)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app - (-> a <-) 1) (env ((□? (a n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> - <-) a 1) (env ((□? (a n)))))
clos/con:
	'((prim -) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> * <-) (app - a 1) (app - n 1)) (env ((□? (a n)))))
clos/con:
	'((prim *) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> / <-) (app * (app - a 1) (app - n 1)) 4) (env ((□? (a n)))))
clos/con:
	'((prim /) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> even? <-) (app / (app * (app - a 1) (app - n 1)) 4))
  (env ((□? (a n)))))
clos/con:
	'((prim even?) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   *
   (-> (app jacobi n a) <-)
   (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...))
  (env ((□? (a n)))))
clos/con:
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env
   (((app
      *
      (-> (app jacobi n a) <-)
      (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env
   (((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-)))))))
literals: '(⊤ ⊥ ⊥)

'(query: (app jacobi n (-> a <-)) (env ((□? (a n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app jacobi (-> n <-) a) (env ((□? (a n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> jacobi <-) n a) (env ((□? (a n)))))
clos/con:
	'((letrec*
   (... modulo-power (jacobi (-> (λ (a n) ...) <-)) is-trivial-composite? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   (-> * <-)
   (app jacobi n a)
   (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...))
  (env ((□? (a n)))))
clos/con:
	'((prim *) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app even? n) <-) (#f) _) (env ((□? (a n)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app even? (-> n <-)) (env ((□? (a n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> even? <-) n) (env ((□? (a n)))))
clos/con:
	'((prim even?) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app even? a) <-) (#f) _) (env ((□? (a n)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app even? (-> a <-)) (env ((□? (a n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> even? <-) a) (env ((□? (a n)))))
clos/con:
	'((prim even?) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app > a n) <-) (#f) _) (env ((□? (a n)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app > a (-> n <-)) (env ((□? (a n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app > (-> a <-) n) (env ((□? (a n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> > <-) a n) (env ((□? (a n)))))
clos/con:
	'((prim >) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app and (app = a 2) (let (n-mod-8) ...)) <-) (#f) c-x)
  (env ((□? (a n)))))
clos/con:
	'(((top) app #f) (env ()))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env
   (((app
      *
      (-> (app jacobi n a) <-)
      (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env
   (((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-)))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...)))))
literals: '(⊤ ⊥ ⊥)

'(query: (app and (app = a 2) (-> (let (n-mod-8) ...) <-)) (env ((□? (a n)))))
clos/con:
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env
   (((app
      *
      (-> (app jacobi n a) <-)
      (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env
   (((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-)))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...)))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (let (... () (n-mod-8 (-> (app modulo n 8) <-)) () ...) ...)
  (env ((□? (a n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo n (-> 8 <-)) (env ((□? (a n)))))
clos/con: ⊥
literals: '(8 ⊥ ⊥)

'(query: (app modulo (-> n <-) 8) (env ((□? (a n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> modulo <-) n 8) (env ((□? (a n)))))
clos/con:
	'((prim modulo) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (n-mod-8)
    (-> (match (app or (app = n-mod-8 1) (app = n-mod-8 7)) ...) <-))
  (env ((□? (a n)))))
clos/con:
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env
   (((app
      *
      (-> (app jacobi n a) <-)
      (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env
   (((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-)))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...)))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app or (app = n-mod-8 1) (app = n-mod-8 7)) (#f) (_ (-> 1 <-)))
  (env ((□? (a n)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (match
   (app or (app = n-mod-8 1) (app = n-mod-8 7))
   ((#f) (-> (match (app or (app = n-mod-8 3) (app = n-mod-8 5)) ...) <-))
   _)
  (env ((□? (a n)))))
clos/con:
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env
   (((app
      *
      (-> (app jacobi n a) <-)
      (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env
   (((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-)))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-))))))
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env (((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...)))))
literals: '(-1 ⊥ ⊥)

'(query:
  (match (app or (app = n-mod-8 3) (app = n-mod-8 5)) (#f) (_ (-> -1 <-)))
  (env ((□? (a n)))))
clos/con: ⊥
literals: '(-1 ⊥ ⊥)

'(query:
  (match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env ((□? (a n)))))
clos/con:
	'((match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env ((□? (a n)))))
literals: '(⊥ ⊥ ⊥)

'(query: (app error (-> "no-match" <-)) (env ((□? (a n)))))
clos/con: ⊥
literals: '(⊥ ⊥ "no-match")

'(query: (app (-> error <-) "no-match") (env ((□? (a n)))))
clos/con:
	'((app (-> error <-) "no-match") (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app or (app = n-mod-8 3) (app = n-mod-8 5)) <-) (#f) _)
  (env ((□? (a n)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (app = n-mod-8 3) (-> (app = n-mod-8 5) <-))
  (env ((□? (a n)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app = n-mod-8 (-> 5 <-)) (env ((□? (a n)))))
clos/con: ⊥
literals: '(5 ⊥ ⊥)

'(query: (app = (-> n-mod-8 <-) 5) (env ((□? (a n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> = <-) n-mod-8 5) (env ((□? (a n)))))
clos/con:
	'((prim =) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (-> (app = n-mod-8 3) <-) (app = n-mod-8 5))
  (env ((□? (a n)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app = n-mod-8 (-> 3 <-)) (env ((□? (a n)))))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(query: (app = (-> n-mod-8 <-) 3) (env ((□? (a n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> = <-) n-mod-8 3) (env ((□? (a n)))))
clos/con:
	'((prim =) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> or <-) (app = n-mod-8 3) (app = n-mod-8 5))
  (env ((□? (a n)))))
clos/con:
	'((prim or) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app or (app = n-mod-8 1) (app = n-mod-8 7)) <-) (#f) _)
  (env ((□? (a n)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (app = n-mod-8 1) (-> (app = n-mod-8 7) <-))
  (env ((□? (a n)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app = n-mod-8 (-> 7 <-)) (env ((□? (a n)))))
clos/con: ⊥
literals: '(7 ⊥ ⊥)

'(query: (app = (-> n-mod-8 <-) 7) (env ((□? (a n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> = <-) n-mod-8 7) (env ((□? (a n)))))
clos/con:
	'((prim =) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (-> (app = n-mod-8 1) <-) (app = n-mod-8 7))
  (env ((□? (a n)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app = n-mod-8 (-> 1 <-)) (env ((□? (a n)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app = (-> n-mod-8 <-) 1) (env ((□? (a n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> = <-) n-mod-8 1) (env ((□? (a n)))))
clos/con:
	'((prim =) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> or <-) (app = n-mod-8 1) (app = n-mod-8 7))
  (env ((□? (a n)))))
clos/con:
	'((prim or) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app and (-> (app = a 2) <-) (let (n-mod-8) ...)) (env ((□? (a n)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app = a (-> 2 <-)) (env ((□? (a n)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query: (app = (-> a <-) 2) (env ((□? (a n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> = <-) a 2) (env ((□? (a n)))))
clos/con:
	'((prim =) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> and <-) (app = a 2) (let (n-mod-8) ...)) (env ((□? (a n)))))
clos/con:
	'((prim and) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app not (app = (app gcd a n) 1)) <-) (#f) _)
  (env ((□? (a n)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app not (-> (app = (app gcd a n) 1) <-)) (env ((□? (a n)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app = (app gcd a n) (-> 1 <-)) (env ((□? (a n)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app = (-> (app gcd a n) <-) 1) (env ((□? (a n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app gcd a (-> n <-)) (env ((□? (a n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app gcd (-> a <-) n) (env ((□? (a n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> gcd <-) a n) (env ((□? (a n)))))
clos/con:
	'((prim gcd) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> = <-) (app gcd a n) 1) (env ((□? (a n)))))
clos/con:
	'((prim =) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> not <-) (app = (app gcd a n) 1)) (env ((□? (a n)))))
clos/con:
	'((prim not) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app = a 1) <-) (#f) _) (env ((□? (a n)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app = a (-> 1 <-)) (env ((□? (a n)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app = (-> a <-) 1) (env ((□? (a n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> = <-) a 1) (env ((□? (a n)))))
clos/con:
	'((prim =) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app = n 1) <-) (#f) _) (env ((□? (a n)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app = n (-> 1 <-)) (env ((□? (a n)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app = (-> n <-) 1) (env ((□? (a n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> = <-) n 1) (env ((□? (a n)))))
clos/con:
	'((prim =) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... square (modulo-power (-> (λ (base exp n) ...) <-)) jacobi ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... square (modulo-power (-> (λ (base exp n) ...) <-)) jacobi ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (base exp n) (-> (match (app = exp 0) ...) <-))
  (env ((□? (base exp n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (match (app = exp 0) (#f) (_ (-> 1 <-))) (env ((□? (base exp n)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (match (app = exp 0) ((#f) (-> (match (app odd? exp) ...) <-)) _)
  (env ((□? (base exp n)))))
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
  (env ((□? (base exp n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (app * base (app modulo-power base (app - exp 1) n)) (-> n <-))
  (env ((□? (base exp n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (-> (app * base (app modulo-power base (app - exp 1) n)) <-) n)
  (env ((□? (base exp n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * base (-> (app modulo-power base (app - exp 1) n) <-))
  (env ((□? (base exp n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo-power base (app - exp 1) (-> n <-))
  (env ((□? (base exp n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo-power base (-> (app - exp 1) <-) n)
  (env ((□? (base exp n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app - exp (-> 1 <-)) (env ((□? (base exp n)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app - (-> exp <-) 1) (env ((□? (base exp n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> - <-) exp 1) (env ((□? (base exp n)))))
clos/con:
	'((prim -) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app modulo-power (-> base <-) (app - exp 1) n)
  (env ((□? (base exp n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app (-> modulo-power <-) base (app - exp 1) n)
  (env ((□? (base exp n)))))
clos/con:
	'((letrec*
   (... square (modulo-power (-> (λ (base exp n) ...) <-)) jacobi ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app * (-> base <-) (app modulo-power base (app - exp 1) n))
  (env ((□? (base exp n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app (-> * <-) base (app modulo-power base (app - exp 1) n))
  (env ((□? (base exp n)))))
clos/con:
	'((prim *) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> modulo <-) (app * base (app modulo-power base (app - exp 1) n)) n)
  (env ((□? (base exp n)))))
clos/con:
	'((prim modulo) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app odd? exp)
   ((#f)
    (->
     (app modulo (app square (app modulo-power base (app / exp 2) n)) n)
     <-))
   _)
  (env ((□? (base exp n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (app square (app modulo-power base (app / exp 2) n)) (-> n <-))
  (env ((□? (base exp n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (-> (app square (app modulo-power base (app / exp 2) n)) <-) n)
  (env ((□? (base exp n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app square (-> (app modulo-power base (app / exp 2) n) <-))
  (env ((□? (base exp n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo-power base (app / exp 2) (-> n <-))
  (env ((□? (base exp n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo-power base (-> (app / exp 2) <-) n)
  (env ((□? (base exp n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app / exp (-> 2 <-)) (env ((□? (base exp n)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query: (app / (-> exp <-) 2) (env ((□? (base exp n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> / <-) exp 2) (env ((□? (base exp n)))))
clos/con:
	'((prim /) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app modulo-power (-> base <-) (app / exp 2) n)
  (env ((□? (base exp n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app (-> modulo-power <-) base (app / exp 2) n)
  (env ((□? (base exp n)))))
clos/con:
	'((letrec*
   (... square (modulo-power (-> (λ (base exp n) ...) <-)) jacobi ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> square <-) (app modulo-power base (app / exp 2) n))
  (env ((□? (base exp n)))))
clos/con:
	'((letrec* (... () (square (-> (λ (x) ...) <-)) modulo-power ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> modulo <-) (app square (app modulo-power base (app / exp 2) n)) n)
  (env ((□? (base exp n)))))
clos/con:
	'((prim modulo) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app odd? exp) <-) (#f) _) (env ((□? (base exp n)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app odd? (-> exp <-)) (env ((□? (base exp n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> odd? <-) exp) (env ((□? (base exp n)))))
clos/con:
	'((prim odd?) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app = exp 0) <-) (#f) _) (env ((□? (base exp n)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app = exp (-> 0 <-)) (env ((□? (base exp n)))))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query: (app = (-> exp <-) 0) (env ((□? (base exp n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> = <-) exp 0) (env ((□? (base exp n)))))
clos/con:
	'((prim =) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... () (square (-> (λ (x) ...) <-)) modulo-power ...) ...)
  (env ()))
clos/con:
	'((letrec* (... () (square (-> (λ (x) ...) <-)) modulo-power ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (x) (-> (app * x x) <-)) (env ((□? (x)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app * x (-> x <-)) (env ((□? (x)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app * (-> x <-) x) (env ((□? (x)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> * <-) x x) (env ((□? (x)))))
clos/con:
	'((prim *) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (letrec* (square ... byte-size) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app display "Generating prime...") <-)) () ...) ...)
  (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app display (-> "Generating prime..." <-)) (env ()))
clos/con: ⊥
literals: '(⊥ ⊥ "Generating prime...")

'(query: (app (-> display <-) "Generating prime...") (env ()))
clos/con:
	'((prim display) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (... () (_ (-> (app newline) <-)) () ...) ...) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> newline <-)) (env ()))
clos/con:
	'((prim newline) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (...
        ()
        (_
         (->
          (app
           display
           (app generate-solovay-strassen-prime byte-size iterations))
          <-))
        ()
        ...)
    ...)
  (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   display
   (-> (app generate-solovay-strassen-prime byte-size iterations) <-))
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app generate-solovay-strassen-prime byte-size (-> iterations <-))
  (env ()))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query:
  (app generate-solovay-strassen-prime (-> byte-size <-) iterations)
  (env ()))
clos/con: ⊥
literals: '(15 ⊥ ⊥)

'(query:
  (app (-> generate-solovay-strassen-prime <-) byte-size iterations)
  (env ()))
clos/con:
	'((letrec*
   (...
    generate-fermat-prime
    (generate-solovay-strassen-prime (-> (λ (byte-size iterations) ...) <-))
    iterations
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   (-> display <-)
   (app generate-solovay-strassen-prime byte-size iterations))
  (env ()))
clos/con:
	'((prim display) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (...
        ()
        (_
         (-> (app display " is prime with at least probability 1 - 1/2^") <-))
        ()
        ...)
    ...)
  (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app display (-> " is prime with at least probability 1 - 1/2^" <-))
  (env ()))
clos/con: ⊥
literals: '(⊥ ⊥ " is prime with at least probability 1 - 1/2^")

'(query:
  (app (-> display <-) " is prime with at least probability 1 - 1/2^")
  (env ()))
clos/con:
	'((prim display) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app display iterations) <-)) () ...) ...)
  (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app display (-> iterations <-)) (env ()))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query: (app (-> display <-) iterations) (env ()))
clos/con:
	'((prim display) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (... () (_ (-> (app display ".") <-)) () ...) ...) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app display (-> "." <-)) (env ()))
clos/con: ⊥
literals: '(⊥ ⊥ ".")

'(query: (app (-> display <-) ".") (env ()))
clos/con:
	'((prim display) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (app newline) <-)) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> newline <-)) (env ()))
clos/con:
	'((prim newline) (env ()))
literals: '(⊥ ⊥ ⊥)
