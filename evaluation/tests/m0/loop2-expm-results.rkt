'(expression:
  (lettypes
   ((cons car cdr) (nil))
   (let ((lp1 (app cons 'unspecified (app nil))))
     (let ((a
            (app
             set!
             lp1
             (λ (i x)
               (let ((a (app = 0 i)))
                 (match
                  a
                  ((#f)
                   (let ((lp2 (app cons 'unspecified (app nil))))
                     (let ((b
                            (app
                             set!
                             lp2
                             (λ (j f y)
                               (let ((b (app = 0 j)))
                                 (match
                                  b
                                  ((#f)
                                   (let (($tmp$3 (app f y)))
                                     (app lp2 (app - j 1) f $tmp$3)))
                                  (_ (app lp1 (app - i 1) y))))))))
                       (app lp2 10 (λ (n) (app + n i)) x))))
                  (_ x)))))))
       (app lp1 10 0)))))

'(query:
  (let (... () (a (-> (app set! lp1 (λ (i x) ...)) <-)) () ...) ...)
  (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (b (-> (app set! lp2 (λ (j f y) ...)) <-)) () ...) ...)
  (env (())))
clos/con:
	'(((top) app void) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (lp1 (-> (app cons 'unspecified (app nil)) <-)) () ...) ...)
  (env ()))
clos/con:
	'((con
   cons
   (let (... () (lp1 (-> (app cons 'unspecified (app nil)) <-)) () ...) ...))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (lp2 (-> (app cons 'unspecified (app nil)) <-)) () ...) ...)
  (env (())))
clos/con:
	'((con
   cons
   (let (... () (lp2 (-> (app cons 'unspecified (app nil)) <-)) () ...) ...))
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: ((top) lettypes (cons ... nil) ...) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> + <-) n i) (env (() ())))
clos/con:
	'((prim +) (env (() ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> - <-) i 1) (env (() ())))
clos/con:
	'((prim -) (env (() ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> - <-) j 1) (env (() ())))
clos/con:
	'((prim -) (env (() ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> = <-) 0 i) (env (())))
clos/con:
	'((prim =) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> = <-) 0 j) (env (() ())))
clos/con:
	'((prim =) (env (() ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 'unspecified (app nil)) (env (())))
clos/con:
	'((app (-> cons <-) 'unspecified (app nil)) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 'unspecified (app nil)) (env ()))
clos/con:
	'((app (-> cons <-) 'unspecified (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f <-) y) (env (() ())))
clos/con:
	'((app lp2 10 (-> (λ (n) ...) <-) x) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> lp1 <-) (app - i 1) y) (env (() ())))
