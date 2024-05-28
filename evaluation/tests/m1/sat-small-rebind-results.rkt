'(expression:
  (letrec*
   ((phi (λ (x1 x2) (app or x1 (app not x2))))
    (try (λ (f) (app or (app f (app #t)) (app f (app #f)))))
    (sat-solve-2 (λ (p) (app try (λ (n1) (app try (λ (n2) (app p n1 n2))))))))
   (app sat-solve-2 phi)))

'(query:
  (app (-> f <-) (app #f))
  (env ((λ (n1) (-> (app try (λ (n2) ...)) <-)))))
clos/con:
	'((app try (-> (λ (n2) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
	'((app try (-> (λ (n2) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f <-) (app #f))
  (env ((λ (p) (-> (app try (λ (n1) ...)) <-)))))
clos/con:
	'((app try (-> (λ (n1) ...) <-))
  (env ((letrec* (phi ... sat-solve-2) (-> (app sat-solve-2 phi) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f <-) (app #t))
  (env ((λ (n1) (-> (app try (λ (n2) ...)) <-)))))
clos/con:
	'((app try (-> (λ (n2) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
	'((app try (-> (λ (n2) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f <-) (app #t))
  (env ((λ (p) (-> (app try (λ (n1) ...)) <-)))))
clos/con:
	'((app try (-> (λ (n1) ...) <-))
  (env ((letrec* (phi ... sat-solve-2) (-> (app sat-solve-2 phi) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> p <-) n1 n2)
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1 x2) ...) <-)) try ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> p <-) n1 n2)
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1 x2) ...) <-)) try ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f (-> (app #f) <-))
  (env ((λ (n1) (-> (app try (λ (n2) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f (-> (app #f) <-))
  (env ((λ (p) (-> (app try (λ (n1) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f (-> (app #t) <-))
  (env ((λ (n1) (-> (app try (λ (n2) ...)) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f (-> (app #t) <-))
  (env ((λ (p) (-> (app try (λ (n1) ...)) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (-> (app f (app #t)) <-) (app f (app #f)))
  (env ((λ (n1) (-> (app try (λ (n2) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (-> (app f (app #t)) <-) (app f (app #f)))
  (env ((λ (p) (-> (app try (λ (n1) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (-> x1 <-) (app not x2))
  (env ((λ (n2) (-> (app p n1 n2) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (app f (app #t)) (-> (app f (app #f)) <-))
  (env ((λ (n1) (-> (app try (λ (n2) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (app f (app #t)) (-> (app f (app #f)) <-))
  (env ((λ (p) (-> (app try (λ (n1) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or x1 (-> (app not x2) <-))
  (env ((λ (n2) (-> (app p n1 n2) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app p (-> n1 <-) n2)
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app p (-> n1 <-) n2)
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app p n1 (-> n2 <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app p n1 (-> n2 <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (phi ... sat-solve-2) (-> (app sat-solve-2 phi) <-))
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (f) (-> (app or (app f (app #t)) (app f (app #f))) <-))
  (env ((λ (n1) (-> (app try (λ (n2) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (f) (-> (app or (app f (app #t)) (app f (app #f))) <-))
  (env ((λ (p) (-> (app try (λ (n1) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (n1) (-> (app try (λ (n2) ...)) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (n1) (-> (app try (λ (n2) ...)) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (n2) (-> (app p n1 n2) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (n2) (-> (app p n1 n2) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (p) (-> (app try (λ (n1) ...)) <-))
  (env ((letrec* (phi ... sat-solve-2) (-> (app sat-solve-2 phi) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x1 x2) (-> (app or x1 (app not x2)) <-))
  (env ((λ (n2) (-> (app p n1 n2) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: ((top) letrec* (phi ... sat-solve-2) ...) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app not (-> x2 <-)) (env ((λ (n2) (-> (app p n1 n2) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  f
  (λ (f) (-> (app or (app f (app #t)) (app f (app #f))) <-))
  (env ((λ (n1) (-> (app try (λ (n2) ...)) <-)))))
clos/con:
	'((app try (-> (λ (n2) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
	'((app try (-> (λ (n2) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  f
  (λ (f) (-> (app or (app f (app #t)) (app f (app #f))) <-))
  (env ((λ (p) (-> (app try (λ (n1) ...)) <-)))))
clos/con:
	'((app try (-> (λ (n1) ...) <-))
  (env ((letrec* (phi ... sat-solve-2) (-> (app sat-solve-2 phi) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  n1
  (λ (n1) (-> (app try (λ (n2) ...)) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n1
  (λ (n1) (-> (app try (λ (n2) ...)) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n2
  (λ (n2) (-> (app p n1 n2) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n2
  (λ (n2) (-> (app p n1 n2) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  p
  (λ (p) (-> (app try (λ (n1) ...)) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1 x2) ...) <-)) try ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  p
  (λ (p) (-> (app try (λ (n1) ...)) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1 x2) ...) <-)) try ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  p
  (λ (p) (-> (app try (λ (n1) ...)) <-))
  (env ((letrec* (phi ... sat-solve-2) (-> (app sat-solve-2 phi) <-)))))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1 x2) ...) <-)) try ...) ...) (env ()))
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
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-2 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  try
  (letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-2 ...) ...)
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-2 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  try
  (letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-2 ...) ...)
  (env ((letrec* (phi ... sat-solve-2) (-> (app sat-solve-2 phi) <-)))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-2 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  try
  (letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-2 ...) ...)
  (env ()))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-2 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x1
  (λ (x1 x2) (-> (app or x1 (app not x2)) <-))
  (env ((λ (n2) (-> (app p n1 n2) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x2
  (λ (x1 x2) (-> (app or x1 (app not x2)) <-))
  (env ((λ (n2) (-> (app p n1 n2) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)
