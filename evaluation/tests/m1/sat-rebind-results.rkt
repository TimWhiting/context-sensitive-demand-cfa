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
   (-> and <-)
   (app or x1 (app not x2) (app not x3))
   (app or (app not x2) (app not x3))
   (app or x4 x2))
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((prim and) (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   and
   (-> (app or x1 (app not x2) (app not x3)) <-)
   (app or (app not x2) (app not x3))
   (app or x4 x2))
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
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
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
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
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

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
  (env ((λ (n2) (-> (app try (λ (n3) ...)) <-)))))
clos/con:
	'((app try (-> (λ (n3) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
	'((app try (-> (λ (n3) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f <-) (app #f))
  (env ((λ (n3) (-> (app try (λ (n4) ...)) <-)))))
clos/con:
	'((app try (-> (λ (n4) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
	'((app try (-> (λ (n4) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f <-) (app #f))
  (env ((λ (p) (-> (app try (λ (n1) ...)) <-)))))
clos/con:
	'((app try (-> (λ (n1) ...) <-))
  (env ((letrec* (phi ... sat-solve-4) (-> (app sat-solve-4 phi) <-)))))
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
  (env ((λ (n2) (-> (app try (λ (n3) ...)) <-)))))
clos/con:
	'((app try (-> (λ (n3) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
	'((app try (-> (λ (n3) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f <-) (app #t))
  (env ((λ (n3) (-> (app try (λ (n4) ...)) <-)))))
clos/con:
	'((app try (-> (λ (n4) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
	'((app try (-> (λ (n4) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f <-) (app #t))
  (env ((λ (p) (-> (app try (λ (n1) ...)) <-)))))
