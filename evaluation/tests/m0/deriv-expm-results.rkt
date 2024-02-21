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
  (match
   (app not (app pair? a))
   ((#f) (-> (match (app eq? (app car a) '+) ...) <-))
   _)
  (env (())))
clos/con:
	'((con
   cons
   (app
    cons
    (-> '* <-)
    (app
     cons
     a
     (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
   (app
    cons
    '*
    (->
     (app
      cons
      a
      (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil)))
     <-)))
  (env (())))
	'((con
   cons
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
  (env (())))
	'((con
   cons
   (app cons (-> '+ <-) (app map deriv (app cdr a)))
   (app cons '+ (-> (app map deriv (app cdr a)) <-)))
  (env (())))
	'((con
   cons
   (app cons (-> '- <-) (app map deriv (app cdr a)))
   (app cons '- (-> (app map deriv (app cdr a)) <-)))
  (env (())))
	'((con
   error
   (app error (-> (app #f) <-) "No derivation method available")
   (app error (app #f) (-> "No derivation method available" <-)))
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

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
  (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> cadr <-) a) (env (())))
clos/con:
	'((letrec* (... cdr (cadr (-> (λ (cadr-v) ...) <-)) caddr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> (app eq? (app car a) '/) <-) (#f) _) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app caddr (-> a <-)) (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (match map-l (cons map-c map-d) ((nil) (-> (app nil) <-))) (env (())))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> map <-) deriv (app cdr a)) (env (())))
clos/con:
	'((letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) pair? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> '+ <-) (app map deriv (app cdr a))) (env (())))
clos/con:
	'((app cons (-> '+ <-) (app map deriv (app cdr a))) (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (a) (-> (match (app not (app pair? a)) ...) <-)) (env (())))
clos/con:
	'((con
   cons
   (app
    cons
    (-> '* <-)
    (app
     cons
     a
     (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
   (app
    cons
    '*
    (->
     (app
      cons
      a
      (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil)))
     <-)))
  (env (())))
	'((con
   cons
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
  (env (())))
	'((con
   cons
   (app cons (-> '+ <-) (app map deriv (app cdr a)))
   (app cons '+ (-> (app map deriv (app cdr a)) <-)))
  (env (())))
	'((con
   cons
   (app cons (-> '- <-) (app map deriv (app cdr a)))
   (app cons '- (-> (app map deriv (app cdr a)) <-)))
  (env (())))
	'((con
   error
   (app error (-> (app #f) <-) "No derivation method available")
   (app error (app #f) (-> "No derivation method available" <-)))
  (env (())))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> cdr <-) a) (env (())))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app map deriv (-> (app cdr a) <-)) (env (())))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil))))
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
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil)))
   (app
    cons
    (app cons '* (app cons 'b (app cons 'x (app nil))))
    (-> (app cons 5 (app nil)) <-)))
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
      (app cons 5 (app nil)))))
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
   (app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil))))
   (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'b <-) (app cons 'x (app nil)))
   (app cons 'b (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'x <-) (app cons 'x (app nil)))
   (app cons 'x (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'x <-) (app cons 'x (app nil)))
   (app cons 'x (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 3 <-) (app cons 'x (app cons 'x (app nil))))
   (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 5 <-) (app nil)) (app cons 5 (-> (app nil) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) pair? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) pair? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> deriv <-) a) (env (() ())))
clos/con:
	'((letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app map (-> deriv <-) (app cdr a)) (env (())))
clos/con:
	'((letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> (app map-f map-c) <-) (app map map-f map-d)) (env (())))
clos/con:
	'((con
   cons
   (app
    cons
    (-> '* <-)
    (app
     cons
     a
     (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
   (app
    cons
    '*
    (->
     (app
      cons
      a
      (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil)))
     <-)))
  (env (())))
	'((con
   cons
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
  (env (())))
	'((con
   cons
   (app cons (-> '+ <-) (app map deriv (app cdr a)))
   (app cons '+ (-> (app map deriv (app cdr a)) <-)))
  (env (())))
	'((con
   cons
   (app cons (-> '- <-) (app map deriv (app cdr a)))
   (app cons '- (-> (app map deriv (app cdr a)) <-)))
  (env (())))
	'((con
   cons
   (app cons (-> '/ <-) (app cons (app deriv a) (app cons a (app nil))))
   (app cons '/ (-> (app cons (app deriv a) (app cons a (app nil))) <-)))
  (env (() ())))
	'((con
   error
   (app error (-> (app #f) <-) "No derivation method available")
   (app error (app #f) (-> "No derivation method available" <-)))
  (env (())))
literals: '(⊤ ⊥ ⊥ ⊥)

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
  (env (())))
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

'(query: (app cons (-> 5 <-) (app nil)) (env ()))
clos/con: ⊥
literals: '(5 ⊥ ⊥ ⊥)

'(query: (app caddr (-> a <-)) (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app map map-f (-> map-d <-)) (env (())))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil))))
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
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil)))
   (app
    cons
    (app cons '* (app cons 'b (app cons 'x (app nil))))
    (-> (app cons 5 (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'x <-) (app cons 'x (app nil)))
   (app cons 'x (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'x <-) (app cons 'x (app nil)))
   (app cons 'x (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 5 <-) (app nil)) (app cons 5 (-> (app nil) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> car <-) (app cdr (app cdr cadr-v))) (env (())))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   '/
   (->
    (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil)))
    <-))
  (env (())))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app deriv (app cadr a)) <-)
    (app cons (app caddr a) (app nil)))
   (app
    cons
    (app deriv (app cadr a))
    (-> (app cons (app caddr a) (app nil)) <-)))
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> (app deriv (app caddr a)) <-) (app nil)) (env (())))
clos/con:
	'((con
   cons
   (app
    cons
    (-> '* <-)
    (app
     cons
     a
     (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
   (app
    cons
    '*
    (->
     (app
      cons
      a
      (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil)))
     <-)))
  (env (())))
	'((con
   cons
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
  (env (())))
	'((con
   cons
   (app cons (-> '+ <-) (app map deriv (app cdr a)))
   (app cons '+ (-> (app map deriv (app cdr a)) <-)))
  (env (())))
	'((con
   cons
   (app cons (-> '- <-) (app map deriv (app cdr a)))
   (app cons '- (-> (app map deriv (app cdr a)) <-)))
  (env (())))
	'((con
   error
   (app error (-> (app #f) <-) "No derivation method available")
   (app error (app #f) (-> "No derivation method available" <-)))
  (env (())))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> cdr <-) (app cdr cadr-v)) (env (())))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec* (... map (pair? (-> (λ (pair?-v) ...) <-)) deriv ...) ...)
  (env ()))
clos/con:
	'((letrec* (... map (pair? (-> (λ (pair?-v) ...) <-)) deriv ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> '* <-)
   (app
    cons
    (app caddr a)
    (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))))
  (env (())))
