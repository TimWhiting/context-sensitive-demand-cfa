#lang racket/base
(require racket/list
         racket/match)

(define etal "~\\textit{et al.}")

(define (ensuremath . xs) (list "\\ensuremath{" xs "}"))

(define (latex-return xs) (list xs "\\\\"))
(define (carriage-return xs) (list xs "\n"))

(define (align xss)
  (list (carriage-return "\\begin{align*}")
        (match-let ([(list yss ... ys) xss])
          (append (map (λ (ys) (carriage-return (latex-return (add-between ys "&")))) yss)
                  (carriage-return (add-between ys "&"))))
        (carriage-return "\\end{align*}")))

(define (table xss #:alignment [alignment (list->string (apply map (λ _ #\c)  xss))] #:horizontal-lines? [hlines? #f])
  (list (carriage-return (list "\\begin{tabular}" "{" alignment "}"))
        (let ([rows (match-let ([(list yss ... ys) xss])
                      (append (map (λ (ys) (if (eq? ys 'hline) (carriage-return "\\hline") (carriage-return (latex-return (add-between ys "&"))))) yss)
                              (list (if (eq? ys 'hline) (carriage-return "\\hline") (carriage-return (add-between ys "&"))))))])
          (if hlines? (add-between rows (carriage-return "\\hline")) rows))
        (carriage-return "\\end{tabular}")))

(define (pair x y) (ensuremath "(" x "," y ")"))
(define (triple x y z) (ensuremath "(" x "," y "," z ")"))

(define (meta x ℓ)
  (ensuremath
   (cond
     [(not ℓ) x]
     [(exact-nonnegative-integer? ℓ) (list x "_" (number->string ℓ))]
     [(string? ℓ) (list x ℓ)]
     [(symbol? ℓ) (list x "_" (symbol->string ℓ))]
     [(equal? ℓ `(0..n)) (list x "_{0..n}" )]
     [else
      (match* (x ℓ))])))


#;(define (stx-ctx e) (ensuremath "\\mathbb{K}" "(" e ")"))
(define □ (ensuremath "\\square "))

(define (⊆ X Y) (ensuremath X "\\subseteq " Y))
(define (∪ X Y) (ensuremath X "\\cup " Y))
(define (= X Y) (ensuremath X "=" Y))
(define (≠ X Y) (ensuremath X "\\ne " Y))

(define (∀ a b) (ensuremath "\\forall " a "." b))
(define (∈ x X) (ensuremath x "\\in " X))
(define (∧ A B) (ensuremath A "\\wedge " B))
(define (singleton x) (ensuremath "\\{" x "\\}"))
(define ∅ (ensuremath "\\emptyset"))
(define (:: n ρ) (ensuremath (list n "::" ρ)))

(provide (all-defined-out))
