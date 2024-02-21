'(expression:
  (lettypes
   ((cons car cdr) (nil))
   (letrec ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
            (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
            (pair?
             (λ (pair?-v)
               (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
            (debug-trace (λ () (app #f)))
            (id (λ (xx) (let ((_ (app debug-trace))) xx)))
            (my-map
             (λ (f l)
               (let ((_ (app debug-trace)))
                 (letrec ((lp
                           (λ (lst)
                             (match
                              (app not (app pair? lst))
                              ((#f)
                               (app
                                cons
                                (app (app id f) (app car lst))
                                (app lp (app cdr lst))))
                              (_ (app nil))))))
                   (app lp l))))))
     (let ((_
            (app
             my-map
             (app id (λ (a) (app + 1 a)))
             (app cons 1 (app cons 2 (app cons 3 (app nil)))))))
       (app
        my-map
        (app id (λ (b) (app + 1 b)))
        (app cons 7 (app cons 8 (app cons 9 (app nil)))))))))

'(query:
  (letrec (... pair? (debug-trace (-> (λ () ...) <-)) id ...) ...)
  (env ()))
clos/con:
	'((letrec (... pair? (debug-trace (-> (λ () ...) <-)) id ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> (app not (app pair? lst)) <-) (#f) _) (env (() ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cdr <-) lst) (env (() ())))
clos/con:
	'((letrec (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> 1 <-) (app cons 2 (app cons 3 (app nil)))) (env ()))
clos/con: ⊥
literals: '(1 ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 9 (app nil)) (env ()))
clos/con:
	'((app (-> cons <-) 9 (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (b) (-> (app + 1 b) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (let (_) (-> (letrec (lp) ...) <-)) (env (())))
clos/con:
	'((con
   cons
   (app cons (-> (app (app id f) (app car lst)) <-) (app lp (app cdr lst)))
   (app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))
  (env (() ())))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (let (...
        ()
        (_
         (->
          (app
           my-map
           (app id (λ (a) ...))
           (app cons 1 (app cons 2 (app cons 3 (app nil)))))
          <-))
        ()
        ...)
    ...)
  (env ()))
clos/con:
	'((con
   cons
   (app cons (-> (app (app id f) (app car lst)) <-) (app lp (app cdr lst)))
   (app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))
  (env (() ())))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app id (-> (λ (b) ...) <-)) (env ()))
clos/con:
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> (app id f) <-) (app car lst)) (env (() ())))
clos/con:
	'((app id (-> (λ (a) ...) <-)) (env ()))
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app id (-> f <-)) (env (() ())))
clos/con:
	'((app id (-> (λ (a) ...) <-)) (env ()))
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons 3 (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> + <-) 1 b) (env (())))
clos/con:
	#<procedure:do-add>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app cons (-> (app (app id f) (app car lst)) <-) (app lp (app cdr lst)))
  (env (() ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (λ () (-> (app #f) <-)) (env (())))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: ((top) lettypes (cons ... nil) ...) (env ()))
clos/con:
	'((con
   cons
   (app cons (-> (app (app id f) (app car lst)) <-) (app lp (app cdr lst)))
   (app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))
  (env (() ())))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (xx) (-> (let (_) ...) <-)) (env (())))
clos/con:
	'((app id (-> (λ (a) ...) <-)) (env ()))
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app + (-> 1 <-) b) (env (())))
clos/con: ⊥
literals: '(1 ⊥ ⊥ ⊥)

'(query: (app cons (-> 3 <-) (app nil)) (env ()))
clos/con: ⊥
literals: '(3 ⊥ ⊥ ⊥)

'(query: (letrec (... id (my-map (-> (λ (f l) ...) <-)) () ...) ...) (env ()))
clos/con:
	'((letrec (... id (my-map (-> (λ (f l) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   my-map
   (app id (λ (a) ...))
   (-> (app cons 1 (app cons 2 (app cons 3 (app nil)))) <-))
  (env ()))
clos/con:
	'((con
   cons
   (app cons (-> 1 <-) (app cons 2 (app cons 3 (app nil))))
   (app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (a) (-> (app + 1 a) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query:
  (letrec (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...)
  (env ()))
clos/con:
	'((letrec (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (let (... () (_ (-> (app debug-trace) <-)) () ...) ...) (env (())))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   my-map
   (-> (app id (λ (a) ...)) <-)
   (app cons 1 (app cons 2 (app cons 3 (app nil)))))
  (env ()))
