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
                       (app seq (app d/dc pat1 c) pat2)
                       (app seq (app regex-empty pat1) (app d/dc pat2 c)))))
                   ((#f)
                    (match
                     (app
                      match-alt
                      re
                      (λ (pat1 pat2)
                        (app alt (app d/dc pat1 c) (app d/dc pat2 c))))
                     ((#f)
                      (match
                       (app
                        match-rep
                        re
                        (λ (pat) (app seq (app d/dc pat c) (app rep pat))))
                       ((#f) regex-NULL)
                       (c-x c-x)))
                     (c-x c-x)))
                   (c-x c-x)))
                 (_ regex-NULL)))
               (_ regex-BLANK)))
             (_ regex-NULL)))
           (_ regex-NULL)))))
     (d/dc regex-derivative)
     (regex-match
      (λ (pattern data)
        (match
         (app null? data)
         ((#f)
          (app regex-match (app d/dc pattern (app car data)) (app cdr data)))
         (_ (app regex-empty? (app regex-empty pattern))))))
     (check-expect
      (λ (check expect)
        (match
         (app not (app equal? check expect))
         ((#f) (app void))
         (_
          (let ((_ (app display "check-expect failed; got: ")))
            (let ((_ (app display check)))
              (let ((_ (app display "; expected: ")))
                (let ((_ (app display expect))) (app newline))))))))))
    (let ((_ (app check-expect (app d/dc 'baz 'f) (app #f))))
      (let ((_
             (app
              check-expect
              (app
               d/dc
               (app cons 'seq (app cons 'foo (app cons 'barn (app nil))))
               'foo)
              'barn)))
        (let ((_
               (app
                check-expect
                (app
                 d/dc
                 (app
                  cons
                  'alt
                  (app
                   cons
                   (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
                   (app
                    cons
                    (app
                     cons
                     'seq
                     (app
                      cons
                      'foo
                      (app
                       cons
                       (app cons 'rep (app cons 'baz (app nil)))
                       (app nil))))
                    (app nil))))
                 'foo)
                (app
                 cons
                 'alt
                 (app
                  cons
                  'bar
                  (app
                   cons
                   (app cons 'rep (app cons 'baz (app nil)))
                   (app nil)))))))
          (let ((_
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
                     (app
                      cons
                      (app cons 'rep (app cons 'bar (app nil)))
                      (app nil))))
                   (app
                    cons
                    'foo
                    (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
                  (app #t))))
            (let ((_
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
                       (app
                        cons
                        (app cons 'rep (app cons 'bar (app nil)))
                        (app nil))))
                     (app
                      cons
                      'foo
                      (app
                       cons
                       'bar
                       (app
                        cons
                        'baz
                        (app cons 'bar (app cons 'bar (app nil)))))))
                    (app #f))))
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
                  (app
                   cons
                   (app
                    cons
                    'rep
                    (app
                     cons
                     (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
                     (app nil)))
                   (app nil))))
                (app
                 cons
                 'foo
                 (app
                  cons
                  'bar
                  (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
               (app #t))))))))))

'(query: ((top) lettypes (cons ... nil) ...) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (lettypes cons ... nil (letrec* (car ... check-expect) ...)) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

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
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (check expect) (-> (match (app not (app equal? check expect)) ...) <-))
  (env (())))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app not (app equal? check expect)) (#f) (_ (-> (let (_) ...) <-)))
  (env (())))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app display "check-expect failed; got: ") <-)) () ...)
    ...)
  (env (())))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app display (-> "check-expect failed; got: " <-)) (env (())))
clos/con: ⊥
literals: '(⊥ ⊥ "check-expect failed; got: ")

'(query: (app (-> display <-) "check-expect failed; got: ") (env (())))
clos/con:
	'((prim display) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (let (_) ...) <-)) (env (())))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (... () (_ (-> (app display check) <-)) () ...) ...) (env (())))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app display (-> check <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> display <-) check) (env (())))
clos/con:
	'((prim display) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (let (_) ...) <-)) (env (())))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app display "; expected: ") <-)) () ...) ...)
  (env (())))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app display (-> "; expected: " <-)) (env (())))
clos/con: ⊥
literals: '(⊥ ⊥ "; expected: ")

'(query: (app (-> display <-) "; expected: ") (env (())))
clos/con:
	'((prim display) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (let (_) ...) <-)) (env (())))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (... () (_ (-> (app display expect) <-)) () ...) ...) (env (())))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app display (-> expect <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   check-expect
   (app
    d/dc
    (app
     cons
     'alt
     (app
      cons
      (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
      (app
       cons
       (app
        cons
        'seq
        (app
         cons
         'foo
         (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
       (app nil))))
    'foo)
   (->
    (app
     cons
     'alt
     (app
      cons
      'bar
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-))
  (env ()))
	'((app
   check-expect
   (app d/dc (app cons 'seq (app cons 'foo (app cons 'barn (app nil)))) 'foo)
   (-> 'barn <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> display <-) expect) (env (())))
clos/con:
	'((prim display) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (app newline) <-)) (env (())))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> newline <-)) (env (())))
clos/con:
	'((prim newline) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app not (app equal? check expect)) ((#f) (-> (app void) <-)) _)
  (env (())))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> void <-)) (env (())))
clos/con:
	'((prim void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app not (app equal? check expect)) <-) (#f) _) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app not (-> (app equal? check expect) <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app equal? check (-> expect <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   check-expect
   (app
    d/dc
    (app
     cons
     'alt
     (app
      cons
      (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
      (app
       cons
       (app
        cons
        'seq
        (app
         cons
         'foo
         (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
       (app nil))))
    'foo)
   (->
    (app
     cons
     'alt
     (app
      cons
      'bar
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-))
  (env ()))
	'((app
   check-expect
   (app d/dc (app cons 'seq (app cons 'foo (app cons 'barn (app nil)))) 'foo)
   (-> 'barn <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app equal? (-> check <-) expect) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> equal? <-) check expect) (env (())))
clos/con:
	'((prim equal?) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> not <-) (app equal? check expect)) (env (())))
clos/con:
	'((prim not) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... d/dc (regex-match (-> (λ (pattern data) ...) <-)) check-expect ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... d/dc (regex-match (-> (λ (pattern data) ...) <-)) check-expect ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (pattern data) (-> (match (app null? data) ...) <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app null? data)
   (#f)
   (_ (-> (app regex-empty? (app regex-empty pattern)) <-)))
  (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-empty? (-> (app regex-empty pattern) <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-empty (-> pattern <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   regex-match
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app
       cons
       (app
        cons
        'rep
        (app
         cons
         (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
         (app nil)))
       (app nil))))
    <-)
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-empty <-) pattern) (env (())))
clos/con:
	'((letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-empty? <-) (app regex-empty pattern)) (env (())))
clos/con:
	'((letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app null? data)
   ((#f)
    (-> (app regex-match (app d/dc pattern (app car data)) (app cdr data)) <-))
   _)
  (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-match (app d/dc pattern (app car data)) (-> (app cdr data) <-))
  (env (())))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   cons
   'alt
   (->
    (app
     cons
     (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
     (app
      cons
      (app
       cons
       'seq
       (app
        cons
        'foo
        (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
      (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'bar
   (-> (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))) <-))
  (env ()))
	'((app
   cons
   'bar
   (-> (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))) <-))
  (env ()))
	'((app
   cons
   'foo
   (->
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))
    <-))
  (env ()))
	'((app
   cons
   'foo
   (->
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
    <-))
  (env ()))
	'((app
   cons
   'foo
   (->
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
    <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))) <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)) <-))
  (env ()))
	'((app
   cons
   'rep
   (->
    (app
     cons
     (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
     (app nil))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app
      cons
      (app
       cons
       'rep
       (app
        cons
        (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
        (app nil)))
      (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
    <-))
  (env ()))
	'((app
   cons
   (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
   (->
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))
    <-))
  (env ()))
	'((app cons 'alt (-> (app cons 'bar (app cons 'baz (app nil))) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'baz (app nil)) <-)) (env ()))
	'((app cons 'baz (-> (app cons 'bar (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'baz (-> (app cons 'bar (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'foo (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'foo (-> (app cons 'barn (app nil)) <-)) (env ()))
	'((app cons 'rep (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'rep (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'rep (-> (app cons 'baz (app nil)) <-)) (env ()))
	'((app cons 'seq (-> (app cons 'foo (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'seq (-> (app cons 'foo (app cons 'barn (app nil))) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cdr (-> data <-)) (env (())))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   cons
   'alt
   (->
    (app
     cons
     (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
     (app
      cons
      (app
       cons
       'seq
       (app
        cons
        'foo
        (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
      (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'bar
   (-> (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))) <-))
  (env ()))
	'((app
   cons
   'bar
   (-> (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))) <-))
  (env ()))
	'((app
   cons
   'foo
   (->
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))
    <-))
  (env ()))
	'((app
   cons
   'foo
   (->
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
    <-))
  (env ()))
	'((app
   cons
   'foo
   (->
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
    <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))) <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)) <-))
  (env ()))
	'((app
   cons
   'rep
   (->
    (app
     cons
     (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
     (app nil))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app
      cons
      (app
       cons
       'rep
       (app
        cons
        (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
        (app nil)))
      (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
    <-))
  (env ()))
	'((app
   cons
   (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
   (->
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))
    <-))
  (env ()))
	'((app
   regex-match
   (app
    cons
    'seq
    (app
     cons
     'foo
     (app
      cons
      (app
       cons
       'rep
       (app
        cons
        (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
        (app nil)))
      (app nil))))
   (->
    (app
     cons
     'foo
     (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
    <-))
  (env ()))
	'((app
   regex-match
   (app
    cons
    'seq
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
   (->
    (app
     cons
     'foo
     (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
    <-))
  (env ()))
	'((app
   regex-match
   (app
    cons
    'seq
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
   (->
    (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
    <-))
  (env ()))
	'((app cons 'alt (-> (app cons 'bar (app cons 'baz (app nil))) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'baz (app nil)) <-)) (env ()))
	'((app cons 'baz (-> (app cons 'bar (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'baz (-> (app cons 'bar (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'foo (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'foo (-> (app cons 'barn (app nil)) <-)) (env ()))
	'((app cons 'rep (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'rep (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'rep (-> (app cons 'baz (app nil)) <-)) (env ()))
	'((app cons 'seq (-> (app cons 'foo (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'seq (-> (app cons 'foo (app cons 'barn (app nil))) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cdr <-) data) (env (())))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-match (-> (app d/dc pattern (app car data)) <-) (app cdr data))
  (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app d/dc pattern (-> (app car data) <-)) (env (())))
clos/con:
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app car (-> data <-)) (env (())))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   cons
   'alt
   (->
    (app
     cons
     (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
     (app
      cons
      (app
       cons
       'seq
       (app
        cons
        'foo
        (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
      (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'bar
   (-> (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))) <-))
  (env ()))
	'((app
   cons
   'bar
   (-> (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))) <-))
  (env ()))
	'((app
   cons
   'foo
   (->
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))
    <-))
  (env ()))
	'((app
   cons
   'foo
   (->
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
    <-))
  (env ()))
	'((app
   cons
   'foo
   (->
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
    <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))) <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)) <-))
  (env ()))
	'((app
   cons
   'rep
   (->
    (app
     cons
     (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
     (app nil))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app
      cons
      (app
       cons
       'rep
       (app
        cons
        (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
        (app nil)))
      (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
    <-))
  (env ()))
	'((app
   cons
   (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
   (->
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))
    <-))
  (env ()))
	'((app
   regex-match
   (app
    cons
    'seq
    (app
     cons
     'foo
     (app
      cons
      (app
       cons
       'rep
       (app
        cons
        (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
        (app nil)))
      (app nil))))
   (->
    (app
     cons
     'foo
     (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
    <-))
  (env ()))
	'((app
   regex-match
   (app
    cons
    'seq
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
   (->
    (app
     cons
     'foo
     (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
    <-))
  (env ()))
	'((app
   regex-match
   (app
    cons
    'seq
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
   (->
    (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
    <-))
  (env ()))
	'((app cons 'alt (-> (app cons 'bar (app cons 'baz (app nil))) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'baz (app nil)) <-)) (env ()))
	'((app cons 'baz (-> (app cons 'bar (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'baz (-> (app cons 'bar (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'foo (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'foo (-> (app cons 'barn (app nil)) <-)) (env ()))
	'((app cons 'rep (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'rep (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'rep (-> (app cons 'baz (app nil)) <-)) (env ()))
	'((app cons 'seq (-> (app cons 'foo (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'seq (-> (app cons 'foo (app cons 'barn (app nil))) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> car <-) data) (env (())))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app d/dc (-> pattern <-) (app car data)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   regex-match
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app
       cons
       (app
        cons
        'rep
        (app
         cons
         (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
         (app nil)))
       (app nil))))
    <-)
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> d/dc <-) pattern (app car data)) (env (())))
clos/con:
	'((letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) d/dc ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> regex-match <-) (app d/dc pattern (app car data)) (app cdr data))
  (env (())))
