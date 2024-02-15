#lang racket/base
(require "all-examples.rkt")
(require "demand.rkt" "config.rkt" "debug.rkt" "static-contexts.rkt")
(require "m-cfa.rkt" "envs.rkt" "results.rkt")
(require racket/pretty)

(module+ main
  (trace 1)
  (show-envs-simple #t)
  (show-envs #f)
  (current-m 2)
  (run-basic (get-example-expr 'tic-tac-toe)
             (lambda (x)
               (go-ran 0
                       (go-ran 0
                               (go-ran 0
                                       (go-bod
                                        (go-bod
                                         (go-bin 26
                                                 (go-bod x)))))))
               ))
  )

(define (run-basic expr mkq)
  (analysis-kind 'basic)
  (define top-query-b (list (cons `(top) expr) (menv (list))))
  (define qb (mkq top-query-b))
  (pretty-result
   (run-print-query (apply eval qb)))
  )


(define (go-bod q) (apply bod-e q))
(define (go-ran i q) (apply (ran-e i) q))
(define (go-bin i q) (apply (bin-e i) q))