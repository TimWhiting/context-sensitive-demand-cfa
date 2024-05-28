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

'(query: ((top) lettypes (cons ... nil) ...) (env ()))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   cons
   (app cons 1 (app cons 2 (app nil ...)))
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-))
  (env ()))
	'((app
   flatten
   (->
    (app
     cons
     (app cons 1 (app cons ...))
     (app cons (app cons ...) (app nil ...)))
    <-))
  (env ()))
	'((app cons 1 (-> (app cons 2 (app nil)) <-)) (env ()))
	'((app cons 3 (-> (app cons 4 (app cons 5 (app nil ...))) <-)) (env ()))
	'((app cons 4 (-> (app cons 5 (app nil)) <-)) (env ()))
	'((match
   (app null? x)
   ((#f) (-> (app cons (app car x) (app append (app cdr ...) y)) <-))
   _)
  (env
   (((match
      (app pair? x)
      (#f)
      (_
       (->
        (app append (app flatten (app car ...)) (app flatten (app cdr ...)))
        <-)))))))
	'((match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _)
  (env
   (((app
      append
      (app flatten (app car x))
      (-> (app flatten (app cdr x)) <-))))))
	'((match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _)
  (env
   (((letrec*
      (car ... flatten)
      (-> (app flatten (app cons (app cons ...) (app cons ...))) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query: (lettypes cons ... nil (letrec* (car ... flatten) ...)) (env ()))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   cons
   (app cons 1 (app cons 2 (app nil ...)))
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-))
  (env ()))
	'((app
   flatten
   (->
    (app
     cons
     (app cons 1 (app cons ...))
     (app cons (app cons ...) (app nil ...)))
    <-))
  (env ()))
	'((app cons 1 (-> (app cons 2 (app nil)) <-)) (env ()))
	'((app cons 3 (-> (app cons 4 (app cons 5 (app nil ...))) <-)) (env ()))
	'((app cons 4 (-> (app cons 5 (app nil)) <-)) (env ()))
	'((match
   (app null? x)
   ((#f) (-> (app cons (app car x) (app append (app cdr ...) y)) <-))
   _)
  (env
   (((match
      (app pair? x)
      (#f)
      (_
       (->
        (app append (app flatten (app car ...)) (app flatten (app cdr ...)))
        <-)))))))
	'((match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _)
  (env
   (((app
      append
      (app flatten (app car x))
      (-> (app flatten (app cdr x)) <-))))))
	'((match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _)
  (env
   (((letrec*
      (car ... flatten)
      (-> (app flatten (app cons (app cons ...) (app cons ...))) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... append (flatten (-> (λ (x) ...) <-)) () ...) ...)
  (env ()))
clos/con:
	'((letrec* (... append (flatten (-> (λ (x) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (x) (-> (match (app pair? x) ...) <-)) (env ((□? (x)))))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   cons
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 1 (app cons 2 (app nil ...))) <-)
   (app cons (app cons (app cons ...) (app nil ...)) (app nil)))
  (env ()))
	'((app
   cons
   (app cons 1 (app cons 2 (app nil ...)))
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-))
  (env ()))
	'((app
   flatten
   (->
    (app
     cons
     (app cons 1 (app cons ...))
     (app cons (app cons ...) (app nil ...)))
    <-))
  (env ()))
	'((app cons (-> (app cons (app cons 3 (app cons ...)) (app nil)) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 3 (app cons 4 (app cons ...))) <-) (app nil))
  (env ()))
	'((app cons 1 (-> (app cons 2 (app nil)) <-)) (env ()))
	'((app cons 3 (-> (app cons 4 (app cons 5 (app nil ...))) <-)) (env ()))
	'((app cons 4 (-> (app cons 5 (app nil)) <-)) (env ()))
	'((match
   (app null? x)
   ((#f) (-> (app cons (app car x) (app append (app cdr ...) y)) <-))
   _)
  (env
   (((match
      (app pair? x)
      (#f)
      (_
       (->
        (app append (app flatten (app car ...)) (app flatten (app cdr ...)))
        <-)))))))
	'((match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _)
  (env
   (((app
      append
      (-> (app flatten (app car x)) <-)
      (app flatten (app cdr x)))))))
	'((match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _)
  (env
   (((app
      append
      (app flatten (app car x))
      (-> (app flatten (app cdr x)) <-))))))
	'((match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _)
  (env
   (((letrec*
      (car ... flatten)
      (-> (app flatten (app cons (app cons ...) (app cons ...))) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app pair? x)
   (#f)
   (_
    (->
     (app append (app flatten (app car ...)) (app flatten (app cdr ...)))
     <-)))
  (env ((□? (x)))))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   cons
   (app cons 1 (app cons 2 (app nil ...)))
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-))
  (env ()))
	'((app cons 1 (-> (app cons 2 (app nil)) <-)) (env ()))
	'((app cons 3 (-> (app cons 4 (app cons 5 (app nil ...))) <-)) (env ()))
	'((app cons 4 (-> (app cons 5 (app nil)) <-)) (env ()))
	'((match
   (app null? x)
   ((#f) (-> (app cons (app car x) (app append (app cdr ...) y)) <-))
   _)
  (env
   (((match
      (app pair? x)
      (#f)
      (_
       (->
        (app append (app flatten (app car ...)) (app flatten (app cdr ...)))
        <-)))))))
	'((match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _)
  (env
   (((app
      append
      (app flatten (app car x))
      (-> (app flatten (app cdr x)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app append (app flatten (app car x)) (-> (app flatten (app cdr x)) <-))
  (env ((□? (x)))))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   cons
   (app cons 1 (app cons 2 (app nil ...)))
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-))
  (env ()))
	'((app cons 1 (-> (app cons 2 (app nil)) <-)) (env ()))
	'((app cons 3 (-> (app cons 4 (app cons 5 (app nil ...))) <-)) (env ()))
	'((app cons 4 (-> (app cons 5 (app nil)) <-)) (env ()))
	'((match
   (app null? x)
   ((#f) (-> (app cons (app car x) (app append (app cdr ...) y)) <-))
   _)
  (env
   (((match
      (app pair? x)
      (#f)
      (_
       (->
        (app append (app flatten (app car ...)) (app flatten (app cdr ...)))
        <-)))))))
	'((match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _)
  (env
   (((app
      append
      (app flatten (app car x))
      (-> (app flatten (app cdr x)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query: (app flatten (-> (app cdr x) <-)) (env ((□? (x)))))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   cons
   (app cons 1 (app cons 2 (app nil ...)))
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-))
  (env ()))
	'((app cons 1 (-> (app cons 2 (app nil)) <-)) (env ()))
	'((app cons 3 (-> (app cons 4 (app cons 5 (app nil ...))) <-)) (env ()))
	'((app cons 4 (-> (app cons 5 (app nil)) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cdr (-> x <-)) (env ((□? (x)))))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   cons
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 1 (app cons 2 (app nil ...))) <-)
   (app cons (app cons (app cons ...) (app nil ...)) (app nil)))
  (env ()))
	'((app
   cons
   (app cons 1 (app cons 2 (app nil ...)))
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-))
  (env ()))
	'((app
   flatten
   (->
    (app
     cons
     (app cons 1 (app cons ...))
     (app cons (app cons ...) (app nil ...)))
    <-))
  (env ()))
	'((app cons (-> (app cons (app cons 3 (app cons ...)) (app nil)) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 3 (app cons 4 (app cons ...))) <-) (app nil))
  (env ()))
	'((app cons 1 (-> (app cons 2 (app nil)) <-)) (env ()))
	'((app cons 3 (-> (app cons 4 (app cons 5 (app nil ...))) <-)) (env ()))
	'((app cons 4 (-> (app cons 5 (app nil)) <-)) (env ()))
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> cdr <-) x) (env ((□? (x)))))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> flatten <-) (app cdr x)) (env ((□? (x)))))
clos/con:
	'((letrec* (... append (flatten (-> (λ (x) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app append (-> (app flatten (app car x)) <-) (app flatten (app cdr x)))
  (env ((□? (x)))))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   cons
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 1 (app cons 2 (app nil ...))) <-)
   (app cons (app cons (app cons ...) (app nil ...)) (app nil)))
  (env ()))
	'((app
   cons
   (app cons 1 (app cons 2 (app nil ...)))
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-))
  (env ()))
	'((app cons (-> (app cons (app cons 3 (app cons ...)) (app nil)) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 3 (app cons 4 (app cons ...))) <-) (app nil))
  (env ()))
	'((app cons 1 (-> (app cons 2 (app nil)) <-)) (env ()))
	'((app cons 3 (-> (app cons 4 (app cons 5 (app nil ...))) <-)) (env ()))
	'((app cons 4 (-> (app cons 5 (app nil)) <-)) (env ()))
	'((match
   (app null? x)
   ((#f) (-> (app cons (app car x) (app append (app cdr ...) y)) <-))
   _)
  (env
   (((match
      (app pair? x)
      (#f)
      (_
       (->
        (app append (app flatten (app car ...)) (app flatten (app cdr ...)))
        <-)))))))
	'((match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _)
  (env
   (((app
      append
      (-> (app flatten (app car x)) <-)
      (app flatten (app cdr x)))))))
	'((match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _)
  (env
   (((app
      append
      (app flatten (app car x))
      (-> (app flatten (app cdr x)) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query: (app flatten (-> (app car x) <-)) (env ((□? (x)))))
clos/con:
	'((app
   cons
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 1 (app cons 2 (app nil ...))) <-)
   (app cons (app cons (app cons ...) (app nil ...)) (app nil)))
  (env ()))
	'((app cons (-> (app cons (app cons 3 (app cons ...)) (app nil)) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 3 (app cons 4 (app cons ...))) <-) (app nil))
  (env ()))
