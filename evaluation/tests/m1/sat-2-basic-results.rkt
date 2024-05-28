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
  (λ (n4) (-> (app try (λ (n5) ...)) <-))
  (env ((□? (n4)) (□? (n3)) (□? (n2)) (□? (n1)) (□? (p)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app try (-> (λ (n5) ...) <-))
  (env ((□? (n4)) (□? (n3)) (□? (n2)) (□? (n1)) (□? (p)))))
clos/con:
	'((app try (-> (λ (n5) ...) <-))
  (env ((□? (n4)) (□? (n3)) (□? (n2)) (□? (n1)) (□? (p)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (n5) (-> (app try (λ (n6) ...)) <-))
  (env ((□? (n5)) (□? (n4)) (□? (n3)) (□? (n2)) (□? (n1)) (□? (p)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app try (-> (λ (n6) ...) <-))
  (env ((□? (n5)) (□? (n4)) (□? (n3)) (□? (n2)) (□? (n1)) (□? (p)))))
clos/con:
	'((app try (-> (λ (n6) ...) <-))
  (env ((□? (n5)) (□? (n4)) (□? (n3)) (□? (n2)) (□? (n1)) (□? (p)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (n6) (-> (app try (λ (n7) ...)) <-))
  (env ((□? (n6)) (□? (n5)) (□? (n4)) (□? (n3)) (□? (n2)) (□? (n1)) (□? (p)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app try (-> (λ (n7) ...) <-))
  (env ((□? (n6)) (□? (n5)) (□? (n4)) (□? (n3)) (□? (n2)) (□? (n1)) (□? (p)))))
clos/con:
	'((app try (-> (λ (n7) ...) <-))
  (env ((□? (n6)) (□? (n5)) (□? (n4)) (□? (n3)) (□? (n2)) (□? (n1)) (□? (p)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (n7)
    (-> (app (app (app (app (app (app (app p n1) n2) n3) n4) n5) n6) n7) <-))
  (env
   ((□? (n7))
    (□? (n6))
    (□? (n5))
    (□? (n4))
    (□? (n3))
    (□? (n2))
    (□? (n1))
    (□? (p)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (app (app (app (app (app (app p n1) n2) n3) n4) n5) n6) (-> n7 <-))
  (env
   ((□? (n7))
    (□? (n6))
    (□? (n5))
    (□? (n4))
    (□? (n3))
    (□? (n2))
    (□? (n1))
    (□? (p)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> (app (app (app (app (app (app p n1) n2) n3) n4) n5) n6) <-) n7)
  (env
   ((□? (n7))
    (□? (n6))
    (□? (n5))
    (□? (n4))
    (□? (n3))
    (□? (n2))
    (□? (n1))
    (□? (p)))))
clos/con:
	'((λ (x6) (-> (λ (x7) ...) <-))
  (env
   (((app (-> (app (app (app (app (app (app p n1) n2) n3) n4) n5) n6) <-) n7))
    ((app (-> (app (app (app (app (app p n1) n2) n3) n4) n5) <-) n6))
    ((app (-> (app (app (app (app p n1) n2) n3) n4) <-) n5))
    ((app (-> (app (app (app p n1) n2) n3) <-) n4))
    ((app (-> (app (app p n1) n2) <-) n3))
    ((app (-> (app p n1) <-) n2)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (app (app (app (app (app p n1) n2) n3) n4) n5) (-> n6 <-))
  (env
   ((□? (n7))
    (□? (n6))
    (□? (n5))
    (□? (n4))
    (□? (n3))
    (□? (n2))
    (□? (n1))
    (□? (p)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> (app (app (app (app (app p n1) n2) n3) n4) n5) <-) n6)
  (env
   ((□? (n7))
    (□? (n6))
    (□? (n5))
    (□? (n4))
    (□? (n3))
    (□? (n2))
    (□? (n1))
    (□? (p)))))
clos/con:
	'((λ (x5) (-> (λ (x6) ...) <-))
  (env
   (((app (-> (app (app (app (app (app p n1) n2) n3) n4) n5) <-) n6))
    ((app (-> (app (app (app (app p n1) n2) n3) n4) <-) n5))
    ((app (-> (app (app (app p n1) n2) n3) <-) n4))
    ((app (-> (app (app p n1) n2) <-) n3))
    ((app (-> (app p n1) <-) n2)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (app (app (app (app p n1) n2) n3) n4) (-> n5 <-))
  (env
   ((□? (n7))
    (□? (n6))
    (□? (n5))
    (□? (n4))
    (□? (n3))
    (□? (n2))
    (□? (n1))
    (□? (p)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> (app (app (app (app p n1) n2) n3) n4) <-) n5)
  (env
   ((□? (n7))
    (□? (n6))
    (□? (n5))
    (□? (n4))
    (□? (n3))
    (□? (n2))
    (□? (n1))
    (□? (p)))))
clos/con:
	'((λ (x4) (-> (λ (x5) ...) <-))
  (env
   (((app (-> (app (app (app (app p n1) n2) n3) n4) <-) n5))
    ((app (-> (app (app (app p n1) n2) n3) <-) n4))
    ((app (-> (app (app p n1) n2) <-) n3))
    ((app (-> (app p n1) <-) n2)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (app (app (app p n1) n2) n3) (-> n4 <-))
  (env
   ((□? (n7))
    (□? (n6))
    (□? (n5))
    (□? (n4))
    (□? (n3))
    (□? (n2))
    (□? (n1))
    (□? (p)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> (app (app (app p n1) n2) n3) <-) n4)
  (env
   ((□? (n7))
    (□? (n6))
    (□? (n5))
    (□? (n4))
    (□? (n3))
    (□? (n2))
    (□? (n1))
    (□? (p)))))
clos/con:
	'((λ (x3) (-> (λ (x4) ...) <-))
  (env
   (((app (-> (app (app (app p n1) n2) n3) <-) n4))
    ((app (-> (app (app p n1) n2) <-) n3))
    ((app (-> (app p n1) <-) n2)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (app (app p n1) n2) (-> n3 <-))
  (env
   ((□? (n7))
    (□? (n6))
    (□? (n5))
    (□? (n4))
    (□? (n3))
    (□? (n2))
    (□? (n1))
    (□? (p)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> (app (app p n1) n2) <-) n3)
  (env
   ((□? (n7))
    (□? (n6))
    (□? (n5))
    (□? (n4))
    (□? (n3))
    (□? (n2))
    (□? (n1))
    (□? (p)))))
clos/con:
	'((λ (x2) (-> (λ (x3) ...) <-))
  (env (((app (-> (app (app p n1) n2) <-) n3)) ((app (-> (app p n1) <-) n2)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (app p n1) (-> n2 <-))
  (env
   ((□? (n7))
    (□? (n6))
    (□? (n5))
    (□? (n4))
    (□? (n3))
    (□? (n2))
    (□? (n1))
    (□? (p)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> (app p n1) <-) n2)
  (env
   ((□? (n7))
    (□? (n6))
    (□? (n5))
    (□? (n4))
    (□? (n3))
    (□? (n2))
    (□? (n1))
    (□? (p)))))
clos/con:
	'((λ (x1) (-> (λ (x2) ...) <-)) (env (((app (-> (app p n1) <-) n2)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app p (-> n1 <-))
  (env
   ((□? (n7))
    (□? (n6))
    (□? (n5))
    (□? (n4))
    (□? (n3))
    (□? (n2))
    (□? (n1))
    (□? (p)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> p <-) n1)
  (env
   ((□? (n7))
    (□? (n6))
    (□? (n5))
    (□? (n4))
    (□? (n3))
    (□? (n2))
    (□? (n1))
    (□? (p)))))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1) ...) <-)) try ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> try <-) (λ (n7) ...))
  (env ((□? (n6)) (□? (n5)) (□? (n4)) (□? (n3)) (□? (n2)) (□? (n1)) (□? (p)))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> try <-) (λ (n6) ...))
  (env ((□? (n5)) (□? (n4)) (□? (n3)) (□? (n2)) (□? (n1)) (□? (p)))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> try <-) (λ (n5) ...))
  (env ((□? (n4)) (□? (n3)) (□? (n2)) (□? (n1)) (□? (p)))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> try <-) (λ (n4) ...))
  (env ((□? (n3)) (□? (n2)) (□? (n1)) (□? (p)))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> try <-) (λ (n3) ...)) (env ((□? (n2)) (□? (n1)) (□? (p)))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> try <-) (λ (n2) ...)) (env ((□? (n1)) (□? (p)))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> try <-) (λ (n1) ...)) (env ((□? (p)))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...)
  (env ()))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (f) (-> (app or (app f (app #t)) (app f (app #f))) <-))
  (env ((□? (f)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app or (app f (app #t)) (-> (app f (app #f)) <-)) (env ((□? (f)))))
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
	'((app try (-> (λ (n5) ...) <-))
  (env ((□? (n4)) (□? (n3)) (□? (n2)) (□? (n1)) (□? (p)))))
	'((app try (-> (λ (n6) ...) <-))
  (env ((□? (n5)) (□? (n4)) (□? (n3)) (□? (n2)) (□? (n1)) (□? (p)))))
	'((app try (-> (λ (n7) ...) <-))
  (env ((□? (n6)) (□? (n5)) (□? (n4)) (□? (n3)) (□? (n2)) (□? (n1)) (□? (p)))))
literals: '(⊥ ⊥ ⊥)

'(query: (app or (-> (app f (app #t)) <-) (app f (app #f))) (env ((□? (f)))))
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
	'((app try (-> (λ (n5) ...) <-))
  (env ((□? (n4)) (□? (n3)) (□? (n2)) (□? (n1)) (□? (p)))))
	'((app try (-> (λ (n6) ...) <-))
  (env ((□? (n5)) (□? (n4)) (□? (n3)) (□? (n2)) (□? (n1)) (□? (p)))))
	'((app try (-> (λ (n7) ...) <-))
  (env ((□? (n6)) (□? (n5)) (□? (n4)) (□? (n3)) (□? (n2)) (□? (n1)) (□? (p)))))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> or <-) (app f (app #t)) (app f (app #f))) (env ((□? (f)))))
clos/con:
	'((prim or) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (letrec* (... () (phi (-> (λ (x1) ...) <-)) try ...) ...) (env ()))
clos/con:
	'((letrec* (... () (phi (-> (λ (x1) ...) <-)) try ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (x1) (-> (λ (x2) ...) <-)) (env ((□? (x1)))))
clos/con:
	'((λ (x1) (-> (λ (x2) ...) <-)) (env ((□? (x1)))))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (x2) (-> (λ (x3) ...) <-)) (env ((□? (x2)) (□? (x1)))))
clos/con:
	'((λ (x2) (-> (λ (x3) ...) <-)) (env ((□? (x2)) (□? (x1)))))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (x3) (-> (λ (x4) ...) <-)) (env ((□? (x3)) (□? (x2)) (□? (x1)))))
clos/con:
	'((λ (x3) (-> (λ (x4) ...) <-)) (env ((□? (x3)) (□? (x2)) (□? (x1)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x4) (-> (λ (x5) ...) <-))
  (env ((□? (x4)) (□? (x3)) (□? (x2)) (□? (x1)))))
clos/con:
	'((λ (x4) (-> (λ (x5) ...) <-))
  (env ((□? (x4)) (□? (x3)) (□? (x2)) (□? (x1)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x5) (-> (λ (x6) ...) <-))
  (env ((□? (x5)) (□? (x4)) (□? (x3)) (□? (x2)) (□? (x1)))))
clos/con:
	'((λ (x5) (-> (λ (x6) ...) <-))
  (env ((□? (x5)) (□? (x4)) (□? (x3)) (□? (x2)) (□? (x1)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x6) (-> (λ (x7) ...) <-))
  (env ((□? (x6)) (□? (x5)) (□? (x4)) (□? (x3)) (□? (x2)) (□? (x1)))))
clos/con:
	'((λ (x6) (-> (λ (x7) ...) <-))
  (env ((□? (x6)) (□? (x5)) (□? (x4)) (□? (x3)) (□? (x2)) (□? (x1)))))
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
  (env
   ((□? (x7)) (□? (x6)) (□? (x5)) (□? (x4)) (□? (x3)) (□? (x2)) (□? (x1)))))
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
  (env
   ((□? (x7)) (□? (x6)) (□? (x5)) (□? (x4)) (□? (x3)) (□? (x2)) (□? (x1)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or x4 (-> x2 <-))
  (env
   ((□? (x7)) (□? (x6)) (□? (x5)) (□? (x4)) (□? (x3)) (□? (x2)) (□? (x1)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (-> x4 <-) x2)
  (env
   ((□? (x7)) (□? (x6)) (□? (x5)) (□? (x4)) (□? (x3)) (□? (x2)) (□? (x1)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> or <-) x4 x2)
  (env
   ((□? (x7)) (□? (x6)) (□? (x5)) (□? (x4)) (□? (x3)) (□? (x2)) (□? (x1)))))
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
  (env
   ((□? (x7)) (□? (x6)) (□? (x5)) (□? (x4)) (□? (x3)) (□? (x2)) (□? (x1)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (app not x2) (-> (app not x3) <-))
  (env
   ((□? (x7)) (□? (x6)) (□? (x5)) (□? (x4)) (□? (x3)) (□? (x2)) (□? (x1)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app not (-> x3 <-))
  (env
   ((□? (x7)) (□? (x6)) (□? (x5)) (□? (x4)) (□? (x3)) (□? (x2)) (□? (x1)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> not <-) x3)
  (env
   ((□? (x7)) (□? (x6)) (□? (x5)) (□? (x4)) (□? (x3)) (□? (x2)) (□? (x1)))))
clos/con:
	'((prim not) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (-> (app not x2) <-) (app not x3))
  (env
   ((□? (x7)) (□? (x6)) (□? (x5)) (□? (x4)) (□? (x3)) (□? (x2)) (□? (x1)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app not (-> x2 <-))
  (env
   ((□? (x7)) (□? (x6)) (□? (x5)) (□? (x4)) (□? (x3)) (□? (x2)) (□? (x1)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> not <-) x2)
  (env
   ((□? (x7)) (□? (x6)) (□? (x5)) (□? (x4)) (□? (x3)) (□? (x2)) (□? (x1)))))
clos/con:
	'((prim not) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> or <-) (app not x2) (app not x3))
  (env
   ((□? (x7)) (□? (x6)) (□? (x5)) (□? (x4)) (□? (x3)) (□? (x2)) (□? (x1)))))
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
  (env
   ((□? (x7)) (□? (x6)) (□? (x5)) (□? (x4)) (□? (x3)) (□? (x2)) (□? (x1)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (app not x4) (-> x1 <-))
  (env
   ((□? (x7)) (□? (x6)) (□? (x5)) (□? (x4)) (□? (x3)) (□? (x2)) (□? (x1)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (-> (app not x4) <-) x1)
  (env
   ((□? (x7)) (□? (x6)) (□? (x5)) (□? (x4)) (□? (x3)) (□? (x2)) (□? (x1)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app not (-> x4 <-))
  (env
   ((□? (x7)) (□? (x6)) (□? (x5)) (□? (x4)) (□? (x3)) (□? (x2)) (□? (x1)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> not <-) x4)
  (env
   ((□? (x7)) (□? (x6)) (□? (x5)) (□? (x4)) (□? (x3)) (□? (x2)) (□? (x1)))))
clos/con:
	'((prim not) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> or <-) (app not x4) x1)
  (env
   ((□? (x7)) (□? (x6)) (□? (x5)) (□? (x4)) (□? (x3)) (□? (x2)) (□? (x1)))))
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
  (env
   ((□? (x7)) (□? (x6)) (□? (x5)) (□? (x4)) (□? (x3)) (□? (x2)) (□? (x1)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or x3 (-> x4 <-))
  (env
   ((□? (x7)) (□? (x6)) (□? (x5)) (□? (x4)) (□? (x3)) (□? (x2)) (□? (x1)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (-> x3 <-) x4)
  (env
   ((□? (x7)) (□? (x6)) (□? (x5)) (□? (x4)) (□? (x3)) (□? (x2)) (□? (x1)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> or <-) x3 x4)
  (env
   ((□? (x7)) (□? (x6)) (□? (x5)) (□? (x4)) (□? (x3)) (□? (x2)) (□? (x1)))))
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
  (env
   ((□? (x7)) (□? (x6)) (□? (x5)) (□? (x4)) (□? (x3)) (□? (x2)) (□? (x1)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or x1 (app not x2) (-> (app not x3) <-))
  (env
   ((□? (x7)) (□? (x6)) (□? (x5)) (□? (x4)) (□? (x3)) (□? (x2)) (□? (x1)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app not (-> x3 <-))
  (env
   ((□? (x7)) (□? (x6)) (□? (x5)) (□? (x4)) (□? (x3)) (□? (x2)) (□? (x1)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> not <-) x3)
  (env
   ((□? (x7)) (□? (x6)) (□? (x5)) (□? (x4)) (□? (x3)) (□? (x2)) (□? (x1)))))
clos/con:
	'((prim not) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or x1 (-> (app not x2) <-) (app not x3))
  (env
   ((□? (x7)) (□? (x6)) (□? (x5)) (□? (x4)) (□? (x3)) (□? (x2)) (□? (x1)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app not (-> x2 <-))
  (env
   ((□? (x7)) (□? (x6)) (□? (x5)) (□? (x4)) (□? (x3)) (□? (x2)) (□? (x1)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> not <-) x2)
  (env
   ((□? (x7)) (□? (x6)) (□? (x5)) (□? (x4)) (□? (x3)) (□? (x2)) (□? (x1)))))
clos/con:
	'((prim not) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (-> x1 <-) (app not x2) (app not x3))
  (env
   ((□? (x7)) (□? (x6)) (□? (x5)) (□? (x4)) (□? (x3)) (□? (x2)) (□? (x1)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> or <-) x1 (app not x2) (app not x3))
  (env
   ((□? (x7)) (□? (x6)) (□? (x5)) (□? (x4)) (□? (x3)) (□? (x2)) (□? (x1)))))
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
  (env
   ((□? (x7)) (□? (x6)) (□? (x5)) (□? (x4)) (□? (x3)) (□? (x2)) (□? (x1)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or x1 (-> x2 <-))
  (env
   ((□? (x7)) (□? (x6)) (□? (x5)) (□? (x4)) (□? (x3)) (□? (x2)) (□? (x1)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (-> x1 <-) x2)
  (env
   ((□? (x7)) (□? (x6)) (□? (x5)) (□? (x4)) (□? (x3)) (□? (x2)) (□? (x1)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> or <-) x1 x2)
  (env
   ((□? (x7)) (□? (x6)) (□? (x5)) (□? (x4)) (□? (x3)) (□? (x2)) (□? (x1)))))
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
  (env
   ((□? (x7)) (□? (x6)) (□? (x5)) (□? (x4)) (□? (x3)) (□? (x2)) (□? (x1)))))
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
