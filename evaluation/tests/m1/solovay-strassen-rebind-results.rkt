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

'(query:
  (app
   *
   (-> (app jacobi n a) <-)
   (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app
   *
   (-> (app jacobi n a) <-)
   (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app
   *
   (-> (app jacobi n a) <-)
   (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app
   *
   (-> (app jacobi n a) <-)
   (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app
   *
   (-> (app jacobi n a) <-)
   (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app
   *
   (app jacobi n a)
   (-> (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...) <-))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app
   *
   (app jacobi n a)
   (-> (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...) <-))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app
   *
   (app jacobi n a)
   (-> (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...) <-))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app
   *
   (app jacobi n a)
   (-> (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...) <-))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app
   *
   (app jacobi n a)
   (-> (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...) <-))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app
   and
   (-> (app not (app is-trivial-composite? n)) <-)
   (app is-fermat-prime? n iterations))
  (env
   ((let (... () (n (-> (app generate-fermat-prime byte-size 5) <-)) () ...)
      ...))))
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
   ((let (... () (n (-> (app generate-fermat-prime byte-size 5) <-)) () ...)
      ...))))
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
   display
   (-> (app generate-solovay-strassen-prime byte-size iterations) <-))
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

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
   (-> (app = jacobi-a-n 0) <-)
   (app not (app = (app modulo jacobi-a-n n) exp)))
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   or
   (-> (app = jacobi-a-n 0) <-)
   (app not (app = (app modulo jacobi-a-n n) exp)))
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
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
  (app
   or
   (app = jacobi-a-n 0)
   (-> (app not (app = (app modulo jacobi-a-n n) exp)) <-))
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   or
   (app = jacobi-a-n 0)
   (-> (app not (app = (app modulo jacobi-a-n n) exp)) <-))
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app * (-> (app - a 1) <-) (app - n 1))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * (-> (app - a 1) <-) (app - n 1))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * (-> (app - a 1) <-) (app - n 1))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * (-> (app - a 1) <-) (app - n 1))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * (-> (app - a 1) <-) (app - n 1))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * (-> base <-) (app modulo-power base (app - exp 1) n))
  (env
   ((let* (...
           jacobi-a-n
           (exp (-> (app modulo-power a (app / (app - n 1) 2) n) <-))
           ()
           ...)
      ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

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
  (app * (app - a 1) (-> (app - n 1) <-))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * (app - a 1) (-> (app - n 1) <-))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * (app - a 1) (-> (app - n 1) <-))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * (app - a 1) (-> (app - n 1) <-))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * (app - a 1) (-> (app - n 1) <-))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * base (-> (app modulo-power base (app - exp 1) n) <-))
  (env
   ((let* (...
           jacobi-a-n
           (exp (-> (app modulo-power a (app / (app - n 1) 2) n) <-))
           ()
           ...)
      ...))))
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
  (app + 1 (-> (app modulo (app random byte-size) (app - n 1)) <-))
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app + 1 (-> (app modulo (app random byte-size) (app - n 1)) <-))
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> a <-) 1)
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> a <-) 1)
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> a <-) 1)
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> a <-) 1)
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> a <-) 1)
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> exp <-) 1)
  (env
   ((let* (...
           jacobi-a-n
           (exp (-> (app modulo-power a (app / (app - n 1) 2) n) <-))
           ()
           ...)
      ...))))
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
literals: '(5 ⊥ ⊥)

'(query:
  (app - (-> iterations <-) 1)
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

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
  (app - (-> iterations <-) 1)
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query:
  (app - (-> n <-) 1)
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
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
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> n <-) 1)
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
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
  (app - (-> n <-) 1)
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> n <-) 1)
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> n <-) 1)
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> n <-) 1)
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> n <-) 1)
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> n <-) 1)
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app / (-> (app * (app - a 1) (app - n 1)) <-) 4)
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app / (-> (app * (app - a 1) (app - n 1)) <-) 4)
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app / (-> (app * (app - a 1) (app - n 1)) <-) 4)
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app / (-> (app * (app - a 1) (app - n 1)) <-) 4)
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app / (-> (app * (app - a 1) (app - n 1)) <-) 4)
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app / (-> (app - n 1) <-) 2)
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app / (-> (app - n 1) <-) 2)
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
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
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
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
  (app / (-> (app log n) <-) (app log 2))
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app / (-> a <-) 2)
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app / (-> a <-) 2)
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app / (-> a <-) 2)
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app / (-> a <-) 2)
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app / (-> a <-) 2)
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app / (-> a <-) 2)
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app / (-> exp <-) 2)
  (env
   ((let* (...
           jacobi-a-n
           (exp (-> (app modulo-power a (app / (app - n 1) 2) n) <-))
           ()
           ...)
      ...))))
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
  (app / (-> n <-) 2)
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app / (-> n <-) 2)
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app / (-> n <-) 2)
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app / (-> n <-) 2)
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query:
  (app / (-> n <-) 2)
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app / (-> n <-) 2)
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
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
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
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
  (app / (app log n) (-> (app log 2) <-))
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
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
literals: '(5 ⊥ ⊥)

'(query:
  (app <= (-> iterations <-) 0)
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

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
  (app <= (-> iterations <-) 0)
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query:
  (app = (-> (app gcd a n) <-) 1)
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> (app gcd a n) <-) 1)
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> (app gcd a n) <-) 1)
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> (app gcd a n) <-) 1)
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> (app gcd a n) <-) 1)
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> (app gcd a n) <-) 1)
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> (app gcd a n) <-) 1)
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> (app modulo jacobi-a-n n) <-) exp)
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> (app modulo jacobi-a-n n) <-) exp)
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
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
  (app = (-> a <-) 1)
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> a <-) 1)
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> a <-) 1)
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> a <-) 1)
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query:
  (app = (-> a <-) 1)
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> a <-) 1)
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> a <-) 1)
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> a <-) 2)
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> a <-) 2)
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> a <-) 2)
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> a <-) 2)
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query:
  (app = (-> a <-) 2)
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> a <-) 2)
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> a <-) 2)
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> exp <-) 0)
  (env
   ((let* (...
           jacobi-a-n
           (exp (-> (app modulo-power a (app / (app - n 1) 2) n) <-))
           ()
           ...)
      ...))))
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
  (app = (-> jacobi-a-n <-) 0)
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> jacobi-a-n <-) 0)
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> n <-) 1)
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> n <-) 1)
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> n <-) 1)
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> n <-) 1)
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> n <-) 1)
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query:
  (app = (-> n <-) 1)
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> n <-) 1)
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> n <-) 2)
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> n <-) 2)
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> n-mod-8 <-) 1)
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> n-mod-8 <-) 1)
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> n-mod-8 <-) 1)
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> n-mod-8 <-) 1)
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> n-mod-8 <-) 1)
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query:
  (app = (-> n-mod-8 <-) 1)
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> n-mod-8 <-) 1)
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> n-mod-8 <-) 3)
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> n-mod-8 <-) 3)
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> n-mod-8 <-) 3)
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> n-mod-8 <-) 3)
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> n-mod-8 <-) 3)
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query:
  (app = (-> n-mod-8 <-) 3)
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> n-mod-8 <-) 3)
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> n-mod-8 <-) 5)
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> n-mod-8 <-) 5)
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> n-mod-8 <-) 5)
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> n-mod-8 <-) 5)
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> n-mod-8 <-) 5)
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query:
  (app = (-> n-mod-8 <-) 5)
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> n-mod-8 <-) 5)
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> n-mod-8 <-) 7)
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> n-mod-8 <-) 7)
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> n-mod-8 <-) 7)
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> n-mod-8 <-) 7)
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> n-mod-8 <-) 7)
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query:
  (app = (-> n-mod-8 <-) 7)
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> n-mod-8 <-) 7)
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (app modulo jacobi-a-n n) (-> exp <-))
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (app modulo jacobi-a-n n) (-> exp <-))
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app > (-> a <-) n)
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app > (-> a <-) n)
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app > (-> a <-) n)
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app > (-> a <-) n)
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app > (-> a <-) n)
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app > (-> a <-) n)
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app > a (-> n <-))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app > a (-> n <-))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app > a (-> n <-))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app > a (-> n <-))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query:
  (app > a (-> n <-))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app > a (-> n <-))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app and (-> (app = a 2) <-) (let (n-mod-8) ...))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app and (-> (app = a 2) <-) (let (n-mod-8) ...))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app and (-> (app = a 2) <-) (let (n-mod-8) ...))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app and (-> (app = a 2) <-) (let (n-mod-8) ...))
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app and (-> (app = a 2) <-) (let (n-mod-8) ...))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app and (-> (app = a 2) <-) (let (n-mod-8) ...))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app and (-> (app = a 2) <-) (let (n-mod-8) ...))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app and (-> (app even? n) <-) (app not (app = n 2)))
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app and (-> (app even? n) <-) (app not (app = n 2)))
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app and (app = a 2) (-> (let (n-mod-8) ...) <-))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app and (app = a 2) (-> (let (n-mod-8) ...) <-))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app and (app = a 2) (-> (let (n-mod-8) ...) <-))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app and (app = a 2) (-> (let (n-mod-8) ...) <-))
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app and (app = a 2) (-> (let (n-mod-8) ...) <-))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app and (app = a 2) (-> (let (n-mod-8) ...) <-))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app and (app = a 2) (-> (let (n-mod-8) ...) <-))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app and (app even? n) (-> (app not (app = n 2)) <-))
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app and (app even? n) (-> (app not (app = n 2)) <-))
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

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
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
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
  (app ceiling (-> (app / (app log n) (app log 2)) <-))
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app even? (-> (app / (app * (app - a 1) (app - n 1)) 4) <-))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app even? (-> (app / (app * (app - a 1) (app - n 1)) 4) <-))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app even? (-> (app / (app * (app - a 1) (app - n 1)) 4) <-))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app even? (-> (app / (app * (app - a 1) (app - n 1)) 4) <-))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app even? (-> (app / (app * (app - a 1) (app - n 1)) 4) <-))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app even? (-> a <-))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app even? (-> a <-))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app even? (-> a <-))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app even? (-> a <-))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app even? (-> a <-))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app even? (-> a <-))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app even? (-> n <-))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app even? (-> n <-))
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app even? (-> n <-))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app even? (-> n <-))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app even? (-> n <-))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query:
  (app even? (-> n <-))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app even? (-> n <-))
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app even? (-> n <-))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app gcd (-> a <-) n)
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app gcd (-> a <-) n)
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app gcd (-> a <-) n)
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app gcd (-> a <-) n)
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query:
  (app gcd (-> a <-) n)
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app gcd (-> a <-) n)
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app gcd (-> a <-) n)
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app gcd a (-> n <-))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app gcd a (-> n <-))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app gcd a (-> n <-))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app gcd a (-> n <-))
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app gcd a (-> n <-))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query:
  (app gcd a (-> n <-))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app gcd a (-> n <-))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app generate-fermat-prime (-> byte-size <-) 5)
  (env
   ((app
     display
     (-> (app generate-solovay-strassen-prime byte-size iterations) <-)))))
