#lang racket/base
(require "table-monad/main.rkt" "config.rkt")
(require racket/match racket/pretty)
(provide (all-defined-out))

(define ((clos Ce p) k) (k (product/set (list Ce p))))
(define ((lit x) k) (k (product/lattice x)))

(define ((>>=eval m fclos flit) k)
  (m (λ (xs)
       ;  (pretty-print xs)
       (match xs
         [(product/set xs) ((apply fclos xs) k)]
         [(product/lattice n) ((flit n) k)]
         ))))
(define ((>>=lit m f) k) ((>>=eval m (λ (_ __) ⊥) f) k))
(define ((>>=clos m f) k) ((>>=eval m f (λ (_) ⊥)) k))

; abstract values
(struct literal (litLattices) #:transparent)
(struct flat-lattice () #:transparent)
(struct top flat-lattice () #:transparent)
(struct bottom flat-lattice () #:transparent)
(struct singleton flat-lattice (x) #:transparent)

(define litbottom (literal (list (bottom) (bottom) (bottom) (bottom))))
(define (litnum f) (literal (list (singleton f) (bottom) (bottom) (bottom))))
(define topnum (lit (literal (list (top) (bottom) (bottom) (bottom)))))
(define (litchar c) (literal (list (bottom) (singleton c) (bottom) (bottom))))
(define topchar (lit (literal (list (bottom) (top) (bottom) (bottom)))))
(define (litstring s) (literal (list (bottom) (bottom) (singleton s) (bottom))))
(define topstr (lit (literal (list (bottom) (bottom) (top) (bottom)))))
(define (litsym s) (literal (list (bottom) (bottom) (bottom) (singleton s))))
(define topsym (lit (literal (list (bottom) (bottom) (bottom) (top)))))

(define (to-lit lit)
  (match lit
    [(? number? n) (litnum n)]
    [(? string? s) (litstring s)]
    [(? char? c) (litchar c)]
    [`',x (litsym x)]
    [_ #f]
    )
  )

; union of flat lattice
(define (flat-union s1 s2)
  (match (cons s1 s2)
    [(cons (top) _) (top)]
    [(cons _ (top)) (top)]
    [(cons (bottom) x) x]
    [(cons x (bottom)) x]
    [(cons (singleton x) (singleton y)) (if (equal? x y) (singleton x) (top))]
    ))

(define (flat-lte s1 s2)
  (match (cons s1 s2)
    [(cons _ (top)) #t]
    [(cons (bottom) _) #t]
    [(cons (singleton x) (singleton y)) (equal? x y)]
    [(cons _ _) #f]
    ))

(define (lit-union s1 s2)
  (match (cons s1 s2)
    [(cons (literal lits1) (literal lits2)) (literal (map flat-union lits1 lits2))]
    ))

(define (lit-lte s1 s2)
  (match (cons s1 s2)
    [(cons (literal lits1) (literal lits2)) (andmap flat-lte lits1 lits2)]
    ))