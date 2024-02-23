#lang racket/base
(require "all-examples.rkt")
(require "demand.rkt" "config.rkt" "debug.rkt" "static-contexts.rkt")
(require "m-cfa.rkt" "envs.rkt" "results.rkt" "run.rkt")
(require racket/pretty)

(module+ main
  (trace 1)
  (show-envs-simple #t)
  (show-envs #f)
  (run-mcfa 0 'exponential (get-example-expr 'map))
  ; (run-basic 0 (get-example-expr 'primtest) (lambda (x) (go-ran 0 (go-bin 0 (go-bod (go-bin 4 x))))))

  ; (run-basic 1 (get-example-expr 'sat-2)
  ;            (lambda (x) x)
  ;            ;  (lambda (x) (alternate 15 go-bod (go-ran-i 0) (go-bin 2 x)))
  ;            )
  ; (run-basic (get-example-expr 'inst)
  ;            (lambda (x) (repeat 2 go-bod (go-bin 0 x)))
  ;            )
  )

(define (repeat n f a)
  (if (= n 0) a
      (repeat (- n 1) f (f a))
      ))

(define (alternate n f g a)
  (if (= n 0) a
      (alternate (- n 1) g f (f a))
      ))

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


(define (go-bod q) (apply bod-e q))
(define ((go-ran-i i) q) (apply (ran-e i) q))
(define ((go-bin-i i) q) (apply (bin-e i) q))
(define (go-ran i q) (apply (ran-e i) q))
(define (go-bin i q) (apply (bin-e i) q))
(define (go-match-clause i q) (apply (match-clause-e i) q))