clos/con:
	'((app id (-> (λ (a) ...) <-)) (env ()))
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec (... debug-trace (id (-> (λ (xx) ...) <-)) my-map ...) ...)
  (env ()))
clos/con:
	'((letrec (... debug-trace (id (-> (λ (xx) ...) <-)) my-map ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-))
  (env (() ())))
clos/con:
	'((con
   cons
   (app cons (-> (app (app id f) (app car lst)) <-) (app lp (app cdr lst)))
   (app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))
  (env (() ())))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (letrec (car ... my-map) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'((con
   cons
   (app cons (-> (app (app id f) (app car lst)) <-) (app lp (app cdr lst)))
   (app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))
  (env (() ())))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match pair?-v (cons pair?-c pair?-d) (_ (-> (app #f) <-)))
  (env (())))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app not (-> (app pair? lst) <-)) (env (() ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> 2 <-) (app cons 3 (app nil))) (env ()))
clos/con: ⊥
literals: '(2 ⊥ ⊥ ⊥)

'(query: (λ (lst) (-> (match (app not (app pair? lst)) ...) <-)) (env (() ())))
clos/con:
	'((con
   cons
   (app cons (-> (app (app id f) (app car lst)) <-) (app lp (app cdr lst)))
   (app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))
  (env (() ())))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app + (-> 1 <-) a) (env (())))
clos/con: ⊥
literals: '(1 ⊥ ⊥ ⊥)

'(query:
  (match pair?-v ((cons pair?-c pair?-d) (-> (app #t) <-)) _)
  (env (())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match
   (app not (app pair? lst))
   ((#f)
    (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
   _)
  (env (() ())))
clos/con:
	'((con
   cons
   (app cons (-> (app (app id f) (app car lst)) <-) (app lp (app cdr lst)))
   (app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))
  (env (() ())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   my-map
   (-> (app id (λ (b) ...)) <-)
   (app cons 7 (app cons 8 (app cons 9 (app nil)))))
  (env ()))
clos/con:
	'((app id (-> (λ (a) ...) <-)) (env ()))
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app + 1 (-> a <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 1 (app cons 2 (app cons 3 (app nil)))) (env ()))
clos/con:
	'((app (-> cons <-) 1 (app cons 2 (app cons 3 (app nil)))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (cdr-v) (-> (match cdr-v ...) <-)) (env (())))
clos/con:
	'((con
   cons
   (app cons (-> 2 <-) (app cons 3 (app nil)))
   (app cons 2 (-> (app cons 3 (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 8 <-) (app cons 9 (app nil)))
   (app cons 8 (-> (app cons 9 (app nil)) <-)))
  (env ()))
	'((con cons (app cons (-> 3 <-) (app nil)) (app cons 3 (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 9 <-) (app nil)) (app cons 9 (-> (app nil) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> id <-) (λ (b) ...)) (env ()))
clos/con:
	'((letrec (... debug-trace (id (-> (λ (xx) ...) <-)) my-map ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (let (... () (_ (-> (app debug-trace) <-)) () ...) ...) (env (())))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> pair? <-) lst) (env (() ())))
clos/con:
	'((letrec (... cdr (pair? (-> (λ (pair?-v) ...) <-)) debug-trace ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> lp <-) l) (env (())))
clos/con:
	'((letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...) (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> debug-trace <-)) (env (())))
clos/con:
	'((letrec (... pair? (debug-trace (-> (λ () ...) <-)) id ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> car <-) lst) (env (() ())))
clos/con:
	'((letrec (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (lettypes cons ... nil (letrec (car ... my-map) ...)) (env ()))
clos/con:
	'((con
   cons
   (app cons (-> (app (app id f) (app car lst)) <-) (app lp (app cdr lst)))
   (app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))
  (env (() ())))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app + 1 (-> b <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app pair? (-> lst <-)) (env (() ())))
clos/con:
	'((con
   cons
   (app cons (-> 1 <-) (app cons 2 (app cons 3 (app nil))))
   (app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 2 <-) (app cons 3 (app nil)))
   (app cons 2 (-> (app cons 3 (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 7 <-) (app cons 8 (app cons 9 (app nil))))
   (app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 8 <-) (app cons 9 (app nil)))
   (app cons 8 (-> (app cons 9 (app nil)) <-)))
  (env ()))
	'((con cons (app cons (-> 3 <-) (app nil)) (app cons 3 (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 9 <-) (app nil)) (app cons 9 (-> (app nil) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (letrec (lp) (-> (app lp l) <-)) (env (())))
