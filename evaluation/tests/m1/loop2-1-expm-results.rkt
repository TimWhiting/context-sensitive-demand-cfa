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

'(query:
  (app (-> f <-) y)
  (env
   (((letrec (lp2) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((letrec (lp1) (-> (app lp1 10 0) <-))))))
clos/con:
	'((app lp2 10 (-> (λ (n) ...) <-) x)
  (env (((letrec (lp1) (-> (app lp1 10 0) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f <-) y)
  (env
   (((letrec (lp2) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con:
	'((app lp2 10 (-> (λ (n) ...) <-) x)
  (env (((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f <-) y)
  (env
   (((match (app = 0 j) ((#f) (-> (app lp2 (app - j 1) f (app f y)) <-)) _))
    ((letrec (lp1) (-> (app lp1 10 0) <-))))))
clos/con:
	'((app lp2 10 (-> (λ (n) ...) <-) x)
  (env (((letrec (lp1) (-> (app lp1 10 0) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f <-) y)
  (env
   (((match (app = 0 j) ((#f) (-> (app lp2 (app - j 1) f (app f y)) <-)) _))
    ((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con:
	'((app lp2 10 (-> (λ (n) ...) <-) x)
  (env (((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app + (-> n <-) i)
  (env
   (((app lp2 (app - j 1) f (-> (app f y) <-)))
    ((letrec (lp1) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app + (-> n <-) i)
  (env
   (((app lp2 (app - j 1) f (-> (app f y) <-)))
    ((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app + n (-> i <-))
  (env
   (((app lp2 (app - j 1) f (-> (app f y) <-)))
    ((letrec (lp1) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query:
  (app + n (-> i <-))
  (env
   (((app lp2 (app - j 1) f (-> (app f y) <-)))
    ((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> i <-) 1)
  (env
   (((match (app = 0 j) ((#f) (-> (app lp2 (app - j 1) f (app f y)) <-)) _))
    ((letrec (lp1) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query:
  (app - (-> i <-) 1)
  (env
   (((match (app = 0 j) ((#f) (-> (app lp2 (app - j 1) f (app f y)) <-)) _))
    ((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> j <-) 1)
  (env
   (((letrec (lp2) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((letrec (lp1) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query:
  (app - (-> j <-) 1)
  (env
   (((letrec (lp2) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query:
  (app - (-> j <-) 1)
  (env
   (((match (app = 0 j) ((#f) (-> (app lp2 (app - j 1) f (app f y)) <-)) _))
    ((letrec (lp1) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> j <-) 1)
  (env
   (((match (app = 0 j) ((#f) (-> (app lp2 (app - j 1) f (app f y)) <-)) _))
    ((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = 0 (-> i <-))
  (env (((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = 0 (-> j <-))
  (env
   (((letrec (lp2) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((letrec (lp1) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query:
  (app = 0 (-> j <-))
  (env
   (((letrec (lp2) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query:
  (app = 0 (-> j <-))
  (env
   (((match (app = 0 j) ((#f) (-> (app lp2 (app - j 1) f (app f y)) <-)) _))
    ((letrec (lp1) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = 0 (-> j <-))
  (env
   (((match (app = 0 j) ((#f) (-> (app lp2 (app - j 1) f (app f y)) <-)) _))
    ((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app f (-> y <-))
  (env
   (((letrec (lp2) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((letrec (lp1) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query:
  (app f (-> y <-))
  (env
   (((letrec (lp2) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app f (-> y <-))
  (env
   (((match (app = 0 j) ((#f) (-> (app lp2 (app - j 1) f (app f y)) <-)) _))
    ((letrec (lp1) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app f (-> y <-))
  (env
   (((match (app = 0 j) ((#f) (-> (app lp2 (app - j 1) f (app f y)) <-)) _))
    ((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app lp1 (-> (app - i 1) <-) y)
  (env
   (((match (app = 0 j) ((#f) (-> (app lp2 (app - j 1) f (app f y)) <-)) _))
    ((letrec (lp1) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(9 ⊥ ⊥)

'(query:
  (app lp1 (-> (app - i 1) <-) y)
  (env
   (((match (app = 0 j) ((#f) (-> (app lp2 (app - j 1) f (app f y)) <-)) _))
    ((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app lp1 (app - i 1) (-> y <-))
  (env
   (((match (app = 0 j) ((#f) (-> (app lp2 (app - j 1) f (app f y)) <-)) _))
    ((letrec (lp1) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app lp1 (app - i 1) (-> y <-))
  (env
   (((match (app = 0 j) ((#f) (-> (app lp2 (app - j 1) f (app f y)) <-)) _))
    ((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app lp2 (-> (app - j 1) <-) f (app f y))
  (env
   (((letrec (lp2) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((letrec (lp1) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(9 ⊥ ⊥)

'(query:
  (app lp2 (-> (app - j 1) <-) f (app f y))
  (env
   (((letrec (lp2) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(9 ⊥ ⊥)

'(query:
  (app lp2 (-> (app - j 1) <-) f (app f y))
  (env
   (((match (app = 0 j) ((#f) (-> (app lp2 (app - j 1) f (app f y)) <-)) _))
    ((letrec (lp1) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app lp2 (-> (app - j 1) <-) f (app f y))
  (env
   (((match (app = 0 j) ((#f) (-> (app lp2 (app - j 1) f (app f y)) <-)) _))
    ((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app lp2 (app - j 1) (-> f <-) (app f y))
  (env
   (((letrec (lp2) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((letrec (lp1) (-> (app lp1 10 0) <-))))))
clos/con:
	'((app lp2 10 (-> (λ (n) ...) <-) x)
  (env (((letrec (lp1) (-> (app lp1 10 0) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app lp2 (app - j 1) (-> f <-) (app f y))
  (env
   (((letrec (lp2) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con:
	'((app lp2 10 (-> (λ (n) ...) <-) x)
  (env (((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app lp2 (app - j 1) (-> f <-) (app f y))
  (env
   (((match (app = 0 j) ((#f) (-> (app lp2 (app - j 1) f (app f y)) <-)) _))
    ((letrec (lp1) (-> (app lp1 10 0) <-))))))
clos/con:
	'((app lp2 10 (-> (λ (n) ...) <-) x)
  (env (((letrec (lp1) (-> (app lp1 10 0) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app lp2 (app - j 1) (-> f <-) (app f y))
  (env
   (((match (app = 0 j) ((#f) (-> (app lp2 (app - j 1) f (app f y)) <-)) _))
    ((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con:
	'((app lp2 10 (-> (λ (n) ...) <-) x)
  (env (((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app lp2 (app - j 1) f (-> (app f y) <-))
  (env
   (((letrec (lp2) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((letrec (lp1) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app lp2 (app - j 1) f (-> (app f y) <-))
  (env
   (((letrec (lp2) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app lp2 (app - j 1) f (-> (app f y) <-))
  (env
   (((match (app = 0 j) ((#f) (-> (app lp2 (app - j 1) f (app f y)) <-)) _))
    ((letrec (lp1) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app lp2 (app - j 1) f (-> (app f y) <-))
  (env
   (((match (app = 0 j) ((#f) (-> (app lp2 (app - j 1) f (app f y)) <-)) _))
    ((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app lp2 10 (λ (n) ...) (-> x <-))
  (env (((letrec (lp1) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query:
  (app lp2 10 (λ (n) ...) (-> x <-))
  (env (((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (letrec (lp2) (-> (app lp2 10 (λ (n) ...) x) <-))
  (env (((letrec (lp1) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (letrec (lp2) (-> (app lp2 10 (λ (n) ...) x) <-))
  (env (((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (-> (app = 0 i) <-) (#f) _)
  (env (((letrec (lp1) (-> (app lp1 10 0) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app = 0 i) <-) (#f) _)
  (env (((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app = 0 j) <-) (#f) _)
  (env
   (((letrec (lp2) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((letrec (lp1) (-> (app lp1 10 0) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app = 0 j) <-) (#f) _)
  (env
   (((letrec (lp2) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app = 0 j) <-) (#f) _)
  (env
   (((match (app = 0 j) ((#f) (-> (app lp2 (app - j 1) f (app f y)) <-)) _))
    ((letrec (lp1) (-> (app lp1 10 0) <-))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app = 0 j) <-) (#f) _)
  (env
   (((match (app = 0 j) ((#f) (-> (app lp2 (app - j 1) f (app f y)) <-)) _))
    ((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app = 0 i) (#f) (_ (-> x <-)))
  (env (((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app = 0 i) ((#f) (-> (letrec (lp2) ...) <-)) _)
  (env (((letrec (lp1) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app = 0 i) ((#f) (-> (letrec (lp2) ...) <-)) _)
  (env (((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))
  (env
   (((match (app = 0 j) ((#f) (-> (app lp2 (app - j 1) f (app f y)) <-)) _))
    ((letrec (lp1) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))
  (env
   (((match (app = 0 j) ((#f) (-> (app lp2 (app - j 1) f (app f y)) <-)) _))
    ((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app = 0 j) ((#f) (-> (app lp2 (app - j 1) f (app f y)) <-)) _)
  (env
   (((letrec (lp2) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((letrec (lp1) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app = 0 j) ((#f) (-> (app lp2 (app - j 1) f (app f y)) <-)) _)
  (env
   (((letrec (lp2) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app = 0 j) ((#f) (-> (app lp2 (app - j 1) f (app f y)) <-)) _)
  (env
   (((match (app = 0 j) ((#f) (-> (app lp2 (app - j 1) f (app f y)) <-)) _))
    ((letrec (lp1) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app = 0 j) ((#f) (-> (app lp2 (app - j 1) f (app f y)) <-)) _)
  (env
   (((match (app = 0 j) ((#f) (-> (app lp2 (app - j 1) f (app f y)) <-)) _))
    ((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (i x) (-> (match (app = 0 i) ...) <-))
  (env (((letrec (lp1) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (i x) (-> (match (app = 0 i) ...) <-))
  (env (((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (j f y) (-> (match (app = 0 j) ...) <-))
  (env
   (((letrec (lp2) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((letrec (lp1) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (j f y) (-> (match (app = 0 j) ...) <-))
  (env
   (((letrec (lp2) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (j f y) (-> (match (app = 0 j) ...) <-))
  (env
   (((match (app = 0 j) ((#f) (-> (app lp2 (app - j 1) f (app f y)) <-)) _))
    ((letrec (lp1) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (j f y) (-> (match (app = 0 j) ...) <-))
  (env
   (((match (app = 0 j) ((#f) (-> (app lp2 (app - j 1) f (app f y)) <-)) _))
    ((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (n) (-> (app + n i) <-))
  (env
   (((app lp2 (app - j 1) f (-> (app f y) <-)))
    ((letrec (lp1) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (n) (-> (app + n i) <-))
  (env
   (((app lp2 (app - j 1) f (-> (app f y) <-)))
    ((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: ((top) letrec (lp1) ...) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app = 0 (-> i <-)) (env (((letrec (lp1) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query: (letrec (lp1) (-> (app lp1 10 0) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  f
  (λ (j f y) (-> (match (app = 0 j) ...) <-))
  (env
   (((letrec (lp2) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((letrec (lp1) (-> (app lp1 10 0) <-))))))
clos/con:
	'((app lp2 10 (-> (λ (n) ...) <-) x)
  (env (((letrec (lp1) (-> (app lp1 10 0) <-))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  f
  (λ (j f y) (-> (match (app = 0 j) ...) <-))
  (env
   (((letrec (lp2) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con:
	'((app lp2 10 (-> (λ (n) ...) <-) x)
  (env (((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  f
  (λ (j f y) (-> (match (app = 0 j) ...) <-))
  (env
   (((match (app = 0 j) ((#f) (-> (app lp2 (app - j 1) f (app f y)) <-)) _))
    ((letrec (lp1) (-> (app lp1 10 0) <-))))))
clos/con:
	'((app lp2 10 (-> (λ (n) ...) <-) x)
  (env (((letrec (lp1) (-> (app lp1 10 0) <-))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  f
  (λ (j f y) (-> (match (app = 0 j) ...) <-))
  (env
   (((match (app = 0 j) ((#f) (-> (app lp2 (app - j 1) f (app f y)) <-)) _))
    ((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con:
	'((app lp2 10 (-> (λ (n) ...) <-) x)
  (env (((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  i
  (λ (i x) (-> (match (app = 0 i) ...) <-))
  (env (((letrec (lp1) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(store:
  i
  (λ (i x) (-> (match (app = 0 i) ...) <-))
  (env (((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  j
  (λ (j f y) (-> (match (app = 0 j) ...) <-))
  (env
   (((letrec (lp2) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((letrec (lp1) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(store:
  j
  (λ (j f y) (-> (match (app = 0 j) ...) <-))
  (env
   (((letrec (lp2) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(store:
  j
  (λ (j f y) (-> (match (app = 0 j) ...) <-))
  (env
   (((match (app = 0 j) ((#f) (-> (app lp2 (app - j 1) f (app f y)) <-)) _))
    ((letrec (lp1) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  j
  (λ (j f y) (-> (match (app = 0 j) ...) <-))
  (env
   (((match (app = 0 j) ((#f) (-> (app lp2 (app - j 1) f (app f y)) <-)) _))
    ((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  lp2
  (letrec (... () (lp2 (-> (λ (j f y) ...) <-)) () ...) ...)
  (env (((letrec (lp1) (-> (app lp1 10 0) <-))))))
clos/con:
	'((letrec (... () (lp2 (-> (λ (j f y) ...) <-)) () ...) ...)
  (env (((letrec (lp1) (-> (app lp1 10 0) <-))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  lp2
  (letrec (... () (lp2 (-> (λ (j f y) ...) <-)) () ...) ...)
  (env (((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con:
	'((letrec (... () (lp2 (-> (λ (j f y) ...) <-)) () ...) ...)
  (env (((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  n
  (λ (n) (-> (app + n i) <-))
  (env
   (((app lp2 (app - j 1) f (-> (app f y) <-)))
    ((letrec (lp1) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  n
  (λ (n) (-> (app + n i) <-))
  (env
   (((app lp2 (app - j 1) f (-> (app f y) <-)))
    ((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  x
  (λ (i x) (-> (match (app = 0 i) ...) <-))
  (env (((letrec (lp1) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(store:
  x
  (λ (i x) (-> (match (app = 0 i) ...) <-))
  (env (((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  y
  (λ (j f y) (-> (match (app = 0 j) ...) <-))
  (env
   (((letrec (lp2) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((letrec (lp1) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(store:
  y
  (λ (j f y) (-> (match (app = 0 j) ...) <-))
  (env
   (((letrec (lp2) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  y
  (λ (j f y) (-> (match (app = 0 j) ...) <-))
  (env
   (((match (app = 0 j) ((#f) (-> (app lp2 (app - j 1) f (app f y)) <-)) _))
    ((letrec (lp1) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  y
  (λ (j f y) (-> (match (app = 0 j) ...) <-))
  (env
   (((match (app = 0 j) ((#f) (-> (app lp2 (app - j 1) f (app f y)) <-)) _))
    ((match (app = 0 j) (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store: lp1 (letrec (... () (lp1 (-> (λ (i x) ...) <-)) () ...) ...) (env ()))
clos/con:
	'((letrec (... () (lp1 (-> (λ (i x) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)
