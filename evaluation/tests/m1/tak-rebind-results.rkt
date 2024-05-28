'(expression:
  (letrec*
   ((tak
     (λ (x y z)
       (match
        (app not (app < y x))
        ((#f)
         (app
          tak
          (app tak (app - x 1) y z)
          (app tak (app - y 1) z x)
          (app tak (app - z 1) x y)))
        (_ z)))))
   (app tak 32 15 8)))

'(query:
  (app
   tak
   (-> (app tak (app - x 1) y z) <-)
   (app tak (app - y 1) z x)
   (app tak (app - z 1) x y))
  (env
   ((app
     tak
     (-> (app tak (app - x 1) y z) <-)
     (app tak (app - y 1) z x)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app
   tak
   (-> (app tak (app - x 1) y z) <-)
   (app tak (app - y 1) z x)
   (app tak (app - z 1) x y))
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (-> (app tak (app - y 1) z x) <-)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app
   tak
   (-> (app tak (app - x 1) y z) <-)
   (app tak (app - y 1) z x)
   (app tak (app - z 1) x y))
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (app tak (app - y 1) z x)
     (-> (app tak (app - z 1) x y) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app
   tak
   (-> (app tak (app - x 1) y z) <-)
   (app tak (app - y 1) z x)
   (app tak (app - z 1) x y))
  (env
   ((match
     (app not (app < y x))
     ((#f)
      (->
       (app
        tak
        (app tak (app - x 1) y z)
        (app tak (app - y 1) z x)
        (app tak (app - z 1) x y))
       <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app
   tak
   (-> (app tak (app - x 1) y z) <-)
   (app tak (app - y 1) z x)
   (app tak (app - z 1) x y))
  (env ((letrec* (tak) (-> (app tak 32 15 8) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app
   tak
   (app tak (app - x 1) y z)
   (-> (app tak (app - y 1) z x) <-)
   (app tak (app - z 1) x y))
  (env
   ((app
     tak
     (-> (app tak (app - x 1) y z) <-)
     (app tak (app - y 1) z x)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app
   tak
   (app tak (app - x 1) y z)
   (-> (app tak (app - y 1) z x) <-)
   (app tak (app - z 1) x y))
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (-> (app tak (app - y 1) z x) <-)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app
   tak
   (app tak (app - x 1) y z)
   (-> (app tak (app - y 1) z x) <-)
   (app tak (app - z 1) x y))
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (app tak (app - y 1) z x)
     (-> (app tak (app - z 1) x y) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app
   tak
   (app tak (app - x 1) y z)
   (-> (app tak (app - y 1) z x) <-)
   (app tak (app - z 1) x y))
  (env
   ((match
     (app not (app < y x))
     ((#f)
      (->
       (app
        tak
        (app tak (app - x 1) y z)
        (app tak (app - y 1) z x)
        (app tak (app - z 1) x y))
       <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app
   tak
   (app tak (app - x 1) y z)
   (-> (app tak (app - y 1) z x) <-)
   (app tak (app - z 1) x y))
  (env ((letrec* (tak) (-> (app tak 32 15 8) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app
   tak
   (app tak (app - x 1) y z)
   (app tak (app - y 1) z x)
   (-> (app tak (app - z 1) x y) <-))
  (env
   ((app
     tak
     (-> (app tak (app - x 1) y z) <-)
     (app tak (app - y 1) z x)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app
   tak
   (app tak (app - x 1) y z)
   (app tak (app - y 1) z x)
   (-> (app tak (app - z 1) x y) <-))
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (-> (app tak (app - y 1) z x) <-)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app
   tak
   (app tak (app - x 1) y z)
   (app tak (app - y 1) z x)
   (-> (app tak (app - z 1) x y) <-))
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (app tak (app - y 1) z x)
     (-> (app tak (app - z 1) x y) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app
   tak
   (app tak (app - x 1) y z)
   (app tak (app - y 1) z x)
   (-> (app tak (app - z 1) x y) <-))
  (env
   ((match
     (app not (app < y x))
     ((#f)
      (->
       (app
        tak
        (app tak (app - x 1) y z)
        (app tak (app - y 1) z x)
        (app tak (app - z 1) x y))
       <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app
   tak
   (app tak (app - x 1) y z)
   (app tak (app - y 1) z x)
   (-> (app tak (app - z 1) x y) <-))
  (env ((letrec* (tak) (-> (app tak 32 15 8) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> x <-) 1)
  (env
   ((app
     tak
     (-> (app tak (app - x 1) y z) <-)
     (app tak (app - y 1) z x)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> x <-) 1)
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (-> (app tak (app - y 1) z x) <-)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> x <-) 1)
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (app tak (app - y 1) z x)
     (-> (app tak (app - z 1) x y) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> x <-) 1)
  (env
   ((match
     (app not (app < y x))
     ((#f)
      (->
       (app
        tak
        (app tak (app - x 1) y z)
        (app tak (app - y 1) z x)
        (app tak (app - z 1) x y))
       <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> y <-) 1)
  (env
   ((app
     tak
     (-> (app tak (app - x 1) y z) <-)
     (app tak (app - y 1) z x)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> y <-) 1)
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (-> (app tak (app - y 1) z x) <-)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> y <-) 1)
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (app tak (app - y 1) z x)
     (-> (app tak (app - z 1) x y) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> y <-) 1)
  (env
   ((match
     (app not (app < y x))
     ((#f)
      (->
       (app
        tak
        (app tak (app - x 1) y z)
        (app tak (app - y 1) z x)
        (app tak (app - z 1) x y))
       <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> z <-) 1)
  (env
   ((app
     tak
     (-> (app tak (app - x 1) y z) <-)
     (app tak (app - y 1) z x)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> z <-) 1)
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (-> (app tak (app - y 1) z x) <-)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> z <-) 1)
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (app tak (app - y 1) z x)
     (-> (app tak (app - z 1) x y) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> z <-) 1)
  (env
   ((match
     (app not (app < y x))
     ((#f)
      (->
       (app
        tak
        (app tak (app - x 1) y z)
        (app tak (app - y 1) z x)
        (app tak (app - z 1) x y))
       <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app < (-> y <-) x)
  (env
   ((app
     tak
     (-> (app tak (app - x 1) y z) <-)
     (app tak (app - y 1) z x)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app < (-> y <-) x)
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (-> (app tak (app - y 1) z x) <-)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app < (-> y <-) x)
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (app tak (app - y 1) z x)
     (-> (app tak (app - z 1) x y) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app < (-> y <-) x)
  (env
   ((match
     (app not (app < y x))
     ((#f)
      (->
       (app
        tak
        (app tak (app - x 1) y z)
        (app tak (app - y 1) z x)
        (app tak (app - z 1) x y))
       <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app < y (-> x <-))
  (env
   ((app
     tak
     (-> (app tak (app - x 1) y z) <-)
     (app tak (app - y 1) z x)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app < y (-> x <-))
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (-> (app tak (app - y 1) z x) <-)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app < y (-> x <-))
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (app tak (app - y 1) z x)
     (-> (app tak (app - z 1) x y) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app < y (-> x <-))
  (env
   ((match
     (app not (app < y x))
     ((#f)
      (->
       (app
        tak
        (app tak (app - x 1) y z)
        (app tak (app - y 1) z x)
        (app tak (app - z 1) x y))
       <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app not (-> (app < y x) <-))
  (env
   ((app
     tak
     (-> (app tak (app - x 1) y z) <-)
     (app tak (app - y 1) z x)
     (app tak (app - z 1) x y)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app not (-> (app < y x) <-))
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (-> (app tak (app - y 1) z x) <-)
     (app tak (app - z 1) x y)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app not (-> (app < y x) <-))
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (app tak (app - y 1) z x)
     (-> (app tak (app - z 1) x y) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app not (-> (app < y x) <-))
  (env
   ((match
     (app not (app < y x))
     ((#f)
      (->
       (app
        tak
        (app tak (app - x 1) y z)
        (app tak (app - y 1) z x)
        (app tak (app - z 1) x y))
       <-))
     _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app not (-> (app < y x) <-))
  (env ((letrec* (tak) (-> (app tak 32 15 8) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app tak (-> (app - x 1) <-) y z)
  (env
   ((app
     tak
     (-> (app tak (app - x 1) y z) <-)
     (app tak (app - y 1) z x)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (-> (app - x 1) <-) y z)
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (-> (app tak (app - y 1) z x) <-)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (-> (app - x 1) <-) y z)
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (app tak (app - y 1) z x)
     (-> (app tak (app - z 1) x y) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (-> (app - x 1) <-) y z)
  (env
   ((match
     (app not (app < y x))
     ((#f)
      (->
       (app
        tak
        (app tak (app - x 1) y z)
        (app tak (app - y 1) z x)
        (app tak (app - z 1) x y))
       <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (-> (app - x 1) <-) y z)
  (env ((letrec* (tak) (-> (app tak 32 15 8) <-)))))
clos/con: ⊥
literals: '(31 ⊥ ⊥)

'(query:
  (app tak (-> (app - y 1) <-) z x)
  (env
   ((app
     tak
     (-> (app tak (app - x 1) y z) <-)
     (app tak (app - y 1) z x)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (-> (app - y 1) <-) z x)
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (-> (app tak (app - y 1) z x) <-)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (-> (app - y 1) <-) z x)
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (app tak (app - y 1) z x)
     (-> (app tak (app - z 1) x y) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (-> (app - y 1) <-) z x)
  (env
   ((match
     (app not (app < y x))
     ((#f)
      (->
       (app
        tak
        (app tak (app - x 1) y z)
        (app tak (app - y 1) z x)
        (app tak (app - z 1) x y))
       <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (-> (app - y 1) <-) z x)
  (env ((letrec* (tak) (-> (app tak 32 15 8) <-)))))
clos/con: ⊥
literals: '(14 ⊥ ⊥)

'(query:
  (app tak (-> (app - z 1) <-) x y)
  (env
   ((app
     tak
     (-> (app tak (app - x 1) y z) <-)
     (app tak (app - y 1) z x)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (-> (app - z 1) <-) x y)
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (-> (app tak (app - y 1) z x) <-)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (-> (app - z 1) <-) x y)
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (app tak (app - y 1) z x)
     (-> (app tak (app - z 1) x y) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (-> (app - z 1) <-) x y)
  (env
   ((match
     (app not (app < y x))
     ((#f)
      (->
       (app
        tak
        (app tak (app - x 1) y z)
        (app tak (app - y 1) z x)
        (app tak (app - z 1) x y))
       <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (-> (app - z 1) <-) x y)
  (env ((letrec* (tak) (-> (app tak 32 15 8) <-)))))
clos/con: ⊥
literals: '(7 ⊥ ⊥)

'(query:
  (app tak (app - x 1) (-> y <-) z)
  (env
   ((app
     tak
     (-> (app tak (app - x 1) y z) <-)
     (app tak (app - y 1) z x)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (app - x 1) (-> y <-) z)
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (-> (app tak (app - y 1) z x) <-)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (app - x 1) (-> y <-) z)
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (app tak (app - y 1) z x)
     (-> (app tak (app - z 1) x y) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (app - x 1) (-> y <-) z)
  (env
   ((match
     (app not (app < y x))
     ((#f)
      (->
       (app
        tak
        (app tak (app - x 1) y z)
        (app tak (app - y 1) z x)
        (app tak (app - z 1) x y))
       <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (app - x 1) (-> y <-) z)
  (env ((letrec* (tak) (-> (app tak 32 15 8) <-)))))
clos/con: ⊥
literals: '(15 ⊥ ⊥)

'(query:
  (app tak (app - x 1) y (-> z <-))
  (env
   ((app
     tak
     (-> (app tak (app - x 1) y z) <-)
     (app tak (app - y 1) z x)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (app - x 1) y (-> z <-))
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (-> (app tak (app - y 1) z x) <-)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (app - x 1) y (-> z <-))
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (app tak (app - y 1) z x)
     (-> (app tak (app - z 1) x y) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (app - x 1) y (-> z <-))
  (env
   ((match
     (app not (app < y x))
     ((#f)
      (->
       (app
        tak
        (app tak (app - x 1) y z)
        (app tak (app - y 1) z x)
        (app tak (app - z 1) x y))
       <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (app - x 1) y (-> z <-))
  (env ((letrec* (tak) (-> (app tak 32 15 8) <-)))))
clos/con: ⊥
literals: '(8 ⊥ ⊥)

'(query:
  (app tak (app - y 1) (-> z <-) x)
  (env
   ((app
     tak
     (-> (app tak (app - x 1) y z) <-)
     (app tak (app - y 1) z x)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (app - y 1) (-> z <-) x)
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (-> (app tak (app - y 1) z x) <-)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (app - y 1) (-> z <-) x)
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (app tak (app - y 1) z x)
     (-> (app tak (app - z 1) x y) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (app - y 1) (-> z <-) x)
  (env
   ((match
     (app not (app < y x))
     ((#f)
      (->
       (app
        tak
        (app tak (app - x 1) y z)
        (app tak (app - y 1) z x)
        (app tak (app - z 1) x y))
       <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (app - y 1) (-> z <-) x)
  (env ((letrec* (tak) (-> (app tak 32 15 8) <-)))))
clos/con: ⊥
literals: '(8 ⊥ ⊥)

'(query:
  (app tak (app - y 1) z (-> x <-))
  (env
   ((app
     tak
     (-> (app tak (app - x 1) y z) <-)
     (app tak (app - y 1) z x)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (app - y 1) z (-> x <-))
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (-> (app tak (app - y 1) z x) <-)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (app - y 1) z (-> x <-))
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (app tak (app - y 1) z x)
     (-> (app tak (app - z 1) x y) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (app - y 1) z (-> x <-))
  (env
   ((match
     (app not (app < y x))
     ((#f)
      (->
       (app
        tak
        (app tak (app - x 1) y z)
        (app tak (app - y 1) z x)
        (app tak (app - z 1) x y))
       <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (app - y 1) z (-> x <-))
  (env ((letrec* (tak) (-> (app tak 32 15 8) <-)))))
clos/con: ⊥
literals: '(32 ⊥ ⊥)

'(query:
  (app tak (app - z 1) (-> x <-) y)
  (env
   ((app
     tak
     (-> (app tak (app - x 1) y z) <-)
     (app tak (app - y 1) z x)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (app - z 1) (-> x <-) y)
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (-> (app tak (app - y 1) z x) <-)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (app - z 1) (-> x <-) y)
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (app tak (app - y 1) z x)
     (-> (app tak (app - z 1) x y) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (app - z 1) (-> x <-) y)
  (env
   ((match
     (app not (app < y x))
     ((#f)
      (->
       (app
        tak
        (app tak (app - x 1) y z)
        (app tak (app - y 1) z x)
        (app tak (app - z 1) x y))
       <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (app - z 1) (-> x <-) y)
  (env ((letrec* (tak) (-> (app tak 32 15 8) <-)))))
clos/con: ⊥
literals: '(32 ⊥ ⊥)

'(query:
  (app tak (app - z 1) x (-> y <-))
  (env
   ((app
     tak
     (-> (app tak (app - x 1) y z) <-)
     (app tak (app - y 1) z x)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (app - z 1) x (-> y <-))
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (-> (app tak (app - y 1) z x) <-)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (app - z 1) x (-> y <-))
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (app tak (app - y 1) z x)
     (-> (app tak (app - z 1) x y) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (app - z 1) x (-> y <-))
  (env
   ((match
     (app not (app < y x))
     ((#f)
      (->
       (app
        tak
        (app tak (app - x 1) y z)
        (app tak (app - y 1) z x)
        (app tak (app - z 1) x y))
       <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app tak (app - z 1) x (-> y <-))
  (env ((letrec* (tak) (-> (app tak 32 15 8) <-)))))
clos/con: ⊥
literals: '(15 ⊥ ⊥)

'(query:
  (match
   (app not (app < y x))
   ((#f)
    (->
     (app
      tak
      (app tak (app - x 1) y z)
      (app tak (app - y 1) z x)
      (app tak (app - z 1) x y))
     <-))
   _)
  (env
   ((app
     tak
     (-> (app tak (app - x 1) y z) <-)
     (app tak (app - y 1) z x)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app not (app < y x))
   ((#f)
    (->
     (app
      tak
      (app tak (app - x 1) y z)
      (app tak (app - y 1) z x)
      (app tak (app - z 1) x y))
     <-))
   _)
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (-> (app tak (app - y 1) z x) <-)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app not (app < y x))
   ((#f)
    (->
     (app
      tak
      (app tak (app - x 1) y z)
      (app tak (app - y 1) z x)
      (app tak (app - z 1) x y))
     <-))
   _)
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (app tak (app - y 1) z x)
     (-> (app tak (app - z 1) x y) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app not (app < y x))
   ((#f)
    (->
     (app
      tak
      (app tak (app - x 1) y z)
      (app tak (app - y 1) z x)
      (app tak (app - z 1) x y))
     <-))
   _)
  (env
   ((match
     (app not (app < y x))
     ((#f)
      (->
       (app
        tak
        (app tak (app - x 1) y z)
        (app tak (app - y 1) z x)
        (app tak (app - z 1) x y))
       <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app not (app < y x))
   ((#f)
    (->
     (app
      tak
      (app tak (app - x 1) y z)
      (app tak (app - y 1) z x)
      (app tak (app - z 1) x y))
     <-))
   _)
  (env ((letrec* (tak) (-> (app tak 32 15 8) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (-> (app not (app < y x)) <-) (#f) _)
  (env
   ((app
     tak
     (-> (app tak (app - x 1) y z) <-)
     (app tak (app - y 1) z x)
     (app tak (app - z 1) x y)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app not (app < y x)) <-) (#f) _)
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (-> (app tak (app - y 1) z x) <-)
     (app tak (app - z 1) x y)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app not (app < y x)) <-) (#f) _)
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (app tak (app - y 1) z x)
     (-> (app tak (app - z 1) x y) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app not (app < y x)) <-) (#f) _)
  (env
   ((match
     (app not (app < y x))
     ((#f)
      (->
       (app
        tak
        (app tak (app - x 1) y z)
        (app tak (app - y 1) z x)
        (app tak (app - z 1) x y))
       <-))
     _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app not (app < y x)) <-) (#f) _)
  (env ((letrec* (tak) (-> (app tak 32 15 8) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app not (app < y x)) (#f) (_ (-> z <-)))
  (env
   ((app
     tak
     (-> (app tak (app - x 1) y z) <-)
     (app tak (app - y 1) z x)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app not (app < y x)) (#f) (_ (-> z <-)))
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (-> (app tak (app - y 1) z x) <-)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app not (app < y x)) (#f) (_ (-> z <-)))
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (app tak (app - y 1) z x)
     (-> (app tak (app - z 1) x y) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app not (app < y x)) (#f) (_ (-> z <-)))
  (env
   ((match
     (app not (app < y x))
     ((#f)
      (->
       (app
        tak
        (app tak (app - x 1) y z)
        (app tak (app - y 1) z x)
        (app tak (app - z 1) x y))
       <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (x y z) (-> (match (app not (app < y x)) ...) <-))
  (env
   ((app
     tak
     (-> (app tak (app - x 1) y z) <-)
     (app tak (app - y 1) z x)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (x y z) (-> (match (app not (app < y x)) ...) <-))
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (-> (app tak (app - y 1) z x) <-)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (x y z) (-> (match (app not (app < y x)) ...) <-))
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (app tak (app - y 1) z x)
     (-> (app tak (app - z 1) x y) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (x y z) (-> (match (app not (app < y x)) ...) <-))
  (env
   ((match
     (app not (app < y x))
     ((#f)
      (->
       (app
        tak
        (app tak (app - x 1) y z)
        (app tak (app - y 1) z x)
        (app tak (app - z 1) x y))
       <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (x y z) (-> (match (app not (app < y x)) ...) <-))
  (env ((letrec* (tak) (-> (app tak 32 15 8) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: ((top) letrec* (tak) ...) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app - (-> x <-) 1) (env ((letrec* (tak) (-> (app tak 32 15 8) <-)))))
clos/con: ⊥
literals: '(32 ⊥ ⊥)

'(query: (app - (-> y <-) 1) (env ((letrec* (tak) (-> (app tak 32 15 8) <-)))))
clos/con: ⊥
literals: '(15 ⊥ ⊥)

'(query: (app - (-> z <-) 1) (env ((letrec* (tak) (-> (app tak 32 15 8) <-)))))
clos/con: ⊥
literals: '(8 ⊥ ⊥)

'(query: (app < (-> y <-) x) (env ((letrec* (tak) (-> (app tak 32 15 8) <-)))))
clos/con: ⊥
literals: '(15 ⊥ ⊥)

'(query: (app < y (-> x <-)) (env ((letrec* (tak) (-> (app tak 32 15 8) <-)))))
clos/con: ⊥
literals: '(32 ⊥ ⊥)

'(query: (letrec* (tak) (-> (app tak 32 15 8) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  tak
  (letrec* (... () (tak (-> (λ (x y z) ...) <-)) () ...) ...)
  (env
   ((app
     tak
     (-> (app tak (app - x 1) y z) <-)
     (app tak (app - y 1) z x)
     (app tak (app - z 1) x y)))))
clos/con:
	'((letrec* (... () (tak (-> (λ (x y z) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  tak
  (letrec* (... () (tak (-> (λ (x y z) ...) <-)) () ...) ...)
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (-> (app tak (app - y 1) z x) <-)
     (app tak (app - z 1) x y)))))
clos/con:
	'((letrec* (... () (tak (-> (λ (x y z) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  tak
  (letrec* (... () (tak (-> (λ (x y z) ...) <-)) () ...) ...)
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (app tak (app - y 1) z x)
     (-> (app tak (app - z 1) x y) <-)))))
clos/con:
	'((letrec* (... () (tak (-> (λ (x y z) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  tak
  (letrec* (... () (tak (-> (λ (x y z) ...) <-)) () ...) ...)
  (env
   ((match
     (app not (app < y x))
     ((#f)
      (->
       (app
        tak
        (app tak (app - x 1) y z)
        (app tak (app - y 1) z x)
        (app tak (app - z 1) x y))
       <-))
     _))))
clos/con:
	'((letrec* (... () (tak (-> (λ (x y z) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  tak
  (letrec* (... () (tak (-> (λ (x y z) ...) <-)) () ...) ...)
  (env ((letrec* (tak) (-> (app tak 32 15 8) <-)))))
clos/con:
	'((letrec* (... () (tak (-> (λ (x y z) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  tak
  (letrec* (... () (tak (-> (λ (x y z) ...) <-)) () ...) ...)
  (env ()))
clos/con:
	'((letrec* (... () (tak (-> (λ (x y z) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x
  (λ (x y z) (-> (match (app not (app < y x)) ...) <-))
  (env
   ((app
     tak
     (-> (app tak (app - x 1) y z) <-)
     (app tak (app - y 1) z x)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  x
  (λ (x y z) (-> (match (app not (app < y x)) ...) <-))
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (-> (app tak (app - y 1) z x) <-)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  x
  (λ (x y z) (-> (match (app not (app < y x)) ...) <-))
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (app tak (app - y 1) z x)
     (-> (app tak (app - z 1) x y) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  x
  (λ (x y z) (-> (match (app not (app < y x)) ...) <-))
  (env
   ((match
     (app not (app < y x))
     ((#f)
      (->
       (app
        tak
        (app tak (app - x 1) y z)
        (app tak (app - y 1) z x)
        (app tak (app - z 1) x y))
       <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  x
  (λ (x y z) (-> (match (app not (app < y x)) ...) <-))
  (env ((letrec* (tak) (-> (app tak 32 15 8) <-)))))
clos/con: ⊥
literals: '(32 ⊥ ⊥)

'(store:
  y
  (λ (x y z) (-> (match (app not (app < y x)) ...) <-))
  (env
   ((app
     tak
     (-> (app tak (app - x 1) y z) <-)
     (app tak (app - y 1) z x)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  y
  (λ (x y z) (-> (match (app not (app < y x)) ...) <-))
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (-> (app tak (app - y 1) z x) <-)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  y
  (λ (x y z) (-> (match (app not (app < y x)) ...) <-))
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (app tak (app - y 1) z x)
     (-> (app tak (app - z 1) x y) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  y
  (λ (x y z) (-> (match (app not (app < y x)) ...) <-))
  (env
   ((match
     (app not (app < y x))
     ((#f)
      (->
       (app
        tak
        (app tak (app - x 1) y z)
        (app tak (app - y 1) z x)
        (app tak (app - z 1) x y))
       <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  y
  (λ (x y z) (-> (match (app not (app < y x)) ...) <-))
  (env ((letrec* (tak) (-> (app tak 32 15 8) <-)))))
clos/con: ⊥
literals: '(15 ⊥ ⊥)

'(store:
  z
  (λ (x y z) (-> (match (app not (app < y x)) ...) <-))
  (env
   ((app
     tak
     (-> (app tak (app - x 1) y z) <-)
     (app tak (app - y 1) z x)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  z
  (λ (x y z) (-> (match (app not (app < y x)) ...) <-))
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (-> (app tak (app - y 1) z x) <-)
     (app tak (app - z 1) x y)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  z
  (λ (x y z) (-> (match (app not (app < y x)) ...) <-))
  (env
   ((app
     tak
     (app tak (app - x 1) y z)
     (app tak (app - y 1) z x)
     (-> (app tak (app - z 1) x y) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  z
  (λ (x y z) (-> (match (app not (app < y x)) ...) <-))
  (env
   ((match
     (app not (app < y x))
     ((#f)
      (->
       (app
        tak
        (app tak (app - x 1) y z)
        (app tak (app - y 1) z x)
        (app tak (app - z 1) x y))
       <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  z
  (λ (x y z) (-> (match (app not (app < y x)) ...) <-))
  (env ((letrec* (tak) (-> (app tak 32 15 8) <-)))))
clos/con: ⊥
literals: '(8 ⊥ ⊥)
