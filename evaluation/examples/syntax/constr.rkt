#lang s-exp "../../lang/simple-scheme.rkt"
(let ([x (cons 1 (nil))])
  (match x
    [(cons 1 n) n]
    [_ x]
    ))