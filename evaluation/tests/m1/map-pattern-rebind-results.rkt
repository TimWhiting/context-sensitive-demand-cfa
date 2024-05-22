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
  (app
   (-> my-map <-)
   (app id (λ (b) ...))
   (app cons 7 (app cons 8 (app cons 9 (app nil)))))
  (env ()))
clos/con:
	'((letrec* (... id (my-map (-> (λ (f l) ...) <-)) ans1 ...) ...) (env ()))
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

'(query:
  (app
   my-map
   (-> (app id (λ (b) ...)) <-)
   (app cons 7 (app cons 8 (app cons 9 (app nil)))))
  (env ()))
clos/con:
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   my-map
   (app id (λ (a) ...))
   (-> (app cons 1 (app cons 2 (app cons 3 (app nil)))) <-))
  (env ()))
clos/con:
	'((con
   cons
   (app
    my-map
    (app id (λ (a) ...))
    (-> (app cons 1 (app cons 2 (app cons 3 (app nil)))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   my-map
   (app id (λ (b) ...))
   (-> (app cons 7 (app cons 8 (app cons 9 (app nil)))) <-))
  (env ()))
clos/con:
	'((con
   cons
   (app
    my-map
    (app id (λ (b) ...))
    (-> (app cons 7 (app cons 8 (app cons 9 (app nil)))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> #f <-))
  (env ((let (... () (_ (-> (app debug-trace) <-)) () ...) ...))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> #f <-))
  (env ((let (... () (_ (-> (app debug-trace) <-)) () ...) ...))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> (app id f) <-) (app car lst))
  (env
   ((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))))
clos/con:
	'((app id (-> (λ (a) ...) <-)) (env ()))
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> (app id f) <-) (app car lst))
  (env ((letrec (lp) (-> (app lp l) <-)))))
clos/con:
	'((app id (-> (λ (a) ...) <-)) (env ()))
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> + <-) 1 a)
  (env
   ((app cons (-> (app (app id f) (app car lst)) <-) (app lp (app cdr lst))))))
clos/con:
	'((prim +)
  (env
   ((app cons (-> (app (app id f) (app car lst)) <-) (app lp (app cdr lst))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> + <-) 1 b)
  (env
   ((app cons (-> (app (app id f) (app car lst)) <-) (app lp (app cdr lst))))))
clos/con:
	'((prim +)
  (env
   ((app cons (-> (app (app id f) (app car lst)) <-) (app lp (app cdr lst))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> car <-) lst)
  (env
   ((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> cdr <-) lst)
  (env
   ((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> cons <-) (app (app id f) (app car lst)) (app lp (app cdr lst)))
  (env
   ((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))))
clos/con:
	'((app (-> cons <-) (app (app id f) (app car lst)) (app lp (app cdr lst)))
  (env
   ((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> cons <-) (app (app id f) (app car lst)) (app lp (app cdr lst)))
  (env ((letrec (lp) (-> (app lp l) <-)))))
clos/con:
	'((app (-> cons <-) (app (app id f) (app car lst)) (app lp (app cdr lst)))
  (env ((letrec (lp) (-> (app lp l) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> debug-trace <-))
  (env
   ((app
     my-map
     (-> (app id (λ (a) ...)) <-)
     (app cons 1 (app cons 2 (app cons 3 (app nil))))))))
clos/con:
	'((letrec* (... pair? (debug-trace (-> (λ () ...) <-)) id ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> debug-trace <-))
  (env
   ((app
     my-map
     (-> (app id (λ (b) ...)) <-)
     (app cons 7 (app cons 8 (app cons 9 (app nil))))))))
clos/con:
	'((letrec* (... pair? (debug-trace (-> (λ () ...) <-)) id ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> debug-trace <-))
  (env
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
     ...))))
clos/con:
	'((letrec* (... pair? (debug-trace (-> (λ () ...) <-)) id ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> debug-trace <-))
  (env
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
     ...))))
clos/con:
	'((letrec* (... pair? (debug-trace (-> (λ () ...) <-)) id ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> debug-trace <-))
  (env ((app (-> (app id f) <-) (app car lst)))))
clos/con:
	'((letrec* (... pair? (debug-trace (-> (λ () ...) <-)) id ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> id <-) f)
  (env
   ((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))))
clos/con:
	'((letrec* (... debug-trace (id (-> (λ (xx) ...) <-)) my-map ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> lp <-) (app cdr lst))
  (env
   ((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))))
clos/con:
	'((letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...)
  (env
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
     ...))))
	'((letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...)
  (env
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
     ...))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> lp <-) (app cdr lst))
  (env ((letrec (lp) (-> (app lp l) <-)))))
clos/con:
	'((letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...)
  (env
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
     ...))))
	'((letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...)
  (env
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
     ...))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> lp <-) l)
  (env
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
     ...))))
clos/con:
	'((letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...)
  (env
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
     ...))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> lp <-) l)
  (env
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
     ...))))
clos/con:
	'((letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...)
  (env
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
     ...))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> nil <-))
  (env
   ((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))))
clos/con:
	'((app (-> nil <-))
  (env
   ((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> not <-) (app pair? lst))
  (env
   ((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))))
clos/con:
	'((prim not)
  (env
   ((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> not <-) (app pair? lst))
  (env ((letrec (lp) (-> (app lp l) <-)))))
clos/con:
	'((prim not) (env ((letrec (lp) (-> (app lp l) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> pair? <-) lst)
  (env
   ((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))))
