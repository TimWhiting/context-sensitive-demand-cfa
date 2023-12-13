#lang racket/base
(require racket/match
         racket/set
         racket/pretty
         (rename-in "monad.rkt" [run run*]))

(provide powerset-node)

; Fixing Nondeterminism shows how to generalize from
; a powerset to a lattice and the powerset instance
; in the lattice framework. However, it appears that
; the instance still compares sets and, when applying
; a continuation, will apply every element of the set
; to it. The Propagating Differences paper discusses
; how to avoid that if one has a difference operator,
; of which the powerset lattice has an obvious one.
; With that approach, the implementation still incurs
; at least two unnecessary set operations.

(struct node (ks) #:transparent)
(struct powerset-node node (xss) #:transparent)
(struct lattice-node node (n ⊑ ⊔) #:transparent)

(define ((node-depend/powerset nm k) s)
  (match (hash-ref s nm #f)
    [#f
     (hash-set s nm (powerset-node (list k) (set)))]
    [(powerset-node ks xss)
     (for/fold ([s (hash-set s nm (powerset-node (cons k ks) xss))])
               ([xs (in-set xss)])
       ((apply k xs) s))]))

(define ((node-depend/lattice nm k) s)
  (match-let ([(lattice-node ks n ⊑ ⊔) (hash-ref s nm)])
    ((k n) (hash-set s nm (lattice-node (cons k ks) n ⊑ ⊔)))))

(provide node-depend/powerset
         node-depend/lattice)

(define ((node-absorb/powerset nm xs) s)
  (match (hash-ref s nm #f)
    [#f
     (hash-set s nm (powerset-node (list) (set xs)))]
    [(powerset-node ks xss)
     (if (set-member? xss xs)
       s
       (foldl (λ (k s) ((apply k xs) s)) (hash-set s nm (powerset-node ks (set-add xss xs))) ks))]))

(define ((node-absorb/lattice nm n) s)
  (match-let ([(lattice-node ks n₀ ⊑ ⊔) (hash-ref s nm)])
    (if (⊑ n n₀)
      s
      (let ([n (⊔ n₀ n)])
        (foldl (λ (k s) ((k n) s)) (hash-set s nm (lattice-node ks n ⊑ ⊔)) ks)))))

(provide node-absorb/powerset
         node-absorb/lattice)

(define ((id-κ/powerset nm) . xs) (node-absorb/powerset nm xs))
(define ((id-κ/lattice nm) n) (node-absorb/lattice nm n))

(provide id-κ/powerset
         id-κ/lattice)

(define ((memoize/powerset nm k f) s)
  (if (hash-has-key? s nm)
    ((node-depend/powerset nm k) s)
    (((f nm) (id-κ/powerset nm)) (hash-set s nm (powerset-node (list k) (set))))))

(define ((memoize/lattice nm ⊥ ⊑ ⊔ k f) s)
  (if (hash-has-key? s nm)
    ((node-depend/lattice nm k) s)
    (((f nm) (id-κ/lattice nm)) (hash-set s nm (lattice-node (list k) ⊥ ⊑ ⊔)))))

(define-syntax define-key
  (syntax-rules ()
    [(_ (name param ...) body)
     (struct name (param ...)
       #:transparent
       #:property prop:procedure
      (λ (self k) (memoize/powerset self k (match-lambda [(name param ...) body]))))]
    [(_ (name param ...) #:⊥ ⊥-expr #:⊑ ⊑-expr #:⊔ ⊔-expr body)
     (begin
       (define ⊥ ⊥-expr)
       (define ⊑ ⊑-expr)
       (define ⊔ ⊔-expr)
       (struct name (param ...)
         #:transparent
         #:property prop:procedure
         (λ (self k) (memoize/lattice self ⊥ ⊑ ⊔ k (match-lambda [(name param ...) body])))))]))

(define (run m [s (hash)])
  (match (hash-ref (run* m s) m)
    [(powerset-node _ xss) xss]
    [(lattice-node _ n _ _) n]))

(define (run-get-hash m [s (hash)])
  (run* m s))

(define (from-hash m s)
  (match (hash-ref s m)
    [(powerset-node _ xss) xss]
    [(lattice-node _ n _ _) n]))

(provide (all-from-out "monad.rkt")
         run
         run-get-hash
         from-hash
         define-key)
