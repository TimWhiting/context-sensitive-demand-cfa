'(expression:
  (letrec*
   ((phi
     (λ (x1 x2 x3 x4)
       (app
        and
        (app or x1 (app not x2) (app not x3))
        (app or (app not x2) (app not x3))
        (app or x4 x2))))
    (try (λ (f) (app or (app f (app #t)) (app f (app #f)))))
    (sat-solve-4
     (λ (p)
       (app
        try
        (λ (n1)
          (app
           try
           (λ (n2)
             (app try (λ (n3) (app try (λ (n4) (app p n1 n2 n3 n4))))))))))))
   (app sat-solve-4 phi)))

'(query:
  (app
   and
   (-> (app or x1 (app not x2) (app not x3)) <-)
   (app or (app not x2) (app not x3))
   (app or x4 x2))
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   and
   (app or x1 (app not x2) (app not x3))
   (-> (app or (app not x2) (app not x3)) <-)
   (app or x4 x2))
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   and
   (app or x1 (app not x2) (app not x3))
   (app or (app not x2) (app not x3))
   (-> (app or x4 x2) <-))
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (phi ... sat-solve-4) (-> (app sat-solve-4 phi) <-))
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x1 x2 x3 x4)
    (->
     (app
      and
      (app or x1 (app not x2) (app not x3))
      (app or (app not x2) (app not x3))
      (app or x4 x2))
     <-))
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: ((top) letrec* (phi ... sat-solve-4) ...) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f <-) (app #f)) (env ()))
clos/con:
	'((app try (-> (λ (n1) ...) <-)) (env ()))
	'((app try (-> (λ (n2) ...) <-)) (env ()))
	'((app try (-> (λ (n3) ...) <-)) (env ()))
	'((app try (-> (λ (n4) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f <-) (app #t)) (env ()))
clos/con:
	'((app try (-> (λ (n1) ...) <-)) (env ()))
	'((app try (-> (λ (n2) ...) <-)) (env ()))
	'((app try (-> (λ (n3) ...) <-)) (env ()))
	'((app try (-> (λ (n4) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> p <-) n1 n2 n3 n4) (env ()))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f (-> (app #f) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f (-> (app #t) <-)) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app not (-> x2 <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app not (-> x2 <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app not (-> x3 <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app not (-> x3 <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app or (-> (app f (app #t)) <-) (app f (app #f))) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app or (-> (app not x2) <-) (app not x3)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app or (-> x1 <-) (app not x2) (app not x3)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app or (-> x4 <-) x2) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app or (app f (app #t)) (-> (app f (app #f)) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app or (app not x2) (-> (app not x3) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app or x1 (-> (app not x2) <-) (app not x3)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app or x1 (app not x2) (-> (app not x3) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app or x4 (-> x2 <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app p (-> n1 <-) n2 n3 n4) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app p n1 (-> n2 <-) n3 n4) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app p n1 n2 (-> n3 <-) n4) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app p n1 n2 n3 (-> n4 <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (f) (-> (app or (app f (app #t)) (app f (app #f))) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (n1) (-> (app try (λ (n2) ...)) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (n2) (-> (app try (λ (n3) ...)) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (n3) (-> (app try (λ (n4) ...)) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (n4) (-> (app p n1 n2 n3 n4) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (p) (-> (app try (λ (n1) ...)) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  phi
  (letrec* (... () (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...)
  (env ()))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  sat-solve-4
  (letrec* (... try (sat-solve-4 (-> (λ (p) ...) <-)) () ...) ...)
  (env ()))
clos/con:
	'((letrec* (... try (sat-solve-4 (-> (λ (p) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  try
  (letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...)
  (env ()))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x1
  (λ (x1 x2 x3 x4)
    (->
     (app
      and
      (app or x1 (app not x2) (app not x3))
      (app or (app not x2) (app not x3))
      (app or x4 x2))
     <-))
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x2
  (λ (x1 x2 x3 x4)
    (->
     (app
      and
      (app or x1 (app not x2) (app not x3))
      (app or (app not x2) (app not x3))
      (app or x4 x2))
     <-))
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x3
  (λ (x1 x2 x3 x4)
    (->
     (app
      and
      (app or x1 (app not x2) (app not x3))
      (app or (app not x2) (app not x3))
      (app or x4 x2))
     <-))
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x4
  (λ (x1 x2 x3 x4)
    (->
     (app
      and
      (app or x1 (app not x2) (app not x3))
      (app or (app not x2) (app not x3))
      (app or x4 x2))
     <-))
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: f (λ (f) (-> (app or (app f (app #t)) (app f (app #f))) <-)) (env ()))
clos/con:
	'((app try (-> (λ (n1) ...) <-)) (env ()))
	'((app try (-> (λ (n2) ...) <-)) (env ()))
	'((app try (-> (λ (n3) ...) <-)) (env ()))
	'((app try (-> (λ (n4) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: n1 (λ (n1) (-> (app try (λ (n2) ...)) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: n2 (λ (n2) (-> (app try (λ (n3) ...)) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: n3 (λ (n3) (-> (app try (λ (n4) ...)) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: n4 (λ (n4) (-> (app p n1 n2 n3 n4) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: p (λ (p) (-> (app try (λ (n1) ...)) <-)) (env ()))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)
