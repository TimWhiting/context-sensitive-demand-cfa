#lang racket/base
(require (rename-in "table-monad/main.rkt" [void fail]))
(require "config.rkt" "static-contexts.rkt" "demand-abstraction.rkt" "debug.rkt" "demand-primitives.rkt")
(require racket/pretty)
(require racket/match
         racket/list)

#|
TODO:
Ask Kimball about errors and cut refinement equality for 0CFA

Work on paper based on pattern matching / constructors

Add more simple tests

Handle Errors

Make sure more r6rs programs work

Work on Koka version

Finish the paper
|#

; environment refinement
(define-key (refine p) fail)

(define (((put-refines ρ₀ ρ₁) k) s)
  (pretty-trace `(addrefine ,ρ₀ ,ρ₁))
  ((k #f) ((node-absorb/powerset (refine ρ₁) (list ρ₀)) s)))

; Just wraps do-get-refines so we can do a debug statement around it
(define (get-refines* kind ρ)
  (match ρ
    [(list)
     ⊥]
    [(cons _ _)
     (print-result-env `(refines ,kind) (λ () (do-get-refines* ρ)))
     ]))

(define do-get-refines*
  (match-lambda
    [(list)
     ⊥]
    [(and ρ (cons cc ρ′))
     ;  (pretty-trace "GET-REFINES")
     ;  (pretty-trace ρ)
     (⊔ (if (cc-determined? cc) ; won't have any refinements at this scope
            fail
            (refine ρ))
        (>>= (do-get-refines* ρ′) (λ (ρ′) (unit (cons cc ρ′)))))]))

(define (find x Ce ρ)
  ; (pretty-print `(find ,x ,(drop Ce 1) ,ρ))
  (match Ce
    [(cons _ #t) ⊥]
    [(cons _ #f) ⊥]
    [(cons _ (? symbol? y))
     (if (equal? x y)
         (unit Ce ρ)
         ⊥)]
    [(cons _ (? integer?)) ⊥]
    [(cons _ `(match ,_ ,@ms))
     (apply each
            (cons (>>= (focus-match Ce ρ)
                       (λ (Cm ρm) (find x Cm ρm)))
                  (map (λ (i)
                         (>>= (focus-clause Ce ρ i)
                              (λ (Cm ρm) (find x Cm ρm))))
                       (range (length ms)))))]
    [(cons C `(λ ,ys ,e))
     (if (ors (map (λ (y) (equal? x y)) ys))
         ⊥
         (find x
               (cons `(bod ,ys ,C) e)
               (cons (take-cc `(□? ,ys)) ρ)))]
    [(cons _ `(app ,_ ,@es))
     (apply each
            (cons (>>= (rat Ce ρ)
                       (λ (Ce ρ) (find x Ce ρ)))
                  (map (λ (i)
                         ;  (pretty-print i)
                         (>>= (ran Ce ρ i)
                              (λ (Ce ρ) (find x Ce ρ))))
                       (range (length es))))
            )]
    [(cons _ `(let (,@binds) ,_))
     (apply each
            (cons (if (ors (map (λ (n) (equal? n x)) (map car binds)))
                      ⊥
                      (>>= (bod Ce ρ)
                           (λ (Ce ρ) (find x Ce ρ))))
                  (map (λ (i)
                         (>>= (bin Ce ρ i)
                              (λ (Ce ρ)
                                (match Ce
                                  [(cons `(let-bin ,y ,_ ,_ ,_ ,_) _) (if (equal? x y) ⊥ (find x Ce ρ))]
                                  [_(find x Ce ρ)])
                                )))
                       (range (length binds)))))
     ]
    [(cons _ e) (error 'find (pretty-format `(no match for find ,e)))]
    ))


