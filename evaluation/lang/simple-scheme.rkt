#lang racket
(provide (except-out (all-from-out racket)
                     #%module-begin
                     #%top)
         (rename-out [module-begin #%module-begin])
         (rename-out [unbound-as-quoted #%top])
         )
(define-syntax-rule (whereami)
  (variable-reference->module-source (#%variable-reference)))
(define-syntax-rule (module-begin e ...)
  (#%module-begin
   (define example-expr (translate-top-defs `(e) ...))
   (define example-name (string->symbol (path->string (path-replace-extension (file-name-from-path (whereami)) ""))))
   (provide (all-defined-out))
   ;  (pretty-print example-expr)
   ;  (pretty-print example-name)
   ))
(define-syntax-rule (unbound-as-quoted . id)
  #`id)

(define (is-def d)
  (match d
    [`(define ,id ,expr) #t]
    [_ #f])
  )

(define (to-let-bind d)
  (match d
    [`(define ,id ,expr) `(,id ,expr)]
    [_ d]
    ))

(define (to-begin exprs)
  (match exprs
    ['() '()]
    [(list e) e]
    [(cons e es) `(let ((_ ,e)) ,(to-begin es))]
    )
  )

(define (translate-top-defs . ss)
  ; (pretty-print `(translate-top-defs ,ss))
  (define tops (map translate-top ss))
  (define exprs (filter (lambda (d) (not (is-def d))) tops))
  (define binds (map to-let-bind (filter is-def tops)))
  ; (pretty-print `(translate-top-defs ,tops))
  (match binds
    [(cons _ _) `(letrec ,binds ,(to-begin exprs))]
    [(list) (to-begin exprs)])
  )

(define (translate-top s)
  (match (translate s)
    [`(app ,e) e]
    [e e]
    )
  )

(define (translate-def d)
  (match d
    [`(,x ,e) `(,x ,(translate-top-defs e))]
    )
  )

(define (translate s)
  ; (pretty-print `(translate ,s))
  (match s
    [#f `(app #f)]
    [#t `(app #t)]
    [(? number? x) x]
    [(? symbol? x) x]
    [(? string? x) x]
    [`(λ (,@args) ,@es) `(λ (,@args) ,(apply translate-top-defs es))]
    [`(lambda (,@args) ,@es) `(λ (,@args) ,(apply translate-top-defs es))]
    [`(letrec ,defs ,@es) `(letrec ,(map translate-def defs) ,(apply translate-top-defs es))]
    [`(let ,defs ,@es) `(let ,(map translate-def defs) ,(apply translate-top-defs es))]
    [`(let* ,defs ,@es) `(let* ,(map translate-def defs) ,(apply translate-top-defs es))]
    [`(if ,c ,t ,f) `(match ,(translate c) [#t ,(translate t)] [#f ,(translate f)])]
    [`(cond ,@mchs) (unwrap-cond mchs)]
    [`(match ,c ,@mchs) `(match ,(translate c) ,@(map unwrap-match mchs))]
    [`(define (,id ,@args) ,@exprs) `(define ,id (λ (,@args) ,(apply translate-top-defs exprs)))]
    [`(define ,id ,expr) `(define ,id ,(translate-top-defs expr))]
    [`(,@es)
     ;  (pretty-print `(translate-app))
     `(app ,@(map translate es))]
    )
  )

(define (unwrap-match mch)
  (match mch
    [`(,c ,@es)
     `(,c ,(apply translate-top-defs es))]))

(define (unwrap-cond mchs)
  (match mchs
    ['() `(app error)]
    [(list `(else ,@es)) (apply translate-top-defs es)]
    [(cons `(,c ,@es) xs)
     `(match ,(translate c)
        [#f ,(unwrap-cond xs)]
        [_ ,(apply translate-top-defs es)]
        )]))