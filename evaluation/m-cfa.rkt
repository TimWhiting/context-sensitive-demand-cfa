#lang racket/base
(require (rename-in "table-monad/main.rkt"))
(require "config.rkt" "static-contexts.rkt" "abstract-value.rkt"
         "syntax.rkt" "envs.rkt" "debug.rkt" "primitives.rkt")
(require racket/pretty)
(require racket/match
         racket/list
         racket/set)
(provide meval store)

(define (repeat x m)
  (map (lambda (_) x) (range m))
  )

(define (seql xss)
  (match xss
    ['() (unit '())]
    [(cons x xs)
     (>>= x
          (λ (r)
            (>>= (seql xs)
                 (λ (rs)
                   (unit (cons r rs))
                   ))))]))


(define-key (store addr) #:⊥ litbottom #:⊑ lit-lte #:⊔ lit-union #:product
  ⊥)

(define product-absorb-lit (node-absorb/product litbottom lit-lte lit-union))

(define (((extend-store Ce x env val) k) s)
  ((k #f) ((product-absorb-lit (store (list Ce x env)) val) s))
  )

(define (get-store Ce x env)
  (store (list Ce x env))
  )

(define (get-store-val Ce x env)
  (>>= (get-store (get-rebindce x Ce) x env)
       (λ (val)
         (match val
           [(product/set (list Ce ρ)) (clos Ce ρ)]
           [(product/lattice l) (lit l)]
           ))
       )
  )

(define (store-lookup Ce x ρ)
  (>>=
   ((bind x) Ce ρ)
   (λ (Cex px i)
     (match (analysis-kind)
       ['rebinding
        (match i
          [-1 (clos Ce ρ)] ; Constructors
          [_ (get-store-val Ce x ρ)])] ; lookup in current ctx
       ['exponential
        (match Cex
          [(cons `(bin ,_ ,_ ,_ ,_ ,_ ,_) _)
           (>>= (>>= (out Cex ρ) (bin i))
                (λ (Cex p)
                  (get-store-val Cex x px)))]
          [(cons `(let-bod ,_ ,_ ,_) _)
           (>>= (>>= (out Cex ρ) (bin i))
                (λ (Cex p)
                  (get-store-val Cex x px)))]
          [_
           (match i
             [-1 (error 'constructor `(constructor-should-be-handled ,(show-simple-ctx Ce) ,x))] ; treat as constructor - bound in the original environment
             [_ (get-store-val Cex x px)])]
          )]) ; bound ctx
     )
   ))

(define (lookup-addr Ce x ρ)
  ; (pretty-print `(lookup-addr ,x ,(show-simple-ctx Ce)))
  (>>=
   ((bind x) Ce ρ)
   (λ (Cex px i)
     (match (analysis-kind)
       ['rebinding
        (match i
          [-1
           (unit Ce)] ; Constructors
          [_ (unit (get-rebindce x Ce) ρ)])] ; lookup in current ctx
       ['exponential
        ; (pretty-print `(exponential ,(show-simple-ctx Cex)))
        (match Cex
          [(cons `(bin ,_ ,_ ,_ ,_ ,_ ,_) _)
           (>>= (>>= (out Cex ρ) (bin i))
                (λ (Cex p)
                  (unit (get-rebindce x Cex) px)))]
          [(cons `(let-bod ,_ ,_ ,_) _)
           (>>= (>>= (out Cex ρ) (bin i))
                (λ (Cex p)
                  (unit (get-rebindce x Cex) px)))]
          [_
           (match i
             [-1 (error 'constructor `(constructor-should-be-handled ,(show-simple-ctx Ce) ,x))] ; treat as constructor - bound in the original environment
             [_ (unit (get-rebindce x Cex) px)])]
          )]) ; bound ctx
     )
   ))

(define (symbol-lookup Ce x ρ)
  (match (lookup-primitive x)
    [#f
     (match ((lookup-constructor x) Ce)
       [#f (store-lookup Ce x ρ)]
       [_ (clos Ce ρ)]
       )
     ]
    [Ce (clos Ce ρ)]
    ))

(define (lookup-constructor-vals xs ρ)
  (seql (map (lambda (x) (get-store 'con x ρ)) xs))
  )

(define (get-rebindce var bind)
  (match (analysis-kind)
    ['exponential bind]
    ['rebinding
     (if (equal? bind 'con)
         'con
         (match (lookup-primitive var)
           [#f
            (match ((lookup-constructor var) bind)
              [#f ((rebindce var) bind)]
              [c bind]
              )]
           [p bind]
           )
         )
     ])
  )

(define ((rebindce x) ce)
  (match ce
    [(cons `(top) _) ce]
    [(cons `(bod ,y ,C) e)
     (cons C `(λ ,y ,e))]
    [_ ((rebindce x) (oute ce))]
    )
  )

(define (eval* args)
  (seql (map (λ (a) (>>= a meval)) args))
  )

(define (evalbind* binds vars ρnew args)
  (seql (map (λ (arg var bind)
               (>>= (>>= arg meval)
                    (λ (res)
                      (define ctx (get-rebindce var bind))
                      (extend-store ctx var ρnew res))
                    ))
             args vars binds)))

(define (bind-args binds vars ρ vals)
  (if (and (equal? (length vars) (length vals)) (equal? (length vars) (length binds)))
      (seql (map
             (λ (val var bind)
               (define ctx (get-rebindce var bind))
               (extend-store ctx var ρ val)
               ) vals vars binds))
      ⊥ ; Two closures with different numbers of arguments flow to the same place
      ))

(define (rebind-vars Ce lam vars ρ ρnew)
  (seql
   (map
    (λ (var)
      (>>= (store-lookup (get-rebindce var Ce) var ρ)
           (λ (v)
             (extend-store lam var ρnew v)))
      ) vars)))


(define (bins Ce ρ binds)
  (map car (map
            (λ (i) ((bin-e i) Ce ρ))
            (range (length binds))))
  )

; demand evaluation
(define-key (meval Ce ρ) #:⊥ litbottom #:⊑ lit-lte #:⊔ lit-union #:product
  (print-eval-result
   `(meval ,(show-simple-ctx Ce) ,(show-simple-env ρ))
   (λ ()
     ;  (pretty-print Ce)
     ;  (pretty-print `(meval ,(show-simple-ctx Ce) ,(show-simple-env ρ)))
     (match Ce
       [(cons _ #t) (truecon Ce ρ)]
       [(cons _ #f) (falsecon Ce ρ)]
       [(cons _ (? number? x)) (lit (litnum x))]
       [(cons _ (? string? x)) (lit (litstring x))]
       [(cons _ (? symbol? x))
        (pretty-print `(meval ,(show-simple-ctx Ce) ,(show-simple-env ρ)))
        (symbol-lookup Ce x ρ)]
       [(cons _ `(λ ,_ ,_)) (clos Ce ρ)]
       [(cons _ `',x) (clos Ce ρ)]
       [(cons _ `(lettypes ,_ ,_))
        (>>= (bod Ce ρ) meval)]
       [(cons _ `(let ,binds ,_))
        (>>= (eval* (map
                     (λ (i) ((bin i) Ce ρ))
                     (range (length binds))))
             (λ (evaled-binds)
               (>>= (bind-args (bins Ce ρ binds) (map car binds) ρ evaled-binds)
                    (λ (_)
                      (>>= (bod Ce ρ) meval)))))]
       [(cons _ `(let* ,binds ,_))
        (>>= (evalbind*
              (bins Ce ρ binds)
              (map car binds)
              ρ
              (map
               (λ (i) ((bin i) Ce ρ))
               (range (length binds))))
             (λ (_)
               (>>= (bod Ce ρ) meval)))]
       [(cons _ `(letrec* ,binds ,_))
        (>>= (evalbind*
              (bins Ce ρ binds)
              (map car binds)
              ρ
              (map
               (λ (i) ((bin i) Ce ρ))
               (range (length binds))))
             (λ (_)
               (>>= (bod Ce ρ) meval)))]
       [(cons _ `(letrec ,binds ,_))
        ; Scheme rules state that the recursive definitions should not depend on order
        ; and shouldn't reference each other until they have all been initialized
        ; (as is often the case with recursive lambdas), as such we treat just like normal let
        (>>= (eval* (map
                     (λ (i) ((bin i) Ce ρ))
                     (range (length binds))))
             (λ (evaled-binds)
               (>>= (bind-args (bins Ce ρ binds) (map car binds) ρ evaled-binds)
                    (λ (_)
                      (>>= (bod Ce ρ) meval)))))]
       [(cons _ `(match ,_ ,@clauses))
        (>>=eval (>>= (focus-match Ce ρ) meval)
                 (eval-con-clause Ce ρ clauses 0)
                 (eval-lit-clause Ce ρ clauses 0))]
       [(cons C `(app set! ,var ,_))
        (>>=
         ((ran 1) Ce ρ)
         (λ (valCe _)
           (>>= (lookup-addr Ce var ρ)
                (λ (bindVarCe px)
                  (>>= (meval valCe ρ)
                       (λ (res)
                         (pretty-print (show-simple-ctx bindVarCe))
                         (>>= (extend-store bindVarCe var px res)
                              (λ (_)
                                (clos `((top) app void) ρ))
                              )))))))
        ]
       [(cons C `(app ,f ,@args))
        (>>=clos
         (>>= (rat Ce ρ) meval)
         (λ (lam lamρ)
           (>>= (eval* (map
                        (λ (i) ((ran i) Ce ρ))
                        (range (length args))))
                (λ (evaled-args)
                  (match lam
                    [`(prim ,_ ,_)
                     (apply-primitive lam C ρ evaled-args)]
                    [(cons _ `(λ ,xs ,bod))
                     (>>= (bod-enter lam Ce ρ lamρ)
                          (λ (Ce ρ-new)
                            (>>=
                             (bind-args (repeat Ce (length xs)) xs ρ-new evaled-args)
                             (λ (_)
                               (match (analysis-kind)
                                 ['exponential (meval Ce ρ-new)]
                                 ['rebinding
                                  (define frees (set->list (set-subtract (free-vars `(λ ,xs ,bod)) (apply set xs))))
                                  (>>= (rebind-vars Ce lam frees lamρ ρ-new)
                                       (λ (_)
                                         (meval Ce ρ-new)))]
                                 ))))
                          )]
                    [(cons C con)
                     (if (or (equal? con #t) (equal? con #f) (symbol? con))
                         (let ([argse (map (lambda (i) (car ((ran-e i) Ce ρ))) (range (length args)))])
                           (if (= (length args) 0)
                               (clos `(con ,con) (top-env))
                               (>>= (bind-args (repeat 'con (length argse)) argse ρ evaled-args)
                                    (λ (_) (clos `(con ,con ,Ce) ρ)))
                               ))
                         ⊥ ;(error 'invalid-rator (format "~a" con))
                         )
                     ]
                    ))))

         )
        ]
       [(cons C e) (error 'meval (pretty-format `(can not eval expression: ,e in context ,C)))]
       ))
   ))



