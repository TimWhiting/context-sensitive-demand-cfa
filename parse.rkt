#lang racket/base
(require racket/match
         racket/string
         racket/list
         "syntax.rkt")


(define (parse-cursors Ce)
  (add-between (map parse-cursor (string-split Ce " / ")) "\\,/\\,")
  )

(define parse-cursor
  (match-lambda
    ["C[e]" (cursor (e) (∘e))]
    ["p-n" (p 'n)]
    ["p-(0..n-1)" (p `(0..n-1))]
    ["C[c]" (cursor (c) (∘e))]
    ["C[i]" (cursor (i) (∘e))]
    ["C[e₁]" (cursor (e 1) (∘e))]
    ["C[λx.e]" (cursor (lam (var 'x) (e)) (∘e))]
    ["C[λy.e]" (cursor (lam (var 'y) (e)) (∘e))]
    [(regexp #rx"^C([^\\[]*)\\[(.*)\\]$" (list _ tick exp))
     (let ([tick (match tick
                   ["x" "_x"]
                   ["v" "_v"]
                   ["s" "_s"]
                   [tick tick])])
       (match exp
         ["e" (cursor (e) (∘e tick))]
         ["c" (cursor (c) (∘e tick))]
         ["c-s" (cursor (c 's) (∘e tick))]
         ["i" (cursor (i) (∘e tick))]
         ["i-s" (cursor (i 's) (∘e tick))]
         ["e-x" (cursor (e "_x") (∘e tick))]
         ["e-s" (cursor (e "_s") (∘e tick))]
         ["(e₀ e₁)" (cursor (app (e 0) (e 1)) (∘e tick))]
         ["(e₂ e₃)" (cursor (app (e 2) (e 3)) (∘e tick))]
         ["(e₀ [e₁])" (cursor (e 1) (ran (e 0) (∘e tick)))]
         ["([e₀] e₁)" (cursor (e 0) (rat (e 1) (∘e tick)))]
         ["λx.e" (cursor (lam (var 'x) (e)) (∘e tick))]
         ["λx.e-s" (cursor (lam (var 'x) (e "_s")) (∘e tick))]
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

(define-match-expander matches
  (syntax-rules ()
    [(_ lhs rhs)
     (regexp #rx"^(.*) matches (.*)$" (list _ lhs rhs))]))

(define-match-expander matches!
  (syntax-rules ()
    [(_ lhs rhs)
     (regexp #rx"^(.*) matches! (.*)$" (list _ lhs rhs))]))

(provide (all-defined-out))
