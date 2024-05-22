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

'(query:
  (app (-> #f <-))
  (env ((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> #f <-))
  (env ((λ (x2) (-> (app (λ (f3) ...) (λ (x3) ...)) <-)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> #t <-))
  (env ((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> #t <-))
  (env ((λ (x2) (-> (app (λ (f3) ...) (λ (x3) ...)) <-)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> (λ (f2) ...) <-) (λ (x2) ...))
  (env ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...))))
clos/con:
	'((app (-> (λ (f2) ...) <-) (λ (x2) ...))
  (env ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> (λ (f2) ...) <-) (λ (x2) ...))
  (env ((let (a) (-> (app f1 (app #f)) <-)))))
clos/con:
	'((app (-> (λ (f2) ...) <-) (λ (x2) ...))
  (env ((let (a) (-> (app f1 (app #f)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> (λ (f3) ...) <-) (λ (x3) ...))
  (env ((let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...))))
clos/con:
	'((app (-> (λ (f3) ...) <-) (λ (x3) ...))
  (env ((let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> (λ (f3) ...) <-) (λ (x3) ...))
  (env ((let (b) (-> (app f2 (app #f)) <-)))))
clos/con:
	'((app (-> (λ (f3) ...) <-) (λ (x3) ...))
  (env ((let (b) (-> (app f2 (app #f)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> (λ (z) ...) <-) (λ (y1 y2 y3) ...))
  (env ((let (... () (c (-> (app f3 (app #t)) <-)) () ...) ...))))
clos/con:
	'((app (-> (λ (z) ...) <-) (λ (y1 y2 y3) ...))
  (env ((let (... () (c (-> (app f3 (app #t)) <-)) () ...) ...))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> (λ (z) ...) <-) (λ (y1 y2 y3) ...))
  (env ((let (c) (-> (app f3 (app #f)) <-)))))
clos/con:
	'((app (-> (λ (z) ...) <-) (λ (y1 y2 y3) ...))
  (env ((let (c) (-> (app f3 (app #f)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f1 <-) (app #f))
  (env (((top) app (λ (f1) ...) (λ (x1) ...)))))
clos/con:
	'((app (λ (f1) ...) (-> (λ (x1) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f1 <-) (app #t))
  (env (((top) app (λ (f1) ...) (λ (x1) ...)))))
clos/con:
	'((app (λ (f1) ...) (-> (λ (x1) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f2 <-) (app #f))
  (env ((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))))
clos/con:
	'((app (λ (f2) ...) (-> (λ (x2) ...) <-))
  (env ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...))))
	'((app (λ (f2) ...) (-> (λ (x2) ...) <-))
  (env ((let (a) (-> (app f1 (app #f)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f2 <-) (app #t))
  (env ((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))))
clos/con:
	'((app (λ (f2) ...) (-> (λ (x2) ...) <-))
  (env ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...))))
	'((app (λ (f2) ...) (-> (λ (x2) ...) <-))
  (env ((let (a) (-> (app f1 (app #f)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f3 <-) (app #f))
  (env ((λ (x2) (-> (app (λ (f3) ...) (λ (x3) ...)) <-)))))
clos/con:
	'((app (λ (f3) ...) (-> (λ (x3) ...) <-))
  (env ((let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...))))
	'((app (λ (f3) ...) (-> (λ (x3) ...) <-))
  (env ((let (b) (-> (app f2 (app #f)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f3 <-) (app #t))
  (env ((λ (x2) (-> (app (λ (f3) ...) (λ (x3) ...)) <-)))))
clos/con:
	'((app (λ (f3) ...) (-> (λ (x3) ...) <-))
  (env ((let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...))))
	'((app (λ (f3) ...) (-> (λ (x3) ...) <-))
  (env ((let (b) (-> (app f2 (app #f)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> z <-) x1 x2 x3)
  (env ((λ (x3) (-> (app (λ (z) ...) (λ (y1 y2 y3) ...)) <-)))))
clos/con:
	'((app (λ (z) ...) (-> (λ (y1 y2 y3) ...) <-))
  (env ((let (... () (c (-> (app f3 (app #t)) <-)) () ...) ...))))
	'((app (λ (z) ...) (-> (λ (y1 y2 y3) ...) <-))
  (env ((let (c) (-> (app f3 (app #f)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (λ (f2) ...) (-> (λ (x2) ...) <-))
  (env ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...))))
clos/con:
	'((app (λ (f2) ...) (-> (λ (x2) ...) <-))
  (env ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (λ (f2) ...) (-> (λ (x2) ...) <-))
  (env ((let (a) (-> (app f1 (app #f)) <-)))))
clos/con:
	'((app (λ (f2) ...) (-> (λ (x2) ...) <-))
  (env ((let (a) (-> (app f1 (app #f)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (λ (f3) ...) (-> (λ (x3) ...) <-))
  (env ((let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...))))
clos/con:
	'((app (λ (f3) ...) (-> (λ (x3) ...) <-))
  (env ((let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (λ (f3) ...) (-> (λ (x3) ...) <-))
  (env ((let (b) (-> (app f2 (app #f)) <-)))))
clos/con:
	'((app (λ (f3) ...) (-> (λ (x3) ...) <-))
  (env ((let (b) (-> (app f2 (app #f)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (λ (z) ...) (-> (λ (y1 y2 y3) ...) <-))
  (env ((let (... () (c (-> (app f3 (app #t)) <-)) () ...) ...))))
clos/con:
	'((app (λ (z) ...) (-> (λ (y1 y2 y3) ...) <-))
  (env ((let (... () (c (-> (app f3 (app #t)) <-)) () ...) ...))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (λ (z) ...) (-> (λ (y1 y2 y3) ...) <-))
  (env ((let (c) (-> (app f3 (app #f)) <-)))))
clos/con:
	'((app (λ (z) ...) (-> (λ (y1 y2 y3) ...) <-))
  (env ((let (c) (-> (app f3 (app #f)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f1 (-> (app #f) <-))
  (env (((top) app (λ (f1) ...) (λ (x1) ...)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f1 (-> (app #t) <-))
  (env (((top) app (λ (f1) ...) (λ (x1) ...)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f2 (-> (app #f) <-))
  (env ((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f2 (-> (app #t) <-))
  (env ((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f3 (-> (app #f) <-))
  (env ((λ (x2) (-> (app (λ (f3) ...) (λ (x3) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f3 (-> (app #t) <-))
  (env ((λ (x2) (-> (app (λ (f3) ...) (λ (x3) ...)) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app z (-> x1 <-) x2 x3)
  (env ((λ (x3) (-> (app (λ (z) ...) (λ (y1 y2 y3) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app z x1 (-> x2 <-) x3)
  (env ((λ (x3) (-> (app (λ (z) ...) (λ (y1 y2 y3) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app z x1 x2 (-> x3 <-))
  (env ((λ (x3) (-> (app (λ (z) ...) (λ (y1 y2 y3) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)
  (env (((top) app (λ (f1) ...) (λ (x1) ...)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...)
  (env ((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (c (-> (app f3 (app #t)) <-)) () ...) ...)
  (env ((λ (x2) (-> (app (λ (f3) ...) (λ (x3) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (a) (-> (app f1 (app #f)) <-))
  (env (((top) app (λ (f1) ...) (λ (x1) ...)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (b) (-> (app f2 (app #f)) <-))
  (env ((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (c) (-> (app f3 (app #f)) <-))
  (env ((λ (x2) (-> (app (λ (f3) ...) (λ (x3) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (f1) (-> (let (a) ...) <-))
  (env (((top) app (λ (f1) ...) (λ (x1) ...)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (f2) (-> (let (b) ...) <-))
  (env ((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (f3) (-> (let (c) ...) <-))
  (env ((λ (x2) (-> (app (λ (f3) ...) (λ (x3) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-))
  (env ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-))
  (env ((let (a) (-> (app f1 (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x2) (-> (app (λ (f3) ...) (λ (x3) ...)) <-))
  (env ((let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x2) (-> (app (λ (f3) ...) (λ (x3) ...)) <-))
  (env ((let (b) (-> (app f2 (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x3) (-> (app (λ (z) ...) (λ (y1 y2 y3) ...)) <-))
  (env ((let (... () (c (-> (app f3 (app #t)) <-)) () ...) ...))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x3) (-> (app (λ (z) ...) (λ (y1 y2 y3) ...)) <-))
  (env ((let (c) (-> (app f3 (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (z) (-> (app z x1 x2 x3) <-))
  (env ((λ (x3) (-> (app (λ (z) ...) (λ (y1 y2 y3) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: ((top) app (λ (f1) ...) (λ (x1) ...)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (((top) app (λ (f1) ...) (λ (x1) ...)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (((top) app (λ (f1) ...) (λ (x1) ...)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> (λ (f1) ...) <-) (λ (x1) ...)) (env ()))
clos/con:
	'((app (-> (λ (f1) ...) <-) (λ (x1) ...)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (λ (f1) ...) (-> (λ (x1) ...) <-)) (env ()))
clos/con:
	'((app (λ (f1) ...) (-> (λ (x1) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (y1 y2 y3) (-> y1 <-)) (env ((λ (z) (-> (app z x1 x2 x3) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  a
  (app (-> (λ (f1) ...) <-) (λ (x1) ...))
  (env (((top) app (λ (f1) ...) (λ (x1) ...)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  b
  (app (-> (λ (f2) ...) <-) (λ (x2) ...))
  (env ((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c
  (app (-> (λ (f3) ...) <-) (λ (x3) ...))
  (env ((λ (x2) (-> (app (λ (f3) ...) (λ (x3) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  f1
  (app (-> (λ (f1) ...) <-) (λ (x1) ...))
  (env (((top) app (λ (f1) ...) (λ (x1) ...)))))
clos/con:
	'((app (λ (f1) ...) (-> (λ (x1) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  f2
  (app (-> (λ (f2) ...) <-) (λ (x2) ...))
  (env ((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))))
clos/con:
	'((app (λ (f2) ...) (-> (λ (x2) ...) <-))
  (env ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...))))
	'((app (λ (f2) ...) (-> (λ (x2) ...) <-))
  (env ((let (a) (-> (app f1 (app #f)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  f3
  (app (-> (λ (f3) ...) <-) (λ (x3) ...))
  (env ((λ (x2) (-> (app (λ (f3) ...) (λ (x3) ...)) <-)))))
clos/con:
	'((app (λ (f3) ...) (-> (λ (x3) ...) <-))
  (env ((let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...))))
	'((app (λ (f3) ...) (-> (λ (x3) ...) <-))
  (env ((let (b) (-> (app f2 (app #f)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  x1
  (app (-> (λ (z) ...) <-) (λ (y1 y2 y3) ...))
  (env ((λ (x3) (-> (app (λ (z) ...) (λ (y1 y2 y3) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x1
  (app (λ (f1) ...) (-> (λ (x1) ...) <-))
  (env ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x1
  (app (λ (f1) ...) (-> (λ (x1) ...) <-))
  (env ((let (a) (-> (app f1 (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x1
  (app (λ (f2) ...) (-> (λ (x2) ...) <-))
  (env ((let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x1
  (app (λ (f2) ...) (-> (λ (x2) ...) <-))
  (env ((let (b) (-> (app f2 (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x1
  (app (λ (f3) ...) (-> (λ (x3) ...) <-))
  (env ((let (... () (c (-> (app f3 (app #t)) <-)) () ...) ...))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x1
  (app (λ (f3) ...) (-> (λ (x3) ...) <-))
  (env ((let (c) (-> (app f3 (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x2
  (app (-> (λ (z) ...) <-) (λ (y1 y2 y3) ...))
  (env ((λ (x3) (-> (app (λ (z) ...) (λ (y1 y2 y3) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x2
  (app (λ (f2) ...) (-> (λ (x2) ...) <-))
  (env ((let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x2
  (app (λ (f2) ...) (-> (λ (x2) ...) <-))
  (env ((let (b) (-> (app f2 (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x2
  (app (λ (f3) ...) (-> (λ (x3) ...) <-))
  (env ((let (... () (c (-> (app f3 (app #t)) <-)) () ...) ...))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x2
  (app (λ (f3) ...) (-> (λ (x3) ...) <-))
  (env ((let (c) (-> (app f3 (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x3
  (app (-> (λ (z) ...) <-) (λ (y1 y2 y3) ...))
  (env ((λ (x3) (-> (app (λ (z) ...) (λ (y1 y2 y3) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x3
  (app (λ (f3) ...) (-> (λ (x3) ...) <-))
  (env ((let (... () (c (-> (app f3 (app #t)) <-)) () ...) ...))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x3
  (app (λ (f3) ...) (-> (λ (x3) ...) <-))
  (env ((let (c) (-> (app f3 (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  y1
  (app (λ (z) ...) (-> (λ (y1 y2 y3) ...) <-))
  (env ((λ (z) (-> (app z x1 x2 x3) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  y2
  (app (λ (z) ...) (-> (λ (y1 y2 y3) ...) <-))
  (env ((λ (z) (-> (app z x1 x2 x3) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  y3
  (app (λ (z) ...) (-> (λ (y1 y2 y3) ...) <-))
  (env ((λ (z) (-> (app z x1 x2 x3) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  z
  (app (-> (λ (z) ...) <-) (λ (y1 y2 y3) ...))
  (env ((λ (x3) (-> (app (λ (z) ...) (λ (y1 y2 y3) ...)) <-)))))
clos/con:
	'((app (λ (z) ...) (-> (λ (y1 y2 y3) ...) <-))
  (env ((let (... () (c (-> (app f3 (app #t)) <-)) () ...) ...))))
	'((app (λ (z) ...) (-> (λ (y1 y2 y3) ...) <-))
  (env ((let (c) (-> (app f3 (app #f)) <-)))))
literals: '(⊥ ⊥ ⊥)