literals: '(⊤ ⊥ ⊥)

'(query: (app car (-> x <-)) (env ((□? (x)))))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   cons
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 1 (app cons 2 (app nil ...))) <-)
   (app cons (app cons (app cons ...) (app nil ...)) (app nil)))
  (env ()))
	'((app
   cons
   (app cons 1 (app cons 2 (app nil ...)))
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-))
  (env ()))
	'((app
   flatten
   (->
    (app
     cons
     (app cons 1 (app cons ...))
     (app cons (app cons ...) (app nil ...)))
    <-))
  (env ()))
	'((app cons (-> (app cons (app cons 3 (app cons ...)) (app nil)) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 3 (app cons 4 (app cons ...))) <-) (app nil))
  (env ()))
	'((app cons 1 (-> (app cons 2 (app nil)) <-)) (env ()))
	'((app cons 3 (-> (app cons 4 (app cons 5 (app nil ...))) <-)) (env ()))
	'((app cons 4 (-> (app cons 5 (app nil)) <-)) (env ()))
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> car <-) x) (env ((□? (x)))))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> flatten <-) (app car x)) (env ((□? (x)))))
clos/con:
	'((letrec* (... append (flatten (-> (λ (x) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> append <-) (app flatten (app car x)) (app flatten (app cdr x)))
  (env ((□? (x)))))
