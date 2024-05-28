'(expression:
  (letrec*
   ((phi
     (λ (x1 x2)
       (match
        x1
        ((#f) (match (app not x2) ((#f) (app #f)) (_ (app #t))))
        (_ (app #t)))))
    (try
     (λ (f)
       (match
        (app f (app #t))
        ((#f) (match (app f (app #f)) ((#f) (app #f)) (_ (app #t))))
        (_ (app #t)))))
    (sat-solve-2 (λ (p) (app try (λ (n1) (app try (λ (n2) (app p n1 n2))))))))
   (app sat-solve-2 phi)))

'(query:
  (letrec* (phi ... sat-solve-2) (-> (app sat-solve-2 phi) <-))
  (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: ((top) letrec* (phi ... sat-solve-2) ...) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f <-) (app #t)) (env (())))
clos/con:
	'((app try (-> (λ (n1) ...) <-)) (env (())))
	'((app try (-> (λ (n2) ...) <-)) (env (() ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> p <-) n1 n2) (env (() () ())))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1 x2) ...) <-)) try ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f (-> (app #t) <-)) (env (())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app p (-> n1 <-) n2) (env (() () ())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app p n1 (-> n2 <-)) (env (() () ())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app f (app #t)) <-) (#f) _) (env (())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> x1 <-) (#f) _) (env (())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app f (app #t)) (#f) (_ (-> (app #t) <-))) (env (())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match x1 (#f) (_ (-> (app #t) <-))) (env (())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (f) (-> (match (app f (app #t ...)) ...) <-)) (env (())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (n1) (-> (app try (λ (n2) ...)) <-)) (env (() ())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (n2) (-> (app p n1 n2) <-)) (env (() () ())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (p) (-> (app try (λ (n1) ...)) <-)) (env (())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (x1 x2) (-> (match x1 ...) <-)) (env (())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  phi
  (letrec* (... () (phi (-> (λ (x1 x2) ...) <-)) try ...) ...)
  (env ()))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1 x2) ...) <-)) try ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  sat-solve-2
  (letrec* (... try (sat-solve-2 (-> (λ (p) ...) <-)) () ...) ...)
  (env ()))
clos/con:
	'((letrec* (... try (sat-solve-2 (-> (λ (p) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  try
  (letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-2 ...) ...)
  (env ()))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-2 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: f (λ (f) (-> (match (app f (app #t ...)) ...) <-)) (env (())))
clos/con:
	'((app try (-> (λ (n1) ...) <-)) (env (())))
	'((app try (-> (λ (n2) ...) <-)) (env (() ())))
literals: '(⊥ ⊥ ⊥)

'(store: n1 (λ (n1) (-> (app try (λ (n2) ...)) <-)) (env (() ())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: n2 (λ (n2) (-> (app p n1 n2) <-)) (env (() () ())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: p (λ (p) (-> (app try (λ (n1) ...)) <-)) (env (())))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1 x2) ...) <-)) try ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: x1 (λ (x1 x2) (-> (match x1 ...) <-)) (env (())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: x2 (λ (x1 x2) (-> (match x1 ...) <-)) (env (())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)
