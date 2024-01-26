#lang racket/base

(provide (all-defined-out))

; m stack frames
(define current-m (make-parameter 1))

; 'basic or 'hybrid
(define demand-kind (make-parameter '_))

; 'exponential or 'rebinding
(define mcfa-kind (make-parameter 'exponential))

; Show simple environments that match between hybrid and basic
(define show-envs-simple (make-parameter #f))

; what level to trace at (set to a number)
(define trace (make-parameter #f))

; number for n deep environments, or true for full depth
(define show-envs (make-parameter #f))