clos/con:
	'((letrec* (... null? (append (-> (λ (x y) ...) <-)) flatten ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app pair? x) ((#f) (-> (match (app null? x) ...) <-)) _)
  (env ((□? (x)))))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   cons
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 1 (app cons 2 (app nil ...))) <-)
   (app cons (app cons (app cons ...) (app nil ...)) (app nil)))
  (env ()))
	'((app
   cons
   (app cons 1 (app cons 2 (app nil ...)))
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-))
  (env ()))
	'((app
   flatten
   (->
    (app
     cons
     (app cons 1 (app cons ...))
     (app cons (app cons ...) (app nil ...)))
    <-))
  (env ()))
	'((app cons (-> (app cons (app cons 3 (app cons ...)) (app nil)) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 3 (app cons 4 (app cons ...))) <-) (app nil))
  (env ()))
	'((app cons 1 (-> (app cons 2 (app nil)) <-)) (env ()))
	'((app cons 3 (-> (app cons 4 (app cons 5 (app nil ...))) <-)) (env ()))
	'((app cons 4 (-> (app cons 5 (app nil)) <-)) (env ()))
	'((match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _)
  (env
   (((app
      append
      (-> (app flatten (app car x)) <-)
      (app flatten (app cdr x)))))))
	'((match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _)
  (env
   (((app
      append
      (app flatten (app car x))
      (-> (app flatten (app cdr x)) <-))))))
	'((match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _)
  (env
   (((letrec*
      (car ... flatten)
      (-> (app flatten (app cons (app cons ...) (app cons ...))) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query: (match (app null? x) (#f) (_ (-> x <-))) (env ((□? (x)))))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   cons
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 1 (app cons 2 (app nil ...))) <-)
   (app cons (app cons (app cons ...) (app nil ...)) (app nil)))
  (env ()))
	'((app
   cons
   (app cons 1 (app cons 2 (app nil ...)))
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-))
  (env ()))
	'((app
   flatten
   (->
    (app
     cons
     (app cons 1 (app cons ...))
     (app cons (app cons ...) (app nil ...)))
    <-))
  (env ()))
	'((app cons (-> (app cons (app cons 3 (app cons ...)) (app nil)) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 3 (app cons 4 (app cons ...))) <-) (app nil))
  (env ()))
	'((app cons 1 (-> (app cons 2 (app nil)) <-)) (env ()))
	'((app cons 3 (-> (app cons 4 (app cons 5 (app nil ...))) <-)) (env ()))
	'((app cons 4 (-> (app cons 5 (app nil)) <-)) (env ()))
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _)
  (env ((□? (x)))))
clos/con:
	'((match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _)
  (env ((□? (x)))))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons x (-> (app nil) <-)) (env ((□? (x)))))
clos/con:
	'(((top) app nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ((□? (x)))))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> x <-) (app nil)) (env ((□? (x)))))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   cons
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 1 (app cons 2 (app nil ...))) <-)
   (app cons (app cons (app cons ...) (app nil ...)) (app nil)))
  (env ()))
	'((app
   cons
   (app cons 1 (app cons 2 (app nil ...)))
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-))
  (env ()))
	'((app
   flatten
   (->
    (app
     cons
     (app cons 1 (app cons ...))
     (app cons (app cons ...) (app nil ...)))
    <-))
  (env ()))
	'((app cons (-> (app cons (app cons 3 (app cons ...)) (app nil)) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 3 (app cons 4 (app cons ...))) <-) (app nil))
  (env ()))
	'((app cons 1 (-> (app cons 2 (app nil)) <-)) (env ()))
	'((app cons 3 (-> (app cons 4 (app cons 5 (app nil ...))) <-)) (env ()))
	'((app cons 4 (-> (app cons 5 (app nil)) <-)) (env ()))
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> cons <-) x (app nil)) (env ((□? (x)))))
clos/con:
	'((app (-> cons <-) x (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app null? x) <-) (#f) _) (env ((□? (x)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app null? (-> x <-)) (env ((□? (x)))))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   cons
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 1 (app cons 2 (app nil ...))) <-)
   (app cons (app cons (app cons ...) (app nil ...)) (app nil)))
  (env ()))
	'((app
   cons
   (app cons 1 (app cons 2 (app nil ...)))
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-))
  (env ()))
	'((app
   flatten
   (->
    (app
     cons
     (app cons 1 (app cons ...))
     (app cons (app cons ...) (app nil ...)))
    <-))
  (env ()))
	'((app cons (-> (app cons (app cons 3 (app cons ...)) (app nil)) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 3 (app cons 4 (app cons ...))) <-) (app nil))
  (env ()))
	'((app cons 1 (-> (app cons 2 (app nil)) <-)) (env ()))
	'((app cons 3 (-> (app cons 4 (app cons 5 (app nil ...))) <-)) (env ()))
	'((app cons 4 (-> (app cons 5 (app nil)) <-)) (env ()))
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> null? <-) x) (env ((□? (x)))))
clos/con:
	'((letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) append ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app pair? x) <-) (#f) _) (env ((□? (x)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app pair? (-> x <-)) (env ((□? (x)))))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   cons
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 1 (app cons 2 (app nil ...))) <-)
   (app cons (app cons (app cons ...) (app nil ...)) (app nil)))
  (env ()))
	'((app
   cons
   (app cons 1 (app cons 2 (app nil ...)))
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-))
  (env ()))
	'((app
   flatten
   (->
    (app
     cons
     (app cons 1 (app cons ...))
     (app cons (app cons ...) (app nil ...)))
    <-))
  (env ()))
	'((app cons (-> (app cons (app cons 3 (app cons ...)) (app nil)) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 3 (app cons 4 (app cons ...))) <-) (app nil))
  (env ()))
	'((app cons 1 (-> (app cons 2 (app nil)) <-)) (env ()))
	'((app cons 3 (-> (app cons 4 (app cons 5 (app nil ...))) <-)) (env ()))
	'((app cons 4 (-> (app cons 5 (app nil)) <-)) (env ()))
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> pair? <-) x) (env ((□? (x)))))
clos/con:
	'((letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... null? (append (-> (λ (x y) ...) <-)) flatten ...) ...)
  (env ()))
