'(expression:
  (letrec*
   ((id (λ (x) x))
    (f (λ (n) (match (app <= n 1) ((#f) (app * n (app f (app - n 1)))) (_ 1))))
    (g
     (λ (n) (match (app <= n 1) ((#f) (app * n (app g (app - n 1)))) (_ 1)))))
   (app + (app (app id f) 3) (app (app id g) 4))))

'(query:
  (app * (-> n <-) (app f (app - n 1)))
  (env (((app * n (-> (app f (app - n 1)) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * (-> n <-) (app f (app - n 1)))
  (env (((app + (-> (app (app id f) 3) <-) (app (app id g) 4))))))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(query:
  (app * (-> n <-) (app g (app - n 1)))
  (env (((app * n (-> (app g (app - n 1)) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * (-> n <-) (app g (app - n 1)))
  (env (((app + (app (app id f) 3) (-> (app (app id g) 4) <-))))))
clos/con: ⊥
literals: '(4 ⊥ ⊥)

'(query:
  (app * n (-> (app f (app - n 1)) <-))
  (env (((app * n (-> (app f (app - n 1)) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * n (-> (app f (app - n 1)) <-))
  (env (((app + (-> (app (app id f) 3) <-) (app (app id g) 4))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * n (-> (app g (app - n 1)) <-))
  (env (((app * n (-> (app g (app - n 1)) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * n (-> (app g (app - n 1)) <-))
  (env (((app + (app (app id f) 3) (-> (app (app id g) 4) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> n <-) 1)
  (env (((app + (-> (app (app id f) 3) <-) (app (app id g) 4))))))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(query:
  (app - (-> n <-) 1)
  (env (((app + (app (app id f) 3) (-> (app (app id g) 4) <-))))))
clos/con: ⊥
literals: '(4 ⊥ ⊥)

'(query:
  (app <= (-> n <-) 1)
  (env (((app + (-> (app (app id f) 3) <-) (app (app id g) 4))))))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(query:
  (app <= (-> n <-) 1)
  (env (((app + (app (app id f) 3) (-> (app (app id g) 4) <-))))))
clos/con: ⊥
literals: '(4 ⊥ ⊥)

'(query:
  (app f (-> (app - n 1) <-))
  (env (((app * n (-> (app f (app - n 1)) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app f (-> (app - n 1) <-))
  (env (((app + (-> (app (app id f) 3) <-) (app (app id g) 4))))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query:
  (app g (-> (app - n 1) <-))
  (env (((app * n (-> (app g (app - n 1)) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app g (-> (app - n 1) <-))
  (env (((app + (app (app id f) 3) (-> (app (app id g) 4) <-))))))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(query:
  (letrec* (id ... g) (-> (app + (app (app id f) 3) (app (app id g) 4)) <-))
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (-> (app <= n 1) <-) (#f) _)
  (env (((app * n (-> (app f (app - n 1)) <-))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app <= n 1) <-) (#f) _)
  (env (((app * n (-> (app g (app - n 1)) <-))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app <= n 1) <-) (#f) _)
  (env (((app + (-> (app (app id f) 3) <-) (app (app id g) 4))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app <= n 1) <-) (#f) _)
  (env (((app + (app (app id f) 3) (-> (app (app id g) 4) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app <= n 1) ((#f) (-> (app * n (app f (app - n 1))) <-)) _)
  (env (((app * n (-> (app f (app - n 1)) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app <= n 1) ((#f) (-> (app * n (app f (app - n 1))) <-)) _)
  (env (((app + (-> (app (app id f) 3) <-) (app (app id g) 4))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app <= n 1) ((#f) (-> (app * n (app g (app - n 1))) <-)) _)
  (env (((app * n (-> (app g (app - n 1)) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app <= n 1) ((#f) (-> (app * n (app g (app - n 1))) <-)) _)
  (env (((app + (app (app id f) 3) (-> (app (app id g) 4) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (n) (-> (match (app <= n 1) ...) <-))
  (env (((app * n (-> (app f (app - n 1)) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (n) (-> (match (app <= n 1) ...) <-))
  (env (((app * n (-> (app g (app - n 1)) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (n) (-> (match (app <= n 1) ...) <-))
  (env (((app + (-> (app (app id f) 3) <-) (app (app id g) 4))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (n) (-> (match (app <= n 1) ...) <-))
  (env (((app + (app (app id f) 3) (-> (app (app id g) 4) <-))))))
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

'(query: (app + (-> (app (app id f) 3) <-) (app (app id g) 4)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app + (app (app id f) 3) (-> (app (app id g) 4) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app - (-> n <-) 1) (env (((app * n (-> (app f (app - n 1)) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app - (-> n <-) 1) (env (((app * n (-> (app g (app - n 1)) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app <= (-> n <-) 1) (env (((app * n (-> (app f (app - n 1)) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app <= (-> n <-) 1) (env (((app * n (-> (app g (app - n 1)) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (λ (x) (-> x <-)) (env (((app (-> (app id f) <-) 3)))))
clos/con:
	'((letrec* (... id (f (-> (λ (n) ...) <-)) g ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (x) (-> x <-)) (env (((app (-> (app id g) <-) 4)))))
clos/con:
	'((letrec* (... f (g (-> (λ (n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n
  (λ (n) (-> (match (app <= n 1) ...) <-))
  (env (((app * n (-> (app f (app - n 1)) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  n
  (λ (n) (-> (match (app <= n 1) ...) <-))
  (env (((app * n (-> (app g (app - n 1)) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  n
  (λ (n) (-> (match (app <= n 1) ...) <-))
  (env (((app + (-> (app (app id f) 3) <-) (app (app id g) 4))))))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(store:
  n
  (λ (n) (-> (match (app <= n 1) ...) <-))
  (env (((app + (app (app id f) 3) (-> (app (app id g) 4) <-))))))
clos/con: ⊥
literals: '(4 ⊥ ⊥)

'(store: f (letrec* (... id (f (-> (λ (n) ...) <-)) g ...) ...) (env ()))
clos/con:
	'((letrec* (... id (f (-> (λ (n) ...) <-)) g ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: g (letrec* (... f (g (-> (λ (n) ...) <-)) () ...) ...) (env ()))
clos/con:
	'((letrec* (... f (g (-> (λ (n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: id (letrec* (... () (id (-> (λ (x) ...) <-)) f ...) ...) (env ()))
clos/con:
	'((letrec* (... () (id (-> (λ (x) ...) <-)) f ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: x (λ (x) (-> x <-)) (env (((app (-> (app id f) <-) 3)))))
clos/con:
	'((letrec* (... id (f (-> (λ (n) ...) <-)) g ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: x (λ (x) (-> x <-)) (env (((app (-> (app id g) <-) 4)))))
clos/con:
	'((letrec* (... f (g (-> (λ (n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)
