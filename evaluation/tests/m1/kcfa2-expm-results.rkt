'(expression:
  (app
   (λ (f1) (let ((a (app f1 (app #t)))) (app f1 (app #f))))
   (λ (x1)
     (app
      (λ (f2)
        (let ((b (app f2 (app #t))))
          (let ((c (app f2 (app #f)))) (app f2 (app #t)))))
      (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)))))))

'(query:
  (app (-> #f <-))
  (env
   (((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> #f <-))
  (env
   (((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> #t <-))
  (env
   (((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> #t <-))
  (env
   (((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> #t <-))
  (env
   (((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> #t <-))
  (env
   (((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> (λ (f2) ...) <-) (λ (x2) ...))
  (env (((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((app (-> (λ (f2) ...) <-) (λ (x2) ...))
  (env (((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> (λ (f2) ...) <-) (λ (x2) ...))
  (env (((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((app (-> (λ (f2) ...) <-) (λ (x2) ...))
  (env (((let (a) (-> (app f1 (app #f)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> (λ (z) ...) <-) (λ (y1 y2) ...))
  (env
   (((let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((app (-> (λ (z) ...) <-) (λ (y1 y2) ...))
  (env
   (((let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> (λ (z) ...) <-) (λ (y1 y2) ...))
  (env
   (((let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((app (-> (λ (z) ...) <-) (λ (y1 y2) ...))
  (env
   (((let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...))
    ((let (a) (-> (app f1 (app #f)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> (λ (z) ...) <-) (λ (y1 y2) ...))
  (env
   (((let (... () (c (-> (app f2 (app #f)) <-)) () ...) ...))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((app (-> (λ (z) ...) <-) (λ (y1 y2) ...))
  (env
   (((let (... () (c (-> (app f2 (app #f)) <-)) () ...) ...))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> (λ (z) ...) <-) (λ (y1 y2) ...))
  (env
   (((let (... () (c (-> (app f2 (app #f)) <-)) () ...) ...))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((app (-> (λ (z) ...) <-) (λ (y1 y2) ...))
  (env
   (((let (... () (c (-> (app f2 (app #f)) <-)) () ...) ...))
    ((let (a) (-> (app f1 (app #f)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> (λ (z) ...) <-) (λ (y1 y2) ...))
  (env
   (((let (c) (-> (app f2 (app #t)) <-)))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((app (-> (λ (z) ...) <-) (λ (y1 y2) ...))
  (env
   (((let (c) (-> (app f2 (app #t)) <-)))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> (λ (z) ...) <-) (λ (y1 y2) ...))
  (env
   (((let (c) (-> (app f2 (app #t)) <-)))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((app (-> (λ (z) ...) <-) (λ (y1 y2) ...))
  (env
   (((let (c) (-> (app f2 (app #t)) <-)))
    ((let (a) (-> (app f1 (app #f)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f1 <-) (app #f))
  (env ((((top) app (λ (f1) ...) (λ (x1) ...))))))
clos/con:
	'((app (λ (f1) ...) (-> (λ (x1) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f1 <-) (app #t))
  (env ((((top) app (λ (f1) ...) (λ (x1) ...))))))
clos/con:
	'((app (λ (f1) ...) (-> (λ (x1) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f2 <-) (app #f))
  (env
   (((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((app (λ (f2) ...) (-> (λ (x2) ...) <-))
  (env (((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f2 <-) (app #f))
  (env
   (((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((app (λ (f2) ...) (-> (λ (x2) ...) <-))
  (env (((let (a) (-> (app f1 (app #f)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f2 <-) (app #t))
  (env
   (((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((app (λ (f2) ...) (-> (λ (x2) ...) <-))
  (env (((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f2 <-) (app #t))
  (env
   (((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((app (λ (f2) ...) (-> (λ (x2) ...) <-))
  (env (((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f2 <-) (app #t))
  (env
   (((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((app (λ (f2) ...) (-> (λ (x2) ...) <-))
  (env (((let (a) (-> (app f1 (app #f)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f2 <-) (app #t))
  (env
   (((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((app (λ (f2) ...) (-> (λ (x2) ...) <-))
  (env (((let (a) (-> (app f1 (app #f)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> z <-) x1 x2)
  (env
   (((λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-)))
    ((let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((app (λ (z) ...) (-> (λ (y1 y2) ...) <-))
  (env
   (((let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> z <-) x1 x2)
  (env
   (((λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-)))
    ((let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((app (λ (z) ...) (-> (λ (y1 y2) ...) <-))
  (env
   (((let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...))
    ((let (a) (-> (app f1 (app #f)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> z <-) x1 x2)
  (env
   (((λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-)))
    ((let (... () (c (-> (app f2 (app #f)) <-)) () ...) ...))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((app (λ (z) ...) (-> (λ (y1 y2) ...) <-))
  (env
   (((let (... () (c (-> (app f2 (app #f)) <-)) () ...) ...))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> z <-) x1 x2)
  (env
   (((λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-)))
    ((let (... () (c (-> (app f2 (app #f)) <-)) () ...) ...))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((app (λ (z) ...) (-> (λ (y1 y2) ...) <-))
  (env
   (((let (... () (c (-> (app f2 (app #f)) <-)) () ...) ...))
    ((let (a) (-> (app f1 (app #f)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> z <-) x1 x2)
  (env
   (((λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-)))
    ((let (c) (-> (app f2 (app #t)) <-)))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((app (λ (z) ...) (-> (λ (y1 y2) ...) <-))
  (env
   (((let (c) (-> (app f2 (app #t)) <-)))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> z <-) x1 x2)
  (env
   (((λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-)))
    ((let (c) (-> (app f2 (app #t)) <-)))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((app (λ (z) ...) (-> (λ (y1 y2) ...) <-))
  (env
   (((let (c) (-> (app f2 (app #t)) <-)))
    ((let (a) (-> (app f1 (app #f)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (λ (f2) ...) (-> (λ (x2) ...) <-))
  (env (((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((app (λ (f2) ...) (-> (λ (x2) ...) <-))
  (env (((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (λ (f2) ...) (-> (λ (x2) ...) <-))
  (env (((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((app (λ (f2) ...) (-> (λ (x2) ...) <-))
  (env (((let (a) (-> (app f1 (app #f)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (λ (z) ...) (-> (λ (y1 y2) ...) <-))
  (env
   (((let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((app (λ (z) ...) (-> (λ (y1 y2) ...) <-))
  (env
   (((let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (λ (z) ...) (-> (λ (y1 y2) ...) <-))
  (env
   (((let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((app (λ (z) ...) (-> (λ (y1 y2) ...) <-))
  (env
   (((let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...))
    ((let (a) (-> (app f1 (app #f)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (λ (z) ...) (-> (λ (y1 y2) ...) <-))
  (env
   (((let (... () (c (-> (app f2 (app #f)) <-)) () ...) ...))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((app (λ (z) ...) (-> (λ (y1 y2) ...) <-))
  (env
   (((let (... () (c (-> (app f2 (app #f)) <-)) () ...) ...))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (λ (z) ...) (-> (λ (y1 y2) ...) <-))
  (env
   (((let (... () (c (-> (app f2 (app #f)) <-)) () ...) ...))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((app (λ (z) ...) (-> (λ (y1 y2) ...) <-))
  (env
   (((let (... () (c (-> (app f2 (app #f)) <-)) () ...) ...))
    ((let (a) (-> (app f1 (app #f)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (λ (z) ...) (-> (λ (y1 y2) ...) <-))
  (env
   (((let (c) (-> (app f2 (app #t)) <-)))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((app (λ (z) ...) (-> (λ (y1 y2) ...) <-))
  (env
   (((let (c) (-> (app f2 (app #t)) <-)))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (λ (z) ...) (-> (λ (y1 y2) ...) <-))
  (env
   (((let (c) (-> (app f2 (app #t)) <-)))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((app (λ (z) ...) (-> (λ (y1 y2) ...) <-))
  (env
   (((let (c) (-> (app f2 (app #t)) <-)))
    ((let (a) (-> (app f1 (app #f)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f1 (-> (app #f) <-))
  (env ((((top) app (λ (f1) ...) (λ (x1) ...))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f1 (-> (app #t) <-))
  (env ((((top) app (λ (f1) ...) (λ (x1) ...))))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f2 (-> (app #f) <-))
  (env
   (((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f2 (-> (app #f) <-))
  (env
   (((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f2 (-> (app #t) <-))
  (env
   (((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f2 (-> (app #t) <-))
  (env
   (((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f2 (-> (app #t) <-))
  (env
   (((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f2 (-> (app #t) <-))
  (env
   (((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app z (-> x1 <-) x2)
  (env
   (((λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-)))
    ((let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app z (-> x1 <-) x2)
  (env
   (((λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-)))
    ((let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app z (-> x1 <-) x2)
  (env
   (((λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-)))
    ((let (... () (c (-> (app f2 (app #f)) <-)) () ...) ...))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app z (-> x1 <-) x2)
  (env
   (((λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-)))
    ((let (... () (c (-> (app f2 (app #f)) <-)) () ...) ...))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app z (-> x1 <-) x2)
  (env
   (((λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-)))
    ((let (c) (-> (app f2 (app #t)) <-)))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app z (-> x1 <-) x2)
  (env
   (((λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-)))
    ((let (c) (-> (app f2 (app #t)) <-)))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app z x1 (-> x2 <-))
  (env
   (((λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-)))
    ((let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app z x1 (-> x2 <-))
  (env
   (((λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-)))
    ((let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app z x1 (-> x2 <-))
  (env
   (((λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-)))
    ((let (... () (c (-> (app f2 (app #f)) <-)) () ...) ...))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app z x1 (-> x2 <-))
  (env
   (((λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-)))
    ((let (... () (c (-> (app f2 (app #f)) <-)) () ...) ...))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app z x1 (-> x2 <-))
  (env
   (((λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-)))
    ((let (c) (-> (app f2 (app #t)) <-)))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app z x1 (-> x2 <-))
  (env
   (((λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-)))
    ((let (c) (-> (app f2 (app #t)) <-)))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)
  (env ((((top) app (λ (f1) ...) (λ (x1) ...))))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...)
  (env
   (((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...)
  (env
   (((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (c (-> (app f2 (app #f)) <-)) () ...) ...)
  (env
   (((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (c (-> (app f2 (app #f)) <-)) () ...) ...)
  (env
   (((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (a) (-> (app f1 (app #f)) <-))
  (env ((((top) app (λ (f1) ...) (λ (x1) ...))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (b) (-> (let (c) ...) <-))
  (env
   (((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (b) (-> (let (c) ...) <-))
  (env
   (((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (c) (-> (app f2 (app #t)) <-))
  (env
   (((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (c) (-> (app f2 (app #t)) <-))
  (env
   (((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (f1) (-> (let (a) ...) <-))
  (env ((((top) app (λ (f1) ...) (λ (x1) ...))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (f2) (-> (let (b) ...) <-))
  (env
   (((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (f2) (-> (let (b) ...) <-))
  (env
   (((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-))
  (env (((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-))
  (env (((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-))
  (env
   (((let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-))
  (env
   (((let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-))
  (env
   (((let (... () (c (-> (app f2 (app #f)) <-)) () ...) ...))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-))
  (env
   (((let (... () (c (-> (app f2 (app #f)) <-)) () ...) ...))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-))
  (env
   (((let (c) (-> (app f2 (app #t)) <-)))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-))
  (env
   (((let (c) (-> (app f2 (app #t)) <-)))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (y1 y2) (-> y1 <-))
  (env
   (((λ (z) (-> (app z x1 x2) <-)))
    ((let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (y1 y2) (-> y1 <-))
  (env
   (((λ (z) (-> (app z x1 x2) <-)))
    ((let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (y1 y2) (-> y1 <-))
  (env
   (((λ (z) (-> (app z x1 x2) <-)))
    ((let (... () (c (-> (app f2 (app #f)) <-)) () ...) ...))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (y1 y2) (-> y1 <-))
  (env
   (((λ (z) (-> (app z x1 x2) <-)))
    ((let (... () (c (-> (app f2 (app #f)) <-)) () ...) ...))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (y1 y2) (-> y1 <-))
  (env
   (((λ (z) (-> (app z x1 x2) <-)))
    ((let (c) (-> (app f2 (app #t)) <-)))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (y1 y2) (-> y1 <-))
  (env
   (((λ (z) (-> (app z x1 x2) <-)))
    ((let (c) (-> (app f2 (app #t)) <-)))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (z) (-> (app z x1 x2) <-))
  (env
   (((λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-)))
    ((let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (z) (-> (app z x1 x2) <-))
  (env
   (((λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-)))
    ((let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (z) (-> (app z x1 x2) <-))
  (env
   (((λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-)))
    ((let (... () (c (-> (app f2 (app #f)) <-)) () ...) ...))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (z) (-> (app z x1 x2) <-))
  (env
   (((λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-)))
    ((let (... () (c (-> (app f2 (app #f)) <-)) () ...) ...))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (z) (-> (app z x1 x2) <-))
  (env
   (((λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-)))
    ((let (c) (-> (app f2 (app #t)) <-)))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (z) (-> (app z x1 x2) <-))
  (env
   (((λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-)))
    ((let (c) (-> (app f2 (app #t)) <-)))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: ((top) app (λ (f1) ...) (λ (x1) ...)) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((((top) app (λ (f1) ...) (λ (x1) ...))))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ((((top) app (λ (f1) ...) (λ (x1) ...))))))
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

'(store:
  a
  (let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)
  (env ((((top) app (λ (f1) ...) (λ (x1) ...))))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  b
  (let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...)
  (env
   (((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  b
  (let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...)
  (env
   (((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c
  (let (... () (c (-> (app f2 (app #f)) <-)) () ...) ...)
  (env
   (((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c
  (let (... () (c (-> (app f2 (app #f)) <-)) () ...) ...)
  (env
   (((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  f1
  (λ (f1) (-> (let (a) ...) <-))
  (env ((((top) app (λ (f1) ...) (λ (x1) ...))))))
clos/con:
	'((app (λ (f1) ...) (-> (λ (x1) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  f2
  (λ (f2) (-> (let (b) ...) <-))
  (env
   (((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((app (λ (f2) ...) (-> (λ (x2) ...) <-))
  (env (((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  f2
  (λ (f2) (-> (let (b) ...) <-))
  (env
   (((λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((app (λ (f2) ...) (-> (λ (x2) ...) <-))
  (env (((let (a) (-> (app f1 (app #f)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  x1
  (λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-))
  (env (((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x1
  (λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-))
  (env (((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x2
  (λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-))
  (env
   (((let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x2
  (λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-))
  (env
   (((let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x2
  (λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-))
  (env
   (((let (... () (c (-> (app f2 (app #f)) <-)) () ...) ...))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x2
  (λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-))
  (env
   (((let (... () (c (-> (app f2 (app #f)) <-)) () ...) ...))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x2
  (λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-))
  (env
   (((let (c) (-> (app f2 (app #t)) <-)))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x2
  (λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-))
  (env
   (((let (c) (-> (app f2 (app #t)) <-)))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  y1
  (λ (y1 y2) (-> y1 <-))
  (env
   (((λ (z) (-> (app z x1 x2) <-)))
    ((let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  y1
  (λ (y1 y2) (-> y1 <-))
  (env
   (((λ (z) (-> (app z x1 x2) <-)))
    ((let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  y1
  (λ (y1 y2) (-> y1 <-))
  (env
   (((λ (z) (-> (app z x1 x2) <-)))
    ((let (... () (c (-> (app f2 (app #f)) <-)) () ...) ...))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  y1
  (λ (y1 y2) (-> y1 <-))
  (env
   (((λ (z) (-> (app z x1 x2) <-)))
    ((let (... () (c (-> (app f2 (app #f)) <-)) () ...) ...))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  y1
  (λ (y1 y2) (-> y1 <-))
  (env
   (((λ (z) (-> (app z x1 x2) <-)))
    ((let (c) (-> (app f2 (app #t)) <-)))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  y1
  (λ (y1 y2) (-> y1 <-))
  (env
   (((λ (z) (-> (app z x1 x2) <-)))
    ((let (c) (-> (app f2 (app #t)) <-)))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  y2
  (λ (y1 y2) (-> y1 <-))
  (env
   (((λ (z) (-> (app z x1 x2) <-)))
    ((let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  y2
  (λ (y1 y2) (-> y1 <-))
  (env
   (((λ (z) (-> (app z x1 x2) <-)))
    ((let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  y2
  (λ (y1 y2) (-> y1 <-))
  (env
   (((λ (z) (-> (app z x1 x2) <-)))
    ((let (... () (c (-> (app f2 (app #f)) <-)) () ...) ...))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  y2
  (λ (y1 y2) (-> y1 <-))
  (env
   (((λ (z) (-> (app z x1 x2) <-)))
    ((let (... () (c (-> (app f2 (app #f)) <-)) () ...) ...))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  y2
  (λ (y1 y2) (-> y1 <-))
  (env
   (((λ (z) (-> (app z x1 x2) <-)))
    ((let (c) (-> (app f2 (app #t)) <-)))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  y2
  (λ (y1 y2) (-> y1 <-))
  (env
   (((λ (z) (-> (app z x1 x2) <-)))
    ((let (c) (-> (app f2 (app #t)) <-)))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  z
  (λ (z) (-> (app z x1 x2) <-))
  (env
   (((λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-)))
    ((let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((app (λ (z) ...) (-> (λ (y1 y2) ...) <-))
  (env
   (((let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  z
  (λ (z) (-> (app z x1 x2) <-))
  (env
   (((λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-)))
    ((let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((app (λ (z) ...) (-> (λ (y1 y2) ...) <-))
  (env
   (((let (... () (b (-> (app f2 (app #t)) <-)) () ...) ...))
    ((let (a) (-> (app f1 (app #f)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  z
  (λ (z) (-> (app z x1 x2) <-))
  (env
   (((λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-)))
    ((let (... () (c (-> (app f2 (app #f)) <-)) () ...) ...))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((app (λ (z) ...) (-> (λ (y1 y2) ...) <-))
  (env
   (((let (... () (c (-> (app f2 (app #f)) <-)) () ...) ...))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  z
  (λ (z) (-> (app z x1 x2) <-))
  (env
   (((λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-)))
    ((let (... () (c (-> (app f2 (app #f)) <-)) () ...) ...))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((app (λ (z) ...) (-> (λ (y1 y2) ...) <-))
  (env
   (((let (... () (c (-> (app f2 (app #f)) <-)) () ...) ...))
    ((let (a) (-> (app f1 (app #f)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  z
  (λ (z) (-> (app z x1 x2) <-))
  (env
   (((λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-)))
    ((let (c) (-> (app f2 (app #t)) <-)))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
clos/con:
	'((app (λ (z) ...) (-> (λ (y1 y2) ...) <-))
  (env
   (((let (c) (-> (app f2 (app #t)) <-)))
    ((let (... () (a (-> (app f1 (app #t)) <-)) () ...) ...)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  z
  (λ (z) (-> (app z x1 x2) <-))
  (env
   (((λ (x2) (-> (app (λ (z) ...) (λ (y1 y2) ...)) <-)))
    ((let (c) (-> (app f2 (app #t)) <-)))
    ((let (a) (-> (app f1 (app #f)) <-))))))
clos/con:
	'((app (λ (z) ...) (-> (λ (y1 y2) ...) <-))
  (env
   (((let (c) (-> (app f2 (app #t)) <-)))
    ((let (a) (-> (app f1 (app #f)) <-))))))
literals: '(⊥ ⊥ ⊥)
