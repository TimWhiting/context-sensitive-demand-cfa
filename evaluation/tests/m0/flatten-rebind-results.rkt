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

'(query:
  (app
   cons
   (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
   (-> (app nil) <-))
  (env ()))
clos/con:
	'((con nil) (env ()))
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

'(query:
  (app (-> append <-) (app flatten (app car x)) (app flatten (app cdr x)))
  (env ()))
clos/con:
	'((letrec* (... null? (append (-> (λ (x y) ...) <-)) flatten ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app (-> cons <-) (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
  (env ()))
clos/con:
	'((app (-> cons <-) (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
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
  (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (-> (app nil) <-))
  (env ()))
clos/con:
	'((con nil) (env ()))
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

'(query:
  (letrec* (... append (flatten (-> (λ (x) ...) <-)) () ...) ...)
  (env ()))
clos/con:
	'((letrec* (... append (flatten (-> (λ (x) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec* (... null? (append (-> (λ (x y) ...) <-)) flatten ...) ...)
  (env ()))
clos/con:
	'((letrec* (... null? (append (-> (λ (x y) ...) <-)) flatten ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) append ...) ...)
  (env ()))
clos/con:
	'((letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) append ...) ...)
  (env ()))
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

'(query:
  (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _)
  (env ()))
clos/con:
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
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

'(query: (app (-> #f <-)) (env ()))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ()))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ()))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ()))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> append <-) (app cdr x) y) (env ()))
clos/con:
	'((letrec* (... null? (append (-> (λ (x y) ...) <-)) flatten ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> car <-) x) (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> car <-) x) (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cdr <-) x) (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cdr <-) x) (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) (app car x) (app append (app cdr x) y)) (env ()))
clos/con:
	'((app (-> cons <-) (app car x) (app append (app cdr x) y)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 1 (app cons 2 (app nil))) (env ()))
clos/con:
	'((app (-> cons <-) 1 (app cons 2 (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 2 (app nil)) (env ()))
clos/con:
	'((app (-> cons <-) 2 (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 3 (app cons 4 (app cons 5 (app nil)))) (env ()))
clos/con:
	'((app (-> cons <-) 3 (app cons 4 (app cons 5 (app nil)))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 4 (app cons 5 (app nil))) (env ()))
clos/con:
	'((app (-> cons <-) 4 (app cons 5 (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 5 (app nil)) (env ()))
clos/con:
	'((app (-> cons <-) 5 (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) x (app nil)) (env ()))
clos/con:
	'((app (-> cons <-) x (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> flatten <-) (app car x)) (env ()))
clos/con:
	'((letrec* (... append (flatten (-> (λ (x) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> flatten <-) (app cdr x)) (env ()))
clos/con:
	'((letrec* (... append (flatten (-> (λ (x) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> null? <-) x) (env ()))
clos/con:
	'((letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) append ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> null? <-) x) (env ()))
clos/con:
	'((letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) append ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> pair? <-) x) (env ()))
clos/con:
	'((letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...) (env ()))
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

'(query: (app cons (-> 1 <-) (app cons 2 (app nil))) (env ()))
clos/con: ⊥
literals: '(1 ⊥ ⊥ ⊥)

'(query: (app cons (-> 2 <-) (app nil)) (env ()))
clos/con: ⊥
literals: '(2 ⊥ ⊥ ⊥)

'(query: (app cons (-> 3 <-) (app cons 4 (app cons 5 (app nil)))) (env ()))
clos/con: ⊥
literals: '(3 ⊥ ⊥ ⊥)

'(query: (app cons (-> 4 <-) (app cons 5 (app nil))) (env ()))
clos/con: ⊥
literals: '(4 ⊥ ⊥ ⊥)

'(query: (app cons (-> 5 <-) (app nil)) (env ()))
clos/con: ⊥
literals: '(5 ⊥ ⊥ ⊥)

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

