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
literals: '(⊥ ⊥ ⊥)

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
literals: '(⊥ ⊥ ⊥)

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
literals: '(⊥ ⊥ ⊥)

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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
   (-> (app nil) <-))
  (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

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
literals: '(⊥ ⊥ ⊥)

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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app append (-> (app cdr x) <-) y)
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
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
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ((app cons (app car x) (-> (app append (app cdr x) y) <-)))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app append (-> (app cdr x) <-) y)
  (env ((app cons (app car x) (-> (app append (app cdr x) y) <-)))))
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
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ((app cons (app car x) (-> (app append (app cdr x) y) <-)))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x)))
  (env
   ((app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x))))))
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
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x))))))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x)))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
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
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x))))))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x)))
  (env
   ((letrec*
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
      <-)))))
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
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x))))))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app append (app cdr x) (-> y <-))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
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
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app append (app cdr x) (-> y <-))
  (env ((app cons (app car x) (-> (app append (app cdr x) y) <-)))))
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
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-))
  (env
   ((app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x))))))
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
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
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
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-))
  (env
   ((letrec*
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
      <-)))))
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
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app car (-> x <-))
  (env
   ((app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x))))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (app car (-> x <-))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
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
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app car (-> x <-))
  (env
   ((letrec*
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
      <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app car (-> x <-))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
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
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x))))))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app car (-> x <-))
  (env ((app cons (app car x) (-> (app append (app cdr x) y) <-)))))
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
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ((app cons (app car x) (-> (app append (app cdr x) y) <-)))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cdr (-> x <-))
  (env
   ((app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x))))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (app cdr (-> x <-))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
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
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cdr (-> x <-))
  (env
   ((letrec*
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
      <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cdr (-> x <-))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
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
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x))))))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app cdr (-> x <-))
  (env ((app cons (app car x) (-> (app append (app cdr x) y) <-)))))
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
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ((app cons (app car x) (-> (app append (app cdr x) y) <-)))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> (app car x) <-) (app append (app cdr x) y))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
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
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app cons (-> (app car x) <-) (app append (app cdr x) y))
  (env ((app cons (app car x) (-> (app append (app cdr x) y) <-)))))
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
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥)

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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> x <-) (app nil))
  (env
   ((app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x))))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (app cons (-> x <-) (app nil))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
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
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> x <-) (app nil))
  (env
   ((letrec*
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
      <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (app car x) (-> (app append (app cdr x) y) <-))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
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
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ((app cons (app car x) (-> (app append (app cdr x) y) <-)))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (app car x) (-> (app append (app cdr x) y) <-))
  (env ((app cons (app car x) (-> (app append (app cdr x) y) <-)))))
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
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ((app cons (app car x) (-> (app append (app cdr x) y) <-)))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (-> (app nil) <-))
  (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons x (-> (app nil) <-))
  (env
   ((app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x))))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons x (-> (app nil) <-))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons x (-> (app nil) <-))
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app flatten (-> (app car x) <-))
  (env
   ((app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x))))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (app flatten (-> (app car x) <-))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (app flatten (-> (app car x) <-))
  (env
   ((letrec*
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
      <-)))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (app flatten (-> (app cdr x) <-))
  (env
   ((app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x))))))
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
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app flatten (-> (app cdr x) <-))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
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
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app flatten (-> (app cdr x) <-))
  (env
   ((letrec*
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
      <-)))))
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
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app null? (-> x <-))
  (env
   ((app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x))))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (app null? (-> x <-))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
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
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app null? (-> x <-))
  (env
   ((letrec*
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
      <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app null? (-> x <-))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
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
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x))))))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app null? (-> x <-))
  (env ((app cons (app car x) (-> (app append (app cdr x) y) <-)))))
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
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ((app cons (app car x) (-> (app append (app cdr x) y) <-)))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app pair? (-> x <-))
  (env
   ((app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x))))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (app pair? (-> x <-))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
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
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app pair? (-> x <-))
  (env
   ((letrec*
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
      <-)))))
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
literals: '(⊥ ⊥ ⊥)

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
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((letrec*
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
      <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app null? x)
   ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
   _)
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
clos/con:
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app null? x)
   ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
   _)
  (env ((app cons (app car x) (-> (app append (app cdr x) y) <-)))))
