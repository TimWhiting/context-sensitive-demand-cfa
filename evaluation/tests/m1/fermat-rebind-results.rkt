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
   (let ((_ (app display "Generating prime...")))
     (let ((_ (app newline)))
       (let ((_
              (app display (app generate-fermat-prime byte-size iterations))))
         (let ((_
                (app display " is prime with at least probability 1 - 1/2^")))
           (let ((_ (app display iterations)))
             (let ((_ (app newline)))
               (let ((_ (app display " if it is not a Carmichael number.")))
                 (app newline))))))))))

'(query:
  (app
   (-> and <-)
   (app not (app is-trivial-composite? n))
   (app is-fermat-prime? n iterations))
  (env
   ((app display (-> (app generate-fermat-prime byte-size iterations) <-)))))
clos/con:
	'((prim and)
  (env
   ((app display (-> (app generate-fermat-prime byte-size iterations) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   (-> and <-)
   (app not (app is-trivial-composite? n))
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
	'((prim and)
  (env
   ((match
     (app
      and
      (app not (app is-trivial-composite? n))
      (app is-fermat-prime? n iterations))
     ((#f) (-> (app generate-fermat-prime byte-size iterations) <-))
     _))))
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
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con:
	'((prim or) (env ((app not (-> (app is-trivial-composite? n) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   and
   (-> (app not (app is-trivial-composite? n)) <-)
   (app is-fermat-prime? n iterations))
  (env
   ((app display (-> (app generate-fermat-prime byte-size iterations) <-)))))
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
   ((app display (-> (app generate-fermat-prime byte-size iterations) <-)))))
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
  (app (-> #f <-))
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> #f <-))
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> * <-) base (app modulo-power base (app - exp 1) n))
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con:
	'((prim *)
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> * <-) base (app modulo-power base (app - exp 1) n))
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con:
	'((prim *) (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> * <-) base (app modulo-power base (app - exp 1) n))
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
clos/con:
	'((prim *)
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> * <-) x x)
  (env
   ((app
     modulo
     (-> (app square (app modulo-power base (app / exp 2) n)) <-)
     n))))
clos/con:
	'((prim *)
  (env
   ((app
     modulo
     (-> (app square (app modulo-power base (app / exp 2) n)) <-)
     n))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> - <-) exp 1)
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con:
	'((prim -)
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> - <-) exp 1)
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con:
	'((prim -) (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> - <-) exp 1)
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
clos/con:
	'((prim -)
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> - <-) iterations 1)
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con:
	'((prim -)
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> - <-) iterations 1)
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con:
	'((prim -)
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> - <-) n 1)
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con:
	'((prim -)
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> - <-) n 1)
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con:
	'((prim -)
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> / <-) (app log n) (app log 2))
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con:
	'((prim /)
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> / <-) (app log n) (app log 2))
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con:
	'((prim /)
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> / <-) exp 2)
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con:
	'((prim /)
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> / <-) exp 2)
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con:
	'((prim /) (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> / <-) exp 2)
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
clos/con:
	'((prim /)
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> <= <-) iterations 0)
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con:
	'((prim <=)
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> <= <-) iterations 0)
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con:
	'((prim <=)
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> = <-) (app modulo n 11) 0)
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con:
	'((prim =) (env ((app not (-> (app is-trivial-composite? n) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> = <-) (app modulo n 13) 0)
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con:
	'((prim =) (env ((app not (-> (app is-trivial-composite? n) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> = <-) (app modulo n 17) 0)
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con:
	'((prim =) (env ((app not (-> (app is-trivial-composite? n) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> = <-) (app modulo n 19) 0)
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con:
	'((prim =) (env ((app not (-> (app is-trivial-composite? n) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> = <-) (app modulo n 2) 0)
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con:
	'((prim =) (env ((app not (-> (app is-trivial-composite? n) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> = <-) (app modulo n 23) 0)
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con:
	'((prim =) (env ((app not (-> (app is-trivial-composite? n) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> = <-) (app modulo n 3) 0)
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con:
	'((prim =) (env ((app not (-> (app is-trivial-composite? n) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> = <-) (app modulo n 5) 0)
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con:
	'((prim =) (env ((app not (-> (app is-trivial-composite? n) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> = <-) (app modulo n 7) 0)
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con:
	'((prim =) (env ((app not (-> (app is-trivial-composite? n) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> = <-) (app modulo-power a (app - n 1) n) 1)
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con:
	'((prim =)
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> = <-) (app modulo-power a (app - n 1) n) 1)
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con:
	'((prim =)
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> = <-) exp 0)
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con:
	'((prim =)
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> = <-) exp 0)
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con:
	'((prim =) (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> = <-) exp 0)
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
clos/con:
	'((prim =)
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> ceiling <-) (app / (app log n) (app log 2)))
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con:
	'((prim ceiling)
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> ceiling <-) (app / (app log n) (app log 2)))
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con:
	'((prim ceiling)
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> display <-) " is prime with at least probability 1 - 1/2^")
  (env ()))