'(query: (app cons 1 (-> (app cons 2 (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons 2 (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-)) (env ()))
clos/con:
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons 4 (-> (app cons 5 (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons 5 (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons x (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
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

'(query: (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
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

'(query: (match (-> (app null? x) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> (app null? x) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> (app pair? x) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
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

'(query: (match null?-v ((nil) (-> (app #t) <-)) _) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match null?-v (nil) (_ (-> (app #f) <-))) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match pair?-v ((cons pair?-c pair?-d) (-> (app #t) <-)) _) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match pair?-v (cons pair?-c pair?-d) (_ (-> (app #f) <-))) (env ()))
clos/con:
	'((con #f) (env ()))
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

'(query: (λ (null?-v) (-> (match null?-v ...) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (pair?-v) (-> (match pair?-v ...) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

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

'(store:
  ((ran
    cons
    ((app
      cons
      (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
      (app nil)))
    ()
    (ran
     cons
     ((app cons 1 (app cons 2 (app nil))))
     ()
     (ran
      flatten
      ()
      ()
      (let-bod
       letrec*
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
             (app
              append
              (app flatten (app car x))
              (app flatten (app cdr x))))))))
       (lettypes-bod ((cons car cdr) (nil)) (top))))))
   app
   nil)
  con
  (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ((app car x))
    ()
    (match-clause
     (#f)
     (app null? x)
     ()
     ((_ y))
     (bod
      (x y)
      (bin
       letrec*
       append
       (app
        flatten
        (app
         cons
         (app cons 1 (app cons 2 (app nil)))
         (app
          cons
          (app
           cons
           (app
            cons
            (app cons 3 (app cons 4 (app cons 5 (app nil))))
            (app nil))
           (app nil))
          (app nil))))
       ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
        (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
        (pair?
         (λ (pair?-v)
           (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
        (null? (λ (null?-v) (match null?-v ((nil) (app #t)) (_ (app #f))))))
       ((flatten
         (λ (x)
           (match
            (app pair? x)
            ((#f) (match (app null? x) ((#f) (app cons x (app nil))) (_ x)))
            (_
             (app
              append
              (app flatten (app car x))
              (app flatten (app cdr x))))))))
       (lettypes-bod ((cons car cdr) (nil)) (top))))))
   app
   append
   (app cdr x)
   y)
  con
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

'(store:
  ((ran
    cons
    ((app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil)))
    ()
    (ran
     cons
     ()
     ((app nil))
     (ran
      cons
      ((app cons 1 (app cons 2 (app nil))))
      ()
      (ran
       flatten
       ()
       ()
       (let-bod
        letrec*
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
              (app
               append
               (app flatten (app car x))
               (app flatten (app cdr x))))))))
        (lettypes-bod ((cons car cdr) (nil)) (top)))))))
   app
   nil)
  con
  (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ((app cons 1 (app cons 2 (app nil))))
    ()
    (ran
     flatten
     ()
     ()
     (let-bod
      letrec*
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
            (app
             append
             (app flatten (app car x))
             (app flatten (app cdr x))))))))
      (lettypes-bod ((cons car cdr) (nil)) (top)))))
   app
   cons
   (app
    cons
    (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
    (app nil))
   (app nil))
  con
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

'(store:
  ((ran
    cons
    ((app cons 3 (app cons 4 (app cons 5 (app nil)))))
    ()
    (ran
     cons
     ()
     ((app nil))
     (ran
      cons
      ()
      ((app nil))
      (ran
       cons
       ((app cons 1 (app cons 2 (app nil))))
       ()
       (ran
        flatten
        ()
        ()
        (let-bod
         letrec*
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
               (app
                append
                (app flatten (app car x))
                (app flatten (app cdr x))))))))
         (lettypes-bod ((cons car cdr) (nil)) (top))))))))
   app
   nil)
  con
  (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil)))
    (ran
     flatten
     ()
     ()
     (let-bod
      letrec*
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
            (app
             append
             (app flatten (app car x))
             (app flatten (app cdr x))))))))
      (lettypes-bod ((cons car cdr) (nil)) (top)))))
   app
   cons
   1
   (app cons 2 (app nil)))
  con
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