clos/con:
	'((letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) debug-trace ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (app id f) (-> (app car lst) <-))
  (env
   ((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app (app id f) (-> (app car lst) <-))
  (env ((letrec (lp) (-> (app lp l) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app + (-> 1 <-) a)
  (env
   ((app cons (-> (app (app id f) (app car lst)) <-) (app lp (app cdr lst))))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (app + (-> 1 <-) b)
  (env
   ((app cons (-> (app (app id f) (app car lst)) <-) (app lp (app cdr lst))))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (app + 1 (-> a <-))
  (env
   ((app cons (-> (app (app id f) (app car lst)) <-) (app lp (app cdr lst))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app + 1 (-> b <-))
  (env
   ((app cons (-> (app (app id f) (app car lst)) <-) (app lp (app cdr lst))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app car (-> lst <-))
  (env
   ((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))))
clos/con:
	'((con cons (app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-))) (env ()))
	'((con cons (app cons 2 (-> (app cons 3 (app nil)) <-))) (env ()))
	'((con cons (app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-))) (env ()))
	'((con cons (app cons 8 (-> (app cons 9 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cdr (-> lst <-))
  (env
   ((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))))
clos/con:
	'((con cons (app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-))) (env ()))
	'((con cons (app cons 2 (-> (app cons 3 (app nil)) <-))) (env ()))
	'((con cons (app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-))) (env ()))
	'((con cons (app cons 8 (-> (app cons 9 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> (app (app id f) (app car lst)) <-) (app lp (app cdr lst)))
  (env
   ((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app cons (-> (app (app id f) (app car lst)) <-) (app lp (app cdr lst)))
  (env ((letrec (lp) (-> (app lp l) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-))
  (env
   ((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))))
clos/con:
	'((con
   cons
   (match
    (app not (app pair? lst))
    ((#f)
     (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
    _))
  (env
   ((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-))
  (env ((letrec (lp) (-> (app lp l) <-)))))
clos/con:
	'((con
   cons
   (match
    (app not (app pair? lst))
    ((#f)
     (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
    _))
  (env
   ((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app id (-> f <-))
  (env
   ((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))))
clos/con:
	'((app id (-> (λ (a) ...) <-)) (env ()))
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app lp (-> (app cdr lst) <-))
  (env
   ((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))))
clos/con:
	'((con cons (app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-))) (env ()))
	'((con cons (app cons 2 (-> (app cons 3 (app nil)) <-))) (env ()))
	'((con cons (app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-))) (env ()))
	'((con cons (app cons 8 (-> (app cons 9 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app lp (-> (app cdr lst) <-))
  (env ((letrec (lp) (-> (app lp l) <-)))))
clos/con:
	'((con cons (app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-))) (env ()))
	'((con cons (app cons 2 (-> (app cons 3 (app nil)) <-))) (env ()))
	'((con cons (app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-))) (env ()))
	'((con cons (app cons 8 (-> (app cons 9 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app lp (-> l <-))
  (env
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
     ...))))
clos/con:
	'((con
   cons
   (app
    my-map
    (app id (λ (b) ...))
    (-> (app cons 7 (app cons 8 (app cons 9 (app nil)))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app lp (-> l <-))
  (env
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
     ...))))
clos/con:
	'((con
   cons
   (app
    my-map
    (app id (λ (a) ...))
    (-> (app cons 1 (app cons 2 (app cons 3 (app nil)))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app not (-> (app pair? lst) <-))
  (env
   ((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app not (-> (app pair? lst) <-))
  (env ((letrec (lp) (-> (app lp l) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app pair? (-> lst <-))
  (env
   ((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))))
clos/con:
	'((con cons (app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-))) (env ()))
	'((con cons (app cons 2 (-> (app cons 3 (app nil)) <-))) (env ()))
	'((con cons (app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-))) (env ()))
	'((con cons (app cons 8 (-> (app cons 9 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app debug-trace) <-)) () ...) ...)
  (env
   ((app
     my-map
     (-> (app id (λ (a) ...)) <-)
     (app cons 1 (app cons 2 (app cons 3 (app nil))))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app debug-trace) <-)) () ...) ...)
  (env
   ((app
     my-map
     (-> (app id (λ (b) ...)) <-)
     (app cons 7 (app cons 8 (app cons 9 (app nil))))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app debug-trace) <-)) () ...) ...)
  (env
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
     ...))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app debug-trace) <-)) () ...) ...)
  (env
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
     ...))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app debug-trace) <-)) () ...) ...)
  (env ((app (-> (app id f) <-) (app car lst)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (_) (-> (letrec (lp) ...) <-))
  (env
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
     ...))))
clos/con:
	'((con
   cons
   (match
    (app not (app pair? lst))
    ((#f)
     (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
    _))
  (env ((letrec (lp) (-> (app lp l) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (_) (-> (letrec (lp) ...) <-))
  (env
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
     ...))))
clos/con:
	'((con
   cons
   (match
    (app not (app pair? lst))
    ((#f)
     (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
    _))
  (env ((letrec (lp) (-> (app lp l) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (_) (-> xx <-))
  (env
   ((app
     my-map
     (-> (app id (λ (a) ...)) <-)
     (app cons 1 (app cons 2 (app cons 3 (app nil))))))))
clos/con:
	'((app id (-> (λ (a) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (_) (-> xx <-))
  (env
   ((app
     my-map
     (-> (app id (λ (b) ...)) <-)
     (app cons 7 (app cons 8 (app cons 9 (app nil))))))))
clos/con:
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...)
  (env
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
     ...))))
clos/con:
	'((letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...)
  (env
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
     ...))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...)
  (env
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
     ...))))
clos/con:
	'((letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...)
  (env
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
     ...))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec (lp) (-> (app lp l) <-))
  (env
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
     ...))))
