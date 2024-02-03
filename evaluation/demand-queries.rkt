#lang racket/base
(require "config.rkt" "envs.rkt" "static-contexts.rkt")
(require racket/match racket/list)
(provide (all-defined-out))

(define (basic-queries exp)
  (analysis-kind 'basic)
  (gen-queries (cons `(top) exp) (menv (list)))
  )

(define (hybrid-queries exp)
  (analysis-kind 'basic)
  (gen-queries (cons `(top) exp) (envenv (list)))
  )

(define (gen-queries Ce ρ)
  (define self-query (list Ce ρ))
  (define child-queries (match Ce
                          [(cons _ `(app ,_ ,@args))
                           (foldl append (list)
                                  (cons (apply gen-queries (rat-e Ce ρ))
                                        (map (λ (i)
                                               (apply gen-queries (ran-e Ce ρ i)))
                                             (range (length args)))))]
                          [(cons _ `(λ ,_ ,_))
                           (apply gen-queries (bod-e Ce ρ))]
                          [(cons _ `(let ,binds ,_))
                           (foldl append (list)
                                  (cons (apply gen-queries (bod-e Ce ρ))
                                        (map (λ (i)
                                               (apply gen-queries (bin-e Ce ρ i)))
                                             (range (length binds)))))
                           ]
                          [(cons _ `(match ,_ ,@ms))
                           (foldl append (list)
                                  (cons (apply gen-queries (focus-match-e Ce ρ))
                                        (map (λ (i)
                                               (apply gen-queries (focus-clause-e Ce ρ i)))
                                             (range (length ms)))))]
                          [_ (list)]))
  (cons self-query child-queries))