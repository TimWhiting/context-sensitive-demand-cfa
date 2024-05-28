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

'(query: ((top) lettypes (cons ... nil) ...) (env ()))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (lettypes cons ... nil (letrec* (car ... check-expect) ...)) (env ()))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
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
  (λ (check expect) (-> (app equal? check expect) <-))
  (env ((□? (check expect)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app equal? check (-> expect <-)) (env ((□? (check expect)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app equal? (-> check <-) expect) (env ((□? (check expect)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> equal? <-) check expect) (env ((□? (check expect)))))
clos/con:
	'((prim equal?) (env ()))
literals: '(⊥ ⊥ ⊥)

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
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (pattern data) (-> (match (app null? data) ...) <-))
  (env ((□? (pattern data)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app null? data)
   (#f)
   (_ (-> (app regex-empty? (app regex-empty pattern)) <-)))
  (env ((□? (pattern data)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-empty? (-> (app regex-empty pattern) <-))
  (env ((□? (pattern data)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-empty (-> pattern <-)) (env ((□? (pattern data)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   regex-match
   (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
   (app cons 'foo (app cons 'bar (app nil ...))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-empty <-) pattern) (env ((□? (pattern data)))))
clos/con:
	'((letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> regex-empty? <-) (app regex-empty pattern))
  (env ((□? (pattern data)))))
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
    (->
     (app
      regex-match
      (app regex-derivative pattern (app car ...))
      (app cdr data))
     <-))
   _)
  (env ((□? (pattern data)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   regex-match
   (app regex-derivative pattern (app car data))
   (-> (app cdr data) <-))
  (env ((□? (pattern data)))))
clos/con:
	'(((top) app nil) (env ()))
	'((app cons 'foo (-> (app cons 'bar (app nil)) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cdr (-> data <-)) (env ((□? (pattern data)))))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   regex-match
   (app cons 'seq (app cons 'foo (app cons ...)))
   (-> (app cons 'foo (app cons 'bar (app nil ...))) <-))
  (env ()))
	'((app cons 'foo (-> (app cons 'bar (app nil)) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cdr <-) data) (env ((□? (pattern data)))))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   regex-match
   (-> (app regex-derivative pattern (app car data)) <-)
   (app cdr data))
  (env ((□? (pattern data)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-derivative pattern (-> (app car data) <-))
  (env ((□? (pattern data)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app car (-> data <-)) (env ((□? (pattern data)))))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   regex-match
   (app cons 'seq (app cons 'foo (app cons ...)))
   (-> (app cons 'foo (app cons 'bar (app nil ...))) <-))
  (env ()))
	'((app cons 'foo (-> (app cons 'bar (app nil)) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> car <-) data) (env ((□? (pattern data)))))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-derivative (-> pattern <-) (app car data))
  (env ((□? (pattern data)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   regex-match
   (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
   (app cons 'foo (app cons 'bar (app nil ...))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> regex-derivative <-) pattern (app car data))
  (env ((□? (pattern data)))))
clos/con:
	'((letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) regex-match ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   (-> regex-match <-)
   (app regex-derivative pattern (app car data))
   (app cdr data))
  (env ((□? (pattern data)))))
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

'(query: (match (-> (app null? data) <-) (#f) _) (env ((□? (pattern data)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app null? (-> data <-)) (env ((□? (pattern data)))))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   regex-match
   (app cons 'seq (app cons 'foo (app cons ...)))
   (-> (app cons 'foo (app cons 'bar (app nil ...))) <-))
  (env ()))
	'((app cons 'foo (-> (app cons 'bar (app nil)) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> null? <-) data) (env ((□? (pattern data)))))
clos/con:
	'((letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) debug-trace ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

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
literals: '(⊥ ⊥ ⊥)

'(query: (λ (re c) (-> (let (_) ...) <-)) (env ((□? (re c)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app debug-trace) <-)) () ...) ...)
  (env ((□? (re c)))))
clos/con:
	'((λ () (-> 'do-nothing <-))
  (env (((let (... () (_ (-> (app debug-trace) <-)) () ...) ...)))))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> debug-trace <-)) (env ((□? (re c)))))