clos/con:
	'((letrec*
   (... d/dc (regex-match (-> (λ (pattern data) ...) <-)) check-expect ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app null? data) <-) (#f) _) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app null? (-> data <-)) (env (())))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   cons
   'alt
   (->
    (app
     cons
     (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
     (app
      cons
      (app
       cons
       'seq
       (app
        cons
        'foo
        (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
      (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'bar
   (-> (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))) <-))
  (env ()))
	'((app
   cons
   'bar
   (-> (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))) <-))
  (env ()))
	'((app
   cons
   'foo
   (->
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))
    <-))
  (env ()))
	'((app
   cons
   'foo
   (->
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
    <-))
  (env ()))
	'((app
   cons
   'foo
   (->
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
    <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))) <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)) <-))
  (env ()))
	'((app
   cons
   'rep
   (->
    (app
     cons
     (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
     (app nil))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app
      cons
      (app
       cons
       'rep
       (app
        cons
        (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
        (app nil)))
      (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
    <-))
  (env ()))
	'((app
   cons
   (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
   (->
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))
    <-))
  (env ()))
	'((app
   regex-match
   (app
    cons
    'seq
    (app
     cons
     'foo
     (app
      cons
      (app
       cons
       'rep
       (app
        cons
        (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
        (app nil)))
      (app nil))))
   (->
    (app
     cons
     'foo
     (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
    <-))
  (env ()))
	'((app
   regex-match
   (app
    cons
    'seq
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
   (->
    (app
     cons
     'foo
     (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
    <-))
  (env ()))
	'((app
   regex-match
   (app
    cons
    'seq
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
   (->
    (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
    <-))
  (env ()))
	'((app cons 'alt (-> (app cons 'bar (app cons 'baz (app nil))) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'baz (app nil)) <-)) (env ()))
	'((app cons 'baz (-> (app cons 'bar (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'baz (-> (app cons 'bar (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'foo (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'foo (-> (app cons 'barn (app nil)) <-)) (env ()))
	'((app cons 'rep (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'rep (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'rep (-> (app cons 'baz (app nil)) <-)) (env ()))
	'((app cons 'seq (-> (app cons 'foo (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'seq (-> (app cons 'foo (app cons 'barn (app nil))) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> null? <-) data) (env (())))
clos/con:
	'((letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) debug-trace ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... regex-derivative (d/dc (-> regex-derivative <-)) regex-match ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) d/dc ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) d/dc ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) d/dc ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (re c) (-> (let (_) ...) <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (... () (_ (-> (app debug-trace) <-)) () ...) ...) (env (())))
clos/con:
	'((λ () (-> 'do-nothing <-)) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> debug-trace <-)) (env (())))
clos/con:
	'((letrec* (... null? (debug-trace (-> (λ () ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (match (app regex-empty? re) ...) <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app regex-empty? re) (#f) (_ (-> regex-NULL <-))) (env (())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-empty? re)
   ((#f) (-> (match (app regex-null? re) ...) <-))
   _)
  (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app regex-null? re) (#f) (_ (-> regex-NULL <-))) (env (())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-null? re) ((#f) (-> (match (app eq? c re) ...) <-)) _)
  (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app eq? c re) (#f) (_ (-> regex-BLANK <-))) (env (())))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app eq? c re) ((#f) (-> (match (app regex-atom? re) ...) <-)) _)
  (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app regex-atom? re) (#f) (_ (-> regex-NULL <-))) (env (())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-atom? re)
   ((#f) (-> (match (app match-seq re (λ (pat1 pat2) ...)) ...) <-))
   _)
  (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-seq re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env (())))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app match-seq re (λ (pat1 pat2) ...))
   ((#f) (-> (match (app match-alt re (λ (pat1 pat2) ...)) ...) <-))
   c-x)
  (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-alt re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env (())))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app match-alt re (λ (pat1 pat2) ...))
   ((#f) (-> (match (app match-rep re (λ (pat) ...)) ...) <-))
   c-x)
  (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-rep re (λ (pat) ...)) (#f) (c-x (-> c-x <-)))
  (env (())))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-rep re (λ (pat) ...)) ((#f) (-> regex-NULL <-)) c-x)
  (env (())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app match-rep re (λ (pat) ...)) <-) (#f) c-x) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app match-rep re (-> (λ (pat) ...) <-)) (env (())))
clos/con:
	'((app match-rep re (-> (λ (pat) ...) <-)) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (pat) (-> (app seq (app d/dc pat c) (app rep pat)) <-))
  (env (() ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
   _)
  (env (())))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
   _)
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app seq (app d/dc pat c) (-> (app rep pat) <-)) (env (() ())))
clos/con:
	'(((top) app #t) (env ()))
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
   _)
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app rep (-> pat <-)) (env (() ())))
clos/con:
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> rep <-) pat) (env (() ())))
clos/con:
	'((letrec* (... alt (rep (-> (λ (pat) ...) <-)) regex-empty ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app seq (-> (app d/dc pat c) <-) (app rep pat)) (env (() ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app d/dc pat (-> c <-)) (env (() ())))
clos/con:
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app
   d/dc
   (app
    cons
    'alt
    (app
     cons
     (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
     (app
      cons
      (app
       cons
       'seq
       (app
        cons
        'foo
        (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
      (app nil))))
   (-> 'foo <-))
  (env ()))
	'((app
   d/dc
   (app cons 'seq (app cons 'foo (app cons 'barn (app nil))))
   (-> 'foo <-))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((app d/dc 'baz (-> 'f <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app d/dc (-> pat <-) c) (env (() ())))
clos/con:
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> d/dc <-) pat c) (env (() ())))
clos/con:
	'((letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) d/dc ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> seq <-) (app d/dc pat c) (app rep pat)) (env (() ())))
clos/con:
	'((letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app match-rep (-> re <-) (λ (pat) ...)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app
   d/dc
   (->
    (app
     cons
     'alt
     (app
      cons
      (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
      (app
       cons
       (app
        cons
        'seq
        (app
         cons
         'foo
         (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
       (app nil))))
    <-)
   'foo)
  (env ()))
	'((app
   d/dc
   (-> (app cons 'seq (app cons 'foo (app cons 'barn (app nil)))) <-)
   'foo)
  (env ()))
	'((app
   regex-match
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app
       cons
       (app
        cons
        'rep
        (app
         cons
         (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
         (app nil)))
       (app nil))))
    <-)
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((app d/dc (-> 'baz <-) 'f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> match-rep <-) re (λ (pat) ...)) (env (())))
clos/con:
	'((letrec* (... match-alt (match-rep (-> (λ (re f) ...) <-)) seq ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x)
  (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app match-alt re (-> (λ (pat1 pat2) ...) <-)) (env (())))
clos/con:
	'((app match-alt re (-> (λ (pat1 pat2) ...) <-)) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (pat1 pat2) (-> (app alt (app d/dc pat1 c) (app d/dc pat2 c)) <-))
  (env (() ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
   _)
  (env (())))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
   _)
  (env (())))
	'((match
   (app regex-null? pat2)
   ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
   _)
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app alt (app d/dc pat1 c) (-> (app d/dc pat2 c) <-)) (env (() ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app d/dc pat2 (-> c <-)) (env (() ())))
clos/con:
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app
   d/dc
   (app
    cons
    'alt
    (app
     cons
     (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
     (app
      cons
      (app
       cons
       'seq
       (app
        cons
        'foo
        (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
      (app nil))))
   (-> 'foo <-))
  (env ()))
	'((app
   d/dc
   (app cons 'seq (app cons 'foo (app cons 'barn (app nil))))
   (-> 'foo <-))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((app d/dc 'baz (-> 'f <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app d/dc (-> pat2 <-) c) (env (() ())))
clos/con:
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> d/dc <-) pat2 c) (env (() ())))
clos/con:
	'((letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) d/dc ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app alt (-> (app d/dc pat1 c) <-) (app d/dc pat2 c)) (env (() ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app d/dc pat1 (-> c <-)) (env (() ())))
clos/con:
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app
   d/dc
   (app
    cons
    'alt
    (app
     cons
     (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
     (app
      cons
      (app
       cons
       'seq
       (app
        cons
        'foo
        (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
      (app nil))))
   (-> 'foo <-))
  (env ()))
	'((app
   d/dc
   (app cons 'seq (app cons 'foo (app cons 'barn (app nil))))
   (-> 'foo <-))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((app d/dc 'baz (-> 'f <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app d/dc (-> pat1 <-) c) (env (() ())))
clos/con:
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> d/dc <-) pat1 c) (env (() ())))
clos/con:
	'((letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) d/dc ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> alt <-) (app d/dc pat1 c) (app d/dc pat2 c)) (env (() ())))
clos/con:
	'((letrec* (... seq (alt (-> (λ (pat1 pat2) ...) <-)) rep ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app match-alt (-> re <-) (λ (pat1 pat2) ...)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app
   d/dc
   (->
    (app
     cons
     'alt
     (app
      cons
      (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
      (app
       cons
       (app
        cons
        'seq
        (app
         cons
         'foo
         (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
       (app nil))))
    <-)
   'foo)
  (env ()))
	'((app
   d/dc
   (-> (app cons 'seq (app cons 'foo (app cons 'barn (app nil)))) <-)
   'foo)
  (env ()))
	'((app
   regex-match
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app
       cons
       (app
        cons
        'rep
        (app
         cons
         (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
         (app nil)))
       (app nil))))
    <-)
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((app d/dc (-> 'baz <-) 'f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> match-alt <-) re (λ (pat1 pat2) ...)) (env (())))
clos/con:
	'((letrec*
   (... match-seq (match-alt (-> (λ (re f) ...) <-)) match-rep ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x)
  (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app match-seq re (-> (λ (pat1 pat2) ...) <-)) (env (())))
clos/con:
	'((app match-seq re (-> (λ (pat1 pat2) ...) <-)) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (pat1 pat2)
    (->
     (app
      alt
      (app seq (app d/dc pat1 c) pat2)
      (app seq (app regex-empty pat1) (app d/dc pat2 c)))
     <-))
  (env (() ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
   _)
  (env (())))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
   _)
  (env (())))
	'((match
   (app regex-null? pat2)
   ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
   _)
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   alt
   (app seq (app d/dc pat1 c) pat2)
   (-> (app seq (app regex-empty pat1) (app d/dc pat2 c)) <-))
  (env (() ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
   _)
  (env (())))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
   _)
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app seq (app regex-empty pat1) (-> (app d/dc pat2 c) <-))
  (env (() ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app d/dc pat2 (-> c <-)) (env (() ())))
clos/con:
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app
   d/dc
   (app
    cons
    'alt
    (app
     cons
     (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
     (app
      cons
      (app
       cons
       'seq
       (app
        cons
        'foo
        (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
      (app nil))))
   (-> 'foo <-))
  (env ()))
	'((app
   d/dc
   (app cons 'seq (app cons 'foo (app cons 'barn (app nil))))
   (-> 'foo <-))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((app d/dc 'baz (-> 'f <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app d/dc (-> pat2 <-) c) (env (() ())))
clos/con:
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> d/dc <-) pat2 c) (env (() ())))
clos/con:
	'((letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) d/dc ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app seq (-> (app regex-empty pat1) <-) (app d/dc pat2 c))
  (env (() ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-empty (-> pat1 <-)) (env (() ())))
clos/con:
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-empty <-) pat1) (env (() ())))
clos/con:
	'((letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> seq <-) (app regex-empty pat1) (app d/dc pat2 c))
  (env (() ())))
clos/con:
	'((letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   alt
   (-> (app seq (app d/dc pat1 c) pat2) <-)
   (app seq (app regex-empty pat1) (app d/dc pat2 c)))
  (env (() ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
   _)
  (env (())))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
   _)
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app seq (app d/dc pat1 c) (-> pat2 <-)) (env (() ())))
clos/con:
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app seq (-> (app d/dc pat1 c) <-) pat2) (env (() ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app d/dc pat1 (-> c <-)) (env (() ())))
clos/con:
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app
   d/dc
   (app
    cons
    'alt
    (app
     cons
     (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
     (app
      cons
      (app
       cons
       'seq
       (app
        cons
        'foo
        (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
      (app nil))))
   (-> 'foo <-))
  (env ()))
	'((app
   d/dc
   (app cons 'seq (app cons 'foo (app cons 'barn (app nil))))
   (-> 'foo <-))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((app d/dc 'baz (-> 'f <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app d/dc (-> pat1 <-) c) (env (() ())))
clos/con:
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> d/dc <-) pat1 c) (env (() ())))
clos/con:
	'((letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) d/dc ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> seq <-) (app d/dc pat1 c) pat2) (env (() ())))
clos/con:
	'((letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   (-> alt <-)
   (app seq (app d/dc pat1 c) pat2)
   (app seq (app regex-empty pat1) (app d/dc pat2 c)))
  (env (() ())))
clos/con:
	'((letrec* (... seq (alt (-> (λ (pat1 pat2) ...) <-)) rep ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app match-seq (-> re <-) (λ (pat1 pat2) ...)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app
   d/dc
   (->
    (app
     cons
     'alt
     (app
      cons
      (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
      (app
       cons
       (app
        cons
        'seq
        (app
         cons
         'foo
         (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
       (app nil))))
    <-)
   'foo)
  (env ()))
	'((app
   d/dc
   (-> (app cons 'seq (app cons 'foo (app cons 'barn (app nil)))) <-)
   'foo)
  (env ()))
	'((app
   regex-match
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app
       cons
       (app
        cons
        'rep
        (app
         cons
         (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
         (app nil)))
       (app nil))))
    <-)
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((app d/dc (-> 'baz <-) 'f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> match-seq <-) re (λ (pat1 pat2) ...)) (env (())))
clos/con:
	'((letrec*
   (... regex-atom? (match-seq (-> (λ (re f) ...) <-)) match-alt ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app regex-atom? re) <-) (#f) _) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-atom? (-> re <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app
   d/dc
   (->
    (app
     cons
     'alt
     (app
      cons
      (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
      (app
       cons
       (app
        cons
        'seq
        (app
         cons
         'foo
         (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
       (app nil))))
    <-)
   'foo)
  (env ()))
	'((app
   d/dc
   (-> (app cons 'seq (app cons 'foo (app cons 'barn (app nil)))) <-)
   'foo)
  (env ()))
	'((app
   regex-match
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app
       cons
       (app
        cons
        'rep
        (app
         cons
         (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
         (app nil)))
       (app nil))))
    <-)
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((app d/dc (-> 'baz <-) 'f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-atom? <-) re) (env (())))
clos/con:
	'((letrec*
   (... regex-empty? (regex-atom? (-> (λ (re) ...) <-)) match-seq ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app eq? c re) <-) (#f) _) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app eq? c (-> re <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app
   d/dc
   (->
    (app
     cons
     'alt
     (app
      cons
      (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
      (app
       cons
       (app
        cons
        'seq
        (app
         cons
         'foo
         (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
       (app nil))))
    <-)
   'foo)
  (env ()))
	'((app
   d/dc
   (-> (app cons 'seq (app cons 'foo (app cons 'barn (app nil)))) <-)
   'foo)
  (env ()))
	'((app
   regex-match
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app
       cons
       (app
        cons
        'rep
        (app
         cons
         (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
         (app nil)))
       (app nil))))
    <-)
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((app d/dc (-> 'baz <-) 'f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app eq? (-> c <-) re) (env (())))
clos/con:
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app
   d/dc
   (app
    cons
    'alt
    (app
     cons
     (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
     (app
      cons
      (app
       cons
       'seq
       (app
        cons
        'foo
        (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
      (app nil))))
   (-> 'foo <-))
  (env ()))
	'((app
   d/dc
   (app cons 'seq (app cons 'foo (app cons 'barn (app nil))))
   (-> 'foo <-))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((app d/dc 'baz (-> 'f <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> eq? <-) c re) (env (())))
clos/con:
	'((prim eq?) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app regex-null? re) <-) (#f) _) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-null? (-> re <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app
   d/dc
   (->
    (app
     cons
     'alt
     (app
      cons
      (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
      (app
       cons
       (app
        cons
        'seq
        (app
         cons
         'foo
         (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
       (app nil))))
    <-)
   'foo)
  (env ()))
	'((app
   d/dc
   (-> (app cons 'seq (app cons 'foo (app cons 'barn (app nil)))) <-)
   'foo)
  (env ()))
	'((app
   regex-match
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app
       cons
       (app
        cons
        'rep
        (app
         cons
         (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
         (app nil)))
       (app nil))))
    <-)
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((app d/dc (-> 'baz <-) 'f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-null? <-) re) (env (())))
clos/con:
	'((letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app regex-empty? re) <-) (#f) _) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-empty? (-> re <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app
   d/dc
   (->
    (app
     cons
     'alt
     (app
      cons
      (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
      (app
       cons
       (app
        cons
        'seq
        (app
         cons
         'foo
         (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
       (app nil))))
    <-)
   'foo)
  (env ()))
	'((app
   d/dc
   (-> (app cons 'seq (app cons 'foo (app cons 'barn (app nil)))) <-)
   'foo)
  (env ()))
	'((app
   regex-match
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app
       cons
       (app
        cons
        'rep
        (app
         cons
         (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
         (app nil)))
       (app nil))))
    <-)
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((app d/dc (-> 'baz <-) 'f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-empty? <-) re) (env (())))
clos/con:
	'((letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

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
literals: '(⊥ ⊥ ⊥)

'(query: (λ (re) (-> (match (app regex-empty? re) ...) <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app regex-empty? re) (#f) (_ (-> (app #t) <-))) (env (())))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-empty? re)
   ((#f) (-> (match (app regex-null? re) ...) <-))
   _)
  (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app regex-null? re) (#f) (_ (-> (app #f) <-))) (env (())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-null? re)
   ((#f) (-> (match (app regex-atom? re) ...) <-))
   _)
  (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app regex-atom? re) (#f) (_ (-> (app #f) <-))) (env (())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-atom? re)
   ((#f) (-> (match (app match-seq re (λ (pat1 pat2) ...)) ...) <-))
   _)
  (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-seq re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env (())))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app match-seq re (λ (pat1 pat2) ...))
   ((#f) (-> (match (app match-alt re (λ (pat1 pat2) ...)) ...) <-))
   c-x)
  (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-alt re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env (())))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app match-alt re (λ (pat1 pat2) ...))
   ((#f) (-> (match (app regex-rep? re) ...) <-))
   c-x)
  (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app regex-rep? re) (#f) (_ (-> (app #t) <-))) (env (())))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app regex-rep? re) ((#f) (-> (app #f) <-)) _) (env (())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app regex-rep? re) <-) (#f) _) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-rep? (-> re <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app
   regex-match
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app
       cons
       (app
        cons
        'rep
        (app
         cons
         (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
         (app nil)))
       (app nil))))
    <-)
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-rep? <-) re) (env (())))
clos/con:
	'((letrec*
   (... regex-seq? (regex-rep? (-> (λ (re) ...) <-)) regex-null? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x)
  (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app match-alt re (-> (λ (pat1 pat2) ...) <-)) (env (())))
clos/con:
	'((app match-alt re (-> (λ (pat1 pat2) ...) <-)) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (pat1 pat2)
    (-> (app alt (app regex-empty pat1) (app regex-empty pat2)) <-))
  (env (() ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
   _)
  (env (())))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
   _)
  (env (())))
	'((match
   (app regex-null? pat2)
   ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
   _)
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-))
  (env (() ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-empty (-> pat2 <-)) (env (() ())))
clos/con:
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-empty <-) pat2) (env (() ())))
clos/con:
	'((letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2))
  (env (() ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-empty (-> pat1 <-)) (env (() ())))
clos/con:
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-empty <-) pat1) (env (() ())))
clos/con:
	'((letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> alt <-) (app regex-empty pat1) (app regex-empty pat2))
  (env (() ())))
clos/con:
	'((letrec* (... seq (alt (-> (λ (pat1 pat2) ...) <-)) rep ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app match-alt (-> re <-) (λ (pat1 pat2) ...)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app
   regex-match
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app
       cons
       (app
        cons
        'rep
        (app
         cons
         (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
         (app nil)))
       (app nil))))
    <-)
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> match-alt <-) re (λ (pat1 pat2) ...)) (env (())))
clos/con:
	'((letrec*
   (... match-seq (match-alt (-> (λ (re f) ...) <-)) match-rep ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x)
  (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app match-seq re (-> (λ (pat1 pat2) ...) <-)) (env (())))
clos/con:
	'((app match-seq re (-> (λ (pat1 pat2) ...) <-)) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (pat1 pat2)
    (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-))
  (env (() ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
   _)
  (env (())))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
   _)
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-))
  (env (() ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-empty (-> pat2 <-)) (env (() ())))
