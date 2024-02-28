#lang racket/base
(require "config.rkt" "envs.rkt" "static-contexts.rkt" "syntax.rkt")
(require racket/match racket/list)
(provide (all-defined-out))

(define (basic-queries exp)
  (analysis-kind 'basic)
  (gen-queries (cons `(top) exp) (menv (list)))
  )

(define (gen-queries Ce ρ)
  (define self-query (list Ce ρ))
  (define child-queries (match Ce
                          [(cons _ `(app ,_ ,@args))
                           (foldl append (list)
                                  (cons (apply gen-queries (rat-e Ce ρ))
                                        (map (λ (i)
                                               (apply gen-queries ((ran-e i) Ce ρ)))
                                             (range (length args)))))]
                          [(cons _ `(λ ,_ ,_))
                           (apply gen-queries (bod-e Ce ρ))]
                          [(cons _ `(lettypes ,_ ,_))
                           (apply gen-queries (bod-e Ce ρ))]
                          [(cons _ `(match ,_ ,@ms))
                           (foldl append (list)
                                  (cons (apply gen-queries (focus-match-e Ce ρ))
                                        (map (λ (i)
                                               (apply gen-queries ((match-clause-e i) Ce ρ)))
                                             (range (length ms)))))]
                          [(cons _ `(,let-kind ,binds ,_))
                           (check-let let-kind)
                           (foldl append (list)
                                  (cons (apply gen-queries (bod-e Ce ρ))
                                        (map (λ (i)
                                               (apply gen-queries ((bin-e i) Ce ρ)))
                                             (range (length binds)))))
                           ]
                          [_ (list)]))
  ; (if (is-instant-query self-query)
  ; child-queries
  (cons self-query child-queries)
  ); )