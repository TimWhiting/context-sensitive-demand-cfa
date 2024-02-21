'(expression:
  (letrec*
   ((tak
     (λ (x y z)
       (match
        (app not (app < y x))
        ((#f)
         (app
          tak
          (app tak (app - x 1) y z)
          (app tak (app - y 1) z x)
          (app tak (app - z 1) x y)))
        (_ z)))))
   (app tak 32 15 8)))

'(query: (λ (x y z) (-> (match (app not (app < y x)) ...) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app tak (-> (app - z 1) <-) x y) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: ((top) letrec* (tak) ...) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query:
  (app
   (-> tak <-)
   (app tak (app - x 1) y z)
   (app tak (app - y 1) z x)
   (app tak (app - z 1) x y))
  (env ()))
clos/con:
	'((letrec* (... () (tak (-> (λ (x y z) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app tak (app - z 1) x (-> y <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (match (app not (app < y x)) (#f) (_ (-> z <-))) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app - (-> z <-) 1) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app tak (app - y 1) z (-> x <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app tak (-> 32 <-) 15 8) (env ()))
clos/con: ⊥
literals: '(32 ⊥ ⊥ ⊥)

'(query: (app (-> tak <-) (app - y 1) z x) (env ()))
clos/con:
	'((letrec* (... () (tak (-> (λ (x y z) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app tak (-> (app - y 1) <-) z x) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app not (-> (app < y x) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> - <-) z 1) (env ()))
clos/con:
	#<procedure:do-sub>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> (app not (app < y x)) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app tak 32 15 (-> 8 <-)) (env ()))
clos/con: ⊥
literals: '(8 ⊥ ⊥ ⊥)

'(query: (letrec* (... () (tak (-> (λ (x y z) ...) <-)) () ...) ...) (env ()))
clos/con:
	'((letrec* (... () (tak (-> (λ (x y z) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app tak (app - z 1) (-> x <-) y) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query:
  (app
   tak
   (app tak (app - x 1) y z)
   (-> (app tak (app - y 1) z x) <-)
   (app tak (app - z 1) x y))
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (letrec* (tak) (-> (app tak 32 15 8) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app - (-> y <-) 1) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query:
  (app
   tak
   (app tak (app - x 1) y z)
   (app tak (app - y 1) z x)
   (-> (app tak (app - z 1) x y) <-))
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> - <-) x 1) (env ()))
clos/con:
	#<procedure:do-sub>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app tak (app - y 1) (-> z <-) x) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app - (-> x <-) 1) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app < (-> y <-) x) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> < <-) y x) (env ()))
clos/con:
	#<procedure:do-lt>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app tak 32 (-> 15 <-) 8) (env ()))
clos/con: ⊥
literals: '(15 ⊥ ⊥ ⊥)

'(query: (app (-> - <-) y 1) (env ()))
clos/con:
	#<procedure:do-sub>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app - z (-> 1 <-)) (env ()))
clos/con: ⊥
literals: '(1 ⊥ ⊥ ⊥)

'(query: (app < y (-> x <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> tak <-) (app - z 1) x y) (env ()))
clos/con:
	'((letrec* (... () (tak (-> (λ (x y z) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match
   (app not (app < y x))
   ((#f)
    (->
     (app
      tak
      (app tak (app - x 1) y z)
      (app tak (app - y 1) z x)
      (app tak (app - z 1) x y))
     <-))
   _)
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app - y (-> 1 <-)) (env ()))
clos/con: ⊥
literals: '(1 ⊥ ⊥ ⊥)

'(query:
  (app
   tak
   (-> (app tak (app - x 1) y z) <-)
   (app tak (app - y 1) z x)
   (app tak (app - z 1) x y))
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> tak <-) 32 15 8) (env ()))
clos/con:
	'((letrec* (... () (tak (-> (λ (x y z) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> tak <-) (app - x 1) y z) (env ()))
clos/con:
	'((letrec* (... () (tak (-> (λ (x y z) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app - x (-> 1 <-)) (env ()))
clos/con: ⊥
literals: '(1 ⊥ ⊥ ⊥)

'(query: (app tak (app - x 1) y (-> z <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> not <-) (app < y x)) (env ()))
clos/con:
	#<procedure:do-not>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app tak (-> (app - x 1) <-) y z) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app tak (app - x 1) (-> y <-) z) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: tak (env ()))
clos/con:
	'((letrec* (... () (tak (-> (λ (x y z) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: x (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: z (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: y (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)
