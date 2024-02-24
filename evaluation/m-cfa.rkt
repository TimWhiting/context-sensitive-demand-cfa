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

(define (eval* args)
  (match args
    [(list) (unit (list))]
    [(cons e as)
     (>>= e; This is just a compuation i.e. ((ran i) Ce ρ) and needs to be evaluated
          (λ (e ρ)
            (>>= (eval* as)
                 (λ (ress)
                   (>>= (meval e ρ)
                        (λ (res) (unit (cons res ress)))
                        )))))]
    ))

(define (evalbind* ces vars ρnew args)
  ; (pretty-print (map show-simple-ctx binds))
  (match args
    [(list) (unit (list))]
    [(cons arg args)
     (match-let ([(cons var vars) vars]
                 [(cons bind binds) ces])
       (>>= (>>= arg meval); This is just a compuation i.e. ((ran i) Ce ρ) and needs to be evaluated
            (λ (res)
              ; (pretty-print `(evalbind* ,(show-simple-ctx (car ces)) ,var ,(show-simple-result res) ,(show-simple-env ρnew)))
              (>>= (extend-store bind var ρnew res)
                   (λ (_) (evalbind* binds vars ρnew args))))

            ))
     ]
    )
  )

(define-key (store addr) #:⊥ litbottom #:⊑ lit-lte #:⊔ lit-union #:product
  ⊥)

(define product-absorb-lit (node-absorb/product litbottom lit-lte lit-union))

(define (((extend-store Ce x env val) k) s)
  (match (analysis-kind)
    ['rebinding ((k #f) ((product-absorb-lit (store (list '_ x env)) val) s))]
    ['exponential ((k #f) ((product-absorb-lit (store (list Ce x env)) val) s))]
    )
  ; (pretty-print `(extend-store ,(show-simple-ctx Ce) ,x ,(show-simple-env env) ,(show-simple-result val)))
  )

(define (get-store Ce x env)
  ; (pretty-print `(store-lookup ,(show-simple-ctx Ce) ,x ,(show-simple-env env)))
  (match (analysis-kind)
    ['rebinding (store (list '_ x env))]
    ['exponential (store (list Ce x env))]
    )
  )

(define (get-store-val Ce x env)
  (>>= (get-store Ce x env)
       (λ (val)
         ;  (pretty-print `(store-lookup-got ,val))
         (match val
           [(product/set (list Ce ρ)) (clos Ce ρ)]
           [(product/lattice l) (lit l)]
           ))
       )
  )

(define (bind-args ces vars ρ values)
  (if (and (equal? (length vars) (length values)) (equal? (length vars) (length ces)))
      (match vars
        [(list) (unit #f)]
        [(cons var vars)
         ;  (pretty-print `(bind-args ,(show-simple-ctx (car ces)) ,var ,(show-simple-result (car values))))
         (>>= (extend-store (car ces) var ρ (car values))
              (λ (_) (bind-args (cdr ces) vars ρ (cdr values))))])
      ⊥ ; Two closures with different numbers of arguments flow to the same place
      ;(error 'invalid-num-args (format "in bind args got ~a ~a" vars (map show-simple-result values)))
      ))

(define (rebind-vars Ce vars ρ ρnew)
  (match vars
    [(list) (unit #f)]
    [(cons var vars)
     (match (lookup-primitive var)
       [#f
        ; (pretty-print `(rebind-vars ,(show-simple-ctx Ce) ,var ,(show-simple-env ρ) ,(show-simple-env ρnew)))
        (>>=
         ((bind var) Ce ρ)
         (λ (Cex __ i)
           (match i
             [-1

              ; (pretty-print `(no-rebind-con ,var))
              (rebind-vars Ce vars ρ ρnew)]
             [_  (>>= (store-lookup Ce var ρ)
                      (λ (v)
                        ; (pretty-print `(rebind-var ,(show-simple-ctx Ce) ,var ,(show-simple-env ρnew) ,(show-simple-result v)))
                        (>>= (extend-store Ce var ρnew v)
                             (λ (_) (rebind-vars Ce vars ρ ρnew)))))])
           ))
        ]
       [_
        ; (pretty-print `(no-rebind-prim ,var))
        (rebind-vars Ce vars ρ ρnew)]
       )
     ]))


(define (store-lookup Ce x ρ)
  (>>=
   ((bind x) Ce ρ)
   (λ (Cex px i)
     (match (analysis-kind)
       ['rebinding (get-store-val '_ x ρ)] ; lookup ctx
       ['exponential
        (match Cex
          [(cons `(bin ,_ ,_ ,_ ,_ ,_ ,_) _)
           (>>= (>>= (out Cex ρ) (bin i))
                (λ (Cex p)
                  ; (pretty-print `(let-bin-lookup ,(show-simple-ctx Cex) ,i ,(show-simple-env plookup)))
                  (get-store-val Cex x px)))]
          [(cons `(let-bod ,_ ,_ ,_) _)
           (>>= (>>= (out Cex ρ) (bin i))
                (λ (Cex p)
                  ; (pretty-print `(let-bod-lookup ,(show-simple-ctx Cex) ,i ,(show-simple-env plookup)))
                  (get-store-val Cex x px)))]
          [_
           (match i
             [-1
              ;  (pretty-print `(returning-cons ,Ce ,ρ))
              (clos Ce ρ)] ; treat as constructor - bound in the original environment
             [_
              ; (pretty-print "lookup")
              ; (pretty-print `(store-lookup ,(show-simple-ctx Cex) ,x ,(show-simple-env ρ)))
              (get-store-val Cex x px)
              ])]
          )]) ; bound ctx
     )
   ))


(define (symbol-lookup Ce x ρ)
  (match (lookup-primitive x)
    [#f (store-lookup Ce x ρ)]
    [Ce (clos Ce ρ)]
    ))

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
     (match Ce
       [(cons _ #t) (truecon Ce ρ)]
       [(cons _ #f) (falsecon Ce ρ)]
       [(cons _ (? integer? x)) (lit (litint x))]
       [(cons _ (? string? x)) (lit (litstring x))]
       [(cons _ (? symbol? x)) (symbol-lookup Ce x ρ)]
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
                      ; (pretty-print `(bound-let-vars ,(map car binds) ,ρ ,evaled-binds))
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
               ; (pretty-print `(bound-let-vars ,(map car binds) ,ρ ,evaled-binds))
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
               ; (pretty-print `(bound-let-vars ,(map car binds) ,ρ ,evaled-binds))
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
                      ; (pretty-print `(bound-let-vars ,(map car binds) ,ρ ,evaled-binds))
                      (>>= (bod Ce ρ) meval)))))]
       [(cons _ `(match ,_ ,@clauses))
        (>>=eval (>>= (focus-match Ce ρ) meval)
                 (eval-con-clause Ce ρ clauses 0)
                 (eval-lit-clause Ce ρ clauses 0))]
       [(cons C `(app ,f ,@args))
        ; (pretty-trace `(eval-fun ,f ,(show-simple-env ρ)))
        (>>=clos
         (>>= (rat Ce ρ) meval)
         (λ (lam lamρ)
           ;  (pretty-trace `(eval-args ,lam ,args))
           (>>= (eval* (map
                        (λ (i) ((ran i) Ce ρ))
                        (range (length args))))
                (λ (evaled-args)
                  ; (pretty-print `(evaled-args ,(map show-simple-result evaled-args)))
                  (match lam
                    [`(prim ,_ ,_)
                     ;  (pretty-trace `(applying prim: ,lam ,args))
                     (apply-primitive lam C ρ evaled-args)]
                    [(cons _ `(λ ,xs ,bod))
                     ;  (pretty-print `(applying closure: ,lam ,args ,ρ))
                     ;  (pretty-print `(applying closure: ,lam ,args ,ρ ,lamρ ,evaled-args))
                     (>>= (bod-enter lam Ce ρ lamρ)
                          (λ (Ce ρ-new)
                            ;  (pretty-print `(binding in ,ρ-new))
                            (>>=
                             (bind-args (repeat Ce (length xs)) xs ρ-new evaled-args)
                             (λ (_)
                               (match (analysis-kind)
                                 ['exponential (meval Ce ρ-new)]
                                 ['rebinding
                                  (define frees (set->list (set-subtract (free-vars `(λ ,xs ,bod)) (apply set xs))))
                                  (>>= (rebind-vars Ce frees lamρ ρ-new)
                                       (λ (_) (meval Ce ρ-new)))]
                                 ))))
                          )]
                    [(cons C con)
                     (if (or (equal? con #t) (equal? con #f) (symbol? con))
                         (let ([argse (map (lambda (i) (car ((ran-e i) Ce ρ))) (range (length args)))])
                           ;  (pretty-print con)
                           ;  (pretty-print `(conapp ,con))
                           (if (= (length args) 0)
                               (clos `(con ,con) (top-env))
                               (>>= (bind-args (repeat 'con (length argse)) argse ρ evaled-args)
                                    (λ (_) (clos `(con ,con ,Ce) ρ)))
                               ))
                         (error 'invalid-rator (format "~a" con))
                         )
                     ]
                    ))))

         )
        ]
       [(cons C e) (error 'meval (pretty-format `(can not eval expression: ,e in context ,C)))]
       ))
   ))


(define ((eval-con-clause parent parentρ clauses i) ce ρ)
  ; (pretty-print `(eval-con-clause ,ce ,ρ))
  (match clauses
    [(cons clause clauses)
     (>>= (pattern-con-matches (car clause) ce ρ)
          (λ (matches)
            ; (pretty-print `(clause-res ,matches))
            (match matches
              [(list vars exprs) ; Matches and binds variables
               (define clauseCe (car ((match-clause-e i) parent parentρ)))
               ;  (pretty-print `(pattern ,(car clause) binds ,vars to ,(map show-simple-result exprs) in ,(show-simple-ctx clauseCe)))
               (>>= (bind-args (repeat clauseCe (length vars)) vars parentρ exprs)
                    (λ (_)
                      ; (pretty-print 'finished-binding)
                      (>>= ((match-clause i) parent parentρ) meval)))]
              [#f ((eval-con-clause parent parentρ clauses (+ i 1)) ce ρ)] ; Doesn't match
              [#t (>>= ((match-clause i) parent parentρ) meval)] ; Matches, but doesn't bind anything
              )
            ))]
    [_ ;(clos (cons parent 'match-error) parentρ)
     ;  (pretty-print `(match-error ,(show-simple-ctx (car (focus-match-e parent parentρ))) ,(show-simple-ctx ce)))
     ⊥]
    ))

(define ((eval-lit-clause parent parentρ clauses i) lit)
  (match clauses
    [(cons clause clauses)
     (>>= (pattern-lit-matches (car clause) lit)
          (λ (matches)
            ; (pretty-print `(clause-res ,matches))
            (match matches
              [#f ((eval-lit-clause parent parentρ clauses (+ i 1)) lit)]
              [#t (>>= ((match-clause i) parent parentρ) meval)]
              [(list vars exprs)
               (define clauseCe (car ((match-clause-e i) parent parentρ)))
               (>>= (bind-args (repeat clauseCe (length vars)) vars parentρ exprs)
                    (λ (_)
                      (>>= ((match-clause i) parent parentρ) meval)))
               ])))]
    [_ ;(clos (cons parent 'match-error) parentρ)
     ;  (pretty-print `(match-error ,(show-simple-ctx (car (focus-match-e parent parentρ))) ,(show-simple-literal lit)))
     ⊥
     ]
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


(define (store-lookup-vals xs ρ)
  ; (pretty-print `(lookup ,(map show-simple-ctx xs)))
  ; (>>=
  (lookup-all (map (lambda (x) (get-store 'con x ρ)) xs))
  ;  (λ (xs)
  ;  (pretty-print `(lookup-result ,(map show-simple-result xs)) )
  ;  xs))
  )

(define (lookup-all xss)
  (match xss
    ['() (unit '())]
    [(cons x xs)
     (>>= (lookup-all xs)
          (λ (rs)
            (>>= x ; (store ...)
                 (λ (r)
                   (unit (cons r rs))
                   ))))]))

(define (pattern-con-matches pattern Ce ρ)
  ; (pretty-print `(con-matches ,pattern ,(show-simple-ctx Ce) ,(show-simple-env ρ)))
  (match pattern
    [`(,con ,@subpats)
     (match Ce
       [`(con ,con1)
        (if (eq? con con1) (unit #t) (unit #f))
        ]
       [`(con ,con1 ,Ce)
        (define args (map (lambda (i) (car ((ran-e i) Ce ρ))) (range (length (args-e Ce)))))
        ; (pretty-print `(matching-con-clause ,con ,con1 ,(length args) ,(length subpats)))
        (if (and (equal? con con1) (equal? (length args) (length subpats)))
            (begin
              ; (pretty-print `(looking-up ,@(map show-simple-ctx args)))
              (>>= (store-lookup-vals args ρ)
                   (λ (vals)
                     ;  (pretty-print `(matching ,vals to ,subpats))
                     (let loop ([subpats subpats] [vals vals])
                       ;  (pretty-print `(matching ,(map show-simple-result vals) to ,subpats))
                       (if (empty? subpats) (unit (list (list) (list)))
                           (>>= (pattern-matches (car subpats) (car vals))
                                (λ (res)
                                  ; (pretty-print `(matched ,(car subpats) ,(show-simple-result (car vals)) ,res))
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
       [_ (error 'pattern-con-match (format "no-matching-pattern for ~a" (show-simple-ctx Ce)))]
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
     ;  (pretty-print `(matches-symbol ,x ,Ce))
     (if (eq? x '_) (unit (list (list) (list)))
         (>>= (clos Ce ρ) (λ (res) (unit (list (list x) (list res))))))]
    [lit1
     (match Ce
       [(cons _ con1); Singleton constructor
        ;  (pretty-print `(match-singleton constructor ,Ce ,con1 ,lit1 ,(equal? lit1 con1)))
        (if (equal? lit1 con1)
            (unit #t)
            (unit #f)
            )])
     ]))


