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
   (-> and <-)
   (app not (app is-trivial-composite? n))
   (app is-fermat-prime? n iterations))
  (env ()))
clos/con:
	'((prim and) (env ()))
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
  (env ()))
clos/con:
	'((prim or) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   and
   (-> (app not (app is-trivial-composite? n)) <-)
   (app is-fermat-prime? n iterations))
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   and
   (app not (app is-trivial-composite? n))
   (-> (app is-fermat-prime? n iterations) <-))
  (env ()))
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
  (env ()))
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
  (env ()))
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
  (env ()))
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
  (env ()))
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
  (env ()))
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
  (env ()))
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
  (env ()))
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
  (env ()))
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
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> modulo <-) (app * base (app modulo-power base (app - exp 1) n)) n)
  (env ()))
clos/con:
	'((prim modulo) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> modulo <-) (app square (app modulo-power base (app / exp 2) n)) n)
  (env ()))
clos/con:
	'((prim modulo) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> or <-) (app <= iterations 0) (let* (byte-size ... a) ...))
  (env ()))
clos/con:
	'((prim or) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app modulo (-> (app * base (app modulo-power base (app - exp 1) n)) <-) n)
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (-> (app square (app modulo-power base (app / exp 2) n)) <-) n)
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (app * base (app modulo-power base (app - exp 1) n)) (-> n <-))
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (app square (app modulo-power base (app / exp 2) n)) (-> n <-))
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app or (-> (app <= iterations 0) <-) (let* (byte-size ... a) ...))
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (app <= iterations 0) (-> (let* (byte-size ... a) ...) <-))
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
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
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let* (...
         ()
         (byte-size (-> (app ceiling (app / (app log n) (app log 2))) <-))
         a
         ...)
    ...)
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let* (... byte-size (a (-> (app random byte-size) <-)) () ...) ...)
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let* (byte-size ... a)
    (-> (match (app = (app modulo-power a (app - n 1) n) 1) ...) <-))
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
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

'(query:
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

'(query:
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

'(query:
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

'(query:
  (letrec*
   (... generate-fermat-prime (iterations (-> 10 <-)) byte-size ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query:
  (letrec*
   (square ... byte-size)
   (-> (app generate-fermat-prime byte-size iterations) <-))
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (letrec* (... () (square (-> (λ (x) ...) <-)) modulo-power ...) ...)
  (env ()))
clos/con:
	'((letrec* (... () (square (-> (λ (x) ...) <-)) modulo-power ...) ...)
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
  (env ()))
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
  (env ()))
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
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app = (app modulo-power a (app - n 1) n) 1)
   (#f)
   (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-)))
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app = (app modulo-power a (app - n 1) n) 1)
   ((#f) (-> (app #f) <-))
   _)
  (env ()))
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
  (env ()))
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
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (-> (app = (app modulo-power a (app - n 1) n) 1) <-) (#f) _)
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app = exp 0) ((#f) (-> (match (app odd? exp) ...) <-)) _)
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (n iterations)
    (-> (app or (app <= iterations 0) (let* (byte-size ... a) ...)) <-))
  (env ()))
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
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: ((top) letrec* (square ... byte-size) ...) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ()))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> * <-) base (app modulo-power base (app - exp 1) n)) (env ()))
clos/con:
	'((prim *) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> * <-) x x) (env ()))
clos/con:
	'((prim *) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> - <-) exp 1) (env ()))
clos/con:
	'((prim -) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> - <-) iterations 1) (env ()))
clos/con:
	'((prim -) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> - <-) n 1) (env ()))
clos/con:
	'((prim -) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> / <-) (app log n) (app log 2)) (env ()))
clos/con:
	'((prim /) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> / <-) exp 2) (env ()))
clos/con:
	'((prim /) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> <= <-) iterations 0) (env ()))
clos/con:
	'((prim <=) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> = <-) (app modulo n 11) 0) (env ()))
clos/con:
	'((prim =) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> = <-) (app modulo n 13) 0) (env ()))
clos/con:
	'((prim =) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> = <-) (app modulo n 17) 0) (env ()))
clos/con:
	'((prim =) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> = <-) (app modulo n 19) 0) (env ()))
