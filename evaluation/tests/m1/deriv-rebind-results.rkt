'(expression:
  (lettypes
   ((cons car cdr) (nil) (error r))
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
   cons
   '*
   (->
    (app
     cons
     (app caddr a)
     (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil))))
    <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

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
  (env
   ((letrec*
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
      <-)))))
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
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

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
  (env
   ((letrec*
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
      <-)))))
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
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

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
literals: '(⊥ ⊥ ⊥)

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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

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
  (env
   ((letrec*
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
      <-)))))
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
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

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
  (env
   ((letrec*
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
      <-)))))
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
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   '/
   (->
    (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil)))
    <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((con
   cons
   (app
    cons
    '/
    (->
     (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil)))
     <-)))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   '/
   (->
    (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil)))
    <-))
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con
   cons
   (app
    cons
    '/
    (->
     (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil)))
     <-)))
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   '/
   (->
    (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil)))
    <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((con
   cons
   (app
    cons
    '/
    (->
     (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil)))
     <-)))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   '/
   (->
    (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil)))
    <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((con
   cons
   (app
    cons
    '/
    (->
     (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil)))
     <-)))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   '/
   (->
    (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil)))
    <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con
   cons
   (app
    cons
    '/
    (->
     (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil)))
     <-)))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

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
  (env
   ((letrec*
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
      <-)))))
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
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

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
  (env
   ((letrec*
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
      <-)))))
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
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

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
  (env
   ((letrec*
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
      <-)))))
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
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> (app caddr a) <-)
   (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil))))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> (app caddr a) <-)
   (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil))))
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> (app caddr a) <-)
   (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil))))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> (app caddr a) <-)
   (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil))))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> (app caddr a) <-)
   (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil))))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> (app caddr a) <-)
   (app cons (app deriv (app caddr a)) (app nil)))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> (app caddr a) <-)
   (app cons (app deriv (app caddr a)) (app nil)))
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> (app caddr a) <-)
   (app cons (app deriv (app caddr a)) (app nil)))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> (app caddr a) <-)
   (app cons (app deriv (app caddr a)) (app nil)))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> (app caddr a) <-)
   (app cons (app deriv (app caddr a)) (app nil)))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

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
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

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
literals: '(⊥ ⊥ ⊥)

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
literals: '(⊥ ⊥ ⊥)

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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> (app deriv (app cadr a)) <-)
   (app cons (app caddr a) (app nil)))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app
   cons
   (-> (app deriv (app cadr a)) <-)
   (app cons (app caddr a) (app nil)))
  (env
   ((letrec*
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
      <-)))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app
   cons
   (-> (app deriv (app cadr a)) <-)
   (app cons (app caddr a) (app nil)))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app
   cons
   (-> (app deriv (app cadr a)) <-)
   (app cons (app caddr a) (app nil)))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app
   cons
   (-> (app deriv (app cadr a)) <-)
   (app cons (app caddr a) (app nil)))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app
   cons
   (-> a <-)
   (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil)))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

'(query:
  (app
   cons
   (-> a <-)
   (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil)))
  (env
   ((letrec*
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
      <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> a <-)
   (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil)))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> a <-)
   (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil)))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (app
   cons
   (-> a <-)
   (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil)))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