clos/con:
	'((con
   cons
   (app cons (-> (app (app id f) (app car lst)) <-) (app lp (app cdr lst)))
   (app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))
  (env (() ())))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec (... cdr (pair? (-> (λ (pair?-v) ...) <-)) debug-trace ...) ...)
  (env ()))
clos/con:
	'((letrec (... cdr (pair? (-> (λ (pair?-v) ...) <-)) debug-trace ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   (-> my-map <-)
   (app id (λ (a) ...))
   (app cons 1 (app cons 2 (app cons 3 (app nil)))))
  (env ()))
clos/con:
	'((letrec (... id (my-map (-> (λ (f l) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (car-v) (-> (match car-v ...) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (match (-> cdr-v <-) (cons cdr-c cdr-d)) (env (())))
clos/con:
	'((con
   cons
   (app cons (-> 1 <-) (app cons 2 (app cons 3 (app nil))))
   (app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 2 <-) (app cons 3 (app nil)))
   (app cons 2 (-> (app cons 3 (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 7 <-) (app cons 8 (app cons 9 (app nil))))
   (app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 8 <-) (app cons 9 (app nil)))
   (app cons 8 (-> (app cons 9 (app nil)) <-)))
  (env ()))
	'((con cons (app cons (-> 3 <-) (app nil)) (app cons 3 (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 9 <-) (app nil)) (app cons 9 (-> (app nil) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-)) (env ()))
clos/con:
	'((con
   cons
   (app cons (-> 2 <-) (app cons 3 (app nil)))
   (app cons 2 (-> (app cons 3 (app nil)) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app id (-> (λ (a) ...) <-)) (env ()))
clos/con:
	'((app id (-> (λ (a) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons 9 (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> debug-trace <-)) (env (())))
clos/con:
	'((letrec (... pair? (debug-trace (-> (λ () ...) <-)) id ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app lp (-> l <-)) (env (())))
clos/con:
	'((con
   cons
   (app cons (-> 1 <-) (app cons 2 (app cons 3 (app nil))))
   (app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 7 <-) (app cons 8 (app cons 9 (app nil))))
   (app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match (app not (app pair? lst)) (#f) (_ (-> (app nil) <-)))
  (env (() ())))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app (-> cons <-) (app (app id f) (app car lst)) (app lp (app cdr lst)))
  (env (() ())))
clos/con:
	'((app (-> cons <-) (app (app id f) (app car lst)) (app lp (app cdr lst)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> pair?-v <-) (cons pair?-c pair?-d) _) (env (())))
clos/con:
	'((con
   cons
   (app cons (-> 1 <-) (app cons 2 (app cons 3 (app nil))))
   (app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 2 <-) (app cons 3 (app nil)))
   (app cons 2 (-> (app cons 3 (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 7 <-) (app cons 8 (app cons 9 (app nil))))
   (app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 8 <-) (app cons 9 (app nil)))
   (app cons 8 (-> (app cons 9 (app nil)) <-)))
  (env ()))
	'((con cons (app cons (-> 3 <-) (app nil)) (app cons 3 (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 9 <-) (app nil)) (app cons 9 (-> (app nil) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> 8 <-) (app cons 9 (app nil))) (env ()))
clos/con: ⊥
literals: '(8 ⊥ ⊥ ⊥)

'(query: (app (-> id <-) f) (env (() ())))
clos/con:
	'((letrec (... debug-trace (id (-> (λ (xx) ...) <-)) my-map ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 8 (app cons 9 (app nil))) (env ()))
clos/con:
	'((app (-> cons <-) 8 (app cons 9 (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 2 (app cons 3 (app nil))) (env ()))
clos/con:
	'((app (-> cons <-) 2 (app cons 3 (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 3 (app nil)) (env ()))
clos/con:
	'((app (-> cons <-) 3 (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> lp <-) (app cdr lst)) (env (() ())))
clos/con:
	'((letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...) (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> 7 <-) (app cons 8 (app cons 9 (app nil)))) (env ()))
clos/con: ⊥
literals: '(7 ⊥ ⊥ ⊥)

