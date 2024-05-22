'(expression:
  (let ((id (λ (x) (let ((y 10)) x))))
    (let ((z (app id (app #t)))) (app id (app #f)))))

'(query:
  (let (... () (y (-> 10 <-)) () ...) ...)
  (env (((let (... () (z (-> (app id (app #t)) <-)) () ...) ...)))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query:
  (let (... () (y (-> 10 <-)) () ...) ...)
  (env (((let (z) (-> (app id (app #f)) <-))))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query:
  (let (y) (-> x <-))
  (env (((let (... () (z (-> (app id (app #t)) <-)) () ...) ...)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x) (-> (let (y) ...) <-))
  (env (((let (... () (z (-> (app id (app #t)) <-)) () ...) ...)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x) (-> (let (y) ...) <-))
  (env (((let (z) (-> (app id (app #f)) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: ((top) let (id) ...) (env ()))
clos/con:
	'((con #f) (env ()))
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

'(query: (let (... () (z (-> (app id (app #t)) <-)) () ...) ...) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (id) (-> (let (z) ...) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (y) (-> x <-)) (env (((let (z) (-> (app id (app #f)) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (z) (-> (app id (app #f)) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x
  (λ (x) (-> (let (y) ...) <-))
  (env (((let (... () (z (-> (app id (app #t)) <-)) () ...) ...)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x
  (λ (x) (-> (let (y) ...) <-))
  (env (((let (z) (-> (app id (app #f)) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  y
  (let (... () (y (-> 10 <-)) () ...) ...)
  (env (((let (... () (z (-> (app id (app #t)) <-)) () ...) ...)))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(store:
  y
  (let (... () (y (-> 10 <-)) () ...) ...)
  (env (((let (z) (-> (app id (app #f)) <-))))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(store: id (let (... () (id (-> (λ (x) ...) <-)) () ...) ...) (env ()))
clos/con:
	'((let (... () (id (-> (λ (x) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: z (let (... () (z (-> (app id (app #t)) <-)) () ...) ...) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)
