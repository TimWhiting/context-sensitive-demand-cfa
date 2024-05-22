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

'(query:
  (app
   (-> and <-)
   (app or x1 (app not x2) (app not x3))
   (app or (app not x2) (app not x3))
   (app or x4 x2))
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((prim and) (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   and
   (-> (app or x1 (app not x2) (app not x3)) <-)
   (app or (app not x2) (app not x3))
   (app or x4 x2))
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   and
   (app or x1 (app not x2) (app not x3))
   (-> (app or (app not x2) (app not x3)) <-)
   (app or x4 x2))
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   and
   (app or x1 (app not x2) (app not x3))
   (app or (app not x2) (app not x3))
   (-> (app or x4 x2) <-))
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> display <-) s)
  (env ((let (... () (_ (-> (app println "trying") <-)) () ...) ...))))
clos/con:
	'((prim display)
  (env ((let (... () (_ (-> (app println "trying") <-)) () ...) ...))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f <-) (app #f))
  (env ((λ (n1) (-> (app try (λ (n2) ...)) <-)))))
clos/con:
	'((app try (-> (λ (n2) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
	'((app try (-> (λ (n2) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f <-) (app #f))
  (env ((λ (n2) (-> (app try (λ (n3) ...)) <-)))))
clos/con:
	'((app try (-> (λ (n3) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
	'((app try (-> (λ (n3) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f <-) (app #f))
  (env ((λ (n3) (-> (app try (λ (n4) ...)) <-)))))
clos/con:
	'((app try (-> (λ (n4) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
	'((app try (-> (λ (n4) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f <-) (app #f))
  (env ((λ (p) (-> (app try (λ (n1) ...)) <-)))))
clos/con:
	'((app try (-> (λ (n1) ...) <-))
  (env ((app display (-> (app sat-solve-4 phi) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f <-) (app #t))
  (env ((λ (n1) (-> (app try (λ (n2) ...)) <-)))))
clos/con:
	'((app try (-> (λ (n2) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
	'((app try (-> (λ (n2) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f <-) (app #t))
  (env ((λ (n2) (-> (app try (λ (n3) ...)) <-)))))
clos/con:
	'((app try (-> (λ (n3) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
	'((app try (-> (λ (n3) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f <-) (app #t))
  (env ((λ (n3) (-> (app try (λ (n4) ...)) <-)))))
clos/con:
	'((app try (-> (λ (n4) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
	'((app try (-> (λ (n4) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f <-) (app #t))
  (env ((λ (p) (-> (app try (λ (n1) ...)) <-)))))
clos/con:
	'((app try (-> (λ (n1) ...) <-))
  (env ((app display (-> (app sat-solve-4 phi) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> newline <-))
  (env ((let (... () (_ (-> (app println "trying") <-)) () ...) ...))))
clos/con:
	'((prim newline)
  (env ((let (... () (_ (-> (app println "trying") <-)) () ...) ...))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> or <-) (app f (app #t)) (app f (app #f)))
  (env ((λ (n1) (-> (app try (λ (n2) ...)) <-)))))
clos/con:
	'((prim or) (env ((λ (n1) (-> (app try (λ (n2) ...)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> or <-) (app f (app #t)) (app f (app #f)))
  (env ((λ (n2) (-> (app try (λ (n3) ...)) <-)))))
clos/con:
	'((prim or) (env ((λ (n2) (-> (app try (λ (n3) ...)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> or <-) (app f (app #t)) (app f (app #f)))
  (env ((λ (n3) (-> (app try (λ (n4) ...)) <-)))))
clos/con:
	'((prim or) (env ((λ (n3) (-> (app try (λ (n4) ...)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> or <-) (app f (app #t)) (app f (app #f)))
  (env ((λ (p) (-> (app try (λ (n1) ...)) <-)))))
