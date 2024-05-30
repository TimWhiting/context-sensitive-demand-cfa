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
  (let* (... () (r (-> (app (app blur id) (app #t)) <-)) s ...) ...)
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (let* (... r (s (-> (app (app blur id) (app #f)) <-)) () ...) ...)
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (let* (r ... s) (-> (app not (app (app blur ...) s (app - ...))) <-))
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: ((top) letrec (id ... lp) ...) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> (app blur id) <-) (app #f)) (env ()))
clos/con:
	'((letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (env ()))
	'((letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> (app blur id) <-) (app #t)) (env ()))
clos/con:
	'((letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (env ()))
	'((letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> (app blur lp) <-) s (app - n 1)) (env ()))
clos/con:
	'((letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (env ()))
	'((letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (app blur id) (-> (app #f) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (app blur id) (-> (app #t) <-)) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (app blur lp) (-> s <-) (app - n 1)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (app blur lp) s (-> (app - n 1) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app - (-> n <-) 1) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app <= (-> n <-) 1) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app id (-> a <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app lp (-> (app #f) <-) 2) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app not (-> (app (app blur lp) s (app - n 1)) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (letrec (id ... lp) (-> (app lp (app #f) 2) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> (app <= n 1) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (app <= n 1) (#f) (_ (-> (app id a) <-))) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (app <= n 1) ((#f) (-> (let* (r ... s) ...) <-)) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (a n) (-> (match (app <= n 1) ...) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (x) (-> x <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (y) (-> y <-)) (env ()))
clos/con:
	'((letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (env ()))
	'((letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  r
  (let* (... () (r (-> (app (app blur id) (app #t)) <-)) s ...) ...)
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  s
  (let* (... r (s (-> (app (app blur id) (app #f)) <-)) () ...) ...)
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: a (λ (a n) (-> (match (app <= n 1) ...) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: blur (letrec (... id (blur (-> (λ (y) ...) <-)) lp ...) ...) (env ()))
clos/con:
	'((letrec (... id (blur (-> (λ (y) ...) <-)) lp ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: id (letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (env ()))
clos/con:
	'((letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: lp (letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...) (env ()))
clos/con:
	'((letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: n (λ (a n) (-> (match (app <= n 1) ...) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: x (λ (x) (-> x <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: y (λ (y) (-> y <-)) (env ()))
clos/con:
	'((letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (env ()))
	'((letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)
