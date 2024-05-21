#lang racket/base
(require "all-examples.rkt")
(require "demand.rkt" "config.rkt" "debug.rkt" "static-contexts.rkt" "syntax.rkt")
(require "m-cfa.rkt" "envs.rkt" "results.rkt" "run.rkt")
(require racket/pretty racket/match)

(module+ main
  (trace 1)
  (show-envs-simple #t)
  (show-envs #f)
  ; (run-mcfa -0 'exponential (get-example-expr 'rsa))
  (run-basic 0 (get-example-expr 'ack) (λ (x) x))
  ; (run-basic 1 (get-example-expr 'primtest) (λ (x) (go-ran 0 (go-match-clause 0 (go-match-clause 0 (go-bod (go-bin 1 x)))))))
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
  ; (pretty-print expr)
  (run/parameters
   "sample"
   m
   kind
   (let ([h (run-get-hash (meval (cons `(top) expr) (top-env)))])
     (define eval-results-hash (hash))
     (define eval-results-x (filter (lambda (q) (match q [(cons (meval Ce p) _) (not (is-instant-query (list Ce p)))] [_ #f])) (hash->list h)))
     (for ([result eval-results-x])
       (match-let ([(cons (meval Ce p) res) result])
         (set! eval-results-hash (hash-update eval-results-hash Ce (λ (oldres) (join oldres res)) (from-value res)))
         )
       )
     (for ([q (hash->list eval-results-hash)])
       (match q
         [(cons Ce res)
          (if (is-singleton-val (cons Ce res))
              (begin
                (pretty-print (show-simple-ctx Ce))
                (pretty-print (show-simple-results res)))
              ; (begin
              ;   (displayln "Not singleton")
              ;   (pretty-print (show-simple-ctx Ce))
              ;   (pretty-print (show-simple-results res))
              ;   )
              '()
              )
          ]
         )
       )
     (displayln "Final result:")
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