clos/con:
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-empty <-) pat2) (env (() ())))
clos/con:
	'((letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2))
  (env (() ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-empty (-> pat1 <-)) (env (() ())))
clos/con:
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-empty <-) pat1) (env (() ())))
clos/con:
	'((letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> seq <-) (app regex-empty pat1) (app regex-empty pat2))
  (env (() ())))
clos/con:
	'((letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app match-seq (-> re <-) (λ (pat1 pat2) ...)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app
   regex-match
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app
       cons
       (app
        cons
        'rep
        (app
         cons
         (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
         (app nil)))
       (app nil))))
    <-)
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> match-seq <-) re (λ (pat1 pat2) ...)) (env (())))
clos/con:
	'((letrec*
   (... regex-atom? (match-seq (-> (λ (re f) ...) <-)) match-alt ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app regex-atom? re) <-) (#f) _) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-atom? (-> re <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app
   regex-match
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app
       cons
       (app
        cons
        'rep
        (app
         cons
         (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
         (app nil)))
       (app nil))))
    <-)
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-atom? <-) re) (env (())))
clos/con:
	'((letrec*
   (... regex-empty? (regex-atom? (-> (λ (re) ...) <-)) match-seq ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app regex-null? re) <-) (#f) _) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-null? (-> re <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app
   regex-match
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app
       cons
       (app
        cons
        'rep
        (app
         cons
         (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
         (app nil)))
       (app nil))))
    <-)
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-null? <-) re) (env (())))
clos/con:
	'((letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app regex-empty? re) <-) (#f) _) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-empty? (-> re <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app
   regex-match
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app
       cons
       (app
        cons
        'rep
        (app
         cons
         (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
         (app nil)))
       (app nil))))
    <-)
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-empty? <-) re) (env (())))
clos/con:
	'((letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... alt (rep (-> (λ (pat) ...) <-)) regex-empty ...) ...)
  (env ()))
clos/con:
	'((letrec* (... alt (rep (-> (λ (pat) ...) <-)) regex-empty ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (pat) (-> (match (app regex-null? pat) ...) <-)) (env (())))
clos/con:
	'(((top) app #t) (env ()))
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
   _)
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app regex-null? pat) (#f) (_ (-> regex-BLANK <-))) (env (())))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-null? pat)
   ((#f) (-> (match (app regex-empty? pat) ...) <-))
   _)
  (env (())))
clos/con:
	'(((top) app #t) (env ()))
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
   _)
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-empty? pat) (#f) (_ (-> regex-BLANK <-)))
  (env (())))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
   _)
  (env (())))
clos/con:
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
   _)
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 'rep (-> (app cons pat (app nil)) <-)) (env (())))
clos/con:
	'((app cons 'rep (-> (app cons pat (app nil)) <-)) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons pat (-> (app nil) <-)) (env (())))
clos/con:
	'(((top) app nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env (())))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> pat <-) (app nil)) (env (())))
clos/con:
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) pat (app nil)) (env (())))
clos/con:
	'((app (-> cons <-) pat (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> 'rep <-) (app cons pat (app nil))) (env (())))
clos/con:
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 'rep (app cons pat (app nil))) (env (())))
clos/con:
	'((app (-> cons <-) 'rep (app cons pat (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app regex-empty? pat) <-) (#f) _) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-empty? (-> pat <-)) (env (())))
clos/con:
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-empty? <-) pat) (env (())))
clos/con:
	'((letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app regex-null? pat) <-) (#f) _) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-null? (-> pat <-)) (env (())))
clos/con:
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-null? <-) pat) (env (())))
clos/con:
	'((letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... seq (alt (-> (λ (pat1 pat2) ...) <-)) rep ...) ...)
  (env ()))
clos/con:
	'((letrec* (... seq (alt (-> (λ (pat1 pat2) ...) <-)) rep ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (pat1 pat2) (-> (match (app regex-null? pat1) ...) <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
   _)
  (env (())))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
   _)
  (env (())))
	'((match
   (app regex-null? pat2)
   ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
   _)
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app regex-null? pat1) (#f) (_ (-> pat2 <-))) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
   _)
  (env (())))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
   _)
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-null? pat1)
   ((#f) (-> (match (app regex-null? pat2) ...) <-))
   _)
  (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
   _)
  (env (())))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
   _)
  (env (())))
	'((match
   (app regex-null? pat2)
   ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
   _)
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app regex-null? pat2) (#f) (_ (-> pat1 <-))) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
   _)
  (env (())))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
   _)
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-null? pat2)
   ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
   _)
  (env (())))
clos/con:
	'((match
   (app regex-null? pat2)
   ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
   _)
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons 'alt (-> (app cons pat1 (app cons pat2 (app nil))) <-))
  (env (())))
clos/con:
	'((app cons 'alt (-> (app cons pat1 (app cons pat2 (app nil))) <-)) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons pat1 (-> (app cons pat2 (app nil)) <-)) (env (())))
clos/con:
	'((app cons pat1 (-> (app cons pat2 (app nil)) <-)) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons pat2 (-> (app nil) <-)) (env (())))
clos/con:
	'(((top) app nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env (())))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> pat2 <-) (app nil)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
   _)
  (env (())))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
   _)
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) pat2 (app nil)) (env (())))
clos/con:
	'((app (-> cons <-) pat2 (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> pat1 <-) (app cons pat2 (app nil))) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
   _)
  (env (())))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
   _)
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) pat1 (app cons pat2 (app nil))) (env (())))
clos/con:
	'((app (-> cons <-) pat1 (app cons pat2 (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil))))
  (env (())))
clos/con:
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil)))) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> cons <-) 'alt (app cons pat1 (app cons pat2 (app nil))))
  (env (())))
clos/con:
	'((app (-> cons <-) 'alt (app cons pat1 (app cons pat2 (app nil)))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app regex-null? pat2) <-) (#f) _) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-null? (-> pat2 <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
   _)
  (env (())))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
   _)
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-null? <-) pat2) (env (())))
clos/con:
	'((letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app regex-null? pat1) <-) (#f) _) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-null? (-> pat1 <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
   _)
  (env (())))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
   _)
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-null? <-) pat1) (env (())))
clos/con:
	'((letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env ()))
clos/con:
	'((letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (pat1 pat2) (-> (match (app regex-null? pat1) ...) <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
   _)
  (env (())))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
   _)
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app regex-null? pat1) (#f) (_ (-> regex-NULL <-))) (env (())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-null? pat1)
   ((#f) (-> (match (app regex-null? pat2) ...) <-))
   _)
  (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
   _)
  (env (())))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
   _)
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app regex-null? pat2) (#f) (_ (-> regex-NULL <-))) (env (())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-null? pat2)
   ((#f) (-> (match (app regex-empty? pat1) ...) <-))
   _)
  (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
   _)
  (env (())))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
   _)
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app regex-empty? pat1) (#f) (_ (-> pat2 <-))) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
   _)
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-empty? pat1)
   ((#f) (-> (match (app regex-empty? pat2) ...) <-))
   _)
  (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
   _)
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app regex-empty? pat2) (#f) (_ (-> pat1 <-))) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
   _)
  (env (())))
clos/con:
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
   _)
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil))) <-))
  (env (())))
clos/con:
	'((app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil))) <-)) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons pat1 (-> (app cons pat2 (app nil)) <-)) (env (())))
