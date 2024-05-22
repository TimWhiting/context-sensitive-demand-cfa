'(expression:
  (let ((id (λ (x) (let ((y 10)) x))))
    (let ((z (app id (app #t)))) (app id (app #f)))))

'(query: ((top) let (id) ...) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ()))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ()))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> id <-) (app #f)) (env ()))
clos/con:
	'((let (... () (id (-> (λ (x) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> id <-) (app #t)) (env ()))
clos/con:
	'((let (... () (id (-> (λ (x) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app id (-> (app #f) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app id (-> (app #t) <-)) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (... () (id (-> (λ (x) ...) <-)) () ...) ...) (env ()))
clos/con:
	'((let (... () (id (-> (λ (x) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (... () (y (-> 10 <-)) () ...) ...) (env ()))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query: (let (... () (z (-> (app id (app #t)) <-)) () ...) ...) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (id) (-> (let (z) ...) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (y) (-> x <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (z) (-> (app id (app #f)) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (x) (-> (let (y) ...) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: id ((top) let (id) ...) (env ()))
clos/con:
	'((let (... () (id (-> (λ (x) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: x (let (... () (id (-> (λ (x) ...) <-)) () ...) ...) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: y (let (... () (id (-> (λ (x) ...) <-)) () ...) ...) (env ()))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(store: z ((top) let (id) ...) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)
