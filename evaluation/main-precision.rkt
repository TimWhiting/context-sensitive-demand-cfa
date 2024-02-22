#lang racket/base
(require "demand.rkt" "all-examples.rkt" "config.rkt" "utils.rkt"
         "debug.rkt" "syntax.rkt" "envs.rkt" "demand-queries.rkt" "results.rkt" "run.rkt")
(require "m-cfa.rkt")
(require racket/pretty racket/match)
(define max-context-length 2)

(define (run-mcfa kind query m)
  (define hash-result (hash))
  (match-let
      ([(cons res t)
        (run/parameters
         name
         m kind
         (let ([hash-new (run-get-hash query (hash))])
           (set! hash-result hash-new)
           )
         )])
    hash-result
    )
  )

(define (run-expm name exp m)
  (run-mcfa 'exponential (meval (cons `(top) exp) (expenv '())) m))

(define (run-demand name kind m query)
  (define hash-result (hash))
  (match-let
      ([(cons res t)
        (run/parameters
         name
         m kind
         (let
             ([hash-new (run-get-hash query (hash))])
           (set! hash-result hash-new)
           (from-hash query hash-result)
           ))])
    (from-hash query hash-result)
    )
  )

; TODO: Prior to this we need to simplify to make them comparable.
(define (compare-hashes expm demand)
  (for ([query (hash->list expm)])
    (match-let ([(cons (meval c p) val) query])
      (pretty-print (equal? val (hash-ref demand (eval c p))))
      )
    )
  )

(module+ main
  (show-envs-simple #t)
  (show-envs #f)
  ; (trace 1)
  (trace #f)
  (for ([m (in-range 0 (+ 1 max-context-length))])
    (let ([basic-cost 0]
          [rebind-cost 0]
          [expm-cost 0]
          [num-queries 0]
          [basic-acc-cost 0])
      (current-m m)
      (for ([example (get-examples '(ack blur cpstak deriv eta facehugger flatten
                                         kcfa-2 kcfa-3 loop2-1 map mj09 primtest
                                         regex rsa sat-1 sat-2 sat-3 tak sat-small))])
        ; (for ([example test-examples])
        (match-let ([`(example ,name ,exp) example])
          (define exp-hash (run-expm name exp m))
          (define demand-hash (hash))
          (define qbs (basic-queries exp))
          (for ([qs qbs])
            (match-let ([(list cb pb) qs])
              (define query (eval cb pb))
              (define res (run-demand name 'basic m query))
              (set! demand-hash (hash-set demand-hash query res))
              ))
          (compare-hashes exp-hash demand-hash)

          )))))