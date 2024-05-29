#lang racket/base

(provide (all-defined-out))

; number of times to time the computation (to get a statistical average / stderr)
(define time-trials 1)

(define gases (list 100 200 300 400 500 700 1000 1200))

; number of times to run a query computation (to accumulate enough time to be in milliseconds hopefully?)
(define acc-trials 1)

; number of ways to shuffle queries when caching
(define num-shuffles 0)

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