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

(define-syntax-rule (run/timen name n m k x)
  (let* [
         (result (make-channel))
         (timeout-ms (/ (* timeout acc-trials) n))
         ;  (_ (pretty-print timeout-ms))
         (alarm (alarm-evt (+ (current-inexact-monotonic-milliseconds) timeout-ms) #t))
         (thd (thread
               (lambda ()
                 (analysis-kind k)
                 (current-m m)
                 (with-handlers ([exn:fail? (λ (err) (channel-put result `(#f ,err)))])
                   (let ((res x))
                     (channel-put result `(#t ,res))
                     )
                   )
                 )))
         (res (sync result alarm))
         ]
    (kill-thread thd)
    (match res
      [`(#t ,v)
       ;  (pretty-print `(result ,v))
       v]
      [`(#f ,err)
       (pretty-display (format "error in ~a! m=~a kind=~a: error ~a" name m k err))
       `(#f ,(format "~a" err))]
      [_
       (pretty-display (format "timeout in ~a! m=~a kind=~a: time=~a" name m k (current-milliseconds)))
       #f
       ]
      )))

(define-syntax-rule (run/timeoutn name n m k x)
  (let ([times '()])
    (for ([_ (in-range time-trials)])
      (set! times (cons (run/timen name n m k x) times))
      )
    times
    ))

(define-syntax-rule (run/timeout name m k x)
  (run/timeoutn name 1 m k x))