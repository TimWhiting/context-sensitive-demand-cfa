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

'(query:
  (app (-> k <-) z)
  (env
   ((match
     (app not (app < y x))
     ((#f) (-> (app tak (app - x 1) y z (λ (v1) ...)) <-))
     _))))
clos/con:
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-))
  (env
   ((match
     (app not (app < y x))
     ((#f) (-> (app tak (app - x 1) y z (λ (v1) ...)) <-))
     _))))
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-))
  (env ((letrec* (tak) (-> (app tak x y z (λ (a) ...)) <-)))))
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-))
  (env ((λ (v1) (-> (app tak (app - y 1) z x (λ (v2) ...)) <-)))))
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-))
  (env ((λ (v2) (-> (app tak (app - z 1) x y (λ (v3) ...)) <-)))))
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-))
  (env ((λ (v3) (-> (app tak v1 v2 v3 k) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> k <-) z)
  (env ((λ (v1) (-> (app tak (app - y 1) z x (λ (v2) ...)) <-)))))
clos/con:
	'((app tak (app - y 1) z x (-> (λ (v2) ...) <-))
  (env ((match (app not (app < y x)) (#f) (_ (-> (app k z) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> k <-) z)
  (env ((λ (v2) (-> (app tak (app - z 1) x y (λ (v3) ...)) <-)))))
clos/con:
	'((app tak (app - z 1) x y (-> (λ (v3) ...) <-))
  (env ((match (app not (app < y x)) (#f) (_ (-> (app k z) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app - (-> x <-) 1)
  (env
   ((match
     (app not (app < y x))
     ((#f) (-> (app tak (app - x 1) y z (λ (v1) ...)) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> x <-) 1)
  (env ((letrec* (tak) (-> (app tak x y z (λ (a) ...)) <-)))))
clos/con: ⊥
literals: '(32 ⊥ ⊥)

'(query:
  (app - (-> x <-) 1)
  (env ((λ (v1) (-> (app tak (app - y 1) z x (λ (v2) ...)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> x <-) 1)
  (env ((λ (v2) (-> (app tak (app - z 1) x y (λ (v3) ...)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> y <-) 1)
  (env ((match (app not (app < y x)) (#f) (_ (-> (app k z) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> z <-) 1)
  (env ((match (app not (app < y x)) (#f) (_ (-> (app k z) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app < (-> y <-) x)
  (env
   ((match
     (app not (app < y x))
     ((#f) (-> (app tak (app - x 1) y z (λ (v1) ...)) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app < (-> y <-) x)
  (env ((letrec* (tak) (-> (app tak x y z (λ (a) ...)) <-)))))
clos/con: ⊥
literals: '(15 ⊥ ⊥)

'(query:
  (app < (-> y <-) x)
  (env ((λ (v1) (-> (app tak (app - y 1) z x (λ (v2) ...)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app < (-> y <-) x)
  (env ((λ (v2) (-> (app tak (app - z 1) x y (λ (v3) ...)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app < y (-> x <-))
  (env
   ((match
     (app not (app < y x))
     ((#f) (-> (app tak (app - x 1) y z (λ (v1) ...)) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app < y (-> x <-))
  (env ((letrec* (tak) (-> (app tak x y z (λ (a) ...)) <-)))))
clos/con: ⊥
literals: '(32 ⊥ ⊥)

'(query:
  (app < y (-> x <-))
  (env ((λ (v1) (-> (app tak (app - y 1) z x (λ (v2) ...)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app < y (-> x <-))
  (env ((λ (v2) (-> (app tak (app - z 1) x y (λ (v3) ...)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app k (-> z <-))
  (env
   ((match
     (app not (app < y x))
     ((#f) (-> (app tak (app - x 1) y z (λ (v1) ...)) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app k (-> z <-))
  (env ((λ (v1) (-> (app tak (app - y 1) z x (λ (v2) ...)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app k (-> z <-))
  (env ((λ (v2) (-> (app tak (app - z 1) x y (λ (v3) ...)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app not (-> (app < y x) <-))
  (env
   ((match
     (app not (app < y x))
     ((#f) (-> (app tak (app - x 1) y z (λ (v1) ...)) <-))
     _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app not (-> (app < y x) <-))
  (env ((letrec* (tak) (-> (app tak x y z (λ (a) ...)) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app not (-> (app < y x) <-))
  (env ((λ (v1) (-> (app tak (app - y 1) z x (λ (v2) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app not (-> (app < y x) <-))
  (env ((λ (v2) (-> (app tak (app - z 1) x y (λ (v3) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app not (-> (app < y x) <-))
  (env ((λ (v3) (-> (app tak v1 v2 v3 k) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app tak (-> (app - x 1) <-) y z (λ (v1) ...))
  (env
   ((match
     (app not (app < y x))
     ((#f) (-> (app tak (app - x 1) y z (λ (v1) ...)) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (-> (app - x 1) <-) y z (λ (v1) ...))
  (env ((letrec* (tak) (-> (app tak x y z (λ (a) ...)) <-)))))
clos/con: ⊥
literals: '(31 ⊥ ⊥)

'(query:
  (app tak (-> (app - x 1) <-) y z (λ (v1) ...))
  (env ((λ (v1) (-> (app tak (app - y 1) z x (λ (v2) ...)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (-> (app - x 1) <-) y z (λ (v1) ...))
  (env ((λ (v2) (-> (app tak (app - z 1) x y (λ (v3) ...)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (-> (app - x 1) <-) y z (λ (v1) ...))
  (env ((λ (v3) (-> (app tak v1 v2 v3 k) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (-> (app - y 1) <-) z x (λ (v2) ...))
  (env ((match (app not (app < y x)) (#f) (_ (-> (app k z) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (-> (app - z 1) <-) x y (λ (v3) ...))
  (env ((match (app not (app < y x)) (#f) (_ (-> (app k z) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (-> v1 <-) v2 v3 k)
  (env ((match (app not (app < y x)) (#f) (_ (-> (app k z) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (-> x <-) y z (λ (a) ...))
  (env ((letrec* (cpstak) (-> (app cpstak 32 15 8) <-)))))
clos/con: ⊥
literals: '(32 ⊥ ⊥)

'(query:
  (app tak (app - x 1) (-> y <-) z (λ (v1) ...))
  (env
   ((match
     (app not (app < y x))
     ((#f) (-> (app tak (app - x 1) y z (λ (v1) ...)) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (app - x 1) (-> y <-) z (λ (v1) ...))
  (env ((letrec* (tak) (-> (app tak x y z (λ (a) ...)) <-)))))
clos/con: ⊥
literals: '(15 ⊥ ⊥)

'(query:
  (app tak (app - x 1) (-> y <-) z (λ (v1) ...))
  (env ((λ (v1) (-> (app tak (app - y 1) z x (λ (v2) ...)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (app - x 1) (-> y <-) z (λ (v1) ...))
  (env ((λ (v2) (-> (app tak (app - z 1) x y (λ (v3) ...)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (app - x 1) (-> y <-) z (λ (v1) ...))
  (env ((λ (v3) (-> (app tak v1 v2 v3 k) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (app - x 1) y (-> z <-) (λ (v1) ...))
  (env
   ((match
     (app not (app < y x))
     ((#f) (-> (app tak (app - x 1) y z (λ (v1) ...)) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (app - x 1) y (-> z <-) (λ (v1) ...))
  (env ((letrec* (tak) (-> (app tak x y z (λ (a) ...)) <-)))))
clos/con: ⊥
literals: '(8 ⊥ ⊥)

'(query:
  (app tak (app - x 1) y (-> z <-) (λ (v1) ...))
  (env ((λ (v1) (-> (app tak (app - y 1) z x (λ (v2) ...)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (app - x 1) y (-> z <-) (λ (v1) ...))
  (env ((λ (v2) (-> (app tak (app - z 1) x y (λ (v3) ...)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (app - x 1) y (-> z <-) (λ (v1) ...))
  (env ((λ (v3) (-> (app tak v1 v2 v3 k) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (app - y 1) (-> z <-) x (λ (v2) ...))
  (env ((match (app not (app < y x)) (#f) (_ (-> (app k z) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (app - y 1) z (-> x <-) (λ (v2) ...))
  (env ((match (app not (app < y x)) (#f) (_ (-> (app k z) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (app - z 1) (-> x <-) y (λ (v3) ...))
  (env ((match (app not (app < y x)) (#f) (_ (-> (app k z) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (app - z 1) x (-> y <-) (λ (v3) ...))
  (env ((match (app not (app < y x)) (#f) (_ (-> (app k z) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak v1 (-> v2 <-) v3 k)
  (env ((match (app not (app < y x)) (#f) (_ (-> (app k z) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak v1 v2 (-> v3 <-) k)
  (env ((match (app not (app < y x)) (#f) (_ (-> (app k z) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak v1 v2 v3 (-> k <-))
  (env ((match (app not (app < y x)) (#f) (_ (-> (app k z) <-))))))
clos/con:
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-))
  (env
   ((match
     (app not (app < y x))
     ((#f) (-> (app tak (app - x 1) y z (λ (v1) ...)) <-))
     _))))
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-))
  (env ((letrec* (tak) (-> (app tak x y z (λ (a) ...)) <-)))))
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-))
  (env ((λ (v1) (-> (app tak (app - y 1) z x (λ (v2) ...)) <-)))))
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-))
  (env ((λ (v2) (-> (app tak (app - z 1) x y (λ (v3) ...)) <-)))))
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-))
  (env ((λ (v3) (-> (app tak v1 v2 v3 k) <-)))))
	'((app tak (app - y 1) z x (-> (λ (v2) ...) <-))
  (env ((match (app not (app < y x)) (#f) (_ (-> (app k z) <-))))))
	'((app tak (app - z 1) x y (-> (λ (v3) ...) <-))
  (env ((match (app not (app < y x)) (#f) (_ (-> (app k z) <-))))))
	'((app tak x y z (-> (λ (a) ...) <-))
  (env ((letrec* (cpstak) (-> (app cpstak 32 15 8) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app tak x (-> y <-) z (λ (a) ...))
  (env ((letrec* (cpstak) (-> (app cpstak 32 15 8) <-)))))
clos/con: ⊥
literals: '(15 ⊥ ⊥)

'(query:
  (app tak x y (-> z <-) (λ (a) ...))
  (env ((letrec* (cpstak) (-> (app cpstak 32 15 8) <-)))))
clos/con: ⊥
literals: '(8 ⊥ ⊥)

'(query:
  (letrec* (tak) (-> (app tak x y z (λ (a) ...)) <-))
  (env ((letrec* (cpstak) (-> (app cpstak 32 15 8) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app not (app < y x))
   ((#f) (-> (app tak (app - x 1) y z (λ (v1) ...)) <-))
   _)
  (env
   ((match
     (app not (app < y x))
     ((#f) (-> (app tak (app - x 1) y z (λ (v1) ...)) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app not (app < y x))
   ((#f) (-> (app tak (app - x 1) y z (λ (v1) ...)) <-))
   _)
  (env ((letrec* (tak) (-> (app tak x y z (λ (a) ...)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app not (app < y x))
   ((#f) (-> (app tak (app - x 1) y z (λ (v1) ...)) <-))
   _)
  (env ((λ (v1) (-> (app tak (app - y 1) z x (λ (v2) ...)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app not (app < y x))
   ((#f) (-> (app tak (app - x 1) y z (λ (v1) ...)) <-))
   _)
  (env ((λ (v2) (-> (app tak (app - z 1) x y (λ (v3) ...)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app not (app < y x))
   ((#f) (-> (app tak (app - x 1) y z (λ (v1) ...)) <-))
   _)
  (env ((λ (v3) (-> (app tak v1 v2 v3 k) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (-> (app not (app < y x)) <-) (#f) _)
  (env
   ((match
     (app not (app < y x))
     ((#f) (-> (app tak (app - x 1) y z (λ (v1) ...)) <-))
     _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app not (app < y x)) <-) (#f) _)
  (env ((letrec* (tak) (-> (app tak x y z (λ (a) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app not (app < y x)) <-) (#f) _)
  (env ((λ (v1) (-> (app tak (app - y 1) z x (λ (v2) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app not (app < y x)) <-) (#f) _)
  (env ((λ (v2) (-> (app tak (app - z 1) x y (λ (v3) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app not (app < y x)) <-) (#f) _)
  (env ((λ (v3) (-> (app tak v1 v2 v3 k) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app not (app < y x)) (#f) (_ (-> (app k z) <-)))
  (env
   ((match
     (app not (app < y x))
     ((#f) (-> (app tak (app - x 1) y z (λ (v1) ...)) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app not (app < y x)) (#f) (_ (-> (app k z) <-)))
  (env ((λ (v1) (-> (app tak (app - y 1) z x (λ (v2) ...)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app not (app < y x)) (#f) (_ (-> (app k z) <-)))
  (env ((λ (v2) (-> (app tak (app - z 1) x y (λ (v3) ...)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app not (app < y x)) (#f) (_ (-> (app k z) <-)))
  (env ((λ (v3) (-> (app tak v1 v2 v3 k) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (a) (-> a <-))
  (env ((match (app not (app < y x)) (#f) (_ (-> (app k z) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (v1) (-> (app tak (app - y 1) z x (λ (v2) ...)) <-))
  (env ((match (app not (app < y x)) (#f) (_ (-> (app k z) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (v2) (-> (app tak (app - z 1) x y (λ (v3) ...)) <-))
  (env ((match (app not (app < y x)) (#f) (_ (-> (app k z) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (v3) (-> (app tak v1 v2 v3 k) <-))
  (env ((match (app not (app < y x)) (#f) (_ (-> (app k z) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (x y z k) (-> (match (app not (app < ...)) ...) <-))
  (env
   ((match
     (app not (app < y x))
     ((#f) (-> (app tak (app - x 1) y z (λ (v1) ...)) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (x y z k) (-> (match (app not (app < ...)) ...) <-))
  (env ((letrec* (tak) (-> (app tak x y z (λ (a) ...)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (x y z k) (-> (match (app not (app < ...)) ...) <-))
  (env ((λ (v1) (-> (app tak (app - y 1) z x (λ (v2) ...)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (x y z k) (-> (match (app not (app < ...)) ...) <-))
  (env ((λ (v2) (-> (app tak (app - z 1) x y (λ (v3) ...)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (x y z k) (-> (match (app not (app < ...)) ...) <-))
  (env ((λ (v3) (-> (app tak v1 v2 v3 k) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (x y z) (-> (letrec* (tak) ...) <-))
  (env ((letrec* (cpstak) (-> (app cpstak 32 15 8) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: ((top) letrec* (cpstak) ...) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> k <-) z) (env ((λ (v3) (-> (app tak v1 v2 v3 k) <-)))))
clos/con:
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-))
  (env
   ((match
     (app not (app < y x))
     ((#f) (-> (app tak (app - x 1) y z (λ (v1) ...)) <-))
     _))))
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-))
  (env ((letrec* (tak) (-> (app tak x y z (λ (a) ...)) <-)))))
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-))
  (env ((λ (v1) (-> (app tak (app - y 1) z x (λ (v2) ...)) <-)))))
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-))
  (env ((λ (v2) (-> (app tak (app - z 1) x y (λ (v3) ...)) <-)))))
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-))
  (env ((λ (v3) (-> (app tak v1 v2 v3 k) <-)))))
	'((app tak (app - y 1) z x (-> (λ (v2) ...) <-))
  (env ((match (app not (app < y x)) (#f) (_ (-> (app k z) <-))))))
	'((app tak (app - z 1) x y (-> (λ (v3) ...) <-))
  (env ((match (app not (app < y x)) (#f) (_ (-> (app k z) <-))))))
	'((app tak x y z (-> (λ (a) ...) <-))
  (env ((letrec* (cpstak) (-> (app cpstak 32 15 8) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query: (app - (-> x <-) 1) (env ((λ (v3) (-> (app tak v1 v2 v3 k) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app < (-> y <-) x) (env ((λ (v3) (-> (app tak v1 v2 v3 k) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app < y (-> x <-)) (env ((λ (v3) (-> (app tak v1 v2 v3 k) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app k (-> z <-)) (env ((λ (v3) (-> (app tak v1 v2 v3 k) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (letrec* (cpstak) (-> (app cpstak 32 15 8) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  a
  (λ (a) (-> a <-))
  (env ((match (app not (app < y x)) (#f) (_ (-> (app k z) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  cpstak
  (letrec* (... () (cpstak (-> (λ (x y z) ...) <-)) () ...) ...)
  (env ()))
clos/con:
	'((letrec* (... () (cpstak (-> (λ (x y z) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  k
  (λ (x y z k) (-> (match (app not (app < ...)) ...) <-))
  (env
   ((match
     (app not (app < y x))
     ((#f) (-> (app tak (app - x 1) y z (λ (v1) ...)) <-))
     _))))
clos/con:
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-))
  (env
   ((match
     (app not (app < y x))
     ((#f) (-> (app tak (app - x 1) y z (λ (v1) ...)) <-))
     _))))
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-))
  (env ((letrec* (tak) (-> (app tak x y z (λ (a) ...)) <-)))))
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-))
  (env ((λ (v1) (-> (app tak (app - y 1) z x (λ (v2) ...)) <-)))))
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-))
  (env ((λ (v2) (-> (app tak (app - z 1) x y (λ (v3) ...)) <-)))))
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-))
  (env ((λ (v3) (-> (app tak v1 v2 v3 k) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  k
  (λ (x y z k) (-> (match (app not (app < ...)) ...) <-))
  (env ((letrec* (tak) (-> (app tak x y z (λ (a) ...)) <-)))))
clos/con:
	'((app tak x y z (-> (λ (a) ...) <-))
  (env ((letrec* (cpstak) (-> (app cpstak 32 15 8) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  k
  (λ (x y z k) (-> (match (app not (app < ...)) ...) <-))
  (env ((match (app not (app < y x)) (#f) (_ (-> (app k z) <-))))))
clos/con:
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-))
  (env
   ((match
     (app not (app < y x))
     ((#f) (-> (app tak (app - x 1) y z (λ (v1) ...)) <-))
     _))))
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-))
  (env ((letrec* (tak) (-> (app tak x y z (λ (a) ...)) <-)))))
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-))
  (env ((λ (v1) (-> (app tak (app - y 1) z x (λ (v2) ...)) <-)))))
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-))
  (env ((λ (v2) (-> (app tak (app - z 1) x y (λ (v3) ...)) <-)))))
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-))
  (env ((λ (v3) (-> (app tak v1 v2 v3 k) <-)))))
	'((app tak (app - y 1) z x (-> (λ (v2) ...) <-))
  (env ((match (app not (app < y x)) (#f) (_ (-> (app k z) <-))))))
	'((app tak (app - z 1) x y (-> (λ (v3) ...) <-))
  (env ((match (app not (app < y x)) (#f) (_ (-> (app k z) <-))))))
	'((app tak x y z (-> (λ (a) ...) <-))
  (env ((letrec* (cpstak) (-> (app cpstak 32 15 8) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  k
  (λ (x y z k) (-> (match (app not (app < ...)) ...) <-))
  (env ((λ (v1) (-> (app tak (app - y 1) z x (λ (v2) ...)) <-)))))
clos/con:
	'((app tak (app - y 1) z x (-> (λ (v2) ...) <-))
  (env ((match (app not (app < y x)) (#f) (_ (-> (app k z) <-))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  k
  (λ (x y z k) (-> (match (app not (app < ...)) ...) <-))
  (env ((λ (v2) (-> (app tak (app - z 1) x y (λ (v3) ...)) <-)))))
clos/con:
	'((app tak (app - z 1) x y (-> (λ (v3) ...) <-))
  (env ((match (app not (app < y x)) (#f) (_ (-> (app k z) <-))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  k
  (λ (x y z k) (-> (match (app not (app < ...)) ...) <-))
  (env ((λ (v3) (-> (app tak v1 v2 v3 k) <-)))))
clos/con:
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-))
  (env
   ((match
     (app not (app < y x))
     ((#f) (-> (app tak (app - x 1) y z (λ (v1) ...)) <-))
     _))))
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-))
  (env ((letrec* (tak) (-> (app tak x y z (λ (a) ...)) <-)))))
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-))
  (env ((λ (v1) (-> (app tak (app - y 1) z x (λ (v2) ...)) <-)))))
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-))
  (env ((λ (v2) (-> (app tak (app - z 1) x y (λ (v3) ...)) <-)))))
	'((app tak (app - x 1) y z (-> (λ (v1) ...) <-))
  (env ((λ (v3) (-> (app tak v1 v2 v3 k) <-)))))
	'((app tak (app - y 1) z x (-> (λ (v2) ...) <-))
  (env ((match (app not (app < y x)) (#f) (_ (-> (app k z) <-))))))
	'((app tak (app - z 1) x y (-> (λ (v3) ...) <-))
  (env ((match (app not (app < y x)) (#f) (_ (-> (app k z) <-))))))
	'((app tak x y z (-> (λ (a) ...) <-))
  (env ((letrec* (cpstak) (-> (app cpstak 32 15 8) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  tak
  (letrec* (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...)
  (env
   ((match
     (app not (app < y x))
     ((#f) (-> (app tak (app - x 1) y z (λ (v1) ...)) <-))
     _))))
clos/con:
	'((letrec* (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...)
  (env ((letrec* (cpstak) (-> (app cpstak 32 15 8) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  tak
  (letrec* (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...)
  (env ((letrec* (cpstak) (-> (app cpstak 32 15 8) <-)))))
clos/con:
	'((letrec* (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...)
  (env ((letrec* (cpstak) (-> (app cpstak 32 15 8) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  tak
  (letrec* (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...)
  (env ((letrec* (tak) (-> (app tak x y z (λ (a) ...)) <-)))))
clos/con:
	'((letrec* (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...)
  (env ((letrec* (cpstak) (-> (app cpstak 32 15 8) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  tak
  (letrec* (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...)
  (env ((match (app not (app < y x)) (#f) (_ (-> (app k z) <-))))))
clos/con:
	'((letrec* (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...)
  (env ((letrec* (cpstak) (-> (app cpstak 32 15 8) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  tak
  (letrec* (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...)
  (env ((λ (v1) (-> (app tak (app - y 1) z x (λ (v2) ...)) <-)))))
clos/con:
	'((letrec* (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...)
  (env ((letrec* (cpstak) (-> (app cpstak 32 15 8) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  tak
  (letrec* (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...)
  (env ((λ (v2) (-> (app tak (app - z 1) x y (λ (v3) ...)) <-)))))
clos/con:
	'((letrec* (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...)
  (env ((letrec* (cpstak) (-> (app cpstak 32 15 8) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  tak
  (letrec* (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...)
  (env ((λ (v3) (-> (app tak v1 v2 v3 k) <-)))))
clos/con:
	'((letrec* (... () (tak (-> (λ (x y z k) ...) <-)) () ...) ...)
  (env ((letrec* (cpstak) (-> (app cpstak 32 15 8) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  v1
  (λ (v1) (-> (app tak (app - y 1) z x (λ (v2) ...)) <-))
  (env ((match (app not (app < y x)) (#f) (_ (-> (app k z) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  v2
  (λ (v2) (-> (app tak (app - z 1) x y (λ (v3) ...)) <-))
  (env ((match (app not (app < y x)) (#f) (_ (-> (app k z) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  v3
  (λ (v3) (-> (app tak v1 v2 v3 k) <-))
  (env ((match (app not (app < y x)) (#f) (_ (-> (app k z) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  x
  (λ (x y z k) (-> (match (app not (app < ...)) ...) <-))
  (env
   ((match
     (app not (app < y x))
     ((#f) (-> (app tak (app - x 1) y z (λ (v1) ...)) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  x
  (λ (x y z k) (-> (match (app not (app < ...)) ...) <-))
  (env ((letrec* (tak) (-> (app tak x y z (λ (a) ...)) <-)))))
clos/con: ⊥
literals: '(32 ⊥ ⊥)

'(store:
  x
  (λ (x y z k) (-> (match (app not (app < ...)) ...) <-))
  (env ((match (app not (app < y x)) (#f) (_ (-> (app k z) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  x
  (λ (x y z k) (-> (match (app not (app < ...)) ...) <-))
  (env ((λ (v1) (-> (app tak (app - y 1) z x (λ (v2) ...)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  x
  (λ (x y z k) (-> (match (app not (app < ...)) ...) <-))
  (env ((λ (v2) (-> (app tak (app - z 1) x y (λ (v3) ...)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  x
  (λ (x y z k) (-> (match (app not (app < ...)) ...) <-))
  (env ((λ (v3) (-> (app tak v1 v2 v3 k) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  x
  (λ (x y z) (-> (letrec* (tak) ...) <-))
  (env ((letrec* (cpstak) (-> (app cpstak 32 15 8) <-)))))
clos/con: ⊥
literals: '(32 ⊥ ⊥)

'(store:
  y
  (λ (x y z k) (-> (match (app not (app < ...)) ...) <-))
  (env
   ((match
     (app not (app < y x))
     ((#f) (-> (app tak (app - x 1) y z (λ (v1) ...)) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  y
  (λ (x y z k) (-> (match (app not (app < ...)) ...) <-))
  (env ((letrec* (tak) (-> (app tak x y z (λ (a) ...)) <-)))))
clos/con: ⊥
literals: '(15 ⊥ ⊥)

'(store:
  y
  (λ (x y z k) (-> (match (app not (app < ...)) ...) <-))
  (env ((match (app not (app < y x)) (#f) (_ (-> (app k z) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  y
  (λ (x y z k) (-> (match (app not (app < ...)) ...) <-))
  (env ((λ (v1) (-> (app tak (app - y 1) z x (λ (v2) ...)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  y
  (λ (x y z k) (-> (match (app not (app < ...)) ...) <-))
  (env ((λ (v2) (-> (app tak (app - z 1) x y (λ (v3) ...)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  y
  (λ (x y z k) (-> (match (app not (app < ...)) ...) <-))
  (env ((λ (v3) (-> (app tak v1 v2 v3 k) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  y
  (λ (x y z) (-> (letrec* (tak) ...) <-))
  (env ((letrec* (cpstak) (-> (app cpstak 32 15 8) <-)))))
clos/con: ⊥
literals: '(15 ⊥ ⊥)

'(store:
  z
  (λ (x y z k) (-> (match (app not (app < ...)) ...) <-))
  (env
   ((match
     (app not (app < y x))
     ((#f) (-> (app tak (app - x 1) y z (λ (v1) ...)) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  z
  (λ (x y z k) (-> (match (app not (app < ...)) ...) <-))
  (env ((letrec* (tak) (-> (app tak x y z (λ (a) ...)) <-)))))
clos/con: ⊥
literals: '(8 ⊥ ⊥)

'(store:
  z
  (λ (x y z k) (-> (match (app not (app < ...)) ...) <-))
  (env ((match (app not (app < y x)) (#f) (_ (-> (app k z) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  z
  (λ (x y z k) (-> (match (app not (app < ...)) ...) <-))
  (env ((λ (v1) (-> (app tak (app - y 1) z x (λ (v2) ...)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  z
  (λ (x y z k) (-> (match (app not (app < ...)) ...) <-))
  (env ((λ (v2) (-> (app tak (app - z 1) x y (λ (v3) ...)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  z
  (λ (x y z k) (-> (match (app not (app < ...)) ...) <-))
  (env ((λ (v3) (-> (app tak v1 v2 v3 k) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  z
  (λ (x y z) (-> (letrec* (tak) ...) <-))
  (env ((letrec* (cpstak) (-> (app cpstak 32 15 8) <-)))))
clos/con: ⊥
literals: '(8 ⊥ ⊥)