(define ((eval-con-clause parent parentρ clauses i) ce ρ)
  ; (pretty-print `(eval-con-clause ,(show-simple-ctx parent) ,(show-simple-ctx ce)))

  (match clauses
    [(cons clause clauses)
     (>>= (pattern-con-matches (car clause) ce ρ)
          (λ (matches)
            (match matches
              [(list vars exprs) ; Matches and binds variables
               (define clauseCe (car ((match-clause-e i) parent parentρ)))
               (>>= (bind-args (repeat clauseCe (length vars)) vars parentρ exprs)
                    (λ (_)
                      (>>= ((match-clause i) parent parentρ) meval)))]
              [#f ((eval-con-clause parent parentρ clauses (+ i 1)) ce ρ)] ; Doesn't match
              [#t (>>= ((match-clause i) parent parentρ) meval)] ; Matches, but doesn't bind anything
              )
            ))]
    [_ ⊥]
    ))

(define ((eval-lit-clause parent parentρ clauses i) lit)
  ; (pretty-print `(eval-lit-clause))
  (match clauses
    [(cons clause clauses)
     (>>= (pattern-lit-matches (car clause) lit)
          (λ (matches)
            (match matches
              [#f ((eval-lit-clause parent parentρ clauses (+ i 1)) lit)]
              [#t (>>= ((match-clause i) parent parentρ) meval)]
              [(list vars exprs)
               (define clauseCe (car ((match-clause-e i) parent parentρ)))
               (>>= (bind-args (repeat clauseCe (length vars)) vars parentρ exprs)
                    (λ (_)
                      (>>= ((match-clause i) parent parentρ) meval)))
               ])))]
    [_ ⊥]
    ))

(define (pattern-matches pat val)
  (match val
    [(product/lattice l) (pattern-lit-matches pat l)]
    [(product/set (list Ce ρ)) (pattern-con-matches pat Ce ρ)]
    )
  )

(define (pattern-lit-matches pattern lit2)
  (match pattern
    [(? symbol? pat) (unit (list (list pat) (list (product/lattice lit2))))]
    [lit1 (unit (equal? (to-lit lit1) lit2))]
    ))

(define (pattern-con-matches pattern Ce ρ)
  (match pattern
    [`(,con ,@subpats)
     (match Ce
       [`(con ,con1)
        (if (eq? con con1) (unit #t) (unit #f))
        ]
       [`(con ,con1 ,Ce)
        (define args (map (lambda (i) (car ((ran-e i) Ce ρ))) (range (length (args-e Ce)))))
        (if (and (equal? con con1) (equal? (length args) (length subpats)))
            (begin
              (>>= (lookup-constructor-vals args ρ)
                   (λ (vals)
                     (let loop ([subpats subpats] [vals vals])
                       (if (empty? subpats) (unit (list (list) (list)))
                           (>>= (pattern-matches (car subpats) (car vals))
                                (λ (res)
                                  (match res
                                    [#f (unit #f)]
                                    [#t (loop (cdr subpats) (cdr vals))]
                                    [(list carbinds carvals)
                                     (>>= (loop (cdr subpats) (cdr vals))
                                          (λ (ress)
                                            (match ress
                                              [#f (unit #f)]
                                              [(list binds vals)
                                               (unit (list (append carbinds binds) (append carvals vals)))])
                                            ))
                                     ]
                                    ))
                                ))))))
            (unit #f))
        ]
       [(cons C `',x)
        (unit #f)
        ]
       [Ce
        (if (equal? pattern `(#t)); Truthy
            (unit #t); if Ce is a constructor it would be caught earlier
            (if (equal? pattern `(#f)) ; Falsey
                (unit #f) ; if Ce is a constructor it would be caught earlier
                ⊥
                ; (error 'pattern-con-match (format "no-matching-pattern for ~a" (show-simple-ctx Ce)))
                ))]
       )
     ]
    [`',x
     (match Ce
       [(cons C `',x1)
        (if (eq? x x1) (unit #t) (unit #f))
        ]
       [_ (unit #f)]
       )]
    [(? symbol? x)
     (if (eq? x '_) (unit (list (list) (list)))
         (>>= (clos Ce ρ) (λ (res) (unit (list (list x) (list res))))))]
    [lit1
     (match Ce
       [(cons _ con1); Singleton constructor
        (if (equal? lit1 con1)
            (unit #t)
            (unit #f)
            )])
     ]))

