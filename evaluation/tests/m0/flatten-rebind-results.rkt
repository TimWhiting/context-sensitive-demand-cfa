'(expression:
  (lettypes
   ((cons car cdr) (nil))
   (letrec*
    ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
     (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
     (pair?
      (λ (pair?-v)
        (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
     (null? (λ (null?-v) (match null?-v ((nil) (app #t)) (_ (app #f)))))
     (append
      (λ (x y)
        (match
         (app null? x)
         ((#f) (app cons (app car x) (app append (app cdr x) y)))
         (_ y))))
     (flatten
      (λ (x)
        (match
         (app pair? x)
         ((#f) (match (app null? x) ((#f) (app cons x (app nil))) (_ x)))
         (_
          (app append (app flatten (app car x)) (app flatten (app cdr x))))))))
    (app
     flatten
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))))))

'(query: (app (-> cons <-) (app car x) (app append (app cdr x) y)) (env ()))
clos/con:
	'((app (-> cons <-) (app car x) (app append (app cdr x) y)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   (-> flatten <-)
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
clos/con:
	'((letrec* (... append (flatten (-> (λ (x) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) append ...) ...)
  (env ()))
clos/con:
	'((letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) append ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> 5 <-) (app nil)) (env ()))
clos/con: ⊥
literals: '(5 ⊥ ⊥ ⊥)

'(query: (app car (-> x <-)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (null?-v) (-> (match null?-v ...) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: ((top) lettypes (cons ... nil) ...) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) x (app nil)) (env ()))
clos/con:
	'((app (-> cons <-) x (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec*
   (car ... flatten)
   (->
    (app
     flatten
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil))))
    <-))
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 5 (app nil)) (env ()))
clos/con:
	'((app (-> cons <-) 5 (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cdr (-> x <-)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app cdr (-> x <-)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> cdr <-) x) (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> null? <-) x) (env ()))
clos/con:
	'((letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) append ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app pair? (-> x <-)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app car (-> x <-)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app cons 2 (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> cdr-v <-) (cons cdr-c cdr-d)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-)) (env ()))
clos/con:
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> null? <-) x) (env ()))
clos/con:
	'((letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) append ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons x (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app flatten (-> (app cdr x) <-)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app append (app cdr x) (-> y <-)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (match (app null? x) (#f) (_ (-> x <-))) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app cons 5 (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 1 (app cons 2 (app nil))) (env ()))
clos/con:
	'((app (-> cons <-) 1 (app cons 2 (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> car-v <-) (cons car-c car-d)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ()))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons 4 (-> (app cons 5 (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match pair?-v (cons pair?-c pair?-d) (_ (-> (app #f) <-))) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app null? (-> x <-)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app cons (-> 1 <-) (app cons 2 (app nil))) (env ()))
clos/con: ⊥
literals: '(1 ⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> 2 <-) (app nil)) (env ()))
clos/con: ⊥
literals: '(2 ⊥ ⊥ ⊥)

'(query:
  (app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-))
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query:
  (app cons (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-) (app nil))
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   (app cons 1 (app cons 2 (app nil)))
   (app
    cons
    (app
     cons
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     (app nil))
    (app nil)))
  (env ()))
clos/con:
	'((app
   (-> cons <-)
   (app cons 1 (app cons 2 (app nil)))
   (app
    cons
    (app
     cons
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     (app nil))
    (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> flatten <-) (app car x)) (env ()))
clos/con:
	'((letrec* (... append (flatten (-> (λ (x) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (car-v) (-> (match car-v ...) <-)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> pair?-v <-) (cons pair?-c pair?-d) _) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> (app cons 1 (app cons 2 (app nil))) <-)
   (app
    cons
    (app
     cons
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     (app nil))
    (app nil)))
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app (-> cons <-) (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
  (env ()))
clos/con:
	'((app (-> cons <-) (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 3 (app cons 4 (app cons 5 (app nil)))) (env ()))