'(store:
  ((ran
    cons
    ()
    ((app append (app cdr x) y))
    (match-clause
     (#f)
     (app null? x)
     ()
     ((_ y))
     (bod
      (x y)
      (bin
       letrec*
       append
       (app
        flatten
        (app
         cons
         (app cons 1 (app cons 2 (app nil)))
         (app
          cons
          (app
           cons
           (app
            cons
            (app cons 3 (app cons 4 (app cons 5 (app nil))))
            (app nil))
           (app nil))
          (app nil))))
       ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
        (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
        (pair?
         (λ (pair?-v)
           (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
        (null? (λ (null?-v) (match null?-v ((nil) (app #t)) (_ (app #f))))))
       ((flatten
         (λ (x)
           (match
            (app pair? x)
            ((#f) (match (app null? x) ((#f) (app cons x (app nil))) (_ x)))
            (_
             (app
              append
              (app flatten (app car x))
              (app flatten (app cdr x))))))))
       (lettypes-bod ((cons car cdr) (nil)) (top))))))
   app
   car
   x)
  con
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

'(store:
  ((ran
    cons
    ()
    ((app cons 2 (app nil)))
    (ran
     cons
     ()
     ((app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     (ran
      flatten
      ()
      ()
      (let-bod
       letrec*
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
             (app
              append
              (app flatten (app car x))
              (app flatten (app cdr x))))))))
       (lettypes-bod ((cons car cdr) (nil)) (top))))))
   .
   1)
  con
  (env ()))
clos/con: ⊥
literals: '(1 ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app cons 4 (app cons 5 (app nil))))
    (ran
     cons
     ()
     ((app nil))
     (ran
      cons
      ()
      ((app nil))
      (ran
       cons
       ()
       ((app nil))
       (ran
        cons
        ((app cons 1 (app cons 2 (app nil))))
        ()
        (ran
         flatten
         ()
         ()
         (let-bod
          letrec*
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
                (app
                 append
                 (app flatten (app car x))
                 (app flatten (app cdr x))))))))
          (lettypes-bod ((cons car cdr) (nil)) (top)))))))))
   .
   3)
  con
  (env ()))
clos/con: ⊥
literals: '(3 ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app cons 5 (app nil)))
    (ran
     cons
     (3)
     ()
     (ran
      cons
      ()
      ((app nil))
      (ran
       cons
       ()
       ((app nil))
       (ran
        cons
        ()
        ((app nil))
        (ran
         cons
         ((app cons 1 (app cons 2 (app nil))))
         ()
         (ran
          flatten
          ()
          ()
          (let-bod
           letrec*
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
                ((#f)
                 (match (app null? x) ((#f) (app cons x (app nil))) (_ x)))
                (_
                 (app
                  append
                  (app flatten (app car x))
                  (app flatten (app cdr x))))))))
           (lettypes-bod ((cons car cdr) (nil)) (top))))))))))
   .
   4)
  con
  (env ()))
clos/con: ⊥
literals: '(4 ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app nil))
    (match-clause
     (#f)
     (app null? x)
     ()
     ((_ x))
     (match-clause
      (#f)
      (app pair? x)
      ()
      ((_ (app append (app flatten (app car x)) (app flatten (app cdr x)))))
      (bod
       (x)
       (bin
        letrec*
        flatten
        (app
         flatten
         (app
          cons
          (app cons 1 (app cons 2 (app nil)))
          (app
           cons
           (app
            cons
            (app
             cons
             (app cons 3 (app cons 4 (app cons 5 (app nil))))
             (app nil))
            (app nil))
           (app nil))))
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
             (_ y)))))
        ()
        (lettypes-bod ((cons car cdr) (nil)) (top)))))))
   .
   x)
  con
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

'(store:
  ((ran
    cons
    ()
    ((app nil))
    (ran
     cons
     ((app cons 1 (app cons 2 (app nil))))
     ()
     (ran
      flatten
      ()
      ()
      (let-bod
       letrec*
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
             (app
              append
              (app flatten (app car x))
              (app flatten (app cdr x))))))))
       (lettypes-bod ((cons car cdr) (nil)) (top))))))
   app
   cons
   (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
   (app nil))
  con
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

'(store:
  ((ran
    cons
    ()
    ((app nil))
    (ran
     cons
     ()
     ((app nil))
     (ran
      cons
      ((app cons 1 (app cons 2 (app nil))))
      ()
      (ran
       flatten
       ()
       ()
       (let-bod
        letrec*
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
              (app
               append
               (app flatten (app car x))
               (app flatten (app cdr x))))))))
        (lettypes-bod ((cons car cdr) (nil)) (top)))))))
   app
   cons
   (app cons 3 (app cons 4 (app cons 5 (app nil))))
   (app nil))
  con
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

'(store:
  ((ran
    cons
    ()
    ((app nil))
    (ran
     cons
     ()
     ((app nil))
     (ran
      cons
      ()
      ((app nil))
      (ran
       cons
       ((app cons 1 (app cons 2 (app nil))))
       ()
       (ran
        flatten
        ()
        ()
        (let-bod
         letrec*
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
               (app
                append
                (app flatten (app car x))
                (app flatten (app cdr x))))))))
         (lettypes-bod ((cons car cdr) (nil)) (top))))))))
   app
   cons
   3
   (app cons 4 (app cons 5 (app nil))))
  con
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