clos/con:
	'((con
   cons
   (match
    (app not (app pair? lst))
    ((#f)
     (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
    _))
  (env ((letrec (lp) (-> (app lp l) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec (lp) (-> (app lp l) <-))
  (env
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
     ...))))
clos/con:
	'((con
   cons
   (match
    (app not (app pair? lst))
    ((#f)
     (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
    _))
  (env ((letrec (lp) (-> (app lp l) <-)))))
	'((con nil) (env ()))
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
	'((con
   cons
   (match
    (app not (app pair? lst))
    ((#f)
     (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
    _))
  (env ((letrec (lp) (-> (app lp l) <-)))))
	'((con nil) (env ()))
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
	'((con
   cons
   (match
    (app not (app pair? lst))
    ((#f)
     (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
    _))
  (env ((letrec (lp) (-> (app lp l) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) debug-trace ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) debug-trace ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... debug-trace (id (-> (λ (xx) ...) <-)) my-map ...) ...)
  (env ()))
clos/con:
	'((letrec* (... debug-trace (id (-> (λ (xx) ...) <-)) my-map ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... id (my-map (-> (λ (f l) ...) <-)) ans1 ...) ...)
  (env ()))
clos/con:
	'((letrec* (... id (my-map (-> (λ (f l) ...) <-)) ans1 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... pair? (debug-trace (-> (λ () ...) <-)) id ...) ...)
  (env ()))
clos/con:
	'((letrec* (... pair? (debug-trace (-> (λ () ...) <-)) id ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app not (app pair? lst))
   ((#f)
    (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
   _)
  (env
   ((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))))
clos/con:
	'((con
   cons
   (match
    (app not (app pair? lst))
    ((#f)
     (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
    _))
  (env
   ((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app not (app pair? lst))
   ((#f)
    (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
   _)
  (env ((letrec (lp) (-> (app lp l) <-)))))
clos/con:
	'((con
   cons
   (match
    (app not (app pair? lst))
    ((#f)
     (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
    _))
  (env ((letrec (lp) (-> (app lp l) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app not (app pair? lst)) <-) (#f) _)
  (env
   ((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app not (app pair? lst)) <-) (#f) _)
  (env ((letrec (lp) (-> (app lp l) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> car-v <-) (cons car-c car-d))
  (env ((app (app id f) (-> (app car lst) <-)))))
clos/con:
	'((con
   cons
   (app
    my-map
    (app id (λ (a) ...))
    (-> (app cons 1 (app cons 2 (app cons 3 (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app
    my-map
    (app id (λ (b) ...))
    (-> (app cons 7 (app cons 8 (app cons 9 (app nil)))) <-)))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-))) (env ()))
	'((con cons (app cons 2 (-> (app cons 3 (app nil)) <-))) (env ()))
	'((con cons (app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-))) (env ()))
	'((con cons (app cons 8 (-> (app cons 9 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> cdr-v <-) (cons cdr-c cdr-d))
  (env ((app lp (-> (app cdr lst) <-)))))
clos/con:
	'((con
   cons
   (app
    my-map
    (app id (λ (a) ...))
    (-> (app cons 1 (app cons 2 (app cons 3 (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app
    my-map
    (app id (λ (b) ...))
    (-> (app cons 7 (app cons 8 (app cons 9 (app nil)))) <-)))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-))) (env ()))
	'((con cons (app cons 2 (-> (app cons 3 (app nil)) <-))) (env ()))
	'((con cons (app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-))) (env ()))
	'((con cons (app cons 8 (-> (app cons 9 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> pair?-v <-) (cons pair?-c pair?-d) _)
  (env ((app not (-> (app pair? lst) <-)))))
clos/con:
	'((con
   cons
   (app
    my-map
    (app id (λ (a) ...))
    (-> (app cons 1 (app cons 2 (app cons 3 (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app
    my-map
    (app id (λ (b) ...))
    (-> (app cons 7 (app cons 8 (app cons 9 (app nil)))) <-)))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-))) (env ()))
	'((con cons (app cons 2 (-> (app cons 3 (app nil)) <-))) (env ()))
	'((con cons (app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-))) (env ()))
	'((con cons (app cons 8 (-> (app cons 9 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app not (app pair? lst)) (#f) (_ (-> (app nil) <-)))
  (env
   ((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app not (app pair? lst)) (#f) (_ (-> (app nil) <-)))
  (env ((letrec (lp) (-> (app lp l) <-)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match car-v ((cons car-c car-d) (-> car-c <-)))
  (env ((app (app id f) (-> (app car lst) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-)))
  (env ((app lp (-> (app cdr lst) <-)))))
clos/con:
	'((con cons (app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-))) (env ()))
	'((con cons (app cons 2 (-> (app cons 3 (app nil)) <-))) (env ()))
	'((con cons (app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-))) (env ()))
	'((con cons (app cons 8 (-> (app cons 9 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match pair?-v ((cons pair?-c pair?-d) (-> (app #t) <-)) _)
  (env ((app not (-> (app pair? lst) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match pair?-v (cons pair?-c pair?-d) (_ (-> (app #f) <-)))
  (env ((app not (-> (app pair? lst) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ () (-> (app #f) <-))
  (env ((let (... () (_ (-> (app debug-trace) <-)) () ...) ...))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ () (-> (app #f) <-))
  (env ((let (... () (_ (-> (app debug-trace) <-)) () ...) ...))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (a) (-> (app + 1 a) <-))
  (env
   ((app cons (-> (app (app id f) (app car lst)) <-) (app lp (app cdr lst))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (b) (-> (app + 1 b) <-))
  (env
   ((app cons (-> (app (app id f) (app car lst)) <-) (app lp (app cdr lst))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (car-v) (-> (match car-v ...) <-))
  (env ((app (app id f) (-> (app car lst) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (cdr-v) (-> (match cdr-v ...) <-))
  (env ((app lp (-> (app cdr lst) <-)))))
clos/con:
	'((con cons (app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-))) (env ()))
	'((con cons (app cons 2 (-> (app cons 3 (app nil)) <-))) (env ()))
	'((con cons (app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-))) (env ()))
	'((con cons (app cons 8 (-> (app cons 9 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (f l) (-> (let (_) ...) <-))
  (env
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
     ...))))
clos/con:
	'((con
   cons
   (match
    (app not (app pair? lst))
    ((#f)
     (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
    _))
  (env ((letrec (lp) (-> (app lp l) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (f l) (-> (let (_) ...) <-))
  (env
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
     ...))))
clos/con:
	'((con
   cons
   (match
    (app not (app pair? lst))
    ((#f)
     (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
    _))
  (env ((letrec (lp) (-> (app lp l) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (lst) (-> (match (app not (app pair? lst)) ...) <-))
  (env
   ((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))))
clos/con:
	'((con
   cons
   (match
    (app not (app pair? lst))
    ((#f)
     (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
    _))
  (env
   ((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (lst) (-> (match (app not (app pair? lst)) ...) <-))
  (env ((letrec (lp) (-> (app lp l) <-)))))
clos/con:
	'((con
   cons
   (match
    (app not (app pair? lst))
    ((#f)
     (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
    _))
  (env ((letrec (lp) (-> (app lp l) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (pair?-v) (-> (match pair?-v ...) <-))
  (env ((app not (-> (app pair? lst) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (xx) (-> (let (_) ...) <-))
  (env
   ((app
     my-map
     (-> (app id (λ (a) ...)) <-)
     (app cons 1 (app cons 2 (app cons 3 (app nil))))))))
clos/con:
	'((app id (-> (λ (a) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (xx) (-> (let (_) ...) <-))
  (env
   ((app
     my-map
     (-> (app id (λ (b) ...)) <-)
     (app cons 7 (app cons 8 (app cons 9 (app nil))))))))
clos/con:
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (xx) (-> (let (_) ...) <-))
  (env ((app (-> (app id f) <-) (app car lst)))))
clos/con:
	'((app id (-> (λ (a) ...) <-)) (env ()))
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: ((top) lettypes (cons ... nil) ...) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((app not (-> (app pair? lst) <-)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ((app not (-> (app pair? lst) <-)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> car <-) lst) (env ((letrec (lp) (-> (app lp l) <-)))))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cdr <-) lst) (env ((letrec (lp) (-> (app lp l) <-)))))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 1 (app cons 2 (app cons 3 (app nil)))) (env ()))
clos/con:
	'((app (-> cons <-) 1 (app cons 2 (app cons 3 (app nil)))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 2 (app cons 3 (app nil))) (env ()))
clos/con:
	'((app (-> cons <-) 2 (app cons 3 (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 3 (app nil)) (env ()))
clos/con:
	'((app (-> cons <-) 3 (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 7 (app cons 8 (app cons 9 (app nil)))) (env ()))
clos/con:
	'((app (-> cons <-) 7 (app cons 8 (app cons 9 (app nil)))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 8 (app cons 9 (app nil))) (env ()))
clos/con:
	'((app (-> cons <-) 8 (app cons 9 (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 9 (app nil)) (env ()))
clos/con:
	'((app (-> cons <-) 9 (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> id <-) (λ (a) ...)) (env ()))
clos/con:
	'((letrec* (... debug-trace (id (-> (λ (xx) ...) <-)) my-map ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> id <-) (λ (b) ...)) (env ()))
clos/con:
	'((letrec* (... debug-trace (id (-> (λ (xx) ...) <-)) my-map ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> id <-) f) (env ((letrec (lp) (-> (app lp l) <-)))))
clos/con:
	'((letrec* (... debug-trace (id (-> (λ (xx) ...) <-)) my-map ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ((letrec (lp) (-> (app lp l) <-)))))
clos/con:
	'((app (-> nil <-)) (env ((letrec (lp) (-> (app lp l) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> pair? <-) lst) (env ((letrec (lp) (-> (app lp l) <-)))))
clos/con:
	'((letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) debug-trace ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> void <-)) (env ()))
clos/con:
	'((prim void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app car (-> lst <-)) (env ((letrec (lp) (-> (app lp l) <-)))))
clos/con:
	'((con
   cons
   (app
    my-map
    (app id (λ (a) ...))
    (-> (app cons 1 (app cons 2 (app cons 3 (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app
    my-map
    (app id (λ (b) ...))
    (-> (app cons 7 (app cons 8 (app cons 9 (app nil)))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cdr (-> lst <-)) (env ((letrec (lp) (-> (app lp l) <-)))))
clos/con:
	'((con
   cons
   (app
    my-map
    (app id (λ (a) ...))
    (-> (app cons 1 (app cons 2 (app cons 3 (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app
    my-map
    (app id (λ (b) ...))
    (-> (app cons 7 (app cons 8 (app cons 9 (app nil)))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> 1 <-) (app cons 2 (app cons 3 (app nil)))) (env ()))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app cons (-> 2 <-) (app cons 3 (app nil))) (env ()))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query: (app cons (-> 3 <-) (app nil)) (env ()))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(query: (app cons (-> 7 <-) (app cons 8 (app cons 9 (app nil)))) (env ()))
clos/con: ⊥
literals: '(7 ⊥ ⊥)

'(query: (app cons (-> 8 <-) (app cons 9 (app nil))) (env ()))
clos/con: ⊥
literals: '(8 ⊥ ⊥)

'(query: (app cons (-> 9 <-) (app nil)) (env ()))
clos/con: ⊥
literals: '(9 ⊥ ⊥)

'(query: (app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-)) (env ()))
clos/con:
	'((con cons (app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 2 (-> (app cons 3 (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons 2 (-> (app cons 3 (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 3 (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-)) (env ()))
clos/con:
	'((con cons (app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 8 (-> (app cons 9 (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons 8 (-> (app cons 9 (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 9 (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app id (-> (λ (a) ...) <-)) (env ()))
clos/con:
	'((app id (-> (λ (a) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app id (-> (λ (b) ...) <-)) (env ()))
clos/con:
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app id (-> f <-)) (env ((letrec (lp) (-> (app lp l) <-)))))
clos/con:
	'((app id (-> (λ (a) ...) <-)) (env ()))
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app pair? (-> lst <-)) (env ((letrec (lp) (-> (app lp l) <-)))))
clos/con:
	'((con
   cons
   (app
    my-map
    (app id (λ (a) ...))
    (-> (app cons 1 (app cons 2 (app cons 3 (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app
    my-map
    (app id (λ (b) ...))
    (-> (app cons 7 (app cons 8 (app cons 9 (app nil)))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> xx <-)) (env ((app (-> (app id f) <-) (app car lst)))))
clos/con:
	'((app id (-> (λ (a) ...) <-)) (env ()))
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (letrec* (car ... ans2) (-> (app void) <-)) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (lettypes cons ... nil (letrec* (car ... ans2) ...)) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ((app (app id f) (app car lst)))
    ()
    (match-clause
     (#f)
     (app not (app pair? lst))
     ()
     ((_ (app nil)))
     (bod
      (lst)
      (bin
       letrec
       lp
       (app lp l)
       ()
       ()
       (let-bod
        let
        ((_ (app debug-trace)))
        (bod
         (f l)
         (bin
          letrec*
          my-map
          (app void)
          ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
           (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
           (pair?
            (λ (pair?-v)
              (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
           (debug-trace (λ () (app #f)))
           (id (λ (xx) (let ((_ (app debug-trace))) xx))))
          ((ans1
            (app
             my-map
             (app id (λ (a) (app + 1 a)))
             (app cons 1 (app cons 2 (app cons 3 (app nil))))))
           (ans2
            (app
             my-map
             (app id (λ (b) (app + 1 b)))
             (app cons 7 (app cons 8 (app cons 9 (app nil)))))))
          (lettypes-bod ((cons car cdr) (nil)) (top)))))))))
   app
   lp
   (app cdr lst))
  con
  (env
   ((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))))
clos/con:
	'((con
   cons
   (match
    (app not (app pair? lst))
    ((#f)
     (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
    _))
  (env
   ((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ((app (app id f) (app car lst)))
    ()
    (match-clause
     (#f)
     (app not (app pair? lst))
     ()
     ((_ (app nil)))
     (bod
      (lst)
      (bin
       letrec
       lp
       (app lp l)
       ()
       ()
       (let-bod
        let
        ((_ (app debug-trace)))
        (bod
         (f l)
         (bin
          letrec*
          my-map
          (app void)
          ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
           (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
           (pair?
            (λ (pair?-v)
              (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
           (debug-trace (λ () (app #f)))
           (id (λ (xx) (let ((_ (app debug-trace))) xx))))
          ((ans1
            (app
             my-map
             (app id (λ (a) (app + 1 a)))
             (app cons 1 (app cons 2 (app cons 3 (app nil))))))
           (ans2
            (app
             my-map
             (app id (λ (b) (app + 1 b)))
             (app cons 7 (app cons 8 (app cons 9 (app nil)))))))
          (lettypes-bod ((cons car cdr) (nil)) (top)))))))))
   app
   lp
   (app cdr lst))
  con
  (env ((letrec (lp) (-> (app lp l) <-)))))
clos/con:
	'((con
   cons
   (match
    (app not (app pair? lst))
    ((#f)
     (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
    _))
  (env
   ((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app cons 2 (app cons 3 (app nil))))
    (ran
     my-map
     ((app id (λ (a) (app + 1 a))))
     ()
     (bin
      letrec*
      ans1
      (app void)
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
              (app lp l))))))
      ((ans2
        (app
         my-map
         (app id (λ (b) (app + 1 b)))
         (app cons 7 (app cons 8 (app cons 9 (app nil)))))))
      (lettypes-bod ((cons car cdr) (nil)) (top)))))
   .
   1)
  con
  (env ()))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app cons 3 (app nil)))
    (ran
     cons
     (1)
     ()
     (ran
      my-map
      ((app id (λ (a) (app + 1 a))))
      ()
      (bin
       letrec*
       ans1
       (app void)
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
               (app lp l))))))
       ((ans2
         (app
          my-map
          (app id (λ (b) (app + 1 b)))
          (app cons 7 (app cons 8 (app cons 9 (app nil)))))))
       (lettypes-bod ((cons car cdr) (nil)) (top))))))
   .
   2)
  con
  (env ()))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app cons 8 (app cons 9 (app nil))))
    (ran
     my-map
     ((app id (λ (b) (app + 1 b))))
     ()
     (bin
      letrec*
      ans2
      (app void)
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
         (app cons 1 (app cons 2 (app cons 3 (app nil)))))))
      ()
      (lettypes-bod ((cons car cdr) (nil)) (top)))))
   .
   7)
  con
  (env ()))
clos/con: ⊥
literals: '(7 ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app cons 9 (app nil)))
    (ran
     cons
     (7)
     ()
     (ran
      my-map
      ((app id (λ (b) (app + 1 b))))
      ()
      (bin
       letrec*
       ans2
       (app void)
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
          (app cons 1 (app cons 2 (app cons 3 (app nil)))))))
       ()
       (lettypes-bod ((cons car cdr) (nil)) (top))))))
   .
   8)
  con
  (env ()))
clos/con: ⊥
literals: '(8 ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app lp (app cdr lst)))
    (match-clause
     (#f)
     (app not (app pair? lst))
     ()
     ((_ (app nil)))
     (bod
      (lst)
      (bin
       letrec
       lp
       (app lp l)
       ()
       ()
       (let-bod
        let
        ((_ (app debug-trace)))
        (bod
         (f l)
         (bin
          letrec*
          my-map
          (app void)
          ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
           (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
           (pair?
            (λ (pair?-v)
              (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
           (debug-trace (λ () (app #f)))
           (id (λ (xx) (let ((_ (app debug-trace))) xx))))
          ((ans1
            (app
             my-map
             (app id (λ (a) (app + 1 a)))
             (app cons 1 (app cons 2 (app cons 3 (app nil))))))
           (ans2
            (app
             my-map
             (app id (λ (b) (app + 1 b)))
             (app cons 7 (app cons 8 (app cons 9 (app nil)))))))
          (lettypes-bod ((cons car cdr) (nil)) (top)))))))))
   app
   (app id f)
   (app car lst))
  con
  (env
   ((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app lp (app cdr lst)))
    (match-clause
     (#f)
     (app not (app pair? lst))
     ()
     ((_ (app nil)))
     (bod
      (lst)
      (bin
       letrec
       lp
       (app lp l)
       ()
       ()
       (let-bod
        let
        ((_ (app debug-trace)))
        (bod
         (f l)
         (bin
          letrec*
          my-map
          (app void)
          ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
           (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
           (pair?
            (λ (pair?-v)
              (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
           (debug-trace (λ () (app #f)))
           (id (λ (xx) (let ((_ (app debug-trace))) xx))))
          ((ans1
            (app
             my-map
             (app id (λ (a) (app + 1 a)))
             (app cons 1 (app cons 2 (app cons 3 (app nil))))))
           (ans2
            (app
             my-map
             (app id (λ (b) (app + 1 b)))
             (app cons 7 (app cons 8 (app cons 9 (app nil)))))))
          (lettypes-bod ((cons car cdr) (nil)) (top)))))))))
   app
   (app id f)
   (app car lst))
  con
  (env ((letrec (lp) (-> (app lp l) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app nil))
    (ran
     cons
     (2)
     ()
     (ran
      cons
      (1)
      ()
      (ran
       my-map
       ((app id (λ (a) (app + 1 a))))
       ()
       (bin
        letrec*
        ans1
        (app void)
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
                (app lp l))))))
        ((ans2
          (app
           my-map
           (app id (λ (b) (app + 1 b)))
           (app cons 7 (app cons 8 (app cons 9 (app nil)))))))
        (lettypes-bod ((cons car cdr) (nil)) (top)))))))
   .
   3)
  con
  (env ()))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app nil))
    (ran
     cons
     (8)
     ()
     (ran
      cons
      (7)
      ()
      (ran
       my-map
       ((app id (λ (b) (app + 1 b))))
       ()
       (bin
        letrec*
        ans2
        (app void)
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
           (app cons 1 (app cons 2 (app cons 3 (app nil)))))))
        ()
        (lettypes-bod ((cons car cdr) (nil)) (top)))))))
   .
   9)
  con
  (env ()))
clos/con: ⊥
literals: '(9 ⊥ ⊥)

'(store:
  ((ran
    cons
    (1)
    ()
    (ran
     my-map
     ((app id (λ (a) (app + 1 a))))
     ()
     (bin
      letrec*
      ans1
      (app void)
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
              (app lp l))))))
      ((ans2
        (app
         my-map
         (app id (λ (b) (app + 1 b)))
         (app cons 7 (app cons 8 (app cons 9 (app nil)))))))
      (lettypes-bod ((cons car cdr) (nil)) (top)))))
   app
   cons
   2
   (app cons 3 (app nil)))
  con
  (env ()))
clos/con:
	'((con cons (app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

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
      my-map
      ((app id (λ (a) (app + 1 a))))
      ()
      (bin
       letrec*
       ans1
       (app void)
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
               (app lp l))))))
       ((ans2
         (app
          my-map
          (app id (λ (b) (app + 1 b)))
          (app cons 7 (app cons 8 (app cons 9 (app nil)))))))
       (lettypes-bod ((cons car cdr) (nil)) (top))))))
   app
   cons
   3
   (app nil))
  con
  (env ()))
clos/con:
	'((con cons (app cons 2 (-> (app cons 3 (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    (3)
    ()
    (ran
     cons
     (2)
     ()
     (ran
      cons
      (1)
      ()
      (ran
       my-map
       ((app id (λ (a) (app + 1 a))))
       ()
       (bin
        letrec*
        ans1
        (app void)
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
                (app lp l))))))
        ((ans2
          (app
           my-map
           (app id (λ (b) (app + 1 b)))
           (app cons 7 (app cons 8 (app cons 9 (app nil)))))))
        (lettypes-bod ((cons car cdr) (nil)) (top)))))))
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
    (7)
    ()
    (ran
     my-map
     ((app id (λ (b) (app + 1 b))))
     ()
     (bin
      letrec*
      ans2
      (app void)
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
         (app cons 1 (app cons 2 (app cons 3 (app nil)))))))
      ()
      (lettypes-bod ((cons car cdr) (nil)) (top)))))
   app
   cons
   8
   (app cons 9 (app nil)))
  con
  (env ()))
clos/con:
	'((con cons (app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    (8)
    ()
    (ran
     cons
     (7)
     ()
     (ran
      my-map
      ((app id (λ (b) (app + 1 b))))
      ()
      (bin
       letrec*
       ans2
       (app void)
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
          (app cons 1 (app cons 2 (app cons 3 (app nil)))))))
       ()
       (lettypes-bod ((cons car cdr) (nil)) (top))))))
   app
   cons
   9
   (app nil))
  con
  (env ()))
clos/con:
	'((con cons (app cons 8 (-> (app cons 9 (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    (9)
    ()
    (ran
     cons
     (8)
     ()
     (ran
      cons
      (7)
      ()
      (ran
       my-map
       ((app id (λ (b) (app + 1 b))))
       ()
       (bin
        letrec*
        ans2
        (app void)
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
           (app cons 1 (app cons 2 (app cons 3 (app nil)))))))
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
  +
  (app id (-> (λ (a) ...) <-))
  (env
   ((app cons (-> (app (app id f) (app car lst)) <-) (app lp (app cdr lst))))))
clos/con:
	'((λ (a) (-> (app + 1 a) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  +
  (app id (-> (λ (b) ...) <-))
  (env
   ((app cons (-> (app (app id f) (app car lst)) <-) (app lp (app cdr lst))))))
clos/con:
	'((λ (b) (-> (app + 1 b) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  _
  (letrec* (... debug-trace (id (-> (λ (xx) ...) <-)) my-map ...) ...)
  (env
   ((app
     my-map
     (-> (app id (λ (a) ...)) <-)
     (app cons 1 (app cons 2 (app cons 3 (app nil))))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  _
  (letrec* (... debug-trace (id (-> (λ (xx) ...) <-)) my-map ...) ...)
  (env
   ((app
     my-map
     (-> (app id (λ (b) ...)) <-)
     (app cons 7 (app cons 8 (app cons 9 (app nil))))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  _
  (letrec* (... debug-trace (id (-> (λ (xx) ...) <-)) my-map ...) ...)
  (env ((app (-> (app id f) <-) (app car lst)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  _
  (letrec* (... id (my-map (-> (λ (f l) ...) <-)) ans1 ...) ...)
  (env
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
     ...))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  _
  (letrec* (... id (my-map (-> (λ (f l) ...) <-)) ans1 ...) ...)
  (env
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
     ...))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  a
  (app id (-> (λ (a) ...) <-))
  (env
   ((app cons (-> (app (app id f) (app car lst)) <-) (app lp (app cdr lst))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  b
  (app id (-> (λ (b) ...) <-))
  (env
   ((app cons (-> (app (app id f) (app car lst)) <-) (app lp (app cdr lst))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  car
  (letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...)
  (env
   ((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car
  (letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...)
  (env ((letrec (lp) (-> (app lp l) <-)))))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car
  (letrec* (... id (my-map (-> (λ (f l) ...) <-)) ans1 ...) ...)
  (env
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
     ...))))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car
  (letrec* (... id (my-map (-> (λ (f l) ...) <-)) ans1 ...) ...)
  (env
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
     ...))))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car-c
  (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...)
  (env ((app (app id f) (-> (app car lst) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  car-d
  (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...)
  (env ((app (app id f) (-> (app car lst) <-)))))
clos/con:
	'((con cons (app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-))) (env ()))
	'((con cons (app cons 2 (-> (app cons 3 (app nil)) <-))) (env ()))
	'((con cons (app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-))) (env ()))
	'((con cons (app cons 8 (-> (app cons 9 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car-v
  (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...)
  (env ((app (app id f) (-> (app car lst) <-)))))
clos/con:
	'((con
   cons
   (app
    my-map
    (app id (λ (a) ...))
    (-> (app cons 1 (app cons 2 (app cons 3 (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app
    my-map
    (app id (λ (b) ...))
    (-> (app cons 7 (app cons 8 (app cons 9 (app nil)))) <-)))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-))) (env ()))
	'((con cons (app cons 2 (-> (app cons 3 (app nil)) <-))) (env ()))
	'((con cons (app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-))) (env ()))
	'((con cons (app cons 8 (-> (app cons 9 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr
  (letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...)
  (env
   ((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr
  (letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...)
  (env ((letrec (lp) (-> (app lp l) <-)))))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr
  (letrec* (... id (my-map (-> (λ (f l) ...) <-)) ans1 ...) ...)
  (env
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
     ...))))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr
  (letrec* (... id (my-map (-> (λ (f l) ...) <-)) ans1 ...) ...)
  (env
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
     ...))))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr-c
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...)
  (env ((app lp (-> (app cdr lst) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  cdr-d
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...)
  (env ((app lp (-> (app cdr lst) <-)))))
clos/con:
	'((con cons (app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-))) (env ()))
	'((con cons (app cons 2 (-> (app cons 3 (app nil)) <-))) (env ()))
	'((con cons (app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-))) (env ()))
	'((con cons (app cons 8 (-> (app cons 9 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr-v
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...)
  (env ((app lp (-> (app cdr lst) <-)))))
clos/con:
	'((con
   cons
   (app
    my-map
    (app id (λ (a) ...))
    (-> (app cons 1 (app cons 2 (app cons 3 (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app
    my-map
    (app id (λ (b) ...))
    (-> (app cons 7 (app cons 8 (app cons 9 (app nil)))) <-)))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-))) (env ()))
	'((con cons (app cons 2 (-> (app cons 3 (app nil)) <-))) (env ()))
	'((con cons (app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-))) (env ()))
	'((con cons (app cons 8 (-> (app cons 9 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cons
  (letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...)
  (env
   ((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))))
clos/con:
	'((λ (lst) (-> (match (app not (app pair? lst)) ...) <-))
  (env
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
     ...))))
	'((λ (lst) (-> (match (app not (app pair? lst)) ...) <-))
  (env
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
     ...))))
literals: '(⊥ ⊥ ⊥)

'(store:
  cons
  (letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...)
  (env ((letrec (lp) (-> (app lp l) <-)))))
clos/con:
	'((λ (lst) (-> (match (app not (app pair? lst)) ...) <-))
  (env
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
     ...))))
	'((λ (lst) (-> (match (app not (app pair? lst)) ...) <-))
  (env
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
     ...))))
