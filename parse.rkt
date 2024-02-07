#lang racket/base
(require racket/match
         "syntax.rkt")

(define parse-cursor
  (match-lambda
    ["C[e]" (cursor (e) (∘e))]
    ["C[c]" (cursor (c) (∘e))]
    ["C[i]" (cursor (i) (∘e))]
    ["C[e₁]" (cursor (e 1) (∘e))]
    ["C[λx.e]" (cursor (lam (var 'x) (e)) (∘e))]
    ["C[(letrec (x e₀) e₁)]" (cursor (letr (var 'x) (e 0) (e 1)) (∘e))]
    ["C[(let (x e₀) e₁)]" (cursor (letb (var 'x) (e 0) (e 1)) (∘e))]
    ["C[(letboth (x e₀) e₁)]" (cursor (letboth (var 'x) (e 0) (e 1)) (∘e))]
    [(regexp #rx"^C([^\\[]*)\\[(.*)\\]$" (list _ tick exp))
     (let ([tick (match tick
                   ["x" "_x"]
                   ["v" "_v"]
                   [tick tick])])
       (match exp
         ["e" (cursor (e) (∘e tick))]
         ["c" (cursor (c) (∘e tick))]
         ["i" (cursor (i) (∘e tick))]
         ["e-x" (cursor (e "_x") (∘e tick))]
         ["(letboth (x e₀) e₁)" (cursor (letboth (var 'x) (e 0) (e 1)) (∘e tick))]
         ["(letboth (x e₀) [e₁])" (cursor (e 1) (letbothbod (var 'x) (e 0) (∘e tick)))]
         ["(letboth (x [e₀]) e₁)" (cursor (e 0) (letbothbin (var 'x) (e 1) (∘e tick)))]
         ["(letrec (x e₀) e₁)" (cursor (letr (var 'x) (e 0) (e 1)) (∘e tick))]
         ["(letrec (x e₀) [e₁])" (cursor (e 1) (letrecbod (var 'x) (e 0) (∘e tick)))]
         ["(letrec (x [e₀]) e₁)" (cursor (e 0) (letrecbin (var 'x) (e 1) (∘e tick)))]
         ["(let (x e₀) e₁)" (cursor (letb (var 'x) (e 0) (e 1)) (∘e tick))]
         ["(let (x e₀) [e₁])" (cursor (e 1) (letbod (var 'x) (e 0) (∘e tick)))]
         ["(let (x [e₀]) e₁)" (cursor (e 0) (letbin (var 'x) (e 1) (∘e tick)))]
         ["(e₀ e₁)" (cursor (app (e 0) (e 1)) (∘e tick))]
         ["(e₂ e₃)" (cursor (app (e 2) (e 3)) (∘e tick))]
         ["(e₀ [e₁])" (cursor (e 1) (ran (e 0) (∘e tick)))]
         ["([e₀] e₁)" (cursor (e 0) (rat (e 1) (∘e tick)))]
         ["λx.e" (cursor (lam (var 'x) (e)) (∘e tick))]
         ["λx.e-v" (cursor (lam (var 'x) (e "_v")) (∘e tick))]
         ["λy.e-v" (cursor (lam (var 'y) (e "_v")) (∘e tick))]
         ["λx.[e]" (cursor (e) (bod (var 'x) (∘e tick)))]
         ["λy.e" (cursor (e) (bod (var 'y) (∘e tick)))]
         ["λy.[e]" (cursor (e) (bod (var 'y) (∘e tick)))]
         ["x" (cursor (ref (var 'x)) (∘e tick))]))]))

(define-match-expander =/p
  (syntax-rules ()
    [(_ lhs rhs)
     (regexp #rx"^(.*) = (.*)$" (list _ lhs rhs))]))

(define-match-expander ⊏
  (syntax-rules ()
    [(_ lhs rhs)
     (regexp #rx"^(.*) ⊏ (.*)$" (list _ lhs rhs))]))

(define-match-expander ⊑
  (syntax-rules ()
    [(_ lhs rhs)
     (regexp #rx"^(.*) ⊑ (.*)$" (list _ lhs rhs))]))

(define-match-expander :=
  (syntax-rules ()
    [(_ lhs rhs)
     (regexp #rx"^(.*) := (.*)$" (list _ lhs rhs))]))

(define-match-expander ⇓
  (syntax-rules ()
    [(_ lhs rhs)
     (regexp #rx"^(.*) ⇓ (.*)$" (list _ lhs rhs))]))

(define-match-expander ⇐
  (syntax-rules ()
    [(_ lhs rhs)
     (regexp #rx"^(.*) ⇐ (.*)$" (list _ lhs rhs))]))

(define-match-expander ⇒
  (syntax-rules ()
    [(_ lhs rhs)
     (regexp #rx"^(.*) ⇒ (.*)$" (list _ lhs rhs))]))

(define-match-expander ⇓m+1
  (syntax-rules ()
    [(_ lhs rhs)
     (regexp #rx"^(.*) ⇓m\\+1 (.*)$" (list _ lhs rhs))]))

(define-match-expander ⇐m+1
  (syntax-rules ()
    [(_ lhs rhs)
     (regexp #rx"^(.*) ⇐m\\+1 (.*)$" (list _ lhs rhs))]))

(define-match-expander ⇒m+1
  (syntax-rules ()
    [(_ lhs rhs)
     (regexp #rx"^(.*) ⇒m\\+1 (.*)$" (list _ lhs rhs))]))

(define-match-expander ⇓∞
  (syntax-rules ()
    [(_ lhs rhs)
     (regexp #rx"^(.*) ⇓∞ (.*)$" (list _ lhs rhs))]))

(define-match-expander ⇐∞
  (syntax-rules ()
    [(_ lhs rhs)
     (regexp #rx"^(.*) ⇐∞ (.*)$" (list _ lhs rhs))]))

(define-match-expander ⇒∞
  (syntax-rules ()
    [(_ lhs rhs)
     (regexp #rx"^(.*) ⇒∞ (.*)$" (list _ lhs rhs))]))


(define-match-expander ⇑
  (syntax-rules ()
    [(_ lhs rhs)
     (regexp #rx"^(.*) ⇑ (.*)$" (list _ lhs rhs))]))

(define-match-expander F
  (syntax-rules ()
    [(_ lhs rhs)
     (regexp #rx"^(.*) F (.*)$" (list _ lhs rhs))]))

(define-match-expander R
  (syntax-rules ()
    [(_ lhs rhs)
     (regexp #rx"^(.*) R (.*)$" (list _ lhs rhs))]))

(provide (all-defined-out))
