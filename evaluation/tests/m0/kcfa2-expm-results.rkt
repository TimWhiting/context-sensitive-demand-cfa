'(expression:
  (app
   (λ (f1) (let ((a (app f1 (app #t)))) (app f1 (app #f))))
   (λ (x1)
     (app
      (λ (f2)
        (let ((b (app f2 (app #t))))
          (let ((c (app f2 (app #f)))) (app f2 (app #t)))))
      (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)))))))

'(query: ((top) app (λ (f1) ...) (λ (x1) ...)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (() ())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (() ())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (() ())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> (λ (f1) ...) <-) (λ (x1) ...)) (env ()))
clos/con:
	'((app (-> (λ (f1) ...) <-) (λ (x1) ...)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> (λ (f2) ...) <-) (λ (x2) ...)) (env (())))
clos/con:
	'((app (-> (λ (f2) ...) <-) (λ (x2) ...)) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> (λ (z) ...) <-) (λ (y1 y2) ...)) (env (() ())))
clos/con:
	'((app (-> (λ (z) ...) <-) (λ (y1 y2) ...)) (env (() ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f1 <-) (app #f)) (env (())))
clos/con:
	'((app (λ (f1) ...) (-> (λ (x1) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f1 <-) (app #t)) (env (())))
clos/con:
	'((app (λ (f1) ...) (-> (λ (x1) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f2 <-) (app #f)) (env (() ())))
clos/con:
	'((app (λ (f2) ...) (-> (λ (x2) ...) <-)) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f2 <-) (app #t)) (env (() ())))
clos/con:
	'((app (λ (f2) ...) (-> (λ (x2) ...) <-)) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f2 <-) (app #t)) (env (() ())))
clos/con:
	'((app (λ (f2) ...) (-> (λ (x2) ...) <-)) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> z <-) x1 x2) (env (() () ())))
clos/con:
	'((app (λ (z) ...) (-> (λ (y1 y2) ...) <-)) (env (() ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (λ (f1) ...) (-> (λ (x1) ...) <-)) (env ()))
clos/con:
	'((app (λ (f1) ...) (-> (λ (x1) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (λ (f2) ...) (-> (λ (x2) ...) <-)) (env (())))
clos/con:
	'((app (λ (f2) ...) (-> (λ (x2) ...) <-)) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (λ (z) ...) (-> (λ (y1 y2) ...) <-)) (env (() ())))
clos/con:
	'((app (λ (z) ...) (-> (λ (y1 y2) ...) <-)) (env (() ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app f1 (-> (app #f) <-)) (env (())))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f1 (-> (app #t) <-)) (env (())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f2 (-> (app #f) <-)) (env (() ())))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f2 (-> (app #t) <-)) (env (() ())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f2 (-> (app #t) <-)) (env (() ())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app z (-> x1 <-) x2) (env (() () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app z x1 (-> x2 <-)) (env (() () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...) (env (() ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (... () (c (-> (app f2 (app #f)) <-)) () ...) ...) (env (() ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (a) (-> (app f1 (app #f)) <-)) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (b) (-> (let (c) ...) <-)) (env (() ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (c) (-> (app f2 (app #t)) <-)) (env (() ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (f1) (-> (let (a) ...) <-)) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (f2) (-> (let (b) ...) <-)) (env (() ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-)) (env (() ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (y1 y2) (-> y1 <-)) (env (() () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (z) (-> (app z x1 x2) <-)) (env (() () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  b
  (let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...)
  (env (() ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c
  (let (... () (c (-> (app f2 (app #f)) <-)) () ...) ...)
  (env (() ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: a (let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: f1 (λ (f1) (-> (let (a) ...) <-)) (env (())))
clos/con:
	'((app (λ (f1) ...) (-> (λ (x1) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: f2 (λ (f2) (-> (let (b) ...) <-)) (env (() ())))
clos/con:
	'((app (λ (f2) ...) (-> (λ (x2) ...) <-)) (env (())))
literals: '(⊥ ⊥ ⊥)

'(store: x1 (λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: x2 (λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-)) (env (() ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: y1 (λ (y1 y2) (-> y1 <-)) (env (() () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: y2 (λ (y1 y2) (-> y1 <-)) (env (() () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: z (λ (z) (-> (app z x1 x2) <-)) (env (() () ())))
clos/con:
	'((app (λ (z) ...) (-> (λ (y1 y2) ...) <-)) (env (() ())))
literals: '(⊥ ⊥ ⊥)
