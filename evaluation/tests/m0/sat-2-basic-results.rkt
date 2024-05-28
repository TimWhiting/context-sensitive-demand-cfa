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
                   (app
                    and
                    (app or x1 x2)
                    (app or x1 (app not x2) (app not x3))
                    (app or x3 x4)
                    (app or (app not x4) x1)
                    (app or (app not x2) (app not x3))
                    (app or x4 x2))))))))))
    (try (λ (f) (app or (app f (app #t)) (app f (app #f)))))
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

'(query: ((top) letrec* (phi ... sat-solve-7) ...) (env ()))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... try (sat-solve-7 (-> (λ (p) ...) <-)) () ...) ...)
  (env ()))
clos/con:
	'((letrec* (... try (sat-solve-7 (-> (λ (p) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (p) (-> (app try (λ (n1) ...)) <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app try (-> (λ (n1) ...) <-)) (env (())))
clos/con:
	'((app try (-> (λ (n1) ...) <-)) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (n1) (-> (app try (λ (n2) ...)) <-)) (env (() ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app try (-> (λ (n2) ...) <-)) (env (() ())))
clos/con:
	'((app try (-> (λ (n2) ...) <-)) (env (() ())))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (n2) (-> (app try (λ (n3) ...)) <-)) (env (() () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app try (-> (λ (n3) ...) <-)) (env (() () ())))
clos/con:
	'((app try (-> (λ (n3) ...) <-)) (env (() () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (n3) (-> (app try (λ (n4) ...)) <-)) (env (() () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app try (-> (λ (n4) ...) <-)) (env (() () () ())))
clos/con:
	'((app try (-> (λ (n4) ...) <-)) (env (() () () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (n4) (-> (app try (λ (n5) ...)) <-)) (env (() () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app try (-> (λ (n5) ...) <-)) (env (() () () () ())))
clos/con:
	'((app try (-> (λ (n5) ...) <-)) (env (() () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (n5) (-> (app try (λ (n6) ...)) <-)) (env (() () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app try (-> (λ (n6) ...) <-)) (env (() () () () () ())))
clos/con:
	'((app try (-> (λ (n6) ...) <-)) (env (() () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (n6) (-> (app try (λ (n7) ...)) <-)) (env (() () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app try (-> (λ (n7) ...) <-)) (env (() () () () () () ())))
clos/con:
	'((app try (-> (λ (n7) ...) <-)) (env (() () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (n7)
    (-> (app (app (app (app (app (app (app p n1) n2) n3) n4) n5) n6) n7) <-))
  (env (() () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (app (app (app (app (app (app p n1) n2) n3) n4) n5) n6) (-> n7 <-))
  (env (() () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> (app (app (app (app (app (app p n1) n2) n3) n4) n5) n6) <-) n7)
  (env (() () () () () () () ())))
clos/con:
	'((λ (x6) (-> (λ (x7) ...) <-)) (env (() () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (app (app (app (app (app p n1) n2) n3) n4) n5) (-> n6 <-))
  (env (() () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> (app (app (app (app (app p n1) n2) n3) n4) n5) <-) n6)
  (env (() () () () () () () ())))
clos/con:
	'((λ (x5) (-> (λ (x6) ...) <-)) (env (() () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (app (app (app (app p n1) n2) n3) n4) (-> n5 <-))
  (env (() () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> (app (app (app (app p n1) n2) n3) n4) <-) n5)
  (env (() () () () () () () ())))
clos/con:
	'((λ (x4) (-> (λ (x5) ...) <-)) (env (() () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (app (app (app p n1) n2) n3) (-> n4 <-))
  (env (() () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> (app (app (app p n1) n2) n3) <-) n4)
  (env (() () () () () () () ())))
clos/con:
	'((λ (x3) (-> (λ (x4) ...) <-)) (env (() () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (app (app p n1) n2) (-> n3 <-)) (env (() () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> (app (app p n1) n2) <-) n3) (env (() () () () () () () ())))
