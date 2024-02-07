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
(define (matchexpr scrutinee clausepat clausee) (ensuremath (list "(\\text{match}\\," scrutinee "\\,...\\," "(" clausepat "\\," clausee ")\\," "\\,...)")))
(define (letr x e₀ e₁) (ensuremath (list "(\\text{letrec}\\, (" x "\\," e₀ ")\\," e₁ ")")))
(define (letb x e₀ e₁) (ensuremath (list "(\\text{let}\\, (" x "\\," e₀ ")\\," e₁ ")")))
(define (letboth x e₀ e₁) (ensuremath (list "(\\text{let/letrec}\\, (" x "\\," e₀ ")\\," e₁ ")")))
(define (multi e) (ensuremath (list e (meta "\\dots" #f))))
(define (con-pattern) (multi (p)))

(define ((∘e [ℓ #f]) e)
  (list (meta "C" ℓ)
        (match e
          [#f (list)]
          [(list "[" e "]") (list "[" e "]")]
          [e                (list "[" e "]")])))

(define ((letrecbin x e₁ ∘e) e₀) (∘e (letr x e₀ e₁)))
(define ((letrecbod x e₀ ∘e) e₁) (∘e (letr x e₀ e₁)))
(define ((letbin x e₁ ∘e) e₀) (∘e (letb x e₀ e₁)))
(define ((letbod x e₀ ∘e) e₁) (∘e (letb x e₀ e₁)))
(define ((letbothbin x e₁ ∘e) e₀) (∘e (letboth x e₀ e₁)))
(define ((letbothbod x e₀ ∘e) e₁) (∘e (letboth x e₀ e₁)))
(define ((matchscrutinee epat e₀ ∘e) e) (∘e (matchexpr e epat e₀)))
(define ((matchclause e₀ epat ∘e) e) (∘e (matchexpr e₀ epat e)))
(define ((rat e₁ ∘e) e₀) (∘e (app e₀ e₁)))
(define ((ran e₀ ∘e) e₁) (∘e (app e₀ e₁)))
(define ((bod x ∘e) e) (∘e (lam x e)))
(define ((top) e) e)


(define (cursor e ∘e) (∘e (list "[" e "]")))

(provide (all-defined-out))
