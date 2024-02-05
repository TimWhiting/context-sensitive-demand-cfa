#lang racket/base
(require "all-examples.rkt")
(require "demand.rkt" "config.rkt" "debug.rkt" "static-contexts.rkt")
(require "m-cfa.rkt" "envs.rkt")

(module+ main
  (require racket/pretty)
  (define example0 (list (cons `(top)
                               `(app (λ (x) x)
                                     (λ (y) y))) (list)))

  ; (analysis-kind 'basic)
  ; (pretty-print (run-print-query (apply eval example0)))

  ; (analysis-kind 'hybrid)
  ; (pretty-print (run-print-query (apply eval example0)))

  ; (pretty-print
  ;  (run-print-query (apply eval (apply rat-e example0))))

  ; (pretty-print
  ;  (run-print-query (apply eval (apply ran-e example0))))
  ; (trace 1)
  ; (analysis-kind 'basic)
  ; (pretty-print
  ;  (run-print-query (apply eval (apply bod-e (apply rat-e example0)))))
  ; (analysis-kind 'hybrid)
  ; (pretty-print
  ;  (run-print-query (apply eval (apply bod-e (apply rat-e example0)))))

  ; (pretty-print
  ;  (run-print-query (apply eval (apply bod-e (apply ran-e example0)))))

  ; (current-m 4)

  (define example1 (list (cons `(top)
                               `(app (λ (x) (app x x))
                                     (λ (y) (app y y))))
                         (list)))
  ; (analysis-kind 'basic)
  ; (pretty-print
  ;  (run-print-query (apply eval (apply bod-e (apply ran-e example1)))))
  (analysis-kind 'hybrid)
  ; (pretty-print
  ;  (run-print-query (apply eval (apply bod-e (apply ran-e example1)))))

  ; #;"QUERY"
  ; (pretty-print
  ;  (run-print-query (apply eval (apply bod-e (apply rat-e example1)))))

  ; #;"QUERY"
  ; (pretty-print
  ;  (run-print-query (apply eval (apply rat-e (apply bod-e (apply ran-e example1))))))

  ; #;"QUERY"
  ; (pretty-print
  ;  (run-print-query (apply eval (apply ran-e example1))))

  ; #;"QUERY"

  (define example2 (list (cons `(top)
                               `(let ([x (λ (y) y)])
                                  (app x 1)))
                         (list)))
  ; (pretty-result
  ;  (run-print-query (apply eval example2)))

  ; (pretty-print
  ;  (run-print-query (apply eval (apply bod-e example2))))

  (trace 1)
  ; (current-m 1)
  ; (analysis-kind 'hybrid)
  ; (show-envs-simple #t)
  ; (define top-query (list (cons `(top) (get-example-expr 'multi-param)) (envenv (list))))
  ; ; (define query (go-bod (go-bin 1 top-query)))\
  ; (define query top-query)
  ; (pretty-print query)
  ; (pretty-result
  ;  (run-print-query (apply eval query)))
  (current-m 2)
  (compare-demand 'multi-param (lambda (q) q))
  ; (define top-query-mcfa (list (cons `(top) (get-example-expr 'kcfa-2)) (flatenv (list))))
  ; (pretty-result (run-print-query (apply meval top-query-mcfa)))
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