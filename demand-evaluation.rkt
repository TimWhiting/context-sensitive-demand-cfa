#lang racket/base
(require racket/match
         "base.rkt"
         "syntax.rkt")

(define eval-name (ensuremath "\\Downarrow^{\\mathit{de}}_{\\mathit{eval}}"))
(define call-name (ensuremath "\\Downarrow^{\\mathit{de}}_{\\mathit{call}}"))
(define expr-name (ensuremath "\\Rightarrow^{\\mathit{de}}_{\\mathit{expr}}"))
(define find-name (ensuremath "\\Rightarrow^{\\mathit{de}}_{\\mathit{find}}"))
(define bind-name (ensuremath "\\mathsf{bind}"))


(define (eval Ce ρ₀ σ₀ Cλx.e ρ₁ σ₁ ) (ensuremath Ce "," ρ₀ "," σ₀ " " eval-name Cλx.e "," ρ₁ "," σ₁))
(define (call Ce ρ₀ σ₀ Cfe ρ₁ σ₁) (ensuremath Ce "," ρ₀ "," σ₀ " " call-name " " Cfe "," ρ₁ "," σ₁))
(define (expr Ce ρ₀ σ₀ Cfe ρ₁ σ₁) (ensuremath Ce "," ρ₀ "," σ₀ " " expr-name " " Cfe "," ρ₁ "," σ₁))
(define (find x Ce ρ₀ σ₀ Cx ρ₁ σ₁) (ensuremath x "," Ce "," ρ₀ "," σ₀ " " find-name Cx "," ρ₁ "," σ₁))
(define (bind x Cx ρ) (ensuremath bind-name "(" x "," Cx "," ρ ")"))

(define fresh-name (ensuremath "\\mathsf{fresh}"))
(define (fresh σ) (ensuremath fresh-name "(" σ ")"))