clos/con:
	'((λ (x2) (-> (λ (x3) ...) <-)) (env (() ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (app p n1) (-> n2 <-)) (env (() () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> (app p n1) <-) n2) (env (() () () () () () () ())))
clos/con:
	'((λ (x1) (-> (λ (x2) ...) <-)) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app p (-> n1 <-)) (env (() () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> p <-) n1) (env (() () () () () () () ())))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1) ...) <-)) try ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> try <-) (λ (n7) ...)) (env (() () () () () () ())))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> try <-) (λ (n6) ...)) (env (() () () () () ())))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> try <-) (λ (n5) ...)) (env (() () () () ())))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> try <-) (λ (n4) ...)) (env (() () () ())))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> try <-) (λ (n3) ...)) (env (() () ())))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> try <-) (λ (n2) ...)) (env (() ())))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> try <-) (λ (n1) ...)) (env (())))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...)
  (env ()))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (f) (-> (app or (app f (app #t)) (app f (app #f))) <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app or (app f (app #t)) (-> (app f (app #f)) <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f (-> (app #f) <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f <-) (app #f)) (env (())))
clos/con:
	'((app try (-> (λ (n1) ...) <-)) (env (())))
	'((app try (-> (λ (n2) ...) <-)) (env (() ())))
	'((app try (-> (λ (n3) ...) <-)) (env (() () ())))
	'((app try (-> (λ (n4) ...) <-)) (env (() () () ())))
	'((app try (-> (λ (n5) ...) <-)) (env (() () () () ())))
	'((app try (-> (λ (n6) ...) <-)) (env (() () () () () ())))
	'((app try (-> (λ (n7) ...) <-)) (env (() () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app or (-> (app f (app #t)) <-) (app f (app #f))) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f (-> (app #t) <-)) (env (())))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f <-) (app #t)) (env (())))
clos/con:
	'((app try (-> (λ (n1) ...) <-)) (env (())))
	'((app try (-> (λ (n2) ...) <-)) (env (() ())))
	'((app try (-> (λ (n3) ...) <-)) (env (() () ())))
	'((app try (-> (λ (n4) ...) <-)) (env (() () () ())))
	'((app try (-> (λ (n5) ...) <-)) (env (() () () () ())))
	'((app try (-> (λ (n6) ...) <-)) (env (() () () () () ())))
	'((app try (-> (λ (n7) ...) <-)) (env (() () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> or <-) (app f (app #t)) (app f (app #f))) (env (())))
clos/con:
	'((prim or) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (letrec* (... () (phi (-> (λ (x1) ...) <-)) try ...) ...) (env ()))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1) ...) <-)) try ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (x1) (-> (λ (x2) ...) <-)) (env (())))
clos/con:
	'((λ (x1) (-> (λ (x2) ...) <-)) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (x2) (-> (λ (x3) ...) <-)) (env (() ())))
clos/con:
	'((λ (x2) (-> (λ (x3) ...) <-)) (env (() ())))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (x3) (-> (λ (x4) ...) <-)) (env (() () ())))
clos/con:
	'((λ (x3) (-> (λ (x4) ...) <-)) (env (() () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (x4) (-> (λ (x5) ...) <-)) (env (() () () ())))
clos/con:
	'((λ (x4) (-> (λ (x5) ...) <-)) (env (() () () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (x5) (-> (λ (x6) ...) <-)) (env (() () () () ())))
clos/con:
	'((λ (x5) (-> (λ (x6) ...) <-)) (env (() () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (x6) (-> (λ (x7) ...) <-)) (env (() () () () () ())))
clos/con:
	'((λ (x6) (-> (λ (x7) ...) <-)) (env (() () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x7)
    (->
     (app
      and
      (app or x1 x2)
      (app or x1 (app not x2) (app not x3))
      (app or x3 x4)
      (app or (app not x4) x1)
      (app or (app not x2) (app not x3))
      (app or x4 x2))
     <-))
  (env (() () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   and
   (app or x1 x2)
   (app or x1 (app not x2) (app not x3))
   (app or x3 x4)
   (app or (app not x4) x1)
   (app or (app not x2) (app not x3))
   (-> (app or x4 x2) <-))
  (env (() () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app or x4 (-> x2 <-)) (env (() () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app or (-> x4 <-) x2) (env (() () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> or <-) x4 x2) (env (() () () () () () ())))
clos/con:
	'((prim or) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   and
   (app or x1 x2)
   (app or x1 (app not x2) (app not x3))
   (app or x3 x4)
   (app or (app not x4) x1)
   (-> (app or (app not x2) (app not x3)) <-)
   (app or x4 x2))
  (env (() () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (app not x2) (-> (app not x3) <-))
  (env (() () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app not (-> x3 <-)) (env (() () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> not <-) x3) (env (() () () () () () ())))
clos/con:
	'((prim not) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (-> (app not x2) <-) (app not x3))
  (env (() () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app not (-> x2 <-)) (env (() () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> not <-) x2) (env (() () () () () () ())))
clos/con:
	'((prim not) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> or <-) (app not x2) (app not x3))
  (env (() () () () () () ())))
clos/con:
	'((prim or) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   and
   (app or x1 x2)
   (app or x1 (app not x2) (app not x3))
   (app or x3 x4)
   (-> (app or (app not x4) x1) <-)
   (app or (app not x2) (app not x3))
   (app or x4 x2))
  (env (() () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app or (app not x4) (-> x1 <-)) (env (() () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app or (-> (app not x4) <-) x1) (env (() () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app not (-> x4 <-)) (env (() () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> not <-) x4) (env (() () () () () () ())))
clos/con:
	'((prim not) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> or <-) (app not x4) x1) (env (() () () () () () ())))
clos/con:
	'((prim or) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   and
   (app or x1 x2)
   (app or x1 (app not x2) (app not x3))
   (-> (app or x3 x4) <-)
   (app or (app not x4) x1)
   (app or (app not x2) (app not x3))
   (app or x4 x2))
  (env (() () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app or x3 (-> x4 <-)) (env (() () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app or (-> x3 <-) x4) (env (() () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> or <-) x3 x4) (env (() () () () () () ())))
clos/con:
	'((prim or) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   and
   (app or x1 x2)
   (-> (app or x1 (app not x2) (app not x3)) <-)
   (app or x3 x4)
   (app or (app not x4) x1)
   (app or (app not x2) (app not x3))
   (app or x4 x2))
  (env (() () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or x1 (app not x2) (-> (app not x3) <-))
  (env (() () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app not (-> x3 <-)) (env (() () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> not <-) x3) (env (() () () () () () ())))
clos/con:
	'((prim not) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or x1 (-> (app not x2) <-) (app not x3))
  (env (() () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app not (-> x2 <-)) (env (() () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> not <-) x2) (env (() () () () () () ())))
clos/con:
	'((prim not) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (-> x1 <-) (app not x2) (app not x3))
  (env (() () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> or <-) x1 (app not x2) (app not x3))
  (env (() () () () () () ())))
clos/con:
	'((prim or) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   and
   (-> (app or x1 x2) <-)
   (app or x1 (app not x2) (app not x3))
   (app or x3 x4)
   (app or (app not x4) x1)
   (app or (app not x2) (app not x3))
   (app or x4 x2))
  (env (() () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app or x1 (-> x2 <-)) (env (() () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app or (-> x1 <-) x2) (env (() () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> or <-) x1 x2) (env (() () () () () () ())))
clos/con:
	'((prim or) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   (-> and <-)
   (app or x1 x2)
   (app or x1 (app not x2) (app not x3))
   (app or x3 x4)
   (app or (app not x4) x1)
   (app or (app not x2) (app not x3))
   (app or x4 x2))
  (env (() () () () () () ())))
clos/con:
	'((prim and) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (phi ... sat-solve-7) (-> (app sat-solve-7 phi) <-))
  (env ()))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app sat-solve-7 (-> phi <-)) (env ()))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1) ...) <-)) try ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> sat-solve-7 <-) phi) (env ()))
clos/con:
	'((letrec* (... try (sat-solve-7 (-> (λ (p) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)
