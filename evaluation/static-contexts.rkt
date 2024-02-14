#lang racket/base
(require (rename-in "table-monad/main.rkt" [void fail]))
(require "config.rkt" "envs.rkt" "syntax.rkt" "utils.rkt")
(require racket/match racket/list racket/pretty)
(provide (all-defined-out))
; syntax traversal

(define ((out-arg i) Ce ρ)
  (>>= (out Ce ρ #t)
       (λ (Ce ρ)
         ((ran i) Ce ρ))
       )
  )

(define (>>=list m)
  (m (λ (Ce ρ) (list Ce ρ))))

(define (args-e Ce)
  (match Ce
    [(cons _ `(app ,_ ,@args))
     args]))

; Primitive constructors
(define (check-known-constructor? x)
  (match x
    ['cons #t]
    ['nil #t]
    ['error #t]
    ))

(define (check-known-constructor-or-primitive? x)
  (member x '(cons nil error = - + < <= not or and equal? newline display void)))

(define ((bind x) Ce ρ)
  (define (search-out) (>>= (out Ce ρ) (bind x)))
  ; (pretty-print `(bind ,x ,Ce ,ρ))
  (match Ce
    [(cons `(top) _)
     (check-known-constructor-or-primitive? x)
     (unit x ρ -1)] ; Constructors
    [(cons `(lettypes-bod ,binds ,C) e₁)
     ;  (pretty-print (map car binds))
     ;  (pretty-print x)
     ;  (pretty-print (member x (map car binds)))
     (if (member x (map car binds))
         (unit x ρ -1)
         (search-out)
         )
     ]
    [(cons `(bin ,let-kind ,y ,_ ,before ,after ,_) _)
     ;  (pretty-print `(bin ,y ,x))
     (define defs
       (match let-kind
         ; Only the prior definitions are bound for let*
         ['let* (map car before)]
         ; All definitions are in scope for letrec
         ['letrec (append (map car before) (list y) (map car after))]
         ; None of the definitions are in scope for regular let
         [_ (list)]
         ))
     (if (ors (map (λ (y) (equal? x y)) defs))
         (unit Ce ρ (index-of defs x)) ; Index works for all types of let
         (search-out))]
    [(cons `(bod ,ys ,_) _)
     ;  (pretty-print `(bodbind ,ys ,x ,(ors (map (λ (y) (equal? x y)) ys)) ,(index-of ys x)))
     (if (ors (map (λ (y) (equal? x y)) ys))
         (unit Ce ρ (index-of ys x))
         (search-out))]
    [(cons `(let-bod ,_ ,binds ,_) _)
     (define defs-len (length binds))
     ; reverse the bindings so that in let* we get the most recent definition
     ; in case of shadowing
     (define defs-rev (reverse (map car binds)))
     ;  (pretty-print `(bin ,defs))
     (if (ors (map (λ (y) (equal? x y)) defs-rev))
         ; Adjust the index because the defs are in reversed order
         (unit Ce ρ (- defs-len 1 (index-of defs-rev x)))
         (search-out))]
    [(cons `(match-clause ,m ,scruitinee ,before ,after ,_) e₀)
     (define match-binding (find-match-bind x m))
     (if match-binding (unit Ce ρ match-binding) (search-out))]
    ; All other forms do not introduce bindings
    [(cons _ _) (search-out)]
    ))

(define (out Ce ρ)
  ; (pretty-print `(out ,Ce ,ρ))
  (match Ce
    [(cons `(rat ,es ,C) e₀)
     (unit (cons C `(app ,e₀ ,@es)) ρ)]
    [(cons `(match-e ,es ,C) e₀)
     (unit (cons C `(match ,e₀ ,@es)) ρ)]
    [(cons `(ran ,f ,b ,a ,C) e)
     (unit (cons C `(app ,f ,@b ,e ,@a)) ρ)]
    [(cons `(match-clause ,m ,f ,b ,a ,C) e)
     (unit (cons C `(match ,@(cons f (append b (list `(,m ,e)) a)))) ρ)]
    [(cons `(bod ,y ,C) e)
     (unit (cons C `(λ ,y ,e))
           (match ρ
             [(flatenv ρ) (flatenv ρ)]; Regular m-cfa environments don't change (all bindings are rebound in the innermost environment)
             [(expenv (cons _ ρ)) (expenv ρ)]
             [(menv (cons _ ρ)) (menv ρ)]
             [(envenv (cons _ ρ)) (envenv ρ)]
             [(lenv (cons _ ρ)) (envenv ρ)]
             ))]
    [(cons `(let-bod ,let-kind ,binds ,C) e₁)
     (unit (cons C `(,let-kind ,binds ,e₁)) ρ)]
    [(cons `(bin ,let-kind ,x ,e₁ ,before ,after ,C) e₀)
     (unit (cons C `(,let-kind ,(append before (list `(,x ,e₀)) after) ,e₁)) ρ)]
    [(cons `(lettypes-bod ,binds ,C) e₁)
     (unit (cons C `(lettypes ,binds ,e₁)) ρ)]
    [(cons `(top) _)
     (error 'out "top")]))

(define ((bin-e i) Ce ρ)
  (>>=list ((bin i) Ce ρ)))

(define ((bin i) Ce ρ)
  (match Ce
    [(cons C `(,l ,binds ,e₁))
     (check-let l)
     (define before (take binds i))
     (define eqafter (drop binds i))
     (define after (cdr eqafter))
     (define bind (car eqafter))
     (unit (cons `(bin ,l ,(car bind) ,e₁ ,before ,after ,C) (cadr bind)) ρ)]))

(define (bod-e Ce ρ)
  (>>=list (bod Ce ρ)))

(define (bod Ce ρ)
  (match Ce
    [(cons C `(λ ,x ,e))
     (match ρ
       [(flatenv _) (error 'not-supported "Bod is not supported for regular mcfa (use bod-enter)")]
       [(expenv _) (error 'not-supported "Bod is not supported for regular mcfa (use bod-enter)")]
       [(menv cc) (unit (cons `(bod ,x ,C) e) (menv (cons (take-cc `(□? ,x, C)) cc)))]
       [(envenv cc) (unit (cons `(bod ,x ,C) e) (envenv (cons (take-cc `(□? ,x, C)) cc)))]
       [(lenv cc) (unit (cons `(bod ,x ,C) e) (lenv (cons (take-cc `(□? ,x, C)) cc)))]
       )
     ]
    [(cons C `(lettypes ,binds ,e₁))
     (unit (cons `(lettypes-bod ,binds ,C) e₁) ρ)]
    [(cons C `(,l ,binds ,e₁))
     (check-let l)
     (unit (cons `(let-bod ,l ,binds ,C) e₁) ρ)]
    ))

; For calls this is Lamda Caller CallEnv LambdaEnv
(define (bod-enter Ce call ρ ρ′)
  (match Ce
    [(cons C `(λ ,x ,e))
     ;  (pretty-print `(bod-enter ,ρ′ ,call))
     (define lambod (cons `(bod ,x ,C) e))
     (match ρ′
       [(flatenv _) (unit lambod (flatenv (enter-cc call ρ)))]
       [(expenv _) (unit lambod (expenv (cons (enter-cc call ρ) (expenv-m ρ′))))]
       [(menv _)  (unit lambod (menv (cons (enter-cc call ρ) (menv-m ρ′))))]
       [(envenv _)  (unit lambod (envenv (cons (enter-cc call ρ) (envenv-m ρ′))))]
       [(lenv _)  (unit lambod (lenv (cons (enter-cc call ρ) (lenv-m ρ′))))]
       )]
    [(cons C `(lettypes ,binds ,e₁))
     (unit (cons `(lettypes-bod ,binds ,C) e₁) ρ)]
    [(cons C `(,l ,binds ,e₁))
     (check-let l)
     ; Environments do not change for let bindings (as long as names do not shadow - which for m-CFA we handle by alphatizing).
     (unit (cons `(let-bod ,l ,binds ,C) e₁) ρ)]))

(define (rat-e Ce ρ)
  (>>=list (rat Ce ρ)))

(define (rat Ce ρ)
  (match Ce
    [(cons C `(app ,f ,@es))
     (unit (cons `(rat ,es ,C) f) ρ)]
    ))

(define (focus-match-e Ce ρ)
  (>>=list (focus-match Ce ρ)))

(define (focus-match Ce ρ)
  (match Ce
    [(cons C `(match ,m ,@ms))
     (unit (cons `(match-e ,ms ,C) m) ρ)]
    ))

(define ((match-clause-e i) Ce ρ)
  (>>=list ((match-clause i) Ce ρ)))

(define ((match-clause i) Ce ρ)
  (match Ce
    [(cons C `(match ,m ,@matches))
     (define prev-ms (take matches i))
     (define after-ms (drop matches i))
     (define mat (car after-ms))
     ;  (pretty-print after-ms)
     (unit (cons `(match-clause ,(car mat) ,m ,prev-ms ,(cdr after-ms) ,C) (cadr mat)) ρ)]
    ))

(define ((ran-e i) Ce ρ)
  (>>=list ((ran i) Ce ρ)))

(define ((ran i) Ce ρ)
  ; (pretty-print `(ran ,i))
  (match Ce
    [(cons C `(app ,f ,@args))
     (define prev-args (take args i))
     (define after-args (drop args i))
     ;  (pretty-print after-args)
     (unit (cons `(ran ,f ,prev-args ,(cdr after-args) ,C) (car after-args)) ρ)]))

(module+ main
  (require rackunit)
  (check-equal? (⊑-cc (list) (list)) #t)
  (define query-1 `(,(cons `(top) `(app (λ (x y) (app x y)) (λ (z) z) 2)) ,(envenv '())))
  (define test-query-1 (apply rat-e query-1))
  (define (run-unit2 q) (q (lambda (Ce p) `(,Ce ,p))))

  (analysis-kind 'hybrid)
  (current-m 0)
  (check-equal? (run-unit2 (bod-enter (car test-query-1) `(app x y) (cadr test-query-1) (envenv '())))
                `(((bod (x y) (rat ((λ (z) z) 2) (top))) app x y) ,(envenv '(())))
                )

  (current-m 1)
  (check-equal? (run-unit2 (bod-enter (car test-query-1) `(app x y) (cadr test-query-1) (envenv '(lamenv))))
                `(((bod (x y) (rat ((λ (z) z) 2) (top))) app x y) ,(envenv `((cenv (app x y) ,(envenv '())) lamenv)))
                )
  )