clos/con: ⊥
literals: '(15 ⊥ ⊥)

'(query:
  (app generate-fermat-prime (-> byte-size <-) 5)
  (env
   ((match
     (app is-solovay-strassen-prime? n iterations)
     ((#f) (-> (app generate-solovay-strassen-prime byte-size iterations) <-))
     _))))
clos/con: ⊥
literals: '(15 ⊥ ⊥)

'(query:
  (app generate-fermat-prime (-> byte-size <-) iterations)
  (env
   ((let (... () (n (-> (app generate-fermat-prime byte-size 5) <-)) () ...)
      ...))))
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
   ((let (... () (n (-> (app generate-fermat-prime byte-size 5) <-)) () ...)
      ...))))
clos/con: ⊥
literals: '(5 ⊥ ⊥)

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
literals: '(5 ⊥ ⊥)

'(query:
  (app generate-solovay-strassen-prime (-> byte-size <-) iterations)
  (env
   ((app
     display
     (-> (app generate-solovay-strassen-prime byte-size iterations) <-)))))
clos/con: ⊥
literals: '(15 ⊥ ⊥)

'(query:
  (app generate-solovay-strassen-prime (-> byte-size <-) iterations)
  (env
   ((match
     (app is-solovay-strassen-prime? n iterations)
     ((#f) (-> (app generate-solovay-strassen-prime byte-size iterations) <-))
     _))))
clos/con: ⊥
literals: '(15 ⊥ ⊥)

'(query:
  (app generate-solovay-strassen-prime byte-size (-> iterations <-))
  (env
   ((app
     display
     (-> (app generate-solovay-strassen-prime byte-size iterations) <-)))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query:
  (app generate-solovay-strassen-prime byte-size (-> iterations <-))
  (env
   ((match
     (app is-solovay-strassen-prime? n iterations)
     ((#f) (-> (app generate-solovay-strassen-prime byte-size iterations) <-))
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
   ((let (... () (n (-> (app generate-fermat-prime byte-size 5) <-)) () ...)
      ...))))
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
literals: '(4 ⊥ ⊥)

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
   ((let (... () (n (-> (app generate-fermat-prime byte-size 5) <-)) () ...)
      ...))))
clos/con: ⊥
literals: '(5 ⊥ ⊥)

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
literals: '(5 ⊥ ⊥)

'(query:
  (app is-solovay-strassen-prime? (-> n <-) (app - iterations 1))
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app is-solovay-strassen-prime? (-> n <-) (app - iterations 1))
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app is-solovay-strassen-prime? (-> n <-) iterations)
  (env
   ((app
     display
     (-> (app generate-solovay-strassen-prime byte-size iterations) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app is-solovay-strassen-prime? (-> n <-) iterations)
  (env
   ((match
     (app is-solovay-strassen-prime? n iterations)
     ((#f) (-> (app generate-solovay-strassen-prime byte-size iterations) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app is-solovay-strassen-prime? n (-> (app - iterations 1) <-))
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app is-solovay-strassen-prime? n (-> (app - iterations 1) <-))
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
clos/con: ⊥
literals: '(9 ⊥ ⊥)

'(query:
  (app is-solovay-strassen-prime? n (-> iterations <-))
  (env
   ((app
     display
     (-> (app generate-solovay-strassen-prime byte-size iterations) <-)))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query:
  (app is-solovay-strassen-prime? n (-> iterations <-))
  (env
   ((match
     (app is-solovay-strassen-prime? n iterations)
     ((#f) (-> (app generate-solovay-strassen-prime byte-size iterations) <-))
     _))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query:
  (app is-trivial-composite? (-> n <-))
  (env
   ((let (... () (n (-> (app generate-fermat-prime byte-size 5) <-)) () ...)
      ...))))
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
  (app jacobi (-> (app / a 2) <-) n)
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi (-> (app / a 2) <-) n)
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi (-> (app / a 2) <-) n)
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi (-> (app / a 2) <-) n)
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi (-> (app / a 2) <-) n)
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi (-> (app / a 2) <-) n)
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi (-> (app modulo a n) <-) n)
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi (-> (app modulo a n) <-) n)
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi (-> (app modulo a n) <-) n)
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi (-> (app modulo a n) <-) n)
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi (-> (app modulo a n) <-) n)
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi (-> (app modulo a n) <-) n)
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi (-> a <-) (app / n 2))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi (-> a <-) (app / n 2))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi (-> a <-) (app / n 2))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi (-> a <-) (app / n 2))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi (-> a <-) (app / n 2))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi (-> a <-) (app / n 2))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi (-> a <-) 2)
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi (-> a <-) 2)
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi (-> a <-) 2)
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi (-> a <-) 2)
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi (-> a <-) 2)
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi (-> a <-) 2)
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi (-> a <-) n)
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi (-> a <-) n)
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi (-> n <-) a)
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi (-> n <-) a)
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi (-> n <-) a)
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi (-> n <-) a)
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi (-> n <-) a)
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi (app / a 2) (-> n <-))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi (app / a 2) (-> n <-))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi (app / a 2) (-> n <-))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi (app / a 2) (-> n <-))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query:
  (app jacobi (app / a 2) (-> n <-))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi (app / a 2) (-> n <-))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi (app modulo a n) (-> n <-))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi (app modulo a n) (-> n <-))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi (app modulo a n) (-> n <-))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi (app modulo a n) (-> n <-))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query:
  (app jacobi (app modulo a n) (-> n <-))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi (app modulo a n) (-> n <-))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi 2 (-> n <-))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi 2 (-> n <-))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi 2 (-> n <-))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi 2 (-> n <-))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query:
  (app jacobi 2 (-> n <-))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi 2 (-> n <-))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi a (-> (app / n 2) <-))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi a (-> (app / n 2) <-))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi a (-> (app / n 2) <-))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi a (-> (app / n 2) <-))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (app jacobi a (-> (app / n 2) <-))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi a (-> (app / n 2) <-))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi a (-> n <-))
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi a (-> n <-))
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi n (-> a <-))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi n (-> a <-))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi n (-> a <-))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi n (-> a <-))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app jacobi n (-> a <-))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
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
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
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
  (app log (-> n <-))
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (-> (app * base (app modulo-power base (app - exp 1) n)) <-) n)
  (env
   ((let* (...
           jacobi-a-n
           (exp (-> (app modulo-power a (app / (app - n 1) 2) n) <-))
           ()
           ...)
      ...))))
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
  (app modulo (-> (app random byte-size) <-) (app - n 1))
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (-> (app random byte-size) <-) (app - n 1))
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (-> (app square (app modulo-power base (app / exp 2) n)) <-) n)
  (env
   ((let* (...
           jacobi-a-n
           (exp (-> (app modulo-power a (app / (app - n 1) 2) n) <-))
           ()
           ...)
      ...))))
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
  (app modulo (-> a <-) n)
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (-> a <-) n)
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (-> a <-) n)
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (-> a <-) n)
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (-> a <-) n)
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (-> a <-) n)
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (-> jacobi-a-n <-) n)
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (-> jacobi-a-n <-) n)
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
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
  (app modulo (-> n <-) 8)
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (-> n <-) 8)
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (-> n <-) 8)
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (-> n <-) 8)
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (-> n <-) 8)
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query:
  (app modulo (-> n <-) 8)
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (-> n <-) 8)
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (app * base (app modulo-power base (app - exp 1) n)) (-> n <-))
  (env
   ((let* (...
           jacobi-a-n
           (exp (-> (app modulo-power a (app / (app - n 1) 2) n) <-))
           ()
           ...)
      ...))))
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
  (app modulo (app random byte-size) (-> (app - n 1) <-))
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (app random byte-size) (-> (app - n 1) <-))
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (app square (app modulo-power base (app / exp 2) n)) (-> n <-))
  (env
   ((let* (...
           jacobi-a-n
           (exp (-> (app modulo-power a (app / (app - n 1) 2) n) <-))
           ()
           ...)
      ...))))
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
  (app modulo a (-> n <-))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo a (-> n <-))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo a (-> n <-))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo a (-> n <-))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query:
  (app modulo a (-> n <-))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo a (-> n <-))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo jacobi-a-n (-> n <-))
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo jacobi-a-n (-> n <-))
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
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
  (app modulo-power (-> a <-) (app / (app - n 1) 2) n)
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo-power (-> a <-) (app / (app - n 1) 2) n)
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo-power (-> base <-) (app - exp 1) n)
  (env
   ((let* (...
           jacobi-a-n
           (exp (-> (app modulo-power a (app / (app - n 1) 2) n) <-))
           ()
           ...)
      ...))))
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
  (env
   ((let* (...
           jacobi-a-n
           (exp (-> (app modulo-power a (app / (app - n 1) 2) n) <-))
           ()
           ...)
      ...))))
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
  (app modulo-power a (-> (app / (app - n 1) 2) <-) n)
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo-power a (-> (app / (app - n 1) 2) <-) n)
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
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
  (app modulo-power a (app / (app - n 1) 2) (-> n <-))
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo-power a (app / (app - n 1) 2) (-> n <-))
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo-power base (-> (app - exp 1) <-) n)
  (env
   ((let* (...
           jacobi-a-n
           (exp (-> (app modulo-power a (app / (app - n 1) 2) n) <-))
           ()
           ...)
      ...))))
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
  (env
   ((let* (...
           jacobi-a-n
           (exp (-> (app modulo-power a (app / (app - n 1) 2) n) <-))
           ()
           ...)
      ...))))
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
  (env
   ((let* (...
           jacobi-a-n
           (exp (-> (app modulo-power a (app / (app - n 1) 2) n) <-))
           ()
           ...)
      ...))))
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
  (env
   ((let* (...
           jacobi-a-n
           (exp (-> (app modulo-power a (app / (app - n 1) 2) n) <-))
           ()
           ...)
      ...))))
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
  (app not (-> (app = (app gcd a n) 1) <-))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app not (-> (app = (app gcd a n) 1) <-))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app not (-> (app = (app gcd a n) 1) <-))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app not (-> (app = (app gcd a n) 1) <-))
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app not (-> (app = (app gcd a n) 1) <-))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app not (-> (app = (app gcd a n) 1) <-))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app not (-> (app = (app gcd a n) 1) <-))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app not (-> (app = (app modulo jacobi-a-n n) exp) <-))
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app not (-> (app = (app modulo jacobi-a-n n) exp) <-))
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app not (-> (app = n 2) <-))
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app not (-> (app = n 2) <-))
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app not (-> (app is-trivial-composite? n) <-))
  (env
   ((let (... () (n (-> (app generate-fermat-prime byte-size 5) <-)) () ...)
      ...))))
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
  (env
   ((let* (...
           jacobi-a-n
           (exp (-> (app modulo-power a (app / (app - n 1) 2) n) <-))
           ()
           ...)
      ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

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
  (app or (-> (app = n-mod-8 1) <-) (app = n-mod-8 7))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (-> (app = n-mod-8 1) <-) (app = n-mod-8 7))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (-> (app = n-mod-8 1) <-) (app = n-mod-8 7))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (-> (app = n-mod-8 1) <-) (app = n-mod-8 7))
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (-> (app = n-mod-8 1) <-) (app = n-mod-8 7))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (-> (app = n-mod-8 1) <-) (app = n-mod-8 7))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (-> (app = n-mod-8 1) <-) (app = n-mod-8 7))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (-> (app = n-mod-8 3) <-) (app = n-mod-8 5))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (-> (app = n-mod-8 3) <-) (app = n-mod-8 5))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (-> (app = n-mod-8 3) <-) (app = n-mod-8 5))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (-> (app = n-mod-8 3) <-) (app = n-mod-8 5))
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (-> (app = n-mod-8 3) <-) (app = n-mod-8 5))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (-> (app = n-mod-8 3) <-) (app = n-mod-8 5))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (-> (app = n-mod-8 3) <-) (app = n-mod-8 5))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
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
  (app or (app = n-mod-8 1) (-> (app = n-mod-8 7) <-))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (app = n-mod-8 1) (-> (app = n-mod-8 7) <-))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (app = n-mod-8 1) (-> (app = n-mod-8 7) <-))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (app = n-mod-8 1) (-> (app = n-mod-8 7) <-))
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (app = n-mod-8 1) (-> (app = n-mod-8 7) <-))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (app = n-mod-8 1) (-> (app = n-mod-8 7) <-))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (app = n-mod-8 1) (-> (app = n-mod-8 7) <-))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (app = n-mod-8 3) (-> (app = n-mod-8 5) <-))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (app = n-mod-8 3) (-> (app = n-mod-8 5) <-))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (app = n-mod-8 3) (-> (app = n-mod-8 5) <-))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (app = n-mod-8 3) (-> (app = n-mod-8 5) <-))
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (app = n-mod-8 3) (-> (app = n-mod-8 5) <-))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (app = n-mod-8 3) (-> (app = n-mod-8 5) <-))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (app = n-mod-8 3) (-> (app = n-mod-8 5) <-))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
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
   ((let (... () (n (-> (app generate-fermat-prime byte-size 5) <-)) () ...)
      ...))))
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
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

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
  (app random (-> byte-size <-))
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app square (-> (app modulo-power base (app / exp 2) n) <-))
  (env
   ((let* (...
           jacobi-a-n
           (exp (-> (app modulo-power a (app / (app - n 1) 2) n) <-))
           ()
           ...)
      ...))))
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
	'((con void) (env ()))
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
	'((con void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app display "Generating prime...") <-)) () ...) ...)
  (env ()))