clos/con:
	'((app (-> cons <-) 3 (app cons 4 (app cons 5 (app nil)))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (->
    (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
    <-)
   (app nil))
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cdr <-) x) (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (app car x) (-> (app append (app cdr x) y) <-)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (app cons 1 (app cons 2 (app nil)))
   (->
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))
    <-))
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (->
    (app
     cons
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     (app nil))
    <-)
   (app nil))
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match (app pair? x) ((#f) (-> (match (app null? x) ...) <-)) _)
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query:
  (letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (-> (app nil) <-))
  (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons 1 (-> (app cons 2 (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> car <-) x) (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match pair?-v ((cons pair?-c pair?-d) (-> (app #t) <-)) _) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   (app
    cons
    (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
    (app nil))
   (app nil))
  (env ()))
clos/con:
	'((app
   (-> cons <-)
   (app
    cons
    (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
    (app nil))
   (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (cdr-v) (-> (match cdr-v ...) <-)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query:
  (app (-> append <-) (app flatten (app car x)) (app flatten (app cdr x)))
  (env ()))
clos/con:
	'((letrec* (... null? (append (-> (λ (x y) ...) <-)) flatten ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x)))
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (λ (x y) (-> (match (app null? x) ...) <-)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app cons (-> 4 <-) (app cons 5 (app nil))) (env ()))
clos/con: ⊥
literals: '(4 ⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> (app null? x) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> flatten <-) (app cdr x)) (env ()))
clos/con:
	'((letrec* (... append (flatten (-> (λ (x) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
   (app nil))
  (env ()))
clos/con:
	'((app
   (-> cons <-)
   (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
   (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> append <-) (app cdr x) y) (env ()))
clos/con:
	'((letrec* (... null? (append (-> (λ (x y) ...) <-)) flatten ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match
   (app pair? x)
   (#f)
   (_
    (-> (app append (app flatten (app car x)) (app flatten (app cdr x))) <-)))
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (match null?-v (nil) (_ (-> (app #f) <-))) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (app null? x) (#f) (_ (-> y <-))) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (match (-> null?-v <-) (nil) _) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app null? (-> x <-)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-))) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (λ (x) (-> (match (app pair? x) ...) <-)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 4 (app cons 5 (app nil))) (env ()))
clos/con:
	'((app (-> cons <-) 4 (app cons 5 (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match null?-v ((nil) (-> (app #t) <-)) _) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ()))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match
   (app null? x)
   ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
   _)
  (env ()))
clos/con:
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app flatten (-> (app car x) <-)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app cons (-> 3 <-) (app cons 4 (app cons 5 (app nil)))) (env ()))
clos/con: ⊥
literals: '(3 ⊥ ⊥ ⊥)

'(query: (λ (pair?-v) (-> (match pair?-v ...) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec* (... append (flatten (-> (λ (x) ...) <-)) () ...) ...)
  (env ()))
clos/con:
	'((letrec* (... append (flatten (-> (λ (x) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ()))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> (app car x) <-) (app append (app cdr x) y)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (match (-> (app null? x) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app append (-> (app cdr x) <-) y) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ()))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> x <-) (app nil)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 2 (app nil)) (env ()))
clos/con:
	'((app (-> cons <-) 2 (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (lettypes cons ... nil (letrec* (car ... flatten) ...)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query:
  (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _)
  (env ()))
clos/con:
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
   (-> (app nil) <-))
  (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> (app pair? x) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec* (... null? (append (-> (λ (x y) ...) <-)) flatten ...) ...)
  (env ()))
clos/con:
	'((letrec* (... null? (append (-> (λ (x y) ...) <-)) flatten ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match car-v ((cons car-c car-d) (-> car-c <-))) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query:
  (app
   flatten
   (->
    (app
     cons
     (app cons 1 (app cons 2 (app nil)))
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil)))
    <-))
  (env ()))
clos/con:
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> pair? <-) x) (env ()))
clos/con:
	'((letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> car <-) x) (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (app
    cons
    (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
    (app nil))
   (-> (app nil) <-))
  (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons (-> 4 <-) (app cons 5 (app nil))) (env ()))
clos/con: ⊥
literals: '(4 ⊥ ⊥ ⊥)

'(store: car-c (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: x (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-)) (env ()))
clos/con:
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: car-d (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: cdr (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: cdr-c (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store:
  (app
   cons
   (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
   (-> (app nil) <-))
  (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: cdr-v (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: (app cons 2 (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: flatten (env ()))
clos/con:
	'((letrec* (... append (flatten (-> (λ (x) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: cdr-d (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store:
  (app
   cons
   (->
    (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
    <-)
   (app nil))
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons x (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  (app
   cons
   (->
    (app
     cons
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     (app nil))
    <-)
   (app nil))
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: pair?-d (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: (app cons 1 (-> (app cons 2 (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons (-> 2 <-) (app nil)) (env ()))
clos/con: ⊥
literals: '(2 ⊥ ⊥ ⊥)

'(store: null?-v (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store:
  (app cons (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-) (app nil))
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons (-> x <-) (app nil)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: pair? (env ()))
clos/con:
	'((letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: pair?-v (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: _ (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: (app cons (-> 5 <-) (app nil)) (env ()))
clos/con: ⊥
literals: '(5 ⊥ ⊥ ⊥)

'(store: car-v (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: (app cons (-> 1 <-) (app cons 2 (app nil))) (env ()))
clos/con: ⊥
literals: '(1 ⊥ ⊥ ⊥)

'(store:
  (app
   cons
   (app
    cons
    (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
    (app nil))
   (-> (app nil) <-))
  (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons (-> (app car x) <-) (app append (app cdr x) y)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: (app cons (-> 3 <-) (app cons 4 (app cons 5 (app nil)))) (env ()))
clos/con: ⊥
literals: '(3 ⊥ ⊥ ⊥)

'(store: pair?-c (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: (app cons (app car x) (-> (app append (app cdr x) y) <-)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store:
  (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (-> (app nil) <-))
  (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: append (env ()))
clos/con:
	'((letrec* (... null? (append (-> (λ (x y) ...) <-)) flatten ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: null? (env ()))
clos/con:
	'((letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) append ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: y (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (->
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons 3 (app cons 4 (app cons 5 (app nil)))) <-)
    (app nil)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
	'((con
   cons
   (app
    flatten
    (->
     (app
      cons
      (app cons 1 (app cons 2 (app nil)))
      (app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store:
  (app
   cons
   (-> (app cons 1 (app cons 2 (app nil))) <-)
   (app
    cons
    (app
     cons
     (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
     (app nil))
    (app nil)))
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons 1 (app cons 2 (app nil))) <-)
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons 4 (-> (app cons 5 (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  (app
   cons
   (app cons 1 (app cons 2 (app nil)))
   (->
    (app
     cons
     (app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil))
     (app nil))
    <-))
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (app cons 1 (app cons 2 (app nil)))
    (->
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))
     <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons 5 (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: car (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)
