#lang racket/base
(require "config.rkt" racket/pretty racket/match)
(provide (all-defined-out))

(define-syntax-rule (run/parameters name m k x)
  (let ()
    (analysis-kind k)
    (current-m m)
    (define start (current-inexact-monotonic-milliseconds))
    (let ([res x])
      (define end (current-inexact-monotonic-milliseconds))
      (cons res (- end start)))
    )
  )

(define-syntax-rule (run/time x)
  (let* ([start-time (current-inexact-monotonic-milliseconds)]
         [res x]
         [end-time (current-inexact-monotonic-milliseconds)]
         [total-time (- end-time start-time)])
  (values res total-time)
))

(define-syntax-rule (run/catch name m k info x)
  (let* ([_ (analysis-kind k)]
         [_ (current-m m)]
         [res (with-handlers ([exn:fail? (λ (err) `(#f ,err))])
            (let ([result x])
              `(#t ,result)
              ))])
  (match res
    [`(#t ,v)
      ;  (pretty-print `(result ,v))
      v]
    [`(#f ,err)
      (pretty-display (format "error in ~a! m=~a kind=~a: error ~a info=~a" name m k err info))
      `(#f ,(format "~a" err))]
    [_
      (pretty-display (format "timeout in ~a! m=~a kind=~a: time=~a info=~a" name m k (current-milliseconds) info))
      #f
      ]
    )))