clos/con:
	'((letrec* (... null? (append (-> (λ (x y) ...) <-)) flatten ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (x y) (-> (match (app null? x) ...) <-)) (env ((□? (x y)))))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   cons
   (app cons 1 (app cons 2 (app nil ...)))
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-))
  (env ()))
	'((app cons 1 (-> (app cons 2 (app nil)) <-)) (env ()))
	'((app cons 3 (-> (app cons 4 (app cons 5 (app nil ...))) <-)) (env ()))
	'((app cons 4 (-> (app cons 5 (app nil)) <-)) (env ()))
	'((match
   (app null? x)
   ((#f) (-> (app cons (app car x) (app append (app cdr ...) y)) <-))
   _)
  (env
   (((match
      (app pair? x)
      (#f)
      (_
       (->
        (app append (app flatten (app car ...)) (app flatten (app cdr ...)))
        <-)))))))
	'((match
   (app null? x)
   ((#f) (-> (app cons (app car x) (app append (app cdr ...) y)) <-))
   _)
  (env (((app cons (app car x) (-> (app append (app cdr x) y) <-))))))
	'((match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _)
  (env
   (((app
      append
      (app flatten (app car x))
      (-> (app flatten (app cdr x)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app null? x) (#f) (_ (-> y <-))) (env ((□? (x y)))))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   cons
   (app cons 1 (app cons 2 (app nil ...)))
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-))
  (env ()))
	'((app cons 1 (-> (app cons 2 (app nil)) <-)) (env ()))
	'((app cons 3 (-> (app cons 4 (app cons 5 (app nil ...))) <-)) (env ()))
	'((app cons 4 (-> (app cons 5 (app nil)) <-)) (env ()))
	'((match
   (app null? x)
   ((#f) (-> (app cons (app car x) (app append (app cdr ...) y)) <-))
   _)
  (env
   (((match
      (app pair? x)
      (#f)
      (_
       (->
        (app append (app flatten (app car ...)) (app flatten (app cdr ...)))
        <-)))))))
	'((match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _)
  (env
   (((app
      append
      (app flatten (app car x))
      (-> (app flatten (app cdr x)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app null? x)
   ((#f) (-> (app cons (app car x) (app append (app cdr ...) y)) <-))
   _)
  (env ((□? (x y)))))
clos/con:
	'((match
   (app null? x)
   ((#f) (-> (app cons (app car x) (app append (app cdr ...) y)) <-))
   _)
  (env ((□? (x y)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (app car x) (-> (app append (app cdr x) y) <-))
  (env ((□? (x y)))))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   cons
   (app cons 1 (app cons 2 (app nil ...)))
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-))
  (env ()))
	'((app cons 1 (-> (app cons 2 (app nil)) <-)) (env ()))
	'((app cons 3 (-> (app cons 4 (app cons 5 (app nil ...))) <-)) (env ()))
	'((app cons 4 (-> (app cons 5 (app nil)) <-)) (env ()))
	'((match
   (app null? x)
   ((#f) (-> (app cons (app car x) (app append (app cdr ...) y)) <-))
   _)
  (env
   (((match
      (app pair? x)
      (#f)
      (_
       (->
        (app append (app flatten (app car ...)) (app flatten (app cdr ...)))
        <-)))))))
	'((match
   (app null? x)
   ((#f) (-> (app cons (app car x) (app append (app cdr ...) y)) <-))
   _)
  (env (((app cons (app car x) (-> (app append (app cdr x) y) <-))))))
	'((match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _)
  (env
   (((app
      append
      (app flatten (app car x))
      (-> (app flatten (app cdr x)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query: (app append (app cdr x) (-> y <-)) (env ((□? (x y)))))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   cons
   (app cons 1 (app cons 2 (app nil ...)))
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-))
  (env ()))
	'((app cons 1 (-> (app cons 2 (app nil)) <-)) (env ()))
	'((app cons 3 (-> (app cons 4 (app cons 5 (app nil ...))) <-)) (env ()))
	'((app cons 4 (-> (app cons 5 (app nil)) <-)) (env ()))
	'((match
   (app null? x)
   ((#f) (-> (app cons (app car x) (app append (app cdr ...) y)) <-))
   _)
  (env
   (((match
      (app pair? x)
      (#f)
      (_
       (->
        (app append (app flatten (app car ...)) (app flatten (app cdr ...)))
        <-)))))))
	'((match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _)
  (env
   (((app
      append
      (app flatten (app car x))
      (-> (app flatten (app cdr x)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query: (app append (-> (app cdr x) <-) y) (env ((□? (x y)))))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   cons
   (app cons 1 (app cons 2 (app nil ...)))
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-))
  (env ()))
	'((app cons 1 (-> (app cons 2 (app nil)) <-)) (env ()))
	'((app cons 3 (-> (app cons 4 (app cons 5 (app nil ...))) <-)) (env ()))
	'((app cons 4 (-> (app cons 5 (app nil)) <-)) (env ()))
	'((match
   (app null? x)
   ((#f) (-> (app cons (app car x) (app append (app cdr ...) y)) <-))
   _)
  (env
   (((match
      (app pair? x)
      (#f)
      (_
       (->
        (app append (app flatten (app car ...)) (app flatten (app cdr ...)))
        <-)))))))
	'((match
   (app null? x)
   ((#f) (-> (app cons (app car x) (app append (app cdr ...) y)) <-))
   _)
  (env (((app cons (app car x) (-> (app append (app cdr x) y) <-))))))
	'((match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _)
  (env
   (((app
      append
      (app flatten (app car x))
      (-> (app flatten (app cdr x)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query: (app cdr (-> x <-)) (env ((□? (x y)))))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   cons
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 1 (app cons 2 (app nil ...))) <-)
   (app cons (app cons (app cons ...) (app nil ...)) (app nil)))
  (env ()))
	'((app
   cons
   (app cons 1 (app cons 2 (app nil ...)))
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-))
  (env ()))
	'((app cons (-> (app cons (app cons 3 (app cons ...)) (app nil)) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 3 (app cons 4 (app cons ...))) <-) (app nil))
  (env ()))
	'((app cons 1 (-> (app cons 2 (app nil)) <-)) (env ()))
	'((app cons 3 (-> (app cons 4 (app cons 5 (app nil ...))) <-)) (env ()))
	'((app cons 4 (-> (app cons 5 (app nil)) <-)) (env ()))
	'((match
   (app null? x)
   ((#f) (-> (app cons (app car x) (app append (app cdr ...) y)) <-))
   _)
  (env
   (((match
      (app pair? x)
      (#f)
      (_
       (->
        (app append (app flatten (app car ...)) (app flatten (app cdr ...)))
        <-)))))))
	'((match
   (app null? x)
   ((#f) (-> (app cons (app car x) (app append (app cdr ...) y)) <-))
   _)
  (env (((app cons (app car x) (-> (app append (app cdr x) y) <-))))))
	'((match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _)
  (env
   (((app
      append
      (-> (app flatten (app car x)) <-)
      (app flatten (app cdr x)))))))
	'((match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _)
  (env
   (((app
      append
      (app flatten (app car x))
      (-> (app flatten (app cdr x)) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> cdr <-) x) (env ((□? (x y)))))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> append <-) (app cdr x) y) (env ((□? (x y)))))
clos/con:
	'((letrec* (... null? (append (-> (λ (x y) ...) <-)) flatten ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> (app car x) <-) (app append (app cdr x) y))
  (env ((□? (x y)))))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   cons
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 1 (app cons 2 (app nil ...))) <-)
   (app cons (app cons (app cons ...) (app nil ...)) (app nil)))
  (env ()))
	'((app
   cons
   (app cons 1 (app cons 2 (app nil ...)))
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-))
  (env ()))
	'((app cons (-> (app cons (app cons 3 (app cons ...)) (app nil)) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 3 (app cons 4 (app cons ...))) <-) (app nil))
  (env ()))
	'((app cons 1 (-> (app cons 2 (app nil)) <-)) (env ()))
	'((app cons 3 (-> (app cons 4 (app cons 5 (app nil ...))) <-)) (env ()))
	'((app cons 4 (-> (app cons 5 (app nil)) <-)) (env ()))
literals: '(⊤ ⊥ ⊥)

'(query: (app car (-> x <-)) (env ((□? (x y)))))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   cons
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 1 (app cons 2 (app nil ...))) <-)
   (app cons (app cons (app cons ...) (app nil ...)) (app nil)))
  (env ()))
	'((app
   cons
   (app cons 1 (app cons 2 (app nil ...)))
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-))
  (env ()))
	'((app cons (-> (app cons (app cons 3 (app cons ...)) (app nil)) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 3 (app cons 4 (app cons ...))) <-) (app nil))
  (env ()))
	'((app cons 1 (-> (app cons 2 (app nil)) <-)) (env ()))
	'((app cons 3 (-> (app cons 4 (app cons 5 (app nil ...))) <-)) (env ()))
	'((app cons 4 (-> (app cons 5 (app nil)) <-)) (env ()))
	'((match
   (app null? x)
   ((#f) (-> (app cons (app car x) (app append (app cdr ...) y)) <-))
   _)
  (env
   (((match
      (app pair? x)
      (#f)
      (_
       (->
        (app append (app flatten (app car ...)) (app flatten (app cdr ...)))
        <-)))))))
	'((match
   (app null? x)
   ((#f) (-> (app cons (app car x) (app append (app cdr ...) y)) <-))
   _)
  (env (((app cons (app car x) (-> (app append (app cdr x) y) <-))))))
	'((match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _)
  (env
   (((app
      append
      (-> (app flatten (app car x)) <-)
      (app flatten (app cdr x)))))))
	'((match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _)
  (env
   (((app
      append
      (app flatten (app car x))
      (-> (app flatten (app cdr x)) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> car <-) x) (env ((□? (x y)))))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> cons <-) (app car x) (app append (app cdr x) y))
  (env ((□? (x y)))))