literals: '(⊤ ⊥ ⊥)

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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

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
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

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
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

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
  (env
   ((letrec*
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
      <-)))))
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
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (app caddr a)
   (->
    (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))
    <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((con
   cons
   (app
    cons
    (app caddr a)
    (->
     (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))
     <-)))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (app caddr a)
   (->
    (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))
    <-))
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con
   cons
   (app
    cons
    (app caddr a)
    (->
     (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))
     <-)))
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (app caddr a)
   (->
    (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))
    <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((con
   cons
   (app
    cons
    (app caddr a)
    (->
     (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))
     <-)))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (app caddr a)
   (->
    (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))
    <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((con
   cons
   (app
    cons
    (app caddr a)
    (->
     (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))
     <-)))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (app caddr a)
   (->
    (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))
    <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con
   cons
   (app
    cons
    (app caddr a)
    (->
     (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))
     <-)))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (app caddr a)
   (-> (app cons (app deriv (app caddr a)) (app nil)) <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((con
   cons
   (app
    cons
    (app caddr a)
    (-> (app cons (app deriv (app caddr a)) (app nil)) <-)))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (app caddr a)
   (-> (app cons (app deriv (app caddr a)) (app nil)) <-))
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con
   cons
   (app
    cons
    (app caddr a)
    (-> (app cons (app deriv (app caddr a)) (app nil)) <-)))
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (app caddr a)
   (-> (app cons (app deriv (app caddr a)) (app nil)) <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((con
   cons
   (app
    cons
    (app caddr a)
    (-> (app cons (app deriv (app caddr a)) (app nil)) <-)))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (app caddr a)
   (-> (app cons (app deriv (app caddr a)) (app nil)) <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((con
   cons
   (app
    cons
    (app caddr a)
    (-> (app cons (app deriv (app caddr a)) (app nil)) <-)))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (app caddr a)
   (-> (app cons (app deriv (app caddr a)) (app nil)) <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con
   cons
   (app
    cons
    (app caddr a)
    (-> (app cons (app deriv (app caddr a)) (app nil)) <-)))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

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
  (env
   ((letrec*
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
      <-)))))
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
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

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
literals: '(⊥ ⊥ ⊥)

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
literals: '(⊥ ⊥ ⊥)

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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (app deriv (app cadr a))
   (-> (app cons (app caddr a) (app nil)) <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((con
   cons
   (app
    cons
    (app deriv (app cadr a))
    (-> (app cons (app caddr a) (app nil)) <-)))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (app deriv (app cadr a))
   (-> (app cons (app caddr a) (app nil)) <-))
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con
   cons
   (app
    cons
    (app deriv (app cadr a))
    (-> (app cons (app caddr a) (app nil)) <-)))
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (app deriv (app cadr a))
   (-> (app cons (app caddr a) (app nil)) <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((con
   cons
   (app
    cons
    (app deriv (app cadr a))
    (-> (app cons (app caddr a) (app nil)) <-)))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (app deriv (app cadr a))
   (-> (app cons (app caddr a) (app nil)) <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((con
   cons
   (app
    cons
    (app deriv (app cadr a))
    (-> (app cons (app caddr a) (app nil)) <-)))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (app deriv (app cadr a))
   (-> (app cons (app caddr a) (app nil)) <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con
   cons
   (app
    cons
    (app deriv (app cadr a))
    (-> (app cons (app caddr a) (app nil)) <-)))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   a
   (->
    (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))
    <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((con
   cons
   (app
    cons
    a
    (->
     (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))
     <-)))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   a
   (->
    (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))
    <-))
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con
   cons
   (app
    cons
    a
    (->
     (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))
     <-)))
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   a
   (->
    (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))
    <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((con
   cons
   (app
    cons
    a
    (->
     (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))
     <-)))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   a
   (->
    (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))
    <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((con
   cons
   (app
    cons
    a
    (->
     (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))
     <-)))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   a
   (->
    (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))
    <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con
   cons
   (app
    cons
    a
    (->
     (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))
     <-)))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> map-f <-) map-c)
  (env ((app cons '+ (-> (app map (λ (a) ...) (app cdr a)) <-)))))
clos/con:
	'((app map (-> (λ (a) ...) <-) (app cdr a))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((app map (-> (λ (a) ...) <-) (app cdr a))
  (env
   ((letrec*
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
      <-)))))
	'((app map (-> (λ (a) ...) <-) (app cdr a))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((app map (-> (λ (a) ...) <-) (app cdr a))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
	'((app map (-> (λ (a) ...) <-) (app cdr a))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> map-f <-) map-c)
  (env ((app cons '+ (-> (app map deriv (app cdr a)) <-)))))
clos/con:
	'((letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> map-f <-) map-c)
  (env ((app cons '- (-> (app map deriv (app cdr a)) <-)))))
clos/con:
	'((letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> map-f <-) map-c)
  (env ((app cons (app map-f map-c) (-> (app map map-f map-d) <-)))))
clos/con:
	'((app map (-> (λ (a) ...) <-) (app cdr a))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((app map (-> (λ (a) ...) <-) (app cdr a))
  (env
   ((letrec*
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
      <-)))))
	'((app map (-> (λ (a) ...) <-) (app cdr a))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((app map (-> (λ (a) ...) <-) (app cdr a))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
	'((app map (-> (λ (a) ...) <-) (app cdr a))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
	'((letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app caddr (-> a <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

'(query:
  (app caddr (-> a <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

'(query:
  (app caddr (-> a <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

'(query:
  (app caddr (-> a <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

'(query:
  (app caddr (-> a <-))
  (env
   ((letrec*
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
      <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app caddr (-> a <-))
  (env
   ((letrec*
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
      <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app caddr (-> a <-))
  (env
   ((letrec*
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
      <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app caddr (-> a <-))
  (env
   ((letrec*
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
      <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app caddr (-> a <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app caddr (-> a <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app caddr (-> a <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app caddr (-> a <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app caddr (-> a <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (app caddr (-> a <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (app caddr (-> a <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (app caddr (-> a <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (app caddr (-> a <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (app caddr (-> a <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (app caddr (-> a <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (app caddr (-> a <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (app cadr (-> a <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

'(query:
  (app cadr (-> a <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

'(query:
  (app cadr (-> a <-))
  (env
   ((letrec*
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
      <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cadr (-> a <-))
  (env
   ((letrec*
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
      <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cadr (-> a <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cadr (-> a <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cadr (-> a <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (app cadr (-> a <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (app cadr (-> a <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (app cadr (-> a <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (app car (-> (app cdr (app cdr cadr-v)) <-))
  (env
   ((app
     cons
     (-> (app caddr a) <-)
     (app
      cons
      (app caddr a)
      (app cons (app deriv (app caddr a)) (app nil)))))))
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
	'((con cons (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'b (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app car (-> (app cdr (app cdr cadr-v)) <-))
  (env
   ((app
     cons
     (-> (app caddr a) <-)
     (app cons (app deriv (app caddr a)) (app nil))))))
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
	'((con cons (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'b (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app car (-> (app cdr (app cdr cadr-v)) <-))
  (env ((app cons (-> (app caddr a) <-) (app nil)))))
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
	'((con cons (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'b (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app car (-> (app cdr (app cdr cadr-v)) <-))
  (env ((app deriv (-> (app caddr a) <-)))))
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
	'((con cons (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'b (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app car (-> (app cdr cadr-v) <-))
  (env
   ((app
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
      (app nil))))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app car (-> (app cdr cadr-v) <-))
  (env ((app deriv (-> (app cadr a) <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app car (-> a <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

'(query:
  (app car (-> a <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

'(query:
  (app car (-> a <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

'(query:
  (app car (-> a <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

'(query:
  (app car (-> a <-))
  (env
   ((letrec*
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
      <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app car (-> a <-))
  (env
   ((letrec*
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
      <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app car (-> a <-))
  (env
   ((letrec*
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
      <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app car (-> a <-))
  (env
   ((letrec*
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
      <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app car (-> a <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app car (-> a <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app car (-> a <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app car (-> a <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app car (-> a <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (app car (-> a <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (app car (-> a <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (app car (-> a <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (app car (-> a <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (app car (-> a <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (app car (-> a <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (app car (-> a <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (app cdr (-> (app cdr cadr-v) <-))
  (env
   ((app
     cons
     (-> (app caddr a) <-)
     (app
      cons
      (app caddr a)
      (app cons (app deriv (app caddr a)) (app nil)))))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cdr (-> (app cdr cadr-v) <-))
  (env
   ((app
     cons
     (-> (app caddr a) <-)
     (app cons (app deriv (app caddr a)) (app nil))))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cdr (-> (app cdr cadr-v) <-))
  (env ((app cons (-> (app caddr a) <-) (app nil)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cdr (-> (app cdr cadr-v) <-))
  (env ((app deriv (-> (app caddr a) <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cdr (-> a <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

'(query:
  (app cdr (-> a <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

'(query:
  (app cdr (-> a <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

'(query:
  (app cdr (-> a <-))
  (env
   ((letrec*
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
      <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cdr (-> a <-))
  (env
   ((letrec*
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
      <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cdr (-> a <-))
  (env
   ((letrec*
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
      <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cdr (-> a <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cdr (-> a <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cdr (-> a <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cdr (-> a <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (app cdr (-> a <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (app cdr (-> a <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (app cdr (-> a <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (app cdr (-> a <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (app cdr (-> a <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (app cdr (-> cadr-v <-))
  (env
   ((app
     cons
     (-> (app caddr a) <-)
     (app
      cons
      (app caddr a)
      (app cons (app deriv (app caddr a)) (app nil)))))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (app cdr (-> cadr-v <-))
  (env
   ((app
     cons
     (-> (app caddr a) <-)
     (app cons (app deriv (app caddr a)) (app nil))))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (app cdr (-> cadr-v <-))
  (env
   ((app
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
      (app nil))))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (app cdr (-> cadr-v <-))
  (env ((app cons (-> (app caddr a) <-) (app nil)))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-))
  (env ()))
clos/con:
	'((con
   cons
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-))
  (env ()))
clos/con:
	'((con
   cons
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons '+ (-> (app map (λ (a) ...) (app cdr a)) <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons '+ (-> (app map (λ (a) ...) (app cdr a)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons '+ (-> (app map (λ (a) ...) (app cdr a)) <-))
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons '+ (-> (app map (λ (a) ...) (app cdr a)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons '+ (-> (app map (λ (a) ...) (app cdr a)) <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons '+ (-> (app map (λ (a) ...) (app cdr a)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons '+ (-> (app map (λ (a) ...) (app cdr a)) <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons '+ (-> (app map (λ (a) ...) (app cdr a)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons '+ (-> (app map (λ (a) ...) (app cdr a)) <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons '+ (-> (app map (λ (a) ...) (app cdr a)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons '+ (-> (app map deriv (app cdr a)) <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons '+ (-> (app map deriv (app cdr a)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons '+ (-> (app map deriv (app cdr a)) <-))
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons '+ (-> (app map deriv (app cdr a)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons '+ (-> (app map deriv (app cdr a)) <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons '+ (-> (app map deriv (app cdr a)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons '+ (-> (app map deriv (app cdr a)) <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons '+ (-> (app map deriv (app cdr a)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons '+ (-> (app map deriv (app cdr a)) <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons '+ (-> (app map deriv (app cdr a)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons '- (-> (app map deriv (app cdr a)) <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons '- (-> (app map deriv (app cdr a)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons '- (-> (app map deriv (app cdr a)) <-))
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons '- (-> (app map deriv (app cdr a)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons '- (-> (app map deriv (app cdr a)) <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons '- (-> (app map deriv (app cdr a)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons '- (-> (app map deriv (app cdr a)) <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons '- (-> (app map deriv (app cdr a)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons '- (-> (app map deriv (app cdr a)) <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons '- (-> (app map deriv (app cdr a)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons '/ (-> (app cons (app deriv a) (app cons a (app nil))) <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con
   cons
   (app cons '/ (-> (app cons (app deriv a) (app cons a (app nil))) <-)))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> (app caddr a) <-) (app nil))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> (app caddr a) <-) (app nil))
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> (app caddr a) <-) (app nil))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> (app caddr a) <-) (app nil))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> (app caddr a) <-) (app nil))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> (app cons '+ (app map (λ (a) ...) (app cdr a))) <-) (app nil))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons '+ (app map (λ (a) ...) (app cdr a))) <-)
    (app nil)))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> (app cons '+ (app map (λ (a) ...) (app cdr a))) <-) (app nil))
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons '+ (app map (λ (a) ...) (app cdr a))) <-)
    (app nil)))
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> (app cons '+ (app map (λ (a) ...) (app cdr a))) <-) (app nil))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons '+ (app map (λ (a) ...) (app cdr a))) <-)
    (app nil)))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> (app cons '+ (app map (λ (a) ...) (app cdr a))) <-) (app nil))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons '+ (app map (λ (a) ...) (app cdr a))) <-)
    (app nil)))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> (app cons '+ (app map (λ (a) ...) (app cdr a))) <-) (app nil))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons '+ (app map (λ (a) ...) (app cdr a))) <-)
    (app nil)))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> (app deriv (app caddr a)) <-) (app nil))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app cons (-> (app deriv (app caddr a)) <-) (app nil))
  (env
   ((letrec*
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
      <-)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app cons (-> (app deriv (app caddr a)) <-) (app nil))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app cons (-> (app deriv (app caddr a)) <-) (app nil))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app cons (-> (app deriv (app caddr a)) <-) (app nil))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app cons (-> (app deriv a) <-) (app cons a (app nil)))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app cons (-> (app map-f map-c) <-) (app map map-f map-d))
  (env ((app cons '+ (-> (app map (λ (a) ...) (app cdr a)) <-)))))
clos/con:
	'((con
   cons
   (λ (a)
     (-> (app cons '/ (app cons (app deriv a) (app cons a (app nil)))) <-)))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> (app map-f map-c) <-) (app map map-f map-d))
  (env ((app cons '+ (-> (app map deriv (app cdr a)) <-)))))
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app cons (-> (app map-f map-c) <-) (app map map-f map-d))
  (env ((app cons '- (-> (app map deriv (app cdr a)) <-)))))
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app cons (-> (app map-f map-c) <-) (app map map-f map-d))
  (env ((app cons (app map-f map-c) (-> (app map map-f map-d) <-)))))
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
	'((con
   cons
   (λ (a)
     (-> (app cons '/ (app cons (app deriv a) (app cons a (app nil)))) <-)))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (app cons (-> a <-) (app nil))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (app cons (app caddr a) (-> (app nil) <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (app caddr a) (-> (app nil) <-))
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (app caddr a) (-> (app nil) <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (app caddr a) (-> (app nil) <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (app caddr a) (-> (app nil) <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (-> (app nil) <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (-> (app nil) <-))
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (-> (app nil) <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (-> (app nil) <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (-> (app nil) <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (app deriv (app caddr a)) (-> (app nil) <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (app deriv (app caddr a)) (-> (app nil) <-))
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (app deriv (app caddr a)) (-> (app nil) <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (app deriv (app caddr a)) (-> (app nil) <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (app deriv (app caddr a)) (-> (app nil) <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (app deriv a) (-> (app cons a (app nil)) <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con cons (app cons (app deriv a) (-> (app cons a (app nil)) <-)))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (app map-f map-c) (-> (app map map-f map-d) <-))
  (env ((app cons '+ (-> (app map (λ (a) ...) (app cdr a)) <-)))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons (app map-f map-c) (-> (app map map-f map-d) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (app map-f map-c) (-> (app map map-f map-d) <-))
  (env ((app cons '+ (-> (app map deriv (app cdr a)) <-)))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons (app map-f map-c) (-> (app map map-f map-d) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (app map-f map-c) (-> (app map map-f map-d) <-))
  (env ((app cons '- (-> (app map deriv (app cdr a)) <-)))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons (app map-f map-c) (-> (app map map-f map-d) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (app map-f map-c) (-> (app map map-f map-d) <-))
  (env ((app cons (app map-f map-c) (-> (app map map-f map-d) <-)))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons (app map-f map-c) (-> (app map map-f map-d) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons a (-> (app nil) <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app deriv (-> (app caddr a) <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app deriv (-> (app caddr a) <-))
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app deriv (-> (app caddr a) <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app deriv (-> (app caddr a) <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app deriv (-> (app caddr a) <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app deriv (-> (app cadr a) <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

'(query:
  (app deriv (-> (app cadr a) <-))
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

'(query:
  (app deriv (-> (app cadr a) <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

'(query:
  (app deriv (-> (app cadr a) <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

'(query:
  (app deriv (-> (app cadr a) <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

'(query:
  (app deriv (-> a <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (app eq? (-> (app car a) <-) '*)
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> (app car a) <-) '*)
  (env
   ((letrec*
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
      <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> (app car a) <-) '*)
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> (app car a) <-) '*)
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> (app car a) <-) '*)
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> (app car a) <-) '+)
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> (app car a) <-) '+)
  (env
   ((letrec*
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
      <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> (app car a) <-) '+)
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> (app car a) <-) '+)
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> (app car a) <-) '+)
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> (app car a) <-) '-)
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> (app car a) <-) '-)
  (env
   ((letrec*
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
      <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> (app car a) <-) '-)
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> (app car a) <-) '-)
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> (app car a) <-) '-)
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> (app car a) <-) '/)
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> (app car a) <-) '/)
  (env
   ((letrec*
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
      <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> (app car a) <-) '/)
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> (app car a) <-) '/)
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> (app car a) <-) '/)
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> a <-) 'x)
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

'(query:
  (app eq? (-> a <-) 'x)
  (env
   ((letrec*
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
      <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> a <-) 'x)
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> a <-) 'x)
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (app eq? (-> a <-) 'x)
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (app error (-> (app #f) <-) "No derivation method available")
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app error (-> (app #f) <-) "No derivation method available")
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app error (-> (app #f) <-) "No derivation method available")
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app error (-> (app #f) <-) "No derivation method available")
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app error (-> (app #f) <-) "No derivation method available")
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app map (-> map-f <-) map-d)
  (env ((app cons '+ (-> (app map (λ (a) ...) (app cdr a)) <-)))))
clos/con:
	'((app map (-> (λ (a) ...) <-) (app cdr a))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((app map (-> (λ (a) ...) <-) (app cdr a))
  (env
   ((letrec*
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
      <-)))))
	'((app map (-> (λ (a) ...) <-) (app cdr a))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((app map (-> (λ (a) ...) <-) (app cdr a))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
	'((app map (-> (λ (a) ...) <-) (app cdr a))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app map (-> map-f <-) map-d)
  (env ((app cons '+ (-> (app map deriv (app cdr a)) <-)))))
clos/con:
	'((letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app map (-> map-f <-) map-d)
  (env ((app cons '- (-> (app map deriv (app cdr a)) <-)))))
clos/con:
	'((letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app map (-> map-f <-) map-d)
  (env ((app cons (app map-f map-c) (-> (app map map-f map-d) <-)))))
clos/con:
	'((app map (-> (λ (a) ...) <-) (app cdr a))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((app map (-> (λ (a) ...) <-) (app cdr a))
  (env
   ((letrec*
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
      <-)))))
	'((app map (-> (λ (a) ...) <-) (app cdr a))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((app map (-> (λ (a) ...) <-) (app cdr a))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
	'((app map (-> (λ (a) ...) <-) (app cdr a))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
	'((letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app map (λ (a) ...) (-> (app cdr a) <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app map (λ (a) ...) (-> (app cdr a) <-))
  (env
   ((letrec*
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
      <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app map (λ (a) ...) (-> (app cdr a) <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app map (λ (a) ...) (-> (app cdr a) <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app map (λ (a) ...) (-> (app cdr a) <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app map deriv (-> (app cdr a) <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app map deriv (-> (app cdr a) <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app map deriv (-> (app cdr a) <-))
  (env
   ((letrec*
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
      <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app map deriv (-> (app cdr a) <-))
  (env
   ((letrec*
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
      <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app map deriv (-> (app cdr a) <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app map deriv (-> (app cdr a) <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app map deriv (-> (app cdr a) <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app map deriv (-> (app cdr a) <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app map deriv (-> (app cdr a) <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app map deriv (-> (app cdr a) <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app map map-f (-> map-d <-))
  (env ((app cons '+ (-> (app map (λ (a) ...) (app cdr a)) <-)))))
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
	'((con cons (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'b (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app map map-f (-> map-d <-))
  (env ((app cons '+ (-> (app map deriv (app cdr a)) <-)))))
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
	'((con cons (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'b (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app map map-f (-> map-d <-))
  (env ((app cons '- (-> (app map deriv (app cdr a)) <-)))))
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
	'((con cons (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'b (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app map map-f (-> map-d <-))
  (env ((app cons (app map-f map-c) (-> (app map map-f map-d) <-)))))
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
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app map-f (-> map-c <-))
  (env ((app cons '+ (-> (app map (λ (a) ...) (app cdr a)) <-)))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

'(query:
  (app map-f (-> map-c <-))
  (env ((app cons '+ (-> (app map deriv (app cdr a)) <-)))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

'(query:
  (app map-f (-> map-c <-))
  (env ((app cons '- (-> (app map deriv (app cdr a)) <-)))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

'(query:
  (app map-f (-> map-c <-))
  (env ((app cons (app map-f map-c) (-> (app map map-f map-d) <-)))))
clos/con:
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
literals: '(5 ⊥ ⊥)

'(query:
  (app not (-> (app pair? a) <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app not (-> (app pair? a) <-))
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app not (-> (app pair? a) <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app not (-> (app pair? a) <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app not (-> (app pair? a) <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app pair? (-> a <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

'(query:
  (app pair? (-> a <-))
  (env
   ((letrec*
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
      <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app pair? (-> a <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (app pair? (-> a <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (app pair? (-> a <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
literals: '(⊤ ⊥ ⊥)

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
  (env
   ((letrec*
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
      <-)))))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env
   ((letrec*
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
      <-)))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env
   ((letrec*
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
      <-)))))
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
  (env
   ((letrec*
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
      <-)))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env
   ((letrec*
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
      <-)))))
literals: '(⊤ ⊥ ⊥)

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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

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
  (env
   ((letrec*
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
      <-)))))
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
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app eq? (app car a) '*)
   ((#f) (-> (match (app eq? (app car a) '/) ...) <-))
   _)
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app eq? (app car a) '*)
   ((#f) (-> (match (app eq? (app car a) '/) ...) <-))
   _)
  (env
   ((letrec*
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
      <-)))))
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
  (env
   ((letrec*
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
      <-)))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app eq? (app car a) '*)
   ((#f) (-> (match (app eq? (app car a) '/) ...) <-))
   _)
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app eq? (app car a) '*)
   ((#f) (-> (match (app eq? (app car a) '/) ...) <-))
   _)
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app eq? (app car a) '*)
   ((#f) (-> (match (app eq? (app car a) '/) ...) <-))
   _)
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app eq? (app car a) '+)
   (#f)
   (_ (-> (app cons '+ (app map deriv (app cdr a))) <-)))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app eq? (app car a) '+)
   (#f)
   (_ (-> (app cons '+ (app map deriv (app cdr a))) <-)))
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app eq? (app car a) '+)
   (#f)
   (_ (-> (app cons '+ (app map deriv (app cdr a))) <-)))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app eq? (app car a) '+)
   (#f)
   (_ (-> (app cons '+ (app map deriv (app cdr a))) <-)))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app eq? (app car a) '+)
   (#f)
   (_ (-> (app cons '+ (app map deriv (app cdr a))) <-)))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app eq? (app car a) '+)
   ((#f) (-> (match (app eq? (app car a) '-) ...) <-))
   _)
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app eq? (app car a) '+)
   ((#f) (-> (match (app eq? (app car a) '-) ...) <-))
   _)
  (env
   ((letrec*
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
      <-)))))
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
  (env
   ((letrec*
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
      <-)))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env
   ((letrec*
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
      <-)))))
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
  (env
   ((letrec*
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
      <-)))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app eq? (app car a) '+)
   ((#f) (-> (match (app eq? (app car a) '-) ...) <-))
   _)
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app eq? (app car a) '+)
   ((#f) (-> (match (app eq? (app car a) '-) ...) <-))
   _)
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app eq? (app car a) '+)
   ((#f) (-> (match (app eq? (app car a) '-) ...) <-))
   _)
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app eq? (app car a) '-)
   (#f)
   (_ (-> (app cons '- (app map deriv (app cdr a))) <-)))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app eq? (app car a) '-)
   (#f)
   (_ (-> (app cons '- (app map deriv (app cdr a))) <-)))
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app eq? (app car a) '-)
   (#f)
   (_ (-> (app cons '- (app map deriv (app cdr a))) <-)))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app eq? (app car a) '-)
   (#f)
   (_ (-> (app cons '- (app map deriv (app cdr a))) <-)))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app eq? (app car a) '-)
   (#f)
   (_ (-> (app cons '- (app map deriv (app cdr a))) <-)))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app eq? (app car a) '-)
   ((#f) (-> (match (app eq? (app car a) '*) ...) <-))
   _)
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app eq? (app car a) '-)
   ((#f) (-> (match (app eq? (app car a) '*) ...) <-))
   _)
  (env
   ((letrec*
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
      <-)))))
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
  (env
   ((letrec*
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
      <-)))))
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
  (env
   ((letrec*
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
      <-)))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app eq? (app car a) '-)
   ((#f) (-> (match (app eq? (app car a) '*) ...) <-))
   _)
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app eq? (app car a) '-)
   ((#f) (-> (match (app eq? (app car a) '*) ...) <-))
   _)
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app eq? (app car a) '-)
   ((#f) (-> (match (app eq? (app car a) '*) ...) <-))
   _)
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

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
  (env
   ((letrec*
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
      <-)))))
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
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app eq? (app car a) '/)
   ((#f) (-> (app error (app #f) "No derivation method available") <-))
   _)
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app eq? (app car a) '/)
   ((#f) (-> (app error (app #f) "No derivation method available") <-))
   _)
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app eq? (app car a) '/)
   ((#f) (-> (app error (app #f) "No derivation method available") <-))
   _)
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app eq? (app car a) '/)
   ((#f) (-> (app error (app #f) "No derivation method available") <-))
   _)
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app eq? (app car a) '/)
   ((#f) (-> (app error (app #f) "No derivation method available") <-))
   _)
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app not (app pair? a))
   ((#f) (-> (match (app eq? (app car a) '+) ...) <-))
   _)
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app not (app pair? a))
   ((#f) (-> (match (app eq? (app car a) '+) ...) <-))
   _)
  (env
   ((letrec*
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
      <-)))))
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
  (env
   ((letrec*
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
      <-)))))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env
   ((letrec*
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
      <-)))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env
   ((letrec*
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
      <-)))))
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
  (env
   ((letrec*
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
      <-)))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app not (app pair? a))
   ((#f) (-> (match (app eq? (app car a) '+) ...) <-))
   _)
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app not (app pair? a))
   ((#f) (-> (match (app eq? (app car a) '+) ...) <-))
   _)
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app not (app pair? a))
   ((#f) (-> (match (app eq? (app car a) '+) ...) <-))
   _)
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   map-l
   ((cons map-c map-d)
    (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
   (nil))
  (env ((app cons '+ (-> (app map (λ (a) ...) (app cdr a)) <-)))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons '+ (-> (app map (λ (a) ...) (app cdr a)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   map-l
   ((cons map-c map-d)
    (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
   (nil))
  (env ((app cons '+ (-> (app map deriv (app cdr a)) <-)))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons '+ (-> (app map deriv (app cdr a)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   map-l
   ((cons map-c map-d)
    (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
   (nil))
  (env ((app cons '- (-> (app map deriv (app cdr a)) <-)))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons '- (-> (app map deriv (app cdr a)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   map-l
   ((cons map-c map-d)
    (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
   (nil))
  (env ((app cons (app map-f map-c) (-> (app map map-f map-d) <-)))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons (app map-f map-c) (-> (app map map-f map-d) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app eq? (app car a) '*) <-) (#f) _)
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app eq? (app car a) '*) <-) (#f) _)
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app eq? (app car a) '*) <-) (#f) _)
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app eq? (app car a) '*) <-) (#f) _)
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app eq? (app car a) '*) <-) (#f) _)
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app eq? (app car a) '+) <-) (#f) _)
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app eq? (app car a) '+) <-) (#f) _)
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app eq? (app car a) '+) <-) (#f) _)
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app eq? (app car a) '+) <-) (#f) _)
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app eq? (app car a) '+) <-) (#f) _)
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app eq? (app car a) '-) <-) (#f) _)
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app eq? (app car a) '-) <-) (#f) _)
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app eq? (app car a) '-) <-) (#f) _)
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app eq? (app car a) '-) <-) (#f) _)
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app eq? (app car a) '-) <-) (#f) _)
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app eq? (app car a) '/) <-) (#f) _)
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app eq? (app car a) '/) <-) (#f) _)
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app eq? (app car a) '/) <-) (#f) _)
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app eq? (app car a) '/) <-) (#f) _)
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app eq? (app car a) '/) <-) (#f) _)
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app eq? a 'x) <-) (#f) _)
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app eq? a 'x) <-) (#f) _)
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app eq? a 'x) <-) (#f) _)
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app eq? a 'x) <-) (#f) _)
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app eq? a 'x) <-) (#f) _)
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app not (app pair? a)) <-) (#f) _)
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app not (app pair? a)) <-) (#f) _)
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app not (app pair? a)) <-) (#f) _)
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app not (app pair? a)) <-) (#f) _)
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app not (app pair? a)) <-) (#f) _)
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> car-v <-) (cons car-c car-d))
  (env ((app eq? (-> (app car a) <-) '*))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (-> car-v <-) (cons car-c car-d))
  (env ((app eq? (-> (app car a) <-) '+))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (-> car-v <-) (cons car-c car-d))
  (env ((app eq? (-> (app car a) <-) '-))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (-> car-v <-) (cons car-c car-d))
  (env ((app eq? (-> (app car a) <-) '/))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (-> car-v <-) (cons car-c car-d))
  (env ((λ (cadr-v) (-> (app car (app cdr (app cdr cadr-v))) <-)))))
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
	'((con cons (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'b (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> car-v <-) (cons car-c car-d))
  (env ((λ (cadr-v) (-> (app car (app cdr cadr-v)) <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> cdr-v <-) (cons cdr-c cdr-d))
  (env ((app car (-> (app cdr (app cdr cadr-v)) <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> cdr-v <-) (cons cdr-c cdr-d))
  (env ((app car (-> (app cdr cadr-v) <-)))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (-> cdr-v <-) (cons cdr-c cdr-d))
  (env ((app cdr (-> (app cdr cadr-v) <-)))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (-> cdr-v <-) (cons cdr-c cdr-d))
  (env ((app map (λ (a) ...) (-> (app cdr a) <-)))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (-> cdr-v <-) (cons cdr-c cdr-d))
  (env ((app map deriv (-> (app cdr a) <-)))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (-> cdr-v <-) (cons cdr-c cdr-d))
  (env ((app map deriv (-> (app cdr a) <-)))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (-> map-l <-) (cons map-c map-d) (nil))
  (env ((app cons '+ (-> (app map (λ (a) ...) (app cdr a)) <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> map-l <-) (cons map-c map-d) (nil))
  (env ((app cons '+ (-> (app map deriv (app cdr a)) <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> map-l <-) (cons map-c map-d) (nil))
  (env ((app cons '- (-> (app map deriv (app cdr a)) <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> map-l <-) (cons map-c map-d) (nil))
  (env ((app cons (app map-f map-c) (-> (app map map-f map-d) <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> pair?-v <-) (cons pair?-c pair?-d) _)
  (env ((app not (-> (app pair? a) <-)))))
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
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app not (app pair? a)) (#f) (_ (-> (match (app eq? a 'x) ...) <-)))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app not (app pair? a)) (#f) (_ (-> (match (app eq? a 'x) ...) <-)))
  (env
   ((letrec*
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
      <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app not (app pair? a)) (#f) (_ (-> (match (app eq? a 'x) ...) <-)))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app not (app pair? a)) (#f) (_ (-> (match (app eq? a 'x) ...) <-)))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app not (app pair? a)) (#f) (_ (-> (match (app eq? a 'x) ...) <-)))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match car-v ((cons car-c car-d) (-> car-c <-)))
  (env ((app eq? (-> (app car a) <-) '*))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (match car-v ((cons car-c car-d) (-> car-c <-)))
  (env ((app eq? (-> (app car a) <-) '+))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (match car-v ((cons car-c car-d) (-> car-c <-)))
  (env ((app eq? (-> (app car a) <-) '-))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (match car-v ((cons car-c car-d) (-> car-c <-)))
  (env ((app eq? (-> (app car a) <-) '/))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (match car-v ((cons car-c car-d) (-> car-c <-)))
  (env ((λ (cadr-v) (-> (app car (app cdr (app cdr cadr-v))) <-)))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (match car-v ((cons car-c car-d) (-> car-c <-)))
  (env ((λ (cadr-v) (-> (app car (app cdr cadr-v)) <-)))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

'(query:
  (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-)))
  (env ((app car (-> (app cdr (app cdr cadr-v)) <-)))))
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
	'((con cons (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'b (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-)))
  (env ((app car (-> (app cdr cadr-v) <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-)))
  (env ((app cdr (-> (app cdr cadr-v) <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-)))
  (env ((app map (λ (a) ...) (-> (app cdr a) <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-)))
  (env ((app map deriv (-> (app cdr a) <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-)))
  (env ((app map deriv (-> (app cdr a) <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (match map-l (cons map-c map-d) ((nil) (-> (app nil) <-)))
  (env ((app cons (app map-f map-c) (-> (app map map-f map-d) <-)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match pair?-v ((cons pair?-c pair?-d) (-> (app #t) <-)) _)
  (env ((app not (-> (app pair? a) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match pair?-v (cons pair?-c pair?-d) (_ (-> (app #f) <-)))
  (env ((app not (-> (app pair? a) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (a) (-> (app cons '/ (app cons (app deriv a) (app cons a (app nil)))) <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con
   cons
   (λ (a)
     (-> (app cons '/ (app cons (app deriv a) (app cons a (app nil)))) <-)))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (a) (-> (match (app not (app pair? a)) ...) <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (a) (-> (match (app not (app pair? a)) ...) <-))
  (env
   ((letrec*
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
      <-)))))
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
  (env
   ((letrec*
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
      <-)))))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env
   ((letrec*
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
      <-)))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env
   ((letrec*
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
      <-)))))
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
  (env
   ((letrec*
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
      <-)))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env
   ((letrec*
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
      <-)))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (a) (-> (match (app not (app pair? a)) ...) <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (a) (-> (match (app not (app pair? a)) ...) <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (a) (-> (match (app not (app pair? a)) ...) <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (cadr-v) (-> (app car (app cdr (app cdr cadr-v))) <-))
  (env
   ((app
     cons
     (-> (app caddr a) <-)
     (app
      cons
      (app caddr a)
      (app cons (app deriv (app caddr a)) (app nil)))))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (cadr-v) (-> (app car (app cdr (app cdr cadr-v))) <-))
  (env
   ((app
     cons
     (-> (app caddr a) <-)
     (app cons (app deriv (app caddr a)) (app nil))))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (cadr-v) (-> (app car (app cdr (app cdr cadr-v))) <-))
  (env ((app cons (-> (app caddr a) <-) (app nil)))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (cadr-v) (-> (app car (app cdr (app cdr cadr-v))) <-))
  (env ((app deriv (-> (app caddr a) <-)))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (cadr-v) (-> (app car (app cdr cadr-v)) <-))
  (env
   ((app
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
      (app nil))))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

'(query:
  (λ (cadr-v) (-> (app car (app cdr cadr-v)) <-))
  (env ((app deriv (-> (app cadr a) <-)))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

'(query:
  (λ (car-v) (-> (match car-v ...) <-))
  (env ((app eq? (-> (app car a) <-) '*))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (car-v) (-> (match car-v ...) <-))
  (env ((app eq? (-> (app car a) <-) '+))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (car-v) (-> (match car-v ...) <-))
  (env ((app eq? (-> (app car a) <-) '-))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (car-v) (-> (match car-v ...) <-))
  (env ((app eq? (-> (app car a) <-) '/))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (car-v) (-> (match car-v ...) <-))
  (env ((λ (cadr-v) (-> (app car (app cdr (app cdr cadr-v))) <-)))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (car-v) (-> (match car-v ...) <-))
  (env ((λ (cadr-v) (-> (app car (app cdr cadr-v)) <-)))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

'(query:
  (λ (cdr-v) (-> (match cdr-v ...) <-))
  (env ((app car (-> (app cdr (app cdr cadr-v)) <-)))))
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
	'((con cons (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'b (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (cdr-v) (-> (match cdr-v ...) <-))
  (env ((app car (-> (app cdr cadr-v) <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (cdr-v) (-> (match cdr-v ...) <-))
  (env ((app cdr (-> (app cdr cadr-v) <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (cdr-v) (-> (match cdr-v ...) <-))
  (env ((app map (λ (a) ...) (-> (app cdr a) <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (cdr-v) (-> (match cdr-v ...) <-))
  (env ((app map deriv (-> (app cdr a) <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (cdr-v) (-> (match cdr-v ...) <-))
  (env ((app map deriv (-> (app cdr a) <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (map-f map-l) (-> (match map-l ...) <-))
  (env ((app cons '+ (-> (app map (λ (a) ...) (app cdr a)) <-)))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons '+ (-> (app map (λ (a) ...) (app cdr a)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (map-f map-l) (-> (match map-l ...) <-))
  (env ((app cons '+ (-> (app map deriv (app cdr a)) <-)))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons '+ (-> (app map deriv (app cdr a)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (map-f map-l) (-> (match map-l ...) <-))
  (env ((app cons '- (-> (app map deriv (app cdr a)) <-)))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons '- (-> (app map deriv (app cdr a)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (map-f map-l) (-> (match map-l ...) <-))
  (env ((app cons (app map-f map-c) (-> (app map map-f map-d) <-)))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons (app map-f map-c) (-> (app map map-f map-d) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (pair?-v) (-> (match pair?-v ...) <-))
  (env ((app not (-> (app pair? a) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: ((top) lettypes (cons ... error) ...) (env ()))
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
  (env
   ((letrec*
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
      <-)))))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env
   ((letrec*
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
      <-)))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env
   ((letrec*
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
      <-)))))
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
  (env
   ((letrec*
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
      <-)))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env
   ((letrec*
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
      <-)))))
literals: '(⊤ ⊥ ⊥)

'(query: (app cdr (-> cadr-v <-)) (env ((app deriv (-> (app caddr a) <-)))))
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
literals: '(⊤ ⊥ ⊥)

'(query: (app cdr (-> cadr-v <-)) (env ((app deriv (-> (app cadr a) <-)))))
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
literals: '(⊤ ⊥ ⊥)

'(query: (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)) (env ()))
clos/con:
	'((con cons (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)) (env ()))
clos/con:
	'((con cons (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 'b (-> (app cons 'x (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons 'b (-> (app cons 'x (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 'x (-> (app cons 'x (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 'x (-> (app cons 'x (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 'x (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 'x (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 'x (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)) (env ()))
clos/con:
	'((con cons (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 5 (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (lettypes cons ... error (letrec* (car ... deriv) ...)) (env ()))
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
  (env
   ((letrec*
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
      <-)))))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env
   ((letrec*
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
      <-)))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env
   ((letrec*
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
      <-)))))
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
  (env
   ((letrec*
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
      <-)))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env
   ((letrec*
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
      <-)))))
literals: '(⊤ ⊥ ⊥)

'(store:
  _
  (match pair?-v (cons pair?-c pair?-d) (_ (-> (app #f) <-)))
  (env ((app not (-> (app pair? a) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  a
  (λ (a) (-> (app cons '/ (app cons (app deriv a) (app cons a (app nil)))) <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
literals: '(⊤ ⊥ ⊥)

'(store:
  a
  (λ (a) (-> (match (app not (app pair? a)) ...) <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

'(store:
  a
  (λ (a) (-> (match (app not (app pair? a)) ...) <-))
  (env
   ((letrec*
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
      <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  a
  (λ (a) (-> (match (app not (app pair? a)) ...) <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  a
  (λ (a) (-> (match (app not (app pair? a)) ...) <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
literals: '(⊤ ⊥ ⊥)

'(store:
  a
  (λ (a) (-> (match (app not (app pair? a)) ...) <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
literals: '(⊤ ⊥ ⊥)

'(store:
  caddr
  (letrec* (... cadr (caddr (-> (λ (cadr-v) ...) <-)) map ...) ...)
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((letrec* (... cadr (caddr (-> (λ (cadr-v) ...) <-)) map ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  caddr
  (letrec* (... cadr (caddr (-> (λ (cadr-v) ...) <-)) map ...) ...)
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((letrec* (... cadr (caddr (-> (λ (cadr-v) ...) <-)) map ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  caddr
  (letrec* (... cadr (caddr (-> (λ (cadr-v) ...) <-)) map ...) ...)
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((letrec* (... cadr (caddr (-> (λ (cadr-v) ...) <-)) map ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  caddr
  (letrec* (... cadr (caddr (-> (λ (cadr-v) ...) <-)) map ...) ...)
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((letrec* (... cadr (caddr (-> (λ (cadr-v) ...) <-)) map ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  caddr
  (letrec* (... cadr (caddr (-> (λ (cadr-v) ...) <-)) map ...) ...)
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((letrec* (... cadr (caddr (-> (λ (cadr-v) ...) <-)) map ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  caddr
  (letrec* (... cadr (caddr (-> (λ (cadr-v) ...) <-)) map ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cadr (caddr (-> (λ (cadr-v) ...) <-)) map ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cadr
  (letrec* (... cdr (cadr (-> (λ (cadr-v) ...) <-)) caddr ...) ...)
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((letrec* (... cdr (cadr (-> (λ (cadr-v) ...) <-)) caddr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cadr
  (letrec* (... cdr (cadr (-> (λ (cadr-v) ...) <-)) caddr ...) ...)
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((letrec* (... cdr (cadr (-> (λ (cadr-v) ...) <-)) caddr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cadr
  (letrec* (... cdr (cadr (-> (λ (cadr-v) ...) <-)) caddr ...) ...)
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((letrec* (... cdr (cadr (-> (λ (cadr-v) ...) <-)) caddr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cadr
  (letrec* (... cdr (cadr (-> (λ (cadr-v) ...) <-)) caddr ...) ...)
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((letrec* (... cdr (cadr (-> (λ (cadr-v) ...) <-)) caddr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cadr
  (letrec* (... cdr (cadr (-> (λ (cadr-v) ...) <-)) caddr ...) ...)
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((letrec* (... cdr (cadr (-> (λ (cadr-v) ...) <-)) caddr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cadr
  (letrec* (... cdr (cadr (-> (λ (cadr-v) ...) <-)) caddr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cdr (cadr (-> (λ (cadr-v) ...) <-)) caddr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cadr-v
  (λ (cadr-v) (-> (app car (app cdr (app cdr cadr-v))) <-))
  (env
   ((app
     cons
     (-> (app caddr a) <-)
     (app
      cons
      (app caddr a)
      (app cons (app deriv (app caddr a)) (app nil)))))))
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
literals: '(⊤ ⊥ ⊥)

'(store:
  cadr-v
  (λ (cadr-v) (-> (app car (app cdr (app cdr cadr-v))) <-))
  (env
   ((app
     cons
     (-> (app caddr a) <-)
     (app cons (app deriv (app caddr a)) (app nil))))))
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
literals: '(⊤ ⊥ ⊥)

'(store:
  cadr-v
  (λ (cadr-v) (-> (app car (app cdr (app cdr cadr-v))) <-))
  (env ((app cons (-> (app caddr a) <-) (app nil)))))
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
literals: '(⊤ ⊥ ⊥)

'(store:
  cadr-v
  (λ (cadr-v) (-> (app car (app cdr (app cdr cadr-v))) <-))
  (env ((app deriv (-> (app caddr a) <-)))))
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
literals: '(⊤ ⊥ ⊥)

'(store:
  cadr-v
  (λ (cadr-v) (-> (app car (app cdr cadr-v)) <-))
  (env
   ((app
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
      (app nil))))))
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
literals: '(⊤ ⊥ ⊥)

'(store:
  cadr-v
  (λ (cadr-v) (-> (app car (app cdr cadr-v)) <-))
  (env ((app deriv (-> (app cadr a) <-)))))
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
literals: '(⊤ ⊥ ⊥)

'(store:
  car
  (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...)
  (env
   ((app
     cons
     (-> (app caddr a) <-)
     (app
      cons
      (app caddr a)
      (app cons (app deriv (app caddr a)) (app nil)))))))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car
  (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...)
  (env
   ((app
     cons
     (-> (app caddr a) <-)
     (app cons (app deriv (app caddr a)) (app nil))))))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car
  (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...)
  (env
   ((app
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
      (app nil))))))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car
  (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...)
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car
  (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...)
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car
  (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...)
  (env ((app cons (-> (app caddr a) <-) (app nil)))))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car
  (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...)
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car
  (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...)
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car
  (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...)
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car
  (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...)
  (env ((app deriv (-> (app caddr a) <-)))))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car
  (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...)
  (env ((app deriv (-> (app cadr a) <-)))))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car
  (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car-c
  (match car-v ((cons car-c car-d) (-> car-c <-)))
  (env ((app eq? (-> (app car a) <-) '*))))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  car-c
  (match car-v ((cons car-c car-d) (-> car-c <-)))
  (env ((app eq? (-> (app car a) <-) '+))))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  car-c
  (match car-v ((cons car-c car-d) (-> car-c <-)))
  (env ((app eq? (-> (app car a) <-) '-))))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  car-c
  (match car-v ((cons car-c car-d) (-> car-c <-)))
  (env ((app eq? (-> (app car a) <-) '/))))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  car-c
  (match car-v ((cons car-c car-d) (-> car-c <-)))
  (env ((λ (cadr-v) (-> (app car (app cdr (app cdr cadr-v))) <-)))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  car-c
  (match car-v ((cons car-c car-d) (-> car-c <-)))
  (env ((λ (cadr-v) (-> (app car (app cdr cadr-v)) <-)))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

'(store:
  car-d
  (match car-v ((cons car-c car-d) (-> car-c <-)))
  (env ((app eq? (-> (app car a) <-) '*))))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  car-d
  (match car-v ((cons car-c car-d) (-> car-c <-)))
  (env ((app eq? (-> (app car a) <-) '+))))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  car-d
  (match car-v ((cons car-c car-d) (-> car-c <-)))
  (env ((app eq? (-> (app car a) <-) '-))))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  car-d
  (match car-v ((cons car-c car-d) (-> car-c <-)))
  (env ((app eq? (-> (app car a) <-) '/))))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  car-d
  (match car-v ((cons car-c car-d) (-> car-c <-)))
  (env ((λ (cadr-v) (-> (app car (app cdr (app cdr cadr-v))) <-)))))
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
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car-d
  (match car-v ((cons car-c car-d) (-> car-c <-)))
  (env ((λ (cadr-v) (-> (app car (app cdr cadr-v)) <-)))))
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
	'((con cons (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'b (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car-v
  (λ (car-v) (-> (match car-v ...) <-))
  (env ((app eq? (-> (app car a) <-) '*))))
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
literals: '(⊤ ⊥ ⊥)

'(store:
  car-v
  (λ (car-v) (-> (match car-v ...) <-))
  (env ((app eq? (-> (app car a) <-) '+))))
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
literals: '(⊤ ⊥ ⊥)

'(store:
  car-v
  (λ (car-v) (-> (match car-v ...) <-))
  (env ((app eq? (-> (app car a) <-) '-))))
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
literals: '(⊤ ⊥ ⊥)

'(store:
  car-v
  (λ (car-v) (-> (match car-v ...) <-))
  (env ((app eq? (-> (app car a) <-) '/))))
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
literals: '(⊤ ⊥ ⊥)

'(store:
  car-v
  (λ (car-v) (-> (match car-v ...) <-))
  (env ((λ (cadr-v) (-> (app car (app cdr (app cdr cadr-v))) <-)))))
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
	'((con cons (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'b (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car-v
  (λ (car-v) (-> (match car-v ...) <-))
  (env ((λ (cadr-v) (-> (app car (app cdr cadr-v)) <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...)
  (env
   ((app
     cons
     (-> (app caddr a) <-)
     (app
      cons
      (app caddr a)
      (app cons (app deriv (app caddr a)) (app nil)))))))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...)
  (env
   ((app
     cons
     (-> (app caddr a) <-)
     (app cons (app deriv (app caddr a)) (app nil))))))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...)
  (env
   ((app
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
      (app nil))))))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...)
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...)
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...)
  (env ((app cons (-> (app caddr a) <-) (app nil)))))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...)
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...)
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...)
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...)
  (env ((app deriv (-> (app caddr a) <-)))))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...)
  (env ((app deriv (-> (app cadr a) <-)))))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr-c
  (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-)))
  (env ((app car (-> (app cdr (app cdr cadr-v)) <-)))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

'(store:
  cdr-c
  (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-)))
  (env ((app car (-> (app cdr cadr-v) <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr-c
  (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-)))
  (env ((app cdr (-> (app cdr cadr-v) <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr-c
  (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-)))
  (env ((app map (λ (a) ...) (-> (app cdr a) <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr-c
  (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-)))
  (env ((app map deriv (-> (app cdr a) <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr-c
  (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-)))
  (env ((app map deriv (-> (app cdr a) <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr-d
  (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-)))
  (env ((app car (-> (app cdr (app cdr cadr-v)) <-)))))
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
	'((con cons (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'b (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr-d
  (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-)))
  (env ((app car (-> (app cdr cadr-v) <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr-d
  (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-)))
  (env ((app cdr (-> (app cdr cadr-v) <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr-d
  (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-)))
  (env ((app map (λ (a) ...) (-> (app cdr a) <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr-d
  (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-)))
  (env ((app map deriv (-> (app cdr a) <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr-d
  (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-)))
  (env ((app map deriv (-> (app cdr a) <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr-v
  (λ (cdr-v) (-> (match cdr-v ...) <-))
  (env ((app car (-> (app cdr (app cdr cadr-v)) <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr-v
  (λ (cdr-v) (-> (match cdr-v ...) <-))
  (env ((app car (-> (app cdr cadr-v) <-)))))
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
literals: '(⊤ ⊥ ⊥)

'(store:
  cdr-v
  (λ (cdr-v) (-> (match cdr-v ...) <-))
  (env ((app cdr (-> (app cdr cadr-v) <-)))))
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
literals: '(⊤ ⊥ ⊥)

'(store:
  cdr-v
  (λ (cdr-v) (-> (match cdr-v ...) <-))
  (env ((app map (λ (a) ...) (-> (app cdr a) <-)))))
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
literals: '(⊤ ⊥ ⊥)

'(store:
  cdr-v
  (λ (cdr-v) (-> (match cdr-v ...) <-))
  (env ((app map deriv (-> (app cdr a) <-)))))
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
literals: '(⊤ ⊥ ⊥)

'(store:
  cdr-v
  (λ (cdr-v) (-> (match cdr-v ...) <-))
  (env ((app map deriv (-> (app cdr a) <-)))))
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
literals: '(⊤ ⊥ ⊥)

'(store:
  con
  (app
   cons
   '*
   (->
    (app
     cons
     (app caddr a)
     (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil))))
    <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   '*
   (->
    (app
     cons
     (app caddr a)
     (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil))))
    <-))
  (env
   ((letrec*
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
      <-)))))
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
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   '*
   (->
    (app
     cons
     (app caddr a)
     (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil))))
    <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   '*
   (->
    (app
     cons
     (app caddr a)
     (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil))))
    <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   '*
   (->
    (app
     cons
     (app caddr a)
     (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil))))
    <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   '*
   (->
    (app
     cons
     a
     (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil)))
    <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   '*
   (->
    (app
     cons
     a
     (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil)))
    <-))
  (env
   ((letrec*
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
      <-)))))
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
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   '*
   (->
    (app
     cons
     a
     (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil)))
    <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   '*
   (->
    (app
     cons
     a
     (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil)))
    <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   '*
   (->
    (app
     cons
     a
     (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil)))
    <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env
   ((letrec*
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
      <-)))))
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
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env
   ((letrec*
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
      <-)))))
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
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   '/
   (->
    (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil)))
    <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((con
   cons
   (app
    cons
    '/
    (->
     (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil)))
     <-)))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   '/
   (->
    (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil)))
    <-))
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con
   cons
   (app
    cons
    '/
    (->
     (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil)))
     <-)))
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   '/
   (->
    (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil)))
    <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((con
   cons
   (app
    cons
    '/
    (->
     (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil)))
     <-)))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   '/
   (->
    (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil)))
    <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((con
   cons
   (app
    cons
    '/
    (->
     (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil)))
     <-)))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   '/
   (->
    (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil)))
    <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con
   cons
   (app
    cons
    '/
    (->
     (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil)))
     <-)))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env
   ((letrec*
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
      <-)))))
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
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env
   ((letrec*
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
      <-)))))
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
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env
   ((letrec*
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
      <-)))))
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
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (-> '* <-)
   (app
    cons
    (app caddr a)
    (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((app
   cons
   (-> '* <-)
   (app
    cons
    (app caddr a)
    (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (-> '* <-)
   (app
    cons
    (app caddr a)
    (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))))
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((app
   cons
   (-> '* <-)
   (app
    cons
    (app caddr a)
    (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))))
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (-> '* <-)
   (app
    cons
    (app caddr a)
    (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((app
   cons
   (-> '* <-)
   (app
    cons
    (app caddr a)
    (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (-> '* <-)
   (app
    cons
    (app caddr a)
    (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((app
   cons
   (-> '* <-)
   (app
    cons
    (app caddr a)
    (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (-> '* <-)
   (app
    cons
    (app caddr a)
    (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((app
   cons
   (-> '* <-)
   (app
    cons
    (app caddr a)
    (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (-> '* <-)
   (app
    cons
    a
    (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((app
   cons
   (-> '* <-)
   (app
    cons
    a
    (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (-> '* <-)
   (app
    cons
    a
    (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((app
   cons
   (-> '* <-)
   (app
    cons
    a
    (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (-> '* <-)
   (app
    cons
    a
    (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((app
   cons
   (-> '* <-)
   (app
    cons
    a
    (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (-> '* <-)
   (app
    cons
    a
    (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((app
   cons
   (-> '* <-)
   (app
    cons
    a
    (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (-> '* <-)
   (app
    cons
    a
    (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((app
   cons
   (-> '* <-)
   (app
    cons
    a
    (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env
   ((letrec*
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
      <-)))))
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
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env
   ((letrec*
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
      <-)))))
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
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (-> '/ <-)
   (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil))))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((app
   cons
   (-> '/ <-)
   (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil))))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (-> '/ <-)
   (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil))))
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((app
   cons
   (-> '/ <-)
   (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil))))
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (-> '/ <-)
   (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil))))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((app
   cons
   (-> '/ <-)
   (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil))))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (-> '/ <-)
   (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil))))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((app
   cons
   (-> '/ <-)
   (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil))))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (-> '/ <-)
   (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil))))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((app
   cons
   (-> '/ <-)
   (app cons (app deriv (app cadr a)) (app cons (app caddr a) (app nil))))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (-> (app caddr a) <-)
   (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil))))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (-> (app caddr a) <-)
   (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil))))
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (-> (app caddr a) <-)
   (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil))))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (-> (app caddr a) <-)
   (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil))))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (-> (app caddr a) <-)
   (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil))))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (-> (app caddr a) <-)
   (app cons (app deriv (app caddr a)) (app nil)))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (-> (app caddr a) <-)
   (app cons (app deriv (app caddr a)) (app nil)))
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (-> (app caddr a) <-)
   (app cons (app deriv (app caddr a)) (app nil)))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (-> (app caddr a) <-)
   (app cons (app deriv (app caddr a)) (app nil)))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (-> (app caddr a) <-)
   (app cons (app deriv (app caddr a)) (app nil)))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

'(store:
  con
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
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

'(store:
  con
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

'(store:
  con
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

'(store:
  con
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

'(store:
  con
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
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (-> (app deriv (app cadr a)) <-)
   (app cons (app caddr a) (app nil)))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊤ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (-> (app deriv (app cadr a)) <-)
   (app cons (app caddr a) (app nil)))
  (env
   ((letrec*
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
      <-)))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊤ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (-> (app deriv (app cadr a)) <-)
   (app cons (app caddr a) (app nil)))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊤ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (-> (app deriv (app cadr a)) <-)
   (app cons (app caddr a) (app nil)))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊤ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (-> (app deriv (app cadr a)) <-)
   (app cons (app caddr a) (app nil)))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊤ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (-> a <-)
   (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil)))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

'(store:
  con
  (app
   cons
   (-> a <-)
   (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil)))
  (env
   ((letrec*
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
      <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (-> a <-)
   (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil)))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (-> a <-)
   (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil)))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
literals: '(⊤ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (-> a <-)
   (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil)))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
literals: '(⊤ ⊥ ⊥)

'(store:
  con
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env
   ((letrec*
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
      <-)))))
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
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (app caddr a)
   (->
    (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))
    <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((con
   cons
   (app
    cons
    (app caddr a)
    (->
     (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))
     <-)))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (app caddr a)
   (->
    (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))
    <-))
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con
   cons
   (app
    cons
    (app caddr a)
    (->
     (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))
     <-)))
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (app caddr a)
   (->
    (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))
    <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((con
   cons
   (app
    cons
    (app caddr a)
    (->
     (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))
     <-)))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (app caddr a)
   (->
    (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))
    <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((con
   cons
   (app
    cons
    (app caddr a)
    (->
     (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))
     <-)))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (app caddr a)
   (->
    (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))
    <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con
   cons
   (app
    cons
    (app caddr a)
    (->
     (app cons (app caddr a) (app cons (app deriv (app caddr a)) (app nil)))
     <-)))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (app caddr a)
   (-> (app cons (app deriv (app caddr a)) (app nil)) <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((con
   cons
   (app
    cons
    (app caddr a)
    (-> (app cons (app deriv (app caddr a)) (app nil)) <-)))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (app caddr a)
   (-> (app cons (app deriv (app caddr a)) (app nil)) <-))
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con
   cons
   (app
    cons
    (app caddr a)
    (-> (app cons (app deriv (app caddr a)) (app nil)) <-)))
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (app caddr a)
   (-> (app cons (app deriv (app caddr a)) (app nil)) <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((con
   cons
   (app
    cons
    (app caddr a)
    (-> (app cons (app deriv (app caddr a)) (app nil)) <-)))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (app caddr a)
   (-> (app cons (app deriv (app caddr a)) (app nil)) <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((con
   cons
   (app
    cons
    (app caddr a)
    (-> (app cons (app deriv (app caddr a)) (app nil)) <-)))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (app caddr a)
   (-> (app cons (app deriv (app caddr a)) (app nil)) <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con
   cons
   (app
    cons
    (app caddr a)
    (-> (app cons (app deriv (app caddr a)) (app nil)) <-)))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env
   ((letrec*
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
      <-)))))
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
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
literals: '(⊥ ⊥ ⊥)

'(store:
  con
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
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (app deriv (app cadr a))
   (-> (app cons (app caddr a) (app nil)) <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((con
   cons
   (app
    cons
    (app deriv (app cadr a))
    (-> (app cons (app caddr a) (app nil)) <-)))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (app deriv (app cadr a))
   (-> (app cons (app caddr a) (app nil)) <-))
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con
   cons
   (app
    cons
    (app deriv (app cadr a))
    (-> (app cons (app caddr a) (app nil)) <-)))
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (app deriv (app cadr a))
   (-> (app cons (app caddr a) (app nil)) <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((con
   cons
   (app
    cons
    (app deriv (app cadr a))
    (-> (app cons (app caddr a) (app nil)) <-)))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (app deriv (app cadr a))
   (-> (app cons (app caddr a) (app nil)) <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((con
   cons
   (app
    cons
    (app deriv (app cadr a))
    (-> (app cons (app caddr a) (app nil)) <-)))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (app deriv (app cadr a))
   (-> (app cons (app caddr a) (app nil)) <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con
   cons
   (app
    cons
    (app deriv (app cadr a))
    (-> (app cons (app caddr a) (app nil)) <-)))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   a
   (->
    (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))
    <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((con
   cons
   (app
    cons
    a
    (->
     (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))
     <-)))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   a
   (->
    (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))
    <-))
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con
   cons
   (app
    cons
    a
    (->
     (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))
     <-)))
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   a
   (->
    (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))
    <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((con
   cons
   (app
    cons
    a
    (->
     (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))
     <-)))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   a
   (->
    (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))
    <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((con
   cons
   (app
    cons
    a
    (->
     (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))
     <-)))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   a
   (->
    (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))
    <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con
   cons
   (app
    cons
    a
    (->
     (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (app nil))
     <-)))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-))
  (env ()))
clos/con:
	'((con
   cons
   (app cons '* (-> (app cons 'a (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-))
  (env ()))
clos/con:
	'((con cons (app cons '* (-> (app cons 'b (app cons 'x (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-))
  (env ()))
clos/con:
	'((con
   cons
   (app cons '* (-> (app cons 3 (app cons 'x (app cons 'x (app nil)))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons '+ (-> (app map (λ (a) ...) (app cdr a)) <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons '+ (-> (app map (λ (a) ...) (app cdr a)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons '+ (-> (app map (λ (a) ...) (app cdr a)) <-))
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons '+ (-> (app map (λ (a) ...) (app cdr a)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons '+ (-> (app map (λ (a) ...) (app cdr a)) <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons '+ (-> (app map (λ (a) ...) (app cdr a)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons '+ (-> (app map (λ (a) ...) (app cdr a)) <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons '+ (-> (app map (λ (a) ...) (app cdr a)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons '+ (-> (app map (λ (a) ...) (app cdr a)) <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons '+ (-> (app map (λ (a) ...) (app cdr a)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons '+ (-> (app map deriv (app cdr a)) <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons '+ (-> (app map deriv (app cdr a)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons '+ (-> (app map deriv (app cdr a)) <-))
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons '+ (-> (app map deriv (app cdr a)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons '+ (-> (app map deriv (app cdr a)) <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons '+ (-> (app map deriv (app cdr a)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons '+ (-> (app map deriv (app cdr a)) <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons '+ (-> (app map deriv (app cdr a)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons '+ (-> (app map deriv (app cdr a)) <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons '+ (-> (app map deriv (app cdr a)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons '- (-> (app map deriv (app cdr a)) <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons '- (-> (app map deriv (app cdr a)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons '- (-> (app map deriv (app cdr a)) <-))
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons '- (-> (app map deriv (app cdr a)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons '- (-> (app map deriv (app cdr a)) <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons '- (-> (app map deriv (app cdr a)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons '- (-> (app map deriv (app cdr a)) <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons '- (-> (app map deriv (app cdr a)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons '- (-> (app map deriv (app cdr a)) <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons '- (-> (app map deriv (app cdr a)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons '/ (-> (app cons (app deriv a) (app cons a (app nil))) <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con
   cons
   (app cons '/ (-> (app cons (app deriv a) (app cons a (app nil))) <-)))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-))
  (env ()))
clos/con:
	'((con cons (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
clos/con:
	'((app cons (-> '* <-) (app cons 'a (app cons 'x (app cons 'x (app nil)))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> '* <-) (app cons 'b (app cons 'x (app nil))))
  (env ()))
clos/con:
	'((app cons (-> '* <-) (app cons 'b (app cons 'x (app nil)))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
clos/con:
	'((app cons (-> '* <-) (app cons 3 (app cons 'x (app cons 'x (app nil)))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> '+ <-) (app map (λ (a) ...) (app cdr a)))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((app cons (-> '+ <-) (app map (λ (a) ...) (app cdr a)))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> '+ <-) (app map (λ (a) ...) (app cdr a)))
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((app cons (-> '+ <-) (app map (λ (a) ...) (app cdr a)))
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> '+ <-) (app map (λ (a) ...) (app cdr a)))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((app cons (-> '+ <-) (app map (λ (a) ...) (app cdr a)))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> '+ <-) (app map (λ (a) ...) (app cdr a)))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((app cons (-> '+ <-) (app map (λ (a) ...) (app cdr a)))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> '+ <-) (app map (λ (a) ...) (app cdr a)))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((app cons (-> '+ <-) (app map (λ (a) ...) (app cdr a)))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> '+ <-) (app map deriv (app cdr a)))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((app cons (-> '+ <-) (app map deriv (app cdr a)))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> '+ <-) (app map deriv (app cdr a)))
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((app cons (-> '+ <-) (app map deriv (app cdr a)))
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> '+ <-) (app map deriv (app cdr a)))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((app cons (-> '+ <-) (app map deriv (app cdr a)))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> '+ <-) (app map deriv (app cdr a)))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((app cons (-> '+ <-) (app map deriv (app cdr a)))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> '+ <-) (app map deriv (app cdr a)))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((app cons (-> '+ <-) (app map deriv (app cdr a)))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> '- <-) (app map deriv (app cdr a)))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((app cons (-> '- <-) (app map deriv (app cdr a)))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> '- <-) (app map deriv (app cdr a)))
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((app cons (-> '- <-) (app map deriv (app cdr a)))
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> '- <-) (app map deriv (app cdr a)))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((app cons (-> '- <-) (app map deriv (app cdr a)))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> '- <-) (app map deriv (app cdr a)))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((app cons (-> '- <-) (app map deriv (app cdr a)))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> '- <-) (app map deriv (app cdr a)))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((app cons (-> '- <-) (app map deriv (app cdr a)))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> '/ <-) (app cons (app deriv a) (app cons a (app nil))))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((app cons (-> '/ <-) (app cons (app deriv a) (app cons a (app nil))))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil))))
  (env ()))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> (app caddr a) <-) (app nil))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> (app caddr a) <-) (app nil))
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> (app caddr a) <-) (app nil))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> (app caddr a) <-) (app nil))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> (app caddr a) <-) (app nil))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> (app cons '+ (app map (λ (a) ...) (app cdr a))) <-) (app nil))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons '+ (app map (λ (a) ...) (app cdr a))) <-)
    (app nil)))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> (app cons '+ (app map (λ (a) ...) (app cdr a))) <-) (app nil))
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons '+ (app map (λ (a) ...) (app cdr a))) <-)
    (app nil)))
  (env
   ((letrec*
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
      <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> (app cons '+ (app map (λ (a) ...) (app cdr a))) <-) (app nil))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons '+ (app map (λ (a) ...) (app cdr a))) <-)
    (app nil)))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> (app cons '+ (app map (λ (a) ...) (app cdr a))) <-) (app nil))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons '+ (app map (λ (a) ...) (app cdr a))) <-)
    (app nil)))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> (app cons '+ (app map (λ (a) ...) (app cdr a))) <-) (app nil))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con
   cons
   (app
    cons
    (-> (app cons '+ (app map (λ (a) ...) (app cdr a))) <-)
    (app nil)))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> (app deriv (app caddr a)) <-) (app nil))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊤ ⊥ ⊥)

'(store:
  con
  (app cons (-> (app deriv (app caddr a)) <-) (app nil))
  (env
   ((letrec*
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
      <-)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊤ ⊥ ⊥)

'(store:
  con
  (app cons (-> (app deriv (app caddr a)) <-) (app nil))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊤ ⊥ ⊥)

'(store:
  con
  (app cons (-> (app deriv (app caddr a)) <-) (app nil))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊤ ⊥ ⊥)

'(store:
  con
  (app cons (-> (app deriv (app caddr a)) <-) (app nil))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
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
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
literals: '(⊤ ⊥ ⊥)

'(store:
  con
  (app cons (-> (app deriv a) <-) (app cons a (app nil)))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
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
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
literals: '(⊤ ⊥ ⊥)

'(store:
  con
  (app cons (-> (app map-f map-c) <-) (app map map-f map-d))
  (env ((app cons '+ (-> (app map (λ (a) ...) (app cdr a)) <-)))))
clos/con:
	'((con
   cons
   (λ (a)
     (-> (app cons '/ (app cons (app deriv a) (app cons a (app nil)))) <-)))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> (app map-f map-c) <-) (app map map-f map-d))
  (env ((app cons '+ (-> (app map deriv (app cdr a)) <-)))))
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊤ ⊥ ⊥)

'(store:
  con
  (app cons (-> (app map-f map-c) <-) (app map map-f map-d))
  (env ((app cons '- (-> (app map deriv (app cdr a)) <-)))))
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊤ ⊥ ⊥)

'(store:
  con
  (app cons (-> (app map-f map-c) <-) (app map map-f map-d))
  (env ((app cons (app map-f map-c) (-> (app map map-f map-d) <-)))))
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
	'((con
   cons
   (match
    (app eq? (app car a) '+)
    (#f)
    (_ (-> (app cons '+ (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
	'((con
   cons
   (match
    (app eq? (app car a) '-)
    (#f)
    (_ (-> (app cons '- (app map deriv (app cdr a))) <-))))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
	'((con
   cons
   (λ (a)
     (-> (app cons '/ (app cons (app deriv a) (app cons a (app nil)))) <-)))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
	'((con
   error
   (match
    (app eq? (app car a) '/)
    ((#f) (-> (app error (app #f) "No derivation method available") <-))
    _))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊤ ⊥ ⊥)

'(store:
  con
  (app cons (-> 3 <-) (app cons 'x (app cons 'x (app nil))))
  (env ()))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(store:
  con
  (app cons (-> a <-) (app nil))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
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
literals: '(⊤ ⊥ ⊥)

'(store:
  con
  (app cons (app caddr a) (-> (app nil) <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (app caddr a) (-> (app nil) <-))
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (app caddr a) (-> (app nil) <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (app caddr a) (-> (app nil) <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (app caddr a) (-> (app nil) <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (-> (app nil) <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (-> (app nil) <-))
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (-> (app nil) <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (-> (app nil) <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (app cons '+ (app map (λ (a) ...) (app cdr a))) (-> (app nil) <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (app deriv (app caddr a)) (-> (app nil) <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (app deriv (app caddr a)) (-> (app nil) <-))
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (app deriv (app caddr a)) (-> (app nil) <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (app deriv (app caddr a)) (-> (app nil) <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (app deriv (app caddr a)) (-> (app nil) <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (app deriv a) (-> (app cons a (app nil)) <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con cons (app cons (app deriv a) (-> (app cons a (app nil)) <-)))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (app map-f map-c) (-> (app map map-f map-d) <-))
  (env ((app cons '+ (-> (app map (λ (a) ...) (app cdr a)) <-)))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons (app map-f map-c) (-> (app map map-f map-d) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (app map-f map-c) (-> (app map map-f map-d) <-))
  (env ((app cons '+ (-> (app map deriv (app cdr a)) <-)))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons (app map-f map-c) (-> (app map map-f map-d) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (app map-f map-c) (-> (app map map-f map-d) <-))
  (env ((app cons '- (-> (app map deriv (app cdr a)) <-)))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons (app map-f map-c) (-> (app map map-f map-d) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (app map-f map-c) (-> (app map map-f map-d) <-))
  (env ((app cons (app map-f map-c) (-> (app map map-f map-d) <-)))))
clos/con:
	'((con
   cons
   (match
    map-l
    ((cons map-c map-d)
     (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
    (nil)))
  (env ((app cons (app map-f map-c) (-> (app map map-f map-d) <-)))))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-))
  (env ()))
clos/con:
	'((con cons (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons a (-> (app nil) <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app error (-> (app #f) <-) "No derivation method available")
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app error (-> (app #f) <-) "No derivation method available")
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app error (-> (app #f) <-) "No derivation method available")
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app error (-> (app #f) <-) "No derivation method available")
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app error (-> (app #f) <-) "No derivation method available")
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app error (app #f) (-> "No derivation method available" <-))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con: ⊥
literals: '(⊥ ⊥ "No derivation method available")

'(store:
  con
  (app error (app #f) (-> "No derivation method available" <-))
  (env
   ((letrec*
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
      <-)))))
clos/con: ⊥
literals: '(⊥ ⊥ "No derivation method available")

'(store:
  con
  (app error (app #f) (-> "No derivation method available" <-))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con: ⊥
literals: '(⊥ ⊥ "No derivation method available")

'(store:
  con
  (app error (app #f) (-> "No derivation method available" <-))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con: ⊥
literals: '(⊥ ⊥ "No derivation method available")

'(store:
  con
  (app error (app #f) (-> "No derivation method available" <-))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con: ⊥
literals: '(⊥ ⊥ "No derivation method available")

'(store:
  deriv
  (letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...)
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  deriv
  (letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...)
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  deriv
  (letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...)
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  deriv
  (letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...)
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  deriv
  (letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...)
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  deriv
  (letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...)
  (env ()))
clos/con:
	'((letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  map
  (letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) pair? ...) ...)
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) pair? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  map
  (letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) pair? ...) ...)
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) pair? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  map
  (letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) pair? ...) ...)
  (env ((app cons '+ (-> (app map (λ (a) ...) (app cdr a)) <-)))))
clos/con:
	'((letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) pair? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  map
  (letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) pair? ...) ...)
  (env ((app cons '+ (-> (app map deriv (app cdr a)) <-)))))
clos/con:
	'((letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) pair? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  map
  (letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) pair? ...) ...)
  (env ((app cons '- (-> (app map deriv (app cdr a)) <-)))))
clos/con:
	'((letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) pair? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  map
  (letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) pair? ...) ...)
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) pair? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  map
  (letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) pair? ...) ...)
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) pair? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  map
  (letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) pair? ...) ...)
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) pair? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  map
  (letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) pair? ...) ...)
  (env ((app cons (app map-f map-c) (-> (app map map-f map-d) <-)))))
clos/con:
	'((letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) pair? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  map
  (letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) pair? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) pair? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  map-c
  (match
   map-l
   ((cons map-c map-d)
    (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
   (nil))
  (env ((app cons '+ (-> (app map (λ (a) ...) (app cdr a)) <-)))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

'(store:
  map-c
  (match
   map-l
   ((cons map-c map-d)
    (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
   (nil))
  (env ((app cons '+ (-> (app map deriv (app cdr a)) <-)))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

'(store:
  map-c
  (match
   map-l
   ((cons map-c map-d)
    (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
   (nil))
  (env ((app cons '- (-> (app map deriv (app cdr a)) <-)))))
clos/con:
	'((app cons (-> 'a <-) (app cons 'x (app cons 'x (app nil)))) (env ()))
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
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
literals: '(3 ⊥ ⊥)

'(store:
  map-c
  (match
   map-l
   ((cons map-c map-d)
    (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
   (nil))
  (env ((app cons (app map-f map-c) (-> (app map map-f map-d) <-)))))
clos/con:
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
literals: '(5 ⊥ ⊥)

'(store:
  map-d
  (match
   map-l
   ((cons map-c map-d)
    (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
   (nil))
  (env ((app cons '+ (-> (app map (λ (a) ...) (app cdr a)) <-)))))
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
	'((con cons (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'b (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  map-d
  (match
   map-l
   ((cons map-c map-d)
    (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
   (nil))
  (env ((app cons '+ (-> (app map deriv (app cdr a)) <-)))))
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
	'((con cons (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'b (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  map-d
  (match
   map-l
   ((cons map-c map-d)
    (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
   (nil))
  (env ((app cons '- (-> (app map deriv (app cdr a)) <-)))))
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
	'((con cons (app cons 'a (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'b (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 3 (-> (app cons 'x (app cons 'x (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  map-d
  (match
   map-l
   ((cons map-c map-d)
    (-> (app cons (app map-f map-c) (app map map-f map-d)) <-))
   (nil))
  (env ((app cons (app map-f map-c) (-> (app map map-f map-d) <-)))))
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
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  map-f
  (λ (map-f map-l) (-> (match map-l ...) <-))
  (env ((app cons '+ (-> (app map (λ (a) ...) (app cdr a)) <-)))))
clos/con:
	'((app map (-> (λ (a) ...) <-) (app cdr a))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((app map (-> (λ (a) ...) <-) (app cdr a))
  (env
   ((letrec*
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
      <-)))))
	'((app map (-> (λ (a) ...) <-) (app cdr a))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((app map (-> (λ (a) ...) <-) (app cdr a))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
	'((app map (-> (λ (a) ...) <-) (app cdr a))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  map-f
  (λ (map-f map-l) (-> (match map-l ...) <-))
  (env ((app cons '+ (-> (app map deriv (app cdr a)) <-)))))
clos/con:
	'((letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  map-f
  (λ (map-f map-l) (-> (match map-l ...) <-))
  (env ((app cons '- (-> (app map deriv (app cdr a)) <-)))))
clos/con:
	'((letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  map-f
  (λ (map-f map-l) (-> (match map-l ...) <-))
  (env ((app cons (app map-f map-c) (-> (app map map-f map-d) <-)))))
clos/con:
	'((app map (-> (λ (a) ...) <-) (app cdr a))
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
	'((app map (-> (λ (a) ...) <-) (app cdr a))
  (env
   ((letrec*
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
      <-)))))
	'((app map (-> (λ (a) ...) <-) (app cdr a))
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
	'((app map (-> (λ (a) ...) <-) (app cdr a))
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
	'((app map (-> (λ (a) ...) <-) (app cdr a))
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
	'((letrec* (... pair? (deriv (-> (λ (a) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  map-l
  (λ (map-f map-l) (-> (match map-l ...) <-))
  (env ((app cons '+ (-> (app map (λ (a) ...) (app cdr a)) <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  map-l
  (λ (map-f map-l) (-> (match map-l ...) <-))
  (env ((app cons '+ (-> (app map deriv (app cdr a)) <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  map-l
  (λ (map-f map-l) (-> (match map-l ...) <-))
  (env ((app cons '- (-> (app map deriv (app cdr a)) <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  map-l
  (λ (map-f map-l) (-> (match map-l ...) <-))
  (env ((app cons (app map-f map-c) (-> (app map map-f map-d) <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  pair?
  (letrec* (... map (pair? (-> (λ (pair?-v) ...) <-)) deriv ...) ...)
  (env
   ((app
     cons
     (-> (app deriv (app cadr a)) <-)
     (app cons (app caddr a) (app nil))))))
clos/con:
	'((letrec* (... map (pair? (-> (λ (pair?-v) ...) <-)) deriv ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pair?
  (letrec* (... map (pair? (-> (λ (pair?-v) ...) <-)) deriv ...) ...)
  (env
   ((letrec*
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
      <-)))))
clos/con:
	'((letrec* (... map (pair? (-> (λ (pair?-v) ...) <-)) deriv ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pair?
  (letrec* (... map (pair? (-> (λ (pair?-v) ...) <-)) deriv ...) ...)
  (env ((app cons (-> (app deriv (app caddr a)) <-) (app nil)))))
clos/con:
	'((letrec* (... map (pair? (-> (λ (pair?-v) ...) <-)) deriv ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pair?
  (letrec* (... map (pair? (-> (λ (pair?-v) ...) <-)) deriv ...) ...)
  (env ((app cons (-> (app deriv a) <-) (app cons a (app nil))))))
clos/con:
	'((letrec* (... map (pair? (-> (λ (pair?-v) ...) <-)) deriv ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pair?
  (letrec* (... map (pair? (-> (λ (pair?-v) ...) <-)) deriv ...) ...)
  (env ((app cons (-> (app map-f map-c) <-) (app map map-f map-d)))))
clos/con:
	'((letrec* (... map (pair? (-> (λ (pair?-v) ...) <-)) deriv ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pair?
  (letrec* (... map (pair? (-> (λ (pair?-v) ...) <-)) deriv ...) ...)
  (env ()))
clos/con:
	'((letrec* (... map (pair? (-> (λ (pair?-v) ...) <-)) deriv ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pair?-c
  (match pair?-v ((cons pair?-c pair?-d) (-> (app #t) <-)) _)
  (env ((app not (-> (app pair? a) <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  pair?-d
  (match pair?-v ((cons pair?-c pair?-d) (-> (app #t) <-)) _)
  (env ((app not (-> (app pair? a) <-)))))
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
literals: '(⊥ ⊥ ⊥)

'(store:
  pair?-v
  (λ (pair?-v) (-> (match pair?-v ...) <-))
  (env ((app not (-> (app pair? a) <-)))))
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
literals: '(⊤ ⊥ ⊥)

'(store: con (app cons 'b (-> (app cons 'x (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons 'b (-> (app cons 'x (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: con (app cons 'x (-> (app cons 'x (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: con (app cons 'x (-> (app cons 'x (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons 'x (-> (app cons 'x (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: con (app cons 'x (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: con (app cons 'x (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: con (app cons 'x (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: con (app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
clos/con:
	'((app cons (-> 'b <-) (app cons 'x (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: con (app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: con (app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
clos/con:
	'((app cons (-> 'x <-) (app cons 'x (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: con (app cons (-> 'x <-) (app nil)) (env ()))
clos/con:
	'((app cons (-> 'x <-) (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: con (app cons (-> 'x <-) (app nil)) (env ()))
clos/con:
	'((app cons (-> 'x <-) (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: con (app cons (-> 'x <-) (app nil)) (env ()))
clos/con:
	'((app cons (-> 'x <-) (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: con (app cons (-> 5 <-) (app nil)) (env ()))
clos/con: ⊥
literals: '(5 ⊥ ⊥)

'(store: con (app cons 5 (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)
