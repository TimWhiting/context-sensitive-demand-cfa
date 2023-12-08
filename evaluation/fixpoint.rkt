#lang racket/base
(require racket/match
         racket/set)
(provide (all-defined-out))

(define ((unit . xs) κ) (κ xs))
(define ((>>= c f) κ) (c (λ (xs) ((apply f xs) κ))))
(define (>> m . ms) (foldl (λ (m M) (>>= M (λ _ m))) m ms))

(define (id s) s)
(define ((∘ f g) s) (f (g s)))

(define ((⊔ . cs) κ)
  (foldl (λ (c s→s) (∘ (c κ) s→s)) id cs))
(define ⊥ (⊔))

(define (((push nm) xs) s) 
  (match-let ([(cons xss κs) (hash-ref s nm (cons (set) (list)))])
    (if (set-member? xss xs)
      s
      (for/fold ([s (hash-set s nm (cons (set-add xss xs) κs))])
                ([κ (in-list κs)])
        ((κ xs) s)))))

(define ((memo tag f) . xs)
  (let ([nm (cons tag xs)])
    (λ (κ)
      (λ (s)
        (cond
          [(hash-ref s nm #f)
           => (match-lambda
                [(cons xss κs)
                 (for/fold ([s (hash-set s nm (cons xss (cons κ κs)))])
                           ([xs (in-set xss)])
                   ((κ xs) s))])]
          [else
           (((apply f xs)
             (push nm))
            (hash-set s nm (cons (set) (list κ))))])))))