clos/con:
	'((app (-> cons <-) (app car x) (app append (app cdr x) y)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app null? x) <-) (#f) _) (env ((□? (x y)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app null? (-> x <-)) (env ((□? (x y)))))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   cons
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 1 (app cons 2 (app nil ...))) <-)
   (app cons (app cons (app cons ...) (app nil ...)) (app nil)))
  (env ()))
	'((app
   cons
   (app cons 1 (app cons 2 (app nil ...)))
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-))
  (env ()))
	'((app cons (-> (app cons (app cons 3 (app cons ...)) (app nil)) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 3 (app cons 4 (app cons ...))) <-) (app nil))
  (env ()))
	'((app cons 1 (-> (app cons 2 (app nil)) <-)) (env ()))
	'((app cons 3 (-> (app cons 4 (app cons 5 (app nil ...))) <-)) (env ()))
	'((app cons 4 (-> (app cons 5 (app nil)) <-)) (env ()))
	'((match
   (app null? x)
   ((#f) (-> (app cons (app car x) (app append (app cdr ...) y)) <-))
   _)
  (env
   (((match
      (app pair? x)
      (#f)
      (_
       (->
        (app append (app flatten (app car ...)) (app flatten (app cdr ...)))
        <-)))))))
	'((match
   (app null? x)
   ((#f) (-> (app cons (app car x) (app append (app cdr ...) y)) <-))
   _)
  (env (((app cons (app car x) (-> (app append (app cdr x) y) <-))))))
	'((match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _)
  (env
   (((app
      append
      (-> (app flatten (app car x)) <-)
      (app flatten (app cdr x)))))))
	'((match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _)
  (env
   (((app
      append
      (app flatten (app car x))
      (-> (app flatten (app cdr x)) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query: (app (-> null? <-) x) (env ((□? (x y)))))
clos/con:
	'((letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) append ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) append ...) ...)
  (env ()))
clos/con:
	'((letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) append ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (null?-v) (-> (match null?-v ...) <-)) (env ((□? (null?-v)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match null?-v (nil) (_ (-> (app #f) <-))) (env ((□? (null?-v)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((□? (null?-v)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match null?-v ((nil) (-> (app #t) <-)) _) (env ((□? (null?-v)))))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ((□? (null?-v)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> null?-v <-) (nil) _) (env ((□? (null?-v)))))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   cons
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 1 (app cons 2 (app nil ...))) <-)
   (app cons (app cons (app cons ...) (app nil ...)) (app nil)))
  (env ()))
	'((app
   cons
   (app cons 1 (app cons 2 (app nil ...)))
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-))
  (env ()))
	'((app
   flatten
   (->
    (app
     cons
     (app cons 1 (app cons ...))
     (app cons (app cons ...) (app nil ...)))
    <-))
  (env ()))
	'((app cons (-> (app cons (app cons 3 (app cons ...)) (app nil)) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 3 (app cons 4 (app cons ...))) <-) (app nil))
  (env ()))
	'((app cons 1 (-> (app cons 2 (app nil)) <-)) (env ()))
	'((app cons 3 (-> (app cons 4 (app cons 5 (app nil ...))) <-)) (env ()))
	'((app cons 4 (-> (app cons 5 (app nil)) <-)) (env ()))
	'((match
   (app null? x)
   ((#f) (-> (app cons (app car x) (app append (app cdr ...) y)) <-))
   _)
  (env
   (((match
      (app pair? x)
      (#f)
      (_
       (->
        (app append (app flatten (app car ...)) (app flatten (app cdr ...)))
        <-)))))))
	'((match
   (app null? x)
   ((#f) (-> (app cons (app car x) (app append (app cdr ...) y)) <-))
   _)
  (env (((app cons (app car x) (-> (app append (app cdr x) y) <-))))))
	'((match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _)
  (env
   (((app
      append
      (-> (app flatten (app car x)) <-)
      (app flatten (app cdr x)))))))
	'((match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _)
  (env
   (((app
      append
      (app flatten (app car x))
      (-> (app flatten (app cdr x)) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (pair?-v) (-> (match pair?-v ...) <-)) (env ((□? (pair?-v)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match pair?-v (cons pair?-c pair?-d) (_ (-> (app #f) <-)))
  (env ((□? (pair?-v)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((□? (pair?-v)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match pair?-v ((cons pair?-c pair?-d) (-> (app #t) <-)) _)
  (env ((□? (pair?-v)))))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ((□? (pair?-v)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> pair?-v <-) (cons pair?-c pair?-d) _)
  (env ((□? (pair?-v)))))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   cons
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 1 (app cons 2 (app nil ...))) <-)
   (app cons (app cons (app cons ...) (app nil ...)) (app nil)))
  (env ()))
	'((app
   cons
   (app cons 1 (app cons 2 (app nil ...)))
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-))
  (env ()))
	'((app
   flatten
   (->
    (app
     cons
     (app cons 1 (app cons ...))
     (app cons (app cons ...) (app nil ...)))
    <-))
  (env ()))
	'((app cons (-> (app cons (app cons 3 (app cons ...)) (app nil)) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 3 (app cons 4 (app cons ...))) <-) (app nil))
  (env ()))
	'((app cons 1 (-> (app cons 2 (app nil)) <-)) (env ()))
	'((app cons 3 (-> (app cons 4 (app cons 5 (app nil ...))) <-)) (env ()))
	'((app cons 4 (-> (app cons 5 (app nil)) <-)) (env ()))
literals: '(⊤ ⊥ ⊥)

'(query:
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (cdr-v) (-> (match cdr-v ...) <-)) (env ((□? (cdr-v)))))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   cons
   (app cons 1 (app cons 2 (app nil ...)))
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-))
  (env ()))
	'((app cons 1 (-> (app cons 2 (app nil)) <-)) (env ()))
	'((app cons 3 (-> (app cons 4 (app cons 5 (app nil ...))) <-)) (env ()))
	'((app cons 4 (-> (app cons 5 (app nil)) <-)) (env ()))
	'((match
   (app null? x)
   ((#f) (-> (app cons (app car x) (app append (app cdr ...) y)) <-))
   _)
  (env
   (((match
      (app pair? x)
      (#f)
      (_
       (->
        (app append (app flatten (app car ...)) (app flatten (app cdr ...)))
        <-)))))))
	'((match
   (app null? x)
   ((#f) (-> (app cons (app car x) (app append (app cdr ...) y)) <-))
   _)
  (env (((app cons (app car x) (-> (app append (app cdr x) y) <-))))))
	'((match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _)
  (env
   (((app
      append
      (app flatten (app car x))
      (-> (app flatten (app cdr x)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query: (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-))) (env ((□? (cdr-v)))))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   cons
   (app cons 1 (app cons 2 (app nil ...)))
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-))
  (env ()))
	'((app cons 1 (-> (app cons 2 (app nil)) <-)) (env ()))
	'((app cons 3 (-> (app cons 4 (app cons 5 (app nil ...))) <-)) (env ()))
	'((app cons 4 (-> (app cons 5 (app nil)) <-)) (env ()))
	'((match
   (app null? x)
   ((#f) (-> (app cons (app car x) (app append (app cdr ...) y)) <-))
   _)
  (env
   (((match
      (app pair? x)
      (#f)
      (_
       (->
        (app append (app flatten (app car ...)) (app flatten (app cdr ...)))
        <-)))))))
	'((match
   (app null? x)
   ((#f) (-> (app cons (app car x) (app append (app cdr ...) y)) <-))
   _)
  (env (((app cons (app car x) (-> (app append (app cdr x) y) <-))))))
	'((match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _)
  (env
   (((app
      append
      (app flatten (app car x))
      (-> (app flatten (app cdr x)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> cdr-v <-) (cons cdr-c cdr-d)) (env ((□? (cdr-v)))))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   cons
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 1 (app cons 2 (app nil ...))) <-)
   (app cons (app cons (app cons ...) (app nil ...)) (app nil)))
  (env ()))
	'((app
   cons
   (app cons 1 (app cons 2 (app nil ...)))
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-))
  (env ()))
	'((app
   flatten
   (->
    (app
     cons
     (app cons 1 (app cons ...))
     (app cons (app cons ...) (app nil ...)))
    <-))
  (env ()))
	'((app cons (-> (app cons (app cons 3 (app cons ...)) (app nil)) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 3 (app cons 4 (app cons ...))) <-) (app nil))
  (env ()))
	'((app cons 1 (-> (app cons 2 (app nil)) <-)) (env ()))
	'((app cons 3 (-> (app cons 4 (app cons 5 (app nil ...))) <-)) (env ()))
	'((app cons 4 (-> (app cons 5 (app nil)) <-)) (env ()))
	'((match
   (app null? x)
   ((#f) (-> (app cons (app car x) (app append (app cdr ...) y)) <-))
   _)
  (env
   (((match
      (app pair? x)
      (#f)
      (_
       (->
        (app append (app flatten (app car ...)) (app flatten (app cdr ...)))
        <-)))))))
	'((match
   (app null? x)
   ((#f) (-> (app cons (app car x) (app append (app cdr ...) y)) <-))
   _)
  (env (((app cons (app car x) (-> (app append (app cdr x) y) <-))))))
	'((match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _)
  (env
   (((app
      append
      (-> (app flatten (app car x)) <-)
      (app flatten (app cdr x)))))))
	'((match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _)
  (env
   (((app
      append
      (app flatten (app car x))
      (-> (app flatten (app cdr x)) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query: (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (car-v) (-> (match car-v ...) <-)) (env ((□? (car-v)))))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   cons
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 1 (app cons 2 (app nil ...))) <-)
   (app cons (app cons (app cons ...) (app nil ...)) (app nil)))
  (env ()))
	'((app
   cons
   (app cons 1 (app cons 2 (app nil ...)))
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-))
  (env ()))
	'((app cons (-> (app cons (app cons 3 (app cons ...)) (app nil)) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 3 (app cons 4 (app cons ...))) <-) (app nil))
  (env ()))
	'((app cons 1 (-> (app cons 2 (app nil)) <-)) (env ()))
	'((app cons 3 (-> (app cons 4 (app cons 5 (app nil ...))) <-)) (env ()))
	'((app cons 4 (-> (app cons 5 (app nil)) <-)) (env ()))