clos/con:
	'((prim =) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> = <-) (app modulo n 2) 0) (env ()))
clos/con:
	'((prim =) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> = <-) (app modulo n 23) 0) (env ()))
clos/con:
	'((prim =) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> = <-) (app modulo n 3) 0) (env ()))
clos/con:
	'((prim =) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> = <-) (app modulo n 5) 0) (env ()))
clos/con:
	'((prim =) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> = <-) (app modulo n 7) 0) (env ()))
clos/con:
	'((prim =) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> = <-) (app modulo-power a (app - n 1) n) 1) (env ()))
clos/con:
	'((prim =) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> = <-) exp 0) (env ()))
clos/con:
	'((prim =) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> ceiling <-) (app / (app log n) (app log 2))) (env ()))
clos/con:
	'((prim ceiling) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> generate-fermat-prime <-) byte-size iterations) (env ()))
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

'(query: (app (-> generate-fermat-prime <-) byte-size iterations) (env ()))
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

'(query: (app (-> is-fermat-prime? <-) n (app - iterations 1)) (env ()))
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

'(query: (app (-> is-fermat-prime? <-) n iterations) (env ()))
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

'(query: (app (-> is-trivial-composite? <-) n) (env ()))
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

'(query: (app (-> log <-) 2) (env ()))
clos/con:
	'((prim log) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> log <-) n) (env ()))
clos/con:
	'((prim log) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> modulo <-) n 11) (env ()))
clos/con:
	'((prim modulo) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> modulo <-) n 13) (env ()))
clos/con:
	'((prim modulo) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> modulo <-) n 17) (env ()))
clos/con:
	'((prim modulo) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> modulo <-) n 19) (env ()))
clos/con:
	'((prim modulo) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> modulo <-) n 2) (env ()))
clos/con:
	'((prim modulo) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> modulo <-) n 23) (env ()))
clos/con:
	'((prim modulo) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> modulo <-) n 3) (env ()))
clos/con:
	'((prim modulo) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> modulo <-) n 5) (env ()))
clos/con:
	'((prim modulo) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> modulo <-) n 7) (env ()))
clos/con:
	'((prim modulo) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> modulo-power <-) a (app - n 1) n) (env ()))
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

'(query: (app (-> modulo-power <-) base (app - exp 1) n) (env ()))
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

'(query: (app (-> modulo-power <-) base (app / exp 2) n) (env ()))
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

'(query: (app (-> not <-) (app is-trivial-composite? n)) (env ()))
clos/con:
	'((prim not) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> odd? <-) exp) (env ()))
clos/con:
	'((prim odd?) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> random <-) byte-size) (env ()))
clos/con:
	'((prim random) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> random <-) byte-size) (env ()))
clos/con:
	'((prim random) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> square <-) (app modulo-power base (app / exp 2) n)) (env ()))
clos/con:
	'((letrec* (... () (square (-> (λ (x) ...) <-)) modulo-power ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app * (-> base <-) (app modulo-power base (app - exp 1) n)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app * (-> x <-) x) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app * base (-> (app modulo-power base (app - exp 1) n) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app * x (-> x <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app - (-> exp <-) 1) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app - (-> iterations <-) 1) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app - (-> n <-) 1) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app - exp (-> 1 <-)) (env ()))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app - iterations (-> 1 <-)) (env ()))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app - n (-> 1 <-)) (env ()))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app / (-> (app log n) <-) (app log 2)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app / (-> exp <-) 2) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app / (app log n) (-> (app log 2) <-)) (env ()))
clos/con: ⊥
literals: '(0.6931471805599453 ⊥ ⊥)