'(query: (λ (f l) (-> (let (_) ...) <-)) (env (())))
clos/con:
	'((con
   cons
   (app cons (-> (app (app id f) (app car lst)) <-) (app lp (app cdr lst)))
   (app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))
  (env (() ())))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env (() ())))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-))) (env (())))
clos/con:
	'((con
   cons
   (app cons (-> 2 <-) (app cons 3 (app nil)))
   (app cons 2 (-> (app cons 3 (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 8 <-) (app cons 9 (app nil)))
   (app cons 8 (-> (app cons 9 (app nil)) <-)))
  (env ()))
	'((con cons (app cons (-> 3 <-) (app nil)) (app cons 3 (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 9 <-) (app nil)) (app cons 9 (-> (app nil) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> id <-) (λ (a) ...)) (env ()))
clos/con:
	'((letrec (... debug-trace (id (-> (λ (xx) ...) <-)) my-map ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-)) (env ()))
clos/con:
	'((con
   cons
   (app cons (-> 8 <-) (app cons 9 (app nil)))
   (app cons 8 (-> (app cons 9 (app nil)) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (letrec (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
clos/con:
	'((letrec (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   my-map
   (app id (λ (b) ...))
   (-> (app cons 7 (app cons 8 (app cons 9 (app nil)))) <-))
  (env ()))
clos/con:
	'((con
   cons
   (app cons (-> 7 <-) (app cons 8 (app cons 9 (app nil))))
   (app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app car (-> lst <-)) (env (() ())))
clos/con:
	'((con
   cons
   (app cons (-> 1 <-) (app cons 2 (app cons 3 (app nil))))
   (app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 2 <-) (app cons 3 (app nil)))
   (app cons 2 (-> (app cons 3 (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 7 <-) (app cons 8 (app cons 9 (app nil))))
   (app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 8 <-) (app cons 9 (app nil)))
   (app cons 8 (-> (app cons 9 (app nil)) <-)))
  (env ()))
	'((con cons (app cons (-> 3 <-) (app nil)) (app cons 3 (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 9 <-) (app nil)) (app cons 9 (-> (app nil) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...) (env (())))
clos/con:
	'((letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...) (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 7 (app cons 8 (app cons 9 (app nil)))) (env ()))
clos/con:
	'((app (-> cons <-) 7 (app cons 8 (app cons 9 (app nil)))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app lp (-> (app cdr lst) <-)) (env (() ())))
clos/con:
	'((con
   cons
   (app cons (-> 2 <-) (app cons 3 (app nil)))
   (app cons 2 (-> (app cons 3 (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 8 <-) (app cons 9 (app nil)))
   (app cons 8 (-> (app cons 9 (app nil)) <-)))
  (env ()))
	'((con cons (app cons (-> 3 <-) (app nil)) (app cons 3 (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 9 <-) (app nil)) (app cons 9 (-> (app nil) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cdr (-> lst <-)) (env (() ())))
clos/con:
	'((con
   cons
   (app cons (-> 1 <-) (app cons 2 (app cons 3 (app nil))))
   (app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 2 <-) (app cons 3 (app nil)))
   (app cons 2 (-> (app cons 3 (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 7 <-) (app cons 8 (app cons 9 (app nil))))
   (app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 8 <-) (app cons 9 (app nil)))
   (app cons 8 (-> (app cons 9 (app nil)) <-)))
  (env ()))
	'((con cons (app cons (-> 3 <-) (app nil)) (app cons 3 (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 9 <-) (app nil)) (app cons 9 (-> (app nil) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (app id f) (-> (app car lst) <-)) (env (() ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query:
  (let (_)
    (->
     (app
      my-map
      (app id (λ (b) ...))
      (app cons 7 (app cons 8 (app cons 9 (app nil)))))
     <-))
  (env ()))
clos/con:
	'((con
   cons
   (app cons (-> (app (app id f) (app car lst)) <-) (app lp (app cdr lst)))
   (app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))
  (env (() ())))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (let (_) (-> xx <-)) (env (())))
clos/con:
	'((app id (-> (λ (a) ...) <-)) (env ()))
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> 9 <-) (app nil)) (env ()))
clos/con: ⊥
literals: '(9 ⊥ ⊥ ⊥)

'(query: (λ (pair?-v) (-> (match pair?-v ...) <-)) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   (-> my-map <-)
   (app id (λ (b) ...))
   (app cons 7 (app cons 8 (app cons 9 (app nil)))))
  (env ()))
