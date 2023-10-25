#lang racket/base
(require racket/match
         "base.rkt"
         "syntax.rkt")

#|
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


#|
(define time-succ-name (ensuremath "\\mathsf{succ}_{m}"))
(define (time-succ Ce ρ) (ensuremath time-succ-name "(" Ce "," ρ ")"))
(define (instantiate ρ₀ ρ₁ ctx₀ ctx₁) (list ρ₀ "[" (:: ctx₁ ρ₁) "/" (:: ctx₀ ρ₁) "]"))
(define (instantiation ρ₀ ρ₁) (ensuremath ρ₁ " / " ρ₀))
|#
|#

(define grow "\\hspace{2pt}")
(define shrink "\\hspace{-2pt}")

(define (envirostoreρρ ρ-∞ ρ-de σ-de) (ensuremath ρ-∞ grow "{}_{" (mcfa-ρ) "}" shrink "\\Leftrightarrow" "_{" (demand-ρ) "}" ρ-de "," σ-de))

(define (envirostoreccn cc-∞ n-de σ-de) (ensuremath cc-∞ grow "{}_{" (mcfa-cc) "}" shrink "\\Leftrightarrow" "_{" "n" "}" n-de "," σ-de))

(define (envirostoreccρ cc-∞ ρ-de σ-de) (ensuremath cc-∞ grow "{}_{" (mcfa-cc) "}" shrink "\\Leftrightarrow" "_{" (demand-ρ) "}" ρ-de "," σ-de))

(define (ρ [ℓ #f]) (meta "\\rho" ℓ))
(define (σ [ℓ #f]) (meta "\\sigma" ℓ))
(define (cc [ℓ #f]) (meta "\\mathit{cc}" ℓ))

(require "parse.rkt"
         (prefix-in mcfa- "demand-mcfa.rkt")
         (prefix-in demand- "demand-evaluation.rkt"))

(define (spread f . xss)
  (apply f (apply append xss)))



(define parse-ρ×σ
  (match-lambda
    [(regexp #px"^(\\S*ρ\\S*) (.*)$" (list _ ρ σ))
     (list (demand-parse-ρ ρ) (demand-parse-σ σ))]
    [(regexp #px"^\\(\\) (.*)$" (list _ σ))
     (list (demand-parse-ρ "()") (demand-parse-σ σ))]))

(define parse-n×σ
  (match-lambda
    [(regexp #px"^(\\S*n\\S*) (.*)$" (list _ n σ))
     (list (demand-parse-n n) (demand-parse-σ σ))]))



#;
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
    [(⇓ ρ ρ×σ)
     (spread envirostoreρρ (list (mcfa-parse-ρ ρ)) (parse-ρ×σ ρ×σ))]
    #;
    [(⇒ cfg₀ cfg₁)
     (spread expr (parse-config cfg₀) (parse-config cfg₁))]
    #;
    [(⇐ cfg₀ cfg₁)
     (spread call (parse-config cfg₀) (parse-config cfg₁))]
    [(F cc n×σ)
     (spread envirostoreccn (list (mcfa-parse-cc cc)) (parse-n×σ n×σ))]
    [(R cc ρ×σ)
     (spread envirostoreccρ (list (mcfa-parse-cc cc)) (parse-ρ×σ ρ×σ))]
    #;
    [(:= lhs rhs)
     (ensuremath (parse-= lhs) " := " (parse-= rhs))]
    #;
    [(⊏ lhs rhs)
     (ensuremath (parse-= lhs) " \\sqsubset " (parse-= rhs))]
    #;
    [(⊑ lhs rhs)
     (ensuremath (parse-= lhs) " \\sqsubseteq " (parse-= rhs))]
    #;
    [(=/p lhs rhs)
     (= (parse-= lhs) (parse-= rhs))]
    #;
    ["x ≠ y"
     (≠ (var 'x) (var 'y))]
    ["σ(n) = ⊥"
     (= (demand-σ-lookup (demand-σ) "n") "\\bot")]
    ["σ(n) = (app,ρ)"
     (= (demand-σ-lookup (demand-σ) "n") (pair (cursor (app (e 0) (e 1)) (∘e)) (demand-ρ)))]))

(provide (all-defined-out))
