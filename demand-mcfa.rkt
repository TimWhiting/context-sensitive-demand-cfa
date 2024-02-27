#lang racket/base
(require racket/match
         "base.rkt"
         "syntax.rkt")

(define eval-name (ensuremath "\\Downarrow^{m}_{\\mathit{eval}}"))
(define call-name (ensuremath "\\Downarrow^{m}_{\\mathit{call}}"))
(define expr-name (ensuremath "\\Rightarrow^{m}_{\\mathit{expr}}"))
(define find-name (ensuremath "\\Rightarrow^{m}_{\\mathit{find}}"))
(define bind-name (ensuremath "\\mathsf{bind}"))
(define reach-name (ensuremath "\\Uparrow^{m}_{\\mathit{reach}}"))

(define eval-name+1 (ensuremath "\\Downarrow^{m+1}_{\\mathit{eval}}"))
(define call-name+1 (ensuremath "\\Downarrow^{m+1}_{\\mathit{call}}"))
(define expr-name+1 (ensuremath "\\Rightarrow^{m+1}_{\\mathit{expr}}"))
(define find-name+1 (ensuremath "\\Rightarrow^{m+1}_{\\mathit{find}}"))

(define reach-name+1 (ensuremath "\\Uparrow^{m+1}_{\\mathit{reach}}"))


(define eval-name∞ (ensuremath "\\Downarrow^{\\infty}_{\\mathit{eval}}"))
(define call-name∞ (ensuremath "\\Downarrow^{\\infty}_{\\mathit{call}}"))
(define expr-name∞ (ensuremath "\\Rightarrow^{\\infty}_{\\mathit{expr}}"))
(define find-name∞ (ensuremath "\\Rightarrow^{\\infty}_{\\mathit{find}}"))

(define reach-name∞ (ensuremath "\\Uparrow^{\\infty}_{\\mathit{reach}}"))

(define (eval Ce ρ₀ Cλx.e ρ₁) (ensuremath Ce "," ρ₀ " " eval-name Cλx.e "," ρ₁))
(define (call Ce ρ₀ Cfe ρ₁) (ensuremath Ce "," ρ₀ " " call-name " " Cfe "," ρ₁))
(define (expr Ce ρ₀ Cfe ρ₁) (ensuremath Ce "," ρ₀ " " expr-name " " Cfe "," ρ₁))
(define (find x Ce ρ₀ Cx ρ₁) (ensuremath x "," Ce "," ρ₀ " " find-name Cx "," ρ₁))
(define (bind x Cx ρ) (ensuremath bind-name "(" x "," Cx "," ρ ")"))
(define (reach q₀ q₁) (ensuremath q₀ reach-name q₁))

(define (eval+1 Ce ρ₀ Cλx.e ρ₁) (ensuremath Ce "," ρ₀ " " eval-name+1 Cλx.e "," ρ₁))
(define (call+1 Ce ρ₀ Cfe ρ₁) (ensuremath Ce "," ρ₀ " " call-name+1 " " Cfe "," ρ₁))
(define (expr+1 Ce ρ₀ Cfe ρ₁) (ensuremath Ce "," ρ₀ " " expr-name+1 " " Cfe "," ρ₁))
(define (find+1 x Ce ρ₀ Cx ρ₁) (ensuremath x "," Ce "," ρ₀ " " find-name+1 Cx "," ρ₁))

(define (eval∞ Ce ρ₀ Cλx.e ρ₁) (ensuremath Ce "," ρ₀ " " eval-name∞ Cλx.e "," ρ₁))
(define (call∞ Ce ρ₀ Cfe ρ₁) (ensuremath Ce "," ρ₀ " " call-name∞ " " Cfe "," ρ₁))
(define (expr∞ Ce ρ₀ Cfe ρ₁) (ensuremath Ce "," ρ₀ " " expr-name∞ " " Cfe "," ρ₁))
(define (find∞ x Ce ρ₀ Cx ρ₁) (ensuremath x "," Ce "," ρ₀ " " find-name∞ Cx "," ρ₁))


