#lang s-exp "../../lang/simple-scheme.rkt"
; define append
(define (append x y)
  (if (null? x)
      y
      (cons (car x) (append (cdr x) y))))

(define (flatten x)
  (cond
    ((pair? x)
     (append (flatten (car x)) (flatten (cdr x))))
    ((null? x) x)
    (else (list x))))

(flatten '((1 2) (((3 4 5)))))