#lang racket/base
(require racket/set racket/match racket/pretty)
(provide (all-defined-out))

(define (check-let l)
  (if (is-let l)
      '()
      (error 'not-a-let (symbol->string l))
      ))

(define (is-let l)
  (match l
    ['let #t]
    ['letrec #t]
    ['let* #t]
    [_ #f]
    ))

(define (free-vars e)
  ; (pretty-print e)
  (match e
    [`(app ,f ,@args)
     (foldl set-union (set)
            (cons (free-vars f)
                  (map free-vars args)))]
    [`(λ ,xs ,bod)
     (set-subtract (free-vars bod) (apply set xs))]
    [`(match ,scruitinee ,@ms)
     (foldl set-union (set)
            (cons (free-vars scruitinee)
                  (map (λ (match)
                         (set-subtract
                          (free-vars (cadr match))
                          (pattern-bound-vars (car match))
                          ))
                       ms)))]
    [`(lettypes ,binds ,bod)
     (set-subtract
      (free-vars bod)
      (apply set (map car binds)))
     ]
    [`(,let-kind ,binds ,bod)
     (check-let let-kind)
     (match let-kind
       ['let
        (set-union
         (foldl set-union (set)
                (map (λ (bind) (free-vars (cadr bind))) binds))
         ; In a normal let, the variables are bound just for the body
         (set-subtract (free-vars bod) (apply set (map car binds))))
        ]
       ['letrec
        (set-subtract
         (foldl set-union (free-vars bod)
                (map (λ (bind) (free-vars (cadr bind))) binds))
         ; For a let rec the variables are bound for the body and all other bindings
         ; So we subtract after we get all freevars of the body
         (apply set (map car binds)))
        ]
       ['let*
        (define rbinds (reverse binds))
        (let loop ([rbinds rbinds]
                   [fvs (free-vars bod)])
          (match rbinds
            ['() fvs]
            [(cons b bs)
             (match-let ([(list binding expr) b])
               ; add the free variables of the expression to the
               ; (set of free variables of the following expressions - the binding)
               (loop bs (set-union (free-vars expr) (set-remove fvs binding)))
               )
             ]))
        ])
     ]
    [(? symbol? x) (set x)]
    [(? char? x) (set)]
    [#f (set)]
    [#t (set)]
    [(? number? x) (set)]
    [(? string? x) (set)]
    [(? char? x) (set)]
    ))

(define (pattern-bound-vars pat)
  (match pat
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
    [(cons `(let-bod ,let-kind ,binds ,C) e₁)
     (cons C `(,let-kind ,binds ,e₁))]
    [(cons `(bin ,let-kind ,x ,e₁ ,before ,after ,C) e₀)
     (cons C `(,let-kind ,(append before (list `(,x ,e₀)) after) ,e₁))]
    [(cons `(lettypes-bod ,binds ,C) e₁)
     (cons C `(lettypes ,binds ,e₁))]
    [(cons `(top) _) (error 'out "top")]))

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
    [(cons `(let-bod ,let-kind ,binds ,_) e₁)
     `(,let-kind ,(map car binds) (->,e₁ <-))]
    [(cons `(bin ,let-kind ,x ,_ ,before ,after ,_) e₀)
     `(,let-kind (,@(map car before) (->,x = ,e₀ <-) ,@(map car after)) bod)]
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
    [(cons `(let-bod ,let-kind ,binds ,_) e₁)
     `(,let-kind ,(map car binds) (->,e₁ <-))]
    [(cons `(bin ,let-kind ,x ,_ ,before ,after ,_) e₀)
     `(,let-kind (,@(map car before) (->,x = ,e₀ <-) ,@(map car after)) bod)]
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