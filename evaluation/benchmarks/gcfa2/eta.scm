#lang s-exp "../../lang/simple-scheme.rkt"

(let ((id (lambda (x)
                   (let ((y 10))
                        x))))
  (let ((z (id #t)))
    (id #f)))
