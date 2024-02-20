'(expression:
  (letrec ((lp1
            (λ (i x)
              (match
               (app = 0 i)
               ((#f)
                (letrec ((lp2
                          (λ (j f y)
                            (match
                             (app = 0 j)
                             ((#f) (app lp2 (app - j 1) f (app f y)))
                             (_ (app lp1 (app - i 1) y))))))
                  (app lp2 10 (λ (n) (app + n i)) x)))
               (_ x)))))
    (app lp1 10 0)))

(list
 'query:
 '(letrec (... () (lp1 (-> (λ (i x) ...) <-)) () ...) ...)
 (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (lp1 (-> (λ (i x) ...) <-)) () ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> lp1 <-) (app - i 1) y) (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (lp1 (-> (λ (i x) ...) <-)) () ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app lp1 10 (-> 0 <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (0 ⊥ ⊥ ⊥))

(list 'query: '(app f (-> y <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app lp2 10 (λ (n) ...) (-> x <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> = <-) 0 i) (flatenv '()))
'(clos/con: (#<procedure:do-equal>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app = (-> 0 <-) i) (flatenv '()))
'(clos/con: ⊥)
'(literals: (0 ⊥ ⊥ ⊥))

(list
 'query:
 '(match (app = 0 i) ((#f) (-> (letrec (lp2) ...) <-)) _)
 (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> - <-) i 1) (flatenv '()))
'(clos/con: (#<procedure:do-sub>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> = <-) 0 j) (flatenv '()))
'(clos/con: (#<procedure:do-equal>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app = (-> 0 <-) j) (flatenv '()))
'(clos/con: ⊥)
'(literals: (0 ⊥ ⊥ ⊥))

(list 'query: '(app = 0 (-> j <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app - (-> i <-) 1) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> lp2 <-) (app - j 1) f (app f y)) (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (lp2 (-> (λ (j f y) ...) <-)) () ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app lp2 (app - j 1) (-> f <-) (app f y)) (flatenv '()))
(list
 'clos/con:
 (list (list '(app lp2 10 (-> (λ (n) ...) <-) x) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app lp2 (-> 10 <-) (λ (n) ...) x) (flatenv '()))
'(clos/con: ⊥)
'(literals: (10 ⊥ ⊥ ⊥))

(list 'query: '(app lp1 (app - i 1) (-> y <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app lp2 (-> (app - j 1) <-) f (app f y)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app lp2 (app - j 1) f (-> (app f y) <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app + (-> n <-) i) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(match (app = 0 j) ((#f) (-> (app lp2 (app - j 1) f (app f y)) <-)) _)
 (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app - (-> j <-) 1) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '((top) letrec (lp1) ...) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app lp1 (-> 10 <-) 0) (flatenv '()))
'(clos/con: ⊥)
'(literals: (10 ⊥ ⊥ ⊥))

(list 'query: '(λ (i x) (-> (match (app = 0 i) ...) <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(match (-> (app = 0 i) <-) (#f) _) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> - <-) j 1) (flatenv '()))
'(clos/con: (#<procedure:do-sub>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(letrec (lp2) (-> (app lp2 10 (λ (n) ...) x) <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(letrec (lp1) (-> (app lp1 10 0) <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app lp1 (-> (app - i 1) <-) y) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> f <-) y) (flatenv '()))
(list
 'clos/con:
 (list (list '(app lp2 10 (-> (λ (n) ...) <-) x) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> lp1 <-) 10 0) (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (lp1 (-> (λ (i x) ...) <-)) () ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app lp2 10 (-> (λ (n) ...) <-) x) (flatenv '()))
(list
 'clos/con:
 (list (list '(app lp2 10 (-> (λ (n) ...) <-) x) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (j f y) (-> (match (app = 0 j) ...) <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> + <-) n i) (flatenv '()))
'(clos/con: (#<procedure:do-add>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... () (lp2 (-> (λ (j f y) ...) <-)) () ...) ...)
 (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (lp2 (-> (λ (j f y) ...) <-)) () ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(match (-> (app = 0 j) <-) (#f) _) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))
 (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> lp2 <-) 10 (λ (n) ...) x) (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (lp2 (-> (λ (j f y) ...) <-)) () ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app = 0 (-> i <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app - i (-> 1 <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list 'query: '(match (app = 0 i) (#f) (_ (-> x <-))) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(λ (n) (-> (app + n i) <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app + n (-> i <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app - j (-> 1 <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))
