'(expression:
  (lettypes
   ((cons car cdr) (nil))
   (letrec*
    ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
     (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
     (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
     (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
     (map
      (λ (map-f map-l)
        (match
         map-l
         ((cons map-c map-d)
          (app cons (app map-f map-c) (app map map-f map-d)))
         ((nil) (app nil)))))
     (pair?
      (λ (pair?-v)
        (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
     (deriv
      (λ (a)
        (match
         (app not (app pair? a))
         ((#f)
          (match
           (app eq? (app car a) '+)
           ((#f)
            (match
             (app eq? (app car a) '-)
             ((#f)
              (match
               (app eq? (app car a) '*)
               ((#f)
                (match
                 (app eq? (app car a) '/)
                 ((#f) (app error (app #f) "No derivation method available"))
                 (_
                  (app
                   cons
                   '-
                   (app
                    cons
                    (app
                     cons
                     '/
                     (app
                      cons
                      (app deriv (app cadr a))
                      (app cons (app caddr a) (app nil))))
                    (app
                     cons
                     (app
                      cons
                      '/
                      (app
                       cons
                       (app cadr a)
                       (app
                        cons
                        (app
                         cons
                         '*
                         (app
                          cons
                          (app caddr a)
                          (app
                           cons
                           (app caddr a)
                           (app cons (app deriv (app caddr a)) (app nil)))))
                        (app nil))))
                     (app nil)))))))
               (_
                (app
                 cons
                 '*
                 (app
                  cons
                  a
                  (app
                   cons
                   (app
                    cons
                    '+
                    (app
                     map
                     (λ (a)
                       (app
                        cons
                        '/
                        (app cons (app deriv a) (app cons a (app nil)))))
                     (app cdr a)))
                   (app nil)))))))
             (_ (app cons '- (app map deriv (app cdr a))))))
           (_ (app cons '+ (app map deriv (app cdr a))))))
         (_ (match (app eq? a 'x) ((#f) 0) (_ 1)))))))
    (app
     deriv
     (app
      cons
      '+
      (app
       cons
       (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
        (app
         cons
         (app cons '* (app cons 'b (app cons 'x (app nil))))
         (app cons 5 (app nil))))))))))

'(query:
  (app
   (-> cons <-)
   '*
   (app
    cons
    (app caddr a)
    (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))))
  (env ()))
clos/con:
	'((app
   (-> cons <-)
   '*
   (app
    cons
    (app caddr a)
    (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   '*
   (app
    cons
    a
    (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
  (env ()))
clos/con:
	'((app
   (-> cons <-)
   '*
   (app
    cons
    a
    (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   '+
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
clos/con:
	'((app
   (-> cons <-)
   '+
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   '-
   (app
    cons
    (app
     cons
     '/
     (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil))))
    (app
     cons
     (app
      cons
      '/
      (app
       cons
       (app cadr a)
       (app
        cons
        (app
         cons
         '*
         (app
          cons
          (app caddr a)
          (app
           cons
           (app caddr a)
           (app cons (app deriv (app caddr a)) (app nil)))))
        (app nil))))
     (app nil))))
  (env ()))
clos/con:
	'((app
   (-> cons <-)
   '-
   (app
    cons
    (app
     cons
     '/
     (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil))))
    (app
     cons
     (app
      cons
      '/
      (app
       cons
       (app cadr a)
       (app
        cons
        (app
         cons
         '*
         (app
          cons
          (app caddr a)
          (app
           cons
           (app caddr a)
           (app cons (app deriv (app caddr a)) (app nil)))))
        (app nil))))
     (app nil))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   '/
   (app
    cons
    (app cadr a)
    (app
     cons
     (app
      cons
      '*
      (app
       cons
       (app caddr a)
       (app
        cons
        (app caddr a)
        (app cons (app deriv (app caddr a)) (app nil)))))
     (app nil))))
  (env ()))
clos/con:
	'((app
   (-> cons <-)
   '/
   (app
    cons
    (app cadr a)
    (app
     cons
     (app
      cons
      '*
      (app
       cons
       (app caddr a)
       (app
        cons
        (app caddr a)
        (app cons (app deriv (app caddr a)) (app nil)))))
     (app nil))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   '/
   (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil))))
  (env ()))
clos/con:
	'((app
   (-> cons <-)
   '/
   (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   (app
    cons
    '*
    (app
     cons
     (app caddr a)
     (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))))
   (app nil))
  (env ()))
clos/con:
	'((app
   (-> cons <-)
   (app
    cons
    '*
    (app
     cons
     (app caddr a)
     (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))))
   (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   (app
    cons
    '/
    (app
     cons
     (app cadr a)
     (app
      cons
      (app
       cons
       '*
       (app
        cons
        (app caddr a)
        (app
         cons
         (app caddr a)
         (app cons (app deriv (app caddr a)) (app nil)))))
      (app nil))))
   (app nil))
  (env ()))
clos/con:
	'((app
   (-> cons <-)
   (app
    cons
    '/
    (app
     cons
     (app cadr a)
     (app
      cons
      (app
       cons
       '*
       (app
        cons
        (app caddr a)
        (app
         cons
         (app caddr a)
         (app cons (app deriv (app caddr a)) (app nil)))))
      (app nil))))
   (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   (app
    cons
    '/
    (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil))))
   (app
    cons
    (app
     cons
     '/
     (app
      cons
      (app cadr a)
      (app
       cons
       (app
        cons
        '*
        (app
         cons
         (app caddr a)
         (app
          cons
          (app caddr a)
          (app cons (app deriv (app caddr a)) (app nil)))))
       (app nil))))
    (app nil)))
  (env ()))
clos/con:
	'((app
   (-> cons <-)
   (app
    cons
    '/
    (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil))))
   (app
    cons
    (app
     cons
     '/
     (app
      cons
      (app cadr a)
      (app
       cons
       (app
        cons
        '*
        (app
         cons
         (app caddr a)
         (app
          cons
          (app caddr a)
          (app cons (app deriv (app caddr a)) (app nil)))))
       (app nil))))
    (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   (app caddr a)
   (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil))))
  (env ()))
clos/con:
	'((app
   (-> cons <-)
   (app caddr a)
   (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   (app caddr a)
   (app cons (app deriv (app caddr a)) (app nil)))
  (env ()))
clos/con:
	'((app
   (-> cons <-)
   (app caddr a)
   (app cons (app deriv (app caddr a)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   (app cadr a)
   (app
    cons
    (app
     cons
     '*
     (app
      cons
      (app caddr a)
      (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))))
    (app nil)))
  (env ()))
clos/con:
	'((app
   (-> cons <-)
   (app cadr a)
   (app
    cons
    (app
     cons
     '*
     (app
      cons
      (app caddr a)
      (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))))
    (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app
    cons
    (app cons '* (app cons 'b (app cons 'x (app nil))))
    (app cons 5 (app nil))))
  (env ()))
clos/con:
	'((app
   (-> cons <-)
   (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app
    cons
    (app cons '* (app cons 'b (app cons 'x (app nil))))
    (app cons 5 (app nil))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   (app cons '* (app cons 'b (app cons 'x (app nil))))
   (app cons 5 (app nil)))
  (env ()))
clos/con:
	'((app
   (-> cons <-)
   (app cons '* (app cons 'b (app cons 'x (app nil))))
   (app cons 5 (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app
    cons
    (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
clos/con:
	'((app
   (-> cons <-)
   (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app
    cons
    (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   (app deriv (app cadr a))
   (app cons (app caddr a) (app nil)))
  (env ()))
clos/con:
	'((app
   (-> cons <-)
   (app deriv (app cadr a))
   (app cons (app caddr a) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   a
   (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil)))
  (env ()))
clos/con:
	'((app
   (-> cons <-)
   a
   (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   (-> deriv <-)
   (app
    cons
    '+
    (app
     cons
     (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'b (app cons 'x (app nil))))
       (app cons 5 (app nil)))))))
  (env ()))
clos/con:
	'((letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   '*
   (->
    (app
     cons
     (app caddr a)
     (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil))))
    <-))
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    '*
    (->
     (app
      cons
      (app caddr a)
      (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil))))
     <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   '*
   (->
    (app
     cons
     a
     (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil)))
    <-))
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    '*
    (->
     (app
      cons
      a
      (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil)))
     <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   '+
   (->
    (app
     cons
     (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'b (app cons 'x (app nil))))
       (app cons 5 (app nil)))))
    <-))
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    '+
    (->
     (app
      cons
      (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'b (app cons 'x (app nil))))
        (app cons 5 (app nil)))))
     <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   '-
   (->
    (app
     cons
     (app
      cons
      '/
      (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil))))
     (app
      cons
      (app
       cons
       '/
       (app
        cons
        (app cadr a)
        (app
         cons
         (app
          cons
          '*
          (app
           cons
           (app caddr a)
           (app
            cons
            (app caddr a)
            (app cons (app deriv (app caddr a)) (app nil)))))
         (app nil))))
      (app nil)))
    <-))
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    '-
    (->
     (app
      cons
      (app
       cons
       '/
       (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil))))
      (app
       cons
       (app
        cons
        '/
        (app
         cons
         (app cadr a)
         (app
          cons
          (app
           cons
           '*
           (app
            cons
            (app caddr a)
            (app
             cons
             (app caddr a)
             (app cons (app deriv (app caddr a)) (app nil)))))
          (app nil))))
       (app nil)))
     <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   '/
   (->
    (app
     cons
     (app cadr a)
     (app
      cons
      (app
       cons
       '*
       (app
        cons
        (app caddr a)
        (app
         cons
         (app caddr a)
         (app cons (app deriv (app caddr a)) (app nil)))))
      (app nil)))
    <-))
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    '/
    (->
     (app
      cons
      (app cadr a)
      (app
       cons
       (app
        cons
        '*
        (app
         cons
         (app caddr a)
         (app
          cons
          (app caddr a)
          (app cons (app deriv (app caddr a)) (app nil)))))
       (app nil)))
     <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   '/
   (->
    (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil)))
    <-))
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    '/
    (->
     (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil)))
     <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (->
    (app
     cons
     '*
     (app
      cons
      (app caddr a)
      (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))))
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
      '*
      (app
       cons
       (app caddr a)
       (app
        cons
        (app caddr a)
        (app cons (app deriv (app caddr a)) (app nil)))))
     <-)
    (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (->
    (app
     cons
     '/
     (app
      cons
      (app cadr a)
      (app
       cons
       (app
        cons
        '*
        (app
         cons
         (app caddr a)
         (app
          cons
          (app caddr a)
          (app cons (app deriv (app caddr a)) (app nil)))))
       (app nil))))
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
      '/
      (app
       cons
       (app cadr a)
       (app
        cons
        (app
         cons
         '*
         (app
          cons
          (app caddr a)
          (app
           cons
           (app caddr a)
           (app cons (app deriv (app caddr a)) (app nil)))))
        (app nil))))
     <-)
    (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (->
    (app
     cons
     '/
     (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil))))
    <-)
   (app
    cons
    (app
     cons
     '/
     (app
      cons
      (app cadr a)
      (app
       cons
       (app
        cons
        '*
        (app
         cons
         (app caddr a)
         (app
          cons
          (app caddr a)
          (app cons (app deriv (app caddr a)) (app nil)))))
       (app nil))))
    (app nil)))
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (->
     (app
      cons
      '/
      (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil))))
     <-)
    (app
     cons
     (app
      cons
      '/
      (app
       cons
       (app cadr a)
       (app
        cons
        (app
         cons
         '*
         (app
          cons
          (app caddr a)
          (app
           cons
           (app caddr a)
           (app cons (app deriv (app caddr a)) (app nil)))))
        (app nil))))
     (app nil))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> '* <-)
   (app
    cons
    (app caddr a)
    (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))))
  (env ()))
clos/con:
	'((app
   cons
   (-> '* <-)
   (app
    cons
    (app caddr a)
    (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> '* <-)
   (app
    cons
    a
    (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
  (env ()))
clos/con:
	'((app
   cons
   (-> '* <-)
   (app
    cons
    a
    (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> '- <-)
   (app
    cons
    (app
     cons
     '/
     (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil))))
    (app
     cons
     (app
      cons
      '/
      (app
       cons
       (app cadr a)
       (app
        cons
        (app
         cons
         '*
         (app
          cons
          (app caddr a)
          (app
           cons
           (app caddr a)
           (app cons (app deriv (app caddr a)) (app nil)))))
        (app nil))))
     (app nil))))
  (env ()))
clos/con:
	'((app
   cons
   (-> '- <-)
   (app
    cons
    (app
     cons
     '/
     (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil))))
    (app
     cons
     (app
      cons
      '/
      (app
       cons
       (app cadr a)
       (app
        cons
        (app
         cons
         '*
         (app
          cons
          (app caddr a)
          (app
           cons
           (app caddr a)
           (app cons (app deriv (app caddr a)) (app nil)))))
        (app nil))))
     (app nil))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> '/ <-)
   (app
    cons
    (app cadr a)
    (app
     cons
     (app
      cons
      '*
      (app
       cons
       (app caddr a)
       (app
        cons
        (app caddr a)
        (app cons (app deriv (app caddr a)) (app nil)))))
     (app nil))))
  (env ()))
clos/con:
	'((app
   cons
   (-> '/ <-)
   (app
    cons
    (app cadr a)
    (app
     cons
     (app
      cons
      '*
      (app
       cons
       (app caddr a)
       (app
        cons
        (app caddr a)
        (app cons (app deriv (app caddr a)) (app nil)))))
     (app nil))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> '/ <-)
   (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil))))
  (env ()))
clos/con:
	'((app
   cons
   (-> '/ <-)
   (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> (app caddr a) <-)
   (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil))))
  (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> (app caddr a) <-)
   (app cons (app deriv (app caddr a)) (app nil)))
  (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> (app cadr a) <-)
   (app
    cons
    (app
     cons
     '*
     (app
      cons
      (app caddr a)
      (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))))
    (app nil)))
  (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
   (app
    cons
    (app cons '* (app cons 'b (app cons 'x (app nil))))
    (app cons 5 (app nil))))
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
   (app cons 5 (app nil)))
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
   (app
    cons
    (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> (app deriv (app cadr a)) <-)
   (app cons (app caddr a) (app nil)))
  (env ()))
clos/con:
	'((con
   cons
   (match
    (app eq? (app car a) '*)
    (#f)
    (_
     (->
      (app
       cons
       '*
       (app
        cons
        a
        (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
      <-))))
  (env ()))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env ()))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ()))
	'((con
   cons
   (match
    (app eq? (app car a) '/)
    (#f)
    (_
     (->
      (app
       cons
       '-
       (app
        cons
        (app
         cons
         '/
         (app
          cons
          (app deriv (app cadr a))
          (app cons (app caddr a) (app nil))))
        (app
         cons
         (app
          cons
          '/
          (app
           cons
           (app cadr a)
           (app
            cons
            (app
             cons
             '*
             (app
              cons
              (app caddr a)
              (app
               cons
               (app caddr a)
               (app cons (app deriv (app caddr a)) (app nil)))))
            (app nil))))
         (app nil))))
      <-))))
  (env ()))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> a <-)
   (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil)))
  (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((con
   cons
   (app
    deriv
    (->
     (app
      cons
      '+
      (app
       cons
       (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
        (app
         cons
         (app cons '* (app cons 'b (app cons 'x (app nil))))
         (app cons 5 (app nil))))))
     <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (app
    cons
    '*
    (app
     cons
     (app caddr a)
     (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))))
   (-> (app nil) <-))
  (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (app
    cons
    '/
    (app
     cons
     (app cadr a)
     (app
      cons
      (app
       cons
       '*
       (app
        cons
        (app caddr a)
        (app
         cons
         (app caddr a)
         (app cons (app deriv (app caddr a)) (app nil)))))
      (app nil))))
   (-> (app nil) <-))
  (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (app
    cons
    '/
    (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil))))
   (->
    (app
     cons
     (app
      cons
      '/
      (app
       cons
       (app cadr a)
       (app
        cons
        (app
         cons
         '*
         (app
          cons
          (app caddr a)
          (app
           cons
           (app caddr a)
           (app cons (app deriv (app caddr a)) (app nil)))))
        (app nil))))
     (app nil))
    <-))
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (app
     cons
     '/
     (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil))))
    (->
     (app
      cons
      (app
       cons
       '/
       (app
        cons
        (app cadr a)
        (app
         cons
         (app
          cons
          '*
          (app
           cons
           (app caddr a)
           (app
            cons
            (app caddr a)
            (app cons (app deriv (app caddr a)) (app nil)))))
         (app nil))))
      (app nil))
     <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (app caddr a)
   (->
    (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))
    <-))
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (app caddr a)
    (->
     (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))
     <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (app caddr a)
   (-> (app cons (app deriv (app caddr a)) (app nil)) <-))
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (app caddr a)
    (-> (app cons (app deriv (app caddr a)) (app nil)) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (app cadr a)
   (->
    (app
     cons
     (app
      cons
      '*
      (app
       cons
       (app caddr a)
       (app
        cons
        (app caddr a)
        (app cons (app deriv (app caddr a)) (app nil)))))
     (app nil))
    <-))
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (app cadr a)
    (->
     (app
      cons
      (app
       cons
       '*
       (app
        cons
        (app caddr a)
        (app
         cons
         (app caddr a)
         (app cons (app deriv (app caddr a)) (app nil)))))
      (app nil))
     <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (->
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))
    <-))
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
    (->
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil)))
     <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (app cons '* (app cons 'b (app cons 'x (app nil))))
   (-> (app cons 5 (app nil)) <-))
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 'b (app cons 'x (app nil))))
    (-> (app cons 5 (app nil)) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (->
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))
    <-))
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (->
     (app
      cons
      (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'b (app cons 'x (app nil))))
       (app cons 5 (app nil))))
     <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (app deriv (app cadr a))
   (-> (app cons (app caddr a) (app nil)) <-))
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (app deriv (app cadr a))
    (-> (app cons (app caddr a) (app nil)) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   a
   (->
    (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))
    <-))
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    a
    (->
     (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))
     <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   deriv
   (->
    (app
     cons
     '+
     (app
      cons
      (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'b (app cons 'x (app nil))))
        (app cons 5 (app nil))))))
    <-))
  (env ()))
clos/con:
	'((con
   cons
   (app
    deriv
    (->
     (app
      cons
      '+
      (app
       cons
       (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
        (app
         cons
         (app cons '* (app cons 'b (app cons 'x (app nil))))
         (app cons 5 (app nil))))))
     <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app (-> cons <-) '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
clos/con:
	'((app (-> cons <-) '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app (-> cons <-) '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
clos/con:
	'((app (-> cons <-) '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app (-> cons <-) '/ (app cons (app deriv a) (app cons a (app nil))))
  (env ()))
clos/con:
	'((app (-> cons <-) '/ (app cons (app deriv a) (app cons a (app nil))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app (-> cons <-) (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))
  (env ()))
clos/con:
	'((app (-> cons <-) (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app (-> error <-) (app #f) "No derivation method available")
  (env ()))
clos/con:
	'((app (-> error <-) (app #f) "No derivation method available") (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-))
  (env ()))
clos/con:
	'((con
   cons
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-))
  (env ()))
clos/con:
	'((con
   cons
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app cons '/ (-> (app cons (app deriv a) (app cons a (app nil))) <-))
  (env ()))