literals: '(⊥ ⊥ ⊥)

'(store:
  cons
  (letrec* (... id (my-map (-> (λ (f l) ...) <-)) ans1 ...) ...)
  (env
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
     ...))))
clos/con:
	'((λ (f l) (-> (let (_) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cons
  (letrec* (... id (my-map (-> (λ (f l) ...) <-)) ans1 ...) ...)
  (env
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
     ...))))
clos/con:
	'((λ (f l) (-> (let (_) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  debug-trace
  (letrec* (... debug-trace (id (-> (λ (xx) ...) <-)) my-map ...) ...)
  (env
   ((app
     my-map
     (-> (app id (λ (a) ...)) <-)
     (app cons 1 (app cons 2 (app cons 3 (app nil))))))))
clos/con:
	'((letrec* (... pair? (debug-trace (-> (λ () ...) <-)) id ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  debug-trace
  (letrec* (... debug-trace (id (-> (λ (xx) ...) <-)) my-map ...) ...)
  (env
   ((app
     my-map
     (-> (app id (λ (b) ...)) <-)
     (app cons 7 (app cons 8 (app cons 9 (app nil))))))))
clos/con:
	'((letrec* (... pair? (debug-trace (-> (λ () ...) <-)) id ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  debug-trace
  (letrec* (... debug-trace (id (-> (λ (xx) ...) <-)) my-map ...) ...)
  (env ((app (-> (app id f) <-) (app car lst)))))
