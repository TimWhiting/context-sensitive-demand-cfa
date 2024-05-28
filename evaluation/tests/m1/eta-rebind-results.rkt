'(expression:
  (letrec*
   ((do-something (λ () 10)) (id (λ (y) (let ((_ (app do-something))) y))))
   (let ((_ (app (app id (λ (a) a)) (app #t))))
     (app (app id (λ (b) b)) (app #f)))))

'(query:
  (let (... () (_ (-> (app (app id (λ (a) ...)) (app #t)) <-)) () ...) ...)
  (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app do-something) <-)) () ...) ...)
  (env ((app (-> (app id (λ (a) ...)) <-) (app #t)))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app do-something) <-)) () ...) ...)
  (env ((app (-> (app id (λ (b) ...)) <-) (app #f)))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query:
  (let (_) (-> y <-))
  (env ((app (-> (app id (λ (a) ...)) <-) (app #t)))))
clos/con:
	'((app id (-> (λ (a) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (_) (-> y <-))
  (env ((app (-> (app id (λ (b) ...)) <-) (app #f)))))
clos/con:
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (a) (-> a <-))
  (env
   ((let (... () (_ (-> (app (app id (λ (a) ...)) (app #t)) <-)) () ...)
      ...))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (b) (-> b <-))
  (env ((let (_) (-> (app (app id (λ (b) ...)) (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (y) (-> (let (_) ...) <-))
  (env ((app (-> (app id (λ (a) ...)) <-) (app #t)))))
clos/con:
	'((app id (-> (λ (a) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (y) (-> (let (_) ...) <-))
  (env ((app (-> (app id (λ (b) ...)) <-) (app #f)))))
clos/con:
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: ((top) letrec* (do-something ... id) ...) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> (app id (λ (a) ...)) <-) (app #t)) (env ()))
clos/con:
	'((app id (-> (λ (a) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> (app id (λ (b) ...)) <-) (app #f)) (env ()))
clos/con:
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (app id (λ (a) ...)) (-> (app #t) <-)) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (app id (λ (b) ...)) (-> (app #f) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (app (app id (λ (b) ...)) (app #f)) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (letrec* (do-something ... id) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  _
  (let (... () (_ (-> (app (app id (λ (a) ...)) (app #t)) <-)) () ...) ...)
  (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  _
  (let (... () (_ (-> (app do-something) <-)) () ...) ...)
  (env ((app (-> (app id (λ (a) ...)) <-) (app #t)))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(store:
  _
  (let (... () (_ (-> (app do-something) <-)) () ...) ...)
  (env ((app (-> (app id (λ (b) ...)) <-) (app #f)))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(store:
  a
  (λ (a) (-> a <-))
  (env
   ((let (... () (_ (-> (app (app id (λ (a) ...)) (app #t)) <-)) () ...)
      ...))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  b
  (λ (b) (-> b <-))
  (env ((let (_) (-> (app (app id (λ (b) ...)) (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  do-something
  (letrec* (... () (do-something (-> (λ () ...) <-)) id ...) ...)
  (env ((app (-> (app id (λ (a) ...)) <-) (app #t)))))
clos/con:
	'((letrec* (... () (do-something (-> (λ () ...) <-)) id ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  do-something
  (letrec* (... () (do-something (-> (λ () ...) <-)) id ...) ...)
  (env ((app (-> (app id (λ (b) ...)) <-) (app #f)))))
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
  (env ((app (-> (app id (λ (a) ...)) <-) (app #t)))))
clos/con:
	'((app id (-> (λ (a) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  y
  (λ (y) (-> (let (_) ...) <-))
  (env ((app (-> (app id (λ (b) ...)) <-) (app #f)))))
clos/con:
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)
