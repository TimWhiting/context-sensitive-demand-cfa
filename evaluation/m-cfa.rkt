#lang racket/base
(require (rename-in "table-monad/main.rkt" [void fail]))
(require "config.rkt" "static-contexts.rkt" "demand-abstraction.rkt" "debug.rkt" "demand-primitives.rkt")
(require racket/pretty)
(require racket/match
         racket/list
         racket/set)
(provide meval)

; At least k-cfa is wrong for m > 0. Need to check others as well

(define (eval* args)
  (match args
    [(list) (unit (list))]
    [(cons e as)
     (>>= e; This is just a compuation ran Ce p i
          (λ (e p)
            (>>= (eval* as)
                 (λ (ress)
                   (>>= (meval e p)
                        (λ (res) (unit (cons res ress)))
                        )))))]
    ))

(define-key (store addr) #:⊥ litbottom #:⊑ lit-lte #:⊔ lit-union #:product
  ⊥)

(define (extend-store var env val)
  ; (pretty-print "extend")
  ; (pretty-print `(extend-store ,var ,env ,val))
  ; (store (cons var env))
  (extend-store-internal var env val)
  )
(define product-absorb-lit (node-absorb/product litbottom lit-lte lit-union))

(define (((extend-store-internal var env val) k) s)
  ((k #f) ((product-absorb-lit (store (cons var env)) val) s)))

(define (get-store var env)
  (store (cons var env)))

(define (bind-args vars ρ values)
  ; (pretty-print "bind")
  (if (equal? (length vars) (length values))
      (match vars
        [(list) (unit #f)]
        [(cons var vars)
         ;  (pretty-print "extend")
         (>>= (extend-store var ρ (car values))
              (λ (_) (bind-args vars ρ (cdr values))))])
      ⊥))

(define (store-lookup Ce x ρ)
  (>>=
   (bind x Ce ρ)
   (λ (_ p i)
     (match i
       [-1
        ; (pretty-print `(returning-cons ,Ce ,ρ))
        (clos Ce ρ)] ; treat as constructor]
       [_
        ; (pretty-print "lookup")
        (match (analysis-kind)
          ['rebinding (get-store x ρ)]
          ['exponential
           ;  (pretty-print `(store-lookup ,x ,ρ))
           (>>= (get-store x p)
                (λ (val)
                  ; (pretty-print `(store-lookup got ,val ,x ,ρ))
                  (match val
                    [(product/set (list Ce ρ)) (clos Ce ρ)]
                    [(product/lattice l) (lit l)]
                    )))]
          )]))))

(define (rebind-vars vars ρ ρnew)
  (match vars
    [(list) (unit #f)]
    [(cons var vars)
     (>>= (get-store var ρ)
          (λ (v)
            (>>= (extend-store var ρnew v)
                 (λ (_) (rebind-vars vars ρ ρnew)))))]))

; demand evaluation
(define-key (meval Ce ρ) #:⊥ litbottom #:⊑ lit-lte #:⊔ lit-union #:product
  ; (pretty-print "meval")
  (print-eval-result
   `(meval ,Ce ,ρ)
   (λ ()
     (match Ce
       [(cons _ #t) (clos Ce ρ)]
       [(cons _ #f) (clos Ce ρ)]
       [(cons _ (? integer? x)) (lit (litint x))]
       [(cons _ (? symbol? x))
        (match (lookup-primitive x)
          [#f (store-lookup Ce x ρ)]
          [Ce (clos Ce ρ)]
          )
        ]
       [(cons _ `(λ ,_ ,_))
        (clos Ce ρ)]
       [(cons C `(app ,f ,@args))
        (pretty-trace `(do-app ,f ,args ,ρ))
        (>>=clos
         (>>= (rat Ce ρ) meval)
         (λ (lam lamρ)
           (pretty-trace `(got closure or primitive ,lam))
           (match lam
             [`(prim ,_)
              ; (pretty-trace `(eval args prim: ,args))
              (>>= (eval* (map
                           (λ (i) (ran Ce ρ i))
                           (range (length args))))
                   (λ (args)
                     (pretty-trace `(applying prim: ,lam ,args))
                     (apply-primitive lam C ρ args)))]
             [(cons _ `(λ ,xs ,bod))
              ; (pretty-print `(applying closure: ,lam ,args ,ρ))
              (>>= (eval* (map
                           (λ (i) (ran Ce ρ i))
                           (range (length args))))
                   (λ (evaled-args)
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
                                  (define frees (set->list (free-vars bod)))
                                  (>>= (rebind-vars frees ρ ρ-new)
                                       (λ (_) (meval Ce ρ-new)))]
                                 ))))
                          )))]

             [(cons C con)
              ; (pretty-print `(con))
              (>>= (eval* (map
                           (λ (i) (ran Ce ρ i))
                           (range (length args))))
                   (λ (evaled-args)
                     (>>= (bind-args (range (length args)) ρ evaled-args)
                          (λ (_) (clos (cons Ce con) lamρ)))))]
             ))

         )
        ]
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
       [(cons C e) (error 'meval (pretty-format `(can not eval expression: ,e in context ,C)))]
       ))))


(define ((eval-con-clause parent parentp clauses i) ce ρ)
  ; (pretty-print `(eval-con-clause ,ce ,ρ))
  (match clauses
    [(cons clause clauses)
     (>>= (pattern-con-matches (car clause) ce ρ)
          (λ (matches)
            ; (pretty-print `(clause-res ,matches))
            (match matches
              [(list (list vars) (list exprs)) ; Matches and binds variables
               ;  (pretty-print `(pattern ,(car clause) binds ,vars to ,exprs))
               (>>= (bind-args vars parentp exprs)
                    (λ (_)
                      (>>= (focus-clause parent parentp i) meval)))]
              [#f ((eval-con-clause parent parentp clauses (+ i 1)) ce ρ)] ; Doesn't match
              [#t (>>= (focus-clause parent parentp i) meval)] ; Matches, but doesn't bind anything
              )
            ))]
    [_ (clos (cons parent 'match-error) parentp)]
    ))

(define ((eval-lit-clause parent parentp clauses i) lit)
  (match clauses
    [(cons clause clauses)
     (>>= (pattern-lit-matches (car clause) lit)
          (λ (matches)
            ; (pretty-print `(clause-res ,matches))
            (if matches
                (>>= (focus-clause parent parentp i) meval)
                ((eval-con-clause parent clauses (+ i 1)) lit)
                )))]
    [_ (clos (cons parent 'match-error) parentp)]
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