clos/con:
	'((prim display) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> display <-) (app generate-fermat-prime byte-size iterations))
  (env ()))
clos/con:
	'((prim display) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> generate-fermat-prime <-) byte-size iterations)
  (env
   ((app display (-> (app generate-fermat-prime byte-size iterations) <-)))))
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
  (app (-> generate-fermat-prime <-) byte-size iterations)
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

'(query:
  (app (-> is-fermat-prime? <-) n (app - iterations 1))
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

'(query:
  (app (-> is-fermat-prime? <-) n (app - iterations 1))
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

'(query:
  (app (-> is-fermat-prime? <-) n iterations)
  (env
   ((app display (-> (app generate-fermat-prime byte-size iterations) <-)))))
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
  (app (-> is-fermat-prime? <-) n iterations)
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

'(query:
  (app (-> is-trivial-composite? <-) n)
  (env
   ((app display (-> (app generate-fermat-prime byte-size iterations) <-)))))
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
  (app (-> is-trivial-composite? <-) n)
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

'(query:
  (app (-> log <-) 2)
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con:
	'((prim log)
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> log <-) 2)
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con:
	'((prim log)
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> log <-) n)
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con:
	'((prim log)
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> log <-) n)
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con:
	'((prim log)
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> modulo <-) (app * base (app modulo-power base (app - exp 1) n)) n)
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con:
	'((prim modulo)
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> modulo <-) (app * base (app modulo-power base (app - exp 1) n)) n)
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con:
	'((prim modulo) (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> modulo <-) (app * base (app modulo-power base (app - exp 1) n)) n)
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
clos/con:
	'((prim modulo)
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> modulo <-) (app square (app modulo-power base (app / exp 2) n)) n)
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con:
	'((prim modulo)
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> modulo <-) (app square (app modulo-power base (app / exp 2) n)) n)
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con:
	'((prim modulo) (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> modulo <-) (app square (app modulo-power base (app / exp 2) n)) n)
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
clos/con:
	'((prim modulo)
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> modulo <-) n 11)
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con:
	'((prim modulo) (env ((app not (-> (app is-trivial-composite? n) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> modulo <-) n 13)
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con:
	'((prim modulo) (env ((app not (-> (app is-trivial-composite? n) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> modulo <-) n 17)
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con:
	'((prim modulo) (env ((app not (-> (app is-trivial-composite? n) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> modulo <-) n 19)
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con:
	'((prim modulo) (env ((app not (-> (app is-trivial-composite? n) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> modulo <-) n 2)
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con:
	'((prim modulo) (env ((app not (-> (app is-trivial-composite? n) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> modulo <-) n 23)
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con:
	'((prim modulo) (env ((app not (-> (app is-trivial-composite? n) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> modulo <-) n 3)
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con:
	'((prim modulo) (env ((app not (-> (app is-trivial-composite? n) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> modulo <-) n 5)
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con:
	'((prim modulo) (env ((app not (-> (app is-trivial-composite? n) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> modulo <-) n 7)
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con:
	'((prim modulo) (env ((app not (-> (app is-trivial-composite? n) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> modulo-power <-) a (app - n 1) n)
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