clos/con:
	'((app
   cons
   (-> '* <-)
   (app
    cons
    (app caddr a)
    (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))))
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 3 (app cons 'x (app cons 'x (app nil)))) (env ()))
clos/con:
	'((app (-> cons <-) 3 (app cons 'x (app cons 'x (app nil)))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

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
  (env (())))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (pair?-v) (-> (match pair?-v ...) <-)) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app car (-> (app cdr (app cdr cadr-v)) <-)) (env (())))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil))))
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
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil)))
   (app
    cons
    (app cons '* (app cons 'b (app cons 'x (app nil))))
    (-> (app cons 5 (app nil)) <-)))
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
      (app cons 5 (app nil)))))
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
   (app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil))))
   (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'b <-) (app cons 'x (app nil)))
   (app cons 'b (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'x <-) (app cons 'x (app nil)))
   (app cons 'x (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'x <-) (app cons 'x (app nil)))
   (app cons 'x (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 3 <-) (app cons 'x (app cons 'x (app nil))))
   (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 5 <-) (app nil)) (app cons 5 (-> (app nil) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec* (... cdr (cadr (-> (λ (cadr-v) ...) <-)) caddr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cdr (cadr (-> (λ (cadr-v) ...) <-)) caddr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 'a (app cons 'x (app cons 'x (app nil)))) (env ()))
clos/con:
	'((app (-> cons <-) 'a (app cons 'x (app cons 'x (app nil)))) (env ()))
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
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons 'x (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 'x (app nil)) (env ()))
clos/con:
	'((app (-> cons <-) 'x (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   (app caddr a)
   (app cons (app deriv (app caddr a)) (app nil)))
  (env (())))
clos/con:
	'((app
   (-> cons <-)
   (app caddr a)
   (app cons (app deriv (app caddr a)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> (app eq? (app car a) '+) <-) (#f) _) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (λ (a) (-> (app cons '/ (app cons (app deriv a) (app cons a (app nil)))) <-))
  (env (() ())))
clos/con:
	'((con
   cons
   (app cons (-> '/ <-) (app cons (app deriv a) (app cons a (app nil))))
   (app cons '/ (-> (app cons (app deriv a) (app cons a (app nil))) <-)))
  (env (() ())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app map (-> (λ (a) ...) <-) (app cdr a)) (env (())))
clos/con:
	'((app map (-> (λ (a) ...) <-) (app cdr a)) (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (cadr-v) (-> (app car (app cdr (app cdr cadr-v))) <-)) (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> deriv <-) (app caddr a)) (env (())))
clos/con:
	'((letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...) (env ()))
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

'(query: (app cons '- (-> (app map deriv (app cdr a)) <-)) (env (())))
clos/con:
	'((con
   cons
   (app cons (-> (app map-f map-c) <-) (app map map-f map-d))
   (app cons (app map-f map-c) (-> (app map map-f map-d) <-)))
  (env (())))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (-> (app nil) <-))
  (env (())))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app not (-> (app pair? a) <-)) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)) (env ()))
clos/con:
	'((con
   cons
   (app cons (-> 'x <-) (app cons 'x (app nil)))
   (app cons 'x (-> (app cons 'x (app nil)) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app cons (-> '/ <-) (app cons (app deriv a) (app cons a (app nil))))
  (env (() ())))
clos/con:
	'((app cons (-> '/ <-) (app cons (app deriv a) (app cons a (app nil))))
  (env (() ())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> '+ <-) (app map (λ (a) ...) (app cdr a))) (env (())))
clos/con:
	'((app cons (-> '+ <-) (app map (λ (a) ...) (app cdr a))) (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app (-> cons <-) '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
clos/con:
	'((app (-> cons <-) '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app cons '/ (-> (app cons (app deriv a) (app cons a (app nil))) <-))
  (env (() ())))
clos/con:
	'((con
   cons
   (app cons (-> (app deriv a) <-) (app cons a (app nil)))
   (app cons (app deriv a) (-> (app cons a (app nil)) <-)))
  (env (() ())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
  (env (())))
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
     (app nil)))
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
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match (app not (app pair? a)) (#f) (_ (-> (match (app eq? a 'x) ...) <-)))
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> car <-) (app cdr cadr-v)) (env (())))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec* (... cadr (caddr (-> (λ (cadr-v) ...) <-)) map ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cadr (caddr (-> (λ (cadr-v) ...) <-)) map ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match
   map-l
   ((cons map-c map-d)
    (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
   (nil))
  (env (())))
clos/con:
	'((con
   cons
   (app cons (-> (app map-f map-c) <-) (app map map-f map-d))
   (app cons (app map-f map-c) (-> (app map map-f map-d) <-)))
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> eq? <-) (app car a) '+) (env (())))
clos/con:
	#<procedure:do-equal>
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
  (env (())))
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
  (match
   (app eq? (app car a) '+)
   ((#f) (-> (match (app eq? (app car a) '-) ...) <-))
   _)
  (env (())))
clos/con:
	'((con
   cons
   (app
    cons
    (-> '* <-)
    (app
     cons
     a
     (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
   (app
    cons
    '*
    (->
     (app
      cons
      a
      (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil)))
     <-)))
  (env (())))
	'((con
   cons
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
  (env (())))
	'((con
   cons
   (app cons (-> '- <-) (app map deriv (app cdr a)))
   (app cons '- (-> (app map deriv (app cdr a)) <-)))
  (env (())))
	'((con
   error
   (app error (-> (app #f) <-) "No derivation method available")
   (app error (app #f) (-> "No derivation method available" <-)))
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons 5 (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
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

'(query: (app eq? (-> (app car a) <-) '+) (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env (())))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> map <-) deriv (app cdr a)) (env (())))
clos/con:
	'((letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) pair? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cadr (-> a <-)) (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app map deriv (-> (app cdr a) <-)) (env (())))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil))))
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
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil)))
   (app
    cons
    (app cons '* (app cons 'b (app cons 'x (app nil))))
    (-> (app cons 5 (app nil)) <-)))
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
      (app cons 5 (app nil)))))
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
   (app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil))))
   (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'b <-) (app cons 'x (app nil)))
   (app cons 'b (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'x <-) (app cons 'x (app nil)))
   (app cons 'x (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'x <-) (app cons 'x (app nil)))
   (app cons 'x (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 3 <-) (app cons 'x (app cons 'x (app nil))))
   (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 5 <-) (app nil)) (app cons 5 (-> (app nil) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match
   (app eq? (app car a) '*)
   ((#f) (-> (match (app eq? (app car a) '/) ...) <-))
   _)
  (env (())))
clos/con:
	'((con
   cons
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
  (env (())))
	'((con
   error
   (app error (-> (app #f) <-) "No derivation method available")
   (app error (app #f) (-> "No derivation method available" <-)))
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> map-l <-) (cons map-c map-d) (nil)) (env (())))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil))))
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
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil)))
   (app
    cons
    (app cons '* (app cons 'b (app cons 'x (app nil))))
    (-> (app cons 5 (app nil)) <-)))
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
      (app cons 5 (app nil)))))
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
   (app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil))))
   (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'b <-) (app cons 'x (app nil)))
   (app cons 'b (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'x <-) (app cons 'x (app nil)))
   (app cons 'x (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'x <-) (app cons 'x (app nil)))
   (app cons 'x (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 3 <-) (app cons 'x (app cons 'x (app nil))))
   (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 5 <-) (app nil)) (app cons 5 (-> (app nil) <-)))
  (env ()))
	'((con nil) (env ()))
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
  (env (())))
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
  (env (())))
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
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons 'x (-> (app cons 'x (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cdr (-> a <-)) (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app cons (-> 3 <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
clos/con: ⊥
literals: '(3 ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) '- (app map deriv (app cdr a))) (env (())))
clos/con:
	'((app (-> cons <-) '- (app map deriv (app cdr a))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match
   (app eq? (app car a) '/)
   ((#f) (-> (app error (app #f) "No derivation method available") <-))
   _)
  (env (())))
clos/con:
	'((con
   error
   (app error (-> (app #f) <-) "No derivation method available")
   (app error (app #f) (-> "No derivation method available" <-)))
  (env (())))
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

'(query: (app (-> eq? <-) (app car a) '/) (env (())))
clos/con:
	#<procedure:do-equal>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons a (-> (app nil) <-)) (env (() ())))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (app cons '* (app cons 'b (app cons 'x (app nil))))
   (-> (app cons 5 (app nil)) <-))
  (env ()))
clos/con:
	'((con cons (app cons (-> 5 <-) (app nil)) (app cons 5 (-> (app nil) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app (-> cons <-) (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))
  (env (())))
