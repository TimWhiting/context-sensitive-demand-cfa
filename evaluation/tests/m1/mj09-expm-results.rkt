'(expression:
  (let ((h
         (λ (b)
           (let ((g (λ (z) z)))
             (let ((f (λ (k) (match b ((#f) (app k 2)) (_ (app k 1))))))
               (let ((y (app f (λ (x) x)))) (app g y)))))))
    (let ((x (app h (app #t))) (y (app h (app #f)))) y)))

'(query:
  (app (-> f <-) (λ (x) ...))
  (env (((let (... () (x (-> (app h (app #t)) <-)) y ...) ...)))))
clos/con:
	'((let (... () (f (-> (λ (k) ...) <-)) () ...) ...)
  (env (((let (... () (x (-> (app h (app #t)) <-)) y ...) ...)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f <-) (λ (x) ...))
  (env (((let (... x (y (-> (app h (app #f)) <-)) () ...) ...)))))
clos/con:
	'((let (... () (f (-> (λ (k) ...) <-)) () ...) ...)
  (env (((let (... x (y (-> (app h (app #f)) <-)) () ...) ...)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> g <-) y)
  (env (((let (... () (x (-> (app h (app #t)) <-)) y ...) ...)))))
clos/con:
	'((let (... () (g (-> (λ (z) ...) <-)) () ...) ...)
  (env (((let (... () (x (-> (app h (app #t)) <-)) y ...) ...)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> g <-) y)
  (env (((let (... x (y (-> (app h (app #f)) <-)) () ...) ...)))))
clos/con:
	'((let (... () (g (-> (λ (z) ...) <-)) () ...) ...)
  (env (((let (... x (y (-> (app h (app #f)) <-)) () ...) ...)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> k <-) 1)
  (env
   (((let (... () (y (-> (app f (λ (x) ...)) <-)) () ...) ...))
    ((let (... () (x (-> (app h (app #t)) <-)) y ...) ...)))))
clos/con:
	'((app f (-> (λ (x) ...) <-))
  (env (((let (... () (x (-> (app h (app #t)) <-)) y ...) ...)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> k <-) 2)
  (env
   (((let (... () (y (-> (app f (λ (x) ...)) <-)) () ...) ...))
    ((let (... x (y (-> (app h (app #f)) <-)) () ...) ...)))))
clos/con:
	'((app f (-> (λ (x) ...) <-))
  (env (((let (... x (y (-> (app h (app #f)) <-)) () ...) ...)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f (-> (λ (x) ...) <-))
  (env (((let (... () (x (-> (app h (app #t)) <-)) y ...) ...)))))
clos/con:
	'((app f (-> (λ (x) ...) <-))
  (env (((let (... () (x (-> (app h (app #t)) <-)) y ...) ...)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f (-> (λ (x) ...) <-))
  (env (((let (... x (y (-> (app h (app #f)) <-)) () ...) ...)))))
clos/con:
	'((app f (-> (λ (x) ...) <-))
  (env (((let (... x (y (-> (app h (app #f)) <-)) () ...) ...)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app g (-> y <-))
  (env (((let (... () (x (-> (app h (app #t)) <-)) y ...) ...)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (app g (-> y <-))
  (env (((let (... x (y (-> (app h (app #f)) <-)) () ...) ...)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query:
  (app k (-> 1 <-))
  (env
   (((let (... () (y (-> (app f (λ (x) ...)) <-)) () ...) ...))
    ((let (... () (x (-> (app h (app #t)) <-)) y ...) ...)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (app k (-> 2 <-))
  (env
   (((let (... () (y (-> (app f (λ (x) ...)) <-)) () ...) ...))
    ((let (... x (y (-> (app h (app #f)) <-)) () ...) ...)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query:
  (let (... () (f (-> (λ (k) ...) <-)) () ...) ...)
  (env (((let (... () (x (-> (app h (app #t)) <-)) y ...) ...)))))
clos/con:
	'((let (... () (f (-> (λ (k) ...) <-)) () ...) ...)
  (env (((let (... () (x (-> (app h (app #t)) <-)) y ...) ...)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (f (-> (λ (k) ...) <-)) () ...) ...)
  (env (((let (... x (y (-> (app h (app #f)) <-)) () ...) ...)))))
clos/con:
	'((let (... () (f (-> (λ (k) ...) <-)) () ...) ...)
  (env (((let (... x (y (-> (app h (app #f)) <-)) () ...) ...)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (g (-> (λ (z) ...) <-)) () ...) ...)
  (env (((let (... () (x (-> (app h (app #t)) <-)) y ...) ...)))))
clos/con:
	'((let (... () (g (-> (λ (z) ...) <-)) () ...) ...)
  (env (((let (... () (x (-> (app h (app #t)) <-)) y ...) ...)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (g (-> (λ (z) ...) <-)) () ...) ...)
  (env (((let (... x (y (-> (app h (app #f)) <-)) () ...) ...)))))
clos/con:
	'((let (... () (g (-> (λ (z) ...) <-)) () ...) ...)
  (env (((let (... x (y (-> (app h (app #f)) <-)) () ...) ...)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (y (-> (app f (λ (x) ...)) <-)) () ...) ...)
  (env (((let (... () (x (-> (app h (app #t)) <-)) y ...) ...)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (let (... () (y (-> (app f (λ (x) ...)) <-)) () ...) ...)
  (env (((let (... x (y (-> (app h (app #f)) <-)) () ...) ...)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query:
  (let (f) (-> (let (y) ...) <-))
  (env (((let (... () (x (-> (app h (app #t)) <-)) y ...) ...)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (let (f) (-> (let (y) ...) <-))
  (env (((let (... x (y (-> (app h (app #f)) <-)) () ...) ...)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query:
  (let (g) (-> (let (f) ...) <-))
  (env (((let (... () (x (-> (app h (app #t)) <-)) y ...) ...)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (let (g) (-> (let (f) ...) <-))
  (env (((let (... x (y (-> (app h (app #f)) <-)) () ...) ...)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query:
  (let (y) (-> (app g y) <-))
  (env (((let (... () (x (-> (app h (app #t)) <-)) y ...) ...)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (let (y) (-> (app g y) <-))
  (env (((let (... x (y (-> (app h (app #f)) <-)) () ...) ...)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query:
  (match (-> b <-) (#f) _)
  (env
   (((let (... () (y (-> (app f (λ (x) ...)) <-)) () ...) ...))
    ((let (... () (x (-> (app h (app #t)) <-)) y ...) ...)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> b <-) (#f) _)
  (env
   (((let (... () (y (-> (app f (λ (x) ...)) <-)) () ...) ...))
    ((let (... x (y (-> (app h (app #f)) <-)) () ...) ...)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match b (#f) (_ (-> (app k 1) <-)))
  (env
   (((let (... () (y (-> (app f (λ (x) ...)) <-)) () ...) ...))
    ((let (... () (x (-> (app h (app #t)) <-)) y ...) ...)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (match b ((#f) (-> (app k 2) <-)) _)
  (env
   (((let (... () (y (-> (app f (λ (x) ...)) <-)) () ...) ...))
    ((let (... x (y (-> (app h (app #f)) <-)) () ...) ...)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query:
  (λ (b) (-> (let (g) ...) <-))
  (env (((let (... () (x (-> (app h (app #t)) <-)) y ...) ...)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (λ (b) (-> (let (g) ...) <-))
  (env (((let (... x (y (-> (app h (app #f)) <-)) () ...) ...)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query:
  (λ (k) (-> (match b ...) <-))
  (env
   (((let (... () (y (-> (app f (λ (x) ...)) <-)) () ...) ...))
    ((let (... () (x (-> (app h (app #t)) <-)) y ...) ...)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (λ (k) (-> (match b ...) <-))
  (env
   (((let (... () (y (-> (app f (λ (x) ...)) <-)) () ...) ...))
    ((let (... x (y (-> (app h (app #f)) <-)) () ...) ...)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query:
  (λ (x) (-> x <-))
  (env
   (((match b (#f) (_ (-> (app k 1) <-))))
    ((let (... () (x (-> (app h (app #t)) <-)) y ...) ...)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (λ (x) (-> x <-))
  (env
   (((match b ((#f) (-> (app k 2) <-)) _))
    ((let (... x (y (-> (app h (app #f)) <-)) () ...) ...)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query:
  (λ (z) (-> z <-))
  (env
   (((let (y) (-> (app g y) <-)))
    ((let (... () (x (-> (app h (app #t)) <-)) y ...) ...)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (λ (z) (-> z <-))
  (env
   (((let (y) (-> (app g y) <-)))
    ((let (... x (y (-> (app h (app #f)) <-)) () ...) ...)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query: ((top) let (h) ...) (env ()))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query: (app (-> #f <-)) (env ()))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ()))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> h <-) (app #f)) (env ()))
clos/con:
	'((let (... () (h (-> (λ (b) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> h <-) (app #t)) (env ()))
clos/con:
	'((let (... () (h (-> (λ (b) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app h (-> (app #f) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app h (-> (app #t) <-)) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (... () (h (-> (λ (b) ...) <-)) () ...) ...) (env ()))
clos/con:
	'((let (... () (h (-> (λ (b) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (... () (x (-> (app h (app #t)) <-)) y ...) ...) (env ()))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (let (... x (y (-> (app h (app #f)) <-)) () ...) ...) (env ()))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query: (let (h) (-> (let (x ... y) ...) <-)) (env ()))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query: (let (x ... y) (-> y <-)) (env ()))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(store:
  b
  (λ (b) (-> (let (g) ...) <-))
  (env (((let (... () (x (-> (app h (app #t)) <-)) y ...) ...)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  b
  (λ (b) (-> (let (g) ...) <-))
  (env (((let (... x (y (-> (app h (app #f)) <-)) () ...) ...)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  f
  (let (... () (f (-> (λ (k) ...) <-)) () ...) ...)
  (env (((let (... () (x (-> (app h (app #t)) <-)) y ...) ...)))))
clos/con:
	'((let (... () (f (-> (λ (k) ...) <-)) () ...) ...)
  (env (((let (... () (x (-> (app h (app #t)) <-)) y ...) ...)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  f
  (let (... () (f (-> (λ (k) ...) <-)) () ...) ...)
  (env (((let (... x (y (-> (app h (app #f)) <-)) () ...) ...)))))
clos/con:
	'((let (... () (f (-> (λ (k) ...) <-)) () ...) ...)
  (env (((let (... x (y (-> (app h (app #f)) <-)) () ...) ...)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  g
  (let (... () (g (-> (λ (z) ...) <-)) () ...) ...)
  (env (((let (... () (x (-> (app h (app #t)) <-)) y ...) ...)))))
clos/con:
	'((let (... () (g (-> (λ (z) ...) <-)) () ...) ...)
  (env (((let (... () (x (-> (app h (app #t)) <-)) y ...) ...)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  g
  (let (... () (g (-> (λ (z) ...) <-)) () ...) ...)
  (env (((let (... x (y (-> (app h (app #f)) <-)) () ...) ...)))))
clos/con:
	'((let (... () (g (-> (λ (z) ...) <-)) () ...) ...)
  (env (((let (... x (y (-> (app h (app #f)) <-)) () ...) ...)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  k
  (λ (k) (-> (match b ...) <-))
  (env
   (((let (... () (y (-> (app f (λ (x) ...)) <-)) () ...) ...))
    ((let (... () (x (-> (app h (app #t)) <-)) y ...) ...)))))
clos/con:
	'((app f (-> (λ (x) ...) <-))
  (env (((let (... () (x (-> (app h (app #t)) <-)) y ...) ...)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  k
  (λ (k) (-> (match b ...) <-))
  (env
   (((let (... () (y (-> (app f (λ (x) ...)) <-)) () ...) ...))
    ((let (... x (y (-> (app h (app #f)) <-)) () ...) ...)))))
clos/con:
	'((app f (-> (λ (x) ...) <-))
  (env (((let (... x (y (-> (app h (app #f)) <-)) () ...) ...)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  x
  (λ (x) (-> x <-))
  (env
   (((match b (#f) (_ (-> (app k 1) <-))))
    ((let (... () (x (-> (app h (app #t)) <-)) y ...) ...)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(store:
  x
  (λ (x) (-> x <-))
  (env
   (((match b ((#f) (-> (app k 2) <-)) _))
    ((let (... x (y (-> (app h (app #f)) <-)) () ...) ...)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(store:
  y
  (let (... () (y (-> (app f (λ (x) ...)) <-)) () ...) ...)
  (env (((let (... () (x (-> (app h (app #t)) <-)) y ...) ...)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(store:
  y
  (let (... () (y (-> (app f (λ (x) ...)) <-)) () ...) ...)
  (env (((let (... x (y (-> (app h (app #f)) <-)) () ...) ...)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(store:
  z
  (λ (z) (-> z <-))
  (env
   (((let (y) (-> (app g y) <-)))
    ((let (... () (x (-> (app h (app #t)) <-)) y ...) ...)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(store:
  z
  (λ (z) (-> z <-))
  (env
   (((let (y) (-> (app g y) <-)))
    ((let (... x (y (-> (app h (app #f)) <-)) () ...) ...)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(store: h (let (... () (h (-> (λ (b) ...) <-)) () ...) ...) (env ()))
clos/con:
	'((let (... () (h (-> (λ (b) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: x (let (... () (x (-> (app h (app #t)) <-)) y ...) ...) (env ()))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(store: y (let (... x (y (-> (app h (app #f)) <-)) () ...) ...) (env ()))
clos/con: ⊥
literals: '(2 ⊥ ⊥)