clos/con:
	'((prim or) (env ((λ (p) (-> (app try (λ (n1) ...)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> or <-) (app not x2) (app not x3))
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((prim or) (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> or <-) x1 (app not x2) (app not x3))
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((prim or) (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> p <-) n1 n2 n3 n4)
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((letrec* (... println (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> p <-) n1 n2 n3 n4)
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((letrec* (... println (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> println <-) "trying")
  (env ((λ (n1) (-> (app try (λ (n2) ...)) <-)))))
clos/con:
	'((letrec* (... () (println (-> (λ (s) ...) <-)) phi ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> println <-) "trying")
  (env ((λ (n2) (-> (app try (λ (n3) ...)) <-)))))
clos/con:
	'((letrec* (... () (println (-> (λ (s) ...) <-)) phi ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> println <-) "trying")
  (env ((λ (n3) (-> (app try (λ (n4) ...)) <-)))))
clos/con:
	'((letrec* (... () (println (-> (λ (s) ...) <-)) phi ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> println <-) "trying")
  (env ((λ (p) (-> (app try (λ (n1) ...)) <-)))))
clos/con:
	'((letrec* (... () (println (-> (λ (s) ...) <-)) phi ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> try <-) (λ (n1) ...))
  (env ((app display (-> (app sat-solve-4 phi) <-)))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> try <-) (λ (n2) ...))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> try <-) (λ (n2) ...))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> try <-) (λ (n3) ...))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> try <-) (λ (n3) ...))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> try <-) (λ (n4) ...))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> try <-) (λ (n4) ...))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app display (-> s <-))
  (env ((let (... () (_ (-> (app println "trying") <-)) () ...) ...))))
clos/con: ⊥
literals: '(⊥ ⊥ "trying")

