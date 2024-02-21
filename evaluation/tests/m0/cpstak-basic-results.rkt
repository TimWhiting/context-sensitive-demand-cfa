'(expression:
  (letrec*
   ((cpstak
     (λ (x y z)
       (letrec*
        ((tak
          (λ (x y z k)
            (match
             (app not (app < y x))
             ((#f)
              (app
               tak
               (app - x 1)
               y
               z
               (λ (v1)
                 (app
                  tak
                  (app - y 1)
                  z
                  x
                  (λ (v2)
                    (app
                     tak
                     (app - z 1)
                     x
                     y
                     (λ (v3) (app tak v1 v2 v3 k))))))))
             (_ (app k z))))))
        (app tak x y z (λ (a) a))))))
   (app cpstak 32 15 8)))

'(query: ((top) letrec* (cpstak) ...) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query:
  (letrec* (... () (cpstak (-> (λ (x y z) ...) <-)) () ...) ...)
  (env ()))
clos/con:
	'((letrec* (... () (cpstak (-> (λ (x y z) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (x y z) (-> (letrec* (tak) ...) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query:
  (letrec* (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...)
  (env (())))
clos/con:
	'((letrec* (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...) (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (x y z k) (-> (match (app not (app < y x)) ...) <-)) (env (() ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query:
  (match (app not (app < y x)) (#f) (_ (-> (app k z) <-)))
  (env (() ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app k (-> z <-)) (env (() ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> k <-) z) (env (() ())))
clos/con:
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-)) (env (() ())))
	'((app tak (app - y 1) z x (-> (λ (v2) ...) <-)) (env (() () ())))
	'((app tak (app - z 1) x y (-> (λ (v3) ...) <-)) (env (() () () ())))
	'((app tak x y z (-> (λ (a) ...) <-)) (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match
   (app not (app < y x))
   ((#f) (-> (app tak (app - x 1) y z (λ (v1) ...)) <-))
   _)
  (env (() ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app tak (app - x 1) y z (-> (λ (v1) ...) <-)) (env (() ())))
clos/con:
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-)) (env (() ())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (λ (v1) (-> (app tak (app - y 1) z x (λ (v2) ...)) <-))
  (env (() () ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app tak (app - y 1) z x (-> (λ (v2) ...) <-)) (env (() () ())))
clos/con:
	'((app tak (app - y 1) z x (-> (λ (v2) ...) <-)) (env (() () ())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (λ (v2) (-> (app tak (app - z 1) x y (λ (v3) ...)) <-))
  (env (() () () ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app tak (app - z 1) x y (-> (λ (v3) ...) <-)) (env (() () () ())))
clos/con:
	'((app tak (app - z 1) x y (-> (λ (v3) ...) <-)) (env (() () () ())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (v3) (-> (app tak v1 v2 v3 k) <-)) (env (() () () () ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app tak v1 v2 v3 (-> k <-)) (env (() () () () ())))
clos/con:
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-)) (env (() ())))
	'((app tak (app - y 1) z x (-> (λ (v2) ...) <-)) (env (() () ())))
	'((app tak (app - z 1) x y (-> (λ (v3) ...) <-)) (env (() () () ())))
	'((app tak x y z (-> (λ (a) ...) <-)) (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app tak v1 v2 (-> v3 <-) k) (env (() () () () ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app tak v1 (-> v2 <-) v3 k) (env (() () () () ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app tak (-> v1 <-) v2 v3 k) (env (() () () () ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> tak <-) v1 v2 v3 k) (env (() () () () ())))
clos/con:
	'((letrec* (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...) (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app tak (app - z 1) x (-> y <-) (λ (v3) ...)) (env (() () () ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app tak (app - z 1) (-> x <-) y (λ (v3) ...)) (env (() () () ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app tak (-> (app - z 1) <-) x y (λ (v3) ...)) (env (() () () ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app - z (-> 1 <-)) (env (() () () ())))
clos/con: ⊥
literals: '(1 ⊥ ⊥ ⊥)

'(query: (app - (-> z <-) 1) (env (() () () ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> - <-) z 1) (env (() () () ())))
clos/con:
	#<procedure:do-sub>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> tak <-) (app - z 1) x y (λ (v3) ...)) (env (() () () ())))
clos/con:
	'((letrec* (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...) (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app tak (app - y 1) z (-> x <-) (λ (v2) ...)) (env (() () ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app tak (app - y 1) (-> z <-) x (λ (v2) ...)) (env (() () ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app tak (-> (app - y 1) <-) z x (λ (v2) ...)) (env (() () ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app - y (-> 1 <-)) (env (() () ())))
clos/con: ⊥
literals: '(1 ⊥ ⊥ ⊥)

'(query: (app - (-> y <-) 1) (env (() () ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> - <-) y 1) (env (() () ())))
clos/con:
	#<procedure:do-sub>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> tak <-) (app - y 1) z x (λ (v2) ...)) (env (() () ())))
clos/con:
	'((letrec* (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...) (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app tak (app - x 1) y (-> z <-) (λ (v1) ...)) (env (() ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app tak (app - x 1) (-> y <-) z (λ (v1) ...)) (env (() ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app tak (-> (app - x 1) <-) y z (λ (v1) ...)) (env (() ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app - x (-> 1 <-)) (env (() ())))
clos/con: ⊥
literals: '(1 ⊥ ⊥ ⊥)

'(query: (app - (-> x <-) 1) (env (() ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> - <-) x 1) (env (() ())))
clos/con:
	#<procedure:do-sub>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> tak <-) (app - x 1) y z (λ (v1) ...)) (env (() ())))
clos/con:
	'((letrec* (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...) (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> (app not (app < y x)) <-) (#f) _) (env (() ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app not (-> (app < y x) <-)) (env (() ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app < y (-> x <-)) (env (() ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app < (-> y <-) x) (env (() ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> < <-) y x) (env (() ())))
clos/con:
	#<procedure:do-lt>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> not <-) (app < y x)) (env (() ())))
clos/con:
	#<procedure:do-demand-not>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (letrec* (tak) (-> (app tak x y z (λ (a) ...)) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app tak x y z (-> (λ (a) ...) <-)) (env (())))
clos/con:
	'((app tak x y z (-> (λ (a) ...) <-)) (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (a) (-> a <-)) (env (() ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app tak x y (-> z <-) (λ (a) ...)) (env (())))
clos/con: ⊥
literals: '(8 ⊥ ⊥ ⊥)

'(query: (app tak x (-> y <-) z (λ (a) ...)) (env (())))
clos/con: ⊥
literals: '(15 ⊥ ⊥ ⊥)

'(query: (app tak (-> x <-) y z (λ (a) ...)) (env (())))
clos/con: ⊥
literals: '(32 ⊥ ⊥ ⊥)

'(query: (app (-> tak <-) x y z (λ (a) ...)) (env (())))
clos/con:
	'((letrec* (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...) (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (letrec* (cpstak) (-> (app cpstak 32 15 8) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app cpstak 32 15 (-> 8 <-)) (env ()))
clos/con: ⊥
literals: '(8 ⊥ ⊥ ⊥)

'(query: (app cpstak 32 (-> 15 <-) 8) (env ()))
clos/con: ⊥
literals: '(15 ⊥ ⊥ ⊥)

'(query: (app cpstak (-> 32 <-) 15 8) (env ()))
clos/con: ⊥
literals: '(32 ⊥ ⊥ ⊥)

'(query: (app (-> cpstak <-) 32 15 8) (env ()))
clos/con:
	'((letrec* (... () (cpstak (-> (λ (x y z) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)
