'(expression:
  (letrec*
   ((phi
     (λ (x1)
       (λ (x2)
         (λ (x3)
           (λ (x4)
             (λ (x5)
               (λ (x6)
                 (λ (x7)
                   (match
                    (match
                     x1
                     ((#f) (match x2 ((#f) (app #f)) (_ (app #t))))
                     (_ (app #t)))
                    ((#f) (app #f))
                    (_
                     (match
                      (match
                       x1
                       ((#f)
                        (match
                         (app not x2)
                         ((#f)
                          (match (app not x3) ((#f) (app #f)) (_ (app #t))))
                         (_ (app #t))))
                       (_ (app #t)))
                      ((#f) (app #f))
                      (_
                       (match
                        (match
                         x3
                         ((#f) (match x4 ((#f) (app #f)) (_ (app #t))))
                         (_ (app #t)))
                        ((#f) (app #f))
                        (_
                         (match
                          (match
                           (app not x4)
                           ((#f) (match x1 ((#f) (app #f)) (_ (app #t))))
                           (_ (app #t)))
                          ((#f) (app #f))
                          (_
                           (match
                            (match
                             (app not x2)
                             ((#f)
                              (match
                               (app not x3)
                               ((#f) (app #f))
                               (_ (app #t))))
                             (_ (app #t)))
                            ((#f) (app #f))
                            (_
                             (match
                              (match
                               x4
                               ((#f) (match x2 ((#f) (app #f)) (_ (app #t))))
                               (_ (app #t)))
                              ((#f) (app #f))
                              (_ (app #t)))))))))))))))))))))
    (try
     (λ (f)
       (match
        (app f (app #t))
        ((#f) (match (app f (app #f)) ((#f) (app #f)) (_ (app #t))))
        (_ (app #t)))))
    (sat-solve-7
     (λ (p)
       (app
        try
        (λ (n1)
          (app
           try
           (λ (n2)
             (app
              try
              (λ (n3)
                (app
                 try
                 (λ (n4)
                   (app
                    try
                    (λ (n5)
                      (app
                       try
                       (λ (n6)
                         (app
                          try
                          (λ (n7)
                            (app
                             (app
                              (app (app (app (app (app p n1) n2) n3) n4) n5)
                              n6)
                             n7))))))))))))))))))
   (app sat-solve-7 phi)))

'(query:
  (letrec* (phi ... sat-solve-7) (-> (app sat-solve-7 phi) <-))
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (match (app not x4) ...)
   (#f)
   (_ (-> (match (match (app not ...) ...) ...) <-)))
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app f (app #t)) ((#f) (-> (match (app f (app #f ...)) ...) <-)) _)
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app not x2) ((#f) (-> (match (app not x3) ...) <-)) _)
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app not x2) ((#f) (-> (match (app not x3) ...) <-)) _)
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (match (app not x2) ...) (#f) (_ (-> (match (match x4 ...) ...) <-)))
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (match x1 ...) (#f) (_ (-> (match (match x1 ...) ...) <-)))
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (match x1 ...) (#f) (_ (-> (match (match x3 ...) ...) <-)))
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (match x3 ...) (#f) (_ (-> (match (match (app not ...) ...) ...) <-)))
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: ((top) letrec* (phi ... sat-solve-7) ...) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> (app (app (app (...) ...) n3) n4) <-) n5) (env ()))
clos/con:
	'((λ (x4) (-> (λ (x5) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> (app (app (app (...) ...) n4) n5) <-) n6) (env ()))
clos/con:
	'((λ (x5) (-> (λ (x6) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> (app (app (app (...) ...) n5) n6) <-) n7) (env ()))
clos/con:
	'((λ (x6) (-> (λ (x7) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> (app (app (app p ...) n2) n3) <-) n4) (env ()))
clos/con:
	'((λ (x3) (-> (λ (x4) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> (app (app p n1) n2) <-) n3) (env ()))
clos/con:
	'((λ (x2) (-> (λ (x3) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> (app p n1) <-) n2) (env ()))
clos/con:
	'((λ (x1) (-> (λ (x2) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f <-) (app #f)) (env ()))
clos/con:
	'((app try (-> (λ (n1) ...) <-)) (env ()))
	'((app try (-> (λ (n2) ...) <-)) (env ()))
	'((app try (-> (λ (n3) ...) <-)) (env ()))
	'((app try (-> (λ (n4) ...) <-)) (env ()))
	'((app try (-> (λ (n5) ...) <-)) (env ()))
	'((app try (-> (λ (n6) ...) <-)) (env ()))
	'((app try (-> (λ (n7) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f <-) (app #t)) (env ()))
clos/con:
	'((app try (-> (λ (n1) ...) <-)) (env ()))
	'((app try (-> (λ (n2) ...) <-)) (env ()))
	'((app try (-> (λ (n3) ...) <-)) (env ()))
	'((app try (-> (λ (n4) ...) <-)) (env ()))
	'((app try (-> (λ (n5) ...) <-)) (env ()))
	'((app try (-> (λ (n6) ...) <-)) (env ()))
	'((app try (-> (λ (n7) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> p <-) n1) (env ()))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1) ...) <-)) try ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (app (app (app (...) ...) n3) n4) (-> n5 <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (app (app (app (...) ...) n4) n5) (-> n6 <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (app (app (app (...) ...) n5) n6) (-> n7 <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (app (app (app p ...) n2) n3) (-> n4 <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (app (app p n1) n2) (-> n3 <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (app p n1) (-> n2 <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
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

'(query: (app not (-> x4 <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app p (-> n1 <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app f (app #f)) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app f (app #t)) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app not x2) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app not x2) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app not x3) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app not x3) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app not x4) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (match (app not x2) ...) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (match (app not x4) ...) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (match x1 ...) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (match x1 ...) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (match x3 ...) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (match x4 ...) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> x1 <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> x1 <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> x1 <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> x2 <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> x2 <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> x3 <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> x4 <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> x4 <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app f (app #f)) (#f) (_ (-> (app #t) <-))) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app f (app #f)) ((#f) (-> (app #f) <-)) _) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app f (app #t)) (#f) (_ (-> (app #t) <-))) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app not x2) (#f) (_ (-> (app #t) <-))) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app not x2) (#f) (_ (-> (app #t) <-))) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app not x3) (#f) (_ (-> (app #t) <-))) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app not x3) (#f) (_ (-> (app #t) <-))) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app not x3) ((#f) (-> (app #f) <-)) _) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app not x3) ((#f) (-> (app #f) <-)) _) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app not x4) (#f) (_ (-> (app #t) <-))) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app not x4) ((#f) (-> (match x1 ...) <-)) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (match (app not x2) ...) ((#f) (-> (app #f) <-)) _) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (match (app not x4) ...) ((#f) (-> (app #f) <-)) _) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (match x1 ...) ((#f) (-> (app #f) <-)) _) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (match x1 ...) ((#f) (-> (app #f) <-)) _) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (match x3 ...) ((#f) (-> (app #f) <-)) _) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (match x4 ...) (#f) (_ (-> (app #t) <-))) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (match x4 ...) ((#f) (-> (app #f) <-)) _) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match x1 (#f) (_ (-> (app #t) <-))) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match x1 (#f) (_ (-> (app #t) <-))) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match x1 (#f) (_ (-> (app #t) <-))) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match x1 ((#f) (-> (app #f) <-)) _) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match x1 ((#f) (-> (match (app not x2) ...) <-)) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match x1 ((#f) (-> (match x2 ...) <-)) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match x2 (#f) (_ (-> (app #t) <-))) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match x2 (#f) (_ (-> (app #t) <-))) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match x2 ((#f) (-> (app #f) <-)) _) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match x2 ((#f) (-> (app #f) <-)) _) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match x3 (#f) (_ (-> (app #t) <-))) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match x3 ((#f) (-> (match x4 ...) <-)) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match x4 (#f) (_ (-> (app #t) <-))) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match x4 (#f) (_ (-> (app #t) <-))) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match x4 ((#f) (-> (app #f) <-)) _) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match x4 ((#f) (-> (match x2 ...) <-)) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (f) (-> (match (app f (app #t ...)) ...) <-)) (env ()))
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

'(query: (λ (n4) (-> (app try (λ (n5) ...)) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (n5) (-> (app try (λ (n6) ...)) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (n6) (-> (app try (λ (n7) ...)) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (n7) (-> (app (app (app (...) ...) n6) n7) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (p) (-> (app try (λ (n1) ...)) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (x7) (-> (match (match x1 ...) ...) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  phi
  (letrec* (... () (phi (-> (λ (x1) ...) <-)) try ...) ...)
  (env ()))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1) ...) <-)) try ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  sat-solve-7
  (letrec* (... try (sat-solve-7 (-> (λ (p) ...) <-)) () ...) ...)
  (env ()))
clos/con:
	'((letrec* (... try (sat-solve-7 (-> (λ (p) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  try
  (letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...)
  (env ()))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: f (λ (f) (-> (match (app f (app #t ...)) ...) <-)) (env ()))
clos/con:
	'((app try (-> (λ (n1) ...) <-)) (env ()))
	'((app try (-> (λ (n2) ...) <-)) (env ()))
	'((app try (-> (λ (n3) ...) <-)) (env ()))
	'((app try (-> (λ (n4) ...) <-)) (env ()))
	'((app try (-> (λ (n5) ...) <-)) (env ()))
	'((app try (-> (λ (n6) ...) <-)) (env ()))
	'((app try (-> (λ (n7) ...) <-)) (env ()))
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

'(store: n4 (λ (n4) (-> (app try (λ (n5) ...)) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: n5 (λ (n5) (-> (app try (λ (n6) ...)) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: n6 (λ (n6) (-> (app try (λ (n7) ...)) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: n7 (λ (n7) (-> (app (app (app (...) ...) n6) n7) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: p (λ (p) (-> (app try (λ (n1) ...)) <-)) (env ()))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1) ...) <-)) try ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: x1 (λ (x1) (-> (λ (x2) ...) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: x2 (λ (x2) (-> (λ (x3) ...) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: x3 (λ (x3) (-> (λ (x4) ...) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: x4 (λ (x4) (-> (λ (x5) ...) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: x5 (λ (x5) (-> (λ (x6) ...) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: x6 (λ (x6) (-> (λ (x7) ...) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: x7 (λ (x7) (-> (match (match x1 ...) ...) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)
