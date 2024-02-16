#lang racket/base
(require "all-examples.rkt")
(require "demand.rkt" "config.rkt" "debug.rkt" "static-contexts.rkt")
(require "m-cfa.rkt" "envs.rkt" "results.rkt" "run.rkt")
(require racket/pretty)

(module+ main
  (trace 1)
  (show-envs-simple #t)
  (show-envs #f)

  (run-basic (get-example-expr 'sat-2)
             (lambda (x) (alternate 16 go-bod (go-ran-i 0) (go-bin 2 x)))
             ))

(define (repeat n f a)
  (if (= n 0) a
      (repeat (- n 1) f (f a))
      ))

(define (alternate n f g a)
  (if (= n 0) a
      (alternate (- n 1) g f (f a))
      ))

(define (run-basic expr mkq)
  (define top-query-b (list (cons `(top) expr) (menv (list))))
  (define qb (mkq top-query-b))
  (run/parameters
   "sample"
   1
   'basic
   (pretty-result
    (run-print-query (apply eval qb)))
   )
  )


(define (go-bod q) (apply bod-e q))
(define ((go-ran-i i) q) (apply (ran-e i) q))
(define ((go-bin-i i) q) (apply (bin-e i) q))
(define (go-ran i q) (apply (ran-e i) q))
(define (go-bin i q) (apply (bin-e i) q))