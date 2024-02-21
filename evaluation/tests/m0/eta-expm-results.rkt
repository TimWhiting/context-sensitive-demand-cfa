'(expression:
  (letrec ((do-something (λ () 10))
           (id (λ (y) (let ((_ (app do-something))) y))))
    (let ((_ (app (app id (λ (a) a)) (app #t))))
      (app (app id (λ (b) b)) (app #f)))))

'(query: (letrec (do-something ... id) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app id (-> (λ (a) ...) <-)) (env ()))
clos/con:
	'((app id (-> (λ (a) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app (app id (λ (a) ...)) (app #t)) <-)) () ...) ...)
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (let (... () (_ (-> (app do-something) <-)) () ...) ...) (env (())))
clos/con: ⊥
literals: '(10 ⊥ ⊥ ⊥)

'(query: (λ (b) (-> b <-)) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app id (-> (λ (b) ...) <-)) (env ()))
clos/con:
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec (... do-something (id (-> (λ (y) ...) <-)) () ...) ...)
  (env ()))
clos/con:
	'((letrec (... do-something (id (-> (λ (y) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec (... () (do-something (-> (λ () ...) <-)) id ...) ...)
  (env ()))
clos/con:
	'((letrec (... () (do-something (-> (λ () ...) <-)) id ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (y) (-> (let (_) ...) <-)) (env (())))
clos/con:
	'((app id (-> (λ (a) ...) <-)) (env ()))
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ () (-> 10 <-)) (env (())))
clos/con: ⊥
literals: '(10 ⊥ ⊥ ⊥)

'(query: (app (app id (λ (a) ...)) (-> (app #t) <-)) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> (app id (λ (b) ...)) <-) (app #f)) (env ()))
clos/con:
	'((app id (-> (λ (a) ...) <-)) (env ()))
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> id <-) (λ (b) ...)) (env ()))
clos/con:
	'((letrec (... do-something (id (-> (λ (y) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (app id (λ (b) ...)) (-> (app #f) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (let (_) (-> y <-)) (env (())))
clos/con:
	'((app id (-> (λ (a) ...) <-)) (env ()))
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> (app id (λ (a) ...)) <-) (app #t)) (env ()))
clos/con:
	'((app id (-> (λ (a) ...) <-)) (env ()))
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> id <-) (λ (a) ...)) (env ()))
clos/con:
	'((letrec (... do-something (id (-> (λ (y) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (let (_) (-> (app (app id (λ (b) ...)) (app #f)) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> do-something <-)) (env (())))
clos/con:
	'((letrec (... () (do-something (-> (λ () ...) <-)) id ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ()))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ()))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (a) (-> a <-)) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: ((top) letrec (do-something ... id) ...) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: a (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: id (env ()))
clos/con:
	'((letrec (... do-something (id (-> (λ (y) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: y (env (())))
clos/con:
	'((app id (-> (λ (a) ...) <-)) (env ()))
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: b (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: _ (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: do-something (env ()))
clos/con:
	'((letrec (... () (do-something (-> (λ () ...) <-)) id ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: _ (env (())))
clos/con: ⊥
literals: '(10 ⊥ ⊥ ⊥)
