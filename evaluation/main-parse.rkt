#lang racket/base
(require "all-examples.rkt" "config.rkt")
(require racket/pretty racket/match)

(module+ main
  (show-envs-simple #t)
  (show-envs #f)
  (define hand-checked '(structural-rec prim-match multi-param let let-num id err constr
                                        basic-letstar basic-letrec app-num sat-small
                                        tak sat-3 sat-2 sat-1 kcfa-3 kcfa-2 cpstak
                                        church blur ack tic-tac-toe))
  (for ([example (remove-examples (append hand-checked untested))])
    (match-let ([`(example ,name ,exp) example])
      (displayln name)
      (pretty-print exp)
      )
    )
  (define out (open-output-file "tests/syntax.rkt" #:exists 'replace))
  (for ([example (get-examples hand-checked)])
    (match-let ([`(example ,name ,exp) example])
      (pretty-print name out)
      (pretty-print exp out)
      )
    )
  )