clos/con:
	'((app cons pat1 (-> (app cons pat2 (app nil)) <-)) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons pat2 (-> (app nil) <-)) (env (())))
clos/con:
	'(((top) app nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env (())))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> pat2 <-) (app nil)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
   _)
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) pat2 (app nil)) (env (())))
clos/con:
	'((app (-> cons <-) pat2 (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> pat1 <-) (app cons pat2 (app nil))) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) pat1 (app cons pat2 (app nil))) (env (())))
clos/con:
	'((app (-> cons <-) pat1 (app cons pat2 (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil))))
  (env (())))
clos/con:
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil)))) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> cons <-) 'seq (app cons pat1 (app cons pat2 (app nil))))
  (env (())))
clos/con:
	'((app (-> cons <-) 'seq (app cons pat1 (app cons pat2 (app nil)))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app regex-empty? pat2) <-) (#f) _) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-empty? (-> pat2 <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
   _)
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-empty? <-) pat2) (env (())))
clos/con:
	'((letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app regex-empty? pat1) <-) (#f) _) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-empty? (-> pat1 <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-empty? <-) pat1) (env (())))
clos/con:
	'((letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app regex-null? pat2) <-) (#f) _) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-null? (-> pat2 <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
   _)
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-null? <-) pat2) (env (())))
clos/con:
	'((letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app regex-null? pat1) <-) (#f) _) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-null? (-> pat1 <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-null? <-) pat1) (env (())))
clos/con:
	'((letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... match-alt (match-rep (-> (λ (re f) ...) <-)) seq ...) ...)
  (env ()))
