'(expression:
  (lettypes
   ((cons car cdr) (nil) (error r))
   (letrec*
    ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
     (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
     (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
     (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
     (map
      (λ (map-f map-l)
        (match
         map-l
         ((cons map-c map-d)
          (app cons (app map-f map-c) (app map map-f map-d)))
         ((nil) (app nil)))))
     (pair?
      (λ (pair?-v)
        (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
     (null? (λ (null?-v) (match null?-v ((nil) (app #t)) (_ (app #f)))))
     (cadr (λ (p) (app car (app cdr p))))
     (cddr (λ (p) (app cdr (app cdr p))))
     (caadr (λ (p) (app car (app car (app cdr p)))))
     (caddr (λ (p) (app car (app cdr (app cdr p)))))
     (cadddr (λ (p) (app car (app cdr (app cdr (app cdr p))))))
     (map
      (λ (f lst)
        (match
         (app pair? lst)
         ((#f) (app nil))
         (_ (app cons (app f (app car lst)) (app map f (app cdr lst)))))))
     (for-each
      (λ (f lst)
        (let ((_
               (match
                (app pair? lst)
                ((#f) (app nil))
                (_
                 (app cons (app f (app car lst)) (app map f (app cdr lst)))))))
          (app void))))
     (append
      (λ (lst1 lst2)
        (match
         (app not (app pair? lst1))
         ((#f) (app cons (app car lst1) (app append (app cdr lst1) lst2)))
         (_ lst2))))
     (string->list
      (λ (s)
        (letrec*
         ((f
           (λ (i)
             (match
              (app < i (app string-length s))
              ((#f) (app nil))
              (_ (app cons (app string-ref s i) (app f (app + i 1))))))))
         (app f 0))))
     (apply
      (λ (f l)
        (let ((len (app length l)))
          (match
           (app = len 0)
           ((#f)
            (match
             (app = len 1)
             ((#f)
              (match
               (app = len 2)
               ((#f)
                (match
                 (app = len 3)
                 ((#f)
                  (match
                   (app = len 4)
                   ((#f) (app error "no-match"))
                   (_
                    (app
                     f
                     (app car l)
                     (app cadr l)
                     (app caddr l)
                     (app cadddr l)))))
                 (_ (app f (app car l) (app cadr l) (app caddr l)))))
               (_ (app f (app car l) (app cadr l)))))
             (_ (app f (app car l)))))
           (_ (app f))))))
     (assv
      (λ (x f)
        (match
         (app pair? f)
         ((#f) (app #f))
         (_
          (match
           (app eqv? (app car (app car f)) x)
           ((#f) (app assv x (app cdr f)))
           (_ (app car f)))))))
     (assq
      (λ (x f)
        (match
         (app pair? f)
         ((#f) (app #f))
         (_
          (match
           (app eq? (app car (app car f)) x)
           ((#f) (app assv x (app cdr f)))
           (_ (app car f)))))))
     (void (λ () (match (app #f) ((#f) (app void)) (_ (app #t)))))
     (tagged-list?
      (λ (tag l) (app and (app pair? l) (app eq? tag (app car l)))))
     (char->natural
      (λ (c)
        (let ((i (app char->integer c)))
          (match (app < i 0) ((#f) (app + (app * 2 i) 1)) (_ (app * -2 i))))))
     (integer->char-list (λ (n) (app string->list (app number->string n))))
     (gensym-count 0)
     (gensym
      (λ (name)
        (let ((_ (app set! gensym-count (app + gensym-count 1))))
          (app
           string->symbol
           (app
            string-append
            (match
             (app symbol? name)
             ((#f) name)
             (_ (app symbol->string name)))
            "$"
            (app number->string gensym-count))))))
     (member
      (λ (sym S)
        (match
         (app not (app pair? S))
         ((#f)
          (match
           (app eq? sym (app car S))
           ((#f) (app member sym (app cdr S)))
           (_ (app #t))))
         (_ (app #f)))))
     (symbol<?
      (λ (sym1 sym2)
        (app string<? (app symbol->string sym1) (app symbol->string sym2))))
     (insert
      (λ (sym S)
        (match
         (app not (app pair? S))
         ((#f)
          (match
           (app eq? sym (app car S))
           ((#f)
            (match
             (app symbol<? sym (app car S))
             ((#f) (app cons (app car S) (app insert sym (app cdr S))))
             (_ (app cons sym S))))
           (_ S)))
         (_ (app cons sym (app nil))))))
     (remove
      (λ (sym S)
        (match
         (app not (app pair? S))
         ((#f)
          (match
           (app eq? (app car S) sym)
           ((#f) (app cons (app car S) (app remove sym (app cdr S))))
           (_ (app cdr S))))
         (_ (app nil)))))
     (union
      (λ (set1 set2)
        (match
         (app not (app pair? set1))
         ((#f) (app insert (app car set1) (app union (app cdr set1) set2)))
         (_ set2))))
     (difference
      (λ (set1 set2)
        (match
         (app not (app pair? set2))
         ((#f)
          (app difference (app remove (app car set2) set1) (app cdr set2)))
         (_ set1))))
     (reduce
      (λ (f lst init)
        (match
         (app not (app pair? lst))
         ((#f) (app reduce f (app cdr lst) (app f (app car lst) init)))
         (_ init))))
     (azip
      (λ (list1 list2)
        (match
         (app and (app pair? list1) (app pair? list2))
         ((#f) (app nil))
         (_
          (app
           cons
           (app cons (app car list1) (app cons (app car list2) (app nil)))
           (app azip (app cdr list1) (app cdr list2)))))))
     (assq-remove-key
      (λ (env key)
        (match
         (app not (app pair? env))
         ((#f)
          (match
           (app eq? (app car (app car env)) key)
           ((#f)
            (app cons (app car env) (app assq-remove-key (app cdr env) key)))
           (_ (app assq-remove-key (app cdr env) key))))
         (_ (app nil)))))
     (assq-remove-keys
      (λ (env keys)
        (match
         (app not (app pair? keys))
         ((#f)
          (app
           assq-remove-keys
           (app assq-remove-key env (app car keys))
           (app cdr keys)))
         (_ env))))
     (const? (λ (exp) (app or (app integer? exp) (app boolean? exp))))
     (ref? (λ (exp) (app symbol? exp)))
     (let? (λ (exp) (app tagged-list? 'let exp)))
     (let->bindings (λ (exp) (app cadr exp)))
     (let->exp (λ (exp) (app caddr exp)))
     (let->bound-vars (λ (exp) (app map car (app cadr exp))))
     (let->args (λ (exp) (app map cadr (app cadr exp))))
     (letrec? (λ (exp) (app tagged-list? 'letrec exp)))
     (letrec->bindings (λ (exp) (app cadr exp)))
     (letrec->exp (λ (exp) (app caddr exp)))
     (letrec->bound-vars (λ (exp) (app map car (app cadr exp))))
     (letrec->args (λ (exp) (app map cadr (app cadr exp))))
     (lambda? (λ (exp) (app tagged-list? 'lambda exp)))
     (lambda->formals (λ (exp) (app cadr exp)))
     (lambda->exp (λ (exp) (app caddr exp)))
     (if? (λ (exp) (app tagged-list? 'if exp)))
     (if->condition (λ (exp) (app cadr exp)))
     (if->then (λ (exp) (app caddr exp)))
     (if->else (λ (exp) (app cadddr exp)))
     (app? (λ (exp) (app pair? exp)))
     (app->fun (λ (exp) (app car exp)))
     (app->args (λ (exp) (app cdr exp)))
     (prim?
      (λ (exp)
        (app
         or
         (app eq? exp '+)
         (app eq? exp '-)
         (app eq? exp '*)
         (app eq? exp '=)
         (app eq? exp 'display))))
     (begin? (λ (exp) (app tagged-list? 'begin exp)))
     (begin->exps (λ (exp) (app cdr exp)))
     (set!? (λ (exp) (app tagged-list? 'set! exp)))
     (set!->var (λ (exp) (app cadr exp)))
     (set!->exp (λ (exp) (app caddr exp)))
     (closure? (λ (exp) (app tagged-list? 'closure exp)))
     (closure->lam (λ (exp) (app cadr exp)))
     (closure->env (λ (exp) (app caddr exp)))
     (env-make? (λ (exp) (app tagged-list? 'env-make exp)))
     (env-make->id (λ (exp) (app cadr exp)))
     (env-make->fields (λ (exp) (app map car (app cddr exp))))
     (env-make->values (λ (exp) (app map cadr (app cddr exp))))
     (env-get? (λ (exp) (app tagged-list? 'env-get exp)))
     (env-get->id (λ (exp) (app cadr exp)))
     (env-get->field (λ (exp) (app caddr exp)))
     (env-get->env (λ (exp) (app cadddr exp)))
     (set-cell!? (λ (exp) (app tagged-list? 'set-cell! exp)))
     (set-cell!->cell (λ (exp) (app cadr exp)))
     (set-cell!->value (λ (exp) (app caddr exp)))
     (cell? (λ (exp) (app tagged-list? 'cell exp)))
     (cell->value (λ (exp) (app cadr exp)))
     (cell-get? (λ (exp) (app tagged-list? 'cell-get exp)))
     (cell-get->cell (λ (exp) (app cadr exp)))
     (substitute-var
      (λ (env var)
        (let ((sub (app assq var env)))
          (match sub ((#f) var) (_ (app cadr sub))))))
     (substitute
      (λ (env exp)
        (letrec*
         ((substitute-with (λ (env) (λ (exp) (app substitute env exp)))))
         (match
          (app null? env)
          ((#f)
           (match
            (app const? exp)
            ((#f)
             (match
              (app prim? exp)
              ((#f)
               (match
                (app ref? exp)
                ((#f)
                 (match
                  (app lambda? exp)
                  ((#f)
                   (match
                    (app set!? exp)
                    ((#f)
                     (match
                      (app if? exp)
                      ((#f)
                       (match
                        (app let? exp)
                        ((#f)
                         (match
                          (app letrec? exp)
                          ((#f)
                           (match
                            (app begin? exp)
                            ((#f)
                             (match
                              (app cell? exp)
                              ((#f)
                               (match
                                (app cell-get? exp)
                                ((#f)
                                 (match
                                  (app set-cell!? exp)
                                  ((#f)
                                   (match
                                    (app closure? exp)
                                    ((#f)
                                     (match
                                      (app env-make? exp)
                                      ((#f)
                                       (match
                                        (app env-get? exp)
                                        ((#f)
                                         (match
                                          (app app? exp)
                                          ((#f)
                                           (app
                                            error
                                            "unhandled expression type in substitution: "
                                            exp))
                                          (_
                                           (app
                                            map
                                            (app substitute-with env)
                                            exp))))
                                        (_
                                         (app
                                          cons
                                          (app
                                           cons
                                           'env-get
                                           (app
                                            cons
                                            (app env-get->id exp)
                                            (app
                                             cons
                                             (app env-get->field exp)
                                             (app
                                              cons
                                              (app
                                               substitute
                                               env
                                               (app env-get->env exp))
                                              (app nil)))))
                                          (app nil)))))
                                      (_
                                       (app
                                        cons
                                        (app
                                         cons
                                         'env-make
                                         (app
                                          cons
                                          (app env-make->id exp)
                                          (app
                                           append
                                           (app
                                            azip
                                            (app env-make->fields exp)
                                            (app
                                             map
                                             (app substitute-with env)
                                             (app env-make->values exp)))
                                           (app nil))))
                                        (app nil)))))
                                    (_
                                     (app
                                      cons
                                      (app
                                       cons
                                       'closure
                                       (app
                                        cons
                                        (app closure->lam exp)
                                        (app
                                         cons
                                         (app closure->env exp)
                                         (app nil))))
                                      (app nil)))))
                                  (_
                                   (app
                                    cons
                                    (app
                                     cons
                                     'set-cell!
                                     (app
                                      cons
                                      (app
                                       substitute
                                       env
                                       (app set-cell!->cell exp))
                                      (app
                                       cons
                                       (app
                                        substitute
                                        env
                                        (app set-cell!->value exp))
                                       (app nil))))
                                    (app nil)))))
                                (_
                                 (app
                                  cons
                                  (app
                                   cons
                                   'cell-get
                                   (app
                                    cons
                                    (app
                                     substitute
                                     env
                                     (app cell-get->cell exp))
                                    (app nil)))
                                  (app nil)))))
                              (_
                               (app
                                cons
                                (app
                                 cons
                                 'cell
                                 (app
                                  cons
                                  (app substitute env (app cell->value exp))
                                  (app nil)))
                                (app nil)))))
                            (_
                             (app
                              cons
                              'begin
                              (app
                               map
                               (app substitute-with env)
                               (app begin->exps exp))))))
                          (_
                           (let ((new-env
                                  (app
                                   assq-remove-keys
                                   env
                                   (app letrec->bound-vars exp))))
                             (app
                              cons
                              (app
                               cons
                               'letrec
                               (app
                                cons
                                (app
                                 azip
                                 (app letrec->bound-vars exp)
                                 (app
                                  map
                                  (app substitute-with new-env)
                                  (app letrec->args exp)))
                                (app
                                 cons
                                 (app substitute new-env (app letrec->exp exp))
                                 (app nil))))
                              (app nil))))))
                        (_
                         (app
                          cons
                          (app
                           cons
                           'let
                           (app
                            cons
                            (app
                             azip
                             (app let->bound-vars exp)
                             (app
                              map
                              (app substitute-with env)
                              (app let->args exp)))
                            (app
                             cons
                             (app
                              substitute
                              (app
                               assq-remove-keys
                               env
                               (app let->bound-vars exp))
                              (app let->exp exp))
                             (app nil))))
                          (app nil)))))
                      (_
                       (app
                        cons
                        (app
                         cons
                         'if
                         (app
                          cons
                          (app substitute env (app if->condition exp))
                          (app
                           cons
                           (app substitute env (app if->then exp))
                           (app
                            cons
                            (app substitute env (app if->else exp))
                            (app nil)))))
                        (app nil)))))
                    (_
                     (app
                      cons
                      (app
                       cons
                       'set!
                       (app
                        cons
                        (app substitute-var env (app set!->var exp))
                        (app
                         cons
                         (app substitute env (app set!->exp exp))
                         (app nil))))
                      (app nil)))))
                  (_
                   (app
                    cons
                    (app
                     cons
                     'lambda
                     (app
                      cons
                      (app lambda->formals exp)
                      (app
                       cons
                       (app
                        substitute
                        (app assq-remove-keys env (app lambda->formals exp))
                        (app lambda->exp exp))
                       (app nil))))
                    (app nil)))))
                (_ (app substitute-var env exp))))
              (_ exp)))
            (_ exp)))
          (_ exp)))))
     (let=>lambda
      (λ (exp)
        (match
         (app let? exp)
         ((#f) exp)
         (_
          (let ((vars (app map car (app let->bindings exp)))
                (args (app map cadr (app let->bindings exp))))
            (app
             cons
             (app
              cons
              (app
               cons
               'lambda
               (app
                cons
                (app append vars (app nil))
                (app cons (app let->exp exp) (app nil))))
              (app append args (app nil)))
             (app nil)))))))
     (letrec=>lets+sets
      (λ (exp)
        (match
         (app letrec? exp)
         ((#f) (app void))
         (_
          (let* ((bindings (app letrec->bindings exp))
                 (namings
                  (app
                   map
                   (λ (b) (app cons (app car b) (app cons (app #f) (app nil))))
                   bindings))
                 (names (app letrec->bound-vars exp))
                 (sets
                  (app map (λ (binding) (app cons 'set! binding)) bindings))
                 (args (app letrec->args exp)))
            (app
             cons
             (app
              cons
              'let
              (app
               cons
               namings
               (app
                cons
                (app
                 cons
                 'begin
                 (app
                  append
                  (app append sets (app cons (app letrec->exp exp) (app nil)))
                  (app nil)))
                (app nil))))
             (app nil)))))))
     (begin=>let
      (λ (exp)
        (letrec*
         ((singlet? (λ (l) (app and (app list? l) (app = (app length l) 1))))
          (dummy-bind
           (λ (exps)
             (match
              (app singlet? exps)
              ((#f)
               (match
                (app pair? exps)
                ((#f) (app error "no-match"))
                (_
                 (app
                  cons
                  (app
                   cons
                   'let
                   (app
                    cons
                    (app
                     cons
                     (app cons '$_ (app cons (app car exps) (app nil)))
                     (app nil))
                    (app cons (app dummy-bind (app cdr exps)) (app nil))))
                  (app nil)))))
              (_ (app car exps))))))
         (app dummy-bind (app begin->exps exp)))))
     (desugar
      (λ (exp)
        (match
         (app const? exp)
         ((#f)
          (match
           (app prim? exp)
           ((#f)
            (match
             (app ref? exp)
             ((#f)
              (match
               (app lambda? exp)
               ((#f)
                (match
                 (app set!? exp)
                 ((#f)
                  (match
                   (app if? exp)
                   ((#f)
                    (match
                     (app let? exp)
                     ((#f)
                      (match
                       (app letrec? exp)
                       ((#f)
                        (match
                         (app begin? exp)
                         ((#f)
                          (match
                           (app cell? exp)
                           ((#f)
                            (match
                             (app cell-get? exp)
                             ((#f)
                              (match
                               (app set-cell!? exp)
                               ((#f)
                                (match
                                 (app closure? exp)
                                 ((#f)
                                  (match
                                   (app env-make? exp)
                                   ((#f)
                                    (match
                                     (app env-get? exp)
                                     ((#f)
                                      (match
                                       (app app? exp)
                                       ((#f) (app error "unknown exp: " exp))
                                       (_ (app map desugar exp))))
                                     (_
                                      (app
                                       cons
                                       (app
                                        cons
                                        'env-get
                                        (app
                                         cons
                                         (app env-get->id exp)
                                         (app
                                          cons
                                          (app env-get->field exp)
                                          (app
                                           cons
                                           (app env-get->env exp)
                                           (app nil)))))
                                       (app nil)))))
                                   (_
                                    (app
                                     cons
                                     (app
                                      cons
                                      'env-make
                                      (app
                                       cons
                                       (app env-make->id exp)
                                       (app
                                        append
                                        (app
                                         azip
                                         (app env-make->fields exp)
                                         (app
                                          map
                                          desugar
                                          (app env-make->values exp)))
                                        (app nil))))
                                     (app nil)))))
                                 (_
                                  (app
                                   cons
                                   (app
                                    cons
                                    'closure
                                    (app
                                     cons
                                     (app desugar (app closure->lam exp))
                                     (app
                                      cons
                                      (app desugar (app closure->env exp))
                                      (app nil))))
                                   (app nil)))))
                               (_
                                (app
                                 cons
                                 (app
                                  cons
                                  'set-cell!
                                  (app
                                   cons
                                   (app desugar (app set-cell!->cell exp))
                                   (app
                                    cons
                                    (app desugar (app set-cell!->value exp))
                                    (app nil))))
                                 (app nil)))))
                             (_
                              (app
                               cons
                               (app
                                cons
                                'cell-get
                                (app
                                 cons
                                 (app desugar (app cell-get->cell exp))
                                 (app nil)))
                               (app nil)))))
                           (_
                            (app
                             cons
                             (app
                              cons
                              'cell
                              (app
                               cons
                               (app desugar (app cell->value exp))
                               (app nil)))
                             (app nil)))))
                         (_ (app desugar (app begin=>let exp)))))
                       (_ (app desugar (app letrec=>lets+sets exp)))))
                     (_ (app desugar (app let=>lambda exp)))))
                   (_
                    (app
                     cons
                     (app
                      cons
                      'if
                      (app
                       cons
                       (app if->condition exp)
                       (app
                        cons
                        (app if->then exp)
                        (app cons (app if->else exp) (app nil)))))
                     (app nil)))))
                 (_
                  (app
                   cons
                   (app
                    cons
                    'set!
                    (app
                     cons
                     (app set!->var exp)
                     (app cons (app set!->exp exp) (app nil))))
                   (app nil)))))
               (_
                (app
                 cons
                 (app
                  cons
                  'lambda
                  (app
                   cons
                   (app lambda->formals exp)
                   (app cons (app desugar (app lambda->exp exp)) (app nil))))
                 (app nil)))))
             (_ exp)))
           (_ exp)))
         (_ exp))))
     (free-vars
      (λ (exp)
        (match
         (app const? exp)
         ((#f)
          (match
           (app prim? exp)
           ((#f)
            (match
             (app ref? exp)
             ((#f)
              (match
               (app lambda? exp)
               ((#f)
                (match
                 (app if? exp)
                 ((#f)
                  (match
                   (app set!? exp)
                   ((#f)
                    (match
                     (app let? exp)
                     ((#f)
                      (match
                       (app begin? exp)
                       ((#f)
                        (match
                         (app cell-get? exp)
                         ((#f)
                          (match
                           (app cell? exp)
                           ((#f)
                            (match
                             (app set-cell!? exp)
                             ((#f)
                              (match
                               (app closure? exp)
                               ((#f)
                                (match
                                 (app env-make? exp)
                                 ((#f)
                                  (match
                                   (app env-get? exp)
                                   ((#f)
                                    (match
                                     (app app? exp)
                                     ((#f)
                                      (app error "unknown expression: " exp))
                                     (_
                                      (app
                                       reduce
                                       union
                                       (app map free-vars exp)
                                       (app nil)))))
                                   (_ (app free-vars (app env-get->env exp)))))
                                 (_
                                  (app
                                   reduce
                                   union
                                   (app
                                    map
                                    free-vars
                                    (app env-make->values exp))
                                   (app nil)))))
                               (_
                                (app
                                 union
                                 (app free-vars (app closure->lam exp))
                                 (app free-vars (app closure->env exp))))))
                             (_
                              (app
                               union
                               (app free-vars (app set-cell!->cell exp))
                               (app free-vars (app set-cell!->value exp))))))
                           (_ (app free-vars (app cell->value exp)))))
                         (_ (app free-vars (app cell-get->cell exp)))))
                       (_
                        (app
                         reduce
                         union
                         (app map free-vars (app begin->exps exp))
                         (app nil)))))
                     (_ (app free-vars (app let=>lambda exp)))))
                   (_
                    (app
                     union
                     (app cons (app set!->var exp) (app nil))
                     (app free-vars (app set!->exp exp))))))
                 (_
                  (app
                   union
                   (app free-vars (app if->condition exp))
                   (app
                    union
                    (app free-vars (app if->then exp))
                    (app free-vars (app if->else exp)))))))
               (_
                (app
                 difference
                 (app free-vars (app lambda->exp exp))
                 (app lambda->formals exp)))))
             (_ (app cons exp (app nil)))))
           (_ (app nil))))
         (_ (app nil)))))
     (mutable-variables (app nil))
     (mark-mutable
      (λ (symbol)
        (app set! mutable-variables (app cons symbol mutable-variables))))
     (is-mutable?
      (λ (symbol)
        (letrec*
         ((is-in?
           (λ (S)
             (match
              (app not (app pair? S))
              ((#f)
               (match
                (app eq? (app car S) symbol)
                ((#f) (app is-in? (app cdr S)))
                (_ (app #t))))
              (_ (app #f))))))
         (app is-in? mutable-variables))))
     (analyze-mutable-variables
      (λ (exp)
        (match
         (app const? exp)
         ((#f)
          (match
           (app prim? exp)
           ((#f)
            (match
             (app ref? exp)
             ((#f)
              (match
               (app lambda? exp)
               ((#f)
                (match
                 (app set!? exp)
                 ((#f)
                  (match
                   (app if? exp)
                   ((#f)
                    (match
                     (app let? exp)
                     ((#f)
                      (match
                       (app letrec? exp)
                       ((#f)
                        (match
                         (app begin? exp)
                         ((#f)
                          (match
                           (app app? exp)
                           ((#f) (app error "unknown expression type: " exp))
                           (_
                            (let ((_ (app map analyze-mutable-variables exp)))
                              (app void)))))
                         (_
                          (let ((_
                                 (app
                                  map
                                  analyze-mutable-variables
                                  (app begin->exps exp))))
                            (app void)))))
                       (_
                        (let ((_
                               (app
                                map
                                analyze-mutable-variables
                                (app map cadr (app letrec->bindings exp)))))
                          (app
                           analyze-mutable-variables
                           (app letrec->exp exp))))))
                     (_
                      (let ((_
                             (app
                              map
                              analyze-mutable-variables
                              (app map cadr (app let->bindings exp)))))
                        (app analyze-mutable-variables (app let->exp exp))))))
                   (_
                    (let ((_
                           (app
                            analyze-mutable-variables
                            (app if->condition exp))))
                      (let ((_
                             (app
                              analyze-mutable-variables
                              (app if->then exp))))
                        (app analyze-mutable-variables (app if->else exp)))))))
                 (_ (app mark-mutable (app set!->var exp)))))
               (_ (app analyze-mutable-variables (app lambda->exp exp)))))
             (_ (app void))))
           (_ (app void))))
         (_ (app void)))))
     (wrap-mutables
      (λ (exp)
        (letrec*
         ((wrap-mutable-formals
           (λ (formals body-exp)
             (match
              (app not (app pair? formals))
              ((#f)
               (match
                (app is-mutable? (app car formals))
                ((#f) (app wrap-mutable-formals (app cdr formals) body-exp))
                (_
                 (app
                  cons
                  (app
                   cons
                   'let
                   (app
                    cons
                    (app
                     cons
                     (app
                      cons
                      (app car formals)
                      (app
                       cons
                       (app cons 'cell (app cons (app car formals) (app nil)))
                       (app nil)))
                     (app nil))
                    (app
                     cons
                     (app wrap-mutable-formals (app cdr formals) body-exp)
                     (app nil))))
                  (app nil)))))
              (_ body-exp)))))
         (match
          (app const? exp)
          ((#f)
           (match
            (app ref? exp)
            ((#f)
             (match
              (app prim? exp)
              ((#f)
               (match
                (app lambda? exp)
                ((#f)
                 (match
                  (app set!? exp)
                  ((#f)
                   (match
                    (app if? exp)
                    ((#f)
                     (match
                      (app app? exp)
                      ((#f) (app error "unknown expression type: " exp))
                      (_ (app map wrap-mutables exp))))
                    (_
                     (app
                      cons
                      (app
                       cons
                       'if
                       (app
                        cons
                        (app wrap-mutables (app if->condition exp))
                        (app
                         cons
                         (app wrap-mutables (app if->then exp))
                         (app
                          cons
                          (app wrap-mutables (app if->else exp))
                          (app nil)))))
                      (app nil)))))
                  (_
                   (app
                    cons
                    (app
                     cons
                     'set-cell!
                     (app
                      cons
                      (app set!->var exp)
                      (app
                       cons
                       (app wrap-mutables (app set!->exp exp))
                       (app nil))))
                    (app nil)))))
                (_
                 (app
                  cons
                  (app
                   cons
                   'lambda
                   (app
                    cons
                    (app lambda->formals exp)
                    (app
                     cons
                     (app
                      wrap-mutable-formals
                      (app lambda->formals exp)
                      (app wrap-mutables (app lambda->exp exp)))
                     (app nil))))
                  (app nil)))))
              (_ exp)))
            (_
             (match
              (app is-mutable? exp)
              ((#f) exp)
              (_
               (app
                cons
                (app cons 'cell-get (app cons exp (app nil)))
                (app nil)))))))
          (_ exp)))))
     (mangle
      (λ (symbol)
        (letrec*
         ((m
           (λ (chars)
             (match
              (app null? chars)
              ((#f)
               (match
                (app
                 or
                 (app
                  and
                  (app char-alphabetic? (app car chars))
                  (app not (app char=? (app car chars) #\_)))
                 (app char-numeric? (app car chars)))
                ((#f)
                 (app
                  cons
                  #\_
                  (app
                   append
                   (app integer->char-list (app char->natural (app car chars)))
                   (app m (app cdr chars)))))
                (_ (app cons (app car chars) (app m (app cdr chars))))))
              (_ (app nil))))))
         (app
          list->string
          (app m (app string->list (app symbol->string symbol)))))))
     (num-environments 0)
     (environments (app nil))
     (allocate-environment
      (λ (fields)
        (let ((id num-environments))
          (let ((_ (app set! num-environments (app + 1 num-environments))))
            (let ((_
                   (app
                    set!
                    environments
                    (app cons (app cons id fields) environments))))
              id)))))
     (get-environment (λ (id) (app cdr (app assv id environments))))
     (closure-convert
      (λ (exp)
        (match
         (app const? exp)
         ((#f)
          (match
           (app prim? exp)
           ((#f)
            (match
             (app ref? exp)
             ((#f)
              (match
               (app lambda? exp)
               ((#f)
                (match
                 (app if? exp)
                 ((#f)
                  (match
                   (app set!? exp)
                   ((#f)
                    (match
                     (app cell? exp)
                     ((#f)
                      (match
                       (app cell-get? exp)
                       ((#f)
                        (match
                         (app set-cell!? exp)
                         ((#f)
                          (match
                           (app app? exp)
                           ((#f) (app error "unhandled exp: " exp))
                           (_ (app map closure-convert exp))))
                         (_
                          (app
                           cons
                           (app
                            cons
                            'set-cell!
                            (app
                             cons
                             (app closure-convert (app set-cell!->cell exp))
                             (app
                              cons
                              (app closure-convert (app set-cell!->value exp))
                              (app nil))))
                           (app nil)))))
                       (_
                        (app
                         cons
                         (app
                          cons
                          'cell-get
                          (app
                           cons
                           (app closure-convert (app cell-get->cell exp))
                           (app nil)))
                         (app nil)))))
                     (_
                      (app
                       cons
                       (app
                        cons
                        'cell
                        (app
                         cons
                         (app closure-convert (app cell->value exp))
                         (app nil)))
                       (app nil)))))
                   (_
                    (app
                     cons
                     (app
                      cons
                      'set!
                      (app
                       cons
                       (app set!->var exp)
                       (app
                        cons
                        (app closure-convert (app set!->exp exp))
                        (app nil))))
                     (app nil)))))
                 (_
                  (app
                   cons
                   (app
                    cons
                    'if
                    (app
                     cons
                     (app closure-convert (app if->condition exp))
                     (app
                      cons
                      (app closure-convert (app if->then exp))
                      (app
                       cons
                       (app closure-convert (app if->else exp))
                       (app nil)))))
                   (app nil)))))
               (_
                (let* (($env (app gensym 'env))
                       (body (app closure-convert (app lambda->exp exp)))
                       (fv
                        (app
                         difference
                         (app free-vars body)
                         (app lambda->formals exp)))
                       (id (app allocate-environment fv))
                       (sub
                        (app
                         map
                         (λ (v)
                           (app
                            cons
                            v
                            (app
                             cons
                             (app
                              cons
                              (app
                               cons
                               'env-get
                               (app
                                cons
                                id
                                (app cons v (app cons $env (app nil)))))
                              (app nil))
                             (app nil))))
                         fv)))
                  (app
                   cons
                   (app
                    cons
                    'closure
                    (app
                     cons
                     (app
                      cons
                      'lambda
                      (app
                       cons
                       (app
                        cons
                        $env
                        (app append (app lambda->formals exp) (app nil)))
                       (app cons (app substitute sub body) (app nil))))
                     (app
                      cons
                      (app
                       cons
                       'env-make
                       (app cons id (app append (app azip fv fv) (app nil))))
                      (app nil))))
                   (app nil))))))
             (_ exp)))
           (_ exp)))
         (_ exp))))
     (c-compile-program
      (λ (exp)
        (let* ((preamble "")
               (append-preamble
                (λ (s)
                  (app
                   set!
                   preamble
                   (app string-append preamble "  " s "\n"))))
               (body (app c-compile-exp exp append-preamble)))
          (app
           string-append
           "int main (int argc, char* argv[]) {\n"
           preamble
           "  __sum         = MakePrimitive(__prim_sum) ;\n"
           "  __product     = MakePrimitive(__prim_product) ;\n"
           "  __difference  = MakePrimitive(__prim_difference) ;\n"
           "  __display     = MakePrimitive(__prim_display) ;\n"
           "  __numEqual    = MakePrimitive(__prim_numEqual) ;\n"
           "  "
           body
           " ;\n"
           "  return 0;\n"
           " }\n"))))
     (c-compile-exp
      (λ (exp append-preamble)
        (match
         (app const? exp)
         ((#f)
          (match
           (app prim? exp)
           ((#f)
            (match
             (app ref? exp)
             ((#f)
              (match
               (app if? exp)
               ((#f)
                (match
                 (app cell? exp)
                 ((#f)
                  (match
                   (app cell-get? exp)
                   ((#f)
                    (match
                     (app set-cell!? exp)
                     ((#f)
                      (match
                       (app closure? exp)
                       ((#f)
                        (match
                         (app env-make? exp)
                         ((#f)
                          (match
                           (app env-get? exp)
                           ((#f)
                            (match
                             (app app? exp)
                             ((#f)
                              (app error "unknown exp in c-compile-exp: " exp))
                             (_ (app c-compile-app exp append-preamble))))
                           (_ (app c-compile-env-get exp append-preamble))))
                         (_ (app c-compile-env-make exp append-preamble))))
                       (_ (app c-compile-closure exp append-preamble))))
                     (_ (app c-compile-set-cell! exp append-preamble))))
                   (_ (app c-compile-cell-get exp append-preamble))))
                 (_ (app c-compile-cell exp append-preamble))))
               (_ (app c-compile-if exp append-preamble))))
             (_ (app c-compile-ref exp))))
           (_ (app c-compile-prim exp))))
         (_ (app c-compile-const exp)))))
     (c-compile-const
      (λ (exp)
        (match
         (app integer? exp)
         ((#f)
          (match
           (app boolean? exp)
           ((#f) (app error "unknown constant: " exp))
           (_
            (app
             string-append
             "MakeBoolean("
             (match exp ((#f) "0") (_ "1"))
             ")"))))
         (_ (app string-append "MakeInt(" (app number->string exp) ")")))))
     (c-compile-prim
      (λ (p)
        (match
         (app eq? '+ p)
         ((#f)
          (match
           (app eq? '- p)
           ((#f)
            (match
             (app eq? '* p)
             ((#f)
              (match
               (app eq? '= p)
               ((#f)
                (match
                 (app eq? 'display p)
                 ((#f) (app error "unhandled primitive: " p))
                 (_ "__display")))
               (_ "__numEqual")))
             (_ "__product")))
           (_ "__difference")))
         (_ "__sum"))))
     (c-compile-ref (λ (exp) (app mangle exp)))
     (c-compile-args
      (λ (args append-preamble)
        (match
         (app not (app pair? args))
         ((#f)
          (app
           string-append
           (app c-compile-exp (app car args) append-preamble)
           (match
            (app pair? (app cdr args))
            ((#f) "")
            (_
             (app
              string-append
              ", "
              (app c-compile-args (app cdr args) append-preamble))))))
         (_ ""))))
     (c-compile-app
      (λ (exp append-preamble)
        (let (($tmp (app mangle (app gensym 'tmp))))
          (let ((_
                 (app
                  append-preamble
                  (app string-append "Value " $tmp " ; "))))
            (let* ((args (app app->args exp)) (fun (app app->fun exp)))
              (app
               string-append
               "("
               $tmp
               " = "
               (app c-compile-exp fun append-preamble)
               ","
               $tmp
               ".clo.lam("
               "MakeEnv("
               $tmp
               ".clo.env)"
               (match (app null? args) ((#f) ",") (_ ""))
               (app c-compile-args args append-preamble)
               "))"))))))
     (c-compile-if
      (λ (exp append-preamble)
        (app
         string-append
         "("
         (app c-compile-exp (app if->condition exp) append-preamble)
         ").b.value ? "
         "("
         (app c-compile-exp (app if->then exp) append-preamble)
         ") : "
         "("
         (app c-compile-exp (app if->else exp) append-preamble)
         ")")))
     (c-compile-set-cell!
      (λ (exp append-preamble)
        (app
         string-append
         "(*"
         "("
         (app c-compile-exp (app set-cell!->cell exp) append-preamble)
         ".cell.addr)"
         " = "
         (app c-compile-exp (app set-cell!->value exp) append-preamble)
         ")")))
     (c-compile-cell-get
      (λ (exp append-preamble)
        (app
         string-append
         "(*("
         (app c-compile-exp (app cell-get->cell exp) append-preamble)
         ".cell.addr"
         "))")))
     (c-compile-cell
      (λ (exp append-preamble)
        (app
         string-append
         "NewCell("
         (app c-compile-exp (app cell->value exp) append-preamble)
         ")")))
     (c-compile-env-make
      (λ (exp append-preamble)
        (app
         string-append
         "MakeEnv(__alloc_env"
         (app number->string (app env-make->id exp))
         "("
         (app c-compile-args (app env-make->values exp) append-preamble)
         "))")))
     (c-compile-env-get
      (λ (exp append-preamble)
        (app
         string-append
         "((struct __env_"
         (app number->string (app env-get->id exp))
         "*)"
         (app c-compile-exp (app env-get->env exp) append-preamble)
         ".env.env)->"
         (app mangle (app env-get->field exp)))))
     (num-lambdas 0)
     (lambdas (app nil))
     (allocate-lambda
      (λ (lam)
        (let ((id num-lambdas))
          (let ((_ (app set! num-lambdas (app + 1 num-lambdas))))
            (let ((_
                   (app
                    set!
                    lambdas
                    (app
                     cons
                     (app cons id (app cons lam (app nil)))
                     lambdas))))
              id)))))
     (get-lambda (λ (id) (app cdr (app assv id lambdas))))
     (c-compile-closure
      (λ (exp append-preamble)
        (let* ((lam (app closure->lam exp))
               (env (app closure->env exp))
               (lid (app allocate-lambda (app c-compile-lambda lam))))
          (app
           string-append
           "MakeClosure("
           "__lambda_"
           (app number->string lid)
           ","
           (app c-compile-exp env append-preamble)
           ")"))))
     (c-compile-formals
      (λ (formals)
        (match
         (app not (app pair? formals))
         ((#f)
          (app
           string-append
           "Value "
           (app mangle (app car formals))
           (match
            (app pair? (app cdr formals))
            ((#f) "")
            (_
             (app
              string-append
              ", "
              (app c-compile-formals (app cdr formals)))))))
         (_ ""))))
     (c-compile-lambda
      (λ (exp)
        (let* ((preamble "")
               (append-preamble
                (λ (s)
                  (app
                   set!
                   preamble
                   (app string-append preamble "  " s "\n")))))
          (let ((formals (app c-compile-formals (app lambda->formals exp)))
                (body
                 (app c-compile-exp (app lambda->exp exp) append-preamble)))
            (λ (name)
              (app
               string-append
               "Value "
               name
               "("
               formals
               ") {\n"
               preamble
               "  return "
               body
               " ;\n"
               "}\n"))))))
     (c-compile-env-struct
      (λ (env)
        (let* ((id (app car env))
               (fields (app cdr env))
               (sid (app number->string id))
               (tyname (app string-append "struct __env_" sid)))
          (app
           string-append
           "struct __env_"
           (app number->string id)
           " {\n"
           (app
            apply
            string-append
            (app
             map
             (λ (f) (app string-append " Value " (app mangle f) " ; \n"))
             fields))
           "} ;\n\n"
           tyname
           "*"
           " __alloc_env"
           sid
           "("
           (app c-compile-formals fields)
           ")"
           "{\n"
           "  "
           tyname
           "*"
           " t = malloc(sizeof("
           tyname
           "))"
           ";\n"
           (app
            apply
            string-append
            (app
             map
             (λ (f)
               (app
                string-append
                "  t->"
                (app mangle f)
                " = "
                (app mangle f)
                ";\n"))
             fields))
           "  return t;\n"
           "}\n\n"))))
     (emit (λ (line) (let ((_ (app display line))) (app newline))))
     (c-compile-and-emit
      (λ (emit input-program)
        (letrec*
         ((compiled-program ""))
         (let ((_ (app set! input-program (app desugar input-program))))
           (let ((_ (app analyze-mutable-variables input-program)))
             (let ((_
                    (app
                     set!
                     input-program
                     (app desugar (app wrap-mutables input-program)))))
               (let ((_
                      (app
                       set!
                       input-program
                       (app closure-convert input-program))))
                 (let ((_ (app emit "#include <stdlib.h>")))
                   (let ((_ (app emit "#include <stdio.h>")))
                     (let ((_ (app emit "#include \"scheme.h\"")))
                       (let ((_ (app emit "")))
                         (let ((_
                                (app
                                 emit
                                 "\nValue __sum ;\nValue __difference ;\nValue __product ;\nValue __display ;\nValue __numEqual ;\n")))
                           (let ((_
                                  (app
                                   for-each
                                   (λ (env)
                                     (app emit (app c-compile-env-struct env)))
                                   environments)))
                             (let ((_
                                    (app
                                     set!
                                     compiled-program
                                     (app c-compile-program input-program))))
                               (let ((_
                                      (app
                                       emit
                                       "Value __prim_sum(Value e, Value a, Value b) {\n  return MakeInt(a.z.value + b.z.value) ;\n}")))
                                 (let ((_
                                        (app
                                         emit
                                         "Value __prim_product(Value e, Value a, Value b) {\n  return MakeInt(a.z.value * b.z.value) ;\n}")))
                                   (let ((_
                                          (app
                                           emit
                                           "Value __prim_difference(Value e, Value a, Value b) {\n  return MakeInt(a.z.value - b.z.value) ;\n}")))
                                     (let ((_
                                            (app
                                             emit
                                             "Value __prim_display(Value e, Value v) {\n  printf(\"%i\\n\",v.z.value) ;\n  return v ;\n}")))
                                       (let ((_
                                              (app
                                               emit
                                               "Value __prim_numEqual(Value e, Value a, Value b) {\n  return MakeBoolean(a.z.value == b.z.value) ;\n}")))
                                         (let ((_
                                                (app
                                                 for-each
                                                 (λ (l)
                                                   (app
                                                    emit
                                                    (app
                                                     string-append
                                                     "Value __lambda_"
                                                     (app
                                                      number->string
                                                      (app car l))
                                                     "() ;")))
                                                 lambdas)))
                                           (let ((_ (app emit "")))
                                             (let ((_
                                                    (app
                                                     for-each
                                                     (λ (l)
                                                       (app
                                                        emit
                                                        (app
                                                         (app cadr l)
                                                         (app
                                                          string-append
                                                          "__lambda_"
                                                          (app
                                                           number->string
                                                           (app car l))))))
                                                     lambdas)))
                                               (app
                                                emit
                                                compiled-program)))))))))))))))))))))))
     (the-benchmark-program 3))
    (app c-compile-and-emit emit the-benchmark-program))))

'(query: ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'(((top) app void) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (lettypes cons ... error (letrec* (car ... the-benchmark-program) ...))
  (env ()))
clos/con:
	'(((top) app void) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... c-compile-and-emit (the-benchmark-program (-> 3 <-)) () ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(query:
  (letrec*
   (...
    emit
    (c-compile-and-emit (-> (λ (emit input-program) ...) <-))
    the-benchmark-program
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    emit
    (c-compile-and-emit (-> (λ (emit input-program) ...) <-))
    the-benchmark-program
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (emit input-program) (-> (letrec* (compiled-program) ...) <-))
  (env (())))
clos/con:
	'(((top) app void) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... () (compiled-program (-> "" <-)) () ...) ...)
  (env (())))
clos/con: ⊥
literals: '(⊥ ⊥ "")

'(query: (letrec* (compiled-program) (-> (let (_) ...) <-)) (env (())))
clos/con:
	'(((top) app void) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (...
        ()
        (_ (-> (app set! input-program (app desugar input-program)) <-))
        ()
        ...)
    ...)
  (env (())))
