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
 (expenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (lp1 (-> (λ (i x) ...) <-)) () ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(match (app = 0 i) (#f) (_ (-> x <-))) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app = 0 (-> i <-)) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> lp2 <-) 10 (λ (n) ...) x) (expenv '(())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (lp2 (-> (λ (j f y) ...) <-)) () ...) ...)
   (expenv '(())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(match (-> (app = 0 i) <-) (#f) _) (expenv '(())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app lp1 10 (-> 0 <-)) (expenv '()))
'(clos/con: ⊥)
'(literals: (0 ⊥ ⊥ ⊥))

(list 'query: '(λ (i x) (-> (match (app = 0 i) ...) <-)) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app + n (-> i <-)) (expenv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> - <-) i 1) (expenv '(() ())))
'(clos/con: (#<procedure:do-sub>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app lp2 (-> (app - j 1) <-) f (app f y)) (expenv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app lp2 10 (-> (λ (n) ...) <-) x) (expenv '(())))
(list
 'clos/con:
 (list (list '(app lp2 10 (-> (λ (n) ...) <-) x) (expenv '(())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (lp2) (-> (app lp2 10 (λ (n) ...) x) <-))
 (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app lp2 (-> 10 <-) (λ (n) ...) x) (expenv '(())))
'(clos/con: ⊥)
'(literals: (10 ⊥ ⊥ ⊥))

(list 'query: '(app - (-> i <-) 1) (expenv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app = 0 (-> j <-)) (expenv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> lp1 <-) (app - i 1) y) (expenv '(() ())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (lp1 (-> (λ (i x) ...) <-)) () ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app f (-> y <-)) (expenv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app - (-> j <-) 1) (expenv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> = <-) 0 i) (expenv '(())))
'(clos/con: (#<procedure:do-equal>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(match (-> (app = 0 j) <-) (#f) _) (expenv '(() ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... () (lp2 (-> (λ (j f y) ...) <-)) () ...) ...)
 (expenv '(())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (lp2 (-> (λ (j f y) ...) <-)) () ...) ...)
   (expenv '(())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))
 (expenv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> - <-) j 1) (expenv '(() ())))
'(clos/con: (#<procedure:do-sub>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app = (-> 0 <-) i) (expenv '(())))
'(clos/con: ⊥)
'(literals: (0 ⊥ ⊥ ⊥))

(list 'query: '(app lp2 10 (λ (n) ...) (-> x <-)) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(λ (n) (-> (app + n i) <-)) (expenv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '((top) letrec (lp1) ...) (expenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app lp1 (-> 10 <-) 0) (expenv '()))
'(clos/con: ⊥)
'(literals: (10 ⊥ ⊥ ⊥))

(list
 'query:
 '(match (app = 0 i) ((#f) (-> (letrec (lp2) ...) <-)) _)
 (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> = <-) 0 j) (expenv '(() ())))
'(clos/con: (#<procedure:do-equal>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> + <-) n i) (expenv '(() ())))
'(clos/con: (#<procedure:do-add>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (j f y) (-> (match (app = 0 j) ...) <-)) (expenv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app lp1 (app - i 1) (-> y <-)) (expenv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app - j (-> 1 <-)) (expenv '(() ())))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list 'query: '(app (-> lp1 <-) 10 0) (expenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (lp1 (-> (λ (i x) ...) <-)) () ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(letrec (lp1) (-> (app lp1 10 0) <-)) (expenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> lp2 <-) (app - j 1) f (app f y)) (expenv '(() ())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (lp2 (-> (λ (j f y) ...) <-)) () ...) ...)
   (expenv '(())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app lp2 (app - j 1) (-> f <-) (app f y)) (expenv '(() ())))
(list
 'clos/con:
 (list (list '(app lp2 10 (-> (λ (n) ...) <-) x) (expenv '(())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app lp1 (-> (app - i 1) <-) y) (expenv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app - i (-> 1 <-)) (expenv '(() ())))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list 'query: '(app = (-> 0 <-) j) (expenv '(() ())))
'(clos/con: ⊥)
'(literals: (0 ⊥ ⊥ ⊥))

(list 'query: '(app (-> f <-) y) (expenv '(() ())))
(list
 'clos/con:
 (list (list '(app lp2 10 (-> (λ (n) ...) <-) x) (expenv '(())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app lp2 (app - j 1) f (-> (app f y) <-)) (expenv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app + (-> n <-) i) (expenv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(match (app = 0 j) ((#f) (-> (app lp2 (app - j 1) f (app f y)) <-)) _)
 (expenv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))
