#lang racket/base

(define ~cite
  (case-lambda
    [(tag) (list "~" "\\cite{" tag "}")]
    [(desc tag) (list "~" "\\cite[" desc "]{" tag "}")]))

(define (citet tag)
  (list "\\cite{" tag "}"))

(provide (all-defined-out))
