'(expression:
  (lettypes
   ((cons car cdr) (nil))
   (letrec*
    ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
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
            (app lp l)))))
     (ans1
      (app
       my-map
       (app id (λ (a) (app + 1 a)))
       (app cons 1 (app cons 2 (app cons 3 (app nil))))))
     (ans2
      (app
       my-map
       (app id (λ (b) (app + 1 b)))
       (app cons 7 (app cons 8 (app cons 9 (app nil)))))))
    (app void))))

'(query: ((top) lettypes (cons ... nil) ...) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (lettypes cons ... nil (letrec* (car ... ans2) ...)) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    ans1
    (ans2
     (->
      (app
       my-map
       (app id (λ (b) ...))
       (app cons 7 (app cons 8 (app cons 9 (app nil)))))
      <-))
    ()
    ...)
   ...)
  (env ()))
clos/con:
	'(((top) app nil) (env ()))
	'((match
   (app not (app pair? lst))
   ((#f)
    (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
   _)
  (env (() ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   my-map
   (app id (λ (b) ...))
   (-> (app cons 7 (app cons 8 (app cons 9 (app nil)))) <-))
  (env ()))
clos/con:
	'((app
   my-map
   (app id (λ (b) ...))
   (-> (app cons 7 (app cons 8 (app cons 9 (app nil)))) <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-)) (env ()))
clos/con:
	'((app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 8 (-> (app cons 9 (app nil)) <-)) (env ()))
clos/con:
	'((app cons 8 (-> (app cons 9 (app nil)) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 9 (-> (app nil) <-)) (env ()))
clos/con:
	'(((top) app nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> 9 <-) (app nil)) (env ()))
clos/con: ⊥
literals: '(9 ⊥ ⊥)

'(query: (app (-> cons <-) 9 (app nil)) (env ()))
clos/con:
	'((app (-> cons <-) 9 (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> 8 <-) (app cons 9 (app nil))) (env ()))
clos/con: ⊥
literals: '(8 ⊥ ⊥)

'(query: (app (-> cons <-) 8 (app cons 9 (app nil))) (env ()))
clos/con:
	'((app (-> cons <-) 8 (app cons 9 (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> 7 <-) (app cons 8 (app cons 9 (app nil)))) (env ()))
clos/con: ⊥
literals: '(7 ⊥ ⊥)

'(query: (app (-> cons <-) 7 (app cons 8 (app cons 9 (app nil)))) (env ()))
clos/con:
	'((app (-> cons <-) 7 (app cons 8 (app cons 9 (app nil)))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   my-map
   (-> (app id (λ (b) ...)) <-)
   (app cons 7 (app cons 8 (app cons 9 (app nil)))))
  (env ()))
clos/con:
	'((app id (-> (λ (a) ...) <-)) (env ()))
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app id (-> (λ (b) ...) <-)) (env ()))
clos/con:
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (b) (-> (app + 1 b) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app + 1 (-> b <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app + (-> 1 <-) b) (env (())))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app (-> + <-) 1 b) (env (())))
clos/con:
	'((prim +) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> id <-) (λ (b) ...)) (env ()))
clos/con:
	'((letrec* (... debug-trace (id (-> (λ (xx) ...) <-)) my-map ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   (-> my-map <-)
   (app id (λ (b) ...))
   (app cons 7 (app cons 8 (app cons 9 (app nil)))))
  (env ()))
clos/con:
	'((letrec* (... id (my-map (-> (λ (f l) ...) <-)) ans1 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    my-map
    (ans1
     (->
      (app
       my-map
       (app id (λ (a) ...))
       (app cons 1 (app cons 2 (app cons 3 (app nil)))))
      <-))
    ans2
    ...)
   ...)
  (env ()))
clos/con:
	'(((top) app nil) (env ()))
	'((match
   (app not (app pair? lst))
   ((#f)
    (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
   _)
  (env (() ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   my-map
   (app id (λ (a) ...))
   (-> (app cons 1 (app cons 2 (app cons 3 (app nil)))) <-))
  (env ()))
clos/con:
	'((app
   my-map
   (app id (λ (a) ...))
   (-> (app cons 1 (app cons 2 (app cons 3 (app nil)))) <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-)) (env ()))
