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
 '(letrec (tak) (-> (app tak x y z (λ (a) ...)) <-))
 (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app - z (-> 1 <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list 'query: '(app k (-> z <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app not (-> (app < y x) <-)) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app cpstak (-> 32 <-) 15 8) (flatenv '()))
'(clos/con: ⊥)
'(literals: (32 ⊥ ⊥ ⊥))

(list 'query: '(app - (-> y <-) 1) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app tak (app - y 1) z x (-> (λ (v2) ...) <-)) (flatenv '()))
(list
 'clos/con:
 (list (list '(app tak (app - y 1) z x (-> (λ (v2) ...) <-)) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> k <-) z) (flatenv '()))
(list
 'clos/con:
 (list
  (list '(app tak x y z (-> (λ (a) ...) <-)) (flatenv '()))
  (list '(app tak (app - y 1) z x (-> (λ (v2) ...) <-)) (flatenv '()))
  (list '(app tak (app - z 1) x y (-> (λ (v3) ...) <-)) (flatenv '()))
  (list '(app tak (app - x 1) y z (-> (λ (v1) ...) <-)) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app cpstak 32 (-> 15 <-) 8) (flatenv '()))
'(clos/con: ⊥)
'(literals: (15 ⊥ ⊥ ⊥))

(list 'query: '(app tak (app - x 1) (-> y <-) z (λ (v1) ...)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app tak x y z (-> (λ (a) ...) <-)) (flatenv '()))
(list
 'clos/con:
 (list (list '(app tak x y z (-> (λ (a) ...) <-)) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> < <-) y x) (flatenv '()))
'(clos/con: (#<procedure:do-lt>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(match
   (app not (app < y x))
   ((#f) (-> (app tak (app - x 1) y z (λ (v1) ...)) <-))
   _)
 (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app tak x y (-> z <-) (λ (a) ...)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (v1) (-> (app tak (app - y 1) z x (λ (v2) ...)) <-))
 (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app tak (-> v1 <-) v2 v3 k) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> not <-) (app < y x)) (flatenv '()))
'(clos/con: (#<procedure:do-not>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app - y (-> 1 <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list 'query: '(λ (x y z) (-> (letrec (tak) ...) <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(letrec (cpstak) (-> (app cpstak 32 15 8) <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app tak (app - y 1) (-> z <-) x (λ (v2) ...)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app tak v1 v2 (-> v3 <-) k) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app cpstak 32 15 (-> 8 <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (8 ⊥ ⊥ ⊥))

(list 'query: '(app (-> cpstak <-) 32 15 8) (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (cpstak (-> (λ (x y z) ...) <-)) () ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... () (cpstak (-> (λ (x y z) ...) <-)) () ...) ...)
 (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (cpstak (-> (λ (x y z) ...) <-)) () ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> - <-) z 1) (flatenv '()))
'(clos/con: (#<procedure:do-sub>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app tak (app - y 1) z (-> x <-) (λ (v2) ...)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> tak <-) (app - x 1) y z (λ (v1) ...)) (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(match (app not (app < y x)) (#f) (_ (-> (app k z) <-)))
 (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app tak (-> (app - x 1) <-) y z (λ (v1) ...)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(λ (a) (-> a <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app tak v1 (-> v2 <-) v3 k) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app tak (app - z 1) x y (-> (λ (v3) ...) <-)) (flatenv '()))
(list
 'clos/con:
 (list (list '(app tak (app - z 1) x y (-> (λ (v3) ...) <-)) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> tak <-) v1 v2 v3 k) (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app tak (app - z 1) x (-> y <-) (λ (v3) ...)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> - <-) y 1) (flatenv '()))
'(clos/con: (#<procedure:do-sub>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (x y z k) (-> (match (app not (app < y x)) ...) <-))
 (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app tak (app - x 1) y (-> z <-) (λ (v1) ...)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app - x (-> 1 <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list 'query: '(app < y (-> x <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app tak (-> x <-) y z (λ (a) ...)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> tak <-) x y z (λ (a) ...)) (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app tak (app - z 1) (-> x <-) y (λ (v3) ...)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app < (-> y <-) x) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app tak (-> (app - y 1) <-) z x (λ (v2) ...)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app - (-> z <-) 1) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app tak x (-> y <-) z (λ (a) ...)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(match (-> (app not (app < y x)) <-) (#f) _) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (v3) (-> (app tak v1 v2 v3 k) <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> tak <-) (app - z 1) x y (λ (v3) ...)) (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (v2) (-> (app tak (app - z 1) x y (λ (v3) ...)) <-))
 (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...)
 (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app tak v1 v2 v3 (-> k <-)) (flatenv '()))
(list
 'clos/con:
 (list
  (list '(app tak x y z (-> (λ (a) ...) <-)) (flatenv '()))
  (list '(app tak (app - y 1) z x (-> (λ (v2) ...) <-)) (flatenv '()))
  (list '(app tak (app - z 1) x y (-> (λ (v3) ...) <-)) (flatenv '()))
  (list '(app tak (app - x 1) y z (-> (λ (v1) ...) <-)) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app tak (-> (app - z 1) <-) x y (λ (v3) ...)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app - (-> x <-) 1) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app tak (app - x 1) y z (-> (λ (v1) ...) <-)) (flatenv '()))
(list
 'clos/con:
 (list (list '(app tak (app - x 1) y z (-> (λ (v1) ...) <-)) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '((top) letrec (cpstak) ...) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> - <-) x 1) (flatenv '()))
'(clos/con: (#<procedure:do-sub>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> tak <-) (app - y 1) z x (λ (v2) ...)) (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))
