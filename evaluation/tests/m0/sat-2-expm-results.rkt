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

(list 'query: '(app or (-> x1 <-) x2) (expenv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app or x3 (-> x4 <-)) (expenv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app or (-> (app not x4) <-) x1)
 (expenv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app try (-> (λ (n1) ...) <-)) (expenv '(())))
(list 'clos/con: (list (list '(app try (-> (λ (n1) ...) <-)) (expenv '(())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> #t <-)) (expenv '(())))
(list 'clos/con: (list (list '((top) . #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> not <-) x4) (expenv '(() () () () () () ())))
'(clos/con: (#<procedure:do-not>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (app (app p n1) n2) (-> n3 <-))
 (expenv '(() () () () () () () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> try <-) (λ (n2) ...)) (expenv '(() ())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app or x1 (app not x2) (-> (app not x3) <-))
 (expenv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> (app (app (app p n1) n2) n3) <-) n4)
 (expenv '(() () () () () () () ())))
(list
 'clos/con:
 (list (list '(λ (x3) (-> (λ (x4) ...) <-)) (expenv '(() () ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app sat-solve-7 (-> phi <-)) (expenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (phi (-> (λ (x1) ...) <-)) try ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> not <-) x2) (expenv '(() () () () () () ())))
'(clos/con: (#<procedure:do-not>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> try <-) (λ (n7) ...)) (expenv '(() () () () () () ())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> or <-) x3 x4) (expenv '(() () () () () () ())))
'(clos/con: (#<procedure:do-or>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...)
 (expenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> try <-) (λ (n5) ...)) (expenv '(() () () () ())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...)
   (expenv '()))))
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
 (expenv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app or (app not x4) (-> x1 <-))
 (expenv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> sat-solve-7 <-) phi) (expenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... try (sat-solve-7 (-> (λ (p) ...) <-)) () ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app or (-> (app not x2) <-) (app not x3))
 (expenv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> or <-) x1 x2) (expenv '(() () () () () () ())))
'(clos/con: (#<procedure:do-or>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app f (-> (app #f) <-)) (expenv '(())))
(list 'clos/con: (list (list '(con #f) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (n7)
    (-> (app (app (app (app (app (app (app p n1) n2) n3) n4) n5) n6) n7) <-))
 (expenv '(() () () () () () () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (f) (-> (app or (app f (app #t)) (app f (app #f))) <-))
 (expenv '(())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> not <-) x2) (expenv '(() () () () () () ())))
'(clos/con: (#<procedure:do-not>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (app (app (app (app p n1) n2) n3) n4) (-> n5 <-))
 (expenv '(() () () () () () () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app or (app not x2) (-> (app not x3) <-))
 (expenv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app not (-> x2 <-)) (expenv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> not <-) x3) (expenv '(() () () () () () ())))
'(clos/con: (#<procedure:do-not>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app or (-> x3 <-) x4) (expenv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> (app p n1) <-) n2) (expenv '(() () () () () () () ())))
(list 'clos/con: (list (list '(λ (x1) (-> (λ (x2) ...) <-)) (expenv '(())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (phi ... sat-solve-7) (-> (app sat-solve-7 phi) <-))
 (expenv '()))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app not (-> x4 <-)) (expenv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app try (-> (λ (n2) ...) <-)) (expenv '(() ())))
(list
 'clos/con:
 (list (list '(app try (-> (λ (n2) ...) <-)) (expenv '(() ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> or <-) (app f (app #t)) (app f (app #f)))
 (expenv '(())))
'(clos/con: (#<procedure:do-or>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> (app (app (app (app (app p n1) n2) n3) n4) n5) <-) n6)
 (expenv '(() () () () () () () ())))
(list
 'clos/con:
 (list (list '(λ (x5) (-> (λ (x6) ...) <-)) (expenv '(() () () () ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (x6) (-> (λ (x7) ...) <-)) (expenv '(() () () () () ())))
(list
 'clos/con:
 (list (list '(λ (x6) (-> (λ (x7) ...) <-)) (expenv '(() () () () () ())))))
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
 (expenv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app f (-> (app #t) <-)) (expenv '(())))
(list 'clos/con: (list (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app or (-> x1 <-) (app not x2) (app not x3))
 (expenv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app or x1 (-> x2 <-)) (expenv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> try <-) (λ (n3) ...)) (expenv '(() () ())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (n5) (-> (app try (λ (n6) ...)) <-))
 (expenv '(() () () () () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> or <-) x4 x2) (expenv '(() () () () () () ())))
'(clos/con: (#<procedure:do-or>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (app (app (app (app (app p n1) n2) n3) n4) n5) (-> n6 <-))
 (expenv '(() () () () () () () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (p) (-> (app try (λ (n1) ...)) <-)) (expenv '(())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app try (-> (λ (n3) ...) <-)) (expenv '(() () ())))
(list
 'clos/con:
 (list (list '(app try (-> (λ (n3) ...) <-)) (expenv '(() () ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (app (app (app (app (app (app p n1) n2) n3) n4) n5) n6) (-> n7 <-))
 (expenv '(() () () () () () () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> try <-) (λ (n4) ...)) (expenv '(() () () ())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (x3) (-> (λ (x4) ...) <-)) (expenv '(() () ())))
(list
 'clos/con:
 (list (list '(λ (x3) (-> (λ (x4) ...) <-)) (expenv '(() () ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (n4) (-> (app try (λ (n5) ...)) <-))
 (expenv '(() () () () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (n1) (-> (app try (λ (n2) ...)) <-)) (expenv '(() ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (n6) (-> (app try (λ (n7) ...)) <-))
 (expenv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> or <-) (app not x4) x1)
 (expenv '(() () () () () () ())))
'(clos/con: (#<procedure:do-or>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app or (app f (app #t)) (-> (app f (app #f)) <-))
 (expenv '(())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> not <-) x3) (expenv '(() () () () () () ())))
'(clos/con: (#<procedure:do-not>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> try <-) (λ (n6) ...)) (expenv '(() () () () () ())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> (app (app (app (app p n1) n2) n3) n4) <-) n5)
 (expenv '(() () () () () () () ())))
(list
 'clos/con:
 (list (list '(λ (x4) (-> (λ (x5) ...) <-)) (expenv '(() () () ())))))
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
 (expenv '(() () () () () () ())))
'(clos/con: (#<procedure:do-and>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... () (phi (-> (λ (x1) ...) <-)) try ...) ...)
 (expenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (phi (-> (λ (x1) ...) <-)) try ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (app p n1) (-> n2 <-)) (expenv '(() () () () () () () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
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
 (expenv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app or x1 (-> (app not x2) <-) (app not x3))
 (expenv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '((top) letrec (phi ... sat-solve-7) ...) (expenv '()))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (x2) (-> (λ (x3) ...) <-)) (expenv '(() ())))
(list
 'clos/con:
 (list (list '(λ (x2) (-> (λ (x3) ...) <-)) (expenv '(() ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app try (-> (λ (n6) ...) <-)) (expenv '(() () () () () ())))
(list
 'clos/con:
 (list (list '(app try (-> (λ (n6) ...) <-)) (expenv '(() () () () () ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (x4) (-> (λ (x5) ...) <-)) (expenv '(() () () ())))
(list
 'clos/con:
 (list (list '(λ (x4) (-> (λ (x5) ...) <-)) (expenv '(() () () ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app not (-> x3 <-)) (expenv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
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
 (expenv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
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
 (expenv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app not (-> x3 <-)) (expenv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app try (-> (λ (n4) ...) <-)) (expenv '(() () () ())))
(list
 'clos/con:
 (list (list '(app try (-> (λ (n4) ...) <-)) (expenv '(() () () ())))))
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
 (expenv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app p (-> n1 <-)) (expenv '(() () () () () () () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> (app (app (app (app (app (app p n1) n2) n3) n4) n5) n6) <-) n7)
 (expenv '(() () () () () () () ())))
(list
 'clos/con:
 (list (list '(λ (x6) (-> (λ (x7) ...) <-)) (expenv '(() () () () () ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app or (-> (app f (app #t)) <-) (app f (app #f)))
 (expenv '(())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (app (app (app p n1) n2) n3) (-> n4 <-))
 (expenv '(() () () () () () () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app not (-> x2 <-)) (expenv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app or x4 (-> x2 <-)) (expenv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (x5) (-> (λ (x6) ...) <-)) (expenv '(() () () () ())))
(list
 'clos/con:
 (list (list '(λ (x5) (-> (λ (x6) ...) <-)) (expenv '(() () () () ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app try (-> (λ (n5) ...) <-)) (expenv '(() () () () ())))
(list
 'clos/con:
 (list (list '(app try (-> (λ (n5) ...) <-)) (expenv '(() () () () ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> or <-) x1 (app not x2) (app not x3))
 (expenv '(() () () () () () ())))
'(clos/con: (#<procedure:do-or>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (x1) (-> (λ (x2) ...) <-)) (expenv '(())))
(list 'clos/con: (list (list '(λ (x1) (-> (λ (x2) ...) <-)) (expenv '(())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (n3) (-> (app try (λ (n4) ...)) <-)) (expenv '(() () () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app try (-> (λ (n7) ...) <-)) (expenv '(() () () () () () ())))
(list
 'clos/con:
 (list
  (list '(app try (-> (λ (n7) ...) <-)) (expenv '(() () () () () () ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> try <-) (λ (n1) ...)) (expenv '(())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> #f <-)) (expenv '(())))
(list 'clos/con: (list (list '((top) . #f) (expenv '()))))
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
 (expenv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... try (sat-solve-7 (-> (λ (p) ...) <-)) () ...) ...)
 (expenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... try (sat-solve-7 (-> (λ (p) ...) <-)) () ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> f <-) (app #t)) (expenv '(())))
(list
 'clos/con:
 (list
  (list '(app try (-> (λ (n7) ...) <-)) (expenv '(() () () () () () ())))
  (list '(app try (-> (λ (n5) ...) <-)) (expenv '(() () () () ())))
  (list '(app try (-> (λ (n4) ...) <-)) (expenv '(() () () ())))
  (list '(app try (-> (λ (n6) ...) <-)) (expenv '(() () () () () ())))
  (list '(app try (-> (λ (n3) ...) <-)) (expenv '(() () ())))
  (list '(app try (-> (λ (n2) ...) <-)) (expenv '(() ())))
  (list '(app try (-> (λ (n1) ...) <-)) (expenv '(())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (n2) (-> (app try (λ (n3) ...)) <-)) (expenv '(() () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> or <-) (app not x2) (app not x3))
 (expenv '(() () () () () () ())))
'(clos/con: (#<procedure:do-or>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> p <-) n1) (expenv '(() () () () () () () ())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (phi (-> (λ (x1) ...) <-)) try ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> f <-) (app #f)) (expenv '(())))
(list
 'clos/con:
 (list
  (list '(app try (-> (λ (n7) ...) <-)) (expenv '(() () () () () () ())))
  (list '(app try (-> (λ (n5) ...) <-)) (expenv '(() () () () ())))
  (list '(app try (-> (λ (n4) ...) <-)) (expenv '(() () () ())))
  (list '(app try (-> (λ (n6) ...) <-)) (expenv '(() () () () () ())))
  (list '(app try (-> (λ (n3) ...) <-)) (expenv '(() () ())))
  (list '(app try (-> (λ (n2) ...) <-)) (expenv '(() ())))
  (list '(app try (-> (λ (n1) ...) <-)) (expenv '(())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app or (-> x4 <-) x2) (expenv '(() () () () () () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> (app (app p n1) n2) <-) n3)
 (expenv '(() () () () () () () ())))
(list
 'clos/con:
 (list (list '(λ (x2) (-> (λ (x3) ...) <-)) (expenv '(() ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))