clos/con:
	'((letrec (... id (my-map (-> (λ (f l) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons 8 (-> (app cons 9 (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons (-> 9 <-) (app nil)) (app cons 9 (-> (app nil) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> + <-) 1 a) (env (())))
clos/con:
	#<procedure:do-add>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> car-v <-) (cons car-c car-d)) (env (())))
clos/con:
	'((con
   cons
   (app cons (-> 1 <-) (app cons 2 (app cons 3 (app nil))))
   (app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 2 <-) (app cons 3 (app nil)))
   (app cons 2 (-> (app cons 3 (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 7 <-) (app cons 8 (app cons 9 (app nil))))
   (app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 8 <-) (app cons 9 (app nil)))
   (app cons 8 (-> (app cons 9 (app nil)) <-)))
  (env ()))
	'((con cons (app cons (-> 3 <-) (app nil)) (app cons 3 (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 9 <-) (app nil)) (app cons 9 (-> (app nil) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons 2 (-> (app cons 3 (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons (-> 3 <-) (app nil)) (app cons 3 (-> (app nil) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match car-v ((cons car-c car-d) (-> car-c <-))) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> not <-) (app pair? lst)) (env (() ())))
clos/con:
	#<procedure:do-not>
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: l (env (())))
clos/con:
	'((con
   cons
   (app cons (-> 1 <-) (app cons 2 (app cons 3 (app nil))))
   (app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 7 <-) (app cons 8 (app cons 9 (app nil))))
   (app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: a (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: id (env ()))
clos/con:
	'((letrec (... debug-trace (id (-> (λ (xx) ...) <-)) my-map ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: cdr (env ()))
clos/con:
	'((letrec (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: f (env (())))
clos/con:
	'((app id (-> (λ (a) ...) <-)) (env ()))
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: car-v (env (())))
clos/con:
	'((con
   cons
   (app cons (-> 1 <-) (app cons 2 (app cons 3 (app nil))))
   (app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 2 <-) (app cons 3 (app nil)))
   (app cons 2 (-> (app cons 3 (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 7 <-) (app cons 8 (app cons 9 (app nil))))
   (app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 8 <-) (app cons 9 (app nil)))
   (app cons 8 (-> (app cons 9 (app nil)) <-)))
  (env ()))
	'((con cons (app cons (-> 3 <-) (app nil)) (app cons 3 (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 9 <-) (app nil)) (app cons 9 (-> (app nil) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons (-> 9 <-) (app nil)) (env ()))
clos/con: ⊥
literals: '(9 ⊥ ⊥ ⊥)

'(store: (app cons 8 (-> (app cons 9 (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons (-> 9 <-) (app nil)) (app cons 9 (-> (app nil) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons (-> 8 <-) (app cons 9 (app nil))) (env ()))
clos/con: ⊥
literals: '(8 ⊥ ⊥ ⊥)

'(store: (app cons 3 (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: debug-trace (env ()))
clos/con:
	'((letrec (... pair? (debug-trace (-> (λ () ...) <-)) id ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons (-> 2 <-) (app cons 3 (app nil))) (env ()))
clos/con: ⊥
literals: '(2 ⊥ ⊥ ⊥)

'(store: b (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: _ (env ()))
clos/con:
	'((con
   cons
   (app cons (-> (app (app id f) (app car lst)) <-) (app lp (app cdr lst)))
   (app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))
  (env (() ())))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: pair? (env ()))
clos/con:
	'((letrec (... cdr (pair? (-> (λ (pair?-v) ...) <-)) debug-trace ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  (app cons (-> (app (app id f) (app car lst)) <-) (app lp (app cdr lst)))
  (env (() ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: (app cons 9 (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: pair?-d (env (())))
clos/con:
	'((con
   cons
   (app cons (-> 2 <-) (app cons 3 (app nil)))
   (app cons 2 (-> (app cons 3 (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 8 <-) (app cons 9 (app nil)))
   (app cons 8 (-> (app cons 9 (app nil)) <-)))
  (env ()))
	'((con cons (app cons (-> 3 <-) (app nil)) (app cons 3 (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 9 <-) (app nil)) (app cons 9 (-> (app nil) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: xx (env (())))
clos/con:
	'((app id (-> (λ (a) ...) <-)) (env ()))
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: cdr-v (env (())))
clos/con:
	'((con
   cons
   (app cons (-> 1 <-) (app cons 2 (app cons 3 (app nil))))
   (app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 2 <-) (app cons 3 (app nil)))
   (app cons 2 (-> (app cons 3 (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 7 <-) (app cons 8 (app cons 9 (app nil))))
   (app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 8 <-) (app cons 9 (app nil)))
   (app cons 8 (-> (app cons 9 (app nil)) <-)))
  (env ()))
	'((con cons (app cons (-> 3 <-) (app nil)) (app cons 3 (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 9 <-) (app nil)) (app cons 9 (-> (app nil) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons (-> 3 <-) (app nil)) (env ()))