clos/con:
	'((letrec* (... null? (debug-trace (-> (λ () ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (_) (-> (match (app regex-empty? re) ...) <-))
  (env ((□? (re c)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-empty? re) (#f) (_ (-> regex-NULL <-)))
  (env ((□? (re c)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-empty? re)
   ((#f) (-> (match (app regex-null? re) ...) <-))
   _)
  (env ((□? (re c)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-null? re) (#f) (_ (-> regex-NULL <-)))
  (env ((□? (re c)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-null? re) ((#f) (-> (match (app eq? c re) ...) <-)) _)
  (env ((□? (re c)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app eq? c re) (#f) (_ (-> regex-BLANK <-)))
  (env ((□? (re c)))))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app eq? c re) ((#f) (-> (match (app regex-atom? re) ...) <-)) _)
  (env ((□? (re c)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-atom? re) (#f) (_ (-> regex-NULL <-)))
  (env ((□? (re c)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-atom? re)
   ((#f) (-> (match (app match-seq re (λ (pat1 pat2) ...)) ...) <-))
   _)
  (env ((□? (re c)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-seq re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env ((□? (re c)))))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app match-seq re (λ (pat1 pat2) ...))
   ((#f) (-> (match (app match-alt re (λ (pat1 pat2) ...)) ...) <-))
   c-x)
  (env ((□? (re c)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-alt re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env ((□? (re c)))))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app match-alt re (λ (pat1 pat2) ...))
   ((#f) (-> (match (app match-rep re (λ (pat) ...)) ...) <-))
   c-x)
  (env ((□? (re c)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-rep re (λ (pat) ...)) (#f) (c-x (-> c-x <-)))
  (env ((□? (re c)))))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-rep re (λ (pat) ...)) ((#f) (-> regex-NULL <-)) c-x)
  (env ((□? (re c)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app match-rep re (λ (pat) ...)) <-) (#f) c-x)
  (env ((□? (re c)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app match-rep re (-> (λ (pat) ...) <-)) (env ((□? (re c)))))
clos/con:
	'((app match-rep re (-> (λ (pat) ...) <-)) (env ((□? (re c)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-))
  (env ((□? (pat)) (□? (re c)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil ...))) <-))
   _)
  (env (((app seq (app regex-derivative pat c) (-> (app rep pat) <-))))))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app seq (app regex-derivative pat c) (-> (app rep pat) <-))
  (env ((□? (pat)) (□? (re c)))))
clos/con:
	'(((top) app #t) (env ()))
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil ...))) <-))
   _)
  (env (((app seq (app regex-derivative pat c) (-> (app rep pat) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query: (app rep (-> pat <-)) (env ((□? (pat)) (□? (re c)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> rep <-) pat) (env ((□? (pat)) (□? (re c)))))
clos/con:
	'((letrec* (... alt (rep (-> (λ (pat) ...) <-)) regex-empty ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app seq (-> (app regex-derivative pat c) <-) (app rep pat))
  (env ((□? (pat)) (□? (re c)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-derivative pat (-> c <-)) (env ((□? (pat)) (□? (re c)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-derivative (-> pat <-) c) (env ((□? (pat)) (□? (re c)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-derivative <-) pat c) (env ((□? (pat)) (□? (re c)))))
clos/con:
	'((letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) regex-match ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> seq <-) (app regex-derivative pat c) (app rep pat))
  (env ((□? (pat)) (□? (re c)))))
clos/con:
	'((letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app match-rep (-> re <-) (λ (pat) ...)) (env ((□? (re c)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   regex-match
   (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
   (app cons 'foo (app cons 'bar (app nil ...))))
  (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> match-rep <-) re (λ (pat) ...)) (env ((□? (re c)))))
clos/con:
	'((letrec* (... match-alt (match-rep (-> (λ (re f) ...) <-)) seq ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x)
  (env ((□? (re c)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app match-alt re (-> (λ (pat1 pat2) ...) <-)) (env ((□? (re c)))))
clos/con:
	'((app match-alt re (-> (λ (pat1 pat2) ...) <-)) (env ((□? (re c)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (pat1 pat2)
    (->
     (app alt (app regex-derivative pat1 c) (app regex-derivative pat2 c))
     <-))
  (env ((□? (pat1 pat2)) (□? (re c)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((match
   (app regex-null? pat2)
   ((#f) (-> (app cons 'alt (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((λ (pat1 pat2)
       (->
        (app alt (app regex-derivative pat1 c) (app regex-derivative pat2 c))
        <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app alt (app regex-derivative pat1 c) (-> (app regex-derivative pat2 c) <-))
  (env ((□? (pat1 pat2)) (□? (re c)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-derivative pat2 (-> c <-))
  (env ((□? (pat1 pat2)) (□? (re c)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-derivative (-> pat2 <-) c)
  (env ((□? (pat1 pat2)) (□? (re c)))))
clos/con:
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> regex-derivative <-) pat2 c)
  (env ((□? (pat1 pat2)) (□? (re c)))))
clos/con:
	'((letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) regex-match ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app alt (-> (app regex-derivative pat1 c) <-) (app regex-derivative pat2 c))
  (env ((□? (pat1 pat2)) (□? (re c)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-derivative pat1 (-> c <-))
  (env ((□? (pat1 pat2)) (□? (re c)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-derivative (-> pat1 <-) c)
  (env ((□? (pat1 pat2)) (□? (re c)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> regex-derivative <-) pat1 c)
  (env ((□? (pat1 pat2)) (□? (re c)))))
clos/con:
	'((letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) regex-match ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> alt <-) (app regex-derivative pat1 c) (app regex-derivative pat2 c))
  (env ((□? (pat1 pat2)) (□? (re c)))))
clos/con:
	'((letrec* (... seq (alt (-> (λ (pat1 pat2) ...) <-)) rep ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app match-alt (-> re <-) (λ (pat1 pat2) ...)) (env ((□? (re c)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   regex-match
   (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
   (app cons 'foo (app cons 'bar (app nil ...))))
  (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> match-alt <-) re (λ (pat1 pat2) ...)) (env ((□? (re c)))))
clos/con:
	'((letrec*
   (... match-seq (match-alt (-> (λ (re f) ...) <-)) match-rep ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x)
  (env ((□? (re c)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app match-seq re (-> (λ (pat1 pat2) ...) <-)) (env ((□? (re c)))))
clos/con:
	'((app match-seq re (-> (λ (pat1 pat2) ...) <-)) (env ((□? (re c)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (pat1 pat2)
    (->
     (app
      alt
      (app seq (app regex-derivative ...) pat2)
      (app seq (app regex-empty ...) (app regex-derivative ...)))
     <-))
  (env ((□? (pat1 pat2)) (□? (re c)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((app
      alt
      (-> (app seq (app regex-derivative pat1 c) pat2) <-)
      (app seq (app regex-empty pat1) (app regex-derivative pat2 c)))))))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((app
      alt
      (app seq (app regex-derivative pat1 c) pat2)
      (->
       (app seq (app regex-empty pat1) (app regex-derivative pat2 c))
       <-))))))
	'((match
   (app regex-null? pat2)
   ((#f) (-> (app cons 'alt (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((λ (pat1 pat2)
       (->
        (app
         alt
         (app seq (app regex-derivative ...) pat2)
         (app seq (app regex-empty ...) (app regex-derivative ...)))
        <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   alt
   (app seq (app regex-derivative pat1 c) pat2)
   (-> (app seq (app regex-empty pat1) (app regex-derivative pat2 c)) <-))
  (env ((□? (pat1 pat2)) (□? (re c)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((app
      alt
      (app seq (app regex-derivative pat1 c) pat2)
      (->
       (app seq (app regex-empty pat1) (app regex-derivative pat2 c))
       <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app seq (app regex-empty pat1) (-> (app regex-derivative pat2 c) <-))
  (env ((□? (pat1 pat2)) (□? (re c)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-derivative pat2 (-> c <-))
  (env ((□? (pat1 pat2)) (□? (re c)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-derivative (-> pat2 <-) c)
  (env ((□? (pat1 pat2)) (□? (re c)))))
clos/con:
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> regex-derivative <-) pat2 c)
  (env ((□? (pat1 pat2)) (□? (re c)))))
clos/con:
	'((letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) regex-match ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app seq (-> (app regex-empty pat1) <-) (app regex-derivative pat2 c))
  (env ((□? (pat1 pat2)) (□? (re c)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-empty (-> pat1 <-)) (env ((□? (pat1 pat2)) (□? (re c)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-empty <-) pat1) (env ((□? (pat1 pat2)) (□? (re c)))))
clos/con:
	'((letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> seq <-) (app regex-empty pat1) (app regex-derivative pat2 c))
  (env ((□? (pat1 pat2)) (□? (re c)))))
clos/con:
	'((letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   alt
   (-> (app seq (app regex-derivative pat1 c) pat2) <-)
   (app seq (app regex-empty pat1) (app regex-derivative pat2 c)))
  (env ((□? (pat1 pat2)) (□? (re c)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((app
      alt
      (-> (app seq (app regex-derivative pat1 c) pat2) <-)
      (app seq (app regex-empty pat1) (app regex-derivative pat2 c)))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app seq (app regex-derivative pat1 c) (-> pat2 <-))
  (env ((□? (pat1 pat2)) (□? (re c)))))
clos/con:
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app seq (-> (app regex-derivative pat1 c) <-) pat2)
  (env ((□? (pat1 pat2)) (□? (re c)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-derivative pat1 (-> c <-))
  (env ((□? (pat1 pat2)) (□? (re c)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app regex-derivative (-> pat1 <-) c)
  (env ((□? (pat1 pat2)) (□? (re c)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> regex-derivative <-) pat1 c)
  (env ((□? (pat1 pat2)) (□? (re c)))))
clos/con:
	'((letrec*
   (... regex-empty (regex-derivative (-> (λ (re c) ...) <-)) regex-match ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> seq <-) (app regex-derivative pat1 c) pat2)
  (env ((□? (pat1 pat2)) (□? (re c)))))
clos/con:
	'((letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   (-> alt <-)
   (app seq (app regex-derivative pat1 c) pat2)
   (app seq (app regex-empty pat1) (app regex-derivative pat2 c)))
  (env ((□? (pat1 pat2)) (□? (re c)))))
clos/con:
	'((letrec* (... seq (alt (-> (λ (pat1 pat2) ...) <-)) rep ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app match-seq (-> re <-) (λ (pat1 pat2) ...)) (env ((□? (re c)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   regex-match
   (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
   (app cons 'foo (app cons 'bar (app nil ...))))
  (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> match-seq <-) re (λ (pat1 pat2) ...)) (env ((□? (re c)))))
clos/con:
	'((letrec*
   (... regex-atom? (match-seq (-> (λ (re f) ...) <-)) match-alt ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app regex-atom? re) <-) (#f) _) (env ((□? (re c)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-atom? (-> re <-)) (env ((□? (re c)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   regex-match
   (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
   (app cons 'foo (app cons 'bar (app nil ...))))
  (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-atom? <-) re) (env ((□? (re c)))))
clos/con:
	'((letrec*
   (... regex-empty? (regex-atom? (-> (λ (re) ...) <-)) match-seq ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app eq? c re) <-) (#f) _) (env ((□? (re c)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app eq? c (-> re <-)) (env ((□? (re c)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   regex-match
   (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
   (app cons 'foo (app cons 'bar (app nil ...))))
  (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app eq? (-> c <-) re) (env ((□? (re c)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> eq? <-) c re) (env ((□? (re c)))))
clos/con:
	'((prim eq?) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app regex-null? re) <-) (#f) _) (env ((□? (re c)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-null? (-> re <-)) (env ((□? (re c)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   regex-match
   (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
   (app cons 'foo (app cons 'bar (app nil ...))))
  (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-null? <-) re) (env ((□? (re c)))))
clos/con:
	'((letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app regex-empty? re) <-) (#f) _) (env ((□? (re c)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-empty? (-> re <-)) (env ((□? (re c)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   regex-match
   (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
   (app cons 'foo (app cons 'bar (app nil ...))))
  (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-empty? <-) re) (env ((□? (re c)))))
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

'(query: (λ (re) (-> (match (app regex-empty? re) ...) <-)) (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-empty? re) (#f) (_ (-> (app #t) <-)))
  (env ((□? (re)))))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ((□? (re)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-empty? re)
   ((#f) (-> (match (app regex-null? re) ...) <-))
   _)
  (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-null? re) (#f) (_ (-> (app #f) <-)))
  (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((□? (re)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-null? re)
   ((#f) (-> (match (app regex-atom? re) ...) <-))
   _)
  (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-atom? re) (#f) (_ (-> (app #f) <-)))
  (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((□? (re)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-atom? re)
   ((#f) (-> (match (app match-seq re (λ (pat1 pat2) ...)) ...) <-))
   _)
  (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-seq re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env ((□? (re)))))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app match-seq re (λ (pat1 pat2) ...))
   ((#f) (-> (match (app match-alt re (λ (pat1 pat2) ...)) ...) <-))
   c-x)
  (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app match-alt re (λ (pat1 pat2) ...)) (#f) (c-x (-> c-x <-)))
  (env ((□? (re)))))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app match-alt re (λ (pat1 pat2) ...))
   ((#f) (-> (match (app regex-rep? re) ...) <-))
   c-x)
  (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-rep? re) (#f) (_ (-> (app #t) <-)))
  (env ((□? (re)))))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ((□? (re)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-rep? re) ((#f) (-> (app #f) <-)) _)
  (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((□? (re)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app regex-rep? re) <-) (#f) _) (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-rep? (-> re <-)) (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   regex-match
   (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
   (app cons 'foo (app cons 'bar (app nil ...))))
  (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-rep? <-) re) (env ((□? (re)))))
clos/con:
	'((letrec*
   (... regex-seq? (regex-rep? (-> (λ (re) ...) <-)) regex-null? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app match-alt re (λ (pat1 pat2) ...)) <-) (#f) c-x)
  (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app match-alt re (-> (λ (pat1 pat2) ...) <-)) (env ((□? (re)))))
clos/con:
	'((app match-alt re (-> (λ (pat1 pat2) ...) <-)) (env ((□? (re)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (pat1 pat2)
    (-> (app alt (app regex-empty pat1) (app regex-empty pat2)) <-))
  (env ((□? (pat1 pat2)) (□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((match
   (app regex-null? pat2)
   ((#f) (-> (app cons 'alt (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((λ (pat1 pat2)
       (-> (app alt (app regex-empty pat1) (app regex-empty pat2)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app alt (app regex-empty pat1) (-> (app regex-empty pat2) <-))
  (env ((□? (pat1 pat2)) (□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-empty (-> pat2 <-)) (env ((□? (pat1 pat2)) (□? (re)))))
clos/con:
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-empty <-) pat2) (env ((□? (pat1 pat2)) (□? (re)))))
clos/con:
	'((letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app alt (-> (app regex-empty pat1) <-) (app regex-empty pat2))
  (env ((□? (pat1 pat2)) (□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-empty (-> pat1 <-)) (env ((□? (pat1 pat2)) (□? (re)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-empty <-) pat1) (env ((□? (pat1 pat2)) (□? (re)))))
clos/con:
	'((letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> alt <-) (app regex-empty pat1) (app regex-empty pat2))
  (env ((□? (pat1 pat2)) (□? (re)))))
clos/con:
	'((letrec* (... seq (alt (-> (λ (pat1 pat2) ...) <-)) rep ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app match-alt (-> re <-) (λ (pat1 pat2) ...)) (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   regex-match
   (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
   (app cons 'foo (app cons 'bar (app nil ...))))
  (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> match-alt <-) re (λ (pat1 pat2) ...)) (env ((□? (re)))))
clos/con:
	'((letrec*
   (... match-seq (match-alt (-> (λ (re f) ...) <-)) match-rep ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app match-seq re (λ (pat1 pat2) ...)) <-) (#f) c-x)
  (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app match-seq re (-> (λ (pat1 pat2) ...) <-)) (env ((□? (re)))))
clos/con:
	'((app match-seq re (-> (λ (pat1 pat2) ...) <-)) (env ((□? (re)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (pat1 pat2)
    (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-))
  (env ((□? (pat1 pat2)) (□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((λ (pat1 pat2)
       (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app seq (app regex-empty pat1) (-> (app regex-empty pat2) <-))
  (env ((□? (pat1 pat2)) (□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-empty (-> pat2 <-)) (env ((□? (pat1 pat2)) (□? (re)))))
clos/con:
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-empty <-) pat2) (env ((□? (pat1 pat2)) (□? (re)))))
clos/con:
	'((letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app seq (-> (app regex-empty pat1) <-) (app regex-empty pat2))
  (env ((□? (pat1 pat2)) (□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-empty (-> pat1 <-)) (env ((□? (pat1 pat2)) (□? (re)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-empty <-) pat1) (env ((□? (pat1 pat2)) (□? (re)))))
clos/con:
	'((letrec*
   (... rep (regex-empty (-> (λ (re) ...) <-)) regex-derivative ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> seq <-) (app regex-empty pat1) (app regex-empty pat2))
  (env ((□? (pat1 pat2)) (□? (re)))))
clos/con:
	'((letrec* (... match-rep (seq (-> (λ (pat1 pat2) ...) <-)) alt ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app match-seq (-> re <-) (λ (pat1 pat2) ...)) (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   regex-match
   (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
   (app cons 'foo (app cons 'bar (app nil ...))))
  (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> match-seq <-) re (λ (pat1 pat2) ...)) (env ((□? (re)))))
clos/con:
	'((letrec*
   (... regex-atom? (match-seq (-> (λ (re f) ...) <-)) match-alt ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app regex-atom? re) <-) (#f) _) (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-atom? (-> re <-)) (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   regex-match
   (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
   (app cons 'foo (app cons 'bar (app nil ...))))
  (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-atom? <-) re) (env ((□? (re)))))
clos/con:
	'((letrec*
   (... regex-empty? (regex-atom? (-> (λ (re) ...) <-)) match-seq ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app regex-null? re) <-) (#f) _) (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-null? (-> re <-)) (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   regex-match
   (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
   (app cons 'foo (app cons 'bar (app nil ...))))
  (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-null? <-) re) (env ((□? (re)))))
clos/con:
	'((letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app regex-empty? re) <-) (#f) _) (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-empty? (-> re <-)) (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   regex-match
   (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
   (app cons 'foo (app cons 'bar (app nil ...))))
  (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-empty? <-) re) (env ((□? (re)))))
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

'(query:
  (λ (pat) (-> (match (app regex-null? pat) ...) <-))
  (env ((□? (pat)))))
clos/con:
	'(((top) app #t) (env ()))
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil ...))) <-))
   _)
  (env (((app seq (app regex-derivative pat c) (-> (app rep pat) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-null? pat) (#f) (_ (-> regex-BLANK <-)))
  (env ((□? (pat)))))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-null? pat)
   ((#f) (-> (match (app regex-empty? pat) ...) <-))
   _)
  (env ((□? (pat)))))
clos/con:
	'(((top) app #t) (env ()))
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil ...))) <-))
   _)
  (env (((app seq (app regex-derivative pat c) (-> (app rep pat) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-empty? pat) (#f) (_ (-> regex-BLANK <-)))
  (env ((□? (pat)))))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil ...))) <-))
   _)
  (env ((□? (pat)))))
clos/con:
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil ...))) <-))
   _)
  (env ((□? (pat)))))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 'rep (-> (app cons pat (app nil)) <-)) (env ((□? (pat)))))
clos/con:
	'((app cons 'rep (-> (app cons pat (app nil)) <-)) (env ((□? (pat)))))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons pat (-> (app nil) <-)) (env ((□? (pat)))))
