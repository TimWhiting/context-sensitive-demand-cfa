#lang racket/base
(require racket/match racket/pretty racket/list racket/set)
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
    [(? number? x) (set)]
    [(? string? x) (set)]
    [(? char? x) (set)]
    [#f (set)]
    [#t (set)]
    [(? symbol? x) (set x)]
    ['() (set)]
    [`',x (set)]
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