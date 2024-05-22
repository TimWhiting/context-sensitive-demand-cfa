'(expression:
  (letrec*
   ((id (λ (x) x))
    (f (λ (n) (match (app <= n 1) ((#f) (app * n (app f (app - n 1)))) (_ 1))))
    (g
     (λ (n) (match (app <= n 1) ((#f) (app * n (app g (app - n 1)))) (_ 1)))))
   (app + (app (app id f) 3) (app (app id g) 4))))

'(query:
  (app (-> * <-) n (app f (app - n 1)))
  (env ((app * n (-> (app f (app - n 1)) <-)))))
clos/con:
	'((prim *) (env ((app * n (-> (app f (app - n 1)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> * <-) n (app f (app - n 1)))
  (env ((app + (-> (app (app id f) 3) <-) (app (app id g) 4)))))
clos/con:
	'((prim *) (env ((app + (-> (app (app id f) 3) <-) (app (app id g) 4)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> * <-) n (app g (app - n 1)))
  (env ((app * n (-> (app g (app - n 1)) <-)))))
clos/con:
	'((prim *) (env ((app * n (-> (app g (app - n 1)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> * <-) n (app g (app - n 1)))
  (env ((app + (app (app id f) 3) (-> (app (app id g) 4) <-)))))
clos/con:
	'((prim *) (env ((app + (app (app id f) 3) (-> (app (app id g) 4) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> - <-) n 1)
  (env ((app + (-> (app (app id f) 3) <-) (app (app id g) 4)))))
clos/con:
	'((prim -) (env ((app + (-> (app (app id f) 3) <-) (app (app id g) 4)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> - <-) n 1)
  (env ((app + (app (app id f) 3) (-> (app (app id g) 4) <-)))))
clos/con:
	'((prim -) (env ((app + (app (app id f) 3) (-> (app (app id g) 4) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> <= <-) n 1)
  (env ((app + (-> (app (app id f) 3) <-) (app (app id g) 4)))))
clos/con:
	'((prim <=) (env ((app + (-> (app (app id f) 3) <-) (app (app id g) 4)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> <= <-) n 1)
  (env ((app + (app (app id f) 3) (-> (app (app id g) 4) <-)))))
clos/con:
	'((prim <=) (env ((app + (app (app id f) 3) (-> (app (app id g) 4) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f <-) (app - n 1))
  (env ((app * n (-> (app f (app - n 1)) <-)))))
clos/con:
	'((letrec* (... id (f (-> (λ (n) ...) <-)) g ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f <-) (app - n 1))
  (env ((app + (-> (app (app id f) 3) <-) (app (app id g) 4)))))
clos/con:
	'((letrec* (... id (f (-> (λ (n) ...) <-)) g ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> g <-) (app - n 1))
  (env ((app * n (-> (app g (app - n 1)) <-)))))
clos/con:
	'((letrec* (... f (g (-> (λ (n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> g <-) (app - n 1))
  (env ((app + (app (app id f) 3) (-> (app (app id g) 4) <-)))))