clos/con: ⊥
literals: '(3 ⊥ ⊥ ⊥)

'(store: my-map (env ()))
clos/con:
	'((letrec (... id (my-map (-> (λ (f l) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons 2 (-> (app cons 3 (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons (-> 3 <-) (app nil)) (app cons 3 (-> (app nil) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: cdr-c (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: car-d (env (())))
clos/con:
	'((con
   cons
   (app cons (-> 2 <-) (app cons 3 (app nil)))
   (app cons 2 (-> (app cons 3 (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 8 <-) (app cons 9 (app nil)))
   (app cons 8 (-> (app cons 9 (app nil)) <-)))
  (env ()))
	'((con cons (app cons (-> 3 <-) (app nil)) (app cons 3 (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 9 <-) (app nil)) (app cons 9 (-> (app nil) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: pair?-c (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: lp (env (())))
clos/con:
	'((letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...) (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons (-> 7 <-) (app cons 8 (app cons 9 (app nil)))) (env ()))
clos/con: ⊥
literals: '(7 ⊥ ⊥ ⊥)

'(store: pair?-v (env (())))
clos/con:
	'((con
   cons
   (app cons (-> 1 <-) (app cons 2 (app cons 3 (app nil))))
   (app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 2 <-) (app cons 3 (app nil)))
   (app cons 2 (-> (app cons 3 (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 7 <-) (app cons 8 (app cons 9 (app nil))))
   (app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 8 <-) (app cons 9 (app nil)))
   (app cons 8 (-> (app cons 9 (app nil)) <-)))
  (env ()))
	'((con cons (app cons (-> 3 <-) (app nil)) (app cons 3 (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 9 <-) (app nil)) (app cons 9 (-> (app nil) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons (-> 1 <-) (app cons 2 (app cons 3 (app nil)))) (env ()))
clos/con: ⊥
literals: '(1 ⊥ ⊥ ⊥)

'(store: (app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-)) (env ()))
clos/con:
	'((con
   cons
   (app cons (-> 8 <-) (app cons 9 (app nil)))
   (app cons 8 (-> (app cons 9 (app nil)) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: car-c (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(store:
  (app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-))
  (env (() ())))
clos/con:
	'((con
   cons
   (app cons (-> (app (app id f) (app car lst)) <-) (app lp (app cdr lst)))
   (app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))
  (env (() ())))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: lst (env (() ())))
clos/con:
	'((con
   cons
   (app cons (-> 1 <-) (app cons 2 (app cons 3 (app nil))))
   (app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 2 <-) (app cons 3 (app nil)))
   (app cons 2 (-> (app cons 3 (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 7 <-) (app cons 8 (app cons 9 (app nil))))
   (app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 8 <-) (app cons 9 (app nil)))
   (app cons 8 (-> (app cons 9 (app nil)) <-)))
  (env ()))
	'((con cons (app cons (-> 3 <-) (app nil)) (app cons 3 (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 9 <-) (app nil)) (app cons 9 (-> (app nil) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-)) (env ()))
clos/con:
	'((con
   cons
   (app cons (-> 2 <-) (app cons 3 (app nil)))
   (app cons 2 (-> (app cons 3 (app nil)) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: car (env ()))
clos/con:
	'((letrec (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: _ (env (())))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: cdr-d (env (())))
clos/con:
	'((con
   cons
   (app cons (-> 2 <-) (app cons 3 (app nil)))
   (app cons 2 (-> (app cons 3 (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 8 <-) (app cons 9 (app nil)))
   (app cons 8 (-> (app cons 9 (app nil)) <-)))
  (env ()))
	'((con cons (app cons (-> 3 <-) (app nil)) (app cons 3 (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 9 <-) (app nil)) (app cons 9 (-> (app nil) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)
