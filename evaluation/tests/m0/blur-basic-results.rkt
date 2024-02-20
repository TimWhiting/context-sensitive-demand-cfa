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

(list 'query: '((top) letrec (id ... lp) ...) (menv '()))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...)
 (menv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...)
   (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (a n) (-> (match (app <= n 1) ...) <-)) (menv '(())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(match (app <= n 1) (#f) (_ (-> (app id a) <-))) (menv '(())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app id (-> a <-)) (menv '(())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> id <-) a) (menv '(())))
(list
 'clos/con:
 (list
  (list '(letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(match (app <= n 1) ((#f) (-> (let* (r ... s) ...) <-)) _)
 (menv '(())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(let* (... r (s (-> (app (app blur id) (app #f)) <-)) () ...) ...)
 (menv '(())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (app blur id) (-> (app #f) <-)) (menv '(())))
(list 'clos/con: (list (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> #f <-)) (menv '(())))
(list 'clos/con: (list (list '((top) . #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> (app blur id) <-) (app #f)) (menv '(())))
(list
 'clos/con:
 (list
  (list '(letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (menv '()))
  (list
   '(letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...)
   (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app blur (-> id <-)) (menv '(())))
(list
 'clos/con:
 (list
  (list '(letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> blur <-) id) (menv '(())))
(list
 'clos/con:
 (list
  (list '(letrec (... id (blur (-> (λ (y) ...) <-)) lp ...) ...) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(let* (... () (r (-> (app (app blur id) (app #t)) <-)) s ...) ...)
 (menv '(())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (app blur id) (-> (app #t) <-)) (menv '(())))
(list 'clos/con: (list (list '((top) app #t) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> #t <-)) (menv '(())))
(list 'clos/con: (list (list '((top) . #t) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> (app blur id) <-) (app #t)) (menv '(())))
(list
 'clos/con:
 (list
  (list '(letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (menv '()))
  (list
   '(letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...)
   (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app blur (-> id <-)) (menv '(())))
(list
 'clos/con:
 (list
  (list '(letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> blur <-) id) (menv '(())))
(list
 'clos/con:
 (list
  (list '(letrec (... id (blur (-> (λ (y) ...) <-)) lp ...) ...) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(let* (r ... s) (-> (app not (app (app blur lp) s (app - n 1))) <-))
 (menv '(())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app not (-> (app (app blur lp) s (app - n 1)) <-))
 (menv '(())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (app blur lp) s (-> (app - n 1) <-)) (menv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app - n (-> 1 <-)) (menv '(())))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list 'query: '(app - (-> n <-) 1) (menv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> - <-) n 1) (menv '(())))
'(clos/con: (#<procedure:do-sub>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (app blur lp) (-> s <-) (app - n 1)) (menv '(())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> (app blur lp) <-) s (app - n 1)) (menv '(())))
(list
 'clos/con:
 (list
  (list '(letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (menv '()))
  (list
   '(letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...)
   (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app blur (-> lp <-)) (menv '(())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...)
   (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> blur <-) lp) (menv '(())))
(list
 'clos/con:
 (list
  (list '(letrec (... id (blur (-> (λ (y) ...) <-)) lp ...) ...) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> not <-) (app (app blur lp) s (app - n 1)))
 (menv '(())))
'(clos/con: (#<procedure:do-demand-not>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(match (-> (app <= n 1) <-) (#f) _) (menv '(())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app <= n (-> 1 <-)) (menv '(())))
'(clos/con: ⊥)
'(literals: (1 ⊥ ⊥ ⊥))

(list 'query: '(app <= (-> n <-) 1) (menv '(())))
'(clos/con: ⊥)
'(literals: (⊤ ⊥ ⊥ ⊥))

(list 'query: '(app (-> <= <-) n 1) (menv '(())))
'(clos/con: (#<procedure:do-lte>))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... id (blur (-> (λ (y) ...) <-)) lp ...) ...)
 (menv '()))
(list
 'clos/con:
 (list
  (list '(letrec (... id (blur (-> (λ (y) ...) <-)) lp ...) ...) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (y) (-> y <-)) (menv '(())))
(list
 'clos/con:
 (list
  (list '(letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (menv '()))
  (list
   '(letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...)
   (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...)
 (menv '()))
(list
 'clos/con:
 (list
  (list '(letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (x) (-> x <-)) (menv '(())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(letrec (id ... lp) (-> (app lp (app #f) 2) <-)) (menv '()))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app lp (app #f) (-> 2 <-)) (menv '()))
'(clos/con: ⊥)
'(literals: (2 ⊥ ⊥ ⊥))

(list 'query: '(app lp (-> (app #f) <-) 2) (menv '()))
(list 'clos/con: (list (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> #f <-)) (menv '()))
(list 'clos/con: (list (list '((top) . #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> lp <-) (app #f) 2) (menv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...)
   (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))
