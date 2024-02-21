'(expression:
  (letrec ((id (λ (x) x))
           (f
            (λ (n)
              (match (app <= n 1) ((#f) (app * n (app f (app - n 1)))) (_ 1))))
           (g
            (λ (n)
              (match
               (app <= n 1)
               ((#f) (app * n (app g (app - n 1))))
               (_ 1)))))
    (app + (app (app id f) 3) (app (app id g) 4))))

(list 'query: '(app - n (-> 1 <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list 'query: '(app (-> id <-) g) (flatenv '()))
(list
 'clos/con:
 (list
  (list '(letrec (... () (id (-> (λ (x) ...) <-)) f ...) ...) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app id (-> f <-)) (flatenv '()))
(list
 'clos/con:
 (list
  (list '(letrec (... id (f (-> (λ (n) ...) <-)) g ...) ...) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> * <-) n (app f (app - n 1))) (flatenv '()))
'(clos/con: (#<procedure:do-mult>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (x) (-> x <-)) (flatenv '()))
(list
 'clos/con:
 (list
  (list '(letrec (... f (g (-> (λ (n) ...) <-)) () ...) ...) (flatenv '()))
  (list '(letrec (... id (f (-> (λ (n) ...) <-)) g ...) ...) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (app id f) (-> 3 <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (3 ⊥ ⊥ ⊥))

(list 'query: '(app g (-> (app - n 1) <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> + <-) (app (app id f) 3) (app (app id g) 4))
 (flatenv '()))
'(clos/con: (#<procedure:do-add>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> (app id f) <-) 3) (flatenv '()))
(list
 'clos/con:
 (list
  (list '(letrec (... f (g (-> (λ (n) ...) <-)) () ...) ...) (flatenv '()))
  (list '(letrec (... id (f (-> (λ (n) ...) <-)) g ...) ...) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app - (-> n <-) 1) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(match (app <= n 1) (#f) (_ (-> 1 <-))) (flatenv '()))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list 'query: '(app (-> f <-) (app - n 1)) (flatenv '()))
(list
 'clos/con:
 (list
  (list '(letrec (... id (f (-> (λ (n) ...) <-)) g ...) ...) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(match (-> (app <= n 1) <-) (#f) _) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... f (g (-> (λ (n) ...) <-)) () ...) ...)
 (flatenv '()))
(list
 'clos/con:
 (list
  (list '(letrec (... f (g (-> (λ (n) ...) <-)) () ...) ...) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app - (-> n <-) 1) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app * n (-> (app g (app - n 1)) <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(λ (n) (-> (match (app <= n 1) ...) <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app id (-> g <-)) (flatenv '()))
(list
 'clos/con:
 (list
  (list '(letrec (... f (g (-> (λ (n) ...) <-)) () ...) ...) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app * (-> n <-) (app g (app - n 1))) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '((top) letrec (id ... g) ...) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(app + (-> (app (app id f) 3) <-) (app (app id g) 4))
 (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app <= (-> n <-) 1) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(match (app <= n 1) (#f) (_ (-> 1 <-))) (flatenv '()))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list
 'query:
 '(app + (app (app id f) 3) (-> (app (app id g) 4) <-))
 (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> g <-) (app - n 1)) (flatenv '()))
(list
 'clos/con:
 (list
  (list '(letrec (... f (g (-> (λ (n) ...) <-)) () ...) ...) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (app id g) (-> 4 <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (4 ⊥ ⊥ ⊥))

(list 'query: '(app (-> id <-) f) (flatenv '()))
(list
 'clos/con:
 (list
  (list '(letrec (... () (id (-> (λ (x) ...) <-)) f ...) ...) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... () (id (-> (λ (x) ...) <-)) f ...) ...)
 (flatenv '()))
(list
 'clos/con:
 (list
  (list '(letrec (... () (id (-> (λ (x) ...) <-)) f ...) ...) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app * (-> n <-) (app f (app - n 1))) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app <= n (-> 1 <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list 'query: '(λ (n) (-> (match (app <= n 1) ...) <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> - <-) n 1) (flatenv '()))
'(clos/con: (#<procedure:do-sub>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app <= n (-> 1 <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list 'query: '(match (-> (app <= n 1) <-) (#f) _) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> <= <-) n 1) (flatenv '()))
'(clos/con: (#<procedure:do-lte>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(match (app <= n 1) ((#f) (-> (app * n (app g (app - n 1))) <-)) _)
 (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app <= (-> n <-) 1) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (id ... g) (-> (app + (app (app id f) 3) (app (app id g) 4)) <-))
 (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app * n (-> (app f (app - n 1)) <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(match (app <= n 1) ((#f) (-> (app * n (app f (app - n 1))) <-)) _)
 (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app f (-> (app - n 1) <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> * <-) n (app g (app - n 1))) (flatenv '()))
'(clos/con: (#<procedure:do-mult>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> (app id g) <-) 4) (flatenv '()))
(list
 'clos/con:
 (list
  (list '(letrec (... f (g (-> (λ (n) ...) <-)) () ...) ...) (flatenv '()))
  (list '(letrec (... id (f (-> (λ (n) ...) <-)) g ...) ...) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> <= <-) n 1) (flatenv '()))
'(clos/con: (#<procedure:do-lte>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> - <-) n 1) (flatenv '()))
'(clos/con: (#<procedure:do-sub>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... id (f (-> (λ (n) ...) <-)) g ...) ...)
 (flatenv '()))
(list
 'clos/con:
 (list
  (list '(letrec (... id (f (-> (λ (n) ...) <-)) g ...) ...) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app - n (-> 1 <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))