(define (ρ [ℓ #f]) (meta "\\rho" ℓ))
(define (σ [ℓ #f]) (meta "\\sigma" ℓ))
(define (cc [ℓ #f]) (meta "\\mathit{cc}" ℓ))

(define (σ-extend σ n cc) (ensuremath σ "[" n "\\mapsto " cc "]"))
(define (σ-lookup σ n) (ensuremath σ "(" n ")"))


(define ≡σ-name (ensuremath "\\equiv_{\\sigma}"))
(define (≡σ σ ρ₀ ρ₁) (ensuremath ρ₀ "\\equiv_{" σ "}" ρ₁))

#|
(define time-succ-name (ensuremath "\\mathsf{succ}_{m}"))
(define (time-succ Ce ρ) (ensuremath time-succ-name "(" Ce "," ρ ")"))
(define (instantiate ρ₀ ρ₁ ctx₀ ctx₁) (list ρ₀ "[" (:: ctx₁ ρ₁) "/" (:: ctx₀ ρ₁) "]"))
(define (instantiation ρ₀ ρ₁) (ensuremath ρ₁ " / " ρ₀))
|#

(require "parse.rkt")

(define (spread f . xss)
  (apply f (apply append xss)))

(define parse-=
  (match-lambda
    ["(Cx[e-x],ρ-x)" (pair (cursor (e "_x") (∘e "_x")) (ρ "_x"))]
    ["bind(x,C[x],ρ)" (bind (var 'x) (cursor (ref (var 'x)) (∘e)) (ρ))]
    ["(n,σ₁)" (pair "n" (σ 1))]
    ["(n,σ₂)" (pair "n" (σ 2))]
    ["fresh(σ₀)" (fresh (σ 0))]
    ["fresh(σ₁)" (fresh (σ 1))]
    ["σ₀(n)" (σ-lookup (σ 0) "n")]
    ["⊥" (ensuremath "\\bot")]
    ["σ₂" (σ 2)]
    ["σ₁[n ↦ (C'[(e₀ e₁)],ρ')]" (σ-extend (σ 1) "n" (pair (cursor (app (e 0) (e 1)) (∘e)) (ρ "'")))]
    ["(C[(e₀ e₁)],ρ')" (pair (cursor (app (e 0) (e 1)) (∘e)) (ρ "'"))]
    ["σ₁[ρ''/ρ']" (ensuremath (σ 1) "[" (ρ "''") "/" (ρ "'") "]")]
    #;
    ["(C'[e],ρ')" (pair (cursor (e) (∘e "'")) (ρ "'"))]
    #;
    ["ctx₀" (cc 0)]
    #;
    ["ctx₁" (cc 1)]
    #;
    ["time-succ(C'[(e₀ e₁)],ρ')" (time-succ (parse-cursor "C'[(e₀ e₁)]") (ρ "'"))]
    #;
    ["q''" "q''"]
    #;
    ["subst(q',ρ,ρ')" "\\mathsf{subst}(q',\\rho,\\rho')"]
    #;
    ["ρ₀" (ρ 0)]
    #;
    ["ρ₁" (ρ 1)]
    #;
    ["ρ₀'" (ρ "_{0}'")]
    #;
    ["ρ₁'" (ρ "_{1}'")]))

(define parse-n
  (match-lambda
    ["n" "n"]
    ["n-1" "n_{1}"]
    ["n-k" "n_{k}"]))

(define parse-ρ
  (match-lambda
    ["ρ" (ρ)]
    ["ρ₀" (ρ 0)]
    ["ρ₁" (ρ 1)]
    ["ρ'" (ρ "'")]
    ["ρ''" (ρ "''")]
    ["ρ-x" (ρ "_x")]
    ["ρ-v" (ρ "_v")]
    ["n::ρ" (:: "n" (ρ))]
    ["n::ρ'" (:: "n" (ρ "'"))]
    ["ρ-is" (ensuremath "\\langle " "n_{1}" "," "\\dots " "," "n_{k}" "\\rangle")]
    ["()" (ensuremath "\\langle \\rangle")])
  #;
  (match-lambda
    ["ρ₀" (ρ 0)]
    ["ρ₁" (ρ 1)]
    
    ["ρ₀'" (ρ "_{0}'")]
    ["ρ₁'" (ρ "_{0}'")]
    
    ["ctx::ρ" (:: (cc) (ρ))]
    ["ctx₀::ρ" (:: (cc 0) (ρ))]
    ["ctx₀::ρ'" (:: (cc 0) (ρ "'"))]
    ["ctx₁::ρ" (:: (cc 1) (ρ))]
    ["ctx₁::ρ'" (:: (cc 1) (ρ "'"))]
    ["ρ[ctx₁::ρ'/ctx₀::ρ']" (instantiate (ρ) (ρ "'") (cc 0) (cc 1))]
    ["ρ[ρ₁/ρ₀]" (ensuremath (ρ) "[" (ρ 1) "/" (ρ 0) "]")]
    ["?C[λy.[e]]::ρ" (:: (list "?" "_{" (var 'y) "}") (ρ))]
    ["?C'[λx.[e]]::ρ'" (:: (list "?" "_{" (var 'x) "}") (ρ "'"))]
    ["time-succ(C[(e₀ e₁)],ρ)::ρ'" (:: (time-succ (parse-cursor "C[(e₀ e₁)]") (ρ)) (ρ "'"))]))

(define parse-σ
  (match-lambda
    ["σ" (σ)]
    ["σ₀" (σ 0)]
    ["σ₁" (σ 1)]
    ["σ₂" (σ 2)]
    ["σ₃" (σ 3)]
    ["σ₄" (σ 4)]
    ["σ₂[n ↦ (C[(e₀ e₁)],ρ)]" (σ-extend (σ 2) "n" (pair (cursor (app (e 0) (e 1)) (∘e)) (ρ)))] ))

(define parse-config
  (match-lambda
    [(regexp #px"^(.*) (\\S*ρ\\S*) (.*)$" (list _ Ce ρ σ))
     (list (parse-cursor Ce) (parse-ρ ρ) (parse-σ σ))]
    #;
    ["C'[λx.[e]] time-succ(C[(e₀ e₁)],ρ)::ρ'"
     (list (parse-cursor "C'[λx.[e]]") (:: (time-succ (parse-cursor "C[(e₀ e₁)]") (ρ)) (ρ "'")))]
    #;
    ["C[λx.[e]] time-succ(C[(e₀ e₁)],ρ)::ρ'"
     (list (parse-cursor "C[λx.[e]]") (:: (time-succ (parse-cursor "C[(e₀ e₁)]") (ρ)) (ρ "'")))]
    #;
    [(regexp #px"^(.*) (\\S+)$" (list _ Ce ρ))
     (list (parse-cursor Ce) (parse-ρ ρ))]))

(define parse-judgement
  (match-lambda
    [(⇓ cfg₀ cfg₁)
     (spread eval (parse-config cfg₀) (parse-config cfg₁))]
    [(⇒ cfg₀ cfg₁)
     (spread expr (parse-config cfg₀) (parse-config cfg₁))]
    [(⇐ cfg₀ cfg₁)
     (spread call (parse-config cfg₀) (parse-config cfg₁))]
    [(F x×cfg₀ cfg₁)
     (match x×cfg₀
       [(regexp #rx"^x (.*)$" (list _ cfg₀))
        (spread find (list (var 'x)) (parse-config cfg₀) (parse-config cfg₁))])]
    #;
    [(R ρ₀ ρ₁)
     (instantiation (parse-ρ ρ₀) (parse-ρ ρ₁))]
    [(:= lhs rhs)
     (ensuremath (parse-= lhs) " := " (parse-= rhs))]
    #;
    [(⊏ lhs rhs)
     (ensuremath (parse-= lhs) " \\sqsubset " (parse-= rhs))]
    #;
    [(⊑ lhs rhs)
     (ensuremath (parse-= lhs) " \\sqsubseteq " (parse-= rhs))]
    [(=/p lhs rhs)
     (= (parse-= lhs) (parse-= rhs))]
    ["x ≠ y"
     (≠ (var 'x) (var 'y))]
    ["ρ' ≡σ₁ ρ''"
     (≡σ (σ 1) (ρ "'") (ρ "''"))]))

(provide (all-defined-out))
