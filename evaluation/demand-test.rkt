#lang racket/base
(require "all-examples.rkt")
(require "demand.rkt" "config.rkt" "debug.rkt")

(module+ main
  (require racket/pretty)
  (define example0 (list (cons `(top)
                               `(app (λ (x) x)
                                     (λ (y) y))) (list)))

  ; (demand-kind 'basic)
  ; (pretty-print (run-print-query (apply eval example0)))

  ; (demand-kind 'hybrid)
  ; (pretty-print (run-print-query (apply eval example0)))

  ; (pretty-print
  ;  (run-print-query (apply eval (apply rat-e example0))))

  ; (pretty-print
  ;  (run-print-query (apply eval (apply ran-e example0))))
  ; (trace 1)
  ; (demand-kind 'basic)
  ; (pretty-print
  ;  (run-print-query (apply eval (apply bod-e (apply rat-e example0)))))
  ; (demand-kind 'hybrid)
  ; (pretty-print
  ;  (run-print-query (apply eval (apply bod-e (apply rat-e example0)))))

  ; (pretty-print
  ;  (run-print-query (apply eval (apply bod-e (apply ran-e example0)))))

  ; (current-m 4)

  (define example1 (list (cons `(top)
                               `(app (λ (x) (app x x))
                                     (λ (y) (app y y))))
                         (list)))
  ; (demand-kind 'basic)
  ; (pretty-print
  ;  (run-print-query (apply eval (apply bod-e (apply ran-e example1)))))
  (demand-kind 'hybrid)
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

  ;   (trace 1)
  (demand-kind 'basic)
  (pretty-result
   (run-print-query (apply eval (list (cons `(top)
                                            (get-example-expr 'ack)) (list)))))
  )
