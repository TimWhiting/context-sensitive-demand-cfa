#lang racket/base
(require (rename-in "table-monad/main.rkt" [void fail]))
(require "static-contexts.rkt" "abstract-value.rkt"
         "debug.rkt" "primitives.rkt"
         "envs.rkt" "utils.rkt" "syntax.rkt")
(require racket/pretty)
(require racket/match
         racket/list)

#|
TODO:
Add more simple tests

Handle Errors

Make sure more r6rs programs work

Work on Koka version

Finish the paper
|#

; environment refinement
(define-key (refine ρ) fail)

; The first is a refinement of the second parameter
(define (((put-refines ρ₀ ρ₁) k) s)
  (pretty-trace `(addrefine ,(show-simple-env ρ₀) ,(show-simple-env ρ₁)))
  ((k #f) ((node-absorb/powerset (refine ρ₁) (list ρ₀)) s)))


; Just wraps do-get-refines so we can do a debug statement around it
(define (get-refines* kind ρ)
  ; (pretty-print `(get-refines ,ρ))
  (match (env-list ρ)
    [(list) ⊥]
    [(cons _ _)
     ;(print-result-env `(refines ,kind) (λ ()
     (do-get-refines* ρ) ; ))
     ]))

(define (do-get-refines* ρ)
  (match (split-env ρ)
    [(cons c ρ′)
     ;  (pretty-trace "GET-REFINES")
     ;  (pretty-trace ρ)
     (⊔ (if (cc-determined? c) ; won't have any refinements at this scope
            fail
            (refine ρ))
        (>>= (do-get-refines* ρ′)
             (λ (ρ′)
               (match ρ′
                 [(menv ccs) (unit (menv (cons (callc c) ccs)))]
                 ))))]
    [(menv '()) ⊥]
    ))

(define ((find x) Ce ρ)
  ; (pretty-print `(find ,x ,(drop Ce 1) ,ρ))
  ; Different let versions are handled in expr, once inside the definition we avoid all further shadowing
  (define (handle-let binds)
    (apply each
           (cons (if (ors (map (λ (n) (equal? n x)) (map car binds)))
                     ⊥
                     (>>= (bod Ce ρ) (find x)))
                 (map (λ (i)
                        (>>= ((bin i) Ce ρ)
                             (λ (Ce ρ)
                               (match Ce
                                 [(cons `(bin ,_ ,y ,_ ,_ ,_ ,_) _) (if (equal? x y) ⊥ ((find x) Ce ρ))]
                                 [_ ((find x) Ce ρ)])
                               )))
                      (range (length binds))))))
  (match Ce
    [(cons _ #t) ⊥]
    [(cons _ #f) ⊥]
    [(cons _ (? string?)) ⊥]
    [(cons _ (? symbol? y))
     (if (equal? x y)
         (unit Ce ρ)
         ⊥)]
    [(cons _ (? integer?)) ⊥]
    [(cons _ `(match ,_ ,@ms))
     (apply each
            (cons (>>= (focus-match Ce ρ)
                       (λ (Cm ρm) ((find x) Cm ρm)))
                  (map (λ (i)
                         (>>= ((match-clause i) Ce ρ) (find x)))
                       (range (length ms)))))]
    [(cons C `(λ ,ys ,e))
     (if (ors (map (λ (y) (equal? x y)) ys))
         ⊥
         (>>= (bod Ce ρ) (find x)))]
    [(cons _ `(app ,_ ,@es))
     (apply each
            (cons (>>= (rat Ce ρ) (find x))
                  (map (λ (i)
                         ;  (pretty-print i)
                         (>>= ((ran i) Ce ρ) (find x)))
                       (range (length es))))
            )]
    ; Different let versions are handled in expr, once inside the definition we avoid all further shadowing
    [(cons _ `(let (,@binds) ,_))    (handle-let binds)]
    [(cons _ `(letrec (,@binds) ,_)) (handle-let binds)]
    [(cons _ `(let* (,@binds) ,_))   (handle-let binds)]
    [(cons _ e) (error 'find (pretty-format `(no match for find ,e)))]
    ))


(define (eval* args)
  (let loop ([ags args]
             [acc (list)])
    (match ags
      [(list) (unit acc)]
      [(cons e as)
       (>>= e (λ (ce ρ)
                ; (pretty-print `(evaling-arg ,(show-simple-ctx ce) ,(show-simple-env ρ)))
                (>>=
                 (eval ce ρ)
                 (λ (r)
                   ;  (pretty-print `(evaling-arg-result ,(show-simple-ctx ce) result ,r))
                   (loop as (append acc (list r)))))))]
      )
    )
  )

; We need special primitives that can evaluate only what is needed
;  in the demanded constructor / closure data model
(define (lookup-demand-primitive x)
  ; (pretty-print `(primitive-lookup ,x))
  (match x
    ['= `(prim ,do-demand-equal)]
    ['equal? `(prim, do-demand-equal)]
    ['or `(prim ,do-demand-or)]; TODO Handle in match positions
    ['and `(prim ,do-demand-and)]; TODO Handle in match positions
    ['not `(prim ,do-demand-not)]
    ['- `(prim ,do-sub)] ; Numbers work with the regular data model
    ['+ `(prim ,do-add)] ; Numbers work with the regular data model
    ['<= `(prim ,do-lte)] ; Numbers work with the regular data model
    ['< `(prim ,do-lt)] ; Numbers work with the regular data model
    ['newline `(prim, do-newline)]
    ['display `(prim, do-display)]
    ['void `(prim, do-void)]
    [_ #f]
    ))

(define (do-demand-not ρ C a1)
  (>>= (is-truthy ρ C a1)
       (λ (t)
         (match t
           [#f (true C ρ)]
           [#t (false C ρ)]
           )
         )))

(define (is-truthy ρ C v)
  (match v
    [(product/lattice (literal (list i1 f1 c1 s1))) (unit #t)]
    [(product/set (list C `(λ ,_ ,@_))) (unit #t)]; Closures
    ; [(product/set (list (cons C #t) _)) (true C ρ)]
    ; [(product/set (list (cons C #f) _)) (false C ρ)]
    [(product/set (list Ce ρe)) ; Constructors
     (>>=clos (>>= (rat Ce ρe) eval) ; Eval the constructor
              (λ (Cc ρc)
                (match Cc ; Check if it is false
                  [(cons _ #f) (unit #f)]
                  [(cons _ _) (unit #t)]
                  )))]))

(define (do-demand-or ρ C . args)
  (match args
    ['() (false C ρ)]
    [(cons a '())
     (>>= (is-truthy ρ C a)
          (λ (t)
            (match t
              [#f (false C ρ)]
              [#t (unit a)]
              )))]
    [(cons a as)
     (>>= (is-truthy ρ C a)
          (λ (t)
            (match t
              [#f (apply do-demand-or (cons ρ (cons C as)))]
              [#t (unit a)]
              )))]))

(define (do-demand-and ρ C . args)
  (match args
    ['() (true C ρ)]
    [(cons a '())
     (>>= (is-truthy ρ C a)
          (λ (t)
            (match t
              [#f (false C ρ)]
              [#t (unit a)])))]
    [(cons a as)
     (>>= (is-truthy ρ C a)
          (λ (t)
            (match t
              [#f (false C ρ)]
              [#t (apply do-demand-and (cons ρ (cons C as)))]
              )))]))

(define (do-demand-equal ρ C a1 a2)
  (match a1
    [(product/lattice (literal (list i1 f1 c1 s1)))
     (match a2
       [(product/lattice (literal (list i1 f1 c1 s1))) (each (true C ρ) (false C ρ))] ; TODO: More refined
       [_ ⊥]
       )]
    [(product/set (list _ `(λ ,_ ,@_))) (false C ρ)]; Closures never are equal
    [(product/set (list _ _)) (each (true C ρ) (false C ρ))] ; TODO Refine this
    ))

; demand evaluation
(define-key (eval Ce ρ) #:⊥ litbottom #:⊑ lit-lte #:⊔ lit-union #:product
  (print-eval-result
   `(eval ,(show-simple-ctx Ce) ,(show-simple-env ρ))
   (λ ()
     (⊔ (match Ce
          [(cons C #t) (truecon C ρ)]
          [(cons C #f) (falsecon C ρ)]
          [(cons _ (? string? s)) (lit (litstring s))]
          [(cons _ (? integer? x)) (lit (litint x))]
          [(cons C `(app quote ,v)) (clos (cons C `(app quote ,v)) ρ)]
          [(cons _ (? symbol? x))
           ;  (pretty-trace `(bind ,x ,Ce ,ρ))
           (>>= ((bind x) Ce ρ)
                (λ (Cex ρ i)
                  ; (pretty-print `(bound-to ,x ,(show-simple-ctx Cex) ,i))
                  (match Cex
                    [(cons `(bod ,xs ,C) e)
                     (>>= (call C xs e ρ)
                          (λ (Ce ρ)
                            ; (pretty-print `(call-for-ref ,x))
                            (if (equal? (length xs) (length (args-e Ce)))
                                (>>= ((ran i) Ce ρ) eval)
                                ⊥)))

                     ]
                    [(cons `(let-bod ,_ ,_ ,_) _)
                     (>>= (>>= (out Cex ρ)
                               (bin i))
                          eval)
                     ]
                    [(cons `(bin ,_ ,_ ,_ ,_ ,_ ,_) _)
                     (>>= (>>= (out Cex ρ)
                               (bin i))
                          eval)
                     ]
                    [(cons `(match-clause ,_ ,_ ,_ ,_ ,_) _)
                     (>>= (out Cex ρ)
                          (λ (Ce ρ)
                            (>>= (focus-match Ce ρ)
                                 (eval-match-binding i))))
                     ]
                    [(? symbol? x)
                     (match (lookup-demand-primitive x)
                       [#f
                        ; (check-known-constructor? x)
                        (pretty-tracen 0 `(constructor? ,x))
                        (clos Ce ρ)]
                       [Ce (clos Ce ρ)]
                       )]
                    )))]
          [(cons _ `(λ ,_ ,_))
           ;  (pretty-trace "LAM")
           (clos Ce ρ)]
          [(cons C `(app ,f ,@args))
           ;  (pretty-trace `(APP ,ρ))
           (>>=clos
            (>>= (rat Ce ρ) eval)
            (λ (Ce′ ρ′)
              ; (pretty-trace `(got closure or primitive ,Ce′))
              (match Ce′
                [`(prim ,_)
                 (pretty-trace `(eval args prim: ,args))
                 (>>= (eval* (map
                              (λ (i) ((ran i) Ce ρ))
                              (range (length args))))
                      (λ (args)
                        (pretty-trace `(applying prim: ,Ce′ ,args))
                        (apply-primitive Ce′ C ρ args)))]
                [(cons _ `(λ ,_ ,_))
                 (>>= (bod-enter Ce′ Ce ρ ρ′) eval)
                 ]
                ; Constructors just return the application. We need the context to further resolve demand queries for arguments
                [(cons _ con)
                 (if (= (length args) 1)
                     (clos (cons `(top) `(app ,f ,@args)) (top-env))
                     (clos Ce ρ))]
                )
              ))
           ]
          [(cons _ `(lettypes ,_ ,_))
           (>>= (bod Ce ρ) eval)]
          [(cons _ `(let ,_ ,_))
           (>>= (bod Ce ρ) eval)]
          [(cons _ `(let* ,_ ,_))
           (>>= (bod Ce ρ) eval)]
          [(cons _ `(letrec ,_ ,_))
           (>>= (bod Ce ρ) eval)]
          [(cons _ `(match ,_ ,@clauses))
           (>>= (focus-match Ce ρ)
                (λ (Cm ρm)
                  (pretty-trace `(eval-match ,Cm ,ρm))
                  ;  (pretty-trace `(eval-clause ,Ce′ ,ρ′))
                  (>>=eval (eval Cm ρm) (eval-clausecon Ce ρ clauses 0) (eval-clauselit Ce ρ clauses 0))
                  ))]
          [(cons C e) (error 'eval (pretty-format `(can not eval expression: ,e in context ,C)))]
          )
        (>>= (get-refines* `(eval ,(show-simple-ctx Ce) ,(show-simple-env ρ)) ρ)
             (λ (ρ′) (eval Ce ρ′)))))))


(define ((eval-match-binding match-bind) Ce ρ)
  (match match-bind
    [`(,con ,locsub ,sub)
     (>>=clos
      (eval Ce ρ) ; Evaluate the constructor
      (λ (Ce ρ)
        (>>=clos
         ; This is the application site of the constructor, need to see what constructor it is
         (>>= (rat Ce ρ) eval)
         (λ (Cc ρc)
           (match Cc
             [(cons _ con1)
              (if (equal? con con1)
                  ; (pretty-print `(ran subpat ,sub ,locsub))
                  (>>= ((ran locsub) Ce ρ) (eval-match-binding sub))
                  ⊥
                  )]
             ))))) ]
    [#t (eval Ce ρ)]
    ))

(define (patterns-match Ce ρ args subpats i)
  (match args
    [(list) (unit #t)]
    [(cons _ as)
     (match-let ([(cons subpat subpats) subpats])
       ;  (pretty-print `(subpat-matches ,(show-simple-ctx Ce) ,args))
       (>>= ((ran i) Ce ρ)
            (λ (Cex ρx)
              (>>= (>>=eval (eval Cex ρx)
                            (λ (Ce ρ) (pattern-matches subpat Ce ρ))
                            (λ (lit)
                              ; (pretty-print `(subpat ,subpat ,lit))
                              (pattern-matches-lit subpat lit)))
                   (λ (matches)
                     ; (pretty-print `(subpat match ,subpat ,Ce ,matches))
                     (if matches (patterns-match Ce ρ as subpats (+ 1 i)) (unit #f))
                     )))))]
    ))

(define (pattern-matches pattern Ce ρe)
  (match pattern
    [`(,con ,@subpats)
     (>>=clos
      ; This is the application site of the constructor, need to see what constructor it is
      (>>= (rat Ce ρe) eval)
      (λ (Cc ρc)
        (match Cc
          [(cons _ con1)
           (if (equal? con con1)
               ; Find where the constructor is applied
               (match Ce
                 [(cons _ `(app ,_ ,@as))
                  ;  (pretty-print `(subpat ,subpats ,as))
                  (if (equal? (length as) (length subpats))
                      (patterns-match Ce ρe as subpats 0)
                      (unit #f)
                      )]
                 )
               ; Wrong constructor
               (unit #f))]))
      )]
    [(? symbol? _) (unit #t)] ; Variable binding
    [lit1
     (match Ce
       [(cons _ con1); Singleton constructor #t #f
        ; (pretty-print `(match-singleton constructor ,con1 ,lit1 ,(equal? lit1 con1)))
        (if (equal? lit1 con1)
            (unit #t)
            (unit #f)
            )])
     ]
    )
  )

(define (pattern-matches-lit pat lit2)
  (unit (or (symbol? pat) (equal? (to-lit pat) lit2)))
  )

(define ((eval-clauselit parent parentρ clauses i) lit1)
  (match clauses
    [(cons clause clauses)
     (>>= (pattern-matches-lit (car clause) lit1)
          (λ (matches)
            (if matches
                (begin
                  ; (pretty-print `(clause-match ,clause))
                  (>>= ((match-clause i) parent parentρ) eval)
                  )
                ((eval-clauselit parent parentρ clauses (+ i 1)) lit1)
                )))
     ]
    [_
     ;  (pretty-print `(no match in ,parent for ,(cdr ce)))
     (clos (cons `(top) `(app error 'match-error ,lit1)) parentρ)
     ;  (clos (cons lit 'match-error) parentρ)
     ]
    )
  )

(define ((eval-clausecon parent parentρ clauses i) ce ρ)
  (match clauses
    [(cons clause clauses)
     (>>= (pattern-matches (car clause) ce ρ)
          (λ (matches)
            ; (pretty-print `(clause-res ,matches))
            (if matches
                (begin
                  ; (pretty-print `(clause-match ,clause))
                  (>>= ((match-clause i) parent parentρ) eval)
                  )
                ((eval-clausecon parent parentρ clauses (+ i 1)) ce ρ)
                )))]
    [_
     ;  (pretty-print `(no match in ,parent for ,(cdr ce)))
     ;  (clos (cons ce 'match-error) ρ)
     (clos (cons `(top) `(app error 'match-error)) ρ)
     ] ; TODO: Test match error
    ))

(define (call C xs e ρ)
  (define lambod (car (bod-e (cons C `(λ ,xs ,e)) ρ)))
  (define lamenv (inner-lambda-bindings lambod))
  (print-result
   `(call ,(show-simple-ctx (cons C `(λ ,xs ,e))) ,(show-simple-env ρ))
   (λ () (match ρ
           [(menv (cons (callc cc₀) ρ₀))
            ; (pretty-trace `(CALL-BASIC ,(show-simple-ctx (cons C `(λ ,xs ,e)))))
            (>>= (expr (cons C `(λ ,xs ,e)) (menv ρ₀))
                 (λ (Cee ρee)
                   (let ([cc₁ (enter-cc Cee ρee)])
                     (cond
                       [(⊑-cc cc₀ cc₁)
                        (pretty-trace "equal")
                        (pretty-trace `(CALL-EQ ,xs ,(show-simple-call cc₀) ,(show-simple-call cc₁)))
                        (unit Cee ρee)]
                       [(⊑-cc cc₁ cc₀)
                        (pretty-trace "refines")
                        (pretty-trace `(CALL-REFINES ,xs ,(show-simple-call cc₀) ,(show-simple-call cc₁)))
                        ; strictly refines because of above
                        (>>= (put-refines (menv (cons (callc cc₁) ρ₀)) ρ) (λ _ ⊥))
                        ]
                       ;  [(⊑-cc cc₀ cc₁)
                       ;   (define new-cc (take-cc (replace-cc cc₁ cc₀)))
                       ;   (pretty-trace "old-refines")
                       ;   (pretty-trace `(CALL-OLD-REFINES ,xs ,(show-simple-call cc₀) ,(show-simple-call cc₁) ,(show-simple-call new-cc)))
                       ;   (unit Cee (menv (cons (callc cc₀) ρ₀)))
                       ;   ]
                       [else
                        (pretty-trace "no-refine")
                        (pretty-tracen 0 `(CALL-NO-REFINE ,xs ,(show-simple-call cc₀) ,(show-simple-call cc₁)))
                        ⊥]))))]
           )
     )
   )
  )

(define-key (expr Ce ρ)
  (begin
    (print-result
     `(expr ,(show-simple-ctx Ce) ,(show-simple-env ρ))
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
                           ;  (pretty-print (show-simple-ctx Ce))
                           ;  (pretty-print (show-simple-ctx Cλx.e))
                           (match Cλx.e
                             [(cons C `(λ ,xs ,e))
                              (>>= (bod-enter Cλx.e Cee ρee ρλx.e)
                                   (λ (Ce ρ)
                                     (>>= ((find (car (drop xs (length before)))) Ce ρ)
                                          expr))) ]
                             [(cons C (? symbol? x)) (expr Cλx.e ρλx.e)]

                             )))) )]
                [(cons `(bod ,xs ,C) e)
                 (>>= (call C xs e ρ) expr)]
                ; lambda is returned from let body
                [(cons `(let-bod ,_ ,_ ,_) _)
                 (>>= (out Ce ρ) expr)]
                ; lambda is bound by let binding with name ,x
                [(cons `(bin ,let-kind ,x ,_ ,before ,after ,_) _)
                 ;  (pretty-print `(bin-expr ,let-kind ,x))
                 (>>= (out Ce ρ)
                      (λ (Cex ρe)
                        ; (pretty-print `(bin-find ,let-kind ,x ,Cex))
                        (apply each
                               (cons (>>= (bod Cex ρe)
                                          (λ (Cee ρee)
                                            (>>= ((find x) Cee ρee)
                                                 (λ (Cee ρee) ; TODO: Calibrate and use the cut environment instead of doing expr if we can
                                                   ;  (pretty-print `(find-body-found: ,(show-simple-ctx Cee)))
                                                   (expr Cee ρee)))))
                                     (match let-kind
                                       ['letrec
                                        ; x could be referenced in all of the bindings as well
                                        (map (λ (i)
                                               (>>= ((bin i) Cex ρe)
                                                    (λ (Cee ρee)
                                                      ; (pretty-print `(try-to-find ,x ,(show-simple-ctx Cee)))
                                                      (>>= ((find x) Cee ρee)
                                                           (λ (Cee ρee)
                                                             ;  (pretty-print `(found ,x ,(show-simple-ctx Cee)))
                                                             (expr Cee ρee))))))
                                             (range (+ 1 (length before) (length after))))]
                                       ['let* ; x could be referenced in all following bindings
                                        (if (> 1 (length after))
                                            (map (λ (i)
                                                   (>>= ((bin i) Cex ρe)
                                                        (λ (Cee ρee)
                                                          (>>= ((find x) Cee ρee) expr))))
                                                 ; (length before) + 1 is the current binding, start one after
                                                 (range (+ 2 (length before)) (+ 1 (length before) (length after))))
                                            '())]
                                       [_ '()]
                                       )
                                     )
                               )))]
                [(cons `(top) _)
                 ⊥])
              (>>= (get-refines* `(expr ,(show-simple-ctx Ce) ,(show-simple-env ρ)) ρ) (λ (ρ′) (expr Ce ρ′))))))))

(provide (all-defined-out)
         (all-from-out "table-monad/main.rkt"))

(define (run-print-query q)
  (pretty-print q)
  (run q))