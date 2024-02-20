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

(list 'query: '((top) letrec (lp1) ...) (menv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... () (lp1 (-> (λ (i x) ...) <-)) () ...) ...)
 (menv '()))
(list
 'clos/con:
 (list
  (list '(letrec (... () (lp1 (-> (λ (i x) ...) <-)) () ...) ...) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (i x) (-> (match (app = 0 i) ...) <-)) (menv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(match (app = 0 i) (#f) (_ (-> x <-))) (menv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(match (app = 0 i) ((#f) (-> (letrec (lp2) ...) <-)) _)
 (menv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... () (lp2 (-> (λ (j f y) ...) <-)) () ...) ...)
 (menv '(())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (lp2 (-> (λ (j f y) ...) <-)) () ...) ...)
   (menv '(())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (j f y) (-> (match (app = 0 j) ...) <-)) (menv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))
 (menv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app lp1 (app - i 1) (-> y <-)) (menv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app lp1 (-> (app - i 1) <-) y) (menv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app - i (-> 1 <-)) (menv '(() ())))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list 'query: '(app - (-> i <-) 1) (menv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> - <-) i 1) (menv '(() ())))
'(clos/con: (#<procedure:do-sub>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> lp1 <-) (app - i 1) y) (menv '(() ())))
(list
 'clos/con:
 (list
  (list '(letrec (... () (lp1 (-> (λ (i x) ...) <-)) () ...) ...) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(match (app = 0 j) ((#f) (-> (app lp2 (app - j 1) f (app f y)) <-)) _)
 (menv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app lp2 (app - j 1) f (-> (app f y) <-)) (menv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app f (-> y <-)) (menv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> f <-) y) (menv '(() ())))
(list
 'clos/con:
 (list (list '(app lp2 10 (-> (λ (n) ...) <-) x) (menv '(())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app lp2 (app - j 1) (-> f <-) (app f y)) (menv '(() ())))
(list
 'clos/con:
 (list (list '(app lp2 10 (-> (λ (n) ...) <-) x) (menv '(())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app lp2 (-> (app - j 1) <-) f (app f y)) (menv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app - j (-> 1 <-)) (menv '(() ())))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list 'query: '(app - (-> j <-) 1) (menv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> - <-) j 1) (menv '(() ())))
'(clos/con: (#<procedure:do-sub>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> lp2 <-) (app - j 1) f (app f y)) (menv '(() ())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (lp2 (-> (λ (j f y) ...) <-)) () ...) ...)
   (menv '(())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(match (-> (app = 0 j) <-) (#f) _) (menv '(() ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app = 0 (-> j <-)) (menv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app = (-> 0 <-) j) (menv '(() ())))
'(clos/con: ⊥)
'(literals: (0 ⊥ ⊥ ⊥))

(list 'query: '(app (-> = <-) 0 j) (menv '(() ())))
'(clos/con: (#<procedure:do-demand-equal>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(letrec (lp2) (-> (app lp2 10 (λ (n) ...) x) <-)) (menv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app lp2 10 (λ (n) ...) (-> x <-)) (menv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app lp2 10 (-> (λ (n) ...) <-) x) (menv '(())))
(list
 'clos/con:
 (list (list '(app lp2 10 (-> (λ (n) ...) <-) x) (menv '(())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (n) (-> (app + n i) <-)) (menv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app + n (-> i <-)) (menv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app + (-> n <-) i) (menv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> + <-) n i) (menv '(() ())))
'(clos/con: (#<procedure:do-add>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app lp2 (-> 10 <-) (λ (n) ...) x) (menv '(())))
'(clos/con: ⊥)
'(literals: (10 ⊥ ⊥ ⊥))

(list 'query: '(app (-> lp2 <-) 10 (λ (n) ...) x) (menv '(())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (lp2 (-> (λ (j f y) ...) <-)) () ...) ...)
   (menv '(())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(match (-> (app = 0 i) <-) (#f) _) (menv '(())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app = 0 (-> i <-)) (menv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app = (-> 0 <-) i) (menv '(())))
'(clos/con: ⊥)
'(literals: (0 ⊥ ⊥ ⊥))

(list 'query: '(app (-> = <-) 0 i) (menv '(())))
'(clos/con: (#<procedure:do-demand-equal>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(letrec (lp1) (-> (app lp1 10 0) <-)) (menv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app lp1 10 (-> 0 <-)) (menv '()))
'(clos/con: ⊥)
'(literals: (0 ⊥ ⊥ ⊥))

(list 'query: '(app lp1 (-> 10 <-) 0) (menv '()))
'(clos/con: ⊥)
'(literals: (10 ⊥ ⊥ ⊥))

(list 'query: '(app (-> lp1 <-) 10 0) (menv '()))
(list
 'clos/con:
 (list
  (list '(letrec (... () (lp1 (-> (λ (i x) ...) <-)) () ...) ...) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))
