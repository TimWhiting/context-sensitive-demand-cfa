'(expression:
  (letrec ((do-something (λ () 10))
           (id (λ (y) (let ((_ (app do-something))) y))))
    (let ((_ (app (app id (λ (a) a)) (app #t))))
      (app (app id (λ (b) b)) (app #f)))))

(list
 'query:
 '(letrec (do-something ... id) (-> (let (_) ...) <-))
 (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app id (-> (λ (a) ...) <-)) (flatenv '()))
(list 'clos/con: (list (list '(app id (-> (λ (a) ...) <-)) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(let (... () (_ (-> (app (app id (λ (a) ...)) (app #t)) <-)) () ...) ...)
 (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... do-something (id (-> (λ (y) ...) <-)) () ...) ...)
 (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... do-something (id (-> (λ (y) ...) <-)) () ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(let (_) (-> y <-)) (flatenv '()))
(list
 'clos/con:
 (list
  (list '(app id (-> (λ (b) ...) <-)) (flatenv '()))
  (list '(app id (-> (λ (a) ...) <-)) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> #t <-)) (flatenv '()))
(list 'clos/con: (list (list '((top) . #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> #f <-)) (flatenv '()))
(list 'clos/con: (list (list '((top) . #f) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (b) (-> b <-)) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(let (... () (_ (-> (app do-something) <-)) () ...) ...)
 (flatenv '()))
'(clos/con: ⊥)
'(literals: (10 ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... () (do-something (-> (λ () ...) <-)) id ...) ...)
 (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (do-something (-> (λ () ...) <-)) id ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (app id (λ (a) ...)) (-> (app #t) <-)) (flatenv '()))
(list 'clos/con: (list (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> (app id (λ (b) ...)) <-) (app #f)) (flatenv '()))
(list
 'clos/con:
 (list
  (list '(app id (-> (λ (b) ...) <-)) (flatenv '()))
  (list '(app id (-> (λ (a) ...) <-)) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ () (-> 10 <-)) (flatenv '()))
'(clos/con: ⊥)
'(literals: (10 ⊥ ⊥ ⊥))

(list 'query: '(app (-> id <-) (λ (b) ...)) (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... do-something (id (-> (λ (y) ...) <-)) () ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (app id (λ (b) ...)) (-> (app #f) <-)) (flatenv '()))
(list 'clos/con: (list (list '(con #f) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '((top) letrec (do-something ... id) ...) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (y) (-> (let (_) ...) <-)) (flatenv '()))
(list
 'clos/con:
 (list
  (list '(app id (-> (λ (b) ...) <-)) (flatenv '()))
  (list '(app id (-> (λ (a) ...) <-)) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> (app id (λ (a) ...)) <-) (app #t)) (flatenv '()))
(list
 'clos/con:
 (list
  (list '(app id (-> (λ (b) ...) <-)) (flatenv '()))
  (list '(app id (-> (λ (a) ...) <-)) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app id (-> (λ (b) ...) <-)) (flatenv '()))
(list 'clos/con: (list (list '(app id (-> (λ (b) ...) <-)) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(let (_) (-> (app (app id (λ (b) ...)) (app #f)) <-))
 (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (a) (-> a <-)) (flatenv '()))
(list
 'clos/con:
 (list (list '(con #f) (flatenv '())) (list '(con #t) (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> do-something <-)) (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (do-something (-> (λ () ...) <-)) id ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> id <-) (λ (a) ...)) (flatenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... do-something (id (-> (λ (y) ...) <-)) () ...) ...)
   (flatenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))
