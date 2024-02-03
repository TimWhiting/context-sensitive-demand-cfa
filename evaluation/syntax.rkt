#lang racket/base
(require racket/set racket/match)
(provide (all-defined-out))

(define (free-vars e)
  (match e
    [`(app ,f ,@args)
     (foldl set-union (set)
            (cons (free-vars f)
                  (map free-vars args)))]
    [`(λ ,xs ,bod)
     (set-subtract (free-vars bod) (apply set xs))]
    [`(let ,binds ,bod)
     (set-subtract
      (foldl set-union (set)
             (cons (free-vars bod)
                   (map (λ (bind) (free-vars (cadr bind))) binds)))
      (apply set (map car binds)))
     ]
    [`(match ,scruitinee ,@ms)
     (foldl set-union (set)
            (cons (free-vars scruitinee)
                  (map (λ (match)
                         (set-subtract
                          (free-vars (cadr match))
                          (pattern-bound-vars (car match))
                          ))
                       ms)))]
    [(? symbol? x) (set x)]
    [#f (set)]
    [#t (set)]
    [(? number? x) (set)]
    [(? string? x) (set)]
    [(? char? x) (set)]
    ))

(define (pattern-bound-vars pat)
  (match pat
    [(? symbol? x) (set x)]
    [`(,con ,@args)
     (foldl set-union (set)
            (map pattern-bound-vars args))]
    [(? symbol? x) (set x)]
    [_ (set)]
    )
  )

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
    [(cons `(let-bod ,binds ,C) e₁)
     (cons C `(let ,binds ,e₁))]
    [(cons `(let-bin ,x ,e₁ ,before ,after ,C) e₀)
     (cons C `(let ,(append before (list `(,x ,e₀)) after) ,e₁))]
    [(cons `(top) _) (error 'out "top")]))

(define (lam-binds Ce)
  (match Ce
    [(cons `(bod ,y ,C) e) `(□? ,y)]
    [(cons `(top) _) #f]
    [_ (lam-binds (oute Ce))]
    )
  )

(define (show-extra-simple-ctx Ce)
  (match Ce
    [`(prim ,p) `(prim ,p)]
    [(cons `(rat ,es ,_) e₀)
     `(app (->,e₀ <-) ...)]
    [(cons `(match-e ,es ,_) e₀)
     `(match (->,e₀ <-) ,@es)]
    [(cons `(ran ,f ,b ,a ,_) e)
     `(app ... (->,e <-) ...)]
    [(cons `(match-clause ,m ,f ,b ,a ,_) e)
     `(match ,f ,@b (->,m ,e <-) ,@a)]
    [(cons `(bod ,y ,_) e)
     `(λ ,y (->,e <-))]
    [(cons `(let-bod ,binds ,_) e₁)
     `(let ,(map car binds) (->,e₁ <-))]
    [(cons `(let-bin ,x ,_ ,before ,after ,_) e₀)
     `(let (,@(map car before) (->,x = ,e₀ <-) ,@(map car after)) bod)]
    [(cons `(top) _) `(top)]
    [e e]
    )
  )

(define (show-simple-ctx Ce)
  (match Ce
    [`(prim ,p) `(prim ,p)]
    [(cons `(rat ,es ,_) e₀)
     `(app (->,e₀ <-) ,@es)]
    [(cons `(match-e ,es ,_) e₀)
     `(match (->,e₀ <-) ,@es)]
    [(cons `(ran ,f ,b ,a ,_) e)
     `(app ,f ,@b (->,e <-) ,@a)]
    [(cons `(match-clause ,m ,f ,b ,a ,_) e)
     `(match ,f ,@b (->,m ,e <-) ,@a)]
    [(cons `(bod ,y ,_) e)
     `(λ ,y (->,e <-))]
    [(cons `(let-bod ,binds ,_) e₁)
     `(let ,(map car binds) (->,e₁ <-))]
    [(cons `(let-bin ,x ,_ ,before ,after ,_) e₀)
     `(let (,@(map car before) (->,x = ,e₀ <-) ,@(map car after)) bod)]
    [(cons `(top) _) `(top)]
    [e e]
    )
  )

(module+ main
  (require rackunit)
  ; Free variables
  (check-equal? (free-vars `(app a b)) (set 'a 'b))
  (check-equal? (free-vars `(λ (a) (app a b))) (set 'b))
  (check-equal? (free-vars `(λ (a) (match a ((cons b c) (app b c)) (nil (app c1 d1))))) (set 'c1 'd1))
  (check-equal? (free-vars `(let ((a b)) (app a b))) (set 'b))


  )