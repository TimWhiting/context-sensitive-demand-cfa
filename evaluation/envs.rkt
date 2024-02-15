#lang racket/base
(require (rename-in "table-monad/main.rkt" [void fail]))
(require "config.rkt" "abstract-value.rkt" "syntax.rkt" "utils.rkt")
(require racket/set racket/match racket/list racket/pretty)
(provide (all-defined-out))

; m-CFA flat like environments (rebinding free variables)
(struct flatenv (m) #:transparent)
; m-CFA exponential environments (nested environments)
(struct expenv (m) #:transparent)
; Demand m-CFA basic environments (nested environments) akin to m-CFA exponential, but with indeterminate calling contexts
(struct menv (m) #:transparent)
(struct callc (m) #:transparent)

; The lexical environment list
(define (env-list ρ)
  (match ρ
    [(expenv l) l]
    [(menv l) l]
    ))

; Splits into the current closure's calling context, and the lexically enclosing closure's environment
; If the env doesn't include any closures, returns it unaltered
(define (split-env env)
  (match env
    [(flatenv _) (error 'flatenv "Flatenvs do not have lexical splits (they only keep track of innermost calls)")]
    [(expenv (cons (callc head) tail)) (cons head (expenv tail))]
    [(expenv '()) (expenv '())]
    [(menv (cons (callc head) tail)) (cons head (menv tail))]
    [(menv '()) (menv '())]
    )
  )

; Gets the head calling context of environments, or empty list if the environment is empty
; Sometimes we are called from calibrate-envs which returns false if there would be a cut: propagate that
(define (head-cc ρ)
  (match (head-or-empty (env-list ρ))
    [(list) (list)]
    [(callc c) c]
    )
  )

; Get's the indeterminate lexically enclosing exponential environment representation
; (sequence of ccs) that are all indeterminate
(define (indeterminate-env Ce)
  (match Ce
    [(cons `(bod ,y ,C) e)
     (cons (callc `(□? ,y ,C)) (indeterminate-env (cons C e)))]
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
  ; (pretty-print `(refined? ,(show-simple-call cc₀) ,(show-simple-call cc₁)))
  (match cc₀
    [(list)
     (match cc₁
       [(list) #t] ; equal
       [`(□? ,_ ,_) #f]
       [(cons _ _) #f])]
    [`(□? ,x ,_)
     (match cc₁
       [(list) #f]; indeterminate is not more refined
       [`(□? ,y ,_) (equal? x y)]; indeterminate is equal if they are equal otherwise false
       [(cons _ _) #f])]
    [(cons Ce₀ cc₀)
     (match cc₁
       [(list) #f]
       [`(□? ,y ,_) #t]
       [(cons Ce₁ cc₁)
        (and (equal? Ce₀ Ce₁)
             (⊑-cc cc₀ cc₁))])]))

(define (cc-determined? ccs)
  ((cc-determinedm? (current-m)) ccs))

; Can the environment be refined further?
(define (cc-determinedm? m)
  (match-lambda
    [(list) #t]
    [`(□? ,_ ,_) #f]
    [(cons Ce ccs) ((cc-determinedm? (- 1 m)) ccs)]))

; Used for flat environments gets the top m stack frames (assuming most recent stack frame is the head of the list)
(define (take-m cc m)
  (if (equal? m 0) '()
      (match cc
        [(cons c ccs) (cons c (take-m ccs (- m 1)))]
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
        [`(□? ,x ,C)
         `(□? ,x ,C)]
        [(cons Ce cc); This case handles regular/exponential m-CFA and basic Demand m-CFA call strings
         (cons Ce (take-ccm (- m 1) cc))])))

; If m=0 still keep the indeterminate bindings (`lamenv` instead of the call location `Ce`)
(define (enter-cc Ce ρ)
  (match ρ
    [(menv _) (take-cc (cons Ce (head-cc ρ)))]
    [(expenv _) (take-cc (cons Ce (head-cc ρ)))]
    [(flatenv calls) (take-m (cons Ce calls) (current-m))]; Basic m-CFA doesn't
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
    [`(□? ,x ,C) `(□? ,x ,C)]
    [(cons Ce cc) (cons Ce cc)]
    )
  )

(define (show-simple-env ρ)
  (if (show-envs-simple)
      (match ρ
        [(flatenv l) (flatenv (map show-simple-ctx l))]
        [(expenv l) (expenv (map show-simple-call (map callc-m l)))]
        [(menv l) (menv (map show-simple-call (map callc-m l)))]
        )
      ρ
      )
  )

(define (top-env)
  (match (analysis-kind)
    ['exponential (expenv '())]
    ['rebinding (flatenv '())]
    ['basic (menv '())]
    )
  )

(define (show-simple-call cc)
  (match cc
    [(list)
     (list)]
    [`(□? ,x ,_)
     `(□? ,x)]
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