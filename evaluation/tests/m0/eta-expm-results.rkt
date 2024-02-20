'(expression:
  (letrec ((do-something (λ () 10))
           (id (λ (y) (let ((_ (app do-something))) y))))
    (let ((_ (app (app id (λ (a) a)) (app #t))))
      (app (app id (λ (b) b)) (app #f)))))

(list
 'query:
 '(letrec (do-something ... id) (-> (let (_) ...) <-))
 (expenv '()))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app id (-> (λ (a) ...) <-)) (expenv '()))
(list 'clos/con: (list (list '(app id (-> (λ (a) ...) <-)) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(let (... () (_ (-> (app (app id (λ (a) ...)) (app #t)) <-)) () ...) ...)
 (expenv '()))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(let (... () (_ (-> (app do-something) <-)) () ...) ...)
 (expenv '(())))
'(clos/con: ⊥)
'(literals: (10 ⊥ ⊥ ⊥))

(list 'query: '(λ (b) (-> b <-)) (expenv '(())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app id (-> (λ (b) ...) <-)) (expenv '()))
(list 'clos/con: (list (list '(app id (-> (λ (b) ...) <-)) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... do-something (id (-> (λ (y) ...) <-)) () ...) ...)
 (expenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... do-something (id (-> (λ (y) ...) <-)) () ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(letrec (... () (do-something (-> (λ () ...) <-)) id ...) ...)
 (expenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (do-something (-> (λ () ...) <-)) id ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (y) (-> (let (_) ...) <-)) (expenv '(())))
(list
 'clos/con:
 (list
  (list '(app id (-> (λ (b) ...) <-)) (expenv '()))
  (list '(app id (-> (λ (a) ...) <-)) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ () (-> 10 <-)) (expenv '(())))
'(clos/con: ⊥)
'(literals: (10 ⊥ ⊥ ⊥))

(list 'query: '(app (app id (λ (a) ...)) (-> (app #t) <-)) (expenv '()))
(list 'clos/con: (list (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> (app id (λ (b) ...)) <-) (app #f)) (expenv '()))
(list
 'clos/con:
 (list
  (list '(app id (-> (λ (b) ...) <-)) (expenv '()))
  (list '(app id (-> (λ (a) ...) <-)) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> id <-) (λ (b) ...)) (expenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... do-something (id (-> (λ (y) ...) <-)) () ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (app id (λ (b) ...)) (-> (app #f) <-)) (expenv '()))
(list 'clos/con: (list (list '(con #f) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(let (_) (-> y <-)) (expenv '(())))
(list
 'clos/con:
 (list
  (list '(app id (-> (λ (b) ...) <-)) (expenv '()))
  (list '(app id (-> (λ (a) ...) <-)) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> (app id (λ (a) ...)) <-) (app #t)) (expenv '()))
(list
 'clos/con:
 (list
  (list '(app id (-> (λ (b) ...) <-)) (expenv '()))
  (list '(app id (-> (λ (a) ...) <-)) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> id <-) (λ (a) ...)) (expenv '()))
(list
 'clos/con:
 (list
  (list
   '(letrec (... do-something (id (-> (λ (y) ...) <-)) () ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(let (_) (-> (app (app id (λ (b) ...)) (app #f)) <-))
 (expenv '()))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> do-something <-)) (expenv '(())))
(list
 'clos/con:
 (list
  (list
   '(letrec (... () (do-something (-> (λ () ...) <-)) id ...) ...)
   (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> #t <-)) (expenv '()))
(list 'clos/con: (list (list '((top) . #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> #f <-)) (expenv '()))
(list 'clos/con: (list (list '((top) . #f) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (a) (-> a <-)) (expenv '(())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '((top) letrec (do-something ... id) ...) (expenv '()))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))