'(store:
  ((ran
    cons
    ()
    ((app nil))
    (ran
     cons
     (1)
     ()
     (ran
      cons
      ()
      ((app
        cons
        (app
         cons
         (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
         (app nil))
        (app nil)))
      (ran
       flatten
       ()
       ()
       (let-bod
        letrec*
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
              (app
               append
               (app flatten (app car x))
               (app flatten (app cdr x))))))))
        (lettypes-bod ((cons car cdr) (nil)) (top)))))))
   .
   2)
  con
  (env ()))
clos/con: ⊥
literals: '(2 ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app nil))
    (ran
     cons
     (4)
     ()
     (ran
      cons
      (3)
      ()
      (ran
       cons
       ()
       ((app nil))
       (ran
        cons
        ()
        ((app nil))
        (ran
         cons
         ()
         ((app nil))
         (ran
          cons
          ((app cons 1 (app cons 2 (app nil))))
          ()
          (ran
           flatten
           ()
           ()
           (let-bod
            letrec*
            ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
             (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
             (pair?
              (λ (pair?-v)
                (match
                 pair?-v
                 ((cons pair?-c pair?-d) (app #t))
                 (_ (app #f)))))
             (null?
              (λ (null?-v) (match null?-v ((nil) (app #t)) (_ (app #f)))))
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
                 ((#f)
                  (match (app null? x) ((#f) (app cons x (app nil))) (_ x)))
                 (_
                  (app
                   append
                   (app flatten (app car x))
                   (app flatten (app cdr x))))))))
            (lettypes-bod ((cons car cdr) (nil)) (top)))))))))))
   .
   5)
  con
  (env ()))
clos/con: ⊥
literals: '(5 ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    (1)
    ()
    (ran
     cons
     ()
     ((app
       cons
       (app
        cons
        (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
        (app nil))
       (app nil)))
     (ran
      flatten
      ()
      ()
      (let-bod
       letrec*
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
             (app
              append
              (app flatten (app car x))
              (app flatten (app cdr x))))))))
       (lettypes-bod ((cons car cdr) (nil)) (top))))))
   app
   cons
   2
   (app nil))
  con
  (env ()))
clos/con:
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    (2)
    ()
    (ran
     cons
     (1)
     ()
     (ran
      cons
      ()
      ((app
        cons
        (app
         cons
         (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
         (app nil))
        (app nil)))
      (ran
       flatten
       ()
       ()
       (let-bod
        letrec*
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
              (app
               append
               (app flatten (app car x))
               (app flatten (app cdr x))))))))
        (lettypes-bod ((cons car cdr) (nil)) (top)))))))
   app
   nil)
  con
  (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    (3)
    ()
    (ran
     cons
     ()
     ((app nil))
     (ran
      cons
      ()
      ((app nil))
      (ran
       cons
       ()
       ((app nil))
       (ran
        cons
        ((app cons 1 (app cons 2 (app nil))))
        ()
        (ran
         flatten
         ()
         ()
         (let-bod
          letrec*
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
                (app
                 append
                 (app flatten (app car x))
                 (app flatten (app cdr x))))))))
          (lettypes-bod ((cons car cdr) (nil)) (top)))))))))
   app
   cons
   4
   (app cons 5 (app nil)))
  con
  (env ()))
clos/con:
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    (4)
    ()
    (ran
     cons
     (3)
     ()
     (ran
      cons
      ()
      ((app nil))
      (ran
       cons
       ()
       ((app nil))
       (ran
        cons
        ()
        ((app nil))
        (ran
         cons
         ((app cons 1 (app cons 2 (app nil))))
         ()
         (ran
          flatten
          ()
          ()
          (let-bod
           letrec*
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
                ((#f)
                 (match (app null? x) ((#f) (app cons x (app nil))) (_ x)))
                (_
                 (app
                  append
                  (app flatten (app car x))
                  (app flatten (app cdr x))))))))
           (lettypes-bod ((cons car cdr) (nil)) (top))))))))))
   app
   cons
   5
   (app nil))
  con
  (env ()))
