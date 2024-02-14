#lang s-exp "../../lang/simple-scheme.rkt"
(letrec
    ([a (λ (y) (if (equal? y 0)
                   y
                   (a (- y 1))))])
  (a 2))