clos/con:
	'((app try (-> (λ (n1) ...) <-))
  (env ((letrec* (phi ... sat-solve-4) (-> (app sat-solve-4 phi) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> or <-) (app f (app #t)) (app f (app #f)))
  (env ((λ (n1) (-> (app try (λ (n2) ...)) <-)))))
clos/con:
	'((prim or) (env ((λ (n1) (-> (app try (λ (n2) ...)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> or <-) (app f (app #t)) (app f (app #f)))
  (env ((λ (n2) (-> (app try (λ (n3) ...)) <-)))))
clos/con:
	'((prim or) (env ((λ (n2) (-> (app try (λ (n3) ...)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> or <-) (app f (app #t)) (app f (app #f)))
  (env ((λ (n3) (-> (app try (λ (n4) ...)) <-)))))
clos/con:
	'((prim or) (env ((λ (n3) (-> (app try (λ (n4) ...)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> or <-) (app f (app #t)) (app f (app #f)))
  (env ((λ (p) (-> (app try (λ (n1) ...)) <-)))))
clos/con:
	'((prim or) (env ((λ (p) (-> (app try (λ (n1) ...)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> or <-) (app not x2) (app not x3))
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((prim or) (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> or <-) x1 (app not x2) (app not x3))
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((prim or) (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> p <-) n1 n2 n3 n4)
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> p <-) n1 n2 n3 n4)
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> try <-) (λ (n1) ...))
  (env ((letrec* (phi ... sat-solve-4) (-> (app sat-solve-4 phi) <-)))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> try <-) (λ (n2) ...))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> try <-) (λ (n2) ...))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> try <-) (λ (n3) ...))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> try <-) (λ (n3) ...))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> try <-) (λ (n4) ...))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> try <-) (λ (n4) ...))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f (-> (app #f) <-))
  (env ((λ (n1) (-> (app try (λ (n2) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f (-> (app #f) <-))
  (env ((λ (n2) (-> (app try (λ (n3) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f (-> (app #f) <-))
  (env ((λ (n3) (-> (app try (λ (n4) ...)) <-)))))
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
  (env ((λ (n2) (-> (app try (λ (n3) ...)) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f (-> (app #t) <-))
  (env ((λ (n3) (-> (app try (λ (n4) ...)) <-)))))
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
  (env ((λ (n2) (-> (app try (λ (n3) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (-> (app f (app #t)) <-) (app f (app #f)))
  (env ((λ (n3) (-> (app try (λ (n4) ...)) <-)))))
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
  (app or (-> (app not x2) <-) (app not x3))
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (-> x1 <-) (app not x2) (app not x3))
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
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
  (env ((λ (n2) (-> (app try (λ (n3) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (app f (app #t)) (-> (app f (app #f)) <-))
  (env ((λ (n3) (-> (app try (λ (n4) ...)) <-)))))
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
  (app or (app not x2) (-> (app not x3) <-))
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or x1 (-> (app not x2) <-) (app not x3))
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or x1 (app not x2) (-> (app not x3) <-))
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app p (-> n1 <-) n2 n3 n4)
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app p (-> n1 <-) n2 n3 n4)
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app p n1 (-> n2 <-) n3 n4)
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app p n1 (-> n2 <-) n3 n4)
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app p n1 n2 (-> n3 <-) n4)
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app p n1 n2 (-> n3 <-) n4)
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app p n1 n2 n3 (-> n4 <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app p n1 n2 n3 (-> n4 <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app try (-> (λ (n1) ...) <-))
  (env ((letrec* (phi ... sat-solve-4) (-> (app sat-solve-4 phi) <-)))))
clos/con:
	'((app try (-> (λ (n1) ...) <-))
  (env ((letrec* (phi ... sat-solve-4) (-> (app sat-solve-4 phi) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app try (-> (λ (n2) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((app try (-> (λ (n2) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app try (-> (λ (n2) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((app try (-> (λ (n2) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app try (-> (λ (n3) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((app try (-> (λ (n3) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app try (-> (λ (n3) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((app try (-> (λ (n3) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app try (-> (λ (n4) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((app try (-> (λ (n4) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app try (-> (λ (n4) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((app try (-> (λ (n4) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... () (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...)
  (env ()))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...)
  (env ()))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... try (sat-solve-4 (-> (λ (p) ...) <-)) () ...) ...)
  (env ()))
clos/con:
	'((letrec* (... try (sat-solve-4 (-> (λ (p) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (phi ... sat-solve-4) (-> (app sat-solve-4 phi) <-))
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
  (env ((λ (n2) (-> (app try (λ (n3) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (f) (-> (app or (app f (app #t)) (app f (app #f))) <-))
  (env ((λ (n3) (-> (app try (λ (n4) ...)) <-)))))
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
  (λ (n2) (-> (app try (λ (n3) ...)) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (n2) (-> (app try (λ (n3) ...)) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (n3) (-> (app try (λ (n4) ...)) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (n3) (-> (app try (λ (n4) ...)) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (n4) (-> (app p n1 n2 n3 n4) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (n4) (-> (app p n1 n2 n3 n4) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (p) (-> (app try (λ (n1) ...)) <-))
  (env ((letrec* (phi ... sat-solve-4) (-> (app sat-solve-4 phi) <-)))))
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
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: ((top) letrec* (phi ... sat-solve-4) ...) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((λ (n1) (-> (app try (λ (n2) ...)) <-)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((λ (n2) (-> (app try (λ (n3) ...)) <-)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((λ (n3) (-> (app try (λ (n4) ...)) <-)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((λ (p) (-> (app try (λ (n1) ...)) <-)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ((λ (n1) (-> (app try (λ (n2) ...)) <-)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ((λ (n2) (-> (app try (λ (n3) ...)) <-)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ((λ (n3) (-> (app try (λ (n4) ...)) <-)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ((λ (p) (-> (app try (λ (n1) ...)) <-)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> not <-) x2) (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((prim not) (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> not <-) x2) (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((prim not) (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> not <-) x3) (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((prim not) (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> not <-) x3) (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((prim not) (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> or <-) x4 x2) (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((prim or) (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> sat-solve-4 <-) phi) (env ()))
clos/con:
	'((letrec* (... try (sat-solve-4 (-> (λ (p) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app not (-> x2 <-)) (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app not (-> x2 <-)) (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app not (-> x3 <-)) (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app not (-> x3 <-)) (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app or (-> x4 <-) x2) (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app or x4 (-> x2 <-)) (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app sat-solve-4 (-> phi <-)) (env ()))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  and
  (letrec* (... () (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...)
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((λ (x1 x2 x3 x4)
    (->
     (app
      and
      (app or x1 (app not x2) (app not x3))
      (app or (app not x2) (app not x3))
      (app or x4 x2))
     <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  f
  (letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...)
  (env ((λ (n1) (-> (app try (λ (n2) ...)) <-)))))
clos/con:
	'((app try (-> (λ (n2) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
	'((app try (-> (λ (n2) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  f
  (letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...)
  (env ((λ (n2) (-> (app try (λ (n3) ...)) <-)))))
clos/con:
	'((app try (-> (λ (n3) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
	'((app try (-> (λ (n3) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  f
  (letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...)
  (env ((λ (n3) (-> (app try (λ (n4) ...)) <-)))))
clos/con:
	'((app try (-> (λ (n4) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
	'((app try (-> (λ (n4) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  f
  (letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...)
  (env ((λ (p) (-> (app try (λ (n1) ...)) <-)))))
clos/con:
	'((app try (-> (λ (n1) ...) <-))
  (env ((letrec* (phi ... sat-solve-4) (-> (app sat-solve-4 phi) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  n1
  (app try (-> (λ (n1) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n1
  (app try (-> (λ (n1) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n1
  (app try (-> (λ (n2) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n1
  (app try (-> (λ (n2) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n1
  (app try (-> (λ (n3) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n1
  (app try (-> (λ (n3) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n1
  (app try (-> (λ (n4) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n1
  (app try (-> (λ (n4) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n2
  (app try (-> (λ (n2) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n2
  (app try (-> (λ (n2) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n2
  (app try (-> (λ (n3) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n2
  (app try (-> (λ (n3) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n2
  (app try (-> (λ (n4) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n2
  (app try (-> (λ (n4) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n3
  (app try (-> (λ (n3) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n3
  (app try (-> (λ (n3) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n3
  (app try (-> (λ (n4) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n3
  (app try (-> (λ (n4) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n4
  (app try (-> (λ (n4) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n4
  (app try (-> (λ (n4) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  not
  (letrec* (... () (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...)
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((λ (x1 x2 x3 x4)
    (->
     (app
      and
      (app or x1 (app not x2) (app not x3))
      (app or (app not x2) (app not x3))
      (app or x4 x2))
     <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  or
  (letrec* (... () (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...)
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((λ (x1 x2 x3 x4)
    (->
     (app
      and
      (app or x1 (app not x2) (app not x3))
      (app or (app not x2) (app not x3))
      (app or x4 x2))
     <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  or
  (letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...)
  (env ((λ (n1) (-> (app try (λ (n2) ...)) <-)))))
clos/con:
	'((λ (f) (-> (app or (app f (app #t)) (app f (app #f))) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  or
  (letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...)
  (env ((λ (n2) (-> (app try (λ (n3) ...)) <-)))))
clos/con:
	'((λ (f) (-> (app or (app f (app #t)) (app f (app #f))) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  or
  (letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...)
  (env ((λ (n3) (-> (app try (λ (n4) ...)) <-)))))
clos/con:
	'((λ (f) (-> (app or (app f (app #t)) (app f (app #f))) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  or
  (letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...)
  (env ((λ (p) (-> (app try (λ (n1) ...)) <-)))))
clos/con:
	'((λ (f) (-> (app or (app f (app #t)) (app f (app #f))) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  p
  (app try (-> (λ (n1) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  p
  (app try (-> (λ (n1) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  p
  (app try (-> (λ (n2) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  p
  (app try (-> (λ (n2) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  p
  (app try (-> (λ (n3) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  p
  (app try (-> (λ (n3) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  p
  (app try (-> (λ (n4) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  p
  (app try (-> (λ (n4) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  p
  (letrec* (... try (sat-solve-4 (-> (λ (p) ...) <-)) () ...) ...)
  (env ((letrec* (phi ... sat-solve-4) (-> (app sat-solve-4 phi) <-)))))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  try
  (app try (-> (λ (n1) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  try
  (app try (-> (λ (n1) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  try
  (app try (-> (λ (n2) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  try
  (app try (-> (λ (n2) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  try
  (app try (-> (λ (n3) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  try
  (app try (-> (λ (n3) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  try
  (letrec* (... try (sat-solve-4 (-> (λ (p) ...) <-)) () ...) ...)
  (env ((letrec* (phi ... sat-solve-4) (-> (app sat-solve-4 phi) <-)))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x1
  (letrec* (... () (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...)
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x2
  (letrec* (... () (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...)
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x3
  (letrec* (... () (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...)
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x4
  (letrec* (... () (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...)
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: phi ((top) letrec* (phi ... sat-solve-4) ...) (env ()))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: sat-solve-4 ((top) letrec* (phi ... sat-solve-4) ...) (env ()))
clos/con:
	'((letrec* (... try (sat-solve-4 (-> (λ (p) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: try ((top) letrec* (phi ... sat-solve-4) ...) (env ()))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)