clos/con:
	'((app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 2 (-> (app cons 3 (app nil)) <-)) (env ()))
clos/con:
	'((app cons 2 (-> (app cons 3 (app nil)) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 3 (-> (app nil) <-)) (env ()))
clos/con:
	'(((top) app nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> 3 <-) (app nil)) (env ()))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(query: (app (-> cons <-) 3 (app nil)) (env ()))
clos/con:
	'((app (-> cons <-) 3 (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> 2 <-) (app cons 3 (app nil))) (env ()))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query: (app (-> cons <-) 2 (app cons 3 (app nil))) (env ()))
clos/con:
	'((app (-> cons <-) 2 (app cons 3 (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> 1 <-) (app cons 2 (app cons 3 (app nil)))) (env ()))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app (-> cons <-) 1 (app cons 2 (app cons 3 (app nil)))) (env ()))
clos/con:
	'((app (-> cons <-) 1 (app cons 2 (app cons 3 (app nil)))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   my-map
   (-> (app id (λ (a) ...)) <-)
   (app cons 1 (app cons 2 (app cons 3 (app nil)))))
  (env ()))
clos/con:
	'((app id (-> (λ (a) ...) <-)) (env ()))
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app id (-> (λ (a) ...) <-)) (env ()))
clos/con:
	'((app id (-> (λ (a) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (a) (-> (app + 1 a) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app + 1 (-> a <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app + (-> 1 <-) a) (env (())))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app (-> + <-) 1 a) (env (())))
clos/con:
	'((prim +) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> id <-) (λ (a) ...)) (env ()))
clos/con:
	'((letrec* (... debug-trace (id (-> (λ (xx) ...) <-)) my-map ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   (-> my-map <-)
   (app id (λ (a) ...))
   (app cons 1 (app cons 2 (app cons 3 (app nil)))))
  (env ()))
clos/con:
	'((letrec* (... id (my-map (-> (λ (f l) ...) <-)) ans1 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... id (my-map (-> (λ (f l) ...) <-)) ans1 ...) ...)
  (env ()))
clos/con:
	'((letrec* (... id (my-map (-> (λ (f l) ...) <-)) ans1 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (f l) (-> (let (_) ...) <-)) (env (())))
