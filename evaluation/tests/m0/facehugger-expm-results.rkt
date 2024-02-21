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

(list 'query: '(λ (n) (-> (match (app <= n 1) ...) <-)) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> id <-) g) (expenv '()))
(list
 'clos/con:
 (list
  (list '(letrec (... () (id (-> (λ (x) ...) <-)) f ...) ...) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app id (-> f <-)) (expenv '()))
(list
 'clos/con:
 (list
  (list '(letrec (... id (f (-> (λ (n) ...) <-)) g ...) ...) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app * (-> n <-) (app g (app - n 1))) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (app id f) (-> 3 <-)) (expenv '()))
'(clos/con: ⊥)
'(literals: (3 ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> + <-) (app (app id f) 3) (app (app id g) 4))
 (expenv '()))
'(clos/con: (#<procedure:do-add>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> (app id f) <-) 3) (expenv '()))
(list
 'clos/con:
 (list
  (list '(letrec (... f (g (-> (λ (n) ...) <-)) () ...) ...) (expenv '()))
  (list '(letrec (... id (f (-> (λ (n) ...) <-)) g ...) ...) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app <= n (-> 1 <-)) (expenv '(())))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list 'query: '(app * n (-> (app g (app - n 1)) <-)) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> g <-) (app - n 1)) (expenv '(())))
(list
 'clos/con:
 (list
  (list '(letrec (... f (g (-> (λ (n) ...) <-)) () ...) ...) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... f (g (-> (λ (n) ...) <-)) () ...) ...)
 (expenv '()))
(list
 'clos/con:
 (list
  (list '(letrec (... f (g (-> (λ (n) ...) <-)) () ...) ...) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(match (app <= n 1) ((#f) (-> (app * n (app f (app - n 1))) <-)) _)
 (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> <= <-) n 1) (expenv '(())))
'(clos/con: (#<procedure:do-lte>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app <= n (-> 1 <-)) (expenv '(())))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list 'query: '(app id (-> g <-)) (expenv '()))
(list
 'clos/con:
 (list
  (list '(letrec (... f (g (-> (λ (n) ...) <-)) () ...) ...) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app * n (-> (app f (app - n 1)) <-)) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(λ (x) (-> x <-)) (expenv '(())))
(list
 'clos/con:
 (list
  (list '(letrec (... f (g (-> (λ (n) ...) <-)) () ...) ...) (expenv '()))
  (list '(letrec (... id (f (-> (λ (n) ...) <-)) g ...) ...) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> <= <-) n 1) (expenv '(())))
'(clos/con: (#<procedure:do-lte>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(match (-> (app <= n 1) <-) (#f) _) (expenv '(())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '((top) letrec (id ... g) ...) (expenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app - n (-> 1 <-)) (expenv '(())))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list 'query: '(app g (-> (app - n 1) <-)) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(app + (-> (app (app id f) 3) <-) (app (app id g) 4))
 (expenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> - <-) n 1) (expenv '(())))
'(clos/con: (#<procedure:do-sub>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app + (app (app id f) 3) (-> (app (app id g) 4) <-))
 (expenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app f (-> (app - n 1) <-)) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> id <-) f) (expenv '()))
(list
 'clos/con:
 (list
  (list '(letrec (... () (id (-> (λ (x) ...) <-)) f ...) ...) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... () (id (-> (λ (x) ...) <-)) f ...) ...)
 (expenv '()))
(list
 'clos/con:
 (list
  (list '(letrec (... () (id (-> (λ (x) ...) <-)) f ...) ...) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(match (app <= n 1) (#f) (_ (-> 1 <-))) (expenv '(())))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list 'query: '(app (app id g) (-> 4 <-)) (expenv '()))
'(clos/con: ⊥)
'(literals: (4 ⊥ ⊥ ⊥))

(list 'query: '(app - (-> n <-) 1) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app <= (-> n <-) 1) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app - (-> n <-) 1) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app - n (-> 1 <-)) (expenv '(())))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list 'query: '(app (-> * <-) n (app f (app - n 1))) (expenv '(())))
'(clos/con: (#<procedure:do-mult>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app * (-> n <-) (app f (app - n 1))) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> * <-) n (app g (app - n 1))) (expenv '(())))
'(clos/con: (#<procedure:do-mult>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (n) (-> (match (app <= n 1) ...) <-)) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> - <-) n 1) (expenv '(())))
'(clos/con: (#<procedure:do-sub>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (id ... g) (-> (app + (app (app id f) 3) (app (app id g) 4)) <-))
 (expenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> (app id g) <-) 4) (expenv '()))
(list
 'clos/con:
 (list
  (list '(letrec (... f (g (-> (λ (n) ...) <-)) () ...) ...) (expenv '()))
  (list '(letrec (... id (f (-> (λ (n) ...) <-)) g ...) ...) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> f <-) (app - n 1)) (expenv '(())))
(list
 'clos/con:
 (list
  (list '(letrec (... id (f (-> (λ (n) ...) <-)) g ...) ...) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(match (-> (app <= n 1) <-) (#f) _) (expenv '(())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app <= (-> n <-) 1) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... id (f (-> (λ (n) ...) <-)) g ...) ...)
 (expenv '()))
(list
 'clos/con:
 (list
  (list '(letrec (... id (f (-> (λ (n) ...) <-)) g ...) ...) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(match (app <= n 1) (#f) (_ (-> 1 <-))) (expenv '(())))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list
 'query:
 '(match (app <= n 1) ((#f) (-> (app * n (app g (app - n 1))) <-)) _)
 (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))