clos/con:
	'(((top) app nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ((□? (pat)))))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> pat <-) (app nil)) (env ((□? (pat)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) pat (app nil)) (env ((□? (pat)))))
clos/con:
	'((app (-> cons <-) pat (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> 'rep <-) (app cons pat (app nil))) (env ((□? (pat)))))
clos/con:
	'((app cons (-> 'rep <-) (app cons pat (app nil))) (env ((□? (pat)))))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 'rep (app cons pat (app nil))) (env ((□? (pat)))))
clos/con:
	'((app (-> cons <-) 'rep (app cons pat (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app regex-empty? pat) <-) (#f) _) (env ((□? (pat)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-empty? (-> pat <-)) (env ((□? (pat)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-empty? <-) pat) (env ((□? (pat)))))
clos/con:
	'((letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app regex-null? pat) <-) (#f) _) (env ((□? (pat)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-null? (-> pat <-)) (env ((□? (pat)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-null? <-) pat) (env ((□? (pat)))))
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

'(query:
  (λ (pat1 pat2) (-> (match (app regex-null? pat1) ...) <-))
  (env ((□? (pat1 pat2)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((app
      alt
      (-> (app seq (app regex-derivative pat1 c) pat2) <-)
      (app seq (app regex-empty pat1) (app regex-derivative pat2 c)))))))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((app
      alt
      (app seq (app regex-derivative pat1 c) pat2)
      (->
       (app seq (app regex-empty pat1) (app regex-derivative pat2 c))
       <-))))))
	'((match
   (app regex-null? pat2)
   ((#f) (-> (app cons 'alt (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((λ (pat1 pat2)
       (->
        (app
         alt
         (app seq (app regex-derivative ...) pat2)
         (app seq (app regex-empty ...) (app regex-derivative ...)))
        <-))))))
	'((match
   (app regex-null? pat2)
   ((#f) (-> (app cons 'alt (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((λ (pat1 pat2)
       (->
        (app alt (app regex-derivative pat1 c) (app regex-derivative pat2 c))
        <-))))))
	'((match
   (app regex-null? pat2)
   ((#f) (-> (app cons 'alt (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((λ (pat1 pat2)
       (-> (app alt (app regex-empty pat1) (app regex-empty pat2)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-null? pat1) (#f) (_ (-> pat2 <-)))
  (env ((□? (pat1 pat2)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((app
      alt
      (app seq (app regex-derivative pat1 c) pat2)
      (->
       (app seq (app regex-empty pat1) (app regex-derivative pat2 c))
       <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-null? pat1)
   ((#f) (-> (match (app regex-null? pat2) ...) <-))
   _)
  (env ((□? (pat1 pat2)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((app
      alt
      (-> (app seq (app regex-derivative pat1 c) pat2) <-)
      (app seq (app regex-empty pat1) (app regex-derivative pat2 c)))))))
	'((match
   (app regex-null? pat2)
   ((#f) (-> (app cons 'alt (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((λ (pat1 pat2)
       (->
        (app
         alt
         (app seq (app regex-derivative ...) pat2)
         (app seq (app regex-empty ...) (app regex-derivative ...)))
        <-))))))
	'((match
   (app regex-null? pat2)
   ((#f) (-> (app cons 'alt (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((λ (pat1 pat2)
       (->
        (app alt (app regex-derivative pat1 c) (app regex-derivative pat2 c))
        <-))))))
	'((match
   (app regex-null? pat2)
   ((#f) (-> (app cons 'alt (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((λ (pat1 pat2)
       (-> (app alt (app regex-empty pat1) (app regex-empty pat2)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-null? pat2) (#f) (_ (-> pat1 <-)))
  (env ((□? (pat1 pat2)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((app
      alt
      (-> (app seq (app regex-derivative pat1 c) pat2) <-)
      (app seq (app regex-empty pat1) (app regex-derivative pat2 c)))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-null? pat2)
   ((#f) (-> (app cons 'alt (app cons pat1 (app cons ...))) <-))
   _)
  (env ((□? (pat1 pat2)))))
clos/con:
	'((match
   (app regex-null? pat2)
   ((#f) (-> (app cons 'alt (app cons pat1 (app cons ...))) <-))
   _)
  (env ((□? (pat1 pat2)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons 'alt (-> (app cons pat1 (app cons pat2 (app nil ...))) <-))
  (env ((□? (pat1 pat2)))))
clos/con:
	'((app cons 'alt (-> (app cons pat1 (app cons pat2 (app nil ...))) <-))
  (env ((□? (pat1 pat2)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons pat1 (-> (app cons pat2 (app nil)) <-))
  (env ((□? (pat1 pat2)))))
clos/con:
	'((app cons pat1 (-> (app cons pat2 (app nil)) <-)) (env ((□? (pat1 pat2)))))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons pat2 (-> (app nil) <-)) (env ((□? (pat1 pat2)))))
clos/con:
	'(((top) app nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ((□? (pat1 pat2)))))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> pat2 <-) (app nil)) (env ((□? (pat1 pat2)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((app
      alt
      (app seq (app regex-derivative pat1 c) pat2)
      (->
       (app seq (app regex-empty pat1) (app regex-derivative pat2 c))
       <-))))))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) pat2 (app nil)) (env ((□? (pat1 pat2)))))
clos/con:
	'((app (-> cons <-) pat2 (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> pat1 <-) (app cons pat2 (app nil)))
  (env ((□? (pat1 pat2)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((app
      alt
      (-> (app seq (app regex-derivative pat1 c) pat2) <-)
      (app seq (app regex-empty pat1) (app regex-derivative pat2 c)))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> cons <-) pat1 (app cons pat2 (app nil)))
  (env ((□? (pat1 pat2)))))
clos/con:
	'((app (-> cons <-) pat1 (app cons pat2 (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil ...))))
  (env ((□? (pat1 pat2)))))
clos/con:
	'((app cons (-> 'alt <-) (app cons pat1 (app cons pat2 (app nil ...))))
  (env ((□? (pat1 pat2)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> cons <-) 'alt (app cons pat1 (app cons pat2 (app nil ...))))
  (env ((□? (pat1 pat2)))))
clos/con:
	'((app (-> cons <-) 'alt (app cons pat1 (app cons pat2 (app nil ...))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-null? pat2) <-) (#f) _)
  (env ((□? (pat1 pat2)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-null? (-> pat2 <-)) (env ((□? (pat1 pat2)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((app
      alt
      (app seq (app regex-derivative pat1 c) pat2)
      (->
       (app seq (app regex-empty pat1) (app regex-derivative pat2 c))
       <-))))))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-null? <-) pat2) (env ((□? (pat1 pat2)))))
clos/con:
	'((letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-null? pat1) <-) (#f) _)
  (env ((□? (pat1 pat2)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-null? (-> pat1 <-)) (env ((□? (pat1 pat2)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((app
      alt
      (-> (app seq (app regex-derivative pat1 c) pat2) <-)
      (app seq (app regex-empty pat1) (app regex-derivative pat2 c)))))))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-null? <-) pat1) (env ((□? (pat1 pat2)))))
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

'(query:
  (λ (pat1 pat2) (-> (match (app regex-null? pat1) ...) <-))
  (env ((□? (pat1 pat2)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil ...))) <-))
   _)
  (env (((app seq (app regex-derivative pat c) (-> (app rep pat) <-))))))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((app
      alt
      (-> (app seq (app regex-derivative pat1 c) pat2) <-)
      (app seq (app regex-empty pat1) (app regex-derivative pat2 c)))))))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((app
      alt
      (app seq (app regex-derivative pat1 c) pat2)
      (->
       (app seq (app regex-empty pat1) (app regex-derivative pat2 c))
       <-))))))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-))))))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((λ (pat1 pat2)
       (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-null? pat1) (#f) (_ (-> regex-NULL <-)))
  (env ((□? (pat1 pat2)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-null? pat1)
   ((#f) (-> (match (app regex-null? pat2) ...) <-))
   _)
  (env ((□? (pat1 pat2)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil ...))) <-))
   _)
  (env (((app seq (app regex-derivative pat c) (-> (app rep pat) <-))))))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((app
      alt
      (-> (app seq (app regex-derivative pat1 c) pat2) <-)
      (app seq (app regex-empty pat1) (app regex-derivative pat2 c)))))))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((app
      alt
      (app seq (app regex-derivative pat1 c) pat2)
      (->
       (app seq (app regex-empty pat1) (app regex-derivative pat2 c))
       <-))))))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-))))))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((λ (pat1 pat2)
       (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-null? pat2) (#f) (_ (-> regex-NULL <-)))
  (env ((□? (pat1 pat2)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-null? pat2)
   ((#f) (-> (match (app regex-empty? pat1) ...) <-))
   _)
  (env ((□? (pat1 pat2)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil ...))) <-))
   _)
  (env (((app seq (app regex-derivative pat c) (-> (app rep pat) <-))))))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((app
      alt
      (-> (app seq (app regex-derivative pat1 c) pat2) <-)
      (app seq (app regex-empty pat1) (app regex-derivative pat2 c)))))))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((app
      alt
      (app seq (app regex-derivative pat1 c) pat2)
      (->
       (app seq (app regex-empty pat1) (app regex-derivative pat2 c))
       <-))))))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-))))))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((λ (pat1 pat2)
       (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-empty? pat1) (#f) (_ (-> pat2 <-)))
  (env ((□? (pat1 pat2)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil ...))) <-))
   _)
  (env (((app seq (app regex-derivative pat c) (-> (app rep pat) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-empty? pat1)
   ((#f) (-> (match (app regex-empty? pat2) ...) <-))
   _)
  (env ((□? (pat1 pat2)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((app
      alt
      (-> (app seq (app regex-derivative pat1 c) pat2) <-)
      (app seq (app regex-empty pat1) (app regex-derivative pat2 c)))))))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((app
      alt
      (app seq (app regex-derivative pat1 c) pat2)
      (->
       (app seq (app regex-empty pat1) (app regex-derivative pat2 c))
       <-))))))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-))))))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((λ (pat1 pat2)
       (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-empty? pat2) (#f) (_ (-> pat1 <-)))
  (env ((□? (pat1 pat2)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
   _)
  (env ((□? (pat1 pat2)))))
clos/con:
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
   _)
  (env ((□? (pat1 pat2)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil ...))) <-))
  (env ((□? (pat1 pat2)))))