clos/con:
	'((con void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app display iterations) <-)) () ...) ...)
  (env ()))
clos/con:
	'((con void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (n (-> (app generate-fermat-prime byte-size 5) <-)) () ...) ...)
  (env
   ((app
     display
     (-> (app generate-solovay-strassen-prime byte-size iterations) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let (... () (n (-> (app generate-fermat-prime byte-size 5) <-)) () ...) ...)
  (env
   ((match
     (app is-solovay-strassen-prime? n iterations)
     ((#f) (-> (app generate-solovay-strassen-prime byte-size iterations) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let (... () (n (-> (app random byte-size) <-)) () ...) ...)
  (env
   ((let (... () (n (-> (app generate-fermat-prime byte-size 5) <-)) () ...)
      ...))))
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
  (let (... () (n-mod-8 (-> (app modulo n 8) <-)) () ...) ...)
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let (... () (n-mod-8 (-> (app modulo n 8) <-)) () ...) ...)
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let (... () (n-mod-8 (-> (app modulo n 8) <-)) () ...) ...)
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let (... () (n-mod-8 (-> (app modulo n 8) <-)) () ...) ...)
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let (... () (n-mod-8 (-> (app modulo n 8) <-)) () ...) ...)
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query:
  (let (... () (n-mod-8 (-> (app modulo n 8) <-)) () ...) ...)
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let (... () (n-mod-8 (-> (app modulo n 8) <-)) () ...) ...)
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
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
   ((let (... () (n (-> (app generate-fermat-prime byte-size 5) <-)) () ...)
      ...))))
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
  (let (n) (-> (match (app is-solovay-strassen-prime? n iterations) ...) <-))
  (env
   ((app
     display
     (-> (app generate-solovay-strassen-prime byte-size iterations) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let (n) (-> (match (app is-solovay-strassen-prime? n iterations) ...) <-))
  (env
   ((match
     (app is-solovay-strassen-prime? n iterations)
     ((#f) (-> (app generate-solovay-strassen-prime byte-size iterations) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let (n-mod-8)
    (-> (match (app or (app = n-mod-8 1) (app = n-mod-8 7)) ...) <-))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (let (n-mod-8)
    (-> (match (app or (app = n-mod-8 1) (app = n-mod-8 7)) ...) <-))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (let (n-mod-8)
    (-> (match (app or (app = n-mod-8 1) (app = n-mod-8 7)) ...) <-))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (let (n-mod-8)
    (-> (match (app or (app = n-mod-8 1) (app = n-mod-8 7)) ...) <-))
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (let (n-mod-8)
    (-> (match (app or (app = n-mod-8 1) (app = n-mod-8 7)) ...) <-))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (n-mod-8)
    (-> (match (app or (app = n-mod-8 1) (app = n-mod-8 7)) ...) <-))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (let (n-mod-8)
    (-> (match (app or (app = n-mod-8 1) (app = n-mod-8 7)) ...) <-))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
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
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
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
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let* (...
         ()
         (byte-size (-> (app ceiling (app / (app log n) (app log 2))) <-))
         a
         ...)
    ...)
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let* (...
         byte-size
         (a (-> (app + 1 (app modulo (app random byte-size) (app - n 1))) <-))
         ()
         ...)
    ...)
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let* (...
         byte-size
         (a (-> (app + 1 (app modulo (app random byte-size) (app - n 1))) <-))
         ()
         ...)
    ...)
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let* (...
         jacobi-a-n
         (exp (-> (app modulo-power a (app / (app - n 1) 2) n) <-))
         ()
         ...)
    ...)
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let* (...
         jacobi-a-n
         (exp (-> (app modulo-power a (app / (app - n 1) 2) n) <-))
         ()
         ...)
    ...)
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...)
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...)
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
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
  (let* (byte-size ... a) (-> (let* (jacobi-a-n ... exp) ...) <-))
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let* (byte-size ... a) (-> (let* (jacobi-a-n ... exp) ...) <-))
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
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
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
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
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (lettypes error ... error (letrec* (square ... byte-size) ...))
  (env ()))
