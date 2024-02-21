'(expression:
  (letrec ((println (λ (s) (let ((_ (app display s))) (app newline))))
           (phi
            (λ (x1 x2 x3 x4 x5 x6 x7)
              (app
               and
               (app or x1 x2)
               (app or x1 (app not x2) (app not x3))
               (app or x3 x4)
               (app or (app not x4) x1)
               (app or (app not x2) (app not x3))
               (app or x4 x2))))
           (try
            (λ (f)
              (let ((_ (app println "trying")))
                (app or (app f (app #t)) (app f (app #f))))))
           (sat-solve-7
            (λ (p)
              (app
               try
               (λ (n1)
                 (app
                  try
                  (λ (n2)
                    (app
                     try
                     (λ (n3)
                       (app
                        try
                        (λ (n4)
                          (app
                           try
                           (λ (n5)
                             (app
                              try
                              (λ (n6)
                                (app
                                 try
                                 (λ (n7)
                                   (app
                                    p
                                    n1
                                    n2
                                    n3
                                    n4
                                    n5
                                    n6
                                    n7))))))))))))))))))
    (let ((_ (app display (app sat-solve-7 phi)))) (app newline))))

'(query: (app println (-> "trying" <-)) (env ()))
clos/con: ⊥
literals: '(⊥ ⊥ ⊥ "trying")

'(query: (app (-> display <-) s) (env ()))
clos/con:
	#<procedure:do-display>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app try (-> (λ (n2) ...) <-)) (env ()))
clos/con:
	'((app try (-> (λ (n2) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> try <-) (λ (n1) ...)) (env ()))
clos/con:
	'((letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> p <-) n1 n2 n3 n4 n5 n6 n7) (env ()))
clos/con:
	'((letrec (... println (phi (-> (λ (x1 x2 x3 x4 x5 x6 x7) ...) <-)) try ...)
    ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (n4) (-> (app try (λ (n5) ...)) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   and
   (app or x1 x2)
   (app or x1 (app not x2) (app not x3))
   (app or x3 x4)
   (app or (app not x4) x1)
   (-> (app or (app not x2) (app not x3)) <-)
   (app or x4 x2))
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> try <-) (λ (n2) ...)) (env ()))
clos/con:
	'((letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (λ (x1 x2 x3 x4 x5 x6 x7)
    (->
     (app
      and
      (app or x1 x2)
      (app or x1 (app not x2) (app not x3))
      (app or x3 x4)
      (app or (app not x4) x1)
      (app or (app not x2) (app not x3))
      (app or x4 x2))
     <-))
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (let (_) (-> (app newline) <-)) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> not <-) x3) (env ()))
clos/con:
	#<procedure:do-not>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (n7) (-> (app p n1 n2 n3 n4 n5 n6 n7) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (let (... () (_ (-> (app println "trying") <-)) () ...) ...) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> or <-) (app not x4) x1) (env ()))
clos/con:
	#<procedure:do-or>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (let (... () (_ (-> (app display s) <-)) () ...) ...) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> try <-) (λ (n7) ...)) (env ()))
clos/con:
	'((letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app f (-> (app #t) <-)) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> f <-) (app #t)) (env ()))
clos/con:
	'((app try (-> (λ (n1) ...) <-)) (env ()))
	'((app try (-> (λ (n2) ...) <-)) (env ()))
	'((app try (-> (λ (n3) ...) <-)) (env ()))
	'((app try (-> (λ (n4) ...) <-)) (env ()))
	'((app try (-> (λ (n5) ...) <-)) (env ()))
	'((app try (-> (λ (n6) ...) <-)) (env ()))
	'((app try (-> (λ (n7) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app f (-> (app #f) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   (-> and <-)
   (app or x1 x2)
   (app or x1 (app not x2) (app not x3))
   (app or x3 x4)
   (app or (app not x4) x1)
   (app or (app not x2) (app not x3))
   (app or x4 x2))
  (env ()))
clos/con:
	#<procedure:do-and>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app display (-> s <-)) (env ()))
clos/con: ⊥
literals: '(⊥ ⊥ ⊥ "trying")

'(query: (app try (-> (λ (n3) ...) <-)) (env ()))
clos/con:
	'((app try (-> (λ (n3) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app not (-> x4 <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> try <-) (λ (n5) ...)) (env ()))
clos/con:
	'((letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> or <-) x1 x2) (env ()))
clos/con:
	#<procedure:do-or>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app or x1 (-> x2 <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app or (app not x2) (-> (app not x3) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> newline <-)) (env ()))
clos/con:
	#<procedure:do-newline>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> or <-) x3 x4) (env ()))
clos/con:
	#<procedure:do-or>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (letrec (println ... sat-solve-7) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> newline <-)) (env ()))
clos/con:
	#<procedure:do-newline>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app sat-solve-7 (-> phi <-)) (env ()))
clos/con:
	'((letrec (... println (phi (-> (λ (x1 x2 x3 x4 x5 x6 x7) ...) <-)) try ...)
    ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   and
   (-> (app or x1 x2) <-)
   (app or x1 (app not x2) (app not x3))
   (app or x3 x4)
   (app or (app not x4) x1)
   (app or (app not x2) (app not x3))
   (app or x4 x2))
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app or x1 (app not x2) (-> (app not x3) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> println <-) "trying") (env ()))
clos/con:
	'((letrec (... () (println (-> (λ (s) ...) <-)) phi ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app or x4 (-> x2 <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> or <-) x4 x2) (env ()))
