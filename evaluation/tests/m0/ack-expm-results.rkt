'(expression:
  (letrec ((ack
            (λ (m n)
              (match
               (app = m 0)
               ((#f)
                (match
                 (app = n 0)
                 ((#f) (app ack (app - m 1) (app ack m (app - n 1))))
                 (_ (app ack (app - m 1) 1))))
               (_ (app + n 1))))))
    (app ack 3 12)))

(list
 'query:
 '(app ack (-> (app - m 1) <-) (app ack m (app - n 1)))
 (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app - m (-> 1 <-)) (expenv '(())))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list 'query: '((top) letrec (ack) ...) (expenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app - (-> m <-) 1) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> - <-) m 1) (expenv '(())))
'(clos/con: (#<procedure:do-sub>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(match
   (app = n 0)
   ((#f) (-> (app ack (app - m 1) (app ack m (app - n 1))) <-))
   _)
 (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app ack (-> (app - m 1) <-) 1) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app ack (-> 3 <-) 12) (expenv '()))
'(clos/con: ⊥)
'(literals: (3 ⊥ ⊥ ⊥))

(list 'query: '(match (app = m 0) (#f) (_ (-> (app + n 1) <-))) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app - n (-> 1 <-)) (expenv '(())))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list 'query: '(app (-> - <-) n 1) (expenv '(())))
'(clos/con: (#<procedure:do-sub>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app = (-> m <-) 0) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app ack 3 (-> 12 <-)) (expenv '()))
'(clos/con: ⊥)
'(literals: (12 ⊥ ⊥ ⊥))

(list 'query: '(app = (-> n <-) 0) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> ack <-) (app - m 1) (app ack m (app - n 1)))
 (expenv '(())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (ack (-> (λ (m n) ...) <-)) () ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app - m (-> 1 <-)) (expenv '(())))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list 'query: '(app = n (-> 0 <-)) (expenv '(())))
'(clos/con: ⊥)
'(literals: (0 ⊥ ⊥ ⊥))

(list 'query: '(match (-> (app = m 0) <-) (#f) _) (expenv '(())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app - (-> m <-) 1) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> + <-) n 1) (expenv '(())))
'(clos/con: (#<procedure:do-add>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(match (app = m 0) ((#f) (-> (match (app = n 0) ...) <-)) _)
 (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> = <-) n 0) (expenv '(())))
'(clos/con: (#<procedure:do-equal>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app ack m (-> (app - n 1) <-)) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(match (app = n 0) (#f) (_ (-> (app ack (app - m 1) 1) <-)))
 (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... () (ack (-> (λ (m n) ...) <-)) () ...) ...)
 (expenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (ack (-> (λ (m n) ...) <-)) () ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> = <-) m 0) (expenv '(())))
'(clos/con: (#<procedure:do-equal>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app ack (app - m 1) (-> (app ack m (app - n 1)) <-))
 (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app + (-> n <-) 1) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app ack (app - m 1) (-> 1 <-)) (expenv '(())))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list 'query: '(λ (m n) (-> (match (app = m 0) ...) <-)) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(letrec (ack) (-> (app ack 3 12) <-)) (expenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> - <-) m 1) (expenv '(())))
'(clos/con: (#<procedure:do-sub>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app = m (-> 0 <-)) (expenv '(())))
'(clos/con: ⊥)
'(literals: (0 ⊥ ⊥ ⊥))

(list 'query: '(match (-> (app = n 0) <-) (#f) _) (expenv '(())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app + n (-> 1 <-)) (expenv '(())))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list 'query: '(app ack (-> m <-) (app - n 1)) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> ack <-) m (app - n 1)) (expenv '(())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (ack (-> (λ (m n) ...) <-)) () ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> ack <-) (app - m 1) 1) (expenv '(())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (ack (-> (λ (m n) ...) <-)) () ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> ack <-) 3 12) (expenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (ack (-> (λ (m n) ...) <-)) () ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app - (-> n <-) 1) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))