clos/con:
	'((letrec* (... pair? (debug-trace (-> (λ () ...) <-)) id ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  debug-trace
  (letrec* (... id (my-map (-> (λ (f l) ...) <-)) ans1 ...) ...)
  (env
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
     ...))))
clos/con:
	'((letrec* (... pair? (debug-trace (-> (λ () ...) <-)) id ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  debug-trace
  (letrec* (... id (my-map (-> (λ (f l) ...) <-)) ans1 ...) ...)
  (env
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
     ...))))
clos/con:
	'((letrec* (... pair? (debug-trace (-> (λ () ...) <-)) id ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  f
  (letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...)
  (env
   ((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))))
clos/con:
	'((app id (-> (λ (a) ...) <-)) (env ()))
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  f
  (letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...)
  (env ((letrec (lp) (-> (app lp l) <-)))))
clos/con:
	'((app id (-> (λ (a) ...) <-)) (env ()))
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  f
  (letrec* (... id (my-map (-> (λ (f l) ...) <-)) ans1 ...) ...)
  (env
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
     ...))))
clos/con:
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  f
  (letrec* (... id (my-map (-> (λ (f l) ...) <-)) ans1 ...) ...)
  (env
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
     ...))))
clos/con:
	'((app id (-> (λ (a) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  id
  (letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...)
  (env
   ((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))))
