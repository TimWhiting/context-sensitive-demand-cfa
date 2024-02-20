#lang racket
(require "syntax.rkt")
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
                 (with-handlers
                     ([exn:fail? (lambda (e)
                                   ;  (pretty-print (format "In ~a: got error ~a" file e))
                                   (list))])
                   (list `(example,(dynamic-require file 'example-name) ,(dynamic-require file 'example-expr))))
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

(define syntax-basics '(basic-letrec basic-letstar constr prim-match err id let-num app-num let multi-param structural-rec))
(define basic-num-examples '(let-num app-num))
(define basic-lambda-examples '(id let structural-rec err))
(define basic-let-examples '(basic-letrec basic-letstar))
(define multiple-param-examples '(multi-param))
(define constructor-examples '(constr prim-match))
(define r6rs '(ack blur cpstak kcfa-2 kcfa-3 sat-1 sat-2 sat-3))

; Fails to parse: regex, fail to run church
(define untested '(deriv rsa eta church facehugger flatten loop2-1 map mj09 primtest rsa std regex scratch game)); ?check kcfa-2

(define successful-examples
  (filter (lambda (x)
            (not (or
                  (member x untested)
                  #f)))
          all-examples))

(define (remove-examples examples)
  (filter (lambda (x)
            (match x
              [`(example ,nm ,expr) (not (member nm examples))]
              )
            ) all-examples)
  )

; (pretty-print (get-example-expr 'regex))
; (pretty-print (free-vars (get-example-expr 'std-basic)))
; (pretty-print (get-example-expr 'tic-tac-toe))
