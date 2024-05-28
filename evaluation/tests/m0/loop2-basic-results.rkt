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

'(query: ((top) lettypes (cons ... nil) ...) (env ()))
clos/con: ⊥
literals: '(⊥ ⊥ ⊥)

'(query: (lettypes cons ... nil (let (lp1) ...)) (env ()))
clos/con: ⊥
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (lp1 (-> (app cons 'unspecified (app nil)) <-)) () ...) ...)
  (env ()))
clos/con:
	'((let (... () (lp1 (-> (app cons 'unspecified (app nil)) <-)) () ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 'unspecified (-> (app nil) <-)) (env ()))
clos/con:
	'(((top) app nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> 'unspecified <-) (app nil)) (env ()))
clos/con:
	'((app cons (-> 'unspecified <-) (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 'unspecified (app nil)) (env ()))
clos/con:
	'((app (-> cons <-) 'unspecified (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (lp1) (-> (let (a) ...) <-)) (env ()))
clos/con: ⊥
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (a (-> (app set! lp1 (λ (i x) ...)) <-)) () ...) ...)
  (env ()))
