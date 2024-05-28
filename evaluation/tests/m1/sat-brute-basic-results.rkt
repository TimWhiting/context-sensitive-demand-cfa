'(expression:
  (letrec*
   ((println (λ (s) (let ((_ (app display s))) (app newline))))
    (phi
     (λ (x1 x2 x3 x4)
       (app
        and
        (app or x1 (app not x2) (app not x3))
        (app or (app not x2) (app not x3))
        (app or x4 x2))))
    (try
     (λ (f)
       (let ((_ (app println "trying")))
         (app or (app f (app #t)) (app f (app #f))))))
    (sat-solve-4
     (λ (p)
       (app
        try
        (λ (n1)
          (app
           try
           (λ (n2)
             (app try (λ (n3) (app try (λ (n4) (app p n1 n2 n3 n4))))))))))))
   (let ((_ (app display (app sat-solve-4 phi)))) (app newline))))

'(query: ((top) letrec* (println ... sat-solve-4) ...) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... try (sat-solve-4 (-> (λ (p) ...) <-)) () ...) ...)
  (env ()))
clos/con:
	'((letrec* (... try (sat-solve-4 (-> (λ (p) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (p) (-> (app try (λ (n1) ...)) <-)) (env ((□? (p)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app try (-> (λ (n1) ...) <-)) (env ((□? (p)))))
clos/con:
	'((app try (-> (λ (n1) ...) <-)) (env ((□? (p)))))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (n1) (-> (app try (λ (n2) ...)) <-)) (env ((□? (n1)) (□? (p)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app try (-> (λ (n2) ...) <-)) (env ((□? (n1)) (□? (p)))))
clos/con:
	'((app try (-> (λ (n2) ...) <-)) (env ((□? (n1)) (□? (p)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (n2) (-> (app try (λ (n3) ...)) <-))
  (env ((□? (n2)) (□? (n1)) (□? (p)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app try (-> (λ (n3) ...) <-)) (env ((□? (n2)) (□? (n1)) (□? (p)))))
clos/con:
	'((app try (-> (λ (n3) ...) <-)) (env ((□? (n2)) (□? (n1)) (□? (p)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (n3) (-> (app try (λ (n4) ...)) <-))
  (env ((□? (n3)) (□? (n2)) (□? (n1)) (□? (p)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app try (-> (λ (n4) ...) <-))
  (env ((□? (n3)) (□? (n2)) (□? (n1)) (□? (p)))))
clos/con:
	'((app try (-> (λ (n4) ...) <-))
  (env ((□? (n3)) (□? (n2)) (□? (n1)) (□? (p)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (n4) (-> (app p n1 n2 n3 n4) <-))
  (env ((□? (n4)) (□? (n3)) (□? (n2)) (□? (n1)) (□? (p)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app p n1 n2 n3 (-> n4 <-))
  (env ((□? (n4)) (□? (n3)) (□? (n2)) (□? (n1)) (□? (p)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app p n1 n2 (-> n3 <-) n4)
  (env ((□? (n4)) (□? (n3)) (□? (n2)) (□? (n1)) (□? (p)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app p n1 (-> n2 <-) n3 n4)
  (env ((□? (n4)) (□? (n3)) (□? (n2)) (□? (n1)) (□? (p)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app p (-> n1 <-) n2 n3 n4)
  (env ((□? (n4)) (□? (n3)) (□? (n2)) (□? (n1)) (□? (p)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> p <-) n1 n2 n3 n4)
  (env ((□? (n4)) (□? (n3)) (□? (n2)) (□? (n1)) (□? (p)))))
clos/con:
	'((letrec* (... println (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> try <-) (λ (n4) ...))
  (env ((□? (n3)) (□? (n2)) (□? (n1)) (□? (p)))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> try <-) (λ (n3) ...)) (env ((□? (n2)) (□? (n1)) (□? (p)))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> try <-) (λ (n2) ...)) (env ((□? (n1)) (□? (p)))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> try <-) (λ (n1) ...)) (env ((□? (p)))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...)
  (env ()))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (f) (-> (let (_) ...) <-)) (env ((□? (f)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app println "trying") <-)) () ...) ...)
  (env ((□? (f)))))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app println (-> "trying" <-)) (env ((□? (f)))))
clos/con: ⊥
literals: '(⊥ ⊥ "trying")

'(query: (app (-> println <-) "trying") (env ((□? (f)))))
clos/con:
	'((letrec* (... () (println (-> (λ (s) ...) <-)) phi ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (_) (-> (app or (app f (app #t)) (app f (app #f))) <-))
  (env ((□? (f)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app or (app f (app #t)) (-> (app f (app #f)) <-)) (env ((□? (f)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f (-> (app #f) <-)) (env ((□? (f)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((□? (f)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f <-) (app #f)) (env ((□? (f)))))
clos/con:
	'((app try (-> (λ (n1) ...) <-)) (env ((□? (p)))))
	'((app try (-> (λ (n2) ...) <-)) (env ((□? (n1)) (□? (p)))))
	'((app try (-> (λ (n3) ...) <-)) (env ((□? (n2)) (□? (n1)) (□? (p)))))
	'((app try (-> (λ (n4) ...) <-))
  (env ((□? (n3)) (□? (n2)) (□? (n1)) (□? (p)))))
literals: '(⊥ ⊥ ⊥)

'(query: (app or (-> (app f (app #t)) <-) (app f (app #f))) (env ((□? (f)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f (-> (app #t) <-)) (env ((□? (f)))))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ((□? (f)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f <-) (app #t)) (env ((□? (f)))))
clos/con:
	'((app try (-> (λ (n1) ...) <-)) (env ((□? (p)))))
	'((app try (-> (λ (n2) ...) <-)) (env ((□? (n1)) (□? (p)))))
	'((app try (-> (λ (n3) ...) <-)) (env ((□? (n2)) (□? (n1)) (□? (p)))))
	'((app try (-> (λ (n4) ...) <-))
  (env ((□? (n3)) (□? (n2)) (□? (n1)) (□? (p)))))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> or <-) (app f (app #t)) (app f (app #f))) (env ((□? (f)))))
clos/con:
	'((prim or) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... println (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...)
  (env ()))
clos/con:
	'((letrec* (... println (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x1 x2 x3 x4)
    (->
     (app
      and
      (app or x1 (app not x2) (app not x3))
      (app or (app not x2) (app not x3))
      (app or x4 x2))
     <-))
  (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   and
   (app or x1 (app not x2) (app not x3))
   (app or (app not x2) (app not x3))
   (-> (app or x4 x2) <-))
  (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app or x4 (-> x2 <-)) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app or (-> x4 <-) x2) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> or <-) x4 x2) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'((prim or) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   and
   (app or x1 (app not x2) (app not x3))
   (-> (app or (app not x2) (app not x3)) <-)
   (app or x4 x2))
  (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app or (app not x2) (-> (app not x3) <-)) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app not (-> x3 <-)) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> not <-) x3) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'((prim not) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app or (-> (app not x2) <-) (app not x3)) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app not (-> x2 <-)) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> not <-) x2) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'((prim not) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> or <-) (app not x2) (app not x3)) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'((prim or) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   and
   (-> (app or x1 (app not x2) (app not x3)) <-)
   (app or (app not x2) (app not x3))
   (app or x4 x2))
  (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or x1 (app not x2) (-> (app not x3) <-))
  (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app not (-> x3 <-)) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> not <-) x3) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'((prim not) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or x1 (-> (app not x2) <-) (app not x3))
  (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app not (-> x2 <-)) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> not <-) x2) (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'((prim not) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (-> x1 <-) (app not x2) (app not x3))
  (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> or <-) x1 (app not x2) (app not x3))
  (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'((prim or) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   (-> and <-)
   (app or x1 (app not x2) (app not x3))
   (app or (app not x2) (app not x3))
   (app or x4 x2))
  (env ((□? (x1 x2 x3 x4)))))
