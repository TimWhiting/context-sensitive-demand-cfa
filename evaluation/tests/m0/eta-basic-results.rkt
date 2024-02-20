'(expression:
  (letrec ((do-something (λ () 10))
           (id (λ (y) (let ((_ (app do-something))) y))))
    (let ((_ (app (app id (λ (a) a)) (app #t))))
      (app (app id (λ (b) b)) (app #f)))))

(list 'query: '((top) letrec (do-something ... id) ...) (menv '()))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... do-something (id (-> (λ (y) ...) <-)) () ...) ...)
 (menv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... do-something (id (-> (λ (y) ...) <-)) () ...) ...)
   (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (y) (-> (let (_) ...) <-)) (menv '(())))
(list
 'clos/con:
 (list
  (list '(app id (-> (λ (b) ...) <-)) (menv '()))
  (list '(app id (-> (λ (a) ...) <-)) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(let (... () (_ (-> (app do-something) <-)) () ...) ...)
 (menv '(())))
'(clos/con: ⊥)
'(literals: (10 ⊥ ⊥ ⊥))

(list 'query: '(app (-> do-something <-)) (menv '(())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (do-something (-> (λ () ...) <-)) id ...) ...)
   (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(let (_) (-> y <-)) (menv '(())))
(list
 'clos/con:
 (list
  (list '(app id (-> (λ (b) ...) <-)) (menv '()))
  (list '(app id (-> (λ (a) ...) <-)) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... () (do-something (-> (λ () ...) <-)) id ...) ...)
 (menv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (do-something (-> (λ () ...) <-)) id ...) ...)
   (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ () (-> 10 <-)) (menv '(())))
'(clos/con: ⊥)
'(literals: (10 ⊥ ⊥ ⊥))

(list 'query: '(letrec (do-something ... id) (-> (let (_) ...) <-)) (menv '()))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(let (... () (_ (-> (app (app id (λ (a) ...)) (app #t)) <-)) () ...) ...)
 (menv '()))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (app id (λ (a) ...)) (-> (app #t) <-)) (menv '()))
(list 'clos/con: (list (list '((top) app #t) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> #t <-)) (menv '()))
(list 'clos/con: (list (list '((top) . #t) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> (app id (λ (a) ...)) <-) (app #t)) (menv '()))
(list
 'clos/con:
 (list
  (list '(app id (-> (λ (b) ...) <-)) (menv '()))
  (list '(app id (-> (λ (a) ...) <-)) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app id (-> (λ (a) ...) <-)) (menv '()))
(list 'clos/con: (list (list '(app id (-> (λ (a) ...) <-)) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (a) (-> a <-)) (menv '(())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> id <-) (λ (a) ...)) (menv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... do-something (id (-> (λ (y) ...) <-)) () ...) ...)
   (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(let (_) (-> (app (app id (λ (b) ...)) (app #f)) <-))
 (menv '()))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (app id (λ (b) ...)) (-> (app #f) <-)) (menv '()))
(list 'clos/con: (list (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> #f <-)) (menv '()))
(list 'clos/con: (list (list '((top) . #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> (app id (λ (b) ...)) <-) (app #f)) (menv '()))
(list
 'clos/con:
 (list
  (list '(app id (-> (λ (b) ...) <-)) (menv '()))
  (list '(app id (-> (λ (a) ...) <-)) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app id (-> (λ (b) ...) <-)) (menv '()))
(list 'clos/con: (list (list '(app id (-> (λ (b) ...) <-)) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (b) (-> b <-)) (menv '(())))
(list
 'clos/con:
 (list (list '((top) app #t) (menv '())) (list '((top) app #f) (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> id <-) (λ (b) ...)) (menv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... do-something (id (-> (λ (y) ...) <-)) () ...) ...)
   (menv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))
