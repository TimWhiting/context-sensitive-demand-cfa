'(expression:
  (app
   (λ (f1) (let ((_ (app f1 (app #t)))) (app f1 (app #f))))
   (λ (x1)
     (app
      (λ (f2) (let ((_ (app f2 (app #t)))) (app f2 (app #f))))
      (λ (x2)
        (app
         (λ (f3) (let ((_ (app f3 (app #t)))) (app f3 (app #f))))
         (λ (x3) (app (λ (z) (app z x1 x2 x3)) (λ (y1 y2 y3) y1)))))))))

(list 'query: '(λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)) (expenv '(())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(let (... () (_ (-> (app f2 (app #t)) <-)) () ...) ...)
 (expenv '(() ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> #t <-)) (expenv '(() () ())))
(list 'clos/con: (list (list '((top) . #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app f3 (-> (app #t) <-)) (expenv '(() () ())))
(list 'clos/con: (list (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> #f <-)) (expenv '(() ())))
(list 'clos/con: (list (list '((top) . #f) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (f1) (-> (let (_) ...) <-)) (expenv '(())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> z <-) x1 x2 x3) (expenv '(() () () ())))
(list
 'clos/con:
 (list
  (list '(app (λ (z) ...) (-> (λ (y1 y2 y3) ...) <-)) (expenv '(() () ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> (λ (f3) ...) <-) (λ (x3) ...)) (expenv '(() ())))
(list
 'clos/con:
 (list (list '(app (-> (λ (f3) ...) <-) (λ (x3) ...)) (expenv '(() ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> f3 <-) (app #t)) (expenv '(() () ())))
(list
 'clos/con:
 (list (list '(app (λ (f3) ...) (-> (λ (x3) ...) <-)) (expenv '(() ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(let (_) (-> (app f1 (app #f)) <-)) (expenv '(())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app f3 (-> (app #f) <-)) (expenv '(() () ())))
(list 'clos/con: (list (list '(con #f) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '((top) app (λ (f1) ...) (λ (x1) ...)) (expenv '()))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (λ (f1) ...) (-> (λ (x1) ...) <-)) (expenv '()))
(list
 'clos/con:
 (list (list '(app (λ (f1) ...) (-> (λ (x1) ...) <-)) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> #t <-)) (expenv '(())))
(list 'clos/con: (list (list '((top) . #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> #f <-)) (expenv '(() () ())))
(list 'clos/con: (list (list '((top) . #f) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (x2) (-> (app (λ (f3) ...) (λ (x3) ...)) <-))
 (expenv '(() ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app f1 (-> (app #t) <-)) (expenv '(())))
(list 'clos/con: (list (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app z x1 (-> x2 <-) x3) (expenv '(() () () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (f3) (-> (let (_) ...) <-)) (expenv '(() () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> (λ (f1) ...) <-) (λ (x1) ...)) (expenv '()))
(list
 'clos/con:
 (list (list '(app (-> (λ (f1) ...) <-) (λ (x1) ...)) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (f2) (-> (let (_) ...) <-)) (expenv '(() ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app f1 (-> (app #f) <-)) (expenv '(())))
(list 'clos/con: (list (list '(con #f) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(let (_) (-> (app f2 (app #f)) <-)) (expenv '(() ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (λ (f2) ...) (-> (λ (x2) ...) <-)) (expenv '(())))
(list
 'clos/con:
 (list (list '(app (λ (f2) ...) (-> (λ (x2) ...) <-)) (expenv '(())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app z (-> x1 <-) x2 x3) (expenv '(() () () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(λ (x3) (-> (app (λ (z) ...) (λ (y1 y2 y3) ...)) <-))
 (expenv '(() () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> #t <-)) (expenv '(() ())))
(list 'clos/con: (list (list '((top) . #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> (λ (f2) ...) <-) (λ (x2) ...)) (expenv '(())))
(list
 'clos/con:
 (list (list '(app (-> (λ (f2) ...) <-) (λ (x2) ...)) (expenv '(())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> #f <-)) (expenv '(())))
(list 'clos/con: (list (list '((top) . #f) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (y1 y2 y3) (-> y1 <-)) (expenv '(() () () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app f2 (-> (app #t) <-)) (expenv '(() ())))
(list 'clos/con: (list (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(let (... () (_ (-> (app f3 (app #t)) <-)) () ...) ...)
 (expenv '(() () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (-> (λ (z) ...) <-) (λ (y1 y2 y3) ...))
 (expenv '(() () ())))
(list
 'clos/con:
 (list
  (list '(app (-> (λ (z) ...) <-) (λ (y1 y2 y3) ...)) (expenv '(() () ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> f1 <-) (app #t)) (expenv '(())))
(list
 'clos/con:
 (list (list '(app (λ (f1) ...) (-> (λ (x1) ...) <-)) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> f2 <-) (app #t)) (expenv '(() ())))
(list
 'clos/con:
 (list (list '(app (λ (f2) ...) (-> (λ (x2) ...) <-)) (expenv '(())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(λ (z) (-> (app z x1 x2 x3) <-)) (expenv '(() () () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> f3 <-) (app #f)) (expenv '(() () ())))
(list
 'clos/con:
 (list (list '(app (λ (f3) ...) (-> (λ (x3) ...) <-)) (expenv '(() ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> f2 <-) (app #f)) (expenv '(() ())))
(list
 'clos/con:
 (list (list '(app (λ (f2) ...) (-> (λ (x2) ...) <-)) (expenv '(())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app z x1 x2 (-> x3 <-)) (expenv '(() () () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (-> f1 <-) (app #f)) (expenv '(())))
(list
 'clos/con:
 (list (list '(app (λ (f1) ...) (-> (λ (x1) ...) <-)) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app f2 (-> (app #f) <-)) (expenv '(() ())))
(list 'clos/con: (list (list '(con #f) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(let (... () (_ (-> (app f1 (app #t)) <-)) () ...) ...)
 (expenv '(())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(let (_) (-> (app f3 (app #f)) <-)) (expenv '(() () ())))
(list
 'clos/con:
 (list (list '(con #f) (expenv '())) (list '(con #t) (expenv '()))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list 'query: '(app (λ (f3) ...) (-> (λ (x3) ...) <-)) (expenv '(() ())))
(list
 'clos/con:
 (list (list '(app (λ (f3) ...) (-> (λ (x3) ...) <-)) (expenv '(() ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))

(list
 'query:
 '(app (λ (z) ...) (-> (λ (y1 y2 y3) ...) <-))
 (expenv '(() () ())))
(list
 'clos/con:
 (list
  (list '(app (λ (z) ...) (-> (λ (y1 y2 y3) ...) <-)) (expenv '(() () ())))))
'(literals: (⊥ ⊥ ⊥ ⊥))
