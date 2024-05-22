#lang s-exp "../lang/simple-scheme.rkt"




; substitute : alist[var,exp] exp -> exp
(define (substitute env exp)

  (define (substitute-with env)
    (lambda (exp)
      (substitute env exp)))

  (cond
    ; Core forms:
    ; ((null? env)        exp)
    ; ((const? exp)       exp)
    ; ((prim? exp)        exp)
    ; ((ref? exp)         (substitute-var env exp))
    ; ((lambda? exp)      `(lambda ,(lambda->formals exp)
    ;                        ,(substitute (assq-remove-keys env (lambda->formals exp))
    ;                                     (lambda->exp exp))))
    ; ((set!? exp)        `(set! ,(substitute-var env (set!->var exp))
    ;                            ,(substitute env (set!->exp exp))))
    ; ((if? exp)          `(if ,(substitute env (if->condition exp))
    ;                          ,(substitute env (if->then exp))
    ;                          ,(substitute env (if->else exp))))

    ; Sugar:
    ((let? exp)         `(let ,(azip (let->bound-vars exp)
                                     (map (substitute-with env) (let->args exp)))
                           ,(substitute (assq-remove-keys env (let->bound-vars exp))
                                        (let->exp exp))))
    ; ((letrec? exp)      (let ((new-env (assq-remove-keys env (letrec->bound-vars exp))))
    ;                       `(letrec ,(azip (letrec->bound-vars exp)
    ;                                       (map (substitute-with new-env)
    ;                                            (letrec->args exp)))
    ;                          ,(substitute new-env (letrec->exp exp)))))
    ; ((begin? exp)       (cons 'begin (map (substitute-with env) (begin->exps exp))))

    ; IR (1):
    ; ((cell? exp)        `(cell ,(substitute env (cell->value exp))))
    ; ((cell-get? exp)    `(cell-get ,(substitute env (cell-get->cell exp))))
    ; ((set-cell!? exp)   `(set-cell! ,(substitute env (set-cell!->cell exp))
    ;                                 ,(substitute env (set-cell!->value exp))))

    ; ; IR (2):
    ; ((closure? exp)     `(closure ,(closure->lam exp) ,(closure->env exp)))
    ((env-make? exp)    `(env-make ,(env-make->id exp)
                                   ,@(azip (env-make->fields exp)
                                           (map (substitute-with env)
                                                (env-make->values exp)))))
    ; ((env-get? exp)     `(env-get ,(env-get->id exp)
    ;                               ,(env-get->field exp)
    ;                               ,(substitute env (env-get->env exp))))

    ; Application:
    ((app? exp)         (map (substitute-with env) exp))
    (else               (error "unhandled expression type in substitution: " exp))))