literals: '(⊤ ⊥ ⊥)

'(query: (match car-v ((cons car-c car-d) (-> car-c <-))) (env ((□? (car-v)))))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   cons
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 1 (app cons 2 (app nil ...))) <-)
   (app cons (app cons (app cons ...) (app nil ...)) (app nil)))
  (env ()))
	'((app
   cons
   (app cons 1 (app cons 2 (app nil ...)))
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-))
  (env ()))
	'((app cons (-> (app cons (app cons 3 (app cons ...)) (app nil)) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 3 (app cons 4 (app cons ...))) <-) (app nil))
  (env ()))
	'((app cons 1 (-> (app cons 2 (app nil)) <-)) (env ()))
	'((app cons 3 (-> (app cons 4 (app cons 5 (app nil ...))) <-)) (env ()))
	'((app cons 4 (-> (app cons 5 (app nil)) <-)) (env ()))
literals: '(⊤ ⊥ ⊥)

'(query: (match (-> car-v <-) (cons car-c car-d)) (env ((□? (car-v)))))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   cons
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 1 (app cons 2 (app nil ...))) <-)
   (app cons (app cons (app cons ...) (app nil ...)) (app nil)))
  (env ()))
	'((app
   cons
   (app cons 1 (app cons 2 (app nil ...)))
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-))
  (env ()))
	'((app
   flatten
   (->
    (app
     cons
     (app cons 1 (app cons ...))
     (app cons (app cons ...) (app nil ...)))
    <-))
  (env ()))
	'((app cons (-> (app cons (app cons 3 (app cons ...)) (app nil)) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 3 (app cons 4 (app cons ...))) <-) (app nil))
  (env ()))
	'((app cons 1 (-> (app cons 2 (app nil)) <-)) (env ()))
	'((app cons 3 (-> (app cons 4 (app cons 5 (app nil ...))) <-)) (env ()))
	'((app cons 4 (-> (app cons 5 (app nil)) <-)) (env ()))
	'((match
   (app null? x)
   ((#f) (-> (app cons (app car x) (app append (app cdr ...) y)) <-))
   _)
  (env
   (((match
      (app pair? x)
      (#f)
      (_
       (->
        (app append (app flatten (app car ...)) (app flatten (app cdr ...)))
        <-)))))))
	'((match
   (app null? x)
   ((#f) (-> (app cons (app car x) (app append (app cdr ...) y)) <-))
   _)
  (env (((app cons (app car x) (-> (app append (app cdr x) y) <-))))))
	'((match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _)
  (env
   (((app
      append
      (-> (app flatten (app car x)) <-)
      (app flatten (app cdr x)))))))
	'((match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _)
  (env
   (((app
      append
      (app flatten (app car x))
      (-> (app flatten (app cdr x)) <-))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (letrec*
   (car ... flatten)
   (-> (app flatten (app cons (app cons ...) (app cons ...))) <-))
  (env ()))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   cons
   (app cons 1 (app cons 2 (app nil ...)))
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-))
  (env ()))
	'((app
   flatten
   (->
    (app
     cons
     (app cons 1 (app cons ...))
     (app cons (app cons ...) (app nil ...)))
    <-))
  (env ()))
	'((app cons 1 (-> (app cons 2 (app nil)) <-)) (env ()))
	'((app cons 3 (-> (app cons 4 (app cons 5 (app nil ...))) <-)) (env ()))
	'((app cons 4 (-> (app cons 5 (app nil)) <-)) (env ()))
	'((match
   (app null? x)
   ((#f) (-> (app cons (app car x) (app append (app cdr ...) y)) <-))
   _)
  (env
   (((match
      (app pair? x)
      (#f)
      (_
       (->
        (app append (app flatten (app car ...)) (app flatten (app cdr ...)))
        <-)))))))
	'((match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _)
  (env
   (((app
      append
      (app flatten (app car x))
      (-> (app flatten (app cdr x)) <-))))))
	'((match (app null? x) ((#f) (-> (app cons x (app nil)) <-)) _)
  (env
   (((letrec*
      (car ... flatten)
      (-> (app flatten (app cons (app cons ...) (app cons ...))) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   flatten
   (->
    (app
     cons
     (app cons 1 (app cons ...))
     (app cons (app cons ...) (app nil ...)))
    <-))
  (env ()))
clos/con:
	'((app
   flatten
   (->
    (app
     cons
     (app cons 1 (app cons ...))
     (app cons (app cons ...) (app nil ...)))
    <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (app cons 1 (app cons 2 (app nil ...)))
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-))
  (env ()))
clos/con:
	'((app
   cons
   (app cons 1 (app cons 2 (app nil ...)))
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (app cons (app cons (app cons ...) (app nil ...)) (app nil))
   (-> (app nil) <-))
  (env ()))
