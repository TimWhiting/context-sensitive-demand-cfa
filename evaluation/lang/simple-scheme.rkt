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
    [`(define ,id ,expr) #f]
    [_ #t])
  )

(define (to-let-bind d)
  (match d
    [`(define ,id ,expr) `(,id ,expr)]
    [_ d]
    ))

(define (translate-top-defs . ss)
  (define tops (map translate-top ss))
  (define exprs (filter is-def tops))
  (define binds (map to-let-bind (filter (λ (x) (not (is-def x))) tops)))
  (match binds
    [(cons _ _) `(let ,binds ,@exprs)]
    [(list)
     (let loop ([exprs exprs])
       (match exprs
         [(list e) e]
         [(cons e es) `(let ([_ ,e]) ,(loop es))]
         ))
     ])
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
  (match s
    [#f #t]
    [#t #t]
    [(? number? x) x]
    [(? symbol? x) x]
    [`(λ (,@args) ,@es) `(λ (,@args) ,(apply translate-top-defs es))]
    [`(lambda (,@args) ,@es) `(λ (,@args) ,(apply translate-top-defs es))]
    [`(letrec ,defs ,@es) `(let ,(map translate-def defs) ,(apply translate-top-defs es))]
    [`(let ,defs ,@es) `(let ,(map translate-def defs) ,(apply translate-top-defs es))]
    [`(let* ,defs ,@es) `(let ,(map translate-def defs) ,(apply translate-top-defs es))]
    [`(if ,c ,t ,f) `(match ,(translate c) [#t ,(translate t)] [#f ,(translate f)])]
    [`(cond ,@mchs) (unwrap-translate mchs)]
    [`(define (,id ,@args) ,@exprs) `(define ,id (λ (,@args) ,(apply translate-top-defs exprs)))]
    [`(define ,id ,expr) `(define ,id ,(translate-top-defs expr))]
    [`(,@es) `(app ,@(map translate es))]
    )
  )

(define (unwrap-translate mchs)
  (match mchs
    [(list `(else ,e)) (translate e)]
    [(cons `(,c ,e) xs)
     `(match ,(translate c)
        [#t ,(translate e)]
        [#f ,(unwrap-translate xs)])]
    )
  )