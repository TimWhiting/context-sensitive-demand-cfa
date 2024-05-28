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
literals: '(⊤ ⊥ ⊥)

'(query:
  (letrec* (... () (cpstak (-> (λ (x y z) ...) <-)) () ...) ...)
  (env ()))
clos/con:
	'((letrec* (... () (cpstak (-> (λ (x y z) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (x y z) (-> (letrec* (tak) ...) <-)) (env ((□? (x y z)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (letrec* (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...)
  (env ((□? (x y z)))))
clos/con:
	'((letrec* (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...)
  (env ((□? (x y z)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x y z k) (-> (match (app not (app < y x)) ...) <-))
  (env ((□? (x y z k)) (□? (x y z)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app not (app < y x)) (#f) (_ (-> (app k z) <-)))
  (env ((□? (x y z k)) (□? (x y z)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app k (-> z <-)) (env ((□? (x y z k)) (□? (x y z)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> k <-) z) (env ((□? (x y z k)) (□? (x y z)))))
clos/con:
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-))
  (env
   (((match
      (app not (app < y x))
      ((#f) (-> (app tak (app - x 1) y z (λ (v1) ...)) <-))
      _))
    (□? (x y z)))))
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-))
  (env
   (((λ (v1) (-> (app tak (app - y 1) z x (λ (v2) ...)) <-))) (□? (x y z)))))
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-))
  (env
   (((λ (v2) (-> (app tak (app - z 1) x y (λ (v3) ...)) <-))) (□? (x y z)))))
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-))
  (env (((letrec* (tak) (-> (app tak x y z (λ (a) ...)) <-))) (□? (x y z)))))
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-))
  (env (((λ (v3) (-> (app tak v1 v2 v3 k) <-))) (□? (x y z)))))
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-))
  (env ((□? (x y z k)) (□? (x y z)))))
	'((app tak (app - y 1) z x (-> (λ (v2) ...) <-))
  (env
   ((□? (v1))
    ((letrec* (tak) (-> (app tak x y z (λ (a) ...)) <-)))
    (□? (x y z)))))
	'((app tak (app - y 1) z x (-> (λ (v2) ...) <-))
  (env
   ((□? (v1))
    ((match
      (app not (app < y x))
      ((#f) (-> (app tak (app - x 1) y z (λ (v1) ...)) <-))
      _))
    (□? (x y z)))))
	'((app tak (app - y 1) z x (-> (λ (v2) ...) <-))
  (env
   ((□? (v1))
    ((λ (v1) (-> (app tak (app - y 1) z x (λ (v2) ...)) <-)))
    (□? (x y z)))))
	'((app tak (app - y 1) z x (-> (λ (v2) ...) <-))
  (env
   ((□? (v1))
    ((λ (v2) (-> (app tak (app - z 1) x y (λ (v3) ...)) <-)))
    (□? (x y z)))))
	'((app tak (app - y 1) z x (-> (λ (v2) ...) <-))
  (env ((□? (v1)) ((λ (v3) (-> (app tak v1 v2 v3 k) <-))) (□? (x y z)))))
	'((app tak (app - y 1) z x (-> (λ (v2) ...) <-))
  (env ((□? (v1)) (□? (x y z k)) (□? (x y z)))))
	'((app tak (app - z 1) x y (-> (λ (v3) ...) <-))
  (env
   ((□? (v2))
    (□? (v1))
    ((letrec* (tak) (-> (app tak x y z (λ (a) ...)) <-)))
    (□? (x y z)))))
	'((app tak (app - z 1) x y (-> (λ (v3) ...) <-))
  (env
   ((□? (v2))
    (□? (v1))
    ((match
      (app not (app < y x))
      ((#f) (-> (app tak (app - x 1) y z (λ (v1) ...)) <-))
      _))
    (□? (x y z)))))
	'((app tak (app - z 1) x y (-> (λ (v3) ...) <-))
  (env
   ((□? (v2))
    (□? (v1))
    ((λ (v1) (-> (app tak (app - y 1) z x (λ (v2) ...)) <-)))
    (□? (x y z)))))
	'((app tak (app - z 1) x y (-> (λ (v3) ...) <-))
  (env
   ((□? (v2))
    (□? (v1))
    ((λ (v2) (-> (app tak (app - z 1) x y (λ (v3) ...)) <-)))
    (□? (x y z)))))
	'((app tak (app - z 1) x y (-> (λ (v3) ...) <-))
  (env
   ((□? (v2)) (□? (v1)) ((λ (v3) (-> (app tak v1 v2 v3 k) <-))) (□? (x y z)))))
	'((app tak (app - z 1) x y (-> (λ (v3) ...) <-))
  (env ((□? (v2)) (□? (v1)) (□? (x y z k)) (□? (x y z)))))
	'((app tak x y z (-> (λ (a) ...) <-)) (env ((□? (x y z)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app not (app < y x))
   ((#f) (-> (app tak (app - x 1) y z (λ (v1) ...)) <-))
   _)
  (env ((□? (x y z k)) (□? (x y z)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (app - x 1) y z (-> (λ (v1) ...) <-))
  (env ((□? (x y z k)) (□? (x y z)))))
clos/con:
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-))
  (env ((□? (x y z k)) (□? (x y z)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (v1) (-> (app tak (app - y 1) z x (λ (v2) ...)) <-))
  (env ((□? (v1)) (□? (x y z k)) (□? (x y z)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (app - y 1) z x (-> (λ (v2) ...) <-))
  (env ((□? (v1)) (□? (x y z k)) (□? (x y z)))))
clos/con:
	'((app tak (app - y 1) z x (-> (λ (v2) ...) <-))
  (env ((□? (v1)) (□? (x y z k)) (□? (x y z)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (v2) (-> (app tak (app - z 1) x y (λ (v3) ...)) <-))
  (env ((□? (v2)) (□? (v1)) (□? (x y z k)) (□? (x y z)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (app - z 1) x y (-> (λ (v3) ...) <-))
  (env ((□? (v2)) (□? (v1)) (□? (x y z k)) (□? (x y z)))))
clos/con:
	'((app tak (app - z 1) x y (-> (λ (v3) ...) <-))
  (env ((□? (v2)) (□? (v1)) (□? (x y z k)) (□? (x y z)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (v3) (-> (app tak v1 v2 v3 k) <-))
  (env ((□? (v3)) (□? (v2)) (□? (v1)) (□? (x y z k)) (□? (x y z)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak v1 v2 v3 (-> k <-))
  (env ((□? (v3)) (□? (v2)) (□? (v1)) (□? (x y z k)) (□? (x y z)))))
clos/con:
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-))
  (env
   (((match
      (app not (app < y x))
      ((#f) (-> (app tak (app - x 1) y z (λ (v1) ...)) <-))
      _))
    (□? (x y z)))))
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-))
  (env
   (((λ (v1) (-> (app tak (app - y 1) z x (λ (v2) ...)) <-))) (□? (x y z)))))
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-))
  (env
   (((λ (v2) (-> (app tak (app - z 1) x y (λ (v3) ...)) <-))) (□? (x y z)))))
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-))
  (env (((letrec* (tak) (-> (app tak x y z (λ (a) ...)) <-))) (□? (x y z)))))
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-))
  (env (((λ (v3) (-> (app tak v1 v2 v3 k) <-))) (□? (x y z)))))
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-))
  (env ((□? (x y z k)) (□? (x y z)))))
	'((app tak (app - y 1) z x (-> (λ (v2) ...) <-))
  (env
   ((□? (v1))
    ((letrec* (tak) (-> (app tak x y z (λ (a) ...)) <-)))
    (□? (x y z)))))
	'((app tak (app - y 1) z x (-> (λ (v2) ...) <-))
  (env
   ((□? (v1))
    ((match
      (app not (app < y x))
      ((#f) (-> (app tak (app - x 1) y z (λ (v1) ...)) <-))
      _))
    (□? (x y z)))))
	'((app tak (app - y 1) z x (-> (λ (v2) ...) <-))
  (env
   ((□? (v1))
    ((λ (v1) (-> (app tak (app - y 1) z x (λ (v2) ...)) <-)))
    (□? (x y z)))))
	'((app tak (app - y 1) z x (-> (λ (v2) ...) <-))
  (env
   ((□? (v1))
    ((λ (v2) (-> (app tak (app - z 1) x y (λ (v3) ...)) <-)))
    (□? (x y z)))))
	'((app tak (app - y 1) z x (-> (λ (v2) ...) <-))
  (env ((□? (v1)) ((λ (v3) (-> (app tak v1 v2 v3 k) <-))) (□? (x y z)))))
	'((app tak (app - y 1) z x (-> (λ (v2) ...) <-))
  (env ((□? (v1)) (□? (x y z k)) (□? (x y z)))))
	'((app tak (app - z 1) x y (-> (λ (v3) ...) <-))
  (env
   ((□? (v2))
    (□? (v1))
    ((letrec* (tak) (-> (app tak x y z (λ (a) ...)) <-)))
    (□? (x y z)))))
	'((app tak (app - z 1) x y (-> (λ (v3) ...) <-))
  (env
   ((□? (v2))
    (□? (v1))
    ((match
      (app not (app < y x))
      ((#f) (-> (app tak (app - x 1) y z (λ (v1) ...)) <-))
      _))
    (□? (x y z)))))
	'((app tak (app - z 1) x y (-> (λ (v3) ...) <-))
  (env
   ((□? (v2))
    (□? (v1))
    ((λ (v1) (-> (app tak (app - y 1) z x (λ (v2) ...)) <-)))
    (□? (x y z)))))
	'((app tak (app - z 1) x y (-> (λ (v3) ...) <-))
  (env
   ((□? (v2))
    (□? (v1))
    ((λ (v2) (-> (app tak (app - z 1) x y (λ (v3) ...)) <-)))
    (□? (x y z)))))
	'((app tak (app - z 1) x y (-> (λ (v3) ...) <-))
  (env
   ((□? (v2)) (□? (v1)) ((λ (v3) (-> (app tak v1 v2 v3 k) <-))) (□? (x y z)))))
	'((app tak (app - z 1) x y (-> (λ (v3) ...) <-))
  (env ((□? (v2)) (□? (v1)) (□? (x y z k)) (□? (x y z)))))
	'((app tak x y z (-> (λ (a) ...) <-)) (env ((□? (x y z)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app tak v1 v2 (-> v3 <-) k)
  (env ((□? (v3)) (□? (v2)) (□? (v1)) (□? (x y z k)) (□? (x y z)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak v1 (-> v2 <-) v3 k)
  (env ((□? (v3)) (□? (v2)) (□? (v1)) (□? (x y z k)) (□? (x y z)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (-> v1 <-) v2 v3 k)
  (env ((□? (v3)) (□? (v2)) (□? (v1)) (□? (x y z k)) (□? (x y z)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app (-> tak <-) v1 v2 v3 k)
  (env ((□? (v3)) (□? (v2)) (□? (v1)) (□? (x y z k)) (□? (x y z)))))
clos/con:
	'((letrec* (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...)
  (env ((□? (x y z)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app tak (app - z 1) x (-> y <-) (λ (v3) ...))
  (env ((□? (v2)) (□? (v1)) (□? (x y z k)) (□? (x y z)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (app - z 1) (-> x <-) y (λ (v3) ...))
  (env ((□? (v2)) (□? (v1)) (□? (x y z k)) (□? (x y z)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (-> (app - z 1) <-) x y (λ (v3) ...))
  (env ((□? (v2)) (□? (v1)) (□? (x y z k)) (□? (x y z)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - z (-> 1 <-))
  (env ((□? (v2)) (□? (v1)) (□? (x y z k)) (□? (x y z)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (app - (-> z <-) 1)
  (env ((□? (v2)) (□? (v1)) (□? (x y z k)) (□? (x y z)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app (-> - <-) z 1)
  (env ((□? (v2)) (□? (v1)) (□? (x y z k)) (□? (x y z)))))
clos/con:
	'((prim -) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> tak <-) (app - z 1) x y (λ (v3) ...))
  (env ((□? (v2)) (□? (v1)) (□? (x y z k)) (□? (x y z)))))
clos/con:
	'((letrec* (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...)
  (env ((□? (x y z)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app tak (app - y 1) z (-> x <-) (λ (v2) ...))
  (env ((□? (v1)) (□? (x y z k)) (□? (x y z)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (app - y 1) (-> z <-) x (λ (v2) ...))
  (env ((□? (v1)) (□? (x y z k)) (□? (x y z)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (-> (app - y 1) <-) z x (λ (v2) ...))
  (env ((□? (v1)) (□? (x y z k)) (□? (x y z)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app - y (-> 1 <-)) (env ((□? (v1)) (□? (x y z k)) (□? (x y z)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app - (-> y <-) 1) (env ((□? (v1)) (□? (x y z k)) (□? (x y z)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> - <-) y 1) (env ((□? (v1)) (□? (x y z k)) (□? (x y z)))))
clos/con:
	'((prim -) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> tak <-) (app - y 1) z x (λ (v2) ...))
  (env ((□? (v1)) (□? (x y z k)) (□? (x y z)))))
clos/con:
	'((letrec* (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...)
  (env ((□? (x y z)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app tak (app - x 1) y (-> z <-) (λ (v1) ...))
  (env ((□? (x y z k)) (□? (x y z)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (app - x 1) (-> y <-) z (λ (v1) ...))
  (env ((□? (x y z k)) (□? (x y z)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (-> (app - x 1) <-) y z (λ (v1) ...))
  (env ((□? (x y z k)) (□? (x y z)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app - x (-> 1 <-)) (env ((□? (x y z k)) (□? (x y z)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app - (-> x <-) 1) (env ((□? (x y z k)) (□? (x y z)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> - <-) x 1) (env ((□? (x y z k)) (□? (x y z)))))
clos/con:
	'((prim -) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> tak <-) (app - x 1) y z (λ (v1) ...))
  (env ((□? (x y z k)) (□? (x y z)))))
clos/con:
	'((letrec* (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...)
  (env ((□? (x y z)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app not (app < y x)) <-) (#f) _)
  (env ((□? (x y z k)) (□? (x y z)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app not (-> (app < y x) <-)) (env ((□? (x y z k)) (□? (x y z)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app < y (-> x <-)) (env ((□? (x y z k)) (□? (x y z)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app < (-> y <-) x) (env ((□? (x y z k)) (□? (x y z)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> < <-) y x) (env ((□? (x y z k)) (□? (x y z)))))
clos/con:
	'((prim <) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> not <-) (app < y x)) (env ((□? (x y z k)) (□? (x y z)))))
clos/con:
	'((prim not) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (tak) (-> (app tak x y z (λ (a) ...)) <-))
  (env ((□? (x y z)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app tak x y z (-> (λ (a) ...) <-)) (env ((□? (x y z)))))
clos/con:
	'((app tak x y z (-> (λ (a) ...) <-)) (env ((□? (x y z)))))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (a) (-> a <-)) (env ((□? (a)) (□? (x y z)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app tak x y (-> z <-) (λ (a) ...)) (env ((□? (x y z)))))
clos/con: ⊥
literals: '(8 ⊥ ⊥)

'(query: (app tak x (-> y <-) z (λ (a) ...)) (env ((□? (x y z)))))
clos/con: ⊥
literals: '(15 ⊥ ⊥)

'(query: (app tak (-> x <-) y z (λ (a) ...)) (env ((□? (x y z)))))
clos/con: ⊥
literals: '(32 ⊥ ⊥)

'(query: (app (-> tak <-) x y z (λ (a) ...)) (env ((□? (x y z)))))
clos/con:
	'((letrec* (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...)
  (env ((□? (x y z)))))
literals: '(⊥ ⊥ ⊥)

'(query: (letrec* (cpstak) (-> (app cpstak 32 15 8) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app cpstak 32 15 (-> 8 <-)) (env ()))
clos/con: ⊥
literals: '(8 ⊥ ⊥)

'(query: (app cpstak 32 (-> 15 <-) 8) (env ()))
clos/con: ⊥
literals: '(15 ⊥ ⊥)

'(query: (app cpstak (-> 32 <-) 15 8) (env ()))
clos/con: ⊥
literals: '(32 ⊥ ⊥)

'(query: (app (-> cpstak <-) 32 15 8) (env ()))
clos/con:
	'((letrec* (... () (cpstak (-> (λ (x y z) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)