clos/con:
	'((letrec* (... debug-trace (id (-> (λ (xx) ...) <-)) my-map ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  id
  (letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...)
  (env ((letrec (lp) (-> (app lp l) <-)))))
clos/con:
	'((letrec* (... debug-trace (id (-> (λ (xx) ...) <-)) my-map ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  id
  (letrec* (... id (my-map (-> (λ (f l) ...) <-)) ans1 ...) ...)
  (env
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
     ...))))
clos/con:
	'((letrec* (... debug-trace (id (-> (λ (xx) ...) <-)) my-map ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  id
  (letrec* (... id (my-map (-> (λ (f l) ...) <-)) ans1 ...) ...)
  (env
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
     ...))))
clos/con:
	'((letrec* (... debug-trace (id (-> (λ (xx) ...) <-)) my-map ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  l
  (letrec* (... id (my-map (-> (λ (f l) ...) <-)) ans1 ...) ...)
  (env
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
     ...))))
clos/con:
	'((con
   cons
   (app
    my-map
    (app id (λ (b) ...))
    (-> (app cons 7 (app cons 8 (app cons 9 (app nil)))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  l
  (letrec* (... id (my-map (-> (λ (f l) ...) <-)) ans1 ...) ...)
  (env
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
     ...))))
clos/con:
	'((con
   cons
   (app
    my-map
    (app id (λ (a) ...))
    (-> (app cons 1 (app cons 2 (app cons 3 (app nil)))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  lp
  (letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...)
  (env
   ((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))))
clos/con:
	'((letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...)
  (env
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
     ...))))
	'((letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...)
  (env
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
     ...))))