clos/con:
	#<procedure:do-or>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app or (-> x1 <-) x2) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (n2) (-> (app try (λ (n3) ...)) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   and
   (app or x1 x2)
   (app or x1 (app not x2) (app not x3))
   (app or x3 x4)
   (-> (app or (app not x4) x1) <-)
   (app or (app not x2) (app not x3))
   (app or x4 x2))
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> not <-) x3) (env ()))
clos/con:
	#<procedure:do-not>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: ((top) letrec (println ... sat-solve-7) ...) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app p n1 n2 n3 n4 n5 (-> n6 <-) n7) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...)
  (env ()))
clos/con:
	'((letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> not <-) x4) (env ()))
clos/con:
	#<procedure:do-not>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app or (-> x1 <-) (app not x2) (app not x3)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app or (app f (app #t)) (-> (app f (app #f)) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> f <-) (app #f)) (env ()))
clos/con:
	'((app try (-> (λ (n1) ...) <-)) (env ()))
	'((app try (-> (λ (n2) ...) <-)) (env ()))
	'((app try (-> (λ (n3) ...) <-)) (env ()))
	'((app try (-> (λ (n4) ...) <-)) (env ()))
	'((app try (-> (λ (n5) ...) <-)) (env ()))
	'((app try (-> (λ (n6) ...) <-)) (env ()))
	'((app try (-> (λ (n7) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (n1) (-> (app try (λ (n2) ...)) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> try <-) (λ (n4) ...)) (env ()))
clos/con:
	'((letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app not (-> x2 <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (n6) (-> (app try (λ (n7) ...)) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app not (-> x3 <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> or <-) (app not x2) (app not x3)) (env ()))
clos/con:
	#<procedure:do-or>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app or (app not x4) (-> x1 <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (p) (-> (app try (λ (n1) ...)) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (letrec (... () (println (-> (λ (s) ...) <-)) phi ...) ...) (env ()))
clos/con:
	'((letrec (... () (println (-> (λ (s) ...) <-)) phi ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (let (_) (-> (app newline) <-)) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (s) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app not (-> x3 <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ()))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   and
   (app or x1 x2)
   (app or x1 (app not x2) (app not x3))
   (app or x3 x4)
   (app or (app not x4) x1)
   (app or (app not x2) (app not x3))
   (-> (app or x4 x2) <-))
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app not (-> x2 <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app p n1 n2 n3 (-> n4 <-) n5 n6 n7) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app try (-> (λ (n5) ...) <-)) (env ()))
clos/con:
	'((app try (-> (λ (n5) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app try (-> (λ (n4) ...) <-)) (env ()))
clos/con:
	'((app try (-> (λ (n4) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   and
   (app or x1 x2)
   (app or x1 (app not x2) (app not x3))
   (-> (app or x3 x4) <-)
   (app or (app not x4) x1)
   (app or (app not x2) (app not x3))
   (app or x4 x2))
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec (... println (phi (-> (λ (x1 x2 x3 x4 x5 x6 x7) ...) <-)) try ...)
    ...)
  (env ()))
clos/con:
	'((letrec (... println (phi (-> (λ (x1 x2 x3 x4 x5 x6 x7) ...) <-)) try ...)
    ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (f) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app p n1 n2 n3 n4 (-> n5 <-) n6 n7) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> try <-) (λ (n3) ...)) (env ()))
clos/con:
	'((letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app or x3 (-> x4 <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (let (_) (-> (app or (app f (app #t)) (app f (app #f))) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app or (-> (app f (app #t)) <-) (app f (app #f))) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app try (-> (λ (n1) ...) <-)) (env ()))
clos/con:
	'((app try (-> (λ (n1) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> display <-) (app sat-solve-7 phi)) (env ()))
clos/con:
	#<procedure:do-display>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> or <-) (app f (app #t)) (app f (app #f))) (env ()))
clos/con:
	#<procedure:do-or>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app p n1 n2 n3 n4 n5 n6 (-> n7 <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app p n1 (-> n2 <-) n3 n4 n5 n6 n7) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app p n1 n2 (-> n3 <-) n4 n5 n6 n7) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app try (-> (λ (n6) ...) <-)) (env ()))
clos/con:
	'((app try (-> (λ (n6) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec (... try (sat-solve-7 (-> (λ (p) ...) <-)) () ...) ...)
  (env ()))
clos/con:
	'((letrec (... try (sat-solve-7 (-> (λ (p) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app display (-> (app sat-solve-7 phi) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (n5) (-> (app try (λ (n6) ...)) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ()))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> sat-solve-7 <-) phi) (env ()))
clos/con:
	'((letrec (... try (sat-solve-7 (-> (λ (p) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> try <-) (λ (n6) ...)) (env ()))
clos/con:
	'((letrec (... phi (try (-> (λ (f) ...) <-)) sat-solve-7 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app p (-> n1 <-) n2 n3 n4 n5 n6 n7) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app or (-> (app not x2) <-) (app not x3)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app or (-> (app not x4) <-) x1) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app display (app sat-solve-7 phi)) <-)) () ...) ...)
  (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (n3) (-> (app try (λ (n4) ...)) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app or x1 (-> (app not x2) <-) (app not x3)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> not <-) x2) (env ()))
clos/con:
	#<procedure:do-not>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   and
   (app or x1 x2)
   (-> (app or x1 (app not x2) (app not x3)) <-)
   (app or x3 x4)
   (app or (app not x4) x1)
   (app or (app not x2) (app not x3))
   (app or x4 x2))
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app try (-> (λ (n7) ...) <-)) (env ()))
clos/con:
	'((app try (-> (λ (n7) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app or (-> x3 <-) x4) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> or <-) x1 (app not x2) (app not x3)) (env ()))
clos/con:
	#<procedure:do-or>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> not <-) x2) (env ()))
clos/con:
	#<procedure:do-not>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app or (-> x4 <-) x2) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)
