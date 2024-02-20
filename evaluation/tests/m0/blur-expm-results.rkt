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

(list 'query: '(λ (y) (-> y <-)) (expenv '(())))
(list
 'clos/con:
 (list
  (list '(letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (expenv '()))
  (list
   '(letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app <= n (-> 1 <-)) (expenv '(())))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list 'query: '(app (app blur lp) (-> s <-) (app - n 1)) (expenv '(())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> lp <-) (app #f) 2) (expenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (app blur lp) s (-> (app - n 1) <-)) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '((top) letrec (id ... lp) ...) (expenv '()))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (app blur id) (-> (app #t) <-)) (expenv '(())))
(list 'clos/con: (list (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> <= <-) n 1) (expenv '(())))
'(clos/con: (#<procedure:do-lte>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(letrec (id ... lp) (-> (app lp (app #f) 2) <-)) (expenv '()))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app blur (-> lp <-)) (expenv '(())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(match (-> (app <= n 1) <-) (#f) _) (expenv '(())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (app blur id) (-> (app #f) <-)) (expenv '(())))
(list 'clos/con: (list (list '(con #f) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(let* (r ... s) (-> (app not (app (app blur lp) s (app - n 1))) <-))
 (expenv '(())))
(list 'clos/con: (list (list '(con #f) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(match (app <= n 1) ((#f) (-> (let* (r ... s) ...) <-)) _)
 (expenv '(())))
(list 'clos/con: (list (list '(con #f) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> #f <-)) (expenv '(())))
(list 'clos/con: (list (list '((top) . #f) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app - (-> n <-) 1) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...)
 (expenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> not <-) (app (app blur lp) s (app - n 1)))
 (expenv '(())))
'(clos/con: (#<procedure:do-not>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(let* (... () (r (-> (app (app blur id) (app #t)) <-)) s ...) ...)
 (expenv '(())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app - n (-> 1 <-)) (expenv '(())))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...)
 (expenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app <= (-> n <-) 1) (expenv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app id (-> a <-)) (expenv '(())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (a n) (-> (match (app <= n 1) ...) <-)) (expenv '(())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> id <-) a) (expenv '(())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> blur <-) lp) (expenv '(())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... id (blur (-> (λ (y) ...) <-)) lp ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(match (app <= n 1) (#f) (_ (-> (app id a) <-))) (expenv '(())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app not (-> (app (app blur lp) s (app - n 1)) <-))
 (expenv '(())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> #t <-)) (expenv '(())))
(list 'clos/con: (list (list '((top) . #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> #f <-)) (expenv '()))
(list 'clos/con: (list (list '((top) . #f) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> (app blur id) <-) (app #f)) (expenv '(())))
(list
 'clos/con:
 (list
  (list '(letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (expenv '()))
  (list
   '(letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... id (blur (-> (λ (y) ...) <-)) lp ...) ...)
 (expenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... id (blur (-> (λ (y) ...) <-)) lp ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app lp (-> (app #f) <-) 2) (expenv '()))
(list 'clos/con: (list (list '(con #f) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(let* (... r (s (-> (app (app blur id) (app #f)) <-)) () ...) ...)
 (expenv '(())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> (app blur id) <-) (app #t)) (expenv '(())))
(list
 'clos/con:
 (list
  (list '(letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (expenv '()))
  (list
   '(letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> blur <-) id) (expenv '(())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... id (blur (-> (λ (y) ...) <-)) lp ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app blur (-> id <-)) (expenv '(())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app blur (-> id <-)) (expenv '(())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> blur <-) id) (expenv '(())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... id (blur (-> (λ (y) ...) <-)) lp ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (x) (-> x <-)) (expenv '(())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> - <-) n 1) (expenv '(())))
'(clos/con: (#<procedure:do-sub>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> (app blur lp) <-) s (app - n 1)) (expenv '(())))
(list
 'clos/con:
 (list
  (list '(letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (expenv '()))
  (list
   '(letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app lp (app #f) (-> 2 <-)) (expenv '()))
'(clos/con: ⊥)
'(literals: (2 ⊥ ⊥ ⊥))
