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
  (app (-> f <-) y)
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con:
	'((app lp2 10 (-> (λ (n) ...) <-) x)
  (env (((let (a) (-> (app lp1 10 0) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f <-) y)
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con:
	'((app lp2 10 (-> (λ (n) ...) <-) x)
  (env (((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f <-) y)
  (env
   (((let (b) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con:
	'((app lp2 10 (-> (λ (n) ...) <-) x)
  (env (((let (a) (-> (app lp1 10 0) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f <-) y)
  (env
   (((let (b) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con:
	'((app lp2 10 (-> (λ (n) ...) <-) x)
  (env (((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> lp1 <-) (app - i 1) y)
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con:
	'((app set! lp1 (-> (λ (i x) ...) <-)) (env ()))
	'((con
   cons
   (let (... () (lp1 (-> (app cons 'unspecified (app nil)) <-)) () ...) ...))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> lp1 <-) (app - i 1) y)
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con:
	'((app set! lp1 (-> (λ (i x) ...) <-)) (env ()))
	'((con
   cons
   (let (... () (lp1 (-> (app cons 'unspecified (app nil)) <-)) () ...) ...))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> lp2 <-) (app - j 1) f $tmp$3)
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con:
	'((app set! lp2 (-> (λ (j f y) ...) <-))
  (env (((let (a) (-> (app lp1 10 0) <-))))))
	'((con
   cons
   (let (... () (lp2 (-> (app cons 'unspecified (app nil)) <-)) () ...) ...))
  (env (((let (a) (-> (app lp1 10 0) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> lp2 <-) (app - j 1) f $tmp$3)
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con:
	'((app set! lp2 (-> (λ (j f y) ...) <-))
  (env (((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
	'((con
   cons
   (let (... () (lp2 (-> (app cons 'unspecified (app nil)) <-)) () ...) ...))
  (env (((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> lp2 <-) (app - j 1) f $tmp$3)
  (env
   (((let (b) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con:
	'((app set! lp2 (-> (λ (j f y) ...) <-))
  (env (((let (a) (-> (app lp1 10 0) <-))))))
	'((con
   cons
   (let (... () (lp2 (-> (app cons 'unspecified (app nil)) <-)) () ...) ...))
  (env (((let (a) (-> (app lp1 10 0) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> lp2 <-) (app - j 1) f $tmp$3)
  (env
   (((let (b) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con:
	'((app set! lp2 (-> (λ (j f y) ...) <-))
  (env (((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
	'((con
   cons
   (let (... () (lp2 (-> (app cons 'unspecified (app nil)) <-)) () ...) ...))
  (env (((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> lp2 <-) 10 (λ (n) ...) x)
  (env (((let (a) (-> (app lp1 10 0) <-))))))
clos/con:
	'((app set! lp2 (-> (λ (j f y) ...) <-))
  (env (((let (a) (-> (app lp1 10 0) <-))))))
	'((con
   cons
   (let (... () (lp2 (-> (app cons 'unspecified (app nil)) <-)) () ...) ...))
  (env (((let (a) (-> (app lp1 10 0) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> lp2 <-) 10 (λ (n) ...) x)
  (env (((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con:
	'((app set! lp2 (-> (λ (j f y) ...) <-))
  (env (((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
	'((con
   cons
   (let (... () (lp2 (-> (app cons 'unspecified (app nil)) <-)) () ...) ...))
  (env (((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app + (-> n <-) i)
  (env
   (((let (... () ($tmp$3 (-> (app f y) <-)) () ...) ...))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app + (-> n <-) i)
  (env
   (((let (... () ($tmp$3 (-> (app f y) <-)) () ...) ...))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app + n (-> i <-))
  (env
   (((let (... () ($tmp$3 (-> (app f y) <-)) () ...) ...))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query:
  (app + n (-> i <-))
  (env
   (((let (... () ($tmp$3 (-> (app f y) <-)) () ...) ...))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> i <-) 1)
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query:
  (app - (-> i <-) 1)
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> j <-) 1)
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> j <-) 1)
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> j <-) 1)
  (env
   (((let (b) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query:
  (app - (-> j <-) 1)
  (env
   (((let (b) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query:
  (app = 0 (-> i <-))
  (env (((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = 0 (-> j <-))
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = 0 (-> j <-))
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = 0 (-> j <-))
  (env
   (((let (b) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query:
  (app = 0 (-> j <-))
  (env
   (((let (b) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query:
  (app cons 'unspecified (-> (app nil) <-))
  (env (((let (a) (-> (app lp1 10 0) <-))))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons 'unspecified (-> (app nil) <-))
  (env (((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f (-> y <-))
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app f (-> y <-))
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app f (-> y <-))
  (env
   (((let (b) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query:
  (app f (-> y <-))
  (env
   (((let (b) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app lp1 (-> (app - i 1) <-) y)
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(9 ⊥ ⊥)

'(query:
  (app lp1 (-> (app - i 1) <-) y)
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app lp1 (app - i 1) (-> y <-))
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app lp1 (app - i 1) (-> y <-))
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app lp2 (-> (app - j 1) <-) f $tmp$3)
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app lp2 (-> (app - j 1) <-) f $tmp$3)
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app lp2 (-> (app - j 1) <-) f $tmp$3)
  (env
   (((let (b) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(9 ⊥ ⊥)

'(query:
  (app lp2 (-> (app - j 1) <-) f $tmp$3)
  (env
   (((let (b) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(9 ⊥ ⊥)

'(query:
  (app lp2 (app - j 1) (-> f <-) $tmp$3)
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con:
	'((app lp2 10 (-> (λ (n) ...) <-) x)
  (env (((let (a) (-> (app lp1 10 0) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app lp2 (app - j 1) (-> f <-) $tmp$3)
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con:
	'((app lp2 10 (-> (λ (n) ...) <-) x)
  (env (((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app lp2 (app - j 1) (-> f <-) $tmp$3)
  (env
   (((let (b) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con:
	'((app lp2 10 (-> (λ (n) ...) <-) x)
  (env (((let (a) (-> (app lp1 10 0) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app lp2 (app - j 1) (-> f <-) $tmp$3)
  (env
   (((let (b) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con:
	'((app lp2 10 (-> (λ (n) ...) <-) x)
  (env (((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app lp2 (app - j 1) f (-> $tmp$3 <-))
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app lp2 (app - j 1) f (-> $tmp$3 <-))
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app lp2 (app - j 1) f (-> $tmp$3 <-))
  (env
   (((let (b) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app lp2 (app - j 1) f (-> $tmp$3 <-))
  (env
   (((let (b) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app lp2 10 (λ (n) ...) (-> x <-))
  (env (((let (a) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query:
  (app lp2 10 (λ (n) ...) (-> x <-))
  (env (((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-))
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-))
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-))
  (env
   (((let (b) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-))
  (env
   (((let (b) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let (... () ($tmp$3 (-> (app f y) <-)) () ...) ...)
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let (... () ($tmp$3 (-> (app f y) <-)) () ...) ...)
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let (... () ($tmp$3 (-> (app f y) <-)) () ...) ...)
  (env
   (((let (b) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let (... () ($tmp$3 (-> (app f y) <-)) () ...) ...)
  (env
   (((let (b) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let (... () (a (-> (app = 0 i) <-)) () ...) ...)
  (env (((let (a) (-> (app lp1 10 0) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (a (-> (app = 0 i) <-)) () ...) ...)
  (env (((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (a (-> (app set! lp1 (λ (i x) ...)) <-)) () ...) ...)
  (env ()))
clos/con:
	'((con void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (b (-> (app = 0 j) <-)) () ...) ...)
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (b (-> (app = 0 j) <-)) () ...) ...)
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (b (-> (app = 0 j) <-)) () ...) ...)
  (env
   (((let (b) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (b (-> (app = 0 j) <-)) () ...) ...)
  (env
   (((let (b) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (b (-> (app set! lp2 (λ (j f y) ...)) <-)) () ...) ...)
  (env (((let (a) (-> (app lp1 10 0) <-))))))
clos/con:
	'((con void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (b (-> (app set! lp2 (λ (j f y) ...)) <-)) () ...) ...)
  (env (((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con:
	'((con void) (env ()))
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
  (env (((let (a) (-> (app lp1 10 0) <-))))))
clos/con:
	'((con
   cons
   (let (... () (lp2 (-> (app cons 'unspecified (app nil)) <-)) () ...) ...))
  (env (((let (a) (-> (app lp1 10 0) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (lp2 (-> (app cons 'unspecified (app nil)) <-)) () ...) ...)
  (env (((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con:
	'((con
   cons
   (let (... () (lp2 (-> (app cons 'unspecified (app nil)) <-)) () ...) ...))
  (env (((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (a) (-> (match a ...) <-))
  (env (((let (a) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let (a) (-> (match a ...) <-))
  (env (((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let (b) (-> (app lp2 10 (λ (n) ...) x) <-))
  (env (((let (a) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let (b) (-> (app lp2 10 (λ (n) ...) x) <-))
  (env (((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let (b) (-> (match b ...) <-))
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let (b) (-> (match b ...) <-))
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let (b) (-> (match b ...) <-))
  (env
   (((let (b) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let (b) (-> (match b ...) <-))
  (env
   (((let (b) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let (lp2) (-> (let (b) ...) <-))
  (env (((let (a) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let (lp2) (-> (let (b) ...) <-))
  (env (((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (-> a <-) (#f) _)
  (env (((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> b <-) (#f) _)
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> b <-) (#f) _)
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> b <-) (#f) _)
  (env
   (((let (b) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> b <-) (#f) _)
  (env
   (((let (b) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match a (#f) (_ (-> x <-)))
  (env (((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match a ((#f) (-> (let (lp2) ...) <-)) _)
  (env (((let (a) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match a ((#f) (-> (let (lp2) ...) <-)) _)
  (env (((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match b ((#f) (-> (let ($tmp$3) ...) <-)) _)
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match b ((#f) (-> (let ($tmp$3) ...) <-)) _)
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match b ((#f) (-> (let ($tmp$3) ...) <-)) _)
  (env
   (((let (b) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match b ((#f) (-> (let ($tmp$3) ...) <-)) _)
  (env
   (((let (b) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (i x) (-> (let (a) ...) <-))
  (env (((let (a) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (i x) (-> (let (a) ...) <-))
  (env (((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (j f y) (-> (let (b) ...) <-))
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (j f y) (-> (let (b) ...) <-))
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (j f y) (-> (let (b) ...) <-))
  (env
   (((let (b) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (j f y) (-> (let (b) ...) <-))
  (env
   (((let (b) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (n) (-> (app + n i) <-))
  (env
   (((let (... () ($tmp$3 (-> (app f y) <-)) () ...) ...))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (n) (-> (app + n i) <-))
  (env
   (((let (... () ($tmp$3 (-> (app f y) <-)) () ...) ...))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: ((top) lettypes (cons ... nil) ...) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> lp1 <-) 10 0) (env ()))
clos/con:
	'((app set! lp1 (-> (λ (i x) ...) <-)) (env ()))
	'((con
   cons
   (let (... () (lp1 (-> (app cons 'unspecified (app nil)) <-)) () ...) ...))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app = 0 (-> i <-)) (env (((let (a) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(query: (app cons 'unspecified (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (a) (-> (app lp1 10 0) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (let (lp1) (-> (let (a) ...) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (lettypes cons ... nil (let (lp1) ...)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (match (-> a <-) (#f) _) (env (((let (a) (-> (app lp1 10 0) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  $tmp$3
  (let (... () ($tmp$3 (-> (app f y) <-)) () ...) ...)
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  $tmp$3
  (let (... () ($tmp$3 (-> (app f y) <-)) () ...) ...)
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  $tmp$3
  (let (... () ($tmp$3 (-> (app f y) <-)) () ...) ...)
  (env
   (((let (b) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  $tmp$3
  (let (... () ($tmp$3 (-> (app f y) <-)) () ...) ...)
  (env
   (((let (b) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  a
  (let (... () (a (-> (app = 0 i) <-)) () ...) ...)
  (env (((let (a) (-> (app lp1 10 0) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  a
  (let (... () (a (-> (app = 0 i) <-)) () ...) ...)
  (env (((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  a
  (let (... () (a (-> (app set! lp1 (λ (i x) ...)) <-)) () ...) ...)
  (env ()))
clos/con:
	'((con void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  b
  (let (... () (b (-> (app = 0 j) <-)) () ...) ...)
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  b
  (let (... () (b (-> (app = 0 j) <-)) () ...) ...)
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  b
  (let (... () (b (-> (app = 0 j) <-)) () ...) ...)
  (env
   (((let (b) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  b
  (let (... () (b (-> (app = 0 j) <-)) () ...) ...)
  (env
   (((let (b) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  b
  (let (... () (b (-> (app set! lp2 (λ (j f y) ...)) <-)) () ...) ...)
  (env (((let (a) (-> (app lp1 10 0) <-))))))
clos/con:
	'((con void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  b
  (let (... () (b (-> (app set! lp2 (λ (j f y) ...)) <-)) () ...) ...)
  (env (((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con:
	'((con void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons 'unspecified (-> (app nil) <-))
  (env (((let (a) (-> (app lp1 10 0) <-))))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons 'unspecified (-> (app nil) <-))
  (env (((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> 'unspecified <-) (app nil))
  (env (((let (a) (-> (app lp1 10 0) <-))))))
clos/con:
	'((app cons (-> 'unspecified <-) (app nil))
  (env (((let (a) (-> (app lp1 10 0) <-))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> 'unspecified <-) (app nil))
  (env (((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con:
	'((app cons (-> 'unspecified <-) (app nil))
  (env (((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  f
  (λ (j f y) (-> (let (b) ...) <-))
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con:
	'((app lp2 10 (-> (λ (n) ...) <-) x)
  (env (((let (a) (-> (app lp1 10 0) <-))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  f
  (λ (j f y) (-> (let (b) ...) <-))
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con:
	'((app lp2 10 (-> (λ (n) ...) <-) x)
  (env (((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  f
  (λ (j f y) (-> (let (b) ...) <-))
  (env
   (((let (b) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con:
	'((app lp2 10 (-> (λ (n) ...) <-) x)
  (env (((let (a) (-> (app lp1 10 0) <-))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  f
  (λ (j f y) (-> (let (b) ...) <-))
  (env
   (((let (b) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con:
	'((app lp2 10 (-> (λ (n) ...) <-) x)
  (env (((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  i
  (λ (i x) (-> (let (a) ...) <-))
  (env (((let (a) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(store:
  i
  (λ (i x) (-> (let (a) ...) <-))
  (env (((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  j
  (λ (j f y) (-> (let (b) ...) <-))
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  j
  (λ (j f y) (-> (let (b) ...) <-))
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  j
  (λ (j f y) (-> (let (b) ...) <-))
  (env
   (((let (b) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

'(store:
  j
  (λ (j f y) (-> (let (b) ...) <-))
  (env
   (((let (b) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(10 ⊥ ⊥)

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
  (env (((let (a) (-> (app lp1 10 0) <-))))))
clos/con:
	'((app set! lp2 (-> (λ (j f y) ...) <-))
  (env (((let (a) (-> (app lp1 10 0) <-))))))
	'((con
   cons
   (let (... () (lp2 (-> (app cons 'unspecified (app nil)) <-)) () ...) ...))
  (env (((let (a) (-> (app lp1 10 0) <-))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  lp2
  (let (... () (lp2 (-> (app cons 'unspecified (app nil)) <-)) () ...) ...)
  (env (((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con:
	'((app set! lp2 (-> (λ (j f y) ...) <-))
  (env (((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
	'((con
   cons
   (let (... () (lp2 (-> (app cons 'unspecified (app nil)) <-)) () ...) ...))
  (env (((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  n
  (λ (n) (-> (app + n i) <-))
  (env
   (((let (... () ($tmp$3 (-> (app f y) <-)) () ...) ...))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  n
  (λ (n) (-> (app + n i) <-))
  (env
   (((let (... () ($tmp$3 (-> (app f y) <-)) () ...) ...))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  x
  (λ (i x) (-> (let (a) ...) <-))
  (env (((let (a) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(store:
  x
  (λ (i x) (-> (let (a) ...) <-))
  (env (((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  y
  (λ (j f y) (-> (let (b) ...) <-))
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  y
  (λ (j f y) (-> (let (b) ...) <-))
  (env
   (((let ($tmp$3) (-> (app lp2 (app - j 1) f $tmp$3) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  y
  (λ (j f y) (-> (let (b) ...) <-))
  (env
   (((let (b) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((let (a) (-> (app lp1 10 0) <-))))))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(store:
  y
  (λ (j f y) (-> (let (b) ...) <-))
  (env
   (((let (b) (-> (app lp2 10 (λ (n) ...) x) <-)))
    ((match b (#f) (_ (-> (app lp1 (app - i 1) y) <-)))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store: con (app cons 'unspecified (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: con (app cons (-> 'unspecified <-) (app nil)) (env ()))
clos/con:
	'((app cons (-> 'unspecified <-) (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)