clos/con:
	'((app (-> cons <-) (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))
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
  (env (())))
clos/con:
	'((con
   cons
   (app
    cons
    (-> a <-)
    (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil)))
   (app
    cons
    a
    (->
     (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))
     <-)))
  (env (())))
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
  (env (())))
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

'(query: (app (-> #t <-)) (env (())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app eq? (-> (app car a) <-) '/) (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app pair? (-> a <-)) (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (λ (car-v) (-> (match car-v ...) <-)) (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app cons 'x (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
clos/con:
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (app deriv (app caddr a)) (-> (app nil) <-)) (env (())))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app deriv (-> (app caddr a) <-)) (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> (app deriv (app cadr a)) <-)
   (app cons (app caddr a) (app nil)))
  (env (())))
clos/con:
	'((con
   cons
   (app
    cons
    (-> '* <-)
    (app
     cons
     a
     (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
   (app
    cons
    '*
    (->
     (app
      cons
      a
      (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil)))
     <-)))
  (env (())))
	'((con
   cons
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
  (env (())))
	'((con
   cons
   (app cons (-> '+ <-) (app map deriv (app cdr a)))
   (app cons '+ (-> (app map deriv (app cdr a)) <-)))
  (env (())))
	'((con
   cons
   (app cons (-> '- <-) (app map deriv (app cdr a)))
   (app cons '- (-> (app map deriv (app cdr a)) <-)))
  (env (())))
	'((con
   error
   (app error (-> (app #f) <-) "No derivation method available")
   (app error (app #f) (-> "No derivation method available" <-)))
  (env (())))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> car <-) a) (env (())))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> 'x <-) (app nil)) (env ()))
clos/con:
	'((app cons (-> 'x <-) (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) (app deriv a) (app cons a (app nil))) (env (() ())))
clos/con:
	'((app (-> cons <-) (app deriv a) (app cons a (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> '* <-)
   (app
    cons
    a
    (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
  (env (())))
clos/con:
	'((app
   cons
   (-> '* <-)
   (app
    cons
    a
    (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> eq? <-) (app car a) '-) (env (())))
clos/con:
	#<procedure:do-equal>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> car <-) a) (env (())))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cdr <-) a) (env (())))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> not <-) (app pair? a)) (env (())))
clos/con:
	#<procedure:do-not>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match pair?-v (cons pair?-c pair?-d) (_ (-> (app #f) <-)))
  (env (())))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app car (-> a <-)) (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   a
   (->
    (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))
    <-))
  (env (())))
clos/con:
	'((con
   cons
   (app cons (-> (app cons '+ (app map (λ (a) ...) (app cdr a))) <-) (app nil))
   (app
    cons
    (app cons '+ (app map (λ (a) ...) (app cdr a)))
    (-> (app nil) <-)))
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cdr (-> cadr-v <-)) (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> caddr <-) a) (env (())))
clos/con:
	'((letrec* (... cadr (caddr (-> (λ (cadr-v) ...) <-)) map ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match
   (app eq? (app car a) '-)
   ((#f) (-> (match (app eq? (app car a) '*) ...) <-))
   _)
  (env (())))
clos/con:
	'((con
   cons
   (app
    cons
    (-> '* <-)
    (app
     cons
     a
     (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
   (app
    cons
    '*
    (->
     (app
      cons
      a
      (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil)))
     <-)))
  (env (())))
	'((con
   cons
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
  (env (())))
	'((con
   error
   (app error (-> (app #f) <-) "No derivation method available")
   (app error (app #f) (-> "No derivation method available" <-)))
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> pair? <-) a) (env (())))
clos/con:
	'((letrec* (... map (pair? (-> (λ (pair?-v) ...) <-)) deriv ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cdr (-> (app cdr cadr-v) <-)) (env (())))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil))))
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
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil)))
   (app
    cons
    (app cons '* (app cons 'b (app cons 'x (app nil))))
    (-> (app cons 5 (app nil)) <-)))
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
      (app cons 5 (app nil)))))
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
   (app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil))))
   (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'b <-) (app cons 'x (app nil)))
   (app cons 'b (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'x <-) (app cons 'x (app nil)))
   (app cons 'x (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'x <-) (app cons 'x (app nil)))
   (app cons 'x (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 3 <-) (app cons 'x (app cons 'x (app nil))))
   (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 5 <-) (app nil)) (app cons 5 (-> (app nil) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app caddr (-> a <-)) (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> eq? <-) (app car a) '*) (env (())))
clos/con:
	#<procedure:do-equal>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> car <-) a) (env (())))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
clos/con:
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons 'x (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app map-f (-> map-c <-)) (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 'x (app cons 'x (app nil))) (env ()))
clos/con:
	'((app (-> cons <-) 'x (app cons 'x (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app eq? (app car a) (-> '- <-)) (env (())))
clos/con:
	'((app eq? (app car a) (-> '- <-)) (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app map (-> map-f <-) map-d) (env (())))
clos/con:
	'((app map (-> (λ (a) ...) <-) (app cdr a)) (env (())))
	'((letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env (())))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app error (-> (app #f) <-) "No derivation method available")
  (env (())))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> cdr-v <-) (cons cdr-c cdr-d)) (env (())))
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
     (app cons 5 (app nil))))
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
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil)))
   (app
    cons
    (app cons '* (app cons 'b (app cons 'x (app nil))))
    (-> (app cons 5 (app nil)) <-)))
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
      (app cons 5 (app nil)))))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil))))
   (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'b <-) (app cons 'x (app nil)))
   (app cons 'b (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'x <-) (app cons 'x (app nil)))
   (app cons 'x (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'x <-) (app cons 'x (app nil)))
   (app cons 'x (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 3 <-) (app cons 'x (app cons 'x (app nil))))
   (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 5 <-) (app nil)) (app cons 5 (-> (app nil) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query:
  (app (-> cons <-) '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
clos/con:
	'((app (-> cons <-) '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> map <-) map-f map-d) (env (())))
clos/con:
	'((letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) pair? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> (app not (app pair? a)) <-) (#f) _) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> map-f <-) map-c) (env (())))
clos/con:
	'((app map (-> (λ (a) ...) <-) (app cdr a)) (env (())))
	'((letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

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
   (app
    cons
    (-> '* <-)
    (app
     cons
     a
     (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
   (app
    cons
    '*
    (->
     (app
      cons
      a
      (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil)))
     <-)))
  (env (())))
	'((con
   cons
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
  (env (())))
	'((con
   cons
   (app cons (-> '+ <-) (app map deriv (app cdr a)))
   (app cons '+ (-> (app map deriv (app cdr a)) <-)))
  (env (())))
	'((con
   cons
   (app cons (-> '- <-) (app map deriv (app cdr a)))
   (app cons '- (-> (app map deriv (app cdr a)) <-)))
  (env (())))
	'((con
   error
   (app error (-> (app #f) <-) "No derivation method available")
   (app error (app #f) (-> "No derivation method available" <-)))
  (env (())))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> car-v <-) (cons car-c car-d)) (env (())))
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
     (app cons 5 (app nil))))
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
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil)))
   (app
    cons
    (app cons '* (app cons 'b (app cons 'x (app nil))))
    (-> (app cons 5 (app nil)) <-)))
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
      (app cons 5 (app nil)))))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil))))
   (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'b <-) (app cons 'x (app nil)))
   (app cons 'b (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'x <-) (app cons 'x (app nil)))
   (app cons 'x (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'x <-) (app cons 'x (app nil)))
   (app cons 'x (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 3 <-) (app cons 'x (app cons 'x (app nil))))
   (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 5 <-) (app nil)) (app cons 5 (-> (app nil) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) a (app nil)) (env (() ())))
clos/con:
	'((app (-> cons <-) a (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app cons (-> (app cons '+ (app map (λ (a) ...) (app cdr a))) <-) (app nil))
  (env (())))