'(query:
  (app (-> modulo-power <-) a (app - n 1) n)
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

'(query:
  (app (-> modulo-power <-) base (app - exp 1) n)
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

'(query:
  (app (-> modulo-power <-) base (app - exp 1) n)
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

'(query:
  (app (-> modulo-power <-) base (app - exp 1) n)
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

'(query:
  (app (-> modulo-power <-) base (app / exp 2) n)
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

'(query:
  (app (-> modulo-power <-) base (app / exp 2) n)
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

'(query:
  (app (-> modulo-power <-) base (app / exp 2) n)
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

'(query:
  (app (-> not <-) (app is-trivial-composite? n))
  (env
   ((app display (-> (app generate-fermat-prime byte-size iterations) <-)))))
clos/con:
	'((prim not)
  (env
   ((app display (-> (app generate-fermat-prime byte-size iterations) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> not <-) (app is-trivial-composite? n))
  (env
   ((match
     (app
      and
      (app not (app is-trivial-composite? n))
      (app is-fermat-prime? n iterations))
     ((#f) (-> (app generate-fermat-prime byte-size iterations) <-))
     _))))
clos/con:
	'((prim not)
  (env
   ((match
     (app
      and
      (app not (app is-trivial-composite? n))
      (app is-fermat-prime? n iterations))
     ((#f) (-> (app generate-fermat-prime byte-size iterations) <-))
     _))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> odd? <-) exp)
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con:
	'((prim odd?)
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> odd? <-) exp)
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con:
	'((prim odd?) (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> odd? <-) exp)
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
clos/con:
	'((prim odd?)
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> or <-) (app <= iterations 0) (let* (byte-size ... a) ...))
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con:
	'((prim or)
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> or <-) (app <= iterations 0) (let* (byte-size ... a) ...))
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con:
	'((prim or)
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> random <-) byte-size)
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con:
	'((prim random)
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> random <-) byte-size)
  (env
   ((app display (-> (app generate-fermat-prime byte-size iterations) <-)))))
clos/con:
	'((prim random)
  (env
   ((app display (-> (app generate-fermat-prime byte-size iterations) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> random <-) byte-size)
  (env
   ((match
     (app
      and
      (app not (app is-trivial-composite? n))
      (app is-fermat-prime? n iterations))
     ((#f) (-> (app generate-fermat-prime byte-size iterations) <-))
     _))))
clos/con:
	'((prim random)
  (env
   ((match
     (app
      and
      (app not (app is-trivial-composite? n))
      (app is-fermat-prime? n iterations))
     ((#f) (-> (app generate-fermat-prime byte-size iterations) <-))
     _))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> random <-) byte-size)
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con:
	'((prim random)
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> square <-) (app modulo-power base (app / exp 2) n))
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con:
	'((letrec* (... () (square (-> (λ (x) ...) <-)) modulo-power ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> square <-) (app modulo-power base (app / exp 2) n))
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con:
	'((letrec* (... () (square (-> (λ (x) ...) <-)) modulo-power ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> square <-) (app modulo-power base (app / exp 2) n))
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
clos/con:
	'((letrec* (... () (square (-> (λ (x) ...) <-)) modulo-power ...) ...)
  (env ()))
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
  (app - exp (-> 1 <-))
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (app - exp (-> 1 <-))
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (app - exp (-> 1 <-))
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (app - iterations (-> 1 <-))
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (app - iterations (-> 1 <-))
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (app - n (-> 1 <-))
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (app - n (-> 1 <-))
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

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
  (app / exp (-> 2 <-))
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query:
  (app / exp (-> 2 <-))
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query:
  (app / exp (-> 2 <-))
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

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
  (app <= iterations (-> 0 <-))
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query:
  (app <= iterations (-> 0 <-))
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

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
  (app = (app modulo n 11) (-> 0 <-))
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query:
  (app = (app modulo n 13) (-> 0 <-))
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query:
  (app = (app modulo n 17) (-> 0 <-))
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query:
  (app = (app modulo n 19) (-> 0 <-))
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query:
  (app = (app modulo n 2) (-> 0 <-))
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query:
  (app = (app modulo n 23) (-> 0 <-))
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query:
  (app = (app modulo n 3) (-> 0 <-))
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query:
  (app = (app modulo n 5) (-> 0 <-))
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query:
  (app = (app modulo n 7) (-> 0 <-))
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query:
  (app = (app modulo-power a (app - n 1) n) (-> 1 <-))
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (app = (app modulo-power a (app - n 1) n) (-> 1 <-))
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (app = exp (-> 0 <-))
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query:
  (app = exp (-> 0 <-))
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query:
  (app = exp (-> 0 <-))
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

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
  (app display (-> " is prime with at least probability 1 - 1/2^" <-))
  (env ()))