'(query: (app / exp (-> 2 <-)) (env ()))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query: (app <= (-> iterations <-) 0) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app <= iterations (-> 0 <-)) (env ()))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query: (app = (-> (app modulo n 11) <-) 0) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app = (-> (app modulo n 13) <-) 0) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app = (-> (app modulo n 17) <-) 0) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app = (-> (app modulo n 19) <-) 0) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app = (-> (app modulo n 2) <-) 0) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app = (-> (app modulo n 23) <-) 0) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app = (-> (app modulo n 3) <-) 0) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app = (-> (app modulo n 5) <-) 0) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app = (-> (app modulo n 7) <-) 0) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app = (-> (app modulo-power a (app - n 1) n) <-) 1) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app = (-> exp <-) 0) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app = (app modulo n 11) (-> 0 <-)) (env ()))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query: (app = (app modulo n 13) (-> 0 <-)) (env ()))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query: (app = (app modulo n 17) (-> 0 <-)) (env ()))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query: (app = (app modulo n 19) (-> 0 <-)) (env ()))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query: (app = (app modulo n 2) (-> 0 <-)) (env ()))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query: (app = (app modulo n 23) (-> 0 <-)) (env ()))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query: (app = (app modulo n 3) (-> 0 <-)) (env ()))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query: (app = (app modulo n 5) (-> 0 <-)) (env ()))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query: (app = (app modulo n 7) (-> 0 <-)) (env ()))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query: (app = (app modulo-power a (app - n 1) n) (-> 1 <-)) (env ()))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app = exp (-> 0 <-)) (env ()))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query: (app ceiling (-> (app / (app log n) (app log 2)) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app generate-fermat-prime (-> byte-size <-) iterations) (env ()))
clos/con: ⊥
literals: '(15 ⊥ ⊥)

'(query: (app generate-fermat-prime (-> byte-size <-) iterations) (env ()))
clos/con: ⊥
literals: '(15 ⊥ ⊥)

'(query: (app generate-fermat-prime byte-size (-> iterations <-)) (env ()))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query: (app generate-fermat-prime byte-size (-> iterations <-)) (env ()))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query: (app is-fermat-prime? (-> n <-) (app - iterations 1)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app is-fermat-prime? (-> n <-) iterations) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app is-fermat-prime? n (-> (app - iterations 1) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app is-fermat-prime? n (-> iterations <-)) (env ()))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query: (app is-trivial-composite? (-> n <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app log (-> 2 <-)) (env ()))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query: (app log (-> n <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo (-> n <-) 11) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo (-> n <-) 13) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo (-> n <-) 17) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo (-> n <-) 19) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo (-> n <-) 2) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo (-> n <-) 23) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo (-> n <-) 3) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo (-> n <-) 5) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo (-> n <-) 7) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo n (-> 11 <-)) (env ()))
clos/con: ⊥
literals: '(11 ⊥ ⊥)

'(query: (app modulo n (-> 13 <-)) (env ()))
clos/con: ⊥
literals: '(13 ⊥ ⊥)

'(query: (app modulo n (-> 17 <-)) (env ()))
clos/con: ⊥
literals: '(17 ⊥ ⊥)

'(query: (app modulo n (-> 19 <-)) (env ()))
clos/con: ⊥
literals: '(19 ⊥ ⊥)

'(query: (app modulo n (-> 2 <-)) (env ()))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query: (app modulo n (-> 23 <-)) (env ()))
clos/con: ⊥
literals: '(23 ⊥ ⊥)

'(query: (app modulo n (-> 3 <-)) (env ()))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(query: (app modulo n (-> 5 <-)) (env ()))
clos/con: ⊥
literals: '(5 ⊥ ⊥)

'(query: (app modulo n (-> 7 <-)) (env ()))
clos/con: ⊥
literals: '(7 ⊥ ⊥)

'(query: (app modulo-power (-> a <-) (app - n 1) n) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo-power (-> base <-) (app - exp 1) n) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo-power (-> base <-) (app / exp 2) n) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo-power a (-> (app - n 1) <-) n) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo-power a (app - n 1) (-> n <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo-power base (-> (app - exp 1) <-) n) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo-power base (-> (app / exp 2) <-) n) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo-power base (app - exp 1) (-> n <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo-power base (app / exp 2) (-> n <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app not (-> (app is-trivial-composite? n) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app odd? (-> exp <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app random (-> byte-size <-)) (env ()))
clos/con: ⊥
literals: '(15 ⊥ ⊥)

'(query: (app random (-> byte-size <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app square (-> (app modulo-power base (app / exp 2) n) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (let (... () (n (-> (app random byte-size) <-)) () ...) ...) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (letrec* (... iterations (byte-size (-> 15 <-)) () ...) ...) (env ()))
clos/con: ⊥
literals: '(15 ⊥ ⊥)

