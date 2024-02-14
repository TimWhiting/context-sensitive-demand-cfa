#lang s-exp "../lang/simple-scheme.rkt"
(letrec ([a (λ (y) (if (equal? y 0) (a (- y 1)) y))])
  (a 2))