clos/con:
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ((app cons (app car x) (-> (app append (app cdr x) y) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app pair? x)
   (#f)
   (_
    (-> (app append (app flatten (app car x)) (app flatten (app cdr x))) <-)))
  (env
   ((app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x))))))
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
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app pair? x)
   (#f)
   (_
    (-> (app append (app flatten (app car x)) (app flatten (app cdr x))) <-)))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
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
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app pair? x)
   (#f)
   (_
    (-> (app append (app flatten (app car x)) (app flatten (app cdr x))) <-)))
  (env
   ((letrec*
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
      <-)))))
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
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app null? x) <-) (#f) _)
  (env
   ((app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app null? x) <-) (#f) _)
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app null? x) <-) (#f) _)
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app null? x) <-) (#f) _)
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app null? x) <-) (#f) _)
  (env ((app cons (app car x) (-> (app append (app cdr x) y) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app pair? x) <-) (#f) _)
  (env
   ((app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app pair? x) <-) (#f) _)
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app pair? x) <-) (#f) _)
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> car-v <-) (cons car-c car-d))
  (env ((app cons (-> (app car x) <-) (app append (app cdr x) y)))))
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
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ((app cons (app car x) (-> (app append (app cdr x) y) <-)))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x))))))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (-> car-v <-) (cons car-c car-d))
  (env ((app flatten (-> (app car x) <-)))))
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
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (-> cdr-v <-) (cons cdr-c cdr-d))
  (env ((app append (-> (app cdr x) <-) y))))
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
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ((app cons (app car x) (-> (app append (app cdr x) y) <-)))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x))))))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (-> cdr-v <-) (cons cdr-c cdr-d))
  (env ((app flatten (-> (app cdr x) <-)))))
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
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (-> null?-v <-) (nil) _)
  (env ((match (-> (app null? x) <-) (#f) _))))
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
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (-> null?-v <-) (nil) _)
  (env ((match (-> (app null? x) <-) (#f) _))))
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
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ((app cons (app car x) (-> (app append (app cdr x) y) <-)))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x))))))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (-> pair?-v <-) (cons pair?-c pair?-d) _)
  (env ((match (-> (app pair? x) <-) (#f) _))))
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
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app null? x) (#f) (_ (-> x <-)))
  (env
   ((app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x))))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app null? x) (#f) (_ (-> x <-)))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
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
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app null? x) (#f) (_ (-> x <-)))
  (env
   ((letrec*
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
      <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app null? x) (#f) (_ (-> y <-)))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
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
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app null? x) (#f) (_ (-> y <-)))
  (env ((app cons (app car x) (-> (app append (app cdr x) y) <-)))))
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
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _)
  (env
   ((app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x))))))
clos/con:
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _)
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
clos/con:
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _)
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app pair? x) ((#f) (-> (match (app null? x) ...) <-)) _)
  (env
   ((app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x))))))
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
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app pair? x) ((#f) (-> (match (app null? x) ...) <-)) _)
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
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
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app pair? x) ((#f) (-> (match (app null? x) ...) <-)) _)
  (env
   ((letrec*
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
      <-)))))
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
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match car-v ((cons car-c car-d) (-> car-c <-)))
  (env ((app cons (-> (app car x) <-) (app append (app cdr x) y)))))
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
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match car-v ((cons car-c car-d) (-> car-c <-)))
  (env ((app flatten (-> (app car x) <-)))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-)))
  (env ((app append (-> (app cdr x) <-) y))))
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
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ((app cons (app car x) (-> (app append (app cdr x) y) <-)))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-)))
  (env ((app flatten (-> (app cdr x) <-)))))
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
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match null?-v ((nil) (-> (app #t) <-)) _)
  (env ((match (-> (app null? x) <-) (#f) _))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match null?-v ((nil) (-> (app #t) <-)) _)
  (env ((match (-> (app null? x) <-) (#f) _))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match null?-v (nil) (_ (-> (app #f) <-)))
  (env ((match (-> (app null? x) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match null?-v (nil) (_ (-> (app #f) <-)))
  (env ((match (-> (app null? x) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match pair?-v ((cons pair?-c pair?-d) (-> (app #t) <-)) _)
  (env ((match (-> (app pair? x) <-) (#f) _))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match pair?-v (cons pair?-c pair?-d) (_ (-> (app #f) <-)))
  (env ((match (-> (app pair? x) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (car-v) (-> (match car-v ...) <-))
  (env ((app cons (-> (app car x) <-) (app append (app cdr x) y)))))
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
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (car-v) (-> (match car-v ...) <-))
  (env ((app flatten (-> (app car x) <-)))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (cdr-v) (-> (match cdr-v ...) <-))
  (env ((app append (-> (app cdr x) <-) y))))
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
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ((app cons (app car x) (-> (app append (app cdr x) y) <-)))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (cdr-v) (-> (match cdr-v ...) <-))
  (env ((app flatten (-> (app cdr x) <-)))))
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
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (null?-v) (-> (match null?-v ...) <-))
  (env ((match (-> (app null? x) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (null?-v) (-> (match null?-v ...) <-))
  (env ((match (-> (app null? x) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (pair?-v) (-> (match pair?-v ...) <-))
  (env ((match (-> (app pair? x) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x y) (-> (match (app null? x) ...) <-))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
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
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x y) (-> (match (app null? x) ...) <-))
  (env ((app cons (app car x) (-> (app append (app cdr x) y) <-)))))
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
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ((app cons (app car x) (-> (app append (app cdr x) y) <-)))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x) (-> (match (app pair? x) ...) <-))
  (env
   ((app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x))))))
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
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x))))))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (x) (-> (match (app pair? x) ...) <-))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
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
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x) (-> (match (app pair? x) ...) <-))
  (env
   ((letrec*
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
      <-)))))
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
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((letrec*
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
      <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: ((top) lettypes (cons ... nil) ...) (env ()))
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
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((letrec*
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
      <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 1 (-> (app cons 2 (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 2 (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-)) (env ()))
clos/con:
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 4 (-> (app cons 5 (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 5 (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (lettypes cons ... nil (letrec* (car ... flatten) ...)) (env ()))
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
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((letrec*
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
      <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  _
  (match null?-v (nil) (_ (-> (app #f) <-)))
  (env ((match (-> (app null? x) <-) (#f) _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  _
  (match null?-v (nil) (_ (-> (app #f) <-)))
  (env ((match (-> (app null? x) <-) (#f) _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  _
  (match pair?-v (cons pair?-c pair?-d) (_ (-> (app #f) <-)))
  (env ((match (-> (app pair? x) <-) (#f) _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  append
  (letrec* (... null? (append (-> (λ (x y) ...) <-)) flatten ...) ...)
  (env
   ((app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x))))))
clos/con:
	'((letrec* (... null? (append (-> (λ (x y) ...) <-)) flatten ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  append
  (letrec* (... null? (append (-> (λ (x y) ...) <-)) flatten ...) ...)
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
clos/con:
	'((letrec* (... null? (append (-> (λ (x y) ...) <-)) flatten ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  append
  (letrec* (... null? (append (-> (λ (x y) ...) <-)) flatten ...) ...)
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((letrec* (... null? (append (-> (λ (x y) ...) <-)) flatten ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  append
  (letrec* (... null? (append (-> (λ (x y) ...) <-)) flatten ...) ...)
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
clos/con:
	'((letrec* (... null? (append (-> (λ (x y) ...) <-)) flatten ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  append
  (letrec* (... null? (append (-> (λ (x y) ...) <-)) flatten ...) ...)
  (env ((app cons (app car x) (-> (app append (app cdr x) y) <-)))))
clos/con:
	'((letrec* (... null? (append (-> (λ (x y) ...) <-)) flatten ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  append
  (letrec* (... null? (append (-> (λ (x y) ...) <-)) flatten ...) ...)
  (env ()))
clos/con:
	'((letrec* (... null? (append (-> (λ (x y) ...) <-)) flatten ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car
  (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...)
  (env
   ((app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x))))))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car
  (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...)
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car
  (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...)
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car
  (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...)
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car
  (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...)
  (env ((app cons (app car x) (-> (app append (app cdr x) y) <-)))))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car
  (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car-c
  (match car-v ((cons car-c car-d) (-> car-c <-)))
  (env ((app cons (-> (app car x) <-) (app append (app cdr x) y)))))
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
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥)

'(store:
  car-c
  (match car-v ((cons car-c car-d) (-> car-c <-)))
  (env ((app flatten (-> (app car x) <-)))))
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
literals: '(⊤ ⊥ ⊥)

'(store:
  car-d
  (match car-v ((cons car-c car-d) (-> car-c <-)))
  (env ((app cons (-> (app car x) <-) (app append (app cdr x) y)))))
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
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ((app cons (app car x) (-> (app append (app cdr x) y) <-)))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car-d
  (match car-v ((cons car-c car-d) (-> car-c <-)))
  (env ((app flatten (-> (app car x) <-)))))
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
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car-v
  (λ (car-v) (-> (match car-v ...) <-))
  (env ((app cons (-> (app car x) <-) (app append (app cdr x) y)))))
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
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ((app cons (app car x) (-> (app append (app cdr x) y) <-)))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x))))))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥)

'(store:
  car-v
  (λ (car-v) (-> (match car-v ...) <-))
  (env ((app flatten (-> (app car x) <-)))))
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
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥)

'(store:
  cdr
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...)
  (env
   ((app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x))))))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...)
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...)
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...)
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...)
  (env ((app cons (app car x) (-> (app append (app cdr x) y) <-)))))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr-c
  (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-)))
  (env ((app append (-> (app cdr x) <-) y))))
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
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥)

'(store:
  cdr-c
  (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-)))
  (env ((app flatten (-> (app cdr x) <-)))))
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
literals: '(⊤ ⊥ ⊥)

'(store:
  cdr-d
  (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-)))
  (env ((app append (-> (app cdr x) <-) y))))
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
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ((app cons (app car x) (-> (app append (app cdr x) y) <-)))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr-d
  (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-)))
  (env ((app flatten (-> (app cdr x) <-)))))
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
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr-v
  (λ (cdr-v) (-> (match cdr-v ...) <-))
  (env ((app append (-> (app cdr x) <-) y))))
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
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ((app cons (app car x) (-> (app append (app cdr x) y) <-)))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x))))))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥)

