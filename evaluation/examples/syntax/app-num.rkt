#lang s-exp "../../lang/simple-scheme.rkt"
(let ([x (λ (y) y)]) (let ([_ (x 1)]) (x 2)))