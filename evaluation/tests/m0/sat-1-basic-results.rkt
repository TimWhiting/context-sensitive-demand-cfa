'(expression:
  (letrec ((phi
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
                    (app
                     try
                     (λ (n3) (app try (λ (n4) (app p n1 n2 n3 n4))))))))))))
    (app sat-solve-4 phi)))

(list 'query: '((top) letrec (phi ... sat-solve-4) ...) (menv '()))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... try (sat-solve-4 (-> (λ (p) ...) <-)) () ...) ...)
 (menv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... try (sat-solve-4 (-> (λ (p) ...) <-)) () ...) ...)
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

(list 'query: '(λ (n4) (-> (app p n1 n2 n3 n4) <-)) (menv '(() () () () ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app p n1 n2 n3 (-> n4 <-)) (menv '(() () () () ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app p n1 n2 (-> n3 <-) n4) (menv '(() () () () ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app p n1 (-> n2 <-) n3 n4) (menv '(() () () () ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app p (-> n1 <-) n2 n3 n4) (menv '(() () () () ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> p <-) n1 n2 n3 n4) (menv '(() () () () ())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...)
   (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> try <-) (λ (n4) ...)) (menv '(() () () ())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...)
   (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> try <-) (λ (n3) ...)) (menv '(() () ())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...)
   (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> try <-) (λ (n2) ...)) (menv '(() ())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...)
   (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> try <-) (λ (n1) ...)) (menv '(())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...)
   (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...)
 (menv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...)
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
  (list '(app try (-> (λ (n1) ...) <-)) (menv '(())))
  (list '(app try (-> (λ (n4) ...) <-)) (menv '(() () () ())))
  (list '(app try (-> (λ (n2) ...) <-)) (menv '(() ())))
  (list '(app try (-> (λ (n3) ...) <-)) (menv '(() () ())))))
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
  (list '(app try (-> (λ (n1) ...) <-)) (menv '(())))
  (list '(app try (-> (λ (n4) ...) <-)) (menv '(() () () ())))
  (list '(app try (-> (λ (n2) ...) <-)) (menv '(() ())))
  (list '(app try (-> (λ (n3) ...) <-)) (menv '(() () ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> or <-) (app f (app #t)) (app f (app #f))) (menv '(())))
'(clos/con: (#<procedure:do-demand-or>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... () (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...)
 (menv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...)
   (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (x1 x2 x3 x4)
    (->
     (app
      and
      (app or x1 (app not x2) (app not x3))
      (app or (app not x2) (app not x3))
      (app or x4 x2))
     <-))
 (menv '(())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app
   and
   (app or x1 (app not x2) (app not x3))
   (app or (app not x2) (app not x3))
   (-> (app or x4 x2) <-))
 (menv '(())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app or x4 (-> x2 <-)) (menv '(())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app or (-> x4 <-) x2) (menv '(())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> or <-) x4 x2) (menv '(())))
'(clos/con: (#<procedure:do-demand-or>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app
   and
   (app or x1 (app not x2) (app not x3))
   (-> (app or (app not x2) (app not x3)) <-)
   (app or x4 x2))
 (menv '(())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app or (app not x2) (-> (app not x3) <-)) (menv '(())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app not (-> x3 <-)) (menv '(())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> not <-) x3) (menv '(())))
'(clos/con: (#<procedure:do-demand-not>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app or (-> (app not x2) <-) (app not x3)) (menv '(())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app not (-> x2 <-)) (menv '(())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> not <-) x2) (menv '(())))
'(clos/con: (#<procedure:do-demand-not>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> or <-) (app not x2) (app not x3)) (menv '(())))
'(clos/con: (#<procedure:do-demand-or>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app
   and
   (-> (app or x1 (app not x2) (app not x3)) <-)
   (app or (app not x2) (app not x3))
   (app or x4 x2))
 (menv '(())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app or x1 (app not x2) (-> (app not x3) <-)) (menv '(())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app not (-> x3 <-)) (menv '(())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> not <-) x3) (menv '(())))
'(clos/con: (#<procedure:do-demand-not>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app or x1 (-> (app not x2) <-) (app not x3)) (menv '(())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app not (-> x2 <-)) (menv '(())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> not <-) x2) (menv '(())))
'(clos/con: (#<procedure:do-demand-not>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app or (-> x1 <-) (app not x2) (app not x3)) (menv '(())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> or <-) x1 (app not x2) (app not x3)) (menv '(())))
'(clos/con: (#<procedure:do-demand-or>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app
   (-> and <-)
   (app or x1 (app not x2) (app not x3))
   (app or (app not x2) (app not x3))
   (app or x4 x2))
 (menv '(())))
'(clos/con: (#<procedure:do-demand-and>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (phi ... sat-solve-4) (-> (app sat-solve-4 phi) <-))
 (menv '()))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app sat-solve-4 (-> phi <-)) (menv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...)
   (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> sat-solve-4 <-) phi) (menv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... try (sat-solve-4 (-> (λ (p) ...) <-)) () ...) ...)
   (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))
