#lang racket/base
(require racket/match
         racket/pretty
         racket/string
         racket/list
         "base.rkt"
         "syntax.rkt")

(define eval-name (ensuremath "\\Downarrow_{\\mathit{eval}}"))
(define call-name (ensuremath "\\Downarrow_{\\mathit{call}}"))
(define expr-name (ensuremath "\\Rightarrow_{\\mathit{expr}}"))
(define find-name (ensuremath "\\Rightarrow_{\\mathit{find}}"))
(define bind-name (ensuremath "\\mathsf{bind}"))

(define (eval Ce Cλx.e) (ensuremath Ce " " eval-name Cλx.e))
(define (call Ce Cfe) (ensuremath Ce " " call-name Cfe))
(define (expr Ce Cfe) (ensuremath Ce " " expr-name " " Cfe))
(define (find x Ce Cx) (ensuremath x "," Ce " " find-name Cx))
(define (bind x Cx) (ensuremath bind-name "(" x "," Cx ")"))

(require "parse.rkt")

(define (parse-judgement judgement)
  (match judgement
    [(⇓ Ce-0 Ce-1)
     (eval (parse-cursor Ce-0) (add-between (map parse-cursor (string-split Ce-1 " / ")) "\\; /\\; "))]
    [(⇒ Ce-0 Ce-1)
     (expr (parse-cursor Ce-0) (parse-cursor Ce-1))]
    [(⇐ Ce-0 Ce-1)
     (call (parse-cursor Ce-0) (parse-cursor Ce-1))]
    [(=/p Ce "bind(x,C[x])")
     (= (parse-cursor Ce) (bind (var 'x) (cursor (ref (var 'x)) (∘e))))]
    ["x ≠ y"
     (≠ (var 'x) (var 'y))]
    [(F lhs Ce-1)
     (match lhs
       [(regexp #rx"^x (.*)$" (list _ Ce-0))
        (find (var 'x) (parse-cursor Ce-0) (parse-cursor Ce-1))])]))

(provide (all-defined-out))
