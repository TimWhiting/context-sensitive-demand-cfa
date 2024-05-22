#lang s-exp "../../lang/simple-scheme.rkt"

(let* ((id (lambda (x) x))
       (a  (id (lambda (aa) aa)))
       (b  (id (lambda (bb) bb))))
  a)
