#lang racket

(provide (all-defined-out))
(define (file-name file) (build-path "examples" file))
(define all-examples
  (map (lambda (file)
         `(example,(dynamic-require (file-name file) 'example-name) ,(dynamic-require (file-name file) 'example-expr))
         )
       (directory-list "examples")))

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

(pretty-print all-examples)