#lang racket/base
(require (rename-in "table-monad/main.rkt"))
(require "config.rkt" "envs.rkt" "syntax.rkt")
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

(define (is-known-primitive x)
  (member x '(= - + * / modulo ceiling random log gcd quotient odd? even? < <= > not or and equal? eq? symbol? char? error newline display void #f #t))
  )

(define (check-known-primitive? x)
  (if (is-known-primitive x)
      '()
      (error 'unknown-primitive (format "unknown primitive ~a" x))
      ))

; Checks to tsee if a query is syntatically obvious (able to be resolved via simple compiler heuristics)
(define (is-instant-query q)
  (match-let ([(list (cons C e) p) q])
    (or (is-instant-query-kind (expr-kind e))
        (and (symbol? e)
             ; Check if this is a reference to a binding that itself is an instant query kind
             (match-let ([(list Ce p i) ((bind-e e) (cons C e) p)])
               (if (equal? i -1)
                   #t ; Constructors are instant
                   (match Ce ; Other bindings that are instant queries
                     [(cons `(bin ,_ ,_ ,_ ,_ ,_ ,_) _)
                      (is-instant-query-kind (expr-kind (cdr (car (go-bin i (out-e Ce p))))))]
                     [(cons `(let-bod ,_ ,_ ,_) _)
                      (is-instant-query-kind (expr-kind (cdr (car (go-bin i (out-e Ce p))))))]
                     [_ #f]; All other are non-trivial as far as being syntactically obvious
                     );
                   ))
             )
        )
    )
  )

(define ((bind-e x) Ce p)
  (((bind x) Ce p) (λ (Ce p i) (list Ce p i)))
  )

(define ((bind x) Ce ρ)
  (define (search-out) (>>= (out Ce ρ) (bind x)))
  ; (pretty-print `(bind ,x ,Ce ,ρ))
  (match Ce
    [(cons `(top) _)
     (check-known-primitive? x)
     (unit x ρ -1)] ; Primitives
    [(cons `(lettypes-bod ,binds ,C) e₁)
     (if (member x (map car binds))
         (unit x ρ -1)
         (search-out)
         )
     ]
    [(cons `(bin ,let-kind ,y ,_ ,before ,after ,_) _)
     (define defs
       (match let-kind
         ; Only the prior definitions are bound for let*
         ['let* (map car before)]
         ; All bindings are in effect, they are just evaluated sequentially
         ['letrec* (append (map car before) (list y) (map car after))]
         ; All definitions are in scope for letrec
         ['letrec (append (map car before) (list y) (map car after))]
         ; None of the definitions are in scope for regular let
         [_ (list)]
         ))
     (if (ormap (λ (y) (equal? x y)) defs)
         (unit Ce ρ (index-of defs x)) ; Index works for all types of let
         (search-out))]
    [(cons `(bod ,ys ,_) _)
     ;  (pretty-print `(bodbind ,ys ,x ,(ors (map (λ (y) (equal? x y)) ys)) ,(index-of ys x)))
     (if (ormap (λ (y) (equal? x y)) ys)
         (unit Ce ρ (index-of ys x))
         (search-out))]
    [(cons `(let-bod ,_ ,binds ,_) _)
     (define defs-len (length binds))
     ; reverse the bindings so that in let* we get the most recent definition
     ; in case of shadowing
     (define defs-rev (reverse (map car binds)))
     ;  (pretty-print `(bin ,defs))
     (if (ormap (λ (y) (equal? x y)) defs-rev)
         ; Adjust the index because the defs are in reversed order
         (unit Ce ρ (- defs-len 1 (index-of defs-rev x)))
         (search-out))]
    [(cons `(match-clause ,m ,scruitinee ,before ,after ,_) e₀)
     (define match-binding (find-match-bind x m))
     (if match-binding (unit Ce ρ match-binding) (search-out))]
    ; All other forms do not introduce bindings
    [(cons _ _) (search-out)]
    ))

(define (out-e Ce ρ)
  (>>=list (out Ce ρ))
  )

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
       [(menv ccs) (unit (cons `(bod ,x ,C) e) (menv (cons (callc (take-cc `(□? ,x, C))) ccs)))]
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
       [(expenv _) (unit lambod (expenv (cons (callc (enter-cc call ρ)) (expenv-m ρ′))))]
       [(menv _)  (unit lambod (menv (cons (callc (enter-cc call ρ)) (menv-m ρ′))))]
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
     ;  (pretty-print prev-args)
     ;  (pretty-print (cons `(ran ,f ,prev-args ,(cdr after-args) ,C) (car after-args)))
     (unit (cons `(ran ,f ,prev-args ,(cdr after-args) ,C) (car after-args)) ρ)]))

(define (go-bod q) (apply bod-e q))
(define ((go-ran-i i) q) (apply (ran-e i) q))
(define ((go-bin-i i) q) (apply (bin-e i) q))
(define (go-ran i q) (apply (ran-e i) q))
(define (go-bin i q) (apply (bin-e i) q))
(define (go-match-clause i q) (apply (match-clause-e i) q))
(define (go-match q) (apply focus-match-e q))
(define (go-out q) (apply out-e q))

(define (repeat n f a)
  (if (= n 0) a
      (repeat (- n 1) f (f a))
      ))

(define (alternate n f g a)
  (if (= n 0) a
      (alternate (- n 1) g f (f a))
      ))


(module+ main
  (require rackunit)
  (define example (list `((top) λ (x y) (let ((x 0)) (app 0 1))) (menv '())))
  (check-equal? (cadr (go-bod (go-bod example))) (menv (list (callc '(□? (x y) (top))))))

  (current-m 2)
  (define call-example (>>=list (bod-enter (car example) ; Lambda
                                           'ce-call ; Caller expression
                                           (menv (list (callc '(call-env1 call-env2)))) ; Caller environment
                                           (menv (list (callc 'lam-env)))) ; Lambda environment
                                ))
  (check-equal? call-example
                (list
                 '((bod (x y) (top)) let ((x 0)) (app 0 1))
                 (menv (list (callc '(ce-call call-env1)) (callc 'lam-env)))))

  (check-equal? (go-out call-example)
                (list (car example) (menv (list (callc 'lam-env))))
                )

  )