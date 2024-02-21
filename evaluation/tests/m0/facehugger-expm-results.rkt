'(expression:
  (letrec ((id (λ (x) x))
           (f
            (λ (n)
              (match (app <= n 1) ((#f) (app * n (app f (app - n 1)))) (_ 1))))
           (g
            (λ (n)
              (match
               (app <= n 1)
               ((#f) (app * n (app g (app - n 1))))
               (_ 1)))))
    (app + (app (app id f) 3) (app (app id g) 4))))

'(query: (λ (n) (-> (match (app <= n 1) ...) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> id <-) g) (env ()))
clos/con:
	'((letrec (... () (id (-> (λ (x) ...) <-)) f ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app id (-> f <-)) (env ()))
clos/con:
	'((letrec (... id (f (-> (λ (n) ...) <-)) g ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app * (-> n <-) (app g (app - n 1))) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (app id f) (-> 3 <-)) (env ()))
clos/con: ⊥
literals: '(3 ⊥ ⊥ ⊥)

'(query: (app (-> + <-) (app (app id f) 3) (app (app id g) 4)) (env ()))
clos/con:
	#<procedure:do-add>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> (app id f) <-) 3) (env ()))
clos/con:
	'((letrec (... f (g (-> (λ (n) ...) <-)) () ...) ...) (env ()))
	'((letrec (... id (f (-> (λ (n) ...) <-)) g ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app <= n (-> 1 <-)) (env (())))
clos/con: ⊥
literals: '(1 ⊥ ⊥ ⊥)

'(query: (app * n (-> (app g (app - n 1)) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> g <-) (app - n 1)) (env (())))
clos/con:
	'((letrec (... f (g (-> (λ (n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (letrec (... f (g (-> (λ (n) ...) <-)) () ...) ...) (env ()))
clos/con:
	'((letrec (... f (g (-> (λ (n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match (app <= n 1) ((#f) (-> (app * n (app f (app - n 1))) <-)) _)
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> <= <-) n 1) (env (())))
clos/con:
	#<procedure:do-lte>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app <= n (-> 1 <-)) (env (())))
clos/con: ⊥
literals: '(1 ⊥ ⊥ ⊥)

'(query: (app id (-> g <-)) (env ()))
clos/con:
	'((letrec (... f (g (-> (λ (n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app * n (-> (app f (app - n 1)) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (λ (x) (-> x <-)) (env (())))
clos/con:
	'((letrec (... f (g (-> (λ (n) ...) <-)) () ...) ...) (env ()))
	'((letrec (... id (f (-> (λ (n) ...) <-)) g ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> <= <-) n 1) (env (())))
clos/con:
	#<procedure:do-lte>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> (app <= n 1) <-) (#f) _) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: ((top) letrec (id ... g) ...) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app - n (-> 1 <-)) (env (())))
clos/con: ⊥
literals: '(1 ⊥ ⊥ ⊥)

'(query: (app g (-> (app - n 1) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app + (-> (app (app id f) 3) <-) (app (app id g) 4)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> - <-) n 1) (env (())))
clos/con:
	#<procedure:do-sub>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app + (app (app id f) 3) (-> (app (app id g) 4) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app f (-> (app - n 1) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> id <-) f) (env ()))
clos/con:
	'((letrec (... () (id (-> (λ (x) ...) <-)) f ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (letrec (... () (id (-> (λ (x) ...) <-)) f ...) ...) (env ()))
clos/con:
	'((letrec (... () (id (-> (λ (x) ...) <-)) f ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (app <= n 1) (#f) (_ (-> 1 <-))) (env (())))
clos/con: ⊥
literals: '(1 ⊥ ⊥ ⊥)

'(query: (app (app id g) (-> 4 <-)) (env ()))
clos/con: ⊥
literals: '(4 ⊥ ⊥ ⊥)

'(query: (app - (-> n <-) 1) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app <= (-> n <-) 1) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app - (-> n <-) 1) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app - n (-> 1 <-)) (env (())))
clos/con: ⊥
literals: '(1 ⊥ ⊥ ⊥)

'(query: (app (-> * <-) n (app f (app - n 1))) (env (())))
clos/con:
	#<procedure:do-mult>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app * (-> n <-) (app f (app - n 1))) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> * <-) n (app g (app - n 1))) (env (())))
clos/con:
	#<procedure:do-mult>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (n) (-> (match (app <= n 1) ...) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> - <-) n 1) (env (())))
clos/con:
	#<procedure:do-sub>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec (id ... g) (-> (app + (app (app id f) 3) (app (app id g) 4)) <-))
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> (app id g) <-) 4) (env ()))
clos/con:
	'((letrec (... f (g (-> (λ (n) ...) <-)) () ...) ...) (env ()))
	'((letrec (... id (f (-> (λ (n) ...) <-)) g ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> f <-) (app - n 1)) (env (())))
clos/con:
	'((letrec (... id (f (-> (λ (n) ...) <-)) g ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> (app <= n 1) <-) (#f) _) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app <= (-> n <-) 1) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (letrec (... id (f (-> (λ (n) ...) <-)) g ...) ...) (env ()))
clos/con:
	'((letrec (... id (f (-> (λ (n) ...) <-)) g ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (app <= n 1) (#f) (_ (-> 1 <-))) (env (())))
clos/con: ⊥
literals: '(1 ⊥ ⊥ ⊥)

'(query:
  (match (app <= n 1) ((#f) (-> (app * n (app g (app - n 1))) <-)) _)
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: id (env ()))
clos/con:
	'((letrec (... () (id (-> (λ (x) ...) <-)) f ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: x (env (())))
clos/con:
	'((letrec (... f (g (-> (λ (n) ...) <-)) () ...) ...) (env ()))
	'((letrec (... id (f (-> (λ (n) ...) <-)) g ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: f (env ()))
clos/con:
	'((letrec (... id (f (-> (λ (n) ...) <-)) g ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: n (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: g (env ()))
clos/con:
	'((letrec (... f (g (-> (λ (n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)