'(query: (match (-> (app = exp 0) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app odd? exp) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app = exp 0) (#f) (_ (-> 1 <-))) (env ()))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (λ (base exp n) (-> (match (app = exp 0) ...) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (λ (byte-size iterations) (-> (let (n) ...) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (λ (x) (-> (app * x x) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  *
  (letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-trivial-composite?
    ...)
   ...)
  (env ()))
clos/con:
	'((λ (base exp n) (-> (match (app = exp 0) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  *
  (letrec* (... () (square (-> (λ (x) ...) <-)) modulo-power ...) ...)
  (env ()))
clos/con:
	'((λ (x) (-> (app * x x) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  -
  (letrec*
   (...
    is-trivial-composite?
    (is-fermat-prime? (-> (λ (n iterations) ...) <-))
    generate-fermat-prime
    ...)
   ...)
  (env ()))
clos/con:
	'((λ (n iterations)
    (-> (app or (app <= iterations 0) (let* (byte-size ... a) ...)) <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  -
  (letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-trivial-composite?
    ...)
   ...)
  (env ()))
clos/con:
	'((λ (base exp n) (-> (match (app = exp 0) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  /
  (letrec*
   (...
    is-trivial-composite?
    (is-fermat-prime? (-> (λ (n iterations) ...) <-))
    generate-fermat-prime
    ...)
   ...)
  (env ()))
clos/con:
	'((λ (n iterations)
    (-> (app or (app <= iterations 0) (let* (byte-size ... a) ...)) <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  /
  (letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-trivial-composite?
    ...)
   ...)
  (env ()))
clos/con:
	'((λ (base exp n) (-> (match (app = exp 0) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  <=
  (letrec*
   (...
    is-trivial-composite?
    (is-fermat-prime? (-> (λ (n iterations) ...) <-))
    generate-fermat-prime
    ...)
   ...)
  (env ()))
clos/con:
	'((λ (n iterations)
    (-> (app or (app <= iterations 0) (let* (byte-size ... a) ...)) <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  =
  (letrec*
   (...
    is-trivial-composite?
    (is-fermat-prime? (-> (λ (n iterations) ...) <-))
    generate-fermat-prime
    ...)
   ...)
  (env ()))
clos/con:
	'((λ (n iterations)
    (-> (app or (app <= iterations 0) (let* (byte-size ... a) ...)) <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  =
  (letrec*
   (...
    modulo-power
    (is-trivial-composite? (-> (λ (n) ...) <-))
    is-fermat-prime?
    ...)
   ...)
  (env ()))
clos/con:
	'((λ (n)
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
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  =
  (letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-trivial-composite?
    ...)
   ...)
  (env ()))