clos/con:
	'(((top) app nil) (env ()))
	'((match
   (app not (app pair? lst))
   ((#f)
    (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
   _)
  (env (() ())))
literals: '(⊥ ⊥ ⊥)

'(query: (let (... () (_ (-> (app debug-trace) <-)) () ...) ...) (env (())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> debug-trace <-)) (env (())))
clos/con:
	'((letrec* (... pair? (debug-trace (-> (λ () ...) <-)) id ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (letrec (lp) ...) <-)) (env (())))
clos/con:
	'(((top) app nil) (env ()))
	'((match
   (app not (app pair? lst))
   ((#f)
    (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
   _)
  (env (() ())))
literals: '(⊥ ⊥ ⊥)

'(query: (letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...) (env (())))
clos/con:
	'((letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (lst) (-> (match (app not (app pair? lst)) ...) <-)) (env (() ())))
clos/con:
	'(((top) app nil) (env ()))
	'((match
   (app not (app pair? lst))
   ((#f)
    (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
   _)
  (env (() ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app not (app pair? lst)) (#f) (_ (-> (app nil) <-)))
  (env (() ())))
clos/con:
	'(((top) app nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env (() ())))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app not (app pair? lst))
   ((#f)
    (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
   _)
  (env (() ())))
clos/con:
	'((match
   (app not (app pair? lst))
   ((#f)
    (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
   _)
  (env (() ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-))
  (env (() ())))
clos/con:
	'(((top) app nil) (env ()))
	'((match
   (app not (app pair? lst))
   ((#f)
    (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
   _)
  (env (() ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app lp (-> (app cdr lst) <-)) (env (() ())))
clos/con:
	'(((top) app nil) (env ()))
	'((app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-)) (env ()))
	'((app cons 2 (-> (app cons 3 (app nil)) <-)) (env ()))
	'((app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-)) (env ()))
	'((app cons 8 (-> (app cons 9 (app nil)) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cdr (-> lst <-)) (env (() ())))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   my-map
   (app id (λ (a) ...))
   (-> (app cons 1 (app cons 2 (app cons 3 (app nil)))) <-))
  (env ()))
	'((app
   my-map
   (app id (λ (b) ...))
   (-> (app cons 7 (app cons 8 (app cons 9 (app nil)))) <-))
  (env ()))
	'((app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-)) (env ()))
	'((app cons 2 (-> (app cons 3 (app nil)) <-)) (env ()))
	'((app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-)) (env ()))
	'((app cons 8 (-> (app cons 9 (app nil)) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cdr <-) lst) (env (() ())))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> lp <-) (app cdr lst)) (env (() ())))
clos/con:
	'((letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> (app (app id f) (app car lst)) <-) (app lp (app cdr lst)))
  (env (() ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (app id f) (-> (app car lst) <-)) (env (() ())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app car (-> lst <-)) (env (() ())))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   my-map
   (app id (λ (a) ...))
   (-> (app cons 1 (app cons 2 (app cons 3 (app nil)))) <-))
  (env ()))
	'((app
   my-map
   (app id (λ (b) ...))
   (-> (app cons 7 (app cons 8 (app cons 9 (app nil)))) <-))
  (env ()))
	'((app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-)) (env ()))
	'((app cons 2 (-> (app cons 3 (app nil)) <-)) (env ()))
	'((app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-)) (env ()))
	'((app cons 8 (-> (app cons 9 (app nil)) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> car <-) lst) (env (() ())))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> (app id f) <-) (app car lst)) (env (() ())))
clos/con:
	'((app id (-> (λ (a) ...) <-)) (env ()))
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app id (-> f <-)) (env (() ())))
clos/con:
	'((app id (-> (λ (a) ...) <-)) (env ()))
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> id <-) f) (env (() ())))
clos/con:
	'((letrec* (... debug-trace (id (-> (λ (xx) ...) <-)) my-map ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> cons <-) (app (app id f) (app car lst)) (app lp (app cdr lst)))
  (env (() ())))
clos/con:
	'((app (-> cons <-) (app (app id f) (app car lst)) (app lp (app cdr lst)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app not (app pair? lst)) <-) (#f) _) (env (() ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app not (-> (app pair? lst) <-)) (env (() ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app pair? (-> lst <-)) (env (() ())))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   my-map
   (app id (λ (a) ...))
   (-> (app cons 1 (app cons 2 (app cons 3 (app nil)))) <-))
  (env ()))
	'((app
   my-map
   (app id (λ (b) ...))
   (-> (app cons 7 (app cons 8 (app cons 9 (app nil)))) <-))
  (env ()))
	'((app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-)) (env ()))
	'((app cons 2 (-> (app cons 3 (app nil)) <-)) (env ()))
	'((app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-)) (env ()))
	'((app cons 8 (-> (app cons 9 (app nil)) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> pair? <-) lst) (env (() ())))
clos/con:
	'((letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) debug-trace ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> not <-) (app pair? lst)) (env (() ())))
clos/con:
	'((prim not) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (letrec (lp) (-> (app lp l) <-)) (env (())))
clos/con:
	'(((top) app nil) (env ()))
	'((match
   (app not (app pair? lst))
   ((#f)
    (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
   _)
  (env (() ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app lp (-> l <-)) (env (())))
clos/con:
	'((app
   my-map
   (app id (λ (a) ...))
   (-> (app cons 1 (app cons 2 (app cons 3 (app nil)))) <-))
  (env ()))
	'((app
   my-map
   (app id (λ (b) ...))
   (-> (app cons 7 (app cons 8 (app cons 9 (app nil)))) <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> lp <-) l) (env (())))
