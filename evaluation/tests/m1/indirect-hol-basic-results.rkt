'(expression:
  (letrec*
   ((do-something (λ () 10)) (id (λ (y) (let ((_ (app do-something))) y))))
   (let ((_ (app id (app #t)))) (app id (app #f)))))

'(query: ((top) letrec* (do-something ... id) ...) (env ()))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... do-something (id (-> (λ (y) ...) <-)) () ...) ...)
  (env ()))
clos/con:
	'((letrec* (... do-something (id (-> (λ (y) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (y) (-> (let (_) ...) <-)) (env ((□? (y)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app do-something) <-)) () ...) ...)
  (env ((□? (y)))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query: (app (-> do-something <-)) (env ((□? (y)))))
clos/con:
	'((letrec* (... () (do-something (-> (λ () ...) <-)) id ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> y <-)) (env ((□? (y)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... () (do-something (-> (λ () ...) <-)) id ...) ...)
  (env ()))
clos/con:
	'((letrec* (... () (do-something (-> (λ () ...) <-)) id ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ () (-> 10 <-)) (env ((□? ()))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query: (letrec* (do-something ... id) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (... () (_ (-> (app id (app #t)) <-)) () ...) ...) (env ()))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app id (-> (app #t) <-)) (env ()))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ()))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> id <-) (app #t)) (env ()))
clos/con:
	'((letrec* (... do-something (id (-> (λ (y) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (app id (app #f)) <-)) (env ()))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app id (-> (app #f) <-)) (env ()))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ()))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> id <-) (app #f)) (env ()))
clos/con:
	'((letrec* (... do-something (id (-> (λ (y) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)
