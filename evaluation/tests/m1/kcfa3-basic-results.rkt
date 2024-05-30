'(expression:
  (app
   (λ (f1) (let ((a (app f1 (app #t)))) (app f1 (app #f))))
   (λ (x1)
     (app
      (λ (f2) (let ((b (app f2 (app #t)))) (app f2 (app #f))))
      (λ (x2)
        (app
         (λ (f3) (let ((c (app f3 (app #t)))) (app f3 (app #f))))
         (λ (x3) (app (λ (z) (app z x1 x2 x3)) (λ (y1 y2 y3) y1)))))))))

'(query: ((top) app (λ (f1) ...) (λ (x1) ...)) (env ()))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (λ (f1) ...) (-> (λ (x1) ...) <-)) (env ()))
clos/con:
	'((app (λ (f1) ...) (-> (λ (x1) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)) (env ((□? (x1)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (λ (f2) ...) (-> (λ (x2) ...) <-)) (env ((□? (x1)))))
clos/con:
	'((app (λ (f2) ...) (-> (λ (x2) ...) <-)) (env ((□? (x1)))))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (λ (x2) (-> (app (λ (f3) ...) (λ (x3) ...)) <-))
  (env ((□? (x2)) (□? (x1)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (λ (f3) ...) (-> (λ (x3) ...) <-)) (env ((□? (x2)) (□? (x1)))))
clos/con:
	'((app (λ (f3) ...) (-> (λ (x3) ...) <-)) (env ((□? (x2)) (□? (x1)))))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (λ (x3) (-> (app (λ (z) ...) (λ (y1 y2 y3) ...)) <-))
  (env ((□? (x3)) (□? (x2)) (□? (x1)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app (λ (z) ...) (-> (λ (y1 y2 y3) ...) <-))
  (env ((□? (x3)) (□? (x2)) (□? (x1)))))
clos/con:
	'((app (λ (z) ...) (-> (λ (y1 y2 y3) ...) <-))
  (env ((□? (x3)) (□? (x2)) (□? (x1)))))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (λ (y1 y2 y3) (-> y1 <-))
  (env ((□? (y1 y2 y3)) (□? (x3)) (□? (x2)) (□? (x1)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app (-> (λ (z) ...) <-) (λ (y1 y2 y3) ...))
  (env ((□? (x3)) (□? (x2)) (□? (x1)))))
clos/con:
	'((app (-> (λ (z) ...) <-) (λ (y1 y2 y3) ...))
  (env ((□? (x3)) (□? (x2)) (□? (x1)))))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (λ (z) (-> (app z x1 x2 x3) <-))
  (env ((□? (z)) (□? (x3)) (□? (x2)) (□? (x1)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app z x1 x2 (-> x3 <-))
  (env ((□? (z)) (□? (x3)) (□? (x2)) (□? (x1)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app z x1 (-> x2 <-) x3)
  (env ((□? (z)) (□? (x3)) (□? (x2)) (□? (x1)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app z (-> x1 <-) x2 x3)
  (env ((□? (z)) (□? (x3)) (□? (x2)) (□? (x1)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app (-> z <-) x1 x2 x3)
  (env ((□? (z)) (□? (x3)) (□? (x2)) (□? (x1)))))
clos/con:
	'((app (λ (z) ...) (-> (λ (y1 y2 y3) ...) <-))
  (env ((□? (x3)) (□? (x2)) (□? (x1)))))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> (λ (f3) ...) <-) (λ (x3) ...)) (env ((□? (x2)) (□? (x1)))))
clos/con:
	'((app (-> (λ (f3) ...) <-) (λ (x3) ...)) (env ((□? (x2)) (□? (x1)))))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (f3) (-> (let (c) ...) <-)) (env ((□? (f3)) (□? (x2)) (□? (x1)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (let (... () (c (-> (app f3 (app #t)) <-)) () ...) ...)
  (env ((□? (f3)) (□? (x2)) (□? (x1)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app f3 (-> (app #t) <-)) (env ((□? (f3)) (□? (x2)) (□? (x1)))))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ((□? (f3)) (□? (x2)) (□? (x1)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> f3 <-) (app #t)) (env ((□? (f3)) (□? (x2)) (□? (x1)))))
clos/con:
	'((app (λ (f3) ...) (-> (λ (x3) ...) <-)) (env ((□? (x2)) (□? (x1)))))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (let (c) (-> (app f3 (app #f)) <-))
  (env ((□? (f3)) (□? (x2)) (□? (x1)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app f3 (-> (app #f) <-)) (env ((□? (f3)) (□? (x2)) (□? (x1)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((□? (f3)) (□? (x2)) (□? (x1)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> f3 <-) (app #f)) (env ((□? (f3)) (□? (x2)) (□? (x1)))))
clos/con:
	'((app (λ (f3) ...) (-> (λ (x3) ...) <-)) (env ((□? (x2)) (□? (x1)))))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> (λ (f2) ...) <-) (λ (x2) ...)) (env ((□? (x1)))))
clos/con:
	'((app (-> (λ (f2) ...) <-) (λ (x2) ...)) (env ((□? (x1)))))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (f2) (-> (let (b) ...) <-)) (env ((□? (f2)) (□? (x1)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...)
  (env ((□? (f2)) (□? (x1)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app f2 (-> (app #t) <-)) (env ((□? (f2)) (□? (x1)))))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ((□? (f2)) (□? (x1)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> f2 <-) (app #t)) (env ((□? (f2)) (□? (x1)))))
clos/con:
	'((app (λ (f2) ...) (-> (λ (x2) ...) <-)) (env ((□? (x1)))))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (let (b) (-> (app f2 (app #f)) <-)) (env ((□? (f2)) (□? (x1)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app f2 (-> (app #f) <-)) (env ((□? (f2)) (□? (x1)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((□? (f2)) (□? (x1)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> f2 <-) (app #f)) (env ((□? (f2)) (□? (x1)))))
clos/con:
	'((app (λ (f2) ...) (-> (λ (x2) ...) <-)) (env ((□? (x1)))))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> (λ (f1) ...) <-) (λ (x1) ...)) (env ()))
clos/con:
	'((app (-> (λ (f1) ...) <-) (λ (x1) ...)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (f1) (-> (let (a) ...) <-)) (env ((□? (f1)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)
  (env ((□? (f1)))))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app f1 (-> (app #t) <-)) (env ((□? (f1)))))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ((□? (f1)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> f1 <-) (app #t)) (env ((□? (f1)))))
clos/con:
	'((app (λ (f1) ...) (-> (λ (x1) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (let (a) (-> (app f1 (app #f)) <-)) (env ((□? (f1)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app f1 (-> (app #f) <-)) (env ((□? (f1)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((□? (f1)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> f1 <-) (app #f)) (env ((□? (f1)))))
clos/con:
	'((app (λ (f1) ...) (-> (λ (x1) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)