clos/con:
	'((letrec* (... f (g (-> (λ (n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app * (-> n <-) (app f (app - n 1)))
  (env ((app * n (-> (app f (app - n 1)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * (-> n <-) (app f (app - n 1)))
  (env ((app + (-> (app (app id f) 3) <-) (app (app id g) 4)))))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(query:
  (app * (-> n <-) (app g (app - n 1)))
  (env ((app * n (-> (app g (app - n 1)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * (-> n <-) (app g (app - n 1)))
  (env ((app + (app (app id f) 3) (-> (app (app id g) 4) <-)))))
clos/con: ⊥
literals: '(4 ⊥ ⊥)

'(query:
  (app * n (-> (app f (app - n 1)) <-))
  (env ((app * n (-> (app f (app - n 1)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * n (-> (app f (app - n 1)) <-))
  (env ((app + (-> (app (app id f) 3) <-) (app (app id g) 4)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * n (-> (app g (app - n 1)) <-))
  (env ((app * n (-> (app g (app - n 1)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * n (-> (app g (app - n 1)) <-))
  (env ((app + (app (app id f) 3) (-> (app (app id g) 4) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> n <-) 1)
  (env ((app + (-> (app (app id f) 3) <-) (app (app id g) 4)))))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(query:
  (app - (-> n <-) 1)
  (env ((app + (app (app id f) 3) (-> (app (app id g) 4) <-)))))
clos/con: ⊥
literals: '(4 ⊥ ⊥)

'(query:
  (app - n (-> 1 <-))
  (env ((app + (-> (app (app id f) 3) <-) (app (app id g) 4)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (app - n (-> 1 <-))
  (env ((app + (app (app id f) 3) (-> (app (app id g) 4) <-)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (app <= (-> n <-) 1)
  (env ((app + (-> (app (app id f) 3) <-) (app (app id g) 4)))))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(query:
  (app <= (-> n <-) 1)
  (env ((app + (app (app id f) 3) (-> (app (app id g) 4) <-)))))
clos/con: ⊥
literals: '(4 ⊥ ⊥)

'(query:
  (app <= n (-> 1 <-))
  (env ((app + (-> (app (app id f) 3) <-) (app (app id g) 4)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (app <= n (-> 1 <-))
  (env ((app + (app (app id f) 3) (-> (app (app id g) 4) <-)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (app f (-> (app - n 1) <-))
  (env ((app * n (-> (app f (app - n 1)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app f (-> (app - n 1) <-))
  (env ((app + (-> (app (app id f) 3) <-) (app (app id g) 4)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query:
  (app g (-> (app - n 1) <-))
  (env ((app * n (-> (app g (app - n 1)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app g (-> (app - n 1) <-))
  (env ((app + (app (app id f) 3) (-> (app (app id g) 4) <-)))))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(query:
  (letrec* (id ... g) (-> (app + (app (app id f) 3) (app (app id g) 4)) <-))
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (-> (app <= n 1) <-) (#f) _)
  (env ((app * n (-> (app f (app - n 1)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app <= n 1) <-) (#f) _)
  (env ((app * n (-> (app g (app - n 1)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app <= n 1) <-) (#f) _)
  (env ((app + (-> (app (app id f) 3) <-) (app (app id g) 4)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app <= n 1) <-) (#f) _)
  (env ((app + (app (app id f) 3) (-> (app (app id g) 4) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app <= n 1) (#f) (_ (-> 1 <-)))
  (env ((app * n (-> (app f (app - n 1)) <-)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (match (app <= n 1) (#f) (_ (-> 1 <-)))
  (env ((app * n (-> (app g (app - n 1)) <-)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (match (app <= n 1) ((#f) (-> (app * n (app f (app - n 1))) <-)) _)
  (env ((app * n (-> (app f (app - n 1)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app <= n 1) ((#f) (-> (app * n (app f (app - n 1))) <-)) _)
  (env ((app + (-> (app (app id f) 3) <-) (app (app id g) 4)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app <= n 1) ((#f) (-> (app * n (app g (app - n 1))) <-)) _)
  (env ((app * n (-> (app g (app - n 1)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app <= n 1) ((#f) (-> (app * n (app g (app - n 1))) <-)) _)
  (env ((app + (app (app id f) 3) (-> (app (app id g) 4) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (n) (-> (match (app <= n 1) ...) <-))
  (env ((app * n (-> (app f (app - n 1)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (n) (-> (match (app <= n 1) ...) <-))
  (env ((app * n (-> (app g (app - n 1)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (n) (-> (match (app <= n 1) ...) <-))
  (env ((app + (-> (app (app id f) 3) <-) (app (app id g) 4)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (n) (-> (match (app <= n 1) ...) <-))
  (env ((app + (app (app id f) 3) (-> (app (app id g) 4) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: ((top) letrec* (id ... g) ...) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> (app id f) <-) 3) (env ()))
clos/con:
	'((letrec* (... id (f (-> (λ (n) ...) <-)) g ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> (app id g) <-) 4) (env ()))
clos/con:
	'((letrec* (... f (g (-> (λ (n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> + <-) (app (app id f) 3) (app (app id g) 4)) (env ()))
clos/con:
	'((prim +) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> - <-) n 1) (env ((app * n (-> (app f (app - n 1)) <-)))))
clos/con:
	'((prim -) (env ((app * n (-> (app f (app - n 1)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> - <-) n 1) (env ((app * n (-> (app g (app - n 1)) <-)))))
clos/con:
	'((prim -) (env ((app * n (-> (app g (app - n 1)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> <= <-) n 1) (env ((app * n (-> (app f (app - n 1)) <-)))))
clos/con:
	'((prim <=) (env ((app * n (-> (app f (app - n 1)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> <= <-) n 1) (env ((app * n (-> (app g (app - n 1)) <-)))))
clos/con:
	'((prim <=) (env ((app * n (-> (app g (app - n 1)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> id <-) f) (env ()))
clos/con:
	'((letrec* (... () (id (-> (λ (x) ...) <-)) f ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> id <-) g) (env ()))
clos/con:
	'((letrec* (... () (id (-> (λ (x) ...) <-)) f ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (app id f) (-> 3 <-)) (env ()))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(query: (app (app id g) (-> 4 <-)) (env ()))
clos/con: ⊥
literals: '(4 ⊥ ⊥)

'(query: (app + (-> (app (app id f) 3) <-) (app (app id g) 4)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app + (app (app id f) 3) (-> (app (app id g) 4) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app - (-> n <-) 1) (env ((app * n (-> (app f (app - n 1)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app - (-> n <-) 1) (env ((app * n (-> (app g (app - n 1)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app - n (-> 1 <-)) (env ((app * n (-> (app f (app - n 1)) <-)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app - n (-> 1 <-)) (env ((app * n (-> (app g (app - n 1)) <-)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app <= (-> n <-) 1) (env ((app * n (-> (app f (app - n 1)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app <= (-> n <-) 1) (env ((app * n (-> (app g (app - n 1)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app <= n (-> 1 <-)) (env ((app * n (-> (app f (app - n 1)) <-)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app <= n (-> 1 <-)) (env ((app * n (-> (app g (app - n 1)) <-)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app id (-> f <-)) (env ()))
clos/con:
	'((letrec* (... id (f (-> (λ (n) ...) <-)) g ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app id (-> g <-)) (env ()))
clos/con:
	'((letrec* (... f (g (-> (λ (n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (letrec* (... () (id (-> (λ (x) ...) <-)) f ...) ...) (env ()))
clos/con:
	'((letrec* (... () (id (-> (λ (x) ...) <-)) f ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (letrec* (... f (g (-> (λ (n) ...) <-)) () ...) ...) (env ()))
clos/con:
	'((letrec* (... f (g (-> (λ (n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (letrec* (... id (f (-> (λ (n) ...) <-)) g ...) ...) (env ()))
clos/con:
	'((letrec* (... id (f (-> (λ (n) ...) <-)) g ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (x) (-> x <-)) (env ((app (-> (app id f) <-) 3))))
clos/con:
	'((letrec* (... id (f (-> (λ (n) ...) <-)) g ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (x) (-> x <-)) (env ((app (-> (app id g) <-) 4))))
clos/con:
	'((letrec* (... f (g (-> (λ (n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  *
  (letrec* (... f (g (-> (λ (n) ...) <-)) () ...) ...)
  (env ((app * n (-> (app g (app - n 1)) <-)))))
clos/con:
	'((λ (n) (-> (match (app <= n 1) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  *
  (letrec* (... f (g (-> (λ (n) ...) <-)) () ...) ...)
  (env ((app + (app (app id f) 3) (-> (app (app id g) 4) <-)))))
clos/con:
	'((λ (n) (-> (match (app <= n 1) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  *
  (letrec* (... id (f (-> (λ (n) ...) <-)) g ...) ...)
  (env ((app * n (-> (app f (app - n 1)) <-)))))
clos/con:
	'((λ (n) (-> (match (app <= n 1) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  *
  (letrec* (... id (f (-> (λ (n) ...) <-)) g ...) ...)
  (env ((app + (-> (app (app id f) 3) <-) (app (app id g) 4)))))
clos/con:
	'((λ (n) (-> (match (app <= n 1) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  -
  (letrec* (... f (g (-> (λ (n) ...) <-)) () ...) ...)
  (env ((app * n (-> (app g (app - n 1)) <-)))))
clos/con:
	'((λ (n) (-> (match (app <= n 1) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  -
  (letrec* (... f (g (-> (λ (n) ...) <-)) () ...) ...)
  (env ((app + (app (app id f) 3) (-> (app (app id g) 4) <-)))))
clos/con:
	'((λ (n) (-> (match (app <= n 1) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  -
  (letrec* (... id (f (-> (λ (n) ...) <-)) g ...) ...)
  (env ((app * n (-> (app f (app - n 1)) <-)))))
clos/con:
	'((λ (n) (-> (match (app <= n 1) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  -
  (letrec* (... id (f (-> (λ (n) ...) <-)) g ...) ...)
  (env ((app + (-> (app (app id f) 3) <-) (app (app id g) 4)))))
clos/con:
	'((λ (n) (-> (match (app <= n 1) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  <=
  (letrec* (... f (g (-> (λ (n) ...) <-)) () ...) ...)
  (env ((app * n (-> (app g (app - n 1)) <-)))))
clos/con:
	'((λ (n) (-> (match (app <= n 1) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  <=
  (letrec* (... f (g (-> (λ (n) ...) <-)) () ...) ...)
  (env ((app + (app (app id f) 3) (-> (app (app id g) 4) <-)))))
clos/con:
	'((λ (n) (-> (match (app <= n 1) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  <=
  (letrec* (... id (f (-> (λ (n) ...) <-)) g ...) ...)
  (env ((app * n (-> (app f (app - n 1)) <-)))))
clos/con:
	'((λ (n) (-> (match (app <= n 1) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  <=
  (letrec* (... id (f (-> (λ (n) ...) <-)) g ...) ...)
  (env ((app + (-> (app (app id f) 3) <-) (app (app id g) 4)))))
clos/con:
	'((λ (n) (-> (match (app <= n 1) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  f
  (letrec* (... id (f (-> (λ (n) ...) <-)) g ...) ...)
  (env ((app * n (-> (app f (app - n 1)) <-)))))
clos/con:
	'((letrec* (... id (f (-> (λ (n) ...) <-)) g ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  f
  (letrec* (... id (f (-> (λ (n) ...) <-)) g ...) ...)
  (env ((app + (-> (app (app id f) 3) <-) (app (app id g) 4)))))
clos/con:
	'((letrec* (... id (f (-> (λ (n) ...) <-)) g ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  g
  (letrec* (... f (g (-> (λ (n) ...) <-)) () ...) ...)
  (env ((app * n (-> (app g (app - n 1)) <-)))))
clos/con:
	'((letrec* (... f (g (-> (λ (n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  g
  (letrec* (... f (g (-> (λ (n) ...) <-)) () ...) ...)
  (env ((app + (app (app id f) 3) (-> (app (app id g) 4) <-)))))
clos/con:
	'((letrec* (... f (g (-> (λ (n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n
  (letrec* (... f (g (-> (λ (n) ...) <-)) () ...) ...)
  (env ((app * n (-> (app g (app - n 1)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  n
  (letrec* (... f (g (-> (λ (n) ...) <-)) () ...) ...)
  (env ((app + (app (app id f) 3) (-> (app (app id g) 4) <-)))))
clos/con: ⊥
literals: '(4 ⊥ ⊥)

'(store:
  n
  (letrec* (... id (f (-> (λ (n) ...) <-)) g ...) ...)
  (env ((app * n (-> (app f (app - n 1)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  n
  (letrec* (... id (f (-> (λ (n) ...) <-)) g ...) ...)
  (env ((app + (-> (app (app id f) 3) <-) (app (app id g) 4)))))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(store:
  x
  (letrec* (... () (id (-> (λ (x) ...) <-)) f ...) ...)
  (env ((app (-> (app id f) <-) 3))))
clos/con:
	'((letrec* (... id (f (-> (λ (n) ...) <-)) g ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x
  (letrec* (... () (id (-> (λ (x) ...) <-)) f ...) ...)
  (env ((app (-> (app id g) <-) 4))))
clos/con:
	'((letrec* (... f (g (-> (λ (n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: f ((top) letrec* (id ... g) ...) (env ()))
clos/con:
	'((letrec* (... id (f (-> (λ (n) ...) <-)) g ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: g ((top) letrec* (id ... g) ...) (env ()))
clos/con:
	'((letrec* (... f (g (-> (λ (n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: id ((top) letrec* (id ... g) ...) (env ()))
clos/con:
	'((letrec* (... () (id (-> (λ (x) ...) <-)) f ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)
