'(expression:
  (letrec*
   ((do-something (λ () 10)) (id (λ (y) (let ((_ (app do-something))) y))))
   (let ((_ (app id (app #t)))) (app id (app #f)))))

'(query:
  (letrec* (... () (do-something (-> (λ () ...) <-)) id ...) ...)
  (env ()))
clos/con:
	'((letrec* (... () (do-something (-> (λ () ...) <-)) id ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... do-something (id (-> (λ (y) ...) <-)) () ...) ...)
  (env ()))
clos/con:
	'((letrec* (... do-something (id (-> (λ (y) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: ((top) letrec* (do-something ... id) ...) (env ()))
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

'(query: (app (-> do-something <-)) (env ()))
clos/con:
	'((letrec* (... () (do-something (-> (λ () ...) <-)) id ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> id <-) (app #f)) (env ()))
clos/con:
	'((letrec* (... do-something (id (-> (λ (y) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> id <-) (app #t)) (env ()))
clos/con:
	'((letrec* (... do-something (id (-> (λ (y) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app id (-> (app #f) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app id (-> (app #t) <-)) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (... () (_ (-> (app do-something) <-)) () ...) ...) (env ()))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query: (let (... () (_ (-> (app id (app #t)) <-)) () ...) ...) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (app id (app #f)) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> y <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (letrec* (do-something ... id) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ () (-> 10 <-)) (env ()))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query: (λ (y) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  _
  (letrec* (... do-something (id (-> (λ (y) ...) <-)) () ...) ...)
  (env ()))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(store:
  do-something
  (letrec* (... do-something (id (-> (λ (y) ...) <-)) () ...) ...)
  (env ()))
clos/con:
	'((letrec* (... () (do-something (-> (λ () ...) <-)) id ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  y
  (letrec* (... do-something (id (-> (λ (y) ...) <-)) () ...) ...)
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: _ ((top) letrec* (do-something ... id) ...) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: do-something ((top) letrec* (do-something ... id) ...) (env ()))
clos/con:
	'((letrec* (... () (do-something (-> (λ () ...) <-)) id ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: id ((top) letrec* (do-something ... id) ...) (env ()))
clos/con:
	'((letrec* (... do-something (id (-> (λ (y) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)
