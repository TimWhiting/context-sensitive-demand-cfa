'(expression:
  (letrec*
   ((do-something (λ () 10)) (id (λ (y) (let ((_ (app do-something))) y))))
   (let ((_ (app id (app #t)))) (app id (app #f)))))

'(query:
  (let (... () (_ (-> (app do-something) <-)) () ...) ...)
  (env ((let (... () (_ (-> (app id (app #t)) <-)) () ...) ...))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app do-something) <-)) () ...) ...)
  (env ((let (_) (-> (app id (app #f)) <-)))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query:
  (let (_) (-> y <-))
  (env ((let (... () (_ (-> (app id (app #t)) <-)) () ...) ...))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (y) (-> (let (_) ...) <-))
  (env ((let (... () (_ (-> (app id (app #t)) <-)) () ...) ...))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (y) (-> (let (_) ...) <-))
  (env ((let (_) (-> (app id (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: ((top) letrec* (do-something ... id) ...) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app id (-> (app #f) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app id (-> (app #t) <-)) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (... () (_ (-> (app id (app #t)) <-)) () ...) ...) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (app id (app #f)) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> y <-)) (env ((let (_) (-> (app id (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (letrec* (do-something ... id) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  _
  (let (... () (_ (-> (app do-something) <-)) () ...) ...)
  (env ((let (... () (_ (-> (app id (app #t)) <-)) () ...) ...))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(store:
  _
  (let (... () (_ (-> (app do-something) <-)) () ...) ...)
  (env ((let (_) (-> (app id (app #f)) <-)))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(store:
  do-something
  (letrec* (... () (do-something (-> (λ () ...) <-)) id ...) ...)
  (env ((let (... () (_ (-> (app id (app #t)) <-)) () ...) ...))))
clos/con:
	'((letrec* (... () (do-something (-> (λ () ...) <-)) id ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  do-something
  (letrec* (... () (do-something (-> (λ () ...) <-)) id ...) ...)
  (env ((let (_) (-> (app id (app #f)) <-)))))
clos/con:
	'((letrec* (... () (do-something (-> (λ () ...) <-)) id ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  do-something
  (letrec* (... () (do-something (-> (λ () ...) <-)) id ...) ...)
  (env ()))
clos/con:
	'((letrec* (... () (do-something (-> (λ () ...) <-)) id ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  id
  (letrec* (... do-something (id (-> (λ (y) ...) <-)) () ...) ...)
  (env ()))
clos/con:
	'((letrec* (... do-something (id (-> (λ (y) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  y
  (λ (y) (-> (let (_) ...) <-))
  (env ((let (... () (_ (-> (app id (app #t)) <-)) () ...) ...))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  y
  (λ (y) (-> (let (_) ...) <-))
  (env ((let (_) (-> (app id (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: _ (let (... () (_ (-> (app id (app #t)) <-)) () ...) ...) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)
