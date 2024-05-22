'(expression:
  (app
   (λ (f1) (let ((_ (app f1 (app #t)))) (app f1 (app #f))))
   (λ (x1) (app (λ (z) (app z x1)) (λ (y1) y1)))))

'(query:
  (app (-> (λ (z) ...) <-) (λ (y1) ...))
  (env ((let (... () (_ (-> (app f1 (app #t)) <-)) () ...) ...))))
clos/con:
	'((app (-> (λ (z) ...) <-) (λ (y1) ...))
  (env ((let (... () (_ (-> (app f1 (app #t)) <-)) () ...) ...))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> (λ (z) ...) <-) (λ (y1) ...))
  (env ((let (_) (-> (app f1 (app #f)) <-)))))
clos/con:
	'((app (-> (λ (z) ...) <-) (λ (y1) ...))
  (env ((let (_) (-> (app f1 (app #f)) <-)))))
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
  (app (-> z <-) x1)
  (env ((λ (x1) (-> (app (λ (z) ...) (λ (y1) ...)) <-)))))
clos/con:
	'((app (λ (z) ...) (-> (λ (y1) ...) <-))
  (env ((let (... () (_ (-> (app f1 (app #t)) <-)) () ...) ...))))
	'((app (λ (z) ...) (-> (λ (y1) ...) <-))
  (env ((let (_) (-> (app f1 (app #f)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (λ (z) ...) (-> (λ (y1) ...) <-))
  (env ((let (... () (_ (-> (app f1 (app #t)) <-)) () ...) ...))))
clos/con:
	'((app (λ (z) ...) (-> (λ (y1) ...) <-))
  (env ((let (... () (_ (-> (app f1 (app #t)) <-)) () ...) ...))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (λ (z) ...) (-> (λ (y1) ...) <-))
  (env ((let (_) (-> (app f1 (app #f)) <-)))))
clos/con:
	'((app (λ (z) ...) (-> (λ (y1) ...) <-))
  (env ((let (_) (-> (app f1 (app #f)) <-)))))
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
  (app z (-> x1 <-))
  (env ((λ (x1) (-> (app (λ (z) ...) (λ (y1) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app f1 (app #t)) <-)) () ...) ...)
  (env (((top) app (λ (f1) ...) (λ (x1) ...)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (_) (-> (app f1 (app #f)) <-))
  (env (((top) app (λ (f1) ...) (λ (x1) ...)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (f1) (-> (let (_) ...) <-))
  (env (((top) app (λ (f1) ...) (λ (x1) ...)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x1) (-> (app (λ (z) ...) (λ (y1) ...)) <-))
  (env ((let (... () (_ (-> (app f1 (app #t)) <-)) () ...) ...))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x1) (-> (app (λ (z) ...) (λ (y1) ...)) <-))
  (env ((let (_) (-> (app f1 (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (z) (-> (app z x1) <-))
  (env ((λ (x1) (-> (app (λ (z) ...) (λ (y1) ...)) <-)))))
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

'(query: (λ (y1) (-> y1 <-)) (env ((λ (z) (-> (app z x1) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  _
  (app (-> (λ (f1) ...) <-) (λ (x1) ...))
  (env (((top) app (λ (f1) ...) (λ (x1) ...)))))
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
  x1
  (app (-> (λ (z) ...) <-) (λ (y1) ...))
  (env ((λ (x1) (-> (app (λ (z) ...) (λ (y1) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x1
  (app (λ (f1) ...) (-> (λ (x1) ...) <-))
  (env ((let (... () (_ (-> (app f1 (app #t)) <-)) () ...) ...))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x1
  (app (λ (f1) ...) (-> (λ (x1) ...) <-))
  (env ((let (_) (-> (app f1 (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  y1
  (app (λ (z) ...) (-> (λ (y1) ...) <-))
  (env ((λ (z) (-> (app z x1) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  z
  (app (-> (λ (z) ...) <-) (λ (y1) ...))
  (env ((λ (x1) (-> (app (λ (z) ...) (λ (y1) ...)) <-)))))
clos/con:
	'((app (λ (z) ...) (-> (λ (y1) ...) <-))
  (env ((let (... () (_ (-> (app f1 (app #t)) <-)) () ...) ...))))
	'((app (λ (z) ...) (-> (λ (y1) ...) <-))
  (env ((let (_) (-> (app f1 (app #f)) <-)))))
literals: '(⊥ ⊥ ⊥)
