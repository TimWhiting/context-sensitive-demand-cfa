'(expression:
  (lettypes
   ((cons car cdr) (nil))
   (letrec*
    ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
     (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
     (cadar (λ (p) (app car (app cdr (app car p)))))
     (initial-environment-amap
      (app
       cons
       (app cons '+ (app cons + (app nil)))
       (app cons (app cons '- (app cons - (app nil))) (app nil)))))
    (let ((x (app (app cadar initial-environment-amap) 1 1)))
      (app display x)))))

'(query:
  (app
   (-> cons <-)
   (app cons '+ (app cons + (app nil)))
   (app cons (app cons '- (app cons - (app nil))) (app nil)))
  (env ()))
clos/con:
	'((app
   (-> cons <-)
   (app cons '+ (app cons + (app nil)))
   (app cons (app cons '- (app cons - (app nil))) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> (app cons '+ (app cons + (app nil))) <-)
   (app cons (app cons '- (app cons - (app nil))) (app nil)))
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons '+ (app cons + (app nil))) <-)
    (app cons (app cons '- (app cons - (app nil))) (app nil))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (app cons '+ (app cons + (app nil)))
   (-> (app cons (app cons '- (app cons - (app nil))) (app nil)) <-))
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (app cons '+ (app cons + (app nil)))
    (-> (app cons (app cons '- (app cons - (app nil))) (app nil)) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> cons <-) (app cons '- (app cons - (app nil))) (app nil))
  (env ()))
clos/con:
	'((app (-> cons <-) (app cons '- (app cons - (app nil))) (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> (app cons '- (app cons - (app nil))) <-) (app nil))
  (env ()))
clos/con:
	'((con cons (app cons (-> (app cons '- (app cons - (app nil))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (app cons '- (app cons - (app nil))) (-> (app nil) <-))
  (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (...
        ()
        (x (-> (app (app cadar initial-environment-amap) 1 1) <-))
        ()
        ...)
    ...)
  (env ()))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query:
  (letrec*
   (...
    cadar
    (initial-environment-amap
     (->
      (app
       cons
       (app cons '+ (app cons + (app nil)))
       (app cons (app cons '- (app cons - (app nil))) (app nil)))
      <-))
    ()
    ...)
   ...)
  (env ()))
clos/con:
	'((con
   cons
   (letrec*
    (...
     cadar
     (initial-environment-amap
      (->
       (app
        cons
        (app cons '+ (app cons + (app nil)))
        (app cons (app cons '- (app cons - (app nil))) (app nil)))
       <-))
     ()
     ...)
    ...))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... cdr (cadar (-> (λ (p) ...) <-)) initial-environment-amap ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... cdr (cadar (-> (λ (p) ...) <-)) initial-environment-amap ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadar ...) ...)
  (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadar ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (car ... initial-environment-amap) (-> (let (x) ...) <-))
  (env ()))
clos/con:
	'((con void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (lettypes cons ... nil (letrec* (car ... initial-environment-amap) ...))
  (env ()))
clos/con:
	'((con void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: ((top) lettypes (cons ... nil) ...) (env ()))
clos/con:
	'((con void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> (app cadar initial-environment-amap) <-) 1 1) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons '+ (app cons + (app nil))) <-)
    (app cons (app cons '- (app cons - (app nil))) (app nil))))
  (env ()))
	'((prim +) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cadar <-) initial-environment-amap) (env ()))
clos/con:
	'((letrec*
   (... cdr (cadar (-> (λ (p) ...) <-)) initial-environment-amap ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> car <-) (app cdr (app car p))) (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> car <-) p) (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cdr <-) (app car p)) (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadar ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) '+ (app cons + (app nil))) (env ()))
clos/con:
	'((app (-> cons <-) '+ (app cons + (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) '- (app cons - (app nil))) (env ()))
clos/con:
	'((app (-> cons <-) '- (app cons - (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) + (app nil)) (env ()))
clos/con:
	'((app (-> cons <-) + (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) - (app nil)) (env ()))
clos/con:
	'((app (-> cons <-) - (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> display <-) x) (env ()))
clos/con:
	'((prim display) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (app cadar initial-environment-amap) (-> 1 <-) 1) (env ()))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app (app cadar initial-environment-amap) 1 (-> 1 <-)) (env ()))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app cadar (-> initial-environment-amap <-)) (env ()))
clos/con:
	'((con
   cons
   (letrec*
    (...
     cadar
     (initial-environment-amap
      (->
       (app
        cons
        (app cons '+ (app cons + (app nil)))
        (app cons (app cons '- (app cons - (app nil))) (app nil)))
       <-))
     ()
     ...)
    ...))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app car (-> (app cdr (app car p)) <-)) (env ()))
clos/con:
	'((con cons (app cons '+ (-> (app cons + (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app car (-> p <-)) (env ()))
clos/con:
	'((con
   cons
   (letrec*
    (...
     cadar
     (initial-environment-amap
      (->
       (app
        cons
        (app cons '+ (app cons + (app nil)))
        (app cons (app cons '- (app cons - (app nil))) (app nil)))
       <-))
     ()
     ...)
    ...))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cdr (-> (app car p) <-)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons '+ (app cons + (app nil))) <-)
    (app cons (app cons '- (app cons - (app nil))) (app nil))))
  (env ()))
	'((prim +) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons '+ (-> (app cons + (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons '+ (-> (app cons + (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons '- (-> (app cons - (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons '- (-> (app cons - (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> '+ <-) (app cons + (app nil))) (env ()))
clos/con:
	'((app cons (-> '+ <-) (app cons + (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> '- <-) (app cons - (app nil))) (env ()))
clos/con:
	'((app cons (-> '- <-) (app cons - (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> + <-) (app nil)) (env ()))
clos/con:
	'((prim +) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> - <-) (app nil)) (env ()))
clos/con:
	'((prim -) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons + (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons - (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app display (-> x <-)) (env ()))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query: (let (x) (-> (app display x) <-)) (env ()))
clos/con:
	'((con void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> car-v <-) (cons car-c car-d)) (env ()))
clos/con:
	'((con
   cons
   (letrec*
    (...
     cadar
     (initial-environment-amap
      (->
       (app
        cons
        (app cons '+ (app cons + (app nil)))
        (app cons (app cons '- (app cons - (app nil))) (app nil)))
       <-))
     ()
     ...)
    ...))
  (env ()))
	'((con cons (app cons '+ (-> (app cons + (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> cdr-v <-) (cons cdr-c cdr-d)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons '+ (app cons + (app nil))) <-)
    (app cons (app cons '- (app cons - (app nil))) (app nil))))
  (env ()))
	'((prim +) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match car-v ((cons car-c car-d) (-> car-c <-))) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons '+ (app cons + (app nil))) <-)
    (app cons (app cons '- (app cons - (app nil))) (app nil))))
  (env ()))
	'((prim +) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-))) (env ()))
clos/con:
	'((con cons (app cons '+ (-> (app cons + (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (car-v) (-> (match car-v ...) <-)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons '+ (app cons + (app nil))) <-)
    (app cons (app cons '- (app cons - (app nil))) (app nil))))
  (env ()))
	'((prim +) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (cdr-v) (-> (match cdr-v ...) <-)) (env ()))
clos/con:
	'((con cons (app cons '+ (-> (app cons + (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (p) (-> (app car (app cdr (app car p))) <-)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons '+ (app cons + (app nil))) <-)
    (app cons (app cons '- (app cons - (app nil))) (app nil))))
  (env ()))
	'((prim +) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ('+)
    ()
    (ran
     cons
     ()
     ((app cons (app cons '- (app cons - (app nil))) (app nil)))
     (bin
      letrec*
      initial-environment-amap
      (let ((x (app (app cadar initial-environment-amap) 1 1)))
        (app display x))
      ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
       (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
       (cadar (λ (p) (app car (app cdr (app car p))))))
      ()
      (lettypes-bod ((cons car cdr) (nil)) (top)))))
   app
   cons
   +
   (app nil))
  con
  (env ()))
clos/con:
	'((con cons (app cons '+ (-> (app cons + (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ('-)
    ()
    (ran
     cons
     ()
     ((app nil))
     (ran
      cons
      ((app cons '+ (app cons + (app nil))))
      ()
      (bin
       letrec*
       initial-environment-amap
       (let ((x (app (app cadar initial-environment-amap) 1 1)))
         (app display x))
       ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
        (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
        (cadar (λ (p) (app car (app cdr (app car p))))))
       ()
       (lettypes-bod ((cons car cdr) (nil)) (top))))))
   app
   cons
   -
   (app nil))
  con
  (env ()))
clos/con:
	'((con cons (app cons '- (-> (app cons - (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ((app cons '+ (app cons + (app nil))))
    ()
    (bin
     letrec*
     initial-environment-amap
     (let ((x (app (app cadar initial-environment-amap) 1 1))) (app display x))
     ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
      (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
      (cadar (λ (p) (app car (app cdr (app car p))))))
     ()
     (lettypes-bod ((cons car cdr) (nil)) (top))))
   app
   cons
   (app cons '- (app cons - (app nil)))
   (app nil))
  con
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (app cons '+ (app cons + (app nil)))
    (-> (app cons (app cons '- (app cons - (app nil))) (app nil)) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ((app cons '- (app cons - (app nil))))
    ()
    (ran
     cons
     ((app cons '+ (app cons + (app nil))))
     ()
     (bin
      letrec*
      initial-environment-amap
      (let ((x (app (app cadar initial-environment-amap) 1 1)))
        (app display x))
      ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
       (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
       (cadar (λ (p) (app car (app cdr (app car p))))))
      ()
      (lettypes-bod ((cons car cdr) (nil)) (top)))))
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
    ()
    ((app cons (app cons '- (app cons - (app nil))) (app nil)))
    (bin
     letrec*
     initial-environment-amap
     (let ((x (app (app cadar initial-environment-amap) 1 1))) (app display x))
     ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
      (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
      (cadar (λ (p) (app car (app cdr (app car p))))))
     ()
     (lettypes-bod ((cons car cdr) (nil)) (top))))
   app
   cons
   '+
   (app cons + (app nil)))
  con
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons '+ (app cons + (app nil))) <-)
    (app cons (app cons '- (app cons - (app nil))) (app nil))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app cons + (app nil)))
    (ran
     cons
     ()
     ((app cons (app cons '- (app cons - (app nil))) (app nil)))
     (bin
      letrec*
      initial-environment-amap
      (let ((x (app (app cadar initial-environment-amap) 1 1)))
        (app display x))
      ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
       (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
       (cadar (λ (p) (app car (app cdr (app car p))))))
      ()
      (lettypes-bod ((cons car cdr) (nil)) (top)))))
   quote
   +)
  con
  (env ()))
clos/con:
	'((app cons (-> '+ <-) (app cons + (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app cons - (app nil)))
    (ran
     cons
     ()
     ((app nil))
     (ran
      cons
      ((app cons '+ (app cons + (app nil))))
      ()
      (bin
       letrec*
       initial-environment-amap
       (let ((x (app (app cadar initial-environment-amap) 1 1)))
         (app display x))
       ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
        (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
        (cadar (λ (p) (app car (app cdr (app car p))))))
       ()
       (lettypes-bod ((cons car cdr) (nil)) (top))))))
   quote
   -)
  con
  (env ()))
clos/con:
	'((app cons (-> '- <-) (app cons - (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app nil))
    (ran
     cons
     ('+)
     ()
     (ran
      cons
      ()
      ((app cons (app cons '- (app cons - (app nil))) (app nil)))
      (bin
       letrec*
       initial-environment-amap
       (let ((x (app (app cadar initial-environment-amap) 1 1)))
         (app display x))
       ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
        (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
        (cadar (λ (p) (app car (app cdr (app car p))))))
       ()
       (lettypes-bod ((cons car cdr) (nil)) (top))))))
   .
   +)
  con
  (env ()))
clos/con:
	'((prim +) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app nil))
    (ran
     cons
     ('-)
     ()
     (ran
      cons
      ()
      ((app nil))
      (ran
       cons
       ((app cons '+ (app cons + (app nil))))
       ()
       (bin
        letrec*
        initial-environment-amap
        (let ((x (app (app cadar initial-environment-amap) 1 1)))
          (app display x))
        ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
         (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
         (cadar (λ (p) (app car (app cdr (app car p))))))
        ()
        (lettypes-bod ((cons car cdr) (nil)) (top)))))))
   .
   -)
  con
  (env ()))
clos/con:
	'((prim -) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app nil))
    (ran
     cons
     ((app cons '+ (app cons + (app nil))))
     ()
     (bin
      letrec*
      initial-environment-amap
      (let ((x (app (app cadar initial-environment-amap) 1 1)))
        (app display x))
      ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
       (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
       (cadar (λ (p) (app car (app cdr (app car p))))))
      ()
      (lettypes-bod ((cons car cdr) (nil)) (top)))))
   app
   cons
   '-
   (app cons - (app nil)))
  con
  (env ()))
clos/con:
	'((con cons (app cons (-> (app cons '- (app cons - (app nil))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    (+)
    ()
    (ran
     cons
     ('+)
     ()
     (ran
      cons
      ()
      ((app cons (app cons '- (app cons - (app nil))) (app nil)))
      (bin
       letrec*
       initial-environment-amap
       (let ((x (app (app cadar initial-environment-amap) 1 1)))
         (app display x))
       ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
        (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
        (cadar (λ (p) (app car (app cdr (app car p))))))
       ()
       (lettypes-bod ((cons car cdr) (nil)) (top))))))
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
    (-)
    ()
    (ran
     cons
     ('-)
     ()
     (ran
      cons
      ()
      ((app nil))
      (ran
       cons
       ((app cons '+ (app cons + (app nil))))
       ()
       (bin
        letrec*
        initial-environment-amap
        (let ((x (app (app cadar initial-environment-amap) 1 1)))
          (app display x))
        ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
         (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
         (cadar (λ (p) (app car (app cdr (app car p))))))
        ()
        (lettypes-bod ((cons car cdr) (nil)) (top)))))))
   app
   nil)
  con
  (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car
  (letrec*
   (... cdr (cadar (-> (λ (p) ...) <-)) initial-environment-amap ...)
   ...)
  (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car-c
  (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...)
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons '+ (app cons + (app nil))) <-)
    (app cons (app cons '- (app cons - (app nil))) (app nil))))
  (env ()))
	'((prim +) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car-d
  (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...)
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (app cons '+ (app cons + (app nil)))
    (-> (app cons (app cons '- (app cons - (app nil))) (app nil)) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car-v
  (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...)
  (env ()))
clos/con:
	'((con
   cons
   (letrec*
    (...
     cadar
     (initial-environment-amap
      (->
       (app
        cons
        (app cons '+ (app cons + (app nil)))
        (app cons (app cons '- (app cons - (app nil))) (app nil)))
       <-))
     ()
     ...)
    ...))
  (env ()))
	'((con cons (app cons '+ (-> (app cons + (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr
  (letrec*
   (... cdr (cadar (-> (λ (p) ...) <-)) initial-environment-amap ...)
   ...)
  (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadar ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr-c
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadar ...) ...)
  (env ()))
clos/con:
	'((app cons (-> '+ <-) (app cons + (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr-d
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadar ...) ...)
  (env ()))
clos/con:
	'((con cons (app cons '+ (-> (app cons + (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr-v
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadar ...) ...)
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons '+ (app cons + (app nil))) <-)
    (app cons (app cons '- (app cons - (app nil))) (app nil))))
  (env ()))
	'((prim +) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  p
  (letrec*
   (... cdr (cadar (-> (λ (p) ...) <-)) initial-environment-amap ...)
   ...)
  (env ()))
clos/con:
	'((con
   cons
   (letrec*
    (...
     cadar
     (initial-environment-amap
      (->
       (app
        cons
        (app cons '+ (app cons + (app nil)))
        (app cons (app cons '- (app cons - (app nil))) (app nil)))
       <-))
     ()
     ...)
    ...))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: cadar ((top) lettypes (cons ... nil) ...) (env ()))
clos/con:
	'((letrec*
   (... cdr (cadar (-> (λ (p) ...) <-)) initial-environment-amap ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: car ((top) lettypes (cons ... nil) ...) (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: cdr ((top) lettypes (cons ... nil) ...) (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadar ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: initial-environment-amap ((top) lettypes (cons ... nil) ...) (env ()))
clos/con:
	'((con
   cons
   (letrec*
    (...
     cadar
     (initial-environment-amap
      (->
       (app
        cons
        (app cons '+ (app cons + (app nil)))
        (app cons (app cons '- (app cons - (app nil))) (app nil)))
       <-))
     ()
     ...)
    ...))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: x ((top) lettypes (cons ... nil) ...) (env ()))
clos/con: ⊥
literals: '(2 ⊥ ⊥)
