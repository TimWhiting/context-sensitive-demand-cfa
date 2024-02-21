'(expression:
  (letrec ((phi
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
                                     (app
                                      (app (app (app (app p n1) n2) n3) n4)
                                      n5)
                                     n6)
                                    n7))))))))))))))))))
    (app sat-solve-7 phi)))

(list 'query: '((top) letrec (phi ... sat-solve-7) ...) (menv '()))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... try (sat-solve-7 (-> (λ (p) ...) <-)) () ...) ...)
 (menv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... try (sat-solve-7 (-> (λ (p) ...) <-)) () ...) ...)
   (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (p) (-> (app try (λ (n1) ...)) <-)) (menv '(())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app try (-> (λ (n1) ...) <-)) (menv '(())))
(list 'clos/con: (list (list '(app try (-> (λ (n1) ...) <-)) (menv '(())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (n1) (-> (app try (λ (n2) ...)) <-)) (menv '(() ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app try (-> (λ (n2) ...) <-)) (menv '(() ())))
(list 'clos/con: (list (list '(app try (-> (λ (n2) ...) <-)) (menv '(() ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (n2) (-> (app try (λ (n3) ...)) <-)) (menv '(() () ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app try (-> (λ (n3) ...) <-)) (menv '(() () ())))
(list
 'clos/con:
 (list (list '(app try (-> (λ (n3) ...) <-)) (menv '(() () ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (n3) (-> (app try (λ (n4) ...)) <-)) (menv '(() () () ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app try (-> (λ (n4) ...) <-)) (menv '(() () () ())))
(list
 'clos/con:
 (list (list '(app try (-> (λ (n4) ...) <-)) (menv '(() () () ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (n4) (-> (app try (λ (n5) ...)) <-))
 (menv '(() () () () ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app try (-> (λ (n5) ...) <-)) (menv '(() () () () ())))
(list
 'clos/con:
 (list (list '(app try (-> (λ (n5) ...) <-)) (menv '(() () () () ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (n5) (-> (app try (λ (n6) ...)) <-))
 (menv '(() () () () () ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app try (-> (λ (n6) ...) <-)) (menv '(() () () () () ())))
(list
 'clos/con:
 (list (list '(app try (-> (λ (n6) ...) <-)) (menv '(() () () () () ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (n6) (-> (app try (λ (n7) ...)) <-))
 (menv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app try (-> (λ (n7) ...) <-)) (menv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '(app try (-> (λ (n7) ...) <-)) (menv '(() () () () () () ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (n7)
    (-> (app (app (app (app (app (app (app p n1) n2) n3) n4) n5) n6) n7) <-))
 (menv '(() () () () () () () ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (app (app (app (app (app (app p n1) n2) n3) n4) n5) n6) (-> n7 <-))
 (menv '(() () () () () () () ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> (app (app (app (app (app (app p n1) n2) n3) n4) n5) n6) <-) n7)
 (menv '(() () () () () () () ())))
(list
 'clos/con:
 (list (list '(λ (x6) (-> (λ (x7) ...) <-)) (menv '(() () () () () ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (app (app (app (app (app p n1) n2) n3) n4) n5) (-> n6 <-))
 (menv '(() () () () () () () ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> (app (app (app (app (app p n1) n2) n3) n4) n5) <-) n6)
 (menv '(() () () () () () () ())))
(list
 'clos/con:
 (list (list '(λ (x5) (-> (λ (x6) ...) <-)) (menv '(() () () () ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (app (app (app (app p n1) n2) n3) n4) (-> n5 <-))
 (menv '(() () () () () () () ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> (app (app (app (app p n1) n2) n3) n4) <-) n5)
 (menv '(() () () () () () () ())))
(list
 'clos/con:
 (list (list '(λ (x4) (-> (λ (x5) ...) <-)) (menv '(() () () ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (app (app (app p n1) n2) n3) (-> n4 <-))
 (menv '(() () () () () () () ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> (app (app (app p n1) n2) n3) <-) n4)
 (menv '(() () () () () () () ())))
(list
 'clos/con:
 (list (list '(λ (x3) (-> (λ (x4) ...) <-)) (menv '(() () ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (app (app p n1) n2) (-> n3 <-))
 (menv '(() () () () () () () ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> (app (app p n1) n2) <-) n3)
 (menv '(() () () () () () () ())))
(list 'clos/con: (list (list '(λ (x2) (-> (λ (x3) ...) <-)) (menv '(() ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (app p n1) (-> n2 <-)) (menv '(() () () () () () () ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> (app p n1) <-) n2) (menv '(() () () () () () () ())))
(list 'clos/con: (list (list '(λ (x1) (-> (λ (x2) ...) <-)) (menv '(())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app p (-> n1 <-)) (menv '(() () () () () () () ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> p <-) n1) (menv '(() () () () () () () ())))
(list
 'clos/con:
 (list
  (list '(letrec (... () (phi (-> (λ (x1) ...) <-)) try ...) ...) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> try <-) (λ (n7) ...)) (menv '(() () () () () () ())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...)
   (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> try <-) (λ (n6) ...)) (menv '(() () () () () ())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...)
   (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> try <-) (λ (n5) ...)) (menv '(() () () () ())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...)
   (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> try <-) (λ (n4) ...)) (menv '(() () () ())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...)
   (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> try <-) (λ (n3) ...)) (menv '(() () ())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...)
   (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> try <-) (λ (n2) ...)) (menv '(() ())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...)
   (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> try <-) (λ (n1) ...)) (menv '(())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...)
   (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...)
 (menv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...)
   (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (f) (-> (app or (app f (app #t)) (app f (app #f))) <-))
 (menv '(())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app or (app f (app #t)) (-> (app f (app #f)) <-)) (menv '(())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app f (-> (app #f) <-)) (menv '(())))
(list 'clos/con: (list (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> #f <-)) (menv '(())))
(list 'clos/con: (list (list '((top) . #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> f <-) (app #f)) (menv '(())))
(list
 'clos/con:
 (list
  (list '(app try (-> (λ (n7) ...) <-)) (menv '(() () () () () () ())))
  (list '(app try (-> (λ (n5) ...) <-)) (menv '(() () () () ())))
  (list '(app try (-> (λ (n4) ...) <-)) (menv '(() () () ())))
  (list '(app try (-> (λ (n6) ...) <-)) (menv '(() () () () () ())))
  (list '(app try (-> (λ (n3) ...) <-)) (menv '(() () ())))
  (list '(app try (-> (λ (n2) ...) <-)) (menv '(() ())))
  (list '(app try (-> (λ (n1) ...) <-)) (menv '(())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app or (-> (app f (app #t)) <-) (app f (app #f))) (menv '(())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app f (-> (app #t) <-)) (menv '(())))
(list 'clos/con: (list (list '((top) app #t) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> #t <-)) (menv '(())))
(list 'clos/con: (list (list '((top) . #t) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> f <-) (app #t)) (menv '(())))
(list
 'clos/con:
 (list
  (list '(app try (-> (λ (n7) ...) <-)) (menv '(() () () () () () ())))
  (list '(app try (-> (λ (n5) ...) <-)) (menv '(() () () () ())))
  (list '(app try (-> (λ (n4) ...) <-)) (menv '(() () () ())))
  (list '(app try (-> (λ (n6) ...) <-)) (menv '(() () () () () ())))
  (list '(app try (-> (λ (n3) ...) <-)) (menv '(() () ())))
  (list '(app try (-> (λ (n2) ...) <-)) (menv '(() ())))
  (list '(app try (-> (λ (n1) ...) <-)) (menv '(())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> or <-) (app f (app #t)) (app f (app #f))) (menv '(())))
'(clos/con: (#<procedure:do-demand-or>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... () (phi (-> (λ (x1) ...) <-)) try ...) ...)
 (menv '()))
(list
 'clos/con:
 (list
  (list '(letrec (... () (phi (-> (λ (x1) ...) <-)) try ...) ...) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (x1) (-> (λ (x2) ...) <-)) (menv '(())))
(list 'clos/con: (list (list '(λ (x1) (-> (λ (x2) ...) <-)) (menv '(())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (x2) (-> (λ (x3) ...) <-)) (menv '(() ())))
(list 'clos/con: (list (list '(λ (x2) (-> (λ (x3) ...) <-)) (menv '(() ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (x3) (-> (λ (x4) ...) <-)) (menv '(() () ())))
(list
 'clos/con:
 (list (list '(λ (x3) (-> (λ (x4) ...) <-)) (menv '(() () ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (x4) (-> (λ (x5) ...) <-)) (menv '(() () () ())))
(list
 'clos/con:
 (list (list '(λ (x4) (-> (λ (x5) ...) <-)) (menv '(() () () ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (x5) (-> (λ (x6) ...) <-)) (menv '(() () () () ())))
(list
 'clos/con:
 (list (list '(λ (x5) (-> (λ (x6) ...) <-)) (menv '(() () () () ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (x6) (-> (λ (x7) ...) <-)) (menv '(() () () () () ())))
(list
 'clos/con:
 (list (list '(λ (x6) (-> (λ (x7) ...) <-)) (menv '(() () () () () ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (x7)
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
 (menv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app
   and
   (app or x1 x2)
   (app or x1 (app not x2) (app not x3))
   (app or x3 x4)
   (app or (app not x4) x1)
   (app or (app not x2) (app not x3))
   (-> (app or x4 x2) <-))
 (menv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app or x4 (-> x2 <-)) (menv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app or (-> x4 <-) x2) (menv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> or <-) x4 x2) (menv '(() () () () () () ())))
'(clos/con: (#<procedure:do-demand-or>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app
   and
   (app or x1 x2)
   (app or x1 (app not x2) (app not x3))
   (app or x3 x4)
   (app or (app not x4) x1)
   (-> (app or (app not x2) (app not x3)) <-)
   (app or x4 x2))
 (menv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app or (app not x2) (-> (app not x3) <-))
 (menv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app not (-> x3 <-)) (menv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> not <-) x3) (menv '(() () () () () () ())))
'(clos/con: (#<procedure:do-demand-not>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app or (-> (app not x2) <-) (app not x3))
 (menv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app not (-> x2 <-)) (menv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> not <-) x2) (menv '(() () () () () () ())))
'(clos/con: (#<procedure:do-demand-not>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> or <-) (app not x2) (app not x3))
 (menv '(() () () () () () ())))
'(clos/con: (#<procedure:do-demand-or>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app
   and
   (app or x1 x2)
   (app or x1 (app not x2) (app not x3))
   (app or x3 x4)
   (-> (app or (app not x4) x1) <-)
   (app or (app not x2) (app not x3))
   (app or x4 x2))
 (menv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app or (app not x4) (-> x1 <-)) (menv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app or (-> (app not x4) <-) x1) (menv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app not (-> x4 <-)) (menv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> not <-) x4) (menv '(() () () () () () ())))
'(clos/con: (#<procedure:do-demand-not>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> or <-) (app not x4) x1) (menv '(() () () () () () ())))
'(clos/con: (#<procedure:do-demand-or>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app
   and
   (app or x1 x2)
   (app or x1 (app not x2) (app not x3))
   (-> (app or x3 x4) <-)
   (app or (app not x4) x1)
   (app or (app not x2) (app not x3))
   (app or x4 x2))
 (menv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app or x3 (-> x4 <-)) (menv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app or (-> x3 <-) x4) (menv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> or <-) x3 x4) (menv '(() () () () () () ())))
'(clos/con: (#<procedure:do-demand-or>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app
   and
   (app or x1 x2)
   (-> (app or x1 (app not x2) (app not x3)) <-)
   (app or x3 x4)
   (app or (app not x4) x1)
   (app or (app not x2) (app not x3))
   (app or x4 x2))
 (menv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app or x1 (app not x2) (-> (app not x3) <-))
 (menv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app not (-> x3 <-)) (menv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> not <-) x3) (menv '(() () () () () () ())))
'(clos/con: (#<procedure:do-demand-not>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app or x1 (-> (app not x2) <-) (app not x3))
 (menv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app not (-> x2 <-)) (menv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> not <-) x2) (menv '(() () () () () () ())))
'(clos/con: (#<procedure:do-demand-not>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app or (-> x1 <-) (app not x2) (app not x3))
 (menv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> or <-) x1 (app not x2) (app not x3))
 (menv '(() () () () () () ())))
'(clos/con: (#<procedure:do-demand-or>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app
   and
   (-> (app or x1 x2) <-)
   (app or x1 (app not x2) (app not x3))
   (app or x3 x4)
   (app or (app not x4) x1)
   (app or (app not x2) (app not x3))
   (app or x4 x2))
 (menv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app or x1 (-> x2 <-)) (menv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app or (-> x1 <-) x2) (menv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> or <-) x1 x2) (menv '(() () () () () () ())))
'(clos/con: (#<procedure:do-demand-or>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app
   (-> and <-)
   (app or x1 x2)
   (app or x1 (app not x2) (app not x3))
   (app or x3 x4)
   (app or (app not x4) x1)
   (app or (app not x2) (app not x3))
   (app or x4 x2))
 (menv '(() () () () () () ())))
'(clos/con: (#<procedure:do-demand-and>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (phi ... sat-solve-7) (-> (app sat-solve-7 phi) <-))
 (menv '()))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app sat-solve-7 (-> phi <-)) (menv '()))
(list
 'clos/con:
 (list
  (list '(letrec (... () (phi (-> (λ (x1) ...) <-)) try ...) ...) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> sat-solve-7 <-) phi) (menv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... try (sat-solve-7 (-> (λ (p) ...) <-)) () ...) ...)
   (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))
