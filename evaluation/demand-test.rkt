#lang racket/base
(require "all-examples.rkt")
(require "demand.rkt" "config.rkt" "debug.rkt" "static-contexts.rkt")
(require "m-cfa.rkt")

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
  (current-m 1)
  (analysis-kind 'hybrid)
  (show-envs-simple #t)
  (define top-query (list (cons `(top) (get-example-expr 'multi-param)) (envenv (list))))
  ; (define query (go-bod (go-bin 1 top-query)))\
  (define query top-query)
  (pretty-print query)
  (pretty-result
   (run-print-query (apply eval query)))

  ; (define top-query-mcfa (list (cons `(top) (get-example-expr 'kcfa-2)) (flatenv (list))))
  ; (pretty-result (run-print-query (apply meval top-query-mcfa)))
  )

(define (go-bod q) (apply bod-e q))
(define (go-ran i q) (apply ran-e (append q (list i))))
(define (go-bin i q) (apply bin-e (append q (list i))))