clos/con:
	'((app cons 'seq (-> (app cons pat1 (app cons pat2 (app nil ...))) <-))
  (env ((□? (pat1 pat2)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons pat1 (-> (app cons pat2 (app nil)) <-))
  (env ((□? (pat1 pat2)))))
clos/con:
	'((app cons pat1 (-> (app cons pat2 (app nil)) <-)) (env ((□? (pat1 pat2)))))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons pat2 (-> (app nil) <-)) (env ((□? (pat1 pat2)))))
clos/con:
	'(((top) app nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ((□? (pat1 pat2)))))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> pat2 <-) (app nil)) (env ((□? (pat1 pat2)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil ...))) <-))
   _)
  (env (((app seq (app regex-derivative pat c) (-> (app rep pat) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) pat2 (app nil)) (env ((□? (pat1 pat2)))))
clos/con:
	'((app (-> cons <-) pat2 (app nil)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> pat1 <-) (app cons pat2 (app nil)))
  (env ((□? (pat1 pat2)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> cons <-) pat1 (app cons pat2 (app nil)))
  (env ((□? (pat1 pat2)))))
clos/con:
	'((app (-> cons <-) pat1 (app cons pat2 (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil ...))))
  (env ((□? (pat1 pat2)))))
clos/con:
	'((app cons (-> 'seq <-) (app cons pat1 (app cons pat2 (app nil ...))))
  (env ((□? (pat1 pat2)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> cons <-) 'seq (app cons pat1 (app cons pat2 (app nil ...))))
  (env ((□? (pat1 pat2)))))
clos/con:
	'((app (-> cons <-) 'seq (app cons pat1 (app cons pat2 (app nil ...))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-empty? pat2) <-) (#f) _)
  (env ((□? (pat1 pat2)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-empty? (-> pat2 <-)) (env ((□? (pat1 pat2)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil ...))) <-))
   _)
  (env (((app seq (app regex-derivative pat c) (-> (app rep pat) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-empty? <-) pat2) (env ((□? (pat1 pat2)))))
clos/con:
	'((letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-empty? pat1) <-) (#f) _)
  (env ((□? (pat1 pat2)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-empty? (-> pat1 <-)) (env ((□? (pat1 pat2)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-empty? <-) pat1) (env ((□? (pat1 pat2)))))
clos/con:
	'((letrec*
   (... regex-null? (regex-empty? (-> (λ (re) ...) <-)) regex-atom? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-null? pat2) <-) (#f) _)
  (env ((□? (pat1 pat2)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-null? (-> pat2 <-)) (env ((□? (pat1 pat2)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil ...))) <-))
   _)
  (env (((app seq (app regex-derivative pat c) (-> (app rep pat) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-null? <-) pat2) (env ((□? (pat1 pat2)))))
clos/con:
	'((letrec*
   (... regex-rep? (regex-null? (-> (λ (re) ...) <-)) regex-empty? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app regex-null? pat1) <-) (#f) _)
  (env ((□? (pat1 pat2)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-null? (-> pat1 <-)) (env ((□? (pat1 pat2)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-null? <-) pat1) (env ((□? (pat1 pat2)))))
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

'(query:
  (λ (re f) (-> (match (app regex-rep? re) ...) <-))
  (env ((□? (re f)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-rep? re)
   (#f)
   (_ (-> (match (app f (app cadr ...)) ...) <-)))
  (env ((□? (re f)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app f (app cadr re)) (#f) (_ (-> (app #t) <-)))
  (env ((□? (re f)))))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ((□? (re f)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app f (app cadr re)) ((#f) (-> (app #f) <-)) _)
  (env ((□? (re f)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((□? (re f)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app f (app cadr re)) <-) (#f) _) (env ((□? (re f)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil ...))) <-))
   _)
  (env (((app seq (app regex-derivative pat c) (-> (app rep pat) <-))))))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((λ (pat) (-> (app seq (app regex-derivative pat c) (app rep pat)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query: (app f (-> (app cadr re) <-)) (env ((□? (re f)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cadr (-> re <-)) (env ((□? (re f)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   regex-match
   (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
   (app cons 'foo (app cons 'bar (app nil ...))))
  (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cadr <-) re) (env ((□? (re f)))))
clos/con:
	'((letrec* (... debug-trace (cadr (-> (λ (p) ...) <-)) caddr ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f <-) (app cadr re)) (env ((□? (re f)))))
clos/con:
	'((app match-rep re (-> (λ (pat) ...) <-)) (env ((□? (re c)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-rep? re) ((#f) (-> (app #f) <-)) _)
  (env ((□? (re f)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((□? (re f)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app regex-rep? re) <-) (#f) _) (env ((□? (re f)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-rep? (-> re <-)) (env ((□? (re f)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   regex-match
   (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
   (app cons 'foo (app cons 'bar (app nil ...))))
  (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-rep? <-) re) (env ((□? (re f)))))
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

'(query:
  (λ (re f) (-> (match (app regex-alt? re) ...) <-))
  (env ((□? (re f)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-alt? re)
   (#f)
   (_ (-> (match (app f (app cadr ...) (app caddr ...)) ...) <-)))
  (env ((□? (re f)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app f (app cadr re) (app caddr re)) (#f) (_ (-> (app #t) <-)))
  (env ((□? (re f)))))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ((□? (re f)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app f (app cadr re) (app caddr re)) ((#f) (-> (app #f) <-)) _)
  (env ((□? (re f)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((□? (re f)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _)
  (env ((□? (re f)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((match
   (app regex-null? pat2)
   ((#f) (-> (app cons 'alt (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((λ (pat1 pat2)
       (->
        (app alt (app regex-derivative pat1 c) (app regex-derivative pat2 c))
        <-))))))
	'((match
   (app regex-null? pat2)
   ((#f) (-> (app cons 'alt (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((λ (pat1 pat2)
       (-> (app alt (app regex-empty pat1) (app regex-empty pat2)) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query: (app f (app cadr re) (-> (app caddr re) <-)) (env ((□? (re f)))))
clos/con:
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app caddr (-> re <-)) (env ((□? (re f)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   regex-match
   (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
   (app cons 'foo (app cons 'bar (app nil ...))))
  (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> caddr <-) re) (env ((□? (re f)))))
clos/con:
	'((letrec* (... cadr (caddr (-> (λ (p) ...) <-)) regex-NULL ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f (-> (app cadr re) <-) (app caddr re)) (env ((□? (re f)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cadr (-> re <-)) (env ((□? (re f)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   regex-match
   (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
   (app cons 'foo (app cons 'bar (app nil ...))))
  (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cadr <-) re) (env ((□? (re f)))))
clos/con:
	'((letrec* (... debug-trace (cadr (-> (λ (p) ...) <-)) caddr ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f <-) (app cadr re) (app caddr re)) (env ((□? (re f)))))
clos/con:
	'((app match-alt re (-> (λ (pat1 pat2) ...) <-)) (env ((□? (re c)))))
	'((app match-alt re (-> (λ (pat1 pat2) ...) <-)) (env ((□? (re)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-alt? re) ((#f) (-> (app #f) <-)) _)
  (env ((□? (re f)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((□? (re f)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app regex-alt? re) <-) (#f) _) (env ((□? (re f)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-alt? (-> re <-)) (env ((□? (re f)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   regex-match
   (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
   (app cons 'foo (app cons 'bar (app nil ...))))
  (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-alt? <-) re) (env ((□? (re f)))))
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

'(query:
  (λ (re f) (-> (match (app regex-seq? re) ...) <-))
  (env ((□? (re f)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app regex-seq? re)
   (#f)
   (_ (-> (match (app f (app cadr ...) (app caddr ...)) ...) <-)))
  (env ((□? (re f)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app f (app cadr re) (app caddr re)) (#f) (_ (-> (app #t) <-)))
  (env ((□? (re f)))))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ((□? (re f)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app f (app cadr re) (app caddr re)) ((#f) (-> (app #f) <-)) _)
  (env ((□? (re f)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((□? (re f)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app f (app cadr re) (app caddr re)) <-) (#f) _)
  (env ((□? (re f)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((app
      alt
      (-> (app seq (app regex-derivative pat1 c) pat2) <-)
      (app seq (app regex-empty pat1) (app regex-derivative pat2 c)))))))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((app
      alt
      (app seq (app regex-derivative pat1 c) pat2)
      (->
       (app seq (app regex-empty pat1) (app regex-derivative pat2 c))
       <-))))))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((λ (pat1 pat2)
       (-> (app seq (app regex-empty pat1) (app regex-empty pat2)) <-))))))
	'((match
   (app regex-null? pat2)
   ((#f) (-> (app cons 'alt (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((λ (pat1 pat2)
       (->
        (app
         alt
         (app seq (app regex-derivative ...) pat2)
         (app seq (app regex-empty ...) (app regex-derivative ...)))
        <-))))))
literals: '(⊥ ⊥ ⊥)

'(query: (app f (app cadr re) (-> (app caddr re) <-)) (env ((□? (re f)))))
clos/con:
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app caddr (-> re <-)) (env ((□? (re f)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   regex-match
   (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
   (app cons 'foo (app cons 'bar (app nil ...))))
  (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> caddr <-) re) (env ((□? (re f)))))
clos/con:
	'((letrec* (... cadr (caddr (-> (λ (p) ...) <-)) regex-NULL ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f (-> (app cadr re) <-) (app caddr re)) (env ((□? (re f)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cadr (-> re <-)) (env ((□? (re f)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   regex-match
   (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
   (app cons 'foo (app cons 'bar (app nil ...))))
  (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cadr <-) re) (env ((□? (re f)))))
clos/con:
	'((letrec* (... debug-trace (cadr (-> (λ (p) ...) <-)) caddr ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f <-) (app cadr re) (app caddr re)) (env ((□? (re f)))))
clos/con:
	'((app match-seq re (-> (λ (pat1 pat2) ...) <-)) (env ((□? (re c)))))
	'((app match-seq re (-> (λ (pat1 pat2) ...) <-)) (env ((□? (re)))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app regex-seq? re) ((#f) (-> (app #f) <-)) _)
  (env ((□? (re f)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((□? (re f)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app regex-seq? re) <-) (#f) _) (env ((□? (re f)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app regex-seq? (-> re <-)) (env ((□? (re f)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   regex-match
   (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
   (app cons 'foo (app cons 'bar (app nil ...))))
  (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> regex-seq? <-) re) (env ((□? (re f)))))
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

'(query: (λ (re) (-> (match (app char? re) ...) <-)) (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app char? re) (#f) (_ (-> (app #t) <-))) (env ((□? (re)))))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ((□? (re)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app char? re) ((#f) (-> (match (app symbol? re) ...) <-)) _)
  (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app symbol? re) (#f) (_ (-> (app #t) <-))) (env ((□? (re)))))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ((□? (re)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app symbol? re) ((#f) (-> (app #f) <-)) _) (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((□? (re)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app symbol? re) <-) (#f) _) (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app symbol? (-> re <-)) (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   regex-match
   (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
   (app cons 'foo (app cons 'bar (app nil ...))))
  (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> symbol? <-) re) (env ((□? (re)))))
clos/con:
	'((prim symbol?) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app char? re) <-) (#f) _) (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app char? (-> re <-)) (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   regex-match
   (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
   (app cons 'foo (app cons 'bar (app nil ...))))
  (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> char? <-) re) (env ((□? (re)))))
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

'(query: (λ (re) (-> (app eq? re (app #t)) <-)) (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app eq? re (-> (app #t) <-)) (env ((□? (re)))))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ((□? (re)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app eq? (-> re <-) (app #t)) (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   regex-match
   (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
   (app cons 'foo (app cons 'bar (app nil ...))))
  (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil ...))) <-))
   _)
  (env (((app seq (app regex-derivative pat c) (-> (app rep pat) <-))))))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> eq? <-) re (app #t)) (env ((□? (re)))))
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

'(query: (λ (re) (-> (app eq? re (app #f)) <-)) (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app eq? re (-> (app #f) <-)) (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((□? (re)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app eq? (-> re <-) (app #f)) (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   regex-match
   (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
   (app cons 'foo (app cons 'bar (app nil ...))))
  (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
	'((match
   (app regex-empty? pat)
   ((#f) (-> (app cons 'rep (app cons pat (app nil ...))) <-))
   _)
  (env (((app seq (app regex-derivative pat c) (-> (app rep pat) <-))))))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((app
      alt
      (-> (app seq (app regex-derivative pat1 c) pat2) <-)
      (app seq (app regex-empty pat1) (app regex-derivative pat2 c)))))))
	'((match
   (app regex-empty? pat2)
   ((#f) (-> (app cons 'seq (app cons pat1 (app cons ...))) <-))
   _)
  (env
   (((app
      alt
      (app seq (app regex-derivative pat1 c) pat2)
      (->
       (app seq (app regex-empty pat1) (app regex-derivative pat2 c))
       <-))))))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> eq? <-) re (app #f)) (env ((□? (re)))))
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

'(query: (λ (re) (-> (match (app pair? re) ...) <-)) (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app pair? re)
   (#f)
   (_ (-> (match (app eq? (app car ...) 'rep) ...) <-)))
  (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app eq? (app car re) 'rep) (#f) (_ (-> (app #t) <-)))
  (env ((□? (re)))))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ((□? (re)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app eq? (app car re) 'rep) ((#f) (-> (app #f) <-)) _)
  (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((□? (re)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app eq? (app car re) 'rep) <-) (#f) _) (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app eq? (app car re) (-> 'rep <-)) (env ((□? (re)))))
clos/con:
	'((app eq? (app car re) (-> 'rep <-)) (env ((□? (re)))))
literals: '(⊥ ⊥ ⊥)

'(query: (app eq? (-> (app car re) <-) 'rep) (env ((□? (re)))))
clos/con:
	'((app
   cons
   (-> 'seq <-)
   (app cons 'foo (app cons (app cons ...) (app nil ...))))
  (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app car (-> re <-)) (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   regex-match
   (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
   (app cons 'foo (app cons 'bar (app nil ...))))
  (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> car <-) re) (env ((□? (re)))))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> eq? <-) (app car re) 'rep) (env ((□? (re)))))
clos/con:
	'((prim eq?) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app pair? re) ((#f) (-> (app #f) <-)) _) (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((□? (re)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app pair? re) <-) (#f) _) (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app pair? (-> re <-)) (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   regex-match
   (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
   (app cons 'foo (app cons 'bar (app nil ...))))
  (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> pair? <-) re) (env ((□? (re)))))
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

'(query: (λ (re) (-> (match (app pair? re) ...) <-)) (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app pair? re)
   (#f)
   (_ (-> (match (app eq? (app car ...) 'seq) ...) <-)))
  (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app eq? (app car re) 'seq) (#f) (_ (-> (app #t) <-)))
  (env ((□? (re)))))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ((□? (re)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app eq? (app car re) 'seq) ((#f) (-> (app #f) <-)) _)
  (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((□? (re)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app eq? (app car re) 'seq) <-) (#f) _) (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app eq? (app car re) (-> 'seq <-)) (env ((□? (re)))))
clos/con:
	'((app eq? (app car re) (-> 'seq <-)) (env ((□? (re)))))
literals: '(⊥ ⊥ ⊥)

'(query: (app eq? (-> (app car re) <-) 'seq) (env ((□? (re)))))
clos/con:
	'((app
   cons
   (-> 'seq <-)
   (app cons 'foo (app cons (app cons ...) (app nil ...))))
  (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app car (-> re <-)) (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   regex-match
   (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
   (app cons 'foo (app cons 'bar (app nil ...))))
  (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> car <-) re) (env ((□? (re)))))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> eq? <-) (app car re) 'seq) (env ((□? (re)))))
clos/con:
	'((prim eq?) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app pair? re) ((#f) (-> (app #f) <-)) _) (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((□? (re)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app pair? re) <-) (#f) _) (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app pair? (-> re <-)) (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   regex-match
   (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
   (app cons 'foo (app cons 'bar (app nil ...))))
  (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> pair? <-) re) (env ((□? (re)))))
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

'(query: (λ (re) (-> (match (app pair? re) ...) <-)) (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app pair? re)
   (#f)
   (_ (-> (match (app eq? (app car ...) 'alt) ...) <-)))
  (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app eq? (app car re) 'alt) (#f) (_ (-> (app #t) <-)))
  (env ((□? (re)))))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ((□? (re)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app eq? (app car re) 'alt) ((#f) (-> (app #f) <-)) _)
  (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((□? (re)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app eq? (app car re) 'alt) <-) (#f) _) (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app eq? (app car re) (-> 'alt <-)) (env ((□? (re)))))
clos/con:
	'((app eq? (app car re) (-> 'alt <-)) (env ((□? (re)))))
literals: '(⊥ ⊥ ⊥)

'(query: (app eq? (-> (app car re) <-) 'alt) (env ((□? (re)))))
clos/con:
	'((app
   cons
   (-> 'seq <-)
   (app cons 'foo (app cons (app cons ...) (app nil ...))))
  (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app car (-> re <-)) (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   regex-match
   (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
   (app cons 'foo (app cons 'bar (app nil ...))))
  (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> car <-) re) (env ((□? (re)))))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> eq? <-) (app car re) 'alt) (env ((□? (re)))))
clos/con:
	'((prim eq?) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app pair? re) ((#f) (-> (app #f) <-)) _) (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((□? (re)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app pair? re) <-) (#f) _) (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app pair? (-> re <-)) (env ((□? (re)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   regex-match
   (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
   (app cons 'foo (app cons 'bar (app nil ...))))
  (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> pair? <-) re) (env ((□? (re)))))
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

'(query: (λ (p) (-> (app car (app cdr (app cdr ...))) <-)) (env ((□? (p)))))
clos/con:
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app car (-> (app cdr (app cdr p)) <-)) (env ((□? (p)))))
clos/con:
	'(((top) app nil) (env ()))
	'((app cons 'foo (-> (app cons (app cons 'rep (app cons ...)) (app nil)) <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cdr (-> (app cdr p) <-)) (env ((□? (p)))))
clos/con:
	'((app
   cons
   'seq
   (-> (app cons 'foo (app cons (app cons ...) (app nil ...))) <-))
  (env ()))
	'((app cons 'rep (-> (app cons 'bar (app nil)) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cdr (-> p <-)) (env ((□? (p)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   regex-match
   (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
   (app cons 'foo (app cons 'bar (app nil ...))))
  (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cdr <-) p) (env ((□? (p)))))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cdr <-) (app cdr p)) (env ((□? (p)))))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> car <-) (app cdr (app cdr p))) (env ((□? (p)))))
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

'(query: (λ (p) (-> (app car (app cdr p)) <-)) (env ((□? (p)))))
clos/con:
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app car (-> (app cdr p) <-)) (env ((□? (p)))))
clos/con:
	'((app
   cons
   'seq
   (-> (app cons 'foo (app cons (app cons ...) (app nil ...))) <-))
  (env ()))
	'((app cons 'rep (-> (app cons 'bar (app nil)) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cdr (-> p <-)) (env ((□? (p)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   regex-match
   (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
   (app cons 'foo (app cons 'bar (app nil ...))))
  (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cdr <-) p) (env ((□? (p)))))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> car <-) (app cdr p)) (env ((□? (p)))))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... null? (debug-trace (-> (λ () ...) <-)) cadr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... null? (debug-trace (-> (λ () ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ () (-> 'do-nothing <-)) (env ((□? ()))))
clos/con:
	'((λ () (-> 'do-nothing <-)) (env ((□? ()))))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) debug-trace ...) ...)
  (env ()))
