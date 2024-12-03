#lang racket/base
(require racket/match racket/list)
(provide (all-defined-out))

(define (hash-num-keys h) (length (hash-keys h)))

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

(define (last-or-empty cc)
  (match cc
    [(cons _ _) (last cc)]
    [(list) (list)]
    ))

(define (tail-or-empty cc)
  (match cc
    [(cons _ ccs) ccs]
    [(list) (list)]
    ))

(module+ main
  (require rackunit)
  (check-equal? (ors (list #f #f #t)) #t)
  (check-equal? (ors (list #f #f)) #f)
  (check-equal? (alls (list #t #t)) #t)
  (check-equal? (alls (list #t #f)) #f)
  )