#lang racket/base
(require racket/match racket/pretty racket/list racket/set "syntax.rkt")
(provide (all-defined-out))

(define (translate-top-defs-out . ss)
  (define result ((translate-top-defs-internal #t) ss))
  ; (pretty-print result)
  result
  )

(define (is-lam-def d)
  (match d
    [`(define ,id (λ ,xs ,bod)) #t]
    [_ #f])
  )

(define (is-def d)
  (match d
    [`(define ,id ,expr) #t]
    [_ #f])
  )

(define (to-let-bind d)
  (match d
    [`(define ,id ,expr) `(,id ,expr)]
    [_ d]
    ))

(define (to-begin exprs)
  (match exprs
    ['() `(app void)]
    [(list e) e]
    [(cons e es) `(let ((_ ,e)) ,(to-begin es))]
    )
  )

(define (remove-def-types xss)
  (match xss
    ['() '()]
    [(cons `(app ,nm : ,tp) xs) (remove-def-types xs)]
    [(cons `(app define-type ,tp ,@body) xs) (remove-def-types xs)]
    [(cons `(app define-type-alias ,tp ,@body) xs) (remove-def-types xs)]
    [(cons x xs) (cons x (remove-def-types xs))]
    )
  )

(define (get-types xss)
  (match xss
    ['() (list '() '())]
    [(cons `(app define-type ,tp ,@body) xs)
     ;  (pretty-print (car xss))
     ;  (pretty-print body)
     (match-let ([(list fns tps) (get-tps body)]
                 [(list fnss tpss) (get-types xs)])
       (list (append fns fnss) (append tps tpss))
       )
     ]
    [(cons x xs) (get-types xs)]
    ))

(define (get-common-types already-defined)
  (list
   (filter (λ (item)
             (empty?
              (filter
               (λ (def)
                 (match def
                   [`(define ,id ,_) (equal? (car item) id)]
                   )
                 ) already-defined)))
           (list
            (list 'car
                  `(λ (car-v)
                     (match car-v
                       [(cons car-c car-d) car-c])
                     )
                  )
            (list 'cdr
                  `(λ (cdr-v)
                     (match cdr-v
                       [(cons cdr-c cdr-d) cdr-d])
                     )
                  )
            (list 'cadr
                  `(λ (cadr-v)
                     (app car (app cdr cadr-v))
                     )
                  )
            (list 'caddr
                  `(λ (cadr-v)
                     (app car (app cdr (app cdr cadr-v)))
                     )
                  )
            (list 'map
                  `(λ (map-f map-l)
                     (match map-l
                       [(cons map-c map-d) (app cons (app map-f map-c) (app map map-f map-d))]
                       [(nil) (app nil)]
                       )
                     )
                  )
            (list 'length
                  `(λ (length-l)
                     (match length-l
                       [(cons length-c length-d) (app + 1 (app length length-d))]
                       [(nil) 0]
                       )
                     )
                  )
            (list 'pair?
                  `(λ (pair?-v)
                     (match pair?-v
                       [(cons pair?-c pair?-d) (app #t)]
                       [_ (app #f)])
                     )
                  )
            (list 'null?
                  `(λ (null?-v)
                     (match null?-v
                       [(nil) (app #t)]
                       [_ (app #f)])
                     )
                  )
            ))
   (list `(cons car cdr) `(nil) `(error r)))
  )

(define (get-tps tps)
  (match tps
    ['() (list '() '())]
    [(cons `(app ,nm ,@args) tps)
     ;  (pretty-print `(,nm ,args))
     (define as (map remove-tp args))
     ;  (pretty-print `(,nm ,as))
     (match-let ([(list dfs tps) (get-tps tps)]
                 [fns (gen-type-arg-funcs nm as 0 (length args))])
       ;  (pretty-print fns)
       (list (append dfs fns) (cons `(,nm ,@as) tps))
       )
     ]
    ))

(define (gen-type-arg-funcs nm args i n)
  (match args
    ['() (list (list (string->symbol (string-append (symbol->string nm) "?"))
                     `(λ (a)
                        (match a
                          [(,nm ,@(map (λ (_) '_) (range n))) (app #t)]
                          [_ (app #f)]
                          ))))]
    [(cons a as)
     (define name (string-append (symbol->string nm) "-" (symbol->string a)))
     (define match-name (string-append name "-v"))
     (define select-name (string-append name "-x"))
     (cons (list (string->symbol name)
                 `(λ (,(string->symbol match-name))
                    (match ,(string->symbol match-name)
                      [(,nm ,@(map (λ (ix) (if (= i ix) (string->symbol select-name) '_)) (range n))) ,(string->symbol select-name)]
                      [_ (app error ,(format "invalid match for ~a-~a" nm a))]
                      )))
           (gen-type-arg-funcs nm as (+ 1 i) n))]))

(define (remove-tp tp)
  (match tp
    [`(app ,nm : ,tp) nm]
    [x x]
    ))


(define (translate-top-defs ss)
  ((translate-top-defs-internal #f) ss)
  )

(define ((translate-top-defs-internal top) ss)
  ; (pretty-print `(translate-top-defs ,ss))
  (define tops-full-defs (if top (map (translate-top #t) ss) (map (translate-top) ss)))
  ; (pretty-print `(translate-top-defs ,tops-full-defs))
  (define tops (remove-def-types tops-full-defs))
  (define exprs (filter (lambda (d) (not (is-def d))) tops))
  (define all-defs (filter is-def tops))
  (define all-binds (map to-let-bind all-defs))
  ; (define rec-defs (filter is-lam-def all-defs))
  ; (define other-defs (filter (lambda (x) (not (is-lam-def x))) all-defs))
  ; (define rec-binds (map to-let-bind rec-defs))
  ; (define other-binds (map to-let-bind other-defs))

  ; (pretty-print `(translate-top-defs ,tops))
  (match-let ([(list top-type-defs top-types) (get-types tops-full-defs)]
              [(list common-type-defs common-types) (if top (get-common-types all-defs) (list '() '()) )]
              )
    ; (if (empty? top-type-defs) '() (pretty-print top-type-defs))
    ; (if (empty? common-type-defs) '() (pretty-print common-type-defs))
    (define bodies (append exprs (map cadr all-binds)))
    (define fvs (if (empty? bodies) (set) (apply set-union (map free-vars bodies))))
    ; (pretty-print fvs)
    (define used (filter (lambda (td)
                           (match td
                             [`(,nm ,_) (set-member? fvs nm)]
                             )) (append top-type-defs common-type-defs)))
    (define used-types (filter (lambda (td)
                                 (match td
                                   [`(,nm ,@_) (set-member? fvs nm)]
                                   )) (append common-types top-types)))
    (make-type-defs used-types (make-let-recstar (append used all-binds) (to-begin exprs)))
    ))


(define (translate-top-defs-expr expr ss)
  ; (pretty-print `(translate-top-defs-expr ,ss))
  (define tops-full-defs (map (translate-top) ss))
  (define tops (remove-def-types tops-full-defs))
  (define binds (map to-let-bind (filter is-def tops)))
  ; (pretty-print `(translate-top-defs ,expr))
  (match-let ([(list top-type-defs top-types) (get-types tops-full-defs)])
    ; (if (empty? top-type-defs) '() (pretty-print top-type-defs))
    (define fvs (apply set-union (free-vars (cons expr (map cadr binds)))))
    ; (pretty-print fvs)
    (define used (filter (lambda (td)
                           (match td
                             [`(,nm ,@_) (set-member? fvs nm)]
                             )) top-type-defs))
    (make-type-defs top-types (make-let-recstar (append used binds) expr))
    ))

(define (make-type-defs tps body)
  (match tps
    ['() body]
    [tps `(lettypes ,tps ,body)]
    ))

(define (make-let-recstar binds expr)
  (match binds
    ['() expr]
    [(cons _ _) `(letrec* ,binds ,expr)]
    ))

(define (make-let-rec binds expr)
  (match binds
    ['() expr]
    [(cons _ _) `(letrec ,binds ,expr)]
    ))

(define (make-let-star binds expr)
  (match binds
    ['() expr]
    [(cons _ _) `(let* ,binds ,expr)]
    ))

(define ((translate-top [top #f]) s)
  (match (translate s)
    [`(app ,e) (if top e `(app ,e))]
    [e e]
    )
  )

(define (translate-def d)
  (match d
    [`(,x ,e) `(,x ,(translate e))]
    )
  )

(define (translate s)
  ; (pretty-print `(translate ,s))
  (match s
    [#f `(app #f)]
    [#t `(app #t)]
    [(? number? x) x]
    [(? symbol? x) x]
    [(? string? x) x]
    [(? char? x) x]
    [`(λ (,@args) ,@es)
     ;  (pretty-print `(translate-bod ,es))
     `(λ (,@(remove-types args)) ,(translate-top-defs es))]
    [`(lambda (,@args) ,@es) `(λ (,@(remove-types args)) ,(translate-top-defs es))]
    [`(local ,defs ,@es) (translate-top-defs-expr (translate-top-defs es) defs)]
    [`(letrec ,defs ,@es) `(letrec ,(map translate-def defs) ,(translate-top-defs es))]
    [`(let ,(and loop (? symbol? loop)) ,defs ,@es)
     (pretty-print `(,loop ,(map car defs) ,(map cadr defs) ,(translate-top-defs es)))
     (pretty-print `(letrec (,loop (λ ,(map car defs) ,(translate-top-defs es))) (app ,loop ,@(map cadr defs))))
     `(letrec ((,loop (λ ,(map car defs) ,(translate-top-defs es)))) (app ,loop ,@(map cadr defs)))]
    [`(let ,defs ,@es) `(let ,(map translate-def defs) ,(translate-top-defs es))]
    [`(let* ,defs ,@es) `(let* ,(map translate-def defs) ,(translate-top-defs es))]
    [`(if ,c ,t ,f) `(match ,(translate c) [(#f) ,(translate f)] [_ ,(translate t)] )]
    [`(if ,c ,t) `(match ,(translate c) [(#f) (app void)] [_ ,(translate t)] )]
    [`(cond ,@mchs) (unwrap-cond mchs)]
    [`(match ,c ,@mchs) `(match ,(translate c) ,@(map unwrap-match mchs))]
    [`(type-case ,tp ,c ,@mchs)
     ;  (pretty-print `(translate-type-case ,@mchs))
     `(match ,(translate c) ,@(map unwrap-match mchs))]
    [`(case ,sc ,@branches) `(match ,(translate sc) ,@(map unwrap-case branches))]
    [`(define (,id ,@args) : ,returntype ,@exprs) `(define ,id (λ (,@(remove-types args)) ,(translate-top-defs exprs)))]
    [`(define (,id ,@args) ,@exprs)
     ;  (pretty-print `(translate-define ,exprs))
     `(define ,id (λ (,@(remove-types args)) ,(translate-top-defs exprs)))]
    [`(define ,id ,expr)
     ;  (pretty-print `(translate-def ,expr))
     `(define ,id ,(translate expr))]
    [`(begin ,@exprs) (to-begin (map translate exprs))]
    [`(list ,a ,@as) `(app cons ,(translate a) ,(translate `(list ,@as)))]
    [`(list) `(app nil)]
    [`(quote ,(? number? x)) x]
    [`(quote ,(? char? x)) x]
    [`(quote ,(? string? x)) x]
    [`(quote ,ls) (desugar-quote ls)]
    [`(quasiquote ,@ls) (desugar-qq 1 ls)]
    [`(,@es)
     ;  (pretty-print `(app ,es))
     `(app ,@(map translate es))]
    )
  )

(define (desugar-qq n qq-exp)
  (match qq-exp
    [(list 'unquote exp)
     (if (= n 1)
         (translate exp)
         (list 'app 'list ''unquote
               (desugar-qq (- n 1) exp)))]

    [`(quasiquote ,qq-exp)
     `(list 'quasiquote ,(desugar-qq (+ n 1) qq-exp))]

    [(cons (list 'unquote-splicing exp) rest)
     (if (= n 1)
         `(app append ,(translate exp) ,(desugar-qq n rest))
         (cons (list 'unquote-splicing (desugar-qq (- n 1) exp))
               (desugar-qq n rest)))]

    [`(,qq-exp1 . ,rest)
     `(app cons ,(desugar-qq n qq-exp1)
           ,(desugar-qq n rest))]
    [else
     (desugar-quote qq-exp)])
  )

(define (desugar-quote l)
  (match l
    ['() `(app nil)]
    [(cons x xs)
     `(app cons ,(translate `',x) ,(desugar-quote xs))]
    [(? string? s) s]
    [(? number? n) n]
    [(? boolean? b) b]
    [(? symbol? x)
     ;  (pretty-print `(quoting ,x as ',x))
     `',x]
    )
  )

(define (expand-datum l)
  (match l
    ['() `(nil)]
    [`(,x ,@xs) `(cons ,(expand-datum x) ,@(map expand-datum xs))]
    [x
     ;  (pretty-print `(quoting ,x as ',x))
     `',x]
    )
  )

(define (remove-types args)
  (match args
    [(cons a as) (cons (remove-type a) (remove-types as))]
    ['() '()]
    [x x]
    ))

(define (remove-type a)
  (match a
    [`(,name : ,type) name]
    [x x]
    )
  )

(define (unwrap-match mch)
  (match mch
    [`(,(? symbol? c) ,@es) `((,c) ,(translate-top-defs es))]
    [`(,c ,@es)
     `(,c ,(translate-top-defs es))]
    ))

(define (unwrap-cond mchs)
  (match mchs
    ['() `(app error "no-match")]
    [(list `(else ,@es)) (translate-top-defs es)]
    [(cons `(,c) xs)
     `(match ,(translate c)
        [(#f) ,(unwrap-cond xs)]
        [c-x c-x]
        )]
    [(cons `(,c ,@es) xs)
     `(match ,(translate c)
        [(#f) ,(unwrap-cond xs)]
        [_ ,(translate-top-defs es)]
        )]))

(define (unwrap-case branch)
  (match branch
    [`(,datum ,@bd) `(,(expand-datum datum) ,(translate-top-defs bd))]
    )
  )