clos/con:
	'(((top) app nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-)
   (app nil))
  (env ()))
clos/con:
	'((app
   cons
   (-> (app cons (app cons (app cons ...) (app nil ...)) (app nil)) <-)
   (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (app cons (app cons 3 (app cons ...)) (app nil)) (-> (app nil) <-))
  (env ()))
clos/con:
	'(((top) app nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> (app cons (app cons 3 (app cons ...)) (app nil)) <-) (app nil))
  (env ()))
clos/con:
	'((app cons (-> (app cons (app cons 3 (app cons ...)) (app nil)) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (app cons 3 (app cons 4 (app cons ...))) (-> (app nil) <-))
  (env ()))
clos/con:
	'(((top) app nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> (app cons 3 (app cons 4 (app cons ...))) <-) (app nil))
  (env ()))
clos/con:
	'((app cons (-> (app cons 3 (app cons 4 (app cons ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 3 (-> (app cons 4 (app cons 5 (app nil ...))) <-)) (env ()))
clos/con:
	'((app cons 3 (-> (app cons 4 (app cons 5 (app nil ...))) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 4 (-> (app cons 5 (app nil)) <-)) (env ()))
clos/con:
	'((app cons 4 (-> (app cons 5 (app nil)) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 5 (-> (app nil) <-)) (env ()))
