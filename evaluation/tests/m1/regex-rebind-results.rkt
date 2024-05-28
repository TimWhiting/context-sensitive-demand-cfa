'(expression:
  (lettypes
   ((cons car cdr) (nil))
   (letrec*
    ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
     (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
     (pair?
      (λ (pair?-v)
        (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
     (null? (λ (null?-v) (match null?-v ((nil) (app #t)) (_ (app #f)))))
     (debug-trace (λ () 'do-nothing))
     (cadr (λ (p) (app car (app cdr p))))
     (caddr (λ (p) (app car (app cdr (app cdr p)))))
     (regex-NULL (app #f))
     (regex-BLANK (app #t))
     (regex-alt?
      (λ (re)
        (match
         (app pair? re)
         ((#f) (app #f))
         (_
          (match (app eq? (app car re) 'alt) ((#f) (app #f)) (_ (app #t)))))))
     (regex-seq?
      (λ (re)
        (match
         (app pair? re)
         ((#f) (app #f))
         (_
          (match (app eq? (app car re) 'seq) ((#f) (app #f)) (_ (app #t)))))))
     (regex-rep?
      (λ (re)
        (match
         (app pair? re)
         ((#f) (app #f))
         (_
          (match (app eq? (app car re) 'rep) ((#f) (app #f)) (_ (app #t)))))))
     (regex-null? (λ (re) (app eq? re (app #f))))
     (regex-empty? (λ (re) (app eq? re (app #t))))
     (regex-atom?
      (λ (re)
        (match
         (app char? re)
         ((#f) (match (app symbol? re) ((#f) (app #f)) (_ (app #t))))
         (_ (app #t)))))
     (match-seq
      (λ (re f)
        (match
         (app regex-seq? re)
         ((#f) (app #f))
         (_
          (match
           (app f (app cadr re) (app caddr re))
           ((#f) (app #f))
           (_ (app #t)))))))
     (match-alt
      (λ (re f)
        (match
         (app regex-alt? re)
         ((#f) (app #f))
         (_
          (match
           (app f (app cadr re) (app caddr re))
           ((#f) (app #f))
           (_ (app #t)))))))
     (match-rep
      (λ (re f)
        (match
         (app regex-rep? re)
         ((#f) (app #f))
         (_ (match (app f (app cadr re)) ((#f) (app #f)) (_ (app #t)))))))
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

'(query:
  (app
   alt
   (-> (app seq (app regex-derivative pat1 c) pat2) <-)
   (app seq (app regex-empty pat1) (app regex-derivative pat2 c)))
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   alt
   (app seq (app regex-derivative pat1 c) pat2)
   (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-))
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   check-expect
   (->
    (app
     regex-match
     (app cons 'seq (app cons ...))
     (app cons 'foo (app cons ...)))
    <-)
   (app #f))
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   check-expect
   (app
    regex-match
    (app cons 'seq (app cons ...))
    (app cons 'foo (app cons ...)))
   (-> (app #f) <-))
  (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   'seq
   (-> (app cons 'foo (app cons (app cons ...) (app nil ...))) <-))
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    'seq
    (-> (app cons 'foo (app cons (app cons ...) (app nil ...))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   regex-match
   (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
   (app cons 'foo (app cons 'bar (app nil ...))))
  (env ()))
clos/con:
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   regex-match
   (-> (app regex-derivative pattern (app car data)) <-)
   (app cdr data))
  (env
   ((app
     check-expect
     (->
      (app
       regex-match
       (app cons 'seq (app cons ...))
       (app cons 'foo (app cons ...)))
      <-)
     (app #f)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   regex-match
   (-> (app regex-derivative pattern (app car data)) <-)
   (app cdr data))
  (env
   ((match
     (app null? data)
     ((#f)
      (->
       (app
        regex-match
        (app regex-derivative pattern (app car ...))
        (app cdr data))
       <-))
     _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   regex-match
   (app cons 'seq (app cons 'foo (app cons ...)))
   (-> (app cons 'foo (app cons 'bar (app nil ...))) <-))
  (env ()))
clos/con:
	'((con
   cons
   (app
    regex-match
    (app cons 'seq (app cons 'foo (app cons ...)))
    (-> (app cons 'foo (app cons 'bar (app nil ...))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   regex-match
   (app regex-derivative pattern (app car data))
   (-> (app cdr data) <-))
  (env
   ((app
     check-expect
     (->
      (app
       regex-match
       (app cons 'seq (app cons ...))
       (app cons 'foo (app cons ...)))
      <-)
     (app #f)))))
clos/con:
	'((con cons (app cons 'foo (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   regex-match
   (app regex-derivative pattern (app car data))
   (-> (app cdr data) <-))
  (env
   ((match
     (app null? data)
     ((#f)
      (->
       (app
        regex-match
        (app regex-derivative pattern (app car ...))
        (app cdr data))
       <-))
     _))))
clos/con:
	'((con cons (app cons 'foo (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f <-) (app cadr re) (app caddr re))
  (env ((match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((app match-alt re (-> (λ (pat1 pat2) ...) <-))
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
	'((app match-alt re (-> (λ (pat1 pat2) ...) <-))
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
	'((app match-alt re (-> (λ (pat1 pat2) ...) <-))
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
	'((app match-alt re (-> (λ (pat1 pat2) ...) <-))
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
	'((app match-alt re (-> (λ (pat1 pat2) ...) <-))
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
	'((app match-alt re (-> (λ (pat1 pat2) ...) <-))
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f <-) (app cadr re) (app caddr re))
  (env ((match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((app match-alt re (-> (λ (pat1 pat2) ...) <-))
  (env
   ((app seq (-> (app regex-empty pat1) <-) (app regex-derivative pat2 c)))))
	'((app match-alt re (-> (λ (pat1 pat2) ...) <-))
  (env ((app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
	'((app match-alt re (-> (λ (pat1 pat2) ...) <-))
  (env ((app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
	'((app match-alt re (-> (λ (pat1 pat2) ...) <-))
  (env ((app regex-empty? (-> (app regex-empty pattern) <-)))))
	'((app match-alt re (-> (λ (pat1 pat2) ...) <-))
  (env ((app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
	'((app match-alt re (-> (λ (pat1 pat2) ...) <-))
  (env ((app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f <-) (app cadr re) (app caddr re))
  (env ((match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((app match-seq re (-> (λ (pat1 pat2) ...) <-))
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
	'((app match-seq re (-> (λ (pat1 pat2) ...) <-))
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
	'((app match-seq re (-> (λ (pat1 pat2) ...) <-))
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
	'((app match-seq re (-> (λ (pat1 pat2) ...) <-))
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
	'((app match-seq re (-> (λ (pat1 pat2) ...) <-))
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
	'((app match-seq re (-> (λ (pat1 pat2) ...) <-))
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f <-) (app cadr re) (app caddr re))
  (env ((match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((app match-seq re (-> (λ (pat1 pat2) ...) <-))
  (env
   ((app seq (-> (app regex-empty pat1) <-) (app regex-derivative pat2 c)))))
	'((app match-seq re (-> (λ (pat1 pat2) ...) <-))
  (env ((app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
	'((app match-seq re (-> (λ (pat1 pat2) ...) <-))
  (env ((app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
	'((app match-seq re (-> (λ (pat1 pat2) ...) <-))
  (env ((app regex-empty? (-> (app regex-empty pattern) <-)))))
	'((app match-seq re (-> (λ (pat1 pat2) ...) <-))
  (env ((app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
	'((app match-seq re (-> (λ (pat1 pat2) ...) <-))
  (env ((app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f <-) (app cadr re))
  (env ((match (-> (app match-rep re (λ (pat) ...)) <-) (#f) c-x))))
clos/con:
	'((app match-rep re (-> (λ (pat) ...) <-))
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
	'((app match-rep re (-> (λ (pat) ...) <-))
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
	'((app match-rep re (-> (λ (pat) ...) <-))
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
	'((app match-rep re (-> (λ (pat) ...) <-))
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
	'((app match-rep re (-> (λ (pat) ...) <-))
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
	'((app match-rep re (-> (λ (pat) ...) <-))
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app alt (-> (app regex-derivative pat1 c) <-) (app regex-derivative pat2 c))
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2))
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app alt (app regex-derivative pat1 c) (-> (app regex-derivative pat2 c) <-))
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-))
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app caddr (-> re <-))
  (env ((match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app caddr (-> re <-))
  (env ((match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app caddr (-> re <-))
  (env ((match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app caddr (-> re <-))
  (env ((match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cadr (-> re <-))
  (env ((match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cadr (-> re <-))
  (env ((match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cadr (-> re <-))
  (env ((match (-> (app match-rep re (λ (pat) ...)) <-) (#f) c-x))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cadr (-> re <-))
  (env ((match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cadr (-> re <-))
  (env ((match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app car (-> (app cdr (app cdr p)) <-))
  (env ((app f (app cadr re) (-> (app caddr re) <-)))))
clos/con:
	'((con
   cons
   (app cons 'foo (-> (app cons (app cons 'rep (app cons ...)) (app nil)) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app car (-> (app cdr (app cdr p)) <-))
  (env ((app f (app cadr re) (-> (app caddr re) <-)))))
clos/con:
	'((con
   cons
   (app cons 'foo (-> (app cons (app cons 'rep (app cons ...)) (app nil)) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app car (-> (app cdr p) <-))
  (env ((app f (-> (app cadr re) <-) (app caddr re)))))
clos/con:
	'((con
   cons
   (app
    cons
    'seq
    (-> (app cons 'foo (app cons (app cons ...) (app nil ...))) <-)))
  (env ()))
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app car (-> (app cdr p) <-))
  (env ((app f (-> (app cadr re) <-) (app caddr re)))))
clos/con:
	'((con
   cons
   (app
    cons
    'seq
    (-> (app cons 'foo (app cons (app cons ...) (app nil ...))) <-)))
  (env ()))
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app car (-> data <-))
  (env
   ((app
     check-expect
     (->
      (app
       regex-match
       (app cons 'seq (app cons ...))
       (app cons 'foo (app cons ...)))
      <-)
     (app #f)))))
clos/con:
	'((con
   cons
   (app
    regex-match
    (app cons 'seq (app cons 'foo (app cons ...)))
    (-> (app cons 'foo (app cons 'bar (app nil ...))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app car (-> data <-))
  (env
   ((match
     (app null? data)
     ((#f)
      (->
       (app
        regex-match
        (app regex-derivative pattern (app car ...))
        (app cdr data))
       <-))
     _))))
clos/con:
	'((con cons (app cons 'foo (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app car (-> re <-))
  (env ((match (-> (app regex-alt? re) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app car (-> re <-))
  (env ((match (-> (app regex-rep? re) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app car (-> re <-))
  (env ((match (-> (app regex-rep? re) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app car (-> re <-))
  (env ((match (-> (app regex-seq? re) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cdr (-> (app cdr p) <-))
  (env ((app f (app cadr re) (-> (app caddr re) <-)))))
clos/con:
	'((con
   cons
   (app
    cons
    'seq
    (-> (app cons 'foo (app cons (app cons ...) (app nil ...))) <-)))
  (env ()))
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cdr (-> (app cdr p) <-))
  (env ((app f (app cadr re) (-> (app caddr re) <-)))))
clos/con:
	'((con
   cons
   (app
    cons
    'seq
    (-> (app cons 'foo (app cons (app cons ...) (app nil ...))) <-)))
  (env ()))
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cdr (-> data <-))
  (env
   ((app
     check-expect
     (->
      (app
       regex-match
       (app cons 'seq (app cons ...))
       (app cons 'foo (app cons ...)))
      <-)
     (app #f)))))
clos/con:
	'((con
   cons
   (app
    regex-match
    (app cons 'seq (app cons 'foo (app cons ...)))
    (-> (app cons 'foo (app cons 'bar (app nil ...))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cdr (-> data <-))
  (env
   ((match
     (app null? data)
     ((#f)
      (->
       (app
        regex-match
        (app regex-derivative pattern (app car ...))
        (app cdr data))
       <-))
     _))))
clos/con:
	'((con cons (app cons 'foo (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cdr (-> p <-))
  (env ((app f (-> (app cadr re) <-) (app caddr re)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cdr (-> p <-))
  (env ((app f (-> (app cadr re) <-) (app caddr re)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cdr (-> p <-))
  (env ((app f (app cadr re) (-> (app caddr re) <-)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cdr (-> p <-))
  (env ((app f (app cadr re) (-> (app caddr re) <-)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app char? (-> re <-))
  (env ((match (-> (app regex-atom? re) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app char? (-> re <-))
  (env ((match (-> (app regex-atom? re) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons 'alt (-> (app cons pat1 (app cons pat2 (app nil ...))) <-))
  (env
   ((λ (pat1 pat2)
      (->
       (app
        alt
        (app seq (app regex-derivative ...) pat2)
        (app seq (app regex-empty ...) (app regex-derivative ...)))
       <-)))))
clos/con:
	'((con
   cons
   (app cons 'alt (-> (app cons pat1 (app cons pat2 (app nil ...))) <-)))
  (env
   ((λ (pat1 pat2)
      (->
       (app
        alt
        (app seq (app regex-derivative ...) pat2)
        (app seq (app regex-empty ...) (app regex-derivative ...)))
       <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons 'alt (-> (app cons pat1 (app cons pat2 (app nil ...))) <-))
  (env
   ((λ (pat1 pat2)
      (->
       (app alt (app regex-derivative pat1 c) (app regex-derivative pat2 c))
       <-)))))
clos/con:
	'((con
   cons
   (app cons 'alt (-> (app cons pat1 (app cons pat2 (app nil ...))) <-)))
  (env
   ((λ (pat1 pat2)
      (->
       (app alt (app regex-derivative pat1 c) (app regex-derivative pat2 c))
       <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons 'alt (-> (app cons pat1 (app cons pat2 (app nil ...))) <-))
  (env
   ((λ (pat1 pat2)
      (-> (app alt (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con
   cons
   (app cons 'alt (-> (app cons pat1 (app cons pat2 (app nil ...))) <-)))
  (env
   ((λ (pat1 pat2)
      (-> (app alt (app regex-empty pat1) (app regex-empty pat2)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons 'foo (-> (app cons (app cons 'rep (app cons ...)) (app nil)) <-))
  (env ()))
clos/con:
	'((con
   cons
   (app cons 'foo (-> (app cons (app cons 'rep (app cons ...)) (app nil)) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons 'rep (-> (app cons pat (app nil)) <-))
  (env ((app seq (app regex-derivative pat c) (-> (app rep pat) <-)))))
clos/con:
	'((con cons (app cons 'rep (-> (app cons pat (app nil)) <-)))
  (env ((app seq (app regex-derivative pat c) (-> (app rep pat) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil ...))) <-))
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
clos/con:
	'((con
   cons
   (app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil ...))) <-)))
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil ...))) <-))
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
clos/con:
	'((con
   cons
   (app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil ...))) <-)))
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil ...))) <-))
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
clos/con:
	'((con
   cons
   (app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil ...))) <-)))
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil ...))) <-))
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con
   cons
   (app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil ...))) <-)))
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> pat <-) (app nil))
  (env ((app seq (app regex-derivative pat c) (-> (app rep pat) <-)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> pat1 <-) (app cons pat2 (app nil)))
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> pat1 <-) (app cons pat2 (app nil)))
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> pat1 <-) (app cons pat2 (app nil)))
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> pat1 <-) (app cons pat2 (app nil)))
  (env
   ((λ (pat1 pat2)
      (->
       (app
        alt
        (app seq (app regex-derivative ...) pat2)
        (app seq (app regex-empty ...) (app regex-derivative ...)))
       <-)))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> pat1 <-) (app cons pat2 (app nil)))
  (env
   ((λ (pat1 pat2)
      (->
       (app alt (app regex-derivative pat1 c) (app regex-derivative pat2 c))
       <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> pat1 <-) (app cons pat2 (app nil)))
  (env
   ((λ (pat1 pat2)
      (-> (app alt (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> pat1 <-) (app cons pat2 (app nil)))
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> pat2 <-) (app nil))
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> pat2 <-) (app nil))
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> pat2 <-) (app nil))
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
clos/con:
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil ...))) <-))
    _))
  (env ((app seq (app regex-derivative pat c) (-> (app rep pat) <-)))))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> pat2 <-) (app nil))
  (env
   ((λ (pat1 pat2)
      (->
       (app
        alt
        (app seq (app regex-derivative ...) pat2)
        (app seq (app regex-empty ...) (app regex-derivative ...)))
       <-)))))
clos/con:
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> pat2 <-) (app nil))
  (env
   ((λ (pat1 pat2)
      (->
       (app alt (app regex-derivative pat1 c) (app regex-derivative pat2 c))
       <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> pat2 <-) (app nil))
  (env
   ((λ (pat1 pat2)
      (-> (app alt (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> pat2 <-) (app nil))
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (app cons 'rep (app cons 'bar (app nil ...))) (-> (app nil) <-))
  (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons pat (-> (app nil) <-))
  (env ((app seq (app regex-derivative pat c) (-> (app rep pat) <-)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons pat1 (-> (app cons pat2 (app nil)) <-))
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
clos/con:
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-)))
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons pat1 (-> (app cons pat2 (app nil)) <-))
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
clos/con:
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-)))
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons pat1 (-> (app cons pat2 (app nil)) <-))
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
clos/con:
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-)))
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons pat1 (-> (app cons pat2 (app nil)) <-))
  (env
   ((λ (pat1 pat2)
      (->
       (app
        alt
        (app seq (app regex-derivative ...) pat2)
        (app seq (app regex-empty ...) (app regex-derivative ...)))
       <-)))))
clos/con:
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-)))
  (env
   ((λ (pat1 pat2)
      (->
       (app
        alt
        (app seq (app regex-derivative ...) pat2)
        (app seq (app regex-empty ...) (app regex-derivative ...)))
       <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons pat1 (-> (app cons pat2 (app nil)) <-))
  (env
   ((λ (pat1 pat2)
      (->
       (app alt (app regex-derivative pat1 c) (app regex-derivative pat2 c))
       <-)))))
clos/con:
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-)))
  (env
   ((λ (pat1 pat2)
      (->
       (app alt (app regex-derivative pat1 c) (app regex-derivative pat2 c))
       <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons pat1 (-> (app cons pat2 (app nil)) <-))
  (env
   ((λ (pat1 pat2)
      (-> (app alt (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-)))
  (env
   ((λ (pat1 pat2)
      (-> (app alt (app regex-empty pat1) (app regex-empty pat2)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons pat1 (-> (app cons pat2 (app nil)) <-))
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-)))
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons pat2 (-> (app nil) <-))
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons pat2 (-> (app nil) <-))
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons pat2 (-> (app nil) <-))
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons pat2 (-> (app nil) <-))
  (env
   ((λ (pat1 pat2)
      (->
       (app
        alt
        (app seq (app regex-derivative ...) pat2)
        (app seq (app regex-empty ...) (app regex-derivative ...)))
       <-)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons pat2 (-> (app nil) <-))
  (env
   ((λ (pat1 pat2)
      (->
       (app alt (app regex-derivative pat1 c) (app regex-derivative pat2 c))
       <-)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons pat2 (-> (app nil) <-))
  (env
   ((λ (pat1 pat2)
      (-> (app alt (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons pat2 (-> (app nil) <-))
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> (app car re) <-) 'alt)
  (env ((match (-> (app regex-alt? re) <-) (#f) _))))
clos/con:
	'((app
   cons
   (-> 'seq <-)
   (app cons 'foo (app cons (app cons ...) (app nil ...))))
  (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> (app car re) <-) 'rep)
  (env ((match (-> (app regex-rep? re) <-) (#f) _))))
clos/con:
	'((app
   cons
   (-> 'seq <-)
   (app cons 'foo (app cons (app cons ...) (app nil ...))))
  (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> (app car re) <-) 'rep)
  (env ((match (-> (app regex-rep? re) <-) (#f) _))))
clos/con:
	'((app
   cons
   (-> 'seq <-)
   (app cons 'foo (app cons (app cons ...) (app nil ...))))
  (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> (app car re) <-) 'seq)
  (env ((match (-> (app regex-seq? re) <-) (#f) _))))
clos/con:
	'((app
   cons
   (-> 'seq <-)
   (app cons 'foo (app cons (app cons ...) (app nil ...))))
  (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> c <-) re)
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> c <-) re)
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> c <-) re)
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> c <-) re)
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> c <-) re)
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> c <-) re)
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> re <-) (app #f))
  (env ((match (-> (app regex-null? pat) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> re <-) (app #f))
  (env ((match (-> (app regex-null? pat1) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> re <-) (app #f))
  (env ((match (-> (app regex-null? pat1) <-) (#f) _))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> re <-) (app #f))
  (env ((match (-> (app regex-null? pat2) <-) (#f) _))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil ...))) <-))
    _))
  (env ((app seq (app regex-derivative pat c) (-> (app rep pat) <-)))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> re <-) (app #f))
  (env ((match (-> (app regex-null? pat2) <-) (#f) _))))
clos/con:
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> re <-) (app #f))
  (env ((match (-> (app regex-null? re) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> re <-) (app #f))
  (env ((match (-> (app regex-null? re) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> re <-) (app #t))
  (env
   ((match
     (app null? data)
     (#f)
     (_ (-> (app regex-empty? (app regex-empty pattern)) <-))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> re <-) (app #t))
  (env ((match (-> (app regex-empty? pat) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> re <-) (app #t))
  (env ((match (-> (app regex-empty? pat1) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> re <-) (app #t))
  (env ((match (-> (app regex-empty? pat2) <-) (#f) _))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil ...))) <-))
    _))
  (env ((app seq (app regex-derivative pat c) (-> (app rep pat) <-)))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> re <-) (app #t))
  (env ((match (-> (app regex-empty? re) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? (-> re <-) (app #t))
  (env ((match (-> (app regex-empty? re) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? c (-> re <-))
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? c (-> re <-))
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? c (-> re <-))
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? c (-> re <-))
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? c (-> re <-))
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? c (-> re <-))
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? re (-> (app #f) <-))
  (env ((match (-> (app regex-null? pat) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? re (-> (app #f) <-))
  (env ((match (-> (app regex-null? pat1) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? re (-> (app #f) <-))
  (env ((match (-> (app regex-null? pat1) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? re (-> (app #f) <-))
  (env ((match (-> (app regex-null? pat2) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? re (-> (app #f) <-))
  (env ((match (-> (app regex-null? pat2) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? re (-> (app #f) <-))
  (env ((match (-> (app regex-null? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? re (-> (app #f) <-))
  (env ((match (-> (app regex-null? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? re (-> (app #t) <-))
  (env
   ((match
     (app null? data)
     (#f)
     (_ (-> (app regex-empty? (app regex-empty pattern)) <-))))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? re (-> (app #t) <-))
  (env ((match (-> (app regex-empty? pat) <-) (#f) _))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? re (-> (app #t) <-))
  (env ((match (-> (app regex-empty? pat1) <-) (#f) _))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? re (-> (app #t) <-))
  (env ((match (-> (app regex-empty? pat2) <-) (#f) _))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? re (-> (app #t) <-))
  (env ((match (-> (app regex-empty? re) <-) (#f) _))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app eq? re (-> (app #t) <-))
  (env ((match (-> (app regex-empty? re) <-) (#f) _))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app equal? (-> check <-) expect)
  (env
   ((letrec*
     (car ... check-expect)
     (->
      (app
       check-expect
       (app regex-match (app cons ...) (app cons ...))
       (app #f))
      <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app equal? check (-> expect <-))
  (env
   ((letrec*
     (car ... check-expect)
     (->
      (app
       check-expect
       (app regex-match (app cons ...) (app cons ...))
       (app #f))
      <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f (-> (app cadr re) <-) (app caddr re))
  (env ((match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f (-> (app cadr re) <-) (app caddr re))
  (env ((match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f (-> (app cadr re) <-) (app caddr re))
  (env ((match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f (-> (app cadr re) <-) (app caddr re))
  (env ((match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f (-> (app cadr re) <-))
  (env ((match (-> (app match-rep re (λ (pat) ...)) <-) (#f) c-x))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f (app cadr re) (-> (app caddr re) <-))
  (env ((match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f (app cadr re) (-> (app caddr re) <-))
  (env ((match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f (app cadr re) (-> (app caddr re) <-))
  (env ((match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f (app cadr re) (-> (app caddr re) <-))
  (env ((match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app match-alt (-> re <-) (λ (pat1 pat2) ...))
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app match-alt (-> re <-) (λ (pat1 pat2) ...))
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app match-alt (-> re <-) (λ (pat1 pat2) ...))
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app match-alt (-> re <-) (λ (pat1 pat2) ...))
  (env
   ((app seq (-> (app regex-empty pat1) <-) (app regex-derivative pat2 c)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app match-alt (-> re <-) (λ (pat1 pat2) ...))
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app match-alt (-> re <-) (λ (pat1 pat2) ...))
  (env ((app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app match-alt (-> re <-) (λ (pat1 pat2) ...))
  (env ((app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app match-alt (-> re <-) (λ (pat1 pat2) ...))
  (env ((app regex-empty? (-> (app regex-empty pattern) <-)))))
clos/con:
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app match-alt (-> re <-) (λ (pat1 pat2) ...))
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app match-alt (-> re <-) (λ (pat1 pat2) ...))
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app match-alt (-> re <-) (λ (pat1 pat2) ...))
  (env ((app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app match-alt (-> re <-) (λ (pat1 pat2) ...))
  (env ((app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app match-rep (-> re <-) (λ (pat) ...))
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app match-rep (-> re <-) (λ (pat) ...))
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app match-rep (-> re <-) (λ (pat) ...))
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app match-rep (-> re <-) (λ (pat) ...))
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app match-rep (-> re <-) (λ (pat) ...))
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app match-rep (-> re <-) (λ (pat) ...))
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app match-seq (-> re <-) (λ (pat1 pat2) ...))
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app match-seq (-> re <-) (λ (pat1 pat2) ...))
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app match-seq (-> re <-) (λ (pat1 pat2) ...))
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app match-seq (-> re <-) (λ (pat1 pat2) ...))
  (env
   ((app seq (-> (app regex-empty pat1) <-) (app regex-derivative pat2 c)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app match-seq (-> re <-) (λ (pat1 pat2) ...))
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app match-seq (-> re <-) (λ (pat1 pat2) ...))
  (env ((app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app match-seq (-> re <-) (λ (pat1 pat2) ...))
  (env ((app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app match-seq (-> re <-) (λ (pat1 pat2) ...))
  (env ((app regex-empty? (-> (app regex-empty pattern) <-)))))
clos/con:
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app match-seq (-> re <-) (λ (pat1 pat2) ...))
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app match-seq (-> re <-) (λ (pat1 pat2) ...))
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app match-seq (-> re <-) (λ (pat1 pat2) ...))
  (env ((app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app match-seq (-> re <-) (λ (pat1 pat2) ...))
  (env ((app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app null? (-> data <-))
  (env
   ((app
     check-expect
     (->
      (app
       regex-match
       (app cons 'seq (app cons ...))
       (app cons 'foo (app cons ...)))
      <-)
     (app #f)))))
clos/con:
	'((con
   cons
   (app
    regex-match
    (app cons 'seq (app cons 'foo (app cons ...)))
    (-> (app cons 'foo (app cons 'bar (app nil ...))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app null? (-> data <-))
  (env
   ((match
     (app null? data)
     ((#f)
      (->
       (app
        regex-match
        (app regex-derivative pattern (app car ...))
        (app cdr data))
       <-))
     _))))
clos/con:
	'((con cons (app cons 'foo (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app pair? (-> re <-))
  (env ((match (-> (app regex-alt? re) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app pair? (-> re <-))
  (env ((match (-> (app regex-rep? re) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app pair? (-> re <-))
  (env ((match (-> (app regex-rep? re) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app pair? (-> re <-))
  (env ((match (-> (app regex-seq? re) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-alt? (-> re <-))
  (env ((match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-alt? (-> re <-))
  (env ((match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-atom? (-> re <-))
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-atom? (-> re <-))
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-atom? (-> re <-))
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-atom? (-> re <-))
  (env
   ((app seq (-> (app regex-empty pat1) <-) (app regex-derivative pat2 c)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-atom? (-> re <-))
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-atom? (-> re <-))
  (env ((app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-atom? (-> re <-))
  (env ((app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-atom? (-> re <-))
  (env ((app regex-empty? (-> (app regex-empty pattern) <-)))))
clos/con:
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-atom? (-> re <-))
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-atom? (-> re <-))
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-atom? (-> re <-))
  (env ((app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-atom? (-> re <-))
  (env ((app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-derivative (-> pat <-) c)
  (env ((match (-> (app f (app cadr re)) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-derivative (-> pat1 <-) c)
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-derivative (-> pat1 <-) c)
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-derivative (-> pat2 <-) c)
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-derivative (-> pat2 <-) c)
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-derivative (-> pattern <-) (app car data))
  (env
   ((app
     check-expect
     (->
      (app
       regex-match
       (app cons 'seq (app cons ...))
       (app cons 'foo (app cons ...)))
      <-)
     (app #f)))))
clos/con:
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-derivative (-> pattern <-) (app car data))
  (env
   ((match
     (app null? data)
     ((#f)
      (->
       (app
        regex-match
        (app regex-derivative pattern (app car ...))
        (app cdr data))
       <-))
     _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-derivative pat (-> c <-))
  (env ((match (-> (app f (app cadr re)) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-derivative pat1 (-> c <-))
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-derivative pat1 (-> c <-))
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-derivative pat2 (-> c <-))
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-derivative pat2 (-> c <-))
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-derivative pattern (-> (app car data) <-))
  (env
   ((app
     check-expect
     (->
      (app
       regex-match
       (app cons 'seq (app cons ...))
       (app cons 'foo (app cons ...)))
      <-)
     (app #f)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-derivative pattern (-> (app car data) <-))
  (env
   ((match
     (app null? data)
     ((#f)
      (->
       (app
        regex-match
        (app regex-derivative pattern (app car ...))
        (app cdr data))
       <-))
     _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-empty (-> pat1 <-))
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-empty (-> pat1 <-))
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-empty (-> pat1 <-))
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-empty (-> pat2 <-))
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-empty (-> pat2 <-))
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-empty (-> pattern <-))
  (env
   ((app
     check-expect
     (->
      (app
       regex-match
       (app cons 'seq (app cons ...))
       (app cons 'foo (app cons ...)))
      <-)
     (app #f)))))
clos/con:
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-empty (-> pattern <-))
  (env
   ((match
     (app null? data)
     ((#f)
      (->
       (app
        regex-match
        (app regex-derivative pattern (app car ...))
        (app cdr data))
       <-))
     _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-empty? (-> (app regex-empty pattern) <-))
  (env
   ((app
     check-expect
     (->
      (app
       regex-match
       (app cons 'seq (app cons ...))
       (app cons 'foo (app cons ...)))
      <-)
     (app #f)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-empty? (-> (app regex-empty pattern) <-))
  (env
   ((match
     (app null? data)
     ((#f)
      (->
       (app
        regex-match
        (app regex-derivative pattern (app car ...))
        (app cdr data))
       <-))
     _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-empty? (-> pat <-))
  (env ((app seq (app regex-derivative pat c) (-> (app rep pat) <-)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-empty? (-> pat1 <-))
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-empty? (-> pat1 <-))
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-empty? (-> pat1 <-))
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-empty? (-> pat1 <-))
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-empty? (-> pat2 <-))
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-empty? (-> pat2 <-))
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-empty? (-> pat2 <-))
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
clos/con:
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil ...))) <-))
    _))
  (env ((app seq (app regex-derivative pat c) (-> (app rep pat) <-)))))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-empty? (-> pat2 <-))
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-empty? (-> re <-))
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-empty? (-> re <-))
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-empty? (-> re <-))
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-empty? (-> re <-))
  (env
   ((app seq (-> (app regex-empty pat1) <-) (app regex-derivative pat2 c)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-empty? (-> re <-))
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-empty? (-> re <-))
  (env ((app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-empty? (-> re <-))
  (env ((app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-empty? (-> re <-))
  (env ((app regex-empty? (-> (app regex-empty pattern) <-)))))
clos/con:
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-empty? (-> re <-))
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-empty? (-> re <-))
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-empty? (-> re <-))
  (env ((app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-empty? (-> re <-))
  (env ((app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-null? (-> pat <-))
  (env ((app seq (app regex-derivative pat c) (-> (app rep pat) <-)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-null? (-> pat1 <-))
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-null? (-> pat1 <-))
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-null? (-> pat1 <-))
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-null? (-> pat1 <-))
  (env
   ((λ (pat1 pat2)
      (->
       (app
        alt
        (app seq (app regex-derivative ...) pat2)
        (app seq (app regex-empty ...) (app regex-derivative ...)))
       <-)))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-null? (-> pat1 <-))
  (env
   ((λ (pat1 pat2)
      (->
       (app alt (app regex-derivative pat1 c) (app regex-derivative pat2 c))
       <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-null? (-> pat1 <-))
  (env
   ((λ (pat1 pat2)
      (-> (app alt (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-null? (-> pat1 <-))
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-null? (-> pat2 <-))
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-null? (-> pat2 <-))
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-null? (-> pat2 <-))
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
clos/con:
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil ...))) <-))
    _))
  (env ((app seq (app regex-derivative pat c) (-> (app rep pat) <-)))))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-null? (-> pat2 <-))
  (env
   ((λ (pat1 pat2)
      (->
       (app
        alt
        (app seq (app regex-derivative ...) pat2)
        (app seq (app regex-empty ...) (app regex-derivative ...)))
       <-)))))
clos/con:
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-null? (-> pat2 <-))
  (env
   ((λ (pat1 pat2)
      (->
       (app alt (app regex-derivative pat1 c) (app regex-derivative pat2 c))
       <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-null? (-> pat2 <-))
  (env
   ((λ (pat1 pat2)
      (-> (app alt (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-null? (-> pat2 <-))
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-null? (-> re <-))
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-null? (-> re <-))
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-null? (-> re <-))
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-null? (-> re <-))
  (env
   ((app seq (-> (app regex-empty pat1) <-) (app regex-derivative pat2 c)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-null? (-> re <-))
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-null? (-> re <-))
  (env ((app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-null? (-> re <-))
  (env ((app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-null? (-> re <-))
  (env ((app regex-empty? (-> (app regex-empty pattern) <-)))))
clos/con:
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-null? (-> re <-))
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-null? (-> re <-))
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-null? (-> re <-))
  (env ((app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-null? (-> re <-))
  (env ((app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-rep? (-> re <-))
  (env
   ((app seq (-> (app regex-empty pat1) <-) (app regex-derivative pat2 c)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-rep? (-> re <-))
  (env ((app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-rep? (-> re <-))
  (env ((app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-rep? (-> re <-))
  (env ((app regex-empty? (-> (app regex-empty pattern) <-)))))
clos/con:
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-rep? (-> re <-))
  (env ((app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-rep? (-> re <-))
  (env ((app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-rep? (-> re <-))
  (env ((match (-> (app match-rep re (λ (pat) ...)) <-) (#f) c-x))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-seq? (-> re <-))
  (env ((match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-seq? (-> re <-))
  (env ((match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app rep (-> pat <-))
  (env ((match (-> (app f (app cadr re)) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app seq (-> (app regex-derivative pat c) <-) (app rep pat))
  (env ((match (-> (app f (app cadr re)) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app seq (-> (app regex-derivative pat1 c) <-) pat2)
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app seq (-> (app regex-empty pat1) <-) (app regex-derivative pat2 c))
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2))
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app seq (app regex-derivative pat c) (-> (app rep pat) <-))
  (env ((match (-> (app f (app cadr re)) <-) (#f) _))))
clos/con:
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil ...))) <-))
    _))
  (env ((app seq (app regex-derivative pat c) (-> (app rep pat) <-)))))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app seq (app regex-derivative pat1 c) (-> pat2 <-))
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-))
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-))
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app symbol? (-> re <-))
  (env ((match (-> (app regex-atom? re) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app symbol? (-> re <-))
  (env ((match (-> (app regex-atom? re) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app debug-trace) <-)) () ...) ...)
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((λ () (-> 'do-nothing <-))
  (env ((let (... () (_ (-> (app debug-trace) <-)) () ...) ...))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app debug-trace) <-)) () ...) ...)
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((λ () (-> 'do-nothing <-))
  (env ((let (... () (_ (-> (app debug-trace) <-)) () ...) ...))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app debug-trace) <-)) () ...) ...)
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((λ () (-> 'do-nothing <-))
  (env ((let (... () (_ (-> (app debug-trace) <-)) () ...) ...))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app debug-trace) <-)) () ...) ...)
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((λ () (-> 'do-nothing <-))
  (env ((let (... () (_ (-> (app debug-trace) <-)) () ...) ...))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app debug-trace) <-)) () ...) ...)
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((λ () (-> 'do-nothing <-))
  (env ((let (... () (_ (-> (app debug-trace) <-)) () ...) ...))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app debug-trace) <-)) () ...) ...)
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((λ () (-> 'do-nothing <-))
  (env ((let (... () (_ (-> (app debug-trace) <-)) () ...) ...))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (_) (-> (match (app regex-empty? re) ...) <-))
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (_) (-> (match (app regex-empty? re) ...) <-))
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (_) (-> (match (app regex-empty? re) ...) <-))
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (_) (-> (match (app regex-empty? re) ...) <-))
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (_) (-> (match (app regex-empty? re) ...) <-))
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (_) (-> (match (app regex-empty? re) ...) <-))
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (car ... check-expect)
   (->
    (app check-expect (app regex-match (app cons ...) (app cons ...)) (app #f))
    <-))
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... caddr (regex-NULL (-> (app #f) <-)) regex-BLANK ...) ...)
  (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... regex-NULL (regex-BLANK (-> (app #t) <-)) regex-alt? ...) ...)
  (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app match-alt re (λ (pat1 pat2) ...))
   ((#f) (-> (match (app match-rep re (λ (pat) ...)) ...) <-))
   c-x)
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app match-alt re (λ (pat1 pat2) ...))
   ((#f) (-> (match (app match-rep re (λ (pat) ...)) ...) <-))
   c-x)
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app match-alt re (λ (pat1 pat2) ...))
   ((#f) (-> (match (app match-rep re (λ (pat) ...)) ...) <-))
   c-x)
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app match-alt re (λ (pat1 pat2) ...))
   ((#f) (-> (match (app match-rep re (λ (pat) ...)) ...) <-))
   c-x)
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app match-alt re (λ (pat1 pat2) ...))
   ((#f) (-> (match (app match-rep re (λ (pat) ...)) ...) <-))
   c-x)
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app match-alt re (λ (pat1 pat2) ...))
   ((#f) (-> (match (app match-rep re (λ (pat) ...)) ...) <-))
   c-x)
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app match-alt re (λ (pat1 pat2) ...))
   ((#f) (-> (match (app regex-rep? re) ...) <-))
   c-x)
  (env
   ((app seq (-> (app regex-empty pat1) <-) (app regex-derivative pat2 c)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app match-alt re (λ (pat1 pat2) ...))
   ((#f) (-> (match (app regex-rep? re) ...) <-))
   c-x)
  (env ((app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app match-alt re (λ (pat1 pat2) ...))
   ((#f) (-> (match (app regex-rep? re) ...) <-))
   c-x)
  (env ((app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app match-alt re (λ (pat1 pat2) ...))
   ((#f) (-> (match (app regex-rep? re) ...) <-))
   c-x)
  (env ((app regex-empty? (-> (app regex-empty pattern) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app match-alt re (λ (pat1 pat2) ...))
   ((#f) (-> (match (app regex-rep? re) ...) <-))
   c-x)
  (env ((app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app match-alt re (λ (pat1 pat2) ...))
   ((#f) (-> (match (app regex-rep? re) ...) <-))
   c-x)
  (env ((app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app match-seq re (λ (pat1 pat2) ...))
   ((#f) (-> (match (app match-alt re (λ (pat1 pat2) ...)) ...) <-))
   c-x)
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app match-seq re (λ (pat1 pat2) ...))
   ((#f) (-> (match (app match-alt re (λ (pat1 pat2) ...)) ...) <-))
   c-x)
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app match-seq re (λ (pat1 pat2) ...))
   ((#f) (-> (match (app match-alt re (λ (pat1 pat2) ...)) ...) <-))
   c-x)
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app match-seq re (λ (pat1 pat2) ...))
   ((#f) (-> (match (app match-alt re (λ (pat1 pat2) ...)) ...) <-))
   c-x)
  (env
   ((app seq (-> (app regex-empty pat1) <-) (app regex-derivative pat2 c)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app match-seq re (λ (pat1 pat2) ...))
   ((#f) (-> (match (app match-alt re (λ (pat1 pat2) ...)) ...) <-))
   c-x)
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app match-seq re (λ (pat1 pat2) ...))
   ((#f) (-> (match (app match-alt re (λ (pat1 pat2) ...)) ...) <-))
   c-x)
  (env ((app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app match-seq re (λ (pat1 pat2) ...))
   ((#f) (-> (match (app match-alt re (λ (pat1 pat2) ...)) ...) <-))
   c-x)
  (env ((app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app match-seq re (λ (pat1 pat2) ...))
   ((#f) (-> (match (app match-alt re (λ (pat1 pat2) ...)) ...) <-))
   c-x)
  (env ((app regex-empty? (-> (app regex-empty pattern) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app match-seq re (λ (pat1 pat2) ...))
   ((#f) (-> (match (app match-alt re (λ (pat1 pat2) ...)) ...) <-))
   c-x)
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app match-seq re (λ (pat1 pat2) ...))
   ((#f) (-> (match (app match-alt re (λ (pat1 pat2) ...)) ...) <-))
   c-x)
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app match-seq re (λ (pat1 pat2) ...))
   ((#f) (-> (match (app match-alt re (λ (pat1 pat2) ...)) ...) <-))
   c-x)
  (env ((app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app match-seq re (λ (pat1 pat2) ...))
   ((#f) (-> (match (app match-alt re (λ (pat1 pat2) ...)) ...) <-))
   c-x)
  (env ((app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app null? data)
   (#f)
   (_ (-> (app regex-empty? (app regex-empty pattern)) <-)))
  (env
   ((app
     check-expect
     (->
      (app
       regex-match
       (app cons 'seq (app cons ...))
       (app cons 'foo (app cons ...)))
      <-)
     (app #f)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app null? data)
   (#f)
   (_ (-> (app regex-empty? (app regex-empty pattern)) <-)))
  (env
   ((match
     (app null? data)
     ((#f)
      (->
       (app
        regex-match
        (app regex-derivative pattern (app car ...))
        (app cdr data))
       <-))
     _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app null? data)
   ((#f)
    (->
     (app
      regex-match
      (app regex-derivative pattern (app car ...))
      (app cdr data))
     <-))
   _)
  (env
   ((app
     check-expect
     (->
      (app
       regex-match
       (app cons 'seq (app cons ...))
       (app cons 'foo (app cons ...)))
      <-)
     (app #f)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app null? data)
   ((#f)
    (->
     (app
      regex-match
      (app regex-derivative pattern (app car ...))
      (app cdr data))
     <-))
   _)
  (env
   ((match
     (app null? data)
     ((#f)
      (->
       (app
        regex-match
        (app regex-derivative pattern (app car ...))
        (app cdr data))
       <-))
     _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app pair? re)
   (#f)
   (_ (-> (match (app eq? (app car ...) 'alt) ...) <-)))
  (env ((match (-> (app regex-alt? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app pair? re)
   (#f)
   (_ (-> (match (app eq? (app car ...) 'rep) ...) <-)))
  (env ((match (-> (app regex-rep? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app pair? re)
   (#f)
   (_ (-> (match (app eq? (app car ...) 'rep) ...) <-)))
  (env ((match (-> (app regex-rep? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app pair? re)
   (#f)
   (_ (-> (match (app eq? (app car ...) 'seq) ...) <-)))
  (env ((match (-> (app regex-seq? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-alt? re)
   (#f)
   (_ (-> (match (app f (app cadr ...) (app caddr ...)) ...) <-)))
  (env ((match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-alt? re)
   (#f)
   (_ (-> (match (app f (app cadr ...) (app caddr ...)) ...) <-)))
  (env ((match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-atom? re)
   ((#f) (-> (match (app match-seq re (λ (pat1 pat2) ...)) ...) <-))
   _)
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-atom? re)
   ((#f) (-> (match (app match-seq re (λ (pat1 pat2) ...)) ...) <-))
   _)
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-atom? re)
   ((#f) (-> (match (app match-seq re (λ (pat1 pat2) ...)) ...) <-))
   _)
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-atom? re)
   ((#f) (-> (match (app match-seq re (λ (pat1 pat2) ...)) ...) <-))
   _)
  (env
   ((app seq (-> (app regex-empty pat1) <-) (app regex-derivative pat2 c)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-atom? re)
   ((#f) (-> (match (app match-seq re (λ (pat1 pat2) ...)) ...) <-))
   _)
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-atom? re)
   ((#f) (-> (match (app match-seq re (λ (pat1 pat2) ...)) ...) <-))
   _)
  (env ((app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-atom? re)
   ((#f) (-> (match (app match-seq re (λ (pat1 pat2) ...)) ...) <-))
   _)
  (env ((app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-atom? re)
   ((#f) (-> (match (app match-seq re (λ (pat1 pat2) ...)) ...) <-))
   _)
  (env ((app regex-empty? (-> (app regex-empty pattern) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-atom? re)
   ((#f) (-> (match (app match-seq re (λ (pat1 pat2) ...)) ...) <-))
   _)
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-atom? re)
   ((#f) (-> (match (app match-seq re (λ (pat1 pat2) ...)) ...) <-))
   _)
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-atom? re)
   ((#f) (-> (match (app match-seq re (λ (pat1 pat2) ...)) ...) <-))
   _)
  (env ((app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-atom? re)
   ((#f) (-> (match (app match-seq re (λ (pat1 pat2) ...)) ...) <-))
   _)
  (env ((app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil ...))) <-))
   _)
  (env ((app seq (app regex-derivative pat c) (-> (app rep pat) <-)))))
clos/con:
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil ...))) <-))
    _))
  (env ((app seq (app regex-derivative pat c) (-> (app rep pat) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-empty? pat1)
   ((#f) (-> (match (app regex-empty? pat2) ...) <-))
   _)
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
clos/con:
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-empty? pat1)
   ((#f) (-> (match (app regex-empty? pat2) ...) <-))
   _)
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
clos/con:
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-empty? pat1)
   ((#f) (-> (match (app regex-empty? pat2) ...) <-))
   _)
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
clos/con:
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-empty? pat1)
   ((#f) (-> (match (app regex-empty? pat2) ...) <-))
   _)
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
   _)
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
clos/con:
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
   _)
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
clos/con:
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
   _)
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
clos/con:
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
   _)
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-empty? re)
   ((#f) (-> (match (app regex-null? re) ...) <-))
   _)
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-empty? re)
   ((#f) (-> (match (app regex-null? re) ...) <-))
   _)
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-empty? re)
   ((#f) (-> (match (app regex-null? re) ...) <-))
   _)
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-empty? re)
   ((#f) (-> (match (app regex-null? re) ...) <-))
   _)
  (env
   ((app seq (-> (app regex-empty pat1) <-) (app regex-derivative pat2 c)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-empty? re)
   ((#f) (-> (match (app regex-null? re) ...) <-))
   _)
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-empty? re)
   ((#f) (-> (match (app regex-null? re) ...) <-))
   _)
  (env ((app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-empty? re)
   ((#f) (-> (match (app regex-null? re) ...) <-))
   _)
  (env ((app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-empty? re)
   ((#f) (-> (match (app regex-null? re) ...) <-))
   _)
  (env ((app regex-empty? (-> (app regex-empty pattern) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-empty? re)
   ((#f) (-> (match (app regex-null? re) ...) <-))
   _)
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-empty? re)
   ((#f) (-> (match (app regex-null? re) ...) <-))
   _)
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-empty? re)
   ((#f) (-> (match (app regex-null? re) ...) <-))
   _)
  (env ((app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-empty? re)
   ((#f) (-> (match (app regex-null? re) ...) <-))
   _)
  (env ((app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-null? pat)
   ((#f) (-> (match (app regex-empty? pat) ...) <-))
   _)
  (env ((app seq (app regex-derivative pat c) (-> (app rep pat) <-)))))
clos/con:
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil ...))) <-))
    _))
  (env ((app seq (app regex-derivative pat c) (-> (app rep pat) <-)))))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-null? pat1)
   ((#f) (-> (match (app regex-null? pat2) ...) <-))
   _)
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-null? pat1)
   ((#f) (-> (match (app regex-null? pat2) ...) <-))
   _)
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
clos/con:
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-null? pat1)
   ((#f) (-> (match (app regex-null? pat2) ...) <-))
   _)
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
clos/con:
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil ...))) <-))
    _))
  (env ((app seq (app regex-derivative pat c) (-> (app rep pat) <-)))))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-null? pat1)
   ((#f) (-> (match (app regex-null? pat2) ...) <-))
   _)
  (env
   ((λ (pat1 pat2)
      (->
       (app
        alt
        (app seq (app regex-derivative ...) pat2)
        (app seq (app regex-empty ...) (app regex-derivative ...)))
       <-)))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((λ (pat1 pat2)
      (->
       (app
        alt
        (app seq (app regex-derivative ...) pat2)
        (app seq (app regex-empty ...) (app regex-derivative ...)))
       <-)))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-null? pat1)
   ((#f) (-> (match (app regex-null? pat2) ...) <-))
   _)
  (env
   ((λ (pat1 pat2)
      (->
       (app alt (app regex-derivative pat1 c) (app regex-derivative pat2 c))
       <-)))))
clos/con:
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((λ (pat1 pat2)
      (->
       (app alt (app regex-derivative pat1 c) (app regex-derivative pat2 c))
       <-)))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-null? pat1)
   ((#f) (-> (match (app regex-null? pat2) ...) <-))
   _)
  (env
   ((λ (pat1 pat2)
      (-> (app alt (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((λ (pat1 pat2)
      (-> (app alt (app regex-empty pat1) (app regex-empty pat2)) <-)))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-null? pat1)
   ((#f) (-> (match (app regex-null? pat2) ...) <-))
   _)
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-null? pat2)
   ((#f) (-> (app cons 'alt (app cons pat1 (app cons ...))) <-))
   _)
  (env
   ((λ (pat1 pat2)
      (->
       (app
        alt
        (app seq (app regex-derivative ...) pat2)
        (app seq (app regex-empty ...) (app regex-derivative ...)))
       <-)))))
clos/con:
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((λ (pat1 pat2)
      (->
       (app
        alt
        (app seq (app regex-derivative ...) pat2)
        (app seq (app regex-empty ...) (app regex-derivative ...)))
       <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-null? pat2)
   ((#f) (-> (app cons 'alt (app cons pat1 (app cons ...))) <-))
   _)
  (env
   ((λ (pat1 pat2)
      (->
       (app alt (app regex-derivative pat1 c) (app regex-derivative pat2 c))
       <-)))))
clos/con:
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((λ (pat1 pat2)
      (->
       (app alt (app regex-derivative pat1 c) (app regex-derivative pat2 c))
       <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-null? pat2)
   ((#f) (-> (app cons 'alt (app cons pat1 (app cons ...))) <-))
   _)
  (env
   ((λ (pat1 pat2)
      (-> (app alt (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((λ (pat1 pat2)
      (-> (app alt (app regex-empty pat1) (app regex-empty pat2)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-null? pat2)
   ((#f) (-> (match (app regex-empty? pat1) ...) <-))
   _)
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-null? pat2)
   ((#f) (-> (match (app regex-empty? pat1) ...) <-))
   _)
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
clos/con:
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-null? pat2)
   ((#f) (-> (match (app regex-empty? pat1) ...) <-))
   _)
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
clos/con:
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil ...))) <-))
    _))
  (env ((app seq (app regex-derivative pat c) (-> (app rep pat) <-)))))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-null? pat2)
   ((#f) (-> (match (app regex-empty? pat1) ...) <-))
   _)
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-null? re)
   ((#f) (-> (match (app regex-atom? re) ...) <-))
   _)
  (env
   ((app seq (-> (app regex-empty pat1) <-) (app regex-derivative pat2 c)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-null? re)
   ((#f) (-> (match (app regex-atom? re) ...) <-))
   _)
  (env ((app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-null? re)
   ((#f) (-> (match (app regex-atom? re) ...) <-))
   _)
  (env ((app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-null? re)
   ((#f) (-> (match (app regex-atom? re) ...) <-))
   _)
  (env ((app regex-empty? (-> (app regex-empty pattern) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-null? re)
   ((#f) (-> (match (app regex-atom? re) ...) <-))
   _)
  (env ((app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-null? re)
   ((#f) (-> (match (app regex-atom? re) ...) <-))
   _)
  (env ((app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-rep? re)
   (#f)
   (_ (-> (match (app f (app cadr ...)) ...) <-)))
  (env ((match (-> (app match-rep re (λ (pat) ...)) <-) (#f) c-x))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-seq? re)
   (#f)
   (_ (-> (match (app f (app cadr ...) (app caddr ...)) ...) <-)))
  (env ((match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-seq? re)
   (#f)
   (_ (-> (match (app f (app cadr ...) (app caddr ...)) ...) <-)))
  (env ((match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app char? re) <-) (#f) _)
  (env ((match (-> (app regex-atom? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app char? re) <-) (#f) _)
  (env ((match (-> (app regex-atom? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app eq? (app car re) 'alt) <-) (#f) _)
  (env ((match (-> (app regex-alt? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app eq? (app car re) 'rep) <-) (#f) _)
  (env ((match (-> (app regex-rep? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app eq? (app car re) 'rep) <-) (#f) _)
  (env ((match (-> (app regex-rep? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app eq? (app car re) 'seq) <-) (#f) _)
  (env ((match (-> (app regex-seq? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app eq? c re) <-) (#f) _)
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app eq? c re) <-) (#f) _)
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app eq? c re) <-) (#f) _)
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app eq? c re) <-) (#f) _)
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app eq? c re) <-) (#f) _)
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app eq? c re) <-) (#f) _)
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _)
  (env ((match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((λ (pat1 pat2)
      (->
       (app alt (app regex-derivative pat1 c) (app regex-derivative pat2 c))
       <-)))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _)
  (env ((match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((λ (pat1 pat2)
      (-> (app alt (app regex-empty pat1) (app regex-empty pat2)) <-)))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _)
  (env ((match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((λ (pat1 pat2)
      (->
       (app
        alt
        (app seq (app regex-derivative ...) pat2)
        (app seq (app regex-empty ...) (app regex-derivative ...)))
       <-)))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _)
  (env ((match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app f (app cadr re)) <-) (#f) _)
  (env ((match (-> (app match-rep re (λ (pat) ...)) <-) (#f) c-x))))
clos/con:
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil ...))) <-))
    _))
  (env ((app seq (app regex-derivative pat c) (-> (app rep pat) <-)))))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x)
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x)
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x)
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x)
  (env
   ((app seq (-> (app regex-empty pat1) <-) (app regex-derivative pat2 c)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x)
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x)
  (env ((app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x)
  (env ((app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x)
  (env ((app regex-empty? (-> (app regex-empty pattern) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x)
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x)
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x)
  (env ((app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x)
  (env ((app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app match-rep re (λ (pat) ...)) <-) (#f) c-x)
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app match-rep re (λ (pat) ...)) <-) (#f) c-x)
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app match-rep re (λ (pat) ...)) <-) (#f) c-x)
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app match-rep re (λ (pat) ...)) <-) (#f) c-x)
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app match-rep re (λ (pat) ...)) <-) (#f) c-x)
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app match-rep re (λ (pat) ...)) <-) (#f) c-x)
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x)
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x)
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x)
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x)
  (env
   ((app seq (-> (app regex-empty pat1) <-) (app regex-derivative pat2 c)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x)
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x)
  (env ((app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x)
  (env ((app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x)
  (env ((app regex-empty? (-> (app regex-empty pattern) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x)
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x)
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x)
  (env ((app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x)
  (env ((app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app null? data) <-) (#f) _)
  (env
   ((app
     check-expect
     (->
      (app
       regex-match
       (app cons 'seq (app cons ...))
       (app cons 'foo (app cons ...)))
      <-)
     (app #f)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app null? data) <-) (#f) _)
  (env
   ((match
     (app null? data)
     ((#f)
      (->
       (app
        regex-match
        (app regex-derivative pattern (app car ...))
        (app cdr data))
       <-))
     _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app pair? re) <-) (#f) _)
  (env ((match (-> (app regex-alt? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app pair? re) <-) (#f) _)
  (env ((match (-> (app regex-rep? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app pair? re) <-) (#f) _)
  (env ((match (-> (app regex-rep? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app pair? re) <-) (#f) _)
  (env ((match (-> (app regex-seq? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-alt? re) <-) (#f) _)
  (env ((match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-alt? re) <-) (#f) _)
  (env ((match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-atom? re) <-) (#f) _)
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-atom? re) <-) (#f) _)
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-atom? re) <-) (#f) _)
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-atom? re) <-) (#f) _)
  (env
   ((app seq (-> (app regex-empty pat1) <-) (app regex-derivative pat2 c)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-atom? re) <-) (#f) _)
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-atom? re) <-) (#f) _)
  (env ((app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-atom? re) <-) (#f) _)
  (env ((app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-atom? re) <-) (#f) _)
  (env ((app regex-empty? (-> (app regex-empty pattern) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-atom? re) <-) (#f) _)
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-atom? re) <-) (#f) _)
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-atom? re) <-) (#f) _)
  (env ((app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-atom? re) <-) (#f) _)
  (env ((app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-empty? pat) <-) (#f) _)
  (env ((app seq (app regex-derivative pat c) (-> (app rep pat) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-empty? pat1) <-) (#f) _)
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-empty? pat1) <-) (#f) _)
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-empty? pat1) <-) (#f) _)
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-empty? pat1) <-) (#f) _)
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-empty? pat2) <-) (#f) _)
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-empty? pat2) <-) (#f) _)
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-empty? pat2) <-) (#f) _)
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-empty? pat2) <-) (#f) _)
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-empty? re) <-) (#f) _)
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-empty? re) <-) (#f) _)
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-empty? re) <-) (#f) _)
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-empty? re) <-) (#f) _)
  (env
   ((app seq (-> (app regex-empty pat1) <-) (app regex-derivative pat2 c)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-empty? re) <-) (#f) _)
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-empty? re) <-) (#f) _)
  (env ((app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-empty? re) <-) (#f) _)
  (env ((app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-empty? re) <-) (#f) _)
  (env ((app regex-empty? (-> (app regex-empty pattern) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-empty? re) <-) (#f) _)
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-empty? re) <-) (#f) _)
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-empty? re) <-) (#f) _)
  (env ((app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-empty? re) <-) (#f) _)
  (env ((app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-null? pat) <-) (#f) _)
  (env ((app seq (app regex-derivative pat c) (-> (app rep pat) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-null? pat1) <-) (#f) _)
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-null? pat1) <-) (#f) _)
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-null? pat1) <-) (#f) _)
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-null? pat1) <-) (#f) _)
  (env
   ((λ (pat1 pat2)
      (->
       (app
        alt
        (app seq (app regex-derivative ...) pat2)
        (app seq (app regex-empty ...) (app regex-derivative ...)))
       <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-null? pat1) <-) (#f) _)
  (env
   ((λ (pat1 pat2)
      (->
       (app alt (app regex-derivative pat1 c) (app regex-derivative pat2 c))
       <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-null? pat1) <-) (#f) _)
  (env
   ((λ (pat1 pat2)
      (-> (app alt (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-null? pat1) <-) (#f) _)
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-null? pat2) <-) (#f) _)
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-null? pat2) <-) (#f) _)
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-null? pat2) <-) (#f) _)
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-null? pat2) <-) (#f) _)
  (env
   ((λ (pat1 pat2)
      (->
       (app
        alt
        (app seq (app regex-derivative ...) pat2)
        (app seq (app regex-empty ...) (app regex-derivative ...)))
       <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-null? pat2) <-) (#f) _)
  (env
   ((λ (pat1 pat2)
      (->
       (app alt (app regex-derivative pat1 c) (app regex-derivative pat2 c))
       <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-null? pat2) <-) (#f) _)
  (env
   ((λ (pat1 pat2)
      (-> (app alt (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-null? pat2) <-) (#f) _)
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-null? re) <-) (#f) _)
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-null? re) <-) (#f) _)
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-null? re) <-) (#f) _)
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-null? re) <-) (#f) _)
  (env
   ((app seq (-> (app regex-empty pat1) <-) (app regex-derivative pat2 c)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-null? re) <-) (#f) _)
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-null? re) <-) (#f) _)
  (env ((app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-null? re) <-) (#f) _)
  (env ((app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-null? re) <-) (#f) _)
  (env ((app regex-empty? (-> (app regex-empty pattern) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-null? re) <-) (#f) _)
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-null? re) <-) (#f) _)
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-null? re) <-) (#f) _)
  (env ((app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-null? re) <-) (#f) _)
  (env ((app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-rep? re) <-) (#f) _)
  (env
   ((app seq (-> (app regex-empty pat1) <-) (app regex-derivative pat2 c)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-rep? re) <-) (#f) _)
  (env ((app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-rep? re) <-) (#f) _)
  (env ((app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-rep? re) <-) (#f) _)
  (env ((app regex-empty? (-> (app regex-empty pattern) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-rep? re) <-) (#f) _)
  (env ((app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-rep? re) <-) (#f) _)
  (env ((app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-rep? re) <-) (#f) _)
  (env ((match (-> (app match-rep re (λ (pat) ...)) <-) (#f) c-x))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-seq? re) <-) (#f) _)
  (env ((match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-seq? re) <-) (#f) _)
  (env ((match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app symbol? re) <-) (#f) _)
  (env ((match (-> (app regex-atom? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app symbol? re) <-) (#f) _)
  (env ((match (-> (app regex-atom? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> car-v <-) (cons car-c car-d))
  (env ((app eq? (-> (app car re) <-) 'alt))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> car-v <-) (cons car-c car-d))
  (env ((app eq? (-> (app car re) <-) 'rep))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> car-v <-) (cons car-c car-d))
  (env ((app eq? (-> (app car re) <-) 'seq))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> car-v <-) (cons car-c car-d))
  (env ((app regex-derivative pattern (-> (app car data) <-)))))
clos/con:
	'((con
   cons
   (app
    regex-match
    (app cons 'seq (app cons 'foo (app cons ...)))
    (-> (app cons 'foo (app cons 'bar (app nil ...))) <-)))
  (env ()))
	'((con cons (app cons 'foo (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> car-v <-) (cons car-c car-d))
  (env ((λ (p) (-> (app car (app cdr (app cdr ...))) <-)))))
clos/con:
	'((con
   cons
   (app cons 'foo (-> (app cons (app cons 'rep (app cons ...)) (app nil)) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> car-v <-) (cons car-c car-d))
  (env ((λ (p) (-> (app car (app cdr p)) <-)))))
clos/con:
	'((con
   cons
   (app
    cons
    'seq
    (-> (app cons 'foo (app cons (app cons ...) (app nil ...))) <-)))
  (env ()))
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> cdr-v <-) (cons cdr-c cdr-d))
  (env
   ((app
     regex-match
     (app regex-derivative pattern (app car data))
     (-> (app cdr data) <-)))))
clos/con:
	'((con
   cons
   (app
    regex-match
    (app cons 'seq (app cons 'foo (app cons ...)))
    (-> (app cons 'foo (app cons 'bar (app nil ...))) <-)))
  (env ()))
	'((con cons (app cons 'foo (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> cdr-v <-) (cons cdr-c cdr-d))
  (env ((app car (-> (app cdr (app cdr p)) <-)))))
clos/con:
	'((con
   cons
   (app
    cons
    'seq
    (-> (app cons 'foo (app cons (app cons ...) (app nil ...))) <-)))
  (env ()))
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> cdr-v <-) (cons cdr-c cdr-d))
  (env ((app car (-> (app cdr p) <-)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> cdr-v <-) (cons cdr-c cdr-d))
  (env ((app cdr (-> (app cdr p) <-)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> null?-v <-) (nil) _)
  (env ((match (-> (app null? data) <-) (#f) _))))
clos/con:
	'((con
   cons
   (app
    regex-match
    (app cons 'seq (app cons 'foo (app cons ...)))
    (-> (app cons 'foo (app cons 'bar (app nil ...))) <-)))
  (env ()))
	'((con cons (app cons 'foo (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> pair?-v <-) (cons pair?-c pair?-d) _)
  (env ((match (-> (app pair? re) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> pair?-v <-) (cons pair?-c pair?-d) _)
  (env ((match (-> (app pair? re) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> pair?-v <-) (cons pair?-c pair?-d) _)
  (env ((match (-> (app pair? re) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app char? re) ((#f) (-> (match (app symbol? re) ...) <-)) _)
  (env ((match (-> (app regex-atom? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app char? re) ((#f) (-> (match (app symbol? re) ...) <-)) _)
  (env ((match (-> (app regex-atom? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app eq? (app car re) 'alt) (#f) (_ (-> (app #t) <-)))
  (env ((match (-> (app regex-alt? re) <-) (#f) _))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app eq? (app car re) 'alt) ((#f) (-> (app #f) <-)) _)
  (env ((match (-> (app regex-alt? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app eq? (app car re) 'rep) (#f) (_ (-> (app #t) <-)))
  (env ((match (-> (app regex-rep? re) <-) (#f) _))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app eq? (app car re) 'rep) (#f) (_ (-> (app #t) <-)))
  (env ((match (-> (app regex-rep? re) <-) (#f) _))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app eq? (app car re) 'rep) ((#f) (-> (app #f) <-)) _)
  (env ((match (-> (app regex-rep? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app eq? (app car re) 'rep) ((#f) (-> (app #f) <-)) _)
  (env ((match (-> (app regex-rep? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app eq? (app car re) 'seq) (#f) (_ (-> (app #t) <-)))
  (env ((match (-> (app regex-seq? re) <-) (#f) _))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app eq? (app car re) 'seq) ((#f) (-> (app #f) <-)) _)
  (env ((match (-> (app regex-seq? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app eq? c re) (#f) (_ (-> regex-BLANK <-)))
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app eq? c re) (#f) (_ (-> regex-BLANK <-)))
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app eq? c re) (#f) (_ (-> regex-BLANK <-)))
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app eq? c re) (#f) (_ (-> regex-BLANK <-)))
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app eq? c re) (#f) (_ (-> regex-BLANK <-)))
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app eq? c re) (#f) (_ (-> regex-BLANK <-)))
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app eq? c re) ((#f) (-> (match (app regex-atom? re) ...) <-)) _)
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app eq? c re) ((#f) (-> (match (app regex-atom? re) ...) <-)) _)
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app eq? c re) ((#f) (-> (match (app regex-atom? re) ...) <-)) _)
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app eq? c re) ((#f) (-> (match (app regex-atom? re) ...) <-)) _)
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app eq? c re) ((#f) (-> (match (app regex-atom? re) ...) <-)) _)
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app eq? c re) ((#f) (-> (match (app regex-atom? re) ...) <-)) _)
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app f (app cadr re) (app caddr re)) (#f) (_ (-> (app #t) <-)))
  (env ((match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app f (app cadr re) (app caddr re)) (#f) (_ (-> (app #t) <-)))
  (env ((match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app f (app cadr re) (app caddr re)) (#f) (_ (-> (app #t) <-)))
  (env ((match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app f (app cadr re) (app caddr re)) (#f) (_ (-> (app #t) <-)))
  (env ((match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app f (app cadr re) (app caddr re)) ((#f) (-> (app #f) <-)) _)
  (env ((match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app f (app cadr re) (app caddr re)) ((#f) (-> (app #f) <-)) _)
  (env ((match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app f (app cadr re) (app caddr re)) ((#f) (-> (app #f) <-)) _)
  (env ((match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app f (app cadr re) (app caddr re)) ((#f) (-> (app #f) <-)) _)
  (env ((match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app f (app cadr re)) (#f) (_ (-> (app #t) <-)))
  (env ((match (-> (app match-rep re (λ (pat) ...)) <-) (#f) c-x))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app f (app cadr re)) ((#f) (-> (app #f) <-)) _)
  (env ((match (-> (app match-rep re (λ (pat) ...)) <-) (#f) c-x))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-alt re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-alt re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-alt re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-alt re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env
   ((app seq (-> (app regex-empty pat1) <-) (app regex-derivative pat2 c)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-alt re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-alt re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env ((app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-alt re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env ((app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-alt re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env ((app regex-empty? (-> (app regex-empty pattern) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-alt re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-alt re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-alt re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env ((app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-alt re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env ((app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-rep re (λ (pat) ...)) (#f) (c-x (-> c-x <-)))
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-rep re (λ (pat) ...)) (#f) (c-x (-> c-x <-)))
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-rep re (λ (pat) ...)) (#f) (c-x (-> c-x <-)))
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-rep re (λ (pat) ...)) (#f) (c-x (-> c-x <-)))
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-rep re (λ (pat) ...)) (#f) (c-x (-> c-x <-)))
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-rep re (λ (pat) ...)) (#f) (c-x (-> c-x <-)))
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-rep re (λ (pat) ...)) ((#f) (-> regex-NULL <-)) c-x)
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-rep re (λ (pat) ...)) ((#f) (-> regex-NULL <-)) c-x)
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-rep re (λ (pat) ...)) ((#f) (-> regex-NULL <-)) c-x)
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-rep re (λ (pat) ...)) ((#f) (-> regex-NULL <-)) c-x)
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-rep re (λ (pat) ...)) ((#f) (-> regex-NULL <-)) c-x)
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-rep re (λ (pat) ...)) ((#f) (-> regex-NULL <-)) c-x)
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-seq re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-seq re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-seq re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-seq re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env
   ((app seq (-> (app regex-empty pat1) <-) (app regex-derivative pat2 c)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-seq re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-seq re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env ((app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-seq re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env ((app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-seq re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env ((app regex-empty? (-> (app regex-empty pattern) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-seq re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-seq re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-seq re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env ((app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-seq re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env ((app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app pair? re) ((#f) (-> (app #f) <-)) _)
  (env ((match (-> (app regex-alt? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app pair? re) ((#f) (-> (app #f) <-)) _)
  (env ((match (-> (app regex-rep? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app pair? re) ((#f) (-> (app #f) <-)) _)
  (env ((match (-> (app regex-rep? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app pair? re) ((#f) (-> (app #f) <-)) _)
  (env ((match (-> (app regex-seq? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-alt? re) ((#f) (-> (app #f) <-)) _)
  (env ((match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-alt? re) ((#f) (-> (app #f) <-)) _)
  (env ((match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-atom? re) (#f) (_ (-> (app #f) <-)))
  (env
   ((app seq (-> (app regex-empty pat1) <-) (app regex-derivative pat2 c)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-atom? re) (#f) (_ (-> (app #f) <-)))
  (env ((app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-atom? re) (#f) (_ (-> (app #f) <-)))
  (env ((app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-atom? re) (#f) (_ (-> (app #f) <-)))
  (env ((app regex-empty? (-> (app regex-empty pattern) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-atom? re) (#f) (_ (-> (app #f) <-)))
  (env ((app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-atom? re) (#f) (_ (-> (app #f) <-)))
  (env ((app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-atom? re) (#f) (_ (-> regex-NULL <-)))
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-atom? re) (#f) (_ (-> regex-NULL <-)))
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-atom? re) (#f) (_ (-> regex-NULL <-)))
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-atom? re) (#f) (_ (-> regex-NULL <-)))
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-atom? re) (#f) (_ (-> regex-NULL <-)))
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-atom? re) (#f) (_ (-> regex-NULL <-)))
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-empty? pat) (#f) (_ (-> regex-BLANK <-)))
  (env ((app seq (app regex-derivative pat c) (-> (app rep pat) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-empty? pat1) (#f) (_ (-> pat2 <-)))
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-empty? pat1) (#f) (_ (-> pat2 <-)))
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-empty? pat1) (#f) (_ (-> pat2 <-)))
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
clos/con:
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil ...))) <-))
    _))
  (env ((app seq (app regex-derivative pat c) (-> (app rep pat) <-)))))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-empty? pat1) (#f) (_ (-> pat2 <-)))
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-empty? pat2) (#f) (_ (-> pat1 <-)))
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-empty? pat2) (#f) (_ (-> pat1 <-)))
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-empty? pat2) (#f) (_ (-> pat1 <-)))
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-empty? pat2) (#f) (_ (-> pat1 <-)))
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-empty? re) (#f) (_ (-> (app #t) <-)))
  (env
   ((app seq (-> (app regex-empty pat1) <-) (app regex-derivative pat2 c)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-empty? re) (#f) (_ (-> (app #t) <-)))
  (env ((app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-empty? re) (#f) (_ (-> (app #t) <-)))
  (env ((app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-empty? re) (#f) (_ (-> (app #t) <-)))
  (env ((app regex-empty? (-> (app regex-empty pattern) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-empty? re) (#f) (_ (-> (app #t) <-)))
  (env ((app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-empty? re) (#f) (_ (-> (app #t) <-)))
  (env ((app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-empty? re) (#f) (_ (-> regex-NULL <-)))
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-empty? re) (#f) (_ (-> regex-NULL <-)))
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-empty? re) (#f) (_ (-> regex-NULL <-)))
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-empty? re) (#f) (_ (-> regex-NULL <-)))
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-empty? re) (#f) (_ (-> regex-NULL <-)))
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-empty? re) (#f) (_ (-> regex-NULL <-)))
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-null? pat) (#f) (_ (-> regex-BLANK <-)))
  (env ((app seq (app regex-derivative pat c) (-> (app rep pat) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-null? pat1) (#f) (_ (-> pat2 <-)))
  (env
   ((λ (pat1 pat2)
      (->
       (app
        alt
        (app seq (app regex-derivative ...) pat2)
        (app seq (app regex-empty ...) (app regex-derivative ...)))
       <-)))))
clos/con:
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-null? pat1) (#f) (_ (-> pat2 <-)))
  (env
   ((λ (pat1 pat2)
      (->
       (app alt (app regex-derivative pat1 c) (app regex-derivative pat2 c))
       <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-null? pat1) (#f) (_ (-> pat2 <-)))
  (env
   ((λ (pat1 pat2)
      (-> (app alt (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-null? pat1) (#f) (_ (-> regex-NULL <-)))
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-null? pat1) (#f) (_ (-> regex-NULL <-)))
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-null? pat1) (#f) (_ (-> regex-NULL <-)))
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-null? pat1) (#f) (_ (-> regex-NULL <-)))
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-null? pat2) (#f) (_ (-> pat1 <-)))
  (env
   ((λ (pat1 pat2)
      (->
       (app
        alt
        (app seq (app regex-derivative ...) pat2)
        (app seq (app regex-empty ...) (app regex-derivative ...)))
       <-)))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-null? pat2) (#f) (_ (-> pat1 <-)))
  (env
   ((λ (pat1 pat2)
      (->
       (app alt (app regex-derivative pat1 c) (app regex-derivative pat2 c))
       <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-null? pat2) (#f) (_ (-> pat1 <-)))
  (env
   ((λ (pat1 pat2)
      (-> (app alt (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-null? pat2) (#f) (_ (-> regex-NULL <-)))
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-null? pat2) (#f) (_ (-> regex-NULL <-)))
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-null? pat2) (#f) (_ (-> regex-NULL <-)))
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-null? pat2) (#f) (_ (-> regex-NULL <-)))
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-null? re) (#f) (_ (-> (app #f) <-)))
  (env
   ((app seq (-> (app regex-empty pat1) <-) (app regex-derivative pat2 c)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-null? re) (#f) (_ (-> (app #f) <-)))
  (env ((app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-null? re) (#f) (_ (-> (app #f) <-)))
  (env ((app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-null? re) (#f) (_ (-> (app #f) <-)))
  (env ((app regex-empty? (-> (app regex-empty pattern) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-null? re) (#f) (_ (-> (app #f) <-)))
  (env ((app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-null? re) (#f) (_ (-> (app #f) <-)))
  (env ((app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-null? re) (#f) (_ (-> regex-NULL <-)))
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-null? re) (#f) (_ (-> regex-NULL <-)))
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-null? re) (#f) (_ (-> regex-NULL <-)))
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-null? re) (#f) (_ (-> regex-NULL <-)))
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-null? re) (#f) (_ (-> regex-NULL <-)))
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-null? re) (#f) (_ (-> regex-NULL <-)))
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-null? re) ((#f) (-> (match (app eq? c re) ...) <-)) _)
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-null? re) ((#f) (-> (match (app eq? c re) ...) <-)) _)
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-null? re) ((#f) (-> (match (app eq? c re) ...) <-)) _)
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-null? re) ((#f) (-> (match (app eq? c re) ...) <-)) _)
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-null? re) ((#f) (-> (match (app eq? c re) ...) <-)) _)
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-null? re) ((#f) (-> (match (app eq? c re) ...) <-)) _)
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-rep? re) (#f) (_ (-> (app #t) <-)))
  (env
   ((app seq (-> (app regex-empty pat1) <-) (app regex-derivative pat2 c)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-rep? re) (#f) (_ (-> (app #t) <-)))
  (env ((app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-rep? re) (#f) (_ (-> (app #t) <-)))
  (env ((app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-rep? re) (#f) (_ (-> (app #t) <-)))
  (env ((app regex-empty? (-> (app regex-empty pattern) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-rep? re) (#f) (_ (-> (app #t) <-)))
  (env ((app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-rep? re) (#f) (_ (-> (app #t) <-)))
  (env ((app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-rep? re) ((#f) (-> (app #f) <-)) _)
  (env
   ((app seq (-> (app regex-empty pat1) <-) (app regex-derivative pat2 c)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-rep? re) ((#f) (-> (app #f) <-)) _)
  (env ((app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-rep? re) ((#f) (-> (app #f) <-)) _)
  (env ((app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-rep? re) ((#f) (-> (app #f) <-)) _)
  (env ((app regex-empty? (-> (app regex-empty pattern) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-rep? re) ((#f) (-> (app #f) <-)) _)
  (env ((app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-rep? re) ((#f) (-> (app #f) <-)) _)
  (env ((app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-rep? re) ((#f) (-> (app #f) <-)) _)
  (env ((match (-> (app match-rep re (λ (pat) ...)) <-) (#f) c-x))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-seq? re) ((#f) (-> (app #f) <-)) _)
  (env ((match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-seq? re) ((#f) (-> (app #f) <-)) _)
  (env ((match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app symbol? re) (#f) (_ (-> (app #t) <-)))
  (env ((match (-> (app regex-atom? re) <-) (#f) _))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app symbol? re) (#f) (_ (-> (app #t) <-)))
  (env ((match (-> (app regex-atom? re) <-) (#f) _))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app symbol? re) ((#f) (-> (app #f) <-)) _)
  (env ((match (-> (app regex-atom? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app symbol? re) ((#f) (-> (app #f) <-)) _)
  (env ((match (-> (app regex-atom? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match car-v ((cons car-c car-d) (-> car-c <-)))
  (env ((app eq? (-> (app car re) <-) 'alt))))
clos/con:
	'((app
   cons
   (-> 'seq <-)
   (app cons 'foo (app cons (app cons ...) (app nil ...))))
  (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match car-v ((cons car-c car-d) (-> car-c <-)))
  (env ((app eq? (-> (app car re) <-) 'rep))))
clos/con:
	'((app
   cons
   (-> 'seq <-)
   (app cons 'foo (app cons (app cons ...) (app nil ...))))
  (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match car-v ((cons car-c car-d) (-> car-c <-)))
  (env ((app eq? (-> (app car re) <-) 'seq))))
clos/con:
	'((app
   cons
   (-> 'seq <-)
   (app cons 'foo (app cons (app cons ...) (app nil ...))))
  (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match car-v ((cons car-c car-d) (-> car-c <-)))
  (env ((app regex-derivative pattern (-> (app car data) <-)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match car-v ((cons car-c car-d) (-> car-c <-)))
  (env ((λ (p) (-> (app car (app cdr (app cdr ...))) <-)))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match car-v ((cons car-c car-d) (-> car-c <-)))
  (env ((λ (p) (-> (app car (app cdr p)) <-)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-)))
  (env
   ((app
     regex-match
     (app regex-derivative pattern (app car data))
     (-> (app cdr data) <-)))))
clos/con:
	'((con cons (app cons 'foo (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-)))
  (env ((app car (-> (app cdr (app cdr p)) <-)))))
clos/con:
	'((con
   cons
   (app cons 'foo (-> (app cons (app cons 'rep (app cons ...)) (app nil)) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-)))
  (env ((app car (-> (app cdr p) <-)))))
clos/con:
	'((con
   cons
   (app
    cons
    'seq
    (-> (app cons 'foo (app cons (app cons ...) (app nil ...))) <-)))
  (env ()))
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-)))
  (env ((app cdr (-> (app cdr p) <-)))))
clos/con:
	'((con
   cons
   (app
    cons
    'seq
    (-> (app cons 'foo (app cons (app cons ...) (app nil ...))) <-)))
  (env ()))
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match null?-v ((nil) (-> (app #t) <-)) _)
  (env ((match (-> (app null? data) <-) (#f) _))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match null?-v (nil) (_ (-> (app #f) <-)))
  (env ((match (-> (app null? data) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match pair?-v ((cons pair?-c pair?-d) (-> (app #t) <-)) _)
  (env ((match (-> (app pair? re) <-) (#f) _))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match pair?-v ((cons pair?-c pair?-d) (-> (app #t) <-)) _)
  (env ((match (-> (app pair? re) <-) (#f) _))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match pair?-v ((cons pair?-c pair?-d) (-> (app #t) <-)) _)
  (env ((match (-> (app pair? re) <-) (#f) _))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match pair?-v (cons pair?-c pair?-d) (_ (-> (app #f) <-)))
  (env ((match (-> (app pair? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match pair?-v (cons pair?-c pair?-d) (_ (-> (app #f) <-)))
  (env ((match (-> (app pair? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match pair?-v (cons pair?-c pair?-d) (_ (-> (app #f) <-)))
  (env ((match (-> (app pair? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (car-v) (-> (match car-v ...) <-))
  (env ((app eq? (-> (app car re) <-) 'alt))))
clos/con:
	'((app
   cons
   (-> 'seq <-)
   (app cons 'foo (app cons (app cons ...) (app nil ...))))
  (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (car-v) (-> (match car-v ...) <-))
  (env ((app eq? (-> (app car re) <-) 'rep))))
clos/con:
	'((app
   cons
   (-> 'seq <-)
   (app cons 'foo (app cons (app cons ...) (app nil ...))))
  (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (car-v) (-> (match car-v ...) <-))
  (env ((app eq? (-> (app car re) <-) 'seq))))
clos/con:
	'((app
   cons
   (-> 'seq <-)
   (app cons 'foo (app cons (app cons ...) (app nil ...))))
  (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (car-v) (-> (match car-v ...) <-))
  (env ((app regex-derivative pattern (-> (app car data) <-)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (car-v) (-> (match car-v ...) <-))
  (env ((λ (p) (-> (app car (app cdr (app cdr ...))) <-)))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (car-v) (-> (match car-v ...) <-))
  (env ((λ (p) (-> (app car (app cdr p)) <-)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (cdr-v) (-> (match cdr-v ...) <-))
  (env
   ((app
     regex-match
     (app regex-derivative pattern (app car data))
     (-> (app cdr data) <-)))))
clos/con:
	'((con cons (app cons 'foo (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (cdr-v) (-> (match cdr-v ...) <-))
  (env ((app car (-> (app cdr (app cdr p)) <-)))))
clos/con:
	'((con
   cons
   (app cons 'foo (-> (app cons (app cons 'rep (app cons ...)) (app nil)) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (cdr-v) (-> (match cdr-v ...) <-))
  (env ((app car (-> (app cdr p) <-)))))
clos/con:
	'((con
   cons
   (app
    cons
    'seq
    (-> (app cons 'foo (app cons (app cons ...) (app nil ...))) <-)))
  (env ()))
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (cdr-v) (-> (match cdr-v ...) <-))
  (env ((app cdr (-> (app cdr p) <-)))))
clos/con:
	'((con
   cons
   (app
    cons
    'seq
    (-> (app cons 'foo (app cons (app cons ...) (app nil ...))) <-)))
  (env ()))
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (check expect) (-> (app equal? check expect) <-))
  (env
   ((letrec*
     (car ... check-expect)
     (->
      (app
       check-expect
       (app regex-match (app cons ...) (app cons ...))
       (app #f))
      <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (null?-v) (-> (match null?-v ...) <-))
  (env ((match (-> (app null? data) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (p) (-> (app car (app cdr (app cdr ...))) <-))
  (env ((app f (app cadr re) (-> (app caddr re) <-)))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (p) (-> (app car (app cdr (app cdr ...))) <-))
  (env ((app f (app cadr re) (-> (app caddr re) <-)))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (p) (-> (app car (app cdr p)) <-))
  (env ((app f (-> (app cadr re) <-) (app caddr re)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (p) (-> (app car (app cdr p)) <-))
  (env ((app f (-> (app cadr re) <-) (app caddr re)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (p) (-> (app car (app cdr p)) <-))
  (env ((app f (-> (app cadr re) <-)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (pair?-v) (-> (match pair?-v ...) <-))
  (env ((match (-> (app pair? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (pair?-v) (-> (match pair?-v ...) <-))
  (env ((match (-> (app pair? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (pair?-v) (-> (match pair?-v ...) <-))
  (env ((match (-> (app pair? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-))
  (env ((match (-> (app f (app cadr re)) <-) (#f) _))))
clos/con:
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil ...))) <-))
    _))
  (env ((app seq (app regex-derivative pat c) (-> (app rep pat) <-)))))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (pat) (-> (match (app regex-null? pat) ...) <-))
  (env ((app seq (app regex-derivative pat c) (-> (app rep pat) <-)))))
clos/con:
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil ...))) <-))
    _))
  (env ((app seq (app regex-derivative pat c) (-> (app rep pat) <-)))))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (pat1 pat2)
    (->
     (app
      alt
      (app seq (app regex-derivative ...) pat2)
      (app seq (app regex-empty ...) (app regex-derivative ...)))
     <-))
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((λ (pat1 pat2)
      (->
       (app
        alt
        (app seq (app regex-derivative ...) pat2)
        (app seq (app regex-empty ...) (app regex-derivative ...)))
       <-)))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (pat1 pat2)
    (->
     (app alt (app regex-derivative pat1 c) (app regex-derivative pat2 c))
     <-))
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((λ (pat1 pat2)
      (->
       (app alt (app regex-derivative pat1 c) (app regex-derivative pat2 c))
       <-)))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (pat1 pat2)
    (-> (app alt (app regex-empty pat1) (app regex-empty pat2)) <-))
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((λ (pat1 pat2)
      (-> (app alt (app regex-empty pat1) (app regex-empty pat2)) <-)))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (pat1 pat2)
    (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-))
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (pat1 pat2) (-> (match (app regex-null? pat1) ...) <-))
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (pat1 pat2) (-> (match (app regex-null? pat1) ...) <-))
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
clos/con:
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (pat1 pat2) (-> (match (app regex-null? pat1) ...) <-))
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
clos/con:
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil ...))) <-))
    _))
  (env ((app seq (app regex-derivative pat c) (-> (app rep pat) <-)))))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (pat1 pat2) (-> (match (app regex-null? pat1) ...) <-))
  (env
   ((λ (pat1 pat2)
      (->
       (app
        alt
        (app seq (app regex-derivative ...) pat2)
        (app seq (app regex-empty ...) (app regex-derivative ...)))
       <-)))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((λ (pat1 pat2)
      (->
       (app
        alt
        (app seq (app regex-derivative ...) pat2)
        (app seq (app regex-empty ...) (app regex-derivative ...)))
       <-)))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (pat1 pat2) (-> (match (app regex-null? pat1) ...) <-))
  (env
   ((λ (pat1 pat2)
      (->
       (app alt (app regex-derivative pat1 c) (app regex-derivative pat2 c))
       <-)))))
clos/con:
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((λ (pat1 pat2)
      (->
       (app alt (app regex-derivative pat1 c) (app regex-derivative pat2 c))
       <-)))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (pat1 pat2) (-> (match (app regex-null? pat1) ...) <-))
  (env
   ((λ (pat1 pat2)
      (-> (app alt (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con
   cons
   (match
    (app regex-null? pat2)
    ((#f) (-> (app cons 'alt (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((λ (pat1 pat2)
      (-> (app alt (app regex-empty pat1) (app regex-empty pat2)) <-)))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (pat1 pat2) (-> (match (app regex-null? pat1) ...) <-))
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (pattern data) (-> (match (app null? data) ...) <-))
  (env
   ((app
     check-expect
     (->
      (app
       regex-match
       (app cons 'seq (app cons ...))
       (app cons 'foo (app cons ...)))
      <-)
     (app #f)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (pattern data) (-> (match (app null? data) ...) <-))
  (env
   ((match
     (app null? data)
     ((#f)
      (->
       (app
        regex-match
        (app regex-derivative pattern (app car ...))
        (app cdr data))
       <-))
     _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (re c) (-> (let (_) ...) <-))
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (re c) (-> (let (_) ...) <-))
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (re c) (-> (let (_) ...) <-))
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (re c) (-> (let (_) ...) <-))
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (re c) (-> (let (_) ...) <-))
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (re c) (-> (let (_) ...) <-))
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (re f) (-> (match (app regex-alt? re) ...) <-))
  (env ((match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (re f) (-> (match (app regex-alt? re) ...) <-))
  (env ((match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (re f) (-> (match (app regex-rep? re) ...) <-))
  (env ((match (-> (app match-rep re (λ (pat) ...)) <-) (#f) c-x))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (re f) (-> (match (app regex-seq? re) ...) <-))
  (env ((match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (re f) (-> (match (app regex-seq? re) ...) <-))
  (env ((match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (re) (-> (app eq? re (app #f)) <-))
  (env ((match (-> (app regex-null? pat) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (re) (-> (app eq? re (app #f)) <-))
  (env ((match (-> (app regex-null? pat1) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (re) (-> (app eq? re (app #f)) <-))
  (env ((match (-> (app regex-null? pat1) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (re) (-> (app eq? re (app #f)) <-))
  (env ((match (-> (app regex-null? pat2) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (re) (-> (app eq? re (app #f)) <-))
  (env ((match (-> (app regex-null? pat2) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (re) (-> (app eq? re (app #f)) <-))
  (env ((match (-> (app regex-null? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (re) (-> (app eq? re (app #f)) <-))
  (env ((match (-> (app regex-null? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (re) (-> (app eq? re (app #t)) <-))
  (env
   ((match
     (app null? data)
     (#f)
     (_ (-> (app regex-empty? (app regex-empty pattern)) <-))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (re) (-> (app eq? re (app #t)) <-))
  (env ((match (-> (app regex-empty? pat) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (re) (-> (app eq? re (app #t)) <-))
  (env ((match (-> (app regex-empty? pat1) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (re) (-> (app eq? re (app #t)) <-))
  (env ((match (-> (app regex-empty? pat2) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (re) (-> (app eq? re (app #t)) <-))
  (env ((match (-> (app regex-empty? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (re) (-> (app eq? re (app #t)) <-))
  (env ((match (-> (app regex-empty? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (re) (-> (match (app char? re) ...) <-))
  (env ((match (-> (app regex-atom? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (re) (-> (match (app char? re) ...) <-))
  (env ((match (-> (app regex-atom? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (re) (-> (match (app pair? re) ...) <-))
  (env ((match (-> (app regex-alt? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (re) (-> (match (app pair? re) ...) <-))
  (env ((match (-> (app regex-rep? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (re) (-> (match (app pair? re) ...) <-))
  (env ((match (-> (app regex-rep? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (re) (-> (match (app pair? re) ...) <-))
  (env ((match (-> (app regex-seq? re) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (re) (-> (match (app regex-empty? re) ...) <-))
  (env
   ((app seq (-> (app regex-empty pat1) <-) (app regex-derivative pat2 c)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (re) (-> (match (app regex-empty? re) ...) <-))
  (env ((app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (re) (-> (match (app regex-empty? re) ...) <-))
  (env ((app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (re) (-> (match (app regex-empty? re) ...) <-))
  (env ((app regex-empty? (-> (app regex-empty pattern) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (re) (-> (match (app regex-empty? re) ...) <-))
  (env ((app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (re) (-> (match (app regex-empty? re) ...) <-))
  (env ((app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: ((top) lettypes (cons ... nil) ...) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app car (-> (app cdr p) <-)) (env ((app f (-> (app cadr re) <-)))))
clos/con:
	'((con
   cons
   (app
    cons
    'seq
    (-> (app cons 'foo (app cons (app cons ...) (app nil ...))) <-)))
  (env ()))
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cdr (-> p <-)) (env ((app f (-> (app cadr re) <-)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 'bar (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 'bar (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 'foo (-> (app cons 'bar (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons 'foo (-> (app cons 'bar (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 'rep (-> (app cons 'bar (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (lettypes cons ... nil (letrec* (car ... check-expect) ...)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  _
  (let (... () (_ (-> (app debug-trace) <-)) () ...) ...)
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((λ () (-> 'do-nothing <-))
  (env ((let (... () (_ (-> (app debug-trace) <-)) () ...) ...))))
literals: '(⊥ ⊥ ⊥)

'(store:
  _
  (let (... () (_ (-> (app debug-trace) <-)) () ...) ...)
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((λ () (-> 'do-nothing <-))
  (env ((let (... () (_ (-> (app debug-trace) <-)) () ...) ...))))
literals: '(⊥ ⊥ ⊥)

'(store:
  _
  (let (... () (_ (-> (app debug-trace) <-)) () ...) ...)
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((λ () (-> 'do-nothing <-))
  (env ((let (... () (_ (-> (app debug-trace) <-)) () ...) ...))))
literals: '(⊥ ⊥ ⊥)

'(store:
  _
  (let (... () (_ (-> (app debug-trace) <-)) () ...) ...)
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((λ () (-> 'do-nothing <-))
  (env ((let (... () (_ (-> (app debug-trace) <-)) () ...) ...))))
literals: '(⊥ ⊥ ⊥)

'(store:
  _
  (let (... () (_ (-> (app debug-trace) <-)) () ...) ...)
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((λ () (-> 'do-nothing <-))
  (env ((let (... () (_ (-> (app debug-trace) <-)) () ...) ...))))
literals: '(⊥ ⊥ ⊥)

'(store:
  _
  (let (... () (_ (-> (app debug-trace) <-)) () ...) ...)
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((λ () (-> 'do-nothing <-))
  (env ((let (... () (_ (-> (app debug-trace) <-)) () ...) ...))))
literals: '(⊥ ⊥ ⊥)

'(store:
  alt
  (letrec* (... seq (alt (-> (λ (pat1 pat2) ...) <-)) rep ...) ...)
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((letrec* (... seq (alt (-> (λ (pat1 pat2) ...) <-)) rep ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  alt
  (letrec* (... seq (alt (-> (λ (pat1 pat2) ...) <-)) rep ...) ...)
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((letrec* (... seq (alt (-> (λ (pat1 pat2) ...) <-)) rep ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  alt
  (letrec* (... seq (alt (-> (λ (pat1 pat2) ...) <-)) rep ...) ...)
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((letrec* (... seq (alt (-> (λ (pat1 pat2) ...) <-)) rep ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  alt
  (letrec* (... seq (alt (-> (λ (pat1 pat2) ...) <-)) rep ...) ...)
  (env
   ((app seq (-> (app regex-empty pat1) <-) (app regex-derivative pat2 c)))))
clos/con:
	'((letrec* (... seq (alt (-> (λ (pat1 pat2) ...) <-)) rep ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  alt
  (letrec* (... seq (alt (-> (λ (pat1 pat2) ...) <-)) rep ...) ...)
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((letrec* (... seq (alt (-> (λ (pat1 pat2) ...) <-)) rep ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  alt
  (letrec* (... seq (alt (-> (λ (pat1 pat2) ...) <-)) rep ...) ...)
  (env ((app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((letrec* (... seq (alt (-> (λ (pat1 pat2) ...) <-)) rep ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  alt
  (letrec* (... seq (alt (-> (λ (pat1 pat2) ...) <-)) rep ...) ...)
  (env ((app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((letrec* (... seq (alt (-> (λ (pat1 pat2) ...) <-)) rep ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  alt
  (letrec* (... seq (alt (-> (λ (pat1 pat2) ...) <-)) rep ...) ...)
  (env ((app regex-empty? (-> (app regex-empty pattern) <-)))))
clos/con:
	'((letrec* (... seq (alt (-> (λ (pat1 pat2) ...) <-)) rep ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  alt
  (letrec* (... seq (alt (-> (λ (pat1 pat2) ...) <-)) rep ...) ...)
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((letrec* (... seq (alt (-> (λ (pat1 pat2) ...) <-)) rep ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  alt
  (letrec* (... seq (alt (-> (λ (pat1 pat2) ...) <-)) rep ...) ...)
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((letrec* (... seq (alt (-> (λ (pat1 pat2) ...) <-)) rep ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  alt
  (letrec* (... seq (alt (-> (λ (pat1 pat2) ...) <-)) rep ...) ...)
  (env ((app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((letrec* (... seq (alt (-> (λ (pat1 pat2) ...) <-)) rep ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  alt
  (letrec* (... seq (alt (-> (λ (pat1 pat2) ...) <-)) rep ...) ...)
  (env ((app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((letrec* (... seq (alt (-> (λ (pat1 pat2) ...) <-)) rep ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  alt
  (letrec* (... seq (alt (-> (λ (pat1 pat2) ...) <-)) rep ...) ...)
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((letrec* (... seq (alt (-> (λ (pat1 pat2) ...) <-)) rep ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  alt
  (letrec* (... seq (alt (-> (λ (pat1 pat2) ...) <-)) rep ...) ...)
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((letrec* (... seq (alt (-> (λ (pat1 pat2) ...) <-)) rep ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  alt
  (letrec* (... seq (alt (-> (λ (pat1 pat2) ...) <-)) rep ...) ...)
  (env ()))
clos/con:
	'((letrec* (... seq (alt (-> (λ (pat1 pat2) ...) <-)) rep ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c
  (λ (re c) (-> (let (_) ...) <-))
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c
  (λ (re c) (-> (let (_) ...) <-))
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c
  (λ (re c) (-> (let (_) ...) <-))
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c
  (λ (re c) (-> (let (_) ...) <-))
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c
  (λ (re c) (-> (let (_) ...) <-))
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c
  (λ (re c) (-> (let (_) ...) <-))
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c
  (λ (re c) (-> (let (_) ...) <-))
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c
  (λ (re c) (-> (let (_) ...) <-))
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c
  (λ (re c) (-> (let (_) ...) <-))
  (env ((match (-> (app f (app cadr re)) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c-x
  (match (app match-alt re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c-x
  (match (app match-alt re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c-x
  (match (app match-alt re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c-x
  (match (app match-alt re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env
   ((app seq (-> (app regex-empty pat1) <-) (app regex-derivative pat2 c)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c-x
  (match (app match-alt re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c-x
  (match (app match-alt re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env ((app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c-x
  (match (app match-alt re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env ((app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c-x
  (match (app match-alt re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env ((app regex-empty? (-> (app regex-empty pattern) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c-x
  (match (app match-alt re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c-x
  (match (app match-alt re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c-x
  (match (app match-alt re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env ((app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c-x
  (match (app match-alt re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env ((app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c-x
  (match (app match-rep re (λ (pat) ...)) (#f) (c-x (-> c-x <-)))
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c-x
  (match (app match-rep re (λ (pat) ...)) (#f) (c-x (-> c-x <-)))
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c-x
  (match (app match-rep re (λ (pat) ...)) (#f) (c-x (-> c-x <-)))
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c-x
  (match (app match-rep re (λ (pat) ...)) (#f) (c-x (-> c-x <-)))
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c-x
  (match (app match-rep re (λ (pat) ...)) (#f) (c-x (-> c-x <-)))
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c-x
  (match (app match-rep re (λ (pat) ...)) (#f) (c-x (-> c-x <-)))
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c-x
  (match (app match-seq re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c-x
  (match (app match-seq re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c-x
  (match (app match-seq re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c-x
  (match (app match-seq re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env
   ((app seq (-> (app regex-empty pat1) <-) (app regex-derivative pat2 c)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c-x
  (match (app match-seq re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c-x
  (match (app match-seq re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env ((app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c-x
  (match (app match-seq re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env ((app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c-x
  (match (app match-seq re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env ((app regex-empty? (-> (app regex-empty pattern) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c-x
  (match (app match-seq re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c-x
  (match (app match-seq re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c-x
  (match (app match-seq re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env ((app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c-x
  (match (app match-seq re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env ((app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  caddr
  (letrec* (... cadr (caddr (-> (λ (p) ...) <-)) regex-NULL ...) ...)
  (env ((match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((letrec* (... cadr (caddr (-> (λ (p) ...) <-)) regex-NULL ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  caddr
  (letrec* (... cadr (caddr (-> (λ (p) ...) <-)) regex-NULL ...) ...)
  (env ((match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((letrec* (... cadr (caddr (-> (λ (p) ...) <-)) regex-NULL ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  caddr
  (letrec* (... cadr (caddr (-> (λ (p) ...) <-)) regex-NULL ...) ...)
  (env ((match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((letrec* (... cadr (caddr (-> (λ (p) ...) <-)) regex-NULL ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  caddr
  (letrec* (... cadr (caddr (-> (λ (p) ...) <-)) regex-NULL ...) ...)
  (env ((match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((letrec* (... cadr (caddr (-> (λ (p) ...) <-)) regex-NULL ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  caddr
  (letrec* (... cadr (caddr (-> (λ (p) ...) <-)) regex-NULL ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cadr (caddr (-> (λ (p) ...) <-)) regex-NULL ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cadr
  (letrec* (... debug-trace (cadr (-> (λ (p) ...) <-)) caddr ...) ...)
  (env ((match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((letrec* (... debug-trace (cadr (-> (λ (p) ...) <-)) caddr ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cadr
  (letrec* (... debug-trace (cadr (-> (λ (p) ...) <-)) caddr ...) ...)
  (env ((match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((letrec* (... debug-trace (cadr (-> (λ (p) ...) <-)) caddr ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cadr
  (letrec* (... debug-trace (cadr (-> (λ (p) ...) <-)) caddr ...) ...)
  (env ((match (-> (app match-rep re (λ (pat) ...)) <-) (#f) c-x))))
clos/con:
	'((letrec* (... debug-trace (cadr (-> (λ (p) ...) <-)) caddr ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cadr
  (letrec* (... debug-trace (cadr (-> (λ (p) ...) <-)) caddr ...) ...)
  (env ((match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((letrec* (... debug-trace (cadr (-> (λ (p) ...) <-)) caddr ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cadr
  (letrec* (... debug-trace (cadr (-> (λ (p) ...) <-)) caddr ...) ...)
  (env ((match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((letrec* (... debug-trace (cadr (-> (λ (p) ...) <-)) caddr ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cadr
  (letrec* (... debug-trace (cadr (-> (λ (p) ...) <-)) caddr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... debug-trace (cadr (-> (λ (p) ...) <-)) caddr ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car
  (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...)
  (env
   ((app
     check-expect
     (->
      (app
       regex-match
       (app cons 'seq (app cons ...))
       (app cons 'foo (app cons ...)))
      <-)
     (app #f)))))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car
  (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...)
  (env
   ((match
     (app null? data)
     ((#f)
      (->
       (app
        regex-match
        (app regex-derivative pattern (app car ...))
        (app cdr data))
       <-))
     _))))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car
  (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...)
  (env ((app f (-> (app cadr re) <-) (app caddr re)))))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car
  (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...)
  (env ((app f (-> (app cadr re) <-) (app caddr re)))))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car
  (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...)
  (env ((app f (-> (app cadr re) <-)))))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car
  (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...)
  (env ((app f (app cadr re) (-> (app caddr re) <-)))))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car
  (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...)
  (env ((app f (app cadr re) (-> (app caddr re) <-)))))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car
  (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...)
  (env ((match (-> (app regex-alt? re) <-) (#f) _))))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car
  (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...)
  (env ((match (-> (app regex-rep? re) <-) (#f) _))))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car
  (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...)
  (env ((match (-> (app regex-rep? re) <-) (#f) _))))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car
  (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...)
  (env ((match (-> (app regex-seq? re) <-) (#f) _))))
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
  (env ((app eq? (-> (app car re) <-) 'alt))))
clos/con:
	'((app
   cons
   (-> 'seq <-)
   (app cons 'foo (app cons (app cons ...) (app nil ...))))
  (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car-c
  (match car-v ((cons car-c car-d) (-> car-c <-)))
  (env ((app eq? (-> (app car re) <-) 'rep))))
clos/con:
	'((app
   cons
   (-> 'seq <-)
   (app cons 'foo (app cons (app cons ...) (app nil ...))))
  (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car-c
  (match car-v ((cons car-c car-d) (-> car-c <-)))
  (env ((app eq? (-> (app car re) <-) 'seq))))
clos/con:
	'((app
   cons
   (-> 'seq <-)
   (app cons 'foo (app cons (app cons ...) (app nil ...))))
  (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car-c
  (match car-v ((cons car-c car-d) (-> car-c <-)))
  (env ((app regex-derivative pattern (-> (app car data) <-)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car-c
  (match car-v ((cons car-c car-d) (-> car-c <-)))
  (env ((λ (p) (-> (app car (app cdr (app cdr ...))) <-)))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car-c
  (match car-v ((cons car-c car-d) (-> car-c <-)))
  (env ((λ (p) (-> (app car (app cdr p)) <-)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car-d
  (match car-v ((cons car-c car-d) (-> car-c <-)))
  (env ((app eq? (-> (app car re) <-) 'alt))))
clos/con:
	'((con
   cons
   (app
    cons
    'seq
    (-> (app cons 'foo (app cons (app cons ...) (app nil ...))) <-)))
  (env ()))
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car-d
  (match car-v ((cons car-c car-d) (-> car-c <-)))
  (env ((app eq? (-> (app car re) <-) 'rep))))
clos/con:
	'((con
   cons
   (app
    cons
    'seq
    (-> (app cons 'foo (app cons (app cons ...) (app nil ...))) <-)))
  (env ()))
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car-d
  (match car-v ((cons car-c car-d) (-> car-c <-)))
  (env ((app eq? (-> (app car re) <-) 'seq))))
clos/con:
	'((con
   cons
   (app
    cons
    'seq
    (-> (app cons 'foo (app cons (app cons ...) (app nil ...))) <-)))
  (env ()))
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car-d
  (match car-v ((cons car-c car-d) (-> car-c <-)))
  (env ((app regex-derivative pattern (-> (app car data) <-)))))
clos/con:
	'((con cons (app cons 'foo (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car-d
  (match car-v ((cons car-c car-d) (-> car-c <-)))
  (env ((λ (p) (-> (app car (app cdr (app cdr ...))) <-)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car-d
  (match car-v ((cons car-c car-d) (-> car-c <-)))
  (env ((λ (p) (-> (app car (app cdr p)) <-)))))
clos/con:
	'((con
   cons
   (app cons 'foo (-> (app cons (app cons 'rep (app cons ...)) (app nil)) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car-v
  (λ (car-v) (-> (match car-v ...) <-))
  (env ((app eq? (-> (app car re) <-) 'alt))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car-v
  (λ (car-v) (-> (match car-v ...) <-))
  (env ((app eq? (-> (app car re) <-) 'rep))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car-v
  (λ (car-v) (-> (match car-v ...) <-))
  (env ((app eq? (-> (app car re) <-) 'seq))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car-v
  (λ (car-v) (-> (match car-v ...) <-))
  (env ((app regex-derivative pattern (-> (app car data) <-)))))
clos/con:
	'((con
   cons
   (app
    regex-match
    (app cons 'seq (app cons 'foo (app cons ...)))
    (-> (app cons 'foo (app cons 'bar (app nil ...))) <-)))
  (env ()))
	'((con cons (app cons 'foo (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car-v
  (λ (car-v) (-> (match car-v ...) <-))
  (env ((λ (p) (-> (app car (app cdr (app cdr ...))) <-)))))
clos/con:
	'((con
   cons
   (app cons 'foo (-> (app cons (app cons 'rep (app cons ...)) (app nil)) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car-v
  (λ (car-v) (-> (match car-v ...) <-))
  (env ((λ (p) (-> (app car (app cdr p)) <-)))))
clos/con:
	'((con
   cons
   (app
    cons
    'seq
    (-> (app cons 'foo (app cons (app cons ...) (app nil ...))) <-)))
  (env ()))
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...)
  (env
   ((app
     check-expect
     (->
      (app
       regex-match
       (app cons 'seq (app cons ...))
       (app cons 'foo (app cons ...)))
      <-)
     (app #f)))))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...)
  (env
   ((match
     (app null? data)
     ((#f)
      (->
       (app
        regex-match
        (app regex-derivative pattern (app car ...))
        (app cdr data))
       <-))
     _))))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...)
  (env ((app f (-> (app cadr re) <-) (app caddr re)))))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...)
  (env ((app f (-> (app cadr re) <-) (app caddr re)))))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...)
  (env ((app f (-> (app cadr re) <-)))))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...)
  (env ((app f (app cadr re) (-> (app caddr re) <-)))))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...)
  (env ((app f (app cadr re) (-> (app caddr re) <-)))))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr-c
  (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-)))
  (env
   ((app
     regex-match
     (app regex-derivative pattern (app car data))
     (-> (app cdr data) <-)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr-c
  (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-)))
  (env ((app car (-> (app cdr (app cdr p)) <-)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr-c
  (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-)))
  (env ((app car (-> (app cdr p) <-)))))
clos/con:
	'((app
   cons
   (-> 'seq <-)
   (app cons 'foo (app cons (app cons ...) (app nil ...))))
  (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr-c
  (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-)))
  (env ((app cdr (-> (app cdr p) <-)))))
clos/con:
	'((app
   cons
   (-> 'seq <-)
   (app cons 'foo (app cons (app cons ...) (app nil ...))))
  (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr-d
  (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-)))
  (env
   ((app
     regex-match
     (app regex-derivative pattern (app car data))
     (-> (app cdr data) <-)))))
clos/con:
	'((con cons (app cons 'foo (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr-d
  (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-)))
  (env ((app car (-> (app cdr (app cdr p)) <-)))))
clos/con:
	'((con
   cons
   (app cons 'foo (-> (app cons (app cons 'rep (app cons ...)) (app nil)) <-)))
  (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr-d
  (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-)))
  (env ((app car (-> (app cdr p) <-)))))
clos/con:
	'((con
   cons
   (app
    cons
    'seq
    (-> (app cons 'foo (app cons (app cons ...) (app nil ...))) <-)))
  (env ()))
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr-d
  (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-)))
  (env ((app cdr (-> (app cdr p) <-)))))
clos/con:
	'((con
   cons
   (app
    cons
    'seq
    (-> (app cons 'foo (app cons (app cons ...) (app nil ...))) <-)))
  (env ()))
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr-v
  (λ (cdr-v) (-> (match cdr-v ...) <-))
  (env
   ((app
     regex-match
     (app regex-derivative pattern (app car data))
     (-> (app cdr data) <-)))))
clos/con:
	'((con
   cons
   (app
    regex-match
    (app cons 'seq (app cons 'foo (app cons ...)))
    (-> (app cons 'foo (app cons 'bar (app nil ...))) <-)))
  (env ()))
	'((con cons (app cons 'foo (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr-v
  (λ (cdr-v) (-> (match cdr-v ...) <-))
  (env ((app car (-> (app cdr (app cdr p)) <-)))))
clos/con:
	'((con
   cons
   (app
    cons
    'seq
    (-> (app cons 'foo (app cons (app cons ...) (app nil ...))) <-)))
  (env ()))
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr-v
  (λ (cdr-v) (-> (match cdr-v ...) <-))
  (env ((app car (-> (app cdr p) <-)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr-v
  (λ (cdr-v) (-> (match cdr-v ...) <-))
  (env ((app cdr (-> (app cdr p) <-)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  check
  (λ (check expect) (-> (app equal? check expect) <-))
  (env
   ((letrec*
     (car ... check-expect)
     (->
      (app
       check-expect
       (app regex-match (app cons ...) (app cons ...))
       (app #f))
      <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  check-expect
  (letrec*
   (... regex-match (check-expect (-> (λ (check expect) ...) <-)) () ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... regex-match (check-expect (-> (λ (check expect) ...) <-)) () ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   'seq
   (-> (app cons 'foo (app cons (app cons ...) (app nil ...))) <-))
  (env ()))
clos/con:
	'((con
   cons
   (app
    cons
    'seq
    (-> (app cons 'foo (app cons (app cons ...) (app nil ...))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app
   cons
   (-> 'seq <-)
   (app cons 'foo (app cons (app cons ...) (app nil ...))))
  (env ()))
clos/con:
	'((app
   cons
   (-> 'seq <-)
   (app cons 'foo (app cons (app cons ...) (app nil ...))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons 'alt (-> (app cons pat1 (app cons pat2 (app nil ...))) <-))
  (env
   ((λ (pat1 pat2)
      (->
       (app
        alt
        (app seq (app regex-derivative ...) pat2)
        (app seq (app regex-empty ...) (app regex-derivative ...)))
       <-)))))
clos/con:
	'((con
   cons
   (app cons 'alt (-> (app cons pat1 (app cons pat2 (app nil ...))) <-)))
  (env
   ((λ (pat1 pat2)
      (->
       (app
        alt
        (app seq (app regex-derivative ...) pat2)
        (app seq (app regex-empty ...) (app regex-derivative ...)))
       <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons 'alt (-> (app cons pat1 (app cons pat2 (app nil ...))) <-))
  (env
   ((λ (pat1 pat2)
      (->
       (app alt (app regex-derivative pat1 c) (app regex-derivative pat2 c))
       <-)))))
clos/con:
	'((con
   cons
   (app cons 'alt (-> (app cons pat1 (app cons pat2 (app nil ...))) <-)))
  (env
   ((λ (pat1 pat2)
      (->
       (app alt (app regex-derivative pat1 c) (app regex-derivative pat2 c))
       <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons 'alt (-> (app cons pat1 (app cons pat2 (app nil ...))) <-))
  (env
   ((λ (pat1 pat2)
      (-> (app alt (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con
   cons
   (app cons 'alt (-> (app cons pat1 (app cons pat2 (app nil ...))) <-)))
  (env
   ((λ (pat1 pat2)
      (-> (app alt (app regex-empty pat1) (app regex-empty pat2)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons 'foo (-> (app cons (app cons 'rep (app cons ...)) (app nil)) <-))
  (env ()))
clos/con:
	'((con
   cons
   (app cons 'foo (-> (app cons (app cons 'rep (app cons ...)) (app nil)) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons 'rep (-> (app cons pat (app nil)) <-))
  (env ((app seq (app regex-derivative pat c) (-> (app rep pat) <-)))))
clos/con:
	'((con cons (app cons 'rep (-> (app cons pat (app nil)) <-)))
  (env ((app seq (app regex-derivative pat c) (-> (app rep pat) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil ...))) <-))
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
clos/con:
	'((con
   cons
   (app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil ...))) <-)))
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil ...))) <-))
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
clos/con:
	'((con
   cons
   (app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil ...))) <-)))
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil ...))) <-))
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
clos/con:
	'((con
   cons
   (app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil ...))) <-)))
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil ...))) <-))
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con
   cons
   (app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil ...))) <-)))
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil ...))))
  (env
   ((λ (pat1 pat2)
      (->
       (app
        alt
        (app seq (app regex-derivative ...) pat2)
        (app seq (app regex-empty ...) (app regex-derivative ...)))
       <-)))))
clos/con:
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil ...))))
  (env
   ((λ (pat1 pat2)
      (->
       (app
        alt
        (app seq (app regex-derivative ...) pat2)
        (app seq (app regex-empty ...) (app regex-derivative ...)))
       <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil ...))))
  (env
   ((λ (pat1 pat2)
      (->
       (app alt (app regex-derivative pat1 c) (app regex-derivative pat2 c))
       <-)))))
clos/con:
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil ...))))
  (env
   ((λ (pat1 pat2)
      (->
       (app alt (app regex-derivative pat1 c) (app regex-derivative pat2 c))
       <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil ...))))
  (env
   ((λ (pat1 pat2)
      (-> (app alt (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil ...))))
  (env
   ((λ (pat1 pat2)
      (-> (app alt (app regex-empty pat1) (app regex-empty pat2)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
clos/con:
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> 'rep <-) (app cons pat (app nil)))
  (env ((app seq (app regex-derivative pat c) (-> (app rep pat) <-)))))
clos/con:
	'((app cons (-> 'rep <-) (app cons pat (app nil)))
  (env ((app seq (app regex-derivative pat c) (-> (app rep pat) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil ...))))
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
clos/con:
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil ...))))
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil ...))))
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
clos/con:
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil ...))))
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil ...))))
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
clos/con:
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil ...))))
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil ...))))
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil ...))))
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> pat <-) (app nil))
  (env ((app seq (app regex-derivative pat c) (-> (app rep pat) <-)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> pat1 <-) (app cons pat2 (app nil)))
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> pat1 <-) (app cons pat2 (app nil)))
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> pat1 <-) (app cons pat2 (app nil)))
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> pat1 <-) (app cons pat2 (app nil)))
  (env
   ((λ (pat1 pat2)
      (->
       (app
        alt
        (app seq (app regex-derivative ...) pat2)
        (app seq (app regex-empty ...) (app regex-derivative ...)))
       <-)))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> pat1 <-) (app cons pat2 (app nil)))
  (env
   ((λ (pat1 pat2)
      (->
       (app alt (app regex-derivative pat1 c) (app regex-derivative pat2 c))
       <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> pat1 <-) (app cons pat2 (app nil)))
  (env
   ((λ (pat1 pat2)
      (-> (app alt (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> pat1 <-) (app cons pat2 (app nil)))
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> pat2 <-) (app nil))
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> pat2 <-) (app nil))
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> pat2 <-) (app nil))
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
clos/con:
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil ...))) <-))
    _))
  (env ((app seq (app regex-derivative pat c) (-> (app rep pat) <-)))))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> pat2 <-) (app nil))
  (env
   ((λ (pat1 pat2)
      (->
       (app
        alt
        (app seq (app regex-derivative ...) pat2)
        (app seq (app regex-empty ...) (app regex-derivative ...)))
       <-)))))
clos/con:
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> pat2 <-) (app nil))
  (env
   ((λ (pat1 pat2)
      (->
       (app alt (app regex-derivative pat1 c) (app regex-derivative pat2 c))
       <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> pat2 <-) (app nil))
  (env
   ((λ (pat1 pat2)
      (-> (app alt (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (-> pat2 <-) (app nil))
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons (app cons 'rep (app cons 'bar (app nil ...))) (-> (app nil) <-))
  (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons pat (-> (app nil) <-))
  (env ((app seq (app regex-derivative pat c) (-> (app rep pat) <-)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons pat1 (-> (app cons pat2 (app nil)) <-))
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
clos/con:
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-)))
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons pat1 (-> (app cons pat2 (app nil)) <-))
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
clos/con:
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-)))
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons pat1 (-> (app cons pat2 (app nil)) <-))
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
clos/con:
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-)))
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons pat1 (-> (app cons pat2 (app nil)) <-))
  (env
   ((λ (pat1 pat2)
      (->
       (app
        alt
        (app seq (app regex-derivative ...) pat2)
        (app seq (app regex-empty ...) (app regex-derivative ...)))
       <-)))))
clos/con:
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-)))
  (env
   ((λ (pat1 pat2)
      (->
       (app
        alt
        (app seq (app regex-derivative ...) pat2)
        (app seq (app regex-empty ...) (app regex-derivative ...)))
       <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons pat1 (-> (app cons pat2 (app nil)) <-))
  (env
   ((λ (pat1 pat2)
      (->
       (app alt (app regex-derivative pat1 c) (app regex-derivative pat2 c))
       <-)))))
clos/con:
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-)))
  (env
   ((λ (pat1 pat2)
      (->
       (app alt (app regex-derivative pat1 c) (app regex-derivative pat2 c))
       <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons pat1 (-> (app cons pat2 (app nil)) <-))
  (env
   ((λ (pat1 pat2)
      (-> (app alt (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-)))
  (env
   ((λ (pat1 pat2)
      (-> (app alt (app regex-empty pat1) (app regex-empty pat2)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons pat1 (-> (app cons pat2 (app nil)) <-))
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con cons (app cons pat1 (-> (app cons pat2 (app nil)) <-)))
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons pat2 (-> (app nil) <-))
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons pat2 (-> (app nil) <-))
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons pat2 (-> (app nil) <-))
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons pat2 (-> (app nil) <-))
  (env
   ((λ (pat1 pat2)
      (->
       (app
        alt
        (app seq (app regex-derivative ...) pat2)
        (app seq (app regex-empty ...) (app regex-derivative ...)))
       <-)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons pat2 (-> (app nil) <-))
  (env
   ((λ (pat1 pat2)
      (->
       (app alt (app regex-derivative pat1 c) (app regex-derivative pat2 c))
       <-)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons pat2 (-> (app nil) <-))
  (env
   ((λ (pat1 pat2)
      (-> (app alt (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  con
  (app cons pat2 (-> (app nil) <-))
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  data
  (λ (pattern data) (-> (match (app null? data) ...) <-))
  (env
   ((app
     check-expect
     (->
      (app
       regex-match
       (app cons 'seq (app cons ...))
       (app cons 'foo (app cons ...)))
      <-)
     (app #f)))))
clos/con:
	'((con
   cons
   (app
    regex-match
    (app cons 'seq (app cons 'foo (app cons ...)))
    (-> (app cons 'foo (app cons 'bar (app nil ...))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  data
  (λ (pattern data) (-> (match (app null? data) ...) <-))
  (env
   ((match
     (app null? data)
     ((#f)
      (->
       (app
        regex-match
        (app regex-derivative pattern (app car ...))
        (app cdr data))
       <-))
     _))))
clos/con:
	'((con cons (app cons 'foo (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  debug-trace
  (letrec* (... null? (debug-trace (-> (λ () ...) <-)) cadr ...) ...)
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((letrec* (... null? (debug-trace (-> (λ () ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  debug-trace
  (letrec* (... null? (debug-trace (-> (λ () ...) <-)) cadr ...) ...)
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((letrec* (... null? (debug-trace (-> (λ () ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  debug-trace
  (letrec* (... null? (debug-trace (-> (λ () ...) <-)) cadr ...) ...)
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((letrec* (... null? (debug-trace (-> (λ () ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  debug-trace
  (letrec* (... null? (debug-trace (-> (λ () ...) <-)) cadr ...) ...)
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((letrec* (... null? (debug-trace (-> (λ () ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  debug-trace
  (letrec* (... null? (debug-trace (-> (λ () ...) <-)) cadr ...) ...)
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((letrec* (... null? (debug-trace (-> (λ () ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  debug-trace
  (letrec* (... null? (debug-trace (-> (λ () ...) <-)) cadr ...) ...)
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((letrec* (... null? (debug-trace (-> (λ () ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  debug-trace
  (letrec* (... null? (debug-trace (-> (λ () ...) <-)) cadr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... null? (debug-trace (-> (λ () ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  expect
  (λ (check expect) (-> (app equal? check expect) <-))
  (env
   ((letrec*
     (car ... check-expect)
     (->
      (app
       check-expect
       (app regex-match (app cons ...) (app cons ...))
       (app #f))
      <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  f
  (λ (re f) (-> (match (app regex-alt? re) ...) <-))
  (env ((match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((app match-alt re (-> (λ (pat1 pat2) ...) <-))
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
	'((app match-alt re (-> (λ (pat1 pat2) ...) <-))
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
	'((app match-alt re (-> (λ (pat1 pat2) ...) <-))
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
	'((app match-alt re (-> (λ (pat1 pat2) ...) <-))
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
	'((app match-alt re (-> (λ (pat1 pat2) ...) <-))
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
	'((app match-alt re (-> (λ (pat1 pat2) ...) <-))
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
literals: '(⊥ ⊥ ⊥)

'(store:
  f
  (λ (re f) (-> (match (app regex-alt? re) ...) <-))
  (env ((match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((app match-alt re (-> (λ (pat1 pat2) ...) <-))
  (env
   ((app seq (-> (app regex-empty pat1) <-) (app regex-derivative pat2 c)))))
	'((app match-alt re (-> (λ (pat1 pat2) ...) <-))
  (env ((app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
	'((app match-alt re (-> (λ (pat1 pat2) ...) <-))
  (env ((app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
	'((app match-alt re (-> (λ (pat1 pat2) ...) <-))
  (env ((app regex-empty? (-> (app regex-empty pattern) <-)))))
	'((app match-alt re (-> (λ (pat1 pat2) ...) <-))
  (env ((app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
	'((app match-alt re (-> (λ (pat1 pat2) ...) <-))
  (env ((app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  f
  (λ (re f) (-> (match (app regex-rep? re) ...) <-))
  (env ((match (-> (app match-rep re (λ (pat) ...)) <-) (#f) c-x))))
clos/con:
	'((app match-rep re (-> (λ (pat) ...) <-))
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
	'((app match-rep re (-> (λ (pat) ...) <-))
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
	'((app match-rep re (-> (λ (pat) ...) <-))
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
	'((app match-rep re (-> (λ (pat) ...) <-))
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
	'((app match-rep re (-> (λ (pat) ...) <-))
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
	'((app match-rep re (-> (λ (pat) ...) <-))
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
literals: '(⊥ ⊥ ⊥)

'(store:
  f
  (λ (re f) (-> (match (app regex-seq? re) ...) <-))
  (env ((match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((app match-seq re (-> (λ (pat1 pat2) ...) <-))
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
	'((app match-seq re (-> (λ (pat1 pat2) ...) <-))
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
	'((app match-seq re (-> (λ (pat1 pat2) ...) <-))
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
	'((app match-seq re (-> (λ (pat1 pat2) ...) <-))
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
	'((app match-seq re (-> (λ (pat1 pat2) ...) <-))
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
	'((app match-seq re (-> (λ (pat1 pat2) ...) <-))
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
literals: '(⊥ ⊥ ⊥)

'(store:
  f
  (λ (re f) (-> (match (app regex-seq? re) ...) <-))
  (env ((match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((app match-seq re (-> (λ (pat1 pat2) ...) <-))
  (env
   ((app seq (-> (app regex-empty pat1) <-) (app regex-derivative pat2 c)))))
	'((app match-seq re (-> (λ (pat1 pat2) ...) <-))
  (env ((app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
	'((app match-seq re (-> (λ (pat1 pat2) ...) <-))
  (env ((app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
	'((app match-seq re (-> (λ (pat1 pat2) ...) <-))
  (env ((app regex-empty? (-> (app regex-empty pattern) <-)))))
	'((app match-seq re (-> (λ (pat1 pat2) ...) <-))
  (env ((app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
	'((app match-seq re (-> (λ (pat1 pat2) ...) <-))
  (env ((app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
literals: '(⊥ ⊥ ⊥)

'(store:
  match-alt
  (letrec*
   (... match-seq (match-alt (-> (λ (re f) ...) <-)) match-rep ...)
   ...)
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((letrec*
   (... match-seq (match-alt (-> (λ (re f) ...) <-)) match-rep ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  match-alt
  (letrec*
   (... match-seq (match-alt (-> (λ (re f) ...) <-)) match-rep ...)
   ...)
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((letrec*
   (... match-seq (match-alt (-> (λ (re f) ...) <-)) match-rep ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  match-alt
  (letrec*
   (... match-seq (match-alt (-> (λ (re f) ...) <-)) match-rep ...)
   ...)
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((letrec*
   (... match-seq (match-alt (-> (λ (re f) ...) <-)) match-rep ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  match-alt
  (letrec*
   (... match-seq (match-alt (-> (λ (re f) ...) <-)) match-rep ...)
   ...)
  (env
   ((app seq (-> (app regex-empty pat1) <-) (app regex-derivative pat2 c)))))
clos/con:
	'((letrec*
   (... match-seq (match-alt (-> (λ (re f) ...) <-)) match-rep ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  match-alt
  (letrec*
   (... match-seq (match-alt (-> (λ (re f) ...) <-)) match-rep ...)
   ...)
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((letrec*
   (... match-seq (match-alt (-> (λ (re f) ...) <-)) match-rep ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  match-alt
  (letrec*
   (... match-seq (match-alt (-> (λ (re f) ...) <-)) match-rep ...)
   ...)
  (env ((app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((letrec*
   (... match-seq (match-alt (-> (λ (re f) ...) <-)) match-rep ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  match-alt
  (letrec*
   (... match-seq (match-alt (-> (λ (re f) ...) <-)) match-rep ...)
   ...)
  (env ((app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((letrec*
   (... match-seq (match-alt (-> (λ (re f) ...) <-)) match-rep ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  match-alt
  (letrec*
   (... match-seq (match-alt (-> (λ (re f) ...) <-)) match-rep ...)
   ...)
  (env ((app regex-empty? (-> (app regex-empty pattern) <-)))))
clos/con:
	'((letrec*
   (... match-seq (match-alt (-> (λ (re f) ...) <-)) match-rep ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  match-alt
  (letrec*
   (... match-seq (match-alt (-> (λ (re f) ...) <-)) match-rep ...)
   ...)
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((letrec*
   (... match-seq (match-alt (-> (λ (re f) ...) <-)) match-rep ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  match-alt
  (letrec*
   (... match-seq (match-alt (-> (λ (re f) ...) <-)) match-rep ...)
   ...)
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((letrec*
   (... match-seq (match-alt (-> (λ (re f) ...) <-)) match-rep ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  match-alt
  (letrec*
   (... match-seq (match-alt (-> (λ (re f) ...) <-)) match-rep ...)
   ...)
  (env ((app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((letrec*
   (... match-seq (match-alt (-> (λ (re f) ...) <-)) match-rep ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  match-alt
  (letrec*
   (... match-seq (match-alt (-> (λ (re f) ...) <-)) match-rep ...)
   ...)
  (env ((app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((letrec*
   (... match-seq (match-alt (-> (λ (re f) ...) <-)) match-rep ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  match-alt
  (letrec*
   (... match-seq (match-alt (-> (λ (re f) ...) <-)) match-rep ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... match-seq (match-alt (-> (λ (re f) ...) <-)) match-rep ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  match-rep
  (letrec* (... match-alt (match-rep (-> (λ (re f) ...) <-)) seq ...) ...)
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((letrec* (... match-alt (match-rep (-> (λ (re f) ...) <-)) seq ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  match-rep
  (letrec* (... match-alt (match-rep (-> (λ (re f) ...) <-)) seq ...) ...)
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((letrec* (... match-alt (match-rep (-> (λ (re f) ...) <-)) seq ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  match-rep
  (letrec* (... match-alt (match-rep (-> (λ (re f) ...) <-)) seq ...) ...)
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((letrec* (... match-alt (match-rep (-> (λ (re f) ...) <-)) seq ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  match-rep
  (letrec* (... match-alt (match-rep (-> (λ (re f) ...) <-)) seq ...) ...)
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((letrec* (... match-alt (match-rep (-> (λ (re f) ...) <-)) seq ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  match-rep
  (letrec* (... match-alt (match-rep (-> (λ (re f) ...) <-)) seq ...) ...)
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((letrec* (... match-alt (match-rep (-> (λ (re f) ...) <-)) seq ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  match-rep
  (letrec* (... match-alt (match-rep (-> (λ (re f) ...) <-)) seq ...) ...)
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((letrec* (... match-alt (match-rep (-> (λ (re f) ...) <-)) seq ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  match-rep
  (letrec* (... match-alt (match-rep (-> (λ (re f) ...) <-)) seq ...) ...)
  (env ()))
clos/con:
	'((letrec* (... match-alt (match-rep (-> (λ (re f) ...) <-)) seq ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  match-seq
  (letrec*
   (... regex-atom? (match-seq (-> (λ (re f) ...) <-)) match-alt ...)
   ...)
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((letrec*
   (... regex-atom? (match-seq (-> (λ (re f) ...) <-)) match-alt ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  match-seq
  (letrec*
   (... regex-atom? (match-seq (-> (λ (re f) ...) <-)) match-alt ...)
   ...)
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((letrec*
   (... regex-atom? (match-seq (-> (λ (re f) ...) <-)) match-alt ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  match-seq
  (letrec*
   (... regex-atom? (match-seq (-> (λ (re f) ...) <-)) match-alt ...)
   ...)
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((letrec*
   (... regex-atom? (match-seq (-> (λ (re f) ...) <-)) match-alt ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  match-seq
  (letrec*
   (... regex-atom? (match-seq (-> (λ (re f) ...) <-)) match-alt ...)
   ...)
  (env
   ((app seq (-> (app regex-empty pat1) <-) (app regex-derivative pat2 c)))))
clos/con:
	'((letrec*
   (... regex-atom? (match-seq (-> (λ (re f) ...) <-)) match-alt ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  match-seq
  (letrec*
   (... regex-atom? (match-seq (-> (λ (re f) ...) <-)) match-alt ...)
   ...)
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((letrec*
   (... regex-atom? (match-seq (-> (λ (re f) ...) <-)) match-alt ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  match-seq
  (letrec*
   (... regex-atom? (match-seq (-> (λ (re f) ...) <-)) match-alt ...)
   ...)
  (env ((app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((letrec*
   (... regex-atom? (match-seq (-> (λ (re f) ...) <-)) match-alt ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  match-seq
  (letrec*
   (... regex-atom? (match-seq (-> (λ (re f) ...) <-)) match-alt ...)
   ...)
  (env ((app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((letrec*
   (... regex-atom? (match-seq (-> (λ (re f) ...) <-)) match-alt ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  match-seq
  (letrec*
   (... regex-atom? (match-seq (-> (λ (re f) ...) <-)) match-alt ...)
   ...)
  (env ((app regex-empty? (-> (app regex-empty pattern) <-)))))
clos/con:
	'((letrec*
   (... regex-atom? (match-seq (-> (λ (re f) ...) <-)) match-alt ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  match-seq
  (letrec*
   (... regex-atom? (match-seq (-> (λ (re f) ...) <-)) match-alt ...)
   ...)
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((letrec*
   (... regex-atom? (match-seq (-> (λ (re f) ...) <-)) match-alt ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  match-seq
  (letrec*
   (... regex-atom? (match-seq (-> (λ (re f) ...) <-)) match-alt ...)
   ...)
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((letrec*
   (... regex-atom? (match-seq (-> (λ (re f) ...) <-)) match-alt ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  match-seq
  (letrec*
   (... regex-atom? (match-seq (-> (λ (re f) ...) <-)) match-alt ...)
   ...)
  (env ((app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((letrec*
   (... regex-atom? (match-seq (-> (λ (re f) ...) <-)) match-alt ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  match-seq
  (letrec*
   (... regex-atom? (match-seq (-> (λ (re f) ...) <-)) match-alt ...)
   ...)
  (env ((app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((letrec*
   (... regex-atom? (match-seq (-> (λ (re f) ...) <-)) match-alt ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  match-seq
  (letrec*
   (... regex-atom? (match-seq (-> (λ (re f) ...) <-)) match-alt ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... regex-atom? (match-seq (-> (λ (re f) ...) <-)) match-alt ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  null?
  (letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) debug-trace ...) ...)
  (env
   ((app
     check-expect
     (->
      (app
       regex-match
       (app cons 'seq (app cons ...))
       (app cons 'foo (app cons ...)))
      <-)
     (app #f)))))
clos/con:
	'((letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) debug-trace ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  null?
  (letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) debug-trace ...) ...)
  (env
   ((match
     (app null? data)
     ((#f)
      (->
       (app
        regex-match
        (app regex-derivative pattern (app car ...))
        (app cdr data))
       <-))
     _))))
clos/con:
	'((letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) debug-trace ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  null?
  (letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) debug-trace ...) ...)
  (env ()))
clos/con:
	'((letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) debug-trace ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  null?-v
  (λ (null?-v) (-> (match null?-v ...) <-))
  (env ((match (-> (app null? data) <-) (#f) _))))
clos/con:
	'((con
   cons
   (app
    regex-match
    (app cons 'seq (app cons 'foo (app cons ...)))
    (-> (app cons 'foo (app cons 'bar (app nil ...))) <-)))
  (env ()))
	'((con cons (app cons 'foo (-> (app cons 'bar (app nil)) <-))) (env ()))
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  p
  (λ (p) (-> (app car (app cdr (app cdr ...))) <-))
  (env ((app f (app cadr re) (-> (app caddr re) <-)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  p
  (λ (p) (-> (app car (app cdr (app cdr ...))) <-))
  (env ((app f (app cadr re) (-> (app caddr re) <-)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  p
  (λ (p) (-> (app car (app cdr p)) <-))
  (env ((app f (-> (app cadr re) <-) (app caddr re)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  p
  (λ (p) (-> (app car (app cdr p)) <-))
  (env ((app f (-> (app cadr re) <-) (app caddr re)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  p
  (λ (p) (-> (app car (app cdr p)) <-))
  (env ((app f (-> (app cadr re) <-)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pair?
  (letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...)
  (env ((match (-> (app regex-alt? re) <-) (#f) _))))
clos/con:
	'((letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pair?
  (letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...)
  (env ((match (-> (app regex-rep? re) <-) (#f) _))))
clos/con:
	'((letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pair?
  (letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...)
  (env ((match (-> (app regex-rep? re) <-) (#f) _))))
clos/con:
	'((letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pair?
  (letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...)
  (env ((match (-> (app regex-seq? re) <-) (#f) _))))
clos/con:
	'((letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pair?
  (letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pair?-c
  (match pair?-v ((cons pair?-c pair?-d) (-> (app #t) <-)) _)
  (env ((match (-> (app pair? re) <-) (#f) _))))
clos/con:
	'((app
   cons
   (-> 'seq <-)
   (app cons 'foo (app cons (app cons ...) (app nil ...))))
  (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pair?-c
  (match pair?-v ((cons pair?-c pair?-d) (-> (app #t) <-)) _)
  (env ((match (-> (app pair? re) <-) (#f) _))))
clos/con:
	'((app
   cons
   (-> 'seq <-)
   (app cons 'foo (app cons (app cons ...) (app nil ...))))
  (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pair?-c
  (match pair?-v ((cons pair?-c pair?-d) (-> (app #t) <-)) _)
  (env ((match (-> (app pair? re) <-) (#f) _))))
clos/con:
	'((app
   cons
   (-> 'seq <-)
   (app cons 'foo (app cons (app cons ...) (app nil ...))))
  (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pair?-d
  (match pair?-v ((cons pair?-c pair?-d) (-> (app #t) <-)) _)
  (env ((match (-> (app pair? re) <-) (#f) _))))
clos/con:
	'((con
   cons
   (app
    cons
    'seq
    (-> (app cons 'foo (app cons (app cons ...) (app nil ...))) <-)))
  (env ()))
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pair?-d
  (match pair?-v ((cons pair?-c pair?-d) (-> (app #t) <-)) _)
  (env ((match (-> (app pair? re) <-) (#f) _))))
clos/con:
	'((con
   cons
   (app
    cons
    'seq
    (-> (app cons 'foo (app cons (app cons ...) (app nil ...))) <-)))
  (env ()))
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pair?-d
  (match pair?-v ((cons pair?-c pair?-d) (-> (app #t) <-)) _)
  (env ((match (-> (app pair? re) <-) (#f) _))))
clos/con:
	'((con
   cons
   (app
    cons
    'seq
    (-> (app cons 'foo (app cons (app cons ...) (app nil ...))) <-)))
  (env ()))
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pair?-v
  (λ (pair?-v) (-> (match pair?-v ...) <-))
  (env ((match (-> (app pair? re) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pair?-v
  (λ (pair?-v) (-> (match pair?-v ...) <-))
  (env ((match (-> (app pair? re) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pair?-v
  (λ (pair?-v) (-> (match pair?-v ...) <-))
  (env ((match (-> (app pair? re) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pat
  (λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-))
  (env ((match (-> (app f (app cadr re)) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pat
  (λ (pat) (-> (match (app regex-null? pat) ...) <-))
  (env ((app seq (app regex-derivative pat c) (-> (app rep pat) <-)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pat1
  (λ (pat1 pat2)
    (->
     (app
      alt
      (app seq (app regex-derivative ...) pat2)
      (app seq (app regex-empty ...) (app regex-derivative ...)))
     <-))
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pat1
  (λ (pat1 pat2)
    (->
     (app alt (app regex-derivative pat1 c) (app regex-derivative pat2 c))
     <-))
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pat1
  (λ (pat1 pat2)
    (-> (app alt (app regex-empty pat1) (app regex-empty pat2)) <-))
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pat1
  (λ (pat1 pat2)
    (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-))
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pat1
  (λ (pat1 pat2) (-> (match (app regex-null? pat1) ...) <-))
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pat1
  (λ (pat1 pat2) (-> (match (app regex-null? pat1) ...) <-))
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pat1
  (λ (pat1 pat2) (-> (match (app regex-null? pat1) ...) <-))
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pat1
  (λ (pat1 pat2) (-> (match (app regex-null? pat1) ...) <-))
  (env
   ((λ (pat1 pat2)
      (->
       (app
        alt
        (app seq (app regex-derivative ...) pat2)
        (app seq (app regex-empty ...) (app regex-derivative ...)))
       <-)))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pat1
  (λ (pat1 pat2) (-> (match (app regex-null? pat1) ...) <-))
  (env
   ((λ (pat1 pat2)
      (->
       (app alt (app regex-derivative pat1 c) (app regex-derivative pat2 c))
       <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pat1
  (λ (pat1 pat2) (-> (match (app regex-null? pat1) ...) <-))
  (env
   ((λ (pat1 pat2)
      (-> (app alt (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pat1
  (λ (pat1 pat2) (-> (match (app regex-null? pat1) ...) <-))
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pat2
  (λ (pat1 pat2)
    (->
     (app
      alt
      (app seq (app regex-derivative ...) pat2)
      (app seq (app regex-empty ...) (app regex-derivative ...)))
     <-))
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pat2
  (λ (pat1 pat2)
    (->
     (app alt (app regex-derivative pat1 c) (app regex-derivative pat2 c))
     <-))
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pat2
  (λ (pat1 pat2)
    (-> (app alt (app regex-empty pat1) (app regex-empty pat2)) <-))
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pat2
  (λ (pat1 pat2)
    (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-))
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pat2
  (λ (pat1 pat2) (-> (match (app regex-null? pat1) ...) <-))
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pat2
  (λ (pat1 pat2) (-> (match (app regex-null? pat1) ...) <-))
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pat2
  (λ (pat1 pat2) (-> (match (app regex-null? pat1) ...) <-))
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
clos/con:
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil ...))) <-))
    _))
  (env ((app seq (app regex-derivative pat c) (-> (app rep pat) <-)))))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pat2
  (λ (pat1 pat2) (-> (match (app regex-null? pat1) ...) <-))
  (env
   ((λ (pat1 pat2)
      (->
       (app
        alt
        (app seq (app regex-derivative ...) pat2)
        (app seq (app regex-empty ...) (app regex-derivative ...)))
       <-)))))
clos/con:
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pat2
  (λ (pat1 pat2) (-> (match (app regex-null? pat1) ...) <-))
  (env
   ((λ (pat1 pat2)
      (->
       (app alt (app regex-derivative pat1 c) (app regex-derivative pat2 c))
       <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pat2
  (λ (pat1 pat2) (-> (match (app regex-null? pat1) ...) <-))
  (env
   ((λ (pat1 pat2)
      (-> (app alt (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pat2
  (λ (pat1 pat2) (-> (match (app regex-null? pat1) ...) <-))
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pattern
  (λ (pattern data) (-> (match (app null? data) ...) <-))
  (env
   ((app
     check-expect
     (->
      (app
       regex-match
       (app cons 'seq (app cons ...))
       (app cons 'foo (app cons ...)))
      <-)
     (app #f)))))
clos/con:
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pattern
  (λ (pattern data) (-> (match (app null? data) ...) <-))
  (env
   ((match
     (app null? data)
     ((#f)
      (->
       (app
        regex-match
        (app regex-derivative pattern (app car ...))
        (app cdr data))
       <-))
     _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  re
  (λ (re c) (-> (let (_) ...) <-))
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  re
  (λ (re c) (-> (let (_) ...) <-))
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  re
  (λ (re c) (-> (let (_) ...) <-))
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  re
  (λ (re c) (-> (let (_) ...) <-))
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  re
  (λ (re c) (-> (let (_) ...) <-))
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  re
  (λ (re c) (-> (let (_) ...) <-))
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  re
  (λ (re f) (-> (match (app regex-alt? re) ...) <-))
  (env ((match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  re
  (λ (re f) (-> (match (app regex-alt? re) ...) <-))
  (env ((match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  re
  (λ (re f) (-> (match (app regex-rep? re) ...) <-))
  (env ((match (-> (app match-rep re (λ (pat) ...)) <-) (#f) c-x))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  re
  (λ (re f) (-> (match (app regex-seq? re) ...) <-))
  (env ((match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  re
  (λ (re f) (-> (match (app regex-seq? re) ...) <-))
  (env ((match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  re
  (λ (re) (-> (app eq? re (app #f)) <-))
  (env ((match (-> (app regex-null? pat) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  re
  (λ (re) (-> (app eq? re (app #f)) <-))
  (env ((match (-> (app regex-null? pat1) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  re
  (λ (re) (-> (app eq? re (app #f)) <-))
  (env ((match (-> (app regex-null? pat1) <-) (#f) _))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  re
  (λ (re) (-> (app eq? re (app #f)) <-))
  (env ((match (-> (app regex-null? pat2) <-) (#f) _))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil ...))) <-))
    _))
  (env ((app seq (app regex-derivative pat c) (-> (app rep pat) <-)))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  re
  (λ (re) (-> (app eq? re (app #f)) <-))
  (env ((match (-> (app regex-null? pat2) <-) (#f) _))))
clos/con:
	'((con
   cons
   (match
    (app regex-empty? pat2)
    ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
    _))
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  re
  (λ (re) (-> (app eq? re (app #f)) <-))
  (env ((match (-> (app regex-null? re) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  re
  (λ (re) (-> (app eq? re (app #f)) <-))
  (env ((match (-> (app regex-null? re) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  re
  (λ (re) (-> (app eq? re (app #t)) <-))
  (env
   ((match
     (app null? data)
     (#f)
     (_ (-> (app regex-empty? (app regex-empty pattern)) <-))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  re
  (λ (re) (-> (app eq? re (app #t)) <-))
  (env ((match (-> (app regex-empty? pat) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  re
  (λ (re) (-> (app eq? re (app #t)) <-))
  (env ((match (-> (app regex-empty? pat1) <-) (#f) _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  re
  (λ (re) (-> (app eq? re (app #t)) <-))
  (env ((match (-> (app regex-empty? pat2) <-) (#f) _))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con
   cons
   (match
    (app regex-empty? pat)
    ((#f) (-> (app cons 'rep (app cons pat (app nil ...))) <-))
    _))
  (env ((app seq (app regex-derivative pat c) (-> (app rep pat) <-)))))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  re
  (λ (re) (-> (app eq? re (app #t)) <-))
  (env ((match (-> (app regex-empty? re) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  re
  (λ (re) (-> (app eq? re (app #t)) <-))
  (env ((match (-> (app regex-empty? re) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  re
  (λ (re) (-> (match (app char? re) ...) <-))
  (env ((match (-> (app regex-atom? re) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  re
  (λ (re) (-> (match (app char? re) ...) <-))
  (env ((match (-> (app regex-atom? re) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  re
  (λ (re) (-> (match (app pair? re) ...) <-))
  (env ((match (-> (app regex-alt? re) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  re
  (λ (re) (-> (match (app pair? re) ...) <-))
  (env ((match (-> (app regex-rep? re) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  re
  (λ (re) (-> (match (app pair? re) ...) <-))
  (env ((match (-> (app regex-rep? re) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  re
  (λ (re) (-> (match (app pair? re) ...) <-))
  (env ((match (-> (app regex-seq? re) <-) (#f) _))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  re
  (λ (re) (-> (match (app regex-empty? re) ...) <-))
  (env
   ((app seq (-> (app regex-empty pat1) <-) (app regex-derivative pat2 c)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  re
  (λ (re) (-> (match (app regex-empty? re) ...) <-))
  (env ((app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  re
  (λ (re) (-> (match (app regex-empty? re) ...) <-))
  (env ((app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  re
  (λ (re) (-> (match (app regex-empty? re) ...) <-))
  (env ((app regex-empty? (-> (app regex-empty pattern) <-)))))
clos/con:
	'((con
   cons
   (app
    regex-match
    (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
    (app cons 'foo (app cons 'bar (app nil ...)))))
  (env ()))
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  re
  (λ (re) (-> (match (app regex-empty? re) ...) <-))
  (env ((app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  re
  (λ (re) (-> (match (app regex-empty? re) ...) <-))
  (env ((app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((con
   cons
   (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-BLANK
  (letrec* (... regex-NULL (regex-BLANK (-> (app #t) <-)) regex-alt? ...) ...)
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-BLANK
  (letrec* (... regex-NULL (regex-BLANK (-> (app #t) <-)) regex-alt? ...) ...)
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-BLANK
  (letrec* (... regex-NULL (regex-BLANK (-> (app #t) <-)) regex-alt? ...) ...)
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-BLANK
  (letrec* (... regex-NULL (regex-BLANK (-> (app #t) <-)) regex-alt? ...) ...)
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-BLANK
  (letrec* (... regex-NULL (regex-BLANK (-> (app #t) <-)) regex-alt? ...) ...)
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-BLANK
  (letrec* (... regex-NULL (regex-BLANK (-> (app #t) <-)) regex-alt? ...) ...)
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-BLANK
  (letrec* (... regex-NULL (regex-BLANK (-> (app #t) <-)) regex-alt? ...) ...)
  (env ((app seq (app regex-derivative pat c) (-> (app rep pat) <-)))))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-BLANK
  (letrec* (... regex-NULL (regex-BLANK (-> (app #t) <-)) regex-alt? ...) ...)
  (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-NULL
  (letrec* (... caddr (regex-NULL (-> (app #f) <-)) regex-BLANK ...) ...)
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-NULL
  (letrec* (... caddr (regex-NULL (-> (app #f) <-)) regex-BLANK ...) ...)
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-NULL
  (letrec* (... caddr (regex-NULL (-> (app #f) <-)) regex-BLANK ...) ...)
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-NULL
  (letrec* (... caddr (regex-NULL (-> (app #f) <-)) regex-BLANK ...) ...)
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-NULL
  (letrec* (... caddr (regex-NULL (-> (app #f) <-)) regex-BLANK ...) ...)
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-NULL
  (letrec* (... caddr (regex-NULL (-> (app #f) <-)) regex-BLANK ...) ...)
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-NULL
  (letrec* (... caddr (regex-NULL (-> (app #f) <-)) regex-BLANK ...) ...)
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-NULL
  (letrec* (... caddr (regex-NULL (-> (app #f) <-)) regex-BLANK ...) ...)
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-NULL
  (letrec* (... caddr (regex-NULL (-> (app #f) <-)) regex-BLANK ...) ...)
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-NULL
  (letrec* (... caddr (regex-NULL (-> (app #f) <-)) regex-BLANK ...) ...)
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-NULL
  (letrec* (... caddr (regex-NULL (-> (app #f) <-)) regex-BLANK ...) ...)
  (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-alt?
  (letrec*
   (... regex-BLANK (regex-alt? (-> (λ (re) ...) <-)) regex-seq? ...)
   ...)
  (env ((match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((letrec*
   (... regex-BLANK (regex-alt? (-> (λ (re) ...) <-)) regex-seq? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-alt?
  (letrec*
   (... regex-BLANK (regex-alt? (-> (λ (re) ...) <-)) regex-seq? ...)
   ...)
  (env ((match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((letrec*
   (... regex-BLANK (regex-alt? (-> (λ (re) ...) <-)) regex-seq? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-alt?
  (letrec*
   (... regex-BLANK (regex-alt? (-> (λ (re) ...) <-)) regex-seq? ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... regex-BLANK (regex-alt? (-> (λ (re) ...) <-)) regex-seq? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-atom?
  (letrec*
   (... regex-empty? (regex-atom? (-> (λ (re) ...) <-)) match-seq ...)
   ...)
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((letrec*
   (... regex-empty? (regex-atom? (-> (λ (re) ...) <-)) match-seq ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-atom?
  (letrec*
   (... regex-empty? (regex-atom? (-> (λ (re) ...) <-)) match-seq ...)
   ...)
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((letrec*
   (... regex-empty? (regex-atom? (-> (λ (re) ...) <-)) match-seq ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-atom?
  (letrec*
   (... regex-empty? (regex-atom? (-> (λ (re) ...) <-)) match-seq ...)
   ...)
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((letrec*
   (... regex-empty? (regex-atom? (-> (λ (re) ...) <-)) match-seq ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-atom?
  (letrec*
   (... regex-empty? (regex-atom? (-> (λ (re) ...) <-)) match-seq ...)
   ...)
  (env
   ((app seq (-> (app regex-empty pat1) <-) (app regex-derivative pat2 c)))))
clos/con:
	'((letrec*
   (... regex-empty? (regex-atom? (-> (λ (re) ...) <-)) match-seq ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-atom?
  (letrec*
   (... regex-empty? (regex-atom? (-> (λ (re) ...) <-)) match-seq ...)
   ...)
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((letrec*
   (... regex-empty? (regex-atom? (-> (λ (re) ...) <-)) match-seq ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-atom?
  (letrec*
   (... regex-empty? (regex-atom? (-> (λ (re) ...) <-)) match-seq ...)
   ...)
  (env ((app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((letrec*
   (... regex-empty? (regex-atom? (-> (λ (re) ...) <-)) match-seq ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-atom?
  (letrec*
   (... regex-empty? (regex-atom? (-> (λ (re) ...) <-)) match-seq ...)
   ...)
  (env ((app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((letrec*
   (... regex-empty? (regex-atom? (-> (λ (re) ...) <-)) match-seq ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-atom?
  (letrec*
   (... regex-empty? (regex-atom? (-> (λ (re) ...) <-)) match-seq ...)
   ...)
  (env ((app regex-empty? (-> (app regex-empty pattern) <-)))))
clos/con:
	'((letrec*
   (... regex-empty? (regex-atom? (-> (λ (re) ...) <-)) match-seq ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-atom?
  (letrec*
   (... regex-empty? (regex-atom? (-> (λ (re) ...) <-)) match-seq ...)
   ...)
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((letrec*
   (... regex-empty? (regex-atom? (-> (λ (re) ...) <-)) match-seq ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-atom?
  (letrec*
   (... regex-empty? (regex-atom? (-> (λ (re) ...) <-)) match-seq ...)
   ...)
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((letrec*
   (... regex-empty? (regex-atom? (-> (λ (re) ...) <-)) match-seq ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-atom?
  (letrec*
   (... regex-empty? (regex-atom? (-> (λ (re) ...) <-)) match-seq ...)
   ...)
  (env ((app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((letrec*
   (... regex-empty? (regex-atom? (-> (λ (re) ...) <-)) match-seq ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-atom?
  (letrec*
   (... regex-empty? (regex-atom? (-> (λ (re) ...) <-)) match-seq ...)
   ...)
  (env ((app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((letrec*
   (... regex-empty? (regex-atom? (-> (λ (re) ...) <-)) match-seq ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-atom?
  (letrec*
   (... regex-empty? (regex-atom? (-> (λ (re) ...) <-)) match-seq ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... regex-empty? (regex-atom? (-> (λ (re) ...) <-)) match-seq ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-derivative
  (letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) regex-match ...)
   ...)
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) regex-match ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-derivative
  (letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) regex-match ...)
   ...)
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) regex-match ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-derivative
  (letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) regex-match ...)
   ...)
  (env
   ((app
     check-expect
     (->
      (app
       regex-match
       (app cons 'seq (app cons ...))
       (app cons 'foo (app cons ...)))
      <-)
     (app #f)))))
clos/con:
	'((letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) regex-match ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-derivative
  (letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) regex-match ...)
   ...)
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) regex-match ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-derivative
  (letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) regex-match ...)
   ...)
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) regex-match ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-derivative
  (letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) regex-match ...)
   ...)
  (env
   ((match
     (app null? data)
     ((#f)
      (->
       (app
        regex-match
        (app regex-derivative pattern (app car ...))
        (app cdr data))
       <-))
     _))))
clos/con:
	'((letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) regex-match ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-derivative
  (letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) regex-match ...)
   ...)
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) regex-match ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-derivative
  (letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) regex-match ...)
   ...)
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) regex-match ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-derivative
  (letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) regex-match ...)
   ...)
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) regex-match ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-derivative
  (letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) regex-match ...)
   ...)
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) regex-match ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-derivative
  (letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) regex-match ...)
   ...)
  (env ((match (-> (app f (app cadr re)) <-) (#f) _))))
clos/con:
	'((letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) regex-match ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-derivative
  (letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) regex-match ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) regex-match ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-empty
  (letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-empty
  (letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-empty
  (letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env
   ((app
     check-expect
     (->
      (app
       regex-match
       (app cons 'seq (app cons ...))
       (app cons 'foo (app cons ...)))
      <-)
     (app #f)))))
clos/con:
	'((letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-empty
  (letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-empty
  (letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env
   ((app seq (-> (app regex-empty pat1) <-) (app regex-derivative pat2 c)))))
clos/con:
	'((letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-empty
  (letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-empty
  (letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env
   ((match
     (app null? data)
     ((#f)
      (->
       (app
        regex-match
        (app regex-derivative pattern (app car ...))
        (app cdr data))
       <-))
     _))))
clos/con:
	'((letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-empty
  (letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ((app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-empty
  (letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ((app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-empty
  (letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ((app regex-empty? (-> (app regex-empty pattern) <-)))))
clos/con:
	'((letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-empty
  (letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-empty
  (letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-empty
  (letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ((app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-empty
  (letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ((app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-empty
  (letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-empty
  (letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-empty
  (letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-empty?
  (letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-empty?
  (letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
clos/con:
	'((letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-empty?
  (letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-empty?
  (letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
clos/con:
	'((letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-empty?
  (letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env
   ((app
     check-expect
     (->
      (app
       regex-match
       (app cons 'seq (app cons ...))
       (app cons 'foo (app cons ...)))
      <-)
     (app #f)))))
clos/con:
	'((letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-empty?
  (letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-empty?
  (letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env
   ((app seq (-> (app regex-empty pat1) <-) (app regex-derivative pat2 c)))))
clos/con:
	'((letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-empty?
  (letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-empty?
  (letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env
   ((match
     (app null? data)
     ((#f)
      (->
       (app
        regex-match
        (app regex-derivative pattern (app car ...))
        (app cdr data))
       <-))
     _))))
clos/con:
	'((letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-empty?
  (letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
clos/con:
	'((letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-empty?
  (letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-empty?
  (letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ((app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-empty?
  (letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ((app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-empty?
  (letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ((app regex-empty? (-> (app regex-empty pattern) <-)))))
clos/con:
	'((letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-empty?
  (letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-empty?
  (letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-empty?
  (letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ((app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-empty?
  (letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ((app seq (app regex-derivative pat c) (-> (app rep pat) <-)))))
clos/con:
	'((letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-empty?
  (letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ((app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-empty?
  (letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-match
  (letrec*
   (...
    regex-derivative
    (regex-match (-> (λ (pattern data) ...) <-))
    check-expect
    ...)
   ...)
  (env
   ((app
     check-expect
     (->
      (app
       regex-match
       (app cons 'seq (app cons ...))
       (app cons 'foo (app cons ...)))
      <-)
     (app #f)))))
clos/con:
	'((letrec*
   (...
    regex-derivative
    (regex-match (-> (λ (pattern data) ...) <-))
    check-expect
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-match
  (letrec*
   (...
    regex-derivative
    (regex-match (-> (λ (pattern data) ...) <-))
    check-expect
    ...)
   ...)
  (env
   ((match
     (app null? data)
     ((#f)
      (->
       (app
        regex-match
        (app regex-derivative pattern (app car ...))
        (app cdr data))
       <-))
     _))))
clos/con:
	'((letrec*
   (...
    regex-derivative
    (regex-match (-> (λ (pattern data) ...) <-))
    check-expect
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-match
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
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-null?
  (letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-null?
  (letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env
   ((app
     alt
     (-> (app seq (app regex-derivative pat1 c) pat2) <-)
     (app seq (app regex-empty pat1) (app regex-derivative pat2 c))))))
clos/con:
	'((letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-null?
  (letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-null?
  (letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env
   ((app
     alt
     (app seq (app regex-derivative pat1 c) pat2)
     (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-)))))
clos/con:
	'((letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-null?
  (letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-null?
  (letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env
   ((app seq (-> (app regex-empty pat1) <-) (app regex-derivative pat2 c)))))
clos/con:
	'((letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-null?
  (letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-null?
  (letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env
   ((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-)))))
clos/con:
	'((letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-null?
  (letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env
   ((λ (pat1 pat2)
      (->
       (app
        alt
        (app seq (app regex-derivative ...) pat2)
        (app seq (app regex-empty ...) (app regex-derivative ...)))
       <-)))))
clos/con:
	'((letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-null?
  (letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env
   ((λ (pat1 pat2)
      (->
       (app alt (app regex-derivative pat1 c) (app regex-derivative pat2 c))
       <-)))))
clos/con:
	'((letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-null?
  (letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env
   ((λ (pat1 pat2)
      (-> (app alt (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-null?
  (letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env
   ((λ (pat1 pat2)
      (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-)))))
clos/con:
	'((letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-null?
  (letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ((app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-null?
  (letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ((app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-null?
  (letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ((app regex-empty? (-> (app regex-empty pattern) <-)))))
clos/con:
	'((letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-null?
  (letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-null?
  (letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-null?
  (letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ((app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-null?
  (letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ((app seq (app regex-derivative pat c) (-> (app rep pat) <-)))))
clos/con:
	'((letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-null?
  (letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ((app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-null?
  (letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-rep?
  (letrec*
   (... regex-seq? (regex-rep? (-> (λ (re) ...) <-)) regex-null? ...)
   ...)
  (env
   ((app seq (-> (app regex-empty pat1) <-) (app regex-derivative pat2 c)))))
clos/con:
	'((letrec*
   (... regex-seq? (regex-rep? (-> (λ (re) ...) <-)) regex-null? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-rep?
  (letrec*
   (... regex-seq? (regex-rep? (-> (λ (re) ...) <-)) regex-null? ...)
   ...)
  (env ((app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((letrec*
   (... regex-seq? (regex-rep? (-> (λ (re) ...) <-)) regex-null? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-rep?
  (letrec*
   (... regex-seq? (regex-rep? (-> (λ (re) ...) <-)) regex-null? ...)
   ...)
  (env ((app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((letrec*
   (... regex-seq? (regex-rep? (-> (λ (re) ...) <-)) regex-null? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-rep?
  (letrec*
   (... regex-seq? (regex-rep? (-> (λ (re) ...) <-)) regex-null? ...)
   ...)
  (env ((app regex-empty? (-> (app regex-empty pattern) <-)))))
clos/con:
	'((letrec*
   (... regex-seq? (regex-rep? (-> (λ (re) ...) <-)) regex-null? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-rep?
  (letrec*
   (... regex-seq? (regex-rep? (-> (λ (re) ...) <-)) regex-null? ...)
   ...)
  (env ((app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((letrec*
   (... regex-seq? (regex-rep? (-> (λ (re) ...) <-)) regex-null? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-rep?
  (letrec*
   (... regex-seq? (regex-rep? (-> (λ (re) ...) <-)) regex-null? ...)
   ...)
  (env ((app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((letrec*
   (... regex-seq? (regex-rep? (-> (λ (re) ...) <-)) regex-null? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-rep?
  (letrec*
   (... regex-seq? (regex-rep? (-> (λ (re) ...) <-)) regex-null? ...)
   ...)
  (env ((match (-> (app match-rep re (λ (pat) ...)) <-) (#f) c-x))))
clos/con:
	'((letrec*
   (... regex-seq? (regex-rep? (-> (λ (re) ...) <-)) regex-null? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-rep?
  (letrec*
   (... regex-seq? (regex-rep? (-> (λ (re) ...) <-)) regex-null? ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... regex-seq? (regex-rep? (-> (λ (re) ...) <-)) regex-null? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-seq?
  (letrec*
   (... regex-alt? (regex-seq? (-> (λ (re) ...) <-)) regex-rep? ...)
   ...)
  (env ((match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((letrec*
   (... regex-alt? (regex-seq? (-> (λ (re) ...) <-)) regex-rep? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-seq?
  (letrec*
   (... regex-alt? (regex-seq? (-> (λ (re) ...) <-)) regex-rep? ...)
   ...)
  (env ((match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x))))
clos/con:
	'((letrec*
   (... regex-alt? (regex-seq? (-> (λ (re) ...) <-)) regex-rep? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  regex-seq?
  (letrec*
   (... regex-alt? (regex-seq? (-> (λ (re) ...) <-)) regex-rep? ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... regex-alt? (regex-seq? (-> (λ (re) ...) <-)) regex-rep? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  rep
  (letrec* (... alt (rep (-> (λ (pat) ...) <-)) regex-empty ...) ...)
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((letrec* (... alt (rep (-> (λ (pat) ...) <-)) regex-empty ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  rep
  (letrec* (... alt (rep (-> (λ (pat) ...) <-)) regex-empty ...) ...)
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((letrec* (... alt (rep (-> (λ (pat) ...) <-)) regex-empty ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  rep
  (letrec* (... alt (rep (-> (λ (pat) ...) <-)) regex-empty ...) ...)
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((letrec* (... alt (rep (-> (λ (pat) ...) <-)) regex-empty ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  rep
  (letrec* (... alt (rep (-> (λ (pat) ...) <-)) regex-empty ...) ...)
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((letrec* (... alt (rep (-> (λ (pat) ...) <-)) regex-empty ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  rep
  (letrec* (... alt (rep (-> (λ (pat) ...) <-)) regex-empty ...) ...)
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((letrec* (... alt (rep (-> (λ (pat) ...) <-)) regex-empty ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  rep
  (letrec* (... alt (rep (-> (λ (pat) ...) <-)) regex-empty ...) ...)
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((letrec* (... alt (rep (-> (λ (pat) ...) <-)) regex-empty ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  rep
  (letrec* (... alt (rep (-> (λ (pat) ...) <-)) regex-empty ...) ...)
  (env ((match (-> (app f (app cadr re)) <-) (#f) _))))
clos/con:
	'((letrec* (... alt (rep (-> (λ (pat) ...) <-)) regex-empty ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  rep
  (letrec* (... alt (rep (-> (λ (pat) ...) <-)) regex-empty ...) ...)
  (env ()))
clos/con:
	'((letrec* (... alt (rep (-> (λ (pat) ...) <-)) regex-empty ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  seq
  (letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env
   ((app
     alt
     (-> (app regex-derivative pat1 c) <-)
     (app regex-derivative pat2 c)))))
clos/con:
	'((letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  seq
  (letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env
   ((app
     alt
     (app regex-derivative pat1 c)
     (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  seq
  (letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env
   ((app
     regex-match
     (-> (app regex-derivative pattern (app car data)) <-)
     (app cdr data)))))
clos/con:
	'((letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  seq
  (letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env
   ((app seq (-> (app regex-empty pat1) <-) (app regex-derivative pat2 c)))))
clos/con:
	'((letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  seq
  (letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env
   ((app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-)))))
clos/con:
	'((letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  seq
  (letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env ((app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  seq
  (letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env ((app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  seq
  (letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env ((app regex-empty? (-> (app regex-empty pattern) <-)))))
clos/con:
	'((letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  seq
  (letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env ((app seq (-> (app regex-derivative pat c) <-) (app rep pat)))))
clos/con:
	'((letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  seq
  (letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env ((app seq (-> (app regex-derivative pat1 c) <-) pat2))))
clos/con:
	'((letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  seq
  (letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env ((app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2)))))
clos/con:
	'((letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  seq
  (letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env ((app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-)))))
clos/con:
	'((letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  seq
  (letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env ((match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _))))
clos/con:
	'((letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  seq
  (letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env ((match (-> (app f (app cadr re)) <-) (#f) _))))
clos/con:
	'((letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  seq
  (letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env ()))
clos/con:
	'((letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: con (app cons 'bar (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: con (app cons 'bar (-> (app nil) <-)) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: con (app cons 'foo (-> (app cons 'bar (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons 'foo (-> (app cons 'bar (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: con (app cons 'rep (-> (app cons 'bar (app nil)) <-)) (env ()))
clos/con:
	'((con cons (app cons 'rep (-> (app cons 'bar (app nil)) <-))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: con (app cons (-> 'bar <-) (app nil)) (env ()))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: con (app cons (-> 'bar <-) (app nil)) (env ()))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: con (app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
clos/con:
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: con (app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
clos/con:
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)
