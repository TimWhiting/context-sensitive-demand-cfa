#lang racket
(provide (except-out (all-from-out racket)
                     #%module-begin
                     #%top)
         (rename-out [module-begin #%module-begin])
         (rename-out [unbound-as-quoted #%top])
         )
(define-syntax-rule (whereami)
  (variable-reference->module-source (#%variable-reference)))
(define-syntax-rule (module-begin e)
  (#%module-begin
   (define example-expr (translate-top `(e)))
   (define example-name (string->symbol (path->string (path-replace-extension (file-name-from-path (whereami)) ""))))
   (provide (all-defined-out))
   (pretty-print example-expr)
   (pretty-print example-name)
   ))
(define-syntax-rule (unbound-as-quoted . id)
  #`id)

(define (translate-top s)
  (match (translate s)
    [`(app ,e) e]
    )
  )

(define (translate-def d)
  (match d
    [`(,x ,e) `(,x ,(translate e))]
    )
  )

(define (translate s)
  (match s
    [(? number? x) x]
    [(? symbol? x) x]
    [`(λ (,@args) ,e) `(λ (,@args) ,(translate e))]
    [`(let ,defs ,e) `(let ,(map translate-def defs) ,(translate e))]
    [`(,@es) `(app ,@(map translate es))]
    )
  )