clos/con:
	'((app set! lp1 (-> (λ (i x) ...) <-)) (env ()))
	'((con
   cons
   (let (... () (lp1 (-> (app cons 'unspecified (app nil)) <-)) () ...) ...))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> lp1 <-) 10 0) (env ()))
clos/con:
	'((app set! lp1 (-> (λ (i x) ...) <-)) (env ()))
	'((con
   cons
   (let (... () (lp1 (-> (app cons 'unspecified (app nil)) <-)) () ...) ...))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> lp2 <-) (app - j 1) f $tmp$3) (env (() ())))
clos/con:
	'((app set! lp2 (-> (λ (j f y) ...) <-)) (env (())))
	'((con
   cons
   (let (... () (lp2 (-> (app cons 'unspecified (app nil)) <-)) () ...) ...))
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> lp2 <-) 10 (λ (n) ...) x) (env (())))
clos/con:
	'((app set! lp2 (-> (λ (j f y) ...) <-)) (env (())))
	'((con
   cons
   (let (... () (lp2 (-> (app cons 'unspecified (app nil)) <-)) () ...) ...))
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env (())))
clos/con:
	'((app (-> nil <-)) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app + (-> n <-) i) (env (() ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app + n (-> i <-)) (env (() ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app - (-> i <-) 1) (env (() ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app - (-> j <-) 1) (env (() ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app - i (-> 1 <-)) (env (() ())))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app - j (-> 1 <-)) (env (() ())))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app = (-> 0 <-) i) (env (())))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query: (app = (-> 0 <-) j) (env (() ())))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query: (app = 0 (-> i <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app = 0 (-> j <-)) (env (() ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app cons 'unspecified (-> (app nil) <-)) (env (())))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 'unspecified (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> 'unspecified <-) (app nil)) (env (())))
clos/con:
	'((app cons (-> 'unspecified <-) (app nil)) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> 'unspecified <-) (app nil)) (env ()))
clos/con:
	'((app cons (-> 'unspecified <-) (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f (-> y <-)) (env (() ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app lp1 (-> (app - i 1) <-) y) (env (() ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app lp1 (-> 10 <-) 0) (env ()))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query: (app lp1 (app - i 1) (-> y <-)) (env (() ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app lp1 10 (-> 0 <-)) (env ()))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query: (app lp2 (-> (app - j 1) <-) f $tmp$3) (env (() ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app lp2 (-> 10 <-) (λ (n) ...) x) (env (())))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query: (app lp2 (app - j 1) (-> f <-) $tmp$3) (env (() ())))
clos/con:
	'((app lp2 10 (-> (λ (n) ...) <-) x) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app lp2 (app - j 1) f (-> $tmp$3 <-)) (env (() ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app lp2 10 (-> (λ (n) ...) <-) x) (env (())))
clos/con:
	'((app lp2 10 (-> (λ (n) ...) <-) x) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app lp2 10 (λ (n) ...) (-> x <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app set! lp1 (-> (λ (i x) ...) <-)) (env ()))
clos/con:
	'((app set! lp1 (-> (λ (i x) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app set! lp2 (-> (λ (j f y) ...) <-)) (env (())))
clos/con:
	'((app set! lp2 (-> (λ (j f y) ...) <-)) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)) (env (() ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (let (... () ($tmp$3 (-> (app f y) <-)) () ...) ...) (env (() ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (let (... () (a (-> (app = 0 i) <-)) () ...) ...) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (... () (b (-> (app = 0 j) <-)) () ...) ...) (env (() ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (a) (-> (app lp1 10 0) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (let (a) (-> (match a ...) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (let (b) (-> (app lp2 10 (λ (n) ...) x) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (let (b) (-> (match b ...) <-)) (env (() ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (let (lp1) (-> (let (a) ...) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (let (lp2) (-> (let (b) ...) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (lettypes cons ... nil (let (lp1) ...)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (match (-> a <-) (#f) _) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> b <-) (#f) _) (env (() ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match a (#f) (_ (-> x <-))) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (match a ((#f) (-> (let (lp2) ...) <-)) _) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (match b (#f) (_ (-> (app lp1 (app - i 1) y) <-))) (env (() ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (match b ((#f) (-> (let ($tmp$3) ...) <-)) _) (env (() ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (λ (i x) (-> (let (a) ...) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (λ (j f y) (-> (let (b) ...) <-)) (env (() ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (λ (n) (-> (app + n i) <-)) (env (() ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  $tmp$3
  (let (... () ($tmp$3 (-> (app f y) <-)) () ...) ...)
  (env (() ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  ((ran
    cons
    ('unspecified)
    ()
    (bin
     let
     lp1
     (let ((a
            (app
             set!
             lp1
             (λ (i x)
               (let ((a (app = 0 i)))
                 (match
                  a
                  ((#f)
                   (let ((lp2 (app cons 'unspecified (app nil))))
                     (let ((b
                            (app
                             set!
                             lp2
                             (λ (j f y)
                               (let ((b (app = 0 j)))
                                 (match
                                  b
                                  ((#f)
                                   (let (($tmp$3 (app f y)))
                                     (app lp2 (app - j 1) f $tmp$3)))
                                  (_ (app lp1 (app - i 1) y))))))))
                       (app lp2 10 (λ (n) (app + n i)) x))))
                  (_ x)))))))
       (app lp1 10 0))
     ()
     ()
     (lettypes-bod ((cons car cdr) (nil)) (top))))
   app
   nil)
  con
  (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ('unspecified)
    ()
    (bin
     let
     lp2
     (let ((b
            (app
             set!
             lp2
             (λ (j f y)
               (let ((b (app = 0 j)))
                 (match
                  b
                  ((#f)
                   (let (($tmp$3 (app f y))) (app lp2 (app - j 1) f $tmp$3)))
                  (_ (app lp1 (app - i 1) y))))))))
       (app lp2 10 (λ (n) (app + n i)) x))
     ()
     ()
     (match-clause
      (#f)
      a
      ()
      ((_ x))
      (let-bod
       let
       ((a (app = 0 i)))
       (bod
        (i x)
        (ran
         set!
         (lp1)
         ()
         (bin
          let
          a
          (app lp1 10 0)
          ()
          ()
          (let-bod
           let
           ((lp1 (app cons 'unspecified (app nil))))
           (lettypes-bod ((cons car cdr) (nil)) (top))))))))))
   app
   nil)
  con
  (env (())))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app nil))
    (bin
     let
     lp1
     (let ((a
            (app
             set!
             lp1
             (λ (i x)
               (let ((a (app = 0 i)))
                 (match
                  a
                  ((#f)
                   (let ((lp2 (app cons 'unspecified (app nil))))
                     (let ((b
                            (app
                             set!
                             lp2
                             (λ (j f y)
                               (let ((b (app = 0 j)))
                                 (match
                                  b
                                  ((#f)
                                   (let (($tmp$3 (app f y)))
                                     (app lp2 (app - j 1) f $tmp$3)))
                                  (_ (app lp1 (app - i 1) y))))))))
                       (app lp2 10 (λ (n) (app + n i)) x))))
                  (_ x)))))))
       (app lp1 10 0))
     ()
     ()
     (lettypes-bod ((cons car cdr) (nil)) (top))))
   quote
   unspecified)
  con
  (env ()))
clos/con:
	'((app cons (-> 'unspecified <-) (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app nil))
    (bin
     let
     lp2
     (let ((b
            (app
             set!
             lp2
             (λ (j f y)
               (let ((b (app = 0 j)))
                 (match
                  b
                  ((#f)
                   (let (($tmp$3 (app f y))) (app lp2 (app - j 1) f $tmp$3)))
                  (_ (app lp1 (app - i 1) y))))))))
       (app lp2 10 (λ (n) (app + n i)) x))
     ()
     ()
     (match-clause
      (#f)
      a
      ()
      ((_ x))
      (let-bod
       let
       ((a (app = 0 i)))
       (bod
        (i x)
        (ran
         set!
         (lp1)
         ()
         (bin
          let
          a
          (app lp1 10 0)
          ()
          ()
          (let-bod
           let
           ((lp1 (app cons 'unspecified (app nil))))
           (lettypes-bod ((cons car cdr) (nil)) (top))))))))))
   quote
   unspecified)
  con
  (env (())))
clos/con:
	'((app cons (-> 'unspecified <-) (app nil)) (env (())))
literals: '(⊥ ⊥ ⊥)

'(store:
  a
  (let (... () (a (-> (app set! lp1 (λ (i x) ...)) <-)) () ...) ...)
  (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  b
  (let (... () (b (-> (app set! lp2 (λ (j f y) ...)) <-)) () ...) ...)
  (env (())))
clos/con:
	'(((top) app void) (env (())))
literals: '(⊥ ⊥ ⊥)

'(store:
  lp1
  (let (... () (lp1 (-> (app cons 'unspecified (app nil)) <-)) () ...) ...)
  (env ()))
clos/con:
	'((app set! lp1 (-> (λ (i x) ...) <-)) (env ()))
	'((con
   cons
   (let (... () (lp1 (-> (app cons 'unspecified (app nil)) <-)) () ...) ...))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  lp2
  (let (... () (lp2 (-> (app cons 'unspecified (app nil)) <-)) () ...) ...)
  (env (())))
clos/con:
	'((app set! lp2 (-> (λ (j f y) ...) <-)) (env (())))
	'((con
   cons
   (let (... () (lp2 (-> (app cons 'unspecified (app nil)) <-)) () ...) ...))
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(store: a (let (... () (a (-> (app = 0 i) <-)) () ...) ...) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: b (let (... () (b (-> (app = 0 j) <-)) () ...) ...) (env (() ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: f (λ (j f y) (-> (let (b) ...) <-)) (env (() ())))
clos/con:
	'((app lp2 10 (-> (λ (n) ...) <-) x) (env (())))
literals: '(⊥ ⊥ ⊥)

'(store: i (λ (i x) (-> (let (a) ...) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store: j (λ (j f y) (-> (let (b) ...) <-)) (env (() ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store: n (λ (n) (-> (app + n i) <-)) (env (() ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store: x (λ (i x) (-> (let (a) ...) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store: y (λ (j f y) (-> (let (b) ...) <-)) (env (() ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)
