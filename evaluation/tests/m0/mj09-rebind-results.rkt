'(expression:
  (let ((h
         (λ (b)
           (let ((g (λ (z) z)))
             (let ((f (λ (k) (match b ((#f) (app k 2)) (_ (app k 1))))))
               (let ((y (app f (λ (x) x)))) (app g y)))))))
    (let ((x (app h (app #t))) (y (app h (app #f)))) y)))

'(query: ((top) let (h) ...) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ()))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ()))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> f <-) (λ (x) ...)) (env ()))
clos/con:
	'((let (... () (f (-> (λ (k) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> g <-) y) (env ()))
clos/con:
	'((let (... () (g (-> (λ (z) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> h <-) (app #f)) (env ()))
clos/con:
	'((let (... () (h (-> (λ (b) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> h <-) (app #t)) (env ()))
clos/con:
	'((let (... () (h (-> (λ (b) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> k <-) 1) (env ()))
clos/con:
	'((app f (-> (λ (x) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> k <-) 2) (env ()))
clos/con:
	'((app f (-> (λ (x) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app f (-> (λ (x) ...) <-)) (env ()))
clos/con:
	'((app f (-> (λ (x) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app g (-> y <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app h (-> (app #f) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app h (-> (app #t) <-)) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app k (-> 1 <-)) (env ()))
clos/con: ⊥
literals: '(1 ⊥ ⊥ ⊥)

'(query: (app k (-> 2 <-)) (env ()))
clos/con: ⊥
literals: '(2 ⊥ ⊥ ⊥)

'(query: (let (... () (f (-> (λ (k) ...) <-)) () ...) ...) (env ()))
clos/con:
	'((let (... () (f (-> (λ (k) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (let (... () (g (-> (λ (z) ...) <-)) () ...) ...) (env ()))
clos/con:
	'((let (... () (g (-> (λ (z) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (let (... () (h (-> (λ (b) ...) <-)) () ...) ...) (env ()))
clos/con:
	'((let (... () (h (-> (λ (b) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (let (... () (x (-> (app h (app #t)) <-)) y ...) ...) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (let (... () (y (-> (app f (λ (x) ...)) <-)) () ...) ...) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (let (... x (y (-> (app h (app #f)) <-)) () ...) ...) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (let (f) (-> (let (y) ...) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (let (g) (-> (let (f) ...) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (let (h) (-> (let (x ... y) ...) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (let (x ... y) (-> y <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (let (y) (-> (app g y) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (match (-> b <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match b (#f) (_ (-> (app k 1) <-))) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (match b ((#f) (-> (app k 2) <-)) _) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (λ (b) (-> (let (g) ...) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (λ (k) (-> (match b ...) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (λ (x) (-> x <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (λ (z) (-> z <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: b (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: f (env ()))
clos/con:
	'((let (... () (f (-> (λ (k) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: g (env ()))
clos/con:
	'((let (... () (g (-> (λ (z) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: h (env ()))
clos/con:
	'((let (... () (h (-> (λ (b) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: k (env ()))
clos/con:
	'((app f (-> (λ (x) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: x (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: y (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: z (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)