(define (ρ [ℓ #f]) (meta "\\hat{\\rho}" ℓ))
(define (cc [ℓ #f]) (meta "\\hat{\\mathit{cc}}" ℓ))

(define time-succ-name (ensuremath "\\mathsf{succ}_{m}"))
(define (time-succ Ce ρ) (ensuremath time-succ-name "(" Ce "," ρ ")"))
(define (instantiate ρ₀ ρ₁ ctx₀ ctx₁) (list ρ₀ "[" (:: ctx₁ ρ₁) "/" (:: ctx₀ ρ₁) "]"))
(define (instantiation ρ₀ ρ₁) (ensuremath ρ₁ " / " ρ₀))

(require "parse.rkt")

(define (spread f . xss)
  (apply f (apply append xss)))

(define parse-=
  (match-lambda
    ["(Cx[e-x],ρ-x)" (pair (cursor (e "_x") (∘e "_x")) (ρ "_x"))]
    ["(C'[e],ρ')" (pair (cursor (e) (∘e "'")) (ρ "'"))]
    ["bind(x,C[x],ρ)" (bind (var 'x) (cursor (ref (var 'x)) (∘e)) (ρ))]
    ["ctx₀" (cc 0)]
    ["ctx₁" (cc 1)]
    ["ctx₂" (cc 2)]
    ["time-succ(C'[(e₀ e₁)],ρ')" (time-succ (parse-cursor "C'[(e₀ e₁)]") (ρ "'"))]
    ["q''" "q''"]
    ["subst(q',ρ,ρ')" "\\mathsf{subst}(q',\\rho,\\rho')"]
    ["ρ₀" (ρ 0)]
    ["ρ₁" (ρ 1)]
    ["ρ₀'" (ρ "_{0}'")]
    ["ρ₁'" (ρ "_{1}'")]))

(define parse-cc
  (match-lambda
    ["cc" (cc)]
    ["cc-1" (cc 1)]
    ["cc-k" (cc "_{k}")]
    ["?" (ensuremath "?_{x}")]
    ["app::cc" (:: (cursor (app (e 0) (e 1)) (∘e)) (cc))]
    ["()" (ensuremath "\\langle \\rangle")]))

(define parse-ρ
  (match-lambda
    ["ρ" (ρ)]
    ["ρ₀" (ρ 0)]
    ["ρ₁" (ρ 1)]
    ["ρ'" (ρ "'")]
    ["ρ''" (ρ "''")]
    ["ρ₀'" (ρ "_{0}'")]
    ["ρ₁'" (ρ "_{1}'")]
    ["ρ-x" (ρ "_x")]
    ["ρ-v" (ρ "_v")]
    ["ctx::ρ" (:: (cc) (ρ))]
    ["ctx₀::ρ" (:: (cc 0) (ρ))]
    ["ctx₀::ρ'" (:: (cc 0) (ρ "'"))]
    ["ctx₁::ρ" (:: (cc 1) (ρ))]
    ["ctx₁::ρ'" (:: (cc 1) (ρ "'"))]
    ["ρ[ctx₁::ρ'/ctx₀::ρ']" (instantiate (ρ) (ρ "'") (cc 0) (cc 1))]
    ["ρ[ρ₁/ρ₀]" (ensuremath (ρ) "[" (ρ 1) "/" (ρ 0) "]")]
    ["?C[λy.[e]]::ρ" (:: (list "?" "_{" (var 'y) "}") (ρ))]
    ["?C'[λx.[e]]::ρ'" (:: (list "?" "_{" (var 'x) "}") (ρ "'"))]
    ["time-succ(C[(e₀ e₁)],ρ)::ρ'" (:: (time-succ (parse-cursor "C[(e₀ e₁)]") (ρ)) (ρ "'"))]
    ["ρ-is" (ensuremath "\\langle" (cc 1) "," "\\dots " "," (cc "_{k}") "\\rangle")]))

(define parse-config
  (match-lambda
    ["C'[λx.[e]] time-succ(C[(e₀ e₁)],ρ)::ρ'"
     (list (parse-cursor "C'[λx.[e]]") (:: (time-succ (parse-cursor "C[(e₀ e₁)]") (ρ)) (ρ "'")))]
    ["C[λx.[e]] time-succ(C[(e₀ e₁)],ρ)::ρ'"
     (list (parse-cursor "C[λx.[e]]") (:: (time-succ (parse-cursor "C[(e₀ e₁)]") (ρ)) (ρ "'")))]
    [(regexp #px"^(.*) (\\S+)$" (list _ Ce ρ))
     (list (parse-cursor Ce) (parse-ρ ρ))]))

(define parse-query
  (match-lambda
    ["q" "q"]
    ["q'" "q'"]
    ["q''" "q''"]
    [(regexp "^ev (.*)$" (list _ cfg))
     (match-let ([(list Ce ρ) (parse-config cfg)])
       (ensuremath "\\mathsf{eval}" "(" Ce "," ρ ")"))]
    [(regexp "^ex (.*)$" (list _ cfg))
     (match-let ([(list Ce ρ) (parse-config cfg)])
       (ensuremath "\\mathsf{expr}" "(" Ce "," ρ ")"))]
    [(regexp "^ca (.*)$" (list _ cfg))
     (match-let ([(list Ce ρ) (parse-config cfg)])
       (ensuremath "\\mathsf{call}" "(" Ce "," ρ ")"))]))

(define parse-judgement
  (match-lambda
    [(⇓ cfg₀ cfg₁)
     (spread eval (parse-config cfg₀) (parse-config cfg₁))]
    [(⇒ cfg₀ cfg₁)
     (spread expr (parse-config cfg₀) (parse-config cfg₁))]
    [(⇐ cfg₀ cfg₁)
     (spread call (parse-config cfg₀) (parse-config cfg₁))]
    [(⇓m+1 cfg₀ cfg₁)
     (spread eval+1 (parse-config cfg₀) (parse-config cfg₁))]
    [(⇒m+1 cfg₀ cfg₁)
     (spread expr+1 (parse-config cfg₀) (parse-config cfg₁))]
    [(⇐m+1 cfg₀ cfg₁)
     (spread call+1 (parse-config cfg₀) (parse-config cfg₁))]
    [(⇓∞ cfg₀ cfg₁)
     (spread eval∞ (parse-config cfg₀) (parse-config cfg₁))]
    [(⇒∞ cfg₀ cfg₁)
     (spread expr∞ (parse-config cfg₀) (parse-config cfg₁))]
    [(⇐∞ cfg₀ cfg₁)
     (spread call∞ (parse-config cfg₀) (parse-config cfg₁))]
    [(⇑ q₀ q₁)
     (reach (parse-query q₀) (parse-query q₁))]
    [(F x×cfg₀ cfg₁)
     (match x×cfg₀
       [(regexp #rx"^x (.*)$" (list _ cfg₀))
        (spread find (list (var 'x)) (parse-config cfg₀) (parse-config cfg₁))])]
    [(R ρ₀ ρ₁)
     (instantiation (parse-ρ ρ₀) (parse-ρ ρ₁))]
    [(:= lhs rhs)
     (ensuremath (parse-= lhs) " := " (parse-= rhs))]
    [(⊏ lhs rhs)
     (ensuremath (parse-= lhs) " \\sqsubset " (parse-= rhs))]
    [(⊑ lhs rhs)
     (ensuremath (parse-= lhs) " \\sqsubseteq " (parse-= rhs))]
    [(=/p lhs rhs)
     (= (parse-= lhs) (parse-= rhs))]
    ["x ≠ y"
     (≠ (var 'x) (var 'y))]))

(provide (all-defined-out))
