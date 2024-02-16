#lang s-exp "../lang/simple-scheme.rkt"

(define (apply f)
  (lambda (x)
    (f x)))
(define (add1 x)
  (+ 1 x))
(define (sub1 x)
  (- 1 x)
  )

((apply add1) 42)
((apply sub1) 35)