clos/con:
	'((letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) debug-trace ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (null?-v) (-> (match null?-v ...) <-)) (env ((□? (null?-v)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match null?-v (nil) (_ (-> (app #f) <-))) (env ((□? (null?-v)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((□? (null?-v)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match null?-v ((nil) (-> (app #t) <-)) _) (env ((□? (null?-v)))))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ((□? (null?-v)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> null?-v <-) (nil) _) (env ((□? (null?-v)))))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   regex-match
   (app cons 'seq (app cons 'foo (app cons ...)))
   (-> (app cons 'foo (app cons 'bar (app nil ...))) <-))
  (env ()))
	'((app cons 'foo (-> (app cons 'bar (app nil)) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cdr (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (pair?-v) (-> (match pair?-v ...) <-)) (env ((□? (pair?-v)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match pair?-v (cons pair?-c pair?-d) (_ (-> (app #f) <-)))
  (env ((□? (pair?-v)))))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env ((□? (pair?-v)))))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match pair?-v ((cons pair?-c pair?-d) (-> (app #t) <-)) _)
  (env ((□? (pair?-v)))))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env ((□? (pair?-v)))))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> pair?-v <-) (cons pair?-c pair?-d) _)
  (env ((□? (pair?-v)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'((app
   regex-match
   (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
   (app cons 'foo (app cons 'bar (app nil ...))))
  (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) pair? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (cdr-v) (-> (match cdr-v ...) <-)) (env ((□? (cdr-v)))))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   cons
   'seq
   (-> (app cons 'foo (app cons (app cons ...) (app nil ...))) <-))
  (env ()))
	'((app cons 'foo (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'foo (-> (app cons (app cons 'rep (app cons ...)) (app nil)) <-))
  (env ()))
	'((app cons 'rep (-> (app cons 'bar (app nil)) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-))) (env ((□? (cdr-v)))))
clos/con:
	'(((top) app nil) (env ()))
	'((app
   cons
   'seq
   (-> (app cons 'foo (app cons (app cons ...) (app nil ...))) <-))
  (env ()))
	'((app cons 'foo (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'foo (-> (app cons (app cons 'rep (app cons ...)) (app nil)) <-))
  (env ()))
	'((app cons 'rep (-> (app cons 'bar (app nil)) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> cdr-v <-) (cons cdr-c cdr-d)) (env ((□? (cdr-v)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'(((top) app nil) (env ()))
	'((app
   cons
   'seq
   (-> (app cons 'foo (app cons (app cons ...) (app nil ...))) <-))
  (env ()))
	'((app
   regex-match
   (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
   (app cons 'foo (app cons 'bar (app nil ...))))
  (env ()))
	'((app
   regex-match
   (app cons 'seq (app cons 'foo (app cons ...)))
   (-> (app cons 'foo (app cons 'bar (app nil ...))) <-))
  (env ()))
	'((app cons 'foo (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'rep (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (car-v) (-> (match car-v ...) <-)) (env ((□? (car-v)))))
clos/con:
	'((app
   cons
   (-> 'seq <-)
   (app cons 'foo (app cons (app cons ...) (app nil ...))))
  (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match car-v ((cons car-c car-d) (-> car-c <-))) (env ((□? (car-v)))))
clos/con:
	'((app
   cons
   (-> 'seq <-)
   (app cons 'foo (app cons (app cons ...) (app nil ...))))
  (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((app cons (-> 'rep <-) (app cons 'bar (app nil))) (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> car-v <-) (cons car-c car-d)) (env ((□? (car-v)))))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
	'(((top) app nil) (env ()))
	'((app
   cons
   'seq
   (-> (app cons 'foo (app cons (app cons ...) (app nil ...))) <-))
  (env ()))
	'((app
   regex-match
   (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
   (app cons 'foo (app cons 'bar (app nil ...))))
  (env ()))
	'((app
   regex-match
   (app cons 'seq (app cons 'foo (app cons ...)))
   (-> (app cons 'foo (app cons 'bar (app nil ...))) <-))
  (env ()))
	'((app cons 'foo (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons 'foo (-> (app cons (app cons 'rep (app cons ...)) (app nil)) <-))
  (env ()))
	'((app cons 'rep (-> (app cons 'bar (app nil)) <-)) (env ()))
	'((app cons (-> 'bar <-) (app nil)) (env ()))
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (car ... check-expect)
   (->
    (app check-expect (app regex-match (app cons ...) (app cons ...)) (app #f))
    <-))
  (env ()))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
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
     (app cons 'seq (app cons ...))
     (app cons 'foo (app cons ...)))
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
   (app cons 'seq (app cons 'foo (app cons ...)))
   (-> (app cons 'foo (app cons 'bar (app nil ...))) <-))
  (env ()))
