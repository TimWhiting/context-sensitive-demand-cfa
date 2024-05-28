'(expression:
  (letrec*
   ((phi
     (λ (x1 x2 x3 x4)
       (match
        (match
         x1
         ((#f)
          (match
           (app not x2)
           ((#f) (match (app not x3) ((#f) (app #f)) (_ (app #t))))
           (_ (app #t))))
         (_ (app #t)))
        ((#f) (app #f))
        (_
         (match
          (match
           (app not x2)
           ((#f) (match (app not x3) ((#f) (app #f)) (_ (app #t))))
           (_ (app #t)))
          ((#f) (app #f))
          (_
           (match
            (match
             x4
             ((#f) (match x2 ((#f) (app #f)) (_ (app #t))))
             (_ (app #t)))
            ((#f) (app #f))
            (_ (app #t)))))))))
    (try
     (λ (f)
       (match
        (app f (app #t))
        ((#f) (match (app f (app #f)) ((#f) (app #f)) (_ (app #t))))
        (_ (app #t)))))
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

'(query: ((top) letrec* (phi ... sat-solve-4) ...) (env ()))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... try (sat-solve-4 (-> (λ (p) ...) <-)) () ...) ...)
  (env ()))
clos/con:
	'((letrec* (... try (sat-solve-4 (-> (λ (p) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (p) (-> (app try (λ (n1) ...)) <-)) (env ((□? (p)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app try (-> (λ (n1) ...) <-)) (env ((□? (p)))))
clos/con:
	'((app try (-> (λ (n1) ...) <-)) (env ((□? (p)))))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (n1) (-> (app try (λ (n2) ...)) <-)) (env ((□? (n1)) (□? (p)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app try (-> (λ (n2) ...) <-)) (env ((□? (n1)) (□? (p)))))
clos/con:
	'((app try (-> (λ (n2) ...) <-)) (env ((□? (n1)) (□? (p)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (n2) (-> (app try (λ (n3) ...)) <-))
  (env ((□? (n2)) (□? (n1)) (□? (p)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app try (-> (λ (n3) ...) <-)) (env ((□? (n2)) (□? (n1)) (□? (p)))))
clos/con:
	'((app try (-> (λ (n3) ...) <-)) (env ((□? (n2)) (□? (n1)) (□? (p)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (n3) (-> (app try (λ (n4) ...)) <-))
  (env ((□? (n3)) (□? (n2)) (□? (n1)) (□? (p)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app try (-> (λ (n4) ...) <-))
  (env ((□? (n3)) (□? (n2)) (□? (n1)) (□? (p)))))
clos/con:
	'((app try (-> (λ (n4) ...) <-))
  (env ((□? (n3)) (□? (n2)) (□? (n1)) (□? (p)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (n4) (-> (app p n1 n2 n3 n4) <-))
  (env ((□? (n4)) (□? (n3)) (□? (n2)) (□? (n1)) (□? (p)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app p n1 n2 n3 (-> n4 <-))
  (env ((□? (n4)) (□? (n3)) (□? (n2)) (□? (n1)) (□? (p)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app p n1 n2 (-> n3 <-) n4)
  (env ((□? (n4)) (□? (n3)) (□? (n2)) (□? (n1)) (□? (p)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app p n1 (-> n2 <-) n3 n4)
  (env ((□? (n4)) (□? (n3)) (□? (n2)) (□? (n1)) (□? (p)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app p (-> n1 <-) n2 n3 n4)
  (env ((□? (n4)) (□? (n3)) (□? (n2)) (□? (n1)) (□? (p)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> p <-) n1 n2 n3 n4)
  (env ((□? (n4)) (□? (n3)) (□? (n2)) (□? (n1)) (□? (p)))))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> try <-) (λ (n4) ...))
  (env ((□? (n3)) (□? (n2)) (□? (n1)) (□? (p)))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> try <-) (λ (n3) ...)) (env ((□? (n2)) (□? (n1)) (□? (p)))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> try <-) (λ (n2) ...)) (env ((□? (n1)) (□? (p)))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> try <-) (λ (n1) ...)) (env ((□? (p)))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...)
  (env ()))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (f) (-> (match (app f (app #t ...)) ...) <-)) (env ((□? (f)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app f (app #t)) (#f) (_ (-> (app #t) <-))) (env ((□? (f)))))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ((□? (f)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app f (app #t)) ((#f) (-> (match (app f (app #f ...)) ...) <-)) _)
  (env ((□? (f)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app f (app #f)) (#f) (_ (-> (app #t) <-))) (env ((□? (f)))))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ((□? (f)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app f (app #f)) ((#f) (-> (app #f) <-)) _) (env ((□? (f)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((□? (f)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app f (app #f)) <-) (#f) _) (env ((□? (f)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f (-> (app #f) <-)) (env ((□? (f)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((□? (f)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f <-) (app #f)) (env ((□? (f)))))
clos/con:
	'((app try (-> (λ (n1) ...) <-)) (env ((□? (p)))))
	'((app try (-> (λ (n2) ...) <-)) (env ((□? (n1)) (□? (p)))))
	'((app try (-> (λ (n3) ...) <-)) (env ((□? (n2)) (□? (n1)) (□? (p)))))
	'((app try (-> (λ (n4) ...) <-))
  (env ((□? (n3)) (□? (n2)) (□? (n1)) (□? (p)))))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app f (app #t)) <-) (#f) _) (env ((□? (f)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f (-> (app #t) <-)) (env ((□? (f)))))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ((□? (f)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f <-) (app #t)) (env ((□? (f)))))
clos/con:
	'((app try (-> (λ (n1) ...) <-)) (env ((□? (p)))))
	'((app try (-> (λ (n2) ...) <-)) (env ((□? (n1)) (□? (p)))))
	'((app try (-> (λ (n3) ...) <-)) (env ((□? (n2)) (□? (n1)) (□? (p)))))
	'((app try (-> (λ (n4) ...) <-))
  (env ((□? (n3)) (□? (n2)) (□? (n1)) (□? (p)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... () (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...)
  (env ()))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x1 x2 x3 x4) (-> (match (match x1 ...) ...) <-))
  (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (match x1 ...) (#f) (_ (-> (match (match (app not ...) ...) ...) <-)))
  (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (match (app not x2) ...) (#f) (_ (-> (match (match x4 ...) ...) <-)))
  (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (match x4 ...) (#f) (_ (-> (app #t) <-)))
  (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (match x4 ...) ((#f) (-> (app #f) <-)) _)
  (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (match x4 ...) <-) (#f) _) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match x4 (#f) (_ (-> (app #t) <-))) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match x4 ((#f) (-> (match x2 ...) <-)) _) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match x2 (#f) (_ (-> (app #t) <-))) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match x2 ((#f) (-> (app #f) <-)) _) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> x2 <-) (#f) _) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> x4 <-) (#f) _) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (match (app not x2) ...) ((#f) (-> (app #f) <-)) _)
  (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (match (app not x2) ...) <-) (#f) _)
  (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app not x2) (#f) (_ (-> (app #t) <-)))
  (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app not x2) ((#f) (-> (match (app not x3) ...) <-)) _)
  (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app not x3) (#f) (_ (-> (app #t) <-)))
  (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app not x3) ((#f) (-> (app #f) <-)) _)
  (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app not x3) <-) (#f) _) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app not (-> x3 <-)) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> not <-) x3) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'((prim not) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app not x2) <-) (#f) _) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app not (-> x2 <-)) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> not <-) x2) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'((prim not) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (match x1 ...) ((#f) (-> (app #f) <-)) _)
  (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (match x1 ...) <-) (#f) _) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match x1 (#f) (_ (-> (app #t) <-))) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match x1 ((#f) (-> (match (app not x2) ...) <-)) _)
  (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app not x2) (#f) (_ (-> (app #t) <-)))
  (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app not x2) ((#f) (-> (match (app not x3) ...) <-)) _)
  (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app not x3) (#f) (_ (-> (app #t) <-)))
  (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app not x3) ((#f) (-> (app #f) <-)) _)
  (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app not x3) <-) (#f) _) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app not (-> x3 <-)) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> not <-) x3) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'((prim not) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app not x2) <-) (#f) _) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app not (-> x2 <-)) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> not <-) x2) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'((prim not) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> x1 <-) (#f) _) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (phi ... sat-solve-4) (-> (app sat-solve-4 phi) <-))
  (env ()))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app sat-solve-4 (-> phi <-)) (env ()))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> sat-solve-4 <-) phi) (env ()))
clos/con:
	'((letrec* (... try (sat-solve-4 (-> (λ (p) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)
