'(expression:
  (letrec ((id (λ (x) x))
           (blur (λ (y) y))
           (lp
            (λ (a n)
              (match
               (app <= n 1)
               ((#f)
                (let* ((r (app (app blur id) (app #t)))
                       (s (app (app blur id) (app #f))))
                  (app not (app (app blur lp) s (app - n 1)))))
               (_ (app id a))))))
    (app lp (app #f) 2)))

(list 'query: '(app (app blur id) (-> (app #f) <-)) (flatenv '()))
(list 'clos/con: (list (list '(con #f) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> blur <-) id) (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... id (blur (-> (λ (y) ...) <-)) lp ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> #f <-)) (flatenv '()))
(list 'clos/con: (list (list '((top) . #f) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> lp <-) (app #f) 2) (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app <= n (-> 1 <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list
 'query:
 '(app not (-> (app (app blur lp) s (app - n 1)) <-))
 (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (a n) (-> (match (app <= n 1) ...) <-)) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app - n (-> 1 <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list 'query: '(app (-> (app blur id) <-) (app #t)) (flatenv '()))
(list
 'clos/con:
 (list
  (list '(letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (flatenv '()))
  (list
   '(letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '((top) letrec (id ... lp) ...) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> #t <-)) (flatenv '()))
(list 'clos/con: (list (list '((top) . #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(let* (... () (r (-> (app (app blur id) (app #t)) <-)) s ...) ...)
 (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(letrec (id ... lp) (-> (app lp (app #f) 2) <-)) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(match (app <= n 1) (#f) (_ (-> (app id a) <-))) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> id <-) a) (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (y) (-> y <-)) (flatenv '()))
(list
 'clos/con:
 (list
  (list '(letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (flatenv '()))
  (list
   '(letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app id (-> a <-)) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> blur <-) id) (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... id (blur (-> (λ (y) ...) <-)) lp ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...)
 (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app blur (-> id <-)) (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app blur (-> id <-)) (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> - <-) n 1) (flatenv '()))
'(clos/con: (#<procedure:do-sub>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(match (app <= n 1) ((#f) (-> (let* (r ... s) ...) <-)) _)
 (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> blur <-) lp) (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... id (blur (-> (λ (y) ...) <-)) lp ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (app blur lp) s (-> (app - n 1) <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...)
 (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(let* (r ... s) (-> (app not (app (app blur lp) s (app - n 1))) <-))
 (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(let* (... r (s (-> (app (app blur id) (app #f)) <-)) () ...) ...)
 (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> <= <-) n 1) (flatenv '()))
'(clos/con: (#<procedure:do-lte>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(match (-> (app <= n 1) <-) (#f) _) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (x) (-> x <-)) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app lp (app #f) (-> 2 <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (2 ⊥ ⊥ ⊥))

(list 'query: '(app blur (-> lp <-)) (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> #f <-)) (flatenv '()))
(list 'clos/con: (list (list '((top) . #f) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (app blur lp) (-> s <-) (app - n 1)) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... id (blur (-> (λ (y) ...) <-)) lp ...) ...)
 (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... id (blur (-> (λ (y) ...) <-)) lp ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app - (-> n <-) 1) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> not <-) (app (app blur lp) s (app - n 1)))
 (flatenv '()))
'(clos/con: (#<procedure:do-not>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app lp (-> (app #f) <-) 2) (flatenv '()))
(list 'clos/con: (list (list '(con #f) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app <= (-> n <-) 1) (flatenv '()))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (app blur id) (-> (app #t) <-)) (flatenv '()))
(list 'clos/con: (list (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> (app blur id) <-) (app #f)) (flatenv '()))
(list
 'clos/con:
 (list
  (list '(letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (flatenv '()))
  (list
   '(letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> (app blur lp) <-) s (app - n 1)) (flatenv '()))
(list
 'clos/con:
 (list
  (list '(letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (flatenv '()))
  (list
   '(letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))
