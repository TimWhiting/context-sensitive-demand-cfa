(meval
 '((top)
   app
   (λ (f1) (let ((_ (app f1 #t))) (app f1 #f)))
   (λ (x1)
     (app
      (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
      (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))))
 (flatenv '()))
(list 'start (list 'meval '(top) (flatenv '())))
(list 'eval-fun '(λ (f1) (let ((_ (app f1 #t))) (app f1 #f))) (flatenv '()))
(list
 'start
 (list
  'meval
  '(app (-> (λ (f1) (let ((_ (app f1 #t))) (app f1 #f))) <-) ...)
  (flatenv '())))
(list
 'end
 (list
  'meval
  '(app (-> (λ (f1) (let ((_ (app f1 #t))) (app f1 #f))) <-) ...)
  (flatenv '())))
(list
 'result
 '(app (-> (λ (f1) (let ((_ (app f1 #t))) (app f1 #f))) <-) ...)
 (flatenv '()))
'(eval-args
  ((λ (x1)
     (app
      (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
      (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)))))))
(list
 'start
 (list
  'meval
  '(app
    ...
    (->
     (λ (x1)
       (app
        (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
        (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)))))
     <-)
    ...)
  (flatenv '())))
(list
 'end
 (list
  'meval
  '(app
    ...
    (->
     (λ (x1)
       (app
        (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
        (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)))))
     <-)
    ...)
  (flatenv '())))
(list
 'result
 '(app
   ...
   (->
    (λ (x1)
      (app
       (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
       (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)))))
    <-)
   ...)
 (flatenv '()))
(list
 'bind-args
 '(f1)
 (flatenv '((top)))
 '((clos/con:
    (λ (x1)
      (app
       (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
       (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))))))
(list
 'extend-store
 'f1
 (flatenv '((top)))
 '(clos/con:
   (λ (x1)
     (app
      (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
      (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)))))))
(list 'bind-args '() (flatenv '((top))) '())
(list
 'rebind-vars
 '(λ (f1) (-> (let ((_ (app f1 #t))) (app f1 #f)) <-))
 '()
 (flatenv '())
 (flatenv '((top))))
(list
 'start
 (list
  'meval
  '(λ (f1) (-> (let ((_ (app f1 #t))) (app f1 #f)) <-))
  (flatenv '((top)))))
(list
 'start
 (list 'meval '(let ((-> _ = (app f1 #t) <-)) bod) (flatenv '((top)))))
(list 'eval-fun 'f1 (flatenv '((top))))
(list 'start (list 'meval '(app (-> f1 <-) ...) (flatenv '((top)))))
(list 'end (list 'meval '(app (-> f1 <-) ...) (flatenv '((top)))))
(list
 'result
 '(app
   ...
   (->
    (λ (x1)
      (app
       (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
       (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)))))
    <-)
   ...)
 (flatenv '()))
'(eval-args (#t))
(list 'start (list 'meval '(app ... (-> #t <-) ...) (flatenv '((top)))))
(list 'end (list 'meval '(app ... (-> #t <-) ...) (flatenv '((top)))))
(list 'result '(app ... (-> #t <-) ...) (flatenv '((top))))
(list
 'bind-args
 '(x1)
 (flatenv '((let ((-> _ = (app f1 #t) <-)) bod)))
 '((clos/con: #t)))
(list
 'extend-store
 'x1
 (flatenv '((let ((-> _ = (app f1 #t) <-)) bod)))
 '(clos/con: #t))
(list 'bind-args '() (flatenv '((let ((-> _ = (app f1 #t) <-)) bod))) '())
(list
 'rebind-vars
 '(λ (x1)
    (->
     (app
      (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
      (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
     <-))
 '()
 (flatenv '())
 (flatenv '((let ((-> _ = (app f1 #t) <-)) bod))))
(list
 'start
 (list
  'meval
  '(λ (x1)
     (->
      (app
       (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
       (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
      <-))
  (flatenv '((let ((-> _ = (app f1 #t) <-)) bod)))))
(list
 'eval-fun
 '(λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
 (flatenv '((let ((-> _ = (app f1 #t) <-)) bod))))
(list
 'start
 (list
  'meval
  '(app (-> (λ (f2) (let ((_ (app f2 #t))) (app f2 #f))) <-) ...)
  (flatenv '((let ((-> _ = (app f1 #t) <-)) bod)))))
(list
 'end
 (list
  'meval
  '(app (-> (λ (f2) (let ((_ (app f2 #t))) (app f2 #f))) <-) ...)
  (flatenv '((let ((-> _ = (app f1 #t) <-)) bod)))))
(list
 'result
 '(app (-> (λ (f2) (let ((_ (app f2 #t))) (app f2 #f))) <-) ...)
 (flatenv '((let ((-> _ = (app f1 #t) <-)) bod))))
'(eval-args ((λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)))))
(list
 'start
 (list
  'meval
  '(app ... (-> (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))) <-) ...)
  (flatenv '((let ((-> _ = (app f1 #t) <-)) bod)))))
(list
 'end
 (list
  'meval
  '(app ... (-> (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))) <-) ...)
  (flatenv '((let ((-> _ = (app f1 #t) <-)) bod)))))
(list
 'result
 '(app ... (-> (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))) <-) ...)
 (flatenv '((let ((-> _ = (app f1 #t) <-)) bod))))
(list
 'bind-args
 '(f2)
 (flatenv
  '((λ (x1)
      (->
       (app
        (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
        (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
       <-))))
 '((clos/con: (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))))
(list
 'extend-store
 'f2
 (flatenv
  '((λ (x1)
      (->
       (app
        (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
        (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
       <-))))
 '(clos/con: (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)))))
(list
 'bind-args
 '()
 (flatenv
  '((λ (x1)
      (->
       (app
        (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
        (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
       <-))))
 '())
(list
 'rebind-vars
 '(λ (f2) (-> (let ((_ (app f2 #t))) (app f2 #f)) <-))
 '()
 (flatenv '((let ((-> _ = (app f1 #t) <-)) bod)))
 (flatenv
  '((λ (x1)
      (->
       (app
        (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
        (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
       <-)))))
(list
 'start
 (list
  'meval
  '(λ (f2) (-> (let ((_ (app f2 #t))) (app f2 #f)) <-))
  (flatenv
   '((λ (x1)
       (->
        (app
         (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
         (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
        <-))))))
(list
 'start
 (list
  'meval
  '(let ((-> _ = (app f2 #t) <-)) bod)
  (flatenv
   '((λ (x1)
       (->
        (app
         (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
         (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
        <-))))))
(list
 'eval-fun
 'f2
 (flatenv
  '((λ (x1)
      (->
       (app
        (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
        (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
       <-)))))
(list
 'start
 (list
  'meval
  '(app (-> f2 <-) ...)
  (flatenv
   '((λ (x1)
       (->
        (app
         (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
         (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
        <-))))))
(list
 'end
 (list
  'meval
  '(app (-> f2 <-) ...)
  (flatenv
   '((λ (x1)
       (->
        (app
         (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
         (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
        <-))))))
(list
 'result
 '(app ... (-> (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))) <-) ...)
 (flatenv '((let ((-> _ = (app f1 #t) <-)) bod))))
'(eval-args (#t))
(list
 'start
 (list
  'meval
  '(app ... (-> #t <-) ...)
  (flatenv
   '((λ (x1)
       (->
        (app
         (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
         (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
        <-))))))
(list
 'end
 (list
  'meval
  '(app ... (-> #t <-) ...)
  (flatenv
   '((λ (x1)
       (->
        (app
         (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
         (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
        <-))))))
(list
 'result
 '(app ... (-> #t <-) ...)
 (flatenv
  '((λ (x1)
      (->
       (app
        (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
        (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
       <-)))))
(list
 'bind-args
 '(x2)
 (flatenv '((let ((-> _ = (app f2 #t) <-)) bod)))
 '((clos/con: #t)))
(list
 'extend-store
 'x2
 (flatenv '((let ((-> _ = (app f2 #t) <-)) bod)))
 '(clos/con: #t))
(list 'bind-args '() (flatenv '((let ((-> _ = (app f2 #t) <-)) bod))) '())
(list
 'rebind-vars
 '(λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))
 '(x1)
 (flatenv '((let ((-> _ = (app f1 #t) <-)) bod)))
 (flatenv '((let ((-> _ = (app f2 #t) <-)) bod))))
(list
 'extend-store
 'x1
 (flatenv '((let ((-> _ = (app f2 #t) <-)) bod)))
 '(clos/con: #t))
(list
 'rebind-vars
 '(λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))
 '()
 (flatenv '((let ((-> _ = (app f1 #t) <-)) bod)))
 (flatenv '((let ((-> _ = (app f2 #t) <-)) bod))))
(list
 'start
 (list
  'meval
  '(λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))
  (flatenv '((let ((-> _ = (app f2 #t) <-)) bod)))))
(list
 'eval-fun
 '(λ (z) (app z x1 x2))
 (flatenv '((let ((-> _ = (app f2 #t) <-)) bod))))
(list
 'start
 (list
  'meval
  '(app (-> (λ (z) (app z x1 x2)) <-) ...)
  (flatenv '((let ((-> _ = (app f2 #t) <-)) bod)))))
(list
 'end
 (list
  'meval
  '(app (-> (λ (z) (app z x1 x2)) <-) ...)
  (flatenv '((let ((-> _ = (app f2 #t) <-)) bod)))))
(list
 'result
 '(app (-> (λ (z) (app z x1 x2)) <-) ...)
 (flatenv '((let ((-> _ = (app f2 #t) <-)) bod))))
'(eval-args ((λ (y1 y2) y1)))
(list
 'start
 (list
  'meval
  '(app ... (-> (λ (y1 y2) y1) <-) ...)
  (flatenv '((let ((-> _ = (app f2 #t) <-)) bod)))))
(list
 'end
 (list
  'meval
  '(app ... (-> (λ (y1 y2) y1) <-) ...)
  (flatenv '((let ((-> _ = (app f2 #t) <-)) bod)))))
(list
 'result
 '(app ... (-> (λ (y1 y2) y1) <-) ...)
 (flatenv '((let ((-> _ = (app f2 #t) <-)) bod))))
(list
 'bind-args
 '(z)
 (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))))
 '((clos/con: (λ (y1 y2) y1))))
(list
 'extend-store
 'z
 (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))))
 '(clos/con: (λ (y1 y2) y1)))
(list
 'bind-args
 '()
 (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))))
 '())
(list
 'rebind-vars
 '(λ (z) (-> (app z x1 x2) <-))
 '(x2 x1)
 (flatenv '((let ((-> _ = (app f2 #t) <-)) bod)))
 (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-)))))
(list
 'extend-store
 'x2
 (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))))
 '(clos/con: #t))
(list
 'rebind-vars
 '(λ (z) (-> (app z x1 x2) <-))
 '(x1)
 (flatenv '((let ((-> _ = (app f2 #t) <-)) bod)))
 (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-)))))
(list
 'extend-store
 'x1
 (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))))
 '(clos/con: #t))
(list
 'rebind-vars
 '(λ (z) (-> (app z x1 x2) <-))
 '()
 (flatenv '((let ((-> _ = (app f2 #t) <-)) bod)))
 (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-)))))
(list
 'start
 (list
  'meval
  '(λ (z) (-> (app z x1 x2) <-))
  (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))))))
(list
 'eval-fun
 'z
 (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-)))))
(list
 'start
 (list
  'meval
  '(app (-> z <-) ...)
  (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))))))
(list
 'end
 (list
  'meval
  '(app (-> z <-) ...)
  (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))))))
(list
 'result
 '(app ... (-> (λ (y1 y2) y1) <-) ...)
 (flatenv '((let ((-> _ = (app f2 #t) <-)) bod))))
'(eval-args (x1 x2))
(list
 'start
 (list
  'meval
  '(app ... (-> x2 <-) ...)
  (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))))))
(list
 'end
 (list
  'meval
  '(app ... (-> x2 <-) ...)
  (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))))))
(list
 'result
 '(app ... (-> #t <-) ...)
 (flatenv
  '((λ (x1)
      (->
       (app
        (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
        (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
       <-)))))
(list
 'start
 (list
  'meval
  '(app ... (-> x1 <-) ...)
  (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))))))
(list
 'end
 (list
  'meval
  '(app ... (-> x1 <-) ...)
  (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))))))
(list 'result '(app ... (-> #t <-) ...) (flatenv '((top))))
(list
 'bind-args
 '(y1 y2)
 (flatenv '((λ (z) (-> (app z x1 x2) <-))))
 '((clos/con: #t) (clos/con: #t)))
(list
 'extend-store
 'y1
 (flatenv '((λ (z) (-> (app z x1 x2) <-))))
 '(clos/con: #t))
(list
 'bind-args
 '(y2)
 (flatenv '((λ (z) (-> (app z x1 x2) <-))))
 '((clos/con: #t)))
(list
 'extend-store
 'y2
 (flatenv '((λ (z) (-> (app z x1 x2) <-))))
 '(clos/con: #t))
(list 'bind-args '() (flatenv '((λ (z) (-> (app z x1 x2) <-)))) '())
(list
 'rebind-vars
 '(λ (y1 y2) (-> y1 <-))
 '()
 (flatenv '((let ((-> _ = (app f2 #t) <-)) bod)))
 (flatenv '((λ (z) (-> (app z x1 x2) <-)))))
(list
 'start
 (list
  'meval
  '(λ (y1 y2) (-> y1 <-))
  (flatenv '((λ (z) (-> (app z x1 x2) <-))))))
(list
 'end
 (list
  'meval
  '(λ (y1 y2) (-> y1 <-))
  (flatenv '((λ (z) (-> (app z x1 x2) <-))))))
(list 'result '(app ... (-> #t <-) ...) (flatenv '((top))))
(list
 'end
 (list
  'meval
  '(λ (z) (-> (app z x1 x2) <-))
  (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))))))
(list 'result '(app ... (-> #t <-) ...) (flatenv '((top))))
(list
 'end
 (list
  'meval
  '(λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))
  (flatenv '((let ((-> _ = (app f2 #t) <-)) bod)))))
(list 'result '(app ... (-> #t <-) ...) (flatenv '((top))))
(list
 'end
 (list
  'meval
  '(let ((-> _ = (app f2 #t) <-)) bod)
  (flatenv
   '((λ (x1)
       (->
        (app
         (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
         (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
        <-))))))
(list 'result '(app ... (-> #t <-) ...) (flatenv '((top))))
(list
 'bind-args
 '(_)
 (flatenv
  '((λ (x1)
      (->
       (app
        (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
        (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
       <-))))
 '((clos/con: #t)))
(list
 'extend-store
 '_
 (flatenv
  '((λ (x1)
      (->
       (app
        (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
        (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
       <-))))
 '(clos/con: #t))
(list
 'bind-args
 '()
 (flatenv
  '((λ (x1)
      (->
       (app
        (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
        (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
       <-))))
 '())
(list
 'start
 (list
  'meval
  '(let (_) (-> (app f2 #f) <-))
  (flatenv
   '((λ (x1)
       (->
        (app
         (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
         (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
        <-))))))
(list
 'eval-fun
 'f2
 (flatenv
  '((λ (x1)
      (->
       (app
        (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
        (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
       <-)))))
(list
 'start
 (list
  'meval
  '(app (-> f2 <-) ...)
  (flatenv
   '((λ (x1)
       (->
        (app
         (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
         (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
        <-))))))
(list
 'end
 (list
  'meval
  '(app (-> f2 <-) ...)
  (flatenv
   '((λ (x1)
       (->
        (app
         (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
         (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
        <-))))))
(list
 'result
 '(app ... (-> (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))) <-) ...)
 (flatenv '((let ((-> _ = (app f1 #t) <-)) bod))))
'(eval-args (#f))
(list
 'start
 (list
  'meval
  '(app ... (-> #f <-) ...)
  (flatenv
   '((λ (x1)
       (->
        (app
         (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
         (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
        <-))))))
(list
 'end
 (list
  'meval
  '(app ... (-> #f <-) ...)
  (flatenv
   '((λ (x1)
       (->
        (app
         (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
         (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
        <-))))))
(list
 'result
 '(app ... (-> #f <-) ...)
 (flatenv
  '((λ (x1)
      (->
       (app
        (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
        (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
       <-)))))
(list
 'bind-args
 '(x2)
 (flatenv '((let (_) (-> (app f2 #f) <-))))
 '((clos/con: #f)))
(list
 'extend-store
 'x2
 (flatenv '((let (_) (-> (app f2 #f) <-))))
 '(clos/con: #f))
(list 'bind-args '() (flatenv '((let (_) (-> (app f2 #f) <-)))) '())
(list
 'rebind-vars
 '(λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))
 '(x1)
 (flatenv '((let ((-> _ = (app f1 #t) <-)) bod)))
 (flatenv '((let (_) (-> (app f2 #f) <-)))))
(list
 'extend-store
 'x1
 (flatenv '((let (_) (-> (app f2 #f) <-))))
 '(clos/con: #t))
(list
 'rebind-vars
 '(λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))
 '()
 (flatenv '((let ((-> _ = (app f1 #t) <-)) bod)))
 (flatenv '((let (_) (-> (app f2 #f) <-)))))
(list
 'start
 (list
  'meval
  '(λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))
  (flatenv '((let (_) (-> (app f2 #f) <-))))))
(list
 'eval-fun
 '(λ (z) (app z x1 x2))
 (flatenv '((let (_) (-> (app f2 #f) <-)))))
(list
 'start
 (list
  'meval
  '(app (-> (λ (z) (app z x1 x2)) <-) ...)
  (flatenv '((let (_) (-> (app f2 #f) <-))))))
(list
 'end
 (list
  'meval
  '(app (-> (λ (z) (app z x1 x2)) <-) ...)
  (flatenv '((let (_) (-> (app f2 #f) <-))))))
(list
 'result
 '(app (-> (λ (z) (app z x1 x2)) <-) ...)
 (flatenv '((let (_) (-> (app f2 #f) <-)))))
'(eval-args ((λ (y1 y2) y1)))
(list
 'start
 (list
  'meval
  '(app ... (-> (λ (y1 y2) y1) <-) ...)
  (flatenv '((let (_) (-> (app f2 #f) <-))))))
(list
 'end
 (list
  'meval
  '(app ... (-> (λ (y1 y2) y1) <-) ...)
  (flatenv '((let (_) (-> (app f2 #f) <-))))))
(list
 'result
 '(app ... (-> (λ (y1 y2) y1) <-) ...)
 (flatenv '((let (_) (-> (app f2 #f) <-)))))
(list
 'bind-args
 '(z)
 (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))))
 '((clos/con: (λ (y1 y2) y1))))
(list
 'extend-store
 'z
 (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))))
 '(clos/con: (λ (y1 y2) y1)))
(list
 'bind-args
 '()
 (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))))
 '())
(list
 'rebind-vars
 '(λ (z) (-> (app z x1 x2) <-))
 '(x2 x1)
 (flatenv '((let (_) (-> (app f2 #f) <-))))
 (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-)))))
(list
 'end
 (list
  'meval
  '(app (-> z <-) ...)
  (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))))))
(list
 'result
 '(app ... (-> (λ (y1 y2) y1) <-) ...)
 (flatenv '((let (_) (-> (app f2 #f) <-)))))
'(eval-args (x1 x2))
(list
 'bind-args
 '(y1 y2)
 (flatenv '((λ (z) (-> (app z x1 x2) <-))))
 '((clos/con: #t) (clos/con: #t)))
(list
 'extend-store
 'y1
 (flatenv '((λ (z) (-> (app z x1 x2) <-))))
 '(clos/con: #t))
(list
 'bind-args
 '(y2)
 (flatenv '((λ (z) (-> (app z x1 x2) <-))))
 '((clos/con: #t)))
(list
 'extend-store
 'y2
 (flatenv '((λ (z) (-> (app z x1 x2) <-))))
 '(clos/con: #t))
(list 'bind-args '() (flatenv '((λ (z) (-> (app z x1 x2) <-)))) '())
(list
 'rebind-vars
 '(λ (y1 y2) (-> y1 <-))
 '()
 (flatenv '((let (_) (-> (app f2 #f) <-))))
 (flatenv '((λ (z) (-> (app z x1 x2) <-)))))
(list
 'end
 (list
  'meval
  '(λ (z) (-> (app z x1 x2) <-))
  (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))))))
(list 'result '(app ... (-> #t <-) ...) (flatenv '((top))))
(list
 'extend-store
 'x2
 (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))))
 '(clos/con: #f))
(list
 'rebind-vars
 '(λ (z) (-> (app z x1 x2) <-))
 '(x1)
 (flatenv '((let (_) (-> (app f2 #f) <-))))
 (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-)))))
(list
 'end
 (list
  'meval
  '(app ... (-> x2 <-) ...)
  (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))))))
(list
 'result
 '(app ... (-> #f <-) ...)
 (flatenv
  '((λ (x1)
      (->
       (app
        (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
        (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
       <-)))))
(list
 'bind-args
 '(y1 y2)
 (flatenv '((λ (z) (-> (app z x1 x2) <-))))
 '((clos/con: #t) (clos/con: #f)))
(list
 'extend-store
 'y1
 (flatenv '((λ (z) (-> (app z x1 x2) <-))))
 '(clos/con: #t))
(list
 'bind-args
 '(y2)
 (flatenv '((λ (z) (-> (app z x1 x2) <-))))
 '((clos/con: #f)))
(list
 'extend-store
 'y2
 (flatenv '((λ (z) (-> (app z x1 x2) <-))))
 '(clos/con: #f))
(list 'bind-args '() (flatenv '((λ (z) (-> (app z x1 x2) <-)))) '())
(list
 'rebind-vars
 '(λ (y1 y2) (-> y1 <-))
 '()
 (flatenv '((let (_) (-> (app f2 #f) <-))))
 (flatenv '((λ (z) (-> (app z x1 x2) <-)))))
(list
 'end
 (list
  'meval
  '(λ (z) (-> (app z x1 x2) <-))
  (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))))))
(list 'result '(app ... (-> #t <-) ...) (flatenv '((top))))
(list
 'bind-args
 '(y1 y2)
 (flatenv '((λ (z) (-> (app z x1 x2) <-))))
 '((clos/con: #t) (clos/con: #f)))
(list
 'extend-store
 'y1
 (flatenv '((λ (z) (-> (app z x1 x2) <-))))
 '(clos/con: #t))
(list
 'bind-args
 '(y2)
 (flatenv '((λ (z) (-> (app z x1 x2) <-))))
 '((clos/con: #f)))
(list
 'extend-store
 'y2
 (flatenv '((λ (z) (-> (app z x1 x2) <-))))
 '(clos/con: #f))
(list 'bind-args '() (flatenv '((λ (z) (-> (app z x1 x2) <-)))) '())
(list
 'rebind-vars
 '(λ (y1 y2) (-> y1 <-))
 '()
 (flatenv '((let ((-> _ = (app f2 #t) <-)) bod)))
 (flatenv '((λ (z) (-> (app z x1 x2) <-)))))
(list
 'end
 (list
  'meval
  '(λ (z) (-> (app z x1 x2) <-))
  (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))))))
(list 'result '(app ... (-> #t <-) ...) (flatenv '((top))))
(list
 'extend-store
 'x1
 (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))))
 '(clos/con: #t))
(list
 'rebind-vars
 '(λ (z) (-> (app z x1 x2) <-))
 '()
 (flatenv '((let (_) (-> (app f2 #f) <-))))
 (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-)))))
(list
 'end
 (list
  'meval
  '(λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))
  (flatenv '((let (_) (-> (app f2 #f) <-))))))
(list 'result '(app ... (-> #t <-) ...) (flatenv '((top))))
(list
 'end
 (list
  'meval
  '(let (_) (-> (app f2 #f) <-))
  (flatenv
   '((λ (x1)
       (->
        (app
         (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
         (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
        <-))))))
(list 'result '(app ... (-> #t <-) ...) (flatenv '((top))))
(list
 'end
 (list
  'meval
  '(λ (f2) (-> (let ((_ (app f2 #t))) (app f2 #f)) <-))
  (flatenv
   '((λ (x1)
       (->
        (app
         (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
         (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
        <-))))))
(list 'result '(app ... (-> #t <-) ...) (flatenv '((top))))
(list
 'end
 (list
  'meval
  '(λ (x1)
     (->
      (app
       (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
       (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
      <-))
  (flatenv '((let ((-> _ = (app f1 #t) <-)) bod)))))
(list 'result '(app ... (-> #t <-) ...) (flatenv '((top))))
(list
 'end
 (list 'meval '(let ((-> _ = (app f1 #t) <-)) bod) (flatenv '((top)))))
(list 'result '(app ... (-> #t <-) ...) (flatenv '((top))))
(list 'bind-args '(_) (flatenv '((top))) '((clos/con: #t)))
(list 'extend-store '_ (flatenv '((top))) '(clos/con: #t))
(list 'bind-args '() (flatenv '((top))) '())
(list 'start (list 'meval '(let (_) (-> (app f1 #f) <-)) (flatenv '((top)))))
(list 'eval-fun 'f1 (flatenv '((top))))
(list 'start (list 'meval '(app (-> f1 <-) ...) (flatenv '((top)))))
(list 'end (list 'meval '(app (-> f1 <-) ...) (flatenv '((top)))))
(list
 'result
 '(app
   ...
   (->
    (λ (x1)
      (app
       (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
       (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)))))
    <-)
   ...)
 (flatenv '()))
'(eval-args (#f))
(list 'start (list 'meval '(app ... (-> #f <-) ...) (flatenv '((top)))))
(list 'end (list 'meval '(app ... (-> #f <-) ...) (flatenv '((top)))))
(list 'result '(app ... (-> #f <-) ...) (flatenv '((top))))
(list
 'bind-args
 '(x1)
 (flatenv '((let (_) (-> (app f1 #f) <-))))
 '((clos/con: #f)))
(list
 'extend-store
 'x1
 (flatenv '((let (_) (-> (app f1 #f) <-))))
 '(clos/con: #f))
(list 'bind-args '() (flatenv '((let (_) (-> (app f1 #f) <-)))) '())
(list
 'rebind-vars
 '(λ (x1)
    (->
     (app
      (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
      (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
     <-))
 '()
 (flatenv '())
 (flatenv '((let (_) (-> (app f1 #f) <-)))))
(list
 'start
 (list
  'meval
  '(λ (x1)
     (->
      (app
       (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
       (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
      <-))
  (flatenv '((let (_) (-> (app f1 #f) <-))))))
(list
 'eval-fun
 '(λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
 (flatenv '((let (_) (-> (app f1 #f) <-)))))
(list
 'start
 (list
  'meval
  '(app (-> (λ (f2) (let ((_ (app f2 #t))) (app f2 #f))) <-) ...)
  (flatenv '((let (_) (-> (app f1 #f) <-))))))
(list
 'end
 (list
  'meval
  '(app (-> (λ (f2) (let ((_ (app f2 #t))) (app f2 #f))) <-) ...)
  (flatenv '((let (_) (-> (app f1 #f) <-))))))
(list
 'result
 '(app (-> (λ (f2) (let ((_ (app f2 #t))) (app f2 #f))) <-) ...)
 (flatenv '((let (_) (-> (app f1 #f) <-)))))
'(eval-args ((λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)))))
(list
 'start
 (list
  'meval
  '(app ... (-> (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))) <-) ...)
  (flatenv '((let (_) (-> (app f1 #f) <-))))))
(list
 'end
 (list
  'meval
  '(app ... (-> (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))) <-) ...)
  (flatenv '((let (_) (-> (app f1 #f) <-))))))
(list
 'result
 '(app ... (-> (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))) <-) ...)
 (flatenv '((let (_) (-> (app f1 #f) <-)))))
(list
 'bind-args
 '(f2)
 (flatenv
  '((λ (x1)
      (->
       (app
        (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
        (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
       <-))))
 '((clos/con: (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))))
(list
 'extend-store
 'f2
 (flatenv
  '((λ (x1)
      (->
       (app
        (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
        (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
       <-))))
 '(clos/con: (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)))))
(list
 'bind-args
 '()
 (flatenv
  '((λ (x1)
      (->
       (app
        (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
        (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
       <-))))
 '())
(list
 'rebind-vars
 '(λ (f2) (-> (let ((_ (app f2 #t))) (app f2 #f)) <-))
 '()
 (flatenv '((let (_) (-> (app f1 #f) <-))))
 (flatenv
  '((λ (x1)
      (->
       (app
        (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
        (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
       <-)))))
(list
 'end
 (list
  'meval
  '(app (-> f2 <-) ...)
  (flatenv
   '((λ (x1)
       (->
        (app
         (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
         (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
        <-))))))
(list
 'result
 '(app ... (-> (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))) <-) ...)
 (flatenv '((let (_) (-> (app f1 #f) <-)))))
'(eval-args (#f))
(list
 'bind-args
 '(x2)
 (flatenv '((let (_) (-> (app f2 #f) <-))))
 '((clos/con: #f)))
(list
 'extend-store
 'x2
 (flatenv '((let (_) (-> (app f2 #f) <-))))
 '(clos/con: #f))
(list 'bind-args '() (flatenv '((let (_) (-> (app f2 #f) <-)))) '())
(list
 'rebind-vars
 '(λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))
 '(x1)
 (flatenv '((let (_) (-> (app f1 #f) <-))))
 (flatenv '((let (_) (-> (app f2 #f) <-)))))
(list
 'extend-store
 'x1
 (flatenv '((let (_) (-> (app f2 #f) <-))))
 '(clos/con: #f))
(list
 'rebind-vars
 '(λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))
 '()
 (flatenv '((let (_) (-> (app f1 #f) <-))))
 (flatenv '((let (_) (-> (app f2 #f) <-)))))
(list
 'extend-store
 'x1
 (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))))
 '(clos/con: #f))
(list
 'rebind-vars
 '(λ (z) (-> (app z x1 x2) <-))
 '()
 (flatenv '((let (_) (-> (app f2 #f) <-))))
 (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-)))))
(list
 'end
 (list
  'meval
  '(app ... (-> x1 <-) ...)
  (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))))))
(list 'result '(app ... (-> #f <-) ...) (flatenv '((top))))
(list
 'bind-args
 '(y1 y2)
 (flatenv '((λ (z) (-> (app z x1 x2) <-))))
 '((clos/con: #f) (clos/con: #f)))
(list
 'extend-store
 'y1
 (flatenv '((λ (z) (-> (app z x1 x2) <-))))
 '(clos/con: #f))
(list
 'bind-args
 '(y2)
 (flatenv '((λ (z) (-> (app z x1 x2) <-))))
 '((clos/con: #f)))
(list
 'extend-store
 'y2
 (flatenv '((λ (z) (-> (app z x1 x2) <-))))
 '(clos/con: #f))
(list
 'end
 (list
  'meval
  '(λ (y1 y2) (-> y1 <-))
  (flatenv '((λ (z) (-> (app z x1 x2) <-))))))
(list 'result '(app ... (-> #f <-) ...) (flatenv '((top))))
(list
 'end
 (list
  'meval
  '(λ (z) (-> (app z x1 x2) <-))
  (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))))))
(list 'result '(app ... (-> #f <-) ...) (flatenv '((top))))
(list
 'end
 (list
  'meval
  '(λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))
  (flatenv '((let (_) (-> (app f2 #f) <-))))))
(list 'result '(app ... (-> #f <-) ...) (flatenv '((top))))
(list
 'end
 (list
  'meval
  '(let (_) (-> (app f2 #f) <-))
  (flatenv
   '((λ (x1)
       (->
        (app
         (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
         (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
        <-))))))
(list 'result '(app ... (-> #f <-) ...) (flatenv '((top))))
(list
 'end
 (list
  'meval
  '(λ (f2) (-> (let ((_ (app f2 #t))) (app f2 #f)) <-))
  (flatenv
   '((λ (x1)
       (->
        (app
         (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
         (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
        <-))))))
(list 'result '(app ... (-> #f <-) ...) (flatenv '((top))))
(list
 'end
 (list
  'meval
  '(λ (x1)
     (->
      (app
       (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
       (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
      <-))
  (flatenv '((let ((-> _ = (app f1 #t) <-)) bod)))))
(list 'result '(app ... (-> #f <-) ...) (flatenv '((top))))
(list
 'end
 (list 'meval '(let ((-> _ = (app f1 #t) <-)) bod) (flatenv '((top)))))
(list 'result '(app ... (-> #f <-) ...) (flatenv '((top))))
(list 'bind-args '(_) (flatenv '((top))) '((clos/con: #f)))
(list 'extend-store '_ (flatenv '((top))) '(clos/con: #f))
(list 'bind-args '() (flatenv '((top))) '())
(list
 'end
 (list
  'meval
  '(λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))
  (flatenv '((let ((-> _ = (app f2 #t) <-)) bod)))))
(list 'result '(app ... (-> #f <-) ...) (flatenv '((top))))
(list
 'end
 (list
  'meval
  '(let ((-> _ = (app f2 #t) <-)) bod)
  (flatenv
   '((λ (x1)
       (->
        (app
         (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
         (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
        <-))))))
(list 'result '(app ... (-> #f <-) ...) (flatenv '((top))))
(list
 'bind-args
 '(_)
 (flatenv
  '((λ (x1)
      (->
       (app
        (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
        (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
       <-))))
 '((clos/con: #f)))
(list
 'extend-store
 '_
 (flatenv
  '((λ (x1)
      (->
       (app
        (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
        (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
       <-))))
 '(clos/con: #f))
(list
 'bind-args
 '()
 (flatenv
  '((λ (x1)
      (->
       (app
        (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
        (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
       <-))))
 '())
(list
 'end
 (list
  'meval
  '(λ (f2) (-> (let ((_ (app f2 #t))) (app f2 #f)) <-))
  (flatenv
   '((λ (x1)
       (->
        (app
         (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
         (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
        <-))))))
(list 'result '(app ... (-> #f <-) ...) (flatenv '((top))))
(list
 'end
 (list
  'meval
  '(λ (f2) (-> (let ((_ (app f2 #t))) (app f2 #f)) <-))
  (flatenv
   '((λ (x1)
       (->
        (app
         (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
         (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
        <-))))))
(list 'result '(app ... (-> #t <-) ...) (flatenv '((top))))
(list
 'end
 (list
  'meval
  '(λ (z) (-> (app z x1 x2) <-))
  (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))))))
(list 'result '(app ... (-> #f <-) ...) (flatenv '((top))))
(list
 'end
 (list
  'meval
  '(λ (z) (-> (app z x1 x2) <-))
  (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))))))
(list 'result '(app ... (-> #f <-) ...) (flatenv '((top))))
(list
 'end
 (list
  'meval
  '(λ (z) (-> (app z x1 x2) <-))
  (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))))))
(list 'result '(app ... (-> #f <-) ...) (flatenv '((top))))
(list 'bind-args '() (flatenv '((λ (z) (-> (app z x1 x2) <-)))) '())
(list
 'rebind-vars
 '(λ (y1 y2) (-> y1 <-))
 '()
 (flatenv '((let ((-> _ = (app f2 #t) <-)) bod)))
 (flatenv '((λ (z) (-> (app z x1 x2) <-)))))
(list
 'end
 (list
  'meval
  '(λ (z) (-> (app z x1 x2) <-))
  (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))))))
(list 'result '(app ... (-> #f <-) ...) (flatenv '((top))))
(list
 'end
 (list
  'meval
  '(λ (z) (-> (app z x1 x2) <-))
  (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))))))
(list 'result '(app ... (-> #t <-) ...) (flatenv '((top))))
(list
 'bind-args
 '(y1 y2)
 (flatenv '((λ (z) (-> (app z x1 x2) <-))))
 '((clos/con: #f) (clos/con: #f)))
(list
 'extend-store
 'y1
 (flatenv '((λ (z) (-> (app z x1 x2) <-))))
 '(clos/con: #f))
(list
 'bind-args
 '(y2)
 (flatenv '((λ (z) (-> (app z x1 x2) <-))))
 '((clos/con: #f)))
(list
 'extend-store
 'y2
 (flatenv '((λ (z) (-> (app z x1 x2) <-))))
 '(clos/con: #f))
(list 'bind-args '() (flatenv '((λ (z) (-> (app z x1 x2) <-)))) '())
(list
 'rebind-vars
 '(λ (y1 y2) (-> y1 <-))
 '()
 (flatenv '((let (_) (-> (app f2 #f) <-))))
 (flatenv '((λ (z) (-> (app z x1 x2) <-)))))
(list
 'end
 (list
  'meval
  '(λ (z) (-> (app z x1 x2) <-))
  (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))))))
(list 'result '(app ... (-> #f <-) ...) (flatenv '((top))))
(list
 'end
 (list
  'meval
  '(λ (z) (-> (app z x1 x2) <-))
  (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))))))
(list 'result '(app ... (-> #t <-) ...) (flatenv '((top))))
(list
 'bind-args
 '(y1 y2)
 (flatenv '((λ (z) (-> (app z x1 x2) <-))))
 '((clos/con: #f) (clos/con: #t)))
(list
 'extend-store
 'y1
 (flatenv '((λ (z) (-> (app z x1 x2) <-))))
 '(clos/con: #f))
(list
 'bind-args
 '(y2)
 (flatenv '((λ (z) (-> (app z x1 x2) <-))))
 '((clos/con: #t)))
(list
 'extend-store
 'y2
 (flatenv '((λ (z) (-> (app z x1 x2) <-))))
 '(clos/con: #t))
(list 'bind-args '() (flatenv '((λ (z) (-> (app z x1 x2) <-)))) '())
(list
 'rebind-vars
 '(λ (y1 y2) (-> y1 <-))
 '()
 (flatenv '((let (_) (-> (app f2 #f) <-))))
 (flatenv '((λ (z) (-> (app z x1 x2) <-)))))
(list
 'end
 (list
  'meval
  '(λ (z) (-> (app z x1 x2) <-))
  (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))))))
(list 'result '(app ... (-> #f <-) ...) (flatenv '((top))))
(list
 'end
 (list
  'meval
  '(λ (z) (-> (app z x1 x2) <-))
  (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))))))
(list 'result '(app ... (-> #t <-) ...) (flatenv '((top))))
(list
 'bind-args
 '(y1 y2)
 (flatenv '((λ (z) (-> (app z x1 x2) <-))))
 '((clos/con: #f) (clos/con: #t)))
(list
 'extend-store
 'y1
 (flatenv '((λ (z) (-> (app z x1 x2) <-))))
 '(clos/con: #f))
(list
 'bind-args
 '(y2)
 (flatenv '((λ (z) (-> (app z x1 x2) <-))))
 '((clos/con: #t)))
(list
 'extend-store
 'y2
 (flatenv '((λ (z) (-> (app z x1 x2) <-))))
 '(clos/con: #t))
(list 'bind-args '() (flatenv '((λ (z) (-> (app z x1 x2) <-)))) '())
(list
 'rebind-vars
 '(λ (y1 y2) (-> y1 <-))
 '()
 (flatenv '((let ((-> _ = (app f2 #t) <-)) bod)))
 (flatenv '((λ (z) (-> (app z x1 x2) <-)))))
(list
 'end
 (list
  'meval
  '(λ (z) (-> (app z x1 x2) <-))
  (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))))))
(list 'result '(app ... (-> #f <-) ...) (flatenv '((top))))
(list
 'end
 (list
  'meval
  '(λ (z) (-> (app z x1 x2) <-))
  (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))))))
(list 'result '(app ... (-> #t <-) ...) (flatenv '((top))))
(list
 'end
 (list
  'meval
  '(λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))
  (flatenv '((let (_) (-> (app f2 #f) <-))))))
(list 'result '(app ... (-> #f <-) ...) (flatenv '((top))))
(list
 'end
 (list
  'meval
  '(λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))
  (flatenv '((let (_) (-> (app f2 #f) <-))))))
(list 'result '(app ... (-> #t <-) ...) (flatenv '((top))))
(list
 'end
 (list
  'meval
  '(let (_) (-> (app f2 #f) <-))
  (flatenv
   '((λ (x1)
       (->
        (app
         (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
         (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
        <-))))))
(list 'result '(app ... (-> #f <-) ...) (flatenv '((top))))
(list
 'end
 (list
  'meval
  '(let (_) (-> (app f2 #f) <-))
  (flatenv
   '((λ (x1)
       (->
        (app
         (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
         (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
        <-))))))
(list 'result '(app ... (-> #t <-) ...) (flatenv '((top))))
(list
 'end
 (list
  'meval
  '(app (-> f2 <-) ...)
  (flatenv
   '((λ (x1)
       (->
        (app
         (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
         (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
        <-))))))
(list
 'result
 '(app ... (-> (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))) <-) ...)
 (flatenv '((let (_) (-> (app f1 #f) <-)))))
'(eval-args (#t))
(list
 'bind-args
 '(x2)
 (flatenv '((let ((-> _ = (app f2 #t) <-)) bod)))
 '((clos/con: #t)))
(list
 'extend-store
 'x2
 (flatenv '((let ((-> _ = (app f2 #t) <-)) bod)))
 '(clos/con: #t))
(list 'bind-args '() (flatenv '((let ((-> _ = (app f2 #t) <-)) bod))) '())
(list
 'rebind-vars
 '(λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))
 '(x1)
 (flatenv '((let (_) (-> (app f1 #f) <-))))
 (flatenv '((let ((-> _ = (app f2 #t) <-)) bod))))
(list
 'extend-store
 'x1
 (flatenv '((let ((-> _ = (app f2 #t) <-)) bod)))
 '(clos/con: #f))
(list
 'rebind-vars
 '(λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))
 '()
 (flatenv '((let (_) (-> (app f1 #f) <-))))
 (flatenv '((let ((-> _ = (app f2 #t) <-)) bod))))
(list
 'extend-store
 'x1
 (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))))
 '(clos/con: #f))
(list
 'rebind-vars
 '(λ (z) (-> (app z x1 x2) <-))
 '()
 (flatenv '((let ((-> _ = (app f2 #t) <-)) bod)))
 (flatenv '((λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-)))))
(list
 'end
 (list
  'meval
  '(λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))
  (flatenv '((let ((-> _ = (app f2 #t) <-)) bod)))))
(list 'result '(app ... (-> #f <-) ...) (flatenv '((top))))
(list
 'end
 (list
  'meval
  '(λ (x2) (-> (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1)) <-))
  (flatenv '((let ((-> _ = (app f2 #t) <-)) bod)))))
(list 'result '(app ... (-> #t <-) ...) (flatenv '((top))))
(list
 'end
 (list
  'meval
  '(let ((-> _ = (app f2 #t) <-)) bod)
  (flatenv
   '((λ (x1)
       (->
        (app
         (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
         (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
        <-))))))
(list 'result '(app ... (-> #f <-) ...) (flatenv '((top))))
(list
 'end
 (list
  'meval
  '(let ((-> _ = (app f2 #t) <-)) bod)
  (flatenv
   '((λ (x1)
       (->
        (app
         (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
         (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
        <-))))))
(list 'result '(app ... (-> #t <-) ...) (flatenv '((top))))
(list
 'end
 (list
  'meval
  '(λ (x1)
     (->
      (app
       (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
       (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
      <-))
  (flatenv '((let (_) (-> (app f1 #f) <-))))))
(list 'result '(app ... (-> #f <-) ...) (flatenv '((top))))
(list 'end (list 'meval '(let (_) (-> (app f1 #f) <-)) (flatenv '((top)))))
(list 'result '(app ... (-> #f <-) ...) (flatenv '((top))))
(list
 'end
 (list
  'meval
  '(λ (f1) (-> (let ((_ (app f1 #t))) (app f1 #f)) <-))
  (flatenv '((top)))))
(list 'result '(app ... (-> #f <-) ...) (flatenv '((top))))
(list 'end (list 'meval '(top) (flatenv '())))
(list 'result '(app ... (-> #f <-) ...) (flatenv '((top))))
(list
 'end
 (list
  'meval
  '(λ (f1) (-> (let ((_ (app f1 #t))) (app f1 #f)) <-))
  (flatenv '((top)))))
(list 'result '(app ... (-> #f <-) ...) (flatenv '((top))))
(list
 'end
 (list
  'meval
  '(λ (x1)
     (->
      (app
       (λ (f2) (let ((_ (app f2 #t))) (app f2 #f)))
       (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))
      <-))
  (flatenv '((let (_) (-> (app f1 #f) <-))))))
(list 'result '(app ... (-> #t <-) ...) (flatenv '((top))))
(list 'end (list 'meval '(let (_) (-> (app f1 #f) <-)) (flatenv '((top)))))
(list 'result '(app ... (-> #t <-) ...) (flatenv '((top))))
(list
 'end
 (list
  'meval
  '(λ (f1) (-> (let ((_ (app f1 #t))) (app f1 #f)) <-))
  (flatenv '((top)))))
(list 'result '(app ... (-> #t <-) ...) (flatenv '((top))))
(list 'end (list 'meval '(top) (flatenv '())))
(list 'result '(app ... (-> #t <-) ...) (flatenv '((top))))
(list
 'end
 (list
  'meval
  '(λ (f1) (-> (let ((_ (app f1 #t))) (app f1 #f)) <-))
  (flatenv '((top)))))
(list 'result '(app ... (-> #t <-) ...) (flatenv '((top))))
'(clos/con: (#t #f))
'(literals: (⊥ ⊥ ⊥ ⊥))
