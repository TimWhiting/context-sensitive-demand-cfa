#lang racket/base
(require racket/set racket/match racket/pretty "utils.rkt")
(provide (all-defined-out))
(require "lang/syntax.rkt")
(provide (all-from-out "lang/syntax.rkt"))

(define (find-match-bind-loc x ms loc)
  (match ms
    [(cons m ms)
     (define is-match (find-match-bind x m))
     (if is-match (list loc is-match) (find-match-bind-loc x ms (+ 1 loc)))
     ]
    [_ #f]
    ))

(define (find-match-bind x m)
  (match m
    [(? symbol? y)
     (if (equal? y x) #t #f)]
    [`(,con ,@args)
     (define submatch (find-match-bind-loc x args 0))
     (match submatch
       [(list lsub sub)
        `(,con ,lsub ,sub)]
       [#f #f])]
    [_ #f]; Literal case
    ))

(define (oute Ce)
  (match Ce
    [(cons `(rat ,es ,C) e₀)
     (cons C `(app ,e₀ ,@es))]
    [(cons `(match-e ,es ,C) e₀)
     (cons C `(match ,e₀ ,@es))]
    [(cons `(ran ,f ,b ,a ,C) e)
     (cons C `(app ,f ,@b ,e ,@a))]
    [(cons `(match-clause ,m ,f ,b ,a ,C) e)
     (cons C `(match ,@(cons f (append b (list `(,m ,e)) a))))]
    [(cons `(bod ,y ,C) e)
     (cons C `(λ ,y ,e))]
    [(cons `(let-bod ,let-kind ,binds ,C) e₁)
     (cons C `(,let-kind ,binds ,e₁))]
    [(cons `(bin ,let-kind ,x ,e₁ ,before ,after ,C) e₀)
     (cons C `(,let-kind ,(append before (list `(,x ,e₀)) after) ,e₁))]
    [(cons `(lettypes-bod ,binds ,C) e₁)
     (cons C `(lettypes ,binds ,e₁))]
    [(cons `(top) _) (error 'out "top")]))

(define (show-simple-expr e)
  (match e
    [`(app ,@es) `(app ,@(map show-simple-expr es))]
    [`(prim ,p) `(prim ,p)]
    [`(match ,e ,@mchs) `(match ,(show-simple-expr e) ...)]
    [`(λ ,y ,bod) `(λ ,y ...)]
    [`(,let-kind ,binds ,bod) `(,let-kind ,(head-or-empty (map car binds)) ... ,(last-or-empty (map car binds)) ...)]
    [''match-error ''match-error]
    [(? symbol? x) x]
    [(? number? x) x]
    [(? char? x) x]
    [(? string? x) x]
    [#t #t]
    [#f #f]
    )
  )

(define (show-simple-ctx Ce)
  ; (pretty-print Ce)
  (match Ce
    [`(prim ,p) `(prim ,p)]
    [(cons `(rat ,es ,_) e₀)
     `(app (->,(show-simple-expr e₀) <-) ,@(map show-simple-expr es))]
    [(cons `(match-e ,es ,_) e₀)
     `(match (->,(show-simple-expr e₀) <-) ,@(map car es))]
    [(cons `(ran ,f ,b ,a ,_) e)
     `(app ,(show-simple-expr f) ,@(map show-simple-expr b) (->,(show-simple-expr e) <-) ,@(map show-simple-expr a))]
    [(cons `(match-clause ,m ,f ,b ,a ,_) e)
     `(match ,(show-simple-expr f) ,@(map car b) (,m (->,(show-simple-expr e) <-)) ,@(map car a))]
    [(cons `(bod ,y ,_) e)
     `(λ ,y (->,(show-simple-expr e) <-))]
    [(cons `(let-bod ,let-kind ,binds ,_) e₁)
     `(,let-kind ,(head-or-empty (map car binds)) ... ,(last-or-empty (map car binds)) (->,(show-simple-expr e₁) <-))]
    [(cons `(bin ,let-kind ,x ,_ ,before ,after ,_) e₀)
     `(,let-kind (,(last-or-empty (map car before)) (,x (->,(show-simple-expr e₀) <-)) ,(head-or-empty (map car after))) ...)]
    [(cons `(top) e) (cons `(top) (show-simple-expr e))]
    [(cons `(lettypes-bod ,tps, _) bod)
     `(lettypes ,(head-or-empty (map car tps)) ... ,(last-or-empty (map car tps)) ,(show-simple-expr bod))
     ]
    [(? symbol? x) x]
    [(? number? x) x]
    [(? char? x) x]
    [(? string? x) x]
    [`(con ,nm ,args) Ce]
    [_
     (pretty-print Ce)
     (error 'fail "")
     ]
    )
  )

(module+ main
  (require rackunit)
  ; Free variables
  (check-equal? (free-vars `(app a b)) (set 'a 'b))
  (check-equal? (free-vars `(λ (a) (app a b))) (set 'b))
  (check-equal? (free-vars `(λ (a) (match a ((cons b c) (app b c)) (nil (app c1 d1))))) (set 'c1 'd1))
  (check-equal? (free-vars `(let ((a b)) (app a b))) (set 'b))
  ; Bound variables (patterns)
  (check-equal? (pattern-bound-vars `(cons b c)) (set 'b 'c))
  (check-equal? (pattern-bound-vars `(cons (cons a b) c)) (set 'a 'b 'c))
  (check-equal? (pattern-bound-vars `(cons (cons a 2) #f)) (set 'a))
  (check-equal? (pattern-bound-vars `(cons (cons 1.0 "") #f)) (set))
  ; Pattern bind locations
  (check-equal? (find-match-bind 'a `(cons a b)) `(cons 0 #t))
  (check-equal? (find-match-bind 'a `(cons b a)) `(cons 1 #t))
  (check-equal? (find-match-bind 'a `(cons b (cons a))) `(cons 1 (cons 0 #t)))
  (check-equal? (find-match-bind 'a `(cons b (cons 1.0 nil))) #f)
  )