#lang racket/base
(require "./table-monad/main.rkt" racket/match racket/pretty)

(struct simple-lattice () #:transparent)
(struct top simple-lattice () #:transparent)
(struct bottom simple-lattice () #:transparent)
(struct singleton simple-lattice (x) #:transparent)

(define (simple-union s1 s2)
  (match (cons s1 s2)
    [(cons (top) _) (top)]
    [(cons _ (top)) (top)]
    [(cons (bottom) x) x]
    [(cons x (bottom)) x]
    [(cons (singleton x) (singleton y)) (if (equal? x y) (singleton x) (top))]
    ))
(define (simple-lte s1 s2)
  (match (cons s1 s2)
    [(cons _ (top)) #t]
    [(cons (bottom) _) #t]
    [(cons (singleton x) (singleton y)) (equal? x y)]
    [(cons _ _) #f]
    ))


(define ((unit1 . xs) k) (k (product/set xs)))
(define ((unit2 xs) k) (k (product/lattice xs)))
(define ((void k) s) s)
(define ((>>=1 m f) k) (m (λ (xs)
  #;(displayln xs)
  (match xs 
    [(product/set xs) ((f xs) k)]
    [(product/lattice n) (id k)]
    ))))
(define ((>>=2 m f) k) (m (λ (xs)
  #;(displayln xs)
  (match xs
    [(product/set xs) (id k)]
    [(product/lattice n) ((f n) k)]
    ))))

(define-key (test1 x) #:⊥ (bottom) #:⊑ simple-lte #:⊔ simple-union #:product
  (begin #;(pretty-print "test1")
    (match x
      [10 (>>=1 (unit1 x) (λ (x) (unit2 (singleton 1))))]
      [8 (>>=2 (test1 10) unit2)] ;  (λ (l) (pretty-print "lattice cont") (unit (cons x l)))
      )))

(pretty-print (run (test1 8)))