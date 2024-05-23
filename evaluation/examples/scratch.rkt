#lang s-exp "../lang/simple-scheme.rkt"

;; Utilities.

(define (cadar p) (car (cdr (car p))))

; initial-environment-amap : alist[symbol,value]
(define initial-environment-amap
  (list (list '+ +)
        (list '- -)
        ))

(let ((x ((cadar initial-environment-amap) 1 1)))
  (display x))