clos/con:
	'((con
   cons
   (app cons (-> '+ <-) (app map (λ (a) ...) (app cdr a)))
   (app cons '+ (-> (app map (λ (a) ...) (app cdr a)) <-)))
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app deriv (-> a <-)) (env (() ())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

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

'(query: (app (-> cdr <-) cadr-v) (env (())))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> (app eq? (app car a) '*) <-) (#f) _) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 'x (app nil)) (env ()))
clos/con:
	'((app (-> cons <-) 'x (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match
   (app eq? (app car a) '+)
   (#f)
   (_ (-> (app cons '+ (app map deriv (app cdr a))) <-)))
  (env (())))
clos/con:
	'((con
   cons
   (app cons (-> '+ <-) (app map deriv (app cdr a)))
   (app cons '+ (-> (app map deriv (app cdr a)) <-)))
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> caddr <-) a) (env (())))
clos/con:
	'((letrec* (... cadr (caddr (-> (λ (cadr-v) ...) <-)) map ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> (app caddr a) <-) (app nil)) (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 'b (app cons 'x (app nil))) (env ()))
clos/con:
	'((app (-> cons <-) 'b (app cons 'x (app nil))) (env ()))
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
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> (app eq? a 'x) <-) (#f) _) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app eq? (app car a) (-> '* <-)) (env (())))
clos/con:
	'((app eq? (app car a) (-> '* <-)) (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)) (env ()))
clos/con:
	'((con
   cons
   (app cons (-> 'x <-) (app cons 'x (app nil)))
   (app cons 'x (-> (app cons 'x (app nil)) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cdr (-> a <-)) (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) '* (app cons 'b (app cons 'x (app nil)))) (env ()))
clos/con:
	'((app (-> cons <-) '* (app cons 'b (app cons 'x (app nil)))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cdr <-) a) (env (())))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cdr (-> a <-)) (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app cons (-> 'x <-) (app nil)) (env ()))
clos/con:
	'((app cons (-> 'x <-) (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (cadr-v) (-> (app car (app cdr cadr-v)) <-)) (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

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
  (env (())))
clos/con:
	'((con
   cons
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
       (app
        cons
        (app caddr a)
        (app cons (app deriv (app caddr a)) (app nil)))))
     (app nil)))
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
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app eq? (app car a) (-> '/ <-)) (env (())))
clos/con:
	'((app eq? (app car a) (-> '/ <-)) (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   '/
   (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil))))
  (env (())))
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
  (env (())))
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

'(query: (app car (-> (app cdr cadr-v) <-)) (env (())))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil))))
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
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil)))
   (app
    cons
    (app cons '* (app cons 'b (app cons 'x (app nil))))
    (-> (app cons 5 (app nil)) <-)))
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
      (app cons 5 (app nil)))))
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
   (app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil))))
   (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'b <-) (app cons 'x (app nil)))
   (app cons 'b (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'x <-) (app cons 'x (app nil)))
   (app cons 'x (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'x <-) (app cons 'x (app nil)))
   (app cons 'x (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 3 <-) (app cons 'x (app cons 'x (app nil))))
   (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 5 <-) (app nil)) (app cons 5 (-> (app nil) <-)))
  (env ()))
	'((con nil) (env ()))
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
  (env (())))
clos/con:
	'((con
   cons
   (app
    cons
    (-> '/ <-)
    (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil))))
   (app
    cons
    '/
    (->
     (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil)))
     <-)))
  (env (())))
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
  (env (())))
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
    (app nil))
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
    (-> (app nil) <-)))
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons '+ (-> (app map deriv (app cdr a)) <-)) (env (())))
clos/con:
	'((con
   cons
   (app cons (-> (app map-f map-c) <-) (app map map-f map-d))
   (app cons (app map-f map-c) (-> (app map map-f map-d) <-)))
  (env (())))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 'x (app cons 'x (app nil))) (env ()))
clos/con:
	'((app (-> cons <-) 'x (app cons 'x (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons '+ (-> (app map (λ (a) ...) (app cdr a)) <-)) (env (())))
clos/con:
	'((con
   cons
   (app cons (-> (app map-f map-c) <-) (app map map-f map-d))
   (app cons (app map-f map-c) (-> (app map map-f map-d) <-)))
  (env (())))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (app caddr a)
   (-> (app cons (app deriv (app caddr a)) (app nil)) <-))
  (env (())))
clos/con:
	'((con
   cons
   (app cons (-> (app deriv (app caddr a)) <-) (app nil))
   (app cons (app deriv (app caddr a)) (-> (app nil) <-)))
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 'x (app nil)) (env ()))
clos/con:
	'((app (-> cons <-) 'x (app nil)) (env ()))
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
  (env (())))
clos/con:
	'((con
   cons
   (app
    cons
    (-> '* <-)
    (app
     cons
     a
     (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
   (app
    cons
    '*
    (->
     (app
      cons
      a
      (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil)))
     <-)))
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-))
  (env ()))