clos/con: ⊥
literals: '(⊥ ⊥ " is prime with at least probability 1 - 1/2^")

'(query:
  (app display (-> (app generate-fermat-prime byte-size iterations) <-))
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app generate-fermat-prime (-> byte-size <-) iterations)
  (env
   ((app display (-> (app generate-fermat-prime byte-size iterations) <-)))))
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
   ((app display (-> (app generate-fermat-prime byte-size iterations) <-)))))
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
   ((app display (-> (app generate-fermat-prime byte-size iterations) <-)))))
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
   ((app display (-> (app generate-fermat-prime byte-size iterations) <-)))))
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
   ((app display (-> (app generate-fermat-prime byte-size iterations) <-)))))
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
  (app log (-> 2 <-))
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query:
  (app log (-> 2 <-))
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

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
  (app modulo n (-> 11 <-))
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con: ⊥
literals: '(11 ⊥ ⊥)

'(query:
  (app modulo n (-> 13 <-))
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con: ⊥
literals: '(13 ⊥ ⊥)

'(query:
  (app modulo n (-> 17 <-))
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con: ⊥
literals: '(17 ⊥ ⊥)

'(query:
  (app modulo n (-> 19 <-))
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con: ⊥
literals: '(19 ⊥ ⊥)

'(query:
  (app modulo n (-> 2 <-))
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query:
  (app modulo n (-> 23 <-))
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con: ⊥
literals: '(23 ⊥ ⊥)

