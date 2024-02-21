'(expression:
  (lettypes
   ((cons car cdr) (nil))
   (letrec*
    ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
     (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
     (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
     (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
     (pair?
      (λ (pair?-v)
        (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
     (null? (λ (null?-v) (match null?-v ((nil) (app #t)) (_ (app #f)))))
     (debug-trace (λ () 'do-nothing))
     (cadr (λ (p) (app car (app cdr p))))
     (caddr (λ (p) (app car (app cdr (app cdr p)))))
     (regex-NULL (app #f))
     (regex-BLANK (app #t))
     (regex-alt? (λ (re) (app and (app pair? re) (app eq? (app car re) 'alt))))
     (regex-seq? (λ (re) (app and (app pair? re) (app eq? (app car re) 'seq))))
     (regex-rep? (λ (re) (app and (app pair? re) (app eq? (app car re) 'rep))))
     (regex-null? (λ (re) (app eq? re (app #f))))
     (regex-empty? (λ (re) (app eq? re (app #t))))
     (regex-atom? (λ (re) (app or (app char? re) (app symbol? re))))
     (match-seq
      (λ (re f)
        (app and (app regex-seq? re) (app f (app cadr re) (app caddr re)))))
     (match-alt
      (λ (re f)
        (app and (app regex-alt? re) (app f (app cadr re) (app caddr re)))))
     (match-rep (λ (re f) (app and (app regex-rep? re) (app f (app cadr re)))))
     (seq
      (λ (pat1 pat2)
        (match
         (app regex-null? pat1)
         ((#f)
          (match
           (app regex-null? pat2)
           ((#f)
            (match
             (app regex-empty? pat1)
             ((#f)
              (match
               (app regex-empty? pat2)
               ((#f) (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))))
               (_ pat1)))
             (_ pat2)))
           (_ regex-NULL)))
         (_ regex-NULL))))
     (alt
      (λ (pat1 pat2)
        (match
         (app regex-null? pat1)
         ((#f)
          (match
           (app regex-null? pat2)
           ((#f) (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))))
           (_ pat1)))
         (_ pat2))))
     (rep
      (λ (pat)
        (match
         (app regex-null? pat)
         ((#f)
          (match
           (app regex-empty? pat)
           ((#f) (app cons 'rep (app cons pat (app nil))))
           (_ regex-BLANK)))
         (_ regex-BLANK))))
     (regex-empty
      (λ (re)
        (match
         (app regex-empty? re)
         ((#f)
          (match
           (app regex-null? re)
           ((#f)
            (match
             (app regex-atom? re)
             ((#f)
              (match
               (app
                match-seq
                re
                (λ (pat1 pat2)
                  (app seq (app regex-empty pat1) (app regex-empty pat2))))
               ((#f)
                (match
                 (app
                  match-alt
                  re
                  (λ (pat1 pat2)
                    (app alt (app regex-empty pat1) (app regex-empty pat2))))
                 ((#f)
                  (match (app regex-rep? re) ((#f) (app #f)) (_ (app #t))))
                 (c-x c-x)))
               (c-x c-x)))
             (_ (app #f))))
           (_ (app #f))))
         (_ (app #t)))))
     (regex-derivative
      (λ (re c)
        (let ((_ (app debug-trace)))
          (match
           (app regex-empty? re)
           ((#f)
            (match
             (app regex-null? re)
             ((#f)
              (match
               (app eq? c re)
               ((#f)
                (match
                 (app regex-atom? re)
                 ((#f)
                  (match
                   (app
                    match-seq
                    re
                    (λ (pat1 pat2)
                      (app
                       alt
                       (app seq (app regex-derivative pat1 c) pat2)
                       (app
                        seq
                        (app regex-empty pat1)
                        (app regex-derivative pat2 c)))))
                   ((#f)
                    (match
                     (app
                      match-alt
                      re
                      (λ (pat1 pat2)
                        (app
                         alt
                         (app regex-derivative pat1 c)
                         (app regex-derivative pat2 c))))
                     ((#f)
                      (match
                       (app
                        match-rep
                        re
                        (λ (pat)
                          (app
                           seq
                           (app regex-derivative pat c)
                           (app rep pat))))
                       ((#f) regex-NULL)
                       (c-x c-x)))
                     (c-x c-x)))
                   (c-x c-x)))
                 (_ regex-NULL)))
               (_ regex-BLANK)))
             (_ regex-NULL)))
           (_ regex-NULL)))))
     (regex-match
      (λ (pattern data)
        (match
         (app null? data)
         ((#f)
          (app
           regex-match
           (app regex-derivative pattern (app car data))
           (app cdr data)))
         (_ (app regex-empty? (app regex-empty pattern))))))
     (check-expect (λ (check expect) (app equal? check expect))))
    (app
     check-expect
     (app
      regex-match
      (app
       cons
       'seq
       (app
        cons
        'foo
        (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
      (app cons 'foo (app cons 'bar (app nil))))
     (app #f)))))

'(query: (λ (pat1 pat2) (-> (match (app regex-null? pat1) ...) <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> and <-) (app pair? re) (app eq? (app car re) 'seq)) (env ()))
clos/con:
	#<procedure:do-and>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
    <-))
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    'seq
    (->
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
     <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) debug-trace ...) ...)
  (env ()))
clos/con:
	'((letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) debug-trace ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> and <-) (app pair? re) (app eq? (app car re) 'rep)) (env ()))
clos/con:
	#<procedure:do-and>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> cdr-v <-) (cons cdr-c cdr-d)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    cons
    'foo
    (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    'seq
    (->
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
    (-> (app cons 'foo (app cons 'bar (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
	'((con cons (app cons 'alt (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'foo (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con cons (app cons 'rep (-> (app cons pat (app nil)) <-))) (env ()))
	'((con cons (app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cadr <-) re) (env ()))
clos/con:
	'((letrec* (... cdr (cadr (-> (λ (cadr-v) ...) <-)) caddr ...) ...) (env ()))
	'((letrec* (... debug-trace (cadr (-> (λ (p) ...) <-)) caddr ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons 'bar (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> (app regex-null? pat1) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app eq? (-> (app car re) <-) 'alt) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app regex-empty? (-> pat1 <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-))
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (app regex-null? re) (#f) (_ (-> regex-NULL <-))) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> regex-null? <-) pat2) (env ()))
clos/con:
	'((letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app regex-null? (-> pat1 <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> null? <-) data) (env ()))
clos/con:
	'((letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) debug-trace ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app car (-> (app cdr (app cdr cadr-v)) <-)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    'foo
    (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    'seq
    (->
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
     <-)))
  (env ()))
	'((con cons (app cons 'alt (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'foo (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con cons (app cons 'rep (-> (app cons pat (app nil)) <-))) (env ()))
	'((con cons (app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app regex-empty? (-> re <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> (app match-rep re (λ (pat) ...)) <-) (#f) c-x) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) pat2 (app nil)) (env ()))
clos/con:
	'((app (-> cons <-) pat2 (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> pair? <-) re) (env ()))
clos/con:
	'((letrec* (... caddr (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app (-> cons <-) 'seq (app cons pat1 (app cons pat2 (app nil))))
  (env ()))
clos/con:
	'((app (-> cons <-) 'seq (app cons pat1 (app cons pat2 (app nil)))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cadr <-) re) (env ()))
clos/con:
	'((letrec* (... cdr (cadr (-> (λ (cadr-v) ...) <-)) caddr ...) ...) (env ()))
	'((letrec* (... debug-trace (cadr (-> (λ (p) ...) <-)) caddr ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> regex-derivative <-) pat1 c) (env ()))
clos/con:
	'((letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) regex-match ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (re) (-> (match (app regex-empty? re) ...) <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (λ (re) (-> (app and (app pair? re) (app eq? (app car re) 'rep)) <-))
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (app regex-empty? re) (#f) (_ (-> regex-NULL <-))) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> (app regex-null? pat2) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (λ (pat1 pat2)
    (->
     (app
      alt
      (app seq (app regex-derivative pat1 c) pat2)
      (app seq (app regex-empty pat1) (app regex-derivative pat2 c)))
     <-))
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (λ (re) (-> (app and (app pair? re) (app eq? (app car re) 'seq)) <-))
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app and (-> (app pair? re) <-) (app eq? (app car re) 'alt)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app regex-derivative pat1 (-> c <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app regex-empty (-> pat2 <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app cons 'alt (-> (app cons pat1 (app cons pat2 (app nil))) <-))
  (env ()))
clos/con:
	'((con cons (app cons 'alt (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app regex-empty (-> pat1 <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ()))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> regex-null? <-) re) (env ()))
clos/con:
	'((letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ()))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-null? pat2)
   ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
   _)
  (env ()))
clos/con:
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> match-alt <-) re (λ (pat1 pat2) ...)) (env ()))
clos/con:
	'((letrec*
   (... match-seq (match-alt (-> (λ (re f) ...) <-)) match-rep ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-null? pat2)
   ((#f) (-> (match (app regex-empty? pat1) ...) <-))
   _)
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-null? pat)
   ((#f) (-> (match (app regex-empty? pat) ...) <-))
   _)
  (env ()))
clos/con:
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match (app regex-null? re) ((#f) (-> (match (app eq? c re) ...) <-)) _)
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec* (... match-alt (match-rep (-> (λ (re f) ...) <-)) seq ...) ...)
  (env ()))
clos/con:
	'((letrec* (... match-alt (match-rep (-> (λ (re f) ...) <-)) seq ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> (app regex-empty? re) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> car <-) (app cdr cadr-v)) (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (p) (-> (app car (app cdr p)) <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app f (app cadr re) (-> (app caddr re) <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (re) (-> (app eq? re (app #f)) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app match-seq re (-> (λ (pat1 pat2) ...) <-)) (env ()))
clos/con:
	'((app match-seq re (-> (λ (pat1 pat2) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil))))
  (env ()))
clos/con:
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> regex-alt? <-) re) (env ()))
clos/con:
	'((letrec*
   (... regex-BLANK (regex-alt? (-> (λ (re) ...) <-)) regex-seq? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> (app regex-null? re) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) pat1 (app cons pat2 (app nil))) (env ()))
clos/con:
	'((app (-> cons <-) pat1 (app cons pat2 (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app eq? (-> re <-) (app #f)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app car (-> data <-)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    'foo
    (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    'seq
    (->
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
    (-> (app cons 'foo (app cons 'bar (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'alt (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'foo (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con cons (app cons 'rep (-> (app cons pat (app nil)) <-))) (env ()))
	'((con cons (app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ () (-> 'do-nothing <-)) (env ()))
clos/con:
	'((λ () (-> 'do-nothing <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app seq (app regex-derivative pat1 c) (-> pat2 <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
clos/con:
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (cdr-v) (-> (match cdr-v ...) <-)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    'foo
    (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    'seq
    (->
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
     <-)))
  (env ()))
	'((con cons (app cons 'alt (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'foo (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con cons (app cons 'rep (-> (app cons pat (app nil)) <-))) (env ()))
	'((con cons (app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> pat <-) (app nil)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 'rep (app cons pat (app nil))) (env ()))
clos/con:
	'((app (-> cons <-) 'rep (app cons pat (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (app regex-empty? re) (#f) (_ (-> (app #t) <-))) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cdr (-> p <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ()))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-null? pat1)
   ((#f) (-> (match (app regex-null? pat2) ...) <-))
   _)
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app and (app regex-seq? re) (-> (app f (app cadr re) (app caddr re)) <-))
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> match-seq <-) re (λ (pat1 pat2) ...)) (env ()))
clos/con:
	'((letrec*
   (... regex-atom? (match-seq (-> (λ (re f) ...) <-)) match-alt ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cadr (-> re <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app regex-null? (-> re <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> car <-) re) (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app regex-derivative pat2 (-> c <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> eq? <-) (app car re) 'alt) (env ()))
clos/con:
	#<procedure:do-equal>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ()))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app regex-seq? (-> re <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (app regex-rep? re) ((#f) (-> (app #f) <-)) _) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app and (-> (app pair? re) <-) (app eq? (app car re) 'rep)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app f (-> (app cadr re) <-) (app caddr re)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app alt (-> (app regex-derivative pat1 c) <-) (app regex-derivative pat2 c))
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2))
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cadr <-) re) (env ()))
clos/con:
	'((letrec* (... cdr (cadr (-> (λ (cadr-v) ...) <-)) caddr ...) ...) (env ()))
	'((letrec* (... debug-trace (cadr (-> (λ (p) ...) <-)) caddr ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (app eq? c re) (#f) (_ (-> regex-BLANK <-))) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons 'rep (-> (app cons pat (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons 'rep (-> (app cons pat (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app cons (app cons 'rep (app cons 'bar (app nil))) (-> (app nil) <-))
  (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons pat (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   regex-match
   (app
    cons
    'seq
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
   (-> (app cons 'foo (app cons 'bar (app nil))) <-))
  (env ()))
clos/con:
	'((con
   cons
   (app
    regex-match
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
    (-> (app cons 'foo (app cons 'bar (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ()))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   regex-match
   (-> (app regex-derivative pattern (app car data)) <-)
   (app cdr data))
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cdr (-> p <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (pat1 pat2) (-> (match (app regex-null? pat1) ...) <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> 'bar <-) (app nil)) (env ()))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app eq? (app car re) (-> 'rep <-)) (env ()))
clos/con:
	'((app eq? (app car re) (-> 'rep <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (app regex-null? pat) (#f) (_ (-> regex-BLANK <-))) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec* (... alt (rep (-> (λ (pat) ...) <-)) regex-empty ...) ...)
  (env ()))
clos/con:
	'((letrec* (... alt (rep (-> (λ (pat) ...) <-)) regex-empty ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app (-> alt <-) (app regex-derivative pat1 c) (app regex-derivative pat2 c))
  (env ()))
clos/con:
	'((letrec* (... seq (alt (-> (λ (pat1 pat2) ...) <-)) rep ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app match-seq re (-> (λ (pat1 pat2) ...) <-)) (env ()))
clos/con:
	'((app match-seq re (-> (λ (pat1 pat2) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 'bar (app nil)) (env ()))
clos/con:
	'((app (-> cons <-) 'bar (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (re) (-> (app eq? re (app #t)) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec* (... seq (alt (-> (λ (pat1 pat2) ...) <-)) rep ...) ...)
  (env ()))
clos/con:
	'((letrec* (... seq (alt (-> (λ (pat1 pat2) ...) <-)) rep ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app match-rep (-> re <-) (λ (pat) ...)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app match-seq (-> re <-) (λ (pat1 pat2) ...)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app null? (-> data <-)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    'foo
    (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    'seq
    (->
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
    (-> (app cons 'foo (app cons 'bar (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'alt (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'foo (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con cons (app cons 'rep (-> (app cons pat (app nil)) <-))) (env ()))
	'((con cons (app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (pair?-v) (-> (match pair?-v ...) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> (app regex-empty? re) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> (app regex-null? pat) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-null? pat1)
   ((#f) (-> (match (app regex-null? pat2) ...) <-))
   _)
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> symbol? <-) re) (env ()))
clos/con:
	#<procedure:do-symbol?>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match (app eq? c re) ((#f) (-> (match (app regex-atom? re) ...) <-)) _)
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app rep (-> pat <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> or <-) (app char? re) (app symbol? re)) (env ()))
clos/con:
	#<procedure:do-or>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> regex-rep? <-) re) (env ()))
clos/con:
	'((letrec*
   (... regex-seq? (regex-rep? (-> (λ (re) ...) <-)) regex-null? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> regex-null? <-) re) (env ()))
clos/con:
	'((letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app car (-> re <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   alt
   (app seq (app regex-derivative pat1 c) pat2)
   (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-))
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match null?-v (nil) (_ (-> (app #f) <-))) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app pair? (-> re <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons 'rep (-> (app cons 'bar (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ()))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> regex-empty? <-) re) (env ()))
clos/con:
	'((letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> regex-derivative <-) pat2 c) (env ()))
clos/con:
	'((letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) regex-match ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app regex-rep? (-> re <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (λ (re f)
    (-> (app and (app regex-seq? re) (app f (app cadr re) (app caddr re))) <-))
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match
   (app match-alt re (λ (pat1 pat2) ...))
   ((#f) (-> (match (app match-rep re (λ (pat) ...)) ...) <-))
   c-x)
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> regex-empty <-) pattern) (env ()))
clos/con:
	'((letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app regex-null? (-> pat2 <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (let (... () (_ (-> (app debug-trace) <-)) () ...) ...) (env ()))
clos/con:
	'((λ () (-> 'do-nothing <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (re c) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons pat2 (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (app regex-null? pat1) (#f) (_ (-> pat2 <-))) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil))))
  (env ()))
clos/con:
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app f (-> (app cadr re) <-) (app caddr re)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   'foo
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
clos/con:
	'((app
   (-> cons <-)
   'foo
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... regex-BLANK (regex-alt? (-> (λ (re) ...) <-)) regex-seq? ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... regex-BLANK (regex-alt? (-> (λ (re) ...) <-)) regex-seq? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cdr (-> (app cdr p) <-)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    'foo
    (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    'seq
    (->
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
     <-)))
  (env ()))
	'((con cons (app cons 'alt (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'foo (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con cons (app cons 'rep (-> (app cons pat (app nil)) <-))) (env ()))
	'((con cons (app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app regex-empty? (-> re <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> regex-atom? <-) re) (env ()))
clos/con:
	'((letrec*
   (... regex-empty? (regex-atom? (-> (λ (re) ...) <-)) match-seq ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app and (app pair? re) (-> (app eq? (app car re) 'rep) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> regex-derivative <-) pat2 c) (env ()))
clos/con:
	'((letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) regex-match ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app (-> seq <-) (app regex-empty pat1) (app regex-empty pat2))
  (env ()))
clos/con:
	'((letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app (-> cons <-) 'alt (app cons pat1 (app cons pat2 (app nil))))
  (env ()))
clos/con:
	'((app (-> cons <-) 'alt (app cons pat1 (app cons pat2 (app nil)))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app seq (-> (app regex-derivative pat1 c) <-) pat2) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app seq (-> (app regex-derivative pat c) <-) (app rep pat)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> car-v <-) (cons car-c car-d)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    cons
    'foo
    (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    'seq
    (->
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
    (-> (app cons 'foo (app cons 'bar (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
	'((con cons (app cons 'alt (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'foo (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con cons (app cons 'rep (-> (app cons pat (app nil)) <-))) (env ()))
	'((con cons (app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (λ (re f)
    (-> (app and (app regex-alt? re) (app f (app cadr re) (app caddr re))) <-))
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> debug-trace <-)) (env ()))
clos/con:
	'((letrec* (... null? (debug-trace (-> (λ () ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... regex-seq? (regex-rep? (-> (λ (re) ...) <-)) regex-null? ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... regex-seq? (regex-rep? (-> (λ (re) ...) <-)) regex-null? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   regex-match
   (app regex-derivative pattern (app car data))
   (-> (app cdr data) <-))
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    'foo
    (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    'seq
    (->
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
     <-)))
  (env ()))
	'((con cons (app cons 'alt (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'foo (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con cons (app cons 'rep (-> (app cons pat (app nil)) <-))) (env ()))
	'((con cons (app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons pat1 (-> (app cons pat2 (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> car <-) (app cdr p)) (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (app regex-atom? re) (#f) (_ (-> (app #f) <-))) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> f <-) (app cadr re) (app caddr re)) (env ()))
clos/con:
	'((app match-alt re (-> (λ (pat1 pat2) ...) <-)) (env ()))
	'((app match-alt re (-> (λ (pat1 pat2) ...) <-)) (env ()))
	'((app match-rep re (-> (λ (pat) ...) <-)) (env ()))
	'((app match-seq re (-> (λ (pat1 pat2) ...) <-)) (env ()))
	'((app match-seq re (-> (λ (pat1 pat2) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> (app regex-null? pat2) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> regex-empty <-) pat2) (env ()))
clos/con:
	'((letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app regex-empty (-> pat2 <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cdr <-) cadr-v) (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   regex-match
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
    <-)
   (app cons 'foo (app cons 'bar (app nil))))
  (env ()))
clos/con:
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-))) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    'foo
    (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    'seq
    (->
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
     <-)))
  (env ()))
	'((con cons (app cons 'alt (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'foo (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con cons (app cons 'rep (-> (app cons pat (app nil)) <-))) (env ()))
	'((con cons (app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: ((top) lettypes (cons ... nil) ...) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> regex-derivative <-) pat c) (env ()))
clos/con:
	'((letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) regex-match ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app match-alt (-> re <-) (λ (pat1 pat2) ...)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> (app regex-atom? re) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x)
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app caddr (-> re <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> eq? <-) (app car re) 'seq) (env ()))
clos/con:
	#<procedure:do-equal>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> regex-derivative <-) pattern (app car data)) (env ()))
clos/con:
	'((letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) regex-match ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x)
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cdr <-) cadr-v) (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> seq <-) (app regex-derivative pat1 c) pat2) (env ()))
clos/con:
	'((letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cdr <-) data) (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app regex-empty (-> pat1 <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> pat2 <-) (app nil)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app equal? check (-> expect <-)) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env ()))
clos/con:
	'((letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> car <-) (app cdr (app cdr p))) (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app regex-derivative (-> pat <-) c) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app regex-derivative pat (-> c <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> match-alt <-) re (λ (pat1 pat2) ...)) (env ()))
clos/con:
	'((letrec*
   (... match-seq (match-alt (-> (λ (re f) ...) <-)) match-rep ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   check-expect
   (->
    (app
     regex-match
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     (app cons 'foo (app cons 'bar (app nil))))
    <-)
   (app #f))
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (λ (pat1 pat2)
    (->
     (app alt (app regex-derivative pat1 c) (app regex-derivative pat2 c))
     <-))
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (app regex-atom? re) (#f) (_ (-> regex-NULL <-))) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (cadr-v) (-> (app car (app cdr cadr-v)) <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app car (-> re <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> eq? <-) re (app #t)) (env ()))
clos/con:
	#<procedure:do-equal>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> car <-) data) (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match (app match-seq re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> pair?-v <-) (cons pair?-c pair?-d) _) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
   _)
  (env ()))
clos/con:
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cdr <-) (app cdr cadr-v)) (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   'seq
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
clos/con:
	'((app
   (-> cons <-)
   'seq
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-))
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons pat2 (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
clos/con:
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app symbol? (-> re <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app eq? c (-> re <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app pair? (-> re <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cdr (-> cadr-v <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match pair?-v ((cons pair?-c pair?-d) (-> (app #t) <-)) _) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (null?-v) (-> (match null?-v ...) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> eq? <-) (app car re) 'rep) (env ()))
clos/con:
	#<procedure:do-equal>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (check expect) (-> (app equal? check expect) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match
   (app null? data)
   (#f)
   (_ (-> (app regex-empty? (app regex-empty pattern)) <-)))
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app eq? (-> c <-) re) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app and (-> (app regex-seq? re) <-) (app f (app cadr re) (app caddr re)))
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> f <-) (app cadr re)) (env ()))
clos/con:
	'((app match-alt re (-> (λ (pat1 pat2) ...) <-)) (env ()))
	'((app match-alt re (-> (λ (pat1 pat2) ...) <-)) (env ()))
	'((app match-rep re (-> (λ (pat) ...) <-)) (env ()))
	'((app match-seq re (-> (λ (pat1 pat2) ...) <-)) (env ()))
	'((app match-seq re (-> (λ (pat1 pat2) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   cons
   'foo
   (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-))
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    'foo
    (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> pat1 <-) (app cons pat2 (app nil))) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app eq? re (-> (app #f) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> regex-empty? <-) re) (env ()))
clos/con:
	'((letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app match-seq (-> re <-) (λ (pat1 pat2) ...)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> regex-empty <-) pat1) (env ()))
clos/con:
	'((letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> car <-) re) (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app eq? (app car re) (-> 'seq <-)) (env ()))
clos/con:
	'((app eq? (app car re) (-> 'seq <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-empty? pat1)
   ((#f) (-> (match (app regex-empty? pat2) ...) <-))
   _)
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) regex-match ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) regex-match ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> regex-seq? <-) re) (env ()))
clos/con:
	'((letrec*
   (... regex-alt? (regex-seq? (-> (λ (re) ...) <-)) regex-rep? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ()))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> regex-empty? <-) (app regex-empty pattern)) (env ()))
clos/con:
	'((letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> rep <-) pat) (env ()))
clos/con:
	'((letrec* (... alt (rep (-> (λ (pat) ...) <-)) regex-empty ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> seq <-) (app regex-derivative pat c) (app rep pat)) (env ()))
clos/con:
	'((letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app regex-empty? (-> pat <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) pat2 (app nil)) (env ()))
clos/con:
	'((app (-> cons <-) pat2 (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ()))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   check-expect
   (app
    regex-match
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
    (app cons 'foo (app cons 'bar (app nil))))
   (-> (app #f) <-))
  (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-))
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ()))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ()))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> caddr <-) re) (env ()))
clos/con:
	'((letrec* (... cadr (caddr (-> (λ (cadr-v) ...) <-)) pair? ...) ...) (env ()))
	'((letrec* (... cadr (caddr (-> (λ (p) ...) <-)) regex-NULL ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (let (_) (-> (match (app regex-empty? re) ...) <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> regex-null? <-) pat2) (env ()))
clos/con:
	'((letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... regex-empty? (regex-atom? (-> (λ (re) ...) <-)) match-seq ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... regex-empty? (regex-atom? (-> (λ (re) ...) <-)) match-seq ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   (-> regex-match <-)
   (app regex-derivative pattern (app car data))
   (app cdr data))
  (env ()))
clos/con:
	'((letrec*
   (...
    regex-derivative
    (regex-match (-> (λ (pattern data) ...) <-))
    check-expect
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app and (app regex-rep? re) (-> (app f (app cadr re)) <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec*
   (car ... check-expect)
   (->
    (app
     check-expect
     (app
      regex-match
      (app
       cons
       'seq
       (app
        cons
        'foo
        (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
      (app cons 'foo (app cons 'bar (app nil))))
     (app #f))
    <-))
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> regex-empty <-) pat1) (env ()))
clos/con:
	'((letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cdr <-) p) (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app eq? (-> re <-) (app #t)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 'foo (app cons 'bar (app nil))) (env ()))
clos/con:
	'((app (-> cons <-) 'foo (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match
   (app match-seq re (λ (pat1 pat2) ...))
   ((#f) (-> (match (app match-alt re (λ (pat1 pat2) ...)) ...) <-))
   c-x)
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app regex-derivative (-> pattern <-) (app car data)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match (app match-rep re (λ (pat) ...)) (#f) (c-x (-> c-x <-)))
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> car <-) (app cdr (app cdr cadr-v))) (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (car-v) (-> (match car-v ...) <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match (app match-alt re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cdr (-> data <-)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    'foo
    (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    'seq
    (->
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
    (-> (app cons 'foo (app cons 'bar (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'alt (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'foo (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con cons (app cons 'rep (-> (app cons pat (app nil)) <-))) (env ()))
	'((con cons (app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> char? <-) re) (env ()))
clos/con:
	#<procedure:do-char?>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app regex-null? (-> pat <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app regex-derivative pat2 (-> c <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app regex-derivative (-> pat2 <-) c) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> regex-null? <-) pat1) (env ()))
clos/con:
	'((letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> regex-empty? <-) pat1) (env ()))
clos/con:
	'((letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app and (-> (app regex-rep? re) <-) (app f (app cadr re))) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app regex-null? (-> pat2 <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app eq? (-> (app car re) <-) 'rep) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> pair? <-) re) (env ()))
clos/con:
	'((letrec* (... caddr (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> regex-null? <-) pat1) (env ()))
clos/con:
	'((letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match (app match-seq re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... match-seq (match-alt (-> (λ (re f) ...) <-)) match-rep ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... match-seq (match-alt (-> (λ (re f) ...) <-)) match-rep ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec* (... null? (debug-trace (-> (λ () ...) <-)) cadr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... null? (debug-trace (-> (λ () ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app eq? (-> (app car re) <-) 'seq) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (λ (re) (-> (app and (app pair? re) (app eq? (app car re) 'alt)) <-))
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> pair? <-) re) (env ()))
clos/con:
	'((letrec* (... caddr (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> (app regex-null? pat1) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app regex-empty (-> pat1 <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> regex-empty <-) pat2) (env ()))
clos/con:
	'((letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app and (app regex-alt? re) (-> (app f (app cadr re) (app caddr re)) <-))
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> match-rep <-) re (λ (pat) ...)) (env ()))
clos/con:
	'((letrec* (... match-alt (match-rep (-> (λ (re f) ...) <-)) seq ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ()))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> eq? <-) c re) (env ()))
clos/con:
	#<procedure:do-equal>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match
   (app match-seq re (λ (pat1 pat2) ...))
   ((#f) (-> (match (app match-alt re (λ (pat1 pat2) ...)) ...) <-))
   c-x)
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> regex-empty <-) pat1) (env ()))
clos/con:
	'((letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cdr (-> (app cdr cadr-v) <-)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    'foo
    (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    'seq
    (->
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
     <-)))
  (env ()))
	'((con cons (app cons 'alt (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'foo (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con cons (app cons 'rep (-> (app cons pat (app nil)) <-))) (env ()))
	'((con cons (app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> regex-empty? <-) pat2) (env ()))
clos/con:
	'((letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app (-> and <-) (app regex-seq? re) (app f (app cadr re) (app caddr re)))
  (env ()))
clos/con:
	#<procedure:do-and>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> f <-) (app cadr re) (app caddr re)) (env ()))
clos/con:
	'((app match-alt re (-> (λ (pat1 pat2) ...) <-)) (env ()))
	'((app match-alt re (-> (λ (pat1 pat2) ...) <-)) (env ()))
	'((app match-rep re (-> (λ (pat) ...) <-)) (env ()))
	'((app match-seq re (-> (λ (pat1 pat2) ...) <-)) (env ()))
	'((app match-seq re (-> (λ (pat1 pat2) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (λ (pat1 pat2)
    (-> (app alt (app regex-empty pat1) (app regex-empty pat2)) <-))
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cadr (-> re <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-atom? re)
   ((#f) (-> (match (app match-seq re (λ (pat1 pat2) ...)) ...) <-))
   _)
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (app regex-empty? pat) (#f) (_ (-> regex-BLANK <-))) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app car (-> (app cdr cadr-v) <-)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    'foo
    (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    'seq
    (->
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
     <-)))
  (env ()))
	'((con cons (app cons 'alt (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'foo (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con cons (app cons 'rep (-> (app cons pat (app nil)) <-))) (env ()))
	'((con cons (app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   (-> check-expect <-)
   (app
    regex-match
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
    (app cons 'foo (app cons 'bar (app nil))))
   (app #f))
  (env ()))
clos/con:
	'((letrec*
   (... regex-match (check-expect (-> (λ (check expect) ...) <-)) () ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> and <-) (app pair? re) (app eq? (app car re) 'alt)) (env ()))
clos/con:
	#<procedure:do-and>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> match-seq <-) re (λ (pat1 pat2) ...)) (env ()))
clos/con:
	'((letrec*
   (... regex-atom? (match-seq (-> (λ (re f) ...) <-)) match-alt ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app regex-alt? (-> re <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> regex-null? <-) pat) (env ()))
clos/con:
	'((letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app match-alt re (-> (λ (pat1 pat2) ...) <-)) (env ()))
clos/con:
	'((app match-alt re (-> (λ (pat1 pat2) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> equal? <-) check expect) (env ()))
clos/con:
	#<procedure:do-equal>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> and <-) (app regex-rep? re) (app f (app cadr re))) (env ()))
clos/con:
	#<procedure:do-and>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> regex-rep? <-) re) (env ()))
clos/con:
	'((letrec*
   (... regex-seq? (regex-rep? (-> (λ (re) ...) <-)) regex-null? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cdr <-) p) (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match pair?-v (cons pair?-c pair?-d) (_ (-> (app #f) <-))) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (pat) (-> (match (app regex-null? pat) ...) <-)) (env ()))
clos/con:
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> (app regex-empty? pat) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-atom? re)
   ((#f) (-> (match (app match-seq re (λ (pat1 pat2) ...)) ...) <-))
   _)
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec* (... regex-NULL (regex-BLANK (-> (app #t) <-)) regex-alt? ...) ...)
  (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec* (... cadr (caddr (-> (λ (p) ...) <-)) regex-NULL ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cadr (caddr (-> (λ (p) ...) <-)) regex-NULL ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   alt
   (-> (app seq (app regex-derivative pat1 c) pat2) <-)
   (app seq (app regex-empty pat1) (app regex-derivative pat2 c)))
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app regex-derivative (-> pat2 <-) c) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match
   (app null? data)
   ((#f)
    (->
     (app
      regex-match
      (app regex-derivative pattern (app car data))
      (app cdr data))
     <-))
   _)
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app regex-null? (-> pat1 <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
clos/con:
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec* (... cdr (cadr (-> (λ (cadr-v) ...) <-)) caddr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cdr (cadr (-> (λ (cadr-v) ...) <-)) caddr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2))
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x)
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app and (-> (app pair? re) <-) (app eq? (app car re) 'seq)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (app regex-null? re) (#f) (_ (-> (app #f) <-))) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   (-> regex-match <-)
   (app
    cons
    'seq
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
   (app cons 'foo (app cons 'bar (app nil))))
  (env ()))
clos/con:
	'((letrec*
   (...
    regex-derivative
    (regex-match (-> (λ (pattern data) ...) <-))
    check-expect
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (app regex-rep? re) (#f) (_ (-> (app #t) <-))) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app alt (app regex-derivative pat1 c) (-> (app regex-derivative pat2 c) <-))
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app regex-null? (-> re <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app (-> and <-) (app regex-alt? re) (app f (app cadr re) (app caddr re)))
  (env ()))
clos/con:
	#<procedure:do-and>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match (app match-alt re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil))) <-))
  (env ()))
clos/con:
	'((con cons (app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 'bar (app nil)) (env ()))
clos/con:
	'((app (-> cons <-) 'bar (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... regex-alt? (regex-seq? (-> (λ (re) ...) <-)) regex-rep? ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... regex-alt? (regex-seq? (-> (λ (re) ...) <-)) regex-rep? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match
   (app match-alt re (λ (pat1 pat2) ...))
   ((#f) (-> (match (app regex-rep? re) ...) <-))
   c-x)
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app car (-> (app cdr (app cdr p)) <-)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    'foo
    (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    'seq
    (->
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
     <-)))
  (env ()))
	'((con cons (app cons 'alt (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'foo (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con cons (app cons 'rep (-> (app cons pat (app nil)) <-))) (env ()))
	'((con cons (app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> caddr <-) re) (env ()))
clos/con:
	'((letrec* (... cadr (caddr (-> (λ (cadr-v) ...) <-)) pair? ...) ...) (env ()))
	'((letrec* (... cadr (caddr (-> (λ (p) ...) <-)) regex-NULL ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app regex-empty? (-> (app regex-empty pattern) <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app regex-derivative (-> pat1 <-) c) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec* (... cadr (caddr (-> (λ (cadr-v) ...) <-)) pair? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cadr (caddr (-> (λ (cadr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match null?-v ((nil) (-> (app #t) <-)) _) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cadr (-> re <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> (app regex-empty? pat1) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app eq? (app car re) (-> 'alt <-)) (env ()))
clos/con:
	'((app eq? (app car re) (-> 'alt <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> null?-v <-) (nil) _) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    'foo
    (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    'seq
    (->
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
    (-> (app cons 'foo (app cons 'bar (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'alt (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'foo (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con cons (app cons 'rep (-> (app cons pat (app nil)) <-))) (env ()))
	'((con cons (app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app regex-atom? (-> re <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (app regex-null? pat1) (#f) (_ (-> regex-NULL <-))) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app and (-> (app regex-alt? re) <-) (app f (app cadr re) (app caddr re)))
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app car (-> re <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app f (app cadr re) (-> (app caddr re) <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
clos/con:
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> eq? <-) re (app #f)) (env ()))
clos/con:
	#<procedure:do-equal>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... regex-atom? (match-seq (-> (λ (re f) ...) <-)) match-alt ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... regex-atom? (match-seq (-> (λ (re f) ...) <-)) match-alt ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> regex-atom? <-) re) (env ()))
clos/con:
	'((letrec*
   (... regex-empty? (regex-atom? (-> (λ (re) ...) <-)) match-seq ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ()))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app match-rep re (-> (λ (pat) ...) <-)) (env ()))
clos/con:
	'((app match-rep re (-> (λ (pat) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> (app eq? c re) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cdr <-) (app cdr p)) (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> (app regex-rep? re) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec* (... caddr (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... caddr (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (p) (-> (app car (app cdr (app cdr p))) <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec* (... debug-trace (cadr (-> (λ (p) ...) <-)) caddr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... debug-trace (cadr (-> (λ (p) ...) <-)) caddr ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons pat1 (-> (app cons pat2 (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app and (app pair? re) (-> (app eq? (app car re) 'alt) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app regex-derivative pattern (-> (app car data) <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app regex-empty? (-> pat2 <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-empty? re)
   ((#f) (-> (match (app regex-null? re) ...) <-))
   _)
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ()))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app match-alt re (-> (λ (pat1 pat2) ...) <-)) (env ()))
clos/con:
	'((app match-alt re (-> (λ (pat1 pat2) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app equal? (-> check <-) expect) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app char? (-> re <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app car (-> (app cdr p) <-)) (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    'foo
    (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    'seq
    (->
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
     <-)))
  (env ()))
	'((con cons (app cons 'alt (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'foo (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con cons (app cons 'rep (-> (app cons pat (app nil)) <-))) (env ()))
	'((con cons (app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons 'bar (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> (app regex-empty? pat2) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app regex-rep? (-> re <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (app regex-null? pat2) (#f) (_ (-> pat1 <-))) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app (-> seq <-) (app regex-empty pat1) (app regex-derivative pat2 c))
  (env ()))
clos/con:
	'((letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match car-v ((cons car-c car-d) (-> car-c <-))) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) pat1 (app cons pat2 (app nil))) (env ()))
clos/con:
	'((app (-> cons <-) pat1 (app cons pat2 (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app seq (-> (app regex-empty pat1) <-) (app regex-derivative pat2 c))
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> 'bar <-) (app nil)) (env ()))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> (app regex-atom? re) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> car <-) re) (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app or (-> (app char? re) <-) (app symbol? re)) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-))
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app regex-atom? (-> re <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app regex-derivative pat1 (-> c <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match (app match-rep re (λ (pat) ...)) ((#f) (-> regex-NULL <-)) c-x)
  (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) pat (app nil)) (env ()))
clos/con:
	'((app (-> cons <-) pat (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x)
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec* (... caddr (regex-NULL (-> (app #f) <-)) regex-BLANK ...) ...)
  (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-null? re)
   ((#f) (-> (match (app regex-atom? re) ...) <-))
   _)
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
   _)
  (env ()))
clos/con:
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (app regex-null? pat2) (#f) (_ (-> regex-NULL <-))) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (re) (-> (app or (app char? re) (app symbol? re)) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> regex-derivative <-) pat1 c) (env ()))
clos/con:
	'((letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) regex-match ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app
   (-> alt <-)
   (app seq (app regex-derivative pat1 c) pat2)
   (app seq (app regex-empty pat1) (app regex-derivative pat2 c)))
  (env ()))
clos/con:
	'((letrec* (... seq (alt (-> (λ (pat1 pat2) ...) <-)) rep ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cdr (-> cadr-v <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-empty? re)
   ((#f) (-> (match (app regex-null? re) ...) <-))
   _)
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app caddr (-> re <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app (-> cons <-) (app cons 'rep (app cons 'bar (app nil))) (app nil))
  (env ()))
clos/con:
	'((app (-> cons <-) (app cons 'rep (app cons 'bar (app nil))) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (app regex-empty? pat2) (#f) (_ (-> pat1 <-))) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (app regex-empty? pat1) (#f) (_ (-> pat2 <-))) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app pair? (-> re <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... regex-match (check-expect (-> (λ (check expect) ...) <-)) () ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... regex-match (check-expect (-> (λ (check expect) ...) <-)) () ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app match-alt (-> re <-) (λ (pat1 pat2) ...)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app (-> alt <-) (app regex-empty pat1) (app regex-empty pat2))
  (env ()))
clos/con:
	'((letrec* (... seq (alt (-> (λ (pat1 pat2) ...) <-)) rep ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (λ (pat1 pat2)
    (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-))
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app f (-> (app cadr re) <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app or (app char? re) (-> (app symbol? re) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> (app null? data) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app eq? re (-> (app #t) <-)) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app seq (app regex-derivative pat c) (-> (app rep pat) <-)) (env ()))
clos/con:
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ()))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> pat1 <-) (app cons pat2 (app nil))) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> (app regex-null? re) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app and (app pair? re) (-> (app eq? (app car re) 'seq) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app regex-derivative (-> pat1 <-) c) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    regex-derivative
    (regex-match (-> (λ (pattern data) ...) <-))
    check-expect
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    regex-derivative
    (regex-match (-> (λ (pattern data) ...) <-))
    check-expect
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> regex-empty? <-) pat) (env ()))
clos/con:
	'((letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (pattern data) (-> (match (app null? data) ...) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (cadr-v) (-> (app car (app cdr (app cdr cadr-v))) <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (lettypes cons ... nil (letrec* (car ... check-expect) ...)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 'rep (app cons 'bar (app nil))) (env ()))
clos/con:
	'((app (-> cons <-) 'rep (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons (-> pat2 <-) (app nil)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app regex-empty (-> pattern <-)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (λ (re f) (-> (app and (app regex-rep? re) (app f (app cadr re))) <-))
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app cons 'foo (-> (app cons 'bar (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons 'foo (-> (app cons 'bar (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: car-c (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  (app
   cons
   'foo
   (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-))
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    'foo
    (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: regex-seq? (env ()))
clos/con:
	'((letrec*
   (... regex-alt? (regex-seq? (-> (λ (re) ...) <-)) regex-rep? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  (app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
clos/con:
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: cadr (env ()))
clos/con:
	'((letrec* (... cdr (cadr (-> (λ (cadr-v) ...) <-)) caddr ...) ...) (env ()))
	'((letrec* (... debug-trace (cadr (-> (λ (p) ...) <-)) caddr ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: c (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
clos/con:
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  (app cons (app cons 'rep (app cons 'bar (app nil))) (-> (app nil) <-))
  (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons 'rep (-> (app cons pat (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons 'rep (-> (app cons pat (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: expect (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: car-d (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    'foo
    (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    'seq
    (->
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
     <-)))
  (env ()))
	'((con cons (app cons 'alt (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'foo (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con cons (app cons 'rep (-> (app cons pat (app nil)) <-))) (env ()))
	'((con cons (app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  (app cons 'alt (-> (app cons pat1 (app cons pat2 (app nil))) <-))
  (env ()))
clos/con:
	'((con cons (app cons 'alt (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: cdr (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: cdr-c (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: regex-rep? (env ()))
clos/con:
	'((letrec*
   (... regex-seq? (regex-rep? (-> (λ (re) ...) <-)) regex-null? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons (-> pat1 <-) (app cons pat2 (app nil))) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: re (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: p (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: match-alt (env ()))
clos/con:
	'((letrec*
   (... match-seq (match-alt (-> (λ (re f) ...) <-)) match-rep ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: pat1 (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons (-> pat1 <-) (app cons pat2 (app nil))) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: cdr-v (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    cons
    'foo
    (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    'seq
    (->
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
    (-> (app cons 'foo (app cons 'bar (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
	'((con cons (app cons 'alt (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'foo (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con cons (app cons 'rep (-> (app cons pat (app nil)) <-))) (env ()))
	'((con cons (app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: cdr-d (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    'foo
    (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    'seq
    (->
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
     <-)))
  (env ()))
	'((con cons (app cons 'alt (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'foo (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con cons (app cons 'rep (-> (app cons pat (app nil)) <-))) (env ()))
	'((con cons (app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
clos/con:
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons (-> pat2 <-) (app nil)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons 'bar (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: regex-atom? (env ()))
clos/con:
	'((letrec*
   (... regex-empty? (regex-atom? (-> (λ (re) ...) <-)) match-seq ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: pat (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
clos/con:
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons (-> pat <-) (app nil)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: regex-derivative (env ()))
clos/con:
	'((letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) regex-match ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: pair?-d (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    'seq
    (->
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
     <-)))
  (env ()))
	'((con cons (app cons 'alt (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con cons (app cons 'rep (-> (app cons pat (app nil)) <-))) (env ()))
	'((con cons (app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: c-x (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: null?-v (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    'foo
    (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    'seq
    (->
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
    (-> (app cons 'foo (app cons 'bar (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'alt (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'foo (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con cons (app cons 'rep (-> (app cons pat (app nil)) <-))) (env ()))
	'((con cons (app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: cadr-v (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons pat1 (-> (app cons pat2 (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: debug-trace (env ()))
clos/con:
	'((letrec* (... null? (debug-trace (-> (λ () ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons pat2 (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  (app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil))))
  (env ()))
clos/con:
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: pair?-v (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: _ (env ()))
clos/con:
	'((λ () (-> 'do-nothing <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  (app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil))))
  (env ()))
clos/con:
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: alt (env ()))
clos/con:
	'((letrec* (... seq (alt (-> (λ (pat1 pat2) ...) <-)) rep ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: pair? (env ()))
clos/con:
	'((letrec* (... caddr (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons pat (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: pat2 (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons pat1 (-> (app cons pat2 (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: regex-match (env ()))
clos/con:
	'((letrec*
   (...
    regex-derivative
    (regex-match (-> (λ (pattern data) ...) <-))
    check-expect
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: car-v (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    cons
    'foo
    (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    'seq
    (->
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
    (-> (app cons 'foo (app cons 'bar (app nil))) <-)))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
	'((con cons (app cons 'alt (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'foo (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con cons (app cons 'rep (-> (app cons pat (app nil)) <-))) (env ()))
	'((con cons (app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: data (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    'foo
    (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-)))
  (env ()))
	'((con
   cons
   (app
    cons
    'seq
    (->
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
     <-)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
    (-> (app cons 'foo (app cons 'bar (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'alt (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
	'((con cons (app cons 'foo (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con cons (app cons 'rep (-> (app cons pat (app nil)) <-))) (env ()))
	'((con cons (app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  (app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
    <-))
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    'seq
    (->
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
     <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: regex-alt? (env ()))
clos/con:
	'((letrec*
   (... regex-BLANK (regex-alt? (-> (λ (re) ...) <-)) regex-seq? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons (-> pat2 <-) (app nil)) (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons pat2 (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons (-> 'bar <-) (app nil)) (env ()))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: seq (env ()))
clos/con:
	'((letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons (-> 'bar <-) (app nil)) (env ()))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: pair?-c (env ()))
clos/con:
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: check (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  (app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil))) <-))
  (env ()))
clos/con:
	'((con cons (app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: regex-null? (env ()))
clos/con:
	'((letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: rep (env ()))
clos/con:
	'((letrec* (... alt (rep (-> (λ (pat) ...) <-)) regex-empty ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: regex-empty (env ()))
clos/con:
	'((letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: match-rep (env ()))
clos/con:
	'((letrec* (... match-alt (match-rep (-> (λ (re f) ...) <-)) seq ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: null? (env ()))
clos/con:
	'((letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) debug-trace ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: match-seq (env ()))
clos/con:
	'((letrec*
   (... regex-atom? (match-seq (-> (λ (re f) ...) <-)) match-alt ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: regex-NULL (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: pattern (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env ()))
	'((con
   cons
   (app
    regex-match
    (->
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     <-)
    (app cons 'foo (app cons 'bar (app nil)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
    _))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: f (env ()))
clos/con:
	'((app match-alt re (-> (λ (pat1 pat2) ...) <-)) (env ()))
	'((app match-alt re (-> (λ (pat1 pat2) ...) <-)) (env ()))
	'((app match-rep re (-> (λ (pat) ...) <-)) (env ()))
	'((app match-seq re (-> (λ (pat1 pat2) ...) <-)) (env ()))
	'((app match-seq re (-> (λ (pat1 pat2) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store:
  (app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: caddr (env ()))
clos/con:
	'((letrec* (... cadr (caddr (-> (λ (cadr-v) ...) <-)) pair? ...) ...) (env ()))
	'((letrec* (... cadr (caddr (-> (λ (p) ...) <-)) regex-NULL ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: check-expect (env ()))
clos/con:
	'((letrec*
   (... regex-match (check-expect (-> (λ (check expect) ...) <-)) () ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: car (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: regex-BLANK (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons 'foo (-> (app cons 'bar (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons 'foo (-> (app cons 'bar (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: regex-empty? (env ()))
clos/con:
	'((letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons 'bar (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(store: (app cons 'rep (-> (app cons 'bar (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)