clos/con:
	'((con
   cons
   (app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil))))
   (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> 'x <-) (app nil)) (env ()))
clos/con:
	'((app cons (-> 'x <-) (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app eq? a (-> 'x <-)) (env (())))
clos/con:
	'((app eq? a (-> 'x <-)) (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (lettypes cons ... nil (letrec* (car ... deriv) ...)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (-> '* <-)
    (app
     cons
     a
     (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
   (app
    cons
    '*
    (->
     (app
      cons
      a
      (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil)))
     <-)))
  (env (())))
	'((con
   cons
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
  (env (())))
	'((con
   cons
   (app cons (-> '+ <-) (app map deriv (app cdr a)))
   (app cons '+ (-> (app map deriv (app cdr a)) <-)))
  (env (())))
	'((con
   cons
   (app cons (-> '- <-) (app map deriv (app cdr a)))
   (app cons '- (-> (app map deriv (app cdr a)) <-)))
  (env (())))
	'((con
   error
   (app error (-> (app #f) <-) "No derivation method available")
   (app error (app #f) (-> "No derivation method available" <-)))
  (env (())))
literals: '(⊤ ⊥ ⊥ ⊥)

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
  (app (-> cons <-) '/ (app cons (app deriv a) (app cons a (app nil))))
  (env (() ())))
clos/con:
	'((app (-> cons <-) '/ (app cons (app deriv a) (app cons a (app nil))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app error (app #f) (-> "No derivation method available" <-))
  (env (())))
clos/con: ⊥
literals: '(⊥ ⊥ ⊥ "No derivation method available")

'(query: (letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...) (env ()))
clos/con:
	'((letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app map (-> deriv <-) (app cdr a)) (env (())))
clos/con:
	'((letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> caddr <-) a) (env (())))
clos/con:
	'((letrec* (... cadr (caddr (-> (λ (cadr-v) ...) <-)) map ...) ...) (env ()))
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
  (env (())))
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
  (env (())))
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
  (env (())))
clos/con:
	'((con
   cons
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
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> (app deriv a) <-) (app cons a (app nil))) (env (() ())))
clos/con:
	'((con
   cons
   (app
    cons
    (-> '* <-)
    (app
     cons
     a
     (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
   (app
    cons
    '*
    (->
     (app
      cons
      a
      (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil)))
     <-)))
  (env (())))
	'((con
   cons
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
  (env (())))
	'((con
   cons
   (app cons (-> '+ <-) (app map deriv (app cdr a)))
   (app cons '+ (-> (app map deriv (app cdr a)) <-)))
  (env (())))
	'((con
   cons
   (app cons (-> '- <-) (app map deriv (app cdr a)))
   (app cons '- (-> (app map deriv (app cdr a)) <-)))
  (env (())))
	'((con
   error
   (app error (-> (app #f) <-) "No derivation method available")
   (app error (app #f) (-> "No derivation method available" <-)))
  (env (())))
literals: '(⊤ ⊥ ⊥ ⊥)

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
  (env (())))
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

'(query: (app (-> cons <-) 5 (app nil)) (env ()))
clos/con:
	'((app (-> cons <-) 5 (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> car <-) a) (env (())))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (app deriv (app cadr a))
   (-> (app cons (app caddr a) (app nil)) <-))
  (env (())))
clos/con:
	'((con
   cons
   (app cons (-> (app caddr a) <-) (app nil))
   (app cons (app caddr a) (-> (app nil) <-)))
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app car (-> a <-)) (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (λ (cdr-v) (-> (match cdr-v ...) <-)) (env (())))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil))))
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
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil)))
   (app
    cons
    (app cons '* (app cons 'b (app cons 'x (app nil))))
    (-> (app cons 5 (app nil)) <-)))
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
      (app cons 5 (app nil)))))
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
   (app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil))))
   (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'b <-) (app cons 'x (app nil)))
   (app cons 'b (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'x <-) (app cons 'x (app nil)))
   (app cons 'x (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'x <-) (app cons 'x (app nil)))
   (app cons 'x (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 3 <-) (app cons 'x (app cons 'x (app nil))))
   (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 5 <-) (app nil)) (app cons 5 (-> (app nil) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   a
   (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil)))
  (env (())))
clos/con:
	'((app
   (-> cons <-)
   a
   (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil)))
  (env ()))
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
  (env (())))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app caddr a) <-)
    (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil))))
   (app
    cons
    (app caddr a)
    (->
     (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))
     <-)))
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app caddr (-> a <-)) (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> pair?-v <-) (cons pair?-c pair?-d) _) (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app deriv (-> (app cadr a) <-)) (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   (app deriv (app cadr a))
   (app cons (app caddr a) (app nil)))
  (env (())))
clos/con:
	'((app
   (-> cons <-)
   (app deriv (app cadr a))
   (app cons (app caddr a) (app nil)))
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
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil))))
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

'(query: (app (-> map <-) (λ (a) ...) (app cdr a)) (env (())))
clos/con:
	'((letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) pair? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app eq? (-> (app car a) <-) '*) (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env (())))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env (() ())))
clos/con:
	'((app (-> nil <-)) (env ()))
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
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil)))))
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

'(query: (match (app eq? a 'x) (#f) (_ (-> 1 <-))) (env (())))
clos/con: ⊥
literals: '(1 ⊥ ⊥ ⊥)

'(query: (app eq? (-> a <-) 'x) (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (λ (map-f map-l) (-> (match map-l ...) <-)) (env (())))
clos/con:
	'((con
   cons
   (app cons (-> (app map-f map-c) <-) (app map map-f map-d))
   (app cons (app map-f map-c) (-> (app map map-f map-d) <-)))
  (env (())))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cdr (-> cadr-v <-)) (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env (())))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match car-v ((cons car-c car-d) (-> car-c <-))) (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> (app caddr a) <-)
   (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil))))
  (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   (app caddr a)
   (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil))))
  (env (())))
clos/con:
	'((app
   (-> cons <-)
   (app caddr a)
   (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (app map-f map-c) (-> (app map map-f map-d) <-)) (env (())))
clos/con:
	'((con
   cons
   (app cons (-> (app map-f map-c) <-) (app map map-f map-d))
   (app cons (app map-f map-c) (-> (app map map-f map-d) <-)))
  (env (())))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (app caddr a) (-> (app nil) <-)) (env (())))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   '*
   (app
    cons
    a
    (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
  (env (())))
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

'(query: (app (-> cons <-) (app map-f map-c) (app map map-f map-d)) (env (())))
clos/con:
	'((app (-> cons <-) (app map-f map-c) (app map map-f map-d)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons 'b (-> (app cons 'x (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app (-> error <-) (app #f) "No derivation method available")
  (env (())))
clos/con:
	'((app (-> error <-) (app #f) "No derivation method available") (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-))
  (env ()))
clos/con:
	'((con
   cons
   (app cons (-> 3 <-) (app cons 'x (app cons 'x (app nil))))
   (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (app caddr a)
   (->
    (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))
    <-))
  (env (())))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app caddr a) <-)
    (app cons (app deriv (app caddr a)) (app nil)))
   (app
    cons
    (app caddr a)
    (-> (app cons (app deriv (app caddr a)) (app nil)) <-)))
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> caddr <-) a) (env (())))
clos/con:
	'((letrec* (... cadr (caddr (-> (λ (cadr-v) ...) <-)) map ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   '*
   (app
    cons
    (app caddr a)
    (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))))
  (env (())))
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

