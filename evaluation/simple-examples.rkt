#lang racket/base
(provide (all-defined-out))

(define example-id-0 `(app (λ (x) x) (λ (y) y)))
(define example-0 `(app (λ (x) (app x x)) (λ (y) (app y y))))
(define example-let-0 `(let ([x (λ (y) y)]) x))

(define all-simple-examples (list example-id-0 example-0 example-let-0))