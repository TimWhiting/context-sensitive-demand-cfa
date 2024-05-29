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
(struct state-gas (shash gas) #:transparent)
(provide product/set product/lattice)

(define ((node-depend/powerset nm k) sgi)
  ; (pretty-print 'depend-set)
  (match-let ([(state-gas s g) sgi])
    (match (hash-ref s nm #f)
      [#f
        (state-gas (hash-set s nm (powerset-node (list k) (set))) g)]
      [(powerset-node ks xss)
        (define sg (state-gas (hash-set s nm (powerset-node (cons k ks) xss)) g))
        (for/fold ([sg sg])
                  ([xs (in-set xss)])
          ((apply k xs) sg))])))

(define ((node-depend/lattice nm k) sgi)
  (match-let ([(state-gas s g) sgi])
    (match-let ([(lattice-node ks n ⊑ ⊔) (hash-ref s nm)])
      ((k n) (state-gas (hash-set s nm (lattice-node (cons k ks) n ⊑ ⊔)) g)))))

(define ((node-depend/product nm k) sgi)
  #;(displayln "Node depend product")
  ; (pretty-print 'node-depend-product)
  (match-let ([(state-gas s g) sgi])
    (match-let ([(product-node ks xss n ⊥ ⊑ ⊔) (hash-ref s nm)])
      (define new-deps-hash (state-gas (hash-set s nm (product-node (cons k ks) xss n ⊥ ⊑ ⊔)) g))
      (define new-hash-set
        (for/fold ([sg new-deps-hash])
                  ([xs (in-set xss)])
          ((k (product/set xs)) sg)))
      (if (equal? n ⊥)
          new-hash-set
          ((k (product/lattice n)) new-hash-set)))))

(provide node-depend/powerset
         node-depend/lattice
         node-depend/product)

(define (((node-exists/powerset nm) k) sgi)
  ; (pretty-print 'node-exists-product)
  (match-let ([(state-gas s g) sgi])
    (match (hash-ref s nm #f)
      [#f
      ;  (pretty-print `(new-refine ,nm))
        ((k #f) (state-gas s g))]
      [(powerset-node _ s1)
        (define empty (set-empty? s1))
        (if empty
            ((k #f) (state-gas s g))
            ((k #t) (state-gas s g))
            )
      ]
      [_ ((k #t) (state-gas s g))]
      ))
    )

(define ((node-absorb/powerset nm xs) sgi)
  ; (pretty-print `(absorb-set ,xs))
  (match-let ([(state-gas s g) sgi])
    (match (hash-ref s nm #f)
      [#f
       (state-gas (hash-set s nm (powerset-node (list) (set xs))) g)]
      [(powerset-node ks xss)
      (if (set-member? xss xs)
          (state-gas s g)
          (foldl (λ (k sg) ((apply k xs) sg)) (state-gas (hash-set s nm (powerset-node ks (set-add xss xs))) g) ks))])))

(define ((node-absorb/lattice nm n) sgi)
  (match-let ([(state-gas s g) sgi])
    (match-let ([(lattice-node ks n₀ ⊑ ⊔) (hash-ref s nm)])
      (if (⊑ n n₀)
          (state-gas s g)
          (let ([n (⊔ n₀ n)])
            (foldl (λ (k sg) ((k n) sg)) (state-gas (hash-set s nm (lattice-node ks n ⊑ ⊔)) g) ks))))))

(define (((node-absorb/product ⊥ ⊑ ⊔) nm i) sgi)
  (match-let ([(state-gas s g) sgi])
    ; (pretty-print 'node-absorb-product)
    ; (pretty-print `(node-absorb-prod ,nm ,i))
    (match (hash-ref s nm #f)
      [(product-node ks xss n₀ ⊥ ⊑ ⊔)
        (match i
          [(product/lattice n)
            (if (⊑ n n₀)
                (state-gas s g)
                (let* ([n-new (⊔ n₀ n)]
                       [new-node (product-node ks xss n-new ⊥ ⊑ ⊔)])
                  (foldl (λ (k sg) ((k (product/lattice n-new)) sg)) (state-gas (hash-set s nm new-node) g) ks)))]
          [(product/set xs) 
            (if (set-member? xss xs)
                (state-gas s g)
                (let ([new-node (product-node ks (set-add xss xs) n₀ ⊥ ⊑ ⊔)])
                  (foldl (λ (k sg) ((k (product/set xs)) sg)) (state-gas (hash-set s nm new-node) g) ks)))]
          )]
      [#f
        (match i
          [(product/lattice n) (state-gas (hash-set s nm (product-node (list) (list) n ⊥ ⊑ ⊔)) g)]
          [(product/set xs) (state-gas (hash-set s nm (product-node (list) (set xs) ⊥ ⊥ ⊑ ⊔)) g)]
          )]
      )))

(provide node-absorb/powerset
         node-absorb/lattice
         node-absorb/product)

(define ((id-κ/powerset nm) . xs) (node-absorb/powerset nm xs))
(define ((id-κ/lattice nm) n) (node-absorb/lattice nm n))
(define (((id-κ/product ⊥ ⊑ ⊔) nm) n) ((node-absorb/product ⊥ ⊑ ⊔) nm n))

(provide id-κ/powerset
         id-κ/lattice
         id-κ/product)

(define ((memoize/powerset nm k f) sgi)
  ; (pretty-print 'memo-set)
  (match-let ([(state-gas s g) sgi])
    (if (= g 0)
      (error 'ran-out-of-gas)
      (if (hash-has-key? s nm)
          ((node-depend/powerset nm k) (state-gas s (- g 1)))
          (((f nm) (id-κ/powerset nm)) (state-gas (hash-set s nm (powerset-node (list k) (set))) (- g 1)))))))

(define ((memoize/lattice nm ⊥ ⊑ ⊔ k f) sgi)
  (match-let ([(state-gas s g) sgi])
    (if (hash-has-key? s nm)
        ((node-depend/lattice nm k) (state-gas s (- g 1)))
        (((f nm) (id-κ/lattice nm)) (state-gas (hash-set s nm (lattice-node (list k) ⊥ ⊑ ⊔)) (- g 1))))))

(define ((memoize/product nm ⊥ ⊑ ⊔ k f) sgi)
  ; (pretty-print 'memo-product)
  (match-let ([(state-gas s g) sgi])
    (if (= g 0)
      (error 'ran-out-of-gas)
      (if (hash-has-key? s nm)
          ((node-depend/product nm k) (state-gas s (- g 1)))
          (begin
            (let ([initial-hash (state-gas (hash-set s nm (product-node (list k) (set) ⊥ ⊥ ⊑ ⊔)) (- g 1))])
              (((f nm) ((id-κ/product ⊥ ⊑ ⊔) nm)) initial-hash))))))
    )

(define-syntax define-key
  (syntax-rules ()
    [(_ (name param ...) #:⊥ ⊥-expr #:⊑ ⊑-expr #:⊔ ⊔-expr #:product body ...)
     (begin
       (define ⊥ ⊥-expr)
       (define ⊑ ⊑-expr)
       (define ⊔ ⊔-expr)
       (struct name (param ...)
         #:transparent
         #:property prop:procedure
         (λ (self k) (memoize/product self ⊥ ⊑ ⊔ k (match-lambda [(name param ...) body ...])))))]
    [(_ (name param ...) #:⊥ ⊥-expr #:⊑ ⊑-expr #:⊔ ⊔-expr body ...)
     (begin
       (define ⊥ ⊥-expr)
       (define ⊑ ⊑-expr)
       (define ⊔ ⊔-expr)
       (struct name (param ...)
         #:transparent
         #:property prop:procedure
         (λ (self k) (memoize/lattice self ⊥ ⊑ ⊔ k (match-lambda [(name param ...) body ...])))))]
    [(_ (name param ...) body ...)
     (struct name (param ...)
       #:transparent
       #:property prop:procedure
       (λ (self k) (memoize/powerset self k (match-lambda [(name param ...) body ...]))))]))

(define (run m state gas)
  (match (hash-ref (run* m (state-gas state gas)) m)
    [(powerset-node _ xss) xss]
    [(lattice-node _ n _ _) n]
    [(product-node _ xss n _ _ _) (cons xss n)]))

(define (run-get-hash m state gas)
  (run* m (state-gas state gas)))

(define (from-hash key state)
  (from-value (hash-ref state key #f)))

(define (from-value v)
  (match v
    [(powerset-node _ xss) xss]
    [(lattice-node _ n _ _) n]
    [(product-node _ xss n _ _ _) (cons xss n)]
    [#f #f]))

(provide (all-from-out "monad.rkt")
         run
         run-get-hash
         state-gas
         node-exists/powerset
         from-hash
         from-value
         define-key)

