#lang s-exp "../../lang/simple-scheme.rkt"
(define (id x) x)
   (define (f n)
     (cond ((<= n 1)  1)
           (else  (* n (f (- n 1))))))
   (define (g n)
     (cond ((<= n 1)  1)
           (else  (* n (g (- n 1))))))
   (+ ((id f) 3) ((id g) 4))