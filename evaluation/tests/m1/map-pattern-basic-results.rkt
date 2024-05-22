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
  (env
   (((letrec (lp) (-> (app lp l) <-)))
    ((letrec*
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
      ...)))))
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
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app id (-> (λ (b) ...) <-)) (env ()))
clos/con:
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (b) (-> (app + 1 b) <-)) (env ((□? (b)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app + 1 (-> b <-)) (env ((□? (b)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app + (-> 1 <-) b) (env ((□? (b)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app (-> + <-) 1 b) (env ((□? (b)))))
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
  (env
   (((letrec (lp) (-> (app lp l) <-)))
    ((letrec*
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
      ...)))))
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
literals: '(⊥ ⊥ ⊥)

'(query: (app id (-> (λ (a) ...) <-)) (env ()))
clos/con:
	'((app id (-> (λ (a) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (a) (-> (app + 1 a) <-)) (env ((□? (a)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app + 1 (-> a <-)) (env ((□? (a)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app + (-> 1 <-) a) (env ((□? (a)))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app (-> + <-) 1 a) (env ((□? (a)))))
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

'(query: (λ (f l) (-> (let (_) ...) <-)) (env ((□? (f l)))))
clos/con:
	'(((top) app nil) (env ()))
	'((match
   (app not (app pair? lst))
   ((#f)
    (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
   _)
  (env
   (((letrec (lp) (-> (app lp l) <-)))
    ((letrec*
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
      ...)))))
	'((match
   (app not (app pair? lst))
   ((#f)
    (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
   _)
  (env
   (((letrec (lp) (-> (app lp l) <-)))
    ((letrec*
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
      ...)))))
	'((match
   (app not (app pair? lst))
   ((#f)
    (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
   _)
  (env (((letrec (lp) (-> (app lp l) <-))) (□? (f l)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app debug-trace) <-)) () ...) ...)
  (env ((□? (f l)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> debug-trace <-)) (env ((□? (f l)))))
clos/con:
	'((letrec* (... pair? (debug-trace (-> (λ () ...) <-)) id ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (letrec (lp) ...) <-)) (env ((□? (f l)))))
clos/con:
	'(((top) app nil) (env ()))
	'((match
   (app not (app pair? lst))
   ((#f)
    (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
   _)
  (env
   (((letrec (lp) (-> (app lp l) <-)))
    ((letrec*
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
      ...)))))
	'((match
   (app not (app pair? lst))
   ((#f)
    (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
   _)
  (env
   (((letrec (lp) (-> (app lp l) <-)))
    ((letrec*
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
      ...)))))
	'((match
   (app not (app pair? lst))
   ((#f)
    (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
   _)
  (env (((letrec (lp) (-> (app lp l) <-))) (□? (f l)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...)
  (env ((□? (f l)))))
clos/con:
	'((letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...) (env ((□? (f l)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (lst) (-> (match (app not (app pair? lst)) ...) <-))
  (env ((□? (lst)) (□? (f l)))))
clos/con:
	'(((top) app nil) (env ()))
	'((match
   (app not (app pair? lst))
   ((#f)
    (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
   _)
  (env
   (((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))
    ((letrec*
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
      ...)))))
	'((match
   (app not (app pair? lst))
   ((#f)
    (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
   _)
  (env
   (((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))
    ((letrec*
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
      ...)))))
	'((match
   (app not (app pair? lst))
   ((#f)
    (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
   _)
  (env
   (((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))
    (□? (f l)))))
	'((match
   (app not (app pair? lst))
   ((#f)
    (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
   _)
  (env
   (((letrec (lp) (-> (app lp l) <-)))
    ((letrec*
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
      ...)))))
	'((match
   (app not (app pair? lst))
   ((#f)
    (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
   _)
  (env
   (((letrec (lp) (-> (app lp l) <-)))
    ((letrec*
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
      ...)))))
	'((match
   (app not (app pair? lst))
   ((#f)
    (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
   _)
  (env
   ((□? (lst))
    ((letrec*
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
      ...)))))
	'((match
   (app not (app pair? lst))
   ((#f)
    (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
   _)
  (env
   ((□? (lst))
    ((letrec*
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
      ...)))))
	'((match
   (app not (app pair? lst))
   ((#f)
    (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
   _)
  (env (((letrec (lp) (-> (app lp l) <-))) (□? (f l)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app not (app pair? lst)) (#f) (_ (-> (app nil) <-)))
  (env ((□? (lst)) (□? (f l)))))
clos/con:
	'(((top) app nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ((□? (lst)) (□? (f l)))))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app not (app pair? lst))
   ((#f)
    (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
   _)
  (env ((□? (lst)) (□? (f l)))))
clos/con:
	'((match
   (app not (app pair? lst))
   ((#f)
    (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
   _)
  (env ((□? (lst)) (□? (f l)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-))
  (env ((□? (lst)) (□? (f l)))))
clos/con:
	'(((top) app nil) (env ()))
	'((match
   (app not (app pair? lst))
   ((#f)
    (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
   _)
  (env
   (((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))
    ((letrec*
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
      ...)))))
	'((match
   (app not (app pair? lst))
   ((#f)
    (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
   _)
  (env
   (((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))
    ((letrec*
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
      ...)))))
	'((match
   (app not (app pair? lst))
   ((#f)
    (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
   _)
  (env
   (((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))
    (□? (f l)))))
literals: '(⊥ ⊥ ⊥)

'(query: (app lp (-> (app cdr lst) <-)) (env ((□? (lst)) (□? (f l)))))
clos/con:
	'(((top) app nil) (env ()))
	'((app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-)) (env ()))
	'((app cons 2 (-> (app cons 3 (app nil)) <-)) (env ()))
	'((app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-)) (env ()))
	'((app cons 8 (-> (app cons 9 (app nil)) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cdr (-> lst <-)) (env ((□? (lst)) (□? (f l)))))
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

'(query: (app (-> cdr <-) lst) (env ((□? (lst)) (□? (f l)))))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> lp <-) (app cdr lst)) (env ((□? (lst)) (□? (f l)))))
clos/con:
	'((letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...) (env ((□? (f l)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> (app (app id f) (app car lst)) <-) (app lp (app cdr lst)))
  (env ((□? (lst)) (□? (f l)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app (app id f) (-> (app car lst) <-)) (env ((□? (lst)) (□? (f l)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app car (-> lst <-)) (env ((□? (lst)) (□? (f l)))))
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

'(query: (app (-> car <-) lst) (env ((□? (lst)) (□? (f l)))))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> (app id f) <-) (app car lst)) (env ((□? (lst)) (□? (f l)))))
clos/con:
	'((app id (-> (λ (a) ...) <-)) (env ()))
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app id (-> f <-)) (env ((□? (lst)) (□? (f l)))))
clos/con:
	'((app id (-> (λ (a) ...) <-)) (env ()))
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> id <-) f) (env ((□? (lst)) (□? (f l)))))
clos/con:
	'((letrec* (... debug-trace (id (-> (λ (xx) ...) <-)) my-map ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> cons <-) (app (app id f) (app car lst)) (app lp (app cdr lst)))
  (env ((□? (lst)) (□? (f l)))))
clos/con:
	'((app (-> cons <-) (app (app id f) (app car lst)) (app lp (app cdr lst)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app not (app pair? lst)) <-) (#f) _)
  (env ((□? (lst)) (□? (f l)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app not (-> (app pair? lst) <-)) (env ((□? (lst)) (□? (f l)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app pair? (-> lst <-)) (env ((□? (lst)) (□? (f l)))))
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

'(query: (app (-> pair? <-) lst) (env ((□? (lst)) (□? (f l)))))
clos/con:
	'((letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) debug-trace ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> not <-) (app pair? lst)) (env ((□? (lst)) (□? (f l)))))
clos/con:
	'((prim not) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (letrec (lp) (-> (app lp l) <-)) (env ((□? (f l)))))
clos/con:
	'(((top) app nil) (env ()))
	'((match
   (app not (app pair? lst))
   ((#f)
    (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
   _)
  (env
   (((letrec (lp) (-> (app lp l) <-)))
    ((letrec*
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
      ...)))))
	'((match
   (app not (app pair? lst))
   ((#f)
    (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
   _)
  (env
   (((letrec (lp) (-> (app lp l) <-)))
    ((letrec*
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
      ...)))))
	'((match
   (app not (app pair? lst))
   ((#f)
    (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
   _)
  (env (((letrec (lp) (-> (app lp l) <-))) (□? (f l)))))
literals: '(⊥ ⊥ ⊥)

'(query: (app lp (-> l <-)) (env ((□? (f l)))))
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

'(query: (app (-> lp <-) l) (env ((□? (f l)))))
clos/con:
	'((letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...) (env ((□? (f l)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... debug-trace (id (-> (λ (xx) ...) <-)) my-map ...) ...)
  (env ()))
clos/con:
	'((letrec* (... debug-trace (id (-> (λ (xx) ...) <-)) my-map ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (xx) (-> (let (_) ...) <-)) (env ((□? (xx)))))
clos/con:
	'((app id (-> (λ (a) ...) <-)) (env ()))
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app debug-trace) <-)) () ...) ...)
  (env ((□? (xx)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> debug-trace <-)) (env ((□? (xx)))))
clos/con:
	'((letrec* (... pair? (debug-trace (-> (λ () ...) <-)) id ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> xx <-)) (env ((□? (xx)))))
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

'(query: (λ () (-> (app #f) <-)) (env ((□? ()))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((□? ()))))
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

'(query: (λ (cdr-v) (-> (match cdr-v ...) <-)) (env ((□? (cdr-v)))))
clos/con:
	'(((top) app nil) (env ()))
	'((app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-)) (env ()))
	'((app cons 2 (-> (app cons 3 (app nil)) <-)) (env ()))
	'((app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-)) (env ()))
	'((app cons 8 (-> (app cons 9 (app nil)) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-))) (env ((□? (cdr-v)))))
clos/con:
	'(((top) app nil) (env ()))
	'((app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-)) (env ()))
	'((app cons 2 (-> (app cons 3 (app nil)) <-)) (env ()))
	'((app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-)) (env ()))
	'((app cons 8 (-> (app cons 9 (app nil)) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> cdr-v <-) (cons cdr-c cdr-d)) (env ((□? (cdr-v)))))
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

'(query: (λ (car-v) (-> (match car-v ...) <-)) (env ((□? (car-v)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (match car-v ((cons car-c car-d) (-> car-c <-))) (env ((□? (car-v)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (match (-> car-v <-) (cons car-c car-d)) (env ((□? (car-v)))))
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
