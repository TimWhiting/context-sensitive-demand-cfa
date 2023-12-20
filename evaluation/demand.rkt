#lang racket/base
(require (rename-in "table-monad/main.rkt" [void fail]))
(require racket/pretty)
(require racket/match
         racket/set)


#|
TODO:
Add in some samples with basic numbers

Add in a small sample with constructors / pattern matching

Implement pattern matchings / constructors

Finish the paper

Presentation
|#

(define ((clos . xs) k) (k (product/set xs)))
(define ((lit x) k) (k (product/lattice x)))

; (define ((>>= m f) k)
;   ((>>=1 m
;          (λ x
;            (begin
;              ;  (pretty-trace x)
;              (apply f x))))
;    k))

(define ((>>=eval m fclos flit) k)
  (m (λ (xs)
       ;  (pretty-trace xs)
       (match xs
         [(product/set xs) ((apply fclos xs) k)]
         [(product/lattice n) ((flit n) k)]
         ))))
(define ((>>=lit m f) k) ((>>=eval m (λ (_ __) ⊥) f) k))
(define ((>>=clos m f) k) ((>>=eval m f (λ (_) ⊥)) k))

; abstract values
(struct literal (litLattices) #:transparent)
(struct simple-lattice () #:transparent)
(struct top simple-lattice () #:transparent)
(struct bottom simple-lattice () #:transparent)
(struct singleton simple-lattice (x) #:transparent)

(define litbottom (literal (list (bottom) (bottom) (bottom) (bottom))))

(define (simple-union s1 s2)
  (match (cons s1 s2)
    [(cons (top) _) (top)]
    [(cons _ (top)) (top)]
    [(cons (bottom) x) x]
    [(cons x (bottom)) x]
    [(cons (singleton x) (singleton y)) (if (equal? x y) (singleton x) (top))]
    ))

(define (simple-lte s1 s2)
  (match (cons s1 s2)
    [(cons _ (top)) #t]
    [(cons (bottom) _) #t]
    [(cons (singleton x) (singleton y)) (equal? x y)]
    [(cons _ _) #f]
    ))

(define (lit-union s1 s2)
  (match (cons s1 s2)
    [(cons (literal lits1) (literal lits2)) (literal (map simple-union lits1 lits2))]
    ))

(define (lit-lte s1 s2)
  (match (cons s1 s2)
    [(cons (literal lits1) (literal lits2)) (andmap simple-lte lits1 lits2)]
    ))

; calling contexts

(define current-m (make-parameter 1))
(define demand-kind (make-parameter '_))
(define trace (make-parameter #f))

; Can the environment be refined further?
(define cc-determined?
  (match-lambda
    [(list)
     #t]
    ['! #t] ; Cut known
    ['? #t] ; Cut unknown (can be reinstantiated to an indeterminate context)
    [`(□? ,_)
     #f]
    [`(cenv ,Ce ,ρ)
     (and (map cc-determined? ρ))]
    [(cons Ce cc)
     (cc-determined? cc)]))

(define (take-cc cc)
  (take-ccm (current-m) cc))

(define (take-ccm m cc)
  (if (zero? m)
      (if (equal? 'basic (demand-kind))
          (list)
          (match cc
            [`(cenv ,Ce ,ρ) '!]; Cut known
            [`(cons Ce cc) '!]; Cut known
            ['! '!]
            [(list) (list)]; Already 0
            [_ '?])) ; Cut unknown -- TODO: Can we leave the variable since it terminates anyways?
      (match cc
        [(list)
         (list)]
        ['! '!] ; Cut known
        ['? '?] ; Cut unknown (can be reinstantiated to an indeterminate context)
        [`(□? ,x)
         `(□? ,x)]
        [`(cenv ,Ce ,ρ)
         `(cenv ,Ce ,(map (λ (cc) (take-ccm (- m 1) cc)) ρ))]
        [(cons Ce cc)
         (cons Ce (take-ccm (- m 1) cc))])))

(define (head-env ρ)
  (match ρ
    [(list) (list)]
    [(cons cc _) cc])
  )

(define (enter-cc Ce ρ)
  (match (demand-kind)
    ['basic (take-cc (cons Ce (head-env ρ)))]
    [_ (take-cc `(cenv ,Ce ,ρ))]
    )
  )

(define (indeterminate-env Ce)
  (match Ce
    [(cons `(bod ,y ,C) e)
     (cons `(□? ,y) (indeterminate-env (cons C e)))]
    [`(top)
     (list)]
    [_
     (indeterminate-env (oute Ce))]
    ))

(define (calibrate-envs ρ₀ ρ₁); Adds one level of missing context
  (let [(res (map calibrate-ccs ρ₀ ρ₁))]
    (if (and res)
        res
        #f)
    ))

(define (calibrate-ccs cc₀ cc₁)
  (match cc₀
    [(list) (list)]
    ['! #f]
    ['? cc₁]
    [`(□? ,x) `(□? ,x)]
    [`(cenv ,Ce₀ ,ρ₀)
     (let [(res (calibrate-envs (indeterminate-env Ce₀) cc₁))]
       (if res
           `(cenv ,Ce₀ ,res)
           #f))]
    )
  )

(define (calibrate-env ρ)
  (begin
    ; (pretty-print "Calibrating env")
    ; (pretty-print ρ)
    (match ρ
      [`(cenv ,Ce ,ρ)
       (let [(res (calibrate-envs (indeterminate-env Ce) ρ))]
         (if res (cons Ce res) #f))]
      [_ #f]
      )))

; Is cc0 more refined or equal to cc1?
;  i.e. should an environment with cc1 be instantiate to replace cc1 with cc0?
(define (⊑-cc cc₀ cc₁)
  (match cc₀
    [(list)
     (match cc₁
       [(list) #t] ; equal
       ['? #f]
       ['! #f]
       [`(□? ,_) #f]
       [`(cenv ,Ce ,ρ) #f]
       [(cons _ _) #f])]
    ['!
     (match cc₁
       ['! #t]; cut unknown is equal
       [(list) #f]; cut is not more refined
       ['? #f]; cut known is not more refined
       [`(□? ,_) #f]; cut is not more refined
       [`(cenv ,Ce ,ρ) #f]; cut is not more refined
       [(cons _ _) #f])]; cut is not more refined
    ['?
     (match cc₁
       ['? #t]; cut known is equal
       ['! #f]; cut unknown is not more refined (it is but we don't need to run under unknown if we know)
       [(list) #f]; cut is not more refined
       [`(□? ,_) #f]; cut is not more refined
       [`(cenv ,Ce ,ρ) #f]; cut is not more refined
       [(cons _ _) #f])]; cut is not more refined
    [`(□? ,x)
     (match cc₁
       [(list) #f]; indeterminate is not more refined
       ['! #f]; indeterminate is more refined - we know more
       ['? #t]; indeterminate is more refined - we know the variables
       [`(□? ,y) (equal? x y)]; indeterminate is equal if they are equal otherwise false
       [`(cenv ,Ce ,ρ) #f]; indeterminate is not more refined
       [(cons _ _) #f])]
    [`(cenv ,Ce₀ ,ρ₀)
     (match cc₁
       [(list) #f]; call-env is not more refined
       ['! #t]; call-env is more refined
       ['? #t]; call-env is more refined
       [`(□? ,_) #t]; call-env is more refined
       [`(cenv ,Ce₁ ,ρ₁)
        (and (equal? Ce₀ Ce₁)
             (and (map ⊑-cc ρ₀ ρ₁)))]
       )]
    [(cons Ce₀ cc₀)
     (match cc₁
       [(list) #f]
       ['! #t]
       ['? #t]
       [`(□? ,_) #t]
       [(cons Ce₁ cc₁)
        (and (equal? Ce₀ Ce₁)
             (⊑-cc cc₀ cc₁))])]))

; syntax traversal

(define (oute Ce)
  (match Ce
    [(cons `(rat ,e₁ ,C) e₀)
     (cons C `(app ,e₀ ,e₁))]
    [(cons `(ran ,e₀ ,C) e₁)
     (cons C `(app ,e₀ ,e₁))]
    [(cons `(bod ,y ,C) e)
     (cons C `(λ (,y) e))]
    [(cons `(let-bod ,x ,e₀ ,C) e₁)
     (cons C `(let ([,x ,e₀]) ,e₁))]
    [(cons `(let-bin ,x ,e₁ ,C) e₀)
     (cons C `(let ([,x ,e₀]) ,e₁))]
    [`(top) (error 'out "top")]))

(define (out Ce ρ)
  (match Ce
    [(cons `(rat ,e₁ ,C) e₀)
     (unit (cons C `(app ,e₀ ,e₁)) ρ)]
    [(cons `(ran ,e₀ ,C) e₁)
     (unit (cons C `(app ,e₀ ,e₁)) ρ)]
    [(cons `(bod ,y ,C) e)
     (unit (cons C `(λ (,y) e))
           (match-let ([(cons _ ρ) ρ]) ρ))]
    [(cons `(let-bod ,x ,e₀ ,C) e₁)
     (unit (cons C `(let ([,x ,e₀]) ,e₁)) ρ)]
    [(cons `(let-bin ,x ,e₁ ,C) e₀)
     (unit (cons C `(let ([,x ,e₀]) ,e₁)) ρ)]
    [`(top)
     (error 'out "top")]))

(define (bin-e Ce ρ)
  (match Ce
    [(cons C `(let ([,x ,e₀]) ,e₁))
     (list (cons `(let-bin ,x ,e₁ ,C) e₀) ρ)]))

(define (bin Ce ρ)
  (match Ce
    [(cons C `(let ([,x ,e₀]) ,e₁))
     (unit (cons `(let-bin ,x ,e₁ ,C) e₀) ρ)]))

(define (bod-e Ce ρ)
  (match Ce
    [(cons C `(λ (,x) ,e))
     (list (cons `(bod ,x ,C) e) (cons (take-cc `(□? ,x)) ρ))]
    [(cons C `(let ([,x ,e₀]) ,e₁))
     (list (cons `(let-bod ,x ,e₀ ,C) e₁) ρ)]))

(define (bod Ce ρ)
  (match Ce
    [(cons C `(λ (,x) ,e))
     (unit (cons `(bod ,x ,C) e) (cons (take-cc `(□? ,x)) ρ))]
    [(cons C `(let ([,x ,e₀]) ,e₁))
     (unit (cons `(let-bod ,x ,e₀ ,C) e₁) ρ)]))

(define (bod-calibrate Ce call ρ ρ′)
  (match Ce
    [(cons C `(λ (,x) ,e))
     (unit (cons `(bod ,x ,C) e) (cons (take-cc `(cenv ,call ,ρ)) ρ′))]
    [(cons C `(let ([,x ,e₀]) ,e₁))
     (unit (cons `(let-bod ,x ,e₀ ,C) e₁) ρ)]))

(define (rat-e Ce ρ)
  (match Ce
    [(cons C `(app ,e₀ ,e₁))
     (list (cons `(rat ,e₁ ,C) e₀) ρ)]))

(define (rat Ce ρ)
  (match Ce
    [(cons C `(app ,e₀ ,e₁))
     (unit (cons `(rat ,e₁ ,C) e₀) ρ)]))

(define (ran-e Ce ρ)
  (match Ce
    [(cons C `(app ,e₀ ,e₁))
     (list (cons `(ran ,e₀ ,C) e₁) ρ)]))

(define (ran Ce ρ)
  (match Ce
    [(cons C `(app ,e₀ ,e₁))
     (unit (cons `(ran ,e₀ ,C) e₁) ρ)]))

(define (gen-queries Ce ρ)
  (define self-query (list Ce ρ))
  (define child-queries (match Ce
                          [(cons C `(app ,e₀ ,e₁))
                           (set-union (apply gen-queries (ran-e Ce ρ))
                                      (apply gen-queries (rat-e Ce ρ)))]
                          [(cons C `(λ (,x) ,e))
                           (apply gen-queries (bod-e Ce ρ))]
                          [(cons C `(let ([,x ,e₀]) ,e₁))
                           (set-union (apply gen-queries (bod-e Ce ρ))
                                      (apply gen-queries (bin-e Ce ρ)))]
                          [_ (set)]))
  (set-add child-queries self-query))

; environment refinement

(define (((put-refines ρ₀ ρ₁) k) s)
  (pretty-trace `(refines ,ρ₀ ,ρ₁))
  ((k #f) ((node-absorb/powerset (refine ρ₁) (list ρ₀)) s)))

(define-key (refine p) fail)

(define get-refines*
  (match-lambda
    [(list)
     ⊥]
    [(and ρ (cons cc ρ′))
     (pretty-trace "GET-REFINES")
     (pretty-trace ρ)
     (⊔ (if (cc-determined? cc)
            ; won't have any refinements at this scope
            fail
            (refine ρ))
        (>>= (get-refines* ρ′) (λ (ρ′) (unit (cons cc ρ′)))))]))

; demand evaluation


(define-key (eval Ce ρ) #:⊥ litbottom #:⊑ lit-lte #:⊔ lit-union #:product
  (print-eval-result
   `(eval-x ,Ce ,ρ)
   (λ ()
     (⊔ (match Ce
          [(cons C (? symbol? x))
           (pretty-trace "REF")
           (>>= (bind x C x ρ)
                (λ (Ce ρ)
                  (match Ce
                    [(cons `(bod ,x ,C) e)
                     (pretty-trace "REF-BOD")
                     (pretty-trace `(bod ,x ,C, e))
                     (>>= (>>= (call C x e ρ) ran) eval)]
                    [(cons `(let-bod ,_ ,_ ,_) e)
                     (pretty-trace "REF-LETBOD")
                     (>>= (>>= (out Ce ρ) bin) eval)])))]
          [(cons _ `(λ (,_) ,_))
           (pretty-trace "LAM")
           (clos Ce ρ)]
          [(cons _ `(app ,_ ,_))
           (pretty-trace "APP")
           (>>=
            (>>=clos
             (>>= (rat Ce ρ) eval)
             (λ (Ce′ ρ′)
               (print-result
                `('bodof ,Ce ,ρ ,Ce′ ,ρ′)
                (λ () (match (demand-kind)
                        ['basic (bod Ce′ ρ′)]
                        [_ (bod-calibrate Ce′ Ce ρ ρ′)]
                        )))

               ))
            eval)]
          [(cons _ `(let ,_ ,_))
           (pretty-trace "LET")
           (>>= (bod Ce ρ) eval)]
          )
        (>>= (get-refines* ρ)
             (λ (ρ′)
               (begin
                 (pretty-trace "REFINES")
                 (pretty-trace ρ′)
                 (eval Ce ρ′)
                 )))))))

(define (bind x C e ρ)
  (match C
    [`(rat ,e₁ ,C)
     (bind x C `(app ,e ,e₁) ρ)]
    [`(ran ,e₀ ,C)
     (bind x C `(app ,e₀ ,e) ρ)]
    [`(bod ,y ,C)
     (if (equal? x y)
         (unit (cons `(bod ,y ,C) e) ρ)
         (bind x C `(λ (,y) ,e) (match-let ([(cons _ ρ) ρ]) ρ)))]
    [`(let-bod ,y ,e₀ ,C′)
     (if (equal? x y)
         (unit (cons C e) ρ)
         (bind x C′ `(let ([,y ,e₀]) ,e) ρ))]
    [`(let-bin ,y ,e₁ ,C)
     (bind x C `(let ([,y ,e]) ,e₁) ρ)]
    [`(top)
     ⊥]))


(define (print-eval-result input computation)
  (>>=eval
   (computation)
   (λ (Cee ρee)
     (if (trace)
         (begin
           (pretty-print input)
           (pretty-print `(result ,Cee ,ρee))
           (clos Cee ρee))
         (clos Cee ρee)
         )
     )
   (λ (num)
     (if (trace)
         (begin
           (pretty-print input)
           (pretty-print `(result ,num))
           (lit num))
         (lit num)
         )
     )
   )
  )

(define (print-result input computation)
  (>>=
   (computation)
   (λ (Cee ρee)
     (if (trace)
         (begin
           (pretty-print input)
           (pretty-print `(result ,Cee ,ρee))
           (unit Cee ρee))
         (unit Cee ρee)))))

(define (pretty-tracen n p)
  (if (trace)
      (if (> (trace) n)
          (pretty-print p)
          (void))
      (void)))

(define (pretty-trace p)
  (if (trace)
      (pretty-print p)
      (void)))

(define (call C x e ρ)
  (print-result
   `(call ,C ,x ,ρ)
   (λ () (match-let ([(cons cc₀ ρ₀) ρ])
           (match (demand-kind)
             ['basic
              (pretty-trace "CALL-BASIC")
              (>>= (expr (cons C `(λ (,x) ,e)) ρ₀)
                   (λ (Cee ρee)
                     (pretty-trace Cee)
                     (let ([cc₁ (enter-cc Cee ρee)])
                       (cond
                         [(equal? cc₀ cc₁)
                          (pretty-trace "CALL-EQUAL")
                          (unit Cee ρee)]
                         [(⊑-cc cc₁ cc₀)
                          (pretty-trace "CALL-FOUND-REFINES")
                          ; strictly refines because of above
                          (>>= (put-refines (cons cc₁ ρ₀) ρ) (λ _ ⊥))
                          ]
                         [else
                          (pretty-tracen 1 "CALL-NOREFINE")
                          ⊥]))))]
             [_ (match (calibrate-env ρ)
                  [(cons Ce ρ′)
                   (pretty-trace "CALL-KNOWN")
                   (unit Ce ρ′)]
                  [#f
                   (begin
                     (pretty-trace "CALL UNKNOWN")
                     (>>= (expr (cons C `(λ (,x) ,e)) ρ₀); Fallback to normal basic evaluation
                          (λ (Cee ρee)
                            (pretty-trace `(,Cee ,ρee))
                            (let ([cc₁ (enter-cc Cee ρee)])
                              (cond
                                [(equal? cc₀ cc₁)
                                 (pretty-trace "CALL-EQ")
                                 (unit Cee ρee)]
                                [(⊑-cc cc₁ cc₀)
                                 (pretty-trace "CALL-REFINE")
                                 (pretty-trace `(,cc₁ ,cc₀))
                                 ; strictly refines because of above
                                 (>>= (put-refines (cons cc₁ ρ₀) ρ) (λ _ ⊥))
                                 ]
                                [x
                                 (pretty-trace "CALL-NOREF")
                                 (pretty-trace `(cc₀ ,cc₀))
                                 ⊥])))))]
                  )])
           )
     )
   )
  )

(define-key (expr Ce ρ)
  (print-result
   `(expr ,Ce ,ρ)
   (λ () (⊔ (match Ce
              [(cons `(rat ,_ ,_) _)
               (pretty-trace "RAT")
               (out Ce ρ)]
              [(cons `(ran ,_ ,_) _)
               (>>= (out Ce ρ)
                    (λ (Cee ρee)
                      (>>=clos (>>= (rat Cee ρee) eval)
                               (λ (Cλx.e ρλx.e)
                                 (match-let ([(cons C `(λ (,x) ,e)) Cλx.e])
                                   (>>= (find x
                                              (cons `(bod ,x ,C) e)
                                              (cons (enter-cc Cee ρee)
                                                    ρλx.e))
                                        expr))))))]
              [(cons `(bod ,x ,C) e)
               (>>= (call C x e ρ) expr)]
              [(cons `(let-bin ,x ,e ,C) e1)
               (>>= (out Ce ρ) expr)]
              [(cons `(top) _)
               ⊥])
            (>>= (get-refines* ρ) (λ (ρ′) (expr Ce ρ′)))))))

(define (find x Ce ρ)
  (match Ce
    [(cons C (? symbol? y))
     (if (equal? x y)
         (unit Ce ρ)
         ⊥)]
    [(cons C `(λ (,y) ,e))
     (if (equal? x y)
         ⊥
         (find x (cons `(bod ,y ,C) e) (cons (take-cc `(□? ,y)) ρ)))]
    [(cons C `(app ,e₀ ,e₁))
     (each (find x (cons `(rat ,e₁ ,C) e₀) ρ)
           (find x (cons `(ran ,e₀ ,C) e₁) ρ))]
    [(cons C `(let ([,y ,e₀]) ,e₁))
     (each (find x (cons `(let-bin ,y ,e₁ ,C) e₀) ρ)
           (if (equal? x y)
               ⊥
               (find x (cons `(let-bod ,y ,e₀ ,C) e₁) ρ)))]))

(provide (all-defined-out)
         (all-from-out "table-monad/main.rkt"))

(define (run-print-query q)
  (pretty-print q)
  (run q))

(module+ main
  (require racket/pretty)
  (define example0 (list (cons `(top)
                               `(app (λ (x) x)
                                     (λ (y) y))) (list)))

  ; (demand-kind 'basic)
  ; (pretty-print (run-print-query (apply eval example0)))

  ; (demand-kind 'hybrid)
  ; (pretty-print (run-print-query (apply eval example0)))

  ; (pretty-print
  ;  (run-print-query (apply eval (apply rat-e example0))))

  ; (pretty-print
  ;  (run-print-query (apply eval (apply ran-e example0))))
  (trace 1)
  ; (demand-kind 'basic)
  ; (pretty-print
  ;  (run-print-query (apply eval (apply bod-e (apply rat-e example0)))))
  ; (demand-kind 'hybrid)
  ; (pretty-print
  ;  (run-print-query (apply eval (apply bod-e (apply rat-e example0)))))

  ; (pretty-print
  ;  (run-print-query (apply eval (apply bod-e (apply ran-e example0)))))

  ; (current-m 4)

  (define example1 (list (cons `(top)
                               `(app (λ (x) (app x x))
                                     (λ (y) (app y y))))
                         (list)))
  ; (demand-kind 'basic)
  ; (pretty-print
  ;  (run-print-query (apply eval (apply bod-e (apply ran-e example1)))))
  (demand-kind 'hybrid)
  (pretty-print
   (run-print-query (apply eval (apply bod-e (apply ran-e example1)))))

  ; #;"QUERY"
  ; (pretty-print
  ;  (run-print-query (apply eval (apply bod-e (apply rat-e example1)))))

  ; #;"QUERY"
  ; (pretty-print
  ;  (run-print-query (apply eval (apply rat-e (apply bod-e (apply ran-e example1))))))

  ; #;"QUERY"
  ; (pretty-print
  ;  (run-print-query (apply eval (apply ran-e example1))))

  ; #;"QUERY"

  ; (define example2 (list (cons `(top)
  ;                              `(let ([x (λ (y) y)])
  ;                                 x))
  ;                        (list)))
  ; (pretty-print
  ;  (run-print-query (apply eval (apply bod-e example2))))
  )