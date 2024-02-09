#lang racket/base

(provide (all-defined-out))

; number of times to time the computation
(define time-trials 5)

(define acc-trials 50)

(define num-shuffles 10)

(define timeout 5.0)

; m stack frames
(define current-m (make-parameter 1))

; 'basic, 'light or 'hybrid for demand-mcfa
; 'exponential or 'rebinding for regular mcfa
(define analysis-kind (make-parameter '_))

; Show simple environments that match between hybrid and basic
(define show-envs-simple (make-parameter #f))

; what level to trace at (set to a number)
(define trace (make-parameter #f))

; number for n deep environments, or true for full depth
(define show-envs (make-parameter #f))