clos/con:
	'((app
   regex-match
   (app cons 'seq (app cons 'foo (app cons ...)))
   (-> (app cons 'foo (app cons 'bar (app nil ...))) <-))
  (env ()))
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
  (app
   regex-match
   (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
   (app cons 'foo (app cons 'bar (app nil ...))))
  (env ()))
clos/con:
	'((app
   regex-match
   (-> (app cons 'seq (app cons 'foo (app cons ...))) <-)
   (app cons 'foo (app cons 'bar (app nil ...))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   cons
   'seq
   (-> (app cons 'foo (app cons (app cons ...) (app nil ...))) <-))
  (env ()))
clos/con:
	'((app
   cons
   'seq
   (-> (app cons 'foo (app cons (app cons ...) (app nil ...))) <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons 'foo (-> (app cons (app cons 'rep (app cons ...)) (app nil)) <-))
  (env ()))
clos/con:
	'((app cons 'foo (-> (app cons (app cons 'rep (app cons ...)) (app nil)) <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (app cons 'rep (app cons 'bar (app nil ...))) (-> (app nil) <-))
  (env ()))
clos/con:
	'(((top) app nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
  (env ()))
clos/con:
	'((app cons (-> (app cons 'rep (app cons 'bar (app nil ...))) <-) (app nil))
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
  (app (-> cons <-) (app cons 'rep (app cons 'bar (app nil ...))) (app nil))
  (env ()))
clos/con:
	'((app (-> cons <-) (app cons 'rep (app cons 'bar (app nil ...))) (app nil))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
clos/con:
	'((app cons (-> 'foo <-) (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> cons <-) 'foo (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
clos/con:
	'((app (-> cons <-) 'foo (app cons (app cons 'rep (app cons ...)) (app nil)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
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

'(query:
  (app
   (-> cons <-)
   'seq
   (app cons 'foo (app cons (app cons ...) (app nil ...))))
  (env ()))
clos/con:
	'((app
   (-> cons <-)
   'seq
   (app cons 'foo (app cons (app cons ...) (app nil ...))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   (-> regex-match <-)
   (app cons 'seq (app cons 'foo (app cons ...)))
   (app cons 'foo (app cons 'bar (app nil ...))))
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

'(query:
  (app
   (-> check-expect <-)
   (app
    regex-match
    (app cons 'seq (app cons ...))
    (app cons 'foo (app cons ...)))
   (app #f))
  (env ()))
clos/con:
	'((letrec*
   (... regex-match (check-expect (-> (λ (check expect) ...) <-)) () ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)
