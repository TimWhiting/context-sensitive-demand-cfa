#lang racket/base

(provide (all-defined-out))

; m stack frames
(define current-m (make-parameter 1))

; 'basic or 'hybrid
(define demand-kind (make-parameter '_))

; what level to trace at (set to a number)
(define trace (make-parameter #f))