clos/con:
	'(((top) app nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> 5 <-) (app nil)) (env ()))
clos/con: ⊥
literals: '(5 ⊥ ⊥)

'(query: (app (-> cons <-) 5 (app nil)) (env ()))
clos/con:
	'((app (-> cons <-) 5 (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> 4 <-) (app cons 5 (app nil))) (env ()))
clos/con: ⊥
literals: '(4 ⊥ ⊥)

'(query: (app (-> cons <-) 4 (app cons 5 (app nil))) (env ()))
clos/con:
	'((app (-> cons <-) 4 (app cons 5 (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> 3 <-) (app cons 4 (app cons 5 (app nil ...)))) (env ()))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(query: (app (-> cons <-) 3 (app cons 4 (app cons 5 (app nil ...)))) (env ()))
clos/con:
	'((app (-> cons <-) 3 (app cons 4 (app cons 5 (app nil ...)))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> cons <-) (app cons 3 (app cons 4 (app cons ...))) (app nil))
  (env ()))
clos/con:
	'((app (-> cons <-) (app cons 3 (app cons 4 (app cons ...))) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> cons <-) (app cons (app cons 3 (app cons ...)) (app nil)) (app nil))
  (env ()))
clos/con:
	'((app (-> cons <-) (app cons (app cons 3 (app cons ...)) (app nil)) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   (app cons (app cons (app cons ...) (app nil ...)) (app nil))
   (app nil))
  (env ()))
clos/con:
	'((app
   (-> cons <-)
   (app cons (app cons (app cons ...) (app nil ...)) (app nil))
   (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> (app cons 1 (app cons 2 (app nil ...))) <-)
   (app cons (app cons (app cons ...) (app nil ...)) (app nil)))
  (env ()))
clos/con:
	'((app
   cons
   (-> (app cons 1 (app cons 2 (app nil ...))) <-)
   (app cons (app cons (app cons ...) (app nil ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 1 (-> (app cons 2 (app nil)) <-)) (env ()))
clos/con:
	'((app cons 1 (-> (app cons 2 (app nil)) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 2 (-> (app nil) <-)) (env ()))
clos/con:
	'(((top) app nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> 2 <-) (app nil)) (env ()))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query: (app (-> cons <-) 2 (app nil)) (env ()))
clos/con:
	'((app (-> cons <-) 2 (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> 1 <-) (app cons 2 (app nil))) (env ()))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app (-> cons <-) 1 (app cons 2 (app nil))) (env ()))
clos/con:
	'((app (-> cons <-) 1 (app cons 2 (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   (app cons 1 (app cons 2 (app nil ...)))
   (app cons (app cons (app cons ...) (app nil ...)) (app nil)))
  (env ()))
clos/con:
	'((app
   (-> cons <-)
   (app cons 1 (app cons 2 (app nil ...)))
   (app cons (app cons (app cons ...) (app nil ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   (-> flatten <-)
   (app
    cons
    (app cons 1 (app cons ...))
    (app cons (app cons ...) (app nil ...))))
  (env ()))
clos/con:
	'((letrec* (... append (flatten (-> (λ (x) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)
