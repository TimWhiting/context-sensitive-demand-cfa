(define example-id-0 `(app (λ (x) x) (λ (y) y)))
(define example-0 `(app (λ (x) (app x x)) (λ (y) (app y y))))
(define example-let-0 `(let ([x (λ (y) y)]) x))

(provide (all-defined-out))