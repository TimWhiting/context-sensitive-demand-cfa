#lang racket/base
(require "config.rkt" racket/pretty)
(provide (all-defined-out))

(define-syntax-rule (run/parameters m k x)
  (let ()
    (analysis-kind k)
    (current-m m)
    x
    )
  )

(define-syntax-rule (run/timen n m k x)
  (let ()
    (define thd (current-thread))
    (sync/timeout
     (/ (* timeout acc-trials) n)
     (thread (lambda ()
               (analysis-kind k)
               (current-m m)
               (let ([resv x])
                 (thread-send thd resv)
                 '()
                 )
               )))
    (define result (thread-receive))
    (if result
        result
        (begin
          (pretty-print (string-append "timeout " "m=" (number->string m) " kind=" (symbol->string k)))
          #f
          )
        ))
  )

(define-syntax-rule (run/timeoutn n m k x)
  (let ([times '()])
    (for ([_ (in-range time-trials)])
      (set! times (cons (run/timen n m k x) times))
      )
    times
    ))

(define-syntax-rule (run/timeout m k x)
  (run/timeoutn 1 m k x))