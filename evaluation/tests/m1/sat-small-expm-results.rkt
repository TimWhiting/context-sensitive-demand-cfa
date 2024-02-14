'(expression:
  (letrec ((phi (λ (x1 x2) (app or x1 (app not x2))))
           (try (λ (f) (app or (app f (app #t)) (app f (app #f)))))
           (sat-solve-2
            (λ (p) (app try (λ (n1) (app try (λ (n2) (app p n1 n2))))))))
    (app sat-solve-2 phi)))

(list
 'query:
 '(app or (-> (app f (app #t)) <-) (app f (app #f)))
 (expenv '(((λ (n1) (-> (app try (λ (n2) ...)) <-))))))
(list
 'clos/con:
 (list (list '(con #t ()) (expenv '())) (list '(con #f ()) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (f) (-> (app or (app f (app #t)) (app f (app #f))) <-))
 (expenv '(((λ (n1) (-> (app try (λ (n2) ...)) <-))))))
(list
 'clos/con:
 (list (list '(con #t ()) (expenv '())) (list '(con #f ()) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (phi (try (-> (λ (f) ...) <-)) sat-solve-2) ...)
 (expenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (phi (try (-> (λ (f) ...) <-)) sat-solve-2) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app sat-solve-2 (-> phi <-)) (expenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec ((phi (-> (λ (x1 x2) ...) <-)) try sat-solve-2) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> p <-) n1 n2)
 (expenv
  '(((app or (-> (app f (app #t)) <-) (app f (app #f))))
    ((app or (app f (app #t)) (-> (app f (app #f)) <-)))
    ((letrec (phi try sat-solve-2) (-> (app sat-solve-2 phi) <-))))))
(list
 'clos/con:
 (list
  (list
   '(letrec ((phi (-> (λ (x1 x2) ...) <-)) try sat-solve-2) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> p <-) n1 n2)
 (expenv
  '(((app or (-> (app f (app #t)) <-) (app f (app #f))))
    ((app or (-> (app f (app #t)) <-) (app f (app #f))))
    ((letrec (phi try sat-solve-2) (-> (app sat-solve-2 phi) <-))))))
(list
 'clos/con:
 (list
  (list
   '(letrec ((phi (-> (λ (x1 x2) ...) <-)) try sat-solve-2) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app f (-> (app #t) <-))
 (expenv '(((λ (p) (-> (app try (λ (n1) ...)) <-))))))
(list 'clos/con: (list (list '(con #t ()) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> #f <-))
 (expenv '(((λ (p) (-> (app try (λ (n1) ...)) <-))))))
(list 'clos/con: (list (list '((top) . #f) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app or (-> x1 <-) (app not x2))
 (expenv '(((λ (n2) (-> (app p n1 n2) <-))))))
(list
 'clos/con:
 (list (list '(con #t ()) (expenv '())) (list '(con #f ()) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app f (-> (app #t) <-))
 (expenv '(((λ (n1) (-> (app try (λ (n2) ...)) <-))))))
(list 'clos/con: (list (list '(con #t ()) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> #f <-))
 (expenv '(((λ (n1) (-> (app try (λ (n2) ...)) <-))))))
(list 'clos/con: (list (list '((top) . #f) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (x1 x2) (-> (app or x1 (app not x2)) <-))
 (expenv '(((λ (n2) (-> (app p n1 n2) <-))))))
(list
 'clos/con:
 (list (list '(con #t ()) (expenv '())) (list '(con #f ()) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (phi try (sat-solve-2 (-> (λ (p) ...) <-))) ...)
 (expenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (phi try (sat-solve-2 (-> (λ (p) ...) <-))) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app or (app f (app #t)) (-> (app f (app #f)) <-))
 (expenv '(((λ (p) (-> (app try (λ (n1) ...)) <-))))))
(list
 'clos/con:
 (list (list '(con #t ()) (expenv '())) (list '(con #f ()) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> sat-solve-2 <-) phi) (expenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (phi try (sat-solve-2 (-> (λ (p) ...) <-))) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (n2) (-> (app p n1 n2) <-))
 (expenv
  '(((app or (-> (app f (app #t)) <-) (app f (app #f))))
    ((app or (app f (app #t)) (-> (app f (app #f)) <-)))
    ((letrec (phi try sat-solve-2) (-> (app sat-solve-2 phi) <-))))))
(list
 'clos/con:
 (list (list '(con #t ()) (expenv '())) (list '(con #f ()) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app f (-> (app #f) <-))
 (expenv '(((λ (p) (-> (app try (λ (n1) ...)) <-))))))
(list 'clos/con: (list (list '(con #f ()) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> or <-) (app f (app #t)) (app f (app #f)))
 (expenv '(((λ (n1) (-> (app try (λ (n2) ...)) <-))))))
'(clos/con: (#<procedure:do-or>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> try <-) (λ (n2) ...))
 (expenv
  '(((app or (app f (app #t)) (-> (app f (app #f)) <-)))
    ((letrec (phi try sat-solve-2) (-> (app sat-solve-2 phi) <-))))))
(list
 'clos/con:
 (list
  (list
   '(letrec (phi (try (-> (λ (f) ...) <-)) sat-solve-2) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app f (-> (app #f) <-))
 (expenv '(((λ (n1) (-> (app try (λ (n2) ...)) <-))))))
(list 'clos/con: (list (list '(con #f ()) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app or (app f (app #t)) (-> (app f (app #f)) <-))
 (expenv '(((λ (n1) (-> (app try (λ (n2) ...)) <-))))))
(list
 'clos/con:
 (list (list '(con #t ()) (expenv '())) (list '(con #f ()) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '((top) letrec (phi try sat-solve-2) ...) (expenv '()))
(list
 'clos/con:
 (list (list '(con #t ()) (expenv '())) (list '(con #f ()) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (phi try sat-solve-2) (-> (app sat-solve-2 phi) <-))
 (expenv '()))
(list
 'clos/con:
 (list (list '(con #t ()) (expenv '())) (list '(con #f ()) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> or <-) (app f (app #t)) (app f (app #f)))
 (expenv '(((λ (p) (-> (app try (λ (n1) ...)) <-))))))
'(clos/con: (#<procedure:do-or>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> p <-) n1 n2)
 (expenv
  '(((app or (app f (app #t)) (-> (app f (app #f)) <-)))
    ((app or (app f (app #t)) (-> (app f (app #f)) <-)))
    ((letrec (phi try sat-solve-2) (-> (app sat-solve-2 phi) <-))))))
(list
 'clos/con:
 (list
  (list
   '(letrec ((phi (-> (λ (x1 x2) ...) <-)) try sat-solve-2) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> p <-) n1 n2)
 (expenv
  '(((app or (app f (app #t)) (-> (app f (app #f)) <-)))
    ((app or (-> (app f (app #t)) <-) (app f (app #f))))
    ((letrec (phi try sat-solve-2) (-> (app sat-solve-2 phi) <-))))))
(list
 'clos/con:
 (list
  (list
   '(letrec ((phi (-> (λ (x1 x2) ...) <-)) try sat-solve-2) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec ((phi (-> (λ (x1 x2) ...) <-)) try sat-solve-2) ...)
 (expenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec ((phi (-> (λ (x1 x2) ...) <-)) try sat-solve-2) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app p (-> n1 <-) n2)
 (expenv
  '(((app or (-> (app f (app #t)) <-) (app f (app #f))))
    ((app or (app f (app #t)) (-> (app f (app #f)) <-)))
    ((letrec (phi try sat-solve-2) (-> (app sat-solve-2 phi) <-))))))
(list 'clos/con: (list (list '(con #f ()) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app p (-> n1 <-) n2)
 (expenv
  '(((app or (-> (app f (app #t)) <-) (app f (app #f))))
    ((app or (-> (app f (app #t)) <-) (app f (app #f))))
    ((letrec (phi try sat-solve-2) (-> (app sat-solve-2 phi) <-))))))
(list 'clos/con: (list (list '(con #t ()) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app p (-> n1 <-) n2)
 (expenv
  '(((app or (app f (app #t)) (-> (app f (app #f)) <-)))
    ((app or (app f (app #t)) (-> (app f (app #f)) <-)))
    ((letrec (phi try sat-solve-2) (-> (app sat-solve-2 phi) <-))))))
(list 'clos/con: (list (list '(con #f ()) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app p (-> n1 <-) n2)
 (expenv
  '(((app or (app f (app #t)) (-> (app f (app #f)) <-)))
    ((app or (-> (app f (app #t)) <-) (app f (app #f))))
    ((letrec (phi try sat-solve-2) (-> (app sat-solve-2 phi) <-))))))
(list 'clos/con: (list (list '(con #t ()) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> f <-) (app #t))
 (expenv '(((λ (n1) (-> (app try (λ (n2) ...)) <-))))))
(list
 'clos/con:
 (list
  (list
   '(app try (-> (λ (n2) ...) <-))
   (expenv
    '(((app or (app f (app #t)) (-> (app f (app #f)) <-)))
      ((letrec (phi try sat-solve-2) (-> (app sat-solve-2 phi) <-))))))
  (list
   '(app try (-> (λ (n2) ...) <-))
   (expenv
    '(((app or (-> (app f (app #t)) <-) (app f (app #f))))
      ((letrec (phi try sat-solve-2) (-> (app sat-solve-2 phi) <-))))))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> not <-) x2)
 (expenv '(((λ (n2) (-> (app p n1 n2) <-))))))
'(clos/con: (#<procedure:do-not>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app or (-> (app f (app #t)) <-) (app f (app #f)))
 (expenv '(((λ (p) (-> (app try (λ (n1) ...)) <-))))))
(list
 'clos/con:
 (list (list '(con #t ()) (expenv '())) (list '(con #f ()) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (f) (-> (app or (app f (app #t)) (app f (app #f))) <-))
 (expenv '(((λ (p) (-> (app try (λ (n1) ...)) <-))))))
(list
 'clos/con:
 (list (list '(con #t ()) (expenv '())) (list '(con #f ()) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (n1) (-> (app try (λ (n2) ...)) <-))
 (expenv
  '(((app or (-> (app f (app #t)) <-) (app f (app #f))))
    ((letrec (phi try sat-solve-2) (-> (app sat-solve-2 phi) <-))))))
(list
 'clos/con:
 (list (list '(con #t ()) (expenv '())) (list '(con #f ()) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> #t <-))
 (expenv '(((λ (p) (-> (app try (λ (n1) ...)) <-))))))
(list 'clos/con: (list (list '((top) . #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app try (-> (λ (n2) ...) <-))
 (expenv
  '(((app or (-> (app f (app #t)) <-) (app f (app #f))))
    ((letrec (phi try sat-solve-2) (-> (app sat-solve-2 phi) <-))))))
(list
 'clos/con:
 (list
  (list
   '(app try (-> (λ (n2) ...) <-))
   (expenv
    '(((app or (-> (app f (app #t)) <-) (app f (app #f))))
      ((letrec (phi try sat-solve-2) (-> (app sat-solve-2 phi) <-))))))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> try <-) (λ (n1) ...))
 (expenv '(((letrec (phi try sat-solve-2) (-> (app sat-solve-2 phi) <-))))))
(list
 'clos/con:
 (list
  (list
   '(letrec (phi (try (-> (λ (f) ...) <-)) sat-solve-2) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (n1) (-> (app try (λ (n2) ...)) <-))
 (expenv
  '(((app or (app f (app #t)) (-> (app f (app #f)) <-)))
    ((letrec (phi try sat-solve-2) (-> (app sat-solve-2 phi) <-))))))
(list
 'clos/con:
 (list (list '(con #t ()) (expenv '())) (list '(con #f ()) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app not (-> x2 <-))
 (expenv '(((λ (n2) (-> (app p n1 n2) <-))))))
(list
 'clos/con:
 (list (list '(con #t ()) (expenv '())) (list '(con #f ()) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app p n1 (-> n2 <-))
 (expenv
  '(((app or (-> (app f (app #t)) <-) (app f (app #f))))
    ((app or (app f (app #t)) (-> (app f (app #f)) <-)))
    ((letrec (phi try sat-solve-2) (-> (app sat-solve-2 phi) <-))))))
(list 'clos/con: (list (list '(con #t ()) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app p n1 (-> n2 <-))
 (expenv
  '(((app or (-> (app f (app #t)) <-) (app f (app #f))))
    ((app or (-> (app f (app #t)) <-) (app f (app #f))))
    ((letrec (phi try sat-solve-2) (-> (app sat-solve-2 phi) <-))))))
(list 'clos/con: (list (list '(con #t ()) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> f <-) (app #t))
 (expenv '(((λ (p) (-> (app try (λ (n1) ...)) <-))))))
(list
 'clos/con:
 (list
  (list
   '(app try (-> (λ (n1) ...) <-))
   (expenv
    '(((letrec (phi try sat-solve-2) (-> (app sat-solve-2 phi) <-))))))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> f <-) (app #f))
 (expenv '(((λ (p) (-> (app try (λ (n1) ...)) <-))))))
(list
 'clos/con:
 (list
  (list
   '(app try (-> (λ (n1) ...) <-))
   (expenv
    '(((letrec (phi try sat-solve-2) (-> (app sat-solve-2 phi) <-))))))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> or <-) x1 (app not x2))
 (expenv '(((λ (n2) (-> (app p n1 n2) <-))))))
'(clos/con: (#<procedure:do-or>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (n2) (-> (app p n1 n2) <-))
 (expenv
  '(((app or (app f (app #t)) (-> (app f (app #f)) <-)))
    ((app or (-> (app f (app #t)) <-) (app f (app #f))))
    ((letrec (phi try sat-solve-2) (-> (app sat-solve-2 phi) <-))))))
(list
 'clos/con:
 (list (list '(con #t ()) (expenv '())) (list '(con #f ()) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> try <-) (λ (n2) ...))
 (expenv
  '(((app or (-> (app f (app #t)) <-) (app f (app #f))))
    ((letrec (phi try sat-solve-2) (-> (app sat-solve-2 phi) <-))))))
(list
 'clos/con:
 (list
  (list
   '(letrec (phi (try (-> (λ (f) ...) <-)) sat-solve-2) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app try (-> (λ (n1) ...) <-))
 (expenv '(((letrec (phi try sat-solve-2) (-> (app sat-solve-2 phi) <-))))))
(list
 'clos/con:
 (list
  (list
   '(app try (-> (λ (n1) ...) <-))
   (expenv
    '(((letrec (phi try sat-solve-2) (-> (app sat-solve-2 phi) <-))))))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (n2) (-> (app p n1 n2) <-))
 (expenv
  '(((app or (-> (app f (app #t)) <-) (app f (app #f))))
    ((app or (-> (app f (app #t)) <-) (app f (app #f))))
    ((letrec (phi try sat-solve-2) (-> (app sat-solve-2 phi) <-))))))
(list
 'clos/con:
 (list (list '(con #t ()) (expenv '())) (list '(con #f ()) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app p n1 (-> n2 <-))
 (expenv
  '(((app or (app f (app #t)) (-> (app f (app #f)) <-)))
    ((app or (app f (app #t)) (-> (app f (app #f)) <-)))
    ((letrec (phi try sat-solve-2) (-> (app sat-solve-2 phi) <-))))))
(list 'clos/con: (list (list '(con #f ()) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app p n1 (-> n2 <-))
 (expenv
  '(((app or (app f (app #t)) (-> (app f (app #f)) <-)))
    ((app or (-> (app f (app #t)) <-) (app f (app #f))))
    ((letrec (phi try sat-solve-2) (-> (app sat-solve-2 phi) <-))))))
(list 'clos/con: (list (list '(con #f ()) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> f <-) (app #f))
 (expenv '(((λ (n1) (-> (app try (λ (n2) ...)) <-))))))
(list
 'clos/con:
 (list
  (list
   '(app try (-> (λ (n2) ...) <-))
   (expenv
    '(((app or (app f (app #t)) (-> (app f (app #f)) <-)))
      ((letrec (phi try sat-solve-2) (-> (app sat-solve-2 phi) <-))))))
  (list
   '(app try (-> (λ (n2) ...) <-))
   (expenv
    '(((app or (-> (app f (app #t)) <-) (app f (app #f))))
      ((letrec (phi try sat-solve-2) (-> (app sat-solve-2 phi) <-))))))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app try (-> (λ (n2) ...) <-))
 (expenv
  '(((app or (app f (app #t)) (-> (app f (app #f)) <-)))
    ((letrec (phi try sat-solve-2) (-> (app sat-solve-2 phi) <-))))))
(list
 'clos/con:
 (list
  (list
   '(app try (-> (λ (n2) ...) <-))
   (expenv
    '(((app or (app f (app #t)) (-> (app f (app #f)) <-)))
      ((letrec (phi try sat-solve-2) (-> (app sat-solve-2 phi) <-))))))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (p) (-> (app try (λ (n1) ...)) <-))
 (expenv '(((letrec (phi try sat-solve-2) (-> (app sat-solve-2 phi) <-))))))
(list
 'clos/con:
 (list (list '(con #t ()) (expenv '())) (list '(con #f ()) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app or x1 (-> (app not x2) <-))
 (expenv '(((λ (n2) (-> (app p n1 n2) <-))))))
(list
 'clos/con:
 (list (list '(con #t ()) (expenv '())) (list '(con #f ()) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (n2) (-> (app p n1 n2) <-))
 (expenv
  '(((app or (app f (app #t)) (-> (app f (app #f)) <-)))
    ((app or (app f (app #t)) (-> (app f (app #f)) <-)))
    ((letrec (phi try sat-solve-2) (-> (app sat-solve-2 phi) <-))))))
(list
 'clos/con:
 (list (list '(con #t ()) (expenv '())) (list '(con #f ()) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> #t <-))
 (expenv '(((λ (n1) (-> (app try (λ (n2) ...)) <-))))))
(list 'clos/con: (list (list '((top) . #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))
