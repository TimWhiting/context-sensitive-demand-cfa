#lang racket/base
(require (rename-in "table-monad/main.rkt"))
(require "config.rkt" "static-contexts.rkt" "demand-abstraction.rkt"
         "syntax.rkt" "envs.rkt" "debug.rkt" "demand-primitives.rkt")
(require racket/pretty)
(require racket/match
         racket/list
         racket/set)
(provide meval)

(define (eval* args)
  (match args
    [(list) (unit (list))]
    [(cons e as)
     (>>= e; This is just a compuation i.e. (ran Ce ρ i) and needs to be evaluated
          (λ (e ρ)
            (>>= (eval* as)
                 (λ (ress)
                   (>>= (meval e ρ)
                        (λ (res) (unit (cons res ress)))
                        )))))]
    ))

(define-key (store addr) #:⊥ litbottom #:⊑ lit-lte #:⊔ lit-union #:product
  ⊥)

(define (extend-store var env val)
  ; (pretty-print "extend")
  ; (pretty-print `(extend-store ,var ,(show-simple-env env) ,(show-simple-result val)))
  ; (store (cons var env))
  (extend-store-internal var env val)
  )
(define product-absorb-lit (node-absorb/product litbottom lit-lte lit-union))

(define (((extend-store-internal var env val) k) s)
  ((k #f) ((product-absorb-lit (store (cons var env)) val) s)))

(define (get-store var env)
  (store (cons var env)))

(define (bind-args vars ρ values)
  ; (pretty-print `(bind-args ,vars ,(show-simple-env ρ) ,(map show-simple-result values)))
  (if (equal? (length vars) (length values))
      (match vars
        [(list) (unit #f)]
        [(cons var vars)
         ;  (pretty-print "extend")
         (>>= (extend-store var ρ (car values))
              (λ (_) (bind-args vars ρ (cdr values))))])
      ⊥))

(define (rebind-vars Ce vars ρ ρnew)
  ; (pretty-print `(rebind-vars ,(show-simple-ctx Ce) ,vars ,(show-simple-env ρ) ,(show-simple-env ρnew)))
  (match vars
    [(list) (unit #f)]
    [(cons var vars)
     (match (lookup-primitive var)
       [#f
        (>>=
         (bind var Ce ρ)
         (λ (_ __ i)
           (match i
             [-1 (rebind-vars Ce vars ρ ρnew)]
             [_  (>>= (get-store var ρ)
                      (λ (v)
                        (>>= (extend-store var ρnew v)
                             (λ (_) (rebind-vars Ce vars ρ ρnew)))))])
           ))
        ]
       [_ (rebind-vars Ce vars ρ ρnew)]
       )
     ]))

(define (store-lookup Ce x ρ)
  (>>=
   (bind x Ce ρ)
   (λ (_ ρ i)
     (match i
       [-1
        ; (pretty-print `(returning-cons ,Ce ,ρ))
        (clos Ce ρ)] ; treat as constructor]
       [_
        ; (pretty-print "lookup")
        ;  (pretty-print `(store-lookup ,x ,ρ))
        (>>= (get-store x ρ)
             (λ (val)
               ; (pretty-print `(store-lookup got ,val ,x ,ρ))
               (match val
                 [(product/set (list Ce ρ)) (clos Ce ρ)]
                 [(product/lattice l) (lit l)]
                 ))
             )]))))

(define (symbol-lookup Ce x ρ)
  (match (lookup-primitive x)
    [#f (store-lookup Ce x ρ)]
    [Ce (clos Ce ρ)]
    )
  )

; demand evaluation
(define-key (meval Ce ρ) #:⊥ litbottom #:⊑ lit-lte #:⊔ lit-union #:product
  ; (pretty-print "meval")
  (print-eval-result
   `(meval ,(show-simple-ctx Ce) ,(show-simple-env ρ))
   (λ ()
     (match Ce
       [(cons _ #t) (clos Ce ρ)]
       [(cons _ #f) (clos Ce ρ)]
       [(cons _ (? integer? x)) (lit (litint x))]
       [(cons _ (? symbol? x)) (symbol-lookup Ce x ρ)]
       [(cons _ `(λ ,_ ,_)) (clos Ce ρ)]
       [(cons _ `(let ,binds ,_))
        (>>= (eval* (map
                     (λ (i) (bin Ce ρ i))
                     (range (length binds))))
             (λ (evaled-binds)
               (>>= (bind-args (map car binds) ρ evaled-binds); TODO: Do we need a new environment (just ensure alphatized)?
                    (λ (_)
                      ; (pretty-print `(bound-let-vars ,(map car binds) ,ρ ,evaled-binds))
                      (>>= (bod Ce ρ) meval)))))]
       [(cons _ `(match ,_ ,@clauses))
        (>>=eval (>>= (focus-match Ce ρ) meval)
                 (eval-con-clause Ce ρ clauses 0)
                 (eval-lit-clause Ce ρ clauses 0))]
       [(cons C `(app ,f ,@args))
        (pretty-trace `(eval-fun ,f ,(show-simple-env ρ)))
        (>>=clos
         (>>= (rat Ce ρ) meval)
         (λ (lam lamρ)
           (pretty-trace `(eval-args ,args))
           (>>= (eval* (map
                        (λ (i) (ran Ce ρ i))
                        (range (length args))))
                (λ (evaled-args)
                  ; (pretty-trace `(got closure or primitive ,(show-simple-ctx lam)))
                  (match lam
                    [`(prim ,_)
                     (pretty-trace `(applying prim: ,lam ,args))
                     (apply-primitive lam C ρ evaled-args)]
                    [(cons _ `(λ ,xs ,bod))
                     ; (pretty-print `(applying closure: ,lam ,args ,ρ))
                     ;  (pretty-print `(applying closure: ,lam ,args ,ρ ,lamρ ,evaled-args))
                     (>>= (bod-enter lam Ce ρ lamρ)
                          (λ (Ce ρ-new)
                            ;  (pretty-print `(binding in ,ρ-new))
                            (>>=
                             (bind-args xs ρ-new evaled-args)
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
                     ; (pretty-print `(con))
                     (>>= (bind-args (range (length args)) ρ evaled-args)
                          (λ (_) (clos (cons Ce con) lamρ)))]
                    ))))

         )
        ]
       [(cons C e) (error 'meval (pretty-format `(can not eval expression: ,e in context ,C)))]
       ))))