'(query:
  (app modulo n (-> 3 <-))
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(query:
  (app modulo n (-> 5 <-))
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con: ⊥
literals: '(5 ⊥ ⊥)

'(query:
  (app modulo n (-> 7 <-))
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
clos/con: ⊥
literals: '(7 ⊥ ⊥)

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
   ((app display (-> (app generate-fermat-prime byte-size iterations) <-)))))
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
   ((app display (-> (app generate-fermat-prime byte-size iterations) <-)))))
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
  (let (...
        ()
        (_
         (->
          (app display (app generate-fermat-prime byte-size iterations))
          <-))
        ()
        ...)
    ...)
  (env ()))
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
  (let (...
        ()
        (_ (-> (app display " if it is not a Carmichael number.") <-))
        ()
        ...)
    ...)
  (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app display "Generating prime...") <-)) () ...) ...)
  (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app display iterations) <-)) () ...) ...)
  (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (n (-> (app random byte-size) <-)) () ...) ...)
  (env
   ((app display (-> (app generate-fermat-prime byte-size iterations) <-)))))
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
   ((app display (-> (app generate-fermat-prime byte-size iterations) <-)))))
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
  (env
   ((app display (-> (app generate-fermat-prime byte-size iterations) <-)))))
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
   ((app display (-> (app generate-fermat-prime byte-size iterations) <-)))))
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
   ((app display (-> (app generate-fermat-prime byte-size iterations) <-)))))
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
  (match (app = exp 0) (#f) (_ (-> 1 <-)))
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (match (app = exp 0) (#f) (_ (-> 1 <-)))
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (match (app = exp 0) (#f) (_ (-> 1 <-)))
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

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
   ((app display (-> (app generate-fermat-prime byte-size iterations) <-)))))
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
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> display <-) " if it is not a Carmichael number.") (env ()))
clos/con:
	'((prim display) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> display <-) "Generating prime...") (env ()))
clos/con:
	'((prim display) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> display <-) iterations) (env ()))
clos/con:
	'((prim display) (env ()))
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

'(query: (app (-> newline <-)) (env ()))
clos/con:
	'((prim newline) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> newline <-)) (env ()))
clos/con:
	'((prim newline) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> newline <-)) (env ()))
clos/con:
	'((prim newline) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app display (-> " if it is not a Carmichael number." <-)) (env ()))
clos/con: ⊥
literals: '(⊥ ⊥ " if it is not a Carmichael number.")

'(query: (app display (-> "Generating prime..." <-)) (env ()))
clos/con: ⊥
literals: '(⊥ ⊥ "Generating prime...")

'(query: (app display (-> iterations <-)) (env ()))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query: (app generate-fermat-prime (-> byte-size <-) iterations) (env ()))
clos/con: ⊥
literals: '(15 ⊥ ⊥)

'(query: (app generate-fermat-prime byte-size (-> iterations <-)) (env ()))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query: (let (... () (_ (-> (app newline) <-)) () ...) ...) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (... () (_ (-> (app newline) <-)) () ...) ...) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (app newline) <-)) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (letrec* (... iterations (byte-size (-> 15 <-)) () ...) ...) (env ()))
clos/con: ⊥
literals: '(15 ⊥ ⊥)

'(query: (letrec* (square ... byte-size) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  *
  (letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-trivial-composite?
    ...)
   ...)
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con:
	'((λ (base exp n) (-> (match (app = exp 0) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  *
  (letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-trivial-composite?
    ...)
   ...)
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con:
	'((λ (base exp n) (-> (match (app = exp 0) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  *
  (letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-trivial-composite?
    ...)
   ...)
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
clos/con:
	'((λ (base exp n) (-> (match (app = exp 0) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  *
  (letrec* (... () (square (-> (λ (x) ...) <-)) modulo-power ...) ...)
  (env
   ((app
     modulo
     (-> (app square (app modulo-power base (app / exp 2) n)) <-)
     n))))
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
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con:
	'((λ (n iterations)
    (-> (app or (app <= iterations 0) (let* (byte-size ... a) ...)) <-))
  (env ()))
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
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
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
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con:
	'((λ (base exp n) (-> (match (app = exp 0) ...) <-)) (env ()))
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
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con:
	'((λ (base exp n) (-> (match (app = exp 0) ...) <-)) (env ()))
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
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
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
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con:
	'((λ (n iterations)
    (-> (app or (app <= iterations 0) (let* (byte-size ... a) ...)) <-))
  (env ()))
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
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
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
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con:
	'((λ (base exp n) (-> (match (app = exp 0) ...) <-)) (env ()))
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
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con:
	'((λ (base exp n) (-> (match (app = exp 0) ...) <-)) (env ()))
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
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
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
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con:
	'((λ (n iterations)
    (-> (app or (app <= iterations 0) (let* (byte-size ... a) ...)) <-))
  (env ()))
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
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
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
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
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
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
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
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
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
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con:
	'((λ (base exp n) (-> (match (app = exp 0) ...) <-)) (env ()))
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
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con:
	'((λ (base exp n) (-> (match (app = exp 0) ...) <-)) (env ()))
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
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
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
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  a
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
  (env
   ((app display (-> (app generate-fermat-prime byte-size iterations) <-)))))
clos/con:
	'((λ (byte-size iterations) (-> (let (n) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  and
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
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  base
  (letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-trivial-composite?
    ...)
   ...)
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  base
  (letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-trivial-composite?
    ...)
   ...)
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
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
  (env
   ((app display (-> (app generate-fermat-prime byte-size iterations) <-)))))
clos/con: ⊥
literals: '(15 ⊥ ⊥)

