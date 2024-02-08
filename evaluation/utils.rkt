#lang racket/base
(require racket/match racket/list)
(provide (all-defined-out))

(define (hash-num-keys h) (length (hash-keys h)))

(define-syntax-rule (zip l ...)
  (map list l ...))

(define (intersperse n l)
  (add-between l n))

(define (ors xs)
  (match xs
    [(list) #f]
    [(cons x xs) (or x (ors xs))])
  )

(define (alls xs)
  (match xs
    [(list) #t]
    [(cons x xs) (and x (alls xs))])
  )

(define (head-or-empty cc)
  (match cc
    [(cons c _) c]
    [(list) (list)]
    ))

(module+ main
  (require rackunit)
  (check-equal? (ors (list #f #f #t)) #t)
  (check-equal? (ors (list #f #f)) #f)
  (check-equal? (alls (list #t #t)) #t)
  (check-equal? (alls (list #t #f)) #f)
  )