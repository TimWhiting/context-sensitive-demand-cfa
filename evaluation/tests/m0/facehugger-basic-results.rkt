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

(list 'query: '((top) letrec (id ... g) ...) (menv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(letrec (... f (g (-> (λ (n) ...) <-)) () ...) ...) (menv '()))
(list
 'clos/con:
 (list (list '(letrec (... f (g (-> (λ (n) ...) <-)) () ...) ...) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (n) (-> (match (app <= n 1) ...) <-)) (menv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(match (app <= n 1) (#f) (_ (-> 1 <-))) (menv '(())))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list
 'query:
 '(match (app <= n 1) ((#f) (-> (app * n (app g (app - n 1))) <-)) _)
 (menv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app * n (-> (app g (app - n 1)) <-)) (menv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app g (-> (app - n 1) <-)) (menv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app - n (-> 1 <-)) (menv '(())))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list 'query: '(app - (-> n <-) 1) (menv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> - <-) n 1) (menv '(())))
'(clos/con: (#<procedure:do-sub>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> g <-) (app - n 1)) (menv '(())))
(list
 'clos/con:
 (list (list '(letrec (... f (g (-> (λ (n) ...) <-)) () ...) ...) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app * (-> n <-) (app g (app - n 1))) (menv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> * <-) n (app g (app - n 1))) (menv '(())))
'(clos/con: (#<procedure:do-mult>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(match (-> (app <= n 1) <-) (#f) _) (menv '(())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app <= n (-> 1 <-)) (menv '(())))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list 'query: '(app <= (-> n <-) 1) (menv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> <= <-) n 1) (menv '(())))
'(clos/con: (#<procedure:do-lte>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(letrec (... id (f (-> (λ (n) ...) <-)) g ...) ...) (menv '()))
(list
 'clos/con:
 (list (list '(letrec (... id (f (-> (λ (n) ...) <-)) g ...) ...) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (n) (-> (match (app <= n 1) ...) <-)) (menv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(match (app <= n 1) (#f) (_ (-> 1 <-))) (menv '(())))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list
 'query:
 '(match (app <= n 1) ((#f) (-> (app * n (app f (app - n 1))) <-)) _)
 (menv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app * n (-> (app f (app - n 1)) <-)) (menv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app f (-> (app - n 1) <-)) (menv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app - n (-> 1 <-)) (menv '(())))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list 'query: '(app - (-> n <-) 1) (menv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> - <-) n 1) (menv '(())))
'(clos/con: (#<procedure:do-sub>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> f <-) (app - n 1)) (menv '(())))
(list
 'clos/con:
 (list (list '(letrec (... id (f (-> (λ (n) ...) <-)) g ...) ...) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app * (-> n <-) (app f (app - n 1))) (menv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> * <-) n (app f (app - n 1))) (menv '(())))
'(clos/con: (#<procedure:do-mult>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(match (-> (app <= n 1) <-) (#f) _) (menv '(())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app <= n (-> 1 <-)) (menv '(())))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list 'query: '(app <= (-> n <-) 1) (menv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> <= <-) n 1) (menv '(())))
'(clos/con: (#<procedure:do-lte>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(letrec (... () (id (-> (λ (x) ...) <-)) f ...) ...) (menv '()))
(list
 'clos/con:
 (list
  (list '(letrec (... () (id (-> (λ (x) ...) <-)) f ...) ...) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (x) (-> x <-)) (menv '(())))
(list
 'clos/con:
 (list
  (list '(letrec (... f (g (-> (λ (n) ...) <-)) () ...) ...) (menv '()))
  (list '(letrec (... id (f (-> (λ (n) ...) <-)) g ...) ...) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (id ... g) (-> (app + (app (app id f) 3) (app (app id g) 4)) <-))
 (menv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(app + (app (app id f) 3) (-> (app (app id g) 4) <-))
 (menv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (app id g) (-> 4 <-)) (menv '()))
'(clos/con: ⊥)
'(literals: (4 ⊥ ⊥ ⊥))

(list 'query: '(app (-> (app id g) <-) 4) (menv '()))
(list
 'clos/con:
 (list
  (list '(letrec (... f (g (-> (λ (n) ...) <-)) () ...) ...) (menv '()))
  (list '(letrec (... id (f (-> (λ (n) ...) <-)) g ...) ...) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app id (-> g <-)) (menv '()))
(list
 'clos/con:
 (list (list '(letrec (... f (g (-> (λ (n) ...) <-)) () ...) ...) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> id <-) g) (menv '()))
(list
 'clos/con:
 (list
  (list '(letrec (... () (id (-> (λ (x) ...) <-)) f ...) ...) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app + (-> (app (app id f) 3) <-) (app (app id g) 4))
 (menv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (app id f) (-> 3 <-)) (menv '()))
'(clos/con: ⊥)
'(literals: (3 ⊥ ⊥ ⊥))

(list 'query: '(app (-> (app id f) <-) 3) (menv '()))
(list
 'clos/con:
 (list
  (list '(letrec (... f (g (-> (λ (n) ...) <-)) () ...) ...) (menv '()))
  (list '(letrec (... id (f (-> (λ (n) ...) <-)) g ...) ...) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app id (-> f <-)) (menv '()))
(list
 'clos/con:
 (list (list '(letrec (... id (f (-> (λ (n) ...) <-)) g ...) ...) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> id <-) f) (menv '()))
(list
 'clos/con:
 (list
  (list '(letrec (... () (id (-> (λ (x) ...) <-)) f ...) ...) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> + <-) (app (app id f) 3) (app (app id g) 4))
 (menv '()))
'(clos/con: (#<procedure:do-add>))
'(literals: (⊥ ⊥ ⊥ ⊥))