clos/con:
	'((prim and) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (letrec* (... () (println (-> (λ (s) ...) <-)) phi ...) ...) (env ()))
clos/con:
	'((letrec* (... () (println (-> (λ (s) ...) <-)) phi ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (s) (-> (let (_) ...) <-)) (env ((□? (s)))))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app display s) <-)) () ...) ...)
  (env ((□? (s)))))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app display (-> s <-)) (env ((□? (s)))))
clos/con: ⊥
literals: '(⊥ ⊥ "trying")

'(query: (app (-> display <-) s) (env ((□? (s)))))
clos/con:
	'((prim display) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (app newline) <-)) (env ((□? (s)))))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> newline <-)) (env ((□? (s)))))
clos/con:
	'((prim newline) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (letrec* (println ... sat-solve-4) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app display (app sat-solve-4 phi)) <-)) () ...) ...)
  (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app display (-> (app sat-solve-4 phi) <-)) (env ()))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app sat-solve-4 (-> phi <-)) (env ()))
clos/con:
	'((letrec* (... println (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> sat-solve-4 <-) phi) (env ()))
clos/con:
	'((letrec* (... try (sat-solve-4 (-> (λ (p) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> display <-) (app sat-solve-4 phi)) (env ()))
clos/con:
	'((prim display) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (app newline) <-)) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> newline <-)) (env ()))
clos/con:
	'((prim newline) (env ()))
literals: '(⊥ ⊥ ⊥)
