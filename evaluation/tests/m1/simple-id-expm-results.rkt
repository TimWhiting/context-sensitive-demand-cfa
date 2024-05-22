'(expression:
  (let* ((id (λ (x) x)) (a (app id (λ (aa) aa))) (b (app id (λ (bb) bb)))) a))

'(query:
  (λ (x) (-> x <-))
  (env (((let* (... a (b (-> (app id (λ (bb) ...)) <-)) () ...) ...)))))
clos/con:
	'((app id (-> (λ (bb) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x) (-> x <-))
  (env (((let* (... id (a (-> (app id (λ (aa) ...)) <-)) b ...) ...)))))
clos/con:
	'((app id (-> (λ (aa) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: ((top) let* (id ... b) ...) (env ()))
clos/con:
	'((app id (-> (λ (aa) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> id <-) (λ (aa) ...)) (env ()))
clos/con:
	'((let* (... () (id (-> (λ (x) ...) <-)) a ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> id <-) (λ (bb) ...)) (env ()))
clos/con:
	'((let* (... () (id (-> (λ (x) ...) <-)) a ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app id (-> (λ (aa) ...) <-)) (env ()))
clos/con:
	'((app id (-> (λ (aa) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app id (-> (λ (bb) ...) <-)) (env ()))
clos/con:
	'((app id (-> (λ (bb) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let* (... () (id (-> (λ (x) ...) <-)) a ...) ...) (env ()))
clos/con:
	'((let* (... () (id (-> (λ (x) ...) <-)) a ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let* (... a (b (-> (app id (λ (bb) ...)) <-)) () ...) ...) (env ()))
clos/con:
	'((app id (-> (λ (bb) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let* (... id (a (-> (app id (λ (aa) ...)) <-)) b ...) ...) (env ()))
clos/con:
	'((app id (-> (λ (aa) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let* (id ... b) (-> a <-)) (env ()))
clos/con:
	'((app id (-> (λ (aa) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  a
  (let* (... id (a (-> (app id (λ (aa) ...)) <-)) b ...) ...)
  (env ()))
clos/con:
	'((app id (-> (λ (aa) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  b
  (let* (... a (b (-> (app id (λ (bb) ...)) <-)) () ...) ...)
  (env ()))
clos/con:
	'((app id (-> (λ (bb) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x
  (λ (x) (-> x <-))
  (env (((let* (... a (b (-> (app id (λ (bb) ...)) <-)) () ...) ...)))))
clos/con:
	'((app id (-> (λ (bb) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x
  (λ (x) (-> x <-))
  (env (((let* (... id (a (-> (app id (λ (aa) ...)) <-)) b ...) ...)))))
clos/con:
	'((app id (-> (λ (aa) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: id (let* (... () (id (-> (λ (x) ...) <-)) a ...) ...) (env ()))
clos/con:
	'((let* (... () (id (-> (λ (x) ...) <-)) a ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)