'(store:
  cdr-v
  (λ (cdr-v) (-> (match cdr-v ...) <-))
  (env ((app flatten (-> (app cdr x) <-)))))
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
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥)

'(store:
  con
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
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
   (-> (app nil) <-))
  (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> (app car x) <-) (app append (app cdr x) y))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
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
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥)

'(store:
  con
  (app cons (-> (app car x) <-) (app append (app cdr x) y))
  (env ((app cons (app car x) (-> (app append (app cdr x) y) <-)))))
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
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥)

'(store:
  con
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
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> x <-) (app nil))
  (env
   ((app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x))))))
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
literals: '(⊤ ⊥ ⊥)

'(store:
  con
  (app cons (-> x <-) (app nil))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
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
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> x <-) (app nil))
  (env
   ((letrec*
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
      <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (app car x) (-> (app append (app cdr x) y) <-))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
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
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ((app cons (app car x) (-> (app append (app cdr x) y) <-)))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (app car x) (-> (app append (app cdr x) y) <-))
  (env ((app cons (app car x) (-> (app append (app cdr x) y) <-)))))
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
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ((app cons (app car x) (-> (app append (app cdr x) y) <-)))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (-> (app nil) <-))
  (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons x (-> (app nil) <-))
  (env
   ((app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x))))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons x (-> (app nil) <-))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons x (-> (app nil) <-))
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  flatten
  (letrec* (... append (flatten (-> (λ (x) ...) <-)) () ...) ...)
  (env
   ((app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x))))))
