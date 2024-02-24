#lang racket/base
(require "all-examples.rkt")
(require "demand.rkt" "config.rkt" "debug.rkt" "static-contexts.rkt" "syntax.rkt")
(require "m-cfa.rkt" "envs.rkt" "results.rkt" "run.rkt")
(require racket/pretty)

(module+ main
  (trace 1)
  (show-envs-simple #t)
  (show-envs #f)
  (run-mcfa 1 'rebinding (get-example-expr 'sat-1))
  ; (run-basic 0 (get-example-expr 'primtest) (lambda (x) (go-ran 0 (go-bin 0 (go-bod (go-bin 4 x))))))
  ; (run-basic 1 (get-example-expr 'blur) (λ (x) (go-ran 0 (go-match (go-bod (go-bin 2 x))))))
  ; (run-basic 1 (get-example-expr 'sat-2)
  ;            (lambda (x) x)
  ;             (lambda (x) (alternate 15 go-bod (go-ran-i 0) (go-bin 2 x)))
  ;            )
  ; (run-basic 2 (get-example-expr 'sat-2)
  ;            (lambda (x) (repeat 2 (go-ran-i 0) (repeat 7 go-bod (go-bin 0 x))))
  ;            )
  ; (run-basic 2 (get-example-expr 'sat-small)
  ;            (lambda (x)
  ;              (define q (go-ran 0 (go-ran 1 (go-bod (go-bin 0 x)
  ;                                                    )
  ;                                          )
  ;                                ))
  ;              (define call1 (car (go-bod (alternate 4 go-bod (go-ran-i 0) (go-bin 2 x)))))
  ;              (define call2 (car (go-ran 0 (go-bod (go-bin 1 x)))))
  ;              (define r (list (car q) (menv (list (callc (list call1 call2))))))
  ;              (pretty-print (show-simple-ctx (car q)))
  ;              (pretty-print (show-simple-ctx call1))
  ;              (pretty-print (show-simple-ctx call2))
  ;              r
  ;              )
  ;            ; (run-basic (get-example-expr 'inst)
  ;            ;            (lambda (x) (repeat 2 go-bod (go-bin 0 x)))
  ;            ;            )
  ;            )
  )

(define (run-mcfa m kind expr)
  (analysis-kind kind)
  (pretty-print expr)
  (run/parameters
   "sample"
   m
   kind
   (let ([h (run-get-hash (meval (cons `(top) expr) (top-env)))])
     (show-simple-results (from-hash (meval (cons `(top) expr) (top-env)) h))
     )
   )
  )

(define (run-basic m expr mkq)
  (current-m m)
  (define top-query-b (list (cons `(top) expr) (menv (list))))
  (define qb (mkq top-query-b))
  (run/parameters
   "sample"
   m
   'basic
   (pretty-result
    (run-print-query (apply eval qb)))
   )
  )


