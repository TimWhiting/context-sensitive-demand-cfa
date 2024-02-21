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

(list 'query: '(app or (-> (app not x4) <-) x1) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app or (-> x1 <-) x2) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app or x3 (-> x4 <-)) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app try (-> (λ (n1) ...) <-)) (flatenv '()))
(list 'clos/con: (list (list '(app try (-> (λ (n1) ...) <-)) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> #t <-)) (flatenv '()))
(list 'clos/con: (list (list '((top) . #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> not <-) x4) (flatenv '()))
'(clos/con: (#<procedure:do-not>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (app (app p n1) n2) (-> n3 <-)) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> try <-) (λ (n2) ...)) (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app or x1 (app not x2) (-> (app not x3) <-)) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> (app (app (app p n1) n2) n3) <-) n4) (flatenv '()))
(list 'clos/con: (list (list '(λ (x3) (-> (λ (x4) ...) <-)) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app sat-solve-7 (-> phi <-)) (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (phi (-> (λ (x1) ...) <-)) try ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> not <-) x2) (flatenv '()))
'(clos/con: (#<procedure:do-not>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> try <-) (λ (n7) ...)) (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> or <-) x3 x4) (flatenv '()))
'(clos/con: (#<procedure:do-or>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...)
 (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> try <-) (λ (n5) ...)) (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...)
   (flatenv '()))))
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
 (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app or (app not x4) (-> x1 <-)) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> sat-solve-7 <-) phi) (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... try (sat-solve-7 (-> (λ (p) ...) <-)) () ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app or (-> (app not x2) <-) (app not x3)) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> or <-) x1 x2) (flatenv '()))
'(clos/con: (#<procedure:do-or>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app f (-> (app #f) <-)) (flatenv '()))
(list 'clos/con: (list (list '(con #f) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (n7)
    (-> (app (app (app (app (app (app (app p n1) n2) n3) n4) n5) n6) n7) <-))
 (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (f) (-> (app or (app f (app #t)) (app f (app #f))) <-))
 (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> not <-) x2) (flatenv '()))
'(clos/con: (#<procedure:do-not>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (app (app (app (app p n1) n2) n3) n4) (-> n5 <-))
 (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app or (app not x2) (-> (app not x3) <-)) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app not (-> x2 <-)) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> (app p n1) <-) n2) (flatenv '()))
(list 'clos/con: (list (list '(λ (x1) (-> (λ (x2) ...) <-)) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> not <-) x3) (flatenv '()))
'(clos/con: (#<procedure:do-not>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app or (-> x3 <-) x4) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (phi ... sat-solve-7) (-> (app sat-solve-7 phi) <-))
 (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app not (-> x4 <-)) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app try (-> (λ (n2) ...) <-)) (flatenv '()))
(list 'clos/con: (list (list '(app try (-> (λ (n2) ...) <-)) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> or <-) (app f (app #t)) (app f (app #f)))
 (flatenv '()))
'(clos/con: (#<procedure:do-or>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> (app (app (app (app (app p n1) n2) n3) n4) n5) <-) n6)
 (flatenv '()))
(list 'clos/con: (list (list '(λ (x5) (-> (λ (x6) ...) <-)) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (x6) (-> (λ (x7) ...) <-)) (flatenv '()))
(list 'clos/con: (list (list '(λ (x6) (-> (λ (x7) ...) <-)) (flatenv '()))))
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
 (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app f (-> (app #t) <-)) (flatenv '()))
(list 'clos/con: (list (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app or (-> x1 <-) (app not x2) (app not x3)) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app or x1 (-> x2 <-)) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> try <-) (λ (n3) ...)) (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (n5) (-> (app try (λ (n6) ...)) <-)) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> or <-) x4 x2) (flatenv '()))
'(clos/con: (#<procedure:do-or>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (p) (-> (app try (λ (n1) ...)) <-)) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app try (-> (λ (n3) ...) <-)) (flatenv '()))
(list 'clos/con: (list (list '(app try (-> (λ (n3) ...) <-)) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (app (app (app (app (app (app p n1) n2) n3) n4) n5) n6) (-> n7 <-))
 (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> try <-) (λ (n4) ...)) (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (app (app (app (app (app p n1) n2) n3) n4) n5) (-> n6 <-))
 (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (x3) (-> (λ (x4) ...) <-)) (flatenv '()))
(list 'clos/con: (list (list '(λ (x3) (-> (λ (x4) ...) <-)) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (n4) (-> (app try (λ (n5) ...)) <-)) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (n1) (-> (app try (λ (n2) ...)) <-)) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (n6) (-> (app try (λ (n7) ...)) <-)) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> or <-) (app not x4) x1) (flatenv '()))
'(clos/con: (#<procedure:do-or>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app or (app f (app #t)) (-> (app f (app #f)) <-))
 (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> not <-) x3) (flatenv '()))
'(clos/con: (#<procedure:do-not>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> try <-) (λ (n6) ...)) (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> (app (app (app (app p n1) n2) n3) n4) <-) n5)
 (flatenv '()))
(list 'clos/con: (list (list '(λ (x4) (-> (λ (x5) ...) <-)) (flatenv '()))))
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
 (flatenv '()))
'(clos/con: (#<procedure:do-and>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... () (phi (-> (λ (x1) ...) <-)) try ...) ...)
 (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (phi (-> (λ (x1) ...) <-)) try ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (app p n1) (-> n2 <-)) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
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
 (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app or x1 (-> (app not x2) <-) (app not x3)) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '((top) letrec (phi ... sat-solve-7) ...) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (x2) (-> (λ (x3) ...) <-)) (flatenv '()))
(list 'clos/con: (list (list '(λ (x2) (-> (λ (x3) ...) <-)) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app try (-> (λ (n6) ...) <-)) (flatenv '()))
(list 'clos/con: (list (list '(app try (-> (λ (n6) ...) <-)) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (x4) (-> (λ (x5) ...) <-)) (flatenv '()))
(list 'clos/con: (list (list '(λ (x4) (-> (λ (x5) ...) <-)) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app not (-> x3 <-)) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
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
 (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
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
 (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app not (-> x3 <-)) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app try (-> (λ (n4) ...) <-)) (flatenv '()))
(list 'clos/con: (list (list '(app try (-> (λ (n4) ...) <-)) (flatenv '()))))
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
 (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app p (-> n1 <-)) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> (app (app (app (app (app (app p n1) n2) n3) n4) n5) n6) <-) n7)
 (flatenv '()))
(list 'clos/con: (list (list '(λ (x6) (-> (λ (x7) ...) <-)) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app or (-> (app f (app #t)) <-) (app f (app #f)))
 (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (app (app (app p n1) n2) n3) (-> n4 <-)) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app not (-> x2 <-)) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app or x4 (-> x2 <-)) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app try (-> (λ (n5) ...) <-)) (flatenv '()))
(list 'clos/con: (list (list '(app try (-> (λ (n5) ...) <-)) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> or <-) x1 (app not x2) (app not x3)) (flatenv '()))
'(clos/con: (#<procedure:do-or>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (x5) (-> (λ (x6) ...) <-)) (flatenv '()))
(list 'clos/con: (list (list '(λ (x5) (-> (λ (x6) ...) <-)) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (x1) (-> (λ (x2) ...) <-)) (flatenv '()))
(list 'clos/con: (list (list '(λ (x1) (-> (λ (x2) ...) <-)) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (n3) (-> (app try (λ (n4) ...)) <-)) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app try (-> (λ (n7) ...) <-)) (flatenv '()))
(list 'clos/con: (list (list '(app try (-> (λ (n7) ...) <-)) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> try <-) (λ (n1) ...)) (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> #f <-)) (flatenv '()))
(list 'clos/con: (list (list '((top) . #f) (flatenv '()))))
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
 (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... try (sat-solve-7 (-> (λ (p) ...) <-)) () ...) ...)
 (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... try (sat-solve-7 (-> (λ (p) ...) <-)) () ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> f <-) (app #t)) (flatenv '()))
(list
 'clos/con:
 (list
  (list '(app try (-> (λ (n7) ...) <-)) (flatenv '()))
  (list '(app try (-> (λ (n5) ...) <-)) (flatenv '()))
  (list '(app try (-> (λ (n4) ...) <-)) (flatenv '()))
  (list '(app try (-> (λ (n6) ...) <-)) (flatenv '()))
  (list '(app try (-> (λ (n3) ...) <-)) (flatenv '()))
  (list '(app try (-> (λ (n2) ...) <-)) (flatenv '()))
  (list '(app try (-> (λ (n1) ...) <-)) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (n2) (-> (app try (λ (n3) ...)) <-)) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> or <-) (app not x2) (app not x3)) (flatenv '()))
'(clos/con: (#<procedure:do-or>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> p <-) n1) (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (phi (-> (λ (x1) ...) <-)) try ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> f <-) (app #f)) (flatenv '()))
(list
 'clos/con:
 (list
  (list '(app try (-> (λ (n7) ...) <-)) (flatenv '()))
  (list '(app try (-> (λ (n5) ...) <-)) (flatenv '()))
  (list '(app try (-> (λ (n4) ...) <-)) (flatenv '()))
  (list '(app try (-> (λ (n6) ...) <-)) (flatenv '()))
  (list '(app try (-> (λ (n3) ...) <-)) (flatenv '()))
  (list '(app try (-> (λ (n2) ...) <-)) (flatenv '()))
  (list '(app try (-> (λ (n1) ...) <-)) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app or (-> x4 <-) x2) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> (app (app p n1) n2) <-) n3) (flatenv '()))
(list 'clos/con: (list (list '(λ (x2) (-> (λ (x3) ...) <-)) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))
