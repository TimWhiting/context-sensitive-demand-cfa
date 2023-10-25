#lang racket/base
(require racket/match
         racket/list
         racket/string
         racket/pretty)

(define label-pattern #px"^\\S+$")

(define bar-pattern #px"^—+$")

(define (apply ? s)
  (cond
    [(regexp? ?) (regexp-match? ? s)]
    [(string? ?) (string=? ? s)]
    [else (? s)]))

(define (ss-case ss snull scons)
  (match ss
    [(list) (snull)]
    [(cons s ss) (scons s ss)]))

(define (expect ? ss k)
  (match ss
    [(list)
     (error 'expect "expected ~v but got empty" ?)]
    [(cons s ss)
     (if (apply ? s)
       (k s ss)
       (error 'expect "expected ~v but got ~v" ? s))]))

(define (expect+ ? ss k)
  (expect ? ss (λ (x ss)
                 (let loop ([ss ss]
                            [k (λ (xs ss) (k (cons x xs) ss))])
                   (branch ? ss
                           (λ (x ss) (loop ss (λ (xs ss) (k (cons x xs) ss))))
                           (λ () (k (list) ss)))))))

(define (branch ? ss k₀ k₁)
  (match ss
    [(list)
     (error 'branch "checking for ~v but got empty" ?)]
    [(cons s ss)
     (if (apply ? s)
       (k₀ s ss)
       (k₁))]))

(define (fail) (error 'fail "should put a good message here"))

(define ((newline k) x ss) (expect "\n" ss (λ (_ ss) (k x ss))))

(define (inference-rule* ss k)
  (inference-rule ss
                  (λ (rule ss)
                    (let loop ([ss ss]
                               [k (λ (rules ss) (k (cons rule rules) ss))])
                      (if (null? ss)
                          (k (list) ss)
                          (expect+ "\n" ss
                                   (λ (_ ss)
                                     (inference-rule ss
                                                     (λ (rule ss) (loop ss (λ (rules ss) (k (cons rule rules) ss))))))))))))

(define (inference-rule ss k)
  (define (make-k label antecedents)
    (newline (λ (_ ss)
               (ss-case ss fail
                        (newline (λ (consequent ss)
                                   (k (list label antecedents consequent) ss)))))))
  (expect label-pattern ss
          (newline (λ (label ss)
                     (branch bar-pattern ss
                             (make-k label (list))
                             (λ ()
                               (ss-case ss fail
                                        (newline (λ (antecedent-line ss)
                                                   (expect bar-pattern ss
                                                           (make-k label (string-split antecedent-line "  "))))))))))))


(define (mathpar parse-judgement . ss)
  (list "\\begin{mathpar}\n"
        (add-between
         (map
          (match-lambda
            [(list label antecedents consequent)
             (list (list "\\inferrule" "[" label "]" "\n")
                   (list "{ ")
                   (add-between (map parse-judgement antecedents) (list " " "\\\\" "\n"))
                   (list " }" "\n")
                   (list "{ ")
                   (parse-judgement consequent)
                   (list " }" "\n"))])
          (inference-rule* ss (λ (rules ss) (if (null? ss) rules (fail)))))
         (list "\n"))
        "\\end{mathpar}\n"))


(provide mathpar)
