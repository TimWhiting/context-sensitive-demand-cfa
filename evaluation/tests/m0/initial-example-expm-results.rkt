'(expression:
  (let ((id (λ (x) x)))
    (letrec ((f
              (λ (n)
                (match
                 (app <= n 0)
                 ((#f) (app * n (app f (app - n 1))))
                 (_ 1))))
             (g
              (λ (n)
                (match
                 (app <= n 1)
                 ((#f) (app * n (app g (app - n 1))))
                 (_ 1)))))
      (app + (app (app id f) 3) (app (app id g) 4)))))

'(query:
  (letrec (f ... g) (-> (app + (app (app id f) 3) (app (app id g) 4)) <-))
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app <= n 0) ((#f) (-> (app * n (app f (app - n 1))) <-)) _)
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app <= n 1) ((#f) (-> (app * n (app g (app - n 1))) <-)) _)
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: ((top) let (id) ...) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> (app id f) <-) 3) (env ()))
clos/con:
	'((letrec (... () (f (-> (λ (n) ...) <-)) g ...) ...) (env ()))
	'((letrec (... f (g (-> (λ (n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> (app id g) <-) 4) (env ()))
clos/con:
	'((letrec (... () (f (-> (λ (n) ...) <-)) g ...) ...) (env ()))
	'((letrec (... f (g (-> (λ (n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> * <-) n (app f (app - n 1))) (env (())))
clos/con:
	'((prim *) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> * <-) n (app g (app - n 1))) (env (())))
clos/con:
	'((prim *) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> + <-) (app (app id f) 3) (app (app id g) 4)) (env ()))
clos/con:
	'((prim +) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> - <-) n 1) (env (())))
clos/con:
	'((prim -) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> - <-) n 1) (env (())))
clos/con:
	'((prim -) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> <= <-) n 0) (env (())))
clos/con:
	'((prim <=) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> <= <-) n 1) (env (())))
clos/con:
	'((prim <=) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f <-) (app - n 1)) (env (())))
clos/con:
	'((letrec (... () (f (-> (λ (n) ...) <-)) g ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> g <-) (app - n 1)) (env (())))
clos/con:
	'((letrec (... f (g (-> (λ (n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> id <-) f) (env ()))
clos/con:
	'((let (... () (id (-> (λ (x) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> id <-) g) (env ()))
clos/con:
	'((let (... () (id (-> (λ (x) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (app id f) (-> 3 <-)) (env ()))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(query: (app (app id g) (-> 4 <-)) (env ()))
clos/con: ⊥
literals: '(4 ⊥ ⊥)

'(query: (app * (-> n <-) (app f (app - n 1))) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app * (-> n <-) (app g (app - n 1))) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app * n (-> (app f (app - n 1)) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app * n (-> (app g (app - n 1)) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app + (-> (app (app id f) 3) <-) (app (app id g) 4)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app + (app (app id f) 3) (-> (app (app id g) 4) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app - (-> n <-) 1) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app - (-> n <-) 1) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app - n (-> 1 <-)) (env (())))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app - n (-> 1 <-)) (env (())))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app <= (-> n <-) 0) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app <= (-> n <-) 1) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app <= n (-> 0 <-)) (env (())))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query: (app <= n (-> 1 <-)) (env (())))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app f (-> (app - n 1) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app g (-> (app - n 1) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app id (-> f <-)) (env ()))
clos/con:
	'((letrec (... () (f (-> (λ (n) ...) <-)) g ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app id (-> g <-)) (env ()))
clos/con:
	'((letrec (... f (g (-> (λ (n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (... () (id (-> (λ (x) ...) <-)) () ...) ...) (env ()))
clos/con:
	'((let (... () (id (-> (λ (x) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (id) (-> (letrec (f ... g) ...) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (letrec (... () (f (-> (λ (n) ...) <-)) g ...) ...) (env ()))
clos/con:
	'((letrec (... () (f (-> (λ (n) ...) <-)) g ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (letrec (... f (g (-> (λ (n) ...) <-)) () ...) ...) (env ()))
clos/con:
	'((letrec (... f (g (-> (λ (n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app <= n 0) <-) (#f) _) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app <= n 1) <-) (#f) _) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app <= n 0) (#f) (_ (-> 1 <-))) (env (())))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (match (app <= n 1) (#f) (_ (-> 1 <-))) (env (())))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (λ (n) (-> (match (app <= n 0) ...) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (λ (n) (-> (match (app <= n 1) ...) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (λ (x) (-> x <-)) (env (())))
clos/con:
	'((letrec (... () (f (-> (λ (n) ...) <-)) g ...) ...) (env ()))
	'((letrec (... f (g (-> (λ (n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: f (letrec (... () (f (-> (λ (n) ...) <-)) g ...) ...) (env ()))
clos/con:
	'((letrec (... () (f (-> (λ (n) ...) <-)) g ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: g (letrec (... f (g (-> (λ (n) ...) <-)) () ...) ...) (env ()))
clos/con:
	'((letrec (... f (g (-> (λ (n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: id (let (... () (id (-> (λ (x) ...) <-)) () ...) ...) (env ()))
clos/con:
	'((let (... () (id (-> (λ (x) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: n (λ (n) (-> (match (app <= n 0) ...) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store: n (λ (n) (-> (match (app <= n 1) ...) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store: x (λ (x) (-> x <-)) (env (())))
clos/con:
	'((letrec (... () (f (-> (λ (n) ...) <-)) g ...) ...) (env ()))
	'((letrec (... f (g (-> (λ (n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)
