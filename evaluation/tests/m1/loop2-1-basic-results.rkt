'(expression:
  (letrec ((lp1
            (λ (i x)
              (match
               (app = 0 i)
               ((#f)
                (letrec ((lp2
                          (λ (j f y)
                            (match
                             (app = 0 j)
                             ((#f) (app lp2 (app - j 1) f (app f y)))
                             (_ (app lp1 (app - i 1) y))))))
                  (app lp2 10 (λ (n) (app + n i)) x)))
               (_ x)))))
    (app lp1 10 0)))

'(query: ((top) letrec (lp1) ...) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (letrec (... () (lp1 (-> (λ (i x) ...) <-)) () ...) ...) (env ()))
clos/con:
	'((letrec (... () (lp1 (-> (λ (i x) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (i x) (-> (match (app = 0 i) ...) <-)) (env ((□? (i x)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (match (app = 0 i) (#f) (_ (-> x <-))) (env ((□? (i x)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app = 0 i) ((#f) (-> (letrec (lp2) ...) <-)) _)
  (env ((□? (i x)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (letrec (... () (lp2 (-> (λ (j f y) ...) <-)) () ...) ...)
  (env ((□? (i x)))))
clos/con:
	'((letrec (... () (lp2 (-> (λ (j f y) ...) <-)) () ...) ...)
  (env ((□? (i x)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (j f y) (-> (match (app = 0 j) ...) <-))
  (env ((□? (j f y)) (□? (i x)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))
  (env ((□? (j f y)) (□? (i x)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app lp1 (app - i 1) (-> y <-)) (env ((□? (j f y)) (□? (i x)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app lp1 (-> (app - i 1) <-) y) (env ((□? (j f y)) (□? (i x)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app - i (-> 1 <-)) (env ((□? (j f y)) (□? (i x)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app - (-> i <-) 1) (env ((□? (j f y)) (□? (i x)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> - <-) i 1) (env ((□? (j f y)) (□? (i x)))))
clos/con:
	'((prim -) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> lp1 <-) (app - i 1) y) (env ((□? (j f y)) (□? (i x)))))
clos/con:
	'((letrec (... () (lp1 (-> (λ (i x) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app = 0 j) ((#f) (-> (app lp2 (app - j 1) f (app f y)) <-)) _)
  (env ((□? (j f y)) (□? (i x)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app lp2 (app - j 1) f (-> (app f y) <-))
  (env ((□? (j f y)) (□? (i x)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app f (-> y <-)) (env ((□? (j f y)) (□? (i x)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> f <-) y) (env ((□? (j f y)) (□? (i x)))))
clos/con:
	'((app lp2 10 (-> (λ (n) ...) <-) x) (env ((□? (i x)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app lp2 (app - j 1) (-> f <-) (app f y))
  (env ((□? (j f y)) (□? (i x)))))
clos/con:
	'((app lp2 10 (-> (λ (n) ...) <-) x) (env ((□? (i x)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app lp2 (-> (app - j 1) <-) f (app f y))
  (env ((□? (j f y)) (□? (i x)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app - j (-> 1 <-)) (env ((□? (j f y)) (□? (i x)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app - (-> j <-) 1) (env ((□? (j f y)) (□? (i x)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> - <-) j 1) (env ((□? (j f y)) (□? (i x)))))
clos/con:
	'((prim -) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> lp2 <-) (app - j 1) f (app f y))
  (env ((□? (j f y)) (□? (i x)))))
clos/con:
	'((letrec (... () (lp2 (-> (λ (j f y) ...) <-)) () ...) ...)
  (env ((□? (i x)))))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app = 0 j) <-) (#f) _) (env ((□? (j f y)) (□? (i x)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app = 0 (-> j <-)) (env ((□? (j f y)) (□? (i x)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app = (-> 0 <-) j) (env ((□? (j f y)) (□? (i x)))))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query: (app (-> = <-) 0 j) (env ((□? (j f y)) (□? (i x)))))
clos/con:
	'((prim =) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (letrec (lp2) (-> (app lp2 10 (λ (n) ...) x) <-)) (env ((□? (i x)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app lp2 10 (λ (n) ...) (-> x <-)) (env ((□? (i x)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app lp2 10 (-> (λ (n) ...) <-) x) (env ((□? (i x)))))
clos/con:
	'((app lp2 10 (-> (λ (n) ...) <-) x) (env ((□? (i x)))))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (n) (-> (app + n i) <-)) (env ((□? (n)) (□? (i x)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app + n (-> i <-)) (env ((□? (n)) (□? (i x)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app + (-> n <-) i) (env ((□? (n)) (□? (i x)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> + <-) n i) (env ((□? (n)) (□? (i x)))))
clos/con:
	'((prim +) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app lp2 (-> 10 <-) (λ (n) ...) x) (env ((□? (i x)))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query: (app (-> lp2 <-) 10 (λ (n) ...) x) (env ((□? (i x)))))
clos/con:
	'((letrec (... () (lp2 (-> (λ (j f y) ...) <-)) () ...) ...)
  (env ((□? (i x)))))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app = 0 i) <-) (#f) _) (env ((□? (i x)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app = 0 (-> i <-)) (env ((□? (i x)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app = (-> 0 <-) i) (env ((□? (i x)))))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query: (app (-> = <-) 0 i) (env ((□? (i x)))))
clos/con:
	'((prim =) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (letrec (lp1) (-> (app lp1 10 0) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app lp1 10 (-> 0 <-)) (env ()))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query: (app lp1 (-> 10 <-) 0) (env ()))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query: (app (-> lp1 <-) 10 0) (env ()))
clos/con:
	'((letrec (... () (lp1 (-> (λ (i x) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)