literals: '(⊥ ⊥ ⊥)

'(store:
  lp
  (letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...)
  (env ((letrec (lp) (-> (app lp l) <-)))))
clos/con:
	'((letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...)
  (env
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
     ...))))
	'((letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...)
  (env
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
     ...))))
literals: '(⊥ ⊥ ⊥)

'(store:
  lp
  (letrec* (... id (my-map (-> (λ (f l) ...) <-)) ans1 ...) ...)
  (env
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
     ...))))
clos/con:
	'((letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...)
  (env
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
     ...))))
literals: '(⊥ ⊥ ⊥)

'(store:
  lp
  (letrec* (... id (my-map (-> (λ (f l) ...) <-)) ans1 ...) ...)
  (env
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
     ...))))
clos/con:
	'((letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...)
  (env
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
     ...))))
literals: '(⊥ ⊥ ⊥)

'(store:
  lst
  (letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...)
  (env
   ((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))))
clos/con:
	'((con cons (app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-))) (env ()))
	'((con cons (app cons 2 (-> (app cons 3 (app nil)) <-))) (env ()))
	'((con cons (app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-))) (env ()))
	'((con cons (app cons 8 (-> (app cons 9 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  lst
  (letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...)
  (env ((letrec (lp) (-> (app lp l) <-)))))
clos/con:
	'((con
   cons
   (app
    my-map
    (app id (λ (a) ...))
    (-> (app cons 1 (app cons 2 (app cons 3 (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app
    my-map
    (app id (λ (b) ...))
    (-> (app cons 7 (app cons 8 (app cons 9 (app nil)))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  nil
  (letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...)
  (env
   ((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))))
clos/con:
	'((λ (lst) (-> (match (app not (app pair? lst)) ...) <-))
  (env
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
     ...))))
	'((λ (lst) (-> (match (app not (app pair? lst)) ...) <-))
  (env
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
     ...))))
literals: '(⊥ ⊥ ⊥)

'(store:
  nil
  (letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...)
  (env ((letrec (lp) (-> (app lp l) <-)))))
