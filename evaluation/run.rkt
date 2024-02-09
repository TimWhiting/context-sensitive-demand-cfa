#lang racket/base
(require "config.rkt" racket/pretty racket/match)
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
    (define result #f)
    (if (sync/timeout
         (/ (* timeout acc-trials) n)
         (thread (lambda ()
                   (analysis-kind k)
                   (current-m m)
                   (with-handlers ([exn:fail? (λ (err) (set! result `(#f ,err)))])
                     (let ((res x))
                       (set! result `(#t ,res))
                       )
                     )
                   )))
        (match result
          [`(#t ,v) v]
          [`(#f ,err)
           (pretty-display (string-append "error " "m=" (number->string m) " kind=" (symbol->string k) " " (pretty-format err)))
           err])
        (pretty-display (string-append "timeout " "m=" (number->string m) " kind=" (symbol->string k) " time=" (number->string (current-milliseconds))))
        )))

(define-syntax-rule (run/timeoutn n m k x)
  (let ([times '()])
    (for ([_ (in-range time-trials)])
      (set! times (cons (run/timen n m k x) times))
      )
    times
    ))

(define-syntax-rule (run/timeout m k x)
  (run/timeoutn 1 m k x))