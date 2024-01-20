#lang racket/base
(provide (all-defined-out))

(define example-id-0 `(app (λ (x) x) (λ (y) y)))
(define example-0 `(app (λ (x) (app x x)) (λ (y) (app y y))))
(define example-let-0 `(let ([x (λ (y) y)]) x))


(define example-error `(app (λ (x) (app x x)) 2)); Error

; Integer examples
(define example-let-num `(let ([x (λ (y) y)]) (app x 1)))
(define example-2 `(let ([x (λ (y) y)]) (let ([_ (app x 1)]) (app x 2))))

; Constructor examples
(define example-con `(let ([x (app cons 1 nil)]) x))


(define all-simple-examples (list
                             ;  example-id-0
                             ;  example-0
                             ;  example-let-0
                             ;  example-let-num
                             ;  example-error
                             ;  example-2
                             example-con
                             ))