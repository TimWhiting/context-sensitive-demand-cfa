#lang racket/base
(require (rename-in "table-monad/main.rkt" [void fail]))
(require "config.rkt")
(require racket/set racket/match racket/list racket/pretty)
(provide (all-defined-out))
; syntax traversal

; m-CFA flat like environments (rebinding free variables)
(struct flatenv (m) #:transparent)
; m-CFA exponential environments (nested environments)
(struct expenv (m) #:transparent)
; Demand m-CFA environments (nested environments, with embedded environments)
(struct envenv (m) #:transparent)
; Demand m-CFA basic environments (nested environments) akin to m-CFA exponential, but with indeterminate calling contexts
(struct menv (m) #:transparent)

; The lexical environment list
(define (env-list ρ)
  (match ρ
    [(expenv l) l]
    [(envenv l) l]
    [(menv l) l]
    ))

; Splits into the current closure's calling context, and the lexically enclosing closure's environment
; If the env doesn't include any closures, returns it unaltered
(define (split-env env)
  (match env
    [(flatenv _) (error 'flatenv "Flatenvs do not have lexical splits (they only keep track of innermost calls)")]
    [(expenv (cons head tail)) (cons head (expenv tail))]
    [(expenv '()) (expenv '())]
    [(envenv (cons head tail)) (cons head (envenv tail))]
    [(envenv '()) (envenv '())]
    [(menv (cons head tail)) (cons head (menv tail))]
    [(menv '()) (menv '())]
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

(define (show-simple-env ρ)
  (if (show-envs-simple)
      (match ρ
        [(flatenv l) (flatenv (show-simple-call l))]
        [(expenv l) (expenv (map show-simple-call l))]
        [(menv l) (menv (map show-simple-call l))]
        [(envenv l) (envenv (map show-simple-call l))]
        )
      ρ
      )
  )

(define (show-simple-call cc)
  (match cc
    [(list)
     (list)]
    ['! '!] ; Cut known
    ['? '?] ; Cut unknown (can be reinstantiated to an indeterminate context)
    [`(□? ,x)
     `(□? ,x)]
    [`(cenv ,Ce ,ρ)
     `(cenv ,(show-simple-ctx Ce) ,(show-simple-env ρ))]
    [(cons Ce cc)
     (cons (show-simple-ctx Ce) (show-simple-call cc))])
  )

(define (bind x Ce ρ)
  (define (search-out) (>>= (out Ce ρ) (λ (Ce ρ) (bind x Ce ρ))))
  ; (pretty-print `(bind ,x ,Ce ,ρ))
  (match Ce
    [(cons `(top) _) (unit x ρ -1)] ; Constructors
    [(cons `(let-bin ,y ,_ ,before ,after ,_) _)
     ;  (pretty-print `(let-bin-bind ,y ,x))
     (define defs (append (map car before) (list y) (map car after)))
     (if (ors (map (λ (y) (equal? x y)) defs))
         (unit Ce ρ (index-of defs x))
         (search-out))]
    [(cons `(bod ,ys ,_) _)
     ;  (pretty-print `(bodbind ,ys ,x ,(ors (map (λ (y) (equal? x y)) ys)) ,(index-of ys x)))
     (if (ors (map (λ (y) (equal? x y)) ys))
         (unit Ce ρ (index-of ys x))
         (search-out))]
    [(cons `(let-bod ,binds ,_) _)
     (define defs (map car binds))
     ;  (pretty-print `(let-bind ,defs))
     (if (ors (map (λ (y) (equal? x y)) defs))
         (unit Ce ρ (index-of defs x))
         (search-out))]
    [(cons `(match-clause ,m ,scruitinee ,before ,after ,_) e₀)
     (define match-binding (find-match-bind x m))
     (if match-binding (unit Ce ρ match-binding) (search-out))]
    ; All other forms do not introduce bindings
    [(cons _ _) (search-out)]
    ))


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
    [lit #f]
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

(define (out Ce ρ)
  ; (pretty-print `(out ,Ce ,ρ))
  (match Ce
    [(cons `(rat ,es ,C) e₀)
     (unit (cons C `(app ,e₀ ,@es)) ρ)]
    [(cons `(match-e ,es ,C) e₀)
     (unit (cons C `(match ,e₀ ,@es)) ρ)]
    [(cons `(ran ,f ,b ,a ,C) e)
     (unit (cons C `(app ,f ,@b ,e ,@a)) ρ)]
    [(cons `(match-clause ,m ,f ,b ,a ,C) e)
     (unit (cons C `(match ,@(cons f (append b (list `(,m ,e)) a)))) ρ)]
    [(cons `(bod ,y ,C) e)
     (unit (cons C `(λ ,y ,e))
           (match ρ
             [(flatenv ρ) (flatenv ρ)]; Regular m-cfa environments don't change (all bindings are rebound in the innermost environment)
             [(expenv (cons _ ρ)) (expenv ρ)]
             [(menv (cons _ ρ)) (menv ρ)]
             [(envenv (cons _ ρ)) (envenv ρ)]
             ))]
    [(cons `(let-bod ,binds ,C) e₁)
     (unit (cons C `(let ,binds ,e₁)) ρ)]
    [(cons `(let-bin ,x ,e₁ ,before ,after ,C) e₀)
     (unit (cons C `(let ,(append before (list `(,x ,e₀)) after) ,e₁)) ρ)]
    [(cons `(top) _)
     (error 'out "top")]))

(define (bin-e Ce ρ i)
  (match Ce
    [(cons C `(let ,binds ,e₁))
     (define before (take binds i))
     (define eqafter (drop binds i))
     (define after (cdr eqafter))
     (define bind (car eqafter))
     (list (cons `(let-bin ,(car bind) ,e₁ ,before ,after ,C) (cadr bind)) ρ)]))

(define (bin Ce ρ i)
  (match Ce
    [(cons C `(let ,binds ,e₁))
     (define before (take binds i))
     (define eqafter (drop binds i))
     (define after (cdr eqafter))
     (define bind (car eqafter))
     ;  (pretty-print bind)
     ;  (pretty-print (car bind))
     ;  (pretty-print (cadr bind))
     (unit (cons `(let-bin ,(car bind) ,e₁ ,before ,after ,C) (cadr bind)) ρ)]))

(define (bod-e Ce ρ)
  (match Ce
    [(cons C `(λ ,x ,e))
     (match ρ
       [(flatenv _) (error 'not-supported "Bod is not supported for regular mcfa (use bod-enter)")]
       [(expenv _) (error 'not-supported "Bod is not supported for regular mcfa (use bod-enter)")]
       [(menv envs) (list (cons `(bod ,x ,C) e) (menv (cons (take-cc `(□? ,x)) envs)))]
       [(envenv envs) (list (cons `(bod ,x ,C) e) (envenv (cons (take-cc `(□? ,x)) envs)))]
       )]
    [(cons C `(let ,binds ,e₁))
     (list (cons `(let-bod ,binds ,C) e₁) ρ)]))

(define (bod Ce ρ)
  (match Ce
    [(cons C `(λ ,x ,e))
     (match ρ
       [(flatenv _) (error 'not-supported "Bod is not supported for regular mcfa (use bod-enter)")]
       [(expenv _) (error 'not-supported "Bod is not supported for regular mcfa (use bod-enter)")]
       [(menv envs) (unit (cons `(bod ,x ,C) e) (menv (cons (take-cc `(□? ,x)) envs)))]
       [(envenv envs) (unit (cons `(bod ,x ,C) e) (envenv (cons (take-cc `(□? ,x)) envs)))]
       )
     ]
    [(cons C `(let ,binds ,e₁))
     (unit (cons `(let-bod ,binds ,C) e₁) ρ)]))

(define (bod-enter Ce call ρ ρ′)
  (match Ce
    [(cons C `(λ ,x ,e))
     ;  (pretty-print `(bod-enter ,ρ′ ,call))
     (match ρ′
       [(flatenv _) (unit (cons `(bod ,x ,C) e) (flatenv (enter-cc call ρ′)))]
       [(expenv _) (unit (cons `(bod ,x ,C) e) (expenv (cons (enter-cc call ρ) (expenv-m ρ′))))]
       [(menv _)  (unit (cons `(bod ,x ,C) e) (menv (cons (enter-cc call ρ) (menv-m ρ′))))]
       [(envenv _)  (unit (cons `(bod ,x ,C) e) (envenv (cons (enter-cc call ρ) (envenv-m ρ′))))]
       )]
    [(cons C `(let ,binds ,e₁))
     ; Environments do not change for let bindings (as long as names do not shadow - which for m-CFA we handle by alphatizing).
     (unit (cons `(let-bod ,binds ,C) e₁) ρ)]))

(define (rat-e Ce ρ)
  (match Ce
    [(cons C `(app ,f ,@es))
     (list (cons `(rat ,es ,C) f) ρ)]))

(define (rat Ce ρ)
  (match Ce
    [(cons C `(app ,f ,@es))
     (unit (cons `(rat ,es ,C) f) ρ)]))

(define (focus-match-e Ce ρ)
  (match Ce
    [(cons C `(match ,m ,@ms))
     (list (cons `(match-e ,ms ,C) m) ρ)]
    ))

(define (focus-match Ce ρ)
  (match Ce
    [(cons C `(match ,m ,@ms))
     (unit (cons `(match-e ,ms ,C) m) ρ)]
    ))

(define (focus-clause-e Ce ρ i)
  (match Ce
    [(cons C `(match ,m ,@matches))
     (define prev-ms (take matches i))
     (define after-ms (drop matches i))
     (define mat (car after-ms))
     (list (cons `(match-clause ,(car mat) ,m ,prev-ms ,(cdr after-ms) ,C) (cadr mat)) ρ)]
    ))

(define (focus-clause Ce ρ i)
  (match Ce
    [(cons C `(match ,m ,@matches))
     (define prev-ms (take matches i))
     (define after-ms (drop matches i))
     (define mat (car after-ms))
     ;  (pretty-print after-ms)
     (unit (cons `(match-clause ,(car mat) ,m ,prev-ms ,(cdr after-ms) ,C) (cadr mat)) ρ)]
    ))

(define (args-e Ce)
  (match Ce
    [(cons _ `(app ,_ ,@args))
     args]))

(define (ran-e Ce ρ i)
  (match Ce
    [(cons C `(app ,f ,@args))
     (define prev-args (take args i))
     (define after-args (drop args i))
     (list (cons `(ran ,f ,prev-args ,(cdr after-args) ,C) (car after-args)) ρ)]))

(define (ran Ce ρ i)
  ; (pretty-print `(ran ,i))
  (match Ce
    [(cons C `(app ,f ,@args))
     (define prev-args (take args i))
     (define after-args (drop args i))
     ;  (pretty-print after-args)
     (unit (cons `(ran ,f ,prev-args ,(cdr after-args) ,C) (car after-args)) ρ)]))

(define (out-arg Ce ρ i)
  (>>= (out Ce ρ #t)
       (λ (Ce ρ)
         (ran Ce ρ i))
       )
  )

(define (gen-queries Ce ρ)
  (define self-query (list Ce ρ))
  (define child-queries (match Ce
                          [(cons _ `(app ,_ ,@args))
                           (foldl append (list)
                                  (cons (apply gen-queries (rat-e Ce ρ))
                                        (map (λ (i)
                                               (apply gen-queries (ran-e Ce ρ i)))
                                             (range (length args)))))]
                          [(cons _ `(λ ,_ ,_))
                           (apply gen-queries (bod-e Ce ρ))]
                          [(cons _ `(let ,binds ,_))
                           (foldl append (list)
                                  (cons (apply gen-queries (bod-e Ce ρ))
                                        (map (λ (i)
                                               (apply gen-queries (bin-e Ce ρ i)))
                                             (range (length binds)))))
                           ]
                          [(cons _ `(match ,_ ,@ms))
                           (foldl append (list)
                                  (cons (apply gen-queries (focus-match-e Ce ρ))
                                        (map (λ (i)
                                               (apply gen-queries (focus-clause-e Ce ρ i)))
                                             (range (length ms)))))]
                          [_ (list)]))
  (cons self-query child-queries))


; calling contexts

; Can the environment be refined further?
(define cc-determined?
  (match-lambda
    [(list) #t]
    ['! #t] ; Cut known
    ['? #t] ; Cut unknown (can be reinstantiated to an indeterminate context)
    [`(□? ,_) #f]
    [`(cenv ,Ce ,ρ) (alls (map cc-determined? (envenv-m ρ)))]
    [(cons Ce cc) (cc-determined? cc)]))

(define (take-cc cc)
  (take-ccm (current-m) cc))

(define (take-ccm m cc)
  (if (zero? m)
      (match (analysis-kind)
        ['hybrid
         (match cc
           [(list) (list)]; Already 0
           [`(cenv ,_ ,_) '!]; Cut known
           ['! '!]
           ['? '?]
           [`(□? ,_) '?]; Cut unknown -- TODO: Can we leave the variable since it terminates anyways, and will be reinstantiate to the same thing?
           [`(cons _ _) (error 'bad-env "Invalid environment for hybrid")]; Cut known
           )]
        [_ (list)]; Handles regular/exponential m-CFA and basic Demand m-CFA which just terminate the call string
        )
      (match cc
        [(list)
         (list)]
        ['! '!] ; Cut known
        ['? '?] ; Cut unknown (can be reinstantiated to an indeterminate context)
        [`(□? ,x)
         `(□? ,x)]
        [`(cenv ,Ce ,ρ)
         `(cenv ,Ce ,(envenv (map (λ (cc) (take-ccm (- m 1) cc)) (envenv-m ρ))))]
        [(cons Ce cc); This case handles regular/exponential m-CFA and basic Demand m-CFA call strings
         (cons Ce (take-ccm (- m 1) cc))])))

(define (head-cc ρ)
  (match (split-env ρ)
    [(cons h t) h]
    [x '()]
    )
  )

(define (enter-cc Ce ρ)
  (match ρ
    [(menv p) (take-cc (cons Ce (head-cc ρ)))]
    [(envenv p) (take-cc `(cenv ,Ce ,ρ))]
    [(expenv p) (take-cc (cons Ce (head-cc ρ)))]
    [(flatenv calls) (take-cc (cons Ce calls))]; Basic m-CFA doesn't
    )
  )

(define (indeterminate-env Ce)
  (match Ce
    [(cons `(bod ,y ,C) e)
     (cons `(□? ,y) (indeterminate-env (cons C e)))]
    [(cons `(top) _)
     (list)]
    [_
     (indeterminate-env (oute Ce))]
    ))

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

(define (calibrate-ccs cc0 cc1)
  (match cc0
    [(list) (list)]
    ['! #f]
    ['? cc1]
    [`(□? ,x) `(□? ,x)]
    [`(cenv ,call ,ρ₀)
     (match (calibrate-envs ρ₀ (envenv (indeterminate-env call)))
       [#f #f]
       [res `(cenv ,call ,res)]
       )]
    )
  )

; Adds missing context
(define (calibrate-envs ρ₀ ρ₁)
  ; (pretty-print `(calibrating-envs ,ρ₀ ,ρ₁))
  (let [(res (map calibrate-ccs (envenv-m ρ₀) (envenv-m ρ₁)))]
    (if (alls res) (envenv res) #f)
    ))

(define (simple-env ρ)
  ; (pretty-print `(simple-env ρ))
  (map simple-call-env (env-list ρ)))

(define (simple-call-env cc)
  ; (pretty-print `(simple-call-env ,cc))
  (match cc
    [(list)
     (list)]
    ['! (list)] ; Cut known
    ['? (list)] ; Cut unknown (can be reinstantiated to an indeterminate context)
    [`(□? ,x)
     `(□? ,x)]
    [`(cenv ,Ce ,ρ)
     ;  (pretty-print `(simplifying ,Ce ,ρ))
     (cons Ce (simple-call-env (head-cc ρ)))]
    [(cons Ce cc)
     (cons Ce cc)]
    )
  )

; Is cc0 more refined or equal to cc1?
;  i.e. should an environment with cc1 be instantiate to replace cc1 with cc0?
(define (⊑-cc cc₀ cc₁)
  (match cc₀
    [(list)
     (match cc₁
       [(list) #t] ; equal
       ['? #f]
       ['! #f]
       [`(□? ,_) #f]
       [`(cenv ,Ce ,ρ) #f]
       [(cons _ _) #f])]
    ['!
     (match cc₁
       ['! #t]; cut unknown is equal
       [(list) #f]; cut is not more refined
       ['? #t]; cut known is more refined
       [`(□? ,_) #f]; cut is not more refined
       [`(cenv ,Ce ,ρ) #f]; cut is not more refined
       [(cons _ _) #f])]; cut is not more refined
    ['?
     (match cc₁
       ['? #t]; cut known is equal
       ['! #f]; cut unknown is not more refined (it is but we don't need to run under unknown if we know)
       [(list) #f]; cut is not more refined
       [`(□? ,_) #f]; cut is not more refined
       [`(cenv ,Ce ,ρ) #f]; cut is not more refined
       [(cons _ _) #f])]; cut is not more refined
    [`(□? ,x)
     (match cc₁
       [(list) #f]; indeterminate is not more refined
       ['! #f]; indeterminate is more refined - we know more
       ['? #t]; indeterminate is more refined - we know the variables
       [`(□? ,y) (equal? x y)]; indeterminate is equal if they are equal otherwise false
       [`(cenv ,Ce ,ρ) #f]; indeterminate is not more refined
       [(cons _ _) #f])]
    [`(cenv ,Ce₀ ,ρ₀)
     (match cc₁
       [(list) #f]; call-env is not more refined
       ['! #t]; call-env is more refined
       ['? #t]; call-env is more refined
       [`(□? ,_) #t]; call-env is more refined
       [`(cenv ,Ce₁ ,ρ₁)
        (and (equal? Ce₀ Ce₁)
             (alls (map ⊑-cc (envenv-m ρ₀) (envenv-m ρ₁))))]
       )]
    [(cons Ce₀ cc₀)
     (match cc₁
       [(list) #f]
       ['! #t]
       ['? #t]
       [`(□? ,_) #t]
       [(cons Ce₁ cc₁)
        (and (equal? Ce₀ Ce₁)
             (⊑-cc cc₀ cc₁))])]))
