'(expression:
  (letrec*
   ((count1 (λ (count) (app set! count (app + count 1)))) (x 0))
   (app count1 x)))

'(query:
  (letrec* (... () (count1 (-> (λ (count) ...) <-)) x ...) ...)
  (env ()))
clos/con:
	'((letrec* (... () (count1 (-> (λ (count) ...) <-)) x ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: ((top) letrec* (count1 ... x) ...) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> + <-) count 1) (env ()))
clos/con:
	'((prim +) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> count1 <-) x) (env ()))
clos/con:
	'((letrec* (... () (count1 (-> (λ (count) ...) <-)) x ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app + (-> count <-) 1) (env ()))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query: (app + count (-> 1 <-)) (env ()))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app count1 (-> x <-)) (env ()))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query: (app set! count (-> (app + count 1) <-)) (env ()))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (letrec* (... count1 (x (-> 0 <-)) () ...) ...) (env ()))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query: (letrec* (count1 ... x) (-> (app count1 x) <-)) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (count) (-> (app set! count (app + count 1)) <-)) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  +
  (letrec* (... () (count1 (-> (λ (count) ...) <-)) x ...) ...)
  (env ()))
clos/con:
	'((λ (count) (-> (app set! count (app + count 1)) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  count
  (letrec* (... () (count1 (-> (λ (count) ...) <-)) x ...) ...)
  (env ()))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(store: count (app set! (-> count <-) (app + count 1)) (env ()))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(store: count1 ((top) letrec* (count1 ... x) ...) (env ()))
clos/con:
	'((letrec* (... () (count1 (-> (λ (count) ...) <-)) x ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: x ((top) letrec* (count1 ... x) ...) (env ()))
clos/con: ⊥
literals: '(0 ⊥ ⊥)
