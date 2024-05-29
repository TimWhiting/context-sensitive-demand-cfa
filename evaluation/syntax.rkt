#lang racket/base
(require racket/set racket/match racket/pretty racket/list "utils.rkt")
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
    [(cons `(bintp ,l ,e ,before ,after ,C) `(typedef ,bind))
      (cons C `(lettypes ,(append before (list bind) after) ,e))]
    [(cons `(top) _) (error 'out "top")]))


(define ((bintp i) Ce)
  (match Ce
    [(cons C `(,l ,binds ,e₁))
     (check-let l)
     (define before (take binds i))
     (define eqafter (drop binds i))
     (define after (cdr eqafter))
     (define bind (car eqafter))
     (cons `(bintp ,l ,e₁ ,before ,after ,C) `(typedef ,bind))]))

(define ((lookup-constructor c) Ce)
  (define (search-out) ((lookup-constructor c) (oute Ce)))
  (match Ce
    [(cons `(top) _) #f]
    [(cons `(lettypes-bod ,binds ,C) e₁)
     (if (member c (map car binds))
         ((bintp (index-of (map car binds) c)) (oute Ce))
         (search-out)
         )]
    [_ (search-out)]
    )
  )

(define (expr-kind e)
  (match e
    [`(app ,@es) 'app]
    [`(match ,e ,@mchs) 'match]
    [`(λ ,y ,bod) 'lambda]
    [`(,let-kind ,binds ,bod) let-kind]
    [(? symbol? x) 'ref-or-constructor]
    [(? number? x) 'number]
    [(? char? x) 'char]
    [(? string? x) 'string]
    [`',x 'quoted]
    [#t 'constructor]
    [#f 'constructor]
    )
  )

(define (is-instant-query-kind k)
  (member k '(lambda number char string quoted constructor))
  )

(define (show-simple-expr e [depth 0])
  (define next-depth (+ 1 depth))
  (define show-simple-rec (λ (e1) (show-simple-expr e1 next-depth)))
  (match e
    [`(app ,e1 ,@es) 
      (if (= depth 2)
        `(app ,(show-simple-rec e1) ...)
         (if (= depth 3)
          `(...)
          `(app ,(show-simple-rec e1) ,@(map show-simple-rec es))
         )
         )]
    [`(prim ,n ,p) `(prim ,n)]
    [`(match ,e ,@mchs) `(match ,(show-simple-rec e) ...)]
    [`(λ ,y ,bod) `(λ ,y ...)]
    [`(,let-kind ,binds ,bod) `(,let-kind ,(show-simple-binds binds) ...)]
    [(? symbol? x) x]
    [(? number? x) x]
    [(? char? x) x]
    [(? string? x) x]
    [`',x `',x]
    [`(typedef ,tp) tp]
    ; ['() '()]
    [#t #t]
    [#f #f]
    )
  )

(define (show-simple-binds binds)
  (define bs (map car binds))
  (match bs
    [(list) (list)]
    [(list a) (list a)]
    [xs `(,(head-or-empty xs) ... ,(last-or-empty xs))]
    )
  )

(define (show-simple-ctx Ce)
  ; (pretty-print Ce)
  (match Ce
    [`(prim ,n ,p) `(prim ,n)]
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
     `(,let-kind ,(show-simple-binds binds) (->,(show-simple-expr e₁) <-))]
    [(cons `(bin ,let-kind ,x ,_ ,before ,after ,_) e₀)
     `(,let-kind (... ,(last-or-empty (map car before)) (,x (->,(show-simple-expr e₀) <-)) ,(head-or-empty (map car after)) ... ) ...)]
    [(cons `(top) e) (cons `(top) (show-simple-expr e))]
    [(cons `(lettypes-bod ,tps, _) bod)
     `(lettypes ,(head-or-empty (map car tps)) ... ,(last-or-empty (map car tps)) ,(show-simple-expr bod))
     ]
    [(? symbol? x) x]
    [(? number? x) x]
    [(? char? x) x]
    [(? string? x) x]
    [`(con ,nm ,@args) `(con ,nm ,@(map show-simple-ctx args))]
    [`(top) `(top)]
    [`',x `',x]
    [(cons `(bintp ,l ,e ,before ,after ,C) tp) tp]
    [_
     (error 'fail (pretty-format `(no-simple-context-for ,Ce)))
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