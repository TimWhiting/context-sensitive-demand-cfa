'(expression:
  (letrec ((id (λ (x) x))
           (blur (λ (y) y))
           (lp
            (λ (a n)
              (match
               (app <= n 1)
               ((#f)
                (let* ((r (app (app blur id) (app #t)))
                       (s (app (app blur id) (app #f))))
                  (app not (app (app blur lp) s (app - n 1)))))
               (_ (app id a))))))
    (app lp (app #f) 2)))

'(query:
  (app (-> #f <-))
  (env (((letrec (id ... lp) (-> (app lp (app #f) 2) <-))))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> #t <-))
  (env (((letrec (id ... lp) (-> (app lp (app #f) 2) <-))))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> (app blur id) <-) (app #f))
  (env (((letrec (id ... lp) (-> (app lp (app #f) 2) <-))))))
clos/con:
	'((letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> (app blur id) <-) (app #t))
  (env (((letrec (id ... lp) (-> (app lp (app #f) 2) <-))))))
clos/con:
	'((letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> (app blur lp) <-) s (app - n 1))
  (env (((letrec (id ... lp) (-> (app lp (app #f) 2) <-))))))
clos/con:
	'((letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> - <-) n 1)
  (env (((letrec (id ... lp) (-> (app lp (app #f) 2) <-))))))
clos/con:
	'((prim -) (env (((letrec (id ... lp) (-> (app lp (app #f) 2) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> <= <-) n 1)
  (env (((app not (-> (app (app blur lp) s (app - n 1)) <-))))))
clos/con:
	'((prim <=) (env (((app not (-> (app (app blur lp) s (app - n 1)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> <= <-) n 1)
  (env (((letrec (id ... lp) (-> (app lp (app #f) 2) <-))))))
clos/con:
	'((prim <=) (env (((letrec (id ... lp) (-> (app lp (app #f) 2) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> blur <-) id)
  (env (((letrec (id ... lp) (-> (app lp (app #f) 2) <-))))))
clos/con:
	'((letrec (... id (blur (-> (λ (y) ...) <-)) lp ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> blur <-) id)
  (env (((letrec (id ... lp) (-> (app lp (app #f) 2) <-))))))
clos/con:
	'((letrec (... id (blur (-> (λ (y) ...) <-)) lp ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> blur <-) lp)
  (env (((letrec (id ... lp) (-> (app lp (app #f) 2) <-))))))
clos/con:
	'((letrec (... id (blur (-> (λ (y) ...) <-)) lp ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> id <-) a)
  (env (((app not (-> (app (app blur lp) s (app - n 1)) <-))))))
clos/con:
	'((letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> not <-) (app (app blur lp) s (app - n 1)))
  (env (((letrec (id ... lp) (-> (app lp (app #f) 2) <-))))))
clos/con:
	'((prim not) (env (((letrec (id ... lp) (-> (app lp (app #f) 2) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (app blur id) (-> (app #f) <-))
  (env (((letrec (id ... lp) (-> (app lp (app #f) 2) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (app blur id) (-> (app #t) <-))
  (env (((letrec (id ... lp) (-> (app lp (app #f) 2) <-))))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (app blur lp) (-> s <-) (app - n 1))
  (env (((letrec (id ... lp) (-> (app lp (app #f) 2) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (app blur lp) s (-> (app - n 1) <-))
  (env (((letrec (id ... lp) (-> (app lp (app #f) 2) <-))))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (app - (-> n <-) 1)
  (env (((letrec (id ... lp) (-> (app lp (app #f) 2) <-))))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query:
  (app - n (-> 1 <-))
  (env (((letrec (id ... lp) (-> (app lp (app #f) 2) <-))))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (app <= (-> n <-) 1)
  (env (((app not (-> (app (app blur lp) s (app - n 1)) <-))))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (app <= (-> n <-) 1)
  (env (((letrec (id ... lp) (-> (app lp (app #f) 2) <-))))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query:
  (app <= n (-> 1 <-))
  (env (((app not (-> (app (app blur lp) s (app - n 1)) <-))))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (app <= n (-> 1 <-))
  (env (((letrec (id ... lp) (-> (app lp (app #f) 2) <-))))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (app blur (-> id <-))
  (env (((letrec (id ... lp) (-> (app lp (app #f) 2) <-))))))
clos/con:
	'((letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app blur (-> id <-))
  (env (((letrec (id ... lp) (-> (app lp (app #f) 2) <-))))))
clos/con:
	'((letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app blur (-> lp <-))
  (env (((letrec (id ... lp) (-> (app lp (app #f) 2) <-))))))
clos/con:
	'((letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app id (-> a <-))
  (env (((app not (-> (app (app blur lp) s (app - n 1)) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app not (-> (app (app blur lp) s (app - n 1)) <-))
  (env (((letrec (id ... lp) (-> (app lp (app #f) 2) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let* (... () (r (-> (app (app blur id) (app #t)) <-)) s ...) ...)
  (env (((letrec (id ... lp) (-> (app lp (app #f) 2) <-))))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let* (... r (s (-> (app (app blur id) (app #f)) <-)) () ...) ...)
  (env (((letrec (id ... lp) (-> (app lp (app #f) 2) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let* (r ... s) (-> (app not (app (app blur lp) s (app - n 1))) <-))
  (env (((letrec (id ... lp) (-> (app lp (app #f) 2) <-))))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app <= n 1) <-) (#f) _)
  (env (((app not (-> (app (app blur lp) s (app - n 1)) <-))))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app <= n 1) <-) (#f) _)
  (env (((letrec (id ... lp) (-> (app lp (app #f) 2) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app <= n 1) (#f) (_ (-> (app id a) <-)))
  (env (((app not (-> (app (app blur lp) s (app - n 1)) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app <= n 1) ((#f) (-> (let* (r ... s) ...) <-)) _)
  (env (((letrec (id ... lp) (-> (app lp (app #f) 2) <-))))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (a n) (-> (match (app <= n 1) ...) <-))
  (env (((app not (-> (app (app blur lp) s (app - n 1)) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (a n) (-> (match (app <= n 1) ...) <-))
  (env (((letrec (id ... lp) (-> (app lp (app #f) 2) <-))))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x) (-> x <-))
  (env (((let* (... () (r (-> (app (app blur id) (app #t)) <-)) s ...) ...)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x) (-> x <-))
  (env (((let* (... r (s (-> (app (app blur id) (app #f)) <-)) () ...) ...)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x) (-> x <-))
  (env (((match (app <= n 1) (#f) (_ (-> (app id a) <-)))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: ((top) letrec (id ... lp) ...) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ()))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> lp <-) (app #f) 2) (env ()))
clos/con:
	'((letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app lp (-> (app #f) <-) 2) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app lp (app #f) (-> 2 <-)) (env ()))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query: (letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (env ()))
clos/con:
	'((letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...) (env ()))
clos/con:
	'((letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (letrec (... id (blur (-> (λ (y) ...) <-)) lp ...) ...) (env ()))
clos/con:
	'((letrec (... id (blur (-> (λ (y) ...) <-)) lp ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (letrec (id ... lp) (-> (app lp (app #f) 2) <-)) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (y) (-> y <-)) (env (((app (-> (app blur id) <-) (app #f))))))
clos/con:
	'((letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (y) (-> y <-)) (env (((app (-> (app blur id) <-) (app #t))))))
clos/con:
	'((letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (y) (-> y <-)) (env (((app (-> (app blur lp) <-) s (app - n 1))))))
clos/con:
	'((letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  a
  (λ (a n) (-> (match (app <= n 1) ...) <-))
  (env (((app not (-> (app (app blur lp) s (app - n 1)) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  a
  (λ (a n) (-> (match (app <= n 1) ...) <-))
  (env (((letrec (id ... lp) (-> (app lp (app #f) 2) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n
  (λ (a n) (-> (match (app <= n 1) ...) <-))
  (env (((app not (-> (app (app blur lp) s (app - n 1)) <-))))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(store:
  n
  (λ (a n) (-> (match (app <= n 1) ...) <-))
  (env (((letrec (id ... lp) (-> (app lp (app #f) 2) <-))))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(store:
  r
  (let* (... () (r (-> (app (app blur id) (app #t)) <-)) s ...) ...)
  (env (((letrec (id ... lp) (-> (app lp (app #f) 2) <-))))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  s
  (let* (... r (s (-> (app (app blur id) (app #f)) <-)) () ...) ...)
  (env (((letrec (id ... lp) (-> (app lp (app #f) 2) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x
  (λ (x) (-> x <-))
  (env (((let* (... () (r (-> (app (app blur id) (app #t)) <-)) s ...) ...)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x
  (λ (x) (-> x <-))
  (env (((let* (... r (s (-> (app (app blur id) (app #f)) <-)) () ...) ...)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x
  (λ (x) (-> x <-))
  (env (((match (app <= n 1) (#f) (_ (-> (app id a) <-)))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  y
  (λ (y) (-> y <-))
  (env (((app (-> (app blur lp) <-) s (app - n 1))))))
clos/con:
	'((letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: blur (letrec (... id (blur (-> (λ (y) ...) <-)) lp ...) ...) (env ()))
clos/con:
	'((letrec (... id (blur (-> (λ (y) ...) <-)) lp ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: id (letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (env ()))
clos/con:
	'((letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: lp (letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...) (env ()))
clos/con:
	'((letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: y (λ (y) (-> y <-)) (env (((app (-> (app blur id) <-) (app #f))))))
clos/con:
	'((letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: y (λ (y) (-> y <-)) (env (((app (-> (app blur id) <-) (app #t))))))
clos/con:
	'((letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)