'(query:
  (app f (-> (app #f) <-))
  (env ((λ (n1) (-> (app try (λ (n2) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f (-> (app #f) <-))
  (env ((λ (n2) (-> (app try (λ (n3) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f (-> (app #f) <-))
  (env ((λ (n3) (-> (app try (λ (n4) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f (-> (app #f) <-))
  (env ((λ (p) (-> (app try (λ (n1) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f (-> (app #t) <-))
  (env ((λ (n1) (-> (app try (λ (n2) ...)) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f (-> (app #t) <-))
  (env ((λ (n2) (-> (app try (λ (n3) ...)) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f (-> (app #t) <-))
  (env ((λ (n3) (-> (app try (λ (n4) ...)) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f (-> (app #t) <-))
  (env ((λ (p) (-> (app try (λ (n1) ...)) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (-> (app f (app #t)) <-) (app f (app #f)))
  (env ((λ (n1) (-> (app try (λ (n2) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (-> (app f (app #t)) <-) (app f (app #f)))
  (env ((λ (n2) (-> (app try (λ (n3) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (-> (app f (app #t)) <-) (app f (app #f)))
  (env ((λ (n3) (-> (app try (λ (n4) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (-> (app f (app #t)) <-) (app f (app #f)))
  (env ((λ (p) (-> (app try (λ (n1) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (-> (app not x2) <-) (app not x3))
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (-> x1 <-) (app not x2) (app not x3))
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (app f (app #t)) (-> (app f (app #f)) <-))
  (env ((λ (n1) (-> (app try (λ (n2) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (app f (app #t)) (-> (app f (app #f)) <-))
  (env ((λ (n2) (-> (app try (λ (n3) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (app f (app #t)) (-> (app f (app #f)) <-))
  (env ((λ (n3) (-> (app try (λ (n4) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (app f (app #t)) (-> (app f (app #f)) <-))
  (env ((λ (p) (-> (app try (λ (n1) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or (app not x2) (-> (app not x3) <-))
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or x1 (-> (app not x2) <-) (app not x3))
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app or x1 (app not x2) (-> (app not x3) <-))
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app p (-> n1 <-) n2 n3 n4)
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app p (-> n1 <-) n2 n3 n4)
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app p n1 (-> n2 <-) n3 n4)
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app p n1 (-> n2 <-) n3 n4)
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app p n1 n2 (-> n3 <-) n4)
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app p n1 n2 (-> n3 <-) n4)
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app p n1 n2 n3 (-> n4 <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app p n1 n2 n3 (-> n4 <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app println (-> "trying" <-))
  (env ((λ (n1) (-> (app try (λ (n2) ...)) <-)))))
clos/con: ⊥
literals: '(⊥ ⊥ "trying")

'(query:
  (app println (-> "trying" <-))
  (env ((λ (n2) (-> (app try (λ (n3) ...)) <-)))))
clos/con: ⊥
literals: '(⊥ ⊥ "trying")

'(query:
  (app println (-> "trying" <-))
  (env ((λ (n3) (-> (app try (λ (n4) ...)) <-)))))
clos/con: ⊥
literals: '(⊥ ⊥ "trying")

'(query:
  (app println (-> "trying" <-))
  (env ((λ (p) (-> (app try (λ (n1) ...)) <-)))))
clos/con: ⊥
literals: '(⊥ ⊥ "trying")

'(query:
  (app try (-> (λ (n1) ...) <-))
  (env ((app display (-> (app sat-solve-4 phi) <-)))))
clos/con:
	'((app try (-> (λ (n1) ...) <-))
  (env ((app display (-> (app sat-solve-4 phi) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app try (-> (λ (n2) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((app try (-> (λ (n2) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app try (-> (λ (n2) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((app try (-> (λ (n2) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app try (-> (λ (n3) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((app try (-> (λ (n3) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app try (-> (λ (n3) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((app try (-> (λ (n3) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app try (-> (λ (n4) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((app try (-> (λ (n4) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app try (-> (λ (n4) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((app try (-> (λ (n4) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app display (app sat-solve-4 phi)) <-)) () ...) ...)
  (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app display s) <-)) () ...) ...)
  (env ((let (... () (_ (-> (app println "trying") <-)) () ...) ...))))
clos/con:
	'(((top) app void)
  (env ((let (... () (_ (-> (app println "trying") <-)) () ...) ...))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app println "trying") <-)) () ...) ...)
  (env ((λ (n1) (-> (app try (λ (n2) ...)) <-)))))
clos/con:
	'(((top) app void)
  (env ((let (... () (_ (-> (app println "trying") <-)) () ...) ...))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app println "trying") <-)) () ...) ...)
  (env ((λ (n2) (-> (app try (λ (n3) ...)) <-)))))
clos/con:
	'(((top) app void)
  (env ((let (... () (_ (-> (app println "trying") <-)) () ...) ...))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app println "trying") <-)) () ...) ...)
  (env ((λ (n3) (-> (app try (λ (n4) ...)) <-)))))
clos/con:
	'(((top) app void)
  (env ((let (... () (_ (-> (app println "trying") <-)) () ...) ...))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app println "trying") <-)) () ...) ...)
  (env ((λ (p) (-> (app try (λ (n1) ...)) <-)))))
clos/con:
	'(((top) app void)
  (env ((let (... () (_ (-> (app println "trying") <-)) () ...) ...))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (_) (-> (app newline) <-))
  (env ((let (... () (_ (-> (app println "trying") <-)) () ...) ...))))
clos/con:
	'(((top) app void)
  (env ((let (... () (_ (-> (app println "trying") <-)) () ...) ...))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (_) (-> (app or (app f (app #t)) (app f (app #f))) <-))
  (env ((λ (n1) (-> (app try (λ (n2) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (_) (-> (app or (app f (app #t)) (app f (app #f))) <-))
  (env ((λ (n2) (-> (app try (λ (n3) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (_) (-> (app or (app f (app #t)) (app f (app #f))) <-))
  (env ((λ (n3) (-> (app try (λ (n4) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (_) (-> (app or (app f (app #t)) (app f (app #f))) <-))
  (env ((λ (p) (-> (app try (λ (n1) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...)
  (env ()))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... println (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...)
  (env ()))
clos/con:
	'((letrec* (... println (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... try (sat-solve-4 (-> (λ (p) ...) <-)) () ...) ...)
  (env ()))
clos/con:
	'((letrec* (... try (sat-solve-4 (-> (λ (p) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (f) (-> (let (_) ...) <-))
  (env ((λ (n1) (-> (app try (λ (n2) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (f) (-> (let (_) ...) <-))
  (env ((λ (n2) (-> (app try (λ (n3) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (f) (-> (let (_) ...) <-))
  (env ((λ (n3) (-> (app try (λ (n4) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (f) (-> (let (_) ...) <-))
  (env ((λ (p) (-> (app try (λ (n1) ...)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (n1) (-> (app try (λ (n2) ...)) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (n1) (-> (app try (λ (n2) ...)) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (n2) (-> (app try (λ (n3) ...)) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (n2) (-> (app try (λ (n3) ...)) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (n3) (-> (app try (λ (n4) ...)) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (n3) (-> (app try (λ (n4) ...)) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (n4) (-> (app p n1 n2 n3 n4) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (n4) (-> (app p n1 n2 n3 n4) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (p) (-> (app try (λ (n1) ...)) <-))
  (env ((app display (-> (app sat-solve-4 phi) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (s) (-> (let (_) ...) <-))
  (env ((let (... () (_ (-> (app println "trying") <-)) () ...) ...))))
clos/con:
	'(((top) app void)
  (env ((let (... () (_ (-> (app println "trying") <-)) () ...) ...))))
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
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: ((top) letrec* (println ... sat-solve-4) ...) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((λ (n1) (-> (app try (λ (n2) ...)) <-)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((λ (n2) (-> (app try (λ (n3) ...)) <-)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((λ (n3) (-> (app try (λ (n4) ...)) <-)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((λ (p) (-> (app try (λ (n1) ...)) <-)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ((λ (n1) (-> (app try (λ (n2) ...)) <-)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ((λ (n2) (-> (app try (λ (n3) ...)) <-)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ((λ (n3) (-> (app try (λ (n4) ...)) <-)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ((λ (p) (-> (app try (λ (n1) ...)) <-)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> display <-) (app sat-solve-4 phi)) (env ()))
clos/con:
	'((prim display) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> newline <-)) (env ()))
clos/con:
	'((prim newline) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> not <-) x2) (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((prim not) (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> not <-) x2) (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((prim not) (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> not <-) x3) (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((prim not) (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> not <-) x3) (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((prim not) (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> or <-) x4 x2) (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((prim or) (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> sat-solve-4 <-) phi) (env ()))
clos/con:
	'((letrec* (... try (sat-solve-4 (-> (λ (p) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app display (-> (app sat-solve-4 phi) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app not (-> x2 <-)) (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app not (-> x2 <-)) (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app not (-> x3 <-)) (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app not (-> x3 <-)) (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app or (-> x4 <-) x2) (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app or x4 (-> x2 <-)) (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app sat-solve-4 (-> phi <-)) (env ()))
clos/con:
	'((letrec* (... println (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (app newline) <-)) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (letrec* (... () (println (-> (λ (s) ...) <-)) phi ...) ...) (env ()))
clos/con:
	'((letrec* (... () (println (-> (λ (s) ...) <-)) phi ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (letrec* (println ... sat-solve-4) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  _
  (letrec* (... () (println (-> (λ (s) ...) <-)) phi ...) ...)
  (env ((let (... () (_ (-> (app println "trying") <-)) () ...) ...))))
clos/con:
	'(((top) app void)
  (env ((let (... () (_ (-> (app println "trying") <-)) () ...) ...))))
literals: '(⊥ ⊥ ⊥)

'(store:
  _
  (letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...)
  (env ((λ (n1) (-> (app try (λ (n2) ...)) <-)))))
clos/con:
	'(((top) app void)
  (env ((let (... () (_ (-> (app println "trying") <-)) () ...) ...))))
literals: '(⊥ ⊥ ⊥)

'(store:
  _
  (letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...)
  (env ((λ (n2) (-> (app try (λ (n3) ...)) <-)))))
clos/con:
	'(((top) app void)
  (env ((let (... () (_ (-> (app println "trying") <-)) () ...) ...))))
literals: '(⊥ ⊥ ⊥)

'(store:
  _
  (letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...)
  (env ((λ (n3) (-> (app try (λ (n4) ...)) <-)))))
clos/con:
	'(((top) app void)
  (env ((let (... () (_ (-> (app println "trying") <-)) () ...) ...))))
literals: '(⊥ ⊥ ⊥)

'(store:
  _
  (letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...)
  (env ((λ (p) (-> (app try (λ (n1) ...)) <-)))))
clos/con:
	'(((top) app void)
  (env ((let (... () (_ (-> (app println "trying") <-)) () ...) ...))))
literals: '(⊥ ⊥ ⊥)

'(store:
  and
  (letrec* (... println (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...)
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((λ (x1 x2 x3 x4)
    (->
     (app
      and
      (app or x1 (app not x2) (app not x3))
      (app or (app not x2) (app not x3))
      (app or x4 x2))
     <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  display
  (letrec* (... () (println (-> (λ (s) ...) <-)) phi ...) ...)
  (env ((let (... () (_ (-> (app println "trying") <-)) () ...) ...))))
clos/con:
	'((λ (s) (-> (let (_) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  f
  (letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...)
  (env ((λ (n1) (-> (app try (λ (n2) ...)) <-)))))
clos/con:
	'((app try (-> (λ (n2) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
	'((app try (-> (λ (n2) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  f
  (letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...)
  (env ((λ (n2) (-> (app try (λ (n3) ...)) <-)))))
clos/con:
	'((app try (-> (λ (n3) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
	'((app try (-> (λ (n3) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  f
  (letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...)
  (env ((λ (n3) (-> (app try (λ (n4) ...)) <-)))))
clos/con:
	'((app try (-> (λ (n4) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
	'((app try (-> (λ (n4) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  f
  (letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...)
  (env ((λ (p) (-> (app try (λ (n1) ...)) <-)))))
clos/con:
	'((app try (-> (λ (n1) ...) <-))
  (env ((app display (-> (app sat-solve-4 phi) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  n1
  (app try (-> (λ (n1) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n1
  (app try (-> (λ (n1) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n1
  (app try (-> (λ (n2) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n1
  (app try (-> (λ (n2) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n1
  (app try (-> (λ (n3) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n1
  (app try (-> (λ (n3) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n1
  (app try (-> (λ (n4) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n1
  (app try (-> (λ (n4) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n2
  (app try (-> (λ (n2) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n2
  (app try (-> (λ (n2) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n2
  (app try (-> (λ (n3) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n2
  (app try (-> (λ (n3) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n2
  (app try (-> (λ (n4) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n2
  (app try (-> (λ (n4) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n3
  (app try (-> (λ (n3) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n3
  (app try (-> (λ (n3) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n3
  (app try (-> (λ (n4) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n3
  (app try (-> (λ (n4) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n4
  (app try (-> (λ (n4) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n4
  (app try (-> (λ (n4) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  newline
  (letrec* (... () (println (-> (λ (s) ...) <-)) phi ...) ...)
  (env ((let (... () (_ (-> (app println "trying") <-)) () ...) ...))))
clos/con:
	'((λ (s) (-> (let (_) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  not
  (letrec* (... println (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...)
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((λ (x1 x2 x3 x4)
    (->
     (app
      and
      (app or x1 (app not x2) (app not x3))
      (app or (app not x2) (app not x3))
      (app or x4 x2))
     <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  or
  (letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...)
  (env ((λ (n1) (-> (app try (λ (n2) ...)) <-)))))
clos/con:
	'((λ (f) (-> (let (_) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  or
  (letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...)
  (env ((λ (n2) (-> (app try (λ (n3) ...)) <-)))))
clos/con:
	'((λ (f) (-> (let (_) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  or
  (letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...)
  (env ((λ (n3) (-> (app try (λ (n4) ...)) <-)))))
clos/con:
	'((λ (f) (-> (let (_) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  or
  (letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...)
  (env ((λ (p) (-> (app try (λ (n1) ...)) <-)))))
clos/con:
	'((λ (f) (-> (let (_) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  or
  (letrec* (... println (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...)
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((λ (x1 x2 x3 x4)
    (->
     (app
      and
      (app or x1 (app not x2) (app not x3))
      (app or (app not x2) (app not x3))
      (app or x4 x2))
     <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  p
  (app try (-> (λ (n1) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((letrec* (... println (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  p
  (app try (-> (λ (n1) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((letrec* (... println (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  p
  (app try (-> (λ (n2) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((letrec* (... println (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  p
  (app try (-> (λ (n2) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((letrec* (... println (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  p
  (app try (-> (λ (n3) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((letrec* (... println (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  p
  (app try (-> (λ (n3) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((letrec* (... println (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  p
  (app try (-> (λ (n4) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((letrec* (... println (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  p
  (app try (-> (λ (n4) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((letrec* (... println (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  p
  (letrec* (... try (sat-solve-4 (-> (λ (p) ...) <-)) () ...) ...)
  (env ((app display (-> (app sat-solve-4 phi) <-)))))
clos/con:
	'((letrec* (... println (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  println
  (letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...)
  (env ((λ (n1) (-> (app try (λ (n2) ...)) <-)))))
clos/con:
	'((letrec* (... () (println (-> (λ (s) ...) <-)) phi ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  println
  (letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...)
  (env ((λ (n2) (-> (app try (λ (n3) ...)) <-)))))
clos/con:
	'((letrec* (... () (println (-> (λ (s) ...) <-)) phi ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  println
  (letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...)
  (env ((λ (n3) (-> (app try (λ (n4) ...)) <-)))))
clos/con:
	'((letrec* (... () (println (-> (λ (s) ...) <-)) phi ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  println
  (letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...)
  (env ((λ (p) (-> (app try (λ (n1) ...)) <-)))))
clos/con:
	'((letrec* (... () (println (-> (λ (s) ...) <-)) phi ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  s
  (letrec* (... () (println (-> (λ (s) ...) <-)) phi ...) ...)
  (env ((let (... () (_ (-> (app println "trying") <-)) () ...) ...))))
clos/con: ⊥
literals: '(⊥ ⊥ "trying")

'(store:
  try
  (app try (-> (λ (n1) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  try
  (app try (-> (λ (n1) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  try
  (app try (-> (λ (n2) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  try
  (app try (-> (λ (n2) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  try
  (app try (-> (λ (n3) ...) <-))
  (env ((app or (-> (app f (app #t)) <-) (app f (app #f))))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  try
  (app try (-> (λ (n3) ...) <-))
  (env ((app or (app f (app #t)) (-> (app f (app #f)) <-)))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  try
  (letrec* (... try (sat-solve-4 (-> (λ (p) ...) <-)) () ...) ...)
  (env ((app display (-> (app sat-solve-4 phi) <-)))))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x1
  (letrec* (... println (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...)
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x2
  (letrec* (... println (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...)
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x3
  (letrec* (... println (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...)
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x4
  (letrec* (... println (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...)
  (env ((λ (n4) (-> (app p n1 n2 n3 n4) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: _ ((top) letrec* (println ... sat-solve-4) ...) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: phi ((top) letrec* (println ... sat-solve-4) ...) (env ()))
clos/con:
	'((letrec* (... println (phi (-> (λ (x1 x2 x3 x4) ...) <-)) try ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: println ((top) letrec* (println ... sat-solve-4) ...) (env ()))
clos/con:
	'((letrec* (... () (println (-> (λ (s) ...) <-)) phi ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: sat-solve-4 ((top) letrec* (println ... sat-solve-4) ...) (env ()))
clos/con:
	'((letrec* (... try (sat-solve-4 (-> (λ (p) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: try ((top) letrec* (println ... sat-solve-4) ...) (env ()))
clos/con:
	'((letrec* (... phi (try (-> (λ (f) ...) <-)) sat-solve-4 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)
