#lang s-exp "../../lang/simple-scheme.rkt"

(letrec ([fact (lambda (n)
                 (if (zero? n) 1 (* n (fact (sub1 n)))))])
  (fact 3))
