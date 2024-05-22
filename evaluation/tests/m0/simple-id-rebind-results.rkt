'(expression:
  (let* ((id (λ (x) x)) (a (app id (λ (aa) aa))) (b (app id (λ (bb) bb)))) a))

'(query: ((top) let* (id ... b) ...) (env ()))
clos/con:
	'((app id (-> (λ (aa) ...) <-)) (env ()))
	'((app id (-> (λ (bb) ...) <-)) (env ()))
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
	'((app id (-> (λ (aa) ...) <-)) (env ()))
	'((app id (-> (λ (bb) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let* (... id (a (-> (app id (λ (aa) ...)) <-)) b ...) ...) (env ()))
clos/con:
	'((app id (-> (λ (aa) ...) <-)) (env ()))
	'((app id (-> (λ (bb) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let* (id ... b) (-> a <-)) (env ()))
clos/con:
	'((app id (-> (λ (aa) ...) <-)) (env ()))
	'((app id (-> (λ (bb) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (x) (-> x <-)) (env ()))
clos/con:
	'((app id (-> (λ (aa) ...) <-)) (env ()))
	'((app id (-> (λ (bb) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: a ((top) let* (id ... b) ...) (env ()))
clos/con:
	'((app id (-> (λ (aa) ...) <-)) (env ()))
	'((app id (-> (λ (bb) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: b ((top) let* (id ... b) ...) (env ()))
clos/con:
	'((app id (-> (λ (aa) ...) <-)) (env ()))
	'((app id (-> (λ (bb) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: id ((top) let* (id ... b) ...) (env ()))
clos/con:
	'((let* (... () (id (-> (λ (x) ...) <-)) a ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: x (let* (... () (id (-> (λ (x) ...) <-)) a ...) ...) (env ()))
clos/con:
	'((app id (-> (λ (aa) ...) <-)) (env ()))
	'((app id (-> (λ (bb) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)
