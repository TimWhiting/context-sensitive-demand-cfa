'(expression:
  (letrec ((phi (λ (x1 x2) (app or x1 (app not x2))))
           (try (λ (f) (app or (app f (app #t)) (app f (app #f)))))
           (sat-solve-2
            (λ (p) (app try (λ (n1) (app try (λ (n2) (app p n1 n2))))))))
    (app sat-solve-2 phi)))

(list
 'query:
 '(app (-> #f <-))
 (flatenv
  '((λ (p) (-> (app try (λ (n1) ...)) <-))
    (letrec (phi ... sat-solve-2) (-> (app sat-solve-2 phi) <-)))))
(list 'clos/con: (list (list '((top) . #f) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-2 ...) ...)
 (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-2 ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app sat-solve-2 (-> phi <-)) (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (phi (-> (λ (x1 x2) ...) <-)) try ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (n1) (-> (app try (λ (n2) ...)) <-))
 (flatenv
  '((app or (-> (app f (app #t)) <-) (app f (app #f)))
    (λ (p) (-> (app try (λ (n1) ...)) <-)))))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> f <-) (app #t))
 (flatenv
  '((λ (n1) (-> (app try (λ (n2) ...)) <-))
    (app or (-> (app f (app #t)) <-) (app f (app #f))))))
(list
 'clos/con:
 (list
  (list
   '(app try (-> (λ (n2) ...) <-))
   (flatenv
    '((app or (-> (app f (app #t)) <-) (app f (app #f)))
      (λ (p) (-> (app try (λ (n1) ...)) <-)))))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> try <-) (λ (n2) ...))
 (flatenv
  '((app or (-> (app f (app #t)) <-) (app f (app #f)))
    (λ (p) (-> (app try (λ (n1) ...)) <-)))))
(list
 'clos/con:
 (list
  (list
   '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-2 ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app try (-> (λ (n1) ...) <-))
 (flatenv '((letrec (phi ... sat-solve-2) (-> (app sat-solve-2 phi) <-)))))
(list
 'clos/con:
 (list
  (list
   '(app try (-> (λ (n1) ...) <-))
   (flatenv '((letrec (phi ... sat-solve-2) (-> (app sat-solve-2 phi) <-)))))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> not <-) x2)
 (flatenv
  '((λ (n2) (-> (app p n1 n2) <-))
    (app or (app f (app #t)) (-> (app f (app #f)) <-)))))
'(clos/con: (#<procedure:do-not>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> #t <-))
 (flatenv
  '((λ (p) (-> (app try (λ (n1) ...)) <-))
    (letrec (phi ... sat-solve-2) (-> (app sat-solve-2 phi) <-)))))
(list 'clos/con: (list (list '((top) . #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> #t <-))
 (flatenv
  '((λ (n1) (-> (app try (λ (n2) ...)) <-))
    (app or (-> (app f (app #t)) <-) (app f (app #f))))))
(list 'clos/con: (list (list '((top) . #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app or x1 (-> (app not x2) <-))
 (flatenv
  '((λ (n2) (-> (app p n1 n2) <-))
    (app or (app f (app #t)) (-> (app f (app #f)) <-)))))
(list 'clos/con: (list (list '(con #f ()) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app f (-> (app #t) <-))
 (flatenv
  '((λ (n1) (-> (app try (λ (n2) ...)) <-))
    (app or (-> (app f (app #t)) <-) (app f (app #f))))))
(list 'clos/con: (list (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> f <-) (app #f))
 (flatenv
  '((λ (n1) (-> (app try (λ (n2) ...)) <-))
    (app or (app f (app #t)) (-> (app f (app #f)) <-)))))
(list
 'clos/con:
 (list
  (list
   '(app try (-> (λ (n2) ...) <-))
   (flatenv
    '((app or (app f (app #t)) (-> (app f (app #f)) <-))
      (λ (p) (-> (app try (λ (n1) ...)) <-)))))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> or <-) (app f (app #t)) (app f (app #f)))
 (flatenv
  '((λ (p) (-> (app try (λ (n1) ...)) <-))
    (letrec (phi ... sat-solve-2) (-> (app sat-solve-2 phi) <-)))))
'(clos/con: (#<procedure:do-or>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app or (-> x1 <-) (app not x2))
 (flatenv
  '((λ (n2) (-> (app p n1 n2) <-))
    (app or (-> (app f (app #t)) <-) (app f (app #f))))))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> or <-) (app f (app #t)) (app f (app #f)))
 (flatenv
  '((λ (n1) (-> (app try (λ (n2) ...)) <-))
    (app or (-> (app f (app #t)) <-) (app f (app #f))))))
'(clos/con: (#<procedure:do-or>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app not (-> x2 <-))
 (flatenv
  '((λ (n2) (-> (app p n1 n2) <-))
    (app or (app f (app #t)) (-> (app f (app #f)) <-)))))
(list 'clos/con: (list (list '(con #f) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app p (-> n1 <-) n2)
 (flatenv
  '((app or (app f (app #t)) (-> (app f (app #f)) <-))
    (λ (n1) (-> (app try (λ (n2) ...)) <-)))))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> #t <-))
 (flatenv
  '((λ (n1) (-> (app try (λ (n2) ...)) <-))
    (app or (app f (app #t)) (-> (app f (app #f)) <-)))))
(list 'clos/con: (list (list '((top) . #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (n2) (-> (app p n1 n2) <-))
 (flatenv
  '((app or (app f (app #t)) (-> (app f (app #f)) <-))
    (λ (n1) (-> (app try (λ (n2) ...)) <-)))))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> try <-) (λ (n1) ...))
 (flatenv '((letrec (phi ... sat-solve-2) (-> (app sat-solve-2 phi) <-)))))
(list
 'clos/con:
 (list
  (list
   '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-2 ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app try (-> (λ (n2) ...) <-))
 (flatenv
  '((app or (-> (app f (app #t)) <-) (app f (app #f)))
    (λ (p) (-> (app try (λ (n1) ...)) <-)))))
(list
 'clos/con:
 (list
  (list
   '(app try (-> (λ (n2) ...) <-))
   (flatenv
    '((app or (-> (app f (app #t)) <-) (app f (app #f)))
      (λ (p) (-> (app try (λ (n1) ...)) <-)))))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app or x1 (-> (app not x2) <-))
 (flatenv
  '((λ (n2) (-> (app p n1 n2) <-))
    (app or (-> (app f (app #t)) <-) (app f (app #f))))))
(list 'clos/con: (list (list '(con #f ()) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app or (-> x1 <-) (app not x2))
 (flatenv
  '((λ (n2) (-> (app p n1 n2) <-))
    (app or (app f (app #t)) (-> (app f (app #f)) <-)))))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... try (sat-solve-2 (-> (λ (p) ...) <-)) () ...) ...)
 (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... try (sat-solve-2 (-> (λ (p) ...) <-)) () ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> #f <-))
 (flatenv
  '((λ (n1) (-> (app try (λ (n2) ...)) <-))
    (app or (app f (app #t)) (-> (app f (app #f)) <-)))))
(list 'clos/con: (list (list '((top) . #f) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (f) (-> (app or (app f (app #t)) (app f (app #f))) <-))
 (flatenv
  '((λ (n1) (-> (app try (λ (n2) ...)) <-))
    (app or (app f (app #t)) (-> (app f (app #f)) <-)))))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> try <-) (λ (n2) ...))
 (flatenv
  '((app or (app f (app #t)) (-> (app f (app #f)) <-))
    (λ (p) (-> (app try (λ (n1) ...)) <-)))))
(list
 'clos/con:
 (list
  (list
   '(letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-2 ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app or (app f (app #t)) (-> (app f (app #f)) <-))
 (flatenv
  '((λ (p) (-> (app try (λ (n1) ...)) <-))
    (letrec (phi ... sat-solve-2) (-> (app sat-solve-2 phi) <-)))))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> f <-) (app #t))
 (flatenv
  '((λ (n1) (-> (app try (λ (n2) ...)) <-))
    (app or (app f (app #t)) (-> (app f (app #f)) <-)))))
(list
 'clos/con:
 (list
  (list
   '(app try (-> (λ (n2) ...) <-))
   (flatenv
    '((app or (app f (app #t)) (-> (app f (app #f)) <-))
      (λ (p) (-> (app try (λ (n1) ...)) <-)))))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> sat-solve-2 <-) phi) (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... try (sat-solve-2 (-> (λ (p) ...) <-)) () ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (f) (-> (app or (app f (app #t)) (app f (app #f))) <-))
 (flatenv
  '((λ (p) (-> (app try (λ (n1) ...)) <-))
    (letrec (phi ... sat-solve-2) (-> (app sat-solve-2 phi) <-)))))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app p n1 (-> n2 <-))
 (flatenv
  '((app or (-> (app f (app #t)) <-) (app f (app #f)))
    (λ (n1) (-> (app try (λ (n2) ...)) <-)))))
(list 'clos/con: (list (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> f <-) (app #f))
 (flatenv
  '((λ (n1) (-> (app try (λ (n2) ...)) <-))
    (app or (-> (app f (app #t)) <-) (app f (app #f))))))
(list
 'clos/con:
 (list
  (list
   '(app try (-> (λ (n2) ...) <-))
   (flatenv
    '((app or (-> (app f (app #t)) <-) (app f (app #f)))
      (λ (p) (-> (app try (λ (n1) ...)) <-)))))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app f (-> (app #f) <-))
 (flatenv
  '((λ (p) (-> (app try (λ (n1) ...)) <-))
    (letrec (phi ... sat-solve-2) (-> (app sat-solve-2 phi) <-)))))
(list 'clos/con: (list (list '(con #f) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> or <-) (app f (app #t)) (app f (app #f)))
 (flatenv
  '((λ (n1) (-> (app try (λ (n2) ...)) <-))
    (app or (app f (app #t)) (-> (app f (app #f)) <-)))))
'(clos/con: (#<procedure:do-or>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app or (app f (app #t)) (-> (app f (app #f)) <-))
 (flatenv
  '((λ (n1) (-> (app try (λ (n2) ...)) <-))
    (app or (app f (app #t)) (-> (app f (app #f)) <-)))))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '((top) letrec (phi ... sat-solve-2) ...) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> or <-) x1 (app not x2))
 (flatenv
  '((λ (n2) (-> (app p n1 n2) <-))
    (app or (-> (app f (app #t)) <-) (app f (app #f))))))
'(clos/con: (#<procedure:do-or>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> p <-) n1 n2)
 (flatenv
  '((app or (app f (app #t)) (-> (app f (app #f)) <-))
    (λ (n1) (-> (app try (λ (n2) ...)) <-)))))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (phi (-> (λ (x1 x2) ...) <-)) try ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (n2) (-> (app p n1 n2) <-))
 (flatenv
  '((app or (-> (app f (app #t)) <-) (app f (app #f)))
    (λ (n1) (-> (app try (λ (n2) ...)) <-)))))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app f (-> (app #t) <-))
 (flatenv
  '((λ (p) (-> (app try (λ (n1) ...)) <-))
    (letrec (phi ... sat-solve-2) (-> (app sat-solve-2 phi) <-)))))
(list 'clos/con: (list (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (phi ... sat-solve-2) (-> (app sat-solve-2 phi) <-))
 (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> f <-) (app #t))
 (flatenv
  '((λ (p) (-> (app try (λ (n1) ...)) <-))
    (letrec (phi ... sat-solve-2) (-> (app sat-solve-2 phi) <-)))))
(list
 'clos/con:
 (list
  (list
   '(app try (-> (λ (n1) ...) <-))
   (flatenv '((letrec (phi ... sat-solve-2) (-> (app sat-solve-2 phi) <-)))))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> p <-) n1 n2)
 (flatenv
  '((app or (-> (app f (app #t)) <-) (app f (app #f)))
    (λ (n1) (-> (app try (λ (n2) ...)) <-)))))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (phi (-> (λ (x1 x2) ...) <-)) try ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... () (phi (-> (λ (x1 x2) ...) <-)) try ...) ...)
 (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (phi (-> (λ (x1 x2) ...) <-)) try ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app p (-> n1 <-) n2)
 (flatenv
  '((app or (-> (app f (app #t)) <-) (app f (app #f)))
    (λ (n1) (-> (app try (λ (n2) ...)) <-)))))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app f (-> (app #f) <-))
 (flatenv
  '((λ (n1) (-> (app try (λ (n2) ...)) <-))
    (app or (app f (app #t)) (-> (app f (app #f)) <-)))))
(list 'clos/con: (list (list '(con #f) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (x1 x2) (-> (app or x1 (app not x2)) <-))
 (flatenv
  '((λ (n2) (-> (app p n1 n2) <-))
    (app or (-> (app f (app #t)) <-) (app f (app #f))))))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app try (-> (λ (n2) ...) <-))
 (flatenv
  '((app or (app f (app #t)) (-> (app f (app #f)) <-))
    (λ (p) (-> (app try (λ (n1) ...)) <-)))))
(list
 'clos/con:
 (list
  (list
   '(app try (-> (λ (n2) ...) <-))
   (flatenv
    '((app or (app f (app #t)) (-> (app f (app #f)) <-))
      (λ (p) (-> (app try (λ (n1) ...)) <-)))))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app or (-> (app f (app #t)) <-) (app f (app #f)))
 (flatenv
  '((λ (p) (-> (app try (λ (n1) ...)) <-))
    (letrec (phi ... sat-solve-2) (-> (app sat-solve-2 phi) <-)))))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (p) (-> (app try (λ (n1) ...)) <-))
 (flatenv '((letrec (phi ... sat-solve-2) (-> (app sat-solve-2 phi) <-)))))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> f <-) (app #f))
 (flatenv
  '((λ (p) (-> (app try (λ (n1) ...)) <-))
    (letrec (phi ... sat-solve-2) (-> (app sat-solve-2 phi) <-)))))
(list
 'clos/con:
 (list
  (list
   '(app try (-> (λ (n1) ...) <-))
   (flatenv '((letrec (phi ... sat-solve-2) (-> (app sat-solve-2 phi) <-)))))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app f (-> (app #t) <-))
 (flatenv
  '((λ (n1) (-> (app try (λ (n2) ...)) <-))
    (app or (app f (app #t)) (-> (app f (app #f)) <-)))))
(list 'clos/con: (list (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (x1 x2) (-> (app or x1 (app not x2)) <-))
 (flatenv
  '((λ (n2) (-> (app p n1 n2) <-))
    (app or (app f (app #t)) (-> (app f (app #f)) <-)))))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app or (-> (app f (app #t)) <-) (app f (app #f)))
 (flatenv
  '((λ (n1) (-> (app try (λ (n2) ...)) <-))
    (app or (-> (app f (app #t)) <-) (app f (app #f))))))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> not <-) x2)
 (flatenv
  '((λ (n2) (-> (app p n1 n2) <-))
    (app or (-> (app f (app #t)) <-) (app f (app #f))))))
'(clos/con: (#<procedure:do-not>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> or <-) x1 (app not x2))
 (flatenv
  '((λ (n2) (-> (app p n1 n2) <-))
    (app or (app f (app #t)) (-> (app f (app #f)) <-)))))
'(clos/con: (#<procedure:do-or>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app f (-> (app #f) <-))
 (flatenv
  '((λ (n1) (-> (app try (λ (n2) ...)) <-))
    (app or (-> (app f (app #t)) <-) (app f (app #f))))))
(list 'clos/con: (list (list '(con #f) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (n1) (-> (app try (λ (n2) ...)) <-))
 (flatenv
  '((app or (app f (app #t)) (-> (app f (app #f)) <-))
    (λ (p) (-> (app try (λ (n1) ...)) <-)))))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app p n1 (-> n2 <-))
 (flatenv
  '((app or (app f (app #t)) (-> (app f (app #f)) <-))
    (λ (n1) (-> (app try (λ (n2) ...)) <-)))))
(list 'clos/con: (list (list '(con #f) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> #f <-))
 (flatenv
  '((λ (n1) (-> (app try (λ (n2) ...)) <-))
    (app or (-> (app f (app #t)) <-) (app f (app #f))))))
(list 'clos/con: (list (list '((top) . #f) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (f) (-> (app or (app f (app #t)) (app f (app #f))) <-))
 (flatenv
  '((λ (n1) (-> (app try (λ (n2) ...)) <-))
    (app or (-> (app f (app #t)) <-) (app f (app #f))))))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app or (-> (app f (app #t)) <-) (app f (app #f)))
 (flatenv
  '((λ (n1) (-> (app try (λ (n2) ...)) <-))
    (app or (app f (app #t)) (-> (app f (app #f)) <-)))))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app not (-> x2 <-))
 (flatenv
  '((λ (n2) (-> (app p n1 n2) <-))
    (app or (-> (app f (app #t)) <-) (app f (app #f))))))
(list 'clos/con: (list (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app or (app f (app #t)) (-> (app f (app #f)) <-))
 (flatenv
  '((λ (n1) (-> (app try (λ (n2) ...)) <-))
    (app or (-> (app f (app #t)) <-) (app f (app #f))))))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))
