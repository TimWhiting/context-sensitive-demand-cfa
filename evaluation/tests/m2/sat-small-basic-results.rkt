'(expression:
  (letrec ((phi (λ (x1 x2) (app or x1 (app not x2))))
           (try (λ (f) (app or (app f (app #t)) (app f (app #f)))))
           (sat-solve-2
            (λ (p) (app try (λ (n1) (app try (λ (n2) (app p n1 n2))))))))
    (app sat-solve-2 phi)))

(list 'query: '((top) letrec (phi ... sat-solve-2) ...) (menv '()))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... try (sat-solve-2 (-> (λ (p) ...) <-)) () ...) ...)
 (menv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... try (sat-solve-2 (-> (λ (p) ...) <-)) () ...) ...)
   (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (p) (-> (app try (λ (n1) ...)) <-)) (menv '((□? (p)))))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app try (-> (λ (n1) ...) <-)) (menv '((□? (p)))))
(list
 'clos/con:
 (list (list '(app try (-> (λ (n1) ...) <-)) (menv '((□? (p)))))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (n1) (-> (app try (λ (n2) ...)) <-))
 (menv '((□? (n1)) (□? (p)))))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app try (-> (λ (n2) ...) <-)) (menv '((□? (n1)) (□? (p)))))
(list
 'clos/con:
 (list (list '(app try (-> (λ (n2) ...) <-)) (menv '((□? (n1)) (□? (p)))))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (n2) (-> (app p n1 n2) <-))
 (menv '((□? (n2)) (□? (n1)) (□? (p)))))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app p n1 (-> n2 <-)) (menv '((□? (n2)) (□? (n1)) (□? (p)))))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app p (-> n1 <-) n2) (menv '((□? (n2)) (□? (n1)) (□? (p)))))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> p <-) n1 n2) (menv '((□? (n2)) (□? (n1)) (□? (p)))))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (phi (-> (λ (x1 x2) ...) <-)) try ...) ...)
   (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> try <-) (λ (n2) ...)) (menv '((□? (n1)) (□? (p)))))
(list
 'clos/con:
 (list
  (list
   '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-2 ...) ...)
   (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> try <-) (λ (n1) ...)) (menv '((□? (p)))))
(list
 'clos/con:
 (list
  (list
   '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-2 ...) ...)
   (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-2 ...) ...)
 (menv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-2 ...) ...)
   (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (f) (-> (app or (app f (app #t)) (app f (app #f))) <-))
 (menv '((□? (f)))))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app or (app f (app #t)) (-> (app f (app #f)) <-))
 (menv '((□? (f)))))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app f (-> (app #f) <-)) (menv '((□? (f)))))
(list 'clos/con: (list (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> #f <-)) (menv '((□? (f)))))
(list 'clos/con: (list (list '((top) . #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> f <-) (app #f)) (menv '((□? (f)))))
(list
 'clos/con:
 (list
  (list '(app try (-> (λ (n2) ...) <-)) (menv '((□? (n1)) (□? (p)))))
  (list '(app try (-> (λ (n1) ...) <-)) (menv '((□? (p)))))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app or (-> (app f (app #t)) <-) (app f (app #f)))
 (menv '((□? (f)))))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app f (-> (app #t) <-)) (menv '((□? (f)))))
(list 'clos/con: (list (list '((top) app #t) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> #t <-)) (menv '((□? (f)))))
(list 'clos/con: (list (list '((top) . #t) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> f <-) (app #t)) (menv '((□? (f)))))
(list
 'clos/con:
 (list
  (list '(app try (-> (λ (n2) ...) <-)) (menv '((□? (n1)) (□? (p)))))
  (list '(app try (-> (λ (n1) ...) <-)) (menv '((□? (p)))))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> or <-) (app f (app #t)) (app f (app #f)))
 (menv '((□? (f)))))
'(clos/con: (#<procedure:do-demand-or>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... () (phi (-> (λ (x1 x2) ...) <-)) try ...) ...)
 (menv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (phi (-> (λ (x1 x2) ...) <-)) try ...) ...)
   (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (x1 x2) (-> (app or x1 (app not x2)) <-))
 (menv '((□? (x1 x2)))))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app or x1 (-> (app not x2) <-)) (menv '((□? (x1 x2)))))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app not (-> x2 <-)) (menv '((□? (x1 x2)))))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> not <-) x2) (menv '((□? (x1 x2)))))
'(clos/con: (#<procedure:do-demand-not>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app or (-> x1 <-) (app not x2)) (menv '((□? (x1 x2)))))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> or <-) x1 (app not x2)) (menv '((□? (x1 x2)))))
'(clos/con: (#<procedure:do-demand-or>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (phi ... sat-solve-2) (-> (app sat-solve-2 phi) <-))
 (menv '()))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app sat-solve-2 (-> phi <-)) (menv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (phi (-> (λ (x1 x2) ...) <-)) try ...) ...)
   (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> sat-solve-2 <-) phi) (menv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... try (sat-solve-2 (-> (λ (p) ...) <-)) () ...) ...)
   (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))