clos/con:
	'((con void) (env ()))
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
   ((let (... () (n (-> (app generate-fermat-prime byte-size 5) <-)) () ...)
      ...))))
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
   (->
    (app
     or
     (app = jacobi-a-n 0)
     (app not (app = (app modulo jacobi-a-n n) exp)))
    <-)
   (#f)
   _)
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
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
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
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
   ((let (... () (n (-> (app generate-fermat-prime byte-size 5) <-)) () ...)
      ...))))
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
   ((let (... () (n (-> (app generate-fermat-prime byte-size 5) <-)) () ...)
      ...))))
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
   (app
    or
    (app = jacobi-a-n 0)
    (app not (app = (app modulo jacobi-a-n n) exp)))
   (#f)
   (_ (-> (app #f) <-)))
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app
    or
    (app = jacobi-a-n 0)
    (app not (app = (app modulo jacobi-a-n n) exp)))
   (#f)
   (_ (-> (app #f) <-)))
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app
    or
    (app = jacobi-a-n 0)
    (app not (app = (app modulo jacobi-a-n n) exp)))
   ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
   _)
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app
    or
    (app = jacobi-a-n 0)
    (app not (app = (app modulo jacobi-a-n n) exp)))
   ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
   _)
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app <= iterations 0)
   ((#f) (-> (match (app and (app even? n) (app not (app = n 2))) ...) <-))
   _)
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app <= iterations 0)
   ((#f) (-> (match (app and (app even? n) (app not (app = n 2))) ...) <-))
   _)
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
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
   (app = a 1)
   ((#f) (-> (match (app not (app = (app gcd a n) 1)) ...) <-))
   _)
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app = a 1)
   ((#f) (-> (match (app not (app = (app gcd a n) 1)) ...) <-))
   _)
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app = a 1)
   ((#f) (-> (match (app not (app = (app gcd a n) 1)) ...) <-))
   _)
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app = a 1)
   ((#f) (-> (match (app not (app = (app gcd a n) 1)) ...) <-))
   _)
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app = a 1)
   ((#f) (-> (match (app not (app = (app gcd a n) 1)) ...) <-))
   _)
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app = a 1)
   ((#f) (-> (match (app not (app = (app gcd a n) 1)) ...) <-))
   _)
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app = a 1)
   ((#f) (-> (match (app not (app = (app gcd a n) 1)) ...) <-))
   _)
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app and (app = a 2) (let (n-mod-8) ...))
   ((#f) (-> (match (app > a n) ...) <-))
   c-x)
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app and (app = a 2) (let (n-mod-8) ...))
   ((#f) (-> (match (app > a n) ...) <-))
   c-x)
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app and (app = a 2) (let (n-mod-8) ...))
   ((#f) (-> (match (app > a n) ...) <-))
   c-x)
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app and (app = a 2) (let (n-mod-8) ...))
   ((#f) (-> (match (app > a n) ...) <-))
   c-x)
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app and (app = a 2) (let (n-mod-8) ...))
   ((#f) (-> (match (app > a n) ...) <-))
   c-x)
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app and (app = a 2) (let (n-mod-8) ...))
   ((#f) (-> (match (app > a n) ...) <-))
   c-x)
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app and (app even? n) (app not (app = n 2)))
   (#f)
   (_ (-> (app #f) <-)))
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app and (app even? n) (app not (app = n 2)))
   (#f)
   (_ (-> (app #f) <-)))
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app and (app even? n) (app not (app = n 2)))
   ((#f) (-> (let* (byte-size ... a) ...) <-))
   _)
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app and (app even? n) (app not (app = n 2)))
   ((#f) (-> (let* (byte-size ... a) ...) <-))
   _)
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app even? a)
   (#f)
   (_ (-> (app * (app jacobi (app / a 2) n) (app jacobi 2 n)) <-)))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app even? a)
   (#f)
   (_ (-> (app * (app jacobi (app / a 2) n) (app jacobi 2 n)) <-)))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app even? a)
   (#f)
   (_ (-> (app * (app jacobi (app / a 2) n) (app jacobi 2 n)) <-)))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app even? a)
   (#f)
   (_ (-> (app * (app jacobi (app / a 2) n) (app jacobi 2 n)) <-)))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app even? a)
   (#f)
   (_ (-> (app * (app jacobi (app / a 2) n) (app jacobi 2 n)) <-)))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app even? a)
   (#f)
   (_ (-> (app * (app jacobi (app / a 2) n) (app jacobi 2 n)) <-)))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app even? n)
   (#f)
   (_ (-> (app * (app jacobi a (app / n 2)) (app jacobi a 2)) <-)))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app even? n)
   (#f)
   (_ (-> (app * (app jacobi a (app / n 2)) (app jacobi a 2)) <-)))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app even? n)
   (#f)
   (_ (-> (app * (app jacobi a (app / n 2)) (app jacobi a 2)) <-)))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app even? n)
   (#f)
   (_ (-> (app * (app jacobi a (app / n 2)) (app jacobi a 2)) <-)))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app even? n)
   (#f)
   (_ (-> (app * (app jacobi a (app / n 2)) (app jacobi a 2)) <-)))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app even? n)
   (#f)
   (_ (-> (app * (app jacobi a (app / n 2)) (app jacobi a 2)) <-)))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

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
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

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
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

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
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

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
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

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
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app is-solovay-strassen-prime? n iterations)
   ((#f) (-> (app generate-solovay-strassen-prime byte-size iterations) <-))
   _)
  (env
   ((app
     display
     (-> (app generate-solovay-strassen-prime byte-size iterations) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app is-solovay-strassen-prime? n iterations)
   ((#f) (-> (app generate-solovay-strassen-prime byte-size iterations) <-))
   _)
  (env
   ((match
     (app is-solovay-strassen-prime? n iterations)
     ((#f) (-> (app generate-solovay-strassen-prime byte-size iterations) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app not (app = (app gcd a n) 1))
   ((#f) (-> (match (app and (app = a 2) (let (n-mod-8) ...)) ...) <-))
   _)
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app not (app = (app gcd a n) 1))
   ((#f) (-> (match (app and (app = a 2) (let (n-mod-8) ...)) ...) <-))
   _)
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app not (app = (app gcd a n) 1))
   ((#f) (-> (match (app and (app = a 2) (let (n-mod-8) ...)) ...) <-))
   _)
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app not (app = (app gcd a n) 1))
   ((#f) (-> (match (app and (app = a 2) (let (n-mod-8) ...)) ...) <-))
   _)
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app not (app = (app gcd a n) 1))
   ((#f) (-> (match (app and (app = a 2) (let (n-mod-8) ...)) ...) <-))
   _)
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app not (app = (app gcd a n) 1))
   ((#f) (-> (match (app and (app = a 2) (let (n-mod-8) ...)) ...) <-))
   _)
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app not (app = (app gcd a n) 1))
   ((#f) (-> (match (app and (app = a 2) (let (n-mod-8) ...)) ...) <-))
   _)
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app odd? exp)
   (#f)
   (_
    (->
     (app modulo (app * base (app modulo-power base (app - exp 1) n)) n)
     <-)))
  (env
   ((let* (...
           jacobi-a-n
           (exp (-> (app modulo-power a (app / (app - n 1) 2) n) <-))
           ()
           ...)
      ...))))
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
  (env
   ((let* (...
           jacobi-a-n
           (exp (-> (app modulo-power a (app / (app - n 1) 2) n) <-))
           ()
           ...)
      ...))))
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
  (match
   (app or (app = n-mod-8 1) (app = n-mod-8 7))
   ((#f) (-> (match (app or (app = n-mod-8 3) (app = n-mod-8 5)) ...) <-))
   _)
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
literals: '(-1 ⊥ ⊥)

'(query:
  (match
   (app or (app = n-mod-8 1) (app = n-mod-8 7))
   ((#f) (-> (match (app or (app = n-mod-8 3) (app = n-mod-8 5)) ...) <-))
   _)
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
literals: '(-1 ⊥ ⊥)

'(query:
  (match
   (app or (app = n-mod-8 1) (app = n-mod-8 7))
   ((#f) (-> (match (app or (app = n-mod-8 3) (app = n-mod-8 5)) ...) <-))
   _)
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
literals: '(-1 ⊥ ⊥)

'(query:
  (match
   (app or (app = n-mod-8 1) (app = n-mod-8 7))
   ((#f) (-> (match (app or (app = n-mod-8 3) (app = n-mod-8 5)) ...) <-))
   _)
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
literals: '(-1 ⊥ ⊥)

'(query:
  (match
   (app or (app = n-mod-8 1) (app = n-mod-8 7))
   ((#f) (-> (match (app or (app = n-mod-8 3) (app = n-mod-8 5)) ...) <-))
   _)
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app or (app = n-mod-8 1) (app = n-mod-8 7))
   ((#f) (-> (match (app or (app = n-mod-8 3) (app = n-mod-8 5)) ...) <-))
   _)
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
literals: '(-1 ⊥ ⊥)

'(query:
  (match
   (app or (app = n-mod-8 1) (app = n-mod-8 7))
   ((#f) (-> (match (app or (app = n-mod-8 3) (app = n-mod-8 5)) ...) <-))
   _)
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(-1 ⊥ ⊥)

'(query:
  (match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app or (app = n-mod-8 3) (app = n-mod-8 5))
   ((#f) (-> (app error "no-match") <-))
   _)
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app <= iterations 0) <-) (#f) _)
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app <= iterations 0) <-) (#f) _)
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

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
  (match (-> (app = a 1) <-) (#f) _)
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app = a 1) <-) (#f) _)
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app = a 1) <-) (#f) _)
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app = a 1) <-) (#f) _)
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app = a 1) <-) (#f) _)
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app = a 1) <-) (#f) _)
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app = a 1) <-) (#f) _)
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app = exp 0) <-) (#f) _)
  (env
   ((let* (...
           jacobi-a-n
           (exp (-> (app modulo-power a (app / (app - n 1) 2) n) <-))
           ()
           ...)
      ...))))
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
  (match (-> (app = n 1) <-) (#f) _)
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app = n 1) <-) (#f) _)
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app = n 1) <-) (#f) _)
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app = n 1) <-) (#f) _)
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app = n 1) <-) (#f) _)
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app = n 1) <-) (#f) _)
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app = n 1) <-) (#f) _)
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app > a n) <-) (#f) _)
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app > a n) <-) (#f) _)
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app > a n) <-) (#f) _)
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app > a n) <-) (#f) _)
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app > a n) <-) (#f) _)
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app > a n) <-) (#f) _)
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app and (app = a 2) (let (n-mod-8) ...)) <-) (#f) c-x)
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
	'((con #f) (env ()))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (-> (app and (app = a 2) (let (n-mod-8) ...)) <-) (#f) c-x)
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
	'((con #f) (env ()))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (-> (app and (app = a 2) (let (n-mod-8) ...)) <-) (#f) c-x)
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
	'((con #f) (env ()))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (-> (app and (app = a 2) (let (n-mod-8) ...)) <-) (#f) c-x)
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (-> (app and (app = a 2) (let (n-mod-8) ...)) <-) (#f) c-x)
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app and (app = a 2) (let (n-mod-8) ...)) <-) (#f) c-x)
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
	'((con #f) (env ()))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (-> (app and (app = a 2) (let (n-mod-8) ...)) <-) (#f) c-x)
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
	'((con #f) (env ()))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (-> (app and (app even? n) (app not (app = n 2))) <-) (#f) _)
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app and (app even? n) (app not (app = n 2))) <-) (#f) _)
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app even? (app / (app * (app - a 1) (app - n 1)) 4)) <-) (#f) _)
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app even? (app / (app * (app - a 1) (app - n 1)) 4)) <-) (#f) _)
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app even? (app / (app * (app - a 1) (app - n 1)) 4)) <-) (#f) _)
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app even? (app / (app * (app - a 1) (app - n 1)) 4)) <-) (#f) _)
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app even? (app / (app * (app - a 1) (app - n 1)) 4)) <-) (#f) _)
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app even? a) <-) (#f) _)
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app even? a) <-) (#f) _)
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app even? a) <-) (#f) _)
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app even? a) <-) (#f) _)
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app even? a) <-) (#f) _)
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app even? a) <-) (#f) _)
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app even? n) <-) (#f) _)
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app even? n) <-) (#f) _)
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app even? n) <-) (#f) _)
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app even? n) <-) (#f) _)
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app even? n) <-) (#f) _)
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app even? n) <-) (#f) _)
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _)
  (env
   ((app
     display
     (-> (app generate-solovay-strassen-prime byte-size iterations) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _)
  (env
   ((match
     (app is-solovay-strassen-prime? n iterations)
     ((#f) (-> (app generate-solovay-strassen-prime byte-size iterations) <-))
     _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app not (app = (app gcd a n) 1)) <-) (#f) _)
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app not (app = (app gcd a n) 1)) <-) (#f) _)
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app not (app = (app gcd a n) 1)) <-) (#f) _)
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app not (app = (app gcd a n) 1)) <-) (#f) _)
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app not (app = (app gcd a n) 1)) <-) (#f) _)
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app not (app = (app gcd a n) 1)) <-) (#f) _)
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app not (app = (app gcd a n) 1)) <-) (#f) _)
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app odd? exp) <-) (#f) _)
  (env
   ((let* (...
           jacobi-a-n
           (exp (-> (app modulo-power a (app / (app - n 1) 2) n) <-))
           ()
           ...)
      ...))))
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
  (match (-> (app or (app = n-mod-8 1) (app = n-mod-8 7)) <-) (#f) _)
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app or (app = n-mod-8 1) (app = n-mod-8 7)) <-) (#f) _)
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app or (app = n-mod-8 1) (app = n-mod-8 7)) <-) (#f) _)
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app or (app = n-mod-8 1) (app = n-mod-8 7)) <-) (#f) _)
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app or (app = n-mod-8 1) (app = n-mod-8 7)) <-) (#f) _)
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app or (app = n-mod-8 1) (app = n-mod-8 7)) <-) (#f) _)
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app or (app = n-mod-8 1) (app = n-mod-8 7)) <-) (#f) _)
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app or (app = n-mod-8 3) (app = n-mod-8 5)) <-) (#f) _)
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app or (app = n-mod-8 3) (app = n-mod-8 5)) <-) (#f) _)
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app or (app = n-mod-8 3) (app = n-mod-8 5)) <-) (#f) _)
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app or (app = n-mod-8 3) (app = n-mod-8 5)) <-) (#f) _)
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app or (app = n-mod-8 3) (app = n-mod-8 5)) <-) (#f) _)
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app or (app = n-mod-8 3) (app = n-mod-8 5)) <-) (#f) _)
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app or (app = n-mod-8 3) (app = n-mod-8 5)) <-) (#f) _)
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app <= iterations 0) (#f) (_ (-> (app #t) <-)))
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app = exp 0) ((#f) (-> (match (app odd? exp) ...) <-)) _)
  (env
   ((let* (...
           jacobi-a-n
           (exp (-> (app modulo-power a (app / (app - n 1) 2) n) <-))
           ()
           ...)
      ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

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
  (match (app = n 1) ((#f) (-> (match (app = a 1) ...) <-)) _)
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app = n 1) ((#f) (-> (match (app = a 1) ...) <-)) _)
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app = n 1) ((#f) (-> (match (app = a 1) ...) <-)) _)
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app = n 1) ((#f) (-> (match (app = a 1) ...) <-)) _)
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app = n 1) ((#f) (-> (match (app = a 1) ...) <-)) _)
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app = n 1) ((#f) (-> (match (app = a 1) ...) <-)) _)
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app = n 1) ((#f) (-> (match (app = a 1) ...) <-)) _)
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-)))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-)))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-)))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-)))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-)))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-)))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app > a n) ((#f) (-> (match (app even? a) ...) <-)) _)
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app > a n) ((#f) (-> (match (app even? a) ...) <-)) _)
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app > a n) ((#f) (-> (match (app even? a) ...) <-)) _)
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app > a n) ((#f) (-> (match (app even? a) ...) <-)) _)
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app > a n) ((#f) (-> (match (app even? a) ...) <-)) _)
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app > a n) ((#f) (-> (match (app even? a) ...) <-)) _)
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app and (app = a 2) (let (n-mod-8) ...)) (#f) (c-x (-> c-x <-)))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app and (app = a 2) (let (n-mod-8) ...)) (#f) (c-x (-> c-x <-)))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app and (app = a 2) (let (n-mod-8) ...)) (#f) (c-x (-> c-x <-)))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app and (app = a 2) (let (n-mod-8) ...)) (#f) (c-x (-> c-x <-)))
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app and (app = a 2) (let (n-mod-8) ...)) (#f) (c-x (-> c-x <-)))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app and (app = a 2) (let (n-mod-8) ...)) (#f) (c-x (-> c-x <-)))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app and (app = a 2) (let (n-mod-8) ...)) (#f) (c-x (-> c-x <-)))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app even? a) ((#f) (-> (match (app even? n) ...) <-)) _)
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app even? a) ((#f) (-> (match (app even? n) ...) <-)) _)
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app even? a) ((#f) (-> (match (app even? n) ...) <-)) _)
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app even? a) ((#f) (-> (match (app even? n) ...) <-)) _)
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app even? a) ((#f) (-> (match (app even? n) ...) <-)) _)
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app even? a) ((#f) (-> (match (app even? n) ...) <-)) _)
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app is-solovay-strassen-prime? n iterations) (#f) (_ (-> n <-)))
  (env
   ((app
     display
     (-> (app generate-solovay-strassen-prime byte-size iterations) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app is-solovay-strassen-prime? n iterations) (#f) (_ (-> n <-)))
  (env
   ((match
     (app is-solovay-strassen-prime? n iterations)
     ((#f) (-> (app generate-solovay-strassen-prime byte-size iterations) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (a n) (-> (match (app = n 1) ...) <-))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (a n) (-> (match (app = n 1) ...) <-))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (a n) (-> (match (app = n 1) ...) <-))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (a n) (-> (match (app = n 1) ...) <-))
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (a n) (-> (match (app = n 1) ...) <-))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (a n) (-> (match (app = n 1) ...) <-))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (a n) (-> (match (app = n 1) ...) <-))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (base exp n) (-> (match (app = exp 0) ...) <-))
  (env
   ((let* (...
           jacobi-a-n
           (exp (-> (app modulo-power a (app / (app - n 1) 2) n) <-))
           ()
           ...)
      ...))))
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
   ((app
     display
     (-> (app generate-solovay-strassen-prime byte-size iterations) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (byte-size iterations) (-> (let (n) ...) <-))
  (env
   ((let (... () (n (-> (app generate-fermat-prime byte-size 5) <-)) () ...)
      ...))))
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
  (λ (byte-size iterations) (-> (let (n) ...) <-))
  (env
   ((match
     (app is-solovay-strassen-prime? n iterations)
     ((#f) (-> (app generate-solovay-strassen-prime byte-size iterations) <-))
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
  (λ (n iterations) (-> (match (app <= iterations 0) ...) <-))
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (n iterations) (-> (match (app <= iterations 0) ...) <-))
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
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

'(query: ((top) lettypes (error) ...) (env ()))
clos/con:
	'((con void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (... () (_ (-> (app display ".") <-)) () ...) ...) (env ()))
clos/con:
	'((con void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (... () (_ (-> (app newline) <-)) () ...) ...) (env ()))
clos/con:
	'((con void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (app newline) <-)) (env ()))
clos/con:
	'((con void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'((con void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'((con void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'((con void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'((con void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'((con void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (letrec* (square ... byte-size) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'((con void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  _
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
	'((con void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  _
  (let (...
        ()
        (_
         (-> (app display " is prime with at least probability 1 - 1/2^") <-))
        ()
        ...)
    ...)
  (env ()))
clos/con:
	'((con void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  _
  (let (... () (_ (-> (app display "Generating prime...") <-)) () ...) ...)
  (env ()))
clos/con:
	'((con void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  _
  (let (... () (_ (-> (app display iterations) <-)) () ...) ...)
  (env ()))
clos/con:
	'((con void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  a
  (let* (...
         byte-size
         (a (-> (app + 1 (app modulo (app random byte-size) (app - n 1))) <-))
         ()
         ...)
    ...)
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  a
  (let* (...
         byte-size
         (a (-> (app + 1 (app modulo (app random byte-size) (app - n 1))) <-))
         ()
         ...)
    ...)
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
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
  a
  (λ (a n) (-> (match (app = n 1) ...) <-))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  a
  (λ (a n) (-> (match (app = n 1) ...) <-))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  a
  (λ (a n) (-> (match (app = n 1) ...) <-))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  a
  (λ (a n) (-> (match (app = n 1) ...) <-))
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(store:
  a
  (λ (a n) (-> (match (app = n 1) ...) <-))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  a
  (λ (a n) (-> (match (app = n 1) ...) <-))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  a
  (λ (a n) (-> (match (app = n 1) ...) <-))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  base
  (λ (base exp n) (-> (match (app = exp 0) ...) <-))
  (env
   ((let* (...
           jacobi-a-n
           (exp (-> (app modulo-power a (app / (app - n 1) 2) n) <-))
           ()
           ...)
      ...))))
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
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
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
  (let* (...
         ()
         (byte-size (-> (app ceiling (app / (app log n) (app log 2))) <-))
         a
         ...)
    ...)
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
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
   ((app
     display
     (-> (app generate-solovay-strassen-prime byte-size iterations) <-)))))
clos/con: ⊥
literals: '(15 ⊥ ⊥)

'(store:
  byte-size
  (λ (byte-size iterations) (-> (let (n) ...) <-))
  (env
   ((let (... () (n (-> (app generate-fermat-prime byte-size 5) <-)) () ...)
      ...))))
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
  byte-size
  (λ (byte-size iterations) (-> (let (n) ...) <-))
  (env
   ((match
     (app is-solovay-strassen-prime? n iterations)
     ((#f) (-> (app generate-solovay-strassen-prime byte-size iterations) <-))
     _))))
clos/con: ⊥
literals: '(15 ⊥ ⊥)

'(store:
  c-x
  (match (app and (app = a 2) (let (n-mod-8) ...)) (#f) (c-x (-> c-x <-)))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
literals: '(⊤ ⊥ ⊥)

'(store:
  c-x
  (match (app and (app = a 2) (let (n-mod-8) ...)) (#f) (c-x (-> c-x <-)))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
literals: '(⊤ ⊥ ⊥)

'(store:
  c-x
  (match (app and (app = a 2) (let (n-mod-8) ...)) (#f) (c-x (-> c-x <-)))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
literals: '(⊤ ⊥ ⊥)

'(store:
  c-x
  (match (app and (app = a 2) (let (n-mod-8) ...)) (#f) (c-x (-> c-x <-)))
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
literals: '(⊤ ⊥ ⊥)

'(store:
  c-x
  (match (app and (app = a 2) (let (n-mod-8) ...)) (#f) (c-x (-> c-x <-)))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  c-x
  (match (app and (app = a 2) (let (n-mod-8) ...)) (#f) (c-x (-> c-x <-)))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
literals: '(⊤ ⊥ ⊥)

'(store:
  c-x
  (match (app and (app = a 2) (let (n-mod-8) ...)) (#f) (c-x (-> c-x <-)))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(store:
  con
  (app error (-> "no-match" <-))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊥ ⊥ "no-match")

'(store:
  con
  (app error (-> "no-match" <-))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊥ ⊥ "no-match")

'(store:
  con
  (app error (-> "no-match" <-))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊥ ⊥ "no-match")

'(store:
  con
  (app error (-> "no-match" <-))
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
clos/con: ⊥
literals: '(⊥ ⊥ "no-match")

'(store:
  con
  (app error (-> "no-match" <-))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con: ⊥
literals: '(⊥ ⊥ "no-match")

'(store:
  con
  (app error (-> "no-match" <-))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊥ ⊥ "no-match")

'(store:
  con
  (app error (-> "no-match" <-))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con: ⊥
literals: '(⊥ ⊥ "no-match")

'(store:
  exp
  (let* (...
         jacobi-a-n
         (exp (-> (app modulo-power a (app / (app - n 1) 2) n) <-))
         ()
         ...)
    ...)
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  exp
  (let* (...
         jacobi-a-n
         (exp (-> (app modulo-power a (app / (app - n 1) 2) n) <-))
         ()
         ...)
    ...)
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  exp
  (λ (base exp n) (-> (match (app = exp 0) ...) <-))
  (env
   ((let* (...
           jacobi-a-n
           (exp (-> (app modulo-power a (app / (app - n 1) 2) n) <-))
           ()
           ...)
      ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

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
    is-solovay-strassen-prime?
    (generate-fermat-prime (-> (λ (byte-size iterations) ...) <-))
    generate-solovay-strassen-prime
    ...)
   ...)
  (env
   ((app
     display
     (-> (app generate-solovay-strassen-prime byte-size iterations) <-)))))
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

'(store:
  generate-fermat-prime
  (letrec*
   (...
    is-solovay-strassen-prime?
    (generate-fermat-prime (-> (λ (byte-size iterations) ...) <-))
    generate-solovay-strassen-prime
    ...)
   ...)
  (env
   ((let (... () (n (-> (app generate-fermat-prime byte-size 5) <-)) () ...)
      ...))))
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

'(store:
  generate-fermat-prime
  (letrec*
   (...
    is-solovay-strassen-prime?
    (generate-fermat-prime (-> (λ (byte-size iterations) ...) <-))
    generate-solovay-strassen-prime
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
    is-solovay-strassen-prime?
    (generate-fermat-prime (-> (λ (byte-size iterations) ...) <-))
    generate-solovay-strassen-prime
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  generate-fermat-prime
  (letrec*
   (...
    is-solovay-strassen-prime?
    (generate-fermat-prime (-> (λ (byte-size iterations) ...) <-))
    generate-solovay-strassen-prime
    ...)
   ...)
  (env
   ((match
     (app is-solovay-strassen-prime? n iterations)
     ((#f) (-> (app generate-solovay-strassen-prime byte-size iterations) <-))
     _))))
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

'(store:
  generate-fermat-prime
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

'(store:
  generate-solovay-strassen-prime
  (letrec*
   (...
    generate-fermat-prime
    (generate-solovay-strassen-prime (-> (λ (byte-size iterations) ...) <-))
    iterations
    ...)
   ...)
  (env
   ((app
     display
     (-> (app generate-solovay-strassen-prime byte-size iterations) <-)))))
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

'(store:
  generate-solovay-strassen-prime
  (letrec*
   (...
    generate-fermat-prime
    (generate-solovay-strassen-prime (-> (λ (byte-size iterations) ...) <-))
    iterations
    ...)
   ...)
  (env
   ((match
     (app is-solovay-strassen-prime? n iterations)
     ((#f) (-> (app generate-solovay-strassen-prime byte-size iterations) <-))
     _))))
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

'(store:
  generate-solovay-strassen-prime
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

'(store:
  is-fermat-prime?
  (letrec*
   (...
    is-trivial-composite?
    (is-fermat-prime? (-> (λ (n iterations) ...) <-))
    is-solovay-strassen-prime?
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
    is-solovay-strassen-prime?
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
    is-solovay-strassen-prime?
    ...)
   ...)
  (env
   ((let (... () (n (-> (app generate-fermat-prime byte-size 5) <-)) () ...)
      ...))))
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

'(store:
  is-fermat-prime?
  (letrec*
   (...
    is-trivial-composite?
    (is-fermat-prime? (-> (λ (n iterations) ...) <-))
    is-solovay-strassen-prime?
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
    is-solovay-strassen-prime?
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
    is-solovay-strassen-prime?
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
    is-solovay-strassen-prime?
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

'(store:
  is-solovay-strassen-prime?
  (letrec*
   (...
    is-fermat-prime?
    (is-solovay-strassen-prime? (-> (λ (n iterations) ...) <-))
    generate-fermat-prime
    ...)
   ...)
  (env
   ((app
     display
     (-> (app generate-solovay-strassen-prime byte-size iterations) <-)))))
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

'(store:
  is-solovay-strassen-prime?
  (letrec*
   (...
    is-fermat-prime?
    (is-solovay-strassen-prime? (-> (λ (n iterations) ...) <-))
    generate-fermat-prime
    ...)
   ...)
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
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

'(store:
  is-solovay-strassen-prime?
  (letrec*
   (...
    is-fermat-prime?
    (is-solovay-strassen-prime? (-> (λ (n iterations) ...) <-))
    generate-fermat-prime
    ...)
   ...)
  (env
   ((match
     (app is-solovay-strassen-prime? n iterations)
     ((#f) (-> (app generate-solovay-strassen-prime byte-size iterations) <-))
     _))))
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

'(store:
  is-solovay-strassen-prime?
  (letrec*
   (...
    is-fermat-prime?
    (is-solovay-strassen-prime? (-> (λ (n iterations) ...) <-))
    generate-fermat-prime
    ...)
   ...)
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
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

'(store:
  is-solovay-strassen-prime?
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

'(store:
  is-trivial-composite?
  (letrec*
   (...
    jacobi
    (is-trivial-composite? (-> (λ (n) ...) <-))
    is-fermat-prime?
    ...)
   ...)
  (env
   ((let (... () (n (-> (app generate-fermat-prime byte-size 5) <-)) () ...)
      ...))))
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

'(store:
  is-trivial-composite?
  (letrec*
   (...
    jacobi
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
    jacobi
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

'(store:
  iterations
  (letrec*
   (... generate-solovay-strassen-prime (iterations (-> 10 <-)) byte-size ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(store:
  iterations
  (λ (byte-size iterations) (-> (let (n) ...) <-))
  (env
   ((app
     display
     (-> (app generate-solovay-strassen-prime byte-size iterations) <-)))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(store:
  iterations
  (λ (byte-size iterations) (-> (let (n) ...) <-))
  (env
   ((let (... () (n (-> (app generate-fermat-prime byte-size 5) <-)) () ...)
      ...))))
clos/con: ⊥
literals: '(5 ⊥ ⊥)

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
literals: '(5 ⊥ ⊥)

'(store:
  iterations
  (λ (byte-size iterations) (-> (let (n) ...) <-))
  (env
   ((match
     (app is-solovay-strassen-prime? n iterations)
     ((#f) (-> (app generate-solovay-strassen-prime byte-size iterations) <-))
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
literals: '(5 ⊥ ⊥)

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
  iterations
  (λ (n iterations) (-> (match (app <= iterations 0) ...) <-))
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  iterations
  (λ (n iterations) (-> (match (app <= iterations 0) ...) <-))
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(store:
  jacobi
  (letrec*
   (... modulo-power (jacobi (-> (λ (a n) ...) <-)) is-trivial-composite? ...)
   ...)
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con:
	'((letrec*
   (... modulo-power (jacobi (-> (λ (a n) ...) <-)) is-trivial-composite? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  jacobi
  (letrec*
   (... modulo-power (jacobi (-> (λ (a n) ...) <-)) is-trivial-composite? ...)
   ...)
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con:
	'((letrec*
   (... modulo-power (jacobi (-> (λ (a n) ...) <-)) is-trivial-composite? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  jacobi
  (letrec*
   (... modulo-power (jacobi (-> (λ (a n) ...) <-)) is-trivial-composite? ...)
   ...)
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con:
	'((letrec*
   (... modulo-power (jacobi (-> (λ (a n) ...) <-)) is-trivial-composite? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  jacobi
  (letrec*
   (... modulo-power (jacobi (-> (λ (a n) ...) <-)) is-trivial-composite? ...)
   ...)
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con:
	'((letrec*
   (... modulo-power (jacobi (-> (λ (a n) ...) <-)) is-trivial-composite? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  jacobi
  (letrec*
   (... modulo-power (jacobi (-> (λ (a n) ...) <-)) is-trivial-composite? ...)
   ...)
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
clos/con:
	'((letrec*
   (... modulo-power (jacobi (-> (λ (a n) ...) <-)) is-trivial-composite? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  jacobi
  (letrec*
   (... modulo-power (jacobi (-> (λ (a n) ...) <-)) is-trivial-composite? ...)
   ...)
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con:
	'((letrec*
   (... modulo-power (jacobi (-> (λ (a n) ...) <-)) is-trivial-composite? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  jacobi
  (letrec*
   (... modulo-power (jacobi (-> (λ (a n) ...) <-)) is-trivial-composite? ...)
   ...)
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con:
	'((letrec*
   (... modulo-power (jacobi (-> (λ (a n) ...) <-)) is-trivial-composite? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  jacobi
  (letrec*
   (... modulo-power (jacobi (-> (λ (a n) ...) <-)) is-trivial-composite? ...)
   ...)
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
clos/con:
	'((letrec*
   (... modulo-power (jacobi (-> (λ (a n) ...) <-)) is-trivial-composite? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  jacobi
  (letrec*
   (... modulo-power (jacobi (-> (λ (a n) ...) <-)) is-trivial-composite? ...)
   ...)
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con:
	'((letrec*
   (... modulo-power (jacobi (-> (λ (a n) ...) <-)) is-trivial-composite? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  jacobi
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

'(store:
  jacobi-a-n
  (let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...)
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(store:
  jacobi-a-n
  (let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...)
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
clos/con:
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
	'((con
   error
   (match
    (app or (app = n-mod-8 3) (app = n-mod-8 5))
    ((#f) (-> (app error "no-match") <-))
    _))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
literals: '(⊤ ⊥ ⊥)

'(store:
  modulo-power
  (letrec*
   (... square (modulo-power (-> (λ (base exp n) ...) <-)) jacobi ...)
   ...)
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con:
	'((letrec*
   (... square (modulo-power (-> (λ (base exp n) ...) <-)) jacobi ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  modulo-power
  (letrec*
   (... square (modulo-power (-> (λ (base exp n) ...) <-)) jacobi ...)
   ...)
  (env
   ((let* (...
           jacobi-a-n
           (exp (-> (app modulo-power a (app / (app - n 1) 2) n) <-))
           ()
           ...)
      ...))))
clos/con:
	'((letrec*
   (... square (modulo-power (-> (λ (base exp n) ...) <-)) jacobi ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  modulo-power
  (letrec*
   (... square (modulo-power (-> (λ (base exp n) ...) <-)) jacobi ...)
   ...)
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con:
	'((letrec*
   (... square (modulo-power (-> (λ (base exp n) ...) <-)) jacobi ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  modulo-power
  (letrec*
   (... square (modulo-power (-> (λ (base exp n) ...) <-)) jacobi ...)
   ...)
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con:
	'((letrec*
   (... square (modulo-power (-> (λ (base exp n) ...) <-)) jacobi ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  modulo-power
  (letrec*
   (... square (modulo-power (-> (λ (base exp n) ...) <-)) jacobi ...)
   ...)
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con:
	'((letrec*
   (... square (modulo-power (-> (λ (base exp n) ...) <-)) jacobi ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  modulo-power
  (letrec*
   (... square (modulo-power (-> (λ (base exp n) ...) <-)) jacobi ...)
   ...)
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con:
	'((letrec*
   (... square (modulo-power (-> (λ (base exp n) ...) <-)) jacobi ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  modulo-power
  (letrec*
   (... square (modulo-power (-> (λ (base exp n) ...) <-)) jacobi ...)
   ...)
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
clos/con:
	'((letrec*
   (... square (modulo-power (-> (λ (base exp n) ...) <-)) jacobi ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  modulo-power
  (letrec*
   (... square (modulo-power (-> (λ (base exp n) ...) <-)) jacobi ...)
   ...)
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
clos/con:
	'((letrec*
   (... square (modulo-power (-> (λ (base exp n) ...) <-)) jacobi ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  modulo-power
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

'(store:
  n
  (let (... () (n (-> (app generate-fermat-prime byte-size 5) <-)) () ...) ...)
  (env
   ((app
     display
     (-> (app generate-solovay-strassen-prime byte-size iterations) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  n
  (let (... () (n (-> (app generate-fermat-prime byte-size 5) <-)) () ...) ...)
  (env
   ((match
     (app is-solovay-strassen-prime? n iterations)
     ((#f) (-> (app generate-solovay-strassen-prime byte-size iterations) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  n
  (let (... () (n (-> (app random byte-size) <-)) () ...) ...)
  (env
   ((let (... () (n (-> (app generate-fermat-prime byte-size 5) <-)) () ...)
      ...))))
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
  (λ (a n) (-> (match (app = n 1) ...) <-))
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  n
  (λ (a n) (-> (match (app = n 1) ...) <-))
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  n
  (λ (a n) (-> (match (app = n 1) ...) <-))
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  n
  (λ (a n) (-> (match (app = n 1) ...) <-))
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  n
  (λ (a n) (-> (match (app = n 1) ...) <-))
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(store:
  n
  (λ (a n) (-> (match (app = n 1) ...) <-))
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  n
  (λ (a n) (-> (match (app = n 1) ...) <-))
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  n
  (λ (base exp n) (-> (match (app = exp 0) ...) <-))
  (env
   ((let* (...
           jacobi-a-n
           (exp (-> (app modulo-power a (app / (app - n 1) 2) n) <-))
           ()
           ...)
      ...))))
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
  (λ (n iterations) (-> (match (app <= iterations 0) ...) <-))
  (env
   ((match
     (app
      or
      (app = jacobi-a-n 0)
      (app not (app = (app modulo jacobi-a-n n) exp)))
     ((#f) (-> (app is-solovay-strassen-prime? n (app - iterations 1)) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  n
  (λ (n iterations) (-> (match (app <= iterations 0) ...) <-))
  (env ((match (-> (app is-solovay-strassen-prime? n iterations) <-) (#f) _))))
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
  n-mod-8
  (let (... () (n-mod-8 (-> (app modulo n 8) <-)) () ...) ...)
  (env
   ((app
     *
     (-> (app jacobi n a) <-)
     (match (app even? (app / (app * (app - a 1) (app - n 1)) 4)) ...)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  n-mod-8
  (let (... () (n-mod-8 (-> (app modulo n 8) <-)) () ...) ...)
  (env ((app * (-> (app jacobi (app / a 2) n) <-) (app jacobi 2 n)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  n-mod-8
  (let (... () (n-mod-8 (-> (app modulo n 8) <-)) () ...) ...)
  (env ((app * (-> (app jacobi a (app / n 2)) <-) (app jacobi a 2)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  n-mod-8
  (let (... () (n-mod-8 (-> (app modulo n 8) <-)) () ...) ...)
  (env ((app * (app jacobi (app / a 2) n) (-> (app jacobi 2 n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  n-mod-8
  (let (... () (n-mod-8 (-> (app modulo n 8) <-)) () ...) ...)
  (env ((app * (app jacobi a (app / n 2)) (-> (app jacobi a 2) <-)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(store:
  n-mod-8
  (let (... () (n-mod-8 (-> (app modulo n 8) <-)) () ...) ...)
  (env ((let* (... () (jacobi-a-n (-> (app jacobi a n) <-)) exp ...) ...))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  n-mod-8
  (let (... () (n-mod-8 (-> (app modulo n 8) <-)) () ...) ...)
  (env ((match (app > a n) (#f) (_ (-> (app jacobi (app modulo a n) n) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  square
  (letrec* (... () (square (-> (λ (x) ...) <-)) modulo-power ...) ...)
  (env
   ((let* (...
           jacobi-a-n
           (exp (-> (app modulo-power a (app / (app - n 1) 2) n) <-))
           ()
           ...)
      ...))))
clos/con:
	'((letrec* (... () (square (-> (λ (x) ...) <-)) modulo-power ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

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

'(store: _ (let (... () (_ (-> (app display ".") <-)) () ...) ...) (env ()))
clos/con:
	'((con void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: _ (let (... () (_ (-> (app newline) <-)) () ...) ...) (env ()))
clos/con:
	'((con void) (env ()))
literals: '(⊥ ⊥ ⊥)
