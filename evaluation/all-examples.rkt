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
                                   (pretty-print (format "In ~a: got error ~a" file e))
                                   (list))])
                   (list `(example,(dynamic-require file 'example-name) ,(dynamic-require file 'example-expr))))
                 (list))))
       (directory-list dir #:build? #t)))

(define all-benchmarks (apply append (get-all-examples "benchmarks")))

(define (get-example s [examples all-benchmarks])
  (let loop ([l examples])
    (match l
      [(list) (error 'get-example "no example named ~a" s)]
      [(cons `(example ,name ,expr) rest)
       (if (equal? name s)
           `(example ,name ,expr)
           (loop rest))])))

(define (get-example-expr s [examples all-benchmarks])
  (match (get-example s examples)
    [`(example ,_ ,expr) expr]))

(define (get-examples ls [examples all-benchmarks])
  (map (lambda (x) (get-example x examples)) ls))


(define (remove-examples examples)
  (filter (lambda (x)
            (match x
              [`(example ,nm ,expr) (not (member nm examples))]
              )
            ) all-benchmarks)
  )

; (pretty-print (get-example-expr 'regex))
; (pretty-print (free-vars (get-example-expr 'sat)))
; (pretty-print (get-example-expr 'loop2-1))