'(store:
  byte-size
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
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  byte-size
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
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con:
	'((λ (n iterations)
    (-> (app or (app <= iterations 0) (let* (byte-size ... a) ...)) <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  ceiling
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
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  exp
  (letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-trivial-composite?
    ...)
   ...)
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  exp
  (letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-trivial-composite?
    ...)
   ...)
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
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
  (env
   ((app display (-> (app generate-fermat-prime byte-size iterations) <-)))))
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
  is-fermat-prime?
  (letrec*
   (...
    is-fermat-prime?
    (generate-fermat-prime (-> (λ (byte-size iterations) ...) <-))
    iterations
    ...)
   ...)
  (env
   ((app display (-> (app generate-fermat-prime byte-size iterations) <-)))))
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
  (env
   ((app display (-> (app generate-fermat-prime byte-size iterations) <-)))))
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
  iterations
  (letrec*
   (...
    is-fermat-prime?
    (generate-fermat-prime (-> (λ (byte-size iterations) ...) <-))
    iterations
    ...)
   ...)
  (env
   ((app display (-> (app generate-fermat-prime byte-size iterations) <-)))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(store:
  iterations
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
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
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
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
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
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con:
	'((λ (n iterations)
    (-> (app or (app <= iterations 0) (let* (byte-size ... a) ...)) <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  log
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
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
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
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con:
	'((λ (base exp n) (-> (match (app = exp 0) ...) <-)) (env ()))
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
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con:
	'((λ (base exp n) (-> (match (app = exp 0) ...) <-)) (env ()))
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
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
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
  n
  (letrec*
   (...
    is-fermat-prime?
    (generate-fermat-prime (-> (λ (byte-size iterations) ...) <-))
    iterations
    ...)
   ...)
  (env
   ((app display (-> (app generate-fermat-prime byte-size iterations) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  n
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
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
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
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
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
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
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
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
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
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
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
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
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
  (env
   ((app display (-> (app generate-fermat-prime byte-size iterations) <-)))))
clos/con:
	'((λ (byte-size iterations) (-> (let (n) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  not
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
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con:
	'((λ (base exp n) (-> (match (app = exp 0) ...) <-)) (env ()))
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
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con:
	'((λ (base exp n) (-> (match (app = exp 0) ...) <-)) (env ()))
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
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
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
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con:
	'((λ (n iterations)
    (-> (app or (app <= iterations 0) (let* (byte-size ... a) ...)) <-))
  (env ()))
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
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
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
  (env ((app not (-> (app is-trivial-composite? n) <-)))))
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
  (env
   ((app display (-> (app generate-fermat-prime byte-size iterations) <-)))))
clos/con:
	'((λ (byte-size iterations) (-> (let (n) ...) <-)) (env ()))
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
  (env
   ((match
     (app
      and
      (app not (app is-trivial-composite? n))
      (app is-fermat-prime? n iterations))
     ((#f) (-> (app generate-fermat-prime byte-size iterations) <-))
     _))))
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
  (env
   ((app
     and
     (app not (app is-trivial-composite? n))
     (-> (app is-fermat-prime? n iterations) <-)))))
clos/con:
	'((λ (n iterations)
    (-> (app or (app <= iterations 0) (let* (byte-size ... a) ...)) <-))
  (env ()))
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
  (env
   ((match
     (app = (app modulo-power a (app - n 1) n) 1)
     (#f)
     (_ (-> (app is-fermat-prime? n (app - iterations 1)) <-))))))
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
  (env ((app * base (-> (app modulo-power base (app - exp 1) n) <-)))))
clos/con:
	'((letrec* (... () (square (-> (λ (x) ...) <-)) modulo-power ...) ...)
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
  (env ((app = (-> (app modulo-power a (app - n 1) n) <-) 1))))
clos/con:
	'((letrec* (... () (square (-> (λ (x) ...) <-)) modulo-power ...) ...)
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
  (env ((app square (-> (app modulo-power base (app / exp 2) n) <-)))))
clos/con:
	'((letrec* (... () (square (-> (λ (x) ...) <-)) modulo-power ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x
  (letrec* (... () (square (-> (λ (x) ...) <-)) modulo-power ...) ...)
  (env
   ((app
     modulo
     (-> (app square (app modulo-power base (app / exp 2) n)) <-)
     n))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store: _ ((top) letrec* (square ... byte-size) ...) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

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