clos/con:
	'((letrec* (... match-alt (match-rep (-> (λ (re f) ...) <-)) seq ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (re f) (-> (match (app regex-rep? re) ...) <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-rep? re)
   (#f)
   (_ (-> (match (app f (app cadr re)) ...) <-)))
  (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app f (app cadr re)) (#f) (_ (-> (app #t) <-))) (env (())))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app f (app cadr re)) ((#f) (-> (app #f) <-)) _) (env (())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app f (app cadr re)) <-) (#f) _) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
   _)
  (env (())))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
   _)
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app f (-> (app cadr re) <-)) (env (())))
clos/con:
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cadr (-> re <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app
   d/dc
   (->
    (app
     cons
     'alt
     (app
      cons
      (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
      (app
       cons
       (app
        cons
        'seq
        (app
         cons
         'foo
         (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
       (app nil))))
    <-)
   'foo)
  (env ()))
	'((app
   d/dc
   (-> (app cons 'seq (app cons 'foo (app cons 'barn (app nil)))) <-)
   'foo)
  (env ()))
	'((app
   regex-match
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app
       cons
       (app
        cons
        'rep
        (app
         cons
         (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
         (app nil)))
       (app nil))))
    <-)
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((app d/dc (-> 'baz <-) 'f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cadr <-) re) (env (())))
clos/con:
	'((letrec* (... debug-trace (cadr (-> (λ (p) ...) <-)) caddr ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f <-) (app cadr re)) (env (())))
clos/con:
	'((app match-rep re (-> (λ (pat) ...) <-)) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app regex-rep? re) ((#f) (-> (app #f) <-)) _) (env (())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app regex-rep? re) <-) (#f) _) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-rep? (-> re <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app
   d/dc
   (->
    (app
     cons
     'alt
     (app
      cons
      (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
      (app
       cons
       (app
        cons
        'seq
        (app
         cons
         'foo
         (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
       (app nil))))
    <-)
   'foo)
  (env ()))
	'((app
   d/dc
   (-> (app cons 'seq (app cons 'foo (app cons 'barn (app nil)))) <-)
   'foo)
  (env ()))
	'((app
   regex-match
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app
       cons
       (app
        cons
        'rep
        (app
         cons
         (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
         (app nil)))
       (app nil))))
    <-)
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((app d/dc (-> 'baz <-) 'f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-rep? <-) re) (env (())))
clos/con:
	'((letrec*
   (... regex-seq? (regex-rep? (-> (λ (re) ...) <-)) regex-null? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

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
literals: '(⊥ ⊥ ⊥)

'(query: (λ (re f) (-> (match (app regex-alt? re) ...) <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-alt? re)
   (#f)
   (_ (-> (match (app f (app cadr re) (app caddr re)) ...) <-)))
  (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app f (app cadr re) (app caddr re)) (#f) (_ (-> (app #t) <-)))
  (env (())))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app f (app cadr re) (app caddr re)) ((#f) (-> (app #f) <-)) _)
  (env (())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _)
  (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
   _)
  (env (())))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
   _)
  (env (())))
	'((match
   (app regex-null? pat2)
   ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
   _)
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app f (app cadr re) (-> (app caddr re) <-)) (env (())))
clos/con:
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app caddr (-> re <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app
   d/dc
   (->
    (app
     cons
     'alt
     (app
      cons
      (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
      (app
       cons
       (app
        cons
        'seq
        (app
         cons
         'foo
         (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
       (app nil))))
    <-)
   'foo)
  (env ()))
	'((app
   d/dc
   (-> (app cons 'seq (app cons 'foo (app cons 'barn (app nil)))) <-)
   'foo)
  (env ()))
	'((app
   regex-match
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app
       cons
       (app
        cons
        'rep
        (app
         cons
         (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
         (app nil)))
       (app nil))))
    <-)
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((app d/dc (-> 'baz <-) 'f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> caddr <-) re) (env (())))
clos/con:
	'((letrec* (... cadr (caddr (-> (λ (p) ...) <-)) regex-NULL ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f (-> (app cadr re) <-) (app caddr re)) (env (())))
clos/con:
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cadr (-> re <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app
   d/dc
   (->
    (app
     cons
     'alt
     (app
      cons
      (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
      (app
       cons
       (app
        cons
        'seq
        (app
         cons
         'foo
         (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
       (app nil))))
    <-)
   'foo)
  (env ()))
	'((app
   d/dc
   (-> (app cons 'seq (app cons 'foo (app cons 'barn (app nil)))) <-)
   'foo)
  (env ()))
	'((app
   regex-match
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app
       cons
       (app
        cons
        'rep
        (app
         cons
         (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
         (app nil)))
       (app nil))))
    <-)
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((app d/dc (-> 'baz <-) 'f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cadr <-) re) (env (())))
clos/con:
	'((letrec* (... debug-trace (cadr (-> (λ (p) ...) <-)) caddr ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f <-) (app cadr re) (app caddr re)) (env (())))
clos/con:
	'((app match-alt re (-> (λ (pat1 pat2) ...) <-)) (env (())))
	'((app match-alt re (-> (λ (pat1 pat2) ...) <-)) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app regex-alt? re) ((#f) (-> (app #f) <-)) _) (env (())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app regex-alt? re) <-) (#f) _) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-alt? (-> re <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app
   d/dc
   (->
    (app
     cons
     'alt
     (app
      cons
      (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
      (app
       cons
       (app
        cons
        'seq
        (app
         cons
         'foo
         (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
       (app nil))))
    <-)
   'foo)
  (env ()))
	'((app
   d/dc
   (-> (app cons 'seq (app cons 'foo (app cons 'barn (app nil)))) <-)
   'foo)
  (env ()))
	'((app
   regex-match
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app
       cons
       (app
        cons
        'rep
        (app
         cons
         (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
         (app nil)))
       (app nil))))
    <-)
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((app d/dc (-> 'baz <-) 'f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-alt? <-) re) (env (())))
clos/con:
	'((letrec*
   (... regex-BLANK (regex-alt? (-> (λ (re) ...) <-)) regex-seq? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

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
literals: '(⊥ ⊥ ⊥)

'(query: (λ (re f) (-> (match (app regex-seq? re) ...) <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-seq? re)
   (#f)
   (_ (-> (match (app f (app cadr re) (app caddr re)) ...) <-)))
  (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app f (app cadr re) (app caddr re)) (#f) (_ (-> (app #t) <-)))
  (env (())))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app f (app cadr re) (app caddr re)) ((#f) (-> (app #f) <-)) _)
  (env (())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _)
  (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
   _)
  (env (())))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
   _)
  (env (())))
	'((match
   (app regex-null? pat2)
   ((#f) (-> (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))) <-))
   _)
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app f (app cadr re) (-> (app caddr re) <-)) (env (())))
clos/con:
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app caddr (-> re <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app
   d/dc
   (->
    (app
     cons
     'alt
     (app
      cons
      (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
      (app
       cons
       (app
        cons
        'seq
        (app
         cons
         'foo
         (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
       (app nil))))
    <-)
   'foo)
  (env ()))
	'((app
   d/dc
   (-> (app cons 'seq (app cons 'foo (app cons 'barn (app nil)))) <-)
   'foo)
  (env ()))
	'((app
   regex-match
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app
       cons
       (app
        cons
        'rep
        (app
         cons
         (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
         (app nil)))
       (app nil))))
    <-)
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((app d/dc (-> 'baz <-) 'f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> caddr <-) re) (env (())))
clos/con:
	'((letrec* (... cadr (caddr (-> (λ (p) ...) <-)) regex-NULL ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f (-> (app cadr re) <-) (app caddr re)) (env (())))
clos/con:
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cadr (-> re <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app
   d/dc
   (->
    (app
     cons
     'alt
     (app
      cons
      (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
      (app
       cons
       (app
        cons
        'seq
        (app
         cons
         'foo
         (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
       (app nil))))
    <-)
   'foo)
  (env ()))
	'((app
   d/dc
   (-> (app cons 'seq (app cons 'foo (app cons 'barn (app nil)))) <-)
   'foo)
  (env ()))
	'((app
   regex-match
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app
       cons
       (app
        cons
        'rep
        (app
         cons
         (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
         (app nil)))
       (app nil))))
    <-)
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((app d/dc (-> 'baz <-) 'f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cadr <-) re) (env (())))
clos/con:
	'((letrec* (... debug-trace (cadr (-> (λ (p) ...) <-)) caddr ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f <-) (app cadr re) (app caddr re)) (env (())))
clos/con:
	'((app match-seq re (-> (λ (pat1 pat2) ...) <-)) (env (())))
	'((app match-seq re (-> (λ (pat1 pat2) ...) <-)) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app regex-seq? re) ((#f) (-> (app #f) <-)) _) (env (())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app regex-seq? re) <-) (#f) _) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-seq? (-> re <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app
   d/dc
   (->
    (app
     cons
     'alt
     (app
      cons
      (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
      (app
       cons
       (app
        cons
        'seq
        (app
         cons
         'foo
         (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
       (app nil))))
    <-)
   'foo)
  (env ()))
	'((app
   d/dc
   (-> (app cons 'seq (app cons 'foo (app cons 'barn (app nil)))) <-)
   'foo)
  (env ()))
	'((app
   regex-match
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app
       cons
       (app
        cons
        'rep
        (app
         cons
         (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
         (app nil)))
       (app nil))))
    <-)
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((app d/dc (-> 'baz <-) 'f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-seq? <-) re) (env (())))
clos/con:
	'((letrec*
   (... regex-alt? (regex-seq? (-> (λ (re) ...) <-)) regex-rep? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

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
literals: '(⊥ ⊥ ⊥)

'(query: (λ (re) (-> (match (app char? re) ...) <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app char? re) (#f) (_ (-> (app #t) <-))) (env (())))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app char? re) ((#f) (-> (match (app symbol? re) ...) <-)) _)
  (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app symbol? re) (#f) (_ (-> (app #t) <-))) (env (())))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app symbol? re) ((#f) (-> (app #f) <-)) _) (env (())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app symbol? re) <-) (#f) _) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app symbol? (-> re <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app
   d/dc
   (->
    (app
     cons
     'alt
     (app
      cons
      (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
      (app
       cons
       (app
        cons
        'seq
        (app
         cons
         'foo
         (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
       (app nil))))
    <-)
   'foo)
  (env ()))
	'((app
   d/dc
   (-> (app cons 'seq (app cons 'foo (app cons 'barn (app nil)))) <-)
   'foo)
  (env ()))
	'((app
   regex-match
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app
       cons
       (app
        cons
        'rep
        (app
         cons
         (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
         (app nil)))
       (app nil))))
    <-)
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((app d/dc (-> 'baz <-) 'f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> symbol? <-) re) (env (())))
clos/con:
	'((prim symbol?) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app char? re) <-) (#f) _) (env (())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app char? (-> re <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app
   d/dc
   (->
    (app
     cons
     'alt
     (app
      cons
      (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
      (app
       cons
       (app
        cons
        'seq
        (app
         cons
         'foo
         (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
       (app nil))))
    <-)
   'foo)
  (env ()))
	'((app
   d/dc
   (-> (app cons 'seq (app cons 'foo (app cons 'barn (app nil)))) <-)
   'foo)
  (env ()))
	'((app
   regex-match
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app
       cons
       (app
        cons
        'rep
        (app
         cons
         (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
         (app nil)))
       (app nil))))
    <-)
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((app d/dc (-> 'baz <-) 'f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> char? <-) re) (env (())))
clos/con:
	'((prim char?) (env ()))
literals: '(⊥ ⊥ ⊥)

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
literals: '(⊥ ⊥ ⊥)

'(query: (λ (re) (-> (app eq? re (app #t)) <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app eq? re (-> (app #t) <-)) (env (())))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app eq? (-> re <-) (app #t)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app
   d/dc
   (->
    (app
     cons
     'alt
     (app
      cons
      (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
      (app
       cons
       (app
        cons
        'seq
        (app
         cons
         'foo
         (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
       (app nil))))
    <-)
   'foo)
  (env ()))
	'((app
   d/dc
   (-> (app cons 'seq (app cons 'foo (app cons 'barn (app nil)))) <-)
   'foo)
  (env ()))
	'((app
   regex-match
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app
       cons
       (app
        cons
        'rep
        (app
         cons
         (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
         (app nil)))
       (app nil))))
    <-)
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((app d/dc (-> 'baz <-) 'f) (env ()))
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
   _)
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> eq? <-) re (app #t)) (env (())))
clos/con:
	'((prim eq?) (env ()))
literals: '(⊥ ⊥ ⊥)

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
literals: '(⊥ ⊥ ⊥)

'(query: (λ (re) (-> (app eq? re (app #f)) <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app eq? re (-> (app #f) <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app eq? (-> re <-) (app #f)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app
   d/dc
   (->
    (app
     cons
     'alt
     (app
      cons
      (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
      (app
       cons
       (app
        cons
        'seq
        (app
         cons
         'foo
         (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
       (app nil))))
    <-)
   'foo)
  (env ()))
	'((app
   d/dc
   (-> (app cons 'seq (app cons 'foo (app cons 'barn (app nil)))) <-)
   'foo)
  (env ()))
	'((app
   regex-match
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app
       cons
       (app
        cons
        'rep
        (app
         cons
         (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
         (app nil)))
       (app nil))))
    <-)
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((app d/dc (-> 'baz <-) 'f) (env ()))
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil))) <-))
   _)
  (env (())))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))) <-))
   _)
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> eq? <-) re (app #f)) (env (())))
clos/con:
	'((prim eq?) (env ()))
literals: '(⊥ ⊥ ⊥)

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
literals: '(⊥ ⊥ ⊥)

'(query: (λ (re) (-> (match (app pair? re) ...) <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app pair? re)
   (#f)
   (_ (-> (match (app eq? (app car re) 'rep) ...) <-)))
  (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app eq? (app car re) 'rep) (#f) (_ (-> (app #t) <-)))
  (env (())))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app eq? (app car re) 'rep) ((#f) (-> (app #f) <-)) _)
  (env (())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app eq? (app car re) 'rep) <-) (#f) _) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app eq? (app car re) (-> 'rep <-)) (env (())))
clos/con:
	'((app eq? (app car re) (-> 'rep <-)) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app eq? (-> (app car re) <-) 'rep) (env (())))
clos/con:
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app car (-> re <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app
   d/dc
   (->
    (app
     cons
     'alt
     (app
      cons
      (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
      (app
       cons
       (app
        cons
        'seq
        (app
         cons
         'foo
         (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
       (app nil))))
    <-)
   'foo)
  (env ()))
	'((app
   d/dc
   (-> (app cons 'seq (app cons 'foo (app cons 'barn (app nil)))) <-)
   'foo)
  (env ()))
	'((app
   regex-match
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app
       cons
       (app
        cons
        'rep
        (app
         cons
         (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
         (app nil)))
       (app nil))))
    <-)
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((app d/dc (-> 'baz <-) 'f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> car <-) re) (env (())))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> eq? <-) (app car re) 'rep) (env (())))
clos/con:
	'((prim eq?) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app pair? re) ((#f) (-> (app #f) <-)) _) (env (())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app pair? re) <-) (#f) _) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app pair? (-> re <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app
   d/dc
   (->
    (app
     cons
     'alt
     (app
      cons
      (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
      (app
       cons
       (app
        cons
        'seq
        (app
         cons
         'foo
         (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
       (app nil))))
    <-)
   'foo)
  (env ()))
	'((app
   d/dc
   (-> (app cons 'seq (app cons 'foo (app cons 'barn (app nil)))) <-)
   'foo)
  (env ()))
	'((app
   regex-match
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app
       cons
       (app
        cons
        'rep
        (app
         cons
         (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
         (app nil)))
       (app nil))))
    <-)
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((app d/dc (-> 'baz <-) 'f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> pair? <-) re) (env (())))
clos/con:
	'((letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

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
literals: '(⊥ ⊥ ⊥)

'(query: (λ (re) (-> (match (app pair? re) ...) <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app pair? re)
   (#f)
   (_ (-> (match (app eq? (app car re) 'seq) ...) <-)))
  (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app eq? (app car re) 'seq) (#f) (_ (-> (app #t) <-)))
  (env (())))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app eq? (app car re) 'seq) ((#f) (-> (app #f) <-)) _)
  (env (())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app eq? (app car re) 'seq) <-) (#f) _) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app eq? (app car re) (-> 'seq <-)) (env (())))
clos/con:
	'((app eq? (app car re) (-> 'seq <-)) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app eq? (-> (app car re) <-) 'seq) (env (())))
clos/con:
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app car (-> re <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app
   d/dc
   (->
    (app
     cons
     'alt
     (app
      cons
      (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
      (app
       cons
       (app
        cons
        'seq
        (app
         cons
         'foo
         (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
       (app nil))))
    <-)
   'foo)
  (env ()))
	'((app
   d/dc
   (-> (app cons 'seq (app cons 'foo (app cons 'barn (app nil)))) <-)
   'foo)
  (env ()))
	'((app
   regex-match
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app
       cons
       (app
        cons
        'rep
        (app
         cons
         (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
         (app nil)))
       (app nil))))
    <-)
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((app d/dc (-> 'baz <-) 'f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> car <-) re) (env (())))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> eq? <-) (app car re) 'seq) (env (())))
clos/con:
	'((prim eq?) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app pair? re) ((#f) (-> (app #f) <-)) _) (env (())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app pair? re) <-) (#f) _) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app pair? (-> re <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app
   d/dc
   (->
    (app
     cons
     'alt
     (app
      cons
      (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
      (app
       cons
       (app
        cons
        'seq
        (app
         cons
         'foo
         (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
       (app nil))))
    <-)
   'foo)
  (env ()))
	'((app
   d/dc
   (-> (app cons 'seq (app cons 'foo (app cons 'barn (app nil)))) <-)
   'foo)
  (env ()))
	'((app
   regex-match
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app
       cons
       (app
        cons
        'rep
        (app
         cons
         (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
         (app nil)))
       (app nil))))
    <-)
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((app d/dc (-> 'baz <-) 'f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> pair? <-) re) (env (())))
clos/con:
	'((letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

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
literals: '(⊥ ⊥ ⊥)

'(query: (λ (re) (-> (match (app pair? re) ...) <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app pair? re)
   (#f)
   (_ (-> (match (app eq? (app car re) 'alt) ...) <-)))
  (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app eq? (app car re) 'alt) (#f) (_ (-> (app #t) <-)))
  (env (())))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app eq? (app car re) 'alt) ((#f) (-> (app #f) <-)) _)
  (env (())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app eq? (app car re) 'alt) <-) (#f) _) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app eq? (app car re) (-> 'alt <-)) (env (())))
clos/con:
	'((app eq? (app car re) (-> 'alt <-)) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app eq? (-> (app car re) <-) 'alt) (env (())))
clos/con:
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app car (-> re <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app
   d/dc
   (->
    (app
     cons
     'alt
     (app
      cons
      (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
      (app
       cons
       (app
        cons
        'seq
        (app
         cons
         'foo
         (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
       (app nil))))
    <-)
   'foo)
  (env ()))
	'((app
   d/dc
   (-> (app cons 'seq (app cons 'foo (app cons 'barn (app nil)))) <-)
   'foo)
  (env ()))
	'((app
   regex-match
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app
       cons
       (app
        cons
        'rep
        (app
         cons
         (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
         (app nil)))
       (app nil))))
    <-)
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((app d/dc (-> 'baz <-) 'f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> car <-) re) (env (())))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> eq? <-) (app car re) 'alt) (env (())))
clos/con:
	'((prim eq?) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app pair? re) ((#f) (-> (app #f) <-)) _) (env (())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app pair? re) <-) (#f) _) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app pair? (-> re <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app
   d/dc
   (->
    (app
     cons
     'alt
     (app
      cons
      (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
      (app
       cons
       (app
        cons
        'seq
        (app
         cons
         'foo
         (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
       (app nil))))
    <-)
   'foo)
  (env ()))
	'((app
   d/dc
   (-> (app cons 'seq (app cons 'foo (app cons 'barn (app nil)))) <-)
   'foo)
  (env ()))
	'((app
   regex-match
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app
       cons
       (app
        cons
        'rep
        (app
         cons
         (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
         (app nil)))
       (app nil))))
    <-)
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((app d/dc (-> 'baz <-) 'f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> pair? <-) re) (env (())))
clos/con:
	'((letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... regex-NULL (regex-BLANK (-> (app #t) <-)) regex-alt? ...) ...)
  (env ()))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ()))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... caddr (regex-NULL (-> (app #f) <-)) regex-BLANK ...) ...)
  (env ()))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ()))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... cadr (caddr (-> (λ (p) ...) <-)) regex-NULL ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cadr (caddr (-> (λ (p) ...) <-)) regex-NULL ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (p) (-> (app car (app cdr (app cdr p))) <-)) (env (())))
clos/con:
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app car (-> (app cdr (app cdr p)) <-)) (env (())))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   cons
   'alt
   (->
    (app
     cons
     (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
     (app
      cons
      (app
       cons
       'seq
       (app
        cons
        'foo
        (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
      (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'bar
   (-> (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))) <-))
  (env ()))
	'((app
   cons
   'bar
   (-> (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))) <-))
  (env ()))
	'((app
   cons
   'foo
   (->
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))
    <-))
  (env ()))
	'((app
   cons
   'foo
   (->
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
    <-))
  (env ()))
	'((app
   cons
   'foo
   (->
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
    <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))) <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)) <-))
  (env ()))
	'((app
   cons
   'rep
   (->
    (app
     cons
     (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
     (app nil))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app
      cons
      (app
       cons
       'rep
       (app
        cons
        (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
        (app nil)))
      (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
    <-))
  (env ()))
	'((app
   cons
   (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
   (->
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))
    <-))
  (env ()))
	'((app cons 'alt (-> (app cons 'bar (app cons 'baz (app nil))) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'baz (app nil)) <-)) (env ()))
	'((app cons 'baz (-> (app cons 'bar (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'baz (-> (app cons 'bar (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'foo (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'foo (-> (app cons 'barn (app nil)) <-)) (env ()))
	'((app cons 'rep (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'rep (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'rep (-> (app cons 'baz (app nil)) <-)) (env ()))
	'((app cons 'seq (-> (app cons 'foo (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'seq (-> (app cons 'foo (app cons 'barn (app nil))) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cdr (-> (app cdr p) <-)) (env (())))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   cons
   'alt
   (->
    (app
     cons
     (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
     (app
      cons
      (app
       cons
       'seq
       (app
        cons
        'foo
        (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
      (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'bar
   (-> (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))) <-))
  (env ()))
	'((app
   cons
   'bar
   (-> (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))) <-))
  (env ()))
	'((app
   cons
   'foo
   (->
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))
    <-))
  (env ()))
	'((app
   cons
   'foo
   (->
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
    <-))
  (env ()))
	'((app
   cons
   'foo
   (->
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
    <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))) <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)) <-))
  (env ()))
	'((app
   cons
   'rep
   (->
    (app
     cons
     (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
     (app nil))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app
      cons
      (app
       cons
       'rep
       (app
        cons
        (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
        (app nil)))
      (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
    <-))
  (env ()))
	'((app
   cons
   (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
   (->
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))
    <-))
  (env ()))
	'((app cons 'alt (-> (app cons 'bar (app cons 'baz (app nil))) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'baz (app nil)) <-)) (env ()))
	'((app cons 'baz (-> (app cons 'bar (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'baz (-> (app cons 'bar (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'foo (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'foo (-> (app cons 'barn (app nil)) <-)) (env ()))
	'((app cons 'rep (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'rep (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'rep (-> (app cons 'baz (app nil)) <-)) (env ()))
	'((app cons 'seq (-> (app cons 'foo (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'seq (-> (app cons 'foo (app cons 'barn (app nil))) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cdr (-> p <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app
   d/dc
   (->
    (app
     cons
     'alt
     (app
      cons
      (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
      (app
       cons
       (app
        cons
        'seq
        (app
         cons
         'foo
         (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
       (app nil))))
    <-)
   'foo)
  (env ()))
	'((app
   d/dc
   (-> (app cons 'seq (app cons 'foo (app cons 'barn (app nil)))) <-)
   'foo)
  (env ()))
	'((app
   regex-match
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app
       cons
       (app
        cons
        'rep
        (app
         cons
         (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
         (app nil)))
       (app nil))))
    <-)
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((app d/dc (-> 'baz <-) 'f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cdr <-) p) (env (())))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cdr <-) (app cdr p)) (env (())))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> car <-) (app cdr (app cdr p))) (env (())))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... debug-trace (cadr (-> (λ (p) ...) <-)) caddr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... debug-trace (cadr (-> (λ (p) ...) <-)) caddr ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (p) (-> (app car (app cdr p)) <-)) (env (())))
clos/con:
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app car (-> (app cdr p) <-)) (env (())))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   cons
   'alt
   (->
    (app
     cons
     (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
     (app
      cons
      (app
       cons
       'seq
       (app
        cons
        'foo
        (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
      (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'bar
   (-> (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))) <-))
  (env ()))
	'((app
   cons
   'bar
   (-> (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))) <-))
  (env ()))
	'((app
   cons
   'foo
   (->
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))
    <-))
  (env ()))
	'((app
   cons
   'foo
   (->
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
    <-))
  (env ()))
	'((app
   cons
   'foo
   (->
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
    <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))) <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)) <-))
  (env ()))
	'((app
   cons
   'rep
   (->
    (app
     cons
     (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
     (app nil))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app
      cons
      (app
       cons
       'rep
       (app
        cons
        (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
        (app nil)))
      (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
    <-))
  (env ()))
	'((app
   cons
   (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
   (->
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))
    <-))
  (env ()))
	'((app cons 'alt (-> (app cons 'bar (app cons 'baz (app nil))) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'baz (app nil)) <-)) (env ()))
	'((app cons 'baz (-> (app cons 'bar (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'baz (-> (app cons 'bar (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'foo (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'foo (-> (app cons 'barn (app nil)) <-)) (env ()))
	'((app cons 'rep (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'rep (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'rep (-> (app cons 'baz (app nil)) <-)) (env ()))
	'((app cons 'seq (-> (app cons 'foo (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'seq (-> (app cons 'foo (app cons 'barn (app nil))) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cdr (-> p <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app
   d/dc
   (->
    (app
     cons
     'alt
     (app
      cons
      (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
      (app
       cons
       (app
        cons
        'seq
        (app
         cons
         'foo
         (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
       (app nil))))
    <-)
   'foo)
  (env ()))
	'((app
   d/dc
   (-> (app cons 'seq (app cons 'foo (app cons 'barn (app nil)))) <-)
   'foo)
  (env ()))
	'((app
   regex-match
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app
       cons
       (app
        cons
        'rep
        (app
         cons
         (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
         (app nil)))
       (app nil))))
    <-)
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((app d/dc (-> 'baz <-) 'f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cdr <-) p) (env (())))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> car <-) (app cdr p)) (env (())))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... null? (debug-trace (-> (λ () ...) <-)) cadr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... null? (debug-trace (-> (λ () ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ () (-> 'do-nothing <-)) (env (())))
clos/con:
	'((λ () (-> 'do-nothing <-)) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) debug-trace ...) ...)
  (env ()))
clos/con:
	'((letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) debug-trace ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (null?-v) (-> (match null?-v ...) <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match null?-v (nil) (_ (-> (app #f) <-))) (env (())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match null?-v ((nil) (-> (app #t) <-)) _) (env (())))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> null?-v <-) (nil) _) (env (())))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   cons
   'alt
   (->
    (app
     cons
     (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
     (app
      cons
      (app
       cons
       'seq
       (app
        cons
        'foo
        (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
      (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'bar
   (-> (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))) <-))
  (env ()))
	'((app
   cons
   'bar
   (-> (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))) <-))
  (env ()))
	'((app
   cons
   'foo
   (->
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))
    <-))
  (env ()))
	'((app
   cons
   'foo
   (->
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
    <-))
  (env ()))
	'((app
   cons
   'foo
   (->
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
    <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))) <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)) <-))
  (env ()))
	'((app
   cons
   'rep
   (->
    (app
     cons
     (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
     (app nil))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app
      cons
      (app
       cons
       'rep
       (app
        cons
        (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
        (app nil)))
      (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
    <-))
  (env ()))
	'((app
   cons
   (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
   (->
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))
    <-))
  (env ()))
	'((app
   regex-match
   (app
    cons
    'seq
    (app
     cons
     'foo
     (app
      cons
      (app
       cons
       'rep
       (app
        cons
        (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
        (app nil)))
      (app nil))))
   (->
    (app
     cons
     'foo
     (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
    <-))
  (env ()))
	'((app
   regex-match
   (app
    cons
    'seq
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
   (->
    (app
     cons
     'foo
     (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
    <-))
  (env ()))
	'((app
   regex-match
   (app
    cons
    'seq
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
   (->
    (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
    <-))
  (env ()))
	'((app cons 'alt (-> (app cons 'bar (app cons 'baz (app nil))) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'baz (app nil)) <-)) (env ()))
	'((app cons 'baz (-> (app cons 'bar (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'baz (-> (app cons 'bar (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'foo (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'foo (-> (app cons 'barn (app nil)) <-)) (env ()))
	'((app cons 'rep (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'rep (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'rep (-> (app cons 'baz (app nil)) <-)) (env ()))
	'((app cons 'seq (-> (app cons 'foo (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'seq (-> (app cons 'foo (app cons 'barn (app nil))) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...) (env ()))
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
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app
   d/dc
   (->
    (app
     cons
     'alt
     (app
      cons
      (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
      (app
       cons
       (app
        cons
        'seq
        (app
         cons
         'foo
         (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
       (app nil))))
    <-)
   'foo)
  (env ()))
	'((app
   d/dc
   (-> (app cons 'seq (app cons 'foo (app cons 'barn (app nil)))) <-)
   'foo)
  (env ()))
	'((app
   regex-match
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app
       cons
       (app
        cons
        'rep
        (app
         cons
         (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
         (app nil)))
       (app nil))))
    <-)
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((app d/dc (-> 'baz <-) 'f) (env ()))
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
	'((app
   cons
   'alt
   (->
    (app
     cons
     (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
     (app
      cons
      (app
       cons
       'seq
       (app
        cons
        'foo
        (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
      (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'bar
   (-> (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))) <-))
  (env ()))
	'((app
   cons
   'bar
   (-> (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))) <-))
  (env ()))
	'((app
   cons
   'foo
   (->
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))
    <-))
  (env ()))
	'((app
   cons
   'foo
   (->
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
    <-))
  (env ()))
	'((app
   cons
   'foo
   (->
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
    <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))) <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)) <-))
  (env ()))
	'((app
   cons
   'rep
   (->
    (app
     cons
     (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
     (app nil))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app
      cons
      (app
       cons
       'rep
       (app
        cons
        (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
        (app nil)))
      (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
    <-))
  (env ()))
	'((app
   cons
   (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
   (->
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))
    <-))
  (env ()))
	'((app cons 'alt (-> (app cons 'bar (app cons 'baz (app nil))) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'baz (app nil)) <-)) (env ()))
	'((app cons 'baz (-> (app cons 'bar (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'baz (-> (app cons 'bar (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'foo (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'foo (-> (app cons 'barn (app nil)) <-)) (env ()))
	'((app cons 'rep (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'rep (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'rep (-> (app cons 'baz (app nil)) <-)) (env ()))
	'((app cons 'seq (-> (app cons 'foo (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'seq (-> (app cons 'foo (app cons 'barn (app nil))) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-))) (env (())))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   cons
   'alt
   (->
    (app
     cons
     (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
     (app
      cons
      (app
       cons
       'seq
       (app
        cons
        'foo
        (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
      (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'bar
   (-> (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))) <-))
  (env ()))
	'((app
   cons
   'bar
   (-> (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))) <-))
  (env ()))
	'((app
   cons
   'foo
   (->
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))
    <-))
  (env ()))
	'((app
   cons
   'foo
   (->
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
    <-))
  (env ()))
	'((app
   cons
   'foo
   (->
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
    <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))) <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)) <-))
  (env ()))
	'((app
   cons
   'rep
   (->
    (app
     cons
     (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
     (app nil))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app
      cons
      (app
       cons
       'rep
       (app
        cons
        (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
        (app nil)))
      (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
    <-))
  (env ()))
	'((app
   cons
   (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
   (->
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))
    <-))
  (env ()))
	'((app cons 'alt (-> (app cons 'bar (app cons 'baz (app nil))) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'baz (app nil)) <-)) (env ()))
	'((app cons 'baz (-> (app cons 'bar (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'baz (-> (app cons 'bar (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'foo (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'foo (-> (app cons 'barn (app nil)) <-)) (env ()))
	'((app cons 'rep (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'rep (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'rep (-> (app cons 'baz (app nil)) <-)) (env ()))
	'((app cons 'seq (-> (app cons 'foo (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'seq (-> (app cons 'foo (app cons 'barn (app nil))) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> cdr-v <-) (cons cdr-c cdr-d)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'(((top) app nil) (env ()))
	'((app
   cons
   'alt
   (->
    (app
     cons
     (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
     (app
      cons
      (app
       cons
       'seq
       (app
        cons
        'foo
        (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
      (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'bar
   (-> (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))) <-))
  (env ()))
	'((app
   cons
   'bar
   (-> (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))) <-))
  (env ()))
	'((app
   cons
   'foo
   (->
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))
    <-))
  (env ()))
	'((app
   cons
   'foo
   (->
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
    <-))
  (env ()))
	'((app
   cons
   'foo
   (->
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
    <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))) <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)) <-))
  (env ()))
	'((app
   cons
   'rep
   (->
    (app
     cons
     (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
     (app nil))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app
      cons
      (app
       cons
       'rep
       (app
        cons
        (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
        (app nil)))
      (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
    <-))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
   (->
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))
    <-))
  (env ()))
	'((app
   d/dc
   (->
    (app
     cons
     'alt
     (app
      cons
      (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
      (app
       cons
       (app
        cons
        'seq
        (app
         cons
         'foo
         (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
       (app nil))))
    <-)
   'foo)
  (env ()))
	'((app
   d/dc
   (-> (app cons 'seq (app cons 'foo (app cons 'barn (app nil)))) <-)
   'foo)
  (env ()))
	'((app
   regex-match
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app
       cons
       (app
        cons
        'rep
        (app
         cons
         (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
         (app nil)))
       (app nil))))
    <-)
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   regex-match
   (app
    cons
    'seq
    (app
     cons
     'foo
     (app
      cons
      (app
       cons
       'rep
       (app
        cons
        (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
        (app nil)))
      (app nil))))
   (->
    (app
     cons
     'foo
     (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
    <-))
  (env ()))
	'((app
   regex-match
   (app
    cons
    'seq
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
   (->
    (app
     cons
     'foo
     (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
    <-))
  (env ()))
	'((app
   regex-match
   (app
    cons
    'seq
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
   (->
    (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
    <-))
  (env ()))
	'((app cons 'alt (-> (app cons 'bar (app cons 'baz (app nil))) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'baz (app nil)) <-)) (env ()))
	'((app cons 'baz (-> (app cons 'bar (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'baz (-> (app cons 'bar (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'foo (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'foo (-> (app cons 'barn (app nil)) <-)) (env ()))
	'((app cons 'rep (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'rep (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'rep (-> (app cons 'baz (app nil)) <-)) (env ()))
	'((app cons 'seq (-> (app cons 'foo (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'seq (-> (app cons 'foo (app cons 'barn (app nil))) <-)) (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((app d/dc (-> 'baz <-) 'f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (car-v) (-> (match car-v ...) <-)) (env (())))
clos/con:
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match car-v ((cons car-c car-d) (-> car-c <-))) (env (())))
clos/con:
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> car-v <-) (cons car-c car-d)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'(((top) app nil) (env ()))
	'((app
   cons
   'alt
   (->
    (app
     cons
     (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
     (app
      cons
      (app
       cons
       'seq
       (app
        cons
        'foo
        (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
      (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'bar
   (-> (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))) <-))
  (env ()))
	'((app
   cons
   'bar
   (-> (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))) <-))
  (env ()))
	'((app
   cons
   'foo
   (->
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))
    <-))
  (env ()))
	'((app
   cons
   'foo
   (->
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
    <-))
  (env ()))
	'((app
   cons
   'foo
   (->
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
    <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))) <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-))
  (env ()))
	'((app
   cons
   'foo
   (-> (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)) <-))
  (env ()))
	'((app
   cons
   'rep
   (->
    (app
     cons
     (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
     (app nil))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app
      cons
      (app
       cons
       'rep
       (app
        cons
        (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
        (app nil)))
      (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
    <-))
  (env ()))
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
    <-))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
	'((app
   cons
   (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
   (->
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))
    <-))
  (env ()))
	'((app
   d/dc
   (->
    (app
     cons
     'alt
     (app
      cons
      (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
      (app
       cons
       (app
        cons
        'seq
        (app
         cons
         'foo
         (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
       (app nil))))
    <-)
   'foo)
  (env ()))
	'((app
   d/dc
   (-> (app cons 'seq (app cons 'foo (app cons 'barn (app nil)))) <-)
   'foo)
  (env ()))
	'((app
   regex-match
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app
       cons
       (app
        cons
        'rep
        (app
         cons
         (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
         (app nil)))
       (app nil))))
    <-)
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
	'((app
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
   (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
	'((app
   regex-match
   (app
    cons
    'seq
    (app
     cons
     'foo
     (app
      cons
      (app
       cons
       'rep
       (app
        cons
        (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
        (app nil)))
      (app nil))))
   (->
    (app
     cons
     'foo
     (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
    <-))
  (env ()))
	'((app
   regex-match
   (app
    cons
    'seq
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
   (->
    (app
     cons
     'foo
     (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
    <-))
  (env ()))
	'((app
   regex-match
   (app
    cons
    'seq
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
   (->
    (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
    <-))
  (env ()))
	'((app cons 'alt (-> (app cons 'bar (app cons 'baz (app nil))) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'bar (-> (app cons 'baz (app nil)) <-)) (env ()))
	'((app cons 'baz (-> (app cons 'bar (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'baz (-> (app cons 'bar (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'foo (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'foo (-> (app cons 'barn (app nil)) <-)) (env ()))
	'((app cons 'rep (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'rep (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'rep (-> (app cons 'baz (app nil)) <-)) (env ()))
	'((app cons 'seq (-> (app cons 'foo (app cons 'bar (app nil))) <-)) (env ()))
	'((app cons 'seq (-> (app cons 'foo (app cons 'barn (app nil))) <-)) (env ()))
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'barn <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'baz <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
	'((app d/dc (-> 'baz <-) 'f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (letrec* (car ... check-expect) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (...
        ()
        (_ (-> (app check-expect (app d/dc 'baz 'f) (app #f)) <-))
        ()
        ...)
    ...)
  (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app check-expect (app d/dc 'baz 'f) (-> (app #f) <-)) (env ()))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ()))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app check-expect (-> (app d/dc 'baz 'f) <-) (app #f)) (env ()))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app d/dc 'baz (-> 'f <-)) (env ()))
clos/con:
	'((app d/dc 'baz (-> 'f <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app d/dc (-> 'baz <-) 'f) (env ()))
clos/con:
	'((app d/dc (-> 'baz <-) 'f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> d/dc <-) 'baz 'f) (env ()))
clos/con:
	'((letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) d/dc ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> check-expect <-) (app d/dc 'baz 'f) (app #f)) (env ()))
clos/con:
	'((letrec*
   (... regex-match (check-expect (-> (λ (check expect) ...) <-)) () ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (...
        ()
        (_
         (->
          (app
           check-expect
           (app
            d/dc
            (app cons 'seq (app cons 'foo (app cons 'barn (app nil))))
            'foo)
           'barn)
          <-))
        ()
        ...)
    ...)
  (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   check-expect
   (app d/dc (app cons 'seq (app cons 'foo (app cons 'barn (app nil)))) 'foo)
   (-> 'barn <-))
  (env ()))
clos/con:
	'((app
   check-expect
   (app d/dc (app cons 'seq (app cons 'foo (app cons 'barn (app nil)))) 'foo)
   (-> 'barn <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   check-expect
   (->
    (app d/dc (app cons 'seq (app cons 'foo (app cons 'barn (app nil)))) 'foo)
    <-)
   'barn)
  (env ()))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   d/dc
   (app cons 'seq (app cons 'foo (app cons 'barn (app nil))))
   (-> 'foo <-))
  (env ()))
clos/con:
	'((app
   d/dc
   (app cons 'seq (app cons 'foo (app cons 'barn (app nil))))
   (-> 'foo <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   d/dc
   (-> (app cons 'seq (app cons 'foo (app cons 'barn (app nil)))) <-)
   'foo)
  (env ()))
clos/con:
	'((app
   d/dc
   (-> (app cons 'seq (app cons 'foo (app cons 'barn (app nil)))) <-)
   'foo)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons 'seq (-> (app cons 'foo (app cons 'barn (app nil))) <-))
  (env ()))
clos/con:
	'((app cons 'seq (-> (app cons 'foo (app cons 'barn (app nil))) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 'foo (-> (app cons 'barn (app nil)) <-)) (env ()))
clos/con:
	'((app cons 'foo (-> (app cons 'barn (app nil)) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 'barn (-> (app nil) <-)) (env ()))
clos/con:
	'(((top) app nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> 'barn <-) (app nil)) (env ()))
clos/con:
	'((app cons (-> 'barn <-) (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 'barn (app nil)) (env ()))
clos/con:
	'((app (-> cons <-) 'barn (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
clos/con:
	'((app cons (-> 'foo <-) (app cons 'barn (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 'foo (app cons 'barn (app nil))) (env ()))
clos/con:
	'((app (-> cons <-) 'foo (app cons 'barn (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil))))
  (env ()))
clos/con:
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'barn (app nil)))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> cons <-) 'seq (app cons 'foo (app cons 'barn (app nil))))
  (env ()))
clos/con:
	'((app (-> cons <-) 'seq (app cons 'foo (app cons 'barn (app nil)))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   (-> d/dc <-)
   (app cons 'seq (app cons 'foo (app cons 'barn (app nil))))
   'foo)
  (env ()))
clos/con:
	'((letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) d/dc ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   (-> check-expect <-)
   (app d/dc (app cons 'seq (app cons 'foo (app cons 'barn (app nil)))) 'foo)
   'barn)
  (env ()))
clos/con:
	'((letrec*
   (... regex-match (check-expect (-> (λ (check expect) ...) <-)) () ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (...
        ()
        (_
         (->
          (app
           check-expect
           (app
            d/dc
            (app
             cons
             'alt
             (app
              cons
              (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
              (app
               cons
               (app
                cons
                'seq
                (app
                 cons
                 'foo
                 (app
                  cons
                  (app cons 'rep (app cons 'baz (app nil)))
                  (app nil))))
               (app nil))))
            'foo)
           (app
            cons
            'alt
            (app
             cons
             'bar
             (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))))
          <-))
        ()
        ...)
    ...)
  (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   check-expect
   (app
    d/dc
    (app
     cons
     'alt
     (app
      cons
      (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
      (app
       cons
       (app
        cons
        'seq
        (app
         cons
         'foo
         (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
       (app nil))))
    'foo)
   (->
    (app
     cons
     'alt
     (app
      cons
      'bar
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-))
  (env ()))
clos/con:
	'((app
   check-expect
   (app
    d/dc
    (app
     cons
     'alt
     (app
      cons
      (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
      (app
       cons
       (app
        cons
        'seq
        (app
         cons
         'foo
         (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
       (app nil))))
    'foo)
   (->
    (app
     cons
     'alt
     (app
      cons
      'bar
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   'alt
   (->
    (app
     cons
     'bar
     (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
    <-))
  (env ()))
clos/con:
	'((app
   cons
   'alt
   (->
    (app
     cons
     'bar
     (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
    <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   'bar
   (-> (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)) <-))
  (env ()))
clos/con:
	'((app
   cons
   'bar
   (-> (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)) <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (app cons 'rep (app cons 'baz (app nil))) (-> (app nil) <-))
  (env ()))
clos/con:
	'(((top) app nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
clos/con:
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 'rep (-> (app cons 'baz (app nil)) <-)) (env ()))
clos/con:
	'((app cons 'rep (-> (app cons 'baz (app nil)) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 'baz (-> (app nil) <-)) (env ()))
clos/con:
	'(((top) app nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> 'baz <-) (app nil)) (env ()))
clos/con:
	'((app cons (-> 'baz <-) (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 'baz (app nil)) (env ()))
clos/con:
	'((app (-> cons <-) 'baz (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
clos/con:
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 'rep (app cons 'baz (app nil))) (env ()))
clos/con:
	'((app (-> cons <-) 'rep (app cons 'baz (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> cons <-) (app cons 'rep (app cons 'baz (app nil))) (app nil))
  (env ()))
clos/con:
	'((app (-> cons <-) (app cons 'rep (app cons 'baz (app nil))) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> 'bar <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
clos/con:
	'((app
   cons
   (-> 'bar <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   'bar
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
clos/con:
	'((app
   (-> cons <-)
   'bar
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> 'alt <-)
   (app
    cons
    'bar
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
clos/con:
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    'bar
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   'alt
   (app
    cons
    'bar
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
clos/con:
	'((app
   (-> cons <-)
   'alt
   (app
    cons
    'bar
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   check-expect
   (->
    (app
     d/dc
     (app
      cons
      'alt
      (app
       cons
       (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
       (app
        cons
        (app
         cons
         'seq
         (app
          cons
          'foo
          (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
        (app nil))))
     'foo)
    <-)
   (app
    cons
    'alt
    (app
     cons
     'bar
     (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))))
  (env ()))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   d/dc
   (app
    cons
    'alt
    (app
     cons
     (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
     (app
      cons
      (app
       cons
       'seq
       (app
        cons
        'foo
        (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
      (app nil))))
   (-> 'foo <-))
  (env ()))
clos/con:
	'((app
   d/dc
   (app
    cons
    'alt
    (app
     cons
     (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
     (app
      cons
      (app
       cons
       'seq
       (app
        cons
        'foo
        (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
      (app nil))))
   (-> 'foo <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   d/dc
   (->
    (app
     cons
     'alt
     (app
      cons
      (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
      (app
       cons
       (app
        cons
        'seq
        (app
         cons
         'foo
         (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
       (app nil))))
    <-)
   'foo)
  (env ()))
clos/con:
	'((app
   d/dc
   (->
    (app
     cons
     'alt
     (app
      cons
      (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
      (app
       cons
       (app
        cons
        'seq
        (app
         cons
         'foo
         (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
       (app nil))))
    <-)
   'foo)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   'alt
   (->
    (app
     cons
     (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
     (app
      cons
      (app
       cons
       'seq
       (app
        cons
        'foo
        (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
      (app nil)))
    <-))
  (env ()))
clos/con:
	'((app
   cons
   'alt
   (->
    (app
     cons
     (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
     (app
      cons
      (app
       cons
       'seq
       (app
        cons
        'foo
        (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
      (app nil)))
    <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
   (->
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))
    <-))
  (env ()))
clos/con:
	'((app
   cons
   (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
   (->
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))
    <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (app
    cons
    'seq
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
   (-> (app nil) <-))
  (env ()))
clos/con:
	'(((top) app nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
clos/con:
	'((app
   cons
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    <-)
   (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
    <-))
  (env ()))
clos/con:
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
    <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   'foo
   (-> (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)) <-))
  (env ()))
clos/con:
	'((app
   cons
   'foo
   (-> (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)) <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (app cons 'rep (app cons 'baz (app nil))) (-> (app nil) <-))
  (env ()))
clos/con:
	'(((top) app nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
clos/con:
	'((app cons (-> (app cons 'rep (app cons 'baz (app nil))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 'rep (-> (app cons 'baz (app nil)) <-)) (env ()))
clos/con:
	'((app cons 'rep (-> (app cons 'baz (app nil)) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 'baz (-> (app nil) <-)) (env ()))
clos/con:
	'(((top) app nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> 'baz <-) (app nil)) (env ()))
clos/con:
	'((app cons (-> 'baz <-) (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 'baz (app nil)) (env ()))
clos/con:
	'((app (-> cons <-) 'baz (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
clos/con:
	'((app cons (-> 'rep <-) (app cons 'baz (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 'rep (app cons 'baz (app nil))) (env ()))
clos/con:
	'((app (-> cons <-) 'rep (app cons 'baz (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> cons <-) (app cons 'rep (app cons 'baz (app nil))) (app nil))
  (env ()))
clos/con:
	'((app (-> cons <-) (app cons 'rep (app cons 'baz (app nil))) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   'foo
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
clos/con:
	'((app
   (-> cons <-)
   'foo
   (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
clos/con:
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   'seq
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
clos/con:
	'((app
   (-> cons <-)
   'seq
   (app
    cons
    'foo
    (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   (app
    cons
    'seq
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
   (app nil))
  (env ()))
clos/con:
	'((app
   (-> cons <-)
   (app
    cons
    'seq
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
   (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
clos/con:
	'((app
   cons
   (-> (app cons 'seq (app cons 'foo (app cons 'bar (app nil)))) <-)
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons 'seq (-> (app cons 'foo (app cons 'bar (app nil))) <-))
  (env ()))
clos/con:
	'((app cons 'seq (-> (app cons 'foo (app cons 'bar (app nil))) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 'foo (-> (app cons 'bar (app nil)) <-)) (env ()))
clos/con:
	'((app cons 'foo (-> (app cons 'bar (app nil)) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 'bar (-> (app nil) <-)) (env ()))
clos/con:
	'(((top) app nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> 'bar <-) (app nil)) (env ()))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 'bar (app nil)) (env ()))
clos/con:
	'((app (-> cons <-) 'bar (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
clos/con:
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 'foo (app cons 'bar (app nil))) (env ()))
clos/con:
	'((app (-> cons <-) 'foo (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil))))
  (env ()))
clos/con:
	'((app cons (-> 'seq <-) (app cons 'foo (app cons 'bar (app nil)))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> cons <-) 'seq (app cons 'foo (app cons 'bar (app nil))))
  (env ()))
clos/con:
	'((app (-> cons <-) 'seq (app cons 'foo (app cons 'bar (app nil)))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
clos/con:
	'((app
   (-> cons <-)
   (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
   (app
    cons
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
    (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
clos/con:
	'((app
   cons
   (-> 'alt <-)
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   'alt
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
clos/con:
	'((app
   (-> cons <-)
   'alt
   (app
    cons
    (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
    (app
     cons
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
     (app nil))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   (-> d/dc <-)
   (app
    cons
    'alt
    (app
     cons
     (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
     (app
      cons
      (app
       cons
       'seq
       (app
        cons
        'foo
        (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
      (app nil))))
   'foo)
  (env ()))
clos/con:
	'((letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) d/dc ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   (-> check-expect <-)
   (app
    d/dc
    (app
     cons
     'alt
     (app
      cons
      (app cons 'seq (app cons 'foo (app cons 'bar (app nil))))
      (app
       cons
       (app
        cons
        'seq
        (app
         cons
         'foo
         (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil))))
       (app nil))))
    'foo)
   (app
    cons
    'alt
    (app
     cons
     'bar
     (app cons (app cons 'rep (app cons 'baz (app nil))) (app nil)))))
  (env ()))
clos/con:
	'((letrec*
   (... regex-match (check-expect (-> (λ (check expect) ...) <-)) () ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (...
        ()
        (_
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
            (app
             cons
             'foo
             (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
           (app #t))
          <-))
        ()
        ...)
    ...)
  (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

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
    (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
   (-> (app #t) <-))
  (env ()))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ()))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

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
     (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
    <-)
   (app #t))
  (env ()))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

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
   (->
    (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
    <-))
  (env ()))
clos/con:
	'((app
   regex-match
   (app
    cons
    'seq
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
   (->
    (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
    <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   'foo
   (-> (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))) <-))
  (env ()))
clos/con:
	'((app
   cons
   'foo
   (-> (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))) <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons 'bar (-> (app cons 'bar (app cons 'bar (app nil))) <-))
  (env ()))
clos/con:
	'((app cons 'bar (-> (app cons 'bar (app cons 'bar (app nil))) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 'bar (-> (app cons 'bar (app nil)) <-)) (env ()))
clos/con:
	'((app cons 'bar (-> (app cons 'bar (app nil)) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 'bar (-> (app nil) <-)) (env ()))
clos/con:
	'(((top) app nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> 'bar <-) (app nil)) (env ()))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 'bar (app nil)) (env ()))
clos/con:
	'((app (-> cons <-) 'bar (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
clos/con:
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 'bar (app cons 'bar (app nil))) (env ()))
clos/con:
	'((app (-> cons <-) 'bar (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil))))
  (env ()))
clos/con:
	'((app cons (-> 'bar <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> cons <-) 'bar (app cons 'bar (app cons 'bar (app nil))))
  (env ()))
clos/con:
	'((app (-> cons <-) 'bar (app cons 'bar (app cons 'bar (app nil)))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   'foo
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
clos/con:
	'((app
   (-> cons <-)
   'foo
   (app cons 'bar (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

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
   (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
clos/con:
	'((app
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
   (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

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
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
    <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   'foo
   (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-))
  (env ()))
clos/con:
	'((app
   cons
   'foo
   (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (app cons 'rep (app cons 'bar (app nil))) (-> (app nil) <-))
  (env ()))
clos/con:
	'(((top) app nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
clos/con:
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 'rep (-> (app cons 'bar (app nil)) <-)) (env ()))
clos/con:
	'((app cons 'rep (-> (app cons 'bar (app nil)) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 'bar (-> (app nil) <-)) (env ()))
clos/con:
	'(((top) app nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> 'bar <-) (app nil)) (env ()))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 'bar (app nil)) (env ()))
clos/con:
	'((app (-> cons <-) 'bar (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
clos/con:
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 'rep (app cons 'bar (app nil))) (env ()))
clos/con:
	'((app (-> cons <-) 'rep (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> cons <-) (app cons 'rep (app cons 'bar (app nil))) (app nil))
  (env ()))
clos/con:
	'((app (-> cons <-) (app cons 'rep (app cons 'bar (app nil))) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

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
literals: '(⊥ ⊥ ⊥)

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
literals: '(⊥ ⊥ ⊥)

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
literals: '(⊥ ⊥ ⊥)

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
literals: '(⊥ ⊥ ⊥)

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
   (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
clos/con:
	'((letrec*
   (... d/dc (regex-match (-> (λ (pattern data) ...) <-)) check-expect ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

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
    (app cons 'foo (app cons 'bar (app cons 'bar (app cons 'bar (app nil))))))
   (app #t))
  (env ()))
clos/con:
	'((letrec*
   (... regex-match (check-expect (-> (λ (check expect) ...) <-)) () ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (...
        ()
        (_
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
            (app
             cons
             'foo
             (app
              cons
              'bar
              (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
           (app #f))
          <-))
        ()
        ...)
    ...)
  (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

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
    (app
     cons
     'foo
     (app
      cons
      'bar
      (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
   (-> (app #f) <-))
  (env ()))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ()))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

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
     (app
      cons
      'foo
      (app
       cons
       'bar
       (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
    <-)
   (app #f))
  (env ()))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

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
   (->
    (app
     cons
     'foo
     (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
    <-))
  (env ()))
clos/con:
	'((app
   regex-match
   (app
    cons
    'seq
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
   (->
    (app
     cons
     'foo
     (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
    <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   'foo
   (->
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
    <-))
  (env ()))
clos/con:
	'((app
   cons
   'foo
   (->
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
    <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   'bar
   (-> (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))) <-))
  (env ()))
clos/con:
	'((app
   cons
   'bar
   (-> (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))) <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons 'baz (-> (app cons 'bar (app cons 'bar (app nil))) <-))
  (env ()))
clos/con:
	'((app cons 'baz (-> (app cons 'bar (app cons 'bar (app nil))) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 'bar (-> (app cons 'bar (app nil)) <-)) (env ()))
clos/con:
	'((app cons 'bar (-> (app cons 'bar (app nil)) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 'bar (-> (app nil) <-)) (env ()))
clos/con:
	'(((top) app nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> 'bar <-) (app nil)) (env ()))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 'bar (app nil)) (env ()))
clos/con:
	'((app (-> cons <-) 'bar (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
clos/con:
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 'bar (app cons 'bar (app nil))) (env ()))
clos/con:
	'((app (-> cons <-) 'bar (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil))))
  (env ()))
clos/con:
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> cons <-) 'baz (app cons 'bar (app cons 'bar (app nil))))
  (env ()))
clos/con:
	'((app (-> cons <-) 'baz (app cons 'bar (app cons 'bar (app nil)))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
clos/con:
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   'bar
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
clos/con:
	'((app
   (-> cons <-)
   'bar
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   'foo
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
clos/con:
	'((app
   (-> cons <-)
   'foo
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

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
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
clos/con:
	'((app
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
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

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
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)))
    <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   'foo
   (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-))
  (env ()))