(define (bind x Ce ρ)
  (define (search-out) (>>= (out Ce ρ) (λ (Ce ρ) (bind x Ce ρ))))
  ; (pretty-print `(bind ,x ,Ce ,ρ))
  (match Ce
    [(cons `(top) _) (unit x ρ -1)] ; Constructors
    [(cons `(let-bin ,y ,_ ,before ,after ,_) _)
     ;  (pretty-print `(let-bin-bind ,y ,x))
     (define defs (append (map car before) (list y) (map car after)))
     (if (ors (map (λ (y) (equal? x y)) defs))
         (unit Ce ρ (index-of defs x))
         (search-out))]
    [(cons `(bod ,ys ,_) _)
     ;  (pretty-print `(bodbind ,ys ,x ,(ors (map (λ (y) (equal? x y)) ys)) ,(index-of ys x)))
     (if (ors (map (λ (y) (equal? x y)) ys))
         (unit Ce ρ (index-of ys x))
         (search-out))]
    [(cons `(let-bod ,binds ,_) _)
     (define defs (map car binds))
     ;  (pretty-print `(let-bind ,defs))
     (if (ors (map (λ (y) (equal? x y)) defs))
         (unit Ce ρ (index-of defs x))
         (search-out))]
    [(cons `(match-clause ,m ,scruitinee ,before ,after ,_) e₀)
     (define match-binding (find-match-bind x m))
     (if match-binding (unit Ce ρ match-binding) (search-out))]
    ; All other forms do not introduce bindings
    [(cons _ _) (search-out)]
    ))

(define (find-match-bind-loc x ms loc)
  (match ms
    [(cons m ms)
     (define is-match (find-match-bind x m))
     (if is-match (list loc is-match) (find-match-bind-loc x ms (+ 1 loc)))
     ]
    [_ #f]
    ))

(define (find-match-bind x m)
  (match m
    [(? symbol? y)
     (if (equal? y x) #t #f)]
    [`(,con ,@args)
     (define submatch (find-match-bind-loc x args 0))
     (match submatch
       [(list lsub sub)
        `(,con ,lsub ,sub)]
       [#f #f])]
    [lit #f]
    ))

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
           ;  (pretty-trace `(bind ,x ,Ce ,ρ))
           (>>= (bind x Ce ρ)
                (λ (Cex ρ i)
                  ; (pretty-print `(bound to ,Cex ,i))
                  (match Cex
                    [(cons `(bod ,x ,C) e)
                     ;  (pretty-trace `(bound ,C ,e ,x ,Cex))
                     (>>= (call C x e ρ)
                          (λ (Ce ρ)
                            (if (equal? (length x) (length (args-e Ce)))
                                ;  (pretty-print `(,Ce ,ρ ,i))
                                (>>= (ran Ce ρ i) (debug-eval `(ref ,i) eval))
                                ⊥)))

                     ]
                    [(cons `(let-bod ,_ ,_) _)
                     ;  (print-eval-result `(ref-let-bod)
                     ;                     (λ ()
                     (>>= (>>= (out Cex ρ)
                               (λ (Ce ρ)
                                 ;  (pretty-print `(,Ce))
                                 (bin Ce ρ i)))
                          (debug-eval `(letbin) eval))
                     ; ) #t)
                     ]
                    [(cons `(let-bin ,_ ,_ ,_ ,_ ,_) _) ; Recursive bindings
                     (>>= (>>= (out Cex ρ) (λ (Ce ρ) (bin Ce ρ i))) eval)
                     ]
                    [(cons `(match-clause ,_ ,_ ,_ ,_ ,_) _)
                     (>>= (out Cex ρ)
                          (λ (Ce ρ)
                            (>>= (focus-match Ce ρ)
                                 (eval-match-binding i))))
                     ]
                    [(? symbol? x)
                     (match (lookup-primitive x)
                       [#f
                        (pretty-tracen 0 `(constructor? ,x))
                        (clos Ce ρ)]
                       [Ce (clos Ce ρ)]
                       )]
                    )))]
          [(cons _ `(λ ,_ ,_))
           ;  (pretty-trace "LAM")
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
                [(cons _ `(λ ,_ ,_))
                 (>>= (enter-bod Ce′ Ce ρ ρ′) (debug-eval 'app-eval eval))
                 ]
                [con (clos con ρ′)]
                )
              ))
           ]
          [(cons _ `(let ,_ ,_))
           (>>= (bod Ce ρ) eval)]
          [(cons _ `(match ,_ ,@clauses))
           (>>= (focus-match Ce ρ)
                (λ (Cm ρm)
                  (pretty-trace `(eval-match ,Cm ,ρm))
                  ;  (pretty-trace `(eval-clause ,Ce′ ,ρ′))
                  (eval-clause Cm ρm Ce clauses 0)))]
          [(cons C e) (error 'eval (pretty-format `(can not eval expression: ,e in context ,C)))]
          )
        (>>= (get-refines* `(eval ,Ce ,ρ) ρ)
             (λ (ρ′) (eval Ce ρ′)))))))


(define ((eval-match-binding match-bind) Ce ρ)
  (match match-bind
    [`(,con ,locsub ,sub)
     (>>=clos
      (eval Ce ρ) ; Evaluate the constructor
      (λ (Ce ρ)
        (match Ce
          [(cons _ con1)
           (if (equal? con con1)
               (>>= (expr Ce ρ); Evaluate where the constructor is applied
                    (λ (Ce ρ)
                      ; (pretty-print `(ran subpat ,sub ,locsub))
                      (>>= (ran Ce ρ locsub) (eval-match-binding sub))))
               ⊥
               )]
          ))) ]
    [#t (eval Ce ρ)]
    ))

(define (enter-bod Ce′ Ce ρ ρ′)
  (match (demand-kind)
    ['basic (bod-enter Ce′ Ce ρ ρ′)]
    [_ (bod-calibrate Ce′ Ce ρ ρ′)]
    ))


(define-key (pattern-matches pattern ce p)
  (match pattern
    [`(,con ,@subpats)
     (>>=clos
      (eval ce p) ; Evaluate the constructor
      (λ (Ce pe)
        (match Ce
          [(cons _ con1)
           (if (equal? con con1)
               ; Find where the constructor is applied
               (>>= (expr Ce pe)
                    (λ (Ce ρ)
                      (match Ce
                        [(cons _ `(app ,_ ,@as))
                         (pretty-print `(subpat ,subpats ,as))
                         (if (equal? (length as) (length subpats))
                             (let loop ([as as]
                                        [i 0]
                                        [subpats subpats])
                               (match as
                                 [(list) (unit #t)]
                                 [(cons _ as)
                                  (match-let ([(cons subpat subpats) subpats])
                                    (pretty-print `(ran subpat matches ,Ce))
                                    (>>= (ran Ce ρ i)
                                         (λ (Ce ρ)
                                           (>>= (pattern-matches subpat Ce ρ)
                                                (λ (matches)
                                                  (pretty-print `(subpat match ,subpat ,Ce ,matches))
                                                  (if matches (loop as (+ 1 i) subpats) (unit #f))
                                                  )))))
                                  ]
                                 )
                               )
                             (unit #f)
                             )]
                        )))
               ; Wrong constructor
               (unit #f))])))]
    [(? symbol? _) (unit #t)] ; Variable binding
    [lit1
     (>>=eval (eval ce p)
              (λ (Ce _) (match Ce
                          [(cons _ con1); Singleton constructor
                           (if (equal? lit con1)
                               (unit #t)
                               (unit #f)
                               )]))
              (λ (lit2) (unit (equal? (to-lit lit1) lit2))))
     ]
    )
  )

(define (eval-clause ce p parent clauses i)
  (match clauses
    [(cons clause clauses)
     (>>= (pattern-matches (car clause) ce p)
          (λ (lit2)
            (if lit2
                (>>= (focus-clause parent p i) eval)
                (eval-clause ce p parent clauses (+ i 1))
                )))]
    [_ ⊥]
    )); TODO: Match error?

(define (call C xs e ρ)
  (define lambod (car (bod-e (cons C `(λ ,xs ,e)) ρ)))
  ; (pretty-trace `(call ,C ,xs ,e ,ρ))
  (print-result
   `(call ,C ,xs ,e ,ρ)
   (λ () (match-let ([(cons cc₀ ρ₀) ρ])
           (match (demand-kind)
             ['basic
              (pretty-trace `(CALL BASIC ,(cons C `(λ ,xs ,e))))
              (>>= (expr (cons C `(λ ,xs ,e)) ρ₀)
                   (λ (Cee ρee)
                     (let ([cc₁ (enter-cc Cee ρee)])
                       (cond
                         [(equal? cc₀ cc₁)
                          (pretty-trace `(CALL-EQ ,cc₀ ,cc₁))
                          (unit Cee ρee)]
                         [(⊑-cc cc₁ cc₀)
                          (pretty-trace `(CALL-REFINES ,cc₀ ,cc₁))
                          ; strictly refines because of above
                          (>>= (put-refines (cons cc₁ ρ₀) ρ) (λ _ ⊥))
                          ]
                         [else
                          (pretty-tracen 0 `(CALL-NO-REFINE ,cc₀ ,cc₁))
                          ⊥]))))]
             [_
              (pretty-trace `HYBRID)
              (match (calibrate-envs ρ (indeterminate-env lambod))
                [`(cenv ,ce ,ρ′)
                 (pretty-trace `(CALL-KNOWN))
                 (unit ce ρ′)]
                [_
                 (begin
                   (pretty-trace `(CALL-UNKNOWN ,(calibrate-envs ρ (indeterminate-env lambod))))
                   (>>= (expr (cons C `(λ ,xs ,e)) ρ₀); Fallback to normal basic evaluation
                        (λ (Cee ρee)
                          (pretty-trace `(,Cee ,ρee))
                          (let ([cc₁ (enter-cc Cee ρee)])
                            (cond
                              [(equal? cc₀ cc₁)
                               (pretty-trace "CALL-EQ")
                               (unit Cee ρee)]
                              [(and (equal? cc₀ '?) (equal? cc₁ '!)); Cuts are equal (0CFA) TODO: is this always the case
                               (unit Cee ρee)]
                              [(⊑-cc cc₁ cc₀)
                               (pretty-trace "CALL-REFINE")
                               (pretty-trace `(,cc₁ ,cc₀))
                               ; strictly refines because of above
                               (>>= (put-refines (cons cc₁ ρ₀) ρ) (λ _ ⊥))
                               ]
                              [else
                               (pretty-trace "CALL-NOREF")
                               (pretty-trace `(cc₀ ,cc₀ cc₁ ,cc₁))
                               ⊥])))))]
                )])
           ))
   )
  )

(define-key (expr Ce ρ)
  (begin
    (print-result
     `(expr ,Ce ,ρ)
     (λ () (⊔ (match Ce
                [(cons `(rat ,_ ,_) _)
                 ;  (pretty-trace "RAT")
                 (out Ce ρ)]
                [(cons `(ran ,_ ,before ,_ ,_) _)
                 (>>= (out Ce ρ)
                      (λ (Cee ρee)
                        (>>=clos
                         (>>= (rat Cee ρee) eval)
                         (λ (Cλx.e ρλx.e)
                           (match-let ([(cons C `(λ ,xs ,e)) Cλx.e])
                             (>>= (enter-bod Cλx.e Cee ρee ρλx.e)
                                  (λ (Ce p)
                                    (>>= (find (car (drop xs (length before))) Ce p)
                                         expr))))))))]
                [(cons `(bod ,xs ,C) e)
                 (>>= (call C xs e ρ) expr)]
                [(cons `(let-bod ,_ ,_) _)
                 (>>= (out Ce ρ) expr)]
                [(cons `(let-bin ,x ,_ ,before ,after ,_) _)
                 (>>= (out Ce ρ)
                      (λ (Cex ρe)
                        ; (pretty-print `(let-bin find ,x ,Cex))
                        (apply each
                               (cons(>>= (bod Cex ρe)
                                         (λ (Cee ρee)
                                           (>>= (find x Cee ρee)
                                                (λ (Cee ρee)
                                                  ; (pretty-print `(find: found: ,Cee))
                                                  (expr Cee ρee)))))
                                    (map (λ (i) ; Recursive bindings
                                           (>>= (bin Cex ρe i)
                                                (λ (Cee ρee)
                                                  (>>= (find x Cee ρee) expr))))
                                         (range (+ 1 (length before) (length after))))
                                    )
                               )))]
                [(cons `(top) _)
                 ⊥])
              (>>= (get-refines* `(expr ,Ce ,ρ) ρ) (λ (ρ′) (expr Ce ρ′))))))))

(provide (all-defined-out)
         (all-from-out "table-monad/main.rkt"))

(define (run-print-query q)
  (pretty-print q)
  (run q))