#lang s-exp "../lang/simple-scheme.rkt"



(define (count-maps source target)
  (let ((count 0))
    (maps-rest source
               target
               '()
               (lattice->elements source)
               (lambda (x)
                 (set! count (+ count 1))
                 (if (= 0 (remainder count print-frequency))
                     (begin
                       (display count)
                       (display "...")
                       (newline))
                     (void))
                 1)
               (lambda (x) (let loop ((i 0)
                                      (l x))
                             (cond ((null? l) i)
                                   (else (loop (+ i (car l))
                                               (cdr l)))))))))