'(query: (app (-> nil <-)) (env (())))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> '- <-) (app map deriv (app cdr a))) (env (())))
clos/con:
	'((app cons (-> '- <-) (app map deriv (app cdr a))) (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (app eq? a 'x) ((#f) (-> 0 <-)) _) (env (())))
clos/con: ⊥
literals: '(0 ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) (app caddr a) (app nil)) (env (())))
clos/con:
	'((app (-> cons <-) (app caddr a) (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
clos/con:
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app car (-> a <-)) (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> cdr <-) cadr-v) (env (())))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-))) (env (())))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil))))
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
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil)))
   (app
    cons
    (app cons '* (app cons 'b (app cons 'x (app nil))))
    (-> (app cons 5 (app nil)) <-)))
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
      (app cons 5 (app nil)))))
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
   (app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil))))
   (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'b <-) (app cons 'x (app nil)))
   (app cons 'b (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'x <-) (app cons 'x (app nil)))
   (app cons 'x (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'x <-) (app cons 'x (app nil)))
   (app cons 'x (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 3 <-) (app cons 'x (app cons 'x (app nil))))
   (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 5 <-) (app nil)) (app cons 5 (-> (app nil) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> a <-)
   (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil)))
  (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

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
  (env (())))
clos/con:
	'((con
   cons
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
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app map (λ (a) ...) (-> (app cdr a) <-)) (env (())))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil))))
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
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil)))
   (app
    cons
    (app cons '* (app cons 'b (app cons 'x (app nil))))
    (-> (app cons 5 (app nil)) <-)))
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
      (app cons 5 (app nil)))))
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
   (app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil))))
   (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'b <-) (app cons 'x (app nil)))
   (app cons 'b (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'x <-) (app cons 'x (app nil)))
   (app cons 'x (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'x <-) (app cons 'x (app nil)))
   (app cons 'x (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 3 <-) (app cons 'x (app cons 'x (app nil))))
   (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 5 <-) (app nil)) (app cons 5 (-> (app nil) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cadr <-) a) (env (())))
clos/con:
	'((letrec* (... cdr (cadr (-> (λ (cadr-v) ...) <-)) caddr ...) ...) (env ()))
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
  (match
   (app eq? (app car a) '-)
   (#f)
   (_ (-> (app cons '- (app map deriv (app cdr a))) <-)))
  (env (())))
clos/con:
	'((con
   cons
   (app cons (-> '- <-) (app map deriv (app cdr a)))
   (app cons '- (-> (app map deriv (app cdr a)) <-)))
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) '+ (app map deriv (app cdr a))) (env (())))
clos/con:
	'((app (-> cons <-) '+ (app map deriv (app cdr a))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)) (env ()))
clos/con:
	'((con
   cons
   (app cons (-> 'b <-) (app cons 'x (app nil)))
   (app cons 'b (-> (app cons 'x (app nil)) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match pair?-v ((cons pair?-c pair?-d) (-> (app #t) <-)) _)
  (env (())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons 'x (-> (app cons 'x (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
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
  (env (())))
clos/con:
	'((con nil) (env ()))
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
  (env (())))
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
    (app nil))
   (app
    cons
    (app
     cons
     '*
     (app
      cons
      (app caddr a)
      (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))))
    (-> (app nil) <-)))
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
clos/con:
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> a <-) (app nil)) (env (() ())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

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

'(query: (app eq? (app car a) (-> '+ <-)) (env (())))
clos/con:
	'((app eq? (app car a) (-> '+ <-)) (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env (())))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app car (-> a <-)) (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: ((top) lettypes (cons ... nil) ...) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    (-> '* <-)
    (app
     cons
     a
     (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
   (app
    cons
    '*
    (->
     (app
      cons
      a
      (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil)))
     <-)))
  (env (())))
	'((con
   cons
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
  (env (())))
	'((con
   cons
   (app cons (-> '+ <-) (app map deriv (app cdr a)))
   (app cons '+ (-> (app map deriv (app cdr a)) <-)))
  (env (())))
	'((con
   cons
   (app cons (-> '- <-) (app map deriv (app cdr a)))
   (app cons '- (-> (app map deriv (app cdr a)) <-)))
  (env (())))
	'((con
   error
   (app error (-> (app #f) <-) "No derivation method available")
   (app error (app #f) (-> "No derivation method available" <-)))
  (env (())))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) '+ (app map (λ (a) ...) (app cdr a))) (env (())))
clos/con:
	'((app (-> cons <-) '+ (app map (λ (a) ...) (app cdr a))) (env ()))
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
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil)))
   (app
    cons
    (app cons '* (app cons 'b (app cons 'x (app nil))))
    (-> (app cons 5 (app nil)) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> (app eq? (app car a) '-) <-) (#f) _) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
  (env (())))
clos/con:
	'((con
   cons
   (app
    cons
    (-> '* <-)
    (app
     cons
     (app caddr a)
     (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))))
   (app
    cons
    '*
    (->
     (app
      cons
      (app caddr a)
      (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil))))
     <-)))
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) (app deriv (app caddr a)) (app nil)) (env (())))
clos/con:
	'((app (-> cons <-) (app deriv (app caddr a)) (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (app deriv a) (-> (app cons a (app nil)) <-)) (env (() ())))
clos/con:
	'((con cons (app cons (-> a <-) (app nil)) (app cons a (-> (app nil) <-)))
  (env (() ())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app eq? (-> (app car a) <-) '-) (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> deriv <-) (app cadr a)) (env (())))
clos/con:
	'((letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> eq? <-) a 'x) (env (())))
clos/con:
	#<procedure:do-equal>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> '/ <-)
   (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil))))
  (env (())))
clos/con:
	'((app
   cons
   (-> '/ <-)
   (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil))))
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cadr (-> a <-)) (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> (app caddr a) <-)
   (app cons (app deriv (app caddr a)) (app nil)))
  (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: map-f (env (())))