clos/con:
	'((λ (base exp n) (-> (match (app = exp 0) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  a
  (letrec*
   (...
    is-trivial-composite?
    (is-fermat-prime? (-> (λ (n iterations) ...) <-))
    generate-fermat-prime
    ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  and
  (letrec*
   (...
    is-fermat-prime?
    (generate-fermat-prime (-> (λ (byte-size iterations) ...) <-))
    iterations
    ...)
   ...)
  (env ()))
clos/con:
	'((λ (byte-size iterations) (-> (let (n) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  base
  (letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-trivial-composite?
    ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  byte-size
  (letrec*
   (...
    is-fermat-prime?
    (generate-fermat-prime (-> (λ (byte-size iterations) ...) <-))
    iterations
    ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(15 ⊥ ⊥)

'(store:
  byte-size
  (letrec*
   (...
    is-trivial-composite?
    (is-fermat-prime? (-> (λ (n iterations) ...) <-))
    generate-fermat-prime
    ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  ceiling
  (letrec*
   (...
    is-trivial-composite?
    (is-fermat-prime? (-> (λ (n iterations) ...) <-))
    generate-fermat-prime
    ...)
   ...)
  (env ()))
clos/con:
	'((λ (n iterations)
    (-> (app or (app <= iterations 0) (let* (byte-size ... a) ...)) <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  exp
  (letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-trivial-composite?
    ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  generate-fermat-prime
  ((top) letrec* (square ... byte-size) ...)
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
    is-fermat-prime?
    (generate-fermat-prime (-> (λ (byte-size iterations) ...) <-))
    iterations
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
  ((top) letrec* (square ... byte-size) ...)
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
  is-trivial-composite?
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
   (...
    is-fermat-prime?
    (generate-fermat-prime (-> (λ (byte-size iterations) ...) <-))
    iterations
    ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(store:
  iterations
  (letrec*
   (...
    is-trivial-composite?
    (is-fermat-prime? (-> (λ (n iterations) ...) <-))
    generate-fermat-prime
    ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  log
  (letrec*
   (...
    is-trivial-composite?
    (is-fermat-prime? (-> (λ (n iterations) ...) <-))
    generate-fermat-prime
    ...)
   ...)
  (env ()))
clos/con:
	'((λ (n iterations)
    (-> (app or (app <= iterations 0) (let* (byte-size ... a) ...)) <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  modulo
  (letrec*
   (...
    modulo-power
    (is-trivial-composite? (-> (λ (n) ...) <-))
    is-fermat-prime?
    ...)
   ...)
  (env ()))
clos/con:
	'((λ (n)
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
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  modulo
  (letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-trivial-composite?
    ...)
   ...)
  (env ()))
clos/con:
	'((λ (base exp n) (-> (match (app = exp 0) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  modulo-power
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
  (letrec*
   (...
    is-fermat-prime?
    (generate-fermat-prime (-> (λ (byte-size iterations) ...) <-))
    iterations
    ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  n
  (letrec*
   (...
    is-trivial-composite?
    (is-fermat-prime? (-> (λ (n iterations) ...) <-))
    generate-fermat-prime
    ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  n
  (letrec*
   (...
    modulo-power
    (is-trivial-composite? (-> (λ (n) ...) <-))
    is-fermat-prime?
    ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  n
  (letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-trivial-composite?
    ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  not
  (letrec*
   (...
    is-fermat-prime?
    (generate-fermat-prime (-> (λ (byte-size iterations) ...) <-))
    iterations
    ...)
   ...)
  (env ()))
clos/con:
	'((λ (byte-size iterations) (-> (let (n) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  odd?
  (letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-trivial-composite?
    ...)
   ...)
  (env ()))
clos/con:
	'((λ (base exp n) (-> (match (app = exp 0) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  or
  (letrec*
   (...
    is-trivial-composite?
    (is-fermat-prime? (-> (λ (n iterations) ...) <-))
    generate-fermat-prime
    ...)
   ...)
  (env ()))
clos/con:
	'((λ (n iterations)
    (-> (app or (app <= iterations 0) (let* (byte-size ... a) ...)) <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  or
  (letrec*
   (...
    modulo-power
    (is-trivial-composite? (-> (λ (n) ...) <-))
    is-fermat-prime?
    ...)
   ...)
  (env ()))
clos/con:
	'((λ (n)
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
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  random
  (letrec*
   (...
    is-fermat-prime?
    (generate-fermat-prime (-> (λ (byte-size iterations) ...) <-))
    iterations
    ...)
   ...)
  (env ()))
clos/con:
	'((λ (byte-size iterations) (-> (let (n) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  random
  (letrec*
   (...
    is-trivial-composite?
    (is-fermat-prime? (-> (λ (n iterations) ...) <-))
    generate-fermat-prime
    ...)
   ...)
  (env ()))
clos/con:
	'((λ (n iterations)
    (-> (app or (app <= iterations 0) (let* (byte-size ... a) ...)) <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  square
  (letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-trivial-composite?
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec* (... () (square (-> (λ (x) ...) <-)) modulo-power ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x
  (letrec* (... () (square (-> (λ (x) ...) <-)) modulo-power ...) ...)
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store: byte-size ((top) letrec* (square ... byte-size) ...) (env ()))
clos/con: ⊥
literals: '(15 ⊥ ⊥)

'(store: is-fermat-prime? ((top) letrec* (square ... byte-size) ...) (env ()))
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

'(store: iterations ((top) letrec* (square ... byte-size) ...) (env ()))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(store: modulo-power ((top) letrec* (square ... byte-size) ...) (env ()))
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

'(store: square ((top) letrec* (square ... byte-size) ...) (env ()))
clos/con:
	'((letrec* (... () (square (-> (λ (x) ...) <-)) modulo-power ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)
