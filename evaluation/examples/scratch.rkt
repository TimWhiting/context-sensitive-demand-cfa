#lang s-exp "../lang/simple-scheme.rkt"

(define (count1 count)
  (set! count (+ count 1)))

(define x 0)
(count1 x)