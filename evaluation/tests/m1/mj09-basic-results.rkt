'(expression:
  (let ((h
         (λ (b)
           (let ((g (λ (z) z)))
             (let ((f (λ (k) (match b ((#f) (app k 2)) (_ (app k 1))))))
               (let ((y (app f (λ (x) x)))) (app g y)))))))
    (let ((x (app h (app #t))) (y (app h (app #f)))) y)))

'(query: ((top) let (h) ...) (env ()))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query: (let (... () (h (-> (λ (b) ...) <-)) () ...) ...) (env ()))
clos/con:
	'((let (... () (h (-> (λ (b) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (b) (-> (let (g) ...) <-)) (env ((□? (b)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (let (... () (g (-> (λ (z) ...) <-)) () ...) ...) (env ((□? (b)))))
clos/con:
	'((let (... () (g (-> (λ (z) ...) <-)) () ...) ...) (env ((□? (b)))))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (z) (-> z <-)) (env ((□? (z)) (□? (b)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (let (g) (-> (let (f) ...) <-)) (env ((□? (b)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (let (... () (f (-> (λ (k) ...) <-)) () ...) ...) (env ((□? (b)))))
clos/con:
	'((let (... () (f (-> (λ (k) ...) <-)) () ...) ...) (env ((□? (b)))))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (k) (-> (match b ...) <-)) (env ((□? (k)) (□? (b)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (match b (#f) (_ (-> (app k 1) <-))) (env ((□? (k)) (□? (b)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app k (-> 1 <-)) (env ((□? (k)) (□? (b)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app (-> k <-) 1) (env ((□? (k)) (□? (b)))))
clos/con:
	'((app f (-> (λ (x) ...) <-)) (env ((□? (b)))))
literals: '(⊥ ⊥ ⊥)

'(query: (match b ((#f) (-> (app k 2) <-)) _) (env ((□? (k)) (□? (b)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query: (app k (-> 2 <-)) (env ((□? (k)) (□? (b)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query: (app (-> k <-) 2) (env ((□? (k)) (□? (b)))))
clos/con:
	'((app f (-> (λ (x) ...) <-)) (env ((□? (b)))))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> b <-) (#f) _) (env ((□? (k)) (□? (b)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (f) (-> (let (y) ...) <-)) (env ((□? (b)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let (... () (y (-> (app f (λ (x) ...)) <-)) () ...) ...)
  (env ((□? (b)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app f (-> (λ (x) ...) <-)) (env ((□? (b)))))
clos/con:
	'((app f (-> (λ (x) ...) <-)) (env ((□? (b)))))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (x) (-> x <-)) (env ((□? (x)) (□? (b)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> f <-) (λ (x) ...)) (env ((□? (b)))))
clos/con:
	'((let (... () (f (-> (λ (k) ...) <-)) () ...) ...) (env ((□? (b)))))
literals: '(⊥ ⊥ ⊥)

'(query: (let (y) (-> (app g y) <-)) (env ((□? (b)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app g (-> y <-)) (env ((□? (b)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> g <-) y) (env ((□? (b)))))
clos/con:
	'((let (... () (g (-> (λ (z) ...) <-)) () ...) ...) (env ((□? (b)))))
literals: '(⊥ ⊥ ⊥)

'(query: (let (h) (-> (let (x ... y) ...) <-)) (env ()))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query: (let (... x (y (-> (app h (app #f)) <-)) () ...) ...) (env ()))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query: (app h (-> (app #f) <-)) (env ()))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ()))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> h <-) (app #f)) (env ()))
clos/con:
	'((let (... () (h (-> (λ (b) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (... () (x (-> (app h (app #t)) <-)) y ...) ...) (env ()))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app h (-> (app #t) <-)) (env ()))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ()))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> h <-) (app #t)) (env ()))
clos/con:
	'((let (... () (h (-> (λ (b) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (x ... y) (-> y <-)) (env ()))
clos/con: ⊥
literals: '(2 ⊥ ⊥)
