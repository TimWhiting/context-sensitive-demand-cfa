#lang racket/base
(require racket/match
         "base.rkt")

(define (var x [ℓ #f]) (meta x ℓ))

(define (e [ℓ #f]) (meta "e" ℓ))

(define (ref x) x)
(define (lam x e) (ensuremath (list "\\lambda " x "." e)))
(define (app e₀ e₁) (ensuremath (list "(" e₀ "\\," e₁ ")")))

(define ((∘e [ℓ #f]) e)
  (list (meta "C" ℓ)
        (match e
          [#f (list)]
          [(list "[" e "]") (list "[" e "]")]
          [e                (list "[" e "]")])))

(define ((rat e₁ ∘e) e₀) (∘e (app e₀ e₁)))
(define ((ran e₀ ∘e) e₁) (∘e (app e₀ e₁)))
(define ((bod x ∘e) e) (∘e (lam x e)))
(define ((top) e) e)


(define (cursor e ∘e) (∘e (list "[" e "]")))

(provide (all-defined-out))
