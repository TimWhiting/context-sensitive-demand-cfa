'(expression:
  (letrec*
   ((id (λ (x) x))
    (f (λ (n) (match (app <= n 1) ((#f) (app * n (app f (app - n 1)))) (_ 1))))
    (g
     (λ (n) (match (app <= n 1) ((#f) (app * n (app g (app - n 1)))) (_ 1)))))
   (app + (app (app id f) 3) (app (app id g) 4))))

'(query: ((top) letrec* (id ... g) ...) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (letrec* (... f (g (-> (λ (n) ...) <-)) () ...) ...) (env ()))
clos/con:
	'((letrec* (... f (g (-> (λ (n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (n) (-> (match (app <= n 1) ...) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (match (app <= n 1) (#f) (_ (-> 1 <-))) (env (())))
clos/con: ⊥
literals: '(1 ⊥ ⊥ ⊥)

'(query:
  (match (app <= n 1) ((#f) (-> (app * n (app g (app - n 1))) <-)) _)
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app * n (-> (app g (app - n 1)) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app g (-> (app - n 1) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app - n (-> 1 <-)) (env (())))
clos/con: ⊥
literals: '(1 ⊥ ⊥ ⊥)

'(query: (app - (-> n <-) 1) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> - <-) n 1) (env (())))
clos/con:
	'((prim -) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> g <-) (app - n 1)) (env (())))
clos/con:
	'((letrec* (... f (g (-> (λ (n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app * (-> n <-) (app g (app - n 1))) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> * <-) n (app g (app - n 1))) (env (())))
clos/con:
	'((prim *) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> (app <= n 1) <-) (#f) _) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app <= n (-> 1 <-)) (env (())))
clos/con: ⊥
literals: '(1 ⊥ ⊥ ⊥)

'(query: (app <= (-> n <-) 1) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> <= <-) n 1) (env (())))
clos/con:
	'((prim <=) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (letrec* (... id (f (-> (λ (n) ...) <-)) g ...) ...) (env ()))
clos/con:
	'((letrec* (... id (f (-> (λ (n) ...) <-)) g ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (n) (-> (match (app <= n 1) ...) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (match (app <= n 1) (#f) (_ (-> 1 <-))) (env (())))
clos/con: ⊥
literals: '(1 ⊥ ⊥ ⊥)

'(query:
  (match (app <= n 1) ((#f) (-> (app * n (app f (app - n 1))) <-)) _)
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app * n (-> (app f (app - n 1)) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app f (-> (app - n 1) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app - n (-> 1 <-)) (env (())))
clos/con: ⊥
literals: '(1 ⊥ ⊥ ⊥)

'(query: (app - (-> n <-) 1) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> - <-) n 1) (env (())))
clos/con:
	'((prim -) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> f <-) (app - n 1)) (env (())))
clos/con:
	'((letrec* (... id (f (-> (λ (n) ...) <-)) g ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app * (-> n <-) (app f (app - n 1))) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> * <-) n (app f (app - n 1))) (env (())))
clos/con:
	'((prim *) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> (app <= n 1) <-) (#f) _) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app <= n (-> 1 <-)) (env (())))
clos/con: ⊥
literals: '(1 ⊥ ⊥ ⊥)

'(query: (app <= (-> n <-) 1) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> <= <-) n 1) (env (())))
clos/con:
	'((prim <=) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (letrec* (... () (id (-> (λ (x) ...) <-)) f ...) ...) (env ()))
clos/con:
	'((letrec* (... () (id (-> (λ (x) ...) <-)) f ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (x) (-> x <-)) (env (())))
clos/con:
	'((letrec* (... f (g (-> (λ (n) ...) <-)) () ...) ...) (env ()))
	'((letrec* (... id (f (-> (λ (n) ...) <-)) g ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec* (id ... g) (-> (app + (app (app id f) 3) (app (app id g) 4)) <-))
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app + (app (app id f) 3) (-> (app (app id g) 4) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (app id g) (-> 4 <-)) (env ()))
clos/con: ⊥
literals: '(4 ⊥ ⊥ ⊥)

'(query: (app (-> (app id g) <-) 4) (env ()))
clos/con:
	'((letrec* (... f (g (-> (λ (n) ...) <-)) () ...) ...) (env ()))
	'((letrec* (... id (f (-> (λ (n) ...) <-)) g ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app id (-> g <-)) (env ()))
clos/con:
	'((letrec* (... f (g (-> (λ (n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> id <-) g) (env ()))
clos/con:
	'((letrec* (... () (id (-> (λ (x) ...) <-)) f ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app + (-> (app (app id f) 3) <-) (app (app id g) 4)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (app id f) (-> 3 <-)) (env ()))
clos/con: ⊥
literals: '(3 ⊥ ⊥ ⊥)

'(query: (app (-> (app id f) <-) 3) (env ()))
clos/con:
	'((letrec* (... f (g (-> (λ (n) ...) <-)) () ...) ...) (env ()))
	'((letrec* (... id (f (-> (λ (n) ...) <-)) g ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app id (-> f <-)) (env ()))
clos/con:
	'((letrec* (... id (f (-> (λ (n) ...) <-)) g ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> id <-) f) (env ()))
clos/con:
	'((letrec* (... () (id (-> (λ (x) ...) <-)) f ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> + <-) (app (app id f) 3) (app (app id g) 4)) (env ()))
clos/con:
	'((prim +) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)