clos/con:
	'((app map (-> (λ (a) ...) <-) (app cdr a)) (env (())))
	'((letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
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
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil)))
   (app
    cons
    (app cons '* (app cons 'b (app cons 'x (app nil))))
    (-> (app cons 5 (app nil)) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
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
  (env (())))
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
    (app nil))
   (app
    cons
    (app
     cons
     '*
     (app
      cons
      (app caddr a)
      (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))))
    (-> (app nil) <-)))
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: a (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: (app cons (-> 'x <-) (app nil)) (env ()))
clos/con:
	'((app cons (-> 'x <-) (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
clos/con:
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)) (env ()))
clos/con:
	'((con
   cons
   (app cons (-> 'b <-) (app cons 'x (app nil)))
   (app cons 'b (-> (app cons 'x (app nil)) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons (-> '- <-) (app map deriv (app cdr a))) (env (())))
clos/con:
	'((app cons (-> '- <-) (app map deriv (app cdr a))) (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: map-l (env (())))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil))))
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
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil)))
   (app
    cons
    (app cons '* (app cons 'b (app cons 'x (app nil))))
    (-> (app cons 5 (app nil)) <-)))
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
      (app cons 5 (app nil)))))
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
   (app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil))))
   (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'b <-) (app cons 'x (app nil)))
   (app cons 'b (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'x <-) (app cons 'x (app nil)))
   (app cons 'x (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'x <-) (app cons 'x (app nil)))
   (app cons 'x (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 3 <-) (app cons 'x (app cons 'x (app nil))))
   (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 5 <-) (app nil)) (app cons 5 (-> (app nil) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: cadr (env ()))
clos/con:
	'((letrec* (... cdr (cadr (-> (λ (cadr-v) ...) <-)) caddr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-))
  (env ()))
clos/con:
	'((con
   cons
   (app cons (-> 3 <-) (app cons 'x (app cons 'x (app nil))))
   (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  (app
   cons
   (-> (app deriv (app cadr a)) <-)
   (app cons (app caddr a) (app nil)))
  (env (())))
clos/con:
	'((con
   cons
   (app
    cons
    (-> '* <-)
    (app
     cons
     a
     (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
   (app
    cons
    '*
    (->
     (app
      cons
      a
      (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil)))
     <-)))
  (env (())))
	'((con
   cons
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
  (env (())))
	'((con
   cons
   (app cons (-> '+ <-) (app map deriv (app cdr a)))
   (app cons '+ (-> (app map deriv (app cdr a)) <-)))
  (env (())))
	'((con
   cons
   (app cons (-> '- <-) (app map deriv (app cdr a)))
   (app cons '- (-> (app map deriv (app cdr a)) <-)))
  (env (())))
	'((con
   error
   (app error (-> (app #f) <-) "No derivation method available")
   (app error (app #f) (-> "No derivation method available" <-)))
  (env (())))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store:
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  (app
   cons
   (-> (app caddr a) <-)
   (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil))))
  (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store:
  (app
   cons
   '*
   (->
    (app
     cons
     a
     (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil)))
    <-))
  (env (())))
clos/con:
	'((con
   cons
   (app
    cons
    (-> a <-)
    (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil)))
   (app
    cons
    a
    (->
     (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))
     <-)))
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
clos/con:
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons (app map-f map-c) (-> (app map map-f map-d) <-)) (env (())))
clos/con:
	'((con
   cons
   (app cons (-> (app map-f map-c) <-) (app map map-f map-d))
   (app cons (app map-f map-c) (-> (app map map-f map-d) <-)))
  (env (())))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons 'x (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  (app
   cons
   (app caddr a)
   (->
    (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))
    <-))
  (env (())))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app caddr a) <-)
    (app cons (app deriv (app caddr a)) (app nil)))
   (app
    cons
    (app caddr a)
    (-> (app cons (app deriv (app caddr a)) (app nil)) <-)))
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons 'x (-> (app cons 'x (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons (app caddr a) (-> (app nil) <-)) (env (())))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: map-c (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: cdr (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  (app cons '/ (-> (app cons (app deriv a) (app cons a (app nil))) <-))
  (env (() ())))
clos/con:
	'((con
   cons
   (app cons (-> (app deriv a) <-) (app cons a (app nil)))
   (app cons (app deriv a) (-> (app cons a (app nil)) <-)))
  (env (() ())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons '+ (-> (app map deriv (app cdr a)) <-)) (env (())))
clos/con:
	'((con
   cons
   (app cons (-> (app map-f map-c) <-) (app map map-f map-d))
   (app cons (app map-f map-c) (-> (app map map-f map-d) <-)))
  (env (())))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons 'x (-> (app cons 'x (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
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
    (-> (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
     (app
      cons
      (app cons '* (app cons 'b (app cons 'x (app nil))))
      (app cons 5 (app nil)))))
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

'(store: (app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
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
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: map-d (env (())))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil))))
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
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil)))
   (app
    cons
    (app cons '* (app cons 'b (app cons 'x (app nil))))
    (-> (app cons 5 (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'x <-) (app cons 'x (app nil)))
   (app cons 'x (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'x <-) (app cons 'x (app nil)))
   (app cons 'x (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 5 <-) (app nil)) (app cons 5 (-> (app nil) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons (-> a <-) (app nil)) (env (() ())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: (app cons '+ (-> (app map (λ (a) ...) (app cdr a)) <-)) (env (())))
clos/con:
	'((con
   cons
   (app cons (-> (app map-f map-c) <-) (app map map-f map-d))
   (app cons (app map-f map-c) (-> (app map map-f map-d) <-)))
  (env (())))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
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
  (env (())))
clos/con:
	'((con
   cons
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
       (app
        cons
        (app caddr a)
        (app cons (app deriv (app caddr a)) (app nil)))))
     (app nil)))
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
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: car-v (env (())))
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
     (app cons 5 (app nil))))
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
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil)))
   (app
    cons
    (app cons '* (app cons 'b (app cons 'x (app nil))))
    (-> (app cons 5 (app nil)) <-)))
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
      (app cons 5 (app nil)))))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil))))
   (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'b <-) (app cons 'x (app nil)))
   (app cons 'b (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'x <-) (app cons 'x (app nil)))
   (app cons 'x (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'x <-) (app cons 'x (app nil)))
   (app cons 'x (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 3 <-) (app cons 'x (app cons 'x (app nil))))
   (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 5 <-) (app nil)) (app cons 5 (-> (app nil) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store:
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
  (env (())))
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
     (app nil)))
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
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons 'b (-> (app cons 'x (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
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
  (env (())))
clos/con:
	'((con
   cons
   (app
    cons
    (-> '/ <-)
    (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil))))
   (app
    cons
    '/
    (->
     (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil)))
     <-)))
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (-> (app nil) <-))
  (env (())))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  (app error (-> (app #f) <-) "No derivation method available")
  (env (())))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
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

'(store:
  (app
   cons
   (-> a <-)
   (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil)))
  (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: (app cons (-> (app caddr a) <-) (app nil)) (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: pair? (env ()))
clos/con:
	'((letrec* (... map (pair? (-> (λ (pair?-v) ...) <-)) deriv ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons (app deriv (app caddr a)) (-> (app nil) <-)) (env (())))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons (-> (app deriv a) <-) (app cons a (app nil))) (env (() ())))
clos/con:
	'((con
   cons
   (app
    cons
    (-> '* <-)
    (app
     cons
     a
     (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
   (app
    cons
    '*
    (->
     (app
      cons
      a
      (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil)))
     <-)))
  (env (())))
	'((con
   cons
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
  (env (())))
	'((con
   cons
   (app cons (-> '+ <-) (app map deriv (app cdr a)))
   (app cons '+ (-> (app map deriv (app cdr a)) <-)))
  (env (())))
	'((con
   cons
   (app cons (-> '- <-) (app map deriv (app cdr a)))
   (app cons '- (-> (app map deriv (app cdr a)) <-)))
  (env (())))
	'((con
   error
   (app error (-> (app #f) <-) "No derivation method available")
   (app error (app #f) (-> "No derivation method available" <-)))
  (env (())))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: (app cons (-> '+ <-) (app map deriv (app cdr a))) (env (())))
clos/con:
	'((app cons (-> '+ <-) (app map deriv (app cdr a))) (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
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
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil))))
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

'(store: (app cons 'x (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  (app cons (-> (app cons '+ (app map (λ (a) ...) (app cdr a))) <-) (app nil))
  (env (())))
clos/con:
	'((con
   cons
   (app cons (-> '+ <-) (app map (λ (a) ...) (app cdr a)))
   (app cons '+ (-> (app map (λ (a) ...) (app cdr a)) <-)))
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  (app
   cons
   (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
   (app cons 5 (app nil)))
  (env ()))
clos/con:
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
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
  (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: (app cons (-> (app map-f map-c) <-) (app map map-f map-d)) (env (())))
clos/con:
	'((con
   cons
   (app
    cons
    (-> '* <-)
    (app
     cons
     a
     (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
   (app
    cons
    '*
    (->
     (app
      cons
      a
      (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil)))
     <-)))
  (env (())))
	'((con
   cons
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
  (env (())))
	'((con
   cons
   (app cons (-> '+ <-) (app map deriv (app cdr a)))
   (app cons '+ (-> (app map deriv (app cdr a)) <-)))
  (env (())))
	'((con
   cons
   (app cons (-> '- <-) (app map deriv (app cdr a)))
   (app cons '- (-> (app map deriv (app cdr a)) <-)))
  (env (())))
	'((con
   cons
   (app cons (-> '/ <-) (app cons (app deriv a) (app cons a (app nil))))
   (app cons '/ (-> (app cons (app deriv a) (app cons a (app nil))) <-)))
  (env (() ())))
	'((con
   error
   (app error (-> (app #f) <-) "No derivation method available")
   (app error (app #f) (-> "No derivation method available" <-)))
  (env (())))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: (app cons (app deriv a) (-> (app cons a (app nil)) <-)) (env (() ())))
clos/con:
	'((con cons (app cons (-> a <-) (app nil)) (app cons a (-> (app nil) <-)))
  (env (() ())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: pair?-d (env (())))
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
      (app cons 5 (app nil)))))
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
   (app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil))))
   (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'b <-) (app cons 'x (app nil)))
   (app cons 'b (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 3 <-) (app cons 'x (app cons 'x (app nil))))
   (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
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
  (env (())))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons '- (-> (app map deriv (app cdr a)) <-)) (env (())))
clos/con:
	'((con
   cons
   (app cons (-> (app map-f map-c) <-) (app map map-f map-d))
   (app cons (app map-f map-c) (-> (app map map-f map-d) <-)))
  (env (())))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: deriv (env ()))
clos/con:
	'((letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
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
  (env (())))
clos/con:
	'((con
   cons
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
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons 'x (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: cdr-v (env (())))
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
     (app cons 5 (app nil))))
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
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil)))
   (app
    cons
    (app cons '* (app cons 'b (app cons 'x (app nil))))
    (-> (app cons 5 (app nil)) <-)))
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
      (app cons 5 (app nil)))))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil))))
   (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'b <-) (app cons 'x (app nil)))
   (app cons 'b (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'x <-) (app cons 'x (app nil)))
   (app cons 'x (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'x <-) (app cons 'x (app nil)))
   (app cons 'x (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 3 <-) (app cons 'x (app cons 'x (app nil))))
   (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 5 <-) (app nil)) (app cons 5 (-> (app nil) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store:
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
  (env (())))
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
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  (app
   cons
   (-> '* <-)
   (app
    cons
    a
    (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
  (env (())))
clos/con:
	'((app
   cons
   (-> '* <-)
   (app
    cons
    a
    (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
clos/con:
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons 5 (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  (app error (app #f) (-> "No derivation method available" <-))
  (env (())))
clos/con: ⊥
literals: '(⊥ ⊥ ⊥ "No derivation method available")

'(store: cdr-c (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store:
  (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-))
  (env ()))
clos/con:
	'((con
   cons
   (app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil))))
   (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: car-d (env (())))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil))))
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
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil)))
   (app
    cons
    (app cons '* (app cons 'b (app cons 'x (app nil))))
    (-> (app cons 5 (app nil)) <-)))
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
      (app cons 5 (app nil)))))
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
   (app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil))))
   (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'b <-) (app cons 'x (app nil)))
   (app cons 'b (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'x <-) (app cons 'x (app nil)))
   (app cons 'x (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'x <-) (app cons 'x (app nil)))
   (app cons 'x (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 3 <-) (app cons 'x (app cons 'x (app nil))))
   (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 5 <-) (app nil)) (app cons 5 (-> (app nil) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  (app
   cons
   (-> '/ <-)
   (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil))))
  (env (())))
clos/con:
	'((app
   cons
   (-> '/ <-)
   (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil))))
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  (app
   cons
   '/
   (->
    (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil)))
    <-))
  (env (())))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app deriv (app cadr a)) <-)
    (app cons (app caddr a) (app nil)))
   (app
    cons
    (app deriv (app cadr a))
    (-> (app cons (app caddr a) (app nil)) <-)))
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons (-> 'x <-) (app nil)) (env ()))
clos/con:
	'((app cons (-> 'x <-) (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: pair?-c (env (())))
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
  (app
   cons
   (-> (app caddr a) <-)
   (app cons (app deriv (app caddr a)) (app nil)))
  (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store:
  (app
   cons
   '*
   (->
    (app
     cons
     (app caddr a)
     (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil))))
    <-))
  (env (())))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app caddr a) <-)
    (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil))))
   (app
    cons
    (app caddr a)
    (->
     (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))
     <-)))
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: map (env ()))
clos/con:
	'((letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) pair? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons a (-> (app nil) <-)) (env (() ())))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  (app
   cons
   (app deriv (app cadr a))
   (-> (app cons (app caddr a) (app nil)) <-))
  (env (())))
