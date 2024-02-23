#lang racket/base
(require "demand.rkt" "abstract-value.rkt" "all-examples.rkt" "config.rkt" "utils.rkt"
         "debug.rkt" "syntax.rkt" "envs.rkt" "demand-queries.rkt" "results.rkt" "run.rkt")
(require "m-cfa.rkt")
(require racket/pretty racket/match racket/hash racket/set)
(define max-context-length 0)

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
           ))])
    (hash-ref hash-result query)
    )
  )

; TODO: Prior to this we need to simplify to make them comparable.
(define (compare-hashes name m expm demand)
  (define out '())
  (define (add-error message)
    (if (equal? out '())
        (set! out (open-output-file (format "tests/diff/~a_~a.rkt" name m) #:exists 'replace))
        '()
        )
    (displayln message out)
    )
  (define exmp-simple (simplify-hash expm))
  (define demand-simple (simplify-hash demand))
  (for ([query (hash->list exmp-simple)])
    (match-let ([(cons key val) query])
      (if (equal? val (hash-ref demand-simple key #f))
          '()
          (match-let ([`(eval ,c) key])
            (add-error (format "difference: ~a\n\tmcfa:~a\n\tdemand:~a" (show-simple-ctx c) val (hash-ref demand-simple key #f)))
            )
          )
      )))

(define (simple-cons/clos x)
  (match x
    [(list `(prim ,n ,l) env) `(prim ,n)]
    [(list `(con ,t) env) (cons `(top) `(app ,t))]
    [(list `(con ,t ,Ce) env) (show-simple-ctx Ce)]
    [(list (cons C e) env) (show-simple-ctx (cons C e))]
    )
  )


(define (simplify-val v)
  (match (from-value v)
    [(cons xss n) (cons (apply set (map simple-cons/clos (set->list xss))) n)]
    )
  )

(define ((update-simple-val new) old)
  (match old
    [(cons xss n)
     (match new
       [(cons xss1 n1)
        (cons (set-union xss xss1) (lit-union n n1))]
       )
     ]
    )
  )

(define (simplify-hash h)
  (define new-hash (hash))
  (for ([key-val (hash->list h)])
    (match-let ([(cons key val) key-val])
      (define simple-val (simplify-val val))
      (define updater (update-simple-val simple-val))
      (match key
        [(meval c p)
         (set! new-hash
               (hash-update new-hash `(eval ,c) updater simple-val))]
        [(eval c p)
         (set! new-hash
               (hash-update new-hash `(eval ,c) updater simple-val))]
        [_ '()]
        )
      )
    )
  new-hash
  )

(module+ main
  (show-envs-simple #t)
  (show-envs #f)
  ; (trace 1)
  (define all-examples '(ack blur cpstak deriv eta facehugger flatten
                             kcfa-2 kcfa-3 loop2-1 map mj09 primtest
                             regex rsa sat-1 sat-2 sat-3 tak sat-small))
  (trace #f)
  (for ([m (in-range 0 (+ 1 max-context-length))])
    (let ([basic-cost 0]
          [rebind-cost 0]
          [expm-cost 0]
          [num-queries 0]
          [basic-acc-cost 0])
      (current-m m)
      (for ([example (get-examples all-examples)])
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
          (compare-hashes name m exp-hash demand-hash)
          )))))