clos/con:
	'((app
   cons
   'foo
   (-> (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil)) <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (app cons 'rep (app cons 'bar (app nil))) (-> (app nil) <-))
  (env ()))
clos/con:
	'(((top) app nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
clos/con:
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 'rep (-> (app cons 'bar (app nil)) <-)) (env ()))
clos/con:
	'((app cons 'rep (-> (app cons 'bar (app nil)) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 'bar (-> (app nil) <-)) (env ()))
clos/con:
	'(((top) app nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> 'bar <-) (app nil)) (env ()))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 'bar (app nil)) (env ()))
clos/con:
	'((app (-> cons <-) 'bar (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
clos/con:
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 'rep (app cons 'bar (app nil))) (env ()))
clos/con:
	'((app (-> cons <-) 'rep (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> cons <-) (app cons 'rep (app cons 'bar (app nil))) (app nil))
  (env ()))
clos/con:
	'((app (-> cons <-) (app cons 'rep (app cons 'bar (app nil))) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

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
literals: '(⊥ ⊥ ⊥)

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
literals: '(⊥ ⊥ ⊥)

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
literals: '(⊥ ⊥ ⊥)

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
literals: '(⊥ ⊥ ⊥)

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
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
clos/con:
	'((letrec*
   (... d/dc (regex-match (-> (λ (pattern data) ...) <-)) check-expect ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

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
    (app
     cons
     'foo
     (app
      cons
      'bar
      (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
   (app #f))
  (env ()))
clos/con:
	'((letrec*
   (... regex-match (check-expect (-> (λ (check expect) ...) <-)) () ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (_)
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
         (app
          cons
          (app
           cons
           'rep
           (app
            cons
            (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
            (app nil)))
          (app nil))))
       (app
        cons
        'foo
        (app
         cons
         'bar
         (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
      (app #t))
     <-))
  (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

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
      (app
       cons
       (app
        cons
        'rep
        (app
         cons
         (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
         (app nil)))
       (app nil))))
    (app
     cons
     'foo
     (app
      cons
      'bar
      (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
   (-> (app #t) <-))
  (env ()))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ()))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

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
       (app
        cons
        (app
         cons
         'rep
         (app
          cons
          (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
          (app nil)))
        (app nil))))
     (app
      cons
      'foo
      (app
       cons
       'bar
       (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
    <-)
   (app #t))
  (env ()))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   regex-match
   (app
    cons
    'seq
    (app
     cons
     'foo
     (app
      cons
      (app
       cons
       'rep
       (app
        cons
        (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
        (app nil)))
      (app nil))))
   (->
    (app
     cons
     'foo
     (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
    <-))
  (env ()))
clos/con:
	'((app
   regex-match
   (app
    cons
    'seq
    (app
     cons
     'foo
     (app
      cons
      (app
       cons
       'rep
       (app
        cons
        (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
        (app nil)))
      (app nil))))
   (->
    (app
     cons
     'foo
     (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
    <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   'foo
   (->
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
    <-))
  (env ()))
clos/con:
	'((app
   cons
   'foo
   (->
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
    <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   'bar
   (-> (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))) <-))
  (env ()))
clos/con:
	'((app
   cons
   'bar
   (-> (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))) <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons 'baz (-> (app cons 'bar (app cons 'bar (app nil))) <-))
  (env ()))
clos/con:
	'((app cons 'baz (-> (app cons 'bar (app cons 'bar (app nil))) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 'bar (-> (app cons 'bar (app nil)) <-)) (env ()))
clos/con:
	'((app cons 'bar (-> (app cons 'bar (app nil)) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 'bar (-> (app nil) <-)) (env ()))
clos/con:
	'(((top) app nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> 'bar <-) (app nil)) (env ()))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 'bar (app nil)) (env ()))
clos/con:
	'((app (-> cons <-) 'bar (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
clos/con:
	'((app cons (-> 'bar <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 'bar (app cons 'bar (app nil))) (env ()))
