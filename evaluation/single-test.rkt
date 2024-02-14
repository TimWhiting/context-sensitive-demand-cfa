#lang racket/base
(require "all-examples.rkt")
(require "demand.rkt" "config.rkt" "debug.rkt" "static-contexts.rkt")
(require "m-cfa.rkt" "envs.rkt" "results.rkt")

(module+ main
  (require racket/pretty)
  (trace 1)
  (show-envs-simple #t)
  (show-envs #f)
  (current-m 0)
  (run-basic (get-example-expr 'tic-tac-toe) (lambda (x) x))
  )

(define (run-hybrid expr mkq)
  (analysis-kind 'hybrid)
  (define top-query-h (list (cons `(top) expr) (envenv (list))))
  (define qh (mkq top-query-h))
  (pretty-result
   (run-print-query (apply eval qh)))
  )

(define (run-basic expr mkq)
  (analysis-kind 'basic)
  (define top-query-b (list (cons `(top) expr) (menv (list))))
  (define qb (mkq top-query-b))
  (pretty-result
   (run-print-query (apply eval qb)))
  )


(define (compare-demand example mkq)
  (define expr (get-example-expr example))
  (run-hybrid expr mkq)
  ; (run-basic expr mkq)
  )

(define (go-bod q) (apply bod-e q))
(define (go-ran i q) (apply (ran-e i) q))
(define (go-bin i q) (apply (bin-e i) q))