clos/con:
	'((letrec* (... append (flatten (-> (λ (x) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  flatten
  (letrec* (... append (flatten (-> (λ (x) ...) <-)) () ...) ...)
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
clos/con:
	'((letrec* (... append (flatten (-> (λ (x) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  flatten
  (letrec* (... append (flatten (-> (λ (x) ...) <-)) () ...) ...)
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((letrec* (... append (flatten (-> (λ (x) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  flatten
  (letrec* (... append (flatten (-> (λ (x) ...) <-)) () ...) ...)
  (env ()))
clos/con:
	'((letrec* (... append (flatten (-> (λ (x) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  null?
  (letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) append ...) ...)
  (env
   ((app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x))))))
clos/con:
	'((letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) append ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  null?
  (letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) append ...) ...)
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
clos/con:
	'((letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) append ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  null?
  (letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) append ...) ...)
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) append ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  null?
  (letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) append ...) ...)
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
clos/con:
	'((letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) append ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  null?
  (letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) append ...) ...)
  (env ((app cons (app car x) (-> (app append (app cdr x) y) <-)))))
clos/con:
	'((letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) append ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  null?
  (letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) append ...) ...)
  (env ()))
clos/con:
	'((letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) append ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  null?-v
  (λ (null?-v) (-> (match null?-v ...) <-))
  (env ((match (-> (app null? x) <-) (#f) _))))
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
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥)

'(store:
  null?-v
  (λ (null?-v) (-> (match null?-v ...) <-))
  (env ((match (-> (app null? x) <-) (#f) _))))
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
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ((app cons (app car x) (-> (app append (app cdr x) y) <-)))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x))))))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥)

