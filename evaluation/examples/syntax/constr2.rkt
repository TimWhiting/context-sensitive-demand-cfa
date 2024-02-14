#lang s-exp "../lang/simple-scheme.rkt"

(define (try f)
  (or (f #t)))

(try (lambda (f) (not f)))
