#lang s-exp "../lang/simple-scheme.rkt"


;take n, applied to a list xs, returns the prefix of xs of length n, or xs itself if n >= length xs.
(define (take [n : Number] [lst : (Listof 'a)]) : (Listof 'a)
  (if (> n 0)
      (cons (first lst)
            (take (- n 1) (rest lst)))
      empty))

;drop n xs returns the suffix of xs after the first n elements, or [] if n >= length xs.
(define (drop [n : Number] [lst : (Listof 'a)]) : (Listof 'a)
  (if (> n 0)
      (drop (- n 1) (rest lst))
      lst))

;takes a list of lists and makes it into a single list
(define (flatten [lst : (Listof (Listof 'a))]) : (Listof 'a)
  (cond
    [(empty? lst) empty]
    [else (append (first lst) (flatten (rest lst)))]))