clos/con:
	'((con
   cons
   (app cons '/ (-> (app cons (app deriv a) (app cons a (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
clos/con:
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
clos/con:
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app cons (-> '/ <-) (app cons (app deriv a) (app cons a (app nil))))
  (env ()))
clos/con:
	'((app cons (-> '/ <-) (app cons (app deriv a) (app cons a (app nil))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app cons (-> (app cons '+ (app map (λ (a) ...) (app cdr a))) <-) (app nil))
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons '+ (app map (λ (a) ...) (app cdr a))) <-)
    (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (-> (app nil) <-))
  (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app error (-> (app #f) <-) "No derivation method available")
  (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app error (app #f) (-> "No derivation method available" <-))
  (env ()))
clos/con: ⊥
literals: '(⊥ ⊥ ⊥ "No derivation method available")

'(query:
  (letrec*
   (car ... deriv)
   (->
    (app
     deriv
     (app
      cons
      '+
      (app
       cons
       (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
        (app
         cons
         (app cons '* (app cons 'b (app cons 'x (app nil))))
         (app cons 5 (app nil)))))))
    <-))
  (env ()))
clos/con:
	'((con
   cons
   (match
    (app eq? (app car a) '*)
    (#f)
    (_
     (->
      (app
       cons
       '*
       (app
        cons
        a
        (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
      <-))))
  (env ()))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env ()))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ()))
	'((con
   cons
   (match
    (app eq? (app car a) '/)
    (#f)
    (_
     (->
      (app
       cons
       '-
       (app
        cons
        (app
         cons
         '/
         (app
          cons
          (app deriv (app cadr a))
          (app cons (app caddr a) (app nil))))
        (app
         cons
         (app
          cons
          '/
          (app
           cons
           (app cadr a)
           (app
            cons
            (app
             cons
             '*
             (app
              cons
              (app caddr a)
              (app
               cons
               (app caddr a)
               (app cons (app deriv (app caddr a)) (app nil)))))
            (app nil))))
         (app nil))))
      <-))))
  (env ()))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query:
  (letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) pair? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) pair? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec* (... cadr (caddr (-> (λ (cadr-v) ...) <-)) map ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cadr (caddr (-> (λ (cadr-v) ...) <-)) map ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec* (... cdr (cadr (-> (λ (cadr-v) ...) <-)) caddr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cdr (cadr (-> (λ (cadr-v) ...) <-)) caddr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec* (... map (pair? (-> (λ (pair?-v) ...) <-)) deriv ...) ...)
  (env ()))
clos/con:
	'((letrec* (... map (pair? (-> (λ (pair?-v) ...) <-)) deriv ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match
   (app eq? (app car a) '*)
   (#f)
   (_
    (->
     (app
      cons
      '*
      (app
       cons
       a
       (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
     <-)))
  (env ()))
clos/con:
	'((con
   cons
   (match
    (app eq? (app car a) '*)
    (#f)
    (_
     (->
      (app
       cons
       '*
       (app
        cons
        a
        (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
      <-))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match
   (app eq? (app car a) '*)
   ((#f) (-> (match (app eq? (app car a) '/) ...) <-))
   _)
  (env ()))
clos/con:
	'((con
   cons
   (match
    (app eq? (app car a) '/)
    (#f)
    (_
     (->
      (app
       cons
       '-
       (app
        cons
        (app
         cons
         '/
         (app
          cons
          (app deriv (app cadr a))
          (app cons (app caddr a) (app nil))))
        (app
         cons
         (app
          cons
          '/
          (app
           cons
           (app cadr a)
           (app
            cons
            (app
             cons
             '*
             (app
              cons
              (app caddr a)
              (app
               cons
               (app caddr a)
               (app cons (app deriv (app caddr a)) (app nil)))))
            (app nil))))
         (app nil))))
      <-))))
  (env ()))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match
   (app eq? (app car a) '+)
   (#f)
   (_ (-> (app cons '+ (app map deriv (app cdr a))) <-)))
  (env ()))
clos/con:
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match
   (app eq? (app car a) '+)
   ((#f) (-> (match (app eq? (app car a) '-) ...) <-))
   _)
  (env ()))
clos/con:
	'((con
   cons
   (match
    (app eq? (app car a) '*)
    (#f)
    (_
     (->
      (app
       cons
       '*
       (app
        cons
        a
        (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
      <-))))
  (env ()))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ()))
	'((con
   cons
   (match
    (app eq? (app car a) '/)
    (#f)
    (_
     (->
      (app
       cons
       '-
       (app
        cons
        (app
         cons
         '/
         (app
          cons
          (app deriv (app cadr a))
          (app cons (app caddr a) (app nil))))
        (app
         cons
         (app
          cons
          '/
          (app
           cons
           (app cadr a)
           (app
            cons
            (app
             cons
             '*
             (app
              cons
              (app caddr a)
              (app
               cons
               (app caddr a)
               (app cons (app deriv (app caddr a)) (app nil)))))
            (app nil))))
         (app nil))))
      <-))))
  (env ()))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match
   (app eq? (app car a) '-)
   (#f)
   (_ (-> (app cons '- (app map deriv (app cdr a))) <-)))
  (env ()))
clos/con:
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match
   (app eq? (app car a) '-)
   ((#f) (-> (match (app eq? (app car a) '*) ...) <-))
   _)
  (env ()))
clos/con:
	'((con
   cons
   (match
    (app eq? (app car a) '*)
    (#f)
    (_
     (->
      (app
       cons
       '*
       (app
        cons
        a
        (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
      <-))))
  (env ()))
	'((con
   cons
   (match
    (app eq? (app car a) '/)
    (#f)
    (_
     (->
      (app
       cons
       '-
       (app
        cons
        (app
         cons
         '/
         (app
          cons
          (app deriv (app cadr a))
          (app cons (app caddr a) (app nil))))
        (app
         cons
         (app
          cons
          '/
          (app
           cons
           (app cadr a)
           (app
            cons
            (app
             cons
             '*
             (app
              cons
              (app caddr a)
              (app
               cons
               (app caddr a)
               (app cons (app deriv (app caddr a)) (app nil)))))
            (app nil))))
         (app nil))))
      <-))))
  (env ()))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match
   (app eq? (app car a) '/)
   (#f)
   (_
    (->
     (app
      cons
      '-
      (app
       cons
       (app
        cons
        '/
        (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil))))
       (app
        cons
        (app
         cons
         '/
         (app
          cons
          (app cadr a)
          (app
           cons
           (app
            cons
            '*
            (app
             cons
             (app caddr a)
             (app
              cons
              (app caddr a)
              (app cons (app deriv (app caddr a)) (app nil)))))
           (app nil))))
        (app nil))))
     <-)))
  (env ()))
clos/con:
	'((con
   cons
   (match
    (app eq? (app car a) '/)
    (#f)
    (_
     (->
      (app
       cons
       '-
       (app
        cons
        (app
         cons
         '/
         (app
          cons
          (app deriv (app cadr a))
          (app cons (app caddr a) (app nil))))
        (app
         cons
         (app
          cons
          '/
          (app
           cons
           (app cadr a)
           (app
            cons
            (app
             cons
             '*
             (app
              cons
              (app caddr a)
              (app
               cons
               (app caddr a)
               (app cons (app deriv (app caddr a)) (app nil)))))
            (app nil))))
         (app nil))))
      <-))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match
   (app eq? (app car a) '/)
   ((#f) (-> (app error (app #f) "No derivation method available") <-))
   _)
  (env ()))
clos/con:
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match
   (app not (app pair? a))
   ((#f) (-> (match (app eq? (app car a) '+) ...) <-))
   _)
  (env ()))
clos/con:
	'((con
   cons
   (match
    (app eq? (app car a) '*)
    (#f)
    (_
     (->
      (app
       cons
       '*
       (app
        cons
        a
        (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
      <-))))
  (env ()))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env ()))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ()))
	'((con
   cons
   (match
    (app eq? (app car a) '/)
    (#f)
    (_
     (->
      (app
       cons
       '-
       (app
        cons
        (app
         cons
         '/
         (app
          cons
          (app deriv (app cadr a))
          (app cons (app caddr a) (app nil))))
        (app
         cons
         (app
          cons
          '/
          (app
           cons
           (app cadr a)
           (app
            cons
            (app
             cons
             '*
             (app
              cons
              (app caddr a)
              (app
               cons
               (app caddr a)
               (app cons (app deriv (app caddr a)) (app nil)))))
            (app nil))))
         (app nil))))
      <-))))
  (env ()))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match
   map-l
   ((cons map-c map-d)
    (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
   (nil))
  (env ()))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match (app not (app pair? a)) (#f) (_ (-> (match (app eq? a 'x) ...) <-)))
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query:
  (λ (a) (-> (app cons '/ (app cons (app deriv a) (app cons a (app nil)))) <-))
  (env ()))
clos/con:
	'((con
   cons
   (λ (a)
     (-> (app cons '/ (app cons (app deriv a) (app cons a (app nil)))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: ((top) lettypes (cons ... nil) ...) (env ()))
clos/con:
	'((con
   cons
   (match
    (app eq? (app car a) '*)
    (#f)
    (_
     (->
      (app
       cons
       '*
       (app
        cons
        a
        (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
      <-))))
  (env ()))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env ()))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ()))
	'((con
   cons
   (match
    (app eq? (app car a) '/)
    (#f)
    (_
     (->
      (app
       cons
       '-
       (app
        cons
        (app
         cons
         '/
         (app
          cons
          (app deriv (app cadr a))
          (app cons (app caddr a) (app nil))))
        (app
         cons
         (app
          cons
          '/
          (app
           cons
           (app cadr a)
           (app
            cons
            (app
             cons
             '*
             (app
              cons
              (app caddr a)
              (app
               cons
               (app caddr a)
               (app cons (app deriv (app caddr a)) (app nil)))))
            (app nil))))
         (app nil))))
      <-))))
  (env ()))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ()))
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

'(query: (app (-> caddr <-) a) (env ()))
clos/con:
	'((letrec* (... cadr (caddr (-> (λ (cadr-v) ...) <-)) map ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> caddr <-) a) (env ()))
clos/con:
	'((letrec* (... cadr (caddr (-> (λ (cadr-v) ...) <-)) map ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> caddr <-) a) (env ()))
clos/con:
	'((letrec* (... cadr (caddr (-> (λ (cadr-v) ...) <-)) map ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> caddr <-) a) (env ()))
clos/con:
	'((letrec* (... cadr (caddr (-> (λ (cadr-v) ...) <-)) map ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cadr <-) a) (env ()))
clos/con:
	'((letrec* (... cdr (cadr (-> (λ (cadr-v) ...) <-)) caddr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cadr <-) a) (env ()))
clos/con:
	'((letrec* (... cdr (cadr (-> (λ (cadr-v) ...) <-)) caddr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> car <-) (app cdr (app cdr cadr-v))) (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> car <-) (app cdr cadr-v)) (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> car <-) a) (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> car <-) a) (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> car <-) a) (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> car <-) a) (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cdr <-) (app cdr cadr-v)) (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cdr <-) a) (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cdr <-) a) (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cdr <-) a) (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cdr <-) cadr-v) (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cdr <-) cadr-v) (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) '* (app cons 'b (app cons 'x (app nil)))) (env ()))
clos/con:
	'((app (-> cons <-) '* (app cons 'b (app cons 'x (app nil)))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) '+ (app map (λ (a) ...) (app cdr a))) (env ()))
clos/con:
	'((app (-> cons <-) '+ (app map (λ (a) ...) (app cdr a))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) '+ (app map deriv (app cdr a))) (env ()))
clos/con:
	'((app (-> cons <-) '+ (app map deriv (app cdr a))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) '- (app map deriv (app cdr a))) (env ()))
clos/con:
	'((app (-> cons <-) '- (app map deriv (app cdr a))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 'a (app cons 'x (app cons 'x (app nil)))) (env ()))
clos/con:
	'((app (-> cons <-) 'a (app cons 'x (app cons 'x (app nil)))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 'b (app cons 'x (app nil))) (env ()))
clos/con:
	'((app (-> cons <-) 'b (app cons 'x (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 'x (app cons 'x (app nil))) (env ()))
clos/con:
	'((app (-> cons <-) 'x (app cons 'x (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 'x (app cons 'x (app nil))) (env ()))
clos/con:
	'((app (-> cons <-) 'x (app cons 'x (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 'x (app nil)) (env ()))
clos/con:
	'((app (-> cons <-) 'x (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 'x (app nil)) (env ()))
clos/con:
	'((app (-> cons <-) 'x (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 'x (app nil)) (env ()))
clos/con:
	'((app (-> cons <-) 'x (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) (app caddr a) (app nil)) (env ()))
clos/con:
	'((app (-> cons <-) (app caddr a) (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) (app deriv (app caddr a)) (app nil)) (env ()))
clos/con:
	'((app (-> cons <-) (app deriv (app caddr a)) (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) (app deriv a) (app cons a (app nil))) (env ()))
clos/con:
	'((app (-> cons <-) (app deriv a) (app cons a (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) (app map-f map-c) (app map map-f map-d)) (env ()))
clos/con:
	'((app (-> cons <-) (app map-f map-c) (app map map-f map-d)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 3 (app cons 'x (app cons 'x (app nil)))) (env ()))
clos/con:
	'((app (-> cons <-) 3 (app cons 'x (app cons 'x (app nil)))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 5 (app nil)) (env ()))
clos/con:
	'((app (-> cons <-) 5 (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) a (app nil)) (env ()))
clos/con:
	'((app (-> cons <-) a (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> deriv <-) (app caddr a)) (env ()))
clos/con:
	'((letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> deriv <-) (app cadr a)) (env ()))
clos/con:
	'((letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> deriv <-) a) (env ()))
clos/con:
	'((letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> eq? <-) (app car a) '*) (env ()))
clos/con:
	'((prim eq?) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> eq? <-) (app car a) '+) (env ()))
clos/con:
	'((prim eq?) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> eq? <-) (app car a) '-) (env ()))
clos/con:
	'((prim eq?) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> eq? <-) (app car a) '/) (env ()))
clos/con:
	'((prim eq?) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> eq? <-) a 'x) (env ()))
clos/con:
	'((prim eq?) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> map <-) (λ (a) ...) (app cdr a)) (env ()))
clos/con:
	'((letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) pair? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> map <-) deriv (app cdr a)) (env ()))
clos/con:
	'((letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) pair? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> map <-) deriv (app cdr a)) (env ()))
clos/con:
	'((letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) pair? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> map <-) map-f map-d) (env ()))
clos/con:
	'((letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) pair? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> map-f <-) map-c) (env ()))
clos/con:
	'((app map (-> (λ (a) ...) <-) (app cdr a)) (env ()))
	'((letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...) (env ()))
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

'(query: (app (-> not <-) (app pair? a)) (env ()))
clos/con:
	'((prim not) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> pair? <-) a) (env ()))
clos/con:
	'((letrec* (... map (pair? (-> (λ (pair?-v) ...) <-)) deriv ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app caddr (-> a <-)) (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((con
   cons
   (app
    deriv
    (->
     (app
      cons
      '+
      (app
       cons
       (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
        (app
         cons
         (app cons '* (app cons 'b (app cons 'x (app nil))))
         (app cons 5 (app nil))))))
     <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app caddr (-> a <-)) (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((con
   cons
   (app
    deriv
    (->
     (app
      cons
      '+
      (app
       cons
       (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
        (app
         cons
         (app cons '* (app cons 'b (app cons 'x (app nil))))
         (app cons 5 (app nil))))))
     <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app caddr (-> a <-)) (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((con
   cons
   (app
    deriv
    (->
     (app
      cons
      '+
      (app
       cons
       (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
        (app
         cons
         (app cons '* (app cons 'b (app cons 'x (app nil))))
         (app cons 5 (app nil))))))
     <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app caddr (-> a <-)) (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((con
   cons
   (app
    deriv
    (->
     (app
      cons
      '+
      (app
       cons
       (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
        (app
         cons
         (app cons '* (app cons 'b (app cons 'x (app nil))))
         (app cons 5 (app nil))))))
     <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app cadr (-> a <-)) (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((con
   cons
   (app
    deriv
    (->
     (app
      cons
      '+
      (app
       cons
       (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
        (app
         cons
         (app cons '* (app cons 'b (app cons 'x (app nil))))
         (app cons 5 (app nil))))))
     <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app cadr (-> a <-)) (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((con
   cons
   (app
    deriv
    (->
     (app
      cons
      '+
      (app
       cons
       (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
        (app
         cons
         (app cons '* (app cons 'b (app cons 'x (app nil))))
         (app cons 5 (app nil))))))
     <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app car (-> (app cdr (app cdr cadr-v)) <-)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    '+
    (->
     (app
      cons
      (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'b (app cons 'x (app nil))))
        (app cons 5 (app nil)))))
     <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
    (->
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 'b (app cons 'x (app nil))))
    (-> (app cons 5 (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (->
     (app
      cons
      (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'b (app cons 'x (app nil))))
       (app cons 5 (app nil))))
     <-)))
  (env ()))
	'((con
   cons
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con cons (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'b (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app car (-> (app cdr cadr-v) <-)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    '+
    (->
     (app
      cons
      (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'b (app cons 'x (app nil))))
        (app cons 5 (app nil)))))
     <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
    (->
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 'b (app cons 'x (app nil))))
    (-> (app cons 5 (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (->
     (app
      cons
      (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'b (app cons 'x (app nil))))
       (app cons 5 (app nil))))
     <-)))
  (env ()))
	'((con
   cons
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con cons (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'b (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app car (-> a <-)) (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((con
   cons
   (app
    deriv
    (->
     (app
      cons
      '+
      (app
       cons
       (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
        (app
         cons
         (app cons '* (app cons 'b (app cons 'x (app nil))))
         (app cons 5 (app nil))))))
     <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app car (-> a <-)) (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((con
   cons
   (app
    deriv
    (->
     (app
      cons
      '+
      (app
       cons
       (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
        (app
         cons
         (app cons '* (app cons 'b (app cons 'x (app nil))))
         (app cons 5 (app nil))))))
     <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app car (-> a <-)) (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((con
   cons
   (app
    deriv
    (->
     (app
      cons
      '+
      (app
       cons
       (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
        (app
         cons
         (app cons '* (app cons 'b (app cons 'x (app nil))))
         (app cons 5 (app nil))))))
     <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app car (-> a <-)) (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((con
   cons
   (app
    deriv
    (->
     (app
      cons
      '+
      (app
       cons
       (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
        (app
         cons
         (app cons '* (app cons 'b (app cons 'x (app nil))))
         (app cons 5 (app nil))))))
     <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app cdr (-> (app cdr cadr-v) <-)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    '+
    (->
     (app
      cons
      (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'b (app cons 'x (app nil))))
        (app cons 5 (app nil)))))
     <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
    (->
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 'b (app cons 'x (app nil))))
    (-> (app cons 5 (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (->
     (app
      cons
      (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'b (app cons 'x (app nil))))
       (app cons 5 (app nil))))
     <-)))
  (env ()))
	'((con
   cons
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con cons (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'b (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cdr (-> a <-)) (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((con
   cons
   (app
    deriv
    (->
     (app
      cons
      '+
      (app
       cons
       (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
        (app
         cons
         (app cons '* (app cons 'b (app cons 'x (app nil))))
         (app cons 5 (app nil))))))
     <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app cdr (-> a <-)) (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((con
   cons
   (app
    deriv
    (->
     (app
      cons
      '+
      (app
       cons
       (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
        (app
         cons
         (app cons '* (app cons 'b (app cons 'x (app nil))))
         (app cons 5 (app nil))))))
     <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app cdr (-> a <-)) (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((con
   cons
   (app
    deriv
    (->
     (app
      cons
      '+
      (app
       cons
       (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
        (app
         cons
         (app cons '* (app cons 'b (app cons 'x (app nil))))
         (app cons 5 (app nil))))))
     <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app cdr (-> cadr-v <-)) (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((con
   cons
   (app
    deriv
    (->
     (app
      cons
      '+
      (app
       cons
       (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
        (app
         cons
         (app cons '* (app cons 'b (app cons 'x (app nil))))
         (app cons 5 (app nil))))))
     <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app cdr (-> cadr-v <-)) (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((con
   cons
   (app
    deriv
    (->
     (app
      cons
      '+
      (app
       cons
       (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
        (app
         cons
         (app cons '* (app cons 'b (app cons 'x (app nil))))
         (app cons 5 (app nil))))))
     <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)) (env ()))
clos/con:
	'((con cons (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons '+ (-> (app map (λ (a) ...) (app cdr a)) <-)) (env ()))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons '+ (-> (app map deriv (app cdr a)) <-)) (env ()))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons '- (-> (app map deriv (app cdr a)) <-)) (env ()))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)) (env ()))
clos/con:
	'((con cons (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons 'b (-> (app cons 'x (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons 'b (-> (app cons 'x (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons 'x (-> (app cons 'x (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons 'x (-> (app cons 'x (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons 'x (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons 'x (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons 'x (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
clos/con:
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> '+ <-) (app map (λ (a) ...) (app cdr a))) (env ()))
clos/con:
	'((app cons (-> '+ <-) (app map (λ (a) ...) (app cdr a))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> '+ <-) (app map deriv (app cdr a))) (env ()))
clos/con:
	'((app cons (-> '+ <-) (app map deriv (app cdr a))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> '- <-) (app map deriv (app cdr a))) (env ()))
clos/con:
	'((app cons (-> '- <-) (app map deriv (app cdr a))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
clos/con:
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> 'x <-) (app nil)) (env ()))
clos/con:
	'((app cons (-> 'x <-) (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> 'x <-) (app nil)) (env ()))
clos/con:
	'((app cons (-> 'x <-) (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> 'x <-) (app nil)) (env ()))
clos/con:
	'((app cons (-> 'x <-) (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> (app caddr a) <-) (app nil)) (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app cons (-> (app deriv (app caddr a)) <-) (app nil)) (env ()))
clos/con:
	'((con
   cons
   (match
    (app eq? (app car a) '*)
    (#f)
    (_
     (->
      (app
       cons
       '*
       (app
        cons
        a
        (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
      <-))))
  (env ()))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env ()))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ()))
	'((con
   cons
   (match
    (app eq? (app car a) '/)
    (#f)
    (_
     (->
      (app
       cons
       '-
       (app
        cons
        (app
         cons
         '/
         (app
          cons
          (app deriv (app cadr a))
          (app cons (app caddr a) (app nil))))
        (app
         cons
         (app
          cons
          '/
          (app
           cons
           (app cadr a)
           (app
            cons
            (app
             cons
             '*
             (app
              cons
              (app caddr a)
              (app
               cons
               (app caddr a)
               (app cons (app deriv (app caddr a)) (app nil)))))
            (app nil))))
         (app nil))))
      <-))))
  (env ()))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app cons (-> (app deriv a) <-) (app cons a (app nil))) (env ()))
clos/con:
	'((con
   cons
   (match
    (app eq? (app car a) '*)
    (#f)
    (_
     (->
      (app
       cons
       '*
       (app
        cons
        a
        (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
      <-))))
  (env ()))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env ()))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ()))
	'((con
   cons
   (match
    (app eq? (app car a) '/)
    (#f)
    (_
     (->
      (app
       cons
       '-
       (app
        cons
        (app
         cons
         '/
         (app
          cons
          (app deriv (app cadr a))
          (app cons (app caddr a) (app nil))))
        (app
         cons
         (app
          cons
          '/
          (app
           cons
           (app cadr a)
           (app
            cons
            (app
             cons
             '*
             (app
              cons
              (app caddr a)
              (app
               cons
               (app caddr a)
               (app cons (app deriv (app caddr a)) (app nil)))))
            (app nil))))
         (app nil))))
      <-))))
  (env ()))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app cons (-> (app map-f map-c) <-) (app map map-f map-d)) (env ()))
clos/con:
	'((con
   cons
   (match
    (app eq? (app car a) '*)
    (#f)
    (_
     (->
      (app
       cons
       '*
       (app
        cons
        a
        (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
      <-))))
  (env ()))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env ()))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ()))
	'((con
   cons
   (match
    (app eq? (app car a) '/)
    (#f)
    (_
     (->
      (app
       cons
       '-
       (app
        cons
        (app
         cons
         '/
         (app
          cons
          (app deriv (app cadr a))
          (app cons (app caddr a) (app nil))))
        (app
         cons
         (app
          cons
          '/
          (app
           cons
           (app cadr a)
           (app
            cons
            (app
             cons
             '*
             (app
              cons
              (app caddr a)
              (app
               cons
               (app caddr a)
               (app cons (app deriv (app caddr a)) (app nil)))))
            (app nil))))
         (app nil))))
      <-))))
  (env ()))
	'((con
   cons
   (λ (a)
     (-> (app cons '/ (app cons (app deriv a) (app cons a (app nil)))) <-)))
  (env ()))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app cons (-> 3 <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
clos/con: ⊥
literals: '(3 ⊥ ⊥ ⊥)

'(query: (app cons (-> 5 <-) (app nil)) (env ()))
clos/con: ⊥
literals: '(5 ⊥ ⊥ ⊥)

'(query: (app cons (-> a <-) (app nil)) (env ()))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app cons (app caddr a) (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (app deriv (app caddr a)) (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (app deriv a) (-> (app cons a (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons (app deriv a) (-> (app cons a (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (app map-f map-c) (-> (app map map-f map-d) <-)) (env ()))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)) (env ()))
clos/con:
	'((con cons (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons 5 (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons a (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app deriv (-> (app caddr a) <-)) (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app deriv (-> (app cadr a) <-)) (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app deriv (-> a <-)) (env ()))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app eq? (-> (app car a) <-) '*) (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app eq? (-> (app car a) <-) '+) (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app eq? (-> (app car a) <-) '-) (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app eq? (-> (app car a) <-) '/) (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app eq? (-> a <-) 'x) (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((con
   cons
   (app
    deriv
    (->
     (app
      cons
      '+
      (app
       cons
       (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
        (app
         cons
         (app cons '* (app cons 'b (app cons 'x (app nil))))
         (app cons 5 (app nil))))))
     <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app eq? (app car a) (-> '* <-)) (env ()))
clos/con:
	'((app eq? (app car a) (-> '* <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app eq? (app car a) (-> '+ <-)) (env ()))
clos/con:
	'((app eq? (app car a) (-> '+ <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app eq? (app car a) (-> '- <-)) (env ()))
clos/con:
	'((app eq? (app car a) (-> '- <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app eq? (app car a) (-> '/ <-)) (env ()))
clos/con:
	'((app eq? (app car a) (-> '/ <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app eq? a (-> 'x <-)) (env ()))
clos/con:
	'((app eq? a (-> 'x <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app map (-> (λ (a) ...) <-) (app cdr a)) (env ()))
clos/con:
	'((app map (-> (λ (a) ...) <-) (app cdr a)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app map (-> deriv <-) (app cdr a)) (env ()))
clos/con:
	'((letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app map (-> deriv <-) (app cdr a)) (env ()))
clos/con:
	'((letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app map (-> map-f <-) map-d) (env ()))
clos/con:
	'((app map (-> (λ (a) ...) <-) (app cdr a)) (env ()))
	'((letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app map (λ (a) ...) (-> (app cdr a) <-)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    '+
    (->
     (app
      cons
      (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'b (app cons 'x (app nil))))
        (app cons 5 (app nil)))))
     <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
    (->
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 'b (app cons 'x (app nil))))
    (-> (app cons 5 (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (->
     (app
      cons
      (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'b (app cons 'x (app nil))))
       (app cons 5 (app nil))))
     <-)))
  (env ()))
	'((con
   cons
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con cons (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'b (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app map deriv (-> (app cdr a) <-)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    '+
    (->
     (app
      cons
      (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'b (app cons 'x (app nil))))
        (app cons 5 (app nil)))))
     <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
    (->
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 'b (app cons 'x (app nil))))
    (-> (app cons 5 (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (->
     (app
      cons
      (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'b (app cons 'x (app nil))))
       (app cons 5 (app nil))))
     <-)))
  (env ()))
	'((con
   cons
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con cons (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'b (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app map deriv (-> (app cdr a) <-)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    '+
    (->
     (app
      cons
      (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'b (app cons 'x (app nil))))
        (app cons 5 (app nil)))))
     <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
    (->
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 'b (app cons 'x (app nil))))
    (-> (app cons 5 (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (->
     (app
      cons
      (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'b (app cons 'x (app nil))))
       (app cons 5 (app nil))))
     <-)))
  (env ()))
	'((con
   cons
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con cons (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'b (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app map map-f (-> map-d <-)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
    (->
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 'b (app cons 'x (app nil))))
    (-> (app cons 5 (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (->
     (app
      cons
      (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'b (app cons 'x (app nil))))
       (app cons 5 (app nil))))
     <-)))
  (env ()))
	'((con cons (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'b (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app map-f (-> map-c <-)) (env ()))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app not (-> (app pair? a) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app pair? (-> a <-)) (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((con
   cons
   (app
    deriv
    (->
     (app
      cons
      '+
      (app
       cons
       (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
        (app
         cons
         (app cons '* (app cons 'b (app cons 'x (app nil))))
         (app cons 5 (app nil))))))
     <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...) (env ()))
clos/con:
	'((letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (lettypes cons ... nil (letrec* (car ... deriv) ...)) (env ()))
clos/con:
	'((con
   cons
   (match
    (app eq? (app car a) '*)
    (#f)
    (_
     (->
      (app
       cons
       '*
       (app
        cons
        a
        (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
      <-))))
  (env ()))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env ()))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ()))
	'((con
   cons
   (match
    (app eq? (app car a) '/)
    (#f)
    (_
     (->
      (app
       cons
       '-
       (app
        cons
        (app
         cons
         '/
         (app
          cons
          (app deriv (app cadr a))
          (app cons (app caddr a) (app nil))))
        (app
         cons
         (app
          cons
          '/
          (app
           cons
           (app cadr a)
           (app
            cons
            (app
             cons
             '*
             (app
              cons
              (app caddr a)
              (app
               cons
               (app caddr a)
               (app cons (app deriv (app caddr a)) (app nil)))))
            (app nil))))
         (app nil))))
      <-))))
  (env ()))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (match (-> (app eq? (app car a) '*) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> (app eq? (app car a) '+) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> (app eq? (app car a) '-) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> (app eq? (app car a) '/) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> (app eq? a 'x) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> (app not (app pair? a)) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> car-v <-) (cons car-c car-d)) (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    '+
    (->
     (app
      cons
      (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'b (app cons 'x (app nil))))
        (app cons 5 (app nil)))))
     <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
    (->
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 'b (app cons 'x (app nil))))
    (-> (app cons 5 (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (->
     (app
      cons
      (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'b (app cons 'x (app nil))))
       (app cons 5 (app nil))))
     <-)))
  (env ()))
	'((con
   cons
   (app
    deriv
    (->
     (app
      cons
      '+
      (app
       cons
       (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
        (app
         cons
         (app cons '* (app cons 'b (app cons 'x (app nil))))
         (app cons 5 (app nil))))))
     <-)))
  (env ()))
	'((con
   cons
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con cons (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'b (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (match (-> cdr-v <-) (cons cdr-c cdr-d)) (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    '+
    (->
     (app
      cons
      (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'b (app cons 'x (app nil))))
        (app cons 5 (app nil)))))
     <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
    (->
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 'b (app cons 'x (app nil))))
    (-> (app cons 5 (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (->
     (app
      cons
      (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'b (app cons 'x (app nil))))
       (app cons 5 (app nil))))
     <-)))
  (env ()))
	'((con
   cons
   (app
    deriv
    (->
     (app
      cons
      '+
      (app
       cons
       (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
        (app
         cons
         (app cons '* (app cons 'b (app cons 'x (app nil))))
         (app cons 5 (app nil))))))
     <-)))
  (env ()))
	'((con
   cons
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con cons (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'b (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (match (-> map-l <-) (cons map-c map-d) (nil)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    '+
    (->
     (app
      cons
      (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'b (app cons 'x (app nil))))
        (app cons 5 (app nil)))))
     <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
    (->
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 'b (app cons 'x (app nil))))
    (-> (app cons 5 (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (->
     (app
      cons
      (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'b (app cons 'x (app nil))))
       (app cons 5 (app nil))))
     <-)))
  (env ()))
	'((con
   cons
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con cons (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'b (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> pair?-v <-) (cons pair?-c pair?-d) _) (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((con
   cons
   (app
    deriv
    (->
     (app
      cons
      '+
      (app
       cons
       (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
        (app
         cons
         (app cons '* (app cons 'b (app cons 'x (app nil))))
         (app cons 5 (app nil))))))
     <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (match (app eq? a 'x) (#f) (_ (-> 1 <-))) (env ()))
clos/con: ⊥
literals: '(1 ⊥ ⊥ ⊥)

'(query: (match (app eq? a 'x) ((#f) (-> 0 <-)) _) (env ()))
clos/con: ⊥
literals: '(0 ⊥ ⊥ ⊥)

'(query: (match car-v ((cons car-c car-d) (-> car-c <-))) (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-))) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    '+
    (->
     (app
      cons
      (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'b (app cons 'x (app nil))))
        (app cons 5 (app nil)))))
     <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
    (->
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 'b (app cons 'x (app nil))))
    (-> (app cons 5 (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (->
     (app
      cons
      (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'b (app cons 'x (app nil))))
       (app cons 5 (app nil))))
     <-)))
  (env ()))
	'((con
   cons
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con cons (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'b (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match map-l (cons map-c map-d) ((nil) (-> (app nil) <-))) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match pair?-v ((cons pair?-c pair?-d) (-> (app #t) <-)) _) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match pair?-v (cons pair?-c pair?-d) (_ (-> (app #f) <-))) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (a) (-> (match (app not (app pair? a)) ...) <-)) (env ()))
clos/con:
	'((con
   cons
   (match
    (app eq? (app car a) '*)
    (#f)
    (_
     (->
      (app
       cons
       '*
       (app
        cons
        a
        (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
      <-))))
  (env ()))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env ()))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ()))
	'((con
   cons
   (match
    (app eq? (app car a) '/)
    (#f)
    (_
     (->
      (app
       cons
       '-
       (app
        cons
        (app
         cons
         '/
         (app
          cons
          (app deriv (app cadr a))
          (app cons (app caddr a) (app nil))))
        (app
         cons
         (app
          cons
          '/
          (app
           cons
           (app cadr a)
           (app
            cons
            (app
             cons
             '*
             (app
              cons
              (app caddr a)
              (app
               cons
               (app caddr a)
               (app cons (app deriv (app caddr a)) (app nil)))))
            (app nil))))
         (app nil))))
      <-))))
  (env ()))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (λ (cadr-v) (-> (app car (app cdr (app cdr cadr-v))) <-)) (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (λ (cadr-v) (-> (app car (app cdr cadr-v)) <-)) (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (λ (car-v) (-> (match car-v ...) <-)) (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (λ (cdr-v) (-> (match cdr-v ...) <-)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    '+
    (->
     (app
      cons
      (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'b (app cons 'x (app nil))))
        (app cons 5 (app nil)))))
     <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
    (->
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 'b (app cons 'x (app nil))))
    (-> (app cons 5 (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (->
     (app
      cons
      (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'b (app cons 'x (app nil))))
       (app cons 5 (app nil))))
     <-)))
  (env ()))
	'((con
   cons
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con cons (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'b (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (map-f map-l) (-> (match map-l ...) <-)) (env ()))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (pair?-v) (-> (match pair?-v ...) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ('*)
    ()
    (match-clause
     _
     (app eq? (app car a) '*)
     (((#f)
       (match
        (app eq? (app car a) '/)
        ((#f) (app error (app #f) "No derivation method available"))
        (_
         (app
          cons
          '-
          (app
           cons
           (app
            cons
            '/
            (app
             cons
             (app deriv (app cadr a))
             (app cons (app caddr a) (app nil))))
           (app
            cons
            (app
             cons
             '/
             (app
              cons
              (app cadr a)
              (app
               cons
               (app
                cons
                '*
                (app
                 cons
                 (app caddr a)
                 (app
                  cons
                  (app caddr a)
                  (app cons (app deriv (app caddr a)) (app nil)))))
               (app nil))))
            (app nil))))))))
     ()
     (match-clause
      (#f)
      (app eq? (app car a) '-)
      ()
      ((_ (app cons '- (app map deriv (app cdr a)))))
      (match-clause
       (#f)
       (app eq? (app car a) '+)
       ()
       ((_ (app cons '+ (app map deriv (app cdr a)))))
       (match-clause
        (#f)
        (app not (app pair? a))
        ()
        ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
        (bod
         (a)
         (bin
          letrec*
          deriv
          (app
           deriv
           (app
            cons
            '+
            (app
             cons
             (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
             (app
              cons
              (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
              (app
               cons
               (app cons '* (app cons 'b (app cons 'x (app nil))))
               (app cons 5 (app nil)))))))
          ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
           (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
           (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
           (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
           (map
            (λ (map-f map-l)
              (match
               map-l
               ((cons map-c map-d)
                (app cons (app map-f map-c) (app map map-f map-d)))
               ((nil) (app nil)))))
           (pair?
            (λ (pair?-v)
              (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f))))))
          ()
          (lettypes-bod ((cons car cdr) (nil)) (top)))))))))
   app
   cons
   a
   (app
    cons
    (app
     cons
     '+
     (app
      map
      (λ (a) (app cons '/ (app cons (app deriv a) (app cons a (app nil)))))
      (app cdr a)))
    (app nil)))
  con
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    '*
    (->
     (app
      cons
      a
      (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil)))
     <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ('*)
    ()
    (ran
     cons
     ()
     ((app
       cons
       (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'b (app cons 'x (app nil))))
        (app cons 5 (app nil)))))
     (ran
      cons
      ('+)
      ()
      (ran
       deriv
       ()
       ()
       (let-bod
        letrec*
        ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
         (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
         (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
         (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
         (map
          (λ (map-f map-l)
            (match
             map-l
             ((cons map-c map-d)
              (app cons (app map-f map-c) (app map map-f map-d)))
             ((nil) (app nil)))))
         (pair?
          (λ (pair?-v)
            (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
         (deriv
          (λ (a)
            (match
             (app not (app pair? a))
             ((#f)
              (match
               (app eq? (app car a) '+)
               ((#f)
                (match
                 (app eq? (app car a) '-)
                 ((#f)
                  (match
                   (app eq? (app car a) '*)
                   ((#f)
                    (match
                     (app eq? (app car a) '/)
                     ((#f)
                      (app error (app #f) "No derivation method available"))
                     (_
                      (app
                       cons
                       '-
                       (app
                        cons
                        (app
                         cons
                         '/
                         (app
                          cons
                          (app deriv (app cadr a))
                          (app cons (app caddr a) (app nil))))
                        (app
                         cons
                         (app
                          cons
                          '/
                          (app
                           cons
                           (app cadr a)
                           (app
                            cons
                            (app
                             cons
                             '*
                             (app
                              cons
                              (app caddr a)
                              (app
                               cons
                               (app caddr a)
                               (app
                                cons
                                (app deriv (app caddr a))
                                (app nil)))))
                            (app nil))))
                         (app nil)))))))
                   (_
                    (app
                     cons
                     '*
                     (app
                      cons
                      a
                      (app
                       cons
                       (app
                        cons
                        '+
                        (app
                         map
                         (λ (a)
                           (app
                            cons
                            '/
                            (app cons (app deriv a) (app cons a (app nil)))))
                         (app cdr a)))
                       (app nil)))))))
                 (_ (app cons '- (app map deriv (app cdr a))))))
               (_ (app cons '+ (app map deriv (app cdr a))))))
             (_ (match (app eq? a 'x) ((#f) 0) (_ 1)))))))
        (lettypes-bod ((cons car cdr) (nil)) (top)))))))
   app
   cons
   3
   (app cons 'x (app cons 'x (app nil))))
  con
  (env ()))
clos/con:
	'((con
   cons
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ('*)
    ()
    (ran
     cons
     ()
     ((app
       cons
       (app cons '* (app cons 'b (app cons 'x (app nil))))
       (app cons 5 (app nil))))
     (ran
      cons
      ((app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))))
      ()
      (ran
       cons
       ('+)
       ()
       (ran
        deriv
        ()
        ()
        (let-bod
         letrec*
         ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
          (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
          (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
          (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
          (map
           (λ (map-f map-l)
             (match
              map-l
              ((cons map-c map-d)
               (app cons (app map-f map-c) (app map map-f map-d)))
              ((nil) (app nil)))))
          (pair?
           (λ (pair?-v)
             (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
          (deriv
           (λ (a)
             (match
              (app not (app pair? a))
              ((#f)
               (match
                (app eq? (app car a) '+)
                ((#f)
                 (match
                  (app eq? (app car a) '-)
                  ((#f)
                   (match
                    (app eq? (app car a) '*)
                    ((#f)
                     (match
                      (app eq? (app car a) '/)
                      ((#f)
                       (app error (app #f) "No derivation method available"))
                      (_
                       (app
                        cons
                        '-
                        (app
                         cons
                         (app
                          cons
                          '/
                          (app
                           cons
                           (app deriv (app cadr a))
                           (app cons (app caddr a) (app nil))))
                         (app
                          cons
                          (app
                           cons
                           '/
                           (app
                            cons
                            (app cadr a)
                            (app
                             cons
                             (app
                              cons
                              '*
                              (app
                               cons
                               (app caddr a)
                               (app
                                cons
                                (app caddr a)
                                (app
                                 cons
                                 (app deriv (app caddr a))
                                 (app nil)))))
                             (app nil))))
                          (app nil)))))))
                    (_
                     (app
                      cons
                      '*
                      (app
                       cons
                       a
                       (app
                        cons
                        (app
                         cons
                         '+
                         (app
                          map
                          (λ (a)
                            (app
                             cons
                             '/
                             (app cons (app deriv a) (app cons a (app nil)))))
                          (app cdr a)))
                        (app nil)))))))
                  (_ (app cons '- (app map deriv (app cdr a))))))
                (_ (app cons '+ (app map deriv (app cdr a))))))
              (_ (match (app eq? a 'x) ((#f) 0) (_ 1)))))))
         (lettypes-bod ((cons car cdr) (nil)) (top))))))))
   app
   cons
   'a
   (app cons 'x (app cons 'x (app nil))))
  con
  (env ()))
clos/con:
	'((con
   cons
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ('*)
    ()
    (ran
     cons
     ()
     ((app cons 5 (app nil)))
     (ran
      cons
      ((app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))))
      ()
      (ran
       cons
       ((app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))))
       ()
       (ran
        cons
        ('+)
        ()
        (ran
         deriv
         ()
         ()
         (let-bod
          letrec*
          ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
           (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
           (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
           (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
           (map
            (λ (map-f map-l)
              (match
               map-l
               ((cons map-c map-d)
                (app cons (app map-f map-c) (app map map-f map-d)))
               ((nil) (app nil)))))
           (pair?
            (λ (pair?-v)
              (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
           (deriv
            (λ (a)
              (match
               (app not (app pair? a))
               ((#f)
                (match
                 (app eq? (app car a) '+)
                 ((#f)
                  (match
                   (app eq? (app car a) '-)
                   ((#f)
                    (match
                     (app eq? (app car a) '*)
                     ((#f)
                      (match
                       (app eq? (app car a) '/)
                       ((#f)
                        (app error (app #f) "No derivation method available"))
                       (_
                        (app
                         cons
                         '-
                         (app
                          cons
                          (app
                           cons
                           '/
                           (app
                            cons
                            (app deriv (app cadr a))
                            (app cons (app caddr a) (app nil))))
                          (app
                           cons
                           (app
                            cons
                            '/
                            (app
                             cons
                             (app cadr a)
                             (app
                              cons
                              (app
                               cons
                               '*
                               (app
                                cons
                                (app caddr a)
                                (app
                                 cons
                                 (app caddr a)
                                 (app
                                  cons
                                  (app deriv (app caddr a))
                                  (app nil)))))
                              (app nil))))
                           (app nil)))))))
                     (_
                      (app
                       cons
                       '*
                       (app
                        cons
                        a
                        (app
                         cons
                         (app
                          cons
                          '+
                          (app
                           map
                           (λ (a)
                             (app
                              cons
                              '/
                              (app cons (app deriv a) (app cons a (app nil)))))
                           (app cdr a)))
                         (app nil)))))))
                   (_ (app cons '- (app map deriv (app cdr a))))))
                 (_ (app cons '+ (app map deriv (app cdr a))))))
               (_ (match (app eq? a 'x) ((#f) 0) (_ 1)))))))
          (lettypes-bod ((cons car cdr) (nil)) (top)))))))))
   app
   cons
   'b
   (app cons 'x (app nil)))
  con
  (env ()))
clos/con:
	'((con cons (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ('*)
    ()
    (ran
     cons
     ()
     ((app nil))
     (ran
      cons
      ((app cadr a))
      ()
      (ran
       cons
       ('/)
       ()
       (ran
        cons
        ()
        ((app nil))
        (ran
         cons
         ((app
           cons
           '/
           (app
            cons
            (app deriv (app cadr a))
            (app cons (app caddr a) (app nil)))))
         ()
         (ran
          cons
          ('-)
          ()
          (match-clause
           _
           (app eq? (app car a) '/)
           (((#f) (app error (app #f) "No derivation method available")))
           ()
           (match-clause
            (#f)
            (app eq? (app car a) '*)
            ()
            ((_
              (app
               cons
               '*
               (app
                cons
                a
                (app
                 cons
                 (app
                  cons
                  '+
                  (app
                   map
                   (λ (a)
                     (app
                      cons
                      '/
                      (app cons (app deriv a) (app cons a (app nil)))))
                   (app cdr a)))
                 (app nil))))))
            (match-clause
             (#f)
             (app eq? (app car a) '-)
             ()
             ((_ (app cons '- (app map deriv (app cdr a)))))
             (match-clause
              (#f)
              (app eq? (app car a) '+)
              ()
              ((_ (app cons '+ (app map deriv (app cdr a)))))
              (match-clause
               (#f)
               (app not (app pair? a))
               ()
               ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
               (bod
                (a)
                (bin
                 letrec*
                 deriv
                 (app
                  deriv
                  (app
                   cons
                   '+
                   (app
                    cons
                    (app
                     cons
                     '*
                     (app cons 3 (app cons 'x (app cons 'x (app nil)))))
                    (app
                     cons
                     (app
                      cons
                      '*
                      (app cons 'a (app cons 'x (app cons 'x (app nil)))))
                     (app
                      cons
                      (app cons '* (app cons 'b (app cons 'x (app nil))))
                      (app cons 5 (app nil)))))))
                 ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
                  (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
                  (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
                  (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
                  (map
                   (λ (map-f map-l)
                     (match
                      map-l
                      ((cons map-c map-d)
                       (app cons (app map-f map-c) (app map map-f map-d)))
                      ((nil) (app nil)))))
                  (pair?
                   (λ (pair?-v)
                     (match
                      pair?-v
                      ((cons pair?-c pair?-d) (app #t))
                      (_ (app #f))))))
                 ()
                 (lettypes-bod ((cons car cdr) (nil)) (top))))))))))))))))
   app
   cons
   (app caddr a)
   (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil))))
  con
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    '*
    (->
     (app
      cons
      (app caddr a)
      (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil))))
     <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ('+)
    ()
    (match-clause
     _
     (app eq? (app car a) '+)
     (((#f)
       (match
        (app eq? (app car a) '-)
        ((#f)
         (match
          (app eq? (app car a) '*)
          ((#f)
           (match
            (app eq? (app car a) '/)
            ((#f) (app error (app #f) "No derivation method available"))
            (_
             (app
              cons
              '-
              (app
               cons
               (app
                cons
                '/
                (app
                 cons
                 (app deriv (app cadr a))
                 (app cons (app caddr a) (app nil))))
               (app
                cons
                (app
                 cons
                 '/
                 (app
                  cons
                  (app cadr a)
                  (app
                   cons
                   (app
                    cons
                    '*
                    (app
                     cons
                     (app caddr a)
                     (app
                      cons
                      (app caddr a)
                      (app cons (app deriv (app caddr a)) (app nil)))))
                   (app nil))))
                (app nil)))))))
          (_
           (app
            cons
            '*
            (app
             cons
             a
             (app
              cons
              (app
               cons
               '+
               (app
                map
                (λ (a)
                  (app
                   cons
                   '/
                   (app cons (app deriv a) (app cons a (app nil)))))
                (app cdr a)))
              (app nil)))))))
        (_ (app cons '- (app map deriv (app cdr a)))))))
     ()
     (match-clause
      (#f)
      (app not (app pair? a))
      ()
      ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
      (bod
       (a)
       (bin
        letrec*
        deriv
        (app
         deriv
         (app
          cons
          '+
          (app
           cons
           (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
           (app
            cons
            (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
            (app
             cons
             (app cons '* (app cons 'b (app cons 'x (app nil))))
             (app cons 5 (app nil)))))))
        ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
         (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
         (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
         (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
         (map
          (λ (map-f map-l)
            (match
             map-l
             ((cons map-c map-d)
              (app cons (app map-f map-c) (app map map-f map-d)))
             ((nil) (app nil)))))
         (pair?
          (λ (pair?-v)
            (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f))))))
        ()
        (lettypes-bod ((cons car cdr) (nil)) (top)))))))
   app
   map
   deriv
   (app cdr a))
  con
  (env ()))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ('+)
    ()
    (ran
     cons
     ()
     ((app nil))
     (ran
      cons
      (a)
      ()
      (ran
       cons
       ('*)
       ()
       (match-clause
        _
        (app eq? (app car a) '*)
        (((#f)
          (match
           (app eq? (app car a) '/)
           ((#f) (app error (app #f) "No derivation method available"))
           (_
            (app
             cons
             '-
             (app
              cons
              (app
               cons
               '/
               (app
                cons
                (app deriv (app cadr a))
                (app cons (app caddr a) (app nil))))
              (app
               cons
               (app
                cons
                '/
                (app
                 cons
                 (app cadr a)
                 (app
                  cons
                  (app
                   cons
                   '*
                   (app
                    cons
                    (app caddr a)
                    (app
                     cons
                     (app caddr a)
                     (app cons (app deriv (app caddr a)) (app nil)))))
                  (app nil))))
               (app nil))))))))
        ()
        (match-clause
         (#f)
         (app eq? (app car a) '-)
         ()
         ((_ (app cons '- (app map deriv (app cdr a)))))
         (match-clause
          (#f)
          (app eq? (app car a) '+)
          ()
          ((_ (app cons '+ (app map deriv (app cdr a)))))
          (match-clause
           (#f)
           (app not (app pair? a))
           ()
           ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
           (bod
            (a)
            (bin
             letrec*
             deriv
             (app
              deriv
              (app
               cons
               '+
               (app
                cons
                (app
                 cons
                 '*
                 (app cons 3 (app cons 'x (app cons 'x (app nil)))))
                (app
                 cons
                 (app
                  cons
                  '*
                  (app cons 'a (app cons 'x (app cons 'x (app nil)))))
                 (app
                  cons
                  (app cons '* (app cons 'b (app cons 'x (app nil))))
                  (app cons 5 (app nil)))))))
             ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
              (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
              (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
              (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
              (map
               (λ (map-f map-l)
                 (match
                  map-l
                  ((cons map-c map-d)
                   (app cons (app map-f map-c) (app map map-f map-d)))
                  ((nil) (app nil)))))
              (pair?
               (λ (pair?-v)
                 (match
                  pair?-v
                  ((cons pair?-c pair?-d) (app #t))
                  (_ (app #f))))))
             ()
             (lettypes-bod ((cons car cdr) (nil)) (top))))))))))))
   app
   map
   (λ (a) (app cons '/ (app cons (app deriv a) (app cons a (app nil)))))
   (app cdr a))
  con
  (env ()))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ('+)
    ()
    (ran
     deriv
     ()
     ()
     (let-bod
      letrec*
      ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
       (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
       (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
       (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
       (map
        (λ (map-f map-l)
          (match
           map-l
           ((cons map-c map-d)
            (app cons (app map-f map-c) (app map map-f map-d)))
           ((nil) (app nil)))))
       (pair?
        (λ (pair?-v)
          (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
       (deriv
        (λ (a)
          (match
           (app not (app pair? a))
           ((#f)
            (match
             (app eq? (app car a) '+)
             ((#f)
              (match
               (app eq? (app car a) '-)
               ((#f)
                (match
                 (app eq? (app car a) '*)
                 ((#f)
                  (match
                   (app eq? (app car a) '/)
                   ((#f) (app error (app #f) "No derivation method available"))
                   (_
                    (app
                     cons
                     '-
                     (app
                      cons
                      (app
                       cons
                       '/
                       (app
                        cons
                        (app deriv (app cadr a))
                        (app cons (app caddr a) (app nil))))
                      (app
                       cons
                       (app
                        cons
                        '/
                        (app
                         cons
                         (app cadr a)
                         (app
                          cons
                          (app
                           cons
                           '*
                           (app
                            cons
                            (app caddr a)
                            (app
                             cons
                             (app caddr a)
                             (app cons (app deriv (app caddr a)) (app nil)))))
                          (app nil))))
                       (app nil)))))))
                 (_
                  (app
                   cons
                   '*
                   (app
                    cons
                    a
                    (app
                     cons
                     (app
                      cons
                      '+
                      (app
                       map
                       (λ (a)
                         (app
                          cons
                          '/
                          (app cons (app deriv a) (app cons a (app nil)))))
                       (app cdr a)))
                     (app nil)))))))
               (_ (app cons '- (app map deriv (app cdr a))))))
             (_ (app cons '+ (app map deriv (app cdr a))))))
           (_ (match (app eq? a 'x) ((#f) 0) (_ 1)))))))
      (lettypes-bod ((cons car cdr) (nil)) (top)))))
   app
   cons
   (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app
    cons
    (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  con
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    '+
    (->
     (app
      cons
      (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'b (app cons 'x (app nil))))
        (app cons 5 (app nil)))))
     <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ('-)
    ()
    (match-clause
     _
     (app eq? (app car a) '-)
     (((#f)
       (match
        (app eq? (app car a) '*)
        ((#f)
         (match
          (app eq? (app car a) '/)
          ((#f) (app error (app #f) "No derivation method available"))
          (_
           (app
            cons
            '-
            (app
             cons
             (app
              cons
              '/
              (app
               cons
               (app deriv (app cadr a))
               (app cons (app caddr a) (app nil))))
             (app
              cons
              (app
               cons
               '/
               (app
                cons
                (app cadr a)
                (app
                 cons
                 (app
                  cons
                  '*
                  (app
                   cons
                   (app caddr a)
                   (app
                    cons
                    (app caddr a)
                    (app cons (app deriv (app caddr a)) (app nil)))))
                 (app nil))))
              (app nil)))))))
        (_
         (app
          cons
          '*
          (app
           cons
           a
           (app
            cons
            (app
             cons
             '+
             (app
              map
              (λ (a)
                (app cons '/ (app cons (app deriv a) (app cons a (app nil)))))
              (app cdr a)))
            (app nil))))))))
     ()
     (match-clause
      (#f)
      (app eq? (app car a) '+)
      ()
      ((_ (app cons '+ (app map deriv (app cdr a)))))
      (match-clause
       (#f)
       (app not (app pair? a))
       ()
       ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
       (bod
        (a)
        (bin
         letrec*
         deriv
         (app
          deriv
          (app
           cons
           '+
           (app
            cons
            (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
            (app
             cons
             (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
             (app
              cons
              (app cons '* (app cons 'b (app cons 'x (app nil))))
              (app cons 5 (app nil)))))))
         ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
          (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
          (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
          (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
          (map
           (λ (map-f map-l)
             (match
              map-l
              ((cons map-c map-d)
               (app cons (app map-f map-c) (app map map-f map-d)))
              ((nil) (app nil)))))
          (pair?
           (λ (pair?-v)
             (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f))))))
         ()
         (lettypes-bod ((cons car cdr) (nil)) (top))))))))
   app
   map
   deriv
   (app cdr a))
  con
  (env ()))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ('-)
    ()
    (match-clause
     _
     (app eq? (app car a) '/)
     (((#f) (app error (app #f) "No derivation method available")))
     ()
     (match-clause
      (#f)
      (app eq? (app car a) '*)
      ()
      ((_
        (app
         cons
         '*
         (app
          cons
          a
          (app
           cons
           (app
            cons
            '+
            (app
             map
             (λ (a)
               (app cons '/ (app cons (app deriv a) (app cons a (app nil)))))
             (app cdr a)))
           (app nil))))))
      (match-clause
       (#f)
       (app eq? (app car a) '-)
       ()
       ((_ (app cons '- (app map deriv (app cdr a)))))
       (match-clause
        (#f)
        (app eq? (app car a) '+)
        ()
        ((_ (app cons '+ (app map deriv (app cdr a)))))
        (match-clause
         (#f)
         (app not (app pair? a))
         ()
         ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
         (bod
          (a)
          (bin
           letrec*
           deriv
           (app
            deriv
            (app
             cons
             '+
             (app
              cons
              (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
              (app
               cons
               (app
                cons
                '*
                (app cons 'a (app cons 'x (app cons 'x (app nil)))))
               (app
                cons
                (app cons '* (app cons 'b (app cons 'x (app nil))))
                (app cons 5 (app nil)))))))
           ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
            (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
            (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
            (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
            (map
             (λ (map-f map-l)
               (match
                map-l
                ((cons map-c map-d)
                 (app cons (app map-f map-c) (app map map-f map-d)))
                ((nil) (app nil)))))
            (pair?
             (λ (pair?-v)
               (match
                pair?-v
                ((cons pair?-c pair?-d) (app #t))
                (_ (app #f))))))
           ()
           (lettypes-bod ((cons car cdr) (nil)) (top))))))))))
   app
   cons
   (app
    cons
    '/
    (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil))))
   (app
    cons
    (app
     cons
     '/
     (app
      cons
      (app cadr a)
      (app
       cons
       (app
        cons
        '*
        (app
         cons
         (app caddr a)
         (app
          cons
          (app caddr a)
          (app cons (app deriv (app caddr a)) (app nil)))))
       (app nil))))
    (app nil)))
  con
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    '-
    (->
     (app
      cons
      (app
       cons
       '/
       (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil))))
      (app
       cons
       (app
        cons
        '/
        (app
         cons
         (app cadr a)
         (app
          cons
          (app
           cons
           '*
           (app
            cons
            (app caddr a)
            (app
             cons
             (app caddr a)
             (app cons (app deriv (app caddr a)) (app nil)))))
          (app nil))))
       (app nil)))
     <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ('/)
    ()
    (bod
     (a)
     (ran
      map
      ()
      ((app cdr a))
      (ran
       cons
       ('+)
       ()
       (ran
        cons
        ()
        ((app nil))
        (ran
         cons
         (a)
         ()
         (ran
          cons
          ('*)
          ()
          (match-clause
           _
           (app eq? (app car a) '*)
           (((#f)
             (match
              (app eq? (app car a) '/)
              ((#f) (app error (app #f) "No derivation method available"))
              (_
               (app
                cons
                '-
                (app
                 cons
                 (app
                  cons
                  '/
                  (app
                   cons
                   (app deriv (app cadr a))
                   (app cons (app caddr a) (app nil))))
                 (app
                  cons
                  (app
                   cons
                   '/
                   (app
                    cons
                    (app cadr a)
                    (app
                     cons
                     (app
                      cons
                      '*
                      (app
                       cons
                       (app caddr a)
                       (app
                        cons
                        (app caddr a)
                        (app cons (app deriv (app caddr a)) (app nil)))))
                     (app nil))))
                  (app nil))))))))
           ()
           (match-clause
            (#f)
            (app eq? (app car a) '-)
            ()
            ((_ (app cons '- (app map deriv (app cdr a)))))
            (match-clause
             (#f)
             (app eq? (app car a) '+)
             ()
             ((_ (app cons '+ (app map deriv (app cdr a)))))
             (match-clause
              (#f)
              (app not (app pair? a))
              ()
              ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
              (bod
               (a)
               (bin
                letrec*
                deriv
                (app
                 deriv
                 (app
                  cons
                  '+
                  (app
                   cons
                   (app
                    cons
                    '*
                    (app cons 3 (app cons 'x (app cons 'x (app nil)))))
                   (app
                    cons
                    (app
                     cons
                     '*
                     (app cons 'a (app cons 'x (app cons 'x (app nil)))))
                    (app
                     cons
                     (app cons '* (app cons 'b (app cons 'x (app nil))))
                     (app cons 5 (app nil)))))))
                ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
                 (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
                 (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
                 (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
                 (map
                  (λ (map-f map-l)
                    (match
                     map-l
                     ((cons map-c map-d)
                      (app cons (app map-f map-c) (app map map-f map-d)))
                     ((nil) (app nil)))))
                 (pair?
                  (λ (pair?-v)
                    (match
                     pair?-v
                     ((cons pair?-c pair?-d) (app #t))
                     (_ (app #f))))))
                ()
                (lettypes-bod ((cons car cdr) (nil)) (top)))))))))))))))
   app
   cons
   (app deriv a)
   (app cons a (app nil)))
  con
  (env ()))
clos/con:
	'((con
   cons
   (app cons '/ (-> (app cons (app deriv a) (app cons a (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ('/)
    ()
    (ran
     cons
     ()
     ((app
       cons
       (app
        cons
        '/
        (app
         cons
         (app cadr a)
         (app
          cons
          (app
           cons
           '*
           (app
            cons
            (app caddr a)
            (app
             cons
             (app caddr a)
             (app cons (app deriv (app caddr a)) (app nil)))))
          (app nil))))
       (app nil)))
     (ran
      cons
      ('-)
      ()
      (match-clause
       _
       (app eq? (app car a) '/)
       (((#f) (app error (app #f) "No derivation method available")))
       ()
       (match-clause
        (#f)
        (app eq? (app car a) '*)
        ()
        ((_
          (app
           cons
           '*
           (app
            cons
            a
            (app
             cons
             (app
              cons
              '+
              (app
               map
               (λ (a)
                 (app cons '/ (app cons (app deriv a) (app cons a (app nil)))))
               (app cdr a)))
             (app nil))))))
        (match-clause
         (#f)
         (app eq? (app car a) '-)
         ()
         ((_ (app cons '- (app map deriv (app cdr a)))))
         (match-clause
          (#f)
          (app eq? (app car a) '+)
          ()
          ((_ (app cons '+ (app map deriv (app cdr a)))))
          (match-clause
           (#f)
           (app not (app pair? a))
           ()
           ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
           (bod
            (a)
            (bin
             letrec*
             deriv
             (app
              deriv
              (app
               cons
               '+
               (app
                cons
                (app
                 cons
                 '*
                 (app cons 3 (app cons 'x (app cons 'x (app nil)))))
                (app
                 cons
                 (app
                  cons
                  '*
                  (app cons 'a (app cons 'x (app cons 'x (app nil)))))
                 (app
                  cons
                  (app cons '* (app cons 'b (app cons 'x (app nil))))
                  (app cons 5 (app nil)))))))
             ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
              (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
              (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
              (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
              (map
               (λ (map-f map-l)
                 (match
                  map-l
                  ((cons map-c map-d)
                   (app cons (app map-f map-c) (app map map-f map-d)))
                  ((nil) (app nil)))))
              (pair?
               (λ (pair?-v)
                 (match
                  pair?-v
                  ((cons pair?-c pair?-d) (app #t))
                  (_ (app #f))))))
             ()
             (lettypes-bod ((cons car cdr) (nil)) (top))))))))))))
   app
   cons
   (app deriv (app cadr a))
   (app cons (app caddr a) (app nil)))
  con
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    '/
    (->
     (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil)))
     <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ('/)
    ()
    (ran
     cons
     ()
     ((app nil))
     (ran
      cons
      ((app
        cons
        '/
        (app
         cons
         (app deriv (app cadr a))
         (app cons (app caddr a) (app nil)))))
      ()
      (ran
       cons
       ('-)
       ()
       (match-clause
        _
        (app eq? (app car a) '/)
        (((#f) (app error (app #f) "No derivation method available")))
        ()
        (match-clause
         (#f)
         (app eq? (app car a) '*)
         ()
         ((_
           (app
            cons
            '*
            (app
             cons
             a
             (app
              cons
              (app
               cons
               '+
               (app
                map
                (λ (a)
                  (app
                   cons
                   '/
                   (app cons (app deriv a) (app cons a (app nil)))))
                (app cdr a)))
              (app nil))))))
         (match-clause
          (#f)
          (app eq? (app car a) '-)
          ()
          ((_ (app cons '- (app map deriv (app cdr a)))))
          (match-clause
           (#f)
           (app eq? (app car a) '+)
           ()
           ((_ (app cons '+ (app map deriv (app cdr a)))))
           (match-clause
            (#f)
            (app not (app pair? a))
            ()
            ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
            (bod
             (a)
             (bin
              letrec*
              deriv
              (app
               deriv
               (app
                cons
                '+
                (app
                 cons
                 (app
                  cons
                  '*
                  (app cons 3 (app cons 'x (app cons 'x (app nil)))))
                 (app
                  cons
                  (app
                   cons
                   '*
                   (app cons 'a (app cons 'x (app cons 'x (app nil)))))
                  (app
                   cons
                   (app cons '* (app cons 'b (app cons 'x (app nil))))
                   (app cons 5 (app nil)))))))
              ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
               (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
               (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
               (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
               (map
                (λ (map-f map-l)
                  (match
                   map-l
                   ((cons map-c map-d)
                    (app cons (app map-f map-c) (app map map-f map-d)))
                   ((nil) (app nil)))))
               (pair?
                (λ (pair?-v)
                  (match
                   pair?-v
                   ((cons pair?-c pair?-d) (app #t))
                   (_ (app #f))))))
              ()
              (lettypes-bod ((cons car cdr) (nil)) (top)))))))))))))
   app
   cons
   (app cadr a)
   (app
    cons
    (app
     cons
     '*
     (app
      cons
      (app caddr a)
      (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))))
    (app nil)))
  con
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    '/
    (->
     (app
      cons
      (app cadr a)
      (app
       cons
       (app
        cons
        '*
        (app
         cons
         (app caddr a)
         (app
          cons
          (app caddr a)
          (app cons (app deriv (app caddr a)) (app nil)))))
       (app nil)))
     <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ('a)
    ()
    (ran
     cons
     ('*)
     ()
     (ran
      cons
      ()
      ((app
        cons
        (app cons '* (app cons 'b (app cons 'x (app nil))))
        (app cons 5 (app nil))))
      (ran
       cons
       ((app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))))
       ()
       (ran
        cons
        ('+)
        ()
        (ran
         deriv
         ()
         ()
         (let-bod
          letrec*
          ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
           (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
           (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
           (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
           (map
            (λ (map-f map-l)
              (match
               map-l
               ((cons map-c map-d)
                (app cons (app map-f map-c) (app map map-f map-d)))
               ((nil) (app nil)))))
           (pair?
            (λ (pair?-v)
              (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
           (deriv
            (λ (a)
              (match
               (app not (app pair? a))
               ((#f)
                (match
                 (app eq? (app car a) '+)
                 ((#f)
                  (match
                   (app eq? (app car a) '-)
                   ((#f)
                    (match
                     (app eq? (app car a) '*)
                     ((#f)
                      (match
                       (app eq? (app car a) '/)
                       ((#f)
                        (app error (app #f) "No derivation method available"))
                       (_
                        (app
                         cons
                         '-
                         (app
                          cons
                          (app
                           cons
                           '/
                           (app
                            cons
                            (app deriv (app cadr a))
                            (app cons (app caddr a) (app nil))))
                          (app
                           cons
                           (app
                            cons
                            '/
                            (app
                             cons
                             (app cadr a)
                             (app
                              cons
                              (app
                               cons
                               '*
                               (app
                                cons
                                (app caddr a)
                                (app
                                 cons
                                 (app caddr a)
                                 (app
                                  cons
                                  (app deriv (app caddr a))
                                  (app nil)))))
                              (app nil))))
                           (app nil)))))))
                     (_
                      (app
                       cons
                       '*
                       (app
                        cons
                        a
                        (app
                         cons
                         (app
                          cons
                          '+
                          (app
                           map
                           (λ (a)
                             (app
                              cons
                              '/
                              (app cons (app deriv a) (app cons a (app nil)))))
                           (app cdr a)))
                         (app nil)))))))
                   (_ (app cons '- (app map deriv (app cdr a))))))
                 (_ (app cons '+ (app map deriv (app cdr a))))))
               (_ (match (app eq? a 'x) ((#f) 0) (_ 1)))))))
          (lettypes-bod ((cons car cdr) (nil)) (top)))))))))
   app
   cons
   'x
   (app cons 'x (app nil)))
  con
  (env ()))
clos/con:
	'((con cons (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ('b)
    ()
    (ran
     cons
     ('*)
     ()
     (ran
      cons
      ()
      ((app cons 5 (app nil)))
      (ran
       cons
       ((app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))))
       ()
       (ran
        cons
        ((app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))))
        ()
        (ran
         cons
         ('+)
         ()
         (ran
          deriv
          ()
          ()
          (let-bod
           letrec*
           ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
            (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
            (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
            (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
            (map
             (λ (map-f map-l)
               (match
                map-l
                ((cons map-c map-d)
                 (app cons (app map-f map-c) (app map map-f map-d)))
                ((nil) (app nil)))))
            (pair?
             (λ (pair?-v)
               (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
            (deriv
             (λ (a)
               (match
                (app not (app pair? a))
                ((#f)
                 (match
                  (app eq? (app car a) '+)
                  ((#f)
                   (match
                    (app eq? (app car a) '-)
                    ((#f)
                     (match
                      (app eq? (app car a) '*)
                      ((#f)
                       (match
                        (app eq? (app car a) '/)
                        ((#f)
                         (app error (app #f) "No derivation method available"))
                        (_
                         (app
                          cons
                          '-
                          (app
                           cons
                           (app
                            cons
                            '/
                            (app
                             cons
                             (app deriv (app cadr a))
                             (app cons (app caddr a) (app nil))))
                           (app
                            cons
                            (app
                             cons
                             '/
                             (app
                              cons
                              (app cadr a)
                              (app
                               cons
                               (app
                                cons
                                '*
                                (app
                                 cons
                                 (app caddr a)
                                 (app
                                  cons
                                  (app caddr a)
                                  (app
                                   cons
                                   (app deriv (app caddr a))
                                   (app nil)))))
                               (app nil))))
                            (app nil)))))))
                      (_
                       (app
                        cons
                        '*
                        (app
                         cons
                         a
                         (app
                          cons
                          (app
                           cons
                           '+
                           (app
                            map
                            (λ (a)
                              (app
                               cons
                               '/
                               (app
                                cons
                                (app deriv a)
                                (app cons a (app nil)))))
                            (app cdr a)))
                          (app nil)))))))
                    (_ (app cons '- (app map deriv (app cdr a))))))
                  (_ (app cons '+ (app map deriv (app cdr a))))))
                (_ (match (app eq? a 'x) ((#f) 0) (_ 1)))))))
           (lettypes-bod ((cons car cdr) (nil)) (top))))))))))
   app
   cons
   'x
   (app nil))
  con
  (env ()))
clos/con:
	'((con cons (app cons 'b (-> (app cons 'x (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ('x)
    ()
    (ran
     cons
     ('a)
     ()
     (ran
      cons
      ('*)
      ()
      (ran
       cons
       ()
       ((app
         cons
         (app cons '* (app cons 'b (app cons 'x (app nil))))
         (app cons 5 (app nil))))
       (ran
        cons
        ((app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))))
        ()
        (ran
         cons
         ('+)
         ()
         (ran
          deriv
          ()
          ()
          (let-bod
           letrec*
           ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
            (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
            (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
            (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
            (map
             (λ (map-f map-l)
               (match
                map-l
                ((cons map-c map-d)
                 (app cons (app map-f map-c) (app map map-f map-d)))
                ((nil) (app nil)))))
            (pair?
             (λ (pair?-v)
               (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
            (deriv
             (λ (a)
               (match
                (app not (app pair? a))
                ((#f)
                 (match
                  (app eq? (app car a) '+)
                  ((#f)
                   (match
                    (app eq? (app car a) '-)
                    ((#f)
                     (match
                      (app eq? (app car a) '*)
                      ((#f)
                       (match
                        (app eq? (app car a) '/)
                        ((#f)
                         (app error (app #f) "No derivation method available"))
                        (_
                         (app
                          cons
                          '-
                          (app
                           cons
                           (app
                            cons
                            '/
                            (app
                             cons
                             (app deriv (app cadr a))
                             (app cons (app caddr a) (app nil))))
                           (app
                            cons
                            (app
                             cons
                             '/
                             (app
                              cons
                              (app cadr a)
                              (app
                               cons
                               (app
                                cons
                                '*
                                (app
                                 cons
                                 (app caddr a)
                                 (app
                                  cons
                                  (app caddr a)
                                  (app
                                   cons
                                   (app deriv (app caddr a))
                                   (app nil)))))
                               (app nil))))
                            (app nil)))))))
                      (_
                       (app
                        cons
                        '*
                        (app
                         cons
                         a
                         (app
                          cons
                          (app
                           cons
                           '+
                           (app
                            map
                            (λ (a)
                              (app
                               cons
                               '/
                               (app
                                cons
                                (app deriv a)
                                (app cons a (app nil)))))
                            (app cdr a)))
                          (app nil)))))))
                    (_ (app cons '- (app map deriv (app cdr a))))))
                  (_ (app cons '+ (app map deriv (app cdr a))))))
                (_ (match (app eq? a 'x) ((#f) 0) (_ 1)))))))
           (lettypes-bod ((cons car cdr) (nil)) (top))))))))))
   app
   cons
   'x
   (app nil))
  con
  (env ()))
clos/con:
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ('x)
    ()
    (ran
     cons
     ('b)
     ()
     (ran
      cons
      ('*)
      ()
      (ran
       cons
       ()
       ((app cons 5 (app nil)))
       (ran
        cons
        ((app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))))
        ()
        (ran
         cons
         ((app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))))
         ()
         (ran
          cons
          ('+)
          ()
          (ran
           deriv
           ()
           ()
           (let-bod
            letrec*
            ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
             (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
             (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
             (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
             (map
              (λ (map-f map-l)
                (match
                 map-l
                 ((cons map-c map-d)
                  (app cons (app map-f map-c) (app map map-f map-d)))
                 ((nil) (app nil)))))
             (pair?
              (λ (pair?-v)
                (match
                 pair?-v
                 ((cons pair?-c pair?-d) (app #t))
                 (_ (app #f)))))
             (deriv
              (λ (a)
                (match
                 (app not (app pair? a))
                 ((#f)
                  (match
                   (app eq? (app car a) '+)
                   ((#f)
                    (match
                     (app eq? (app car a) '-)
                     ((#f)
                      (match
                       (app eq? (app car a) '*)
                       ((#f)
                        (match
                         (app eq? (app car a) '/)
                         ((#f)
                          (app
                           error
                           (app #f)
                           "No derivation method available"))
                         (_
                          (app
                           cons
                           '-
                           (app
                            cons
                            (app
                             cons
                             '/
                             (app
                              cons
                              (app deriv (app cadr a))
                              (app cons (app caddr a) (app nil))))
                            (app
                             cons
                             (app
                              cons
                              '/
                              (app
                               cons
                               (app cadr a)
                               (app
                                cons
                                (app
                                 cons
                                 '*
                                 (app
                                  cons
                                  (app caddr a)
                                  (app
                                   cons
                                   (app caddr a)
                                   (app
                                    cons
                                    (app deriv (app caddr a))
                                    (app nil)))))
                                (app nil))))
                             (app nil)))))))
                       (_
                        (app
                         cons
                         '*
                         (app
                          cons
                          a
                          (app
                           cons
                           (app
                            cons
                            '+
                            (app
                             map
                             (λ (a)
                               (app
                                cons
                                '/
                                (app
                                 cons
                                 (app deriv a)
                                 (app cons a (app nil)))))
                             (app cdr a)))
                           (app nil)))))))
                     (_ (app cons '- (app map deriv (app cdr a))))))
                   (_ (app cons '+ (app map deriv (app cdr a))))))
                 (_ (match (app eq? a 'x) ((#f) 0) (_ 1)))))))
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
    ('x)
    ()
    (ran
     cons
     ('x)
     ()
     (ran
      cons
      ('a)
      ()
      (ran
       cons
       ('*)
       ()
       (ran
        cons
        ()
        ((app
          cons
          (app cons '* (app cons 'b (app cons 'x (app nil))))
          (app cons 5 (app nil))))
        (ran
         cons
         ((app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))))
         ()
         (ran
          cons
          ('+)
          ()
          (ran
           deriv
           ()
           ()
           (let-bod
            letrec*
            ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
             (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
             (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
             (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
             (map
              (λ (map-f map-l)
                (match
                 map-l
                 ((cons map-c map-d)
                  (app cons (app map-f map-c) (app map map-f map-d)))
                 ((nil) (app nil)))))
             (pair?
              (λ (pair?-v)
                (match
                 pair?-v
                 ((cons pair?-c pair?-d) (app #t))
                 (_ (app #f)))))
             (deriv
              (λ (a)
                (match
                 (app not (app pair? a))
                 ((#f)
                  (match
                   (app eq? (app car a) '+)
                   ((#f)
                    (match
                     (app eq? (app car a) '-)
                     ((#f)
                      (match
                       (app eq? (app car a) '*)
                       ((#f)
                        (match
                         (app eq? (app car a) '/)
                         ((#f)
                          (app
                           error
                           (app #f)
                           "No derivation method available"))
                         (_
                          (app
                           cons
                           '-
                           (app
                            cons
                            (app
                             cons
                             '/
                             (app
                              cons
                              (app deriv (app cadr a))
                              (app cons (app caddr a) (app nil))))
                            (app
                             cons
                             (app
                              cons
                              '/
                              (app
                               cons
                               (app cadr a)
                               (app
                                cons
                                (app
                                 cons
                                 '*
                                 (app
                                  cons
                                  (app caddr a)
                                  (app
                                   cons
                                   (app caddr a)
                                   (app
                                    cons
                                    (app deriv (app caddr a))
                                    (app nil)))))
                                (app nil))))
                             (app nil)))))))
                       (_
                        (app
                         cons
                         '*
                         (app
                          cons
                          a
                          (app
                           cons
                           (app
                            cons
                            '+
                            (app
                             map
                             (λ (a)
                               (app
                                cons
                                '/
                                (app
                                 cons
                                 (app deriv a)
                                 (app cons a (app nil)))))
                             (app cdr a)))
                           (app nil)))))))
                     (_ (app cons '- (app map deriv (app cdr a))))))
                   (_ (app cons '+ (app map deriv (app cdr a))))))
                 (_ (match (app eq? a 'x) ((#f) 0) (_ 1)))))))
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
    ('x)
    ()
    (ran
     cons
     ('x)
     ()
     (ran
      cons
      (3)
      ()
      (ran
       cons
       ('*)
       ()
       (ran
        cons
        ()
        ((app
          cons
          (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
          (app
           cons
           (app cons '* (app cons 'b (app cons 'x (app nil))))
           (app cons 5 (app nil)))))
        (ran
         cons
         ('+)
         ()
         (ran
          deriv
          ()
          ()
          (let-bod
           letrec*
           ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
            (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
            (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
            (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
            (map
             (λ (map-f map-l)
               (match
                map-l
                ((cons map-c map-d)
                 (app cons (app map-f map-c) (app map map-f map-d)))
                ((nil) (app nil)))))
            (pair?
             (λ (pair?-v)
               (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
            (deriv
             (λ (a)
               (match
                (app not (app pair? a))
                ((#f)
                 (match
                  (app eq? (app car a) '+)
                  ((#f)
                   (match
                    (app eq? (app car a) '-)
                    ((#f)
                     (match
                      (app eq? (app car a) '*)
                      ((#f)
                       (match
                        (app eq? (app car a) '/)
                        ((#f)
                         (app error (app #f) "No derivation method available"))
                        (_
                         (app
                          cons
                          '-
                          (app
                           cons
                           (app
                            cons
                            '/
                            (app
                             cons
                             (app deriv (app cadr a))
                             (app cons (app caddr a) (app nil))))
                           (app
                            cons
                            (app
                             cons
                             '/
                             (app
                              cons
                              (app cadr a)
                              (app
                               cons
                               (app
                                cons
                                '*
                                (app
                                 cons
                                 (app caddr a)
                                 (app
                                  cons
                                  (app caddr a)
                                  (app
                                   cons
                                   (app deriv (app caddr a))
                                   (app nil)))))
                               (app nil))))
                            (app nil)))))))
                      (_
                       (app
                        cons
                        '*
                        (app
                         cons
                         a
                         (app
                          cons
                          (app
                           cons
                           '+
                           (app
                            map
                            (λ (a)
                              (app
                               cons
                               '/
                               (app
                                cons
                                (app deriv a)
                                (app cons a (app nil)))))
                            (app cdr a)))
                          (app nil)))))))
                    (_ (app cons '- (app map deriv (app cdr a))))))
                  (_ (app cons '+ (app map deriv (app cdr a))))))
                (_ (match (app eq? a 'x) ((#f) 0) (_ 1)))))))
           (lettypes-bod ((cons car cdr) (nil)) (top))))))))))
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
    ('x)
    ()
    (ran
     cons
     (3)
     ()
     (ran
      cons
      ('*)
      ()
      (ran
       cons
       ()
       ((app
         cons
         (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
         (app
          cons
          (app cons '* (app cons 'b (app cons 'x (app nil))))
          (app cons 5 (app nil)))))
       (ran
        cons
        ('+)
        ()
        (ran
         deriv
         ()
         ()
         (let-bod
          letrec*
          ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
           (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
           (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
           (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
           (map
            (λ (map-f map-l)
              (match
               map-l
               ((cons map-c map-d)
                (app cons (app map-f map-c) (app map map-f map-d)))
               ((nil) (app nil)))))
           (pair?
            (λ (pair?-v)
              (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
           (deriv
            (λ (a)
              (match
               (app not (app pair? a))
               ((#f)
                (match
                 (app eq? (app car a) '+)
                 ((#f)
                  (match
                   (app eq? (app car a) '-)
                   ((#f)
                    (match
                     (app eq? (app car a) '*)
                     ((#f)
                      (match
                       (app eq? (app car a) '/)
                       ((#f)
                        (app error (app #f) "No derivation method available"))
                       (_
                        (app
                         cons
                         '-
                         (app
                          cons
                          (app
                           cons
                           '/
                           (app
                            cons
                            (app deriv (app cadr a))
                            (app cons (app caddr a) (app nil))))
                          (app
                           cons
                           (app
                            cons
                            '/
                            (app
                             cons
                             (app cadr a)
                             (app
                              cons
                              (app
                               cons
                               '*
                               (app
                                cons
                                (app caddr a)
                                (app
                                 cons
                                 (app caddr a)
                                 (app
                                  cons
                                  (app deriv (app caddr a))
                                  (app nil)))))
                              (app nil))))
                           (app nil)))))))
                     (_
                      (app
                       cons
                       '*
                       (app
                        cons
                        a
                        (app
                         cons
                         (app
                          cons
                          '+
                          (app
                           map
                           (λ (a)
                             (app
                              cons
                              '/
                              (app cons (app deriv a) (app cons a (app nil)))))
                           (app cdr a)))
                         (app nil)))))))
                   (_ (app cons '- (app map deriv (app cdr a))))))
                 (_ (app cons '+ (app map deriv (app cdr a))))))
               (_ (match (app eq? a 'x) ((#f) 0) (_ 1)))))))
          (lettypes-bod ((cons car cdr) (nil)) (top)))))))))
   app
   cons
   'x
   (app nil))
  con
  (env ()))
clos/con:
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ((app
      cons
      '*
      (app
       cons
       (app caddr a)
       (app
        cons
        (app caddr a)
        (app cons (app deriv (app caddr a)) (app nil))))))
    ()
    (ran
     cons
     ((app cadr a))
     ()
     (ran
      cons
      ('/)
      ()
      (ran
       cons
       ()
       ((app nil))
       (ran
        cons
        ((app
          cons
          '/
          (app
           cons
           (app deriv (app cadr a))
           (app cons (app caddr a) (app nil)))))
        ()
        (ran
         cons
         ('-)
         ()
         (match-clause
          _
          (app eq? (app car a) '/)
          (((#f) (app error (app #f) "No derivation method available")))
          ()
          (match-clause
           (#f)
           (app eq? (app car a) '*)
           ()
           ((_
             (app
              cons
              '*
              (app
               cons
               a
               (app
                cons
                (app
                 cons
                 '+
                 (app
                  map
                  (λ (a)
                    (app
                     cons
                     '/
                     (app cons (app deriv a) (app cons a (app nil)))))
                  (app cdr a)))
                (app nil))))))
           (match-clause
            (#f)
            (app eq? (app car a) '-)
            ()
            ((_ (app cons '- (app map deriv (app cdr a)))))
            (match-clause
             (#f)
             (app eq? (app car a) '+)
             ()
             ((_ (app cons '+ (app map deriv (app cdr a)))))
             (match-clause
              (#f)
              (app not (app pair? a))
              ()
              ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
              (bod
               (a)
               (bin
                letrec*
                deriv
                (app
                 deriv
                 (app
                  cons
                  '+
                  (app
                   cons
                   (app
                    cons
                    '*
                    (app cons 3 (app cons 'x (app cons 'x (app nil)))))
                   (app
                    cons
                    (app
                     cons
                     '*
                     (app cons 'a (app cons 'x (app cons 'x (app nil)))))
                    (app
                     cons
                     (app cons '* (app cons 'b (app cons 'x (app nil))))
                     (app cons 5 (app nil)))))))
                ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
                 (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
                 (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
                 (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
                 (map
                  (λ (map-f map-l)
                    (match
                     map-l
                     ((cons map-c map-d)
                      (app cons (app map-f map-c) (app map map-f map-d)))
                     ((nil) (app nil)))))
                 (pair?
                  (λ (pair?-v)
                    (match
                     pair?-v
                     ((cons pair?-c pair?-d) (app #t))
                     (_ (app #f))))))
                ()
                (lettypes-bod ((cons car cdr) (nil)) (top)))))))))))))))
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
    ((app
      cons
      '+
      (app
       map
       (λ (a) (app cons '/ (app cons (app deriv a) (app cons a (app nil)))))
       (app cdr a))))
    ()
    (ran
     cons
     (a)
     ()
     (ran
      cons
      ('*)
      ()
      (match-clause
       _
       (app eq? (app car a) '*)
       (((#f)
         (match
          (app eq? (app car a) '/)
          ((#f) (app error (app #f) "No derivation method available"))
          (_
           (app
            cons
            '-
            (app
             cons
             (app
              cons
              '/
              (app
               cons
               (app deriv (app cadr a))
               (app cons (app caddr a) (app nil))))
             (app
              cons
              (app
               cons
               '/
               (app
                cons
                (app cadr a)
                (app
                 cons
                 (app
                  cons
                  '*
                  (app
                   cons
                   (app caddr a)
                   (app
                    cons
                    (app caddr a)
                    (app cons (app deriv (app caddr a)) (app nil)))))
                 (app nil))))
              (app nil))))))))
       ()
       (match-clause
        (#f)
        (app eq? (app car a) '-)
        ()
        ((_ (app cons '- (app map deriv (app cdr a)))))
        (match-clause
         (#f)
         (app eq? (app car a) '+)
         ()
         ((_ (app cons '+ (app map deriv (app cdr a)))))
         (match-clause
          (#f)
          (app not (app pair? a))
          ()
          ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
          (bod
           (a)
           (bin
            letrec*
            deriv
            (app
             deriv
             (app
              cons
              '+
              (app
               cons
               (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
               (app
                cons
                (app
                 cons
                 '*
                 (app cons 'a (app cons 'x (app cons 'x (app nil)))))
                (app
                 cons
                 (app cons '* (app cons 'b (app cons 'x (app nil))))
                 (app cons 5 (app nil)))))))
            ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
             (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
             (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
             (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
             (map
              (λ (map-f map-l)
                (match
                 map-l
                 ((cons map-c map-d)
                  (app cons (app map-f map-c) (app map map-f map-d)))
                 ((nil) (app nil)))))
             (pair?
              (λ (pair?-v)
                (match
                 pair?-v
                 ((cons pair?-c pair?-d) (app #t))
                 (_ (app #f))))))
            ()
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
    ((app
      cons
      '/
      (app
       cons
       (app cadr a)
       (app
        cons
        (app
         cons
         '*
         (app
          cons
          (app caddr a)
          (app
           cons
           (app caddr a)
           (app cons (app deriv (app caddr a)) (app nil)))))
        (app nil)))))
    ()
    (ran
     cons
     ((app
       cons
       '/
       (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil)))))
     ()
     (ran
      cons
      ('-)
      ()
      (match-clause
       _
       (app eq? (app car a) '/)
       (((#f) (app error (app #f) "No derivation method available")))
       ()
       (match-clause
        (#f)
        (app eq? (app car a) '*)
        ()
        ((_
          (app
           cons
           '*
           (app
            cons
            a
            (app
             cons
             (app
              cons
              '+
              (app
               map
               (λ (a)
                 (app cons '/ (app cons (app deriv a) (app cons a (app nil)))))
               (app cdr a)))
             (app nil))))))
        (match-clause
         (#f)
         (app eq? (app car a) '-)
         ()
         ((_ (app cons '- (app map deriv (app cdr a)))))
         (match-clause
          (#f)
          (app eq? (app car a) '+)
          ()
          ((_ (app cons '+ (app map deriv (app cdr a)))))
          (match-clause
           (#f)
           (app not (app pair? a))
           ()
           ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
           (bod
            (a)
            (bin
             letrec*
             deriv
             (app
              deriv
              (app
               cons
               '+
               (app
                cons
                (app
                 cons
                 '*
                 (app cons 3 (app cons 'x (app cons 'x (app nil)))))
                (app
                 cons
                 (app
                  cons
                  '*
                  (app cons 'a (app cons 'x (app cons 'x (app nil)))))
                 (app
                  cons
                  (app cons '* (app cons 'b (app cons 'x (app nil))))
                  (app cons 5 (app nil)))))))
             ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
              (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
              (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
              (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
              (map
               (λ (map-f map-l)
                 (match
                  map-l
                  ((cons map-c map-d)
                   (app cons (app map-f map-c) (app map map-f map-d)))
                  ((nil) (app nil)))))
              (pair?
               (λ (pair?-v)
                 (match
                  pair?-v
                  ((cons pair?-c pair?-d) (app #t))
                  (_ (app #f))))))
             ()
             (lettypes-bod ((cons car cdr) (nil)) (top))))))))))))
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
    ((app
      cons
      '/
      (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil)))))
    ()
    (ran
     cons
     ('-)
     ()
     (match-clause
      _
      (app eq? (app car a) '/)
      (((#f) (app error (app #f) "No derivation method available")))
      ()
      (match-clause
       (#f)
       (app eq? (app car a) '*)
       ()
       ((_
         (app
          cons
          '*
          (app
           cons
           a
           (app
            cons
            (app
             cons
             '+
             (app
              map
              (λ (a)
                (app cons '/ (app cons (app deriv a) (app cons a (app nil)))))
              (app cdr a)))
            (app nil))))))
       (match-clause
        (#f)
        (app eq? (app car a) '-)
        ()
        ((_ (app cons '- (app map deriv (app cdr a)))))
        (match-clause
         (#f)
         (app eq? (app car a) '+)
         ()
         ((_ (app cons '+ (app map deriv (app cdr a)))))
         (match-clause
          (#f)
          (app not (app pair? a))
          ()
          ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
          (bod
           (a)
           (bin
            letrec*
            deriv
            (app
             deriv
             (app
              cons
              '+
              (app
               cons
               (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
               (app
                cons
                (app
                 cons
                 '*
                 (app cons 'a (app cons 'x (app cons 'x (app nil)))))
                (app
                 cons
                 (app cons '* (app cons 'b (app cons 'x (app nil))))
                 (app cons 5 (app nil)))))))
            ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
             (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
             (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
             (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
             (map
              (λ (map-f map-l)
                (match
                 map-l
                 ((cons map-c map-d)
                  (app cons (app map-f map-c) (app map map-f map-d)))
                 ((nil) (app nil)))))
             (pair?
              (λ (pair?-v)
                (match
                 pair?-v
                 ((cons pair?-c pair?-d) (app #t))
                 (_ (app #f))))))
            ()
            (lettypes-bod ((cons car cdr) (nil)) (top)))))))))))
   app
   cons
   (app
    cons
    '/
    (app
     cons
     (app cadr a)
     (app
      cons
      (app
       cons
       '*
       (app
        cons
        (app caddr a)
        (app
         cons
         (app caddr a)
         (app cons (app deriv (app caddr a)) (app nil)))))
      (app nil))))
   (app nil))
  con
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (app
     cons
     '/
     (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil))))
    (->
     (app
      cons
      (app
       cons
       '/
       (app
        cons
        (app cadr a)
        (app
         cons
         (app
          cons
          '*
          (app
           cons
           (app caddr a)
           (app
            cons
            (app caddr a)
            (app cons (app deriv (app caddr a)) (app nil)))))
         (app nil))))
      (app nil))
     <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ((app caddr a))
    ()
    (ran
     cons
     ('*)
     ()
     (ran
      cons
      ()
      ((app nil))
      (ran
       cons
       ((app cadr a))
       ()
       (ran
        cons
        ('/)
        ()
        (ran
         cons
         ()
         ((app nil))
         (ran
          cons
          ((app
            cons
            '/
            (app
             cons
             (app deriv (app cadr a))
             (app cons (app caddr a) (app nil)))))
          ()
          (ran
           cons
           ('-)
           ()
           (match-clause
            _
            (app eq? (app car a) '/)
            (((#f) (app error (app #f) "No derivation method available")))
            ()
            (match-clause
             (#f)
             (app eq? (app car a) '*)
             ()
             ((_
               (app
                cons
                '*
                (app
                 cons
                 a
                 (app
                  cons
                  (app
                   cons
                   '+
                   (app
                    map
                    (λ (a)
                      (app
                       cons
                       '/
                       (app cons (app deriv a) (app cons a (app nil)))))
                    (app cdr a)))
                  (app nil))))))
             (match-clause
              (#f)
              (app eq? (app car a) '-)
              ()
              ((_ (app cons '- (app map deriv (app cdr a)))))
              (match-clause
               (#f)
               (app eq? (app car a) '+)
               ()
               ((_ (app cons '+ (app map deriv (app cdr a)))))
               (match-clause
                (#f)
                (app not (app pair? a))
                ()
                ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
                (bod
                 (a)
                 (bin
                  letrec*
                  deriv
                  (app
                   deriv
                   (app
                    cons
                    '+
                    (app
                     cons
                     (app
                      cons
                      '*
                      (app cons 3 (app cons 'x (app cons 'x (app nil)))))
                     (app
                      cons
                      (app
                       cons
                       '*
                       (app cons 'a (app cons 'x (app cons 'x (app nil)))))
                      (app
                       cons
                       (app cons '* (app cons 'b (app cons 'x (app nil))))
                       (app cons 5 (app nil)))))))
                  ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
                   (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
                   (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
                   (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
                   (map
                    (λ (map-f map-l)
                      (match
                       map-l
                       ((cons map-c map-d)
                        (app cons (app map-f map-c) (app map map-f map-d)))
                       ((nil) (app nil)))))
                   (pair?
                    (λ (pair?-v)
                      (match
                       pair?-v
                       ((cons pair?-c pair?-d) (app #t))
                       (_ (app #f))))))
                  ()
                  (lettypes-bod ((cons car cdr) (nil)) (top)))))))))))))))))
   app
   cons
   (app caddr a)
   (app cons (app deriv (app caddr a)) (app nil)))
  con
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (app caddr a)
    (->
     (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))
     <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ((app caddr a))
    ()
    (ran
     cons
     ((app caddr a))
     ()
     (ran
      cons
      ('*)
      ()
      (ran
       cons
       ()
       ((app nil))
       (ran
        cons
        ((app cadr a))
        ()
        (ran
         cons
         ('/)
         ()
         (ran
          cons
          ()
          ((app nil))
          (ran
           cons
           ((app
             cons
             '/
             (app
              cons
              (app deriv (app cadr a))
              (app cons (app caddr a) (app nil)))))
           ()
           (ran
            cons
            ('-)
            ()
            (match-clause
             _
             (app eq? (app car a) '/)
             (((#f) (app error (app #f) "No derivation method available")))
             ()
             (match-clause
              (#f)
              (app eq? (app car a) '*)
              ()
              ((_
                (app
                 cons
                 '*
                 (app
                  cons
                  a
                  (app
                   cons
                   (app
                    cons
                    '+
                    (app
                     map
                     (λ (a)
                       (app
                        cons
                        '/
                        (app cons (app deriv a) (app cons a (app nil)))))
                     (app cdr a)))
                   (app nil))))))
              (match-clause
               (#f)
               (app eq? (app car a) '-)
               ()
               ((_ (app cons '- (app map deriv (app cdr a)))))
               (match-clause
                (#f)
                (app eq? (app car a) '+)
                ()
                ((_ (app cons '+ (app map deriv (app cdr a)))))
                (match-clause
                 (#f)
                 (app not (app pair? a))
                 ()
                 ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
                 (bod
                  (a)
                  (bin
                   letrec*
                   deriv
                   (app
                    deriv
                    (app
                     cons
                     '+
                     (app
                      cons
                      (app
                       cons
                       '*
                       (app cons 3 (app cons 'x (app cons 'x (app nil)))))
                      (app
                       cons
                       (app
                        cons
                        '*
                        (app cons 'a (app cons 'x (app cons 'x (app nil)))))
                       (app
                        cons
                        (app cons '* (app cons 'b (app cons 'x (app nil))))
                        (app cons 5 (app nil)))))))
                   ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
                    (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
                    (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
                    (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
                    (map
                     (λ (map-f map-l)
                       (match
                        map-l
                        ((cons map-c map-d)
                         (app cons (app map-f map-c) (app map map-f map-d)))
                        ((nil) (app nil)))))
                    (pair?
                     (λ (pair?-v)
                       (match
                        pair?-v
                        ((cons pair?-c pair?-d) (app #t))
                        (_ (app #f))))))
                   ()
                   (lettypes-bod ((cons car cdr) (nil)) (top))))))))))))))))))
   app
   cons
   (app deriv (app caddr a))
   (app nil))
  con
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (app caddr a)
    (-> (app cons (app deriv (app caddr a)) (app nil)) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ((app caddr a))
    ()
    (ran
     cons
     ((app deriv (app cadr a)))
     ()
     (ran
      cons
      ('/)
      ()
      (ran
       cons
       ()
       ((app
         cons
         (app
          cons
          '/
          (app
           cons
           (app cadr a)
           (app
            cons
            (app
             cons
             '*
             (app
              cons
              (app caddr a)
              (app
               cons
               (app caddr a)
               (app cons (app deriv (app caddr a)) (app nil)))))
            (app nil))))
         (app nil)))
       (ran
        cons
        ('-)
        ()
        (match-clause
         _
         (app eq? (app car a) '/)
         (((#f) (app error (app #f) "No derivation method available")))
         ()
         (match-clause
          (#f)
          (app eq? (app car a) '*)
          ()
          ((_
            (app
             cons
             '*
             (app
              cons
              a
              (app
               cons
               (app
                cons
                '+
                (app
                 map
                 (λ (a)
                   (app
                    cons
                    '/
                    (app cons (app deriv a) (app cons a (app nil)))))
                 (app cdr a)))
               (app nil))))))
          (match-clause
           (#f)
           (app eq? (app car a) '-)
           ()
           ((_ (app cons '- (app map deriv (app cdr a)))))
           (match-clause
            (#f)
            (app eq? (app car a) '+)
            ()
            ((_ (app cons '+ (app map deriv (app cdr a)))))
            (match-clause
             (#f)
             (app not (app pair? a))
             ()
             ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
             (bod
              (a)
              (bin
               letrec*
               deriv
               (app
                deriv
                (app
                 cons
                 '+
                 (app
                  cons
                  (app
                   cons
                   '*
                   (app cons 3 (app cons 'x (app cons 'x (app nil)))))
                  (app
                   cons
                   (app
                    cons
                    '*
                    (app cons 'a (app cons 'x (app cons 'x (app nil)))))
                   (app
                    cons
                    (app cons '* (app cons 'b (app cons 'x (app nil))))
                    (app cons 5 (app nil)))))))
               ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
                (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
                (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
                (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
                (map
                 (λ (map-f map-l)
                   (match
                    map-l
                    ((cons map-c map-d)
                     (app cons (app map-f map-c) (app map map-f map-d)))
                    ((nil) (app nil)))))
                (pair?
                 (λ (pair?-v)
                   (match
                    pair?-v
                    ((cons pair?-c pair?-d) (app #t))
                    (_ (app #f))))))
               ()
               (lettypes-bod ((cons car cdr) (nil)) (top))))))))))))))
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
    ((app cadr a))
    ()
    (ran
     cons
     ('/)
     ()
     (ran
      cons
      ()
      ((app nil))
      (ran
       cons
       ((app
         cons
         '/
         (app
          cons
          (app deriv (app cadr a))
          (app cons (app caddr a) (app nil)))))
       ()
       (ran
        cons
        ('-)
        ()
        (match-clause
         _
         (app eq? (app car a) '/)
         (((#f) (app error (app #f) "No derivation method available")))
         ()
         (match-clause
          (#f)
          (app eq? (app car a) '*)
          ()
          ((_
            (app
             cons
             '*
             (app
              cons
              a
              (app
               cons
               (app
                cons
                '+
                (app
                 map
                 (λ (a)
                   (app
                    cons
                    '/
                    (app cons (app deriv a) (app cons a (app nil)))))
                 (app cdr a)))
               (app nil))))))
          (match-clause
           (#f)
           (app eq? (app car a) '-)
           ()
           ((_ (app cons '- (app map deriv (app cdr a)))))
           (match-clause
            (#f)
            (app eq? (app car a) '+)
            ()
            ((_ (app cons '+ (app map deriv (app cdr a)))))
            (match-clause
             (#f)
             (app not (app pair? a))
             ()
             ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
             (bod
              (a)
              (bin
               letrec*
               deriv
               (app
                deriv
                (app
                 cons
                 '+
                 (app
                  cons
                  (app
                   cons
                   '*
                   (app cons 3 (app cons 'x (app cons 'x (app nil)))))
                  (app
                   cons
                   (app
                    cons
                    '*
                    (app cons 'a (app cons 'x (app cons 'x (app nil)))))
                   (app
                    cons
                    (app cons '* (app cons 'b (app cons 'x (app nil))))
                    (app cons 5 (app nil)))))))
               ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
                (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
                (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
                (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
                (map
                 (λ (map-f map-l)
                   (match
                    map-l
                    ((cons map-c map-d)
                     (app cons (app map-f map-c) (app map map-f map-d)))
                    ((nil) (app nil)))))
                (pair?
                 (λ (pair?-v)
                   (match
                    pair?-v
                    ((cons pair?-c pair?-d) (app #t))
                    (_ (app #f))))))
               ()
               (lettypes-bod ((cons car cdr) (nil)) (top))))))))))))))
   app
   cons
   (app
    cons
    '*
    (app
     cons
     (app caddr a)
     (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))))
   (app nil))
  con
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (app cadr a)
    (->
     (app
      cons
      (app
       cons
       '*
       (app
        cons
        (app caddr a)
        (app
         cons
         (app caddr a)
         (app cons (app deriv (app caddr a)) (app nil)))))
      (app nil))
     <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ((app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))))
    ()
    (ran
     cons
     ((app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))))
     ()
     (ran
      cons
      ('+)
      ()
      (ran
       deriv
       ()
       ()
       (let-bod
        letrec*
        ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
         (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
         (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
         (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
         (map
          (λ (map-f map-l)
            (match
             map-l
             ((cons map-c map-d)
              (app cons (app map-f map-c) (app map map-f map-d)))
             ((nil) (app nil)))))
         (pair?
          (λ (pair?-v)
            (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
         (deriv
          (λ (a)
            (match
             (app not (app pair? a))
             ((#f)
              (match
               (app eq? (app car a) '+)
               ((#f)
                (match
                 (app eq? (app car a) '-)
                 ((#f)
                  (match
                   (app eq? (app car a) '*)
                   ((#f)
                    (match
                     (app eq? (app car a) '/)
                     ((#f)
                      (app error (app #f) "No derivation method available"))
                     (_
                      (app
                       cons
                       '-
                       (app
                        cons
                        (app
                         cons
                         '/
                         (app
                          cons
                          (app deriv (app cadr a))
                          (app cons (app caddr a) (app nil))))
                        (app
                         cons
                         (app
                          cons
                          '/
                          (app
                           cons
                           (app cadr a)
                           (app
                            cons
                            (app
                             cons
                             '*
                             (app
                              cons
                              (app caddr a)
                              (app
                               cons
                               (app caddr a)
                               (app
                                cons
                                (app deriv (app caddr a))
                                (app nil)))))
                            (app nil))))
                         (app nil)))))))
                   (_
                    (app
                     cons
                     '*
                     (app
                      cons
                      a
                      (app
                       cons
                       (app
                        cons
                        '+
                        (app
                         map
                         (λ (a)
                           (app
                            cons
                            '/
                            (app cons (app deriv a) (app cons a (app nil)))))
                         (app cdr a)))
                       (app nil)))))))
                 (_ (app cons '- (app map deriv (app cdr a))))))
               (_ (app cons '+ (app map deriv (app cdr a))))))
             (_ (match (app eq? a 'x) ((#f) 0) (_ 1)))))))
        (lettypes-bod ((cons car cdr) (nil)) (top)))))))
   app
   cons
   (app cons '* (app cons 'b (app cons 'x (app nil))))
   (app cons 5 (app nil)))
  con
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
    (->
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil)))
     <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ((app cons '* (app cons 'b (app cons 'x (app nil)))))
    ()
    (ran
     cons
     ((app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))))
     ()
     (ran
      cons
      ((app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))))
      ()
      (ran
       cons
       ('+)
       ()
       (ran
        deriv
        ()
        ()
        (let-bod
         letrec*
         ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
          (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
          (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
          (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
          (map
           (λ (map-f map-l)
             (match
              map-l
              ((cons map-c map-d)
               (app cons (app map-f map-c) (app map map-f map-d)))
              ((nil) (app nil)))))
          (pair?
           (λ (pair?-v)
             (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
          (deriv
           (λ (a)
             (match
              (app not (app pair? a))
              ((#f)
               (match
                (app eq? (app car a) '+)
                ((#f)
                 (match
                  (app eq? (app car a) '-)
                  ((#f)
                   (match
                    (app eq? (app car a) '*)
                    ((#f)
                     (match
                      (app eq? (app car a) '/)
                      ((#f)
                       (app error (app #f) "No derivation method available"))
                      (_
                       (app
                        cons
                        '-
                        (app
                         cons
                         (app
                          cons
                          '/
                          (app
                           cons
                           (app deriv (app cadr a))
                           (app cons (app caddr a) (app nil))))
                         (app
                          cons
                          (app
                           cons
                           '/
                           (app
                            cons
                            (app cadr a)
                            (app
                             cons
                             (app
                              cons
                              '*
                              (app
                               cons
                               (app caddr a)
                               (app
                                cons
                                (app caddr a)
                                (app
                                 cons
                                 (app deriv (app caddr a))
                                 (app nil)))))
                             (app nil))))
                          (app nil)))))))
                    (_
                     (app
                      cons
                      '*
                      (app
                       cons
                       a
                       (app
                        cons
                        (app
                         cons
                         '+
                         (app
                          map
                          (λ (a)
                            (app
                             cons
                             '/
                             (app cons (app deriv a) (app cons a (app nil)))))
                          (app cdr a)))
                        (app nil)))))))
                  (_ (app cons '- (app map deriv (app cdr a))))))
                (_ (app cons '+ (app map deriv (app cdr a))))))
              (_ (match (app eq? a 'x) ((#f) 0) (_ 1)))))))
         (lettypes-bod ((cons car cdr) (nil)) (top))))))))
   app
   cons
   5
   (app nil))
  con
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 'b (app cons 'x (app nil))))
    (-> (app cons 5 (app nil)) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ((app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))))
    ()
    (ran
     cons
     ('+)
     ()
     (ran
      deriv
      ()
      ()
      (let-bod
       letrec*
       ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
        (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
        (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
        (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
        (map
         (λ (map-f map-l)
           (match
            map-l
            ((cons map-c map-d)
             (app cons (app map-f map-c) (app map map-f map-d)))
            ((nil) (app nil)))))
        (pair?
         (λ (pair?-v)
           (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
        (deriv
         (λ (a)
           (match
            (app not (app pair? a))
            ((#f)
             (match
              (app eq? (app car a) '+)
              ((#f)
               (match
                (app eq? (app car a) '-)
                ((#f)
                 (match
                  (app eq? (app car a) '*)
                  ((#f)
                   (match
                    (app eq? (app car a) '/)
                    ((#f)
                     (app error (app #f) "No derivation method available"))
                    (_
                     (app
                      cons
                      '-
                      (app
                       cons
                       (app
                        cons
                        '/
                        (app
                         cons
                         (app deriv (app cadr a))
                         (app cons (app caddr a) (app nil))))
                       (app
                        cons
                        (app
                         cons
                         '/
                         (app
                          cons
                          (app cadr a)
                          (app
                           cons
                           (app
                            cons
                            '*
                            (app
                             cons
                             (app caddr a)
                             (app
                              cons
                              (app caddr a)
                              (app cons (app deriv (app caddr a)) (app nil)))))
                           (app nil))))
                        (app nil)))))))
                  (_
                   (app
                    cons
                    '*
                    (app
                     cons
                     a
                     (app
                      cons
                      (app
                       cons
                       '+
                       (app
                        map
                        (λ (a)
                          (app
                           cons
                           '/
                           (app cons (app deriv a) (app cons a (app nil)))))
                        (app cdr a)))
                      (app nil)))))))
                (_ (app cons '- (app map deriv (app cdr a))))))
              (_ (app cons '+ (app map deriv (app cdr a))))))
            (_ (match (app eq? a 'x) ((#f) 0) (_ 1)))))))
       (lettypes-bod ((cons car cdr) (nil)) (top))))))
   app
   cons
   (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app
    cons
    (app cons '* (app cons 'b (app cons 'x (app nil))))
    (app cons 5 (app nil))))
  con
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (->
     (app
      cons
      (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'b (app cons 'x (app nil))))
       (app cons 5 (app nil))))
     <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ((app deriv (app caddr a)))
    ()
    (ran
     cons
     ((app caddr a))
     ()
     (ran
      cons
      ((app caddr a))
      ()
      (ran
       cons
       ('*)
       ()
       (ran
        cons
        ()
        ((app nil))
        (ran
         cons
         ((app cadr a))
         ()
         (ran
          cons
          ('/)
          ()
          (ran
           cons
           ()
           ((app nil))
           (ran
            cons
            ((app
              cons
              '/
              (app
               cons
               (app deriv (app cadr a))
               (app cons (app caddr a) (app nil)))))
            ()
            (ran
             cons
             ('-)
             ()
             (match-clause
              _
              (app eq? (app car a) '/)
              (((#f) (app error (app #f) "No derivation method available")))
              ()
              (match-clause
               (#f)
               (app eq? (app car a) '*)
               ()
               ((_
                 (app
                  cons
                  '*
                  (app
                   cons
                   a
                   (app
                    cons
                    (app
                     cons
                     '+
                     (app
                      map
                      (λ (a)
                        (app
                         cons
                         '/
                         (app cons (app deriv a) (app cons a (app nil)))))
                      (app cdr a)))
                    (app nil))))))
               (match-clause
                (#f)
                (app eq? (app car a) '-)
                ()
                ((_ (app cons '- (app map deriv (app cdr a)))))
                (match-clause
                 (#f)
                 (app eq? (app car a) '+)
                 ()
                 ((_ (app cons '+ (app map deriv (app cdr a)))))
                 (match-clause
                  (#f)
                  (app not (app pair? a))
                  ()
                  ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
                  (bod
                   (a)
                   (bin
                    letrec*
                    deriv
                    (app
                     deriv
                     (app
                      cons
                      '+
                      (app
                       cons
                       (app
                        cons
                        '*
                        (app cons 3 (app cons 'x (app cons 'x (app nil)))))
                       (app
                        cons
                        (app
                         cons
                         '*
                         (app cons 'a (app cons 'x (app cons 'x (app nil)))))
                        (app
                         cons
                         (app cons '* (app cons 'b (app cons 'x (app nil))))
                         (app cons 5 (app nil)))))))
                    ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
                     (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
                     (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
                     (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
                     (map
                      (λ (map-f map-l)
                        (match
                         map-l
                         ((cons map-c map-d)
                          (app cons (app map-f map-c) (app map map-f map-d)))
                         ((nil) (app nil)))))
                     (pair?
                      (λ (pair?-v)
                        (match
                         pair?-v
                         ((cons pair?-c pair?-d) (app #t))
                         (_ (app #f))))))
                    ()
                    (lettypes-bod
                     ((cons car cdr) (nil))
                     (top)))))))))))))))))))
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
    ((app deriv (app cadr a)))
    ()
    (ran
     cons
     ('/)
     ()
     (ran
      cons
      ()
      ((app
        cons
        (app
         cons
         '/
         (app
          cons
          (app cadr a)
          (app
           cons
           (app
            cons
            '*
            (app
             cons
             (app caddr a)
             (app
              cons
              (app caddr a)
              (app cons (app deriv (app caddr a)) (app nil)))))
           (app nil))))
        (app nil)))
      (ran
       cons
       ('-)
       ()
       (match-clause
        _
        (app eq? (app car a) '/)
        (((#f) (app error (app #f) "No derivation method available")))
        ()
        (match-clause
         (#f)
         (app eq? (app car a) '*)
         ()
         ((_
           (app
            cons
            '*
            (app
             cons
             a
             (app
              cons
              (app
               cons
               '+
               (app
                map
                (λ (a)
                  (app
                   cons
                   '/
                   (app cons (app deriv a) (app cons a (app nil)))))
                (app cdr a)))
              (app nil))))))
         (match-clause
          (#f)
          (app eq? (app car a) '-)
          ()
          ((_ (app cons '- (app map deriv (app cdr a)))))
          (match-clause
           (#f)
           (app eq? (app car a) '+)
           ()
           ((_ (app cons '+ (app map deriv (app cdr a)))))
           (match-clause
            (#f)
            (app not (app pair? a))
            ()
            ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
            (bod
             (a)
             (bin
              letrec*
              deriv
              (app
               deriv
               (app
                cons
                '+
                (app
                 cons
                 (app
                  cons
                  '*
                  (app cons 3 (app cons 'x (app cons 'x (app nil)))))
                 (app
                  cons
                  (app
                   cons
                   '*
                   (app cons 'a (app cons 'x (app cons 'x (app nil)))))
                  (app
                   cons
                   (app cons '* (app cons 'b (app cons 'x (app nil))))
                   (app cons 5 (app nil)))))))
              ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
               (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
               (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
               (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
               (map
                (λ (map-f map-l)
                  (match
                   map-l
                   ((cons map-c map-d)
                    (app cons (app map-f map-c) (app map map-f map-d)))
                   ((nil) (app nil)))))
               (pair?
                (λ (pair?-v)
                  (match
                   pair?-v
                   ((cons pair?-c pair?-d) (app #t))
                   (_ (app #f))))))
              ()
              (lettypes-bod ((cons car cdr) (nil)) (top)))))))))))))
   app
   cons
   (app caddr a)
   (app nil))
  con
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (app deriv (app cadr a))
    (-> (app cons (app caddr a) (app nil)) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ((app deriv a))
    ()
    (ran
     cons
     ('/)
     ()
     (bod
      (a)
      (ran
       map
       ()
       ((app cdr a))
       (ran
        cons
        ('+)
        ()
        (ran
         cons
         ()
         ((app nil))
         (ran
          cons
          (a)
          ()
          (ran
           cons
           ('*)
           ()
           (match-clause
            _
            (app eq? (app car a) '*)
            (((#f)
              (match
               (app eq? (app car a) '/)
               ((#f) (app error (app #f) "No derivation method available"))
               (_
                (app
                 cons
                 '-
                 (app
                  cons
                  (app
                   cons
                   '/
                   (app
                    cons
                    (app deriv (app cadr a))
                    (app cons (app caddr a) (app nil))))
                  (app
                   cons
                   (app
                    cons
                    '/
                    (app
                     cons
                     (app cadr a)
                     (app
                      cons
                      (app
                       cons
                       '*
                       (app
                        cons
                        (app caddr a)
                        (app
                         cons
                         (app caddr a)
                         (app cons (app deriv (app caddr a)) (app nil)))))
                      (app nil))))
                   (app nil))))))))
            ()
            (match-clause
             (#f)
             (app eq? (app car a) '-)
             ()
             ((_ (app cons '- (app map deriv (app cdr a)))))
             (match-clause
              (#f)
              (app eq? (app car a) '+)
              ()
              ((_ (app cons '+ (app map deriv (app cdr a)))))
              (match-clause
               (#f)
               (app not (app pair? a))
               ()
               ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
               (bod
                (a)
                (bin
                 letrec*
                 deriv
                 (app
                  deriv
                  (app
                   cons
                   '+
                   (app
                    cons
                    (app
                     cons
                     '*
                     (app cons 3 (app cons 'x (app cons 'x (app nil)))))
                    (app
                     cons
                     (app
                      cons
                      '*
                      (app cons 'a (app cons 'x (app cons 'x (app nil)))))
                     (app
                      cons
                      (app cons '* (app cons 'b (app cons 'x (app nil))))
                      (app cons 5 (app nil)))))))
                 ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
                  (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
                  (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
                  (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
                  (map
                   (λ (map-f map-l)
                     (match
                      map-l
                      ((cons map-c map-d)
                       (app cons (app map-f map-c) (app map map-f map-d)))
                      ((nil) (app nil)))))
                  (pair?
                   (λ (pair?-v)
                     (match
                      pair?-v
                      ((cons pair?-c pair?-d) (app #t))
                      (_ (app #f))))))
                 ()
                 (lettypes-bod ((cons car cdr) (nil)) (top))))))))))))))))
   app
   cons
   a
   (app nil))
  con
  (env ()))
clos/con:
	'((con cons (app cons (app deriv a) (-> (app cons a (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ((app map-f map-c))
    ()
    (match-clause
     (cons map-c map-d)
     map-l
     ()
     (((nil) (app nil)))
     (bod
      (map-f map-l)
      (bin
       letrec*
       map
       (app
        deriv
        (app
         cons
         '+
         (app
          cons
          (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
          (app
           cons
           (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
           (app
            cons
            (app cons '* (app cons 'b (app cons 'x (app nil))))
            (app cons 5 (app nil)))))))
       ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
        (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
        (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
        (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v))))))
       ((pair?
         (λ (pair?-v)
           (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
        (deriv
         (λ (a)
           (match
            (app not (app pair? a))
            ((#f)
             (match
              (app eq? (app car a) '+)
              ((#f)
               (match
                (app eq? (app car a) '-)
                ((#f)
                 (match
                  (app eq? (app car a) '*)
                  ((#f)
                   (match
                    (app eq? (app car a) '/)
                    ((#f)
                     (app error (app #f) "No derivation method available"))
                    (_
                     (app
                      cons
                      '-
                      (app
                       cons
                       (app
                        cons
                        '/
                        (app
                         cons
                         (app deriv (app cadr a))
                         (app cons (app caddr a) (app nil))))
                       (app
                        cons
                        (app
                         cons
                         '/
                         (app
                          cons
                          (app cadr a)
                          (app
                           cons
                           (app
                            cons
                            '*
                            (app
                             cons
                             (app caddr a)
                             (app
                              cons
                              (app caddr a)
                              (app cons (app deriv (app caddr a)) (app nil)))))
                           (app nil))))
                        (app nil)))))))
                  (_
                   (app
                    cons
                    '*
                    (app
                     cons
                     a
                     (app
                      cons
                      (app
                       cons
                       '+
                       (app
                        map
                        (λ (a)
                          (app
                           cons
                           '/
                           (app cons (app deriv a) (app cons a (app nil)))))
                        (app cdr a)))
                      (app nil)))))))
                (_ (app cons '- (app map deriv (app cdr a))))))
              (_ (app cons '+ (app map deriv (app cdr a))))))
            (_ (match (app eq? a 'x) ((#f) 0) (_ 1)))))))
       (lettypes-bod ((cons car cdr) (nil)) (top))))))
   app
   map
   map-f
   map-d)
  con
  (env ()))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ()))
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
       '*
       (app
        cons
        (app caddr a)
        (app
         cons
         (app caddr a)
         (app cons (app deriv (app caddr a)) (app nil)))))
      (app nil)))
    (ran
     cons
     ('/)
     ()
     (ran
      cons
      ()
      ((app nil))
      (ran
       cons
       ((app
         cons
         '/
         (app
          cons
          (app deriv (app cadr a))
          (app cons (app caddr a) (app nil)))))
       ()
       (ran
        cons
        ('-)
        ()
        (match-clause
         _
         (app eq? (app car a) '/)
         (((#f) (app error (app #f) "No derivation method available")))
         ()
         (match-clause
          (#f)
          (app eq? (app car a) '*)
          ()
          ((_
            (app
             cons
             '*
             (app
              cons
              a
              (app
               cons
               (app
                cons
                '+
                (app
                 map
                 (λ (a)
                   (app
                    cons
                    '/
                    (app cons (app deriv a) (app cons a (app nil)))))
                 (app cdr a)))
               (app nil))))))
          (match-clause
           (#f)
           (app eq? (app car a) '-)
           ()
           ((_ (app cons '- (app map deriv (app cdr a)))))
           (match-clause
            (#f)
            (app eq? (app car a) '+)
            ()
            ((_ (app cons '+ (app map deriv (app cdr a)))))
            (match-clause
             (#f)
             (app not (app pair? a))
             ()
             ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
             (bod
              (a)
              (bin
               letrec*
               deriv
               (app
                deriv
                (app
                 cons
                 '+
                 (app
                  cons
                  (app
                   cons
                   '*
                   (app cons 3 (app cons 'x (app cons 'x (app nil)))))
                  (app
                   cons
                   (app
                    cons
                    '*
                    (app cons 'a (app cons 'x (app cons 'x (app nil)))))
                   (app
                    cons
                    (app cons '* (app cons 'b (app cons 'x (app nil))))
                    (app cons 5 (app nil)))))))
               ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
                (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
                (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
                (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
                (map
                 (λ (map-f map-l)
                   (match
                    map-l
                    ((cons map-c map-d)
                     (app cons (app map-f map-c) (app map map-f map-d)))
                    ((nil) (app nil)))))
                (pair?
                 (λ (pair?-v)
                   (match
                    pair?-v
                    ((cons pair?-c pair?-d) (app #t))
                    (_ (app #f))))))
               ()
               (lettypes-bod ((cons car cdr) (nil)) (top))))))))))))))
   app
   cadr
   a)
  con
  (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app
      cons
      (app
       cons
       '+
       (app
        map
        (λ (a) (app cons '/ (app cons (app deriv a) (app cons a (app nil)))))
        (app cdr a)))
      (app nil)))
    (ran
     cons
     ('*)
     ()
     (match-clause
      _
      (app eq? (app car a) '*)
      (((#f)
        (match
         (app eq? (app car a) '/)
         ((#f) (app error (app #f) "No derivation method available"))
         (_
          (app
           cons
           '-
           (app
            cons
            (app
             cons
             '/
             (app
              cons
              (app deriv (app cadr a))
              (app cons (app caddr a) (app nil))))
            (app
             cons
             (app
              cons
              '/
              (app
               cons
               (app cadr a)
               (app
                cons
                (app
                 cons
                 '*
                 (app
                  cons
                  (app caddr a)
                  (app
                   cons
                   (app caddr a)
                   (app cons (app deriv (app caddr a)) (app nil)))))
                (app nil))))
             (app nil))))))))
      ()
      (match-clause
       (#f)
       (app eq? (app car a) '-)
       ()
       ((_ (app cons '- (app map deriv (app cdr a)))))
       (match-clause
        (#f)
        (app eq? (app car a) '+)
        ()
        ((_ (app cons '+ (app map deriv (app cdr a)))))
        (match-clause
         (#f)
         (app not (app pair? a))
         ()
         ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
         (bod
          (a)
          (bin
           letrec*
           deriv
           (app
            deriv
            (app
             cons
             '+
             (app
              cons
              (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
              (app
               cons
               (app
                cons
                '*
                (app cons 'a (app cons 'x (app cons 'x (app nil)))))
               (app
                cons
                (app cons '* (app cons 'b (app cons 'x (app nil))))
                (app cons 5 (app nil)))))))
           ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
            (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
            (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
            (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
            (map
             (λ (map-f map-l)
               (match
                map-l
                ((cons map-c map-d)
                 (app cons (app map-f map-c) (app map map-f map-d)))
                ((nil) (app nil)))))
            (pair?
             (λ (pair?-v)
               (match
                pair?-v
                ((cons pair?-c pair?-d) (app #t))
                (_ (app #f))))))
           ()
           (lettypes-bod ((cons car cdr) (nil)) (top))))))))))
   .
   a)
  con
  (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((con
   cons
   (app
    deriv
    (->
     (app
      cons
      '+
      (app
       cons
       (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
        (app
         cons
         (app cons '* (app cons 'b (app cons 'x (app nil))))
         (app cons 5 (app nil))))))
     <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app
      cons
      (app
       cons
       '/
       (app
        cons
        (app cadr a)
        (app
         cons
         (app
          cons
          '*
          (app
           cons
           (app caddr a)
           (app
            cons
            (app caddr a)
            (app cons (app deriv (app caddr a)) (app nil)))))
         (app nil))))
      (app nil)))
    (ran
     cons
     ('-)
     ()
     (match-clause
      _
      (app eq? (app car a) '/)
      (((#f) (app error (app #f) "No derivation method available")))
      ()
      (match-clause
       (#f)
       (app eq? (app car a) '*)
       ()
       ((_
         (app
          cons
          '*
          (app
           cons
           a
           (app
            cons
            (app
             cons
             '+
             (app
              map
              (λ (a)
                (app cons '/ (app cons (app deriv a) (app cons a (app nil)))))
              (app cdr a)))
            (app nil))))))
       (match-clause
        (#f)
        (app eq? (app car a) '-)
        ()
        ((_ (app cons '- (app map deriv (app cdr a)))))
        (match-clause
         (#f)
         (app eq? (app car a) '+)
         ()
         ((_ (app cons '+ (app map deriv (app cdr a)))))
         (match-clause
          (#f)
          (app not (app pair? a))
          ()
          ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
          (bod
           (a)
           (bin
            letrec*
            deriv
            (app
             deriv
             (app
              cons
              '+
              (app
               cons
               (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
               (app
                cons
                (app
                 cons
                 '*
                 (app cons 'a (app cons 'x (app cons 'x (app nil)))))
                (app
                 cons
                 (app cons '* (app cons 'b (app cons 'x (app nil))))
                 (app cons 5 (app nil)))))))
            ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
             (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
             (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
             (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
             (map
              (λ (map-f map-l)
                (match
                 map-l
                 ((cons map-c map-d)
                  (app cons (app map-f map-c) (app map map-f map-d)))
                 ((nil) (app nil)))))
             (pair?
              (λ (pair?-v)
                (match
                 pair?-v
                 ((cons pair?-c pair?-d) (app #t))
                 (_ (app #f))))))
            ()
            (lettypes-bod ((cons car cdr) (nil)) (top)))))))))))
   app
   cons
   '/
   (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil))))
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
      '/
      (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil))))
     <-)
    (app
     cons
     (app
      cons
      '/
      (app
       cons
       (app cadr a)
       (app
        cons
        (app
         cons
         '*
         (app
          cons
          (app caddr a)
          (app
           cons
           (app caddr a)
           (app cons (app deriv (app caddr a)) (app nil)))))
        (app nil))))
     (app nil))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app
      cons
      (app
       cons
       '/
       (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil))))
      (app
       cons
       (app
        cons
        '/
        (app
         cons
         (app cadr a)
         (app
          cons
          (app
           cons
           '*
           (app
            cons
            (app caddr a)
            (app
             cons
             (app caddr a)
             (app cons (app deriv (app caddr a)) (app nil)))))
          (app nil))))
       (app nil))))
    (match-clause
     _
     (app eq? (app car a) '/)
     (((#f) (app error (app #f) "No derivation method available")))
     ()
     (match-clause
      (#f)
      (app eq? (app car a) '*)
      ()
      ((_
        (app
         cons
         '*
         (app
          cons
          a
          (app
           cons
           (app
            cons
            '+
            (app
             map
             (λ (a)
               (app cons '/ (app cons (app deriv a) (app cons a (app nil)))))
             (app cdr a)))
           (app nil))))))
      (match-clause
       (#f)
       (app eq? (app car a) '-)
       ()
       ((_ (app cons '- (app map deriv (app cdr a)))))
       (match-clause
        (#f)
        (app eq? (app car a) '+)
        ()
        ((_ (app cons '+ (app map deriv (app cdr a)))))
        (match-clause
         (#f)
         (app not (app pair? a))
         ()
         ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
         (bod
          (a)
          (bin
           letrec*
           deriv
           (app
            deriv
            (app
             cons
             '+
             (app
              cons
              (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
              (app
               cons
               (app
                cons
                '*
                (app cons 'a (app cons 'x (app cons 'x (app nil)))))
               (app
                cons
                (app cons '* (app cons 'b (app cons 'x (app nil))))
                (app cons 5 (app nil)))))))
           ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
            (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
            (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
            (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
            (map
             (λ (map-f map-l)
               (match
                map-l
                ((cons map-c map-d)
                 (app cons (app map-f map-c) (app map map-f map-d)))
                ((nil) (app nil)))))
            (pair?
             (λ (pair?-v)
               (match
                pair?-v
                ((cons pair?-c pair?-d) (app #t))
                (_ (app #f))))))
           ()
           (lettypes-bod ((cons car cdr) (nil)) (top))))))))))
   quote
   -)
  con
  (env ()))
clos/con:
	'((app
   cons
   (-> '- <-)
   (app
    cons
    (app
     cons
     '/
     (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil))))
    (app
     cons
     (app
      cons
      '/
      (app
       cons
       (app cadr a)
       (app
        cons
        (app
         cons
         '*
         (app
          cons
          (app caddr a)
          (app
           cons
           (app caddr a)
           (app cons (app deriv (app caddr a)) (app nil)))))
        (app nil))))
     (app nil))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app
      cons
      (app caddr a)
      (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))))
    (ran
     cons
     ()
     ((app nil))
     (ran
      cons
      ((app cadr a))
      ()
      (ran
       cons
       ('/)
       ()
       (ran
        cons
        ()
        ((app nil))
        (ran
         cons
         ((app
           cons
           '/
           (app
            cons
            (app deriv (app cadr a))
            (app cons (app caddr a) (app nil)))))
         ()
         (ran
          cons
          ('-)
          ()
          (match-clause
           _
           (app eq? (app car a) '/)
           (((#f) (app error (app #f) "No derivation method available")))
           ()
           (match-clause
            (#f)
            (app eq? (app car a) '*)
            ()
            ((_
              (app
               cons
               '*
               (app
                cons
                a
                (app
                 cons
                 (app
                  cons
                  '+
                  (app
                   map
                   (λ (a)
                     (app
                      cons
                      '/
                      (app cons (app deriv a) (app cons a (app nil)))))
                   (app cdr a)))
                 (app nil))))))
            (match-clause
             (#f)
             (app eq? (app car a) '-)
             ()
             ((_ (app cons '- (app map deriv (app cdr a)))))
             (match-clause
              (#f)
              (app eq? (app car a) '+)
              ()
              ((_ (app cons '+ (app map deriv (app cdr a)))))
              (match-clause
               (#f)
               (app not (app pair? a))
               ()
               ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
               (bod
                (a)
                (bin
                 letrec*
                 deriv
                 (app
                  deriv
                  (app
                   cons
                   '+
                   (app
                    cons
                    (app
                     cons
                     '*
                     (app cons 3 (app cons 'x (app cons 'x (app nil)))))
                    (app
                     cons
                     (app
                      cons
                      '*
                      (app cons 'a (app cons 'x (app cons 'x (app nil)))))
                     (app
                      cons
                      (app cons '* (app cons 'b (app cons 'x (app nil))))
                      (app cons 5 (app nil)))))))
                 ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
                  (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
                  (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
                  (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
                  (map
                   (λ (map-f map-l)
                     (match
                      map-l
                      ((cons map-c map-d)
                       (app cons (app map-f map-c) (app map map-f map-d)))
                      ((nil) (app nil)))))
                  (pair?
                   (λ (pair?-v)
                     (match
                      pair?-v
                      ((cons pair?-c pair?-d) (app #t))
                      (_ (app #f))))))
                 ()
                 (lettypes-bod ((cons car cdr) (nil)) (top))))))))))))))))
   quote
   *)
  con
  (env ()))
clos/con:
	'((app
   cons
   (-> '* <-)
   (app
    cons
    (app caddr a)
    (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app
      cons
      (app cadr a)
      (app
       cons
       (app
        cons
        '*
        (app
         cons
         (app caddr a)
         (app
          cons
          (app caddr a)
          (app cons (app deriv (app caddr a)) (app nil)))))
       (app nil))))
    (ran
     cons
     ()
     ((app nil))
     (ran
      cons
      ((app
        cons
        '/
        (app
         cons
         (app deriv (app cadr a))
         (app cons (app caddr a) (app nil)))))
      ()
      (ran
       cons
       ('-)
       ()
       (match-clause
        _
        (app eq? (app car a) '/)
        (((#f) (app error (app #f) "No derivation method available")))
        ()
        (match-clause
         (#f)
         (app eq? (app car a) '*)
         ()
         ((_
           (app
            cons
            '*
            (app
             cons
             a
             (app
              cons
              (app
               cons
               '+
               (app
                map
                (λ (a)
                  (app
                   cons
                   '/
                   (app cons (app deriv a) (app cons a (app nil)))))
                (app cdr a)))
              (app nil))))))
         (match-clause
          (#f)
          (app eq? (app car a) '-)
          ()
          ((_ (app cons '- (app map deriv (app cdr a)))))
          (match-clause
           (#f)
           (app eq? (app car a) '+)
           ()
           ((_ (app cons '+ (app map deriv (app cdr a)))))
           (match-clause
            (#f)
            (app not (app pair? a))
            ()
            ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
            (bod
             (a)
             (bin
              letrec*
              deriv
              (app
               deriv
               (app
                cons
                '+
                (app
                 cons
                 (app
                  cons
                  '*
                  (app cons 3 (app cons 'x (app cons 'x (app nil)))))
                 (app
                  cons
                  (app
                   cons
                   '*
                   (app cons 'a (app cons 'x (app cons 'x (app nil)))))
                  (app
                   cons
                   (app cons '* (app cons 'b (app cons 'x (app nil))))
                   (app cons 5 (app nil)))))))
              ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
               (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
               (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
               (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
               (map
                (λ (map-f map-l)
                  (match
                   map-l
                   ((cons map-c map-d)
                    (app cons (app map-f map-c) (app map map-f map-d)))
                   ((nil) (app nil)))))
               (pair?
                (λ (pair?-v)
                  (match
                   pair?-v
                   ((cons pair?-c pair?-d) (app #t))
                   (_ (app #f))))))
              ()
              (lettypes-bod ((cons car cdr) (nil)) (top)))))))))))))
   quote
   /)
  con
  (env ()))
clos/con:
	'((app
   cons
   (-> '/ <-)
   (app
    cons
    (app cadr a)
    (app
     cons
     (app
      cons
      '*
      (app
       cons
       (app caddr a)
       (app
        cons
        (app caddr a)
        (app cons (app deriv (app caddr a)) (app nil)))))
     (app nil))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app
      cons
      (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'b (app cons 'x (app nil))))
       (app cons 5 (app nil)))))
    (ran
     cons
     ('+)
     ()
     (ran
      deriv
      ()
      ()
      (let-bod
       letrec*
       ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
        (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
        (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
        (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
        (map
         (λ (map-f map-l)
           (match
            map-l
            ((cons map-c map-d)
             (app cons (app map-f map-c) (app map map-f map-d)))
            ((nil) (app nil)))))
        (pair?
         (λ (pair?-v)
           (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
        (deriv
         (λ (a)
           (match
            (app not (app pair? a))
            ((#f)
             (match
              (app eq? (app car a) '+)
              ((#f)
               (match
                (app eq? (app car a) '-)
                ((#f)
                 (match
                  (app eq? (app car a) '*)
                  ((#f)
                   (match
                    (app eq? (app car a) '/)
                    ((#f)
                     (app error (app #f) "No derivation method available"))
                    (_
                     (app
                      cons
                      '-
                      (app
                       cons
                       (app
                        cons
                        '/
                        (app
                         cons
                         (app deriv (app cadr a))
                         (app cons (app caddr a) (app nil))))
                       (app
                        cons
                        (app
                         cons
                         '/
                         (app
                          cons
                          (app cadr a)
                          (app
                           cons
                           (app
                            cons
                            '*
                            (app
                             cons
                             (app caddr a)
                             (app
                              cons
                              (app caddr a)
                              (app cons (app deriv (app caddr a)) (app nil)))))
                           (app nil))))
                        (app nil)))))))
                  (_
                   (app
                    cons
                    '*
                    (app
                     cons
                     a
                     (app
                      cons
                      (app
                       cons
                       '+
                       (app
                        map
                        (λ (a)
                          (app
                           cons
                           '/
                           (app cons (app deriv a) (app cons a (app nil)))))
                        (app cdr a)))
                      (app nil)))))))
                (_ (app cons '- (app map deriv (app cdr a))))))
              (_ (app cons '+ (app map deriv (app cdr a))))))
            (_ (match (app eq? a 'x) ((#f) 0) (_ 1)))))))
       (lettypes-bod ((cons car cdr) (nil)) (top))))))
   app
   cons
   '*
   (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  con
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))
    (ran
     cons
     ((app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))))
     ()
     (ran
      cons
      ('+)
      ()
      (ran
       deriv
       ()
       ()
       (let-bod
        letrec*
        ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
         (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
         (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
         (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
         (map
          (λ (map-f map-l)
            (match
             map-l
             ((cons map-c map-d)
              (app cons (app map-f map-c) (app map map-f map-d)))
             ((nil) (app nil)))))
         (pair?
          (λ (pair?-v)
            (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
         (deriv
          (λ (a)
            (match
             (app not (app pair? a))
             ((#f)
              (match
               (app eq? (app car a) '+)
               ((#f)
                (match
                 (app eq? (app car a) '-)
                 ((#f)
                  (match
                   (app eq? (app car a) '*)
                   ((#f)
                    (match
                     (app eq? (app car a) '/)
                     ((#f)
                      (app error (app #f) "No derivation method available"))
                     (_
                      (app
                       cons
                       '-
                       (app
                        cons
                        (app
                         cons
                         '/
                         (app
                          cons
                          (app deriv (app cadr a))
                          (app cons (app caddr a) (app nil))))
                        (app
                         cons
                         (app
                          cons
                          '/
                          (app
                           cons
                           (app cadr a)
                           (app
                            cons
                            (app
                             cons
                             '*
                             (app
                              cons
                              (app caddr a)
                              (app
                               cons
                               (app caddr a)
                               (app
                                cons
                                (app deriv (app caddr a))
                                (app nil)))))
                            (app nil))))
                         (app nil)))))))
                   (_
                    (app
                     cons
                     '*
                     (app
                      cons
                      a
                      (app
                       cons
                       (app
                        cons
                        '+
                        (app
                         map
                         (λ (a)
                           (app
                            cons
                            '/
                            (app cons (app deriv a) (app cons a (app nil)))))
                         (app cdr a)))
                       (app nil)))))))
                 (_ (app cons '- (app map deriv (app cdr a))))))
               (_ (app cons '+ (app map deriv (app cdr a))))))
             (_ (match (app eq? a 'x) ((#f) 0) (_ 1)))))))
        (lettypes-bod ((cons car cdr) (nil)) (top)))))))
   app
   cons
   '*
   (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  con
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app
      cons
      (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'b (app cons 'x (app nil))))
        (app cons 5 (app nil))))))
    (ran
     deriv
     ()
     ()
     (let-bod
      letrec*
      ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
       (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
       (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
       (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
       (map
        (λ (map-f map-l)
          (match
           map-l
           ((cons map-c map-d)
            (app cons (app map-f map-c) (app map map-f map-d)))
           ((nil) (app nil)))))
       (pair?
        (λ (pair?-v)
          (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
       (deriv
        (λ (a)
          (match
           (app not (app pair? a))
           ((#f)
            (match
             (app eq? (app car a) '+)
             ((#f)
              (match
               (app eq? (app car a) '-)
               ((#f)
                (match
                 (app eq? (app car a) '*)
                 ((#f)
                  (match
                   (app eq? (app car a) '/)
                   ((#f) (app error (app #f) "No derivation method available"))
                   (_
                    (app
                     cons
                     '-
                     (app
                      cons
                      (app
                       cons
                       '/
                       (app
                        cons
                        (app deriv (app cadr a))
                        (app cons (app caddr a) (app nil))))
                      (app
                       cons
                       (app
                        cons
                        '/
                        (app
                         cons
                         (app cadr a)
                         (app
                          cons
                          (app
                           cons
                           '*
                           (app
                            cons
                            (app caddr a)
                            (app
                             cons
                             (app caddr a)
                             (app cons (app deriv (app caddr a)) (app nil)))))
                          (app nil))))
                       (app nil)))))))
                 (_
                  (app
                   cons
                   '*
                   (app
                    cons
                    a
                    (app
                     cons
                     (app
                      cons
                      '+
                      (app
                       map
                       (λ (a)
                         (app
                          cons
                          '/
                          (app cons (app deriv a) (app cons a (app nil)))))
                       (app cdr a)))
                     (app nil)))))))
               (_ (app cons '- (app map deriv (app cdr a))))))
             (_ (app cons '+ (app map deriv (app cdr a))))))
           (_ (match (app eq? a 'x) ((#f) 0) (_ 1)))))))
      (lettypes-bod ((cons car cdr) (nil)) (top)))))
   quote
   +)
  con
  (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app
      cons
      a
      (app
       cons
       (app
        cons
        '+
        (app
         map
         (λ (a) (app cons '/ (app cons (app deriv a) (app cons a (app nil)))))
         (app cdr a)))
       (app nil))))
    (match-clause
     _
     (app eq? (app car a) '*)
     (((#f)
       (match
        (app eq? (app car a) '/)
        ((#f) (app error (app #f) "No derivation method available"))
        (_
         (app
          cons
          '-
          (app
           cons
           (app
            cons
            '/
            (app
             cons
             (app deriv (app cadr a))
             (app cons (app caddr a) (app nil))))
           (app
            cons
            (app
             cons
             '/
             (app
              cons
              (app cadr a)
              (app
               cons
               (app
                cons
                '*
                (app
                 cons
                 (app caddr a)
                 (app
                  cons
                  (app caddr a)
                  (app cons (app deriv (app caddr a)) (app nil)))))
               (app nil))))
            (app nil))))))))
     ()
     (match-clause
      (#f)
      (app eq? (app car a) '-)
      ()
      ((_ (app cons '- (app map deriv (app cdr a)))))
      (match-clause
       (#f)
       (app eq? (app car a) '+)
       ()
       ((_ (app cons '+ (app map deriv (app cdr a)))))
       (match-clause
        (#f)
        (app not (app pair? a))
        ()
        ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
        (bod
         (a)
         (bin
          letrec*
          deriv
          (app
           deriv
           (app
            cons
            '+
            (app
             cons
             (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
             (app
              cons
              (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
              (app
               cons
               (app cons '* (app cons 'b (app cons 'x (app nil))))
               (app cons 5 (app nil)))))))
          ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
           (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
           (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
           (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
           (map
            (λ (map-f map-l)
              (match
               map-l
               ((cons map-c map-d)
                (app cons (app map-f map-c) (app map map-f map-d)))
               ((nil) (app nil)))))
           (pair?
            (λ (pair?-v)
              (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f))))))
          ()
          (lettypes-bod ((cons car cdr) (nil)) (top)))))))))
   quote
   *)
  con
  (env ()))
clos/con:
	'((app
   cons
   (-> '* <-)
   (app
    cons
    a
    (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app
      map
      (λ (a) (app cons '/ (app cons (app deriv a) (app cons a (app nil)))))
      (app cdr a)))
    (ran
     cons
     ()
     ((app nil))
     (ran
      cons
      (a)
      ()
      (ran
       cons
       ('*)
       ()
       (match-clause
        _
        (app eq? (app car a) '*)
        (((#f)
          (match
           (app eq? (app car a) '/)
           ((#f) (app error (app #f) "No derivation method available"))
           (_
            (app
             cons
             '-
             (app
              cons
              (app
               cons
               '/
               (app
                cons
                (app deriv (app cadr a))
                (app cons (app caddr a) (app nil))))
              (app
               cons
               (app
                cons
                '/
                (app
                 cons
                 (app cadr a)
                 (app
                  cons
                  (app
                   cons
                   '*
                   (app
                    cons
                    (app caddr a)
                    (app
                     cons
                     (app caddr a)
                     (app cons (app deriv (app caddr a)) (app nil)))))
                  (app nil))))
               (app nil))))))))
        ()
        (match-clause
         (#f)
         (app eq? (app car a) '-)
         ()
         ((_ (app cons '- (app map deriv (app cdr a)))))
         (match-clause
          (#f)
          (app eq? (app car a) '+)
          ()
          ((_ (app cons '+ (app map deriv (app cdr a)))))
          (match-clause
           (#f)
           (app not (app pair? a))
           ()
           ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
           (bod
            (a)
            (bin
             letrec*
             deriv
             (app
              deriv
              (app
               cons
               '+
               (app
                cons
                (app
                 cons
                 '*
                 (app cons 3 (app cons 'x (app cons 'x (app nil)))))
                (app
                 cons
                 (app
                  cons
                  '*
                  (app cons 'a (app cons 'x (app cons 'x (app nil)))))
                 (app
                  cons
                  (app cons '* (app cons 'b (app cons 'x (app nil))))
                  (app cons 5 (app nil)))))))
             ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
              (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
              (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
              (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
              (map
               (λ (map-f map-l)
                 (match
                  map-l
                  ((cons map-c map-d)
                   (app cons (app map-f map-c) (app map map-f map-d)))
                  ((nil) (app nil)))))
              (pair?
               (λ (pair?-v)
                 (match
                  pair?-v
                  ((cons pair?-c pair?-d) (app #t))
                  (_ (app #f))))))
             ()
             (lettypes-bod ((cons car cdr) (nil)) (top))))))))))))
   quote
   +)
  con
  (env ()))
clos/con:
	'((app cons (-> '+ <-) (app map (λ (a) ...) (app cdr a))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app cons 'a (app cons 'x (app cons 'x (app nil)))))
    (ran
     cons
     ()
     ((app
       cons
       (app cons '* (app cons 'b (app cons 'x (app nil))))
       (app cons 5 (app nil))))
     (ran
      cons
      ((app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))))
      ()
      (ran
       cons
       ('+)
       ()
       (ran
        deriv
        ()
        ()
        (let-bod
         letrec*
         ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
          (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
          (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
          (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
          (map
           (λ (map-f map-l)
             (match
              map-l
              ((cons map-c map-d)
               (app cons (app map-f map-c) (app map map-f map-d)))
              ((nil) (app nil)))))
          (pair?
           (λ (pair?-v)
             (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
          (deriv
           (λ (a)
             (match
              (app not (app pair? a))
              ((#f)
               (match
                (app eq? (app car a) '+)
                ((#f)
                 (match
                  (app eq? (app car a) '-)
                  ((#f)
                   (match
                    (app eq? (app car a) '*)
                    ((#f)
                     (match
                      (app eq? (app car a) '/)
                      ((#f)
                       (app error (app #f) "No derivation method available"))
                      (_
                       (app
                        cons
                        '-
                        (app
                         cons
                         (app
                          cons
                          '/
                          (app
                           cons
                           (app deriv (app cadr a))
                           (app cons (app caddr a) (app nil))))
                         (app
                          cons
                          (app
                           cons
                           '/
                           (app
                            cons
                            (app cadr a)
                            (app
                             cons
                             (app
                              cons
                              '*
                              (app
                               cons
                               (app caddr a)
                               (app
                                cons
                                (app caddr a)
                                (app
                                 cons
                                 (app deriv (app caddr a))
                                 (app nil)))))
                             (app nil))))
                          (app nil)))))))
                    (_
                     (app
                      cons
                      '*
                      (app
                       cons
                       a
                       (app
                        cons
                        (app
                         cons
                         '+
                         (app
                          map
                          (λ (a)
                            (app
                             cons
                             '/
                             (app cons (app deriv a) (app cons a (app nil)))))
                          (app cdr a)))
                        (app nil)))))))
                  (_ (app cons '- (app map deriv (app cdr a))))))
                (_ (app cons '+ (app map deriv (app cdr a))))))
              (_ (match (app eq? a 'x) ((#f) 0) (_ 1)))))))
         (lettypes-bod ((cons car cdr) (nil)) (top))))))))
   quote
   *)
  con
  (env ()))
clos/con:
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app cons 'b (app cons 'x (app nil))))
    (ran
     cons
     ()
     ((app cons 5 (app nil)))
     (ran
      cons
      ((app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))))
      ()
      (ran
       cons
       ((app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))))
       ()
       (ran
        cons
        ('+)
        ()
        (ran
         deriv
         ()
         ()
         (let-bod
          letrec*
          ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
           (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
           (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
           (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
           (map
            (λ (map-f map-l)
              (match
               map-l
               ((cons map-c map-d)
                (app cons (app map-f map-c) (app map map-f map-d)))
               ((nil) (app nil)))))
           (pair?
            (λ (pair?-v)
              (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
           (deriv
            (λ (a)
              (match
               (app not (app pair? a))
               ((#f)
                (match
                 (app eq? (app car a) '+)
                 ((#f)
                  (match
                   (app eq? (app car a) '-)
                   ((#f)
                    (match
                     (app eq? (app car a) '*)
                     ((#f)
                      (match
                       (app eq? (app car a) '/)
                       ((#f)
                        (app error (app #f) "No derivation method available"))
                       (_
                        (app
                         cons
                         '-
                         (app
                          cons
                          (app
                           cons
                           '/
                           (app
                            cons
                            (app deriv (app cadr a))
                            (app cons (app caddr a) (app nil))))
                          (app
                           cons
                           (app
                            cons
                            '/
                            (app
                             cons
                             (app cadr a)
                             (app
                              cons
                              (app
                               cons
                               '*
                               (app
                                cons
                                (app caddr a)
                                (app
                                 cons
                                 (app caddr a)
                                 (app
                                  cons
                                  (app deriv (app caddr a))
                                  (app nil)))))
                              (app nil))))
                           (app nil)))))))
                     (_
                      (app
                       cons
                       '*
                       (app
                        cons
                        a
                        (app
                         cons
                         (app
                          cons
                          '+
                          (app
                           map
                           (λ (a)
                             (app
                              cons
                              '/
                              (app cons (app deriv a) (app cons a (app nil)))))
                           (app cdr a)))
                         (app nil)))))))
                   (_ (app cons '- (app map deriv (app cdr a))))))
                 (_ (app cons '+ (app map deriv (app cdr a))))))
               (_ (match (app eq? a 'x) ((#f) 0) (_ 1)))))))
          (lettypes-bod ((cons car cdr) (nil)) (top)))))))))
   quote
   *)
  con
  (env ()))
clos/con:
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app cons 'x (app cons 'x (app nil))))
    (ran
     cons
     ('*)
     ()
     (ran
      cons
      ()
      ((app
        cons
        (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
        (app
         cons
         (app cons '* (app cons 'b (app cons 'x (app nil))))
         (app cons 5 (app nil)))))
      (ran
       cons
       ('+)
       ()
       (ran
        deriv
        ()
        ()
        (let-bod
         letrec*
         ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
          (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
          (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
          (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
          (map
           (λ (map-f map-l)
             (match
              map-l
              ((cons map-c map-d)
               (app cons (app map-f map-c) (app map map-f map-d)))
              ((nil) (app nil)))))
          (pair?
           (λ (pair?-v)
             (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
          (deriv
           (λ (a)
             (match
              (app not (app pair? a))
              ((#f)
               (match
                (app eq? (app car a) '+)
                ((#f)
                 (match
                  (app eq? (app car a) '-)
                  ((#f)
                   (match
                    (app eq? (app car a) '*)
                    ((#f)
                     (match
                      (app eq? (app car a) '/)
                      ((#f)
                       (app error (app #f) "No derivation method available"))
                      (_
                       (app
                        cons
                        '-
                        (app
                         cons
                         (app
                          cons
                          '/
                          (app
                           cons
                           (app deriv (app cadr a))
                           (app cons (app caddr a) (app nil))))
                         (app
                          cons
                          (app
                           cons
                           '/
                           (app
                            cons
                            (app cadr a)
                            (app
                             cons
                             (app
                              cons
                              '*
                              (app
                               cons
                               (app caddr a)
                               (app
                                cons
                                (app caddr a)
                                (app
                                 cons
                                 (app deriv (app caddr a))
                                 (app nil)))))
                             (app nil))))
                          (app nil)))))))
                    (_
                     (app
                      cons
                      '*
                      (app
                       cons
                       a
                       (app
                        cons
                        (app
                         cons
                         '+
                         (app
                          map
                          (λ (a)
                            (app
                             cons
                             '/
                             (app cons (app deriv a) (app cons a (app nil)))))
                          (app cdr a)))
                        (app nil)))))))
                  (_ (app cons '- (app map deriv (app cdr a))))))
                (_ (app cons '+ (app map deriv (app cdr a))))))
              (_ (match (app eq? a 'x) ((#f) 0) (_ 1)))))))
         (lettypes-bod ((cons car cdr) (nil)) (top))))))))
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
    ((app cons 'x (app cons 'x (app nil))))
    (ran
     cons
     ('*)
     ()
     (ran
      cons
      ()
      ((app
        cons
        (app cons '* (app cons 'b (app cons 'x (app nil))))
        (app cons 5 (app nil))))
      (ran
       cons
       ((app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))))
       ()
       (ran
        cons
        ('+)
        ()
        (ran
         deriv
         ()
         ()
         (let-bod
          letrec*
          ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
           (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
           (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
           (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
           (map
            (λ (map-f map-l)
              (match
               map-l
               ((cons map-c map-d)
                (app cons (app map-f map-c) (app map map-f map-d)))
               ((nil) (app nil)))))
           (pair?
            (λ (pair?-v)
              (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
           (deriv
            (λ (a)
              (match
               (app not (app pair? a))
               ((#f)
                (match
                 (app eq? (app car a) '+)
                 ((#f)
                  (match
                   (app eq? (app car a) '-)
                   ((#f)
                    (match
                     (app eq? (app car a) '*)
                     ((#f)
                      (match
                       (app eq? (app car a) '/)
                       ((#f)
                        (app error (app #f) "No derivation method available"))
                       (_
                        (app
                         cons
                         '-
                         (app
                          cons
                          (app
                           cons
                           '/
                           (app
                            cons
                            (app deriv (app cadr a))
                            (app cons (app caddr a) (app nil))))
                          (app
                           cons
                           (app
                            cons
                            '/
                            (app
                             cons
                             (app cadr a)
                             (app
                              cons
                              (app
                               cons
                               '*
                               (app
                                cons
                                (app caddr a)
                                (app
                                 cons
                                 (app caddr a)
                                 (app
                                  cons
                                  (app deriv (app caddr a))
                                  (app nil)))))
                              (app nil))))
                           (app nil)))))))
                     (_
                      (app
                       cons
                       '*
                       (app
                        cons
                        a
                        (app
                         cons
                         (app
                          cons
                          '+
                          (app
                           map
                           (λ (a)
                             (app
                              cons
                              '/
                              (app cons (app deriv a) (app cons a (app nil)))))
                           (app cdr a)))
                         (app nil)))))))
                   (_ (app cons '- (app map deriv (app cdr a))))))
                 (_ (app cons '+ (app map deriv (app cdr a))))))
               (_ (match (app eq? a 'x) ((#f) 0) (_ 1)))))))
          (lettypes-bod ((cons car cdr) (nil)) (top)))))))))
   quote
   a)
  con
  (env ()))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app cons 'x (app nil)))
    (ran
     cons
     ('*)
     ()
     (ran
      cons
      ()
      ((app cons 5 (app nil)))
      (ran
       cons
       ((app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))))
       ()
       (ran
        cons
        ((app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))))
        ()
        (ran
         cons
         ('+)
         ()
         (ran
          deriv
          ()
          ()
          (let-bod
           letrec*
           ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
            (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
            (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
            (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
            (map
             (λ (map-f map-l)
               (match
                map-l
                ((cons map-c map-d)
                 (app cons (app map-f map-c) (app map map-f map-d)))
                ((nil) (app nil)))))
            (pair?
             (λ (pair?-v)
               (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
            (deriv
             (λ (a)
               (match
                (app not (app pair? a))
                ((#f)
                 (match
                  (app eq? (app car a) '+)
                  ((#f)
                   (match
                    (app eq? (app car a) '-)
                    ((#f)
                     (match
                      (app eq? (app car a) '*)
                      ((#f)
                       (match
                        (app eq? (app car a) '/)
                        ((#f)
                         (app error (app #f) "No derivation method available"))
                        (_
                         (app
                          cons
                          '-
                          (app
                           cons
                           (app
                            cons
                            '/
                            (app
                             cons
                             (app deriv (app cadr a))
                             (app cons (app caddr a) (app nil))))
                           (app
                            cons
                            (app
                             cons
                             '/
                             (app
                              cons
                              (app cadr a)
                              (app
                               cons
                               (app
                                cons
                                '*
                                (app
                                 cons
                                 (app caddr a)
                                 (app
                                  cons
                                  (app caddr a)
                                  (app
                                   cons
                                   (app deriv (app caddr a))
                                   (app nil)))))
                               (app nil))))
                            (app nil)))))))
                      (_
                       (app
                        cons
                        '*
                        (app
                         cons
                         a
                         (app
                          cons
                          (app
                           cons
                           '+
                           (app
                            map
                            (λ (a)
                              (app
                               cons
                               '/
                               (app
                                cons
                                (app deriv a)
                                (app cons a (app nil)))))
                            (app cdr a)))
                          (app nil)))))))
                    (_ (app cons '- (app map deriv (app cdr a))))))
                  (_ (app cons '+ (app map deriv (app cdr a))))))
                (_ (match (app eq? a 'x) ((#f) 0) (_ 1)))))))
           (lettypes-bod ((cons car cdr) (nil)) (top))))))))))
   quote
   b)
  con
  (env ()))
clos/con:
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app cons 'x (app nil)))
    (ran
     cons
     ('a)
     ()
     (ran
      cons
      ('*)
      ()
      (ran
       cons
       ()
       ((app
         cons
         (app cons '* (app cons 'b (app cons 'x (app nil))))
         (app cons 5 (app nil))))
       (ran
        cons
        ((app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))))
        ()
        (ran
         cons
         ('+)
         ()
         (ran
          deriv
          ()
          ()
          (let-bod
           letrec*
           ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
            (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
            (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
            (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
            (map
             (λ (map-f map-l)
               (match
                map-l
                ((cons map-c map-d)
                 (app cons (app map-f map-c) (app map map-f map-d)))
                ((nil) (app nil)))))
            (pair?
             (λ (pair?-v)
               (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
            (deriv
             (λ (a)
               (match
                (app not (app pair? a))
                ((#f)
                 (match
                  (app eq? (app car a) '+)
                  ((#f)
                   (match
                    (app eq? (app car a) '-)
                    ((#f)
                     (match
                      (app eq? (app car a) '*)
                      ((#f)
                       (match
                        (app eq? (app car a) '/)
                        ((#f)
                         (app error (app #f) "No derivation method available"))
                        (_
                         (app
                          cons
                          '-
                          (app
                           cons
                           (app
                            cons
                            '/
                            (app
                             cons
                             (app deriv (app cadr a))
                             (app cons (app caddr a) (app nil))))
                           (app
                            cons
                            (app
                             cons
                             '/
                             (app
                              cons
                              (app cadr a)
                              (app
                               cons
                               (app
                                cons
                                '*
                                (app
                                 cons
                                 (app caddr a)
                                 (app
                                  cons
                                  (app caddr a)
                                  (app
                                   cons
                                   (app deriv (app caddr a))
                                   (app nil)))))
                               (app nil))))
                            (app nil)))))))
                      (_
                       (app
                        cons
                        '*
                        (app
                         cons
                         a
                         (app
                          cons
                          (app
                           cons
                           '+
                           (app
                            map
                            (λ (a)
                              (app
                               cons
                               '/
                               (app
                                cons
                                (app deriv a)
                                (app cons a (app nil)))))
                            (app cdr a)))
                          (app nil)))))))
                    (_ (app cons '- (app map deriv (app cdr a))))))
                  (_ (app cons '+ (app map deriv (app cdr a))))))
                (_ (match (app eq? a 'x) ((#f) 0) (_ 1)))))))
           (lettypes-bod ((cons car cdr) (nil)) (top))))))))))
   quote
   x)
  con
  (env ()))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app cons 'x (app nil)))
    (ran
     cons
     (3)
     ()
     (ran
      cons
      ('*)
      ()
      (ran
       cons
       ()
       ((app
         cons
         (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
         (app
          cons
          (app cons '* (app cons 'b (app cons 'x (app nil))))
          (app cons 5 (app nil)))))
       (ran
        cons
        ('+)
        ()
        (ran
         deriv
         ()
         ()
         (let-bod
          letrec*
          ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
           (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
           (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
           (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
           (map
            (λ (map-f map-l)
              (match
               map-l
               ((cons map-c map-d)
                (app cons (app map-f map-c) (app map map-f map-d)))
               ((nil) (app nil)))))
           (pair?
            (λ (pair?-v)
              (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
           (deriv
            (λ (a)
              (match
               (app not (app pair? a))
               ((#f)
                (match
                 (app eq? (app car a) '+)
                 ((#f)
                  (match
                   (app eq? (app car a) '-)
                   ((#f)
                    (match
                     (app eq? (app car a) '*)
                     ((#f)
                      (match
                       (app eq? (app car a) '/)
                       ((#f)
                        (app error (app #f) "No derivation method available"))
                       (_
                        (app
                         cons
                         '-
                         (app
                          cons
                          (app
                           cons
                           '/
                           (app
                            cons
                            (app deriv (app cadr a))
                            (app cons (app caddr a) (app nil))))
                          (app
                           cons
                           (app
                            cons
                            '/
                            (app
                             cons
                             (app cadr a)
                             (app
                              cons
                              (app
                               cons
                               '*
                               (app
                                cons
                                (app caddr a)
                                (app
                                 cons
                                 (app caddr a)
                                 (app
                                  cons
                                  (app deriv (app caddr a))
                                  (app nil)))))
                              (app nil))))
                           (app nil)))))))
                     (_
                      (app
                       cons
                       '*
                       (app
                        cons
                        a
                        (app
                         cons
                         (app
                          cons
                          '+
                          (app
                           map
                           (λ (a)
                             (app
                              cons
                              '/
                              (app cons (app deriv a) (app cons a (app nil)))))
                           (app cdr a)))
                         (app nil)))))))
                   (_ (app cons '- (app map deriv (app cdr a))))))
                 (_ (app cons '+ (app map deriv (app cdr a))))))
               (_ (match (app eq? a 'x) ((#f) 0) (_ 1)))))))
          (lettypes-bod ((cons car cdr) (nil)) (top)))))))))
   quote
   x)
  con
  (env ()))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil))))
    (ran
     cons
     ('*)
     ()
     (ran
      cons
      ()
      ((app nil))
      (ran
       cons
       ((app cadr a))
       ()
       (ran
        cons
        ('/)
        ()
        (ran
         cons
         ()
         ((app nil))
         (ran
          cons
          ((app
            cons
            '/
            (app
             cons
             (app deriv (app cadr a))
             (app cons (app caddr a) (app nil)))))
          ()
          (ran
           cons
           ('-)
           ()
           (match-clause
            _
            (app eq? (app car a) '/)
            (((#f) (app error (app #f) "No derivation method available")))
            ()
            (match-clause
             (#f)
             (app eq? (app car a) '*)
             ()
             ((_
               (app
                cons
                '*
                (app
                 cons
                 a
                 (app
                  cons
                  (app
                   cons
                   '+
                   (app
                    map
                    (λ (a)
                      (app
                       cons
                       '/
                       (app cons (app deriv a) (app cons a (app nil)))))
                    (app cdr a)))
                  (app nil))))))
             (match-clause
              (#f)
              (app eq? (app car a) '-)
              ()
              ((_ (app cons '- (app map deriv (app cdr a)))))
              (match-clause
               (#f)
               (app eq? (app car a) '+)
               ()
               ((_ (app cons '+ (app map deriv (app cdr a)))))
               (match-clause
                (#f)
                (app not (app pair? a))
                ()
                ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
                (bod
                 (a)
                 (bin
                  letrec*
                  deriv
                  (app
                   deriv
                   (app
                    cons
                    '+
                    (app
                     cons
                     (app
                      cons
                      '*
                      (app cons 3 (app cons 'x (app cons 'x (app nil)))))
                     (app
                      cons
                      (app
                       cons
                       '*
                       (app cons 'a (app cons 'x (app cons 'x (app nil)))))
                      (app
                       cons
                       (app cons '* (app cons 'b (app cons 'x (app nil))))
                       (app cons 5 (app nil)))))))
                  ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
                   (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
                   (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
                   (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
                   (map
                    (λ (map-f map-l)
                      (match
                       map-l
                       ((cons map-c map-d)
                        (app cons (app map-f map-c) (app map map-f map-d)))
                       ((nil) (app nil)))))
                   (pair?
                    (λ (pair?-v)
                      (match
                       pair?-v
                       ((cons pair?-c pair?-d) (app #t))
                       (_ (app #f))))))
                  ()
                  (lettypes-bod ((cons car cdr) (nil)) (top)))))))))))))))))
   app
   caddr
   a)
  con
  (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app cons (app caddr a) (app nil)))
    (ran
     cons
     ('/)
     ()
     (ran
      cons
      ()
      ((app
        cons
        (app
         cons
         '/
         (app
          cons
          (app cadr a)
          (app
           cons
           (app
            cons
            '*
            (app
             cons
             (app caddr a)
             (app
              cons
              (app caddr a)
              (app cons (app deriv (app caddr a)) (app nil)))))
           (app nil))))
        (app nil)))
      (ran
       cons
       ('-)
       ()
       (match-clause
        _
        (app eq? (app car a) '/)
        (((#f) (app error (app #f) "No derivation method available")))
        ()
        (match-clause
         (#f)
         (app eq? (app car a) '*)
         ()
         ((_
           (app
            cons
            '*
            (app
             cons
             a
             (app
              cons
              (app
               cons
               '+
               (app
                map
                (λ (a)
                  (app
                   cons
                   '/
                   (app cons (app deriv a) (app cons a (app nil)))))
                (app cdr a)))
              (app nil))))))
         (match-clause
          (#f)
          (app eq? (app car a) '-)
          ()
          ((_ (app cons '- (app map deriv (app cdr a)))))
          (match-clause
           (#f)
           (app eq? (app car a) '+)
           ()
           ((_ (app cons '+ (app map deriv (app cdr a)))))
           (match-clause
            (#f)
            (app not (app pair? a))
            ()
            ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
            (bod
             (a)
             (bin
              letrec*
              deriv
              (app
               deriv
               (app
                cons
                '+
                (app
                 cons
                 (app
                  cons
                  '*
                  (app cons 3 (app cons 'x (app cons 'x (app nil)))))
                 (app
                  cons
                  (app
                   cons
                   '*
                   (app cons 'a (app cons 'x (app cons 'x (app nil)))))
                  (app
                   cons
                   (app cons '* (app cons 'b (app cons 'x (app nil))))
                   (app cons 5 (app nil)))))))
              ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
               (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
               (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
               (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
               (map
                (λ (map-f map-l)
                  (match
                   map-l
                   ((cons map-c map-d)
                    (app cons (app map-f map-c) (app map map-f map-d)))
                   ((nil) (app nil)))))
               (pair?
                (λ (pair?-v)
                  (match
                   pair?-v
                   ((cons pair?-c pair?-d) (app #t))
                   (_ (app #f))))))
              ()
              (lettypes-bod ((cons car cdr) (nil)) (top)))))))))))))
   app
   deriv
   (app cadr a))
  con
  (env ()))
clos/con:
	'((con
   cons
   (match
    (app eq? (app car a) '*)
    (#f)
    (_
     (->
      (app
       cons
       '*
       (app
        cons
        a
        (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
      <-))))
  (env ()))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env ()))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ()))
	'((con
   cons
   (match
    (app eq? (app car a) '/)
    (#f)
    (_
     (->
      (app
       cons
       '-
       (app
        cons
        (app
         cons
         '/
         (app
          cons
          (app deriv (app cadr a))
          (app cons (app caddr a) (app nil))))
        (app
         cons
         (app
          cons
          '/
          (app
           cons
           (app cadr a)
           (app
            cons
            (app
             cons
             '*
             (app
              cons
              (app caddr a)
              (app
               cons
               (app caddr a)
               (app cons (app deriv (app caddr a)) (app nil)))))
            (app nil))))
         (app nil))))
      <-))))
  (env ()))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app cons (app deriv (app caddr a)) (app nil)))
    (ran
     cons
     ((app caddr a))
     ()
     (ran
      cons
      ('*)
      ()
      (ran
       cons
       ()
       ((app nil))
       (ran
        cons
        ((app cadr a))
        ()
        (ran
         cons
         ('/)
         ()
         (ran
          cons
          ()
          ((app nil))
          (ran
           cons
           ((app
             cons
             '/
             (app
              cons
              (app deriv (app cadr a))
              (app cons (app caddr a) (app nil)))))
           ()
           (ran
            cons
            ('-)
            ()
            (match-clause
             _
             (app eq? (app car a) '/)
             (((#f) (app error (app #f) "No derivation method available")))
             ()
             (match-clause
              (#f)
              (app eq? (app car a) '*)
              ()
              ((_
                (app
                 cons
                 '*
                 (app
                  cons
                  a
                  (app
                   cons
                   (app
                    cons
                    '+
                    (app
                     map
                     (λ (a)
                       (app
                        cons
                        '/
                        (app cons (app deriv a) (app cons a (app nil)))))
                     (app cdr a)))
                   (app nil))))))
              (match-clause
               (#f)
               (app eq? (app car a) '-)
               ()
               ((_ (app cons '- (app map deriv (app cdr a)))))
               (match-clause
                (#f)
                (app eq? (app car a) '+)
                ()
                ((_ (app cons '+ (app map deriv (app cdr a)))))
                (match-clause
                 (#f)
                 (app not (app pair? a))
                 ()
                 ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
                 (bod
                  (a)
                  (bin
                   letrec*
                   deriv
                   (app
                    deriv
                    (app
                     cons
                     '+
                     (app
                      cons
                      (app
                       cons
                       '*
                       (app cons 3 (app cons 'x (app cons 'x (app nil)))))
                      (app
                       cons
                       (app
                        cons
                        '*
                        (app cons 'a (app cons 'x (app cons 'x (app nil)))))
                       (app
                        cons
                        (app cons '* (app cons 'b (app cons 'x (app nil))))
                        (app cons 5 (app nil)))))))
                   ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
                    (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
                    (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
                    (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
                    (map
                     (λ (map-f map-l)
                       (match
                        map-l
                        ((cons map-c map-d)
                         (app cons (app map-f map-c) (app map map-f map-d)))
                        ((nil) (app nil)))))
                    (pair?
                     (λ (pair?-v)
                       (match
                        pair?-v
                        ((cons pair?-c pair?-d) (app #t))
                        (_ (app #f))))))
                   ()
                   (lettypes-bod ((cons car cdr) (nil)) (top))))))))))))))))))
   app
   caddr
   a)
  con
  (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil))))
    (ran
     cons
     ()
     ((app
       cons
       (app
        cons
        '/
        (app
         cons
         (app cadr a)
         (app
          cons
          (app
           cons
           '*
           (app
            cons
            (app caddr a)
            (app
             cons
             (app caddr a)
             (app cons (app deriv (app caddr a)) (app nil)))))
          (app nil))))
       (app nil)))
     (ran
      cons
      ('-)
      ()
      (match-clause
       _
       (app eq? (app car a) '/)
       (((#f) (app error (app #f) "No derivation method available")))
       ()
       (match-clause
        (#f)
        (app eq? (app car a) '*)
        ()
        ((_
          (app
           cons
           '*
           (app
            cons
            a
            (app
             cons
             (app
              cons
              '+
              (app
               map
               (λ (a)
                 (app cons '/ (app cons (app deriv a) (app cons a (app nil)))))
               (app cdr a)))
             (app nil))))))
        (match-clause
         (#f)
         (app eq? (app car a) '-)
         ()
         ((_ (app cons '- (app map deriv (app cdr a)))))
         (match-clause
          (#f)
          (app eq? (app car a) '+)
          ()
          ((_ (app cons '+ (app map deriv (app cdr a)))))
          (match-clause
           (#f)
           (app not (app pair? a))
           ()
           ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
           (bod
            (a)
            (bin
             letrec*
             deriv
             (app
              deriv
              (app
               cons
               '+
               (app
                cons
                (app
                 cons
                 '*
                 (app cons 3 (app cons 'x (app cons 'x (app nil)))))
                (app
                 cons
                 (app
                  cons
                  '*
                  (app cons 'a (app cons 'x (app cons 'x (app nil)))))
                 (app
                  cons
                  (app cons '* (app cons 'b (app cons 'x (app nil))))
                  (app cons 5 (app nil)))))))
             ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
              (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
              (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
              (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
              (map
               (λ (map-f map-l)
                 (match
                  map-l
                  ((cons map-c map-d)
                   (app cons (app map-f map-c) (app map map-f map-d)))
                  ((nil) (app nil)))))
              (pair?
               (λ (pair?-v)
                 (match
                  pair?-v
                  ((cons pair?-c pair?-d) (app #t))
                  (_ (app #f))))))
             ()
             (lettypes-bod ((cons car cdr) (nil)) (top))))))))))))
   quote
   /)
  con
  (env ()))
clos/con:
	'((app
   cons
   (-> '/ <-)
   (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app cons (app deriv a) (app cons a (app nil))))
    (bod
     (a)
     (ran
      map
      ()
      ((app cdr a))
      (ran
       cons
       ('+)
       ()
       (ran
        cons
        ()
        ((app nil))
        (ran
         cons
         (a)
         ()
         (ran
          cons
          ('*)
          ()
          (match-clause
           _
           (app eq? (app car a) '*)
           (((#f)
             (match
              (app eq? (app car a) '/)
              ((#f) (app error (app #f) "No derivation method available"))
              (_
               (app
                cons
                '-
                (app
                 cons
                 (app
                  cons
                  '/
                  (app
                   cons
                   (app deriv (app cadr a))
                   (app cons (app caddr a) (app nil))))
                 (app
                  cons
                  (app
                   cons
                   '/
                   (app
                    cons
                    (app cadr a)
                    (app
                     cons
                     (app
                      cons
                      '*
                      (app
                       cons
                       (app caddr a)
                       (app
                        cons
                        (app caddr a)
                        (app cons (app deriv (app caddr a)) (app nil)))))
                     (app nil))))
                  (app nil))))))))
           ()
           (match-clause
            (#f)
            (app eq? (app car a) '-)
            ()
            ((_ (app cons '- (app map deriv (app cdr a)))))
            (match-clause
             (#f)
             (app eq? (app car a) '+)
             ()
             ((_ (app cons '+ (app map deriv (app cdr a)))))
             (match-clause
              (#f)
              (app not (app pair? a))
              ()
              ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
              (bod
               (a)
               (bin
                letrec*
                deriv
                (app
                 deriv
                 (app
                  cons
                  '+
                  (app
                   cons
                   (app
                    cons
                    '*
                    (app cons 3 (app cons 'x (app cons 'x (app nil)))))
                   (app
                    cons
                    (app
                     cons
                     '*
                     (app cons 'a (app cons 'x (app cons 'x (app nil)))))
                    (app
                     cons
                     (app cons '* (app cons 'b (app cons 'x (app nil))))
                     (app cons 5 (app nil)))))))
                ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
                 (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
                 (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
                 (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
                 (map
                  (λ (map-f map-l)
                    (match
                     map-l
                     ((cons map-c map-d)
                      (app cons (app map-f map-c) (app map map-f map-d)))
                     ((nil) (app nil)))))
                 (pair?
                  (λ (pair?-v)
                    (match
                     pair?-v
                     ((cons pair?-c pair?-d) (app #t))
                     (_ (app #f))))))
                ()
                (lettypes-bod ((cons car cdr) (nil)) (top)))))))))))))))
   quote
   /)
  con
  (env ()))
clos/con:
	'((app cons (-> '/ <-) (app cons (app deriv a) (app cons a (app nil))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (ran
     cons
     ()
     ((app
       cons
       (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'b (app cons 'x (app nil))))
        (app cons 5 (app nil)))))
     (ran
      cons
      ('+)
      ()
      (ran
       deriv
       ()
       ()
       (let-bod
        letrec*
        ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
         (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
         (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
         (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
         (map
          (λ (map-f map-l)
            (match
             map-l
             ((cons map-c map-d)
              (app cons (app map-f map-c) (app map map-f map-d)))
             ((nil) (app nil)))))
         (pair?
          (λ (pair?-v)
            (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
         (deriv
          (λ (a)
            (match
             (app not (app pair? a))
             ((#f)
              (match
               (app eq? (app car a) '+)
               ((#f)
                (match
                 (app eq? (app car a) '-)
                 ((#f)
                  (match
                   (app eq? (app car a) '*)
                   ((#f)
                    (match
                     (app eq? (app car a) '/)
                     ((#f)
                      (app error (app #f) "No derivation method available"))
                     (_
                      (app
                       cons
                       '-
                       (app
                        cons
                        (app
                         cons
                         '/
                         (app
                          cons
                          (app deriv (app cadr a))
                          (app cons (app caddr a) (app nil))))
                        (app
                         cons
                         (app
                          cons
                          '/
                          (app
                           cons
                           (app cadr a)
                           (app
                            cons
                            (app
                             cons
                             '*
                             (app
                              cons
                              (app caddr a)
                              (app
                               cons
                               (app caddr a)
                               (app
                                cons
                                (app deriv (app caddr a))
                                (app nil)))))
                            (app nil))))
                         (app nil)))))))
                   (_
                    (app
                     cons
                     '*
                     (app
                      cons
                      a
                      (app
                       cons
                       (app
                        cons
                        '+
                        (app
                         map
                         (λ (a)
                           (app
                            cons
                            '/
                            (app cons (app deriv a) (app cons a (app nil)))))
                         (app cdr a)))
                       (app nil)))))))
                 (_ (app cons '- (app map deriv (app cdr a))))))
               (_ (app cons '+ (app map deriv (app cdr a))))))
             (_ (match (app eq? a 'x) ((#f) 0) (_ 1)))))))
        (lettypes-bod ((cons car cdr) (nil)) (top)))))))
   quote
   *)
  con
  (env ()))
clos/con:
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app cons 5 (app nil)))
    (ran
     cons
     ((app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))))
     ()
     (ran
      cons
      ((app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))))
      ()
      (ran
       cons
       ('+)
       ()
       (ran
        deriv
        ()
        ()
        (let-bod
         letrec*
         ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
          (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
          (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
          (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
          (map
           (λ (map-f map-l)
             (match
              map-l
              ((cons map-c map-d)
               (app cons (app map-f map-c) (app map map-f map-d)))
              ((nil) (app nil)))))
          (pair?
           (λ (pair?-v)
             (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
          (deriv
           (λ (a)
             (match
              (app not (app pair? a))
              ((#f)
               (match
                (app eq? (app car a) '+)
                ((#f)
                 (match
                  (app eq? (app car a) '-)
                  ((#f)
                   (match
                    (app eq? (app car a) '*)
                    ((#f)
                     (match
                      (app eq? (app car a) '/)
                      ((#f)
                       (app error (app #f) "No derivation method available"))
                      (_
                       (app
                        cons
                        '-
                        (app
                         cons
                         (app
                          cons
                          '/
                          (app
                           cons
                           (app deriv (app cadr a))
                           (app cons (app caddr a) (app nil))))
                         (app
                          cons
                          (app
                           cons
                           '/
                           (app
                            cons
                            (app cadr a)
                            (app
                             cons
                             (app
                              cons
                              '*
                              (app
                               cons
                               (app caddr a)
                               (app
                                cons
                                (app caddr a)
                                (app
                                 cons
                                 (app deriv (app caddr a))
                                 (app nil)))))
                             (app nil))))
                          (app nil)))))))
                    (_
                     (app
                      cons
                      '*
                      (app
                       cons
                       a
                       (app
                        cons
                        (app
                         cons
                         '+
                         (app
                          map
                          (λ (a)
                            (app
                             cons
                             '/
                             (app cons (app deriv a) (app cons a (app nil)))))
                          (app cdr a)))
                        (app nil)))))))
                  (_ (app cons '- (app map deriv (app cdr a))))))
                (_ (app cons '+ (app map deriv (app cdr a))))))
              (_ (match (app eq? a 'x) ((#f) 0) (_ 1)))))))
         (lettypes-bod ((cons car cdr) (nil)) (top))))))))
   app
   cons
   '*
   (app cons 'b (app cons 'x (app nil))))
  con
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app cons a (app nil)))
    (ran
     cons
     ('/)
     ()
     (bod
      (a)
      (ran
       map
       ()
       ((app cdr a))
       (ran
        cons
        ('+)
        ()
        (ran
         cons
         ()
         ((app nil))
         (ran
          cons
          (a)
          ()
          (ran
           cons
           ('*)
           ()
           (match-clause
            _
            (app eq? (app car a) '*)
            (((#f)
              (match
               (app eq? (app car a) '/)
               ((#f) (app error (app #f) "No derivation method available"))
               (_
                (app
                 cons
                 '-
                 (app
                  cons
                  (app
                   cons
                   '/
                   (app
                    cons
                    (app deriv (app cadr a))
                    (app cons (app caddr a) (app nil))))
                  (app
                   cons
                   (app
                    cons
                    '/
                    (app
                     cons
                     (app cadr a)
                     (app
                      cons
                      (app
                       cons
                       '*
                       (app
                        cons
                        (app caddr a)
                        (app
                         cons
                         (app caddr a)
                         (app cons (app deriv (app caddr a)) (app nil)))))
                      (app nil))))
                   (app nil))))))))
            ()
            (match-clause
             (#f)
             (app eq? (app car a) '-)
             ()
             ((_ (app cons '- (app map deriv (app cdr a)))))
             (match-clause
              (#f)
              (app eq? (app car a) '+)
              ()
              ((_ (app cons '+ (app map deriv (app cdr a)))))
              (match-clause
               (#f)
               (app not (app pair? a))
               ()
               ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
               (bod
                (a)
                (bin
                 letrec*
                 deriv
                 (app
                  deriv
                  (app
                   cons
                   '+
                   (app
                    cons
                    (app
                     cons
                     '*
                     (app cons 3 (app cons 'x (app cons 'x (app nil)))))
                    (app
                     cons
                     (app
                      cons
                      '*
                      (app cons 'a (app cons 'x (app cons 'x (app nil)))))
                     (app
                      cons
                      (app cons '* (app cons 'b (app cons 'x (app nil))))
                      (app cons 5 (app nil)))))))
                 ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
                  (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
                  (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
                  (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
                  (map
                   (λ (map-f map-l)
                     (match
                      map-l
                      ((cons map-c map-d)
                       (app cons (app map-f map-c) (app map map-f map-d)))
                      ((nil) (app nil)))))
                  (pair?
                   (λ (pair?-v)
                     (match
                      pair?-v
                      ((cons pair?-c pair?-d) (app #t))
                      (_ (app #f))))))
                 ()
                 (lettypes-bod ((cons car cdr) (nil)) (top))))))))))))))))
   app
   deriv
   a)
  con
  (env ()))
clos/con:
	'((con
   cons
   (match
    (app eq? (app car a) '*)
    (#f)
    (_
     (->
      (app
       cons
       '*
       (app
        cons
        a
        (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
      <-))))
  (env ()))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env ()))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ()))
	'((con
   cons
   (match
    (app eq? (app car a) '/)
    (#f)
    (_
     (->
      (app
       cons
       '-
       (app
        cons
        (app
         cons
         '/
         (app
          cons
          (app deriv (app cadr a))
          (app cons (app caddr a) (app nil))))
        (app
         cons
         (app
          cons
          '/
          (app
           cons
           (app cadr a)
           (app
            cons
            (app
             cons
             '*
             (app
              cons
              (app caddr a)
              (app
               cons
               (app caddr a)
               (app cons (app deriv (app caddr a)) (app nil)))))
            (app nil))))
         (app nil))))
      <-))))
  (env ()))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app map deriv (app cdr a)))
    (match-clause
     _
     (app eq? (app car a) '+)
     (((#f)
       (match
        (app eq? (app car a) '-)
        ((#f)
         (match
          (app eq? (app car a) '*)
          ((#f)
           (match
            (app eq? (app car a) '/)
            ((#f) (app error (app #f) "No derivation method available"))
            (_
             (app
              cons
              '-
              (app
               cons
               (app
                cons
                '/
                (app
                 cons
                 (app deriv (app cadr a))
                 (app cons (app caddr a) (app nil))))
               (app
                cons
                (app
                 cons
                 '/
                 (app
                  cons
                  (app cadr a)
                  (app
                   cons
                   (app
                    cons
                    '*
                    (app
                     cons
                     (app caddr a)
                     (app
                      cons
                      (app caddr a)
                      (app cons (app deriv (app caddr a)) (app nil)))))
                   (app nil))))
                (app nil)))))))
          (_
           (app
            cons
            '*
            (app
             cons
             a
             (app
              cons
              (app
               cons
               '+
               (app
                map
                (λ (a)
                  (app
                   cons
                   '/
                   (app cons (app deriv a) (app cons a (app nil)))))
                (app cdr a)))
              (app nil)))))))
        (_ (app cons '- (app map deriv (app cdr a)))))))
     ()
     (match-clause
      (#f)
      (app not (app pair? a))
      ()
      ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
      (bod
       (a)
       (bin
        letrec*
        deriv
        (app
         deriv
         (app
          cons
          '+
          (app
           cons
           (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
           (app
            cons
            (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
            (app
             cons
             (app cons '* (app cons 'b (app cons 'x (app nil))))
             (app cons 5 (app nil)))))))
        ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
         (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
         (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
         (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
         (map
          (λ (map-f map-l)
            (match
             map-l
             ((cons map-c map-d)
              (app cons (app map-f map-c) (app map map-f map-d)))
             ((nil) (app nil)))))
         (pair?
          (λ (pair?-v)
            (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f))))))
        ()
        (lettypes-bod ((cons car cdr) (nil)) (top)))))))
   quote
   +)
  con
  (env ()))
clos/con:
	'((app cons (-> '+ <-) (app map deriv (app cdr a))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app map deriv (app cdr a)))
    (match-clause
     _
     (app eq? (app car a) '-)
     (((#f)
       (match
        (app eq? (app car a) '*)
        ((#f)
         (match
          (app eq? (app car a) '/)
          ((#f) (app error (app #f) "No derivation method available"))
          (_
           (app
            cons
            '-
            (app
             cons
             (app
              cons
              '/
              (app
               cons
               (app deriv (app cadr a))
               (app cons (app caddr a) (app nil))))
             (app
              cons
              (app
               cons
               '/
               (app
                cons
                (app cadr a)
                (app
                 cons
                 (app
                  cons
                  '*
                  (app
                   cons
                   (app caddr a)
                   (app
                    cons
                    (app caddr a)
                    (app cons (app deriv (app caddr a)) (app nil)))))
                 (app nil))))
              (app nil)))))))
        (_
         (app
          cons
          '*
          (app
           cons
           a
           (app
            cons
            (app
             cons
             '+
             (app
              map
              (λ (a)
                (app cons '/ (app cons (app deriv a) (app cons a (app nil)))))
              (app cdr a)))
            (app nil))))))))
     ()
     (match-clause
      (#f)
      (app eq? (app car a) '+)
      ()
      ((_ (app cons '+ (app map deriv (app cdr a)))))
      (match-clause
       (#f)
       (app not (app pair? a))
       ()
       ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
       (bod
        (a)
        (bin
         letrec*
         deriv
         (app
          deriv
          (app
           cons
           '+
           (app
            cons
            (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
            (app
             cons
             (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
             (app
              cons
              (app cons '* (app cons 'b (app cons 'x (app nil))))
              (app cons 5 (app nil)))))))
         ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
          (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
          (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
          (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
          (map
           (λ (map-f map-l)
             (match
              map-l
              ((cons map-c map-d)
               (app cons (app map-f map-c) (app map map-f map-d)))
              ((nil) (app nil)))))
          (pair?
           (λ (pair?-v)
             (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f))))))
         ()
         (lettypes-bod ((cons car cdr) (nil)) (top))))))))
   quote
   -)
  con
  (env ()))
clos/con:
	'((app cons (-> '- <-) (app map deriv (app cdr a))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app map map-f map-d))
    (match-clause
     (cons map-c map-d)
     map-l
     ()
     (((nil) (app nil)))
     (bod
      (map-f map-l)
      (bin
       letrec*
       map
       (app
        deriv
        (app
         cons
         '+
         (app
          cons
          (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
          (app
           cons
           (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
           (app
            cons
            (app cons '* (app cons 'b (app cons 'x (app nil))))
            (app cons 5 (app nil)))))))
       ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
        (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
        (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
        (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v))))))
       ((pair?
         (λ (pair?-v)
           (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
        (deriv
         (λ (a)
           (match
            (app not (app pair? a))
            ((#f)
             (match
              (app eq? (app car a) '+)
              ((#f)
               (match
                (app eq? (app car a) '-)
                ((#f)
                 (match
                  (app eq? (app car a) '*)
                  ((#f)
                   (match
                    (app eq? (app car a) '/)
                    ((#f)
                     (app error (app #f) "No derivation method available"))
                    (_
                     (app
                      cons
                      '-
                      (app
                       cons
                       (app
                        cons
                        '/
                        (app
                         cons
                         (app deriv (app cadr a))
                         (app cons (app caddr a) (app nil))))
                       (app
                        cons
                        (app
                         cons
                         '/
                         (app
                          cons
                          (app cadr a)
                          (app
                           cons
                           (app
                            cons
                            '*
                            (app
                             cons
                             (app caddr a)
                             (app
                              cons
                              (app caddr a)
                              (app cons (app deriv (app caddr a)) (app nil)))))
                           (app nil))))
                        (app nil)))))))
                  (_
                   (app
                    cons
                    '*
                    (app
                     cons
                     a
                     (app
                      cons
                      (app
                       cons
                       '+
                       (app
                        map
                        (λ (a)
                          (app
                           cons
                           '/
                           (app cons (app deriv a) (app cons a (app nil)))))
                        (app cdr a)))
                      (app nil)))))))
                (_ (app cons '- (app map deriv (app cdr a))))))
              (_ (app cons '+ (app map deriv (app cdr a))))))
            (_ (match (app eq? a 'x) ((#f) 0) (_ 1)))))))
       (lettypes-bod ((cons car cdr) (nil)) (top))))))
   app
   map-f
   map-c)
  con
  (env ()))
clos/con:
	'((con
   cons
   (match
    (app eq? (app car a) '*)
    (#f)
    (_
     (->
      (app
       cons
       '*
       (app
        cons
        a
        (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
      <-))))
  (env ()))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env ()))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ()))
	'((con
   cons
   (match
    (app eq? (app car a) '/)
    (#f)
    (_
     (->
      (app
       cons
       '-
       (app
        cons
        (app
         cons
         '/
         (app
          cons
          (app deriv (app cadr a))
          (app cons (app caddr a) (app nil))))
        (app
         cons
         (app
          cons
          '/
          (app
           cons
           (app cadr a)
           (app
            cons
            (app
             cons
             '*
             (app
              cons
              (app caddr a)
              (app
               cons
               (app caddr a)
               (app cons (app deriv (app caddr a)) (app nil)))))
            (app nil))))
         (app nil))))
      <-))))
  (env ()))
	'((con
   cons
   (λ (a)
     (-> (app cons '/ (app cons (app deriv a) (app cons a (app nil)))) <-)))
  (env ()))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app nil))
    (ran
     cons
     ('b)
     ()
     (ran
      cons
      ('*)
      ()
      (ran
       cons
       ()
       ((app cons 5 (app nil)))
       (ran
        cons
        ((app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))))
        ()
        (ran
         cons
         ((app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))))
         ()
         (ran
          cons
          ('+)
          ()
          (ran
           deriv
           ()
           ()
           (let-bod
            letrec*
            ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
             (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
             (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
             (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
             (map
              (λ (map-f map-l)
                (match
                 map-l
                 ((cons map-c map-d)
                  (app cons (app map-f map-c) (app map map-f map-d)))
                 ((nil) (app nil)))))
             (pair?
              (λ (pair?-v)
                (match
                 pair?-v
                 ((cons pair?-c pair?-d) (app #t))
                 (_ (app #f)))))
             (deriv
              (λ (a)
                (match
                 (app not (app pair? a))
                 ((#f)
                  (match
                   (app eq? (app car a) '+)
                   ((#f)
                    (match
                     (app eq? (app car a) '-)
                     ((#f)
                      (match
                       (app eq? (app car a) '*)
                       ((#f)
                        (match
                         (app eq? (app car a) '/)
                         ((#f)
                          (app
                           error
                           (app #f)
                           "No derivation method available"))
                         (_
                          (app
                           cons
                           '-
                           (app
                            cons
                            (app
                             cons
                             '/
                             (app
                              cons
                              (app deriv (app cadr a))
                              (app cons (app caddr a) (app nil))))
                            (app
                             cons
                             (app
                              cons
                              '/
                              (app
                               cons
                               (app cadr a)
                               (app
                                cons
                                (app
                                 cons
                                 '*
                                 (app
                                  cons
                                  (app caddr a)
                                  (app
                                   cons
                                   (app caddr a)
                                   (app
                                    cons
                                    (app deriv (app caddr a))
                                    (app nil)))))
                                (app nil))))
                             (app nil)))))))
                       (_
                        (app
                         cons
                         '*
                         (app
                          cons
                          a
                          (app
                           cons
                           (app
                            cons
                            '+
                            (app
                             map
                             (λ (a)
                               (app
                                cons
                                '/
                                (app
                                 cons
                                 (app deriv a)
                                 (app cons a (app nil)))))
                             (app cdr a)))
                           (app nil)))))))
                     (_ (app cons '- (app map deriv (app cdr a))))))
                   (_ (app cons '+ (app map deriv (app cdr a))))))
                 (_ (match (app eq? a 'x) ((#f) 0) (_ 1)))))))
            (lettypes-bod ((cons car cdr) (nil)) (top)))))))))))
   quote
   x)
  con
  (env ()))
clos/con:
	'((app cons (-> 'x <-) (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app nil))
    (ran
     cons
     ('x)
     ()
     (ran
      cons
      ('a)
      ()
      (ran
       cons
       ('*)
       ()
       (ran
        cons
        ()
        ((app
          cons
          (app cons '* (app cons 'b (app cons 'x (app nil))))
          (app cons 5 (app nil))))
        (ran
         cons
         ((app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))))
         ()
         (ran
          cons
          ('+)
          ()
          (ran
           deriv
           ()
           ()
           (let-bod
            letrec*
            ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
             (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
             (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
             (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
             (map
              (λ (map-f map-l)
                (match
                 map-l
                 ((cons map-c map-d)
                  (app cons (app map-f map-c) (app map map-f map-d)))
                 ((nil) (app nil)))))
             (pair?
              (λ (pair?-v)
                (match
                 pair?-v
                 ((cons pair?-c pair?-d) (app #t))
                 (_ (app #f)))))
             (deriv
              (λ (a)
                (match
                 (app not (app pair? a))
                 ((#f)
                  (match
                   (app eq? (app car a) '+)
                   ((#f)
                    (match
                     (app eq? (app car a) '-)
                     ((#f)
                      (match
                       (app eq? (app car a) '*)
                       ((#f)
                        (match
                         (app eq? (app car a) '/)
                         ((#f)
                          (app
                           error
                           (app #f)
                           "No derivation method available"))
                         (_
                          (app
                           cons
                           '-
                           (app
                            cons
                            (app
                             cons
                             '/
                             (app
                              cons
                              (app deriv (app cadr a))
                              (app cons (app caddr a) (app nil))))
                            (app
                             cons
                             (app
                              cons
                              '/
                              (app
                               cons
                               (app cadr a)
                               (app
                                cons
                                (app
                                 cons
                                 '*
                                 (app
                                  cons
                                  (app caddr a)
                                  (app
                                   cons
                                   (app caddr a)
                                   (app
                                    cons
                                    (app deriv (app caddr a))
                                    (app nil)))))
                                (app nil))))
                             (app nil)))))))
                       (_
                        (app
                         cons
                         '*
                         (app
                          cons
                          a
                          (app
                           cons
                           (app
                            cons
                            '+
                            (app
                             map
                             (λ (a)
                               (app
                                cons
                                '/
                                (app
                                 cons
                                 (app deriv a)
                                 (app cons a (app nil)))))
                             (app cdr a)))
                           (app nil)))))))
                     (_ (app cons '- (app map deriv (app cdr a))))))
                   (_ (app cons '+ (app map deriv (app cdr a))))))
                 (_ (match (app eq? a 'x) ((#f) 0) (_ 1)))))))
            (lettypes-bod ((cons car cdr) (nil)) (top)))))))))))
   quote
   x)
  con
  (env ()))
clos/con:
	'((app cons (-> 'x <-) (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app nil))
    (ran
     cons
     ('x)
     ()
     (ran
      cons
      (3)
      ()
      (ran
       cons
       ('*)
       ()
       (ran
        cons
        ()
        ((app
          cons
          (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
          (app
           cons
           (app cons '* (app cons 'b (app cons 'x (app nil))))
           (app cons 5 (app nil)))))
        (ran
         cons
         ('+)
         ()
         (ran
          deriv
          ()
          ()
          (let-bod
           letrec*
           ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
            (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
            (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
            (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
            (map
             (λ (map-f map-l)
               (match
                map-l
                ((cons map-c map-d)
                 (app cons (app map-f map-c) (app map map-f map-d)))
                ((nil) (app nil)))))
            (pair?
             (λ (pair?-v)
               (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
            (deriv
             (λ (a)
               (match
                (app not (app pair? a))
                ((#f)
                 (match
                  (app eq? (app car a) '+)
                  ((#f)
                   (match
                    (app eq? (app car a) '-)
                    ((#f)
                     (match
                      (app eq? (app car a) '*)
                      ((#f)
                       (match
                        (app eq? (app car a) '/)
                        ((#f)
                         (app error (app #f) "No derivation method available"))
                        (_
                         (app
                          cons
                          '-
                          (app
                           cons
                           (app
                            cons
                            '/
                            (app
                             cons
                             (app deriv (app cadr a))
                             (app cons (app caddr a) (app nil))))
                           (app
                            cons
                            (app
                             cons
                             '/
                             (app
                              cons
                              (app cadr a)
                              (app
                               cons
                               (app
                                cons
                                '*
                                (app
                                 cons
                                 (app caddr a)
                                 (app
                                  cons
                                  (app caddr a)
                                  (app
                                   cons
                                   (app deriv (app caddr a))
                                   (app nil)))))
                               (app nil))))
                            (app nil)))))))
                      (_
                       (app
                        cons
                        '*
                        (app
                         cons
                         a
                         (app
                          cons
                          (app
                           cons
                           '+
                           (app
                            map
                            (λ (a)
                              (app
                               cons
                               '/
                               (app
                                cons
                                (app deriv a)
                                (app cons a (app nil)))))
                            (app cdr a)))
                          (app nil)))))))
                    (_ (app cons '- (app map deriv (app cdr a))))))
                  (_ (app cons '+ (app map deriv (app cdr a))))))
                (_ (match (app eq? a 'x) ((#f) 0) (_ 1)))))))
           (lettypes-bod ((cons car cdr) (nil)) (top))))))))))
   quote
   x)
  con
  (env ()))
clos/con:
	'((app cons (-> 'x <-) (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app nil))
    (ran
     cons
     ((app
       cons
       '/
       (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil)))))
     ()
     (ran
      cons
      ('-)
      ()
      (match-clause
       _
       (app eq? (app car a) '/)
       (((#f) (app error (app #f) "No derivation method available")))
       ()
       (match-clause
        (#f)
        (app eq? (app car a) '*)
        ()
        ((_
          (app
           cons
           '*
           (app
            cons
            a
            (app
             cons
             (app
              cons
              '+
              (app
               map
               (λ (a)
                 (app cons '/ (app cons (app deriv a) (app cons a (app nil)))))
               (app cdr a)))
             (app nil))))))
        (match-clause
         (#f)
         (app eq? (app car a) '-)
         ()
         ((_ (app cons '- (app map deriv (app cdr a)))))
         (match-clause
          (#f)
          (app eq? (app car a) '+)
          ()
          ((_ (app cons '+ (app map deriv (app cdr a)))))
          (match-clause
           (#f)
           (app not (app pair? a))
           ()
           ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
           (bod
            (a)
            (bin
             letrec*
             deriv
             (app
              deriv
              (app
               cons
               '+
               (app
                cons
                (app
                 cons
                 '*
                 (app cons 3 (app cons 'x (app cons 'x (app nil)))))
                (app
                 cons
                 (app
                  cons
                  '*
                  (app cons 'a (app cons 'x (app cons 'x (app nil)))))
                 (app
                  cons
                  (app cons '* (app cons 'b (app cons 'x (app nil))))
                  (app cons 5 (app nil)))))))
             ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
              (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
              (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
              (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
              (map
               (λ (map-f map-l)
                 (match
                  map-l
                  ((cons map-c map-d)
                   (app cons (app map-f map-c) (app map map-f map-d)))
                  ((nil) (app nil)))))
              (pair?
               (λ (pair?-v)
                 (match
                  pair?-v
                  ((cons pair?-c pair?-d) (app #t))
                  (_ (app #f))))))
             ()
             (lettypes-bod ((cons car cdr) (nil)) (top))))))))))))
   app
   cons
   '/
   (app
    cons
    (app cadr a)
    (app
     cons
     (app
      cons
      '*
      (app
       cons
       (app caddr a)
       (app
        cons
        (app caddr a)
        (app cons (app deriv (app caddr a)) (app nil)))))
     (app nil))))
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
      '/
      (app
       cons
       (app cadr a)
       (app
        cons
        (app
         cons
         '*
         (app
          cons
          (app caddr a)
          (app
           cons
           (app caddr a)
           (app cons (app deriv (app caddr a)) (app nil)))))
        (app nil))))
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
     ((app caddr a))
     ()
     (ran
      cons
      ((app caddr a))
      ()
      (ran
       cons
       ('*)
       ()
       (ran
        cons
        ()
        ((app nil))
        (ran
         cons
         ((app cadr a))
         ()
         (ran
          cons
          ('/)
          ()
          (ran
           cons
           ()
           ((app nil))
           (ran
            cons
            ((app
              cons
              '/
              (app
               cons
               (app deriv (app cadr a))
               (app cons (app caddr a) (app nil)))))
            ()
            (ran
             cons
             ('-)
             ()
             (match-clause
              _
              (app eq? (app car a) '/)
              (((#f) (app error (app #f) "No derivation method available")))
              ()
              (match-clause
               (#f)
               (app eq? (app car a) '*)
               ()
               ((_
                 (app
                  cons
                  '*
                  (app
                   cons
                   a
                   (app
                    cons
                    (app
                     cons
                     '+
                     (app
                      map
                      (λ (a)
                        (app
                         cons
                         '/
                         (app cons (app deriv a) (app cons a (app nil)))))
                      (app cdr a)))
                    (app nil))))))
               (match-clause
                (#f)
                (app eq? (app car a) '-)
                ()
                ((_ (app cons '- (app map deriv (app cdr a)))))
                (match-clause
                 (#f)
                 (app eq? (app car a) '+)
                 ()
                 ((_ (app cons '+ (app map deriv (app cdr a)))))
                 (match-clause
                  (#f)
                  (app not (app pair? a))
                  ()
                  ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
                  (bod
                   (a)
                   (bin
                    letrec*
                    deriv
                    (app
                     deriv
                     (app
                      cons
                      '+
                      (app
                       cons
                       (app
                        cons
                        '*
                        (app cons 3 (app cons 'x (app cons 'x (app nil)))))
                       (app
                        cons
                        (app
                         cons
                         '*
                         (app cons 'a (app cons 'x (app cons 'x (app nil)))))
                        (app
                         cons
                         (app cons '* (app cons 'b (app cons 'x (app nil))))
                         (app cons 5 (app nil)))))))
                    ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
                     (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
                     (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
                     (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
                     (map
                      (λ (map-f map-l)
                        (match
                         map-l
                         ((cons map-c map-d)
                          (app cons (app map-f map-c) (app map map-f map-d)))
                         ((nil) (app nil)))))
                     (pair?
                      (λ (pair?-v)
                        (match
                         pair?-v
                         ((cons pair?-c pair?-d) (app #t))
                         (_ (app #f))))))
                    ()
                    (lettypes-bod
                     ((cons car cdr) (nil))
                     (top)))))))))))))))))))
   app
   deriv
   (app caddr a))
  con
  (env ()))
clos/con:
	'((con
   cons
   (match
    (app eq? (app car a) '*)
    (#f)
    (_
     (->
      (app
       cons
       '*
       (app
        cons
        a
        (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
      <-))))
  (env ()))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env ()))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ()))
	'((con
   cons
   (match
    (app eq? (app car a) '/)
    (#f)
    (_
     (->
      (app
       cons
       '-
       (app
        cons
        (app
         cons
         '/
         (app
          cons
          (app deriv (app cadr a))
          (app cons (app caddr a) (app nil))))
        (app
         cons
         (app
          cons
          '/
          (app
           cons
           (app cadr a)
           (app
            cons
            (app
             cons
             '*
             (app
              cons
              (app caddr a)
              (app
               cons
               (app caddr a)
               (app cons (app deriv (app caddr a)) (app nil)))))
            (app nil))))
         (app nil))))
      <-))))
  (env ()))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app nil))
    (ran
     cons
     ((app cadr a))
     ()
     (ran
      cons
      ('/)
      ()
      (ran
       cons
       ()
       ((app nil))
       (ran
        cons
        ((app
          cons
          '/
          (app
           cons
           (app deriv (app cadr a))
           (app cons (app caddr a) (app nil)))))
        ()
        (ran
         cons
         ('-)
         ()
         (match-clause
          _
          (app eq? (app car a) '/)
          (((#f) (app error (app #f) "No derivation method available")))
          ()
          (match-clause
           (#f)
           (app eq? (app car a) '*)
           ()
           ((_
             (app
              cons
              '*
              (app
               cons
               a
               (app
                cons
                (app
                 cons
                 '+
                 (app
                  map
                  (λ (a)
                    (app
                     cons
                     '/
                     (app cons (app deriv a) (app cons a (app nil)))))
                  (app cdr a)))
                (app nil))))))
           (match-clause
            (#f)
            (app eq? (app car a) '-)
            ()
            ((_ (app cons '- (app map deriv (app cdr a)))))
            (match-clause
             (#f)
             (app eq? (app car a) '+)
             ()
             ((_ (app cons '+ (app map deriv (app cdr a)))))
             (match-clause
              (#f)
              (app not (app pair? a))
              ()
              ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
              (bod
               (a)
               (bin
                letrec*
                deriv
                (app
                 deriv
                 (app
                  cons
                  '+
                  (app
                   cons
                   (app
                    cons
                    '*
                    (app cons 3 (app cons 'x (app cons 'x (app nil)))))
                   (app
                    cons
                    (app
                     cons
                     '*
                     (app cons 'a (app cons 'x (app cons 'x (app nil)))))
                    (app
                     cons
                     (app cons '* (app cons 'b (app cons 'x (app nil))))
                     (app cons 5 (app nil)))))))
                ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
                 (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
                 (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
                 (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
                 (map
                  (λ (map-f map-l)
                    (match
                     map-l
                     ((cons map-c map-d)
                      (app cons (app map-f map-c) (app map map-f map-d)))
                     ((nil) (app nil)))))
                 (pair?
                  (λ (pair?-v)
                    (match
                     pair?-v
                     ((cons pair?-c pair?-d) (app #t))
                     (_ (app #f))))))
                ()
                (lettypes-bod ((cons car cdr) (nil)) (top)))))))))))))))
   app
   cons
   '*
   (app
    cons
    (app caddr a)
    (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))))
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
      '*
      (app
       cons
       (app caddr a)
       (app
        cons
        (app caddr a)
        (app cons (app deriv (app caddr a)) (app nil)))))
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
     ((app cons '* (app cons 'b (app cons 'x (app nil)))))
     ()
     (ran
      cons
      ((app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))))
      ()
      (ran
       cons
       ((app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))))
       ()
       (ran
        cons
        ('+)
        ()
        (ran
         deriv
         ()
         ()
         (let-bod
          letrec*
          ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
           (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
           (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
           (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
           (map
            (λ (map-f map-l)
              (match
               map-l
               ((cons map-c map-d)
                (app cons (app map-f map-c) (app map map-f map-d)))
               ((nil) (app nil)))))
           (pair?
            (λ (pair?-v)
              (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
           (deriv
            (λ (a)
              (match
               (app not (app pair? a))
               ((#f)
                (match
                 (app eq? (app car a) '+)
                 ((#f)
                  (match
                   (app eq? (app car a) '-)
                   ((#f)
                    (match
                     (app eq? (app car a) '*)
                     ((#f)
                      (match
                       (app eq? (app car a) '/)
                       ((#f)
                        (app error (app #f) "No derivation method available"))
                       (_
                        (app
                         cons
                         '-
                         (app
                          cons
                          (app
                           cons
                           '/
                           (app
                            cons
                            (app deriv (app cadr a))
                            (app cons (app caddr a) (app nil))))
                          (app
                           cons
                           (app
                            cons
                            '/
                            (app
                             cons
                             (app cadr a)
                             (app
                              cons
                              (app
                               cons
                               '*
                               (app
                                cons
                                (app caddr a)
                                (app
                                 cons
                                 (app caddr a)
                                 (app
                                  cons
                                  (app deriv (app caddr a))
                                  (app nil)))))
                              (app nil))))
                           (app nil)))))))
                     (_
                      (app
                       cons
                       '*
                       (app
                        cons
                        a
                        (app
                         cons
                         (app
                          cons
                          '+
                          (app
                           map
                           (λ (a)
                             (app
                              cons
                              '/
                              (app cons (app deriv a) (app cons a (app nil)))))
                           (app cdr a)))
                         (app nil)))))))
                   (_ (app cons '- (app map deriv (app cdr a))))))
                 (_ (app cons '+ (app map deriv (app cdr a))))))
               (_ (match (app eq? a 'x) ((#f) 0) (_ 1)))))))
          (lettypes-bod ((cons car cdr) (nil)) (top)))))))))
   .
   5)
  con
  (env ()))
clos/con: ⊥
literals: '(5 ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app nil))
    (ran
     cons
     ((app deriv (app cadr a)))
     ()
     (ran
      cons
      ('/)
      ()
      (ran
       cons
       ()
       ((app
         cons
         (app
          cons
          '/
          (app
           cons
           (app cadr a)
           (app
            cons
            (app
             cons
             '*
             (app
              cons
              (app caddr a)
              (app
               cons
               (app caddr a)
               (app cons (app deriv (app caddr a)) (app nil)))))
            (app nil))))
         (app nil)))
       (ran
        cons
        ('-)
        ()
        (match-clause
         _
         (app eq? (app car a) '/)
         (((#f) (app error (app #f) "No derivation method available")))
         ()
         (match-clause
          (#f)
          (app eq? (app car a) '*)
          ()
          ((_
            (app
             cons
             '*
             (app
              cons
              a
              (app
               cons
               (app
                cons
                '+
                (app
                 map
                 (λ (a)
                   (app
                    cons
                    '/
                    (app cons (app deriv a) (app cons a (app nil)))))
                 (app cdr a)))
               (app nil))))))
          (match-clause
           (#f)
           (app eq? (app car a) '-)
           ()
           ((_ (app cons '- (app map deriv (app cdr a)))))
           (match-clause
            (#f)
            (app eq? (app car a) '+)
            ()
            ((_ (app cons '+ (app map deriv (app cdr a)))))
            (match-clause
             (#f)
             (app not (app pair? a))
             ()
             ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
             (bod
              (a)
              (bin
               letrec*
               deriv
               (app
                deriv
                (app
                 cons
                 '+
                 (app
                  cons
                  (app
                   cons
                   '*
                   (app cons 3 (app cons 'x (app cons 'x (app nil)))))
                  (app
                   cons
                   (app
                    cons
                    '*
                    (app cons 'a (app cons 'x (app cons 'x (app nil)))))
                   (app
                    cons
                    (app cons '* (app cons 'b (app cons 'x (app nil))))
                    (app cons 5 (app nil)))))))
               ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
                (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
                (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
                (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
                (map
                 (λ (map-f map-l)
                   (match
                    map-l
                    ((cons map-c map-d)
                     (app cons (app map-f map-c) (app map map-f map-d)))
                    ((nil) (app nil)))))
                (pair?
                 (λ (pair?-v)
                   (match
                    pair?-v
                    ((cons pair?-c pair?-d) (app #t))
                    (_ (app #f))))))
               ()
               (lettypes-bod ((cons car cdr) (nil)) (top))))))))))))))
   app
   caddr
   a)
  con
  (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app nil))
    (ran
     cons
     ((app deriv a))
     ()
     (ran
      cons
      ('/)
      ()
      (bod
       (a)
       (ran
        map
        ()
        ((app cdr a))
        (ran
         cons
         ('+)
         ()
         (ran
          cons
          ()
          ((app nil))
          (ran
           cons
           (a)
           ()
           (ran
            cons
            ('*)
            ()
            (match-clause
             _
             (app eq? (app car a) '*)
             (((#f)
               (match
                (app eq? (app car a) '/)
                ((#f) (app error (app #f) "No derivation method available"))
                (_
                 (app
                  cons
                  '-
                  (app
                   cons
                   (app
                    cons
                    '/
                    (app
                     cons
                     (app deriv (app cadr a))
                     (app cons (app caddr a) (app nil))))
                   (app
                    cons
                    (app
                     cons
                     '/
                     (app
                      cons
                      (app cadr a)
                      (app
                       cons
                       (app
                        cons
                        '*
                        (app
                         cons
                         (app caddr a)
                         (app
                          cons
                          (app caddr a)
                          (app cons (app deriv (app caddr a)) (app nil)))))
                       (app nil))))
                    (app nil))))))))
             ()
             (match-clause
              (#f)
              (app eq? (app car a) '-)
              ()
              ((_ (app cons '- (app map deriv (app cdr a)))))
              (match-clause
               (#f)
               (app eq? (app car a) '+)
               ()
               ((_ (app cons '+ (app map deriv (app cdr a)))))
               (match-clause
                (#f)
                (app not (app pair? a))
                ()
                ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
                (bod
                 (a)
                 (bin
                  letrec*
                  deriv
                  (app
                   deriv
                   (app
                    cons
                    '+
                    (app
                     cons
                     (app
                      cons
                      '*
                      (app cons 3 (app cons 'x (app cons 'x (app nil)))))
                     (app
                      cons
                      (app
                       cons
                       '*
                       (app cons 'a (app cons 'x (app cons 'x (app nil)))))
                      (app
                       cons
                       (app cons '* (app cons 'b (app cons 'x (app nil))))
                       (app cons 5 (app nil)))))))
                  ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
                   (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
                   (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
                   (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
                   (map
                    (λ (map-f map-l)
                      (match
                       map-l
                       ((cons map-c map-d)
                        (app cons (app map-f map-c) (app map map-f map-d)))
                       ((nil) (app nil)))))
                   (pair?
                    (λ (pair?-v)
                      (match
                       pair?-v
                       ((cons pair?-c pair?-d) (app #t))
                       (_ (app #f))))))
                  ()
                  (lettypes-bod ((cons car cdr) (nil)) (top)))))))))))))))))
   .
   a)
  con
  (env ()))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app nil))
    (ran
     cons
     (a)
     ()
     (ran
      cons
      ('*)
      ()
      (match-clause
       _
       (app eq? (app car a) '*)
       (((#f)
         (match
          (app eq? (app car a) '/)
          ((#f) (app error (app #f) "No derivation method available"))
          (_
           (app
            cons
            '-
            (app
             cons
             (app
              cons
              '/
              (app
               cons
               (app deriv (app cadr a))
               (app cons (app caddr a) (app nil))))
             (app
              cons
              (app
               cons
               '/
               (app
                cons
                (app cadr a)
                (app
                 cons
                 (app
                  cons
                  '*
                  (app
                   cons
                   (app caddr a)
                   (app
                    cons
                    (app caddr a)
                    (app cons (app deriv (app caddr a)) (app nil)))))
                 (app nil))))
              (app nil))))))))
       ()
       (match-clause
        (#f)
        (app eq? (app car a) '-)
        ()
        ((_ (app cons '- (app map deriv (app cdr a)))))
        (match-clause
         (#f)
         (app eq? (app car a) '+)
         ()
         ((_ (app cons '+ (app map deriv (app cdr a)))))
         (match-clause
          (#f)
          (app not (app pair? a))
          ()
          ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
          (bod
           (a)
           (bin
            letrec*
            deriv
            (app
             deriv
             (app
              cons
              '+
              (app
               cons
               (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
               (app
                cons
                (app
                 cons
                 '*
                 (app cons 'a (app cons 'x (app cons 'x (app nil)))))
                (app
                 cons
                 (app cons '* (app cons 'b (app cons 'x (app nil))))
                 (app cons 5 (app nil)))))))
            ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
             (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
             (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
             (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
             (map
              (λ (map-f map-l)
                (match
                 map-l
                 ((cons map-c map-d)
                  (app cons (app map-f map-c) (app map map-f map-d)))
                 ((nil) (app nil)))))
             (pair?
              (λ (pair?-v)
                (match
                 pair?-v
                 ((cons pair?-c pair?-d) (app #t))
                 (_ (app #f))))))
            ()
            (lettypes-bod ((cons car cdr) (nil)) (top)))))))))))
   app
   cons
   '+
   (app
    map
    (λ (a) (app cons '/ (app cons (app deriv a) (app cons a (app nil)))))
    (app cdr a)))
  con
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons '+ (app map (λ (a) ...) (app cdr a))) <-)
    (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    (3)
    ()
    (ran
     cons
     ('*)
     ()
     (ran
      cons
      ()
      ((app
        cons
        (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
        (app
         cons
         (app cons '* (app cons 'b (app cons 'x (app nil))))
         (app cons 5 (app nil)))))
      (ran
       cons
       ('+)
       ()
       (ran
        deriv
        ()
        ()
        (let-bod
         letrec*
         ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
          (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
          (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
          (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
          (map
           (λ (map-f map-l)
             (match
              map-l
              ((cons map-c map-d)
               (app cons (app map-f map-c) (app map map-f map-d)))
              ((nil) (app nil)))))
          (pair?
           (λ (pair?-v)
             (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
          (deriv
           (λ (a)
             (match
              (app not (app pair? a))
              ((#f)
               (match
                (app eq? (app car a) '+)
                ((#f)
                 (match
                  (app eq? (app car a) '-)
                  ((#f)
                   (match
                    (app eq? (app car a) '*)
                    ((#f)
                     (match
                      (app eq? (app car a) '/)
                      ((#f)
                       (app error (app #f) "No derivation method available"))
                      (_
                       (app
                        cons
                        '-
                        (app
                         cons
                         (app
                          cons
                          '/
                          (app
                           cons
                           (app deriv (app cadr a))
                           (app cons (app caddr a) (app nil))))
                         (app
                          cons
                          (app
                           cons
                           '/
                           (app
                            cons
                            (app cadr a)
                            (app
                             cons
                             (app
                              cons
                              '*
                              (app
                               cons
                               (app caddr a)
                               (app
                                cons
                                (app caddr a)
                                (app
                                 cons
                                 (app deriv (app caddr a))
                                 (app nil)))))
                             (app nil))))
                          (app nil)))))))
                    (_
                     (app
                      cons
                      '*
                      (app
                       cons
                       a
                       (app
                        cons
                        (app
                         cons
                         '+
                         (app
                          map
                          (λ (a)
                            (app
                             cons
                             '/
                             (app cons (app deriv a) (app cons a (app nil)))))
                          (app cdr a)))
                        (app nil)))))))
                  (_ (app cons '- (app map deriv (app cdr a))))))
                (_ (app cons '+ (app map deriv (app cdr a))))))
              (_ (match (app eq? a 'x) ((#f) 0) (_ 1)))))))
         (lettypes-bod ((cons car cdr) (nil)) (top))))))))
   app
   cons
   'x
   (app cons 'x (app nil)))
  con
  (env ()))
clos/con:
	'((con cons (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    (5)
    ()
    (ran
     cons
     ((app cons '* (app cons 'b (app cons 'x (app nil)))))
     ()
     (ran
      cons
      ((app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))))
      ()
      (ran
       cons
       ((app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))))
       ()
       (ran
        cons
        ('+)
        ()
        (ran
         deriv
         ()
         ()
         (let-bod
          letrec*
          ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
           (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
           (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
           (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
           (map
            (λ (map-f map-l)
              (match
               map-l
               ((cons map-c map-d)
                (app cons (app map-f map-c) (app map map-f map-d)))
               ((nil) (app nil)))))
           (pair?
            (λ (pair?-v)
              (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
           (deriv
            (λ (a)
              (match
               (app not (app pair? a))
               ((#f)
                (match
                 (app eq? (app car a) '+)
                 ((#f)
                  (match
                   (app eq? (app car a) '-)
                   ((#f)
                    (match
                     (app eq? (app car a) '*)
                     ((#f)
                      (match
                       (app eq? (app car a) '/)
                       ((#f)
                        (app error (app #f) "No derivation method available"))
                       (_
                        (app
                         cons
                         '-
                         (app
                          cons
                          (app
                           cons
                           '/
                           (app
                            cons
                            (app deriv (app cadr a))
                            (app cons (app caddr a) (app nil))))
                          (app
                           cons
                           (app
                            cons
                            '/
                            (app
                             cons
                             (app cadr a)
                             (app
                              cons
                              (app
                               cons
                               '*
                               (app
                                cons
                                (app caddr a)
                                (app
                                 cons
                                 (app caddr a)
                                 (app
                                  cons
                                  (app deriv (app caddr a))
                                  (app nil)))))
                              (app nil))))
                           (app nil)))))))
                     (_
                      (app
                       cons
                       '*
                       (app
                        cons
                        a
                        (app
                         cons
                         (app
                          cons
                          '+
                          (app
                           map
                           (λ (a)
                             (app
                              cons
                              '/
                              (app cons (app deriv a) (app cons a (app nil)))))
                           (app cdr a)))
                         (app nil)))))))
                   (_ (app cons '- (app map deriv (app cdr a))))))
                 (_ (app cons '+ (app map deriv (app cdr a))))))
               (_ (match (app eq? a 'x) ((#f) 0) (_ 1)))))))
          (lettypes-bod ((cons car cdr) (nil)) (top)))))))))
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
    (a)
    ()
    (ran
     cons
     ('*)
     ()
     (match-clause
      _
      (app eq? (app car a) '*)
      (((#f)
        (match
         (app eq? (app car a) '/)
         ((#f) (app error (app #f) "No derivation method available"))
         (_
          (app
           cons
           '-
           (app
            cons
            (app
             cons
             '/
             (app
              cons
              (app deriv (app cadr a))
              (app cons (app caddr a) (app nil))))
            (app
             cons
             (app
              cons
              '/
              (app
               cons
               (app cadr a)
               (app
                cons
                (app
                 cons
                 '*
                 (app
                  cons
                  (app caddr a)
                  (app
                   cons
                   (app caddr a)
                   (app cons (app deriv (app caddr a)) (app nil)))))
                (app nil))))
             (app nil))))))))
      ()
      (match-clause
       (#f)
       (app eq? (app car a) '-)
       ()
       ((_ (app cons '- (app map deriv (app cdr a)))))
       (match-clause
        (#f)
        (app eq? (app car a) '+)
        ()
        ((_ (app cons '+ (app map deriv (app cdr a)))))
        (match-clause
         (#f)
         (app not (app pair? a))
         ()
         ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
         (bod
          (a)
          (bin
           letrec*
           deriv
           (app
            deriv
            (app
             cons
             '+
             (app
              cons
              (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
              (app
               cons
               (app
                cons
                '*
                (app cons 'a (app cons 'x (app cons 'x (app nil)))))
               (app
                cons
                (app cons '* (app cons 'b (app cons 'x (app nil))))
                (app cons 5 (app nil)))))))
           ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
            (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
            (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
            (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
            (map
             (λ (map-f map-l)
               (match
                map-l
                ((cons map-c map-d)
                 (app cons (app map-f map-c) (app map map-f map-d)))
                ((nil) (app nil)))))
            (pair?
             (λ (pair?-v)
               (match
                pair?-v
                ((cons pair?-c pair?-d) (app #t))
                (_ (app #f))))))
           ()
           (lettypes-bod ((cons car cdr) (nil)) (top))))))))))
   app
   cons
   (app
    cons
    '+
    (app
     map
     (λ (a) (app cons '/ (app cons (app deriv a) (app cons a (app nil)))))
     (app cdr a)))
   (app nil))
  con
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    a
    (->
     (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))
     <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    cons
    (a)
    ()
    (ran
     cons
     ((app deriv a))
     ()
     (ran
      cons
      ('/)
      ()
      (bod
       (a)
       (ran
        map
        ()
        ((app cdr a))
        (ran
         cons
         ('+)
         ()
         (ran
          cons
          ()
          ((app nil))
          (ran
           cons
           (a)
           ()
           (ran
            cons
            ('*)
            ()
            (match-clause
             _
             (app eq? (app car a) '*)
             (((#f)
               (match
                (app eq? (app car a) '/)
                ((#f) (app error (app #f) "No derivation method available"))
                (_
                 (app
                  cons
                  '-
                  (app
                   cons
                   (app
                    cons
                    '/
                    (app
                     cons
                     (app deriv (app cadr a))
                     (app cons (app caddr a) (app nil))))
                   (app
                    cons
                    (app
                     cons
                     '/
                     (app
                      cons
                      (app cadr a)
                      (app
                       cons
                       (app
                        cons
                        '*
                        (app
                         cons
                         (app caddr a)
                         (app
                          cons
                          (app caddr a)
                          (app cons (app deriv (app caddr a)) (app nil)))))
                       (app nil))))
                    (app nil))))))))
             ()
             (match-clause
              (#f)
              (app eq? (app car a) '-)
              ()
              ((_ (app cons '- (app map deriv (app cdr a)))))
              (match-clause
               (#f)
               (app eq? (app car a) '+)
               ()
               ((_ (app cons '+ (app map deriv (app cdr a)))))
               (match-clause
                (#f)
                (app not (app pair? a))
                ()
                ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
                (bod
                 (a)
                 (bin
                  letrec*
                  deriv
                  (app
                   deriv
                   (app
                    cons
                    '+
                    (app
                     cons
                     (app
                      cons
                      '*
                      (app cons 3 (app cons 'x (app cons 'x (app nil)))))
                     (app
                      cons
                      (app
                       cons
                       '*
                       (app cons 'a (app cons 'x (app cons 'x (app nil)))))
                      (app
                       cons
                       (app cons '* (app cons 'b (app cons 'x (app nil))))
                       (app cons 5 (app nil)))))))
                  ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
                   (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
                   (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
                   (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
                   (map
                    (λ (map-f map-l)
                      (match
                       map-l
                       ((cons map-c map-d)
                        (app cons (app map-f map-c) (app map map-f map-d)))
                       ((nil) (app nil)))))
                   (pair?
                    (λ (pair?-v)
                      (match
                       pair?-v
                       ((cons pair?-c pair?-d) (app #t))
                       (_ (app #f))))))
                  ()
                  (lettypes-bod ((cons car cdr) (nil)) (top)))))))))))))))))
   app
   nil)
  con
  (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  ((ran
    error
    ((app #f))
    ()
    (match-clause
     (#f)
     (app eq? (app car a) '/)
     ()
     ((_
       (app
        cons
        '-
        (app
         cons
         (app
          cons
          '/
          (app
           cons
           (app deriv (app cadr a))
           (app cons (app caddr a) (app nil))))
         (app
          cons
          (app
           cons
           '/
           (app
            cons
            (app cadr a)
            (app
             cons
             (app
              cons
              '*
              (app
               cons
               (app caddr a)
               (app
                cons
                (app caddr a)
                (app cons (app deriv (app caddr a)) (app nil)))))
             (app nil))))
          (app nil))))))
     (match-clause
      (#f)
      (app eq? (app car a) '*)
      ()
      ((_
        (app
         cons
         '*
         (app
          cons
          a
          (app
           cons
           (app
            cons
            '+
            (app
             map
             (λ (a)
               (app cons '/ (app cons (app deriv a) (app cons a (app nil)))))
             (app cdr a)))
           (app nil))))))
      (match-clause
       (#f)
       (app eq? (app car a) '-)
       ()
       ((_ (app cons '- (app map deriv (app cdr a)))))
       (match-clause
        (#f)
        (app eq? (app car a) '+)
        ()
        ((_ (app cons '+ (app map deriv (app cdr a)))))
        (match-clause
         (#f)
         (app not (app pair? a))
         ()
         ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
         (bod
          (a)
          (bin
           letrec*
           deriv
           (app
            deriv
            (app
             cons
             '+
             (app
              cons
              (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
              (app
               cons
               (app
                cons
                '*
                (app cons 'a (app cons 'x (app cons 'x (app nil)))))
               (app
                cons
                (app cons '* (app cons 'b (app cons 'x (app nil))))
                (app cons 5 (app nil)))))))
           ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
            (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
            (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
            (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
            (map
             (λ (map-f map-l)
               (match
                map-l
                ((cons map-c map-d)
                 (app cons (app map-f map-c) (app map map-f map-d)))
                ((nil) (app nil)))))
            (pair?
             (λ (pair?-v)
               (match
                pair?-v
                ((cons pair?-c pair?-d) (app #t))
                (_ (app #f))))))
           ()
           (lettypes-bod ((cons car cdr) (nil)) (top))))))))))
   .
   "No derivation method available")
  con
  (env ()))
clos/con: ⊥
literals: '(⊥ ⊥ ⊥ "No derivation method available")

'(store:
  ((ran
    error
    ()
    ("No derivation method available")
    (match-clause
     (#f)
     (app eq? (app car a) '/)
     ()
     ((_
       (app
        cons
        '-
        (app
         cons
         (app
          cons
          '/
          (app
           cons
           (app deriv (app cadr a))
           (app cons (app caddr a) (app nil))))
         (app
          cons
          (app
           cons
           '/
           (app
            cons
            (app cadr a)
            (app
             cons
             (app
              cons
              '*
              (app
               cons
               (app caddr a)
               (app
                cons
                (app caddr a)
                (app cons (app deriv (app caddr a)) (app nil)))))
             (app nil))))
          (app nil))))))
     (match-clause
      (#f)
      (app eq? (app car a) '*)
      ()
      ((_
        (app
         cons
         '*
         (app
          cons
          a
          (app
           cons
           (app
            cons
            '+
            (app
             map
             (λ (a)
               (app cons '/ (app cons (app deriv a) (app cons a (app nil)))))
             (app cdr a)))
           (app nil))))))
      (match-clause
       (#f)
       (app eq? (app car a) '-)
       ()
       ((_ (app cons '- (app map deriv (app cdr a)))))
       (match-clause
        (#f)
        (app eq? (app car a) '+)
        ()
        ((_ (app cons '+ (app map deriv (app cdr a)))))
        (match-clause
         (#f)
         (app not (app pair? a))
         ()
         ((_ (match (app eq? a 'x) ((#f) 0) (_ 1))))
         (bod
          (a)
          (bin
           letrec*
           deriv
           (app
            deriv
            (app
             cons
             '+
             (app
              cons
              (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
              (app
               cons
               (app
                cons
                '*
                (app cons 'a (app cons 'x (app cons 'x (app nil)))))
               (app
                cons
                (app cons '* (app cons 'b (app cons 'x (app nil))))
                (app cons 5 (app nil)))))))
           ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
            (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
            (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
            (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
            (map
             (λ (map-f map-l)
               (match
                map-l
                ((cons map-c map-d)
                 (app cons (app map-f map-c) (app map map-f map-d)))
                ((nil) (app nil)))))
            (pair?
             (λ (pair?-v)
               (match
                pair?-v
                ((cons pair?-c pair?-d) (app #t))
                (_ (app #f))))))
           ()
           (lettypes-bod ((cons car cdr) (nil)) (top))))))))))
   app
   #f)
  con
  (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  _
  (match pair?-v (cons pair?-c pair?-d) (_ (-> (app #f) <-)))
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(store:
  a
  (λ (a) (-> (app cons '/ (app cons (app deriv a) (app cons a (app nil)))) <-))
  (env ()))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store:
  caddr
  (letrec* (... cadr (caddr (-> (λ (cadr-v) ...) <-)) map ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cadr (caddr (-> (λ (cadr-v) ...) <-)) map ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  cadr
  (letrec* (... cdr (cadr (-> (λ (cadr-v) ...) <-)) caddr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cdr (cadr (-> (λ (cadr-v) ...) <-)) caddr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  cadr-v
  (λ (cadr-v) (-> (app car (app cdr (app cdr cadr-v))) <-))
  (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((con
   cons
   (app
    deriv
    (->
     (app
      cons
      '+
      (app
       cons
       (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
        (app
         cons
         (app cons '* (app cons 'b (app cons 'x (app nil))))
         (app cons 5 (app nil))))))
     <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store:
  car
  (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  car
  (λ (cadr-v) (-> (app car (app cdr (app cdr cadr-v))) <-))
  (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  cdr
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  cdr
  (λ (cadr-v) (-> (app car (app cdr (app cdr cadr-v))) <-))
  (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  deriv
  (letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...)
  (env ()))
clos/con:
	'((letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  deriv
  (λ (a) (-> (app cons '/ (app cons (app deriv a) (app cons a (app nil)))) <-))
  (env ()))
clos/con:
	'((letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  map
  (letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) pair? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) pair? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  map-c
  (match
   map-l
   ((cons map-c map-d)
    (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
   (nil))
  (env ()))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store:
  map-d
  (match
   map-l
   ((cons map-c map-d)
    (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
   (nil))
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
    (->
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 'b (app cons 'x (app nil))))
    (-> (app cons 5 (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (->
     (app
      cons
      (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'b (app cons 'x (app nil))))
       (app cons 5 (app nil))))
     <-)))
  (env ()))
	'((con cons (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'b (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  pair?
  (letrec* (... map (pair? (-> (λ (pair?-v) ...) <-)) deriv ...) ...)
  (env ()))
clos/con:
	'((letrec* (... map (pair? (-> (λ (pair?-v) ...) <-)) deriv ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  pair?-c
  (match pair?-v ((cons pair?-c pair?-d) (-> (app #t) <-)) _)
  (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  pair?-d
  (match pair?-v ((cons pair?-c pair?-d) (-> (app #t) <-)) _)
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    '+
    (->
     (app
      cons
      (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'b (app cons 'x (app nil))))
        (app cons 5 (app nil)))))
     <-)))
  (env ()))
	'((con
   cons
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con cons (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: a (λ (a) (-> (match (app not (app pair? a)) ...) <-)) (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((con
   cons
   (app
    deriv
    (->
     (app
      cons
      '+
      (app
       cons
       (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
        (app
         cons
         (app cons '* (app cons 'b (app cons 'x (app nil))))
         (app cons 5 (app nil))))))
     <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: caddr (λ (a) (-> (match (app not (app pair? a)) ...) <-)) (env ()))
clos/con:
	'((letrec* (... cadr (caddr (-> (λ (cadr-v) ...) <-)) map ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: cadr (λ (a) (-> (match (app not (app pair? a)) ...) <-)) (env ()))
clos/con:
	'((letrec* (... cdr (cadr (-> (λ (cadr-v) ...) <-)) caddr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: cadr-v (λ (cadr-v) (-> (app car (app cdr cadr-v)) <-)) (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((con
   cons
   (app
    deriv
    (->
     (app
      cons
      '+
      (app
       cons
       (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
        (app
         cons
         (app cons '* (app cons 'b (app cons 'x (app nil))))
         (app cons 5 (app nil))))))
     <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: car (λ (a) (-> (match (app not (app pair? a)) ...) <-)) (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: car (λ (cadr-v) (-> (app car (app cdr cadr-v)) <-)) (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: car-c (match car-v ((cons car-c car-d) (-> car-c <-))) (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: car-d (match car-v ((cons car-c car-d) (-> car-c <-))) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    '+
    (->
     (app
      cons
      (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'b (app cons 'x (app nil))))
        (app cons 5 (app nil)))))
     <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
    (->
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 'b (app cons 'x (app nil))))
    (-> (app cons 5 (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (->
     (app
      cons
      (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'b (app cons 'x (app nil))))
       (app cons 5 (app nil))))
     <-)))
  (env ()))
	'((con
   cons
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con cons (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'b (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: car-v (λ (car-v) (-> (match car-v ...) <-)) (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    '+
    (->
     (app
      cons
      (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'b (app cons 'x (app nil))))
        (app cons 5 (app nil)))))
     <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
    (->
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 'b (app cons 'x (app nil))))
    (-> (app cons 5 (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (->
     (app
      cons
      (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'b (app cons 'x (app nil))))
       (app cons 5 (app nil))))
     <-)))
  (env ()))
	'((con
   cons
   (app
    deriv
    (->
     (app
      cons
      '+
      (app
       cons
       (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
        (app
         cons
         (app cons '* (app cons 'b (app cons 'x (app nil))))
         (app cons 5 (app nil))))))
     <-)))
  (env ()))
	'((con
   cons
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con cons (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'b (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: cdr (λ (a) (-> (match (app not (app pair? a)) ...) <-)) (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: cdr (λ (cadr-v) (-> (app car (app cdr cadr-v)) <-)) (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: cdr-c (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-))) (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: cdr-d (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-))) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    '+
    (->
     (app
      cons
      (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'b (app cons 'x (app nil))))
        (app cons 5 (app nil)))))
     <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
    (->
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 'b (app cons 'x (app nil))))
    (-> (app cons 5 (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (->
     (app
      cons
      (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'b (app cons 'x (app nil))))
       (app cons 5 (app nil))))
     <-)))
  (env ()))
	'((con
   cons
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con cons (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'b (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: cdr-v (λ (cdr-v) (-> (match cdr-v ...) <-)) (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    '+
    (->
     (app
      cons
      (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'b (app cons 'x (app nil))))
        (app cons 5 (app nil)))))
     <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
    (->
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 'b (app cons 'x (app nil))))
    (-> (app cons 5 (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (->
     (app
      cons
      (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'b (app cons 'x (app nil))))
       (app cons 5 (app nil))))
     <-)))
  (env ()))
	'((con
   cons
   (app
    deriv
    (->
     (app
      cons
      '+
      (app
       cons
       (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
        (app
         cons
         (app cons '* (app cons 'b (app cons 'x (app nil))))
         (app cons 5 (app nil))))))
     <-)))
  (env ()))
	'((con
   cons
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con cons (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'b (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: deriv (λ (a) (-> (match (app not (app pair? a)) ...) <-)) (env ()))
clos/con:
	'((letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: map (λ (a) (-> (match (app not (app pair? a)) ...) <-)) (env ()))
clos/con:
	'((letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) pair? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: map (λ (map-f map-l) (-> (match map-l ...) <-)) (env ()))
clos/con:
	'((letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) pair? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: map-f (λ (map-f map-l) (-> (match map-l ...) <-)) (env ()))
clos/con:
	'((app map (-> (λ (a) ...) <-) (app cdr a)) (env ()))
	'((letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: map-l (λ (map-f map-l) (-> (match map-l ...) <-)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    '+
    (->
     (app
      cons
      (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'b (app cons 'x (app nil))))
        (app cons 5 (app nil)))))
     <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
    (->
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 'b (app cons 'x (app nil))))
    (-> (app cons 5 (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (->
     (app
      cons
      (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'b (app cons 'x (app nil))))
       (app cons 5 (app nil))))
     <-)))
  (env ()))
	'((con
   cons
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con cons (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'b (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: pair? (λ (a) (-> (match (app not (app pair? a)) ...) <-)) (env ()))
clos/con:
	'((letrec* (... map (pair? (-> (λ (pair?-v) ...) <-)) deriv ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: pair?-v (λ (pair?-v) (-> (match pair?-v ...) <-)) (env ()))
clos/con:
	'((app
   cons
   (-> '+ <-)
   (app
    cons
    (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((app cons (-> 'x <-) (app nil)) (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil)))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil))))
  (env ()))
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil))))))
  (env ()))
	'((con
   cons
   (app
    deriv
    (->
     (app
      cons
      '+
      (app
       cons
       (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
        (app
         cons
         (app cons '* (app cons 'b (app cons 'x (app nil))))
         (app cons 5 (app nil))))))
     <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)
