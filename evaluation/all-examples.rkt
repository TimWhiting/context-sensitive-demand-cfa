#lang racket

(provide (all-defined-out))

(define (is-dir p)
  (match (file-or-directory-type p)
    ['directory #t]
    [_ #f])
  )
(define (get-all-examples dir)
  (map (lambda (file)
         (if (is-dir file)
             (apply append (get-all-examples file))
             (if (string-suffix? (path->string file) ".rkt")
                 (list `(example,(dynamic-require file 'example-name) ,(dynamic-require file 'example-expr)))
                 (list))))
       (directory-list dir #:build? #t)))

(define all-examples (apply append (get-all-examples "examples")))

(define (get-example s)
  (let loop ([l all-examples])
    (match l
      [(list) (error 'get-example "no example named ~a" s)]
      [(cons `(example ,name ,expr) rest)
       (if (equal? name s)
           `(example ,name ,expr)
           (loop rest))])))

(define (get-example-expr s)
  (match (get-example s)
    [`(example ,_ ,expr) expr]))

(define (get-examples ls)
  (map get-example ls))

(define basic-num-examples (get-examples '(let-num app-num)))
(define basic-lambda-examples (get-examples '(id let structural-rec err)))
(define multiple-param-examples (get-examples '(multi-param)))
(define constructor-examples (get-examples '(constr)))
(define r6rs (get-examples '(ack blur church cpstak sat-1 kcfa-2)))
(define test-examples (get-examples '(kcfa-2)))

(define hybrid-failures (get-examples '(church)))
(define general-failures (get-examples '(cpstak)))
(define bad-results (get-examples '(blur sat-1))); ?check kcfa-2

(define successful-examples
  (filter (lambda (x)
            (not (or
                  (member x hybrid-failures)
                  (member x bad-results)
                  (member x general-failures) #f)))
          all-examples))

(pretty-print test-examples)