clos/con:
	'((letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... debug-trace (id (-> (λ (xx) ...) <-)) my-map ...) ...)
  (env ()))
clos/con:
	'((letrec* (... debug-trace (id (-> (λ (xx) ...) <-)) my-map ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (xx) (-> (let (_) ...) <-)) (env (())))
clos/con:
	'((app id (-> (λ (a) ...) <-)) (env ()))
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (... () (_ (-> (app debug-trace) <-)) () ...) ...) (env (())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> debug-trace <-)) (env (())))
clos/con:
	'((letrec* (... pair? (debug-trace (-> (λ () ...) <-)) id ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> xx <-)) (env (())))
clos/con:
	'((app id (-> (λ (a) ...) <-)) (env ()))
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... pair? (debug-trace (-> (λ () ...) <-)) id ...) ...)
  (env ()))
clos/con:
	'((letrec* (... pair? (debug-trace (-> (λ () ...) <-)) id ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ () (-> (app #f) <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) debug-trace ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) debug-trace ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (pair?-v) (-> (match pair?-v ...) <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match pair?-v (cons pair?-c pair?-d) (_ (-> (app #f) <-)))
  (env (())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match pair?-v ((cons pair?-c pair?-d) (-> (app #t) <-)) _)
  (env (())))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> pair?-v <-) (cons pair?-c pair?-d) _) (env (())))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   my-map
   (app id (λ (a) ...))
   (-> (app cons 1 (app cons 2 (app cons 3 (app nil)))) <-))
  (env ()))
	'((app
   my-map
   (app id (λ (b) ...))
   (-> (app cons 7 (app cons 8 (app cons 9 (app nil)))) <-))
  (env ()))
	'((app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-)) (env ()))
	'((app cons 2 (-> (app cons 3 (app nil)) <-)) (env ()))
	'((app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-)) (env ()))
	'((app cons 8 (-> (app cons 9 (app nil)) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (cdr-v) (-> (match cdr-v ...) <-)) (env (())))
clos/con:
	'(((top) app nil) (env ()))
	'((app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-)) (env ()))
	'((app cons 2 (-> (app cons 3 (app nil)) <-)) (env ()))
	'((app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-)) (env ()))
	'((app cons 8 (-> (app cons 9 (app nil)) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-))) (env (())))
clos/con:
	'(((top) app nil) (env ()))
	'((app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-)) (env ()))
	'((app cons 2 (-> (app cons 3 (app nil)) <-)) (env ()))
	'((app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-)) (env ()))
	'((app cons 8 (-> (app cons 9 (app nil)) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> cdr-v <-) (cons cdr-c cdr-d)) (env (())))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   my-map
   (app id (λ (a) ...))
   (-> (app cons 1 (app cons 2 (app cons 3 (app nil)))) <-))
  (env ()))
	'((app
   my-map
   (app id (λ (b) ...))
   (-> (app cons 7 (app cons 8 (app cons 9 (app nil)))) <-))
  (env ()))
	'((app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-)) (env ()))
	'((app cons 2 (-> (app cons 3 (app nil)) <-)) (env ()))
	'((app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-)) (env ()))
	'((app cons 8 (-> (app cons 9 (app nil)) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (car-v) (-> (match car-v ...) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (match car-v ((cons car-c car-d) (-> car-c <-))) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (match (-> car-v <-) (cons car-c car-d)) (env (())))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   my-map
   (app id (λ (a) ...))
   (-> (app cons 1 (app cons 2 (app cons 3 (app nil)))) <-))
  (env ()))
	'((app
   my-map
   (app id (λ (b) ...))
   (-> (app cons 7 (app cons 8 (app cons 9 (app nil)))) <-))
  (env ()))
	'((app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-)) (env ()))
	'((app cons 2 (-> (app cons 3 (app nil)) <-)) (env ()))
	'((app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-)) (env ()))
	'((app cons 8 (-> (app cons 9 (app nil)) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (letrec* (car ... ans2) (-> (app void) <-)) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> void <-)) (env ()))
clos/con:
	'((prim void) (env ()))
literals: '(⊥ ⊥ ⊥)
