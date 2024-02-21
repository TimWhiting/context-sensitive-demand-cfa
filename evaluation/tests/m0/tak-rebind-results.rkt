'(expression:
  (letrec ((tak
            (λ (x y z)
              (match
               (app not (app < y x))
               ((#f)
                (app
                 tak
                 (app tak (app - x 1) y z)
                 (app tak (app - y 1) z x)
                 (app tak (app - z 1) x y)))
               (_ z)))))
    (app tak 32 15 8)))

(list 'query: '(app not (-> (app < y x) <-)) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app
   tak
   (app tak (app - x 1) y z)
   (-> (app tak (app - y 1) z x) <-)
   (app tak (app - z 1) x y))
 (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> - <-) x 1) (flatenv '()))
'(clos/con: (#<procedure:do-sub>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app - y (-> 1 <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list 'query: '(app (-> tak <-) (app - x 1) y z) (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (tak (-> (λ (x y z) ...) <-)) () ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app
   (-> tak <-)
   (app tak (app - x 1) y z)
   (app tak (app - y 1) z x)
   (app tak (app - z 1) x y))
 (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (tak (-> (λ (x y z) ...) <-)) () ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app - (-> z <-) 1) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (x y z) (-> (match (app not (app < y x)) ...) <-))
 (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(match
   (app not (app < y x))
   ((#f)
    (->
     (app
      tak
      (app tak (app - x 1) y z)
      (app tak (app - y 1) z x)
      (app tak (app - z 1) x y))
     <-))
   _)
 (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> - <-) y 1) (flatenv '()))
'(clos/con: (#<procedure:do-sub>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> tak <-) (app - y 1) z x) (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (tak (-> (λ (x y z) ...) <-)) () ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '((top) letrec (tak) ...) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app tak (app - y 1) (-> z <-) x) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app < (-> y <-) x) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app tak (-> (app - y 1) <-) z x) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app tak (-> (app - z 1) <-) x y) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app tak (app - y 1) z (-> x <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> - <-) z 1) (flatenv '()))
'(clos/con: (#<procedure:do-sub>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... () (tak (-> (λ (x y z) ...) <-)) () ...) ...)
 (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (tak (-> (λ (x y z) ...) <-)) () ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app - x (-> 1 <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list 'query: '(app tak 32 15 (-> 8 <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (8 ⊥ ⊥ ⊥))

(list 'query: '(app < y (-> x <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app tak 32 (-> 15 <-) 8) (flatenv '()))
'(clos/con: ⊥)
'(literals: (15 ⊥ ⊥ ⊥))

(list 'query: '(app - (-> y <-) 1) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app - (-> x <-) 1) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> not <-) (app < y x)) (flatenv '()))
'(clos/con: (#<procedure:do-not>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app tak (-> (app - x 1) <-) y z) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app - z (-> 1 <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list 'query: '(match (-> (app not (app < y x)) <-) (#f) _) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app tak (-> 32 <-) 15 8) (flatenv '()))
'(clos/con: ⊥)
'(literals: (32 ⊥ ⊥ ⊥))

(list 'query: '(letrec (tak) (-> (app tak 32 15 8) <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(app
   tak
   (-> (app tak (app - x 1) y z) <-)
   (app tak (app - y 1) z x)
   (app tak (app - z 1) x y))
 (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> tak <-) (app - z 1) x y) (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (tak (-> (λ (x y z) ...) <-)) () ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app tak (app - x 1) y (-> z <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app tak (app - z 1) x (-> y <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(app
   tak
   (app tak (app - x 1) y z)
   (app tak (app - y 1) z x)
   (-> (app tak (app - z 1) x y) <-))
 (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> < <-) y x) (flatenv '()))
'(clos/con: (#<procedure:do-lt>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> tak <-) 32 15 8) (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (tak (-> (λ (x y z) ...) <-)) () ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app tak (app - x 1) (-> y <-) z) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app tak (app - z 1) (-> x <-) y) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(match (app not (app < y x)) (#f) (_ (-> z <-))) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))
