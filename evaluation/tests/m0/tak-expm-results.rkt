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

(list 'query: '(app tak (app - z 1) (-> x <-) y) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app tak (-> (app - z 1) <-) x y) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app tak (-> (app - x 1) <-) y z) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app - (-> y <-) 1) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(match (app not (app < y x)) (#f) (_ (-> z <-))) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app tak (app - z 1) x (-> y <-)) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app tak (app - y 1) z (-> x <-)) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app < y (-> x <-)) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app - (-> x <-) 1) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '((top) letrec (tak) ...) (expenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(app
   tak
   (app tak (app - x 1) y z)
   (app tak (app - y 1) z x)
   (-> (app tak (app - z 1) x y) <-))
 (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app - z (-> 1 <-)) (expenv '(())))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list 'query: '(app tak (app - x 1) (-> y <-) z) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app not (-> (app < y x) <-)) (expenv '(())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> tak <-) (app - y 1) z x) (expenv '(())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (tak (-> (λ (x y z) ...) <-)) () ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> < <-) y x) (expenv '(())))
'(clos/con: (#<procedure:do-lt>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app
   tak
   (app tak (app - x 1) y z)
   (-> (app tak (app - y 1) z x) <-)
   (app tak (app - z 1) x y))
 (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(app
   tak
   (-> (app tak (app - x 1) y z) <-)
   (app tak (app - y 1) z x)
   (app tak (app - z 1) x y))
 (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> tak <-) (app - z 1) x y) (expenv '(())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (tak (-> (λ (x y z) ...) <-)) () ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app - y (-> 1 <-)) (expenv '(())))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list 'query: '(app (-> tak <-) (app - x 1) y z) (expenv '(())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (tak (-> (λ (x y z) ...) <-)) () ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (x y z) (-> (match (app not (app < y x)) ...) <-))
 (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app tak (app - x 1) y (-> z <-)) (expenv '(())))
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
 (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... () (tak (-> (λ (x y z) ...) <-)) () ...) ...)
 (expenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (tak (-> (λ (x y z) ...) <-)) () ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app tak 32 15 (-> 8 <-)) (expenv '()))
'(clos/con: ⊥)
'(literals: (8 ⊥ ⊥ ⊥))

(list 'query: '(app tak 32 (-> 15 <-) 8) (expenv '()))
'(clos/con: ⊥)
'(literals: (15 ⊥ ⊥ ⊥))

(list 'query: '(app (-> - <-) y 1) (expenv '(())))
'(clos/con: (#<procedure:do-sub>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> - <-) x 1) (expenv '(())))
'(clos/con: (#<procedure:do-sub>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app
   (-> tak <-)
   (app tak (app - x 1) y z)
   (app tak (app - y 1) z x)
   (app tak (app - z 1) x y))
 (expenv '(())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (tak (-> (λ (x y z) ...) <-)) () ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app - (-> z <-) 1) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(match (-> (app not (app < y x)) <-) (#f) _) (expenv '(())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(letrec (tak) (-> (app tak 32 15 8) <-)) (expenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app tak (-> 32 <-) 15 8) (expenv '()))
'(clos/con: ⊥)
'(literals: (32 ⊥ ⊥ ⊥))

(list 'query: '(app (-> - <-) z 1) (expenv '(())))
'(clos/con: (#<procedure:do-sub>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app - x (-> 1 <-)) (expenv '(())))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list 'query: '(app tak (app - y 1) (-> z <-) x) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> not <-) (app < y x)) (expenv '(())))
'(clos/con: (#<procedure:do-not>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app tak (-> (app - y 1) <-) z x) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> tak <-) 32 15 8) (expenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (tak (-> (λ (x y z) ...) <-)) () ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app < (-> y <-) x) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))