(define ((eval-con-clause parent parentρ clauses i) ce ρ)
  ; (pretty-print `(eval-con-clause ,ce ,ρ))
  (match clauses
    [(cons clause clauses)
     (>>= (pattern-con-matches (car clause) ce ρ)
          (λ (matches)
            ; (pretty-print `(clause-res ,matches))
            (match matches
              [(list (list vars) (list exprs)) ; Matches and binds variables
               ;  (pretty-print `(pattern ,(car clause) binds ,vars to ,exprs))
               (>>= (bind-args vars parentρ exprs)
                    (λ (_)
                      (>>= (focus-clause parent parentρ i) meval)))]
              [#f ((eval-con-clause parent parentρ clauses (+ i 1)) ce ρ)] ; Doesn't match
              [#t (>>= (focus-clause parent parentρ i) meval)] ; Matches, but doesn't bind anything
              )
            ))]
    [_ (clos (cons parent 'match-error) parentρ)]
    ))

(define ((eval-lit-clause parent parentρ clauses i) lit)
  (match clauses
    [(cons clause clauses)
     (>>= (pattern-lit-matches (car clause) lit)
          (λ (matches)
            ; (pretty-print `(clause-res ,matches))
            (if matches
                (>>= (focus-clause parent parentρ i) meval)
                ((eval-con-clause parent clauses (+ i 1)) lit)
                )))]
    [_ (clos (cons parent 'match-error) parentρ)]
    ))

(define (store-lookups vars ρ)
  (match vars
    [(list) (unit (list))]
    [(cons var vars)
     (>>= (store-lookups vars ρ)
          (λ (vals)
            (>>= (get-store var ρ)
                 (λ (val)
                   (unit (cons val vals))))))]
    ))

(define (pattern-matches pat val)
  (match val
    [(product/lattice l) (pattern-lit-matches pat l)]
    [(product/set (list Ce ρ)) (pattern-con-matches pat Ce ρ)]
    )
  )

(define (pattern-con-matches pattern Ce ρ)
  (match pattern
    [`(,con ,@subpats)
     (match Ce
       [(cons (cons C `(app ,f ,@args)) con1)
        (if (and (equal? con con1) (equal? (length args) (length subpats)))
            (>>= (store-lookups (range (length args)) ρ)
                 (λ (vals)
                   ;  (pretty-print `(matching ,vals to ,subpats))
                   (let loop ([subpats subpats] [vals vals])
                     (if (empty? subpats) (unit (list (list) (list)))
                         (>>= (pattern-matches (car subpats) (car vals))
                              (λ (res)
                                (match res
                                  [#f (unit #f)]
                                  [#t (loop (cdr subpats) (cdr vals))]
                                  [(list bind val)
                                   (>>= (loop (cdr subpats) (cdr vals))
                                        (λ (ress)
                                          (match ress
                                            [#f (unit #f)]
                                            [(list binds vals)
                                             (unit (list (cons bind binds) (cons val vals)))])
                                          ))
                                   ]
                                  )
                                ))))))
            #f)]
       )
     ]
    [(? symbol? x) (>>= (meval Ce ρ) (λ (res) (unit (list (list x) (list res)))))]
    [lit1
     (match Ce
       [(cons _ con1); Singleton constructor
        ;  (pretty-print `(match-singleton constructor ,Ce ,con1 ,lit1 ,(equal? lit1 con1)))
        (if (equal? lit1 con1)
            (unit #t)
            (unit #f)
            )])
     ]))

(define (pattern-lit-matches pattern lit2)
  (match pattern
    [lit1 (unit (equal? (to-lit lit1) lit2))]
    ))
