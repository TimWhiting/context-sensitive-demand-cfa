'(expression:
  (letrec*
   ((phi (λ (x1 x2) (app or x1 (app not x2))))
    (try (λ (f) (app or (app f (app #t)) (app f (app #f)))))
    (sat-solve-2 (λ (p) (app try (λ (n1) (app try (λ (n2) (app p n1 n2))))))))
   (app sat-solve-2 phi)))

'(query: (app f (-> (app #f) <-)) (env (())))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> not <-) x2) (env (())))
clos/con:
	#<procedure:do-not>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (n2) (-> (app p n1 n2) <-)) (env (() () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> or <-) x1 (app not x2)) (env (())))
clos/con:
	#<procedure:do-or>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app or (-> (app f (app #t)) <-) (app f (app #f))) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app try (-> (λ (n1) ...) <-)) (env (())))
clos/con:
	'((app try (-> (λ (n1) ...) <-)) (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec* (... try (sat-solve-2 (-> (λ (p) ...) <-)) () ...) ...)
  (env ()))
clos/con:
	'((letrec* (... try (sat-solve-2 (-> (λ (p) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec* (phi ... sat-solve-2) (-> (app sat-solve-2 phi) <-))
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (f) (-> (app or (app f (app #t)) (app f (app #f))) <-)) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (n1) (-> (app try (λ (n2) ...)) <-)) (env (() ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app p (-> n1 <-) n2) (env (() () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app or x1 (-> (app not x2) <-)) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> sat-solve-2 <-) phi) (env ()))
clos/con:
	'((letrec* (... try (sat-solve-2 (-> (λ (p) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> p <-) n1 n2) (env (() () ())))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1 x2) ...) <-)) try ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (x1 x2) (-> (app or x1 (app not x2)) <-)) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> try <-) (λ (n1) ...)) (env (())))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-2 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app or (app f (app #t)) (-> (app f (app #f)) <-)) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> f <-) (app #t)) (env (())))
clos/con:
	'((app try (-> (λ (n1) ...) <-)) (env (())))
	'((app try (-> (λ (n2) ...) <-)) (env (() ())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (letrec* (... () (phi (-> (λ (x1 x2) ...) <-)) try ...) ...) (env ()))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1 x2) ...) <-)) try ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> or <-) (app f (app #t)) (app f (app #f))) (env (())))
clos/con:
	#<procedure:do-or>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> f <-) (app #f)) (env (())))
clos/con:
	'((app try (-> (λ (n1) ...) <-)) (env (())))
	'((app try (-> (λ (n2) ...) <-)) (env (() ())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (p) (-> (app try (λ (n1) ...)) <-)) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app not (-> x2 <-)) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app p n1 (-> n2 <-)) (env (() () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app f (-> (app #t) <-)) (env (())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app try (-> (λ (n2) ...) <-)) (env (() ())))
clos/con:
	'((app try (-> (λ (n2) ...) <-)) (env (() ())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app or (-> x1 <-) (app not x2)) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-2 ...) ...)
  (env ()))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-2 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> try <-) (λ (n2) ...)) (env (() ())))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-2 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app sat-solve-2 (-> phi <-)) (env ()))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1 x2) ...) <-)) try ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: ((top) letrec* (phi ... sat-solve-2) ...) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: phi (env ()))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1 x2) ...) <-)) try ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: x1 (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: x2 (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: sat-solve-2 (env ()))
clos/con:
	'((letrec* (... try (sat-solve-2 (-> (λ (p) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: n2 (env (() () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: n1 (env (() ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: p (env (())))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1 x2) ...) <-)) try ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: try (env ()))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-2 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: f (env (())))
clos/con:
	'((app try (-> (λ (n1) ...) <-)) (env (())))
	'((app try (-> (λ (n2) ...) <-)) (env (() ())))
literals: '(⊥ ⊥ ⊥ ⊥)
