#lang racket/base
(provide (all-defined-out))

(define-syntax-rule (example name x)
  (define name `(name ,x))
  )

(example id-0 `(app (λ (x) x) (λ (y) y)))
(example structural-rec-0 `(app (λ (x) (app x x)) (λ (y) (app y y))))
(example let-0 `(let ([x (λ (y) y)]) x))
(example err-0 `(app (λ (x) (app x x)) 2)); Error

; Integer examples
(example let-num-0 `(let ([x (λ (y) y)]) (app x 1)))
(example app-num-0 `(let ([x (λ (y) y)]) (let ([_ (app x 1)]) (app x 2))))

; Constructor examples
(example constr-0 `(let ([x (app cons 1 nil)]) x))

; Multiple parameters
(example app-2-params `(app (λ (x y) (app x y)) (λ (z) z) 2))


(define all-simple-examples (list
                             id-0
                             structural-rec-0
                             let-0
                             err-0
                             let-num-0
                             app-num-0
                             constr-0
                             app-2-params
                             ))

; (module+ main
;   (require racket/pretty)
;   (pretty-print id-0)
;   )