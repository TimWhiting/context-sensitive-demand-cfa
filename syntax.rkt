#lang racket/base
(require racket/match
         "base.rkt")

(define (var x [ℓ #f]) (meta x ℓ))

(define (e [ℓ #f]) (meta "e" ℓ))
(define (c [ℓ #f]) (meta "c" ℓ))
(define (i [ℓ #f]) (meta "i" ℓ))
(define (p [ℓ #f]) (meta "p" ℓ))
(define (literal) (meta "literal" #f))

(define (ref x) x)
(define (lam x e) (ensuremath (list "\\lambda " x "." e)))
(define (app e₀ e₁) (ensuremath (list "(" e₀ "\\," e₁ ")")))
(define (multi e) (ensuremath (list e (meta "\\dots" #f))))
(define (con-pattern) (multi (p)))

(define ((∘e [ℓ #f]) e)
  (list (meta "C" ℓ)
        (match e
          [#f (list)]
          [(list "[" e "]") (list "[" "\\highlight{" e "}]")]
          [e                (list "[" "\\highlight{" e "}]")])))

(define ((rat e₁ ∘e) e₀) (∘e (app e₀ e₁)))
(define ((ran e₀ ∘e) e₁) (∘e (app e₀ e₁)))
(define ((bod x ∘e) e) (∘e (lam x e)))
(define ((top) e) e)


(define (cursor e ∘e) (∘e (list "[" e "]")))

(provide (all-defined-out))
