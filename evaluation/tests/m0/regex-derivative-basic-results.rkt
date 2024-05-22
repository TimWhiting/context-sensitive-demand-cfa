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
