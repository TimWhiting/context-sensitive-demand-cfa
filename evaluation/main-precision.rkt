#lang racket/base
(require "demand.rkt" "abstract-value.rkt" "all-examples.rkt" "config.rkt" "utils.rkt"
         "debug.rkt" "syntax.rkt" "envs.rkt" "demand-queries.rkt" "results.rkt" "run.rkt")
(require "m-cfa.rkt")
(require racket/pretty racket/match racket/hash racket/set)

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

(define (check-result add-error name m key exp-res demand-res)
  (define exp-val (simplify-val exp-res))
  (define demand-val (simplify-val demand-res))
  (if (equal? exp-val demand-val)
      '()
      (match-let ([(eval c p) key])
        (add-error (format "difference: ~a, env: ~a\n\tmcfa:~a\n\tdemand:~a" (show-simple-ctx c) (show-simple-env p) exp-val demand-val))
        )
      )
  )

(define (translate-queries h)
  (for/list ([key-val (hash->list h)]
             #:when (match key-val [(cons (meval _ _) _) #t] [_ #f])
             )
    (match key-val
      [(cons (meval c p) val) (cons val (eval c (menv (env-list p))))]
      )
    )
  )

(module+ main
  (show-envs-simple #t)
  (show-envs #f)
  ; (trace 1)
  (define all-examples '(ack blur cpstak deriv eta facehugger flatten
                             kcfa-2 kcfa-3 loop2-1 map mj09 primtest
                             regex rsa sat-1 sat-2 sat-3 tak sat-small))
  (trace #f)

  (for ([m (in-range 1 2)])
    (current-m m)
    (for ([example (get-examples '(blur))])
      (match-let ([`(example ,name ,exp) example])
        (define exp-hash (run-expm name exp m))
        (define out '())
        (define fname  (format "tests/diff/~a_~a.rkt" name m))
        (if (file-exists? fname)
            (delete-file fname)
            '())
        (define (add-error message)
          (if (equal? out '())
              (set! out (open-output-file fname #:exists 'replace))
              '()
              )
          (displayln message out))
        (for ([trans (translate-queries exp-hash)])
          (match-let ([(cons exp-result demand-query) trans])
            (check-result add-error name m demand-query exp-result (run-demand name 'basic m demand-query))
            )
          )))))