clos/con:
	'((app (-> cons <-) 'bar (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil))))
  (env ()))
clos/con:
	'((app cons (-> 'baz <-) (app cons 'bar (app cons 'bar (app nil)))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> cons <-) 'baz (app cons 'bar (app cons 'bar (app nil))))
  (env ()))
clos/con:
	'((app (-> cons <-) 'baz (app cons 'bar (app cons 'bar (app nil)))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
clos/con:
	'((app
   cons
   (-> 'bar <-)
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   'bar
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
clos/con:
	'((app
   (-> cons <-)
   'bar
   (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   'foo
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
clos/con:
	'((app
   (-> cons <-)
   'foo
   (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil))))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

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
      (app
       cons
       (app
        cons
        'rep
        (app
         cons
         (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
         (app nil)))
       (app nil))))
    <-)
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
clos/con:
	'((app
   regex-match
   (->
    (app
     cons
     'seq
     (app
      cons
      'foo
      (app
       cons
       (app
        cons
        'rep
        (app
         cons
         (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
         (app nil)))
       (app nil))))
    <-)
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app
      cons
      (app
       cons
       'rep
       (app
        cons
        (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
        (app nil)))
      (app nil)))
    <-))
  (env ()))
clos/con:
	'((app
   cons
   'seq
   (->
    (app
     cons
     'foo
     (app
      cons
      (app
       cons
       'rep
       (app
        cons
        (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
        (app nil)))
      (app nil)))
    <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   'foo
   (->
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))
    <-))
  (env ()))