clos/con:
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    (5)
    ()
    (ran
     cons
     (4)
     ()
     (ran
      cons
      (3)
      ()
      (ran
       cons
       ()
       ((app nil))
       (ran
        cons
        ()
        ((app nil))
        (ran
         cons
         ()
         ((app nil))
         (ran
          cons
          ((app cons 1 (app cons 2 (app nil))))
          ()
          (ran
           flatten
           ()
           ()
           (let-bod
            letrec*
            ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
             (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
             (pair?
              (λ (pair?-v)
                (match
                 pair?-v
                 ((cons pair?-c pair?-d) (app #t))
                 (_ (app #f)))))
             (null?
              (λ (null?-v) (match null?-v ((nil) (app #t)) (_ (app #f)))))
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
                 ((#f)
                  (match (app null? x) ((#f) (app cons x (app nil))) (_ x)))
                 (_
                  (app
                   append
                   (app flatten (app car x))
                   (app flatten (app cdr x))))))))
            (lettypes-bod ((cons car cdr) (nil)) (top)))))))))))
   app
   nil)
  con
  (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    (x)
    ()
    (match-clause
     (#f)
     (app null? x)
     ()
     ((_ x))
     (match-clause
      (#f)
      (app pair? x)
      ()
      ((_ (app append (app flatten (app car x)) (app flatten (app cdr x)))))
      (bod
       (x)
       (bin
        letrec*
        flatten
        (app
         flatten
         (app
          cons
          (app cons 1 (app cons 2 (app nil)))
          (app
           cons
           (app
            cons
            (app
             cons
             (app cons 3 (app cons 4 (app cons 5 (app nil))))
             (app nil))
            (app nil))
           (app nil))))
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
             (_ y)))))
        ()
        (lettypes-bod ((cons car cdr) (nil)) (top)))))))
   app
   nil)
  con
  (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  _
  (match pair?-v (cons pair?-c pair?-d) (_ (-> (app #f) <-)))
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(store:
  append
  (letrec* (... null? (append (-> (λ (x y) ...) <-)) flatten ...) ...)
  (env ()))
clos/con:
	'((letrec* (... null? (append (-> (λ (x y) ...) <-)) flatten ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  car
  (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  cdr
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  flatten
  (letrec* (... append (flatten (-> (λ (x) ...) <-)) () ...) ...)
  (env ()))
clos/con:
	'((letrec* (... append (flatten (-> (λ (x) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  null?
  (letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) append ...) ...)
  (env ()))
clos/con:
	'((letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) append ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  pair?
  (letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  pair?-c
  (match pair?-v ((cons pair?-c pair?-d) (-> (app #t) <-)) _)
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

'(store:
  pair?-d
  (match pair?-v ((cons pair?-c pair?-d) (-> (app #t) <-)) _)
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

'(store: _ (match null?-v (nil) (_ (-> (app #f) <-))) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: append (λ (x y) (-> (match (app null? x) ...) <-)) (env ()))
clos/con:
	'((letrec* (... null? (append (-> (λ (x y) ...) <-)) flatten ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: append (λ (x) (-> (match (app pair? x) ...) <-)) (env ()))
clos/con:
	'((letrec* (... null? (append (-> (λ (x y) ...) <-)) flatten ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: car (λ (x y) (-> (match (app null? x) ...) <-)) (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: car (λ (x) (-> (match (app pair? x) ...) <-)) (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: car-c (match car-v ((cons car-c car-d) (-> car-c <-))) (env ()))
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

'(store: car-d (match car-v ((cons car-c car-d) (-> car-c <-))) (env ()))
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

'(store: car-v (λ (car-v) (-> (match car-v ...) <-)) (env ()))
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

'(store: cdr (λ (x y) (-> (match (app null? x) ...) <-)) (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: cdr (λ (x) (-> (match (app pair? x) ...) <-)) (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: cdr-c (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-))) (env ()))
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

'(store: cdr-d (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-))) (env ()))
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

'(store: cdr-v (λ (cdr-v) (-> (match cdr-v ...) <-)) (env ()))
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

'(store: flatten (λ (x) (-> (match (app pair? x) ...) <-)) (env ()))
clos/con:
	'((letrec* (... append (flatten (-> (λ (x) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: null? (λ (x y) (-> (match (app null? x) ...) <-)) (env ()))
clos/con:
	'((letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) append ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: null? (λ (x) (-> (match (app pair? x) ...) <-)) (env ()))
clos/con:
	'((letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) append ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: null?-v (λ (null?-v) (-> (match null?-v ...) <-)) (env ()))
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

'(store: pair? (λ (x) (-> (match (app pair? x) ...) <-)) (env ()))
clos/con:
	'((letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: pair?-v (λ (pair?-v) (-> (match pair?-v ...) <-)) (env ()))
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

'(store: x (λ (x y) (-> (match (app null? x) ...) <-)) (env ()))
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

'(store: x (λ (x) (-> (match (app pair? x) ...) <-)) (env ()))
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

'(store: y (λ (x y) (-> (match (app null? x) ...) <-)) (env ()))
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