'(store:
  pair?
  (letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...)
  (env
   ((app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x))))))
clos/con:
	'((letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pair?
  (letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...)
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
clos/con:
	'((letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pair?
  (letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...)
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pair?
  (letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pair?-c
  (match pair?-v ((cons pair?-c pair?-d) (-> (app #t) <-)) _)
  (env ((match (-> (app pair? x) <-) (#f) _))))
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
literals: '(⊤ ⊥ ⊥)

'(store:
  pair?-d
  (match pair?-v ((cons pair?-c pair?-d) (-> (app #t) <-)) _)
  (env ((match (-> (app pair? x) <-) (#f) _))))
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
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pair?-v
  (λ (pair?-v) (-> (match pair?-v ...) <-))
  (env ((match (-> (app pair? x) <-) (#f) _))))
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
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥)

'(store:
  x
  (λ (x y) (-> (match (app null? x) ...) <-))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
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
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x))))))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥)

'(store:
  x
  (λ (x y) (-> (match (app null? x) ...) <-))
  (env ((app cons (app car x) (-> (app append (app cdr x) y) <-)))))
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
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env ((app cons (app car x) (-> (app append (app cdr x) y) <-)))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x
  (λ (x) (-> (match (app pair? x) ...) <-))
  (env
   ((app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x))))))
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
literals: '(⊤ ⊥ ⊥)

'(store:
  x
  (λ (x) (-> (match (app pair? x) ...) <-))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
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
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x
  (λ (x) (-> (match (app pair? x) ...) <-))
  (env
   ((letrec*
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
      <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  y
  (λ (x y) (-> (match (app null? x) ...) <-))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
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
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  y
  (λ (x y) (-> (match (app null? x) ...) <-))
  (env ((app cons (app car x) (-> (app append (app cdr x) y) <-)))))
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
	'((con
   cons
   (match
    (app null? x)
    ((#f) (-> (app cons (app car x) (app append (app cdr x) y)) <-))
    _))
  (env
   ((match
     (app pair? x)
     (#f)
     (_
      (->
       (app append (app flatten (app car x)) (app flatten (app cdr x)))
       <-))))))
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
	'((con cons (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _))
  (env
   ((app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: con (app cons (-> 1 <-) (app cons 2 (app nil))) (env ()))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(store: con (app cons (-> 2 <-) (app nil)) (env ()))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(store: con (app cons (-> 3 <-) (app cons 4 (app cons 5 (app nil)))) (env ()))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(store: con (app cons (-> 4 <-) (app cons 5 (app nil))) (env ()))
clos/con: ⊥
literals: '(4 ⊥ ⊥)

'(store: con (app cons (-> 5 <-) (app nil)) (env ()))
clos/con: ⊥
literals: '(5 ⊥ ⊥)

'(store: con (app cons 1 (-> (app cons 2 (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons 1 (-> (app cons 2 (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: con (app cons 2 (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: con (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-)) (env ()))
clos/con:
	'((con cons (app cons 3 (-> (app cons 4 (app cons 5 (app nil))) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: con (app cons 4 (-> (app cons 5 (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons 4 (-> (app cons 5 (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: con (app cons 5 (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)
