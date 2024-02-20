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

(list 'query: '((top) letrec (cpstak) ...) (menv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... () (cpstak (-> (λ (x y z) ...) <-)) () ...) ...)
 (menv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (cpstak (-> (λ (x y z) ...) <-)) () ...) ...)
   (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (x y z) (-> (letrec (tak) ...) <-)) (menv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...)
 (menv '(())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...)
   (menv '(())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (x y z k) (-> (match (app not (app < y x)) ...) <-))
 (menv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(match (app not (app < y x)) (#f) (_ (-> (app k z) <-)))
 (menv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app k (-> z <-)) (menv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> k <-) z) (menv '(() ())))
(list
 'clos/con:
 (list
  (list '(app tak (app - z 1) x y (-> (λ (v3) ...) <-)) (menv '(() () () ())))
  (list '(app tak (app - x 1) y z (-> (λ (v1) ...) <-)) (menv '(() ())))
  (list '(app tak x y z (-> (λ (a) ...) <-)) (menv '(())))
  (list '(app tak (app - y 1) z x (-> (λ (v2) ...) <-)) (menv '(() () ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(match
   (app not (app < y x))
   ((#f) (-> (app tak (app - x 1) y z (λ (v1) ...)) <-))
   _)
 (menv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app tak (app - x 1) y z (-> (λ (v1) ...) <-)) (menv '(() ())))
(list
 'clos/con:
 (list (list '(app tak (app - x 1) y z (-> (λ (v1) ...) <-)) (menv '(() ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (v1) (-> (app tak (app - y 1) z x (λ (v2) ...)) <-))
 (menv '(() () ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(app tak (app - y 1) z x (-> (λ (v2) ...) <-))
 (menv '(() () ())))
(list
 'clos/con:
 (list
  (list '(app tak (app - y 1) z x (-> (λ (v2) ...) <-)) (menv '(() () ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (v2) (-> (app tak (app - z 1) x y (λ (v3) ...)) <-))
 (menv '(() () () ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(app tak (app - z 1) x y (-> (λ (v3) ...) <-))
 (menv '(() () () ())))
(list
 'clos/con:
 (list
  (list
   '(app tak (app - z 1) x y (-> (λ (v3) ...) <-))
   (menv '(() () () ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (v3) (-> (app tak v1 v2 v3 k) <-)) (menv '(() () () () ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app tak v1 v2 v3 (-> k <-)) (menv '(() () () () ())))
(list
 'clos/con:
 (list
  (list '(app tak (app - z 1) x y (-> (λ (v3) ...) <-)) (menv '(() () () ())))
  (list '(app tak (app - x 1) y z (-> (λ (v1) ...) <-)) (menv '(() ())))
  (list '(app tak x y z (-> (λ (a) ...) <-)) (menv '(())))
  (list '(app tak (app - y 1) z x (-> (λ (v2) ...) <-)) (menv '(() () ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app tak v1 v2 (-> v3 <-) k) (menv '(() () () () ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app tak v1 (-> v2 <-) v3 k) (menv '(() () () () ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app tak (-> v1 <-) v2 v3 k) (menv '(() () () () ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> tak <-) v1 v2 v3 k) (menv '(() () () () ())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...)
   (menv '(())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app tak (app - z 1) x (-> y <-) (λ (v3) ...))
 (menv '(() () () ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(app tak (app - z 1) (-> x <-) y (λ (v3) ...))
 (menv '(() () () ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(app tak (-> (app - z 1) <-) x y (λ (v3) ...))
 (menv '(() () () ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app - z (-> 1 <-)) (menv '(() () () ())))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list 'query: '(app - (-> z <-) 1) (menv '(() () () ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> - <-) z 1) (menv '(() () () ())))
'(clos/con: (#<procedure:do-sub>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> tak <-) (app - z 1) x y (λ (v3) ...))
 (menv '(() () () ())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...)
   (menv '(())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app tak (app - y 1) z (-> x <-) (λ (v2) ...))
 (menv '(() () ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(app tak (app - y 1) (-> z <-) x (λ (v2) ...))
 (menv '(() () ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(app tak (-> (app - y 1) <-) z x (λ (v2) ...))
 (menv '(() () ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app - y (-> 1 <-)) (menv '(() () ())))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list 'query: '(app - (-> y <-) 1) (menv '(() () ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> - <-) y 1) (menv '(() () ())))
'(clos/con: (#<procedure:do-sub>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> tak <-) (app - y 1) z x (λ (v2) ...))
 (menv '(() () ())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...)
   (menv '(())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app tak (app - x 1) y (-> z <-) (λ (v1) ...)) (menv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app tak (app - x 1) (-> y <-) z (λ (v1) ...)) (menv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app tak (-> (app - x 1) <-) y z (λ (v1) ...)) (menv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app - x (-> 1 <-)) (menv '(() ())))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list 'query: '(app - (-> x <-) 1) (menv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> - <-) x 1) (menv '(() ())))
'(clos/con: (#<procedure:do-sub>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> tak <-) (app - x 1) y z (λ (v1) ...)) (menv '(() ())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...)
   (menv '(())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(match (-> (app not (app < y x)) <-) (#f) _) (menv '(() ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app not (-> (app < y x) <-)) (menv '(() ())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app < y (-> x <-)) (menv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app < (-> y <-) x) (menv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> < <-) y x) (menv '(() ())))
'(clos/con: (#<procedure:do-lt>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> not <-) (app < y x)) (menv '(() ())))
'(clos/con: (#<procedure:do-demand-not>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(letrec (tak) (-> (app tak x y z (λ (a) ...)) <-)) (menv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app tak x y z (-> (λ (a) ...) <-)) (menv '(())))
(list
 'clos/con:
 (list (list '(app tak x y z (-> (λ (a) ...) <-)) (menv '(())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (a) (-> a <-)) (menv '(() ())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app tak x y (-> z <-) (λ (a) ...)) (menv '(())))
'(clos/con: ⊥)
'(literals: (8 ⊥ ⊥ ⊥))

(list 'query: '(app tak x (-> y <-) z (λ (a) ...)) (menv '(())))
'(clos/con: ⊥)
'(literals: (15 ⊥ ⊥ ⊥))

(list 'query: '(app tak (-> x <-) y z (λ (a) ...)) (menv '(())))
'(clos/con: ⊥)
'(literals: (32 ⊥ ⊥ ⊥))

(list 'query: '(app (-> tak <-) x y z (λ (a) ...)) (menv '(())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...)
   (menv '(())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(letrec (cpstak) (-> (app cpstak 32 15 8) <-)) (menv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app cpstak 32 15 (-> 8 <-)) (menv '()))
'(clos/con: ⊥)
'(literals: (8 ⊥ ⊥ ⊥))

(list 'query: '(app cpstak 32 (-> 15 <-) 8) (menv '()))
'(clos/con: ⊥)
'(literals: (15 ⊥ ⊥ ⊥))

(list 'query: '(app cpstak (-> 32 <-) 15 8) (menv '()))
'(clos/con: ⊥)
'(literals: (32 ⊥ ⊥ ⊥))

(list 'query: '(app (-> cpstak <-) 32 15 8) (menv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (cpstak (-> (λ (x y z) ...) <-)) () ...) ...)
   (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))