clos/con:
	'((λ (lst) (-> (match (app not (app pair? lst)) ...) <-))
  (env
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
     ...))))
	'((λ (lst) (-> (match (app not (app pair? lst)) ...) <-))
  (env
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
     ...))))
literals: '(⊥ ⊥ ⊥)

'(store:
  nil
  (letrec* (... id (my-map (-> (λ (f l) ...) <-)) ans1 ...) ...)
  (env
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
     ...))))
clos/con:
	'((λ (f l) (-> (let (_) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  nil
  (letrec* (... id (my-map (-> (λ (f l) ...) <-)) ans1 ...) ...)
  (env
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
     ...))))
clos/con:
	'((λ (f l) (-> (let (_) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  not
  (letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...)
  (env
   ((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))))
clos/con:
	'((λ (lst) (-> (match (app not (app pair? lst)) ...) <-))
  (env
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
     ...))))
	'((λ (lst) (-> (match (app not (app pair? lst)) ...) <-))
  (env
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
     ...))))
literals: '(⊥ ⊥ ⊥)

'(store:
  not
  (letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...)
  (env ((letrec (lp) (-> (app lp l) <-)))))
clos/con:
	'((λ (lst) (-> (match (app not (app pair? lst)) ...) <-))
  (env
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
     ...))))
	'((λ (lst) (-> (match (app not (app pair? lst)) ...) <-))
  (env
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
     ...))))
literals: '(⊥ ⊥ ⊥)

'(store:
  not
  (letrec* (... id (my-map (-> (λ (f l) ...) <-)) ans1 ...) ...)
  (env
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
     ...))))
clos/con:
	'((λ (f l) (-> (let (_) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  not
  (letrec* (... id (my-map (-> (λ (f l) ...) <-)) ans1 ...) ...)
  (env
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
     ...))))
clos/con:
	'((λ (f l) (-> (let (_) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pair?
  (letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...)
  (env
   ((app cons (app (app id f) (app car lst)) (-> (app lp (app cdr lst)) <-)))))
clos/con:
	'((letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) debug-trace ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pair?
  (letrec (... () (lp (-> (λ (lst) ...) <-)) () ...) ...)
  (env ((letrec (lp) (-> (app lp l) <-)))))
clos/con:
	'((letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) debug-trace ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pair?
  (letrec* (... id (my-map (-> (λ (f l) ...) <-)) ans1 ...) ...)
  (env
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
     ...))))
clos/con:
	'((letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) debug-trace ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pair?
  (letrec* (... id (my-map (-> (λ (f l) ...) <-)) ans1 ...) ...)
  (env
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
     ...))))
clos/con:
	'((letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) debug-trace ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pair?-c
  (letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) debug-trace ...) ...)
  (env ((app not (-> (app pair? lst) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  pair?-d
  (letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) debug-trace ...) ...)
  (env ((app not (-> (app pair? lst) <-)))))
clos/con:
	'((con cons (app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-))) (env ()))
	'((con cons (app cons 2 (-> (app cons 3 (app nil)) <-))) (env ()))
	'((con cons (app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-))) (env ()))
	'((con cons (app cons 8 (-> (app cons 9 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pair?-v
  (letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) debug-trace ...) ...)
  (env ((app not (-> (app pair? lst) <-)))))
clos/con:
	'((con
   cons
   (app
    my-map
    (app id (λ (a) ...))
    (-> (app cons 1 (app cons 2 (app cons 3 (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app
    my-map
    (app id (λ (b) ...))
    (-> (app cons 7 (app cons 8 (app cons 9 (app nil)))) <-)))
  (env ()))
	'((con cons (app cons 1 (-> (app cons 2 (app cons 3 (app nil))) <-))) (env ()))
	'((con cons (app cons 2 (-> (app cons 3 (app nil)) <-))) (env ()))
	'((con cons (app cons 7 (-> (app cons 8 (app cons 9 (app nil))) <-))) (env ()))
	'((con cons (app cons 8 (-> (app cons 9 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  xx
  (letrec* (... debug-trace (id (-> (λ (xx) ...) <-)) my-map ...) ...)
  (env
   ((app
     my-map
     (-> (app id (λ (a) ...)) <-)
     (app cons 1 (app cons 2 (app cons 3 (app nil))))))))
clos/con:
	'((app id (-> (λ (a) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  xx
  (letrec* (... debug-trace (id (-> (λ (xx) ...) <-)) my-map ...) ...)
  (env
   ((app
     my-map
     (-> (app id (λ (b) ...)) <-)
     (app cons 7 (app cons 8 (app cons 9 (app nil))))))))
clos/con:
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  xx
  (letrec* (... debug-trace (id (-> (λ (xx) ...) <-)) my-map ...) ...)
  (env ((app (-> (app id f) <-) (app car lst)))))
clos/con:
	'((app id (-> (λ (a) ...) <-)) (env ()))
	'((app id (-> (λ (b) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: ans1 ((top) lettypes (cons ... nil) ...) (env ()))
clos/con:
	'((con
   cons
   (match
    (app not (app pair? lst))
    ((#f)
     (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
    _))
  (env ((letrec (lp) (-> (app lp l) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: ans2 ((top) lettypes (cons ... nil) ...) (env ()))
clos/con:
	'((con
   cons
   (match
    (app not (app pair? lst))
    ((#f)
     (-> (app cons (app (app id f) (app car lst)) (app lp (app cdr lst))) <-))
    _))
  (env ((letrec (lp) (-> (app lp l) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: car ((top) lettypes (cons ... nil) ...) (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: cdr ((top) lettypes (cons ... nil) ...) (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: debug-trace ((top) lettypes (cons ... nil) ...) (env ()))
clos/con:
	'((letrec* (... pair? (debug-trace (-> (λ () ...) <-)) id ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: id ((top) lettypes (cons ... nil) ...) (env ()))
clos/con:
	'((letrec* (... debug-trace (id (-> (λ (xx) ...) <-)) my-map ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: my-map ((top) lettypes (cons ... nil) ...) (env ()))
clos/con:
	'((letrec* (... id (my-map (-> (λ (f l) ...) <-)) ans1 ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: pair? ((top) lettypes (cons ... nil) ...) (env ()))
clos/con:
	'((letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) debug-trace ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)
