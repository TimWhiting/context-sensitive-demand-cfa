'(expression:
  (app
   (λ (f1) (let ((_ (app f1 (app #t)))) (app f1 (app #f))))
   (λ (x1)
     (app
      (λ (f2) (let ((_ (app f2 (app #t)))) (app f2 (app #f))))
      (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)))))))

'(query: ((top) app (λ (f1) ...) (λ (x1) ...)) (env ()))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (λ (f1) ...) (-> (λ (x1) ...) <-)) (env ()))
clos/con:
	'((app (λ (f1) ...) (-> (λ (x1) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (λ (f2) ...) (-> (λ (x2) ...) <-)) (env (())))
clos/con:
	'((app (λ (f2) ...) (-> (λ (x2) ...) <-)) (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-)) (env (() ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (λ (z) ...) (-> (λ (y1 y2) ...) <-)) (env (() ())))
clos/con:
	'((app (λ (z) ...) (-> (λ (y1 y2) ...) <-)) (env (() ())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (y1 y2) (-> y1 <-)) (env (() () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> (λ (z) ...) <-) (λ (y1 y2) ...)) (env (() ())))
clos/con:
	'((app (-> (λ (z) ...) <-) (λ (y1 y2) ...)) (env (() ())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (z) (-> (app z x1 x2) <-)) (env (() () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app z x1 (-> x2 <-)) (env (() () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app z (-> x1 <-) x2) (env (() () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> z <-) x1 x2) (env (() () ())))
clos/con:
	'((app (λ (z) ...) (-> (λ (y1 y2) ...) <-)) (env (() ())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> (λ (f2) ...) <-) (λ (x2) ...)) (env (())))
clos/con:
	'((app (-> (λ (f2) ...) <-) (λ (x2) ...)) (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (f2) (-> (let (_) ...) <-)) (env (() ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (let (... () (_ (-> (app f2 (app #t)) <-)) () ...) ...) (env (() ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app f2 (-> (app #t) <-)) (env (() ())))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (() ())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> f2 <-) (app #t)) (env (() ())))
clos/con:
	'((app (λ (f2) ...) (-> (λ (x2) ...) <-)) (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (let (_) (-> (app f2 (app #f)) <-)) (env (() ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app f2 (-> (app #f) <-)) (env (() ())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (() ())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> f2 <-) (app #f)) (env (() ())))
clos/con:
	'((app (λ (f2) ...) (-> (λ (x2) ...) <-)) (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> (λ (f1) ...) <-) (λ (x1) ...)) (env ()))
clos/con:
	'((app (-> (λ (f1) ...) <-) (λ (x1) ...)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (f1) (-> (let (_) ...) <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (let (... () (_ (-> (app f1 (app #t)) <-)) () ...) ...) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app f1 (-> (app #t) <-)) (env (())))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> f1 <-) (app #t)) (env (())))
clos/con:
	'((app (λ (f1) ...) (-> (λ (x1) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (let (_) (-> (app f1 (app #f)) <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app f1 (-> (app #f) <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> f1 <-) (app #f)) (env (())))
clos/con:
	'((app (λ (f1) ...) (-> (λ (x1) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)
