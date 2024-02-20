'(expression:
  (letrec ((cpstak
            (λ (x y z)
              (letrec ((tak
                        (λ (x y z k)
                          (match
                           (app not (app < y x))
                           ((#f)
                            (app
                             tak
                             (app - x 1)
                             y
                             z
                             (λ (v1)
                               (app
                                tak
                                (app - y 1)
                                z
                                x
                                (λ (v2)
                                  (app
                                   tak
                                   (app - z 1)
                                   x
                                   y
                                   (λ (v3) (app tak v1 v2 v3 k))))))))
                           (_ (app k z))))))
                (app tak x y z (λ (a) a))))))
    (app cpstak 32 15 8)))

(list
 'query:
 '(app tak (app - y 1) (-> z <-) x (λ (v2) ...))
 (expenv '(() () ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app < y (-> x <-)) (expenv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (tak) (-> (app tak x y z (λ (a) ...)) <-))
 (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app - z (-> 1 <-)) (expenv '(() () () ())))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list 'query: '(app (-> tak <-) x y z (λ (a) ...)) (expenv '(())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...)
   (expenv '(())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app cpstak 32 (-> 15 <-) 8) (expenv '()))
'(clos/con: ⊥)
'(literals: (15 ⊥ ⊥ ⊥))

(list 'query: '(app cpstak (-> 32 <-) 15 8) (expenv '()))
'(clos/con: ⊥)
'(literals: (32 ⊥ ⊥ ⊥))

(list
 'query:
 '(match (app not (app < y x)) (#f) (_ (-> (app k z) <-)))
 (expenv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (v2) (-> (app tak (app - z 1) x y (λ (v3) ...)) <-))
 (expenv '(() () () ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app not (-> (app < y x) <-)) (expenv '(() ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app tak (-> x <-) y z (λ (a) ...)) (expenv '(())))
'(clos/con: ⊥)
'(literals: (32 ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (x y z k) (-> (match (app not (app < y x)) ...) <-))
 (expenv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(app tak (app - z 1) x (-> y <-) (λ (v3) ...))
 (expenv '(() () () ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> tak <-) v1 v2 v3 k) (expenv '(() () () () ())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...)
   (expenv '(())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app tak (app - y 1) z x (-> (λ (v2) ...) <-))
 (expenv '(() () ())))
(list
 'clos/con:
 (list
  (list '(app tak (app - y 1) z x (-> (λ (v2) ...) <-)) (expenv '(() () ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> tak <-) (app - y 1) z x (λ (v2) ...))
 (expenv '(() () ())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...)
   (expenv '(())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> - <-) z 1) (expenv '(() () () ())))
'(clos/con: (#<procedure:do-sub>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app < (-> y <-) x) (expenv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app - (-> y <-) 1) (expenv '(() () ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...)
 (expenv '(())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...)
   (expenv '(())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(letrec (cpstak) (-> (app cpstak 32 15 8) <-)) (expenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(match
   (app not (app < y x))
   ((#f) (-> (app tak (app - x 1) y z (λ (v1) ...)) <-))
   _)
 (expenv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app cpstak 32 15 (-> 8 <-)) (expenv '()))
'(clos/con: ⊥)
'(literals: (8 ⊥ ⊥ ⊥))

(list 'query: '(app (-> cpstak <-) 32 15 8) (expenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (cpstak (-> (λ (x y z) ...) <-)) () ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... () (cpstak (-> (λ (x y z) ...) <-)) () ...) ...)
 (expenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (cpstak (-> (λ (x y z) ...) <-)) () ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app tak (-> v1 <-) v2 v3 k) (expenv '(() () () () ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(app tak (app - y 1) z (-> x <-) (λ (v2) ...))
 (expenv '(() () ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app tak x y z (-> (λ (a) ...) <-)) (expenv '(())))
(list
 'clos/con:
 (list (list '(app tak x y z (-> (λ (a) ...) <-)) (expenv '(())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app - (-> x <-) 1) (expenv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(app tak (app - x 1) y z (-> (λ (v1) ...) <-))
 (expenv '(() ())))
(list
 'clos/con:
 (list
  (list '(app tak (app - x 1) y z (-> (λ (v1) ...) <-)) (expenv '(() ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> < <-) y x) (expenv '(() ())))
'(clos/con: (#<procedure:do-lt>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app tak (app - z 1) x y (-> (λ (v3) ...) <-))
 (expenv '(() () () ())))
(list
 'clos/con:
 (list
  (list
   '(app tak (app - z 1) x y (-> (λ (v3) ...) <-))
   (expenv '(() () () ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (v1) (-> (app tak (app - y 1) z x (λ (v2) ...)) <-))
 (expenv '(() () ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app - x (-> 1 <-)) (expenv '(() ())))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list 'query: '(app tak v1 v2 v3 (-> k <-)) (expenv '(() () () () ())))
(list
 'clos/con:
 (list
  (list
   '(app tak (app - z 1) x y (-> (λ (v3) ...) <-))
   (expenv '(() () () ())))
  (list '(app tak (app - x 1) y z (-> (λ (v1) ...) <-)) (expenv '(() ())))
  (list '(app tak x y z (-> (λ (a) ...) <-)) (expenv '(())))
  (list '(app tak (app - y 1) z x (-> (λ (v2) ...) <-)) (expenv '(() () ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app tak v1 (-> v2 <-) v3 k) (expenv '(() () () () ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app tak v1 v2 (-> v3 <-) k) (expenv '(() () () () ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(app tak (app - x 1) y (-> z <-) (λ (v1) ...))
 (expenv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(app tak (app - x 1) (-> y <-) z (λ (v1) ...))
 (expenv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(app tak (-> (app - y 1) <-) z x (λ (v2) ...))
 (expenv '(() () ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app k (-> z <-)) (expenv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> - <-) x 1) (expenv '(() ())))
'(clos/con: (#<procedure:do-sub>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app tak (-> (app - z 1) <-) x y (λ (v3) ...))
 (expenv '(() () () ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app tak x y (-> z <-) (λ (a) ...)) (expenv '(())))
'(clos/con: ⊥)
'(literals: (8 ⊥ ⊥ ⊥))

(list 'query: '(app tak x (-> y <-) z (λ (a) ...)) (expenv '(())))
'(clos/con: ⊥)
'(literals: (15 ⊥ ⊥ ⊥))

(list 'query: '(app - y (-> 1 <-)) (expenv '(() () ())))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list 'query: '(λ (a) (-> a <-)) (expenv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> - <-) y 1) (expenv '(() () ())))
'(clos/con: (#<procedure:do-sub>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(match (-> (app not (app < y x)) <-) (#f) _) (expenv '(() ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> tak <-) (app - z 1) x y (λ (v3) ...))
 (expenv '(() () () ())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...)
   (expenv '(())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app tak (-> (app - x 1) <-) y z (λ (v1) ...))
 (expenv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '((top) letrec (cpstak) ...) (expenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> not <-) (app < y x)) (expenv '(() ())))
'(clos/con: (#<procedure:do-not>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> tak <-) (app - x 1) y z (λ (v1) ...))
 (expenv '(() ())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...)
   (expenv '(())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app - (-> z <-) 1) (expenv '(() () () ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (v3) (-> (app tak v1 v2 v3 k) <-))
 (expenv '(() () () () ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(λ (x y z) (-> (letrec (tak) ...) <-)) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(app tak (app - z 1) (-> x <-) y (λ (v3) ...))
 (expenv '(() () () ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> k <-) z) (expenv '(() ())))
(list
 'clos/con:
 (list
  (list
   '(app tak (app - z 1) x y (-> (λ (v3) ...) <-))
   (expenv '(() () () ())))
  (list '(app tak (app - x 1) y z (-> (λ (v1) ...) <-)) (expenv '(() ())))
  (list '(app tak x y z (-> (λ (a) ...) <-)) (expenv '(())))
  (list '(app tak (app - y 1) z x (-> (λ (v2) ...) <-)) (expenv '(() () ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))
