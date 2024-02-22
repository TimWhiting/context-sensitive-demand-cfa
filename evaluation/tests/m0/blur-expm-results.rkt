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
  (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (let* (... r (s (-> (app (app blur id) (app #f)) <-)) () ...) ...)
  (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (let* (r ... s) (-> (app not (app (app blur lp) s (app - n 1))) <-))
  (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: ((top) letrec (id ... lp) ...) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ()))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> (app blur id) <-) (app #f)) (env (())))
clos/con:
	'((letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (env ()))
	'((letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> (app blur id) <-) (app #t)) (env (())))
clos/con:
	'((letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (env ()))
	'((letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> (app blur lp) <-) s (app - n 1)) (env (())))
clos/con:
	'((letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (env ()))
	'((letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> - <-) n 1) (env (())))
clos/con:
	#<procedure:do-sub>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> <= <-) n 1) (env (())))
clos/con:
	#<procedure:do-lte>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> blur <-) id) (env (())))
clos/con:
	'((letrec (... id (blur (-> (λ (y) ...) <-)) lp ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> blur <-) id) (env (())))
clos/con:
	'((letrec (... id (blur (-> (λ (y) ...) <-)) lp ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> blur <-) lp) (env (())))
clos/con:
	'((letrec (... id (blur (-> (λ (y) ...) <-)) lp ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> id <-) a) (env (())))
clos/con:
	'((letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> lp <-) (app #f) 2) (env ()))
clos/con:
	'((letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> not <-) (app (app blur lp) s (app - n 1))) (env (())))
clos/con:
	#<procedure:do-not>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (app blur id) (-> (app #f) <-)) (env (())))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (app blur id) (-> (app #t) <-)) (env (())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (app blur lp) (-> s <-) (app - n 1)) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (app blur lp) s (-> (app - n 1) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app - (-> n <-) 1) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app - n (-> 1 <-)) (env (())))
clos/con: ⊥
literals: '(1 ⊥ ⊥ ⊥)

'(query: (app <= (-> n <-) 1) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app <= n (-> 1 <-)) (env (())))
clos/con: ⊥
literals: '(1 ⊥ ⊥ ⊥)

'(query: (app blur (-> id <-)) (env (())))
clos/con:
	'((letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app blur (-> id <-)) (env (())))
clos/con:
	'((letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app blur (-> lp <-)) (env (())))
clos/con:
	'((letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app id (-> a <-)) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app lp (-> (app #f) <-) 2) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app lp (app #f) (-> 2 <-)) (env ()))
clos/con: ⊥
literals: '(2 ⊥ ⊥ ⊥)

'(query: (app not (-> (app (app blur lp) s (app - n 1)) <-)) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (env ()))
clos/con:
	'((letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...) (env ()))
clos/con:
	'((letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (letrec (... id (blur (-> (λ (y) ...) <-)) lp ...) ...) (env ()))
clos/con:
	'((letrec (... id (blur (-> (λ (y) ...) <-)) lp ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (letrec (id ... lp) (-> (app lp (app #f) 2) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> (app <= n 1) <-) (#f) _) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (app <= n 1) (#f) (_ (-> (app id a) <-))) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (app <= n 1) ((#f) (-> (let* (r ... s) ...) <-)) _) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (a n) (-> (match (app <= n 1) ...) <-)) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (x) (-> x <-)) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (y) (-> y <-)) (env (())))
clos/con:
	'((letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (env ()))
	'((letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: a (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: blur (env ()))
clos/con:
	'((letrec (... id (blur (-> (λ (y) ...) <-)) lp ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: id (env ()))
clos/con:
	'((letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: lp (env ()))
clos/con:
	'((letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: n (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: r (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: s (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: x (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: y (env (())))
clos/con:
	'((letrec (... () (id (-> (λ (x) ...) <-)) blur ...) ...) (env ()))
	'((letrec (... blur (lp (-> (λ (a n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)
