'(expression:
  (letrec ((phi (λ (x1 x2) (app or x1 (app not x2))))
           (try (λ (f) (app or (app f (app #t)) (app f (app #f)))))
           (sat-solve-2
            (λ (p) (app try (λ (n1) (app try (λ (n2) (app p n1 n2))))))))
    (app sat-solve-2 phi)))

(list 'query: '(app (-> not <-) x2) (expenv '(())))
'(clos/con: (#<procedure:do-not>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-2 ...) ...)
 (expenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-2 ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> try <-) (λ (n2) ...)) (expenv '(() ())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-2 ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app sat-solve-2 (-> phi <-)) (expenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (phi (-> (λ (x1 x2) ...) <-)) try ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app f (-> (app #f) <-)) (expenv '(())))
(list 'clos/con: (list (list '(con #f) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> f <-) (app #t)) (expenv '(())))
(list
 'clos/con:
 (list
  (list '(app try (-> (λ (n1) ...) <-)) (expenv '(())))
  (list '(app try (-> (λ (n2) ...) <-)) (expenv '(() ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app try (-> (λ (n2) ...) <-)) (expenv '(() ())))
(list
 'clos/con:
 (list (list '(app try (-> (λ (n2) ...) <-)) (expenv '(() ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... try (sat-solve-2 (-> (λ (p) ...) <-)) () ...) ...)
 (expenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... try (sat-solve-2 (-> (λ (p) ...) <-)) () ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app or x1 (-> (app not x2) <-)) (expenv '(())))
(list 'clos/con: (list (list '(con #f ()) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app not (-> x2 <-)) (expenv '(())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (x1 x2) (-> (app or x1 (app not x2)) <-)) (expenv '(())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> sat-solve-2 <-) phi) (expenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... try (sat-solve-2 (-> (λ (p) ...) <-)) () ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app f (-> (app #t) <-)) (expenv '(())))
(list 'clos/con: (list (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app try (-> (λ (n1) ...) <-)) (expenv '(())))
(list 'clos/con: (list (list '(app try (-> (λ (n1) ...) <-)) (expenv '(())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '((top) letrec (phi ... sat-solve-2) ...) (expenv '()))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (phi ... sat-solve-2) (-> (app sat-solve-2 phi) <-))
 (expenv '()))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
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
 '(app (-> or <-) (app f (app #t)) (app f (app #f)))
 (expenv '(())))
'(clos/con: (#<procedure:do-or>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... () (phi (-> (λ (x1 x2) ...) <-)) try ...) ...)
 (expenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (phi (-> (λ (x1 x2) ...) <-)) try ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (n1) (-> (app try (λ (n2) ...)) <-)) (expenv '(() ())))
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

(list 'query: '(λ (p) (-> (app try (λ (n1) ...)) <-)) (expenv '(())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (n2) (-> (app p n1 n2) <-)) (expenv '(() () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> or <-) x1 (app not x2)) (expenv '(())))
'(clos/con: (#<procedure:do-or>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> p <-) n1 n2) (expenv '(() () ())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (phi (-> (λ (x1 x2) ...) <-)) try ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> f <-) (app #f)) (expenv '(())))
(list
 'clos/con:
 (list
  (list '(app try (-> (λ (n1) ...) <-)) (expenv '(())))
  (list '(app try (-> (λ (n2) ...) <-)) (expenv '(() ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app p n1 (-> n2 <-)) (expenv '(() () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> #t <-)) (expenv '(())))
(list 'clos/con: (list (list '((top) . #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app or (-> x1 <-) (app not x2)) (expenv '(())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app or (app f (app #t)) (-> (app f (app #f)) <-))
 (expenv '(())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> try <-) (λ (n1) ...)) (expenv '(())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-2 ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> #f <-)) (expenv '(())))
(list 'clos/con: (list (list '((top) . #f) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app p (-> n1 <-) n2) (expenv '(() () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))