clos/con:
	'((con
   cons
   (app cons (-> (app caddr a) <-) (app nil))
   (app cons (app caddr a) (-> (app nil) <-)))
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  (app
   cons
   a
   (->
    (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))
    <-))
  (env (())))
clos/con:
	'((con
   cons
   (app cons (-> (app cons '+ (app map (λ (a) ...) (app cdr a))) <-) (app nil))
   (app
    cons
    (app cons '+ (app map (λ (a) ...) (app cdr a)))
    (-> (app nil) <-)))
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: pair?-v (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store:
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
  (env (())))
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
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: cadr-v (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: (app cons (-> 5 <-) (app nil)) (env ()))
clos/con: ⊥
literals: '(5 ⊥ ⊥ ⊥)

'(store:
  (app
   cons
   (app caddr a)
   (-> (app cons (app deriv (app caddr a)) (app nil)) <-))
  (env (())))
clos/con:
	'((con
   cons
   (app cons (-> (app deriv (app caddr a)) <-) (app nil))
   (app cons (app deriv (app caddr a)) (-> (app nil) <-)))
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: caddr (env ()))
clos/con:
	'((letrec* (... cadr (caddr (-> (λ (cadr-v) ...) <-)) map ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)) (env ()))
clos/con:
	'((con
   cons
   (app cons (-> 'x <-) (app cons 'x (app nil)))
   (app cons 'x (-> (app cons 'x (app nil)) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons (-> '+ <-) (app map (λ (a) ...) (app cdr a))) (env (())))
clos/con:
	'((app cons (-> '+ <-) (app map (λ (a) ...) (app cdr a))) (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
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
  (env (())))
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
    (app nil))
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
    (-> (app nil) <-)))
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: car-c (env (())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store:
  (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
clos/con:
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons (-> 'x <-) (app nil)) (env ()))
clos/con:
	'((app cons (-> 'x <-) (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  (app
   cons
   (app cons '* (app cons 'b (app cons 'x (app nil))))
   (-> (app cons 5 (app nil)) <-))
  (env ()))
clos/con:
	'((con cons (app cons (-> 5 <-) (app nil)) (app cons 5 (-> (app nil) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons (-> 3 <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
clos/con: ⊥
literals: '(3 ⊥ ⊥ ⊥)

'(store:
  (app cons (-> '/ <-) (app cons (app deriv a) (app cons a (app nil))))
  (env (() ())))
clos/con:
	'((app cons (-> '/ <-) (app cons (app deriv a) (app cons a (app nil))))
  (env (() ())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: car (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
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
  (env (())))
clos/con:
	'((con
   cons
   (app
    cons
    (-> '* <-)
    (app
     cons
     (app caddr a)
     (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))))
   (app
    cons
    '*
    (->
     (app
      cons
      (app caddr a)
      (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil))))
     <-)))
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: a (env (() ())))
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
   (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
   (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: cdr-d (env (())))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil))))) <-)
    (app
     cons
     (app cons '* (app cons 'b (app cons 'x (app nil))))
     (app cons 5 (app nil))))
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
    (-> (app cons '* (app cons 'b (app cons 'x (app nil)))) <-)
    (app cons 5 (app nil)))
   (app
    cons
    (app cons '* (app cons 'b (app cons 'x (app nil))))
    (-> (app cons 5 (app nil)) <-)))
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
      (app cons 5 (app nil)))))
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
   (app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil))))
   (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'b <-) (app cons 'x (app nil)))
   (app cons 'b (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'x <-) (app cons 'x (app nil)))
   (app cons 'x (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 'x <-) (app cons 'x (app nil)))
   (app cons 'x (-> (app cons 'x (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> 3 <-) (app cons 'x (app cons 'x (app nil))))
   (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 'x <-) (app nil)) (app cons 'x (-> (app nil) <-)))
  (env ()))
	'((con cons (app cons (-> 5 <-) (app nil)) (app cons 5 (-> (app nil) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons (-> (app deriv (app caddr a)) <-) (app nil)) (env (())))
clos/con:
	'((con
   cons
   (app
    cons
    (-> '* <-)
    (app
     cons
     a
     (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
   (app
    cons
    '*
    (->
     (app
      cons
      a
      (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil)))
     <-)))
  (env (())))
	'((con
   cons
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
  (env (())))
	'((con
   cons
   (app cons (-> '+ <-) (app map deriv (app cdr a)))
   (app cons '+ (-> (app map deriv (app cdr a)) <-)))
  (env (())))
	'((con
   cons
   (app cons (-> '- <-) (app map deriv (app cdr a)))
   (app cons '- (-> (app map deriv (app cdr a)) <-)))
  (env (())))
	'((con
   error
   (app error (-> (app #f) <-) "No derivation method available")
   (app error (app #f) (-> "No derivation method available" <-)))
  (env (())))
literals: '(⊤ ⊥ ⊥ ⊥)

'(store:
  (app
   cons
   (-> '* <-)
   (app
    cons
    (app caddr a)
    (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))))
  (env (())))
clos/con:
	'((app
   cons
   (-> '* <-)
   (app
    cons
    (app caddr a)
    (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))))
  (env (())))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
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
  (env (())))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: _ (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(store: (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)) (env ()))
clos/con:
	'((con
   cons
   (app cons (-> 'x <-) (app cons 'x (app nil)))
   (app cons 'x (-> (app cons 'x (app nil)) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)