clos/con:
	'((app
   cons
   'foo
   (->
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))
    <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (app
    cons
    'rep
    (app
     cons
     (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
     (app nil)))
   (-> (app nil) <-))
  (env ()))
clos/con:
	'(((top) app nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
clos/con:
	'((app
   cons
   (->
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    <-)
   (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   'rep
   (->
    (app
     cons
     (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
     (app nil))
    <-))
  (env ()))
clos/con:
	'((app
   cons
   'rep
   (->
    (app
     cons
     (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
     (app nil))
    <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
   (-> (app nil) <-))
  (env ()))
clos/con:
	'(((top) app nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
clos/con:
	'((app
   cons
   (-> (app cons 'alt (app cons 'bar (app cons 'baz (app nil)))) <-)
   (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons 'alt (-> (app cons 'bar (app cons 'baz (app nil))) <-))
  (env ()))
clos/con:
	'((app cons 'alt (-> (app cons 'bar (app cons 'baz (app nil))) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 'bar (-> (app cons 'baz (app nil)) <-)) (env ()))
clos/con:
	'((app cons 'bar (-> (app cons 'baz (app nil)) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 'baz (-> (app nil) <-)) (env ()))
clos/con:
	'(((top) app nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> 'baz <-) (app nil)) (env ()))
clos/con:
	'((app cons (-> 'baz <-) (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 'baz (app nil)) (env ()))
clos/con:
	'((app (-> cons <-) 'baz (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
clos/con:
	'((app cons (-> 'bar <-) (app cons 'baz (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 'bar (app cons 'baz (app nil))) (env ()))
clos/con:
	'((app (-> cons <-) 'bar (app cons 'baz (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil))))
  (env ()))
clos/con:
	'((app cons (-> 'alt <-) (app cons 'bar (app cons 'baz (app nil)))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> cons <-) 'alt (app cons 'bar (app cons 'baz (app nil))))
  (env ()))
clos/con:
	'((app (-> cons <-) 'alt (app cons 'bar (app cons 'baz (app nil)))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
   (app nil))
  (env ()))
clos/con:
	'((app
   (-> cons <-)
   (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
   (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
clos/con:
	'((app
   cons
   (-> 'rep <-)
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   'rep
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
clos/con:
	'((app
   (-> cons <-)
   'rep
   (app
    cons
    (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
    (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   (app
    cons
    'rep
    (app
     cons
     (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
     (app nil)))
   (app nil))
  (env ()))
clos/con:
	'((app
   (-> cons <-)
   (app
    cons
    'rep
    (app
     cons
     (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
     (app nil)))
   (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
clos/con:
	'((app
   cons
   (-> 'foo <-)
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   'foo
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
clos/con:
	'((app
   (-> cons <-)
   'foo
   (app
    cons
    (app
     cons
     'rep
     (app
      cons
      (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
      (app nil)))
    (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
clos/con:
	'((app
   cons
   (-> 'seq <-)
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   (-> cons <-)
   'seq
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
clos/con:
	'((app
   (-> cons <-)
   'seq
   (app
    cons
    'foo
    (app
     cons
     (app
      cons
      'rep
      (app
       cons
       (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
       (app nil)))
     (app nil))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   (-> regex-match <-)
   (app
    cons
    'seq
    (app
     cons
     'foo
     (app
      cons
      (app
       cons
       'rep
       (app
        cons
        (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
        (app nil)))
      (app nil))))
   (app
    cons
    'foo
    (app cons 'bar (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
  (env ()))
clos/con:
	'((letrec*
   (... d/dc (regex-match (-> (λ (pattern data) ...) <-)) check-expect ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

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
      (app
       cons
       (app
        cons
        'rep
        (app
         cons
         (app cons 'alt (app cons 'bar (app cons 'baz (app nil))))
         (app nil)))
       (app nil))))
    (app
     cons
     'foo
     (app
      cons
      'bar
      (app cons 'baz (app cons 'bar (app cons 'bar (app nil)))))))
   (app #t))
  (env ()))
clos/con:
	'((letrec*
   (... regex-match (check-expect (-> (λ (check expect) ...) <-)) () ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)
