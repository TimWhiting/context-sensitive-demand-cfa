#lang racket/base
(require (rename-in "table-monad/main.rkt" [void fail]))
(require "config.rkt" "static-contexts.rkt" "demand-abstraction.rkt" "debug.rkt" "demand-primitives.rkt")
(require racket/pretty)
(require racket/match
         racket/list)


(define (eval* args)
  (let loop ([ags args]
             [acc (list)])
    (match ags
      [(list) (unit acc)]
      [(cons e as) (>>= e (λ (ce p) (>>= (eval ce p) (λ (r) (loop as (append acc (list r)))))))]
      )
    )
  )

; demand evaluation
(define-key (eval Ce ρ) #:⊥ litbottom #:⊑ lit-lte #:⊔ lit-union #:product
  (print-eval-result
   `(eval ,Ce ,ρ)
   (λ ()
     (⊔ (match Ce
          [(cons _ #t) (clos Ce ρ)]
          [(cons _ #f) (clos Ce ρ)]
          [(cons _ (? integer? x)) (lit (litint x))]
          [(cons _ (? symbol? x))
           (>>= (bind x Ce ρ) eval)] ; TODO: Fix this
          [(cons _ `(λ ,_ ,_))
           (clos Ce ρ)]
          [(cons C `(app ,@args))
           (pretty-trace `(APP ,ρ))
           (>>=clos
            (>>= (rat Ce ρ) eval)
            (λ (Ce′ ρ′)
              ; (pretty-trace `(got closure or primitive ,Ce′))
              (match Ce′
                [`(prim ,_)
                 (pretty-trace `(eval args prim: ,args))
                 (>>= (eval* (map
                              (λ (i) (ran Ce ρ i))
                              (range (- (length args) 1))))
                      (λ (args)
                        (pretty-trace `(applying prim: ,Ce′ ,args))
                        (apply-primitive Ce′ C ρ args)))]
                [(cons _ `(λ ,_ ,_)); TODO: Bind args in environment and allocate addresses
                 (>>= (bod Ce′ Ce ρ ρ′) (debug-eval 'app-eval eval))
                 ]
                [con (clos con ρ′)]
                )
              ))
           ]
          [(cons _ `(let ,_ ,_))
           ; TODO: Bind bindings in environment and evaluate them in order
           (>>= (bod Ce ρ) eval)]
          [(cons _ `(match ,_ ,@clauses))
           (>>= (focus-match Ce ρ) (eval-clause Ce clauses 0))] ; TODO: Sequence this into the
          [(cons C e) (error 'eval (pretty-format `(can not eval expression: ,e in context ,C)))]
          )
        (>>= (get-refines* `(eval ,Ce ,ρ) ρ)
             (λ (ρ′) (eval Ce ρ′)))))))


(define ((eval-clause parent clauses i) ce p)
  (match clauses
    [(cons clause clauses)
     (>>= (pattern-matches (car clause) ce p)
          (λ (matches)
            ; (pretty-print `(clause-res ,matches))
            (if matches
                (>>= (focus-clause parent p i) eval)
                ((eval-clause parent clauses (+ i 1)) ce p)
                )))]
    [_ (clos (cons ce 'match-error) p)]
    ))

(define-key (pattern-matches pattern ce p)
  (match pattern
    [`(,con ,@subpats) (unit #f)]
    [(? symbol? _) (unit #t)] ; Variable binding
    [lit1
     (>>=eval (eval ce p)
              (λ (Ce _)
                (match Ce
                  [(cons _ con1); Singleton constructor
                   ;  (pretty-print `(match-singleton constructor ,Ce ,con1 ,lit1 ,(equal? lit1 con1)))
                   (if (equal? lit1 con1)
                       (unit #t)
                       (unit #f)
                       )]))
              (λ (lit2) (unit (equal? (to-lit lit1) lit2))))
     ]
    )
  )
