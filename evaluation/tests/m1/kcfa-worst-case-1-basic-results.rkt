'(expression:
  (app
   (λ (f1) (let ((_ (app f1 (app #t)))) (app f1 (app #f))))
   (λ (x1) (app (λ (z) (app z x1)) (λ (y1) y1)))))

'(query: ((top) app (λ (f1) ...) (λ (x1) ...)) (env ()))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (λ (f1) ...) (-> (λ (x1) ...) <-)) (env ()))
clos/con:
	'((app (λ (f1) ...) (-> (λ (x1) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (x1) (-> (app (λ (z) ...) (λ (y1) ...)) <-)) (env ((□? (x1)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (λ (z) ...) (-> (λ (y1) ...) <-)) (env ((□? (x1)))))
clos/con:
	'((app (λ (z) ...) (-> (λ (y1) ...) <-)) (env ((□? (x1)))))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (y1) (-> y1 <-)) (env ((□? (y1)) (□? (x1)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> (λ (z) ...) <-) (λ (y1) ...)) (env ((□? (x1)))))
clos/con:
	'((app (-> (λ (z) ...) <-) (λ (y1) ...)) (env ((□? (x1)))))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (z) (-> (app z x1) <-)) (env ((□? (z)) (□? (x1)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app z (-> x1 <-)) (env ((□? (z)) (□? (x1)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> z <-) x1) (env ((□? (z)) (□? (x1)))))
clos/con:
	'((app (λ (z) ...) (-> (λ (y1) ...) <-)) (env ((□? (x1)))))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> (λ (f1) ...) <-) (λ (x1) ...)) (env ()))
clos/con:
	'((app (-> (λ (f1) ...) <-) (λ (x1) ...)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (f1) (-> (let (_) ...) <-)) (env ((□? (f1)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app f1 (app #t)) <-)) () ...) ...)
  (env ((□? (f1)))))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f1 (-> (app #t) <-)) (env ((□? (f1)))))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ((□? (f1)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f1 <-) (app #t)) (env ((□? (f1)))))
clos/con:
	'((app (λ (f1) ...) (-> (λ (x1) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (app f1 (app #f)) <-)) (env ((□? (f1)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f1 (-> (app #f) <-)) (env ((□? (f1)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((□? (f1)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f1 <-) (app #f)) (env ((□? (f1)))))
clos/con:
	'((app (λ (f1) ...) (-> (λ (x1) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)
