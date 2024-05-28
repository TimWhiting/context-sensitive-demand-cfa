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

'(query:
  (app (-> f <-) (app #f))
  (env ((λ (n1) (-> (app try (λ (n2) ...)) <-)))))
clos/con:
	'((app try (-> (λ (n2) ...) <-))
  (env ((match (-> (app f (app #f)) <-) (#f) _))))
	'((app try (-> (λ (n2) ...) <-))
  (env ((match (-> (app f (app #t)) <-) (#f) _))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f <-) (app #f))
  (env ((λ (n2) (-> (app try (λ (n3) ...)) <-)))))
clos/con:
	'((app try (-> (λ (n3) ...) <-))
  (env ((match (-> (app f (app #f)) <-) (#f) _))))
	'((app try (-> (λ (n3) ...) <-))
  (env ((match (-> (app f (app #t)) <-) (#f) _))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f <-) (app #f))
  (env ((λ (n3) (-> (app try (λ (n4) ...)) <-)))))
clos/con:
	'((app try (-> (λ (n4) ...) <-))
  (env ((match (-> (app f (app #f)) <-) (#f) _))))
	'((app try (-> (λ (n4) ...) <-))
  (env ((match (-> (app f (app #t)) <-) (#f) _))))
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
  (env ((match (-> (app f (app #f)) <-) (#f) _))))
	'((app try (-> (λ (n2) ...) <-))
  (env ((match (-> (app f (app #t)) <-) (#f) _))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f <-) (app #t))
  (env ((λ (n2) (-> (app try (λ (n3) ...)) <-)))))
clos/con:
	'((app try (-> (λ (n3) ...) <-))
  (env ((match (-> (app f (app #f)) <-) (#f) _))))
	'((app try (-> (λ (n3) ...) <-))
  (env ((match (-> (app f (app #t)) <-) (#f) _))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f <-) (app #t))
  (env ((λ (n3) (-> (app try (λ (n4) ...)) <-)))))
clos/con:
	'((app try (-> (λ (n4) ...) <-))
  (env ((match (-> (app f (app #f)) <-) (#f) _))))
	'((app try (-> (λ (n4) ...) <-))
  (env ((match (-> (app f (app #t)) <-) (#f) _))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f <-) (app #t))
  (env ((λ (p) (-> (app try (λ (n1) ...)) <-)))))
clos/con:
	'((app try (-> (λ (n1) ...) <-))
  (env ((letrec* (phi ... sat-solve-4) (-> (app sat-solve-4 phi) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> p <-) n1 n2 n3 n4)
  (env ((match (-> (app f (app #f)) <-) (#f) _))))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> p <-) n1 n2 n3 n4)
  (env ((match (-> (app f (app #t)) <-) (#f) _))))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...) (env ()))
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
  (app p (-> n1 <-) n2 n3 n4)
  (env ((match (-> (app f (app #f)) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app p (-> n1 <-) n2 n3 n4)
  (env ((match (-> (app f (app #t)) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app p n1 (-> n2 <-) n3 n4)
  (env ((match (-> (app f (app #f)) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app p n1 (-> n2 <-) n3 n4)
  (env ((match (-> (app f (app #t)) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app p n1 n2 (-> n3 <-) n4)
  (env ((match (-> (app f (app #f)) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app p n1 n2 (-> n3 <-) n4)
  (env ((match (-> (app f (app #t)) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app p n1 n2 n3 (-> n4 <-))
  (env ((match (-> (app f (app #f)) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app p n1 n2 n3 (-> n4 <-))
  (env ((match (-> (app f (app #t)) <-) (#f) _))))
clos/con:
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
  (match (-> (app f (app #f)) <-) (#f) _)
  (env ((λ (n1) (-> (app try (λ (n2) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app f (app #f)) <-) (#f) _)
  (env ((λ (n2) (-> (app try (λ (n3) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app f (app #f)) <-) (#f) _)
  (env ((λ (n3) (-> (app try (λ (n4) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app f (app #f)) <-) (#f) _)
  (env ((λ (p) (-> (app try (λ (n1) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app f (app #t)) <-) (#f) _)
  (env ((λ (n1) (-> (app try (λ (n2) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app f (app #t)) <-) (#f) _)
  (env ((λ (n2) (-> (app try (λ (n3) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app f (app #t)) <-) (#f) _)
  (env ((λ (n3) (-> (app try (λ (n4) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app f (app #t)) <-) (#f) _)
  (env ((λ (p) (-> (app try (λ (n1) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app not x2) <-) (#f) _)
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app not x2) <-) (#f) _)
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app not x3) <-) (#f) _)
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app not x3) <-) (#f) _)
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (match (app not x2) ...) <-) (#f) _)
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (match x1 ...) <-) (#f) _)
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (match x4 ...) <-) (#f) _)
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> x1 <-) (#f) _)
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> x2 <-) (#f) _)
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> x4 <-) (#f) _)
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app f (app #f)) (#f) (_ (-> (app #t) <-)))
  (env ((λ (n1) (-> (app try (λ (n2) ...)) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app f (app #f)) (#f) (_ (-> (app #t) <-)))
  (env ((λ (n2) (-> (app try (λ (n3) ...)) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app f (app #f)) (#f) (_ (-> (app #t) <-)))
  (env ((λ (n3) (-> (app try (λ (n4) ...)) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app f (app #f)) (#f) (_ (-> (app #t) <-)))
  (env ((λ (p) (-> (app try (λ (n1) ...)) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app f (app #f)) ((#f) (-> (app #f) <-)) _)
  (env ((λ (n1) (-> (app try (λ (n2) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app f (app #f)) ((#f) (-> (app #f) <-)) _)
  (env ((λ (n2) (-> (app try (λ (n3) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app f (app #f)) ((#f) (-> (app #f) <-)) _)
  (env ((λ (n3) (-> (app try (λ (n4) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app f (app #f)) ((#f) (-> (app #f) <-)) _)
  (env ((λ (p) (-> (app try (λ (n1) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app f (app #t)) (#f) (_ (-> (app #t) <-)))
  (env ((λ (n1) (-> (app try (λ (n2) ...)) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app f (app #t)) (#f) (_ (-> (app #t) <-)))
  (env ((λ (n2) (-> (app try (λ (n3) ...)) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app f (app #t)) (#f) (_ (-> (app #t) <-)))
  (env ((λ (n3) (-> (app try (λ (n4) ...)) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app f (app #t)) (#f) (_ (-> (app #t) <-)))
  (env ((λ (p) (-> (app try (λ (n1) ...)) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app f (app #t)) ((#f) (-> (match (app f (app #f ...)) ...) <-)) _)
  (env ((λ (n1) (-> (app try (λ (n2) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app f (app #t)) ((#f) (-> (match (app f (app #f ...)) ...) <-)) _)
  (env ((λ (n2) (-> (app try (λ (n3) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app f (app #t)) ((#f) (-> (match (app f (app #f ...)) ...) <-)) _)
  (env ((λ (n3) (-> (app try (λ (n4) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app f (app #t)) ((#f) (-> (match (app f (app #f ...)) ...) <-)) _)
  (env ((λ (p) (-> (app try (λ (n1) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app not x2) (#f) (_ (-> (app #t) <-)))
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app not x2) (#f) (_ (-> (app #t) <-)))
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app not x2) ((#f) (-> (match (app not x3) ...) <-)) _)
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app not x2) ((#f) (-> (match (app not x3) ...) <-)) _)
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app not x3) (#f) (_ (-> (app #t) <-)))
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app not x3) (#f) (_ (-> (app #t) <-)))
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app not x3) ((#f) (-> (app #f) <-)) _)
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app not x3) ((#f) (-> (app #f) <-)) _)
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (match (app not x2) ...) (#f) (_ (-> (match (match x4 ...) ...) <-)))
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (match (app not x2) ...) ((#f) (-> (app #f) <-)) _)
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (match x1 ...) (#f) (_ (-> (match (match (app not ...) ...) ...) <-)))
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (match x1 ...) ((#f) (-> (app #f) <-)) _)
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (match x4 ...) (#f) (_ (-> (app #t) <-)))
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (match x4 ...) ((#f) (-> (app #f) <-)) _)
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match x1 (#f) (_ (-> (app #t) <-)))
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match x1 ((#f) (-> (match (app not x2) ...) <-)) _)
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match x2 (#f) (_ (-> (app #t) <-)))
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match x2 ((#f) (-> (app #f) <-)) _)
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match x4 (#f) (_ (-> (app #t) <-)))
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match x4 ((#f) (-> (match x2 ...) <-)) _)
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (f) (-> (match (app f (app #t ...)) ...) <-))
  (env ((λ (n1) (-> (app try (λ (n2) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (f) (-> (match (app f (app #t ...)) ...) <-))
  (env ((λ (n2) (-> (app try (λ (n3) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (f) (-> (match (app f (app #t ...)) ...) <-))
  (env ((λ (n3) (-> (app try (λ (n4) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (f) (-> (match (app f (app #t ...)) ...) <-))
  (env ((λ (p) (-> (app try (λ (n1) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (n1) (-> (app try (λ (n2) ...)) <-))
  (env ((match (-> (app f (app #f)) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (n1) (-> (app try (λ (n2) ...)) <-))
  (env ((match (-> (app f (app #t)) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (n2) (-> (app try (λ (n3) ...)) <-))
  (env ((match (-> (app f (app #f)) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (n2) (-> (app try (λ (n3) ...)) <-))
  (env ((match (-> (app f (app #t)) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (n3) (-> (app try (λ (n4) ...)) <-))
  (env ((match (-> (app f (app #f)) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (n3) (-> (app try (λ (n4) ...)) <-))
  (env ((match (-> (app f (app #t)) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (n4) (-> (app p n1 n2 n3 n4) <-))
  (env ((match (-> (app f (app #f)) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (n4) (-> (app p n1 n2 n3 n4) <-))
  (env ((match (-> (app f (app #t)) <-) (#f) _))))
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
  (λ (x1 x2 x3 x4) (-> (match (match x1 ...) ...) <-))
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

'(store:
  f
  (λ (f) (-> (match (app f (app #t ...)) ...) <-))
  (env ((λ (n1) (-> (app try (λ (n2) ...)) <-)))))
clos/con:
	'((app try (-> (λ (n2) ...) <-))
  (env ((match (-> (app f (app #f)) <-) (#f) _))))
	'((app try (-> (λ (n2) ...) <-))
  (env ((match (-> (app f (app #t)) <-) (#f) _))))
literals: '(⊥ ⊥ ⊥)

'(store:
  f
  (λ (f) (-> (match (app f (app #t ...)) ...) <-))
  (env ((λ (n2) (-> (app try (λ (n3) ...)) <-)))))
clos/con:
	'((app try (-> (λ (n3) ...) <-))
  (env ((match (-> (app f (app #f)) <-) (#f) _))))
	'((app try (-> (λ (n3) ...) <-))
  (env ((match (-> (app f (app #t)) <-) (#f) _))))
literals: '(⊥ ⊥ ⊥)

'(store:
  f
  (λ (f) (-> (match (app f (app #t ...)) ...) <-))
  (env ((λ (n3) (-> (app try (λ (n4) ...)) <-)))))
clos/con:
	'((app try (-> (λ (n4) ...) <-))
  (env ((match (-> (app f (app #f)) <-) (#f) _))))
	'((app try (-> (λ (n4) ...) <-))
  (env ((match (-> (app f (app #t)) <-) (#f) _))))
literals: '(⊥ ⊥ ⊥)

'(store:
  f
  (λ (f) (-> (match (app f (app #t ...)) ...) <-))
  (env ((λ (p) (-> (app try (λ (n1) ...)) <-)))))
clos/con:
	'((app try (-> (λ (n1) ...) <-))
  (env ((letrec* (phi ... sat-solve-4) (-> (app sat-solve-4 phi) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  n1
  (λ (n1) (-> (app try (λ (n2) ...)) <-))
  (env ((match (-> (app f (app #f)) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n1
  (λ (n1) (-> (app try (λ (n2) ...)) <-))
  (env ((match (-> (app f (app #t)) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n2
  (λ (n2) (-> (app try (λ (n3) ...)) <-))
  (env ((match (-> (app f (app #f)) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n2
  (λ (n2) (-> (app try (λ (n3) ...)) <-))
  (env ((match (-> (app f (app #t)) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n3
  (λ (n3) (-> (app try (λ (n4) ...)) <-))
  (env ((match (-> (app f (app #f)) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n3
  (λ (n3) (-> (app try (λ (n4) ...)) <-))
  (env ((match (-> (app f (app #t)) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n4
  (λ (n4) (-> (app p n1 n2 n3 n4) <-))
  (env ((match (-> (app f (app #f)) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n4
  (λ (n4) (-> (app p n1 n2 n3 n4) <-))
  (env ((match (-> (app f (app #t)) <-) (#f) _))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  p
  (λ (p) (-> (app try (λ (n1) ...)) <-))
  (env ((letrec* (phi ... sat-solve-4) (-> (app sat-solve-4 phi) <-)))))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  p
  (λ (p) (-> (app try (λ (n1) ...)) <-))
  (env ((match (-> (app f (app #f)) <-) (#f) _))))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  p
  (λ (p) (-> (app try (λ (n1) ...)) <-))
  (env ((match (-> (app f (app #t)) <-) (#f) _))))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...) (env ()))
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
  (env ((letrec* (phi ... sat-solve-4) (-> (app sat-solve-4 phi) <-)))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  try
  (letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...)
  (env ((match (-> (app f (app #f)) <-) (#f) _))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  try
  (letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...)
  (env ((match (-> (app f (app #t)) <-) (#f) _))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
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
  (λ (x1 x2 x3 x4) (-> (match (match x1 ...) ...) <-))
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x2
  (λ (x1 x2 x3 x4) (-> (match (match x1 ...) ...) <-))
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x3
  (λ (x1 x2 x3 x4) (-> (match (match x1 ...) ...) <-))
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x4
  (λ (x1 x2 x3 x4) (-> (match (match x1 ...) ...) <-))
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)
