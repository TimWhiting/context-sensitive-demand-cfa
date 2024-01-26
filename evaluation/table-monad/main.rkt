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
(struct product-node node (xss n ⊥ ⊑ ⊔) #:transparent)
(struct product () #:transparent)
(struct product/set product (xss) #:transparent)
(struct product/lattice product (n) #:transparent)
(provide product/set product/lattice)

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

(define ((node-depend/product nm k) s)
  #;(displayln "Node depend product")
  (match-let ([(product-node ks xss n ⊥ ⊑ ⊔) (hash-ref s nm)])
    (define new-deps-hash (hash-set s nm (product-node (cons k ks) xss n ⊥ ⊑ ⊔)))
    (define new-hash-set
      (for/fold ([s new-deps-hash])
                ([xs (in-set xss)])
        ((k (product/set xs)) s)))
    (if (equal? n ⊥)
        new-hash-set
        ((k (product/lattice n)) new-hash-set))))

(provide node-depend/powerset
         node-depend/lattice
         node-depend/product)

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

(define (((node-absorb/product ⊥ ⊑ ⊔) nm i) s)
  #;(displayln "Node absorb product")
  #;(displayln nm)
  #;(displayln i)
  #;(pretty-print s)
  (match (hash-ref s nm #f)
    [(product-node ks xss n₀ ⊥ ⊑ ⊔)
     (match i
       [(product/lattice n)
        (if (⊑ n n₀)
            s
            (let* ([n-new (⊔ n₀ n)]
                   [new-node (product-node ks xss n-new ⊥ ⊑ ⊔)])
              (foldl (λ (k s) ((k (product/lattice n-new)) s)) (hash-set s nm new-node) ks)))]
       [(product/set xs) (if (set-member? xss xs)
                             s
                             (let ([new-node (product-node ks (set-add xss xs) n₀ ⊥ ⊑ ⊔)])
                               (foldl (λ (k s) ((k (product/set xs)) s)) (hash-set s nm new-node) ks)))]
       )]
    [#f
     (match i
       [(product/lattice n) (hash-set s nm (product-node (list) (list) n ⊥ ⊑ ⊔)) ]
       [(product/set xs) (hash-set s nm (product-node (list) xs ⊥ ⊥ ⊑ ⊔))]
       )]
    ))

(provide node-absorb/powerset
         node-absorb/lattice
         node-absorb/product)

(define ((id-κ/powerset nm) . xs) (node-absorb/powerset nm xs))
(define ((id-κ/lattice nm) n) (node-absorb/lattice nm n))
(define (((id-κ/product ⊥ ⊑ ⊔) nm) n) ((node-absorb/product ⊥ ⊑ ⊔) nm n))

(provide id-κ/powerset
         id-κ/lattice
         id-κ/product)

(define ((memoize/powerset nm k f) s)
  (if (hash-has-key? s nm)
      ((node-depend/powerset nm k) s)
      (((f nm) (id-κ/powerset nm)) (hash-set s nm (powerset-node (list k) (set))))))

(define ((memoize/lattice nm ⊥ ⊑ ⊔ k f) s)
  (if (hash-has-key? s nm)
      ((node-depend/lattice nm k) s)
      (((f nm) (id-κ/lattice nm)) (hash-set s nm (lattice-node (list k) ⊥ ⊑ ⊔)))))

(define ((memoize/product nm ⊥ ⊑ ⊔ k f) s)
  #;(displayln nm)
  (if (hash-has-key? s nm)
      ((node-depend/product nm k) s)
      (begin
        (let ([initial-hash (hash-set s nm (product-node (list k) (set) ⊥ ⊥ ⊑ ⊔))])
          (((f nm) ((id-κ/product ⊥ ⊑ ⊔) nm)) initial-hash)))))

(define-syntax define-key
  (syntax-rules ()
    [(_ (name param ...) body)
     (struct name (param ...)
       #:transparent
       #:property prop:procedure
       (λ (self k) (memoize/powerset self k (match-lambda [(name param ...) body]))))]
    [(_ (name param ...) #:⊥ ⊥-expr #:⊑ ⊑-expr #:⊔ ⊔-expr #:product body)
     (begin
       (define ⊥ ⊥-expr)
       (define ⊑ ⊑-expr)
       (define ⊔ ⊔-expr)
       (struct name (param ...)
         #:transparent
         #:property prop:procedure
         (λ (self k) (memoize/product self ⊥ ⊑ ⊔ k (match-lambda [(name param ...) body])))))]
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
    [(lattice-node _ n _ _) n]
    [(product-node _ xss n _ _ _) (cons xss n)]))

(define (run-get-hash m [s (hash)])
  (run* m s))

(define (from-hash m s)
  (match (hash-ref s m)
    [(powerset-node _ xss) xss]
    [(lattice-node _ n _ _) n]
    [(product-node _ xss n _ _ _) (cons xss n)]))

(provide (all-from-out "monad.rkt")
         run
         run-get-hash
         from-hash
         define-key)

