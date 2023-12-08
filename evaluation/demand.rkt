#lang racket/base
(require "./fixpoint.rkt")
(require racket/pretty)
(require racket/match
         racket/set)
         
(define (run c)
  ((c (λ (xs)
        (pretty-print xs)
        id))
   (hash)))

; calling contexts

(define current-m (make-parameter 1))

(define cc-determined?
  (match-lambda
    [(list)
     #t]
    [`(□ ,_)
     #f]
    [(cons Ce cc)
     (cc-determined? cc)]))

(define (take-cc cc)
  (let loop ([m (current-m)]
             [cc cc])
    (if (zero? m)
      (list)
      (match cc
        [(list)
         (list)]
        [`(□ ,x)
         `(□ ,x)]
        [(cons Ce cc)
         (cons Ce (loop (- m 1) cc))]))))

(define (enter-cc Ce ρ)
  (take-cc (cons Ce
                 (match ρ
                   [(list)
                    (list)]
                   [(cons cc _)
                    cc]))))

(define (⊑-cc cc₀ cc₁)
  (match cc₀
    [(list)
     (match cc₁
       [(list)
        #t]
       [`(□ ,_)
        #t]
       [(cons _ _)
        #f])]
    [`(□ ,x)
     (match cc₁
       [(list)
        #f]
       [`(□ ,y)
        (equal? x y)]
       [(cons _ _)
        #f])]
    [(cons Ce₀ cc₀)
     (match cc₁
       [(list)
        #f]
       [`(□ ,_)
        #t]
       [(cons Ce₁ cc₁)
        (and (equal? Ce₀ Ce₁)
             (⊑-cc cc₀ cc₁))])]))

; syntax traversal

(define (out Ce ρ)
  (match Ce
    [(cons `(rat ,e₁ ,C) e₀)
     (unit (cons C `(app ,e₀ ,e₁)) ρ)]
    [(cons `(ran ,e₀ ,C) e₁)
     (unit (cons C `(app ,e₀ ,e₁)) ρ)]
    [(cons `(bod ,y ,C) e)
     (unit (cons C `(λ (,y) e))
           (match-let ([(cons _ ρ) ρ]) ρ))]
    [(cons `(let-bod ,x ,e₀ ,C) e₁)
     (unit (cons C `(let ([,x ,e₀]) ,e₁)) ρ)]
    [(cons `(let-bin ,x ,e₁ ,C) e₀)
     (unit (cons C `(let ([,x ,e₀]) ,e₁)) ρ)]
    [`(top)
     (error 'out "top")]))

(define (bin Ce ρ)
  (match Ce
    [(cons C `(let ([,x ,e₀]) ,e₁))
     (unit (cons `(let-bin ,x ,e₁ ,C) e₀) ρ)]))

(define (bod Ce ρ)
  (match Ce
    [(cons C `(λ (,x) ,e))
     (unit (cons `(bod ,x ,C) e) (cons (take-cc `(□ ,x)) ρ))]
    [(cons C `(let ([,x ,e₀]) ,e₁))
     (unit (cons `(let-bod ,x ,e₀ ,C) e₁) ρ)]))

(define (rat Ce ρ)
  (match Ce
    [(cons C `(app ,e₀ ,e₁))
     (unit (cons `(rat ,e₁ ,C) e₀) ρ)]))

(define (ran Ce ρ)
  (match Ce
    [(cons C `(app ,e₀ ,e₁))
     (unit (cons `(ran ,e₀ ,C) e₁) ρ)]))

; environment refinement

(define ((put-refines ρ₀ ρ₁) κ)
  #;
  (pretty-print `(refines ,ρ₀ ,ρ₁))
  ((push `(refine ,ρ₁)) (list ρ₀)))

(define get-refines
  (memo 'refine (λ (ρ₁) ⊥)))


(define get-refines*
  (match-lambda
    [(list)
     ⊥]
    [(and ρ (cons cc ρ′))
     (⊔ (if (cc-determined? cc)
          ; won't have any refinements at this scope
          ⊥
          (get-refines ρ))
        (>>= (get-refines* ρ′) (λ (ρ′) (unit (cons cc ρ′)))))]))

; demand evaluation

(define eval
  (memo 'eval
        (λ (Ce ρ)
          #;
          (pretty-print `(eval ,Ce ,ρ))
          (⊔ (match Ce
               [(cons C (? symbol? x))
                (>>= (bind x C x ρ)
                     (λ (Ce ρ)
                       (match Ce
                         [(cons `(bod ,x ,C) e)
                          (>>= (>>= (call C x e ρ) ran) eval)]
                         [(cons `(let-bod ,_ ,_ ,_) e)
                          (>>= (>>= (out Ce ρ) bin) eval)])))]
               [(cons _ `(λ (,_) ,_))
                (unit Ce ρ)]
               [(cons _ `(app ,_ ,_))
                (>>= (>>= (>>= (rat Ce ρ) eval) bod) eval)])
             (>>= (get-refines* ρ) (λ (ρ) (eval Ce ρ)))))))

(define (bind x C e ρ)
  (match C
    [`(rat ,e₁ ,C)
     (bind x C `(app ,e ,e₁) ρ)]
    [`(ran ,e₀ ,C)
     (bind x C `(app ,e₀ ,e) ρ)]
    [`(bod ,y ,C)
     (if (equal? x y)
       (unit (cons `(bod ,y ,C) e) ρ)
       (bind x C `(λ (,y) ,e) (match-let ([(cons _ ρ) ρ]) ρ)))]
    [`(let-bod ,y ,e₀ ,C′)
     (if (equal? x y)
       (unit (cons C e) ρ)
       (bind x C′ `(let ([,y ,e₀]) ,e) ρ))]
    [`(let-bin ,y ,e₁ ,C)
     (bind x C `(let ([,y ,e]) ,e₁) ρ)]
    [`(top)
     ⊥]))

(define (call C x e ρ)
  #;
  (pretty-print `(call ,x ,e ,ρ))
  (match-let ([(cons cc₀ ρ₀) ρ])
    (>>= (expr (cons C `(λ (,x) ,e)) ρ₀)
         (λ (Cee ρee)
           (let ([cc₁ (enter-cc Cee ρee)])
             (cond
               [(equal? cc₀ cc₁)
                (unit Cee ρee)]
               [(⊑-cc cc₁ cc₀)
                ; strictly refines because of above
                (put-refines (cons cc₁ ρ₀) ρ)]
               [else
                ⊥]))))))

(define expr
  (memo 'expr
        (λ (Ce ρ)
          #;
          (pretty-print `(expr ,Ce ,ρ))
          (⊔ (match Ce
               [(cons `(rat ,_ ,_) _)
                (out Ce ρ)]
               [(cons `(ran ,_ ,_) _)
                (>>= (out Ce ρ)
                     (λ (Cee ρee)
                       (>>= (>>= (rat Cee ρee) eval)
                            (λ (Cλx.e ρλx.e)
                              (match-let ([(cons C `(λ (,x) ,e)) Cλx.e])
                                (>>= (find x
                                         (cons `(bod ,x ,C) e)
                                         (cons (enter-cc Cee ρee)
                                               ρλx.e))
                                     expr))))))]
               [(cons `(bod ,x ,C) e)
                (>>= (call C x e ρ) expr)]
               [(cons `(top) _)
                ⊥])
             (>>= (get-refines* ρ) (λ (ρ) (expr Ce ρ)))))))

(define (find x Ce ρ)
  (match Ce
    [(cons C (? symbol? y))
     (if (equal? x y)
       (unit Ce ρ)
       ⊥)]
    [(cons C `(λ (,y) ,e))
     (if (equal? x y)
       ⊥
       (find x (cons `(bod ,y ,C) e) (cons (take-cc `(□ ,y)) ρ)))]
    [(cons C `(app ,e₀ ,e₁))
     (⊔ (find x (cons `(rat ,e₁ ,C) e₀) ρ)
        (find x (cons `(ran ,e₀ ,C) e₁) ρ))]
    [(cons C `(let ([,y ,e₀]) ,e₁))
     (⊔ (find x (cons `(let-bin ,y ,e₁ ,C) e₀) ρ)
        (if (equal? x y)
          ⊥
          (find x (cons `(let-bod ,y ,e₀ ,C) e₁) ρ)))]))

(module+ main
  (require racket/pretty)

  #;
  (pretty-print
   (run (>>= (>>= (unit (cons `(top)
                              `(app (λ (x) x)
                                    (λ (y) y)))
                    (list))
                  rat)
             eval)))

  #;
  (pretty-print
   (run (>>= (>>= (unit (cons `(top)
                              `(app (λ (x) x)
                                    (λ (y) y)))
                    (list))
                  ran)
             eval)))

  #;
  (pretty-print
   (run (>>= (>>= (>>= (unit (cons `(top)
                                   `(app (λ (x) x)
                                         (λ (y) y)))
                         (list))
                       rat)
                  bod)
             eval)))

  #;
  (pretty-print
   (run (>>= (>>= (>>= (unit (cons `(top)
                                   `(app (λ (x) x)
                                         (λ (y) y)))
                         (list))
                       ran)
                  bod)
             eval)))

  #;
  (pretty-print
   (run (>>= (>>= (>>= (unit (cons `(top)
                                   `(app (λ (x) x)
                                         (λ (y) y)))
                         (list))
                       ran)
                  bod)
             eval)))

  (current-m 4)

  "QUERY"
  (pretty-print
   (run (>>= (>>= (>>= (unit (cons `(top)
                                   `(app (λ (x) (app x x))
                                         (λ (y) (app y y))))
                         (list))
                       rat)
                  bod)
             eval)))

  "QUERY"
  (pretty-print
   (run (>>= (>>= (>>= (>>= (unit (cons `(top)
                                        `(app (λ (x) (app x x))
                                              (λ (y) (app y y))))
                              (list))
                            ran)
                       bod)
                  rat)
             eval)))

  "QUERY"
  (pretty-print
   (run (>>= (>>= (unit (cons `(top)
                              `(app (λ (x) (app x x))
                                    (λ (y) (app y y))))
                    (list))
                  ran)
             expr)))

  "QUERY"
  (pretty-print
   (run (>>= (>>= (unit (cons `(top)
                              `(let ([x (λ (y) y)])
                                 x))
                    (list))
                  bod)
             eval))))