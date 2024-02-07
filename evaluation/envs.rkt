#lang racket/base
(require (rename-in "table-monad/main.rkt" [void fail]))
(require "config.rkt" "demand-abstraction.rkt" "syntax.rkt" "utils.rkt")
(require racket/set racket/match racket/list racket/pretty)
(provide (all-defined-out))

; m-CFA flat like environments (rebinding free variables)
(struct flatenv (m) #:transparent)
; m-CFA exponential environments (nested environments)
(struct expenv (m) #:transparent)
; Demand m-CFA environments (nested environments, with embedded environments)
(struct envenv (m) #:transparent)
; Demand m-CFA basic environments (nested environments) akin to m-CFA exponential, but with indeterminate calling contexts
(struct menv (m) #:transparent)

; The lexical environment list
(define (env-list ρ)
  (match ρ
    [(expenv l) l]
    [(envenv l) l]
    [(menv l) l]
    ))

; Splits into the current closure's calling context, and the lexically enclosing closure's environment
; If the env doesn't include any closures, returns it unaltered
(define (split-env env)
  (match env
    [(flatenv _) (error 'flatenv "Flatenvs do not have lexical splits (they only keep track of innermost calls)")]
    [(expenv (cons head tail)) (cons head (expenv tail))]
    [(expenv '()) (expenv '())]
    [(envenv (cons head tail)) (cons head (envenv tail))]
    [(envenv '()) (envenv '())]
    [(menv (cons head tail)) (cons head (menv tail))]
    [(menv '()) (menv '())]
    )
  )

; Gets the head calling context of environments, or empty list if the environment is empty
; Sometimes we are called from calibrate-envs which returns false if there would be a cut: propagate that
(define (head-cc ρ)
  (if ρ
      (head-or-empty (env-list ρ))
      #f
      ))

; Get's the indeterminate lexically enclosing exponential environment representation
; (sequence of ccs) that are all indeterminate
(define (indeterminate-env Ce)
  (match Ce
    [(cons `(bod ,y ,C) e)
     (cons `(□? ,y) (indeterminate-env (cons C e)))]
    [(cons `(top) _)
     (list)]
    [_ (indeterminate-env (oute Ce))]))

; Gets the innermost indeterminate lambda environment or #f if not in a lambda
(define (inner-lambda-bindings Ce)
  (match (indeterminate-env Ce)
    [(cons b _) b]
    [_ #f]))

; calling contexts

; Is cc0 more refined or equal to cc1?
;  i.e. should an environment with cc1 be instantiate to replace cc1 with cc0?
(define (⊑-cc cc₀ cc₁)
  (match cc₀
    ['! ; TODO: Figure out '! cases here
     (match cc₁
       [(list) #f] ; equal
       [`(□? ,_) #f]
       [`(cenv ,_ ,_) #f]
       [(cons _ _) #f]
       ['! #t])]
    [(list)
     (match cc₁
       ['! #t] ; refines '!
       [(list) #t] ; equal
       [`(□? ,_) #f]
       [`(cenv ,_ ,_) #f]
       [(cons _ _) #f])]
    [`(□? ,x)
     (match cc₁
       ['! #t] ; refines '!
       [(list) #f]; indeterminate is not more refined
       [`(□? ,y) (equal? x y)]; indeterminate is equal if they are equal otherwise false
       [`(cenv ,_ ,_) #f]; indeterminate is not more refined
       [(cons _ _) #f])]
    [`(cenv ,Ce₀ ,ρ₀)
     (match cc₁
       ['! #t] ; refines '!
       [(list) #f]; call-env is not more refined
       [`(□? ,_) #t]; call-env is more refined
       [`(cenv ,Ce₁ ,ρ₁)
        (and (equal? Ce₀ Ce₁)
             (alls (map ⊑-cc (envenv-m ρ₀) (envenv-m ρ₁))))]
       )]
    [(cons Ce₀ cc₀)
     (match cc₁
       ['! #t] ; refines '!
       [(list) #f]
       [`(□? ,_) #t]
       [(cons Ce₁ cc₁)
        (and (equal? Ce₀ Ce₁)
             (⊑-cc cc₀ cc₁))])]))

; Can the environment be refined further?
(define cc-determined?
  (match-lambda
    [(list) #t]
    [`(□? ,_) #f]
    [`(cenv ,Ce ,ρ) (alls (map cc-determined? (envenv-m ρ)))]
    [(cons Ce cc) (cc-determined? cc)]))

; Used for flat environments gets the top m stack frames (assuming most recent stack frame is the head of the list)
(define (take-m cc m)
  (if (equal? m 0) '()
      (match cc
        [(cons c cc) (cons c (take-m cc (- m 1)))]
        ['() '()]
        ))
  )

; Should not be used for flatenvs (see take-m)
(define (take-cc cc)
  (if (equal? (current-m) 0); Special case m=0
      '()
      (take-ccm (current-m) cc)))

; Gets m stack frames from any particular environment representation (other than flat environments)
(define (take-ccm m cc)
  ; Cut is used in calibrate-envs to determine if we need to do an expr relation to find the call sites
  (if (zero? m)
      (list)
      (match cc
        [(list)
         (list)]
        [`(□? ,x)
         `(□? ,x)]
        ['! '!]
        [`(cenv ,Ce ,ρ)
         `(cenv ,Ce ,(envenv (map (λ (cc) (take-ccm (- m 1) cc)) (envenv-m ρ))))]
        [(cons Ce cc); This case handles regular/exponential m-CFA and basic Demand m-CFA call strings
         (cons Ce (take-ccm (- m 1) cc '_))])))

; If m=0 still keep the indeterminate bindings (`lamenv` instead of the call location `Ce`)
(define (enter-cc Ce ρ)
  (match ρ
    [(menv _) (take-cc (cons Ce (head-cc ρ)))]
    [(expenv _) (take-cc (cons Ce (head-cc ρ)))]
    [(expenv _) ((calibrate-ccsm (current-m)) `(cenv ,Ce ,ρ) 'only-ever-cuts)]
    [(flatenv calls) (take-m (cons Ce calls) (current-m))]; Basic m-CFA doesn't
    )
  )

(define (assert-indeterminate cc [ignore-cut #t])
  (match cc
    [`(□? ,x) '()]
    ['only-ever-cuts (if ignore-cut '() (error 'unexpected-need-indet-ctx-in-enter-cc (pretty-format cc)))]
    [_ (error 'expected-indeterminate-ctx (pretty-format `(got ,cc))) ]
    )
  )

(define ((calibrate-ccsm m) cc0 cc1)
  (assert-indeterminate cc1)
  (if (equal? m 0)
      (match cc0 ; Cut
        [(list) (list)]; Already 0
        [`(cenv ,_ ,_) '!]; Cut known
        ['! '!]
        [`(□? ,x) (list)]; Cut unknown -- TODO: Can we leave the variable since it terminates anyways, and will be reinstantiate to the same thing?
        )
      (match cc0
        [(list); Restore indeterminate context if there was any
         (assert-indeterminate cc1 #f)
         cc1] ; cc1 is always indeterminate
        ['! '!];
        [`(□? ,x) `(□? ,x)]
        [`(cenv ,call ,ρ₀)
         (match (calibrate-envsm ρ₀ (envenv (indeterminate-env call)) (- m 1))
           [res `(cenv ,call ,res)]
           )]
        ))
  )

; Adds missing context
(define (calibrate-envsm ρ₀ ρ₁ m)
  ; (pretty-print `(calibrating-envs ,ρ₀ ,ρ₁))
  (let [(res (map (calibrate-ccsm m) (envenv-m ρ₀) (envenv-m ρ₁)))]
    (envenv res)
    ))

(define (calibrate-envs ρ₀ ρ₁)
  (calibrate-envsm ρ₀ ρ₁ (current-m)))

; Cuts should not be a part of queries, they are just used to if we would lose information
(define (expect-no-cut p)
  '()
  ; (match p
  ; [(envenv _)
  ;    (if (not (cut-env p))
  ;     '()
  ;     (error 'env-has-cut (pretty-format p)))])
  )

; Check that a environment is not cut
(define (cut-env p)
  (match p
    [(envenv l)
     (ors (map cut-cc l))]
    ))

; Check if a call context has been cut
(define (cut-cc cc)
  (match cc
    [(list) #f]
    ['! #t]
    [`(□? ,_) #f]
    [`(cenv ,Ce ,ρ) (cut-env ρ)]
    )
  )

(define (equal-simplify-envs? result1 result2)
  (if (or (not result1) (not result2))
      #t ; Cannot compare because one hit a timeout
      (let ()
        (define r1 (simplify-envs result1))
        (define r2 (simplify-envs result2))
        (match r1
          [(cons s1 l1)
           (match r2
             [(cons s2 l2)
              ; Hybrid can be a subset of the basic, since it doesn't visit extraneous
              ; (if (not (equal? r1 r2))
              ;     (pretty-print `(,r1 == ,r2)) '())
              (and (equal? l1 l2) (subset? s1 s2))]
             )]
          )
        )
      )  )

(define (simplify-envs result)
  (match result
    [(cons s l)
     (define (simple-closure-envs c)
       (match c
         [(list `(prim ,l) env) (list `(prim ,l) (simple-env env))]
         [(list (cons C e) env) (list (cons C e) (simple-env env))]
         ;  [(list const env) (list const (simple-env env))]
         ))
     (cons (apply set (map simple-closure-envs (set->list s))) l)
     ]
    )
  )

(define (simple-env ρ)
  ; (pretty-print `(simple-env ρ))
  (map simple-call-env (env-list ρ)))

(define (simple-call-env cc)
  ; (pretty-print `(simple-call-env ,cc))
  (match cc
    [(list) (list)]
    ['! '!]
    [`(□? ,x) `(□? ,x)]
    [`(cenv ,Ce ,ρ)
     ;  (pretty-print `(simplifying ,Ce ,ρ))
     (cons Ce (simple-call-env (head-cc ρ)))]
    [(cons Ce cc) (cons Ce cc)]
    )
  )

(define (show-simple-env ρ)
  (if (show-envs-simple)
      (match ρ
        [(flatenv l) (flatenv (map show-simple-ctx l))]
        [(expenv l) (expenv (map show-simple-call l))]
        [(menv l) (menv (map show-simple-call l))]
        [(envenv l) (envenv (map show-simple-call l))]
        )
      ρ
      )
  )

(define (show-simple-call cc)
  (match cc
    [(list)
     (list)]
    ['! '!] ; Cut known
    [`(□? ,x)
     `(□? ,x)]
    [`(cenv ,Ce ,ρ)
     `(cenv ,(show-simple-ctx Ce) ,(show-simple-env ρ))]
    [(cons Ce cc)
     (cons (show-simple-ctx Ce) (show-simple-call cc))])
  )

(module+ main
  (require rackunit)
  ; Free variables
  (check-equal? (free-vars `(app a b)) (set 'a 'b))
  (check-equal? (free-vars `(λ (a) (app a b))) (set 'b))
  (check-equal? (free-vars `(λ (a) (match a ((cons b c) (app b c)) (nil (app c1 d1))))) (set 'c1 'd1))
  (check-equal? (free-vars `(let ((a b)) (app a b))) (set 'b))
  ; Bound variables (patterns)
  (check-equal? (pattern-bound-vars `(cons b c)) (set 'b 'c))
  (check-equal? (pattern-bound-vars `(cons (cons a b) c)) (set 'a 'b 'c))
  (check-equal? (pattern-bound-vars `(cons (cons a 2) #f)) (set 'a))
  (check-equal? (pattern-bound-vars `(cons (cons 1.0 "") #f)) (set))
  ; Pattern bind locations
  (check-equal? (find-match-bind 'a `(cons a b)) `(cons 0 #t))
  (check-equal? (find-match-bind 'a `(cons b a)) `(cons 1 #t))
  (check-equal? (find-match-bind 'a `(cons b (cons a))) `(cons 1 (cons 0 #t)))
  (check-equal? (find-match-bind 'a `(cons b (cons 1.0 nil))) #f)
  )