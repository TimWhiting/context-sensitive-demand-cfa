#lang s-exp "../lang/simple-scheme.rkt"

(define (do-something) 
  10)

(define (id y) 
  (do-something)
  y)

((id (lambda (a) a)) #t)
((id (lambda (b) b)) #f)
